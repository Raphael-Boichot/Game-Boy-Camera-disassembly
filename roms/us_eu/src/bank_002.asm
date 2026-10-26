; Game Boy Camera (USA, Europe), bank $02. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

; C: the 5 bytes "Magic" that mark a valid SRAM block (compared by the validators)
Sram_MagicString::
    db "Magic"

; C: sum and xor of the 3584-byte image at $C000 -> tag_image_check $DA8F / $DA90
Sram_ComputeImageChecksums::
    ld hl, wPhotoImage                            ; $4005
    xor a                                         ; $4008
    ld b, $e0                                     ; $4009

jr_002_400b:
    add [hl]                                      ; $400B
    inc l                                         ; $400C
    add [hl]                                      ; $400D
    inc l                                         ; $400E
    add [hl]                                      ; $400F
    inc l                                         ; $4010
    add [hl]                                      ; $4011
    inc l                                         ; $4012
    add [hl]                                      ; $4013
    inc l                                         ; $4014
    add [hl]                                      ; $4015
    inc l                                         ; $4016
    add [hl]                                      ; $4017
    inc l                                         ; $4018
    add [hl]                                      ; $4019
    inc l                                         ; $401A
    add [hl]                                      ; $401B
    inc l                                         ; $401C
    add [hl]                                      ; $401D
    inc l                                         ; $401E
    add [hl]                                      ; $401F
    inc l                                         ; $4020
    add [hl]                                      ; $4021
    inc l                                         ; $4022
    add [hl]                                      ; $4023
    inc l                                         ; $4024
    add [hl]                                      ; $4025
    inc l                                         ; $4026
    add [hl]                                      ; $4027
    inc l                                         ; $4028
    add [hl]                                      ; $4029
    inc hl                                        ; $402A
    dec b                                         ; $402B
    jr nz, jr_002_400b                            ; $402C

    ld [wTagImageCheck], a                        ; $402E
    ld hl, wPhotoImage                            ; $4031
    xor a                                         ; $4034
    ld b, $e0                                     ; $4035

jr_002_4037:
    xor [hl]                                      ; $4037
    inc l                                         ; $4038
    xor [hl]                                      ; $4039
    inc l                                         ; $403A
    xor [hl]                                      ; $403B
    inc l                                         ; $403C
    xor [hl]                                      ; $403D
    inc l                                         ; $403E
    xor [hl]                                      ; $403F
    inc l                                         ; $4040
    xor [hl]                                      ; $4041
    inc l                                         ; $4042
    xor [hl]                                      ; $4043
    inc l                                         ; $4044
    xor [hl]                                      ; $4045
    inc l                                         ; $4046
    xor [hl]                                      ; $4047
    inc l                                         ; $4048
    xor [hl]                                      ; $4049
    inc l                                         ; $404A
    xor [hl]                                      ; $404B
    inc l                                         ; $404C
    xor [hl]                                      ; $404D
    inc l                                         ; $404E
    xor [hl]                                      ; $404F
    inc l                                         ; $4050
    xor [hl]                                      ; $4051
    inc l                                         ; $4052
    xor [hl]                                      ; $4053
    inc l                                         ; $4054
    xor [hl]                                      ; $4055
    inc hl                                        ; $4056
    dec b                                         ; $4057
    jr nz, jr_002_4037                            ; $4058

    ld [wTagImageCheck + $1], a                   ; $405A
    ret                                           ; $405D


; C: Z if one of the two copies (AF55 / AFB1) of the tag block carries Magic. L3 pass 2026-10-26: executed in BGB in
; 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Sram_CheckTagMagic::
    ld hl, $af55                                  ; $405E
    call Sram_CompareMagicAt                      ; $4061
    ret z                                         ; $4064

    ld hl, $afb1                                  ; $4065

; C: compares 5 bytes at HL+DE with the Magic string. L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the
; organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Sram_CompareMagicAt::
    push de                                       ; $4068
    add hl, de                                    ; $4069
    ld de, Sram_MagicString                       ; $406A
    ld c, $05                                     ; $406D

jr_002_406f:
    ld a, [de]                                    ; $406F
    cp [hl]                                       ; $4070
    jr nz, jr_002_4078                            ; $4071

    inc hl                                        ; $4073
    inc de                                        ; $4074
    dec c                                         ; $4075
    jr nz, jr_002_406f                            ; $4076

jr_002_4078:
    pop de                                        ; $4078
    ret                                           ; $4079


; C: Z if one of the two copies (B0D2 / B1AB) carries Magic. L3 pass 2026-10-26: executed in BGB in 203 replay(s) of
; the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Sram_CheckSettingsMagic::
    ld hl, $b0d2                                  ; $407A
    call Sram_CompareMagic                        ; $407D
    ret z                                         ; $4080

    ld hl, $b1ab                                  ; $4081

; C: compares 5 bytes at HL with the Magic string. L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Sram_CompareMagic::
    ld de, Sram_MagicString                       ; $4084
    ld c, $05                                     ; $4087

jr_002_4089:
    ld a, [de]                                    ; $4089
    cp [hl]                                       ; $408A
    jr nz, jr_002_4092                            ; $408B

    inc hl                                        ; $408D
    inc de                                        ; $408E
    dec c                                         ; $408F
    jr nz, jr_002_4089                            ; $4090

jr_002_4092:
    ret                                           ; $4092


; C: Z if one of the two copies (B1D0 / B1F5) carries Magic. L3 pass 2026-10-26: executed in BGB in 203 replay(s) of
; the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Sram_CheckVectorMagic::
    ld hl, $b1d0                                  ; $4093
    call Sram_CompareMagic_B                      ; $4096
    ret z                                         ; $4099

    ld hl, $b1f5                                  ; $409A

; C: same compare (second copy). L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Sram_CompareMagic_B::
    ld de, Sram_MagicString                       ; $409D
    ld c, $05                                     ; $40A0

jr_002_40a2:
    ld a, [de]                                    ; $40A2
    cp [hl]                                       ; $40A3
    jr nz, jr_002_40ab                            ; $40A4

    inc hl                                        ; $40A6
    inc de                                        ; $40A7
    dec c                                         ; $40A8
    jr nz, jr_002_40a2                            ; $40A9

jr_002_40ab:
    ret                                           ; $40AB


; C: Z if one of the two copies (AFCA / AFE3) carries Magic. L3 pass 2026-10-26: executed in BGB in 203 replay(s) of
; the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Sram_CheckOwnerMagic::
    ld hl, $afca                                  ; $40AC
    call Sram_CompareMagic_C                      ; $40AF
    ret z                                         ; $40B2

    ld hl, $afe3                                  ; $40B3

; C: same compare (third copy). L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
Sram_CompareMagic_C::
    ld de, Sram_MagicString                       ; $40B6
    ld c, $05                                     ; $40B9

jr_002_40bb:
    ld a, [de]                                    ; $40BB
    cp [hl]                                       ; $40BC
    jr nz, jr_002_40c4                            ; $40BD

    inc hl                                        ; $40BF
    inc de                                        ; $40C0
    dec c                                         ; $40C1
    jr nz, jr_002_40bb                            ; $40C2

jr_002_40c4:
    ret                                           ; $40C4


; C: checksum of a $5A-byte tag block at HL+DE; Z if valid
Sram_VerifyTagChecksum::
    push bc                                       ; $40C5
    push de                                       ; $40C6
    add hl, de                                    ; $40C7
    ld bc, $005a                                  ; $40C8
    call Sram_Checksum                            ; $40CB
    ld a, d                                       ; $40CE
    add $4e                                       ; $40CF
    cp [hl]                                       ; $40D1
    jr nz, jr_002_40d9                            ; $40D2

    inc hl                                        ; $40D4
    ld a, e                                       ; $40D5
    xor $54                                       ; $40D6
    cp [hl]                                       ; $40D8

jr_002_40d9:
    pop de                                        ; $40D9
    pop bc                                        ; $40DA
    ret                                           ; $40DB


; C: checksum of the $D7-byte settings block; Z if valid
Sram_VerifySettingsChecksum::
    push bc                                       ; $40DC
    push de                                       ; $40DD
    ld bc, $00d7                                  ; $40DE
    call Sram_Checksum                            ; $40E1
    ld a, d                                       ; $40E4
    add $4e                                       ; $40E5
    cp [hl]                                       ; $40E7
    jr nz, jr_002_40ef                            ; $40E8

    inc hl                                        ; $40EA
    ld a, e                                       ; $40EB
    xor $54                                       ; $40EC
    cp [hl]                                       ; $40EE

jr_002_40ef:
    pop de                                        ; $40EF
    pop bc                                        ; $40F0
    ret                                           ; $40F1


; C: checksum of the $23-byte photo vector; Z if valid
Sram_VerifyVectorChecksum::
    push bc                                       ; $40F2
    push de                                       ; $40F3
    ld bc, $0023                                  ; $40F4
    call Sram_Checksum                            ; $40F7
    ld a, d                                       ; $40FA
    add $4e                                       ; $40FB
    cp [hl]                                       ; $40FD
    jr nz, jr_002_4105                            ; $40FE

    inc hl                                        ; $4100
    ld a, e                                       ; $4101
    xor $54                                       ; $4102
    cp [hl]                                       ; $4104

jr_002_4105:
    pop de                                        ; $4105
    pop bc                                        ; $4106
    ret                                           ; $4107


; C: checksum of the $17-byte owner block; Z if valid
Sram_VerifyOwnerChecksum::
    push bc                                       ; $4108
    push de                                       ; $4109
    ld bc, $0017                                  ; $410A
    call Sram_Checksum                            ; $410D
    ld a, d                                       ; $4110
    add $4e                                       ; $4111
    cp [hl]                                       ; $4113
    jr nz, jr_002_411b                            ; $4114

    inc hl                                        ; $4116
    ld a, e                                       ; $4117
    xor $54                                       ; $4118
    cp [hl]                                       ; $411A

jr_002_411b:
    pop de                                        ; $411B
    pop bc                                        ; $411C
    ret                                           ; $411D


; C: clears $FB8 bytes of the SRAM bank and rewrites the headers of the two tag blocks
Sram_FormatPhotoBank::
    push bc                                       ; $411E
    ld hl, $a000                                  ; $411F
    add hl, de                                    ; $4122
    ld bc, $0fb8                                  ; $4123

jr_002_4126:
    xor a                                         ; $4126
    ld [hl+], a                                   ; $4127
    dec bc                                        ; $4128
    ld a, b                                       ; $4129
    or c                                          ; $412A
    jr nz, jr_002_4126                            ; $412B

    ld b, $02                                     ; $412D

jr_002_412f:
    push bc                                       ; $412F
    push de                                       ; $4130
    ld hl, $af55                                  ; $4131
    call Sram_WriteMagicAt                        ; $4134
    ld hl, $af00                                  ; $4137
    add hl, de                                    ; $413A
    ld bc, $005a                                  ; $413B
    call Sram_WriteChecksum                       ; $413E
    pop de                                        ; $4141
    pop bc                                        ; $4142
    ld e, $5c                                     ; $4143
    dec b                                         ; $4145
    jr nz, jr_002_412f                            ; $4146

    pop bc                                        ; $4148
    ret                                           ; $4149


; C: copies Magic to HL+DE
Sram_WriteMagicAt::
    push de                                       ; $414A
    add hl, de                                    ; $414B
    ld de, Sram_MagicString                       ; $414C
    ld c, $05                                     ; $414F

jr_002_4151:
    ld a, [de]                                    ; $4151
    ld [hl+], a                                   ; $4152
    inc de                                        ; $4153
    dec c                                         ; $4154
    jr nz, jr_002_4151                            ; $4155

    pop de                                        ; $4157
    ret                                           ; $4158


; C: marks slot B as free ($FF) in both copies of the photo vector
Sram_FreeSlotInVector::
    push bc                                       ; $4159
    ld a, b                                       ; $415A
    cpl                                           ; $415B
    add $1f                                       ; $415C
    ld c, a                                       ; $415E
    ld b, $00                                     ; $415F
    ld de, $0000                                  ; $4161
    call Sram_FreeSlotInVectorCopy                ; $4164
    ld de, $0025                                  ; $4167
    call Sram_FreeSlotInVectorCopy                ; $416A
    pop bc                                        ; $416D
    ret                                           ; $416E


; C: one copy
Sram_FreeSlotInVectorCopy::
    push bc                                       ; $416F
    ld hl, $b1b2                                  ; $4170
    add hl, bc                                    ; $4173
    add hl, de                                    ; $4174
    ld [hl], $ff                                  ; $4175
    ld hl, $b1b2                                  ; $4177
    add hl, de                                    ; $417A
    ld bc, $0023                                  ; $417B
    call Sram_WriteChecksum                       ; $417E
    pop bc                                        ; $4181
    ret                                           ; $4182


; C: writes the default settings block (list of $FE...) and its two copies
Sram_FormatSettingsBlocks::
    ld de, $0000                                  ; $4183
    ld b, $02                                     ; $4186

jr_002_4188:
    push bc                                       ; $4188
    ld hl, $b000                                  ; $4189
    add hl, de                                    ; $418C
    ld a, $fe                                     ; $418D
    ld b, $2f                                     ; $418F

jr_002_4191:
    ld [hl+], a                                   ; $4191
    dec b                                         ; $4192
    jr nz, jr_002_4191                            ; $4193

    xor a                                         ; $4195
    ld [hl], a                                    ; $4196
    ld hl, $b030                                  ; $4197
    add hl, de                                    ; $419A
    ld b, $2f                                     ; $419B

jr_002_419d:
    ld [hl+], a                                   ; $419D
    dec b                                         ; $419E
    jr nz, jr_002_419d                            ; $419F

    ld hl, $b05f                                  ; $41A1
    add hl, de                                    ; $41A4
    ld a, $09                                     ; $41A5
    ld [hl], a                                    ; $41A7
    ld hl, $b060                                  ; $41A8
    add hl, de                                    ; $41AB
    xor a                                         ; $41AC
    ld [hl], a                                    ; $41AD
    push de                                       ; $41AE
    ld hl, $b061                                  ; $41AF
    add hl, de                                    ; $41B2
    ld de, Sram_FormatSettingsBlocks_Tbl41F3      ; $41B3
    ld b, $5a                                     ; $41B6

jr_002_41b8:
    ld a, [de]                                    ; $41B8
    ld [hl+], a                                   ; $41B9
    inc de                                        ; $41BA
    dec b                                         ; $41BB
    jr nz, jr_002_41b8                            ; $41BC

    pop de                                        ; $41BE
    ld hl, $b0bb                                  ; $41BF
    add hl, de                                    ; $41C2
    xor a                                         ; $41C3
    ld b, $15                                     ; $41C4

jr_002_41c6:
    ld [hl+], a                                   ; $41C6
    dec b                                         ; $41C7
    jr nz, jr_002_41c6                            ; $41C8

    ld a, $40                                     ; $41CA
    ld [hl+], a                                   ; $41CC
    xor a                                         ; $41CD
    ld [hl], a                                    ; $41CE
    push de                                       ; $41CF
    ld hl, $b0d2                                  ; $41D0
    add hl, de                                    ; $41D3
    ld de, Sram_MagicString                       ; $41D4
    ld c, $05                                     ; $41D7

jr_002_41d9:
    ld a, [de]                                    ; $41D9
    ld [hl+], a                                   ; $41DA
    inc de                                        ; $41DB
    dec c                                         ; $41DC
    jr nz, jr_002_41d9                            ; $41DD

    pop de                                        ; $41DF
    push de                                       ; $41E0
    ld hl, $b000                                  ; $41E1
    add hl, de                                    ; $41E4
    ld bc, $00d7                                  ; $41E5
    call Sram_WriteChecksum                       ; $41E8
    pop de                                        ; $41EB
    pop bc                                        ; $41EC
    ld e, $d9                                     ; $41ED
    dec b                                         ; $41EF
    jr nz, jr_002_4188                            ; $41F0

    ret                                           ; $41F2


; C: auto: 90 bytes, bytes; referenced by Sram_FormatSettingsBlocks. L3 pass 2026-10-26: read in BGB in 69 replay(s)
; of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Sram_FormatSettingsBlocks_Tbl41F3::
    db $09, $8f, $00, $00, $0d, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $55, $55, $55, $55, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $ff, $ff, $ff, $ff, $09, $00, $00, $0d, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $55, $55, $55, $ff
    db $8f, $5f, $19, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $55, $55, $55, $55, $00, $00, $78, $00

; C: writes an empty photo vector ($FF x $1E) with Magic and checksum (two copies)
Sram_FormatVectorBlocks::
    ld de, $0000                                  ; $424D
    ld b, $02                                     ; $4250

jr_002_4252:
    push bc                                       ; $4252
    ld hl, $b1b2                                  ; $4253
    add hl, de                                    ; $4256
    ld a, $ff                                     ; $4257
    ld b, $1e                                     ; $4259

jr_002_425b:
    ld [hl+], a                                   ; $425B
    dec b                                         ; $425C
    jr nz, jr_002_425b                            ; $425D

    push de                                       ; $425F
    ld hl, $b1d0                                  ; $4260
    add hl, de                                    ; $4263
    ld de, Sram_MagicString                       ; $4264
    ld c, $05                                     ; $4267

jr_002_4269:
    ld a, [de]                                    ; $4269
    ld [hl+], a                                   ; $426A
    inc de                                        ; $426B
    dec c                                         ; $426C
    jr nz, jr_002_4269                            ; $426D

    pop de                                        ; $426F
    push de                                       ; $4270
    ld hl, $b1b2                                  ; $4271
    add hl, de                                    ; $4274
    ld bc, $0023                                  ; $4275
    call Sram_WriteChecksum                       ; $4278
    pop de                                        ; $427B
    pop bc                                        ; $427C
    ld e, $25                                     ; $427D
    dec b                                         ; $427F
    jr nz, jr_002_4252                            ; $4280

    ret                                           ; $4282


; C: writes a blank owner block with Magic and checksum (two copies)
Sram_FormatOwnerBlocks::
    ld de, $0000                                  ; $4283
    ld b, $02                                     ; $4286

jr_002_4288:
    push bc                                       ; $4288
    ld hl, $afb8                                  ; $4289
    add hl, de                                    ; $428C
    xor a                                         ; $428D
    ld b, $12                                     ; $428E

jr_002_4290:
    ld [hl+], a                                   ; $4290
    dec b                                         ; $4291
    jr nz, jr_002_4290                            ; $4292

    push de                                       ; $4294
    ld hl, $afca                                  ; $4295
    add hl, de                                    ; $4298
    ld de, Sram_MagicString                       ; $4299
    ld c, $05                                     ; $429C

jr_002_429e:
    ld a, [de]                                    ; $429E
    ld [hl+], a                                   ; $429F
    inc de                                        ; $42A0
    dec c                                         ; $42A1
    jr nz, jr_002_429e                            ; $42A2

    pop de                                        ; $42A4
    push de                                       ; $42A5
    ld hl, $afb8                                  ; $42A6
    add hl, de                                    ; $42A9
    ld bc, $0017                                  ; $42AA
    call Sram_WriteChecksum                       ; $42AD
    pop de                                        ; $42B0
    pop bc                                        ; $42B1
    ld e, $19                                     ; $42B2
    dec b                                         ; $42B4
    jr nz, jr_002_4288                            ; $42B5

    ret                                           ; $42B7


; C: copies the echo tag block ($AF5C + DE) over the main one ($AF00 + DE), $5C bytes; taken when the echo checksum is
; good (branch target; code read 2026-10-19)
Sram_RepairTag_EchoToMain::
    push de                                       ; $42B8
    ld hl, $af00                                  ; $42B9
    add hl, de                                    ; $42BC
    push hl                                       ; $42BD
    ld hl, $af5c                                  ; $42BE
    add hl, de                                    ; $42C1
    pop de                                        ; $42C2
    jr jr_002_42d0                                ; $42C3

; C: copies the main tag block ($AF00 + DE) over the echo ($AF5C + DE), $5C bytes; taken when the echo checksum fails
; (branch target; code read 2026-10-19)
Sram_RepairTag_MainToEcho::
    push de                                       ; $42C5
    ld hl, $af5c                                  ; $42C6
    add hl, de                                    ; $42C9
    push hl                                       ; $42CA
    ld hl, $af00                                  ; $42CB
    add hl, de                                    ; $42CE
    pop de                                        ; $42CF

jr_002_42d0:
    ld c, $5c                                     ; $42D0

jr_002_42d2:
    ld a, [hl+]                                   ; $42D2
    ld [de], a                                    ; $42D3
    inc de                                        ; $42D4
    dec c                                         ; $42D5
    jr nz, jr_002_42d2                            ; $42D6

    pop de                                        ; $42D8
    ret                                           ; $42D9


; C: copies the settings echo $B0D9 over $B000 ($D9 bytes) (branch target; code read 2026-10-19)
Sram_RepairSettings_EchoToMain::
    ld hl, $b0d9                                  ; $42DA
    ld de, $b000                                  ; $42DD
    jr jr_002_42e8                                ; $42E0

; C: copies the settings block $B000 over its echo $B0D9 ($D9 bytes) (branch target; code read 2026-10-19)
Sram_RepairSettings_MainToEcho::
    ld hl, $b000                                  ; $42E2
    ld de, $b0d9                                  ; $42E5

jr_002_42e8:
    ld c, $d9                                     ; $42E8

jr_002_42ea:
    ld a, [hl+]                                   ; $42EA
    ld [de], a                                    ; $42EB
    inc de                                        ; $42EC
    dec c                                         ; $42ED
    jr nz, jr_002_42ea                            ; $42EE

    ret                                           ; $42F0


; C: copies the vector echo $B1D7 over $B1B2 ($25 bytes) (branch target; code read 2026-10-19)
Sram_RepairVector_EchoToMain::
    ld hl, $b1d7                                  ; $42F1
    ld de, $b1b2                                  ; $42F4
    jr jr_002_42ff                                ; $42F7

; C: copies the photo vector $B1B2 over its echo $B1D7 ($25 bytes) (branch target; code read 2026-10-19)
Sram_RepairVector_MainToEcho::
    ld hl, $b1b2                                  ; $42F9
    ld de, $b1d7                                  ; $42FC

jr_002_42ff:
    ld c, $25                                     ; $42FF

jr_002_4301:
    ld a, [hl+]                                   ; $4301
    ld [de], a                                    ; $4302
    inc de                                        ; $4303
    dec c                                         ; $4304
    jr nz, jr_002_4301                            ; $4305

    ret                                           ; $4307


; C: copies the owner echo $AFD1 over $AFB8 ($19 bytes) (branch target; code read 2026-10-19)
Sram_RepairOwner_EchoToMain::
    ld hl, $afd1                                  ; $4308
    ld de, $afb8                                  ; $430B
    jr jr_002_4316                                ; $430E

; C: copies the owner block $AFB8 over its echo $AFD1 ($19 bytes) (branch target; code read 2026-10-19)
Sram_RepairOwner_MainToEcho::
    ld hl, $afb8                                  ; $4310
    ld de, $afd1                                  ; $4313

jr_002_4316:
    ld c, $19                                     ; $4316

jr_002_4318:
    ld a, [hl+]                                   ; $4318
    ld [de], a                                    ; $4319
    inc de                                        ; $431A
    dec c                                         ; $431B
    jr nz, jr_002_4318                            ; $431C

    ret                                           ; $431E


; C: HL = data
Sram_Checksum::
    ld de, $0000                                  ; $431F

jr_002_4322:
    ld a, d                                       ; $4322
    add [hl]                                      ; $4323
    ld d, a                                       ; $4324
    ld a, e                                       ; $4325
    xor [hl]                                      ; $4326
    ld e, a                                       ; $4327
    dec bc                                        ; $4328
    ld a, b                                       ; $4329
    or c                                          ; $432A
    inc hl                                        ; $432B
    jr nz, jr_002_4322                            ; $432C

    ret                                           ; $432E


; C: computes the checksum of BC bytes at HL and stores (sum+$4E
Sram_WriteChecksum::
    call Sram_Checksum                            ; $432F
    ld a, d                                       ; $4332
    add $4e                                       ; $4333
    ld [hl+], a                                   ; $4335
    ld a, e                                       ; $4336
    xor $54                                       ; $4337
    ld [hl], a                                    ; $4339
    ret                                           ; $433A


; C: validates the pair of tag blocks of one photo slot; repairs from the good copy or formats
Sram_ValidateTagSlot::
    ld a, b                                       ; $433B
    cpl                                           ; $433C
    add $1f                                       ; $433D
    srl a                                         ; $433F
    inc a                                         ; $4341
    ld [rRAMB], a                                 ; $4342
    ld de, $0000                                  ; $4345
    rl d                                          ; $4348
    swap d                                        ; $434A
    call Sram_CheckTagMagic                       ; $434C
    jr z, jr_002_435b                             ; $434F

    call Sram_FormatPhotoBank                     ; $4351
    xor a                                         ; $4354
    ld [rRAMB], a                                 ; $4355
    jp Sram_FreeSlotInVector                      ; $4358


jr_002_435b:
    ld hl, $af00                                  ; $435B
    call Sram_VerifyTagChecksum                   ; $435E
    jr z, jr_002_4376                             ; $4361

    ld hl, $af5c                                  ; $4363
    call Sram_VerifyTagChecksum                   ; $4366
    jp z, Sram_RepairTag_EchoToMain               ; $4369

    call Sram_FormatPhotoBank                     ; $436C
    xor a                                         ; $436F
    ld [rRAMB], a                                 ; $4370
    jp Sram_FreeSlotInVector                      ; $4373


jr_002_4376:
    ld hl, $af5c                                  ; $4376
    call Sram_VerifyTagChecksum                   ; $4379
    jp nz, Sram_RepairTag_MainToEcho              ; $437C

    ret                                           ; $437F


; C: validates both copies of the settings block
Sram_ValidateSettings::
    xor a                                         ; $4380
    ld [rRAMB], a                                 ; $4381
    call Sram_CheckSettingsMagic                  ; $4384
    jp nz, Sram_FormatSettingsBlocks              ; $4387

    ld hl, $b000                                  ; $438A
    call Sram_VerifySettingsChecksum              ; $438D
    jr z, jr_002_439e                             ; $4390

    ld hl, $b0d9                                  ; $4392
    call Sram_VerifySettingsChecksum              ; $4395
    jp z, Sram_RepairSettings_EchoToMain          ; $4398

    jp Sram_FormatSettingsBlocks                  ; $439B


jr_002_439e:
    ld hl, $b0d9                                  ; $439E
    call Sram_VerifySettingsChecksum              ; $43A1
    jp nz, Sram_RepairSettings_MainToEcho         ; $43A4

    ret                                           ; $43A7


; C: validates both copies of the photo vector
Sram_ValidateVector::
    xor a                                         ; $43A8
    ld [rRAMB], a                                 ; $43A9
    call Sram_CheckVectorMagic                    ; $43AC
    jp nz, Sram_FormatVectorBlocks                ; $43AF

    ld hl, $b1b2                                  ; $43B2
    call Sram_VerifyVectorChecksum                ; $43B5
    jr z, jr_002_43c6                             ; $43B8

    ld hl, $b1d7                                  ; $43BA
    call Sram_VerifyVectorChecksum                ; $43BD
    jp z, Sram_RepairVector_EchoToMain            ; $43C0

    jp Sram_FormatVectorBlocks                    ; $43C3


jr_002_43c6:
    ld hl, $b1d7                                  ; $43C6
    call Sram_VerifyVectorChecksum                ; $43C9
    jp nz, Sram_RepairVector_MainToEcho           ; $43CC

    ret                                           ; $43CF


; C: validates both copies of the owner block
Sram_ValidateOwner::
    ld a, $01                                     ; $43D0
    ld [rRAMB], a                                 ; $43D2
    call Sram_CheckOwnerMagic                     ; $43D5
    jp nz, Sram_FormatOwnerBlocks                 ; $43D8

    ld hl, $afb8                                  ; $43DB
    call Sram_VerifyOwnerChecksum                 ; $43DE
    jr z, jr_002_43ef                             ; $43E1

    ld hl, $afd1                                  ; $43E3
    call Sram_VerifyOwnerChecksum                 ; $43E6
    jp z, Sram_RepairOwner_EchoToMain             ; $43E9

    jp Sram_FormatOwnerBlocks                     ; $43EC


jr_002_43ef:
    ld hl, $afd1                                  ; $43EF
    call Sram_VerifyOwnerChecksum                 ; $43F2
    jp nz, Sram_RepairOwner_MainToEcho            ; $43F5

    ret                                           ; $43F8


; C: writes photo_vector_ram to both vector copies
Sram_StorePhotoVector::
    xor a                                         ; $43F9
    ld [rRAMB], a                                 ; $43FA
    ld de, $0000                                  ; $43FD
    call Sram_StorePhotoVectorCopy                ; $4400
    ld de, $0025                                  ; $4403

; C: one copy with checksum
Sram_StorePhotoVectorCopy::
    push de                                       ; $4406
    ld hl, $b1b2                                  ; $4407
    add hl, de                                    ; $440A
    ld de, wPhotoVectorRam                        ; $440B
    ld b, $1e                                     ; $440E

jr_002_4410:
    ld a, [de]                                    ; $4410
    ld [hl+], a                                   ; $4411
    inc de                                        ; $4412
    dec b                                         ; $4413
    jr nz, jr_002_4410                            ; $4414

    pop de                                        ; $4416
    push de                                       ; $4417
    ld hl, $b1b2                                  ; $4418
    add hl, de                                    ; $441B
    ld bc, $0023                                  ; $441C
    call Sram_Checksum                            ; $441F
    ld a, d                                       ; $4422
    add $4e                                       ; $4423
    ld [hl+], a                                   ; $4425
    ld a, e                                       ; $4426
    xor $54                                       ; $4427
    ld [hl], a                                    ; $4429
    pop de                                        ; $442A
    ret                                           ; $442B


; C: boot check: owner
Sram_ValidateAll_Far::
    push af                                       ; $442C
    ld a, $0a                                     ; $442D
    ld [rRAMG], a                                 ; $442F
    pop af                                        ; $4432
    call Sram_ValidateOwner                       ; $4433
    call Sram_ValidateVector                      ; $4436
    ld b, $1e                                     ; $4439

jr_002_443b:
    call Sram_ValidateTagSlot                     ; $443B
    dec b                                         ; $443E
    jr nz, jr_002_443b                            ; $443F

    call Sram_ValidateSettings                    ; $4441
    push af                                       ; $4444
    xor a                                         ; $4445
    ld [rRAMG], a                                 ; $4446
    pop af                                        ; $4449
    jp Far_Call_Return                            ; $444A


; C: A = photo slot id; returns its rank in the vector or carry
Photo_FindSlot_Far::
    ld hl, wPhotoVectorRam                        ; $444D
    ld b, $1e                                     ; $4450

jr_002_4452:
    cp [hl]                                       ; $4452
    jr z, jr_002_445e                             ; $4453

    inc hl                                        ; $4455
    dec b                                         ; $4456
    jr nz, jr_002_4452                            ; $4457

    xor a                                         ; $4459
    scf                                           ; $445A
    jp Far_Call_Return                            ; $445B


jr_002_445e:
    ld a, b                                       ; $445E
    cpl                                           ; $445F
    add $1f                                       ; $4460
    and a                                         ; $4462
    jp Far_Call_Return                            ; $4463


; C: renumbers the slots 0..n-1 in photo_vector_ram and stores photo_count
Photo_RenumberVector::
    push af                                       ; $4466
    ld a, $0a                                     ; $4467
    ld [rRAMG], a                                 ; $4469
    pop af                                        ; $446C
    xor a                                         ; $446D
    ld [rRAMB], a                                 ; $446E
    ld hl, $b1b2                                  ; $4471
    ld de, wPhotoVectorRam                        ; $4474
    ld b, $1e                                     ; $4477

jr_002_4479:
    ld a, [hl+]                                   ; $4479
    ld [de], a                                    ; $447A
    inc de                                        ; $447B
    dec b                                         ; $447C
    jr nz, jr_002_4479                            ; $447D

    ld b, $1e                                     ; $447F
    ld de, $0000                                  ; $4481

jr_002_4484:
    ld hl, wPhotoVectorRam                        ; $4484
    ld a, e                                       ; $4487
    ld c, $1e                                     ; $4488

jr_002_448a:
    cp [hl]                                       ; $448A
    jr nz, jr_002_4491                            ; $448B

    ld [hl], d                                    ; $448D
    inc d                                         ; $448E
    jr jr_002_4495                                ; $448F

jr_002_4491:
    inc hl                                        ; $4491
    dec c                                         ; $4492
    jr nz, jr_002_448a                            ; $4493

jr_002_4495:
    inc e                                         ; $4495
    dec b                                         ; $4496
    jr nz, jr_002_4484                            ; $4497

    ld bc, $1e00                                  ; $4499
    ld hl, wPhotoVectorRam                        ; $449C

jr_002_449f:
    ld a, [hl+]                                   ; $449F
    cp $ff                                        ; $44A0
    jr z, jr_002_44a5                             ; $44A2

    inc c                                         ; $44A4

jr_002_44a5:
    dec b                                         ; $44A5
    jr nz, jr_002_449f                            ; $44A6

    ld a, c                                       ; $44A8
    ld [wPhotoCount], a                           ; $44A9
    push af                                       ; $44AC
    xor a                                         ; $44AD
    ld [rRAMG], a                                 ; $44AE
    pop af                                        ; $44B1
    jp Far_Call_Return                            ; $44B2


; C: formats every block of the save (far call from bank 09)
Sram_FormatAll_Far::
    push af                                       ; $44B5
    ld a, $0a                                     ; $44B6
    ld [rRAMG], a                                 ; $44B8
    pop af                                        ; $44BB
    ld a, $01                                     ; $44BC
    ld [rRAMB], a                                 ; $44BE
    call Sram_FormatOwnerBlocks                   ; $44C1
    xor a                                         ; $44C4
    ld [rRAMB], a                                 ; $44C5
    call Sram_FormatVectorBlocks                  ; $44C8
    ld b, $1e                                     ; $44CB

jr_002_44cd:
    ld a, b                                       ; $44CD
    cpl                                           ; $44CE
    add $1f                                       ; $44CF
    srl a                                         ; $44D1
    inc a                                         ; $44D3
    ld [rRAMB], a                                 ; $44D4
    ld de, $0000                                  ; $44D7
    rl d                                          ; $44DA
    swap d                                        ; $44DC
    call Sram_FormatPhotoBank                     ; $44DE
    xor a                                         ; $44E1
    ld [rRAMB], a                                 ; $44E2
    call Sram_FreeSlotInVector                    ; $44E5
    dec b                                         ; $44E8
    jr nz, jr_002_44cd                            ; $44E9

    xor a                                         ; $44EB
    ld [rRAMB], a                                 ; $44EC
    call Sram_FormatSettingsBlocks                ; $44EF
    push af                                       ; $44F2
    xor a                                         ; $44F3
    ld [rRAMG], a                                 ; $44F4
    pop af                                        ; $44F7
    jp Far_Call_Return                            ; $44F8


; C: A = photo number: marks the slot free
Photo_Erase_Far::
    ldh [hFarcallAArg], a                         ; $44FB
    ld a, $02                                     ; $44FD
    ld hl, Photo_FindSlot_Far                     ; $44FF
    call Far_Call                                 ; $4502
    jp c, Far_Call_Return                         ; $4505

    push af                                       ; $4508
    ld a, $0a                                     ; $4509
    ld [rRAMG], a                                 ; $450B
    pop af                                        ; $450E
    push af                                       ; $450F
    xor a                                         ; $4510
    ld [rRAMB], a                                 ; $4511
    pop af                                        ; $4514
    ld c, a                                       ; $4515
    ld b, $00                                     ; $4516
    ld hl, wPhotoVectorRam                        ; $4518
    add hl, bc                                    ; $451B
    ld [hl], $ff                                  ; $451C
    call Sram_StorePhotoVector                    ; $451E
    push af                                       ; $4521
    xor a                                         ; $4522
    ld [rRAMG], a                                 ; $4523
    pop af                                        ; $4526
    jp Photo_RenumberVector                       ; $4527


; C: erases a photo then removes every reference to it from the hot spots and the animation list. L3 pass 2026-10-26:
; not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Photo_Erase_UnlinkAll_Far::
    ldh [hFarcallAArg], a                         ; $452A
    ld a, $02                                     ; $452C
    ld hl, Photo_FindSlot_Far                     ; $452E
    call Far_Call                                 ; $4531
    jp c, Far_Call_Return                         ; $4534

    ldh [hScratchA], a                            ; $4537
    ld a, [wPhotoCount]                           ; $4539
    dec a                                         ; $453C

jr_002_453d:
    ldh [hScratchB], a                            ; $453D
    ldh [hFarcallAArg], a                         ; $453F
    ld a, $02                                     ; $4541
    ld hl, Photo_LoadHotspots_Far                 ; $4543
    call Far_Call                                 ; $4546
    ld hl, wHotspotBlock                          ; $4549
    ld de, wHotspotBlock + $19                    ; $454C
    ldh a, [hScratchA]                            ; $454F
    ld c, a                                       ; $4551
    ld b, $05                                     ; $4552

jr_002_4554:
    ld a, [hl]                                    ; $4554
    and a                                         ; $4555
    jr z, jr_002_455f                             ; $4556

    ld a, [de]                                    ; $4558
    cp c                                          ; $4559
    jr nz, jr_002_455f                            ; $455A

    ld a, $ff                                     ; $455C
    ld [de], a                                    ; $455E

jr_002_455f:
    inc hl                                        ; $455F
    inc de                                        ; $4560
    dec b                                         ; $4561
    jr nz, jr_002_4554                            ; $4562

    ldh a, [hScratchB]                            ; $4564
    ldh [hFarcallAArg], a                         ; $4566
    ld a, $02                                     ; $4568
    ld hl, Photo_StoreHotspots_Far                ; $456A
    call Far_Call                                 ; $456D
    ldh a, [hScratchB]                            ; $4570
    dec a                                         ; $4572
    bit 7, a                                      ; $4573
    jr z, jr_002_453d                             ; $4575

    ldh [hFarcallAArg], a                         ; $4577
    ld a, $02                                     ; $4579
    ld hl, Settings_LoadAnim_Far                  ; $457B
    call Far_Call                                 ; $457E
    ld hl, wAnimList                              ; $4581
    ldh a, [hScratchA]                            ; $4584
    ld c, a                                       ; $4586
    ld b, $2f                                     ; $4587

jr_002_4589:
    ld a, [hl]                                    ; $4589
    cp c                                          ; $458A
    jr nz, jr_002_4590                            ; $458B

    ld a, $fe                                     ; $458D
    ld [hl], a                                    ; $458F

jr_002_4590:
    inc hl                                        ; $4590
    dec b                                         ; $4591
    jr nz, jr_002_4589                            ; $4592

    ldh [hFarcallAArg], a                         ; $4594
    ld a, $02                                     ; $4596
    ld hl, Settings_Store_Far                     ; $4598
    call Far_Call                                 ; $459B
    jp Far_Call_Return                            ; $459E


; C: saves the working image into a free slot with the copy flag set (copy badge); needs photo_count < 30. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Photo_SaveCopy_Far::
    ld c, a                                       ; $45A1
    ld a, [wPhotoCount]                           ; $45A2
    cp $1e                                        ; $45A5
    jp nc, Far_Call_Return                        ; $45A7

    ld a, $ff                                     ; $45AA
    ldh [hFarcallAArg], a                         ; $45AC
    ld a, $02                                     ; $45AE
    ld hl, Photo_FindSlot_Far                     ; $45B0
    call Far_Call                                 ; $45B3
    jp c, Far_Call_Return                         ; $45B6

    push af                                       ; $45B9
    ld a, $0a                                     ; $45BA
    ld [rRAMG], a                                 ; $45BC
    pop af                                        ; $45BF
    push bc                                       ; $45C0
    push hl                                       ; $45C1
    push af                                       ; $45C2
    ld d, HIGH(wThumbnail)                        ; $45C3
    call Thumb_DrawCopyBadge                      ; $45C5
    ld a, $01                                     ; $45C8
    ld [wSlotTagCopyFlag], a                      ; $45CA
    ld [wSlotTagEchoCopyFlag], a                  ; $45CD
    ld hl, wSlotTagOwnerCopy                      ; $45D0
    ld bc, $005a                                  ; $45D3
    call Sram_WriteChecksum                       ; $45D6
    ld hl, wSlotTagEcho                           ; $45D9
    ld bc, $005a                                  ; $45DC
    call Sram_WriteChecksum                       ; $45DF
    pop af                                        ; $45E2
    srl a                                         ; $45E3
    inc a                                         ; $45E5
    ld [rRAMB], a                                 ; $45E6
    ld de, $0000                                  ; $45E9
    rl d                                          ; $45EC
    swap d                                        ; $45EE
    ld hl, $a000                                  ; $45F0
    add hl, de                                    ; $45F3
    ld de, wPhotoImage                            ; $45F4
    ld bc, $0fb8                                  ; $45F7

jr_002_45fa:
    ld a, [de]                                    ; $45FA
    ld [hl+], a                                   ; $45FB
    inc de                                        ; $45FC
    dec bc                                        ; $45FD
    ld a, b                                       ; $45FE
    or c                                          ; $45FF
    jr nz, jr_002_45fa                            ; $4600

    pop hl                                        ; $4602
    pop bc                                        ; $4603
    ld a, c                                       ; $4604
    cp $1e                                        ; $4605
    jr nc, jr_002_461f                            ; $4607

    push hl                                       ; $4609
    ld hl, wPhotoVectorRam                        ; $460A
    ld b, $1e                                     ; $460D

jr_002_460f:
    cp [hl]                                       ; $460F
    jr nc, jr_002_4617                            ; $4610

    bit 7, [hl]                                   ; $4612
    jr nz, jr_002_4617                            ; $4614

    inc [hl]                                      ; $4616

jr_002_4617:
    inc hl                                        ; $4617
    dec b                                         ; $4618
    jr nz, jr_002_460f                            ; $4619

    pop hl                                        ; $461B
    inc a                                         ; $461C
    jr jr_002_4622                                ; $461D

jr_002_461f:
    ld a, [wPhotoCount]                           ; $461F

jr_002_4622:
    ld [hl], a                                    ; $4622
    call Sram_StorePhotoVector                    ; $4623
    push af                                       ; $4626
    xor a                                         ; $4627
    ld [rRAMG], a                                 ; $4628
    pop af                                        ; $462B
    jp Photo_RenumberVector                       ; $462C


; C: link receive: stores the received photo and bumps the gender counters F12 / F13 of its tag
Photo_SaveReceived_Far::
    ldh [hFarcallAArg], a                         ; $462F
    ld a, $02                                     ; $4631
    ld hl, Owner_Load_Far                         ; $4633
    call Far_Call                                 ; $4636
    ld a, [wPhotoCount]                           ; $4639
    cp $1e                                        ; $463C
    jp nc, Far_Call_Return                        ; $463E

    ld a, $ff                                     ; $4641
    ldh [hFarcallAArg], a                         ; $4643
    ld a, $02                                     ; $4645
    ld hl, Photo_FindSlot_Far                     ; $4647
    call Far_Call                                 ; $464A
    jp c, Far_Call_Return                         ; $464D

    push af                                       ; $4650
    ld a, $0a                                     ; $4651
    ld [rRAMG], a                                 ; $4653
    pop af                                        ; $4656
    push hl                                       ; $4657
    push af                                       ; $4658
    ld de, $0000                                  ; $4659
    ld b, $02                                     ; $465C

jr_002_465e:
    push bc                                       ; $465E
    push de                                       ; $465F
    ld hl, wSlotTagRecvCounters                   ; $4660
    add hl, de                                    ; $4663
    ld a, [wOwnerGenderBlood]                     ; $4664
    ld b, a                                       ; $4667
    ld a, [hl]                                    ; $4668
    bit 0, b                                      ; $4669
    jr z, jr_002_4672                             ; $466B

    cp $63                                        ; $466D
    jr nc, jr_002_4672                            ; $466F

    inc a                                         ; $4671

jr_002_4672:
    ld [hl+], a                                   ; $4672
    ld a, [hl]                                    ; $4673
    bit 1, b                                      ; $4674
    jr z, jr_002_467d                             ; $4676

    cp $63                                        ; $4678
    jr nc, jr_002_467d                            ; $467A

    inc a                                         ; $467C

jr_002_467d:
    ld [hl+], a                                   ; $467D
    ld a, [hl]                                    ; $467E
    cp $63                                        ; $467F
    jr nc, jr_002_4684                            ; $4681

    inc a                                         ; $4683

jr_002_4684:
    ld [hl], a                                    ; $4684
    pop de                                        ; $4685
    push de                                       ; $4686
    ld hl, wSlotTagHotspotFields                  ; $4687
    add hl, de                                    ; $468A
    ld c, $1e                                     ; $468B
    call Sram_ZeroTagBytes                        ; $468D
    pop de                                        ; $4690
    push de                                       ; $4691
    ld hl, wSlotTagMagic                          ; $4692
    add hl, de                                    ; $4695
    ld de, Sram_MagicString                       ; $4696
    ld c, $05                                     ; $4699

jr_002_469b:
    ld a, [de]                                    ; $469B
    ld [hl+], a                                   ; $469C
    inc de                                        ; $469D
    dec c                                         ; $469E
    jr nz, jr_002_469b                            ; $469F

    pop de                                        ; $46A1
    push de                                       ; $46A2
    ld hl, wSlotTagOwnerCopy                      ; $46A3
    add hl, de                                    ; $46A6
    ld bc, $005a                                  ; $46A7
    call Sram_WriteChecksum                       ; $46AA
    pop de                                        ; $46AD
    pop bc                                        ; $46AE
    ld de, $005c                                  ; $46AF
    dec b                                         ; $46B2
    jr nz, jr_002_465e                            ; $46B3

    pop af                                        ; $46B5
    srl a                                         ; $46B6
    inc a                                         ; $46B8
    ld [rRAMB], a                                 ; $46B9
    ld de, $0000                                  ; $46BC
    rl d                                          ; $46BF
    swap d                                        ; $46C1
    ld hl, $a000                                  ; $46C3
    add hl, de                                    ; $46C6
    ld de, wPhotoImage                            ; $46C7
    ld bc, $0fb8                                  ; $46CA

jr_002_46cd:
    ld a, [de]                                    ; $46CD
    ld [hl+], a                                   ; $46CE
    inc de                                        ; $46CF
    dec bc                                        ; $46D0
    ld a, b                                       ; $46D1
    or c                                          ; $46D2
    jr nz, jr_002_46cd                            ; $46D3

    pop hl                                        ; $46D5
    ld a, [wPhotoCount]                           ; $46D6
    ld [hl], a                                    ; $46D9
    call Sram_StorePhotoVector                    ; $46DA
    push af                                       ; $46DD
    xor a                                         ; $46DE
    ld [rRAMG], a                                 ; $46DF
    pop af                                        ; $46E2
    jp Photo_RenumberVector                       ; $46E3


; I: 3 bytes 00 C0 00 between the jp of Photo_SaveReceived_Far (02:46E3) and Sram_ZeroTagBytes (02:46E9); read as code
; they would be nop / ret nz / nop but nothing jumps here. Evidence: never executed or read in the 18,739-entry replay
; coverage (organic or forced runs: only the forced runs touched the ...
Unused_Photo_SaveReceived_Far_Stray46E6::
    db $00, $c0, $00

; C: zeroes C bytes at HL. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: zeroes C bytes at HL (called from Photo_SaveShot_Far on its jr_002_4684 path)
Sram_ZeroTagBytes::
    xor a                                         ; $46E9

jr_002_46ea:
    ld [hl+], a                                   ; $46EA
    inc de                                        ; $46EB
    dec c                                         ; $46EC
    jr nz, jr_002_46ea                            ; $46ED

    ret                                           ; $46EF


; C: stores a new shot: checksums
Photo_SaveShot_Far::
    ldh [hFarcallAArg], a                         ; $46F0
    ld a, $02                                     ; $46F2
    ld hl, Owner_Load_Far                         ; $46F4
    call Far_Call                                 ; $46F7
    call Sram_ComputeImageChecksums               ; $46FA
    ld a, [wPhotoCount]                           ; $46FD
    cp $1e                                        ; $4700
    jp nc, Far_Call_Return                        ; $4702

    ld a, $ff                                     ; $4705
    ldh [hFarcallAArg], a                         ; $4707
    ld a, $02                                     ; $4709
    ld hl, Photo_FindSlot_Far                     ; $470B
    call Far_Call                                 ; $470E
    jp c, Far_Call_Return                         ; $4711

    push af                                       ; $4714
    ld a, $0a                                     ; $4715
    ld [rRAMG], a                                 ; $4717
    pop af                                        ; $471A
    push hl                                       ; $471B
    push af                                       ; $471C
    ld hl, wThumbnail                             ; $471D
    ld bc, $0100                                  ; $4720
    call Mem_Zero                                 ; $4723
    ld hl, Photo_SaveShot_Far_Tbl47B3             ; $4726
    ld bc, wThumbnail                             ; $4729
    call Img_ReduceToThumbnail                    ; $472C
    ld hl, wThumbnail                             ; $472F
    ld a, $03                                     ; $4732
    call Thumb_DrawFrame                          ; $4734
    ld de, $0000                                  ; $4737
    ld b, $02                                     ; $473A

jr_002_473c:
    push bc                                       ; $473C
    push de                                       ; $473D
    ld hl, wSlotTagOwnerCopy                      ; $473E
    add hl, de                                    ; $4741
    ld de, wOwnerId                               ; $4742
    ld c, $12                                     ; $4745
    call Mem_CopyShort                            ; $4747
    ld c, $43                                     ; $474A
    call Mem_ZeroShort                            ; $474C
    pop de                                        ; $474F
    push de                                       ; $4750
    ld hl, wSlotTagImageCheck                     ; $4751
    add hl, de                                    ; $4754
    ld a, [wTagImageCheck]                        ; $4755
    ld [hl+], a                                   ; $4758
    ld a, [wTagImageCheck + $1]                   ; $4759
    ld [hl], a                                    ; $475C
    pop de                                        ; $475D
    push de                                       ; $475E
    ld hl, wSlotTagMagic                          ; $475F
    add hl, de                                    ; $4762
    ld de, Sram_MagicString                       ; $4763
    ld c, $05                                     ; $4766

jr_002_4768:
    ld a, [de]                                    ; $4768
    ld [hl+], a                                   ; $4769
    inc de                                        ; $476A
    dec c                                         ; $476B
    jr nz, jr_002_4768                            ; $476C

    pop de                                        ; $476E
    push de                                       ; $476F
    ld hl, wSlotTagOwnerCopy                      ; $4770
    add hl, de                                    ; $4773
    ld bc, $005a                                  ; $4774
    call Sram_WriteChecksum                       ; $4777
    pop de                                        ; $477A
    pop bc                                        ; $477B
    ld de, $005c                                  ; $477C
    dec b                                         ; $477F
    jr nz, jr_002_473c                            ; $4780

    pop af                                        ; $4782
    srl a                                         ; $4783
    inc a                                         ; $4785
    ld [rRAMB], a                                 ; $4786
    ld de, $0000                                  ; $4789
    rl d                                          ; $478C
    swap d                                        ; $478E
    ld hl, $a000                                  ; $4790
    add hl, de                                    ; $4793
    ld de, wPhotoImage                            ; $4794
    ld bc, $0fb8                                  ; $4797

jr_002_479a:
    ld a, [de]                                    ; $479A
    ld [hl+], a                                   ; $479B
    inc de                                        ; $479C
    dec bc                                        ; $479D
    ld a, b                                       ; $479E
    or c                                          ; $479F
    jr nz, jr_002_479a                            ; $47A0

    pop hl                                        ; $47A2
    ld a, [wPhotoCount]                           ; $47A3
    ld [hl], a                                    ; $47A6
    call Sram_StorePhotoVector                    ; $47A7
    push af                                       ; $47AA
    xor a                                         ; $47AB
    ld [rRAMG], a                                 ; $47AC
    pop af                                        ; $47AF
    jp Photo_RenumberVector                       ; $47B0


; C: auto: 3 bytes, bytes; referenced by Photo_SaveShot_Far. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Photo_SaveShot_Far_Tbl47B3::
    db $00, $c0, $00

; C: copies C bytes from DE to HL. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Mem_CopyShort::
    ld a, [de]                                    ; $47B6
    ld [hl+], a                                   ; $47B7
    inc de                                        ; $47B8
    dec c                                         ; $47B9
    jr nz, Mem_CopyShort                          ; $47BA

    ret                                           ; $47BC


; C: writes C zero bytes at HL. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Mem_ZeroShort::
    xor a                                         ; $47BD

jr_002_47be:
    ld [hl+], a                                   ; $47BE
    inc de                                        ; $47BF
    dec c                                         ; $47C0
    jr nz, jr_002_47be                            ; $47C1

    ret                                           ; $47C3


; C: rewrites the image + thumbnail of an existing slot. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Photo_StoreImage_Far::
    cp $1e                                        ; $47C4
    jp nc, Far_Call_Return                        ; $47C6

    ldh [hFarcallAArg], a                         ; $47C9
    ld a, $02                                     ; $47CB
    ld hl, Photo_FindSlot_Far                     ; $47CD
    call Far_Call                                 ; $47D0
    jp c, Far_Call_Return                         ; $47D3

    push af                                       ; $47D6
    ld a, $0a                                     ; $47D7
    ld [rRAMG], a                                 ; $47D9
    pop af                                        ; $47DC
    push af                                       ; $47DD
    ld hl, wThumbnail                             ; $47DE
    ld bc, $0100                                  ; $47E1
    call Mem_Zero                                 ; $47E4
    ld hl, Photo_StoreImage_Far_Tbl482F           ; $47E7
    ld bc, wThumbnail                             ; $47EA
    call Img_ReduceToThumbnail                    ; $47ED
    ld hl, wThumbnail                             ; $47F0
    ld a, $03                                     ; $47F3
    call Thumb_DrawFrame                          ; $47F5
    ld a, [wSlotTagCopyFlag]                      ; $47F8
    and a                                         ; $47FB
    jr z, jr_002_4803                             ; $47FC

    ld d, HIGH(wThumbnail)                        ; $47FE
    call Thumb_DrawCopyBadge                      ; $4800

jr_002_4803:
    pop af                                        ; $4803
    srl a                                         ; $4804
    inc a                                         ; $4806
    ld [rRAMB], a                                 ; $4807
    ld de, $0000                                  ; $480A
    rl d                                          ; $480D
    swap d                                        ; $480F
    ld hl, $a000                                  ; $4811
    add hl, de                                    ; $4814
    ld de, wPhotoImage                            ; $4815
    ld bc, $0f00                                  ; $4818

jr_002_481b:
    ld a, [de]                                    ; $481B
    ld [hl+], a                                   ; $481C
    inc de                                        ; $481D
    dec bc                                        ; $481E
    ld a, b                                       ; $481F
    or c                                          ; $4820
    jr nz, jr_002_481b                            ; $4821

    call Sram_StorePhotoVector                    ; $4823
    push af                                       ; $4826
    xor a                                         ; $4827
    ld [rRAMG], a                                 ; $4828
    pop af                                        ; $482B
    jp Far_Call_Return                            ; $482C


; C: auto: 3 bytes, bytes; referenced by Photo_StoreImage_Far. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Photo_StoreImage_Far_Tbl482F::
    db $00, $c0, $00

; C: writes the 30-byte hot-spot block D643 into both tag copies
Photo_StoreHotspots_Far::
    cp $1e                                        ; $4832
    jp nc, Far_Call_Return                        ; $4834

    ldh [hFarcallAArg], a                         ; $4837
    ld a, $02                                     ; $4839
    ld hl, Photo_FindSlot_Far                     ; $483B
    call Far_Call                                 ; $483E
    jp c, Far_Call_Return                         ; $4841

    push af                                       ; $4844
    ld a, $0a                                     ; $4845
    ld [rRAMG], a                                 ; $4847
    pop af                                        ; $484A
    srl a                                         ; $484B
    inc a                                         ; $484D
    ld [rRAMB], a                                 ; $484E
    ld de, $0000                                  ; $4851
    rl d                                          ; $4854
    swap d                                        ; $4856
    ld b, $02                                     ; $4858

jr_002_485a:
    push bc                                       ; $485A
    push de                                       ; $485B
    ld hl, $af36                                  ; $485C
    add hl, de                                    ; $485F
    ld de, wHotspotBlock                          ; $4860
    ld c, $1e                                     ; $4863

jr_002_4865:
    ld a, [de]                                    ; $4865
    ld [hl+], a                                   ; $4866
    inc de                                        ; $4867
    dec c                                         ; $4868
    jr nz, jr_002_4865                            ; $4869

    pop de                                        ; $486B
    push de                                       ; $486C
    ld hl, $af00                                  ; $486D
    add hl, de                                    ; $4870
    ld bc, $005a                                  ; $4871
    call Sram_WriteChecksum                       ; $4874
    pop de                                        ; $4877
    pop bc                                        ; $4878
    ld a, e                                       ; $4879
    add $5c                                       ; $487A
    ld e, a                                       ; $487C
    jr nc, jr_002_4880                            ; $487D

    inc d                                         ; $487F

jr_002_4880:
    dec b                                         ; $4880
    jr nz, jr_002_485a                            ; $4881

    call Sram_StorePhotoVector                    ; $4883
    push af                                       ; $4886
    xor a                                         ; $4887
    ld [rRAMG], a                                 ; $4888
    pop af                                        ; $488B
    jp Far_Call_Return                            ; $488C


; C: as above but translates the five target photo numbers through the vector
Photo_StoreHotspotsTranslated_Far::
    cp $1e                                        ; $488F
    jp nc, Far_Call_Return                        ; $4891

    ldh [hFarcallAArg], a                         ; $4894
    ld a, $02                                     ; $4896
    ld hl, Photo_FindSlot_Far                     ; $4898
    call Far_Call                                 ; $489B
    jp c, Far_Call_Return                         ; $489E

    push af                                       ; $48A1
    ld a, $0a                                     ; $48A2
    ld [rRAMG], a                                 ; $48A4
    pop af                                        ; $48A7
    srl a                                         ; $48A8
    inc a                                         ; $48AA
    ld [rRAMB], a                                 ; $48AB
    ld de, $0000                                  ; $48AE
    rl d                                          ; $48B1
    swap d                                        ; $48B3
    ld b, $02                                     ; $48B5

jr_002_48b7:
    push bc                                       ; $48B7
    push de                                       ; $48B8
    ld hl, $af36                                  ; $48B9
    add hl, de                                    ; $48BC
    ld de, wHotspotBlock                          ; $48BD
    ld c, $19                                     ; $48C0

jr_002_48c2:
    ld a, [de]                                    ; $48C2
    ld [hl+], a                                   ; $48C3
    inc de                                        ; $48C4
    dec c                                         ; $48C5
    jr nz, jr_002_48c2                            ; $48C6

    ld c, $05                                     ; $48C8

jr_002_48ca:
    ld a, [de]                                    ; $48CA
    call Vec_GetPhotoVectorByteFar                ; $48CB
    ld [hl+], a                                   ; $48CE
    inc de                                        ; $48CF
    dec c                                         ; $48D0
    jr nz, jr_002_48ca                            ; $48D1

    pop de                                        ; $48D3
    push de                                       ; $48D4
    ld hl, $af00                                  ; $48D5
    add hl, de                                    ; $48D8
    ld bc, $005a                                  ; $48D9
    call Sram_WriteChecksum                       ; $48DC
    pop de                                        ; $48DF
    pop bc                                        ; $48E0
    ld a, e                                       ; $48E1
    add $5c                                       ; $48E2
    ld e, a                                       ; $48E4
    jr nc, jr_002_48e8                            ; $48E5

    inc d                                         ; $48E7

jr_002_48e8:
    dec b                                         ; $48E8
    jr nz, jr_002_48b7                            ; $48E9

    call Sram_StorePhotoVector                    ; $48EB
    push af                                       ; $48EE
    xor a                                         ; $48EF
    ld [rRAMG], a                                 ; $48F0
    pop af                                        ; $48F3
    jp Far_Call_Return                            ; $48F4


; C: writes the border number D7C1 into both tag copies
Photo_StoreBorder_Far::
    cp $1e                                        ; $48F7
    jp nc, Far_Call_Return                        ; $48F9

    ldh [hFarcallAArg], a                         ; $48FC
    ld a, $02                                     ; $48FE
    ld hl, Photo_FindSlot_Far                     ; $4900
    call Far_Call                                 ; $4903
    jp c, Far_Call_Return                         ; $4906

    push af                                       ; $4909
    ld a, $0a                                     ; $490A
    ld [rRAMG], a                                 ; $490C
    pop af                                        ; $490F
    srl a                                         ; $4910
    inc a                                         ; $4912
    ld [rRAMB], a                                 ; $4913
    ld de, $0000                                  ; $4916
    rl d                                          ; $4919
    swap d                                        ; $491B
    ld b, $02                                     ; $491D

jr_002_491f:
    push bc                                       ; $491F
    push de                                       ; $4920
    ld hl, $af54                                  ; $4921
    add hl, de                                    ; $4924
    ld a, [wBorderNumber]                         ; $4925
    ld [hl], a                                    ; $4928
    ld hl, $af00                                  ; $4929
    add hl, de                                    ; $492C
    ld bc, $005a                                  ; $492D
    call Sram_WriteChecksum                       ; $4930
    pop de                                        ; $4933
    pop bc                                        ; $4934
    ld a, e                                       ; $4935
    add $5c                                       ; $4936
    ld e, a                                       ; $4938
    jr nc, jr_002_493c                            ; $4939

    inc d                                         ; $493B

jr_002_493c:
    dec b                                         ; $493C
    jr nz, jr_002_491f                            ; $493D

    call Sram_StorePhotoVector                    ; $493F
    push af                                       ; $4942
    xor a                                         ; $4943
    ld [rRAMG], a                                 ; $4944
    pop af                                        ; $4947
    jp Far_Call_Return                            ; $4948


; C: copies the $36 owner / tag fields from DA5B into both tag copies
Photo_StoreTagFields_Far::
    cp $1e                                        ; $494B
    jp nc, Far_Call_Return                        ; $494D

    ldh [hFarcallAArg], a                         ; $4950
    ld a, $02                                     ; $4952
    ld hl, Photo_FindSlot_Far                     ; $4954
    call Far_Call                                 ; $4957
    jp c, Far_Call_Return                         ; $495A

    push af                                       ; $495D
    ld a, $0a                                     ; $495E
    ld [rRAMG], a                                 ; $4960
    pop af                                        ; $4963
    srl a                                         ; $4964
    inc a                                         ; $4966
    ld [rRAMB], a                                 ; $4967
    ld de, $0000                                  ; $496A
    rl d                                          ; $496D
    swap d                                        ; $496F
    ld b, $02                                     ; $4971

jr_002_4973:
    push bc                                       ; $4973
    push de                                       ; $4974
    ld hl, $af00                                  ; $4975
    add hl, de                                    ; $4978
    ld de, wTagOwnerId                            ; $4979
    ld c, $36                                     ; $497C

jr_002_497e:
    ld a, [de]                                    ; $497E
    ld [hl+], a                                   ; $497F
    inc de                                        ; $4980
    dec c                                         ; $4981
    jr nz, jr_002_497e                            ; $4982

    pop de                                        ; $4984
    push de                                       ; $4985
    ld hl, $af00                                  ; $4986
    add hl, de                                    ; $4989
    ld bc, $005a                                  ; $498A
    call Sram_WriteChecksum                       ; $498D
    pop de                                        ; $4990
    pop bc                                        ; $4991
    ld a, e                                       ; $4992
    add $5c                                       ; $4993
    ld e, a                                       ; $4995
    jr nc, jr_002_4999                            ; $4996

    inc d                                         ; $4998

jr_002_4999:
    dec b                                         ; $4999
    jr nz, jr_002_4973                            ; $499A

    call Sram_StorePhotoVector                    ; $499C
    push af                                       ; $499F
    xor a                                         ; $49A0
    ld [rRAMG], a                                 ; $49A1
    pop af                                        ; $49A4
    jp Far_Call_Return                            ; $49A5


; C: writes animation list
Settings_Store_Far::
    push af                                       ; $49A8
    ld a, $0a                                     ; $49A9
    ld [rRAMG], a                                 ; $49AB
    pop af                                        ; $49AE
    xor a                                         ; $49AF
    ld [rRAMB], a                                 ; $49B0
    ld de, $0000                                  ; $49B3
    ld b, $02                                     ; $49B6

jr_002_49b8:
    push bc                                       ; $49B8
    push de                                       ; $49B9
    ld hl, $b000                                  ; $49BA
    add hl, de                                    ; $49BD
    ld de, wAnimList                              ; $49BE
    ld c, $30                                     ; $49C1

jr_002_49c3:
    ld a, [de]                                    ; $49C3
    ld [hl+], a                                   ; $49C4
    inc de                                        ; $49C5
    dec c                                         ; $49C6
    jr nz, jr_002_49c3                            ; $49C7

    pop de                                        ; $49C9
    push de                                       ; $49CA
    ld hl, $b030                                  ; $49CB
    add hl, de                                    ; $49CE
    ld de, wAnimTiming                            ; $49CF
    ld c, $2f                                     ; $49D2

jr_002_49d4:
    ld a, [de]                                    ; $49D4
    ld [hl+], a                                   ; $49D5
    inc de                                        ; $49D6
    dec c                                         ; $49D7
    jr nz, jr_002_49d4                            ; $49D8

    pop de                                        ; $49DA
    ld hl, $b05f                                  ; $49DB
    add hl, de                                    ; $49DE
    ld a, [wAnimSpeed]                            ; $49DF
    ld [hl+], a                                   ; $49E2
    ld a, [wAnimBorder]                           ; $49E3
    ld [hl], a                                    ; $49E6
    push de                                       ; $49E7
    ld hl, $b000                                  ; $49E8
    add hl, de                                    ; $49EB
    ld bc, $00d7                                  ; $49EC
    call Sram_WriteChecksum                       ; $49EF
    pop de                                        ; $49F2
    pop bc                                        ; $49F3
    ld a, e                                       ; $49F4
    add $d9                                       ; $49F5
    ld e, a                                       ; $49F7
    jr nc, jr_002_49fb                            ; $49F8

    inc d                                         ; $49FA

jr_002_49fb:
    dec b                                         ; $49FB
    jr nz, jr_002_49b8                            ; $49FC

    push af                                       ; $49FE
    xor a                                         ; $49FF
    ld [rRAMG], a                                 ; $4A00
    pop af                                        ; $4A03
    jp Far_Call_Return                            ; $4A04


; C: as 49A8 but translates the 47 animation entries photo number -> slot id
Settings_StoreAnimTranslated_Far::
    push af                                       ; $4A07
    ld a, $0a                                     ; $4A08
    ld [rRAMG], a                                 ; $4A0A
    pop af                                        ; $4A0D
    xor a                                         ; $4A0E
    ld [rRAMB], a                                 ; $4A0F
    ld de, $0000                                  ; $4A12
    ld b, $02                                     ; $4A15

jr_002_4a17:
    push bc                                       ; $4A17
    push de                                       ; $4A18
    ld hl, $b000                                  ; $4A19
    add hl, de                                    ; $4A1C
    ld de, wAnimList                              ; $4A1D
    ld c, $2f                                     ; $4A20

jr_002_4a22:
    ld a, [de]                                    ; $4A22
    call Vec_GetPhotoVectorByteFar                ; $4A23
    ld [hl+], a                                   ; $4A26
    inc de                                        ; $4A27
    dec c                                         ; $4A28
    jr nz, jr_002_4a22                            ; $4A29

    ld a, [de]                                    ; $4A2B
    ld [hl], a                                    ; $4A2C
    pop de                                        ; $4A2D
    push de                                       ; $4A2E
    ld hl, $b030                                  ; $4A2F
    add hl, de                                    ; $4A32
    ld de, wAnimTiming                            ; $4A33
    ld c, $2f                                     ; $4A36

jr_002_4a38:
    ld a, [de]                                    ; $4A38
    ld [hl+], a                                   ; $4A39
    inc de                                        ; $4A3A
    dec c                                         ; $4A3B
    jr nz, jr_002_4a38                            ; $4A3C

    pop de                                        ; $4A3E
    ld hl, $b05f                                  ; $4A3F
    add hl, de                                    ; $4A42
    ld a, [wAnimSpeed]                            ; $4A43
    ld [hl+], a                                   ; $4A46
    ld a, [wAnimBorder]                           ; $4A47
    ld [hl], a                                    ; $4A4A
    push de                                       ; $4A4B
    ld hl, $b000                                  ; $4A4C
    add hl, de                                    ; $4A4F
    ld bc, $00d7                                  ; $4A50
    call Sram_WriteChecksum                       ; $4A53
    pop de                                        ; $4A56
    pop bc                                        ; $4A57
    ld a, e                                       ; $4A58
    add $d9                                       ; $4A59
    ld e, a                                       ; $4A5B
    jr nc, jr_002_4a5f                            ; $4A5C

    inc d                                         ; $4A5E

jr_002_4a5f:
    dec b                                         ; $4A5F
    jr nz, jr_002_4a17                            ; $4A60

    push af                                       ; $4A62
    xor a                                         ; $4A63
    ld [rRAMG], a                                 ; $4A64
    pop af                                        ; $4A67
    jp Far_Call_Return                            ; $4A68


; C: packs the D.J. tune from $D93D.. into the settings block (B061..) of both copies
Dj_StoreTune_Far::
    push af                                       ; $4A6B
    ld a, $0a                                     ; $4A6C
    ld [rRAMG], a                                 ; $4A6E
    pop af                                        ; $4A71
    xor a                                         ; $4A72
    ld [rRAMB], a                                 ; $4A73
    ld de, $0000                                  ; $4A76
    ld b, $02                                     ; $4A79

; C: per-tune loop top: packs duty / length, envelope, modulation, notes and stereo codes of one tune from the editor
; shadows into the SRAM image (branch target; code read 2026-10-19)
Dj_StoreTune_Far_TuneLoop::
    push bc                                       ; $4A7B
    push de                                       ; $4A7C
    ld hl, $b061                                  ; $4A7D
    add hl, de                                    ; $4A80
    ld de, wSound1DutyLen                         ; $4A81
    call Dj_PackDutyLength                        ; $4A84
    ld de, wSound1Envelope                        ; $4A87
    call Dj_PackEnvelope                          ; $4A8A
    ld de, wSound1Modulation                      ; $4A8D
    call Dj_PackModulation                        ; $4A90
    ld de, wSound1Notes                           ; $4A93
    call Dj_CopyNotes                             ; $4A96
    ld de, wSound1Stereo                          ; $4A99
    call Dj_PackStereoCodes                       ; $4A9C
    ld de, wSound2UserWave                        ; $4A9F
    call Dj_PackWave                              ; $4AA2
    ld de, wSound2WaveLen                         ; $4AA5
    call Dj_PackDutyLength                        ; $4AA8
    ld de, wSound2Modulation                      ; $4AAB
    call Dj_PackModulation                        ; $4AAE
    ld de, wSound2Notes                           ; $4AB1
    call Dj_CopyNotes                             ; $4AB4
    ld de, wSound2Stereo                          ; $4AB7
    call Dj_PackStereoCodes                       ; $4ABA
    ld de, wLoopLengths                           ; $4ABD
    ld a, [de]                                    ; $4AC0
    dec a                                         ; $4AC1
    inc de                                        ; $4AC2
    and $0f                                       ; $4AC3
    swap a                                        ; $4AC5
    ld c, a                                       ; $4AC7
    ld a, [de]                                    ; $4AC8
    dec a                                         ; $4AC9
    and $0f                                       ; $4ACA
    or c                                          ; $4ACC
    ld [hl+], a                                   ; $4ACD
    ld de, wNoiseEnvelope                         ; $4ACE
    call Dj_PackEnvelope                          ; $4AD1
    ld de, wNoiseGateLoop                         ; $4AD4
    ld a, [de]                                    ; $4AD7
    inc de                                        ; $4AD8
    and $0f                                       ; $4AD9
    swap a                                        ; $4ADB
    ld c, a                                       ; $4ADD
    ld a, [de]                                    ; $4ADE
    dec a                                         ; $4ADF
    and $0f                                       ; $4AE0
    or c                                          ; $4AE2
    ld [hl+], a                                   ; $4AE3
    ld de, wNoiseNotes                            ; $4AE4
    call Dj_CopyNotes                             ; $4AE7
    ld de, wNoiseStereoWidth                      ; $4AEA
    call Dj_PackStereoCodes                       ; $4AED
    ld de, wNoiseStereoWidth                      ; $4AF0
    call Dj_PackNoiseBits                         ; $4AF3
    ld a, [wTempo]                                ; $4AF6
    ld [hl+], a                                   ; $4AF9
    ld [hl], $01                                  ; $4AFA
    pop de                                        ; $4AFC
    push de                                       ; $4AFD
    ld hl, $b000                                  ; $4AFE
    add hl, de                                    ; $4B01
    ld bc, $00d7                                  ; $4B02
    call Sram_WriteChecksum                       ; $4B05
    pop de                                        ; $4B08
    pop bc                                        ; $4B09
    ld a, e                                       ; $4B0A
    add $d9                                       ; $4B0B
    ld e, a                                       ; $4B0D
    jr nc, jr_002_4b11                            ; $4B0E

    inc d                                         ; $4B10

jr_002_4b11:
    dec b                                         ; $4B11
    jp nz, Dj_StoreTune_Far_TuneLoop              ; $4B12

    push af                                       ; $4B15
    xor a                                         ; $4B16
    ld [rRAMG], a                                 ; $4B17
    pop af                                        ; $4B1A
    jp Far_Call_Return                            ; $4B1B


; C: packs duty (2 bits) and length (4 bits) into one byte. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: packs (duty & 3) << 4 | (length & $0F) into one byte,
; called by Dj_StoreTune_Far_TuneLoop (storing a D.J. tune to SRAM)
Dj_PackDutyLength::
    ld a, [de]                                    ; $4B1E
    inc de                                        ; $4B1F
    and $03                                       ; $4B20
    swap a                                        ; $4B22
    ld c, a                                       ; $4B24
    ld a, [de]                                    ; $4B25
    and $0f                                       ; $4B26
    or c                                          ; $4B28
    ld [hl+], a                                   ; $4B29
    ret                                           ; $4B2A


; C: packs direction / period / initial volume. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB
; scenarios, core organic runs); C from the code: packs envelope direction (bit 7), step (bits 6-4) and volume (bits
; 3-0) into one byte, called by Dj_StoreTune_Far_TuneLoop
Dj_PackEnvelope::
    ld a, [de]                                    ; $4B2B
    inc de                                        ; $4B2C
    and $01                                       ; $4B2D
    rrc a                                         ; $4B2F
    ld c, a                                       ; $4B31
    ld a, [de]                                    ; $4B32
    inc de                                        ; $4B33
    and $07                                       ; $4B34
    swap a                                        ; $4B36
    or c                                          ; $4B38
    ld c, a                                       ; $4B39
    ld a, [de]                                    ; $4B3A
    and $0f                                       ; $4B3B
    or c                                          ; $4B3D
    ld [hl+], a                                   ; $4B3E
    ret                                           ; $4B3F


; C: packs modulation depth and flags. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core
; organic runs); C from the code: packs the modulation fields into one byte, called by Dj_StoreTune_Far_TuneLoop
Dj_PackModulation::
    ld a, [de]                                    ; $4B40
    inc de                                        ; $4B41
    and $7f                                       ; $4B42
    ld [hl+], a                                   ; $4B44
    ld a, [de]                                    ; $4B45
    inc de                                        ; $4B46
    and $7f                                       ; $4B47
    ld [hl-], a                                   ; $4B49
    ld a, [de]                                    ; $4B4A
    and $01                                       ; $4B4B
    rrc a                                         ; $4B4D
    or [hl]                                       ; $4B4F
    ld [hl+], a                                   ; $4B50
    ld a, [de]                                    ; $4B51
    and $02                                       ; $4B52
    rrc a                                         ; $4B54
    rrc a                                         ; $4B56
    or [hl]                                       ; $4B58
    ld [hl+], a                                   ; $4B59
    ret                                           ; $4B5A


; C: copies 16 note bytes. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: copies the 16 note bytes, called by Dj_StoreTune_Far_TuneLoop
Dj_CopyNotes::
    ld b, $10                                     ; $4B5B

jr_002_4b5d:
    ld a, [de]                                    ; $4B5D
    ld [hl+], a                                   ; $4B5E
    inc de                                        ; $4B5F
    dec b                                         ; $4B60
    jr nz, jr_002_4b5d                            ; $4B61

    ret                                           ; $4B63


; C: packs four 2-bit stereo codes per byte. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB
; scenarios, core organic runs); C from the code: packs the stereo codes, called by Dj_StoreTune_Far_TuneLoop
Dj_PackStereoCodes::
    ld b, $04                                     ; $4B64

jr_002_4b66:
    ld a, [de]                                    ; $4B66
    inc de                                        ; $4B67
    and $03                                       ; $4B68
    rrc a                                         ; $4B6A
    rrc a                                         ; $4B6C
    ld c, a                                       ; $4B6E
    ld a, [de]                                    ; $4B6F
    inc de                                        ; $4B70
    and $03                                       ; $4B71
    swap a                                        ; $4B73
    or c                                          ; $4B75
    ld c, a                                       ; $4B76
    ld a, [de]                                    ; $4B77
    inc de                                        ; $4B78
    and $03                                       ; $4B79
    sla a                                         ; $4B7B
    sla a                                         ; $4B7D
    or c                                          ; $4B7F
    ld c, a                                       ; $4B80
    ld a, [de]                                    ; $4B81
    inc de                                        ; $4B82
    and $03                                       ; $4B83
    or c                                          ; $4B85
    ld [hl+], a                                   ; $4B86
    dec b                                         ; $4B87
    jr nz, jr_002_4b66                            ; $4B88

    ret                                           ; $4B8A


; C: packs 32 wave nibbles into 16 bytes. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios,
; core organic runs); C from the code: packs 32 wave nibbles into 16 bytes, called by Dj_StoreTune_Far_TuneLoop
Dj_PackWave::
    ld b, $10                                     ; $4B8B

jr_002_4b8d:
    ld a, [de]                                    ; $4B8D
    inc de                                        ; $4B8E
    and $0f                                       ; $4B8F
    swap a                                        ; $4B91
    ld c, a                                       ; $4B93
    ld a, [de]                                    ; $4B94
    inc de                                        ; $4B95
    and $0f                                       ; $4B96
    or c                                          ; $4B98
    ld [hl+], a                                   ; $4B99
    dec b                                         ; $4B9A
    jr nz, jr_002_4b8d                            ; $4B9B

    ret                                           ; $4B9D


; C: packs the noise pattern bits. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core
; organic runs); C from the code: packs 2 x 8 noise flags into 2 bytes, called by Dj_StoreTune_Far_TuneLoop
Dj_PackNoiseBits::
    ld b, $02                                     ; $4B9E

jr_002_4ba0:
    ld c, $08                                     ; $4BA0

jr_002_4ba2:
    ld a, [de]                                    ; $4BA2
    inc de                                        ; $4BA3
    swap a                                        ; $4BA4
    srl a                                         ; $4BA6
    rl [hl]                                       ; $4BA8
    dec c                                         ; $4BAA
    jr nz, jr_002_4ba2                            ; $4BAB

    inc hl                                        ; $4BAD
    dec b                                         ; $4BAE
    jr nz, jr_002_4ba0                            ; $4BAF

    ret                                           ; $4BB1


; C: stores the counters block DA96.. ($16 bytes) into both settings copies with checksum
Counters_Store_Far::
    push af                                       ; $4BB2
    ld a, $0a                                     ; $4BB3
    ld [rRAMG], a                                 ; $4BB5
    pop af                                        ; $4BB8
    xor a                                         ; $4BB9
    ld [rRAMB], a                                 ; $4BBA
    ld de, $0000                                  ; $4BBD
    ld b, $02                                     ; $4BC0

jr_002_4bc2:
    push bc                                       ; $4BC2
    push de                                       ; $4BC3
    ld hl, $b0bb                                  ; $4BC4
    add hl, de                                    ; $4BC7
    ld de, wCntTaken                              ; $4BC8
    ld c, $16                                     ; $4BCB

jr_002_4bcd:
    ld a, [de]                                    ; $4BCD
    ld [hl+], a                                   ; $4BCE
    inc de                                        ; $4BCF
    dec c                                         ; $4BD0
    jr nz, jr_002_4bcd                            ; $4BD1

    pop de                                        ; $4BD3
    push de                                       ; $4BD4
    ld hl, $b000                                  ; $4BD5
    add hl, de                                    ; $4BD8
    ld bc, $00d7                                  ; $4BD9
    call Sram_WriteChecksum                       ; $4BDC
    pop de                                        ; $4BDF
    pop bc                                        ; $4BE0
    ld a, e                                       ; $4BE1
    add $d9                                       ; $4BE2
    ld e, a                                       ; $4BE4
    jr nc, jr_002_4be8                            ; $4BE5

    inc d                                         ; $4BE7

jr_002_4be8:
    dec b                                         ; $4BE8
    jr nz, jr_002_4bc2                            ; $4BE9

    push af                                       ; $4BEB
    xor a                                         ; $4BEC
    ld [rRAMG], a                                 ; $4BED
    pop af                                        ; $4BF0
    jp Far_Call_Return                            ; $4BF1


; C: stores owner_id DA49.. ($12 bytes) into both owner block copies with checksum
Owner_Store_Far::
    push af                                       ; $4BF4
    ld a, $0a                                     ; $4BF5
    ld [rRAMG], a                                 ; $4BF7
    pop af                                        ; $4BFA
    ld a, $01                                     ; $4BFB
    ld [rRAMB], a                                 ; $4BFD
    ld de, $0000                                  ; $4C00
    ld b, $02                                     ; $4C03

jr_002_4c05:
    push bc                                       ; $4C05
    push de                                       ; $4C06
    ld hl, $afb8                                  ; $4C07
    add hl, de                                    ; $4C0A
    ld de, wOwnerId                               ; $4C0B
    ld c, $12                                     ; $4C0E

jr_002_4c10:
    ld a, [de]                                    ; $4C10
    ld [hl+], a                                   ; $4C11
    inc de                                        ; $4C12
    dec c                                         ; $4C13
    jr nz, jr_002_4c10                            ; $4C14

    pop de                                        ; $4C16
    push de                                       ; $4C17
    ld hl, $afb8                                  ; $4C18
    add hl, de                                    ; $4C1B
    ld bc, $0017                                  ; $4C1C
    call Sram_WriteChecksum                       ; $4C1F
    pop de                                        ; $4C22
    pop bc                                        ; $4C23
    ld a, e                                       ; $4C24
    add $19                                       ; $4C25
    ld e, a                                       ; $4C27
    jr nc, jr_002_4c2b                            ; $4C28

    inc d                                         ; $4C2A

jr_002_4c2b:
    dec b                                         ; $4C2B
    jr nz, jr_002_4c05                            ; $4C2C

    push af                                       ; $4C2E
    xor a                                         ; $4C2F
    ld [rRAMG], a                                 ; $4C30
    pop af                                        ; $4C33
    jp Far_Call_Return                            ; $4C34


; C: stores the $E00-byte Game Face image at B1FC and sets the flag B0D1
GameFace_Store_Far::
    push af                                       ; $4C37
    ld a, $0a                                     ; $4C38
    ld [rRAMG], a                                 ; $4C3A
    pop af                                        ; $4C3D
    xor a                                         ; $4C3E
    ld [rRAMB], a                                 ; $4C3F
    ld hl, $b1fc                                  ; $4C42
    ld de, wPhotoImage                            ; $4C45
    ld bc, $0e00                                  ; $4C48

jr_002_4c4b:
    ld a, [de]                                    ; $4C4B
    ld [hl+], a                                   ; $4C4C
    inc de                                        ; $4C4D
    dec bc                                        ; $4C4E
    ld a, c                                       ; $4C4F
    or b                                          ; $4C50
    jr nz, jr_002_4c4b                            ; $4C51

    ld de, $0000                                  ; $4C53
    ld b, $02                                     ; $4C56

jr_002_4c58:
    push bc                                       ; $4C58
    ld hl, $b0d1                                  ; $4C59
    add hl, de                                    ; $4C5C
    ld a, $01                                     ; $4C5D
    ld [hl], a                                    ; $4C5F
    push de                                       ; $4C60
    ld hl, $b000                                  ; $4C61
    add hl, de                                    ; $4C64
    ld bc, $00d7                                  ; $4C65
    call Sram_WriteChecksum                       ; $4C68
    pop de                                        ; $4C6B
    pop bc                                        ; $4C6C
    ld a, e                                       ; $4C6D
    add $d9                                       ; $4C6E
    ld e, a                                       ; $4C70
    jr nc, jr_002_4c74                            ; $4C71

    inc d                                         ; $4C73

jr_002_4c74:
    dec b                                         ; $4C74
    jr nz, jr_002_4c58                            ; $4C75

    push af                                       ; $4C77
    xor a                                         ; $4C78
    ld [rRAMG], a                                 ; $4C79
    pop af                                        ; $4C7C
    jp Far_Call_Return                            ; $4C7D


; I: A = photo number: copies its image to $C000; numbers >= $1E are built-in images from bank $36 / table 02:5218
Photo_LoadImage_Far::
    cp $1e                                        ; $4C80
    jr nc, jr_002_4cc7                            ; $4C82

    ld hl, wPhotoCount                            ; $4C84
    cp [hl]                                       ; $4C87
    jr nc, jr_002_4cb6                            ; $4C88

    ldh [hFarcallAArg], a                         ; $4C8A
    ld a, $02                                     ; $4C8C
    ld hl, Photo_FindSlot_Far                     ; $4C8E
    call Far_Call                                 ; $4C91
    srl a                                         ; $4C94
    inc a                                         ; $4C96
    ld [rRAMB], a                                 ; $4C97
    ld de, $0000                                  ; $4C9A
    rl d                                          ; $4C9D
    swap d                                        ; $4C9F
    ld hl, $a000                                  ; $4CA1
    add hl, de                                    ; $4CA4
    ld de, wPhotoImage                            ; $4CA5
    ld bc, $0fb8                                  ; $4CA8

jr_002_4cab:
    ld a, [hl+]                                   ; $4CAB
    ld [de], a                                    ; $4CAC
    inc de                                        ; $4CAD
    dec bc                                        ; $4CAE
    ld a, b                                       ; $4CAF
    or c                                          ; $4CB0
    jr nz, jr_002_4cab                            ; $4CB1

    jp Far_Call_Return                            ; $4CB3


jr_002_4cb6:
    farcopy Mem_CopyFromBank, AlbumB_UnusedSlotB_Tiles, wPhotoImage, $0fb8 ; $4CB6
    jp Far_Call_Return                            ; $4CC4


jr_002_4cc7:
    sub $1e                                       ; $4CC7
    cp $10                                        ; $4CC9
    jr c, jr_002_4ce3                             ; $4CCB

    call AlbumB_CheckGate                         ; $4CCD
    jr nz, jr_002_4ce3                            ; $4CD0

    ld a, $36                                     ; $4CD2
    ld hl, AlbumB_UnusedSlotA_Tiles               ; $4CD4
    ld de, wPhotoImage                            ; $4CD7
    ld bc, $0fb8                                  ; $4CDA
    call Mem_CopyFromBank                         ; $4CDD
    jp Far_Call_Return                            ; $4CE0


jr_002_4ce3:
    ld c, a                                       ; $4CE3
    sla a                                         ; $4CE4
    add c                                         ; $4CE6
    ld c, a                                       ; $4CE7
    ld b, $00                                     ; $4CE8
    ld hl, AlbumB_SlotTbl                         ; $4CEA
    add hl, bc                                    ; $4CED
    ld c, [hl]                                    ; $4CEE
    inc hl                                        ; $4CEF
    ld b, [hl]                                    ; $4CF0
    inc hl                                        ; $4CF1
    ld a, [hl]                                    ; $4CF2
    ld l, c                                       ; $4CF3
    ld h, b                                       ; $4CF4
    ld de, wPhotoImage                            ; $4CF5
    ld bc, $0fb8                                  ; $4CF8
    call Mem_CopyFromBank                         ; $4CFB
    jp Far_Call_Return                            ; $4CFE


; I: A = Album B photo id: tests the counter / score thresholds in a table; Z/NZ and the unlock bit mask
AlbumB_CheckGate::
    push de                                       ; $4D01
    push af                                       ; $4D02
    ldh [hFarcallAArg], a                         ; $4D03
    ld a, $02                                     ; $4D05
    ld hl, Counters_Load_Far                      ; $4D07
    call Far_Call                                 ; $4D0A
    ld de, $0000                                  ; $4D0D
    ld a, [wCntTaken + $1]                        ; $4D10
    and a                                         ; $4D13
    jr nz, jr_002_4d1d                            ; $4D14

    ld a, [wCntTaken]                             ; $4D16
    cp $60                                        ; $4D19
    jr c, jr_002_4d1f                             ; $4D1B

jr_002_4d1d:
    set 0, e                                      ; $4D1D

jr_002_4d1f:
    ld a, [wCntErased + $1]                       ; $4D1F
    and a                                         ; $4D22
    jr nz, jr_002_4d2c                            ; $4D23

    ld a, [wCntErased]                            ; $4D25
    cp $60                                        ; $4D28
    jr c, jr_002_4d2e                             ; $4D2A

jr_002_4d2c:
    set 1, e                                      ; $4D2C

jr_002_4d2e:
    ld a, [wCntSent + $1]                         ; $4D2E
    and a                                         ; $4D31
    jr nz, jr_002_4d3b                            ; $4D32

    ld a, [wCntSent]                              ; $4D34
    cp $15                                        ; $4D37
    jr c, jr_002_4d3d                             ; $4D39

jr_002_4d3b:
    set 2, e                                      ; $4D3B

jr_002_4d3d:
    ld a, [wCntRecvA]                             ; $4D3D
    cp $05                                        ; $4D40
    jr c, jr_002_4d46                             ; $4D42

    set 3, e                                      ; $4D44

jr_002_4d46:
    ld a, [wCntRecvB]                             ; $4D46
    cp $05                                        ; $4D49
    jr c, jr_002_4d4f                             ; $4D4B

    set 4, e                                      ; $4D4D

jr_002_4d4f:
    ld a, [wCntPrinted + $1]                      ; $4D4F
    and a                                         ; $4D52
    jr nz, jr_002_4d5c                            ; $4D53

    ld a, [wCntPrinted]                           ; $4D55
    cp $30                                        ; $4D58
    jr c, jr_002_4d5e                             ; $4D5A

jr_002_4d5c:
    set 5, e                                      ; $4D5C

jr_002_4d5e:
    ld a, [wBestShooter + $3]                     ; $4D5E
    ld hl, wBestShooter + $2                      ; $4D61
    or [hl]                                       ; $4D64
    jr nz, jr_002_4d76                            ; $4D65

    ld a, [wBestShooter + $1]                     ; $4D67
    cp $30                                        ; $4D6A
    jr c, jr_002_4d7c                             ; $4D6C

    cp $50                                        ; $4D6E
    jr c, jr_002_4d7a                             ; $4D70

    cp $70                                        ; $4D72
    jr c, jr_002_4d78                             ; $4D74

jr_002_4d76:
    set 0, d                                      ; $4D76

jr_002_4d78:
    set 7, e                                      ; $4D78

jr_002_4d7a:
    set 6, e                                      ; $4D7A

jr_002_4d7c:
    ld a, [wBestBall + $1]                        ; $4D7C
    cp $05                                        ; $4D7F
    jr c, jr_002_4d91                             ; $4D81

    cp $07                                        ; $4D83
    jr c, jr_002_4d8f                             ; $4D85

    cp $10                                        ; $4D87
    jr c, jr_002_4d8d                             ; $4D89

    set 3, d                                      ; $4D8B

jr_002_4d8d:
    set 2, d                                      ; $4D8D

jr_002_4d8f:
    set 1, d                                      ; $4D8F

jr_002_4d91:
    ld a, [wBestRun + $1]                         ; $4D91
    cp $82                                        ; $4D94
    jr c, jr_002_4da0                             ; $4D96

    cp $83                                        ; $4D98
    jr c, jr_002_4d9e                             ; $4D9A

    set 5, d                                      ; $4D9C

jr_002_4d9e:
    set 4, d                                      ; $4D9E

jr_002_4da0:
    pop af                                        ; $4DA0
    push af                                       ; $4DA1
    sub $10                                       ; $4DA2
    sla a                                         ; $4DA4
    ld c, a                                       ; $4DA6
    ld b, $00                                     ; $4DA7
    ld hl, AlbumB_CheckGate_Tbl4DB7               ; $4DA9
    add hl, bc                                    ; $4DAC
    ld a, [hl+]                                   ; $4DAD
    and e                                         ; $4DAE
    ld e, a                                       ; $4DAF
    ld a, [hl]                                    ; $4DB0
    and d                                         ; $4DB1
    or e                                          ; $4DB2
    pop bc                                        ; $4DB3
    ld a, b                                       ; $4DB4
    pop de                                        ; $4DB5
    ret                                           ; $4DB6


; I: auto: 8 bytes, bytes; referenced by AlbumB_CheckGate. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the
; organic corpus, modes 18 (tcrf_check/assets/l3_names/)
AlbumB_CheckGate_Tbl4DB7::
    db $01, $00, $02, $00, $04, $00, $08, $00

    db $10, $00, $20, $00, $40, $00, $80, $00, $00, $01, $00, $02, $00, $04, $00, $08
    db $00, $10, $00, $20, $00, $40, $00

    db $80

; C: hot-spot block of a photo (30 bytes) -> $D643
Photo_LoadHotspots_Far::
    cp $1e                                        ; $4DD7
    jr nc, jr_002_4e04                            ; $4DD9

    ldh [hFarcallAArg], a                         ; $4DDB
    ld a, $02                                     ; $4DDD
    ld hl, Photo_FindSlot_Far                     ; $4DDF
    call Far_Call                                 ; $4DE2
    srl a                                         ; $4DE5
    inc a                                         ; $4DE7
    ld [rRAMB], a                                 ; $4DE8
    ld de, $0000                                  ; $4DEB
    rl d                                          ; $4DEE
    swap d                                        ; $4DF0
    ld hl, $af36                                  ; $4DF2
    add hl, de                                    ; $4DF5
    ld de, wHotspotBlock                          ; $4DF6
    ld b, $1e                                     ; $4DF9

jr_002_4dfb:
    ld a, [hl+]                                   ; $4DFB
    ld [de], a                                    ; $4DFC
    inc de                                        ; $4DFD
    dec b                                         ; $4DFE
    jr nz, jr_002_4dfb                            ; $4DFF

    jp Far_Call_Return                            ; $4E01


jr_002_4e04:
    sub $1e                                       ; $4E04
    ld c, a                                       ; $4E06
    sla a                                         ; $4E07
    add c                                         ; $4E09
    ld c, a                                       ; $4E0A
    ld b, $00                                     ; $4E0B
    ld hl, AlbumB_SlotTbl                         ; $4E0D
    add hl, bc                                    ; $4E10
    ld c, [hl]                                    ; $4E11
    inc hl                                        ; $4E12
    ld b, [hl]                                    ; $4E13
    inc hl                                        ; $4E14
    ld a, [hl]                                    ; $4E15
    ld hl, $0f36                                  ; $4E16
    add hl, bc                                    ; $4E19
    ld de, wHotspotBlock                          ; $4E1A
    ld bc, $001e                                  ; $4E1D
    call Mem_CopyFromBank                         ; $4E20
    jp Far_Call_Return                            ; $4E23


; C: same
Photo_LoadHotspotsTranslated_Far::
    cp $1e                                        ; $4E26
    jr nc, jr_002_4e5e                            ; $4E28

    ldh [hFarcallAArg], a                         ; $4E2A
    ld a, $02                                     ; $4E2C
    ld hl, Photo_FindSlot_Far                     ; $4E2E
    call Far_Call                                 ; $4E31
    srl a                                         ; $4E34
    inc a                                         ; $4E36
    ld [rRAMB], a                                 ; $4E37
    ld de, $0000                                  ; $4E3A
    rl d                                          ; $4E3D
    swap d                                        ; $4E3F
    ld hl, $af36                                  ; $4E41
    add hl, de                                    ; $4E44
    ld de, wHotspotBlock                          ; $4E45
    ld b, $19                                     ; $4E48

jr_002_4e4a:
    ld a, [hl+]                                   ; $4E4A
    ld [de], a                                    ; $4E4B
    inc de                                        ; $4E4C
    dec b                                         ; $4E4D
    jr nz, jr_002_4e4a                            ; $4E4E

    ld b, $05                                     ; $4E50

jr_002_4e52:
    ld a, [hl+]                                   ; $4E52
    call Vec_GetPhotoVectorByte                   ; $4E53
    ld [de], a                                    ; $4E56
    inc de                                        ; $4E57
    dec b                                         ; $4E58
    jr nz, jr_002_4e52                            ; $4E59

    jp Far_Call_Return                            ; $4E5B


jr_002_4e5e:
    sub $1e                                       ; $4E5E
    ld c, a                                       ; $4E60
    sla a                                         ; $4E61
    add c                                         ; $4E63
    ld c, a                                       ; $4E64
    ld b, $00                                     ; $4E65
    ld hl, AlbumB_SlotTbl                         ; $4E67
    add hl, bc                                    ; $4E6A
    ld c, [hl]                                    ; $4E6B
    inc hl                                        ; $4E6C
    ld b, [hl]                                    ; $4E6D
    inc hl                                        ; $4E6E
    ld a, [hl]                                    ; $4E6F
    ld hl, $0f36                                  ; $4E70
    add hl, bc                                    ; $4E73
    ld de, wHotspotBlock                          ; $4E74
    ld bc, $001e                                  ; $4E77
    call Mem_CopyFromBank                         ; $4E7A
    jp Far_Call_Return                            ; $4E7D


; C: border number of a photo -> $D7C1 ($12 for built-in images)
Photo_LoadBorder_Far::
    cp $1e                                        ; $4E80
    jr nc, jr_002_4ea6                            ; $4E82

    ldh [hFarcallAArg], a                         ; $4E84
    ld a, $02                                     ; $4E86
    ld hl, Photo_FindSlot_Far                     ; $4E88
    call Far_Call                                 ; $4E8B
    srl a                                         ; $4E8E
    inc a                                         ; $4E90
    ld [rRAMB], a                                 ; $4E91
    ld de, $0000                                  ; $4E94
    rl d                                          ; $4E97
    swap d                                        ; $4E99
    ld hl, $af54                                  ; $4E9B
    add hl, de                                    ; $4E9E
    ld a, [hl]                                    ; $4E9F
    ld [wBorderNumber], a                         ; $4EA0
    jp Far_Call_Return                            ; $4EA3


jr_002_4ea6:
    ld a, $12                                     ; $4EA6
    ld [wBorderNumber], a                         ; $4EA8
    jp Far_Call_Return                            ; $4EAB


; C: $36 tag fields of a photo -> tag_owner_id $DA5B
Photo_LoadTagFields_Far::
    cp $1e                                        ; $4EAE
    jr nc, jr_002_4edb                            ; $4EB0

    ldh [hFarcallAArg], a                         ; $4EB2
    ld a, $02                                     ; $4EB4
    ld hl, Photo_FindSlot_Far                     ; $4EB6
    call Far_Call                                 ; $4EB9
    srl a                                         ; $4EBC
    inc a                                         ; $4EBE
    ld [rRAMB], a                                 ; $4EBF
    ld de, $0000                                  ; $4EC2
    rl d                                          ; $4EC5
    swap d                                        ; $4EC7
    ld hl, $af00                                  ; $4EC9
    add hl, de                                    ; $4ECC
    ld de, wTagOwnerId                            ; $4ECD
    ld b, $36                                     ; $4ED0

jr_002_4ed2:
    ld a, [hl+]                                   ; $4ED2
    ld [de], a                                    ; $4ED3
    inc de                                        ; $4ED4
    dec b                                         ; $4ED5
    jr nz, jr_002_4ed2                            ; $4ED6

    jp Far_Call_Return                            ; $4ED8


jr_002_4edb:
    sub $1e                                       ; $4EDB
    ld c, a                                       ; $4EDD
    sla a                                         ; $4EDE
    add c                                         ; $4EE0
    ld c, a                                       ; $4EE1
    ld b, $00                                     ; $4EE2
    ld hl, AlbumB_SlotTbl                         ; $4EE4
    add hl, bc                                    ; $4EE7
    ld c, [hl]                                    ; $4EE8
    inc hl                                        ; $4EE9
    ld b, [hl]                                    ; $4EEA
    inc hl                                        ; $4EEB
    ld a, [hl]                                    ; $4EEC
    ld hl, $0f00                                  ; $4EED
    add hl, bc                                    ; $4EF0
    ld de, wTagOwnerId                            ; $4EF1
    ld bc, $0036                                  ; $4EF4
    call Mem_CopyFromBank                         ; $4EF7
    jp Far_Call_Return                            ; $4EFA


; C: animation list / timing / speed / border from the settings block -> $D681..
Settings_LoadAnim_Far::
    xor a                                         ; $4EFD
    ld [rRAMB], a                                 ; $4EFE
    ld hl, $b000                                  ; $4F01
    ld de, wAnimList                              ; $4F04
    ld c, $30                                     ; $4F07

jr_002_4f09:
    ld a, [hl+]                                   ; $4F09
    ld [de], a                                    ; $4F0A
    inc de                                        ; $4F0B
    dec c                                         ; $4F0C
    jr nz, jr_002_4f09                            ; $4F0D

    xor a                                         ; $4F0F
    ld [wAnimListGuard], a                        ; $4F10
    ld hl, $b030                                  ; $4F13
    ld de, wAnimTiming                            ; $4F16
    ld c, $2f                                     ; $4F19

jr_002_4f1b:
    ld a, [hl+]                                   ; $4F1B
    ld [de], a                                    ; $4F1C
    inc de                                        ; $4F1D
    dec c                                         ; $4F1E
    jr nz, jr_002_4f1b                            ; $4F1F

    ld a, $ff                                     ; $4F21
    ld [wAnimTimingGuardLo], a                    ; $4F23
    ld [wAnimTimingGuardHi], a                    ; $4F26
    ld hl, $b05f                                  ; $4F29
    ld a, [hl+]                                   ; $4F2C
    ld [wAnimSpeed], a                            ; $4F2D
    ld a, [hl]                                    ; $4F30
    ld [wAnimBorder], a                           ; $4F31
    jp Far_Call_Return                            ; $4F34


; C: same with the list entries translated slot -> photo number
Settings_LoadAnimTranslated_Far::
    xor a                                         ; $4F37
    ld [rRAMB], a                                 ; $4F38
    ld hl, $b000                                  ; $4F3B
    ld de, wAnimList                              ; $4F3E
    ld c, $2f                                     ; $4F41

jr_002_4f43:
    ld a, [hl+]                                   ; $4F43
    call Vec_GetPhotoVectorByte                   ; $4F44
    ld [de], a                                    ; $4F47
    inc de                                        ; $4F48
    dec c                                         ; $4F49
    jr nz, jr_002_4f43                            ; $4F4A

    ld a, [hl]                                    ; $4F4C
    ld [de], a                                    ; $4F4D
    xor a                                         ; $4F4E
    ld [wAnimListGuard], a                        ; $4F4F
    ld hl, $b030                                  ; $4F52
    ld de, wAnimTiming                            ; $4F55
    ld c, $2f                                     ; $4F58

jr_002_4f5a:
    ld a, [hl+]                                   ; $4F5A
    ld [de], a                                    ; $4F5B
    inc de                                        ; $4F5C
    dec c                                         ; $4F5D
    jr nz, jr_002_4f5a                            ; $4F5E

    ld a, $ff                                     ; $4F60
    ld [wAnimTimingGuardLo], a                    ; $4F62
    ld [wAnimTimingGuardHi], a                    ; $4F65
    ld hl, $b05f                                  ; $4F68
    ld a, [hl+]                                   ; $4F6B
    ld [wAnimSpeed], a                            ; $4F6C
    ld a, [hl]                                    ; $4F6F
    ld [wAnimBorder], a                           ; $4F70
    jp Far_Call_Return                            ; $4F73


; C: HL = DE then loads the D.J. tune. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz)
Dj_LoadTune_FromDE_Far::
    ld h, d                                       ; $4F76
    ld l, e                                       ; $4F77
    jr jr_002_4f81                                ; $4F78

; C: unpacks the D.J. tune from the settings block B061.. into $D93D..
Dj_LoadTune_Far::
    xor a                                         ; $4F7A
    ld [rRAMB], a                                 ; $4F7B
    ld hl, $b061                                  ; $4F7E

jr_002_4f81:
    ld de, wSound1DutyLen                         ; $4F81
    call Dj_UnpackDutyLength                      ; $4F84
    ld de, wSound1Envelope                        ; $4F87
    call Dj_UnpackEnvelope                        ; $4F8A
    ld de, wSound1Modulation                      ; $4F8D
    call Dj_UnpackModulation                      ; $4F90
    ld de, wSound1Notes                           ; $4F93
    call Dj_CopyNotesOut                          ; $4F96
    ld de, wSound1Stereo                          ; $4F99
    call Dj_UnpackStereoCodes                     ; $4F9C
    ld de, wSound2UserWave                        ; $4F9F
    call Dj_UnpackWave                            ; $4FA2
    ld de, wSound2WaveLen                         ; $4FA5
    call Dj_UnpackDutyLength                      ; $4FA8
    ld de, wSound2Modulation                      ; $4FAB
    call Dj_UnpackModulation                      ; $4FAE
    ld de, wSound2Notes                           ; $4FB1
    call Dj_CopyNotesOut                          ; $4FB4
    ld de, wSound2Stereo                          ; $4FB7
    call Dj_UnpackStereoCodes                     ; $4FBA
    ld de, wLoopLengths                           ; $4FBD
    ld a, [hl]                                    ; $4FC0
    and $f0                                       ; $4FC1
    swap a                                        ; $4FC3
    inc a                                         ; $4FC5
    ld [de], a                                    ; $4FC6
    inc de                                        ; $4FC7
    ld a, [hl+]                                   ; $4FC8
    and $0f                                       ; $4FC9
    inc a                                         ; $4FCB
    ld [de], a                                    ; $4FCC
    ld de, wNoiseEnvelope                         ; $4FCD
    call Dj_UnpackEnvelope                        ; $4FD0
    ld de, wNoiseGateLoop                         ; $4FD3
    ld a, [hl]                                    ; $4FD6
    and $f0                                       ; $4FD7
    swap a                                        ; $4FD9
    ld [de], a                                    ; $4FDB
    inc de                                        ; $4FDC
    ld a, [hl+]                                   ; $4FDD
    and $0f                                       ; $4FDE
    inc a                                         ; $4FE0
    ld [de], a                                    ; $4FE1
    ld de, wNoiseNotes                            ; $4FE2
    call Dj_CopyNotesOut                          ; $4FE5
    ld de, wNoiseStereoWidth                      ; $4FE8
    call Dj_UnpackStereoCodes                     ; $4FEB
    ld de, wNoiseStereoWidth                      ; $4FEE
    call Dj_UnpackNoiseBits                       ; $4FF1
    ld a, [hl+]                                   ; $4FF4
    ld [wTempo], a                                ; $4FF5
    ld a, [hl]                                    ; $4FF8
    ld [wSavedTunePresent], a                     ; $4FF9
    jp Far_Call_Return                            ; $4FFC


; C: inverse of 4B1E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackDutyLength::
    ld a, [hl]                                    ; $4FFF
    and $30                                       ; $5000
    swap a                                        ; $5002
    ld [de], a                                    ; $5004
    inc de                                        ; $5005
    ld a, [hl+]                                   ; $5006
    and $0f                                       ; $5007
    ld [de], a                                    ; $5009
    ret                                           ; $500A


; C: inverse of 4B2B. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackEnvelope::
    ld a, [hl]                                    ; $500B
    and $80                                       ; $500C
    rlc a                                         ; $500E
    ld [de], a                                    ; $5010
    inc de                                        ; $5011
    ld a, [hl]                                    ; $5012
    and $70                                       ; $5013
    swap a                                        ; $5015
    ld [de], a                                    ; $5017
    inc de                                        ; $5018
    ld a, [hl+]                                   ; $5019
    and $0f                                       ; $501A
    ld [de], a                                    ; $501C
    ret                                           ; $501D


; C: inverse of 4B40. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackModulation::
    ld a, [hl+]                                   ; $501E
    and $7f                                       ; $501F
    ld [de], a                                    ; $5021
    inc de                                        ; $5022
    ld a, [hl-]                                   ; $5023
    and $7f                                       ; $5024
    ld [de], a                                    ; $5026
    inc de                                        ; $5027
    ld a, [hl+]                                   ; $5028
    and $80                                       ; $5029
    rlc a                                         ; $502B
    ld c, a                                       ; $502D
    ld a, [hl+]                                   ; $502E
    and $80                                       ; $502F
    rlc a                                         ; $5031
    rlc a                                         ; $5033
    or c                                          ; $5035
    ld [de], a                                    ; $5036
    ret                                           ; $5037


; C: copies 16 note bytes. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz)
Dj_CopyNotesOut::
    ld b, $10                                     ; $5038

jr_002_503a:
    ld a, [hl+]                                   ; $503A
    ld [de], a                                    ; $503B
    inc de                                        ; $503C
    dec b                                         ; $503D
    jr nz, jr_002_503a                            ; $503E

    ret                                           ; $5040


; C: inverse of 4B64. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackStereoCodes::
    ld b, $04                                     ; $5041

jr_002_5043:
    ld a, [hl]                                    ; $5043
    and $c0                                       ; $5044
    rlc a                                         ; $5046
    rlc a                                         ; $5048
    ld [de], a                                    ; $504A
    inc de                                        ; $504B
    ld a, [hl]                                    ; $504C
    and $30                                       ; $504D
    swap a                                        ; $504F
    ld [de], a                                    ; $5051
    inc de                                        ; $5052
    ld a, [hl]                                    ; $5053
    and $0c                                       ; $5054
    srl a                                         ; $5056
    srl a                                         ; $5058
    ld [de], a                                    ; $505A
    inc de                                        ; $505B
    ld a, [hl+]                                   ; $505C
    and $03                                       ; $505D
    ld [de], a                                    ; $505F
    inc de                                        ; $5060
    dec b                                         ; $5061
    jr nz, jr_002_5043                            ; $5062

    ret                                           ; $5064


; C: inverse of 4B8B. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackWave::
    ld b, $10                                     ; $5065

jr_002_5067:
    ld a, [hl]                                    ; $5067
    and $f0                                       ; $5068
    swap a                                        ; $506A
    ld [de], a                                    ; $506C
    inc de                                        ; $506D
    ld a, [hl+]                                   ; $506E
    and $0f                                       ; $506F
    ld [de], a                                    ; $5071
    inc de                                        ; $5072
    dec b                                         ; $5073
    jr nz, jr_002_5067                            ; $5074

    ret                                           ; $5076


; C: inverse of 4B9E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackNoiseBits::
    ld b, $02                                     ; $5077

jr_002_5079:
    ld a, [hl+]                                   ; $5079
    ld c, $08                                     ; $507A

jr_002_507c:
    sla a                                         ; $507C
    push af                                       ; $507E
    ld a, [de]                                    ; $507F
    jr nc, jr_002_5084                            ; $5080

    set 4, a                                      ; $5082

jr_002_5084:
    ld [de], a                                    ; $5084
    inc de                                        ; $5085
    pop af                                        ; $5086
    dec c                                         ; $5087
    jr nz, jr_002_507c                            ; $5088

    dec b                                         ; $508A
    jr nz, jr_002_5079                            ; $508B

    ret                                           ; $508D


; C: counters block B0BB.. -> DA96..
Counters_Load_Far::
    xor a                                         ; $508E
    ld [rRAMB], a                                 ; $508F
    ld hl, $b0bb                                  ; $5092
    ld de, wCntTaken                              ; $5095
    ld c, $16                                     ; $5098

jr_002_509a:
    ld a, [hl+]                                   ; $509A
    ld [de], a                                    ; $509B
    inc de                                        ; $509C
    dec c                                         ; $509D
    jr nz, jr_002_509a                            ; $509E

    jp Far_Call_Return                            ; $50A0


; C: owner block AFB8.. -> owner_id DA49..
Owner_Load_Far::
    ld a, $01                                     ; $50A3
    ld [rRAMB], a                                 ; $50A5
    ld hl, $afb8                                  ; $50A8
    ld de, wOwnerId                               ; $50AB
    ld c, $12                                     ; $50AE

jr_002_50b0:
    ld a, [hl+]                                   ; $50B0
    ld [de], a                                    ; $50B1
    inc de                                        ; $50B2
    dec c                                         ; $50B3
    jr nz, jr_002_50b0                            ; $50B4

    jp Far_Call_Return                            ; $50B6


; C: reads the Game Face flag B0D1 into gameface_present and loads the image to $C000
GameFace_Load_Far::
    xor a                                         ; $50B9
    ld [rRAMB], a                                 ; $50BA
    ld a, [$b0d1]                                 ; $50BD
    ld [wGamefacePresent], a                      ; $50C0
    and a                                         ; $50C3
    jp z, Far_Call_Return                         ; $50C4

    ld hl, $b1fc                                  ; $50C7
    ld de, wPhotoImage                            ; $50CA
    ld bc, $0e00                                  ; $50CD

jr_002_50d0:
    ld a, [hl+]                                   ; $50D0
    ld [de], a                                    ; $50D1
    inc de                                        ; $50D2
    dec bc                                        ; $50D3
    ld a, c                                       ; $50D4
    or b                                          ; $50D5
    jr nz, jr_002_50d0                            ; $50D6

    jp Far_Call_Return                            ; $50D8


; C: loads the Game Face image in four 7x128 byte chunks
GameFace_LoadTiles_Far::
    xor a                                         ; $50DB
    ld [rRAMB], a                                 ; $50DC
    ld a, [$b0d1]                                 ; $50DF
    ld [wGamefacePresent], a                      ; $50E2
    and a                                         ; $50E5
    jp z, Far_Call_Return                         ; $50E6

    ld de, wPhotoImage                            ; $50E9
    ld hl, $b1fc                                  ; $50EC
    call GameFace_CopyChunk                       ; $50EF
    ld hl, $b27c                                  ; $50F2
    call GameFace_CopyChunk                       ; $50F5
    ld hl, $b8fc                                  ; $50F8
    call GameFace_CopyChunk                       ; $50FB
    ld hl, $b97c                                  ; $50FE
    call GameFace_CopyChunk                       ; $5101
    jp Far_Call_Return                            ; $5104


; C: copies 7 rows of 128 bytes with a 128 byte skip. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed
; in the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
GameFace_CopyChunk::
    ld b, $07                                     ; $5107

jr_002_5109:
    ld c, $80                                     ; $5109

jr_002_510b:
    ld a, [hl+]                                   ; $510B
    ld [de], a                                    ; $510C
    inc de                                        ; $510D
    dec c                                         ; $510E
    jr nz, jr_002_510b                            ; $510F

    ld a, l                                       ; $5111
    add $80                                       ; $5112
    ld l, a                                       ; $5114
    jr nc, jr_002_5118                            ; $5115

    inc h                                         ; $5117

jr_002_5118:
    dec b                                         ; $5118
    jr nz, jr_002_5109                            ; $5119

    ret                                           ; $511B


; C: loads the eight thumbnails of a page (AE00 area of the slots). L3 pass 2026-10-26: executed in BGB in the
; scenarios link_exchange 0E:03 (tcrf_check/assets/l3_names/scen_hits*.csv)
Album_LoadThumbPage_Far::
    and $18                                       ; $511C
    ld c, a                                       ; $511E
    ld de, wPhotoImage                            ; $511F
    ld b, $08                                     ; $5122

jr_002_5124:
    push bc                                       ; $5124
    push de                                       ; $5125
    ld a, c                                       ; $5126
    ldh [hFarcallAArg], a                         ; $5127
    ld a, $02                                     ; $5129
    ld hl, Photo_FindSlot_Far                     ; $512B
    call Far_Call                                 ; $512E
    jr nc, jr_002_5134                            ; $5131

    xor a                                         ; $5133

jr_002_5134:
    srl a                                         ; $5134
    inc a                                         ; $5136
    ld [rRAMB], a                                 ; $5137
    ld de, $0000                                  ; $513A
    rl d                                          ; $513D
    swap d                                        ; $513F
    ld hl, $ae00                                  ; $5141
    add hl, de                                    ; $5144
    pop de                                        ; $5145
    ld b, $40                                     ; $5146

jr_002_5148:
    ld a, [hl+]                                   ; $5148
    ld [de], a                                    ; $5149
    inc de                                        ; $514A
    ld a, [hl+]                                   ; $514B
    ld [de], a                                    ; $514C
    inc de                                        ; $514D
    ld a, [hl+]                                   ; $514E
    ld [de], a                                    ; $514F
    inc de                                        ; $5150
    ld a, [hl+]                                   ; $5151
    ld [de], a                                    ; $5152
    inc de                                        ; $5153
    dec b                                         ; $5154
    jr nz, jr_002_5148                            ; $5155

    pop bc                                        ; $5157
    inc c                                         ; $5158
    dec b                                         ; $5159
    jr nz, jr_002_5124                            ; $515A

    jp Far_Call_Return                            ; $515C


; C: loads a photo image and copies its tiles to VRAM (safe copy when the LCD is on)
Photo_LoadToVram_Far::
    ldh [hFarcallAArg], a                         ; $515F
    ld a, $02                                     ; $5161
    ld hl, Photo_LoadImage_Far                    ; $5163
    call Far_Call                                 ; $5166
    ld hl, $ff40                                  ; $5169
    bit 7, [hl]                                   ; $516C
    jr nz, jr_002_519d                            ; $516E

    ld a, $00                                     ; $5170
    ld hl, wPhotoImage                            ; $5172
    ld de, $9000                                  ; $5175
    ld bc, $0800                                  ; $5178
    call Mem_CopyFromBank                         ; $517B
    ld a, $00                                     ; $517E
    ld hl, wPhotoImage + $800                     ; $5180
    ld de, $8800                                  ; $5183
    ld bc, $0100                                  ; $5186
    call Mem_CopyFromBank                         ; $5189
    ld a, $00                                     ; $518C
    ld hl, wPhotoImage + $900                     ; $518E
    ld de, $8000                                  ; $5191
    ld bc, $0500                                  ; $5194
    call Mem_CopyFromBank                         ; $5197
    jp Far_Call_Return                            ; $519A


jr_002_519d:
    ld a, $00                                     ; $519D
    ld hl, wPhotoImage                            ; $519F
    ld de, $9000                                  ; $51A2
    ld bc, $0800                                  ; $51A5
    call Vram_CopyFromBank                        ; $51A8
    ld a, $00                                     ; $51AB
    ld hl, wPhotoImage + $800                     ; $51AD
    ld de, $8800                                  ; $51B0
    ld bc, $0100                                  ; $51B3
    call Vram_CopyFromBank                        ; $51B6
    ld a, $00                                     ; $51B9
    ld hl, wPhotoImage + $900                     ; $51BB
    ld de, $8000                                  ; $51BE
    ld bc, $0500                                  ; $51C1
    call Vram_CopyFromBank                        ; $51C4
    jp Far_Call_Return                            ; $51C7


; I: A = photo number; returns the SRAM bank / address of its image (bank $36 for built-in images)
Photo_GetSramAddress_Far::
    cp $1e                                        ; $51CA
    jr nc, jr_002_51f4                            ; $51CC

    ld hl, wPhotoCount                            ; $51CE
    cp [hl]                                       ; $51D1
    jr nc, jr_002_51ec                            ; $51D2

    ldh [hFarcallAArg], a                         ; $51D4
    ld a, $02                                     ; $51D6
    ld hl, Photo_FindSlot_Far                     ; $51D8
    call Far_Call                                 ; $51DB
    srl a                                         ; $51DE
    inc a                                         ; $51E0
    ld bc, $0500                                  ; $51E1
    rl b                                          ; $51E4
    swap b                                        ; $51E6
    and a                                         ; $51E8
    jp Far_Call_Return                            ; $51E9


jr_002_51ec:
    ld bc, AlbumB_UnusedSlotB_Tiles               ; $51EC
    ld a, BANK(AlbumB_UnusedSlotB_Tiles)          ; $51EF
    jp Far_Call_Return                            ; $51F1


jr_002_51f4:
    sub $1e                                       ; $51F4
    cp $10                                        ; $51F6
    jr c, jr_002_5207                             ; $51F8

    call AlbumB_CheckGate                         ; $51FA
    jr nz, jr_002_5207                            ; $51FD

    ld bc, AlbumB_UnusedSlotA_Tiles               ; $51FF
    ld a, BANK(AlbumB_UnusedSlotA_Tiles)          ; $5202
    jp Far_Call_Return                            ; $5204


jr_002_5207:
    ld c, a                                       ; $5207
    sla a                                         ; $5208
    add c                                         ; $520A
    ld c, a                                       ; $520B
    ld b, $00                                     ; $520C
    ld hl, AlbumB_SlotTbl                         ; $520E
    add hl, bc                                    ; $5211
    ld c, [hl]                                    ; $5212
    inc hl                                        ; $5213
    ld b, [hl]                                    ; $5214
    inc hl                                        ; $5215
    ld a, [hl]                                    ; $5216
    and a                                         ; $5217
    jp Far_Call_Return                            ; $5218


; C: if the owner id is all zero fills it with random BCD digits and stores the owner block
Owner_GenerateId_Far::
    ldh [hFarcallAArg], a                         ; $521B
    ld a, $02                                     ; $521D
    ld hl, Owner_Load_Far                         ; $521F
    call Far_Call                                 ; $5222
    xor a                                         ; $5225
    ld hl, wOwnerId                               ; $5226
    ld b, $04                                     ; $5229

jr_002_522b:
    or [hl]                                       ; $522B
    inc hl                                        ; $522C
    dec b                                         ; $522D
    jr nz, jr_002_522b                            ; $522E

    and a                                         ; $5230
    jp nz, Far_Call_Return                        ; $5231

    ld hl, wOwnerId                               ; $5234
    ld bc, $0800                                  ; $5237

jr_002_523a:
    call Rng_Next                                 ; $523A
    and $0f                                       ; $523D
    add c                                         ; $523F

jr_002_5240:
    cp $0a                                        ; $5240
    jr c, jr_002_5248                             ; $5242

    sub $0a                                       ; $5244
    jr jr_002_5240                                ; $5246

jr_002_5248:
    ld c, a                                       ; $5248
    inc a                                         ; $5249
    swap [hl]                                     ; $524A
    or [hl]                                       ; $524C
    ld [hl], a                                    ; $524D
    bit 0, b                                      ; $524E
    jr z, jr_002_5253                             ; $5250

    inc hl                                        ; $5252

jr_002_5253:
    dec b                                         ; $5253
    jr nz, jr_002_523a                            ; $5254

    ldh [hFarcallAArg], a                         ; $5256
    ld a, $02                                     ; $5258
    ld hl, Owner_Store_Far                        ; $525A
    call Far_Call                                 ; $525D
    jp Far_Call_Return                            ; $5260


; C: 30 entries of 3 bytes {address lo; hi; bank}: the 30 pictures of album B (bank $36 $6000 ... bank $3D $7000; one
; per $1000)
AlbumB_SlotTbl::
    dwb AlbumB_Photo01_Tiles
    dwb AlbumB_Photo02_Tiles
    dwb AlbumB_Photo03_Tiles
    dwb AlbumB_Photo04_Tiles
    dwb AlbumB_Photo05_Tiles
    dwb AlbumB_Photo06_Tiles
    dwb AlbumB_Photo07_Tiles
    db $00, $50, $38
    db $00, $60, $38
    db $00, $70, $38
    dwb AlbumB_Photo11_Tiles
    dwb AlbumB_Photo14_Tiles
    db $00, $60, $39
    db $00, $70, $39
    dwb AlbumB_Photo15_Tiles
    dwb AlbumB_Photo16_Tiles
    dwb AlbumB_Photo17_Tiles
    dwb AlbumB_Photo18_Tiles
    dwb AlbumB_Photo19_Tiles
    dwb AlbumB_Photo20_Tiles
    dwb AlbumB_Photo21_Tiles
    dwb AlbumB_Photo22_Tiles
    dwb AlbumB_Photo23_Tiles
    dwb AlbumB_Photo24_Tiles
    dwb AlbumB_Photo25_Tiles
    dwb AlbumB_Photo26_Tiles
    dwb AlbumB_Photo27_Tiles
    dwb AlbumB_Photo28_Tiles
    dwb AlbumB_Photo29_Tiles
    dwb AlbumB_Photo30_Tiles

; I: 203 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B02_5272 (00:247D)
OamPtrTbl_B02_52BD::
    dw OamList_B02_52BD_00
    dw OamList_B02_52BD_01
    dw OamList_B02_52BD_02
    dw OamList_B02_52BD_03
    dw OamList_B02_52BD_04
    dw OamList_B02_52BD_05
    dw OamList_B02_52BD_06
    dw OamList_B02_52BD_07
    dw OamList_B02_52BD_08
    dw OamList_B02_52BD_09
    dw OamList_B02_52BD_0A
    dw OamList_B02_52BD_0B
    dw OamList_B02_52BD_0C
    dw OamList_B02_52BD_0D
    dw OamList_B02_52BD_0E
    dw OamList_B02_52BD_0F
    dw OamList_B02_52BD_10
    dw OamList_B02_52BD_11
    dw OamList_B02_52BD_12
    dw OamList_B02_52BD_13
    dw OamList_B02_52BD_14
    dw OamList_B02_52BD_15
    dw OamList_B02_52BD_16
    dw OamList_B02_52BD_17
    dw OamList_B02_52BD_18
    dw OamList_B02_52BD_19
    dw OamList_B02_52BD_1A
    dw OamList_B02_52BD_1B
    dw OamList_B02_52BD_1C
    dw OamList_B02_52BD_1D
    dw OamList_B02_52BD_1E
    dw OamList_B02_52BD_1F
    dw OamList_B02_52BD_20
    dw OamList_B02_52BD_21
    dw OamList_B02_52BD_22
    dw OamList_B02_52BD_23
    dw OamList_B02_52BD_24
    dw OamList_B02_52BD_25
    dw OamList_B02_52BD_26
    dw OamList_B02_52BD_27
    dw OamList_B02_52BD_28
    dw OamList_B02_52BD_29
    dw OamList_B02_52BD_2A
    dw OamList_B02_52BD_2B
    dw OamList_B02_52BD_2C
    dw OamList_B02_52BD_2D
    dw OamList_B02_52BD_2E
    dw OamList_B02_52BD_2F
    dw OamList_B02_52BD_30
    dw OamList_B02_52BD_31
    dw OamList_B02_52BD_32
    dw OamList_B02_52BD_33
    dw OamList_B02_52BD_34
    dw OamList_B02_52BD_35
    dw OamList_B02_52BD_36
    dw OamList_B02_52BD_37
    dw OamList_B02_52BD_38
    dw OamList_B02_52BD_39
    dw OamList_B02_52BD_3A
    dw OamList_B02_52BD_3B
    dw OamList_B02_52BD_3C
    dw OamList_B02_52BD_3D
    dw OamList_B02_52BD_3E
    dw OamList_B02_52BD_3F
    dw OamList_B02_52BD_40
    dw OamList_B02_52BD_41
    dw OamList_B02_52BD_42
    dw OamList_B02_52BD_43
    dw OamList_B02_52BD_44
    dw OamList_B02_52BD_45
    dw OamList_B02_52BD_46
    dw OamList_B02_52BD_47
    dw OamList_B02_52BD_48
    dw OamList_B02_52BD_49
    dw OamList_B02_52BD_4A
    dw OamList_B02_52BD_4B
    dw OamList_B02_52BD_4C
    dw OamList_B02_52BD_4D
    dw OamList_B02_52BD_4E
    dw OamList_B02_52BD_4F
    dw OamList_B02_52BD_50
    dw OamList_B02_52BD_51
    dw OamList_B02_52BD_52
    dw OamList_B02_52BD_53
    dw OamList_B02_52BD_54
    dw OamList_B02_52BD_55
    dw OamList_B02_52BD_56
    dw OamList_B02_52BD_57
    dw OamList_B02_52BD_58
    dw OamList_B02_52BD_59
    dw OamList_B02_52BD_5A
    dw OamList_B02_52BD_5B
    dw OamList_B02_52BD_5C
    dw OamList_B02_52BD_5D
    dw OamList_B02_52BD_5E
    dw OamList_B02_52BD_5F
    dw OamList_B02_52BD_60
    dw OamList_B02_52BD_61
    dw OamList_B02_52BD_62
    dw OamList_B02_52BD_63
    dw OamList_B02_52BD_64
    dw OamList_B02_52BD_65
    dw OamList_B02_52BD_66
    dw OamList_B02_52BD_67
    dw OamList_B02_52BD_68
    dw OamList_B02_52BD_69
    dw OamList_B02_52BD_6A
    dw OamList_B02_52BD_6B
    dw OamList_B02_52BD_6C
    dw OamList_B02_52BD_6D
    dw OamList_B02_52BD_6E
    dw OamList_B02_52BD_6F
    dw OamList_B02_52BD_70
    dw OamList_B02_52BD_71
    dw OamList_B02_52BD_72
    dw OamList_B02_52BD_73
    dw OamList_B02_52BD_74
    dw OamList_B02_52BD_75
    dw OamList_B02_52BD_76
    dw OamList_B02_52BD_77
    dw OamList_B02_52BD_78
    dw OamList_B02_52BD_79
    dw OamList_B02_52BD_7A
    dw OamList_B02_52BD_7B
    dw OamList_B02_52BD_7C
    dw OamList_B02_52BD_7D
    dw OamList_B02_52BD_7E
    dw OamList_B02_52BD_7F
    dw OamList_B02_52BD_80
    dw OamList_B02_52BD_81
    dw OamList_B02_52BD_82
    dw OamList_B02_52BD_83
    dw OamList_B02_52BD_84
    dw OamList_B02_52BD_85
    dw OamList_B02_52BD_86
    dw OamList_B02_52BD_87
    dw OamList_B02_52BD_88
    dw OamList_B02_52BD_89
    dw OamList_B02_52BD_8A
    dw OamList_B02_52BD_8B
    dw OamList_B02_52BD_8C
    dw OamList_B02_52BD_8D
    dw OamList_B02_52BD_8E
    dw OamList_B02_52BD_8F
    dw OamList_B02_52BD_90
    dw OamList_B02_52BD_91
    dw OamList_B02_52BD_92
    dw OamList_B02_52BD_93
    dw OamList_B02_52BD_94
    dw OamList_B02_52BD_95
    dw OamList_B02_52BD_96
    dw OamList_B02_52BD_97
    dw OamList_B02_52BD_98
    dw OamList_B02_52BD_99
    dw OamList_B02_52BD_9A
    dw OamList_B02_52BD_9B
    dw OamList_B02_52BD_9C
    dw OamList_B02_52BD_9D
    dw OamList_B02_52BD_9E
    dw OamList_B02_52BD_9F
    dw OamList_B02_52BD_A0
    dw OamList_B02_52BD_A1
    dw OamList_B02_52BD_A2
    dw OamList_B02_52BD_A3
    dw OamList_B02_52BD_A4
    dw OamList_B02_52BD_A5
    dw OamList_B02_52BD_A6
    dw OamList_B02_52BD_A7
    dw OamList_B02_52BD_A8
    dw OamList_B02_52BD_A9
    dw OamList_B02_52BD_AA
    dw OamList_B02_52BD_AB
    dw OamList_B02_52BD_AC
    dw OamList_B02_52BD_AD
    dw OamList_B02_52BD_AE
    dw OamList_B02_52BD_AF
    dw OamList_B02_52BD_B0
    dw OamList_B02_52BD_B1
    dw OamList_B02_52BD_B2
    dw OamList_B02_52BD_B3
    dw OamList_B02_52BD_B4
    dw OamList_B02_52BD_B5
    dw OamList_B02_52BD_B6
    dw OamList_B02_52BD_B7
    dw OamList_B02_52BD_B8
    dw OamList_B02_52BD_B9
    dw OamList_B02_52BD_BA
    dw OamList_B02_52BD_BB
    dw OamList_B02_52BD_BC
    dw OamList_B02_52BD_BD
    dw OamList_B02_52BD_BE
    dw OamList_B02_52BD_BF
    dw OamList_B02_52BD_C0
    dw OamList_B02_52BD_C1
    dw OamList_B02_52BD_C2
    dw OamList_B02_52BD_C3
    dw OamList_B02_52BD_C4
    dw OamList_B02_52BD_C5
    dw OamList_B02_52BD_C6
    dw OamList_B02_52BD_C7
    dw OamList_B02_52BD_C8
    dw OamList_B02_52BD_C9
    dw OamList_B02_52BD_CA

; C: OAM list 00 of the table 5272
OamList_B02_52BD_00::
    db $09
    db $21
    db $56
    db $30
    db $f9
    db $21
    db $54
    db $30
    db $09
    db $e7
    db $56
    db $10
    db $f9
    db $e7
    db $54
    db $10
    db $80

; C: OAM list 01 of the table 5272
OamList_B02_52BD_01::
    db $09
    db $22
    db $56
    db $20
    db $f9
    db $22
    db $54
    db $20
    db $09
    db $e6
    db $56
    db $00
    db $f9
    db $e6
    db $54
    db $00
    db $80

; I: OAM list 02 of the table 5272
OamList_B02_52BD_02::
    db $03
    db $ff
    db $5a
    db $00
    db $03
    db $f7
    db $58
    db $00
    db $80

; I: OAM list 03 of the table 5272
OamList_B02_52BD_03::
    db $02
    db $ff
    db $5a
    db $00
    db $02
    db $f7
    db $58
    db $00
    db $80

; I: OAM list 04 of the table 5272
OamList_B02_52BD_04::
    db $02
    db $fe
    db $5a
    db $00
    db $02
    db $f6
    db $58
    db $00
    db $80

; I: OAM list 05 of the table 5272
OamList_B02_52BD_05::
    db $03
    db $fe
    db $5a
    db $00
    db $03
    db $f6
    db $58
    db $00
    db $80

; I: OAM list 06 of the table 5272
OamList_B02_52BD_06::
    db $03
    db $08
    db $5a
    db $20
    db $03
    db $10
    db $58
    db $20
    db $80

; I: OAM list 07 of the table 5272
OamList_B02_52BD_07::
    db $02
    db $08
    db $5a
    db $20
    db $02
    db $10
    db $58
    db $20
    db $80

; I: OAM list 08 of the table 5272
OamList_B02_52BD_08::
    db $02
    db $09
    db $5a
    db $20
    db $02
    db $11
    db $58
    db $20
    db $80

; I: OAM list 09 of the table 5272
OamList_B02_52BD_09::
    db $03
    db $09
    db $5a
    db $20
    db $03
    db $11
    db $58
    db $20
    db $80

; C: OAM list 0A of the table 5272
OamList_B02_52BD_0A::
    db $08
    db $00
    db $5c
    db $10
    db $80

; C: OAM list 0B of the table 5272
OamList_B02_52BD_0B::
    db $07
    db $00
    db $5c
    db $10
    db $80

; C: OAM list 0C of the table 5272
OamList_B02_52BD_0C::
    db $07
    db $ff
    db $5c
    db $10
    db $80

; C: OAM list 0D of the table 5272
OamList_B02_52BD_0D::
    db $08
    db $ff
    db $5c
    db $10
    db $80

; C: OAM list 0E of the table 5272
OamList_B02_52BD_0E::
    db $08
    db $08
    db $5c
    db $30
    db $80

; C: OAM list 0F of the table 5272
OamList_B02_52BD_0F::
    db $07
    db $08
    db $5c
    db $30
    db $80

; C: OAM list 10 of the table 5272
OamList_B02_52BD_10::
    db $07
    db $09
    db $5c
    db $30
    db $80

; C: OAM list 11 of the table 5272
OamList_B02_52BD_11::
    db $08
    db $09
    db $5c
    db $30
    db $80

; C: OAM list 12 of the table 5272
OamList_B02_52BD_12::
    db $08
    db $07
    db $52
    db $10
    db $08
    db $ff
    db $50
    db $10
    db $80

; C: OAM list 13 of the table 5272
OamList_B02_52BD_13::
    db $08
    db $09
    db $52
    db $10
    db $08
    db $01
    db $50
    db $10
    db $80

; C: OAM list 14 of the table 5272
OamList_B02_52BD_14::
    db $08
    db $0b
    db $52
    db $10
    db $08
    db $03
    db $50
    db $10
    db $80

; C: OAM list 15 of the table 5272
OamList_B02_52BD_15::
    db $08
    db $0d
    db $52
    db $10
    db $08
    db $05
    db $50
    db $10
    db $80

; C: OAM list 16 of the table 5272
OamList_B02_52BD_16::
    db $08
    db $00
    db $52
    db $30
    db $08
    db $08
    db $50
    db $30
    db $80

; C: OAM list 17 of the table 5272
OamList_B02_52BD_17::
    db $08
    db $fe
    db $52
    db $30
    db $08
    db $06
    db $50
    db $30
    db $80

; C: OAM list 18 of the table 5272
OamList_B02_52BD_18::
    db $08
    db $fc
    db $52
    db $30
    db $08
    db $04
    db $50
    db $30
    db $80

; C: OAM list 19 of the table 5272
OamList_B02_52BD_19::
    db $08
    db $fa
    db $52
    db $30
    db $08
    db $02
    db $50
    db $30
    db $80

; C: OAM list 1A of the table 5272
OamList_B02_52BD_1A::
    db $10
    db $04
    db $7e
    db $50
    db $80

; C: OAM list 1B of the table 5272
OamList_B02_52BD_1B::
    db $12
    db $04
    db $7e
    db $50
    db $80

; C: OAM list 1C of the table 5272
OamList_B02_52BD_1C::
    db $08
    db $04
    db $7e
    db $10
    db $80

; C: OAM list 1D of the table 5272
OamList_B02_52BD_1D::
    db $06
    db $04
    db $7e
    db $10
    db $80

; C: OAM list 1E of the table 5272
OamList_B02_52BD_1E::
    db $08
    db $20
    db $7c
    db $10
    db $08
    db $18
    db $7a
    db $10
    db $08
    db $10
    db $78
    db $10
    db $08
    db $08
    db $76
    db $10
    db $08
    db $00
    db $74
    db $10
    db $08
    db $f8
    db $72
    db $10
    db $08
    db $f0
    db $70
    db $10
    db $80

; C: OAM list 1F of the table 5272
OamList_B02_52BD_1F::
    db $07
    db $20
    db $7c
    db $10
    db $07
    db $18
    db $7a
    db $10
    db $07
    db $10
    db $78
    db $10
    db $07
    db $08
    db $76
    db $10
    db $07
    db $00
    db $74
    db $10
    db $07
    db $f8
    db $72
    db $10
    db $07
    db $f0
    db $70
    db $10
    db $80

; C: OAM list 20 of the table 5272
OamList_B02_52BD_20::
    db $00
    db $20
    db $4e
    db $10
    db $00
    db $18
    db $4c
    db $10
    db $00
    db $10
    db $4a
    db $10
    db $00
    db $08
    db $48
    db $10
    db $00
    db $00
    db $46
    db $10
    db $00
    db $f8
    db $44
    db $10
    db $00
    db $f0
    db $42
    db $10
    db $00
    db $e8
    db $40
    db $10
    db $f0
    db $20
    db $3e
    db $10
    db $f0
    db $18
    db $3c
    db $10
    db $f0
    db $10
    db $3a
    db $10
    db $f0
    db $08
    db $38
    db $10
    db $f0
    db $00
    db $36
    db $10
    db $f0
    db $f8
    db $34
    db $10
    db $f0
    db $f0
    db $32
    db $10
    db $f0
    db $e8
    db $30
    db $10
    db $80

; C: OAM list 21 of the table 5272
OamList_B02_52BD_21::
    db $00
    db $20
    db $4e
    db $00
    db $00
    db $18
    db $4c
    db $00
    db $00
    db $10
    db $4a
    db $00
    db $00
    db $08
    db $48
    db $00
    db $00
    db $00
    db $46
    db $00
    db $00
    db $f8
    db $44
    db $00
    db $00
    db $f0
    db $42
    db $00
    db $00
    db $e8
    db $40
    db $00
    db $f0
    db $20
    db $3e
    db $00
    db $f0
    db $18
    db $3c
    db $00
    db $f0
    db $10
    db $3a
    db $00
    db $f0
    db $08
    db $38
    db $00
    db $f0
    db $00
    db $36
    db $00
    db $f0
    db $f8
    db $34
    db $00
    db $f0
    db $f0
    db $32
    db $00
    db $f0
    db $e8
    db $30
    db $00
    db $80

; I: OAM list 22 of the table 5272
OamList_B02_52BD_22::
    db $28
    db $05
    db $1e
    db $10
    db $28
    db $fd
    db $1c
    db $10
    db $28
    db $f5
    db $1a
    db $10
    db $28
    db $ed
    db $18
    db $10
    db $18
    db $05
    db $16
    db $10
    db $18
    db $fd
    db $14
    db $10
    db $18
    db $f5
    db $12
    db $10
    db $18
    db $ed
    db $10
    db $10
    db $08
    db $05
    db $0e
    db $10
    db $08
    db $fd
    db $0c
    db $10
    db $08
    db $f5
    db $0a
    db $10
    db $08
    db $ed
    db $08
    db $10
    db $f8
    db $05
    db $06
    db $10
    db $f8
    db $fd
    db $04
    db $10
    db $f8
    db $f5
    db $02
    db $10
    db $f8
    db $ed
    db $00
    db $10
    db $80

; I: OAM list 23 of the table 5272
OamList_B02_52BD_23::
    db $27
    db $07
    db $1e
    db $10
    db $27
    db $ff
    db $1c
    db $10
    db $27
    db $f7
    db $1a
    db $10
    db $27
    db $ef
    db $18
    db $10
    db $17
    db $07
    db $16
    db $10
    db $17
    db $ff
    db $14
    db $10
    db $17
    db $f7
    db $12
    db $10
    db $17
    db $ef
    db $10
    db $10
    db $07
    db $07
    db $0e
    db $10
    db $07
    db $ff
    db $0c
    db $10
    db $07
    db $f7
    db $0a
    db $10
    db $07
    db $ef
    db $08
    db $10
    db $f7
    db $07
    db $06
    db $10
    db $f7
    db $ff
    db $04
    db $10
    db $f7
    db $f7
    db $02
    db $10
    db $f7
    db $ef
    db $00
    db $10
    db $80

; I: OAM list 24 of the table 5272
OamList_B02_52BD_24::
    db $19
    db $06
    db $16
    db $00
    db $19
    db $fe
    db $14
    db $00
    db $19
    db $f6
    db $12
    db $00
    db $19
    db $ee
    db $10
    db $00
    db $09
    db $06
    db $0e
    db $00
    db $09
    db $fe
    db $0c
    db $00
    db $09
    db $f6
    db $0a
    db $00
    db $09
    db $ee
    db $08
    db $00
    db $f9
    db $06
    db $06
    db $00
    db $f9
    db $fe
    db $04
    db $00
    db $f9
    db $f6
    db $02
    db $00
    db $f9
    db $ee
    db $00
    db $00
    db $29
    db $06
    db $1e
    db $00
    db $29
    db $fe
    db $1c
    db $00
    db $29
    db $f6
    db $1a
    db $00
    db $29
    db $ee
    db $18
    db $00
    db $80

; I: OAM list 25 of the table 5272
OamList_B02_52BD_25::
    db $08
    db $1a
    db $2e
    db $10
    db $08
    db $12
    db $2c
    db $10
    db $08
    db $0a
    db $2a
    db $10
    db $08
    db $02
    db $28
    db $10
    db $f8
    db $1a
    db $26
    db $10
    db $f8
    db $12
    db $24
    db $10
    db $f8
    db $0a
    db $22
    db $10
    db $f8
    db $02
    db $20
    db $10
    db $28
    db $1a
    db $6e
    db $10
    db $28
    db $12
    db $6c
    db $10
    db $28
    db $0a
    db $6a
    db $10
    db $28
    db $02
    db $68
    db $10
    db $18
    db $1a
    db $66
    db $10
    db $18
    db $12
    db $64
    db $10
    db $18
    db $0a
    db $62
    db $10
    db $18
    db $02
    db $60
    db $10
    db $80

; I: OAM list 26 of the table 5272
OamList_B02_52BD_26::
    db $07
    db $18
    db $2e
    db $10
    db $07
    db $10
    db $2c
    db $10
    db $07
    db $08
    db $2a
    db $10
    db $07
    db $00
    db $28
    db $10
    db $f7
    db $18
    db $26
    db $10
    db $f7
    db $10
    db $24
    db $10
    db $f7
    db $08
    db $22
    db $10
    db $f7
    db $00
    db $20
    db $10
    db $27
    db $18
    db $6e
    db $10
    db $27
    db $10
    db $6c
    db $10
    db $27
    db $08
    db $6a
    db $10
    db $27
    db $00
    db $68
    db $10
    db $17
    db $18
    db $66
    db $10
    db $17
    db $10
    db $64
    db $10
    db $17
    db $08
    db $62
    db $10
    db $17
    db $00
    db $60
    db $10
    db $80

; I: OAM list 27 of the table 5272
OamList_B02_52BD_27::
    db $09
    db $19
    db $2e
    db $00
    db $09
    db $11
    db $2c
    db $00
    db $09
    db $09
    db $2a
    db $00
    db $09
    db $01
    db $28
    db $00
    db $f9
    db $19
    db $26
    db $00
    db $f9
    db $11
    db $24
    db $00
    db $f9
    db $09
    db $22
    db $00
    db $f9
    db $01
    db $20
    db $00
    db $19
    db $19
    db $66
    db $00
    db $19
    db $11
    db $64
    db $00
    db $19
    db $09
    db $62
    db $00
    db $19
    db $01
    db $60
    db $00
    db $29
    db $19
    db $6e
    db $00
    db $29
    db $11
    db $6c
    db $00
    db $29
    db $09
    db $6a
    db $00
    db $29
    db $01
    db $68
    db $00
    db $80

; C: OAM list 28 of the table 5272
OamList_B02_52BD_28::
    db $0a
    db $fe
    db $5c
    db $50
    db $80

; C: OAM list 29 of the table 5272
OamList_B02_52BD_29::
    db $0a
    db $ff
    db $5c
    db $50
    db $80

; C: OAM list 2A of the table 5272
OamList_B02_52BD_2A::
    db $09
    db $ff
    db $5c
    db $50
    db $80

; C: OAM list 2B of the table 5272
OamList_B02_52BD_2B::
    db $09
    db $fe
    db $5c
    db $50
    db $80

; C: OAM list 2C of the table 5272
OamList_B02_52BD_2C::
    db $0a
    db $0a
    db $5c
    db $70
    db $80

; C: OAM list 2D of the table 5272
OamList_B02_52BD_2D::
    db $0a
    db $09
    db $5c
    db $70
    db $80

; C: OAM list 2E of the table 5272
OamList_B02_52BD_2E::
    db $09
    db $09
    db $5c
    db $70
    db $80

; C: OAM list 2F of the table 5272
OamList_B02_52BD_2F::
    db $09
    db $0a
    db $5c
    db $70
    db $80

; I: OAM list 30 of the table 5272
OamList_B02_52BD_30::
    db $08
    db $08
    db $00
    db $00
    db $80

; I: OAM list 31 of the table 5272
OamList_B02_52BD_31::
    db $08
    db $08
    db $01
    db $00
    db $80

; I: OAM list 32 of the table 5272
OamList_B02_52BD_32::
    db $08
    db $08
    db $02
    db $00
    db $80

; I: OAM list 33 of the table 5272
OamList_B02_52BD_33::
    db $08
    db $0f
    db $05
    db $00
    db $08
    db $07
    db $04
    db $00
    db $08
    db $ff
    db $03
    db $00
    db $80

; I: OAM list 34 of the table 5272
OamList_B02_52BD_34::
    db $08
    db $10
    db $08
    db $00
    db $08
    db $08
    db $07
    db $00
    db $08
    db $00
    db $06
    db $00
    db $80

; I: OAM list 35 of the table 5272
OamList_B02_52BD_35::
    db $08
    db $15
    db $10
    db $00
    db $80

; I: OAM list 36 of the table 5272
OamList_B02_52BD_36::
    db $08
    db $15
    db $11
    db $00
    db $80

; I: OAM list 37 of the table 5272
OamList_B02_52BD_37::
    db $08
    db $15
    db $12
    db $00
    db $80

; I: OAM list 38 of the table 5272
OamList_B02_52BD_38::
    db $08
    db $15
    db $13
    db $00
    db $80

; I: OAM list 39 of the table 5272
OamList_B02_52BD_39::
    db $08
    db $15
    db $14
    db $00
    db $80

; I: OAM list 3A of the table 5272
OamList_B02_52BD_3A::
    db $08
    db $15
    db $15
    db $00
    db $80

; I: OAM list 3B of the table 5272
OamList_B02_52BD_3B::
    db $08
    db $15
    db $16
    db $00
    db $80

; I: OAM list 3C of the table 5272
OamList_B02_52BD_3C::
    db $08
    db $15
    db $09
    db $00
    db $80

; I: OAM list 3D of the table 5272
OamList_B02_52BD_3D::
    db $08
    db $15
    db $0a
    db $00
    db $80

; I: OAM list 3E of the table 5272
OamList_B02_52BD_3E::
    db $08
    db $10
    db $f9
    db $00
    db $80

; I: OAM list 3F of the table 5272
OamList_B02_52BD_3F::
    db $08
    db $10
    db $f9
    db $00
    db $80

; I: OAM list 40 of the table 5272
OamList_B02_52BD_40::
    db $08
    db $10
    db $f9
    db $00
    db $80

; I: OAM list 41 of the table 5272
OamList_B02_52BD_41::
    db $08
    db $10
    db $f9
    db $00
    db $80

; I: OAM list 42 of the table 5272
OamList_B02_52BD_42::
    db $08
    db $06
    db $f9
    db $00
    db $80

; I: OAM list 43 of the table 5272
OamList_B02_52BD_43::
    db $20
    db $64
    db $0e
    db $30
    db $2d
    db $64
    db $0c
    db $70
    db $13
    db $64
    db $0c
    db $30
    db $2d
    db $54
    db $0d
    db $50
    db $13
    db $54
    db $0d
    db $10
    db $2d
    db $44
    db $0d
    db $50
    db $13
    db $44
    db $0d
    db $10
    db $2d
    db $34
    db $0d
    db $50
    db $13
    db $34
    db $0d
    db $10
    db $2d
    db $24
    db $0d
    db $50
    db $13
    db $24
    db $0d
    db $10
    db $20
    db $04
    db $0e
    db $10
    db $2d
    db $14
    db $0d
    db $50
    db $2d
    db $04
    db $0c
    db $50
    db $13
    db $14
    db $0d
    db $10
    db $13
    db $04
    db $0c
    db $10
    db $80

; I: OAM list 44 of the table 5272
OamList_B02_52BD_44::
    db $64
    db $03
    db $0e
    db $10
    db $64
    db $1d
    db $0e
    db $30
    db $74
    db $0f
    db $0d
    db $50
    db $74
    db $1d
    db $0c
    db $70
    db $74
    db $03
    db $0c
    db $50
    db $54
    db $03
    db $0e
    db $10
    db $54
    db $1d
    db $0e
    db $30
    db $44
    db $03
    db $0e
    db $10
    db $24
    db $03
    db $0e
    db $10
    db $24
    db $1d
    db $0e
    db $30
    db $44
    db $1d
    db $0e
    db $30
    db $34
    db $1d
    db $0e
    db $30
    db $14
    db $1d
    db $0c
    db $30
    db $14
    db $0f
    db $0d
    db $10
    db $34
    db $03
    db $0e
    db $10
    db $14
    db $03
    db $0c
    db $10
    db $80

; I: OAM list 45 of the table 5272
OamList_B02_52BD_45::
    db $08
    db $0b
    db $0f
    db $20
    db $08
    db $21
    db $0f
    db $00
    db $80

; I: OAM list 46 of the table 5272
OamList_B02_52BD_46::
    db $08
    db $0a
    db $0f
    db $20
    db $08
    db $22
    db $0f
    db $00
    db $80

; I: OAM list 47 of the table 5272
OamList_B02_52BD_47::
    db $08
    db $f8
    db $0f
    db $20
    db $08
    db $17
    db $0f
    db $00
    db $80

; I: OAM list 48 of the table 5272
OamList_B02_52BD_48::
    db $08
    db $f7
    db $0f
    db $20
    db $08
    db $18
    db $0f
    db $00
    db $80

; C: OAM list 49 of the table 5272
OamList_B02_52BD_49::
    db $2b
    db $2a
    db $06
    db $10
    db $2b
    db $22
    db $05
    db $10
    db $2b
    db $1c
    db $04
    db $10
    db $2b
    db $18
    db $03
    db $10
    db $07
    db $10
    db $01
    db $10
    db $07
    db $08
    db $00
    db $10
    db $29
    db $10
    db $01
    db $50
    db $29
    db $08
    db $00
    db $50
    db $80

; C: OAM list 4A of the table 5272
OamList_B02_52BD_4A::
    db $2b
    db $1c
    db $04
    db $10
    db $2b
    db $2a
    db $06
    db $10
    db $2b
    db $22
    db $05
    db $10
    db $2b
    db $18
    db $03
    db $10
    db $06
    db $10
    db $01
    db $10
    db $06
    db $08
    db $00
    db $10
    db $2a
    db $10
    db $01
    db $50
    db $2a
    db $08
    db $00
    db $50
    db $80

; C: OAM list 4B of the table 5272
OamList_B02_52BD_4B::
    db $2b
    db $2a
    db $06
    db $10
    db $2b
    db $22
    db $05
    db $10
    db $2b
    db $1c
    db $04
    db $10
    db $2b
    db $18
    db $03
    db $10
    db $05
    db $10
    db $01
    db $10
    db $05
    db $08
    db $00
    db $10
    db $2b
    db $10
    db $01
    db $50
    db $2b
    db $08
    db $00
    db $50
    db $80

; C: OAM list 4C of the table 5272
OamList_B02_52BD_4C::
    db $18
    db $30
    db $d3
    db $10
    db $18
    db $28
    db $d2
    db $10
    db $18
    db $20
    db $d1
    db $10
    db $18
    db $18
    db $d0
    db $10
    db $18
    db $10
    db $cf
    db $10
    db $18
    db $08
    db $ce
    db $10
    db $10
    db $30
    db $cd
    db $10
    db $10
    db $28
    db $cc
    db $10
    db $10
    db $20
    db $cb
    db $10
    db $10
    db $18
    db $ca
    db $10
    db $10
    db $10
    db $c9
    db $10
    db $10
    db $08
    db $c8
    db $10
    db $80

; C: OAM list 4D of the table 5272
OamList_B02_52BD_4D::
    db $18
    db $30
    db $df
    db $10
    db $18
    db $28
    db $de
    db $10
    db $18
    db $20
    db $dd
    db $10
    db $18
    db $18
    db $dc
    db $10
    db $18
    db $10
    db $db
    db $10
    db $18
    db $08
    db $da
    db $10
    db $10
    db $30
    db $d9
    db $10
    db $10
    db $28
    db $d8
    db $10
    db $10
    db $20
    db $d7
    db $10
    db $10
    db $18
    db $d6
    db $10
    db $10
    db $10
    db $d5
    db $10
    db $10
    db $08
    db $d4
    db $10
    db $80

; I: OAM list 4E of the table 5272
OamList_B02_52BD_4E::
    db $18
    db $38

    db $fd, $00, $18, $20, $b7, $00, $18, $30, $f9, $00, $18, $28, $f8, $00, $18, $18
    db $f6, $00, $18, $10

    db $c2
    db $00
    db $18
    db $08
    db $c1
    db $00
    db $18
    db $00
    db $c0
    db $00
    db $10
    db $38
    db $bf
    db $00
    db $10
    db $30
    db $be
    db $00
    db $10
    db $28
    db $bd
    db $00
    db $10
    db $20
    db $bc
    db $00
    db $10
    db $18
    db $bb
    db $00
    db $10
    db $10
    db $ba
    db $00
    db $10
    db $08
    db $b9
    db $00
    db $10
    db $00
    db $b8
    db $00
    db $80

; C: OAM list 4F of the table 5272
OamList_B02_52BD_4F::
    db $2b
    db $f0
    db $06
    db $10
    db $2b
    db $e8
    db $05
    db $10
    db $2b
    db $e2
    db $04
    db $10
    db $2b
    db $de
    db $03
    db $10
    db $07
    db $f8
    db $01
    db $30
    db $07
    db $00
    db $00
    db $30
    db $29
    db $f8
    db $01
    db $70
    db $29
    db $00
    db $00
    db $70
    db $80

; C: OAM list 50 of the table 5272
OamList_B02_52BD_50::
    db $2b
    db $e2
    db $04
    db $10
    db $2b
    db $f0
    db $06
    db $10
    db $2b
    db $e8
    db $05
    db $10
    db $2b
    db $de
    db $03
    db $10
    db $06
    db $f8
    db $01
    db $30
    db $06
    db $00
    db $00
    db $30
    db $2a
    db $f8
    db $01
    db $70
    db $2a
    db $00
    db $00
    db $70
    db $80

; C: OAM list 51 of the table 5272
OamList_B02_52BD_51::
    db $2b
    db $f0
    db $06
    db $10
    db $2b
    db $e8
    db $05
    db $10
    db $2b
    db $e2
    db $04
    db $10
    db $2b
    db $de
    db $03
    db $10
    db $05
    db $f8
    db $01
    db $30
    db $05
    db $00
    db $00
    db $30
    db $2b
    db $f8
    db $01
    db $70
    db $2b
    db $00
    db $00
    db $70
    db $80

; C: OAM list 52 of the table 5272
OamList_B02_52BD_52::
    db $28
    db $24
    db $0f
    db $70
    db $0c
    db $24
    db $0f
    db $30
    db $28
    db $04
    db $0f
    db $50
    db $0c
    db $04
    db $0f
    db $10
    db $80

; C: OAM list 53 of the table 5272
OamList_B02_52BD_53::
    db $29
    db $25
    db $0f
    db $70
    db $0b
    db $25
    db $0f
    db $30
    db $29
    db $03
    db $0f
    db $50
    db $0b
    db $03
    db $0f
    db $10
    db $80

; C: OAM list 54 of the table 5272
OamList_B02_52BD_54::
    db $33
    db $08
    db $c2
    db $10
    db $33
    db $20
    db $c6
    db $10
    db $33
    db $18
    db $c5
    db $10
    db $33
    db $10
    db $c4
    db $10
    db $2c
    db $17
    db $c0
    db $70
    db $2c
    db $0f
    db $c0
    db $50
    db $09
    db $17
    db $c0
    db $30
    db $09
    db $0f
    db $c0
    db $10
    db $80

; C: OAM list 55 of the table 5272
OamList_B02_52BD_55::
    db $33
    db $08
    db $c2
    db $10
    db $33
    db $20
    db $c6
    db $10
    db $33
    db $18
    db $c5
    db $10
    db $33
    db $10
    db $c4
    db $10
    db $2d
    db $17
    db $c0
    db $70
    db $2d
    db $0f
    db $c0
    db $50
    db $08
    db $17
    db $c0
    db $30
    db $08
    db $0f
    db $c0
    db $10
    db $80

; C: OAM list 56 of the table 5272
OamList_B02_52BD_56::
    db $33
    db $08
    db $c2
    db $10
    db $33
    db $20
    db $c6
    db $10
    db $33
    db $18
    db $c5
    db $10
    db $33
    db $10
    db $c4
    db $10
    db $2e
    db $17
    db $c0
    db $70
    db $2e
    db $0f
    db $c0
    db $50
    db $07
    db $17
    db $c0
    db $30
    db $07
    db $0f
    db $c0
    db $10
    db $80

; C: OAM list 57 of the table 5272
OamList_B02_52BD_57::
    db $19
    db $f2
    db $c5
    db $10
    db $19
    db $e4
    db $c2
    db $10
    db $19
    db $eb
    db $c4
    db $10
    db $19
    db $fa
    db $c6
    db $10
    db $1d
    db $02
    db $c1
    db $50
    db $15
    db $02
    db $c1
    db $10
    db $1d
    db $26
    db $c1
    db $70
    db $15
    db $26
    db $c1
    db $30
    db $80

; C: OAM list 58 of the table 5272
OamList_B02_52BD_58::
    db $19
    db $f2
    db $c5
    db $10
    db $19
    db $e4
    db $c2
    db $10
    db $19
    db $eb
    db $c4
    db $10
    db $19
    db $fa
    db $c6
    db $10
    db $1d
    db $01
    db $c1
    db $50
    db $15
    db $01
    db $c1
    db $10
    db $1d
    db $27
    db $c1
    db $70
    db $15
    db $27
    db $c1
    db $30
    db $80

; C: OAM list 59 of the table 5272
OamList_B02_52BD_59::
    db $19
    db $f2
    db $c5
    db $10
    db $19
    db $e4
    db $c2
    db $10
    db $19
    db $eb
    db $c4
    db $10
    db $19
    db $fa
    db $c6
    db $10
    db $1d
    db $00
    db $c1
    db $50
    db $15
    db $00
    db $c1
    db $10
    db $1d
    db $28
    db $c1
    db $70
    db $15
    db $28
    db $c1
    db $30
    db $80

; C: OAM list 5A of the table 5272
OamList_B02_52BD_5A::
    db $28
    db $20
    db $df
    db $00
    db $28
    db $18
    db $de
    db $00
    db $28
    db $10
    db $dd
    db $00
    db $28
    db $08
    db $dc
    db $00
    db $20
    db $20
    db $db
    db $00
    db $20
    db $18
    db $da
    db $00
    db $20
    db $10
    db $d9
    db $00
    db $20
    db $08
    db $d8
    db $00
    db $18
    db $20
    db $d7
    db $00
    db $18
    db $18
    db $d6
    db $00
    db $18
    db $10
    db $d5
    db $00
    db $18
    db $08
    db $d4
    db $00
    db $10
    db $20
    db $d3
    db $00
    db $10
    db $18
    db $d2
    db $00
    db $10
    db $10
    db $d1
    db $00
    db $10
    db $08
    db $d0
    db $00
    db $80

; C: OAM list 5B of the table 5272
OamList_B02_52BD_5B::
    db $28
    db $20
    db $ef
    db $00
    db $28
    db $18
    db $ee
    db $00
    db $28
    db $10
    db $ed
    db $00
    db $28
    db $08
    db $ec
    db $00
    db $20
    db $20
    db $eb
    db $00
    db $20
    db $18
    db $ea
    db $00
    db $20
    db $10
    db $e9
    db $00
    db $20
    db $08
    db $e8
    db $00
    db $18
    db $20
    db $e7
    db $00
    db $18
    db $18
    db $e6
    db $00
    db $18
    db $10
    db $e5
    db $00
    db $18
    db $08
    db $e4
    db $00
    db $10
    db $20
    db $e3
    db $00
    db $10
    db $18
    db $e2
    db $00
    db $10
    db $10
    db $e1
    db $00
    db $10
    db $08
    db $e0
    db $00
    db $80

; C: OAM list 5C of the table 5272
OamList_B02_52BD_5C::
    db $18
    db $10
    db $f6
    db $00
    db $18
    db $08
    db $f5
    db $00
    db $10
    db $10
    db $f4
    db $00
    db $10
    db $08
    db $f3
    db $00
    db $80

; C: OAM list 5D of the table 5272
OamList_B02_52BD_5D::
    db $18
    db $10
    db $fa
    db $00
    db $18
    db $08
    db $f9
    db $00
    db $10
    db $10
    db $f8
    db $00
    db $10
    db $08
    db $f7
    db $00
    db $80

; C: OAM list 5E of the table 5272
OamList_B02_52BD_5E::
    db $18
    db $50
    db $73
    db $10
    db $18
    db $48
    db $72
    db $10
    db $18
    db $40
    db $71
    db $10
    db $18
    db $38
    db $70
    db $10
    db $18
    db $30
    db $6f
    db $10
    db $18
    db $28
    db $6e
    db $10
    db $18
    db $20
    db $6d
    db $10
    db $18
    db $18
    db $6c
    db $10
    db $18
    db $10
    db $6b
    db $10
    db $18
    db $08
    db $6a
    db $10
    db $10
    db $50
    db $69
    db $10
    db $10
    db $48
    db $68
    db $10
    db $10
    db $40
    db $67
    db $10
    db $10
    db $38
    db $66
    db $10
    db $10
    db $30
    db $65
    db $10
    db $10
    db $28
    db $64
    db $10
    db $10
    db $20
    db $63
    db $10
    db $10
    db $18
    db $62
    db $10
    db $10
    db $10
    db $61
    db $10
    db $10
    db $08
    db $60
    db $10
    db $80

; C: OAM list 5F of the table 5272
OamList_B02_52BD_5F::
    db $f8
    db $18
    db $61
    db $10
    db $f8
    db $10
    db $60
    db $10
    db $f8
    db $08
    db $5f
    db $10
    db $f8
    db $00
    db $5e
    db $10
    db $f8
    db $f8
    db $5d
    db $10
    db $f0
    db $18
    db $5c
    db $10
    db $f0
    db $10
    db $5b
    db $10
    db $f0
    db $08
    db $5a
    db $10
    db $f0
    db $00
    db $59
    db $10
    db $f0
    db $f8
    db $58
    db $10
    db $f8
    db $f0
    db $53
    db $10
    db $f8
    db $e8
    db $52
    db $10
    db $f0
    db $f0
    db $51
    db $10
    db $f0
    db $e8
    db $50
    db $10
    db $80

; C: OAM list 60 of the table 5272
OamList_B02_52BD_60::
    db $f8
    db $18
    db $76
    db $10
    db $f8
    db $10
    db $75
    db $10
    db $f8
    db $08
    db $74
    db $10
    db $f8
    db $00
    db $73
    db $10
    db $f8
    db $f8
    db $72
    db $10
    db $f0
    db $18
    db $66
    db $10
    db $f0
    db $10
    db $65
    db $10
    db $f0
    db $08
    db $64
    db $10
    db $f0
    db $00
    db $63
    db $10
    db $f0
    db $f8
    db $62
    db $10
    db $f8
    db $f0
    db $57
    db $10
    db $f8
    db $e8
    db $56
    db $10
    db $f0
    db $f0
    db $55
    db $10
    db $f0
    db $e8
    db $54
    db $10
    db $80

; C: OAM list 61 of the table 5272
OamList_B02_52BD_61::
    db $f0
    db $f0
    db $02
    db $00
    db $f0
    db $e8
    db $00
    db $00
    db $80

; C: OAM list 62 of the table 5272
OamList_B02_52BD_62::
    db $f0
    db $f0
    db $06
    db $00
    db $f0
    db $e8
    db $04
    db $00
    db $80

; C: OAM list 63 of the table 5272
OamList_B02_52BD_63::
    db $f0
    db $f0
    db $0a
    db $00
    db $f0
    db $e8
    db $08
    db $00
    db $80

; C: OAM list 64 of the table 5272
OamList_B02_52BD_64::
    db $f0
    db $f0
    db $0e
    db $00
    db $f0
    db $e8
    db $0c
    db $00
    db $80

; C: OAM list 65 of the table 5272
OamList_B02_52BD_65::
    db $f0
    db $f0
    db $12
    db $00
    db $f0
    db $e8
    db $10
    db $00
    db $80

; C: OAM list 66 of the table 5272
OamList_B02_52BD_66::
    db $f0
    db $f0
    db $16
    db $00
    db $f0
    db $e8
    db $14
    db $00
    db $80

; C: OAM list 67 of the table 5272
OamList_B02_52BD_67::
    db $f8
    db $00
    db $2a
    db $00
    db $00
    db $f8
    db $28
    db $00
    db $f0
    db $f8
    db $26
    db $00
    db $00
    db $f0
    db $24
    db $00
    db $f0
    db $f0
    db $22
    db $00
    db $f8
    db $e8
    db $20
    db $00
    db $80

; C: OAM list 68 of the table 5272
OamList_B02_52BD_68::
    db $f8
    db $00
    db $36
    db $00
    db $00
    db $f8
    db $34
    db $00
    db $f0
    db $f8
    db $32
    db $00
    db $00
    db $f0
    db $30
    db $00
    db $f0
    db $f0
    db $2e
    db $00
    db $f8
    db $e8
    db $2c
    db $00
    db $80

; C: OAM list 69 of the table 5272
OamList_B02_52BD_69::
    db $f8
    db $00
    db $42
    db $00
    db $00
    db $f8
    db $40
    db $00
    db $f0
    db $f8
    db $3e
    db $00
    db $00
    db $f0
    db $3c
    db $00
    db $f0
    db $f0
    db $3a
    db $00
    db $f8
    db $e8
    db $38
    db $00
    db $80

; C: OAM list 6A of the table 5272
OamList_B02_52BD_6A::
    db $f8
    db $00
    db $4e
    db $00
    db $00
    db $f8
    db $4c
    db $00
    db $f0
    db $f8
    db $4a
    db $00
    db $00
    db $f0
    db $48
    db $00
    db $f0
    db $f0
    db $46
    db $00
    db $f8
    db $e8
    db $44
    db $00
    db $80

; C: OAM list 6B of the table 5272
OamList_B02_52BD_6B::
    db $f0
    db $f0
    db $1a
    db $00
    db $f0
    db $e8
    db $18
    db $00
    db $80

; C: OAM list 6C of the table 5272
OamList_B02_52BD_6C::
    db $f0
    db $f1
    db $1a
    db $00
    db $f0
    db $e9
    db $18
    db $00
    db $80

; C: OAM list 6D of the table 5272
OamList_B02_52BD_6D::
    db $f1
    db $f1
    db $1a
    db $00
    db $f1
    db $e9
    db $18
    db $00
    db $80

; C: OAM list 6E of the table 5272
OamList_B02_52BD_6E::
    db $f1
    db $f0
    db $1a
    db $00
    db $f1
    db $e8
    db $18
    db $00
    db $80

; C: OAM list 6F of the table 5272
OamList_B02_52BD_6F::
    db $f6
    db $fa
    db $1e
    db $00
    db $f6
    db $df
    db $1e
    db $20
    db $80

; C: OAM list 70 of the table 5272
OamList_B02_52BD_70::
    db $f6
    db $fb
    db $1e
    db $00
    db $f6
    db $de
    db $1e
    db $20
    db $80

; C: OAM list 71 of the table 5272
OamList_B02_52BD_71::
    db $fa
    db $04
    db $1e
    db $00
    db $fa
    db $df
    db $1e
    db $20
    db $80

; C: OAM list 72 of the table 5272
OamList_B02_52BD_72::
    db $fa
    db $05
    db $1e
    db $00
    db $fa
    db $de
    db $1e
    db $20
    db $80

; C: OAM list 73 of the table 5272
OamList_B02_52BD_73::
    db $f0
    db $30
    db $62
    db $10
    db $f0
    db $28
    db $60
    db $10
    db $f0
    db $20
    db $5e
    db $10
    db $f0
    db $18
    db $5c
    db $10
    db $f0
    db $10
    db $5a
    db $10
    db $f0
    db $08
    db $58
    db $10
    db $f0
    db $00
    db $56
    db $10
    db $f0
    db $f8
    db $54
    db $10
    db $f0
    db $f0
    db $52
    db $10
    db $f0
    db $e8
    db $50
    db $10
    db $80

; C: OAM list 74 of the table 5272
OamList_B02_52BD_74::
    db $f0
    db $28
    db $74
    db $10
    db $f0
    db $20
    db $72
    db $10
    db $f0
    db $18
    db $70
    db $10
    db $f0
    db $10
    db $6e
    db $10
    db $f0
    db $08
    db $6c
    db $10
    db $f0
    db $00
    db $6a
    db $10
    db $f0
    db $f8
    db $68
    db $10
    db $f0
    db $f0
    db $66
    db $10
    db $f0
    db $e8
    db $64
    db $10
    db $80

; C: OAM list 75 of the table 5272
OamList_B02_52BD_75::
    db $18
    db $10
    db $73
    db $10
    db $18
    db $08
    db $72
    db $10
    db $10
    db $10
    db $71
    db $10
    db $10
    db $08
    db $70
    db $10
    db $80

; C: OAM list 76 of the table 5272
OamList_B02_52BD_76::
    db $18
    db $10
    db $77
    db $10
    db $18
    db $08
    db $76
    db $10
    db $10
    db $10
    db $75
    db $10
    db $10
    db $08
    db $74
    db $10
    db $80

; C: OAM list 77 of the table 5272
OamList_B02_52BD_77::
    db $17
    db $10
    db $73
    db $10
    db $17
    db $08
    db $72
    db $10
    db $0f
    db $10
    db $71
    db $10
    db $0f
    db $08
    db $70
    db $10
    db $80

; C: OAM list 78 of the table 5272
OamList_B02_52BD_78::
    db $19
    db $10
    db $73
    db $10
    db $19
    db $08
    db $72
    db $10
    db $11
    db $10
    db $71
    db $10
    db $11
    db $08
    db $70
    db $10
    db $80

; C: OAM list 79 of the table 5272
OamList_B02_52BD_79::
    db $10
    db $10
    db $79
    db $00
    db $10
    db $08
    db $78
    db $00
    db $80

; C: OAM list 7A of the table 5272
OamList_B02_52BD_7A::
    db $11
    db $17
    db $00
    db $30
    db $1f
    db $17
    db $00
    db $70
    db $1f
    db $09
    db $00
    db $50
    db $11
    db $09
    db $00
    db $10
    db $80

; C: OAM list 7B of the table 5272
OamList_B02_52BD_7B::
    db $10
    db $18
    db $00
    db $30
    db $20
    db $18
    db $00
    db $70
    db $20
    db $08
    db $00
    db $50
    db $10
    db $08
    db $00
    db $10
    db $80

; C: OAM list 7C of the table 5272
OamList_B02_52BD_7C::
    db $18
    db $08
    db $02
    db $00
    db $80

; C: OAM list 7D of the table 5272
OamList_B02_52BD_7D::
    db $1f
    db $0f
    db $01
    db $30
    db $1f
    db $08
    db $01
    db $10
    db $f0
    db $0f
    db $01
    db $70
    db $f0
    db $08
    db $01
    db $50
    db $80

; C: OAM list 7E of the table 5272
OamList_B02_52BD_7E::
    db $18
    db $18
    db $11
    db $00
    db $18
    db $10
    db $10
    db $00
    db $18
    db $08
    db $0f
    db $00
    db $18
    db $00
    db $0e
    db $00
    db $18
    db $f8
    db $0d
    db $00
    db $10
    db $18
    db $0c
    db $00
    db $10
    db $10
    db $0b
    db $00
    db $10
    db $08
    db $0a
    db $00
    db $10
    db $00
    db $09
    db $00
    db $10
    db $f8
    db $08
    db $00
    db $08
    db $18
    db $07
    db $00
    db $08
    db $10
    db $06
    db $00
    db $08
    db $08
    db $05
    db $00
    db $08
    db $00
    db $04
    db $00
    db $08
    db $f8
    db $03
    db $00
    db $00
    db $08
    db $02
    db $00
    db $00
    db $00
    db $01
    db $00
    db $00
    db $f8
    db $00
    db $00
    db $80

; C: OAM list 7F of the table 5272
OamList_B02_52BD_7F::
    db $10
    db $f8
    db $13
    db $00
    db $08
    db $f8
    db $12
    db $00
    db $18
    db $18
    db $11
    db $00
    db $18
    db $10
    db $10
    db $00
    db $18
    db $08
    db $0f
    db $00
    db $18
    db $00
    db $0e
    db $00
    db $18
    db $f8
    db $0d
    db $00
    db $10
    db $18
    db $0c
    db $00
    db $10
    db $10
    db $0b
    db $00
    db $10
    db $08
    db $0a
    db $00
    db $10
    db $00
    db $09
    db $00
    db $08
    db $18
    db $07
    db $00
    db $08
    db $10
    db $06
    db $00
    db $08
    db $08
    db $05
    db $00
    db $08
    db $00
    db $04
    db $00
    db $00
    db $08
    db $02
    db $00
    db $00
    db $00
    db $01
    db $00
    db $00
    db $f8
    db $00
    db $00
    db $80

; C: OAM list 80 of the table 5272
OamList_B02_52BD_80::
    db $18
    db $f8
    db $15
    db $00
    db $10
    db $f8
    db $14
    db $00
    db $18
    db $18
    db $11
    db $00
    db $18
    db $10
    db $10
    db $00
    db $18
    db $08
    db $0f
    db $00
    db $18
    db $00
    db $0e
    db $00
    db $10
    db $18
    db $0c
    db $00
    db $10
    db $10
    db $0b
    db $00
    db $10
    db $08
    db $0a
    db $00
    db $10
    db $00
    db $09
    db $00
    db $08
    db $18
    db $07
    db $00
    db $08
    db $10
    db $06
    db $00
    db $08
    db $08
    db $05
    db $00
    db $08
    db $00
    db $04
    db $00
    db $08
    db $f8
    db $03
    db $00
    db $00
    db $08
    db $02
    db $00
    db $00
    db $00
    db $01
    db $00
    db $00
    db $f8
    db $00
    db $00
    db $80

; C: OAM list 81 of the table 5272
OamList_B02_52BD_81::
    db $00
    db $08
    db $19
    db $10
    db $00
    db $00
    db $18
    db $10
    db $08
    db $08
    db $17
    db $10
    db $08
    db $00
    db $16
    db $10
    db $80

; C: OAM list 82 of the table 5272
OamList_B02_52BD_82::
    db $ff
    db $08
    db $19
    db $10
    db $ff
    db $00
    db $18
    db $10
    db $07
    db $08
    db $17
    db $10
    db $07
    db $00
    db $16
    db $10
    db $80

; C: OAM list 83 of the table 5272
OamList_B02_52BD_83::
    db $fe
    db $08
    db $19
    db $10
    db $fe
    db $00
    db $18
    db $10
    db $06
    db $08
    db $17
    db $10
    db $06
    db $00
    db $16
    db $10
    db $80

; C: OAM list 84 of the table 5272
OamList_B02_52BD_84::
    db $10
    db $08
    db $19
    db $50
    db $10
    db $00
    db $18
    db $50
    db $08
    db $08
    db $17
    db $50
    db $08
    db $00
    db $16
    db $50
    db $80

; C: OAM list 85 of the table 5272
OamList_B02_52BD_85::
    db $11
    db $08
    db $19
    db $50
    db $11
    db $00
    db $18
    db $50
    db $09
    db $08
    db $17
    db $50
    db $09
    db $00
    db $16
    db $50
    db $80

; C: OAM list 86 of the table 5272
OamList_B02_52BD_86::
    db $12
    db $08
    db $19
    db $50
    db $12
    db $00
    db $18
    db $50
    db $0a
    db $08
    db $17
    db $50
    db $0a
    db $00
    db $16
    db $50
    db $80

; C: OAM list 87 of the table 5272
OamList_B02_52BD_87::
    db $0c
    db $f0
    db $1a
    db $00
    db $0c
    db $f8
    db $1a
    db $00
    db $0c
    db $20
    db $1a
    db $00
    db $0c
    db $10
    db $1a
    db $00
    db $0c
    db $18
    db $1a
    db $00
    db $0c
    db $08
    db $1a
    db $00
    db $0c
    db $00
    db $1a
    db $00
    db $80

; C: OAM list 88 of the table 5272
OamList_B02_52BD_88::
    db $0a
    db $f0
    db $1a
    db $00
    db $0a
    db $f8
    db $1a
    db $00
    db $0a
    db $20
    db $1a
    db $00
    db $0a
    db $10
    db $1a
    db $00
    db $0a
    db $18
    db $1a
    db $00
    db $0a
    db $08
    db $1a
    db $00
    db $0a
    db $00
    db $1a
    db $00
    db $80

; C: OAM list 89 of the table 5272
OamList_B02_52BD_89::
    db $08
    db $f0
    db $1a
    db $00
    db $08
    db $f8
    db $1a
    db $00
    db $08
    db $20
    db $1a
    db $00
    db $08
    db $10
    db $1a
    db $00
    db $08
    db $18
    db $1a
    db $00
    db $08
    db $08
    db $1a
    db $00
    db $08
    db $00
    db $1a
    db $00
    db $80

; C: OAM list 8A of the table 5272
OamList_B02_52BD_8A::
    db $06
    db $f0
    db $1a
    db $00
    db $06
    db $f8
    db $1a
    db $00
    db $06
    db $20
    db $1a
    db $00
    db $06
    db $10
    db $1a
    db $00
    db $06
    db $18
    db $1a
    db $00
    db $06
    db $08
    db $1a
    db $00
    db $06
    db $00
    db $1a
    db $00
    db $80

; C: OAM list 8B of the table 5272
OamList_B02_52BD_8B::
    db $04
    db $f0
    db $1a
    db $00
    db $04
    db $f8
    db $1a
    db $00
    db $04
    db $20
    db $1a
    db $00
    db $04
    db $10
    db $1a
    db $00
    db $04
    db $18
    db $1a
    db $00
    db $04
    db $08
    db $1a
    db $00
    db $04
    db $00
    db $1a
    db $00
    db $80

; C: OAM list 8C of the table 5272
OamList_B02_52BD_8C::
    db $02
    db $f0
    db $1a
    db $00
    db $02
    db $f8
    db $1a
    db $00
    db $02
    db $20
    db $1a
    db $00
    db $02
    db $10
    db $1a
    db $00
    db $02
    db $18
    db $1a
    db $00
    db $02
    db $08
    db $1a
    db $00
    db $02
    db $00
    db $1a
    db $00
    db $80

; C: OAM list 8D of the table 5272
OamList_B02_52BD_8D::
    db $00
    db $f0
    db $1a
    db $00
    db $00
    db $f8
    db $1a
    db $00
    db $00
    db $20
    db $1a
    db $00
    db $00
    db $10
    db $1a
    db $00
    db $00
    db $18
    db $1a
    db $00
    db $00
    db $08
    db $1a
    db $00
    db $00
    db $00
    db $1a
    db $00
    db $80

; C: OAM list 8E of the table 5272
OamList_B02_52BD_8E::
    db $08
    db $08
    db $a1
    db $00
    db $10
    db $08
    db $a1
    db $00
    db $10
    db $00
    db $a1
    db $00
    db $08
    db $00
    db $a1
    db $00
    db $80

; C: OAM list 8F of the table 5272
OamList_B02_52BD_8F::
    db $08
    db $08
    db $00
    db $00
    db $80

; C: OAM list 90 of the table 5272
OamList_B02_52BD_90::
    db $08
    db $08
    db $01
    db $00
    db $80

; C: OAM list 91 of the table 5272
OamList_B02_52BD_91::
    db $08
    db $18
    db $07
    db $00
    db $08
    db $10
    db $06
    db $00
    db $08
    db $08
    db $05
    db $00
    db $00
    db $18
    db $04
    db $00
    db $00
    db $10
    db $03
    db $00
    db $00
    db $08
    db $02
    db $00
    db $80

; C: OAM list 92 of the table 5272
OamList_B02_52BD_92::
    db $08
    db $18
    db $19
    db $00
    db $08
    db $10
    db $18
    db $00
    db $08
    db $08
    db $17
    db $00
    db $00
    db $18
    db $16
    db $00
    db $00
    db $10
    db $15
    db $00
    db $00
    db $08
    db $14
    db $00
    db $80

; C: OAM list 93 of the table 5272
OamList_B02_52BD_93::
    db $00
    db $18
    db $0a
    db $00
    db $00
    db $10
    db $09
    db $00
    db $00
    db $08
    db $08
    db $00
    db $08
    db $18
    db $0d
    db $00
    db $08
    db $10
    db $0c
    db $00
    db $08
    db $08
    db $0b
    db $00
    db $80

; C: OAM list 94 of the table 5272
OamList_B02_52BD_94::
    db $08
    db $18
    db $1f
    db $00
    db $08
    db $10
    db $1e
    db $00
    db $08
    db $08
    db $1d
    db $00
    db $00
    db $18
    db $1c
    db $00
    db $00
    db $10
    db $1b
    db $00
    db $00
    db $08
    db $1a
    db $00
    db $80

; C: OAM list 95 of the table 5272
OamList_B02_52BD_95::
    db $08
    db $18
    db $13
    db $00
    db $08
    db $10
    db $12
    db $00
    db $08
    db $08
    db $11
    db $00
    db $00
    db $18
    db $10
    db $00
    db $00
    db $10
    db $0f
    db $00
    db $00
    db $08
    db $0e
    db $00
    db $80

; C: OAM list 96 of the table 5272
OamList_B02_52BD_96::
    db $08
    db $18
    db $25
    db $00
    db $08
    db $10
    db $24
    db $00
    db $08
    db $08
    db $23
    db $00
    db $00
    db $18
    db $22
    db $00
    db $00
    db $10
    db $21
    db $00
    db $00
    db $08
    db $20
    db $00
    db $80

; I: OAM list 97 of the table 5272
OamList_B02_52BD_97::
    db $18
    db $15
    db $41
    db $00
    db $18
    db $0d
    db $40
    db $00
    db $18
    db $05
    db $3f
    db $00
    db $10
    db $0d
    db $3e
    db $00
    db $10
    db $05
    db $3d
    db $00
    db $10
    db $fd
    db $3c
    db $00
    db $10
    db $f5
    db $3b
    db $00
    db $08
    db $0d
    db $3a
    db $00
    db $08
    db $05
    db $39
    db $00
    db $08
    db $fd
    db $38
    db $00
    db $00
    db $0d
    db $29
    db $00
    db $00
    db $05
    db $28
    db $00
    db $00
    db $fd
    db $27
    db $00
    db $00
    db $f5
    db $26
    db $00
    db $80

; I: OAM list 98 of the table 5272
OamList_B02_52BD_98::
    db $18
    db $15

    db $41, $00, $18, $0d, $40, $00, $18, $05, $3f, $00, $10, $0d, $3e, $00, $10, $05
    db $3d, $00, $10, $fd, $3c, $00, $10, $f5, $3b, $00, $08, $0d, $3a, $00, $08, $05
    db $39, $00, $08, $fd, $38, $00, $00, $0c, $29, $00, $00, $04, $28, $00, $00, $fc
    db $27, $00, $00, $f4, $26, $00, $80

; I: OAM list 99 of the table 5272
OamList_B02_52BD_99::
    db $18, $15, $41, $00, $18, $0d, $40, $00, $18, $05, $3f, $00, $10, $0d, $3e, $00
    db $10, $05, $3d, $00, $10, $fd, $3c, $00, $10, $f5, $3b, $00, $08, $0d, $3a, $00
    db $08, $05, $39, $00, $08, $fd, $38, $00, $00, $0e, $29, $00, $00, $06, $28, $00
    db $00, $fe, $27, $00, $00, $f6, $26, $00, $80

; I: OAM list 9A of the table 5272
OamList_B02_52BD_9A::
    db $18, $15, $41, $00, $18, $0d, $40, $00, $18, $05, $3f, $00, $10, $0d, $3e, $00
    db $10, $05, $3d, $00, $10, $fd, $3c, $00, $10, $f5, $3b, $00, $00, $0d, $37, $00
    db $00, $05, $36, $00, $00, $fd, $35, $00, $00, $f5, $34, $00, $08, $0d, $2c, $00
    db $08, $05, $2b, $00, $08, $fd, $2a, $00, $80

; I: OAM list 9B of the table 5272
OamList_B02_52BD_9B::
    db $18, $15, $41, $00, $18, $0d, $40, $00, $18, $05, $3f, $00, $10, $0d, $3e, $00
    db $10, $05, $3d, $00, $10, $fd, $3c, $00, $10, $f5, $3b, $00, $00, $0d, $37, $00
    db $00, $05, $36, $00, $00, $fd, $35, $00, $00, $f5, $34, $00, $08, $0c, $2c

    db $00
    db $08
    db $04
    db $2b
    db $00
    db $08
    db $fc
    db $2a
    db $00
    db $80

; I: OAM list 9C of the table 5272
OamList_B02_52BD_9C::
    db $18
    db $15
    db $41
    db $00
    db $18
    db $0d
    db $40
    db $00
    db $18
    db $05
    db $3f
    db $00
    db $10
    db $0d
    db $3e
    db $00
    db $10
    db $05
    db $3d
    db $00
    db $10
    db $fd
    db $3c
    db $00
    db $10
    db $f5
    db $3b
    db $00
    db $00
    db $0d
    db $37
    db $00
    db $00
    db $05
    db $36
    db $00
    db $00
    db $fd
    db $35
    db $00
    db $00
    db $f5
    db $34
    db $00
    db $08
    db $0e
    db $2c
    db $00
    db $08
    db $06
    db $2b
    db $00
    db $08
    db $fe
    db $2a
    db $00
    db $80

; I: OAM list 9D of the table 5272
OamList_B02_52BD_9D::
    db $08
    db $0d
    db $3a
    db $00
    db $08
    db $05
    db $39
    db $00
    db $08
    db $fd
    db $38
    db $00
    db $00
    db $0d
    db $37
    db $00
    db $00
    db $05
    db $36
    db $00
    db $00
    db $fd
    db $35
    db $00
    db $00
    db $f5
    db $34
    db $00
    db $18
    db $15
    db $33
    db $00
    db $18
    db $0d
    db $32
    db $00
    db $18
    db $05
    db $31
    db $00
    db $10
    db $0d
    db $30
    db $00
    db $10
    db $05
    db $2f
    db $00
    db $10
    db $fd
    db $2e
    db $00
    db $10
    db $f5
    db $2d
    db $00
    db $80

; I: OAM list 9E of the table 5272
OamList_B02_52BD_9E::
    db $08
    db $0d
    db $3a
    db $00
    db $08
    db $05
    db $39
    db $00
    db $08
    db $fd
    db $38
    db $00
    db $00
    db $0d
    db $37
    db $00
    db $00
    db $05
    db $36
    db $00
    db $00
    db $fd
    db $35
    db $00
    db $00
    db $f5
    db $34
    db $00
    db $18
    db $14
    db $33
    db $00
    db $18
    db $0c
    db $32
    db $00
    db $18
    db $04
    db $31
    db $00
    db $10
    db $0c
    db $30
    db $00
    db $10
    db $04
    db $2f
    db $00
    db $10
    db $fc
    db $2e
    db $00
    db $10
    db $f4
    db $2d
    db $00
    db $80

; I: OAM list 9F of the table 5272
OamList_B02_52BD_9F::
    db $08
    db $0d
    db $3a
    db $00
    db $08
    db $05
    db $39
    db $00
    db $08
    db $fd
    db $38
    db $00
    db $00
    db $0d
    db $37
    db $00
    db $00
    db $05
    db $36
    db $00
    db $00
    db $fd
    db $35
    db $00
    db $00
    db $f5
    db $34
    db $00
    db $18
    db $16
    db $33
    db $00
    db $18
    db $0e
    db $32
    db $00
    db $18
    db $06
    db $31
    db $00
    db $10
    db $0e
    db $30
    db $00
    db $10
    db $06
    db $2f
    db $00
    db $10
    db $fe
    db $2e
    db $00
    db $10
    db $f6
    db $2d
    db $00
    db $80

; C: OAM list A0 of the table 5272
OamList_B02_52BD_A0::
    db $18
    db $0a
    db $3d
    db $00
    db $10
    db $0a
    db $2d
    db $00
    db $18
    db $02
    db $43
    db $00
    db $10
    db $02
    db $33
    db $00
    db $18
    db $fa
    db $3c
    db $00
    db $10
    db $fa
    db $2c
    db $00
    db $08
    db $04
    db $38
    db $00
    db $00
    db $04
    db $28
    db $00
    db $07
    db $fc
    db $34
    db $00
    db $08
    db $f4
    db $42
    db $00
    db $00
    db $f4
    db $32
    db $00
    db $80

; C: OAM list A1 of the table 5272
OamList_B02_52BD_A1::
    db $19
    db $09
    db $3d
    db $00
    db $11
    db $09
    db $2d
    db $00
    db $17
    db $01
    db $43
    db $00
    db $0f
    db $01
    db $33
    db $00
    db $19
    db $f9
    db $3c
    db $00
    db $11
    db $f9
    db $2c
    db $00
    db $09
    db $05
    db $38
    db $00
    db $01
    db $05
    db $28
    db $00
    db $06
    db $fd
    db $34
    db $00
    db $09
    db $f5
    db $42
    db $00
    db $01
    db $f5
    db $32
    db $00
    db $80

; C: OAM list A2 of the table 5272
OamList_B02_52BD_A2::
    db $17
    db $0a
    db $3d
    db $00
    db $0f
    db $0a
    db $2d
    db $00
    db $19
    db $02
    db $43
    db $00
    db $11
    db $02
    db $33
    db $00
    db $17
    db $fa
    db $3c
    db $00
    db $0f
    db $fa
    db $2c
    db $00
    db $07
    db $04
    db $38
    db $00
    db $ff
    db $04
    db $28
    db $00
    db $08
    db $fc
    db $34
    db $00
    db $07
    db $f4
    db $42
    db $00
    db $ff
    db $f4
    db $32
    db $00
    db $80

; I: OAM list A3 of the table 5272
OamList_B02_52BD_A3::
    db $16
    db $08
    db $44
    db $40

    db $80

; C: OAM list A4 of the table 5272
OamList_B02_52BD_A4::
    db $0c, $08, $45, $00
    db $80

; I: OAM list A5 of the table 5272
OamList_B02_52BD_A5::
    db $ef, $ea, $00, $00
    db $80

; I: OAM list A6 of the table 5272
OamList_B02_52BD_A6::
    db $f0, $e8, $00, $00
    db $80

; I: OAM list A7 of the table 5272
OamList_B02_52BD_A7::
    db $f0, $e4, $00, $00
    db $80

; I: OAM list A8 of the table 5272
OamList_B02_52BD_A8::
    db $10, $30, $fc, $10
    db $10, $28, $fa, $10
    db $10, $20, $f8, $10
    db $10, $18, $30, $10
    db $10, $10, $2e, $10
    db $10, $08, $2c, $10
    db $10, $00, $2a, $10
    db $10, $f8, $28, $10
    db $10, $f0, $26, $10
    db $10, $e8, $24, $10
    db $80

; I: OAM list A9 of the table 5272
OamList_B02_52BD_A9::
    db $10, $18, $3e, $10
    db $10, $10, $3c, $10
    db $10, $08, $3a, $10
    db $10, $00, $38, $10
    db $10, $f8, $36, $10
    db $10, $f0, $34, $10
    db $10, $e8, $32, $10
    db $80

; C: OAM list AA of the table 5272
OamList_B02_52BD_AA::
    db $1d, $21, $c9, $00
    db $15, $21, $c4, $00
    db $1e, $f8, $c9, $20
    db $16, $f8, $c4, $20
    db $f0, $1a, $e4, $00
    db $00, $12, $b7, $00
    db $00, $0a, $b6, $00
    db $00, $02, $b5, $00
    db $08, $18, $bb, $00
    db $08, $10, $ba, $00
    db $08, $08, $b9, $00
    db $08, $00, $b8, $00
    db $20, $18, $c8, $00
    db $20, $10, $c7, $00
    db $20, $08, $c6, $00
    db $20, $00, $c5, $00
    db $18, $18, $c3, $00
    db $18, $10, $c2, $00
    db $18, $08, $c1, $00
    db $18, $00, $c0, $00
    db $10, $18, $bf, $00
    db $10, $10, $be, $00
    db $10, $08, $bd, $00
    db $10, $00, $bc, $00
    db $f8, $17, $b4, $00
    db $f8, $0f, $b3, $00
    db $f8, $07, $b2, $00
    db $f8, $ff, $b1, $00
    db $f0, $16, $b0, $00
    db $f0, $0e, $af, $00
    db $f0, $06, $ae, $00
    db $80

; C: OAM list AB of the table 5272
OamList_B02_52BD_AB::
    db $23, $18, $e3, $00
    db $23, $10, $e2, $00
    db $23, $08, $e1, $00
    db $23, $00, $e0, $00
    db $1b, $18, $df, $00
    db $1b, $10, $de, $00
    db $1b, $08, $dd, $00
    db $1b, $00, $dc, $00
    db $13, $18, $db, $00
    db $13, $10, $da, $00
    db $13, $08, $d9, $00
    db $13, $00, $d8, $00
    db $0b, $18, $d7, $00
    db $0b, $10, $d6, $00
    db $0b, $08, $d5, $00
    db $0b, $00, $d4, $00
    db $03, $13, $d3, $00
    db $03, $0b, $d2, $00
    db $03, $03, $d1, $00
    db $fb, $19, $d0, $00
    db $fb, $11, $cf, $00
    db $fb, $09, $ce, $00
    db $fb, $01, $cd, $00
    db $f3, $14, $cc, $00
    db $f3, $0c, $cb, $00
    db $f3, $04, $ca, $00
    db $80

; C: OAM list AC of the table 5272
OamList_B02_52BD_AC::
    db $08, $00, $8b, $10
    db $00, $00, $8a, $10
    db $08, $0b, $93, $30
    db $00, $0b, $92, $30
    db $08, $f5, $93, $10
    db $00, $f5, $92, $10
    db $80

; C: OAM list AD of the table 5272
OamList_B02_52BD_AD::
    db $0b, $0b, $95, $20
    db $03, $0b, $94, $20
    db $0b, $f5, $95, $00
    db $03, $f5, $94, $00
    db $08, $00, $8b, $10
    db $00, $00, $8a, $10
    db $80

; C: OAM list AE of the table 5272
OamList_B02_52BD_AE::
    db $10, $10, $9a, $30
    db $10, $f8, $9a, $10
    db $08, $10, $99, $10
    db $08, $08, $98, $10
    db $08, $00, $97, $10
    db $08, $f8, $96, $10
    db $10, $08, $8d, $10
    db $10, $00, $8c, $10
    db $80

; C: OAM list AF of the table 5272
OamList_B02_52BD_AF::
    db $18, $e8, $9c, $10
    db $18, $28, $9d, $10
    db $18, $20, $9b, $10
    db $18, $18, $9b, $10
    db $18, $10, $9b, $10
    db $18, $08, $9b, $10
    db $18, $00, $9b, $10
    db $18, $f8, $9b, $10
    db $18, $f0, $9b, $10
    db $80

; C: OAM list B0 of the table 5272
OamList_B02_52BD_B0::
    db $18, $08, $af, $10
    db $18, $00, $ae, $10
    db $10, $08, $9f, $10
    db $10, $00, $9e, $10
    db $80

; C: OAM list B1 of the table 5272
OamList_B02_52BD_B1::
    db $10, $10, $a3, $10
    db $10, $08, $a2, $10
    db $08, $10, $a1, $10
    db $08, $08, $a0, $10
    db $80

; C: OAM list B2 of the table 5272
OamList_B02_52BD_B2::
    db $10, $18, $b1, $10
    db $10, $10, $b0, $10
    db $10, $08, $ad, $10
    db $10, $00, $ac, $10
    db $10, $f8, $ab, $10
    db $10, $f0, $aa, $10
    db $08, $18, $a9, $10
    db $08, $10, $a8, $10
    db $08, $08, $a7, $10
    db $08, $00, $a6, $10
    db $08, $f8, $a5, $10
    db $08, $f0, $a4, $10
    db $80

; C: OAM list B3 of the table 5272
OamList_B02_52BD_B3::
    db $10, $18, $bd, $00
    db $10, $10, $bc, $00
    db $10, $08, $bb, $00
    db $10, $00, $ba, $00
    db $10, $f8, $b9, $00
    db $10, $f0, $b8, $00
    db $08, $18, $b7, $00
    db $08, $10, $b6, $00
    db $08, $08, $b5, $00
    db $08, $00, $b4, $00
    db $08, $f8, $b3, $00
    db $08, $f0, $b2, $00
    db $80

; C: OAM list B4 of the table 5272
OamList_B02_52BD_B4::
    db $0c, $40, $26, $10
    db $0c, $38, $24, $10
    db $0c, $30, $22, $10
    db $0c, $28, $20, $10
    db $0c, $20, $1e, $10
    db $0c, $18, $1c, $10
    db $0c, $10, $1a, $10
    db $0c, $08, $18, $10
    db $fc, $40, $16, $10
    db $fc, $38, $14, $10
    db $fc, $30, $12, $10
    db $fc, $28, $10, $10
    db $fc, $20, $0e, $10
    db $fc, $18, $0c, $10
    db $fc, $10, $0a, $10
    db $fc, $08, $08, $10
    db $80

; C: OAM list B5 of the table 5272
OamList_B02_52BD_B5::
    db $2c, $50, $4e, $10
    db $2c, $48, $4c, $10
    db $2c, $40, $4a, $10
    db $2c, $38, $48, $10
    db $2c, $30, $46, $10
    db $2c, $28, $44, $10
    db $2c, $20, $42, $10
    db $2c, $18, $40, $10
    db $2c, $10, $3e, $10
    db $2c, $08, $3c, $10
    db $1c, $50, $3a, $10
    db $1c, $48, $38, $10
    db $1c, $40, $36, $10
    db $1c, $38, $34, $10
    db $1c, $30, $32, $10
    db $1c, $28, $30, $10
    db $1c, $20, $2e, $10
    db $1c, $18, $2c, $10
    db $1c, $10, $2a, $10
    db $1c, $08, $28, $10
    db $80

; C: OAM list B6 of the table 5272
OamList_B02_52BD_B6::
    db $0c, $18, $5a, $10
    db $0c, $10, $58, $10
    db $0c, $08, $56, $10
    db $fc, $18, $54, $10
    db $fc, $10, $52, $10
    db $fc, $08, $50, $10
    db $0c, $40, $26, $10
    db $0c, $38, $24, $10
    db $0c, $30, $22, $10
    db $0c, $28, $20, $10
    db $0c, $20, $1e, $10
    db $fc, $40, $16, $10
    db $fc, $38, $14, $10
    db $fc, $30, $12, $10
    db $fc, $28, $10, $10
    db $fc, $20, $0e, $10
    db $80

; C: OAM list B7 of the table 5272
OamList_B02_52BD_B7::
    db $2c, $18, $66, $10
    db $2c, $10, $64, $10
    db $2c, $08, $62, $10
    db $1c, $18, $60, $10
    db $1c, $10, $5e, $10
    db $1c, $08, $5c, $10
    db $2c, $50, $4e, $10
    db $2c, $48, $4c, $10
    db $2c, $40, $4a, $10
    db $2c, $38, $48, $10
    db $2c, $30, $46, $10
    db $2c, $28, $44, $10
    db $2c, $20, $42, $10
    db $1c, $50, $3a, $10
    db $1c, $48, $38, $10
    db $1c, $40, $36, $10
    db $1c, $38, $34, $10
    db $1c, $30, $32, $10
    db $1c, $28, $30, $10
    db $1c, $20, $2e, $10
    db $80

; C: OAM list B8 of the table 5272
OamList_B02_52BD_B8::
    db $dc, $f2, $00, $80
    db $dc, $fa, $02, $80
    db $dc, $02, $04, $80
    db $ec, $eb, $06, $80
    db $ec, $f3, $08, $80
    db $ec, $fb, $0a, $80
    db $ec, $03, $0c, $80
    db $fc, $e8, $0e, $80
    db $fc, $f0, $10, $80
    db $fc, $f8, $12, $80
    db $fc, $00, $14, $80
    db $fc, $08, $16, $80
    db $0c, $e8, $18, $80
    db $0c, $f0, $1a, $80
    db $0c, $f8, $1c, $80
    db $0c, $00, $1e, $80
    db $0c, $08, $20, $80
    db $1c, $f0, $22, $80
    db $1c, $f8, $24, $80
    db $1c, $00, $26, $80
    db $2c, $f3, $28, $80
    db $2c, $fb, $2a, $80
    db $3c, $f1, $2c, $80
    db $3c, $f9, $2e, $80
    db $3c, $01, $30, $80
    db $4c, $fa, $32, $80
    db $80

; C: OAM list B9 of the table 5272
OamList_B02_52BD_B9::
    db $d3, $fb, $00, $80
    db $d3, $03, $02, $80
    db $d3, $0b, $04, $80
    db $e3, $dc, $06, $80
    db $e3, $e4, $08, $80
    db $e3, $ec, $0a, $80
    db $e3, $f4, $0c, $80
    db $e3, $fc, $0e, $80
    db $e3, $04, $10, $80
    db $e3, $0c, $12, $80
    db $e3, $14, $14, $80
    db $e3, $1c, $16, $80
    db $e3, $24, $18, $80
    db $f3, $dd, $1c, $80
    db $f3, $e5, $1e, $80
    db $f3, $ed, $20, $80
    db $f3, $f5, $22, $80
    db $f3, $fd, $24, $80
    db $f3, $05, $26, $80
    db $03, $f5, $28, $80
    db $03, $fd, $2a, $80
    db $03, $05, $2c, $80
    db $13, $f0, $2e, $80
    db $13, $f8, $30, $80
    db $13, $00, $32, $80
    db $23, $ef, $34, $80
    db $23, $f7, $36, $80
    db $23, $ff, $38, $80
    db $33, $f3, $3a, $80
    db $33, $fb, $3c, $80
    db $33, $03, $3e, $80
    db $33, $0b, $40, $80
    db $43, $f7, $42, $80
    db $43, $ff, $44, $80
    db $43, $07, $46, $80
    db $80

; C: OAM list BA of the table 5272
OamList_B02_52BD_BA::
    db $da, $ea, $00, $80
    db $da, $f2, $02, $80
    db $da, $fa, $04, $80
    db $da, $02, $06, $80
    db $da, $0a, $08, $80
    db $da, $12, $0a, $80
    db $ea, $cf, $0c, $80
    db $ea, $d7, $0e, $80
    db $ea, $df, $10, $80
    db $ea, $e7, $12, $80
    db $ea, $ef, $14, $80
    db $ea, $f7, $16, $80
    db $ea, $ff, $18, $80
    db $ea, $07, $1a, $80
    db $ea, $0f, $1c, $80
    db $fa, $ea, $1e, $80
    db $fa, $f2, $20, $80
    db $fa, $fa, $22, $80
    db $fa, $02, $24, $80
    db $0a, $e4, $26, $80
    db $0a, $ec, $28, $80
    db $0a, $f4, $2a, $80
    db $0a, $fc, $2c, $80
    db $0a, $04, $2e, $80
    db $1a, $e4, $30, $80
    db $1a, $ec, $32, $80
    db $1a, $f4, $34, $80
    db $1a, $fc, $36, $80
    db $1a, $04, $38, $80
    db $2a, $e9, $3a, $80
    db $2a, $f5, $3c, $80
    db $2a, $fd, $3e, $80
    db $3a, $f3, $40, $80
    db $3a, $fb, $42, $80
    db $4a, $f4, $44, $80
    db $80

; C: OAM list BB of the table 5272
OamList_B02_52BD_BB::
    db $48, $ff, $26, $80
    db $c8, $0c, $00, $80
    db $c8, $14, $02, $80
    db $d8, $f6, $04, $80
    db $d8, $fe, $06, $80
    db $d8, $06, $08, $80
    db $d8, $0e, $0a, $80
    db $e8, $eb, $0c, $80
    db $e8, $f3, $0e, $80
    db $e8, $fb, $10, $80
    db $e8, $03, $12, $80
    db $e8, $0b, $14, $80
    db $f9, $d3, $16, $80
    db $f9, $db, $18, $80
    db $f8, $e3, $1a, $80
    db $f8, $eb, $1c, $80
    db $f8, $f3, $1e, $80
    db $f8, $fb, $20, $80
    db $f8, $03, $22, $80
    db $f8, $0b, $24, $80
    db $08, $e6, $28, $80
    db $08, $ee, $2a, $80
    db $08, $f6, $2c, $80
    db $08, $fe, $2e, $80
    db $08, $06, $30, $80
    db $08, $0e, $32, $80
    db $18, $dc, $34, $80
    db $18, $e4, $36, $80
    db $18, $ec, $38, $80
    db $18, $f4, $3a, $80
    db $18, $fc, $3c, $80
    db $18, $04, $3e, $80
    db $28, $d4, $40, $80
    db $28, $dc, $42, $80
    db $28, $e4, $44, $80
    db $28, $fb, $46, $80
    db $28, $03, $48, $80
    db $38, $f9, $4a, $80
    db $38, $01, $4c, $80
    db $48, $f7, $4e, $80
    db $80

; C: OAM list BC of the table 5272
OamList_B02_52BD_BC::
    db $d9, $e1, $00, $80
    db $d9, $e9, $02, $80
    db $d9, $f1, $04, $80
    db $d9, $f9, $06, $80
    db $d9, $01, $08, $80
    db $e9, $e1, $0a, $80
    db $e9, $e9, $0c, $80
    db $e9, $f1, $0e, $80
    db $e9, $f9, $10, $80
    db $e9, $01, $12, $80
    db $e9, $09, $14, $80
    db $e9, $11, $16, $80
    db $f9, $ec, $18, $80
    db $f9, $f4, $1a, $80
    db $f9, $fc, $1c, $80
    db $f9, $04, $1e, $80
    db $f9, $0c, $20, $80
    db $f9, $14, $22, $80
    db $09, $f0, $24, $80
    db $09, $f8, $26, $80
    db $09, $00, $28, $80
    db $09, $08, $2a, $80
    db $09, $10, $2c, $80
    db $19, $eb, $2e, $80
    db $19, $f3, $30, $80
    db $19, $fb, $32, $80
    db $19, $03, $34, $80
    db $19, $0b, $36, $80
    db $29, $e8, $38, $80
    db $29, $f0, $3a, $80
    db $29, $00, $3c, $80
    db $29, $08, $3e, $80
    db $39, $ea, $40, $80
    db $39, $f2, $42, $80
    db $39, $00, $44, $80
    db $39, $08, $46, $80
    db $49, $ed, $48, $80
    db $49, $f5, $4a, $80
    db $49, $00, $4c, $80
    db $49, $08, $4e, $80
    db $80

; C: OAM list BD of the table 5272
OamList_B02_52BD_BD::
    db $cd, $fe, $00, $80
    db $cd, $06, $02, $80
    db $cd, $0e, $04, $80
    db $dd, $fa, $06, $80
    db $dd, $02, $08, $80
    db $dd, $0a, $0a, $80
    db $dd, $12, $0c, $80
    db $ed, $fb, $0e, $80
    db $ed, $03, $10, $80
    db $ed, $0b, $12, $80
    db $ed, $13, $14, $80
    db $fd, $f9, $16, $80
    db $fd, $01, $18, $80
    db $fd, $09, $1a, $80
    db $fd, $11, $1c, $80
    db $0d, $f4, $1e, $80
    db $0d, $fc, $20, $80
    db $0d, $04, $22, $80
    db $0d, $0c, $24, $80
    db $1d, $e9, $26, $80
    db $1d, $f1, $28, $80
    db $1d, $f9, $2a, $80
    db $1d, $01, $2c, $80
    db $1d, $09, $2e, $80
    db $2d, $e7, $30, $80
    db $2d, $ef, $32, $80
    db $2d, $03, $34, $80
    db $2d, $0b, $36, $80
    db $3d, $e2, $38, $80
    db $3d, $ea, $3a, $80
    db $3d, $00, $3c, $80
    db $3d, $08, $3e, $80
    db $4d, $df, $40, $80
    db $4d, $e7, $42, $80
    db $4d, $01, $44, $80
    db $4d, $09, $46, $80
    db $80

; C: OAM list BE of the table 5272
OamList_B02_52BD_BE::
    db $d7, $e3, $00, $80
    db $d7, $eb, $02, $80
    db $d7, $f3, $04, $80
    db $d7, $fb, $06, $80
    db $e7, $e3, $08, $80
    db $e7, $eb, $0a, $80
    db $e7, $f3, $0c, $80
    db $e7, $fb, $0e, $80
    db $f7, $dc, $10, $80
    db $f7, $e4, $12, $80
    db $f7, $ec, $14, $80
    db $f7, $f4, $16, $80
    db $f7, $fc, $18, $80
    db $07, $ca, $1a, $80
    db $07, $d2, $1c, $80
    db $07, $da, $1e, $80
    db $07, $e2, $20, $80
    db $07, $ea, $22, $80
    db $07, $f2, $24, $80
    db $07, $fa, $26, $80
    db $17, $e5, $28, $80
    db $17, $ed, $2a, $80
    db $17, $f5, $2c, $80
    db $17, $fd, $2e, $80
    db $27, $e7, $30, $80
    db $27, $ef, $32, $80
    db $27, $f7, $34, $80
    db $27, $ff, $36, $80
    db $37, $e4, $38, $80
    db $37, $ec, $3a, $80
    db $37, $f4, $3c, $80
    db $37, $fc, $3e, $80
    db $47, $e2, $40, $80
    db $47, $ea, $42, $80
    db $47, $f2, $44, $80
    db $47, $fa, $46, $80
    db $80

; C: OAM list BF of the table 5272
OamList_B02_52BD_BF::
    db $d3, $ef, $00, $80
    db $d3, $f7, $02, $80
    db $d3, $ff, $04, $80
    db $d3, $07, $06, $80
    db $e3, $ef, $08, $80
    db $e3, $f7, $0a, $80
    db $e3, $ff, $0c, $80
    db $e3, $07, $0e, $80
    db $f3, $ef, $10, $80
    db $f3, $f7, $12, $80
    db $f3, $ff, $14, $80
    db $f3, $07, $16, $80
    db $03, $ee, $18, $80
    db $03, $f6, $1a, $80
    db $03, $fe, $1c, $80
    db $03, $06, $1e, $80
    db $03, $0e, $20, $80
    db $03, $16, $22, $80
    db $03, $1e, $24, $80
    db $13, $f0, $26, $80
    db $13, $f8, $28, $80
    db $13, $00, $2a, $80
    db $13, $08, $2c, $80
    db $23, $f6, $2e, $80
    db $23, $fe, $30, $80
    db $23, $06, $32, $80
    db $23, $0e, $34, $80
    db $33, $f5, $36, $80
    db $33, $fd, $38, $80
    db $33, $06, $3a, $80
    db $33, $0e, $3c, $80
    db $43, $f3, $3e, $80
    db $43, $fb, $40, $80
    db $43, $08, $42, $80
    db $43, $10, $44, $80
    db $80

; C: OAM list C0 of the table 5272
OamList_B02_52BD_C0::
    db $e4, $e1, $00, $80
    db $e4, $e9, $02, $80
    db $e4, $f1, $04, $80
    db $e4, $f9, $06, $80
    db $f4, $e1, $08, $80
    db $f4, $e9, $0a, $80
    db $f4, $f1, $0c, $80
    db $f4, $f9, $0e, $80
    db $f4, $01, $10, $80
    db $f4, $09, $12, $80
    db $04, $d8, $14, $80
    db $04, $e0, $16, $80
    db $04, $e8, $18, $80
    db $04, $f0, $1a, $80
    db $04, $f8, $1c, $80
    db $04, $00, $1e, $80
    db $04, $08, $20, $80
    db $14, $e9, $22, $80
    db $14, $f1, $24, $80
    db $14, $f9, $26, $80
    db $14, $01, $28, $80
    db $24, $e9, $2a, $80
    db $24, $f1, $2c, $80
    db $24, $f9, $2e, $80
    db $24, $01, $30, $80
    db $34, $ea, $32, $80
    db $34, $f2, $34, $80
    db $34, $fa, $36, $80
    db $34, $02, $38, $80
    db $44, $ec, $3a, $80
    db $44, $f4, $3c, $80
    db $44, $fc, $3e, $80
    db $80

; C: OAM list C1 of the table 5272
OamList_B02_52BD_C1::
    db $cb, $ea, $00, $80
    db $cb, $f2, $02, $80
    db $cb, $fa, $04, $80
    db $db, $ec, $06, $80
    db $db, $f4, $08, $80
    db $db, $fc, $0a, $80
    db $db, $04, $0c, $80
    db $eb, $ee, $0e, $80
    db $eb, $f6, $10, $80
    db $eb, $fe, $12, $80
    db $eb, $06, $14, $80
    db $eb, $0e, $16, $80
    db $fb, $f4, $18, $80
    db $fb, $fc, $1a, $80
    db $fb, $04, $1c, $80
    db $fb, $0c, $1e, $80
    db $fb, $14, $20, $80
    db $0b, $f4, $22, $80
    db $0b, $fc, $24, $80
    db $0b, $04, $26, $80
    db $0b, $0c, $28, $80
    db $0b, $14, $2a, $80
    db $1b, $eb, $2c, $80
    db $1b, $f3, $2e, $80
    db $1b, $fb, $30, $80
    db $1b, $03, $32, $80
    db $1b, $0b, $34, $80
    db $2b, $e8, $36, $80
    db $2b, $f0, $38, $80
    db $2b, $08, $3a, $80
    db $2b, $10, $3c, $80
    db $3b, $e9, $3e, $80
    db $3b, $f1, $40, $80
    db $3b, $0e, $42, $80
    db $3b, $16, $44, $80
    db $4b, $e7, $46, $80
    db $4b, $0e, $48, $80
    db $4b, $16, $4a, $80
    db $80

; C: OAM list C2 of the table 5272
OamList_B02_52BD_C2::
    db $d7, $e3, $00, $80
    db $d7, $eb, $02, $80
    db $d7, $f3, $04, $80
    db $d7, $fb, $06, $80
    db $e7, $e8, $08, $80
    db $e7, $f0, $0a, $80
    db $e7, $f8, $0c, $80
    db $e7, $00, $0e, $80
    db $f7, $e8, $10, $80
    db $f7, $f0, $12, $80
    db $f7, $f8, $14, $80
    db $f7, $00, $16, $80
    db $07, $e6, $18, $80
    db $07, $ee, $1a, $80
    db $07, $f6, $1c, $80
    db $07, $fe, $1e, $80
    db $17, $e5, $20, $80
    db $17, $ed, $22, $80
    db $17, $f5, $24, $80
    db $17, $fd, $26, $80
    db $17, $05, $28, $80
    db $27, $e6, $2a, $80
    db $27, $ee, $2c, $80
    db $27, $f9, $2e, $80
    db $27, $01, $30, $80
    db $27, $09, $32, $80
    db $37, $e7, $34, $80
    db $37, $ef, $36, $80
    db $37, $02, $38, $80
    db $37, $0a, $3a, $80
    db $37, $12, $3c, $80
    db $47, $e8, $3e, $80
    db $47, $f0, $40, $80
    db $47, $0b, $42, $80
    db $47, $13, $44, $80
    db $80

; C: OAM list C3 of the table 5272
OamList_B02_52BD_C3::
    db $da, $e3, $00, $80
    db $da, $eb, $02, $80
    db $da, $f3, $04, $80
    db $da, $fb, $06, $80
    db $da, $03, $08, $80
    db $da, $0b, $0a, $80
    db $ea, $e0, $0c, $80
    db $ea, $e8, $0e, $80
    db $ea, $f0, $10, $80
    db $ea, $f8, $12, $80
    db $ea, $00, $14, $80
    db $ea, $08, $16, $80
    db $ea, $10, $18, $80
    db $fa, $ec, $1a, $80
    db $fa, $f4, $1c, $80
    db $fa, $fc, $1e, $80
    db $fa, $04, $20, $80
    db $0a, $ed, $22, $80
    db $0a, $f5, $24, $80
    db $0a, $fd, $26, $80
    db $0a, $05, $28, $80
    db $1a, $ea, $2a, $80
    db $1a, $f2, $2c, $80
    db $1a, $fb, $2e, $80
    db $1a, $03, $30, $80
    db $2a, $e8, $32, $80
    db $2a, $f0, $34, $80
    db $2a, $00, $36, $80
    db $2a, $08, $38, $80
    db $3a, $e6, $3a, $80
    db $3a, $ee, $3c, $80
    db $3a, $03, $3e, $80
    db $3a, $0b, $40, $80
    db $4a, $08, $42, $80
    db $80

; C: OAM list C4 of the table 5272
OamList_B02_52BD_C4::
    db $d3, $eb, $00, $80
    db $d3, $f3, $02, $80
    db $d3, $fb, $04, $80
    db $e3, $de, $06, $80
    db $e3, $e6, $08, $80
    db $e3, $ee, $0a, $80
    db $e3, $f6, $0c, $80
    db $e3, $fe, $0e, $80
    db $e3, $06, $10, $80
    db $f3, $df, $12, $80
    db $f3, $e7, $14, $80
    db $f3, $ef, $16, $80
    db $f3, $f7, $18, $80
    db $f3, $ff, $1a, $80
    db $f3, $07, $1c, $80
    db $03, $e9, $1e, $80
    db $03, $f1, $20, $80
    db $03, $f9, $22, $80
    db $03, $01, $24, $80
    db $03, $09, $26, $80
    db $13, $eb, $28, $80
    db $13, $f3, $2a, $80
    db $13, $fb, $2c, $80
    db $23, $ed, $2e, $80
    db $23, $f5, $30, $80
    db $23, $fd, $32, $80
    db $33, $ee, $34, $80
    db $33, $f6, $36, $80
    db $33, $fe, $38, $80
    db $43, $f2, $3a, $80
    db $80

; I: OAM list C5 of the table 5272
OamList_B02_52BD_C5::
    db $26, $f6, $5f, $10
    db $26, $ee, $5e, $10
    db $26, $16, $63, $10
    db $26, $0e, $62, $10
    db $26, $06, $61, $10
    db $26, $fe, $60, $10
    db $1e, $16, $5d, $10
    db $1e, $0e, $5c, $10
    db $1e, $06, $5b, $10
    db $1e, $fe, $5a, $10
    db $1e, $f6, $59, $10
    db $1e, $ee, $58, $10
    db $13, $0e, $57, $10
    db $13, $06, $56, $10
    db $13, $fe, $55, $10
    db $0b, $0e, $54, $10
    db $0b, $06, $53, $10
    db $0b, $fe, $52, $10
    db $13, $f6, $51, $30
    db $13, $ee, $51, $10
    db $0b, $ee, $50, $10
    db $0b, $f6, $50, $30
    db $80

; C: OAM list C6 of the table 5272
OamList_B02_52BD_C6::
    db $10, $08, $71, $10
    db $10, $00, $70, $10
    db $08, $08, $6f, $10
    db $08, $00, $6e, $10
    db $80

; C: OAM list C7 of the table 5272
OamList_B02_52BD_C7::
    db $08, $08, $6b, $10
    db $08, $00, $6a, $10
    db $10, $08, $6d, $10
    db $10, $00, $6c, $10
    db $80

; C: OAM list C8 of the table 5272
OamList_B02_52BD_C8::
    db $f8, $20, $75, $10
    db $f8, $18, $74, $10
    db $f8, $10, $73, $10
    db $f8, $08, $72, $10
    db $f8, $00, $71, $10
    db $f8, $f8, $70, $10
    db $f8, $f0, $6f, $10
    db $f8, $e8, $6e, $10
    db $f0, $20, $6d, $10
    db $f0, $18, $6c, $10
    db $f0, $10, $6b, $10
    db $f0, $08, $6a, $10
    db $f0, $00, $69, $10
    db $f0, $f8, $68, $10
    db $f0, $f0, $67, $10
    db $f0, $e8, $66, $10
    db $f0, $28, $64, $10
    db $f8, $28, $65, $10
    db $80

; C: OAM list C9 of the table 5272
OamList_B02_52BD_C9::
    db $f0, $28, $64, $10
    db $f0, $20, $64, $10
    db $f8, $28, $65, $10
    db $f8, $20, $65, $10
    db $f8, $18, $73, $10
    db $f8, $10, $72, $10
    db $f8, $08, $71, $10
    db $f8, $00, $70, $10
    db $f8, $f8, $6f, $10
    db $f8, $f0, $6e, $10
    db $f8, $e8, $6d, $10
    db $f0, $18, $6c, $10
    db $f0, $10, $6b, $10
    db $f0, $08, $6a, $10
    db $f0, $00, $69, $10
    db $f0, $f8, $68, $10
    db $f0, $f0, $67, $10
    db $f0, $e8, $66, $10
    db $80

; C: OAM list CA of the table 5272
OamList_B02_52BD_CA::
    db $f0, $e0, $f4, $10
    db $e8, $e8, $f3, $10
    db $e8, $e0, $f2, $10
    db $e0, $e8, $f1, $10
    db $e0, $e0, $f0, $10
    db $80

; I: 122 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B02_6E4B (00:2464)
OamPtrTbl_B02_6F16::
    dw OamList_B02_6F16_00
    dw OamList_B02_6F16_01
    dw OamList_B02_6F16_02
    dw OamList_B02_6F16_03
    dw OamList_B02_6F16_04
    dw OamList_B02_6F16_05
    dw OamList_B02_6F16_06
    dw OamList_B02_6F16_07
    dw OamList_B02_6F16_08
    dw OamList_B02_6F16_09
    dw OamList_B02_6F16_0A
    dw OamList_B02_6F16_0B
    dw OamList_B02_6F16_0C
    dw OamList_B02_6F16_0D
    dw OamList_B02_6F16_0E
    dw OamList_B02_6F16_0F
    dw OamList_B02_6F16_10
    dw OamList_B02_6F16_11
    dw OamList_B02_6F16_12
    dw OamList_B02_6F16_13
    dw OamList_B02_6F16_14
    dw OamList_B02_6F16_15
    dw OamList_B02_6F16_16
    dw OamList_B02_6F16_17
    dw OamList_B02_6F16_18
    dw OamList_B02_6F16_19
    dw OamList_B02_6F16_1A
    dw OamList_B02_6F16_1B
    dw OamList_B02_6F16_1C
    dw OamList_B02_6F16_1D
    dw OamList_B02_6F16_1E
    dw OamList_B02_6F16_1F
    dw OamList_B02_6F16_20
    dw OamList_B02_6F16_21
    dw OamList_B02_6F16_22
    dw OamList_B02_6F16_23
    dw OamList_B02_6F16_24
    dw OamList_B02_6F16_25
    dw OamList_B02_6F16_26
    dw OamList_B02_6F16_27
    dw OamList_B02_6F16_28
    dw OamList_B02_6F16_29
    dw OamList_B02_6F16_2A
    dw OamList_B02_6F16_2B
    dw OamList_B02_6F16_2C
    dw OamList_B02_6F16_2D
    dw OamList_B02_6F16_2E
    dw OamList_B02_6F16_2F
    dw OamList_B02_6F16_30
    dw OamList_B02_6F16_31
    dw OamList_B02_6F16_32
    dw OamList_B02_6F16_33
    dw OamList_B02_6F16_34
    dw OamList_B02_6F16_35
    dw OamList_B02_6F16_36
    dw OamList_B02_6F16_37
    dw OamList_B02_6F16_38
    dw OamList_B02_6F16_39
    dw OamList_B02_6F16_3A
    dw OamList_B02_6F16_3B
    dw OamList_B02_6F16_3C
    dw OamList_B02_6F16_3D
    dw OamList_B02_6F16_3E
    dw OamList_B02_6F16_3F
    dw OamList_B02_6F16_40
    dw OamList_B02_6F16_41
    dw OamList_B02_6F16_42
    dw OamList_B02_6F16_43
    dw OamList_B02_6F16_44
    dw OamList_B02_6F16_45
    dw OamList_B02_6F16_46
    dw OamList_B02_6F16_47
    dw OamList_B02_6F16_48
    dw OamList_B02_6F16_49
    dw OamList_B02_6F16_4A
    dw OamList_B02_6F16_4B
    dw OamList_B02_6F16_4C
    dw OamList_B02_6F16_4D
    dw OamList_B02_6F16_4E
    dw OamList_B02_6F16_4F
    dw OamList_B02_6F16_50
    dw OamList_B02_6F16_51
    dw OamList_B02_6F16_52
    dw OamList_B02_6F16_53
    dw OamList_B02_6F16_54
    dw OamList_B02_6F16_55
    dw OamList_B02_6F16_56
    dw OamList_B02_6F16_57
    dw OamList_B02_6F16_58
    dw OamList_B02_6F16_59
    dw OamList_B02_6F16_5A
    dw OamList_B02_6F16_5B
    dw OamList_B02_6F16_5C
    dw OamList_B02_6F16_5D
    dw OamList_B02_6F16_5E
    dw OamList_B02_6F16_5F
    dw OamList_B02_6F16_60
    dw OamList_B02_6F16_61
    dw OamList_B02_6F16_62
    dw OamList_B02_6F16_63
    dw OamList_B02_6F16_64
    dw OamList_B02_6F16_65
    dw OamList_B02_6F16_66
    dw OamList_B02_6F16_67
    dw OamList_B02_6F16_68
    dw OamList_B02_6F16_69
    dw OamList_B02_6F16_6A
    dw OamList_B02_6F16_6B
    dw OamList_B02_6F16_6C
    dw OamList_B02_6F16_6D
    dw OamList_B02_6F16_6E
    dw OamList_B02_6F16_6F
    dw OamList_B02_6F16_70
    dw OamList_B02_6F16_71
    dw OamList_B02_6F16_72
    dw OamList_B02_6F16_73
    dw OamList_B02_6F16_74
    dw OamList_B02_6F16_75
    dw OamList_B02_6F16_76
    dw OamList_B02_6F16_77

; C: OAM list 00 of the table 6E4B
OamList_B02_6F16_00::
    db $10, $08, $de, $10
    db $10, $00, $dd, $10
    db $80

; C: OAM list 01 of the table 6E4B
OamList_B02_6F16_01::
    db $08, $08, $de, $50
    db $08, $00, $dd, $50
    db $80

; C: OAM list 02 of the table 6E4B
OamList_B02_6F16_02::
    db $18, $40, $cf, $10
    db $10, $40, $bf, $10
    db $18, $08, $cf, $10
    db $10, $08, $bf, $10
    db $80

; C: OAM list 03 of the table 6E4B
OamList_B02_6F16_03::
    db $18, $40, $dc, $10
    db $10, $40, $db, $10
    db $18, $08, $dc, $10
    db $10, $08, $db, $10
    db $80

; C: OAM list 04 of the table 6E4B
OamList_B02_6F16_04::
    db $10, $2b, $d0, $10
    db $10, $08, $d0, $10
    db $80

; C: OAM list 05 of the table 6E4B
OamList_B02_6F16_05::
    db $10, $2b, $d1, $10
    db $10, $08, $d1, $10
    db $80

; C: OAM list 06 of the table 6E4B
OamList_B02_6F16_06::
    db $0f, $2b, $d0, $50
    db $0f, $08, $d0, $50
    db $80

; C: OAM list 07 of the table 6E4B
OamList_B02_6F16_07::
    db $10, $2b, $d2, $10
    db $10, $08, $d2, $10
    db $80

; C: OAM list 08 of the table 6E4B
OamList_B02_6F16_08::
    db $18, $10, $da, $10
    db $18, $08, $d9, $10
    db $10, $10, $d8, $10
    db $10, $08, $d7, $10
    db $80

; C: OAM list 09 of the table 6E4B
OamList_B02_6F16_09::
    db $18, $10, $d6, $10
    db $18, $08, $d5, $10
    db $10, $10, $d4, $10
    db $10, $08, $d3, $10
    db $80

; C: OAM list 0A of the table 6E4B
OamList_B02_6F16_0A::
    db $10, $10, $da, $50
    db $10, $08, $d9, $50
    db $18, $10, $d8, $50
    db $18, $08, $d7, $50
    db $80

; C: OAM list 0B of the table 6E4B
OamList_B02_6F16_0B::
    db $10, $10, $d6, $50
    db $10, $08, $d5, $50
    db $18, $10, $d4, $50
    db $18, $08, $d3, $50
    db $80

; I: OAM list 0C of the table 6E4B
OamList_B02_6F16_0C::
    db $10, $08, $24, $10
    db $08, $08, $20, $10
    db $80

; I: OAM list 0D of the table 6E4B
OamList_B02_6F16_0D::
    db $08, $08, $21, $10
    db $80

; I: OAM list 0E of the table 6E4B
OamList_B02_6F16_0E::
    db $08, $08, $22, $10
    db $80

; I: OAM list 0F of the table 6E4B
OamList_B02_6F16_0F::
    db $08, $08, $23, $10
    db $80

; I: OAM list 10 of the table 6E4B
OamList_B02_6F16_10::
    db $03, $18, $dc, $00
    db $fa, $fd, $d0, $00
    db $0b, $fd, $d6, $00
    db $fb, $10, $da, $00
    db $03, $05, $d4, $00
    db $fb, $0d, $d8, $00
    db $f3, $05, $d2, $00
    db $80

; I: OAM list 11 of the table 6E4B
OamList_B02_6F16_11::
    db $fd, $13, $e2, $00
    db $09, $0b, $e6, $00
    db $09, $03, $e4, $00
    db $f9, $0b, $e0, $00
    db $f9, $03, $de, $00
    db $80

; I: OAM list 12 of the table 6E4B
OamList_B02_6F16_12::
    db $f3, $ff, $e8, $00
    db $03, $0f, $ee, $00
    db $fb, $07, $ec, $00
    db $eb, $07, $ea, $00
    db $80

; I: OAM list 13 of the table 6E4B
OamList_B02_6F16_13::
    db $f9, $11, $fa, $00
    db $f9, $19, $fc, $00
    db $00, $01, $f4, $00
    db $f0, $11, $f8, $00
    db $f8, $09, $f6, $00
    db $f0, $01, $f2, $00
    db $f0, $f9, $f0, $00
    db $80

; I: OAM list 14 of the table 6E4B
OamList_B02_6F16_14::
    db $fc, $08, $04, $20
    db $fc, $10, $02, $20
    db $ec, $08, $00, $20
    db $ec, $10, $fe, $20
    db $fc, $00, $04, $00
    db $fc, $f8, $02, $00
    db $ec, $00, $00, $00
    db $ec, $f8, $fe, $00
    db $80

; I: OAM list 15 of the table 6E4B
OamList_B02_6F16_15::
    db $fe, $08, $0c, $20
    db $fe, $10, $0a, $20
    db $ee, $08, $08, $20
    db $ee, $10, $06, $20
    db $fe, $00, $0c, $00
    db $fe, $f8, $0a, $00
    db $ee, $00, $08, $00
    db $ee, $f8, $06, $00
    db $80

; I: OAM list 16 of the table 6E4B
OamList_B02_6F16_16::
    db $02, $08, $10, $20
    db $f2, $08, $0e, $20
    db $02, $00, $10, $00
    db $f2, $00, $0e, $00
    db $80

; I: OAM list 17 of the table 6E4B
OamList_B02_6F16_17::
    db $fd, $0c, $18, $20
    db $ed, $0c, $14, $20
    db $ed, $14, $12, $20
    db $fd, $fc, $18, $00
    db $f5, $04, $16, $00
    db $ed, $fc, $14, $00
    db $ed, $f4, $12, $00
    db $80

; I: OAM list 18 of the table 6E4B
OamList_B02_6F16_18::
    db $00, $00, $ae, $10
    db $00, $f8, $ac, $10
    db $80

; I: OAM list 19 of the table 6E4B
OamList_B02_6F16_19::
    db $f8, $00, $b0, $10
    db $00, $00, $ae, $10
    db $00, $f8, $ac, $10
    db $80

; I: OAM list 1A of the table 6E4B
OamList_B02_6F16_1A::
    db $00, $fb, $ae, $10
    db $00, $f3, $ac, $10
    db $80

; I: OAM list 1B of the table 6E4B
OamList_B02_6F16_1B::
    db $00, $f3, $28, $10
    db $0b, $eb, $26, $10
    db $0b, $e3, $24, $10
    db $80

; I: OAM list 1C of the table 6E4B
OamList_B02_6F16_1C::
    db $00, $0c, $2e, $10
    db $00, $04, $2c, $10
    db $f8, $fc, $2a, $10
    db $80

; I: OAM list 1D of the table 6E4B
OamList_B02_6F16_1D::
    db $fa, $0a, $34, $10
    db $fa, $02, $32, $10
    db $fa, $fa, $30, $10
    db $80

; I: OAM list 1E of the table 6E4B
OamList_B02_6F16_1E::
    db $01, $0a, $3a, $10
    db $f9, $02, $38, $10
    db $f9, $fa, $36, $10
    db $80

; I: OAM list 1F of the table 6E4B
OamList_B02_6F16_1F::
    db $f7, $fa, $50, $10
    db $ff, $02, $52, $10
    db $ff, $0a, $54, $10
    db $80

; I: OAM list 20 of the table 6E4B
OamList_B02_6F16_20::
    db $fc, $40, $5c, $10
    db $fc, $30, $5a, $10
    db $fc, $38, $44, $10
    db $fc, $28, $40, $10
    db $00, $20, $66, $10
    db $00, $18, $64, $10
    db $00, $10, $62, $10
    db $00, $08, $60, $10
    db $80

; I: OAM list 21 of the table 6E4B
OamList_B02_6F16_21::
    db $fc, $40, $44, $10
    db $fc, $38, $5a, $10
    db $fc, $28, $56, $10
    db $fc, $30, $58, $10
    db $00, $20, $76, $10
    db $00, $18, $74, $10
    db $00, $10, $72, $10
    db $00, $08, $70, $10
    db $80

; I: OAM list 22 of the table 6E4B
OamList_B02_6F16_22::
    db $fc, $3d, $44, $10
    db $fc, $38, $7c, $10
    db $fc, $30, $7a, $10
    db $fc, $28, $78, $10
    db $00, $20, $6e, $10
    db $00, $18, $6c, $10
    db $00, $10, $6a, $10
    db $00, $08, $68, $10
    db $80

; I: OAM list 23 of the table 6E4B
OamList_B02_6F16_23::
    db $00, $14, $5e, $00
    db $00, $0c, $5e, $00
    db $00, $04, $5e, $00
    db $00, $fc, $5e, $00
    db $00, $f4, $5e, $00
    db $80

; I: OAM list 24 of the table 6E4B
OamList_B02_6F16_24::
    db $00, $14, $46, $00
    db $00, $0c, $46, $00
    db $00, $04, $46, $00
    db $00, $fc, $46, $00
    db $00, $f4, $46, $00
    db $80

; I: OAM list 25 of the table 6E4B
OamList_B02_6F16_25::
    db $00, $14, $cc, $00
    db $00, $0c, $ca, $00
    db $00, $04, $4e, $00
    db $00, $fc, $4c, $00
    db $00, $f4, $4a, $00
    db $80

; I: OAM list 26 of the table 6E4B
OamList_B02_6F16_26::
    db $08, $16, $22, $00
    db $08, $0e, $20, $00
    db $08, $06, $1e, $00
    db $08, $fe, $1c, $00
    db $08, $f6, $1a, $00
    db $80

; I: OAM list 27 of the table 6E4B
OamList_B02_6F16_27::
    db $00, $1a, $22, $00
    db $00, $12, $20, $00
    db $00, $0a, $1e, $00
    db $00, $02, $1c, $00
    db $00, $fa, $1a, $00
    db $80

; I: OAM list 28 of the table 6E4B
OamList_B02_6F16_28::
    db $03, $17, $22, $00
    db $03, $0f, $20, $00
    db $03, $07, $1e, $00
    db $03, $ff, $1c, $00
    db $03, $f7, $1a, $00
    db $80

; I: OAM list 29 of the table 6E4B
OamList_B02_6F16_29::
    db $fb, $1f, $7e, $00
    db $80

; I: OAM list 2A of the table 6E4B
OamList_B02_6F16_2A::
    db $d3, $19, $c6, $10
    db $d3, $11, $be, $10
    db $d3, $09, $bc, $10
    db $00, $01, $c2, $10
    db $f0, $01, $c2, $10
    db $e0, $01, $c2, $10
    db $d0, $01, $c0, $10
    db $80

; I: OAM list 2B of the table 6E4B
OamList_B02_6F16_2B::
    db $d3, $19, $22, $10
    db $d3, $11, $20, $10
    db $d3, $09, $c8, $10
    db $00, $01, $c2, $10
    db $f0, $01, $c2, $10
    db $e0, $01, $c2, $10
    db $d0, $01, $c0, $10
    db $80

; I: OAM list 2C of the table 6E4B
OamList_B02_6F16_2C::
    db $d3, $19, $1e, $10
    db $d3, $11, $1c, $10
    db $d3, $09, $1a, $10
    db $00, $01, $c2, $10
    db $f0, $01, $c2, $10
    db $e0, $01, $c2, $10
    db $d0, $01, $c0, $10
    db $80

; I: OAM list 2D of the table 6E4B
OamList_B02_6F16_2D::
    db $e1, $0f, $3c, $00
    db $f2, $10, $3e, $00
    db $80

; I: OAM list 2E of the table 6E4B
OamList_B02_6F16_2E::
    db $df, $13, $3c, $00
    db $f1, $14, $3e, $00
    db $80

; I: OAM list 2F of the table 6E4B
OamList_B02_6F16_2F::
    db $dd, $17, $3c, $00
    db $f2, $1b, $3e, $00
    db $80

; I: OAM list 30 of the table 6E4B
OamList_B02_6F16_30::
    db $fc, $30, $42, $10
    db $fc, $28, $c4, $10
    db $00, $20, $66, $10
    db $00, $18, $64, $10
    db $00, $10, $62, $10
    db $00, $08, $60, $10
    db $80

; I: OAM list 31 of the table 6E4B
OamList_B02_6F16_31::
    db $13, $30, $ba, $00
    db $13, $28, $b8, $00
    db $13, $20, $48, $00
    db $13, $18, $b6, $00
    db $13, $10, $b4, $00
    db $80

; I: OAM list 32 of the table 6E4B
OamList_B02_6F16_32::
    db $20, $00, $ac, $10
    db $20, $f8, $ab, $10
    db $20, $f0, $aa, $10
    db $18, $00, $a9, $10
    db $18, $f8, $a8, $10
    db $18, $f0, $a7, $10
    db $10, $00, $a6, $10
    db $10, $f8, $a5, $10
    db $10, $f0, $a4, $10
    db $80

; I: OAM list 33 of the table 6E4B
OamList_B02_6F16_33::
    db $20, $00, $b5, $10
    db $20, $f8, $b4, $10
    db $20, $f0, $b3, $10
    db $18, $00, $b2, $10
    db $18, $f8, $b1, $10
    db $18, $f0, $b0, $10
    db $10, $00, $af, $10
    db $10, $f8, $ae, $10
    db $10, $f0, $ad, $10
    db $80

; I: OAM list 34 of the table 6E4B
OamList_B02_6F16_34::
    db $20, $00, $be, $10
    db $20, $f8, $bd, $10
    db $20, $f0, $bc, $10
    db $18, $00, $bb, $10
    db $18, $f8, $ba, $10
    db $18, $f0, $b9, $10
    db $10, $00, $b8, $10
    db $10, $f8, $b7, $10
    db $10, $f0, $b6, $10
    db $80

; I: OAM list 35 of the table 6E4B
OamList_B02_6F16_35::
    db $09, $18, $e2, $10
    db $09, $10, $e1, $10
    db $09, $08, $e0, $10
    db $01, $18, $d2, $10
    db $01, $10, $d1, $10
    db $01, $08, $d0, $10
    db $f9, $18, $c2, $10
    db $f9, $10, $c1, $10
    db $f9, $08, $c0, $10
    db $80

; I: OAM list 36 of the table 6E4B
OamList_B02_6F16_36::
    db $f9, $18, $e3, $10
    db $09, $18, $e2, $10
    db $09, $10, $e1, $10
    db $09, $08, $e0, $10
    db $01, $18, $d2, $10
    db $01, $10, $d1, $10
    db $01, $08, $d0, $10
    db $f9, $10, $c1, $10
    db $f9, $08, $c0, $10
    db $80

; I: OAM list 37 of the table 6E4B
OamList_B02_6F16_37::
    db $09, $18, $e2, $10
    db $09, $10, $e1, $10
    db $09, $08, $e0, $10
    db $01, $18, $d5, $10
    db $01, $10, $d4, $10
    db $01, $08, $d3, $10
    db $f9, $18, $c5, $10
    db $f9, $10, $c4, $10
    db $f9, $08, $c3, $10
    db $80

; I: OAM list 38 of the table 6E4B
OamList_B02_6F16_38::
    db $09, $18, $e6, $10
    db $f9, $07, $c5, $30
    db $f9, $0f, $c4, $30
    db $f9, $17, $c3, $30
    db $09, $10, $e1, $10
    db $09, $08, $e0, $10
    db $01, $18, $d8, $10
    db $01, $10, $d7, $10
    db $01, $08, $d6, $10
    db $80

; I: OAM list 39 of the table 6E4B
OamList_B02_6F16_39::
    db $09, $18, $c6, $10
    db $01, $18, $db, $10
    db $09, $10, $e1, $10
    db $09, $08, $e5, $10
    db $01, $10, $da, $10
    db $01, $08, $d9, $10
    db $f9, $18, $cb, $10
    db $f9, $10, $ca, $10
    db $f9, $08, $c9, $10
    db $80

; I: OAM list 3A of the table 6E4B
OamList_B02_6F16_3A::
    db $0b, $0b, $10, $10
    db $03, $10, $01, $10
    db $03, $08, $00, $10
    db $fb, $10, $f1, $10
    db $fb, $08, $f0, $10
    db $80

; I: OAM list 3B of the table 6E4B
OamList_B02_6F16_3B::
    db $03, $10, $03, $10
    db $03, $08, $02, $10
    db $fb, $10, $f3, $10
    db $fb, $08, $f2, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 3C of the table 6E4B
OamList_B02_6F16_3C::
    db $fe, $0e, $f5, $10
    db $fe, $06, $f4, $10
    db $03, $10, $05, $10
    db $03, $08, $04, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 3D of the table 6E4B
OamList_B02_6F16_3D::
    db $fa, $08, $f0, $10
    db $fb, $0c, $95, $10
    db $03, $10, $07, $10
    db $03, $08, $06, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 3E of the table 6E4B
OamList_B02_6F16_3E::
    db $fb, $10, $f9, $10
    db $fb, $08, $f8, $10
    db $03, $10, $09, $10
    db $03, $08, $08, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 3F of the table 6E4B
OamList_B02_6F16_3F::
    db $fb, $10, $1f, $10
    db $03, $10, $1e, $10
    db $03, $08, $0f, $10
    db $fb, $08, $ff, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 40 of the table 6E4B
OamList_B02_6F16_40::
    db $02, $15, $fc, $10
    db $08, $0d, $0b, $10
    db $08, $05, $0a, $10
    db $00, $0d, $fb, $10
    db $00, $05, $fa, $10
    db $80

; I: OAM list 41 of the table 6E4B
OamList_B02_6F16_41::
    db $01, $16, $0c, $10
    db $09, $0e, $0e, $10
    db $09, $06, $0d, $10
    db $01, $0e, $fe, $10
    db $01, $06, $fd, $10
    db $80

; I: OAM list 42 of the table 6E4B
OamList_B02_6F16_42::
    db $fb, $0b, $11, $10
    db $0b, $0b, $10, $10
    db $03, $10, $01, $10
    db $03, $08, $00, $10
    db $80

; I: OAM list 43 of the table 6E4B
OamList_B02_6F16_43::
    db $03, $07, $09, $30
    db $fb, $0c, $12, $10
    db $03, $0e, $19, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 44 of the table 6E4B
OamList_B02_6F16_44::
    db $fb, $0c, $13, $10
    db $03, $06, $1a, $10
    db $03, $0e, $1b, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 45 of the table 6E4B
OamList_B02_6F16_45::
    db $fb, $0d, $15, $10
    db $fb, $05, $14, $10
    db $03, $0e, $1d, $10
    db $03, $06, $1c, $10
    db $0b, $0b, $10, $10
    db $80

; I: OAM list 46 of the table 6E4B
OamList_B02_6F16_46::
    db $08, $08, $16, $10
    db $80

; I: OAM list 47 of the table 6E4B
OamList_B02_6F16_47::
    db $08, $08, $17, $10
    db $80

; I: OAM list 48 of the table 6E4B
OamList_B02_6F16_48::
    db $08, $08, $e4, $10
    db $80

; I: OAM list 49 of the table 6E4B
OamList_B02_6F16_49::
    db $08, $08, $17, $30
    db $80

; I: OAM list 4A of the table 6E4B
OamList_B02_6F16_4A::
    db $08, $08, $16, $30
    db $80

; I: OAM list 4B of the table 6E4B
OamList_B02_6F16_4B::
    db $08, $08, $88, $00
    db $80

; I: OAM list 4C of the table 6E4B
OamList_B02_6F16_4C::
    db $08, $08, $89, $00
    db $80

; I: OAM list 4D of the table 6E4B
OamList_B02_6F16_4D::
    db $08, $08, $96, $00
    db $80

; I: OAM list 4E of the table 6E4B
OamList_B02_6F16_4E::
    db $08, $08, $89, $20
    db $80

; I: OAM list 4F of the table 6E4B
OamList_B02_6F16_4F::
    db $08, $08, $88, $20
    db $80

; I: OAM list 50 of the table 6E4B
OamList_B02_6F16_50::
    db $0c, $fc, $28, $00
    db $0c, $0b, $29, $00
    db $04, $06, $27, $00
    db $04, $fe, $26, $00
    db $ef, $14, $23, $00
    db $ef, $0c, $22, $00
    db $fc, $04, $25, $00
    db $fc, $fc, $24, $00
    db $f4, $04, $21, $00
    db $f4, $fc, $20, $00
    db $80

; I: OAM list 51 of the table 6E4B
OamList_B02_6F16_51::
    db $fc, $0d, $31, $00
    db $0c, $0c, $36, $00
    db $0c, $fc, $35, $00
    db $04, $0c, $34, $00
    db $04, $04, $33, $00
    db $04, $fc, $32, $00
    db $fc, $04, $30, $00
    db $fc, $fc, $2f, $00
    db $f4, $14, $2e, $00
    db $f4, $0c, $2d, $00
    db $f4, $04, $2c, $00
    db $f4, $fc, $2b, $00
    db $80

; I: OAM list 52 of the table 6E4B
OamList_B02_6F16_52::
    db $f4, $07, $39, $00
    db $f4, $09, $37, $20
    db $fb, $07, $39, $00
    db $04, $09, $3a, $20
    db $fc, $09, $38, $20
    db $fd, $07, $39, $00
    db $04, $ff, $3a, $00
    db $fc, $ff, $38, $00
    db $f4, $ff, $37, $00
    db $0c, $09, $3b, $20
    db $0c, $ff, $3b, $00
    db $80

; I: OAM list 53 of the table 6E4B
OamList_B02_6F16_53::
    db $01, $09, $3e, $20
    db $f8, $ff, $3c, $00
    db $f8, $09, $3c, $20
    db $fe, $07, $39, $00
    db $f6, $07, $39, $00
    db $09, $09, $3d, $20
    db $ff, $07, $39, $00
    db $01, $ff, $3e, $00
    db $09, $ff, $3d, $00
    db $80

; I: OAM list 54 of the table 6E4B
OamList_B02_6F16_54::
    db $0c, $08, $df, $10
    db $0c, $00, $de, $10
    db $04, $08, $dd, $10
    db $04, $00, $dc, $10
    db $80

; I: OAM list 55 of the table 6E4B
OamList_B02_6F16_55::
    db $18, $24, $88, $00
    db $08, $04, $4a, $00
    db $18, $1c, $5e, $00
    db $18, $14, $5c, $00
    db $18, $0c, $5a, $00
    db $08, $24, $58, $00
    db $08, $1c, $56, $00
    db $08, $14, $54, $00
    db $08, $0c, $52, $00
    db $10, $fc, $64, $00
    db $10, $f4, $62, $00
    db $10, $ec, $60, $00
    db $18, $04, $42, $00
    db $00, $fc, $12, $10
    db $00, $f4, $10, $10
    db $00, $ec, $0e, $10
    db $00, $e4, $0c, $10
    db $00, $dc, $0a, $10
    db $f0, $fc, $08, $10
    db $f0, $f4, $06, $10
    db $f0, $ec, $04, $10
    db $f0, $e4, $02, $10
    db $f0, $dc, $00, $10
    db $80

; I: OAM list 56 of the table 6E4B
OamList_B02_6F16_56::
    db $18, $24, $88, $00
    db $08, $04, $4a, $00
    db $18, $1c, $5e, $00
    db $18, $14, $5c, $00
    db $18, $0c, $5a, $00
    db $08, $24, $58, $00
    db $08, $1c, $56, $00
    db $08, $14, $54, $00
    db $08, $0c, $52, $00
    db $10, $fc, $64, $00
    db $10, $f4, $62, $00
    db $10, $ec, $60, $00
    db $18, $04, $42, $00
    db $00, $fc, $12, $00
    db $00, $f4, $10, $00
    db $00, $ec, $0e, $00
    db $00, $e4, $0c, $00
    db $00, $dc, $0a, $00
    db $f0, $fc, $08, $00
    db $f0, $f4, $06, $00
    db $f0, $ec, $04, $00
    db $f0, $e4, $02, $00
    db $f0, $dc, $00, $00
    db $80

; I: OAM list 57 of the table 6E4B
OamList_B02_6F16_57::
    db $18, $24, $88, $00
    db $18, $1c, $5e, $00
    db $08, $24, $58, $00
    db $08, $1c, $56, $00
    db $10, $14, $6c, $00
    db $10, $0c, $6a, $00
    db $10, $fc, $68, $00
    db $10, $f4, $66, $00
    db $18, $ec, $3e, $00
    db $18, $e4, $3c, $00
    db $08, $ec, $36, $00
    db $08, $e4, $34, $00
    db $00, $14, $12, $10
    db $00, $0c, $22, $10
    db $00, $04, $20, $10
    db $00, $fc, $1e, $10
    db $00, $f4, $1c, $10
    db $f0, $14, $1a, $10
    db $f0, $0c, $18, $10
    db $f0, $04, $16, $10
    db $f0, $fc, $14, $10
    db $f0, $f4, $00, $10
    db $08, $0c, $38, $10
    db $08, $fc, $36, $10
    db $80

; I: OAM list 58 of the table 6E4B
OamList_B02_6F16_58::
    db $18, $24, $88, $00
    db $18, $1c, $5e, $00
    db $08, $24, $58, $00
    db $08, $1c, $56, $00
    db $10, $14, $6c, $00
    db $10, $0c, $6a, $00
    db $10, $fc, $68, $00
    db $10, $f4, $66, $00
    db $18, $ec, $3e, $00
    db $18, $e4, $3c, $00
    db $08, $ec, $36, $00
    db $08, $e4, $34, $00
    db $00, $14, $12, $00
    db $00, $0c, $22, $00
    db $00, $04, $20, $00
    db $00, $fc, $1e, $00
    db $00, $f4, $1c, $00
    db $f0, $14, $1a, $00
    db $f0, $0c, $18, $00
    db $f0, $04, $16, $00
    db $f0, $fc, $14, $00
    db $f0, $f4, $00, $00
    db $08, $0c, $38, $10
    db $08, $fc, $36, $10
    db $80

; I: OAM list 59 of the table 6E4B
OamList_B02_6F16_59::
    db $00, $2c, $86, $10
    db $f0, $0c, $84, $10
    db $10, $0c, $6e, $00
    db $10, $14, $70, $00
    db $10, $1c, $72, $00
    db $18, $04, $4c, $00
    db $08, $04, $44, $00
    db $18, $fc, $42, $00
    db $18, $f4, $40, $00
    db $18, $ec, $3e, $00
    db $18, $e4, $3c, $00
    db $08, $fc, $3a, $00
    db $08, $f4, $38, $00
    db $08, $ec, $36, $00
    db $08, $e4, $34, $00
    db $00, $24, $32, $10
    db $00, $1c, $30, $10
    db $00, $14, $2e, $10
    db $00, $0c, $2c, $10
    db $f0, $2c, $2a, $10
    db $f0, $24, $28, $10
    db $f0, $1c, $26, $10
    db $f0, $14, $24, $10
    db $80

; I: OAM list 5A of the table 6E4B
OamList_B02_6F16_5A::
    db $00, $2c, $86, $00
    db $f0, $0c, $84, $00
    db $00, $24, $32, $00
    db $00, $1c, $30, $00
    db $00, $14, $2e, $00
    db $00, $0c, $2c, $00
    db $f0, $2c, $2a, $00
    db $f0, $24, $28, $00
    db $f0, $1c, $26, $00
    db $f0, $14, $24, $00
    db $10, $0c, $6e, $00
    db $10, $14, $70, $00
    db $10, $1c, $72, $00
    db $18, $04, $4c, $00
    db $08, $04, $44, $00
    db $18, $fc, $42, $00
    db $18, $f4, $40, $00
    db $18, $ec, $3e, $00
    db $18, $e4, $3c, $00
    db $08, $fc, $3a, $00
    db $08, $f4, $38, $00
    db $08, $ec, $36, $00
    db $08, $e4, $34, $00
    db $80

; I: OAM list 5B of the table 6E4B
OamList_B02_6F16_5B::
    db $08, $08, $74, $10
    db $80

; I: OAM list 5C of the table 6E4B
OamList_B02_6F16_5C::
    db $08, $09, $74, $10
    db $80

; I: OAM list 5D of the table 6E4B
OamList_B02_6F16_5D::
    db $08, $08, $74, $30
    db $80

; I: OAM list 5E of the table 6E4B
OamList_B02_6F16_5E::
    db $08, $07, $74, $30
    db $80

; I: OAM list 5F of the table 6E4B
OamList_B02_6F16_5F::
    db $00, $10, $7e, $00
    db $00, $08, $7c, $00
    db $00, $00, $7a, $00
    db $00, $f8, $78, $00
    db $00, $f0, $76, $00
    db $80

; I: OAM list 60 of the table 6E4B
OamList_B02_6F16_60::
    db $00, $10, $7e, $00
    db $00, $08, $7c, $00
    db $fe, $00, $7a, $10
    db $fe, $f8, $78, $10
    db $fe, $f0, $76, $10
    db $80

; I: OAM list 61 of the table 6E4B
OamList_B02_6F16_61::
    db $00, $10, $7e, $00
    db $fe, $08, $7c, $10
    db $00, $00, $7a, $00
    db $fe, $f8, $78, $10
    db $fe, $f0, $76, $10
    db $80

; I: OAM list 62 of the table 6E4B
OamList_B02_6F16_62::
    db $fe, $10, $7e, $10
    db $00, $08, $7c, $00
    db $00, $00, $7a, $00
    db $fe, $f8, $78, $10
    db $fe, $f0, $76, $10
    db $80

; I: OAM list 63 of the table 6E4B
OamList_B02_6F16_63::
    db $08, $00, $46, $10
    db $80

; I: OAM list 64 of the table 6E4B
OamList_B02_6F16_64::
    db $08, $ff, $46, $10
    db $80

; I: OAM list 65 of the table 6E4B
OamList_B02_6F16_65::
    db $08, $08, $46, $30
    db $80

; I: OAM list 66 of the table 6E4B
OamList_B02_6F16_66::
    db $08, $09, $46, $30
    db $80

; I: OAM list 67 of the table 6E4B
OamList_B02_6F16_67::
    db $08, $00, $48, $10
    db $80

; I: OAM list 68 of the table 6E4B
OamList_B02_6F16_68::
    db $08, $ff, $48, $10
    db $80

; I: OAM list 69 of the table 6E4B
OamList_B02_6F16_69::
    db $08, $08, $48, $30
    db $80

; I: OAM list 6A of the table 6E4B
OamList_B02_6F16_6A::
    db $08, $09, $48, $30
    db $80

; I: OAM list 6B of the table 6E4B
OamList_B02_6F16_6B::
    db $08, $00, $80, $10
    db $80

; I: OAM list 6C of the table 6E4B
OamList_B02_6F16_6C::
    db $08, $00, $82, $10
    db $80

; I: OAM list 6D of the table 6E4B
OamList_B02_6F16_6D::
    db $08, $00, $84, $10
    db $80

; I: OAM list 6E of the table 6E4B
OamList_B02_6F16_6E::
    db $08, $10, $03, $00
    db $08, $08, $02, $00
    db $08, $00, $01, $00
    db $08, $f8, $00, $00
    db $80

; I: OAM list 6F of the table 6E4B
OamList_B02_6F16_6F::
    db $08, $10, $06, $00
    db $08, $08, $05, $00
    db $08, $00, $04, $00
    db $80

; I: OAM list 70 of the table 6E4B
OamList_B02_6F16_70::
    db $08, $18, $0c, $00
    db $08, $10, $0b, $00
    db $08, $08, $0a, $00
    db $08, $00, $09, $00
    db $08, $f8, $08, $00
    db $08, $f0, $07, $00
    db $80

; I: OAM list 71 of the table 6E4B
OamList_B02_6F16_71::
    db $08, $08, $11, $00
    db $08, $00, $10, $00
    db $80

; I: OAM list 72 of the table 6E4B
OamList_B02_6F16_72::
    db $08, $08, $13, $00
    db $08, $00, $12, $00
    db $80

; I: OAM list 73 of the table 6E4B
OamList_B02_6F16_73::
    db $08, $18, $18, $00
    db $08, $10, $17, $00
    db $08, $08, $16, $00
    db $08, $00, $15, $00
    db $08, $f8, $14, $00
    db $80

; I: OAM list 74 of the table 6E4B
OamList_B02_6F16_74::
    db $08, $10, $1b, $00
    db $08, $08, $1a, $00
    db $08, $00, $19, $00
    db $80

; I: OAM list 75 of the table 6E4B
OamList_B02_6F16_75::
    db $08, $10, $0f, $00
    db $08, $08, $0e, $00
    db $08, $00, $0d, $00
    db $80

; I: OAM list 76 of the table 6E4B
OamList_B02_6F16_76::
    db $08, $08, $1c, $10
    db $80

; I: OAM list 77 of the table 6E4B
OamList_B02_6F16_77::
    db $10, $0d, $ba, $00
    db $10, $08, $b9, $00
    db $80, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00

    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00

    ; padding
    ds $ec, $00

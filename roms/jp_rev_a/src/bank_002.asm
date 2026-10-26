; Pocket Camera (Japan) (Rev A), bank $02. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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


; C: A = photo number: copies its image to $C000; numbers >= $1E are built-in images from bank $36 / table 02:5218
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
    jr c, jr_002_4ce7                             ; $4CCB

    cp $18                                        ; $4CCD
    jr nc, jr_002_4ce7                            ; $4CCF

    call AlbumB_CheckGate                         ; $4CD1
    jr nz, jr_002_4ce7                            ; $4CD4

    ld a, $36                                     ; $4CD6
    ld hl, AlbumB_UnusedSlotA_Tiles               ; $4CD8
    ld de, wPhotoImage                            ; $4CDB
    ld bc, $0fb8                                  ; $4CDE
    call Mem_CopyFromBank                         ; $4CE1
    jp Far_Call_Return                            ; $4CE4


jr_002_4ce7:
    ld c, a                                       ; $4CE7
    sla a                                         ; $4CE8
    add c                                         ; $4CEA
    ld c, a                                       ; $4CEB
    ld b, $00                                     ; $4CEC
    ld hl, AlbumB_SlotTbl                         ; $4CEE
    add hl, bc                                    ; $4CF1
    ld c, [hl]                                    ; $4CF2
    inc hl                                        ; $4CF3
    ld b, [hl]                                    ; $4CF4
    inc hl                                        ; $4CF5
    ld a, [hl]                                    ; $4CF6
    ld l, c                                       ; $4CF7
    ld h, b                                       ; $4CF8
    ld de, wPhotoImage                            ; $4CF9
    ld bc, $0fb8                                  ; $4CFC
    call Mem_CopyFromBank                         ; $4CFF
    jp Far_Call_Return                            ; $4D02


; C: A = Album B photo id: tests the counter / score thresholds in a table; Z/NZ and the unlock bit mask
AlbumB_CheckGate::
    push de                                       ; $4D05
    push af                                       ; $4D06
    ldh [hFarcallAArg], a                         ; $4D07
    ld a, $02                                     ; $4D09
    ld hl, Counters_Load_Far                      ; $4D0B
    call Far_Call                                 ; $4D0E
    ld d, $00                                     ; $4D11
    ld a, [wCntTaken + $1]                        ; $4D13
    and a                                         ; $4D16
    jr nz, jr_002_4d20                            ; $4D17

    ld a, [wCntTaken]                             ; $4D19
    cp $60                                        ; $4D1C
    jr c, jr_002_4d22                             ; $4D1E

jr_002_4d20:
    set 0, d                                      ; $4D20

jr_002_4d22:
    ld a, [wCntPrinted + $1]                      ; $4D22
    and a                                         ; $4D25
    jr nz, jr_002_4d2f                            ; $4D26

    ld a, [wCntPrinted]                           ; $4D28
    cp $30                                        ; $4D2B
    jr c, jr_002_4d31                             ; $4D2D

jr_002_4d2f:
    set 1, d                                      ; $4D2F

jr_002_4d31:
    ld a, [wCntSent + $1]                         ; $4D31
    and a                                         ; $4D34
    jr nz, jr_002_4d3e                            ; $4D35

    ld a, [wCntSent]                              ; $4D37
    cp $15                                        ; $4D3A
    jr c, jr_002_4d40                             ; $4D3C

jr_002_4d3e:
    set 2, d                                      ; $4D3E

jr_002_4d40:
    ld a, [wBestShooter + $3]                     ; $4D40
    ld hl, wBestShooter + $2                      ; $4D43
    or [hl]                                       ; $4D46
    jr nz, jr_002_4d54                            ; $4D47

    ld a, [wBestShooter + $1]                     ; $4D49
    cp $30                                        ; $4D4C
    jr c, jr_002_4d58                             ; $4D4E

    cp $50                                        ; $4D50
    jr c, jr_002_4d56                             ; $4D52

jr_002_4d54:
    set 6, d                                      ; $4D54

jr_002_4d56:
    set 5, d                                      ; $4D56

jr_002_4d58:
    ld a, [wBestBall + $1]                        ; $4D58
    cp $07                                        ; $4D5B
    jr c, jr_002_4d67                             ; $4D5D

    cp $10                                        ; $4D5F
    jr c, jr_002_4d65                             ; $4D61

    set 4, d                                      ; $4D63

jr_002_4d65:
    set 3, d                                      ; $4D65

jr_002_4d67:
    ld a, [wBestRun + $1]                         ; $4D67
    cp $82                                        ; $4D6A
    jr c, jr_002_4d70                             ; $4D6C

    set 7, d                                      ; $4D6E

jr_002_4d70:
    pop af                                        ; $4D70
    ld e, a                                       ; $4D71
    sub $10                                       ; $4D72
    ld c, a                                       ; $4D74
    ld b, $00                                     ; $4D75
    ld hl, AlbumB_CheckGate_Tbl4D80               ; $4D77
    add hl, bc                                    ; $4D7A
    ld a, [hl]                                    ; $4D7B
    and d                                         ; $4D7C
    ld a, e                                       ; $4D7D
    pop de                                        ; $4D7E
    ret                                           ; $4D7F


; C: auto: 8 bytes, bytes; referenced by AlbumB_CheckGate. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the
; organic corpus, modes 18 (tcrf_check/assets/l3_names/)
AlbumB_CheckGate_Tbl4D80::
    db $01, $02, $04, $08, $10, $20, $40, $80

; C: hot-spot block of a photo (30 bytes) -> $D643
Photo_LoadHotspots_Far::
    cp $1e                                        ; $4D88
    jr nc, jr_002_4db5                            ; $4D8A

    ldh [hFarcallAArg], a                         ; $4D8C
    ld a, $02                                     ; $4D8E
    ld hl, Photo_FindSlot_Far                     ; $4D90
    call Far_Call                                 ; $4D93
    srl a                                         ; $4D96
    inc a                                         ; $4D98
    ld [rRAMB], a                                 ; $4D99
    ld de, $0000                                  ; $4D9C
    rl d                                          ; $4D9F
    swap d                                        ; $4DA1
    ld hl, $af36                                  ; $4DA3
    add hl, de                                    ; $4DA6
    ld de, wHotspotBlock                          ; $4DA7
    ld b, $1e                                     ; $4DAA

jr_002_4dac:
    ld a, [hl+]                                   ; $4DAC
    ld [de], a                                    ; $4DAD
    inc de                                        ; $4DAE
    dec b                                         ; $4DAF
    jr nz, jr_002_4dac                            ; $4DB0

    jp Far_Call_Return                            ; $4DB2


jr_002_4db5:
    sub $1e                                       ; $4DB5
    ld c, a                                       ; $4DB7
    sla a                                         ; $4DB8
    add c                                         ; $4DBA
    ld c, a                                       ; $4DBB
    ld b, $00                                     ; $4DBC
    ld hl, AlbumB_SlotTbl                         ; $4DBE
    add hl, bc                                    ; $4DC1
    ld c, [hl]                                    ; $4DC2
    inc hl                                        ; $4DC3
    ld b, [hl]                                    ; $4DC4
    inc hl                                        ; $4DC5
    ld a, [hl]                                    ; $4DC6
    ld hl, $0f36                                  ; $4DC7
    add hl, bc                                    ; $4DCA
    ld de, wHotspotBlock                          ; $4DCB
    ld bc, $001e                                  ; $4DCE
    call Mem_CopyFromBank                         ; $4DD1
    jp Far_Call_Return                            ; $4DD4


; C: same
Photo_LoadHotspotsTranslated_Far::
    cp $1e                                        ; $4DD7
    jr nc, jr_002_4e0f                            ; $4DD9

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
    ld b, $19                                     ; $4DF9

jr_002_4dfb:
    ld a, [hl+]                                   ; $4DFB
    ld [de], a                                    ; $4DFC
    inc de                                        ; $4DFD
    dec b                                         ; $4DFE
    jr nz, jr_002_4dfb                            ; $4DFF

    ld b, $05                                     ; $4E01

jr_002_4e03:
    ld a, [hl+]                                   ; $4E03
    call Vec_GetPhotoVectorByte                   ; $4E04
    ld [de], a                                    ; $4E07
    inc de                                        ; $4E08
    dec b                                         ; $4E09
    jr nz, jr_002_4e03                            ; $4E0A

    jp Far_Call_Return                            ; $4E0C


jr_002_4e0f:
    sub $1e                                       ; $4E0F
    ld c, a                                       ; $4E11
    sla a                                         ; $4E12
    add c                                         ; $4E14
    ld c, a                                       ; $4E15
    ld b, $00                                     ; $4E16
    ld hl, AlbumB_SlotTbl                         ; $4E18
    add hl, bc                                    ; $4E1B
    ld c, [hl]                                    ; $4E1C
    inc hl                                        ; $4E1D
    ld b, [hl]                                    ; $4E1E
    inc hl                                        ; $4E1F
    ld a, [hl]                                    ; $4E20
    ld hl, $0f36                                  ; $4E21
    add hl, bc                                    ; $4E24
    ld de, wHotspotBlock                          ; $4E25
    ld bc, $001e                                  ; $4E28
    call Mem_CopyFromBank                         ; $4E2B
    jp Far_Call_Return                            ; $4E2E


; C: border number of a photo -> $D7C1 ($12 for built-in images)
Photo_LoadBorder_Far::
    cp $1e                                        ; $4E31
    jr nc, jr_002_4e57                            ; $4E33

    ldh [hFarcallAArg], a                         ; $4E35
    ld a, $02                                     ; $4E37
    ld hl, Photo_FindSlot_Far                     ; $4E39
    call Far_Call                                 ; $4E3C
    srl a                                         ; $4E3F
    inc a                                         ; $4E41
    ld [rRAMB], a                                 ; $4E42
    ld de, $0000                                  ; $4E45
    rl d                                          ; $4E48
    swap d                                        ; $4E4A
    ld hl, $af54                                  ; $4E4C
    add hl, de                                    ; $4E4F
    ld a, [hl]                                    ; $4E50
    ld [wBorderNumber], a                         ; $4E51
    jp Far_Call_Return                            ; $4E54


jr_002_4e57:
    ld a, $12                                     ; $4E57
    ld [wBorderNumber], a                         ; $4E59
    jp Far_Call_Return                            ; $4E5C


; C: $36 tag fields of a photo -> tag_owner_id $DA5B
Photo_LoadTagFields_Far::
    cp $1e                                        ; $4E5F
    jr nc, jr_002_4e8c                            ; $4E61

    ldh [hFarcallAArg], a                         ; $4E63
    ld a, $02                                     ; $4E65
    ld hl, Photo_FindSlot_Far                     ; $4E67
    call Far_Call                                 ; $4E6A
    srl a                                         ; $4E6D
    inc a                                         ; $4E6F
    ld [rRAMB], a                                 ; $4E70
    ld de, $0000                                  ; $4E73
    rl d                                          ; $4E76
    swap d                                        ; $4E78
    ld hl, $af00                                  ; $4E7A
    add hl, de                                    ; $4E7D
    ld de, wTagOwnerId                            ; $4E7E
    ld b, $36                                     ; $4E81

jr_002_4e83:
    ld a, [hl+]                                   ; $4E83
    ld [de], a                                    ; $4E84
    inc de                                        ; $4E85
    dec b                                         ; $4E86
    jr nz, jr_002_4e83                            ; $4E87

    jp Far_Call_Return                            ; $4E89


jr_002_4e8c:
    sub $1e                                       ; $4E8C
    ld c, a                                       ; $4E8E
    sla a                                         ; $4E8F
    add c                                         ; $4E91
    ld c, a                                       ; $4E92
    ld b, $00                                     ; $4E93
    ld hl, AlbumB_SlotTbl                         ; $4E95
    add hl, bc                                    ; $4E98
    ld c, [hl]                                    ; $4E99
    inc hl                                        ; $4E9A
    ld b, [hl]                                    ; $4E9B
    inc hl                                        ; $4E9C
    ld a, [hl]                                    ; $4E9D
    ld hl, $0f00                                  ; $4E9E
    add hl, bc                                    ; $4EA1
    ld de, wTagOwnerId                            ; $4EA2
    ld bc, $0036                                  ; $4EA5
    call Mem_CopyFromBank                         ; $4EA8
    jp Far_Call_Return                            ; $4EAB


; C: animation list / timing / speed / border from the settings block -> $D681..
Settings_LoadAnim_Far::
    xor a                                         ; $4EAE
    ld [rRAMB], a                                 ; $4EAF
    ld hl, $b000                                  ; $4EB2
    ld de, wAnimList                              ; $4EB5
    ld c, $30                                     ; $4EB8

jr_002_4eba:
    ld a, [hl+]                                   ; $4EBA
    ld [de], a                                    ; $4EBB
    inc de                                        ; $4EBC
    dec c                                         ; $4EBD
    jr nz, jr_002_4eba                            ; $4EBE

    xor a                                         ; $4EC0
    ld [wAnimListGuard], a                        ; $4EC1
    ld hl, $b030                                  ; $4EC4
    ld de, wAnimTiming                            ; $4EC7
    ld c, $2f                                     ; $4ECA

jr_002_4ecc:
    ld a, [hl+]                                   ; $4ECC
    ld [de], a                                    ; $4ECD
    inc de                                        ; $4ECE
    dec c                                         ; $4ECF
    jr nz, jr_002_4ecc                            ; $4ED0

    ld a, $ff                                     ; $4ED2
    ld [wAnimTimingGuardLo], a                    ; $4ED4
    ld [wAnimTimingGuardHi], a                    ; $4ED7
    ld hl, $b05f                                  ; $4EDA
    ld a, [hl+]                                   ; $4EDD
    ld [wAnimSpeed], a                            ; $4EDE
    ld a, [hl]                                    ; $4EE1
    ld [wAnimBorder], a                           ; $4EE2
    jp Far_Call_Return                            ; $4EE5


; C: same with the list entries translated slot -> photo number
Settings_LoadAnimTranslated_Far::
    xor a                                         ; $4EE8
    ld [rRAMB], a                                 ; $4EE9
    ld hl, $b000                                  ; $4EEC
    ld de, wAnimList                              ; $4EEF
    ld c, $2f                                     ; $4EF2

jr_002_4ef4:
    ld a, [hl+]                                   ; $4EF4
    call Vec_GetPhotoVectorByte                   ; $4EF5
    ld [de], a                                    ; $4EF8
    inc de                                        ; $4EF9
    dec c                                         ; $4EFA
    jr nz, jr_002_4ef4                            ; $4EFB

    ld a, [hl]                                    ; $4EFD
    ld [de], a                                    ; $4EFE
    xor a                                         ; $4EFF
    ld [wAnimListGuard], a                        ; $4F00
    ld hl, $b030                                  ; $4F03
    ld de, wAnimTiming                            ; $4F06
    ld c, $2f                                     ; $4F09

jr_002_4f0b:
    ld a, [hl+]                                   ; $4F0B
    ld [de], a                                    ; $4F0C
    inc de                                        ; $4F0D
    dec c                                         ; $4F0E
    jr nz, jr_002_4f0b                            ; $4F0F

    ld a, $ff                                     ; $4F11
    ld [wAnimTimingGuardLo], a                    ; $4F13
    ld [wAnimTimingGuardHi], a                    ; $4F16
    ld hl, $b05f                                  ; $4F19
    ld a, [hl+]                                   ; $4F1C
    ld [wAnimSpeed], a                            ; $4F1D
    ld a, [hl]                                    ; $4F20
    ld [wAnimBorder], a                           ; $4F21
    jp Far_Call_Return                            ; $4F24


; C: HL = DE then loads the D.J. tune. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz)
Dj_LoadTune_FromDE_Far::
    ld h, d                                       ; $4F27
    ld l, e                                       ; $4F28
    jr jr_002_4f32                                ; $4F29

; C: unpacks the D.J. tune from the settings block B061.. into $D93D..
Dj_LoadTune_Far::
    xor a                                         ; $4F2B
    ld [rRAMB], a                                 ; $4F2C
    ld hl, $b061                                  ; $4F2F

jr_002_4f32:
    ld de, wSound1DutyLen                         ; $4F32
    call Dj_UnpackDutyLength                      ; $4F35
    ld de, wSound1Envelope                        ; $4F38
    call Dj_UnpackEnvelope                        ; $4F3B
    ld de, wSound1Modulation                      ; $4F3E
    call Dj_UnpackModulation                      ; $4F41
    ld de, wSound1Notes                           ; $4F44
    call Dj_CopyNotesOut                          ; $4F47
    ld de, wSound1Stereo                          ; $4F4A
    call Dj_UnpackStereoCodes                     ; $4F4D
    ld de, wSound2UserWave                        ; $4F50
    call Dj_UnpackWave                            ; $4F53
    ld de, wSound2WaveLen                         ; $4F56
    call Dj_UnpackDutyLength                      ; $4F59
    ld de, wSound2Modulation                      ; $4F5C
    call Dj_UnpackModulation                      ; $4F5F
    ld de, wSound2Notes                           ; $4F62
    call Dj_CopyNotesOut                          ; $4F65
    ld de, wSound2Stereo                          ; $4F68
    call Dj_UnpackStereoCodes                     ; $4F6B
    ld de, wLoopLengths                           ; $4F6E
    ld a, [hl]                                    ; $4F71
    and $f0                                       ; $4F72
    swap a                                        ; $4F74
    inc a                                         ; $4F76
    ld [de], a                                    ; $4F77
    inc de                                        ; $4F78
    ld a, [hl+]                                   ; $4F79
    and $0f                                       ; $4F7A
    inc a                                         ; $4F7C
    ld [de], a                                    ; $4F7D
    ld de, wNoiseEnvelope                         ; $4F7E
    call Dj_UnpackEnvelope                        ; $4F81
    ld de, wNoiseGateLoop                         ; $4F84
    ld a, [hl]                                    ; $4F87
    and $f0                                       ; $4F88
    swap a                                        ; $4F8A
    ld [de], a                                    ; $4F8C
    inc de                                        ; $4F8D
    ld a, [hl+]                                   ; $4F8E
    and $0f                                       ; $4F8F
    inc a                                         ; $4F91
    ld [de], a                                    ; $4F92
    ld de, wNoiseNotes                            ; $4F93
    call Dj_CopyNotesOut                          ; $4F96
    ld de, wNoiseStereoWidth                      ; $4F99
    call Dj_UnpackStereoCodes                     ; $4F9C
    ld de, wNoiseStereoWidth                      ; $4F9F
    call Dj_UnpackNoiseBits                       ; $4FA2
    ld a, [hl+]                                   ; $4FA5
    ld [wTempo], a                                ; $4FA6
    ld a, [hl]                                    ; $4FA9
    ld [wSavedTunePresent], a                     ; $4FAA
    jp Far_Call_Return                            ; $4FAD


; C: inverse of 4B1E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackDutyLength::
    ld a, [hl]                                    ; $4FB0
    and $30                                       ; $4FB1
    swap a                                        ; $4FB3
    ld [de], a                                    ; $4FB5
    inc de                                        ; $4FB6
    ld a, [hl+]                                   ; $4FB7
    and $0f                                       ; $4FB8
    ld [de], a                                    ; $4FBA
    ret                                           ; $4FBB


; C: inverse of 4B2B. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackEnvelope::
    ld a, [hl]                                    ; $4FBC
    and $80                                       ; $4FBD
    rlc a                                         ; $4FBF
    ld [de], a                                    ; $4FC1
    inc de                                        ; $4FC2
    ld a, [hl]                                    ; $4FC3
    and $70                                       ; $4FC4
    swap a                                        ; $4FC6
    ld [de], a                                    ; $4FC8
    inc de                                        ; $4FC9
    ld a, [hl+]                                   ; $4FCA
    and $0f                                       ; $4FCB
    ld [de], a                                    ; $4FCD
    ret                                           ; $4FCE


; C: inverse of 4B40. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackModulation::
    ld a, [hl+]                                   ; $4FCF
    and $7f                                       ; $4FD0
    ld [de], a                                    ; $4FD2
    inc de                                        ; $4FD3
    ld a, [hl-]                                   ; $4FD4
    and $7f                                       ; $4FD5
    ld [de], a                                    ; $4FD7
    inc de                                        ; $4FD8
    ld a, [hl+]                                   ; $4FD9
    and $80                                       ; $4FDA
    rlc a                                         ; $4FDC
    ld c, a                                       ; $4FDE
    ld a, [hl+]                                   ; $4FDF
    and $80                                       ; $4FE0
    rlc a                                         ; $4FE2
    rlc a                                         ; $4FE4
    or c                                          ; $4FE6
    ld [de], a                                    ; $4FE7
    ret                                           ; $4FE8


; C: copies 16 note bytes. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz)
Dj_CopyNotesOut::
    ld b, $10                                     ; $4FE9

jr_002_4feb:
    ld a, [hl+]                                   ; $4FEB
    ld [de], a                                    ; $4FEC
    inc de                                        ; $4FED
    dec b                                         ; $4FEE
    jr nz, jr_002_4feb                            ; $4FEF

    ret                                           ; $4FF1


; C: inverse of 4B64. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackStereoCodes::
    ld b, $04                                     ; $4FF2

jr_002_4ff4:
    ld a, [hl]                                    ; $4FF4
    and $c0                                       ; $4FF5
    rlc a                                         ; $4FF7
    rlc a                                         ; $4FF9
    ld [de], a                                    ; $4FFB
    inc de                                        ; $4FFC
    ld a, [hl]                                    ; $4FFD
    and $30                                       ; $4FFE
    swap a                                        ; $5000
    ld [de], a                                    ; $5002
    inc de                                        ; $5003
    ld a, [hl]                                    ; $5004
    and $0c                                       ; $5005
    srl a                                         ; $5007
    srl a                                         ; $5009
    ld [de], a                                    ; $500B
    inc de                                        ; $500C
    ld a, [hl+]                                   ; $500D
    and $03                                       ; $500E
    ld [de], a                                    ; $5010
    inc de                                        ; $5011
    dec b                                         ; $5012
    jr nz, jr_002_4ff4                            ; $5013

    ret                                           ; $5015


; C: inverse of 4B8B. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackWave::
    ld b, $10                                     ; $5016

jr_002_5018:
    ld a, [hl]                                    ; $5018
    and $f0                                       ; $5019
    swap a                                        ; $501B
    ld [de], a                                    ; $501D
    inc de                                        ; $501E
    ld a, [hl+]                                   ; $501F
    and $0f                                       ; $5020
    ld [de], a                                    ; $5022
    inc de                                        ; $5023
    dec b                                         ; $5024
    jr nz, jr_002_5018                            ; $5025

    ret                                           ; $5027


; C: inverse of 4B9E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackNoiseBits::
    ld b, $02                                     ; $5028

jr_002_502a:
    ld a, [hl+]                                   ; $502A
    ld c, $08                                     ; $502B

jr_002_502d:
    sla a                                         ; $502D
    push af                                       ; $502F
    ld a, [de]                                    ; $5030
    jr nc, jr_002_5035                            ; $5031

    set 4, a                                      ; $5033

jr_002_5035:
    ld [de], a                                    ; $5035
    inc de                                        ; $5036
    pop af                                        ; $5037
    dec c                                         ; $5038
    jr nz, jr_002_502d                            ; $5039

    dec b                                         ; $503B
    jr nz, jr_002_502a                            ; $503C

    ret                                           ; $503E


; C: counters block B0BB.. -> DA96..
Counters_Load_Far::
    xor a                                         ; $503F
    ld [rRAMB], a                                 ; $5040
    ld hl, $b0bb                                  ; $5043
    ld de, wCntTaken                              ; $5046
    ld c, $16                                     ; $5049

jr_002_504b:
    ld a, [hl+]                                   ; $504B
    ld [de], a                                    ; $504C
    inc de                                        ; $504D
    dec c                                         ; $504E
    jr nz, jr_002_504b                            ; $504F

    jp Far_Call_Return                            ; $5051


; C: owner block AFB8.. -> owner_id DA49..
Owner_Load_Far::
    ld a, $01                                     ; $5054
    ld [rRAMB], a                                 ; $5056
    ld hl, $afb8                                  ; $5059
    ld de, wOwnerId                               ; $505C
    ld c, $12                                     ; $505F

jr_002_5061:
    ld a, [hl+]                                   ; $5061
    ld [de], a                                    ; $5062
    inc de                                        ; $5063
    dec c                                         ; $5064
    jr nz, jr_002_5061                            ; $5065

    jp Far_Call_Return                            ; $5067


; C: reads the Game Face flag B0D1 into gameface_present and loads the image to $C000
GameFace_Load_Far::
    xor a                                         ; $506A
    ld [rRAMB], a                                 ; $506B
    ld a, [$b0d1]                                 ; $506E
    ld [wGamefacePresent], a                      ; $5071
    and a                                         ; $5074
    jp z, Far_Call_Return                         ; $5075

    ld hl, $b1fc                                  ; $5078
    ld de, wPhotoImage                            ; $507B
    ld bc, $0e00                                  ; $507E

jr_002_5081:
    ld a, [hl+]                                   ; $5081
    ld [de], a                                    ; $5082
    inc de                                        ; $5083
    dec bc                                        ; $5084
    ld a, c                                       ; $5085
    or b                                          ; $5086
    jr nz, jr_002_5081                            ; $5087

    jp Far_Call_Return                            ; $5089


; C: loads the Game Face image in four 7x128 byte chunks
GameFace_LoadTiles_Far::
    xor a                                         ; $508C
    ld [rRAMB], a                                 ; $508D
    ld a, [$b0d1]                                 ; $5090
    ld [wGamefacePresent], a                      ; $5093
    and a                                         ; $5096
    jp z, Far_Call_Return                         ; $5097

    ld de, wPhotoImage                            ; $509A
    ld hl, $b1fc                                  ; $509D
    call GameFace_CopyChunk                       ; $50A0
    ld hl, $b27c                                  ; $50A3
    call GameFace_CopyChunk                       ; $50A6
    ld hl, $b8fc                                  ; $50A9
    call GameFace_CopyChunk                       ; $50AC
    ld hl, $b97c                                  ; $50AF
    call GameFace_CopyChunk                       ; $50B2
    jp Far_Call_Return                            ; $50B5


; C: copies 7 rows of 128 bytes with a 128 byte skip. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed
; in the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
GameFace_CopyChunk::
    ld b, $07                                     ; $50B8

jr_002_50ba:
    ld c, $80                                     ; $50BA

jr_002_50bc:
    ld a, [hl+]                                   ; $50BC
    ld [de], a                                    ; $50BD
    inc de                                        ; $50BE
    dec c                                         ; $50BF
    jr nz, jr_002_50bc                            ; $50C0

    ld a, l                                       ; $50C2
    add $80                                       ; $50C3
    ld l, a                                       ; $50C5
    jr nc, jr_002_50c9                            ; $50C6

    inc h                                         ; $50C8

jr_002_50c9:
    dec b                                         ; $50C9
    jr nz, jr_002_50ba                            ; $50CA

    ret                                           ; $50CC


; C: loads the eight thumbnails of a page (AE00 area of the slots). L3 pass 2026-10-26: executed in BGB in the
; scenarios link_exchange 0E:03 (tcrf_check/assets/l3_names/scen_hits*.csv)
Album_LoadThumbPage_Far::
    and $18                                       ; $50CD
    ld c, a                                       ; $50CF
    ld de, wPhotoImage                            ; $50D0
    ld b, $08                                     ; $50D3

jr_002_50d5:
    push bc                                       ; $50D5
    push de                                       ; $50D6
    ld a, c                                       ; $50D7
    ldh [hFarcallAArg], a                         ; $50D8
    ld a, $02                                     ; $50DA
    ld hl, Photo_FindSlot_Far                     ; $50DC
    call Far_Call                                 ; $50DF
    jr nc, jr_002_50e5                            ; $50E2

    xor a                                         ; $50E4

jr_002_50e5:
    srl a                                         ; $50E5
    inc a                                         ; $50E7
    ld [rRAMB], a                                 ; $50E8
    ld de, $0000                                  ; $50EB
    rl d                                          ; $50EE
    swap d                                        ; $50F0
    ld hl, $ae00                                  ; $50F2
    add hl, de                                    ; $50F5
    pop de                                        ; $50F6
    ld b, $40                                     ; $50F7

jr_002_50f9:
    ld a, [hl+]                                   ; $50F9
    ld [de], a                                    ; $50FA
    inc de                                        ; $50FB
    ld a, [hl+]                                   ; $50FC
    ld [de], a                                    ; $50FD
    inc de                                        ; $50FE
    ld a, [hl+]                                   ; $50FF
    ld [de], a                                    ; $5100
    inc de                                        ; $5101
    ld a, [hl+]                                   ; $5102
    ld [de], a                                    ; $5103
    inc de                                        ; $5104
    dec b                                         ; $5105
    jr nz, jr_002_50f9                            ; $5106

    pop bc                                        ; $5108
    inc c                                         ; $5109
    dec b                                         ; $510A
    jr nz, jr_002_50d5                            ; $510B

    jp Far_Call_Return                            ; $510D


; C: loads a photo image and copies its tiles to VRAM (safe copy when the LCD is on)
Photo_LoadToVram_Far::
    ldh [hFarcallAArg], a                         ; $5110
    ld a, $02                                     ; $5112
    ld hl, Photo_LoadImage_Far                    ; $5114
    call Far_Call                                 ; $5117
    ld hl, $ff40                                  ; $511A
    bit 7, [hl]                                   ; $511D
    jr nz, jr_002_514e                            ; $511F

    ld a, $00                                     ; $5121
    ld hl, wPhotoImage                            ; $5123
    ld de, $9000                                  ; $5126
    ld bc, $0800                                  ; $5129
    call Mem_CopyFromBank                         ; $512C
    ld a, $00                                     ; $512F
    ld hl, wPhotoImage + $800                     ; $5131
    ld de, $8800                                  ; $5134
    ld bc, $0100                                  ; $5137
    call Mem_CopyFromBank                         ; $513A
    ld a, $00                                     ; $513D
    ld hl, wPhotoImage + $900                     ; $513F
    ld de, $8000                                  ; $5142
    ld bc, $0500                                  ; $5145
    call Mem_CopyFromBank                         ; $5148
    jp Far_Call_Return                            ; $514B


jr_002_514e:
    ld a, $00                                     ; $514E
    ld hl, wPhotoImage                            ; $5150
    ld de, $9000                                  ; $5153
    ld bc, $0800                                  ; $5156
    call Vram_CopyFromBank                        ; $5159
    ld a, $00                                     ; $515C
    ld hl, wPhotoImage + $800                     ; $515E
    ld de, $8800                                  ; $5161
    ld bc, $0100                                  ; $5164
    call Vram_CopyFromBank                        ; $5167
    ld a, $00                                     ; $516A
    ld hl, wPhotoImage + $900                     ; $516C
    ld de, $8000                                  ; $516F
    ld bc, $0500                                  ; $5172
    call Vram_CopyFromBank                        ; $5175
    jp Far_Call_Return                            ; $5178


; C: A = photo number; returns the SRAM bank / address of its image (bank $36 for built-in images)
Photo_GetSramAddress_Far::
    cp $1e                                        ; $517B
    jr nc, jr_002_51a5                            ; $517D

    ld hl, wPhotoCount                            ; $517F
    cp [hl]                                       ; $5182
    jr nc, jr_002_519d                            ; $5183

    ldh [hFarcallAArg], a                         ; $5185
    ld a, $02                                     ; $5187
    ld hl, Photo_FindSlot_Far                     ; $5189
    call Far_Call                                 ; $518C
    srl a                                         ; $518F
    inc a                                         ; $5191
    ld bc, $0500                                  ; $5192
    rl b                                          ; $5195
    swap b                                        ; $5197
    and a                                         ; $5199
    jp Far_Call_Return                            ; $519A


jr_002_519d:
    ld bc, AlbumB_UnusedSlotB_Tiles               ; $519D
    ld a, BANK(AlbumB_UnusedSlotB_Tiles)          ; $51A0
    jp Far_Call_Return                            ; $51A2


jr_002_51a5:
    sub $1e                                       ; $51A5
    cp $10                                        ; $51A7
    jr c, jr_002_51bc                             ; $51A9

    cp $18                                        ; $51AB
    jr nc, jr_002_51bc                            ; $51AD

    call AlbumB_CheckGate                         ; $51AF
    jr nz, jr_002_51bc                            ; $51B2

    ld bc, AlbumB_UnusedSlotA_Tiles               ; $51B4
    ld a, BANK(AlbumB_UnusedSlotA_Tiles)          ; $51B7
    jp Far_Call_Return                            ; $51B9


jr_002_51bc:
    ld c, a                                       ; $51BC
    sla a                                         ; $51BD
    add c                                         ; $51BF
    ld c, a                                       ; $51C0
    ld b, $00                                     ; $51C1
    ld hl, AlbumB_SlotTbl                         ; $51C3
    add hl, bc                                    ; $51C6
    ld c, [hl]                                    ; $51C7
    inc hl                                        ; $51C8
    ld b, [hl]                                    ; $51C9
    inc hl                                        ; $51CA
    ld a, [hl]                                    ; $51CB
    and a                                         ; $51CC
    jp Far_Call_Return                            ; $51CD


; C: if the owner id is all zero fills it with random BCD digits and stores the owner block
Owner_GenerateId_Far::
    ldh [hFarcallAArg], a                         ; $51D0
    ld a, $02                                     ; $51D2
    ld hl, Owner_Load_Far                         ; $51D4
    call Far_Call                                 ; $51D7
    xor a                                         ; $51DA
    ld hl, wOwnerId                               ; $51DB
    ld b, $04                                     ; $51DE

jr_002_51e0:
    or [hl]                                       ; $51E0
    inc hl                                        ; $51E1
    dec b                                         ; $51E2
    jr nz, jr_002_51e0                            ; $51E3

    and a                                         ; $51E5
    jp nz, Far_Call_Return                        ; $51E6

    ld hl, wOwnerId                               ; $51E9
    ld bc, $0800                                  ; $51EC

jr_002_51ef:
    call Rng_Next                                 ; $51EF
    and $0f                                       ; $51F2
    add c                                         ; $51F4

jr_002_51f5:
    cp $0a                                        ; $51F5
    jr c, jr_002_51fd                             ; $51F7

    sub $0a                                       ; $51F9
    jr jr_002_51f5                                ; $51FB

jr_002_51fd:
    ld c, a                                       ; $51FD
    inc a                                         ; $51FE
    swap [hl]                                     ; $51FF
    or [hl]                                       ; $5201
    ld [hl], a                                    ; $5202
    bit 0, b                                      ; $5203
    jr z, jr_002_5208                             ; $5205

    inc hl                                        ; $5207

jr_002_5208:
    dec b                                         ; $5208
    jr nz, jr_002_51ef                            ; $5209

    ldh [hFarcallAArg], a                         ; $520B
    ld a, $02                                     ; $520D
    ld hl, Owner_Store_Far                        ; $520F
    call Far_Call                                 ; $5212
    jp Far_Call_Return                            ; $5215


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
    dwb AlbumB_Photo08_Tiles
    dwb AlbumB_Photo09_Tiles
    dwb AlbumB_Photo10_Tiles
    dwb AlbumB_Photo11_Tiles
    dwb AlbumB_Photo12_Tiles
    dwb AlbumB_Photo13_Tiles
    dwb AlbumB_Photo14_Tiles
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

; C: 203 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B02_5272 (00:247D)
OamPtrTbl_B02_5272::
    dw OamList_B02_5272_00
    dw OamList_B02_5272_01
    dw OamList_B02_5272_02
    dw OamList_B02_5272_03
    dw OamList_B02_5272_04
    dw OamList_B02_5272_05
    dw OamList_B02_5272_06
    dw OamList_B02_5272_07
    dw OamList_B02_5272_08
    dw OamList_B02_5272_09
    dw OamList_B02_5272_0A
    dw OamList_B02_5272_0B
    dw OamList_B02_5272_0C
    dw OamList_B02_5272_0D
    dw OamList_B02_5272_0E
    dw OamList_B02_5272_0F
    dw OamList_B02_5272_10
    dw OamList_B02_5272_11
    dw OamList_B02_5272_12
    dw OamList_B02_5272_13
    dw OamList_B02_5272_14
    dw OamList_B02_5272_15
    dw OamList_B02_5272_16
    dw OamList_B02_5272_17
    dw OamList_B02_5272_18
    dw OamList_B02_5272_19
    dw OamList_B02_5272_1A
    dw OamList_B02_5272_1B
    dw OamList_B02_5272_1C
    dw OamList_B02_5272_1D
    dw OamList_B02_5272_1E
    dw OamList_B02_5272_1F
    dw OamList_B02_5272_20
    dw OamList_B02_5272_21
    dw OamList_B02_5272_22
    dw OamList_B02_5272_23
    dw OamList_B02_5272_24
    dw OamList_B02_5272_25
    dw OamList_B02_5272_26
    dw OamList_B02_5272_27
    dw OamList_B02_5272_28
    dw OamList_B02_5272_29
    dw OamList_B02_5272_2A
    dw OamList_B02_5272_2B
    dw OamList_B02_5272_2C
    dw OamList_B02_5272_2D
    dw OamList_B02_5272_2E
    dw OamList_B02_5272_2F
    dw OamList_B02_5272_30
    dw OamList_B02_5272_31
    dw OamList_B02_5272_32
    dw OamList_B02_5272_33
    dw OamList_B02_5272_34
    dw OamList_B02_5272_35
    dw OamList_B02_5272_36
    dw OamList_B02_5272_37
    dw OamList_B02_5272_38
    dw OamList_B02_5272_39
    dw OamList_B02_5272_3A
    dw OamList_B02_5272_3B
    dw OamList_B02_5272_3C
    dw OamList_B02_5272_3D
    dw OamList_B02_5272_3E
    dw OamList_B02_5272_3F
    dw OamList_B02_5272_40
    dw OamList_B02_5272_41
    dw OamList_B02_5272_42
    dw OamList_B02_5272_43
    dw OamList_B02_5272_44
    dw OamList_B02_5272_45
    dw OamList_B02_5272_46
    dw OamList_B02_5272_47
    dw OamList_B02_5272_48
    dw OamList_B02_5272_49
    dw OamList_B02_5272_4A
    dw OamList_B02_5272_4B
    dw OamList_B02_5272_4C
    dw OamList_B02_5272_4D
    dw OamList_B02_5272_4E
    dw OamList_B02_5272_4F
    dw OamList_B02_5272_50
    dw OamList_B02_5272_51
    dw OamList_B02_5272_52
    dw OamList_B02_5272_53
    dw OamList_B02_5272_54
    dw OamList_B02_5272_55
    dw OamList_B02_5272_56
    dw OamList_B02_5272_57
    dw OamList_B02_5272_58
    dw OamList_B02_5272_59
    dw OamList_B02_5272_5A
    dw OamList_B02_5272_5B
    dw OamList_B02_5272_5C
    dw OamList_B02_5272_5D
    dw OamList_B02_5272_5E
    dw OamList_B02_5272_5F
    dw OamList_B02_5272_60
    dw OamList_B02_5272_61
    dw OamList_B02_5272_62
    dw OamList_B02_5272_63
    dw OamList_B02_5272_64
    dw OamList_B02_5272_65
    dw OamList_B02_5272_66
    dw OamList_B02_5272_67
    dw OamList_B02_5272_68
    dw OamList_B02_5272_69
    dw OamList_B02_5272_6A
    dw OamList_B02_5272_6B
    dw OamList_B02_5272_6C
    dw OamList_B02_5272_6D
    dw OamList_B02_5272_6E
    dw OamList_B02_5272_6F
    dw OamList_B02_5272_70
    dw OamList_B02_5272_71
    dw OamList_B02_5272_72
    dw OamList_B02_5272_73
    dw OamList_B02_5272_74
    dw OamList_B02_5272_75
    dw OamList_B02_5272_76
    dw OamList_B02_5272_77
    dw OamList_B02_5272_78
    dw OamList_B02_5272_79
    dw OamList_B02_5272_7A
    dw OamList_B02_5272_7B
    dw OamList_B02_5272_7C
    dw OamList_B02_5272_7D
    dw OamList_B02_5272_7E
    dw OamList_B02_5272_7F
    dw OamList_B02_5272_80
    dw OamList_B02_5272_81
    dw OamList_B02_5272_82
    dw OamList_B02_5272_83
    dw OamList_B02_5272_84
    dw OamList_B02_5272_85
    dw OamList_B02_5272_86
    dw OamList_B02_5272_87
    dw OamList_B02_5272_88
    dw OamList_B02_5272_89
    dw OamList_B02_5272_8A
    dw OamList_B02_5272_8B
    dw OamList_B02_5272_8C
    dw OamList_B02_5272_8D
    dw OamList_B02_5272_8E
    dw OamList_B02_5272_8F
    dw OamList_B02_5272_90
    dw OamList_B02_5272_91
    dw OamList_B02_5272_92
    dw OamList_B02_5272_93
    dw OamList_B02_5272_94
    dw OamList_B02_5272_95
    dw OamList_B02_5272_96
    dw OamList_B02_5272_97
    dw OamList_B02_5272_98
    dw OamList_B02_5272_99
    dw OamList_B02_5272_9A
    dw OamList_B02_5272_9B
    dw OamList_B02_5272_9C
    dw OamList_B02_5272_9D
    dw OamList_B02_5272_9E
    dw OamList_B02_5272_9F
    dw OamList_B02_5272_A0
    dw OamList_B02_5272_A1
    dw OamList_B02_5272_A2
    dw OamList_B02_5272_A3
    dw OamList_B02_5272_A4
    dw OamList_B02_5272_A5
    dw OamList_B02_5272_A6
    dw OamList_B02_5272_A7
    dw OamList_B02_5272_A8
    dw OamList_B02_5272_A9
    dw OamList_B02_5272_AA
    dw OamList_B02_5272_AB
    dw OamList_B02_5272_AC
    dw OamList_B02_5272_AD
    dw OamList_B02_5272_AE
    dw OamList_B02_5272_AF
    dw OamList_B02_5272_B0
    dw OamList_B02_5272_B1
    dw OamList_B02_5272_B2
    dw OamList_B02_5272_B3
    dw OamList_B02_5272_B4
    dw OamList_B02_5272_B5
    dw OamList_B02_5272_B6
    dw OamList_B02_5272_B7
    dw OamList_B02_5272_B8
    dw OamList_B02_5272_B9
    dw OamList_B02_5272_BA
    dw OamList_B02_5272_BB
    dw OamList_B02_5272_BC
    dw OamList_B02_5272_BD
    dw OamList_B02_5272_BE
    dw OamList_B02_5272_BF
    dw OamList_B02_5272_C0
    dw OamList_B02_5272_C1
    dw OamList_B02_5272_C2
    dw OamList_B02_5272_C3
    dw OamList_B02_5272_C4
    dw OamList_B02_5272_C5
    dw OamList_B02_5272_C6
    dw OamList_B02_5272_C7
    dw OamList_B02_5272_C8
    dw OamList_B02_5272_C9
    dw OamList_B02_5272_CA

; C: OAM list 00 of the table 5272
OamList_B02_5272_00::
    db $09, $21, $56, $30
    db $f9, $21, $54, $30
    db $09, $e7, $56, $10
    db $f9, $e7, $54, $10
    db $80

; C: OAM list 01 of the table 5272
OamList_B02_5272_01::
    db $09, $22, $56, $20
    db $f9, $22, $54, $20
    db $09, $e6, $56, $00
    db $f9, $e6, $54, $00
    db $80

; C: OAM list 02 of the table 5272
OamList_B02_5272_02::
    db $0c, $08, $5a, $00
    db $0c, $00, $58, $00
    db $80

; C: OAM list 03 of the table 5272
OamList_B02_5272_03::
    db $0b, $08, $5a, $00
    db $0b, $00, $58, $00
    db $80

; C: OAM list 04 of the table 5272
OamList_B02_5272_04::
    db $0b, $07, $5a, $00
    db $0b, $ff, $58, $00
    db $80

; C: OAM list 05 of the table 5272
OamList_B02_5272_05::
    db $0c, $07, $5a, $00
    db $0c, $ff, $58, $00
    db $80

; C: OAM list 06 of the table 5272
OamList_B02_5272_06::
    db $0c, $00, $5a, $20
    db $0c, $08, $58, $20
    db $80

; C: OAM list 07 of the table 5272
OamList_B02_5272_07::
    db $0b, $00, $5a, $20
    db $0b, $08, $58, $20
    db $80

; C: OAM list 08 of the table 5272
OamList_B02_5272_08::
    db $0b, $01, $5a, $20
    db $0b, $09, $58, $20
    db $80

; C: OAM list 09 of the table 5272
OamList_B02_5272_09::
    db $0c, $01, $5a, $20
    db $0c, $09, $58, $20
    db $80

; C: OAM list 0A of the table 5272
OamList_B02_5272_0A::
    db $08, $00, $5c, $10
    db $80

; C: OAM list 0B of the table 5272
OamList_B02_5272_0B::
    db $07, $00, $5c, $10
    db $80

; C: OAM list 0C of the table 5272
OamList_B02_5272_0C::
    db $07, $ff, $5c, $10
    db $80

; C: OAM list 0D of the table 5272
OamList_B02_5272_0D::
    db $08, $ff, $5c, $10
    db $80

; C: OAM list 0E of the table 5272
OamList_B02_5272_0E::
    db $08, $08, $5c, $30
    db $80

; C: OAM list 0F of the table 5272
OamList_B02_5272_0F::
    db $07, $08, $5c, $30
    db $80

; C: OAM list 10 of the table 5272
OamList_B02_5272_10::
    db $07, $09, $5c, $30
    db $80

; C: OAM list 11 of the table 5272
OamList_B02_5272_11::
    db $08, $09, $5c, $30
    db $80

; C: OAM list 12 of the table 5272
OamList_B02_5272_12::
    db $08, $07, $52, $10
    db $08, $ff, $50, $10
    db $80

; C: OAM list 13 of the table 5272
OamList_B02_5272_13::
    db $08, $09, $52, $10
    db $08, $01, $50, $10
    db $80

; C: OAM list 14 of the table 5272
OamList_B02_5272_14::
    db $08, $0b, $52, $10
    db $08, $03, $50, $10
    db $80

; C: OAM list 15 of the table 5272
OamList_B02_5272_15::
    db $08, $0d, $52, $10
    db $08, $05, $50, $10
    db $80

; C: OAM list 16 of the table 5272
OamList_B02_5272_16::
    db $08, $00, $52, $30
    db $08, $08, $50, $30
    db $80

; C: OAM list 17 of the table 5272
OamList_B02_5272_17::
    db $08, $fe, $52, $30
    db $08, $06, $50, $30
    db $80

; C: OAM list 18 of the table 5272
OamList_B02_5272_18::
    db $08, $fc, $52, $30
    db $08, $04, $50, $30
    db $80

; C: OAM list 19 of the table 5272
OamList_B02_5272_19::
    db $08, $fa, $52, $30
    db $08, $02, $50, $30
    db $80

; C: OAM list 1A of the table 5272
OamList_B02_5272_1A::
    db $10, $04, $7e, $50
    db $80

; C: OAM list 1B of the table 5272
OamList_B02_5272_1B::
    db $12, $04, $7e, $50
    db $80

; C: OAM list 1C of the table 5272
OamList_B02_5272_1C::
    db $08, $04, $7e, $10
    db $80

; C: OAM list 1D of the table 5272
OamList_B02_5272_1D::
    db $06, $04, $7e, $10
    db $80

; C: OAM list 1E of the table 5272
OamList_B02_5272_1E::
    db $08, $20, $7c, $10
    db $08, $18, $7a, $10
    db $08, $10, $78, $10
    db $08, $08, $76, $10
    db $08, $00, $74, $10
    db $08, $f8, $72, $10
    db $08, $f0, $70, $10
    db $80

; C: OAM list 1F of the table 5272
OamList_B02_5272_1F::
    db $07, $20, $7c, $10
    db $07, $18, $7a, $10
    db $07, $10, $78, $10
    db $07, $08, $76, $10
    db $07, $00, $74, $10
    db $07, $f8, $72, $10
    db $07, $f0, $70, $10
    db $80

; C: OAM list 20 of the table 5272
OamList_B02_5272_20::
    db $00, $20, $4e, $10
    db $00, $18, $4c, $10
    db $00, $10, $4a, $10
    db $00, $08, $48, $10
    db $00, $00, $46, $10
    db $00, $f8, $44, $10
    db $00, $f0, $42, $10
    db $00, $e8, $40, $10
    db $f0, $20, $3e, $10
    db $f0, $18, $3c, $10
    db $f0, $10, $3a, $10
    db $f0, $08, $38, $10
    db $f0, $00, $36, $10
    db $f0, $f8, $34, $10
    db $f0, $f0, $32, $10
    db $f0, $e8, $30, $10
    db $80

; C: OAM list 21 of the table 5272
OamList_B02_5272_21::
    db $00, $20, $4e, $00
    db $00, $18, $4c, $00
    db $00, $10, $4a, $00
    db $00, $08, $48, $00
    db $00, $00, $46, $00
    db $00, $f8, $44, $00
    db $00, $f0, $42, $00
    db $00, $e8, $40, $00
    db $f0, $20, $3e, $00
    db $f0, $18, $3c, $00
    db $f0, $10, $3a, $00
    db $f0, $08, $38, $00
    db $f0, $00, $36, $00
    db $f0, $f8, $34, $00
    db $f0, $f0, $32, $00
    db $f0, $e8, $30, $00
    db $80

; C: OAM list 22 of the table 5272
OamList_B02_5272_22::
    db $25, $07, $1e, $10
    db $25, $ff, $1c, $10
    db $25, $f7, $1a, $10
    db $25, $ef, $18, $10
    db $15, $07, $16, $10
    db $15, $ff, $14, $10
    db $15, $f7, $12, $10
    db $15, $ef, $10, $10
    db $08, $01, $0e, $10
    db $08, $f9, $0c, $10
    db $08, $f1, $0a, $10
    db $08, $e9, $08, $10
    db $f8, $01, $06, $10
    db $f8, $f9, $04, $10
    db $f8, $f1, $02, $10
    db $f8, $e9, $00, $10
    db $80

; C: OAM list 23 of the table 5272
OamList_B02_5272_23::
    db $24, $09, $1e, $10
    db $24, $01, $1c, $10
    db $24, $f9, $1a, $10
    db $24, $f1, $18, $10
    db $14, $09, $16, $10
    db $14, $01, $14, $10
    db $14, $f9, $12, $10
    db $14, $f1, $10, $10
    db $07, $00, $0e, $10
    db $07, $f8, $0c, $10
    db $07, $f0, $0a, $10
    db $07, $e8, $08, $10
    db $f7, $00, $06, $10
    db $f7, $f8, $04, $10
    db $f7, $f0, $02, $10
    db $f7, $e8, $00, $10
    db $80

; C: OAM list 24 of the table 5272
OamList_B02_5272_24::
    db $15, $08, $16, $00
    db $15, $00, $14, $00
    db $15, $f8, $12, $00
    db $15, $f0, $10, $00
    db $09, $ff, $0e, $00
    db $09, $f7, $0c, $00
    db $09, $ef, $0a, $00
    db $09, $e7, $08, $00
    db $f9, $ff, $06, $00
    db $f9, $f7, $04, $00
    db $f9, $ef, $02, $00
    db $f9, $e7, $00, $00
    db $25, $08, $1e, $00
    db $25, $00, $1c, $00
    db $25, $f8, $1a, $00
    db $25, $f0, $18, $00
    db $80

; C: OAM list 25 of the table 5272
OamList_B02_5272_25::
    db $08, $1f, $2e, $10
    db $08, $17, $2c, $10
    db $08, $0f, $2a, $10
    db $08, $07, $28, $10
    db $f8, $1f, $26, $10
    db $f8, $17, $24, $10
    db $f8, $0f, $22, $10
    db $f8, $07, $20, $10
    db $25, $19, $1e, $10
    db $25, $11, $1c, $10
    db $25, $09, $1a, $10
    db $25, $01, $18, $10
    db $15, $19, $16, $10
    db $15, $11, $14, $10
    db $15, $09, $12, $10
    db $15, $01, $10, $10
    db $80

; C: OAM list 26 of the table 5272
OamList_B02_5272_26::
    db $07, $20, $2e, $10
    db $07, $18, $2c, $10
    db $07, $10, $2a, $10
    db $07, $08, $28, $10
    db $f7, $20, $26, $10
    db $f7, $18, $24, $10
    db $f7, $10, $22, $10
    db $f7, $08, $20, $10
    db $24, $17, $1e, $10
    db $24, $0f, $1c, $10
    db $24, $07, $1a, $10
    db $24, $ff, $18, $10
    db $14, $17, $16, $10
    db $14, $0f, $14, $10
    db $14, $07, $12, $10
    db $14, $ff, $10, $10
    db $80

; C: OAM list 27 of the table 5272
OamList_B02_5272_27::
    db $09, $21, $2e, $00
    db $09, $19, $2c, $00
    db $09, $11, $2a, $00
    db $09, $09, $28, $00
    db $f9, $21, $26, $00
    db $f9, $19, $24, $00
    db $f9, $11, $22, $00
    db $f9, $09, $20, $00
    db $15, $18, $16, $00
    db $15, $10, $14, $00
    db $15, $08, $12, $00
    db $15, $00, $10, $00
    db $25, $18, $1e, $00
    db $25, $10, $1c, $00
    db $25, $08, $1a, $00
    db $25, $00, $18, $00
    db $80

; C: OAM list 28 of the table 5272
OamList_B02_5272_28::
    db $0a, $fe, $5c, $50
    db $80

; C: OAM list 29 of the table 5272
OamList_B02_5272_29::
    db $0a, $ff, $5c, $50
    db $80

; C: OAM list 2A of the table 5272
OamList_B02_5272_2A::
    db $09, $ff, $5c, $50
    db $80

; C: OAM list 2B of the table 5272
OamList_B02_5272_2B::
    db $09, $fe, $5c, $50
    db $80

; C: OAM list 2C of the table 5272
OamList_B02_5272_2C::
    db $0a, $0a, $5c, $70
    db $80

; C: OAM list 2D of the table 5272
OamList_B02_5272_2D::
    db $0a, $09, $5c, $70
    db $80

; C: OAM list 2E of the table 5272
OamList_B02_5272_2E::
    db $09, $09, $5c, $70
    db $80

; C: OAM list 2F of the table 5272
OamList_B02_5272_2F::
    db $09, $0a, $5c, $70
    db $80

; C: OAM list 30 of the table 5272
OamList_B02_5272_30::
    db $10, $08, $00, $00
    db $80

; C: OAM list 31 of the table 5272
OamList_B02_5272_31::
    db $10, $08, $01, $00
    db $80

; C: OAM list 32 of the table 5272
OamList_B02_5272_32::
    db $10, $08, $10, $00
    db $80

; C: OAM list 33 of the table 5272
OamList_B02_5272_33::
    db $10, $0e, $0b, $00
    db $10, $06, $0a, $00
    db $80

; C: OAM list 34 of the table 5272
OamList_B02_5272_34::
    db $10, $0e, $07, $00
    db $10, $06, $06, $00
    db $80

; C: OAM list 35 of the table 5272
OamList_B02_5272_35::
    db $10, $10, $03, $00
    db $10, $08, $02, $00
    db $80

; C: OAM list 36 of the table 5272
OamList_B02_5272_36::
    db $10, $10, $05, $00
    db $10, $08, $04, $00
    db $80

; C: OAM list 37 of the table 5272
OamList_B02_5272_37::
    db $10, $0e, $14, $00
    db $10, $06, $13, $00
    db $80

; C: OAM list 38 of the table 5272
OamList_B02_5272_38::
    db $10, $0e, $16, $00
    db $10, $06, $15, $00
    db $80

; C: OAM list 39 of the table 5272
OamList_B02_5272_39::
    db $10, $16, $1a, $00
    db $10, $0e, $19, $00
    db $10, $06, $18, $00
    db $80

; C: OAM list 3A of the table 5272
OamList_B02_5272_3A::
    db $10, $16, $1d, $00
    db $10, $0e, $1c, $00
    db $10, $06, $1b, $00
    db $80

; C: OAM list 3B of the table 5272
OamList_B02_5272_3B::
    db $10, $0e, $1f, $00
    db $10, $06, $1e, $00
    db $80

; C: OAM list 3C of the table 5272
OamList_B02_5272_3C::
    db $10, $15, $21, $00
    db $10, $0e, $17, $00
    db $10, $07, $24, $00
    db $80

; C: OAM list 3D of the table 5272
OamList_B02_5272_3D::
    db $10, $19, $21, $00
    db $10, $03, $21, $00
    db $10, $13, $17, $00
    db $10, $08, $17, $00
    db $10, $0e, $22, $00
    db $80

; C: OAM list 3E of the table 5272
OamList_B02_5272_3E::
    db $10, $10, $11, $00
    db $10, $08, $1d, $00
    db $80

; C: OAM list 3F of the table 5272
OamList_B02_5272_3F::
    db $10, $16, $20, $00
    db $80

; C: OAM list 40 of the table 5272
OamList_B02_5272_40::
    db $10, $16, $21, $00
    db $80

; C: OAM list 41 of the table 5272
OamList_B02_5272_41::
    db $10, $16, $22, $00
    db $80

; C: OAM list 42 of the table 5272
OamList_B02_5272_42::
    db $10, $16, $23, $00
    db $80

; C: OAM list 43 of the table 5272
OamList_B02_5272_43::
    db $18, $64, $0e, $30
    db $25, $64, $0c, $70
    db $0b, $64, $0c, $30
    db $25, $54, $0d, $50
    db $0b, $54, $0d, $10
    db $25, $44, $0d, $50
    db $0b, $44, $0d, $10
    db $25, $34, $0d, $50
    db $0b, $34, $0d, $10
    db $25, $24, $0d, $50
    db $0b, $24, $0d, $10
    db $18, $04, $0e, $10
    db $25, $14, $0d, $50
    db $25, $04, $0c, $50
    db $0b, $14, $0d, $10
    db $0b, $04, $0c, $10
    db $80

; C: OAM list 44 of the table 5272
OamList_B02_5272_44::
    db $5c, $03, $0e, $10
    db $5c, $1d, $0e, $30
    db $6c, $0f, $0d, $50
    db $6c, $1d, $0c, $70
    db $6c, $03, $0c, $50
    db $4c, $03, $0e, $10
    db $4c, $1d, $0e, $30
    db $3c, $03, $0e, $10
    db $1c, $03, $0e, $10
    db $1c, $1d, $0e, $30
    db $3c, $1d, $0e, $30
    db $2c, $1d, $0e, $30
    db $0c, $1d, $0c, $30
    db $0c, $0f, $0d, $10
    db $2c, $03, $0e, $10
    db $0c, $03, $0c, $10
    db $80

; C: OAM list 45 of the table 5272
OamList_B02_5272_45::
    db $10, $03, $0f, $20
    db $10, $29, $0f, $00
    db $80

; C: OAM list 46 of the table 5272
OamList_B02_5272_46::
    db $10, $02, $0f, $20
    db $10, $2a, $0f, $00
    db $80

; C: OAM list 47 of the table 5272
OamList_B02_5272_47::
    db $10, $ff, $0f, $20
    db $10, $19, $0f, $00
    db $80

; C: OAM list 48 of the table 5272
OamList_B02_5272_48::
    db $10, $fe, $0f, $20
    db $10, $1a, $0f, $00
    db $80

; C: OAM list 49 of the table 5272
OamList_B02_5272_49::
    db $2b, $2a, $06, $10
    db $2b, $22, $05, $10
    db $2b, $1c, $04, $10
    db $2b, $18, $03, $10
    db $07, $10, $01, $10
    db $07, $08, $00, $10
    db $29, $10, $01, $50
    db $29, $08, $00, $50
    db $80

; C: OAM list 4A of the table 5272
OamList_B02_5272_4A::
    db $2b, $1c, $04, $10
    db $2b, $2a, $06, $10
    db $2b, $22, $05, $10
    db $2b, $18, $03, $10
    db $06, $10, $01, $10
    db $06, $08, $00, $10
    db $2a, $10, $01, $50
    db $2a, $08, $00, $50
    db $80

; C: OAM list 4B of the table 5272
OamList_B02_5272_4B::
    db $2b, $2a, $06, $10
    db $2b, $22, $05, $10
    db $2b, $1c, $04, $10
    db $2b, $18, $03, $10
    db $05, $10, $01, $10
    db $05, $08, $00, $10
    db $2b, $10, $01, $50
    db $2b, $08, $00, $50
    db $80

; C: OAM list 4C of the table 5272
OamList_B02_5272_4C::
    db $18, $30, $d3, $10
    db $18, $28, $d2, $10
    db $18, $20, $d1, $10
    db $18, $18, $d0, $10
    db $18, $10, $cf, $10
    db $18, $08, $ce, $10
    db $10, $30, $cd, $10
    db $10, $28, $cc, $10
    db $10, $20, $cb, $10
    db $10, $18, $ca, $10
    db $10, $10, $c9, $10
    db $10, $08, $c8, $10
    db $80

; C: OAM list 4D of the table 5272
OamList_B02_5272_4D::
    db $18, $30, $df, $10
    db $18, $28, $de, $10
    db $18, $20, $dd, $10
    db $18, $18, $dc, $10
    db $18, $10, $db, $10
    db $18, $08, $da, $10
    db $10, $30, $d9, $10
    db $10, $28, $d8, $10
    db $10, $20, $d7, $10
    db $10, $18, $d6, $10
    db $10, $10, $d5, $10
    db $10, $08, $d4, $10
    db $80

; C: OAM list 4E of the table 5272
OamList_B02_5272_4E::
    db $18, $30, $c2, $00
    db $18, $28, $c1, $00
    db $18, $20, $c0, $00
    db $18, $18, $bf, $00
    db $18, $10, $be, $00
    db $10, $30, $bd, $00
    db $10, $28, $bc, $00
    db $10, $20, $bb, $00
    db $10, $18, $ba, $00
    db $10, $10, $b9, $00
    db $10, $08, $b8, $00
    db $80

; C: OAM list 4F of the table 5272
OamList_B02_5272_4F::
    db $2b, $f0, $06, $10
    db $2b, $e8, $05, $10
    db $2b, $e2, $04, $10
    db $2b, $de, $03, $10
    db $07, $f8, $01, $30
    db $07, $00, $00, $30
    db $29, $f8, $01, $70
    db $29, $00, $00, $70
    db $80

; C: OAM list 50 of the table 5272
OamList_B02_5272_50::
    db $2b, $e2, $04, $10
    db $2b, $f0, $06, $10
    db $2b, $e8, $05, $10
    db $2b, $de, $03, $10
    db $06, $f8, $01, $30
    db $06, $00, $00, $30
    db $2a, $f8, $01, $70
    db $2a, $00, $00, $70
    db $80

; C: OAM list 51 of the table 5272
OamList_B02_5272_51::
    db $2b, $f0, $06, $10
    db $2b, $e8, $05, $10
    db $2b, $e2, $04, $10
    db $2b, $de, $03, $10
    db $05, $f8, $01, $30
    db $05, $00, $00, $30
    db $2b, $f8, $01, $70
    db $2b, $00, $00, $70
    db $80

; C: OAM list 52 of the table 5272
OamList_B02_5272_52::
    db $28, $24, $0f, $70
    db $0c, $24, $0f, $30
    db $28, $04, $0f, $50
    db $0c, $04, $0f, $10
    db $80

; C: OAM list 53 of the table 5272
OamList_B02_5272_53::
    db $29, $25, $0f, $70
    db $0b, $25, $0f, $30
    db $29, $03, $0f, $50
    db $0b, $03, $0f, $10
    db $80

; C: OAM list 54 of the table 5272
OamList_B02_5272_54::
    db $33, $08, $c2, $10
    db $33, $20, $c6, $10
    db $33, $18, $c5, $10
    db $33, $10, $c4, $10
    db $2c, $17, $c0, $70
    db $2c, $0f, $c0, $50
    db $09, $17, $c0, $30
    db $09, $0f, $c0, $10
    db $80

; C: OAM list 55 of the table 5272
OamList_B02_5272_55::
    db $33, $08, $c2, $10
    db $33, $20, $c6, $10
    db $33, $18, $c5, $10
    db $33, $10, $c4, $10
    db $2d, $17, $c0, $70
    db $2d, $0f, $c0, $50
    db $08, $17, $c0, $30
    db $08, $0f, $c0, $10
    db $80

; C: OAM list 56 of the table 5272
OamList_B02_5272_56::
    db $33, $08, $c2, $10
    db $33, $20, $c6, $10
    db $33, $18, $c5, $10
    db $33, $10, $c4, $10
    db $2e, $17, $c0, $70
    db $2e, $0f, $c0, $50
    db $07, $17, $c0, $30
    db $07, $0f, $c0, $10
    db $80

; C: OAM list 57 of the table 5272
OamList_B02_5272_57::
    db $19, $f2, $c5, $10
    db $19, $e4, $c2, $10
    db $19, $eb, $c4, $10
    db $19, $fa, $c6, $10
    db $1d, $02, $c1, $50
    db $15, $02, $c1, $10
    db $1d, $26, $c1, $70
    db $15, $26, $c1, $30
    db $80

; C: OAM list 58 of the table 5272
OamList_B02_5272_58::
    db $19, $f2, $c5, $10
    db $19, $e4, $c2, $10
    db $19, $eb, $c4, $10
    db $19, $fa, $c6, $10
    db $1d, $01, $c1, $50
    db $15, $01, $c1, $10
    db $1d, $27, $c1, $70
    db $15, $27, $c1, $30
    db $80

; C: OAM list 59 of the table 5272
OamList_B02_5272_59::
    db $19, $f2, $c5, $10
    db $19, $e4, $c2, $10
    db $19, $eb, $c4, $10
    db $19, $fa, $c6, $10
    db $1d, $00, $c1, $50
    db $15, $00, $c1, $10
    db $1d, $28, $c1, $70
    db $15, $28, $c1, $30
    db $80

; C: OAM list 5A of the table 5272
OamList_B02_5272_5A::
    db $28, $20, $df, $00
    db $28, $18, $de, $00
    db $28, $10, $dd, $00
    db $28, $08, $dc, $00
    db $20, $20, $db, $00
    db $20, $18, $da, $00
    db $20, $10, $d9, $00
    db $20, $08, $d8, $00
    db $18, $20, $d7, $00
    db $18, $18, $d6, $00
    db $18, $10, $d5, $00
    db $18, $08, $d4, $00
    db $10, $20, $d3, $00
    db $10, $18, $d2, $00
    db $10, $10, $d1, $00
    db $10, $08, $d0, $00
    db $80

; C: OAM list 5B of the table 5272
OamList_B02_5272_5B::
    db $28, $20, $ef, $00
    db $28, $18, $ee, $00
    db $28, $10, $ed, $00
    db $28, $08, $ec, $00
    db $20, $20, $eb, $00
    db $20, $18, $ea, $00
    db $20, $10, $e9, $00
    db $20, $08, $e8, $00
    db $18, $20, $e7, $00
    db $18, $18, $e6, $00
    db $18, $10, $e5, $00
    db $18, $08, $e4, $00
    db $10, $20, $e3, $00
    db $10, $18, $e2, $00
    db $10, $10, $e1, $00
    db $10, $08, $e0, $00
    db $80

; C: OAM list 5C of the table 5272
OamList_B02_5272_5C::
    db $18, $10, $f6, $00
    db $18, $08, $f5, $00
    db $10, $10, $f4, $00
    db $10, $08, $f3, $00
    db $80

; C: OAM list 5D of the table 5272
OamList_B02_5272_5D::
    db $18, $10, $fa, $00
    db $18, $08, $f9, $00
    db $10, $10, $f8, $00
    db $10, $08, $f7, $00
    db $80

; C: OAM list 5E of the table 5272
OamList_B02_5272_5E::
    db $18, $50, $73, $10
    db $18, $48, $72, $10
    db $18, $40, $71, $10
    db $18, $38, $70, $10
    db $18, $30, $6f, $10
    db $18, $28, $6e, $10
    db $18, $20, $6d, $10
    db $18, $18, $6c, $10
    db $18, $10, $6b, $10
    db $18, $08, $6a, $10
    db $10, $50, $69, $10
    db $10, $48, $68, $10
    db $10, $40, $67, $10
    db $10, $38, $66, $10
    db $10, $30, $65, $10
    db $10, $28, $64, $10
    db $10, $20, $63, $10
    db $10, $18, $62, $10
    db $10, $10, $61, $10
    db $10, $08, $60, $10
    db $80

; C: OAM list 5F of the table 5272
OamList_B02_5272_5F::
    db $f8, $18, $61, $10
    db $f8, $10, $60, $10
    db $f8, $08, $5f, $10
    db $f8, $00, $5e, $10
    db $f8, $f8, $5d, $10
    db $f0, $18, $5c, $10
    db $f0, $10, $5b, $10
    db $f0, $08, $5a, $10
    db $f0, $00, $59, $10
    db $f0, $f8, $58, $10
    db $f8, $f0, $53, $10
    db $f8, $e8, $52, $10
    db $f0, $f0, $51, $10
    db $f0, $e8, $50, $10
    db $80

; C: OAM list 60 of the table 5272
OamList_B02_5272_60::
    db $f8, $18, $76, $10
    db $f8, $10, $75, $10
    db $f8, $08, $74, $10
    db $f8, $00, $73, $10
    db $f8, $f8, $72, $10
    db $f0, $18, $66, $10
    db $f0, $10, $65, $10
    db $f0, $08, $64, $10
    db $f0, $00, $63, $10
    db $f0, $f8, $62, $10
    db $f8, $f0, $57, $10
    db $f8, $e8, $56, $10
    db $f0, $f0, $55, $10
    db $f0, $e8, $54, $10
    db $80

; C: OAM list 61 of the table 5272
OamList_B02_5272_61::
    db $f0, $f0, $02, $00
    db $f0, $e8, $00, $00
    db $80

; C: OAM list 62 of the table 5272
OamList_B02_5272_62::
    db $f0, $f0, $06, $00
    db $f0, $e8, $04, $00
    db $80

; C: OAM list 63 of the table 5272
OamList_B02_5272_63::
    db $f0, $f0, $0a, $00
    db $f0, $e8, $08, $00
    db $80

; C: OAM list 64 of the table 5272
OamList_B02_5272_64::
    db $f0, $f0, $0e, $00
    db $f0, $e8, $0c, $00
    db $80

; C: OAM list 65 of the table 5272
OamList_B02_5272_65::
    db $f0, $f0, $12, $00
    db $f0, $e8, $10, $00
    db $80

; C: OAM list 66 of the table 5272
OamList_B02_5272_66::
    db $f0, $f0, $16, $00
    db $f0, $e8, $14, $00
    db $80

; C: OAM list 67 of the table 5272
OamList_B02_5272_67::
    db $f8, $00, $2a, $00
    db $00, $f8, $28, $00
    db $f0, $f8, $26, $00
    db $00, $f0, $24, $00
    db $f0, $f0, $22, $00
    db $f8, $e8, $20, $00
    db $80

; C: OAM list 68 of the table 5272
OamList_B02_5272_68::
    db $f8, $00, $36, $00
    db $00, $f8, $34, $00
    db $f0, $f8, $32, $00
    db $00, $f0, $30, $00
    db $f0, $f0, $2e, $00
    db $f8, $e8, $2c, $00
    db $80

; C: OAM list 69 of the table 5272
OamList_B02_5272_69::
    db $f8, $00, $42, $00
    db $00, $f8, $40, $00
    db $f0, $f8, $3e, $00
    db $00, $f0, $3c, $00
    db $f0, $f0, $3a, $00
    db $f8, $e8, $38, $00
    db $80

; C: OAM list 6A of the table 5272
OamList_B02_5272_6A::
    db $f8, $00, $4e, $00
    db $00, $f8, $4c, $00
    db $f0, $f8, $4a, $00
    db $00, $f0, $48, $00
    db $f0, $f0, $46, $00
    db $f8, $e8, $44, $00
    db $80

; C: OAM list 6B of the table 5272
OamList_B02_5272_6B::
    db $f0, $f0, $1a, $00
    db $f0, $e8, $18, $00
    db $80

; C: OAM list 6C of the table 5272
OamList_B02_5272_6C::
    db $f0, $f1, $1a, $00
    db $f0, $e9, $18, $00
    db $80

; C: OAM list 6D of the table 5272
OamList_B02_5272_6D::
    db $f1, $f1, $1a, $00
    db $f1, $e9, $18, $00
    db $80

; C: OAM list 6E of the table 5272
OamList_B02_5272_6E::
    db $f1, $f0, $1a, $00
    db $f1, $e8, $18, $00
    db $80

; C: OAM list 6F of the table 5272
OamList_B02_5272_6F::
    db $f6, $fa, $1e, $00
    db $f6, $df, $1e, $20
    db $80

; C: OAM list 70 of the table 5272
OamList_B02_5272_70::
    db $f6, $fb, $1e, $00
    db $f6, $de, $1e, $20
    db $80

; C: OAM list 71 of the table 5272
OamList_B02_5272_71::
    db $fa, $04, $1e, $00
    db $fa, $df, $1e, $20
    db $80

; C: OAM list 72 of the table 5272
OamList_B02_5272_72::
    db $fa, $05, $1e, $00
    db $fa, $de, $1e, $20
    db $80

; C: OAM list 73 of the table 5272
OamList_B02_5272_73::
    db $f0, $30, $62, $10
    db $f0, $28, $60, $10
    db $f0, $20, $5e, $10
    db $f0, $18, $5c, $10
    db $f0, $10, $5a, $10
    db $f0, $08, $58, $10
    db $f0, $00, $56, $10
    db $f0, $f8, $54, $10
    db $f0, $f0, $52, $10
    db $f0, $e8, $50, $10
    db $80

; C: OAM list 74 of the table 5272
OamList_B02_5272_74::
    db $f0, $28, $74, $10
    db $f0, $20, $72, $10
    db $f0, $18, $70, $10
    db $f0, $10, $6e, $10
    db $f0, $08, $6c, $10
    db $f0, $00, $6a, $10
    db $f0, $f8, $68, $10
    db $f0, $f0, $66, $10
    db $f0, $e8, $64, $10
    db $80

; C: OAM list 75 of the table 5272
OamList_B02_5272_75::
    db $18, $10, $73, $10
    db $18, $08, $72, $10
    db $10, $10, $71, $10
    db $10, $08, $70, $10
    db $80

; C: OAM list 76 of the table 5272
OamList_B02_5272_76::
    db $18, $10, $77, $10
    db $18, $08, $76, $10
    db $10, $10, $75, $10
    db $10, $08, $74, $10
    db $80

; C: OAM list 77 of the table 5272
OamList_B02_5272_77::
    db $17, $10, $73, $10
    db $17, $08, $72, $10
    db $0f, $10, $71, $10
    db $0f, $08, $70, $10
    db $80

; C: OAM list 78 of the table 5272
OamList_B02_5272_78::
    db $19, $10, $73, $10
    db $19, $08, $72, $10
    db $11, $10, $71, $10
    db $11, $08, $70, $10
    db $80

; C: OAM list 79 of the table 5272
OamList_B02_5272_79::
    db $10, $10, $79, $00
    db $10, $08, $78, $00
    db $80

; C: OAM list 7A of the table 5272
OamList_B02_5272_7A::
    db $11, $17, $00, $30
    db $1f, $17, $00, $70
    db $1f, $09, $00, $50
    db $11, $09, $00, $10
    db $80

; C: OAM list 7B of the table 5272
OamList_B02_5272_7B::
    db $10, $18, $00, $30
    db $20, $18, $00, $70
    db $20, $08, $00, $50
    db $10, $08, $00, $10
    db $80

; C: OAM list 7C of the table 5272
OamList_B02_5272_7C::
    db $18, $08, $02, $00
    db $80

; C: OAM list 7D of the table 5272
OamList_B02_5272_7D::
    db $1f, $0f, $01, $30
    db $1f, $08, $01, $10
    db $f0, $0f, $01, $70
    db $f0, $08, $01, $50
    db $80

; C: OAM list 7E of the table 5272
OamList_B02_5272_7E::
    db $18, $18, $11, $00
    db $18, $10, $10, $00
    db $18, $08, $0f, $00
    db $18, $00, $0e, $00
    db $18, $f8, $0d, $00
    db $10, $18, $0c, $00
    db $10, $10, $0b, $00
    db $10, $08, $0a, $00
    db $10, $00, $09, $00
    db $10, $f8, $08, $00
    db $08, $18, $07, $00
    db $08, $10, $06, $00
    db $08, $08, $05, $00
    db $08, $00, $04, $00
    db $08, $f8, $03, $00
    db $00, $08, $02, $00
    db $00, $00, $01, $00
    db $00, $f8, $00, $00
    db $80

; C: OAM list 7F of the table 5272
OamList_B02_5272_7F::
    db $10, $f8, $13, $00
    db $08, $f8, $12, $00
    db $18, $18, $11, $00
    db $18, $10, $10, $00
    db $18, $08, $0f, $00
    db $18, $00, $0e, $00
    db $18, $f8, $0d, $00
    db $10, $18, $0c, $00
    db $10, $10, $0b, $00
    db $10, $08, $0a, $00
    db $10, $00, $09, $00
    db $08, $18, $07, $00
    db $08, $10, $06, $00
    db $08, $08, $05, $00
    db $08, $00, $04, $00
    db $00, $08, $02, $00
    db $00, $00, $01, $00
    db $00, $f8, $00, $00
    db $80

; C: OAM list 80 of the table 5272
OamList_B02_5272_80::
    db $18, $f8, $15, $00
    db $10, $f8, $14, $00
    db $18, $18, $11, $00
    db $18, $10, $10, $00
    db $18, $08, $0f, $00
    db $18, $00, $0e, $00
    db $10, $18, $0c, $00
    db $10, $10, $0b, $00
    db $10, $08, $0a, $00
    db $10, $00, $09, $00
    db $08, $18, $07, $00
    db $08, $10, $06, $00
    db $08, $08, $05, $00
    db $08, $00, $04, $00
    db $08, $f8, $03, $00
    db $00, $08, $02, $00
    db $00, $00, $01, $00
    db $00, $f8, $00, $00
    db $80

; C: OAM list 81 of the table 5272
OamList_B02_5272_81::
    db $00, $08, $19, $10
    db $00, $00, $18, $10
    db $08, $08, $17, $10
    db $08, $00, $16, $10
    db $80

; C: OAM list 82 of the table 5272
OamList_B02_5272_82::
    db $ff, $08, $19, $10
    db $ff, $00, $18, $10
    db $07, $08, $17, $10
    db $07, $00, $16, $10
    db $80

; C: OAM list 83 of the table 5272
OamList_B02_5272_83::
    db $fe, $08, $19, $10
    db $fe, $00, $18, $10
    db $06, $08, $17, $10
    db $06, $00, $16, $10
    db $80

; C: OAM list 84 of the table 5272
OamList_B02_5272_84::
    db $10, $08, $19, $50
    db $10, $00, $18, $50
    db $08, $08, $17, $50
    db $08, $00, $16, $50
    db $80

; C: OAM list 85 of the table 5272
OamList_B02_5272_85::
    db $11, $08, $19, $50
    db $11, $00, $18, $50
    db $09, $08, $17, $50
    db $09, $00, $16, $50
    db $80

; C: OAM list 86 of the table 5272
OamList_B02_5272_86::
    db $12, $08, $19, $50
    db $12, $00, $18, $50
    db $0a, $08, $17, $50
    db $0a, $00, $16, $50
    db $80

; C: OAM list 87 of the table 5272
OamList_B02_5272_87::
    db $0c, $f0, $1a, $00
    db $0c, $f8, $1a, $00
    db $0c, $20, $1a, $00
    db $0c, $10, $1a, $00
    db $0c, $18, $1a, $00
    db $0c, $08, $1a, $00
    db $0c, $00, $1a, $00
    db $80

; C: OAM list 88 of the table 5272
OamList_B02_5272_88::
    db $0a, $f0, $1a, $00
    db $0a, $f8, $1a, $00
    db $0a, $20, $1a, $00
    db $0a, $10, $1a, $00
    db $0a, $18, $1a, $00
    db $0a, $08, $1a, $00
    db $0a, $00, $1a, $00
    db $80

; C: OAM list 89 of the table 5272
OamList_B02_5272_89::
    db $08, $f0, $1a, $00
    db $08, $f8, $1a, $00
    db $08, $20, $1a, $00
    db $08, $10, $1a, $00
    db $08, $18, $1a, $00
    db $08, $08, $1a, $00
    db $08, $00, $1a, $00
    db $80

; C: OAM list 8A of the table 5272
OamList_B02_5272_8A::
    db $06, $f0, $1a, $00
    db $06, $f8, $1a, $00
    db $06, $20, $1a, $00
    db $06, $10, $1a, $00
    db $06, $18, $1a, $00
    db $06, $08, $1a, $00
    db $06, $00, $1a, $00
    db $80

; C: OAM list 8B of the table 5272
OamList_B02_5272_8B::
    db $04, $f0, $1a, $00
    db $04, $f8, $1a, $00
    db $04, $20, $1a, $00
    db $04, $10, $1a, $00
    db $04, $18, $1a, $00
    db $04, $08, $1a, $00
    db $04, $00, $1a, $00
    db $80

; C: OAM list 8C of the table 5272
OamList_B02_5272_8C::
    db $02, $f0, $1a, $00
    db $02, $f8, $1a, $00
    db $02, $20, $1a, $00
    db $02, $10, $1a, $00
    db $02, $18, $1a, $00
    db $02, $08, $1a, $00
    db $02, $00, $1a, $00
    db $80

; C: OAM list 8D of the table 5272
OamList_B02_5272_8D::
    db $00, $f0, $1a, $00
    db $00, $f8, $1a, $00
    db $00, $20, $1a, $00
    db $00, $10, $1a, $00
    db $00, $18, $1a, $00
    db $00, $08, $1a, $00
    db $00, $00, $1a, $00
    db $80

; C: OAM list 8E of the table 5272
OamList_B02_5272_8E::
    db $08, $08, $a1, $00
    db $10, $08, $a1, $00
    db $10, $00, $a1, $00
    db $08, $00, $a1, $00
    db $80

; C: OAM list 8F of the table 5272
OamList_B02_5272_8F::
    db $08, $08, $00, $00
    db $80

; C: OAM list 90 of the table 5272
OamList_B02_5272_90::
    db $08, $08, $01, $00
    db $80

; C: OAM list 91 of the table 5272
OamList_B02_5272_91::
    db $08, $18, $07, $00
    db $08, $10, $06, $00
    db $08, $08, $05, $00
    db $00, $18, $04, $00
    db $00, $10, $03, $00
    db $00, $08, $02, $00
    db $80

; C: OAM list 92 of the table 5272
OamList_B02_5272_92::
    db $08, $18, $19, $00
    db $08, $10, $18, $00
    db $08, $08, $17, $00
    db $00, $18, $16, $00
    db $00, $10, $15, $00
    db $00, $08, $14, $00
    db $80

; C: OAM list 93 of the table 5272
OamList_B02_5272_93::
    db $00, $18, $0a, $00
    db $00, $10, $09, $00
    db $00, $08, $08, $00
    db $08, $18, $0d, $00
    db $08, $10, $0c, $00
    db $08, $08, $0b, $00
    db $80

; C: OAM list 94 of the table 5272
OamList_B02_5272_94::
    db $08, $18, $1f, $00
    db $08, $10, $1e, $00
    db $08, $08, $1d, $00
    db $00, $18, $1c, $00
    db $00, $10, $1b, $00
    db $00, $08, $1a, $00
    db $80

; C: OAM list 95 of the table 5272
OamList_B02_5272_95::
    db $08, $18, $13, $00
    db $08, $10, $12, $00
    db $08, $08, $11, $00
    db $00, $18, $10, $00
    db $00, $10, $0f, $00
    db $00, $08, $0e, $00
    db $80

; C: OAM list 96 of the table 5272
OamList_B02_5272_96::
    db $08, $18, $25, $00
    db $08, $10, $24, $00
    db $08, $08, $23, $00
    db $00, $18, $22, $00
    db $00, $10, $21, $00
    db $00, $08, $20, $00
    db $80

; C: OAM list 97 of the table 5272
OamList_B02_5272_97::
    db $18, $08, $38, $00
    db $10, $08, $28, $00
    db $10, $00, $37, $00
    db $08, $00, $27, $00
    db $08, $f8, $36, $00
    db $00, $f8, $26, $00
    db $80

; C: OAM list 98 of the table 5272
OamList_B02_5272_98::
    db $17, $08, $38, $00
    db $0f, $08, $28, $00
    db $11, $00, $37, $00
    db $09, $00, $27, $00
    db $07, $f8, $36, $00
    db $ff, $f8, $26, $00
    db $80

; C: OAM list 99 of the table 5272
OamList_B02_5272_99::
    db $19, $08, $38, $00
    db $11, $08, $28, $00
    db $0f, $00, $37, $00
    db $07, $00, $27, $00
    db $09, $f8, $36, $00
    db $01, $f8, $26, $00
    db $80

; C: OAM list 9A of the table 5272
OamList_B02_5272_9A::
    db $16, $08, $34, $00
    db $18, $00, $3b, $00
    db $10, $00, $2b, $00
    db $09, $00, $3a, $00
    db $01, $00, $2a, $00
    db $08, $f8, $39, $00
    db $00, $f8, $29, $00
    db $80

; C: OAM list 9B of the table 5272
OamList_B02_5272_9B::
    db $15, $08, $34, $00
    db $19, $00, $3b, $00
    db $11, $00, $2b, $00
    db $08, $00, $3a, $00
    db $00, $00, $2a, $00
    db $09, $f7, $39, $00
    db $01, $f7, $29, $00
    db $80

; C: OAM list 9C of the table 5272
OamList_B02_5272_9C::
    db $17, $09, $34, $00
    db $17, $ff, $3b, $00
    db $0f, $ff, $2b, $00
    db $0a, $01, $3a, $00
    db $02, $01, $2a, $00
    db $07, $f7, $39, $00
    db $ff, $f7, $29, $00
    db $80

; C: OAM list 9D of the table 5272
OamList_B02_5272_9D::
    db $18, $0a, $41, $00
    db $10, $0a, $31, $00
    db $18, $02, $40, $00
    db $10, $02, $30, $00
    db $17, $fa, $35, $00
    db $08, $04, $3f, $00
    db $00, $04, $2f, $00
    db $08, $fc, $3e, $00
    db $08, $f4, $3d, $00
    db $00, $fc, $2e, $00
    db $00, $f4, $2d, $00
    db $80

; C: OAM list 9E of the table 5272
OamList_B02_5272_9E::
    db $19, $09, $41, $00
    db $11, $09, $31, $00
    db $17, $01, $40, $00
    db $0f, $01, $30, $00
    db $18, $f9, $35, $00
    db $09, $05, $3f, $00
    db $01, $05, $2f, $00
    db $07, $fd, $3e, $00
    db $09, $f5, $3d, $00
    db $ff, $fd, $2e, $00
    db $01, $f5, $2d, $00
    db $80

; C: OAM list 9F of the table 5272
OamList_B02_5272_9F::
    db $17, $0a, $41, $00
    db $0f, $0a, $31, $00
    db $19, $02, $40, $00
    db $11, $02, $30, $00
    db $16, $fa, $35, $00
    db $07, $04, $3f, $00
    db $ff, $04, $2f, $00
    db $09, $fc, $3e, $00
    db $07, $f4, $3d, $00
    db $01, $fc, $2e, $00
    db $ff, $f4, $2d, $00
    db $80

; C: OAM list A0 of the table 5272
OamList_B02_5272_A0::
    db $18, $0a, $3d, $00
    db $10, $0a, $2d, $00
    db $18, $02, $43, $00
    db $10, $02, $33, $00
    db $18, $fa, $3c, $00
    db $10, $fa, $2c, $00
    db $08, $04, $38, $00
    db $00, $04, $28, $00
    db $07, $fc, $34, $00
    db $08, $f4, $42, $00
    db $00, $f4, $32, $00
    db $80

; C: OAM list A1 of the table 5272
OamList_B02_5272_A1::
    db $19, $09, $3d, $00
    db $11, $09, $2d, $00
    db $17, $01, $43, $00
    db $0f, $01, $33, $00
    db $19, $f9, $3c, $00
    db $11, $f9, $2c, $00
    db $09, $05, $38, $00
    db $01, $05, $28, $00
    db $06, $fd, $34, $00
    db $09, $f5, $42, $00
    db $01, $f5, $32, $00
    db $80

; C: OAM list A2 of the table 5272
OamList_B02_5272_A2::
    db $17, $0a, $3d, $00
    db $0f, $0a, $2d, $00
    db $19, $02, $43, $00
    db $11, $02, $33, $00
    db $17, $fa, $3c, $00
    db $0f, $fa, $2c, $00
    db $07, $04, $38, $00
    db $ff, $04, $28, $00
    db $08, $fc, $34, $00
    db $07, $f4, $42, $00
    db $ff, $f4, $32, $00
    db $80

; C: OAM list A3 of the table 5272
OamList_B02_5272_A3::
    db $16, $08, $44, $40
    db $03, $08, $44, $00
    db $80

; C: OAM list A4 of the table 5272
OamList_B02_5272_A4::
    db $0c, $08, $45, $00
    db $80

; C: OAM list A5 of the table 5272
OamList_B02_5272_A5::
    db $00, $f8, $0a, $00
    db $00, $f0, $08, $00
    db $00, $e8, $06, $00
    db $f0, $f8, $04, $00
    db $f0, $f0, $02, $00
    db $f0, $e8, $00, $00
    db $80

; C: OAM list A6 of the table 5272
OamList_B02_5272_A6::
    db $00, $f8, $16, $00
    db $f0, $f8, $14, $00
    db $00, $f0, $12, $00
    db $f0, $f0, $10, $00
    db $00, $e8, $0e, $00
    db $f0, $e8, $0c, $00
    db $80

; C: OAM list A7 of the table 5272
OamList_B02_5272_A7::
    db $00, $f8, $22, $00
    db $00, $f0, $20, $00
    db $00, $e8, $1e, $00
    db $f0, $f8, $1c, $00
    db $f0, $f0, $1a, $00
    db $f0, $e8, $18, $00
    db $80

; C: OAM list A8 of the table 5272
OamList_B02_5272_A8::
    db $f0, $18, $30, $10
    db $f0, $10, $2e, $10
    db $f0, $08, $2c, $10
    db $f0, $00, $2a, $10
    db $f0, $f8, $28, $10
    db $f0, $f0, $26, $10
    db $f0, $e8, $24, $10
    db $80

; C: OAM list A9 of the table 5272
OamList_B02_5272_A9::
    db $f0, $18, $3e, $10
    db $f0, $10, $3c, $10
    db $f0, $08, $3a, $10
    db $f0, $00, $38, $10
    db $f0, $f8, $36, $10
    db $f0, $f0, $34, $10
    db $f0, $e8, $32, $10
    db $80

; C: OAM list AA of the table 5272
OamList_B02_5272_AA::
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
OamList_B02_5272_AB::
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
OamList_B02_5272_AC::
    db $08, $00, $8b, $10
    db $00, $00, $8a, $10
    db $08, $0b, $93, $30
    db $00, $0b, $92, $30
    db $08, $f5, $93, $10
    db $00, $f5, $92, $10
    db $80

; C: OAM list AD of the table 5272
OamList_B02_5272_AD::
    db $0b, $0b, $95, $20
    db $03, $0b, $94, $20
    db $0b, $f5, $95, $00
    db $03, $f5, $94, $00
    db $08, $00, $8b, $10
    db $00, $00, $8a, $10
    db $80

; C: OAM list AE of the table 5272
OamList_B02_5272_AE::
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
OamList_B02_5272_AF::
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
OamList_B02_5272_B0::
    db $18, $08, $af, $10
    db $18, $00, $ae, $10
    db $10, $08, $9f, $10
    db $10, $00, $9e, $10
    db $80

; C: OAM list B1 of the table 5272
OamList_B02_5272_B1::
    db $10, $10, $a3, $10
    db $10, $08, $a2, $10
    db $08, $10, $a1, $10
    db $08, $08, $a0, $10
    db $80

; C: OAM list B2 of the table 5272
OamList_B02_5272_B2::
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
OamList_B02_5272_B3::
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
OamList_B02_5272_B4::
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
OamList_B02_5272_B5::
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
OamList_B02_5272_B6::
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
OamList_B02_5272_B7::
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
OamList_B02_5272_B8::
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
OamList_B02_5272_B9::
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
OamList_B02_5272_BA::
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
OamList_B02_5272_BB::
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
OamList_B02_5272_BC::
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
OamList_B02_5272_BD::
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
OamList_B02_5272_BE::
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
OamList_B02_5272_BF::
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
OamList_B02_5272_C0::
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
OamList_B02_5272_C1::
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
OamList_B02_5272_C2::
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
OamList_B02_5272_C3::
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
OamList_B02_5272_C4::
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

; C: OAM list C5 of the table 5272
OamList_B02_5272_C5::
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
    db $10, $0e, $57, $10
    db $10, $06, $56, $10
    db $10, $fe, $55, $10
    db $08, $0e, $54, $10
    db $08, $06, $53, $10
    db $08, $fe, $52, $10
    db $10, $f6, $51, $30
    db $10, $ee, $51, $10
    db $08, $ee, $50, $10
    db $08, $f6, $50, $30
    db $80

; C: OAM list C6 of the table 5272
OamList_B02_5272_C6::
    db $10, $08, $71, $10
    db $10, $00, $70, $10
    db $08, $08, $6f, $10
    db $08, $00, $6e, $10
    db $80

; C: OAM list C7 of the table 5272
OamList_B02_5272_C7::
    db $08, $08, $6b, $10
    db $08, $00, $6a, $10
    db $10, $08, $6d, $10
    db $10, $00, $6c, $10
    db $80

; C: OAM list C8 of the table 5272
OamList_B02_5272_C8::
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
OamList_B02_5272_C9::
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
OamList_B02_5272_CA::
    db $f0, $e0, $f4, $10
    db $e8, $e8, $f3, $10
    db $e8, $e0, $f2, $10
    db $e0, $e8, $f1, $10
    db $e0, $e0, $f0, $10
    db $80

; C: 122 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B02_6E4B (00:2464)
OamPtrTbl_B02_6E4B::
    dw OamList_B02_6E4B_00
    dw OamList_B02_6E4B_01
    dw OamList_B02_6E4B_02
    dw OamList_B02_6E4B_03
    dw OamList_B02_6E4B_04
    dw OamList_B02_6E4B_05
    dw OamList_B02_6E4B_06
    dw OamList_B02_6E4B_07
    dw OamList_B02_6E4B_08
    dw OamList_B02_6E4B_09
    dw OamList_B02_6E4B_0A
    dw OamList_B02_6E4B_0B
    dw OamList_B02_6E4B_0C
    dw OamList_B02_6E4B_0D
    dw OamList_B02_6E4B_0E
    dw OamList_B02_6E4B_0F
    dw OamList_B02_6E4B_10
    dw OamList_B02_6E4B_11
    dw OamList_B02_6E4B_12
    dw OamList_B02_6E4B_13
    dw OamList_B02_6E4B_14
    dw OamList_B02_6E4B_15
    dw OamList_B02_6E4B_16
    dw OamList_B02_6E4B_17
    dw OamList_B02_6E4B_18
    dw OamList_B02_6E4B_19
    dw OamList_B02_6E4B_1A
    dw OamList_B02_6E4B_1B
    dw OamList_B02_6E4B_1C
    dw OamList_B02_6E4B_1D
    dw OamList_B02_6E4B_1E
    dw OamList_B02_6E4B_1F
    dw OamList_B02_6E4B_20
    dw OamList_B02_6E4B_21
    dw OamList_B02_6E4B_22
    dw OamList_B02_6E4B_23
    dw OamList_B02_6E4B_24
    dw OamList_B02_6E4B_25
    dw OamList_B02_6E4B_26
    dw OamList_B02_6E4B_27
    dw OamList_B02_6E4B_28
    dw OamList_B02_6E4B_29
    dw OamList_B02_6E4B_2A
    dw OamList_B02_6E4B_2B
    dw OamList_B02_6E4B_2C
    dw OamList_B02_6E4B_2D
    dw OamList_B02_6E4B_2E
    dw OamList_B02_6E4B_2F
    dw OamList_B02_6E4B_30
    dw OamList_B02_6E4B_31
    dw OamList_B02_6E4B_32
    dw OamList_B02_6E4B_33
    dw OamList_B02_6E4B_34
    dw OamList_B02_6E4B_35
    dw OamList_B02_6E4B_36
    dw OamList_B02_6E4B_37
    dw OamList_B02_6E4B_38
    dw OamList_B02_6E4B_39
    dw OamList_B02_6E4B_3A
    dw OamList_B02_6E4B_3B
    dw OamList_B02_6E4B_3C
    dw OamList_B02_6E4B_3D
    dw OamList_B02_6E4B_3E
    dw OamList_B02_6E4B_3F
    dw OamList_B02_6E4B_40
    dw OamList_B02_6E4B_41
    dw OamList_B02_6E4B_42
    dw OamList_B02_6E4B_43
    dw OamList_B02_6E4B_44
    dw OamList_B02_6E4B_45
    dw OamList_B02_6E4B_46
    dw OamList_B02_6E4B_47
    dw OamList_B02_6E4B_48
    dw OamList_B02_6E4B_49
    dw OamList_B02_6E4B_4A
    dw OamList_B02_6E4B_4B
    dw OamList_B02_6E4B_4C
    dw OamList_B02_6E4B_4D
    dw OamList_B02_6E4B_4E
    dw OamList_B02_6E4B_4F
    dw OamList_B02_6E4B_50
    dw OamList_B02_6E4B_51
    dw OamList_B02_6E4B_52
    dw OamList_B02_6E4B_53
    dw OamList_B02_6E4B_54
    dw OamList_B02_6E4B_55
    dw OamList_B02_6E4B_56
    dw OamList_B02_6E4B_57
    dw OamList_B02_6E4B_58
    dw OamList_B02_6E4B_59
    dw OamList_B02_6E4B_5A
    dw OamList_B02_6E4B_5B
    dw OamList_B02_6E4B_5C
    dw OamList_B02_6E4B_5D
    dw OamList_B02_6E4B_5E
    dw OamList_B02_6E4B_5F
    dw OamList_B02_6E4B_60
    dw OamList_B02_6E4B_61
    dw OamList_B02_6E4B_62
    dw OamList_B02_6E4B_63
    dw OamList_B02_6E4B_64
    dw OamList_B02_6E4B_65
    dw OamList_B02_6E4B_66
    dw OamList_B02_6E4B_67
    dw OamList_B02_6E4B_68
    dw OamList_B02_6E4B_69
    dw OamList_B02_6E4B_6A
    dw OamList_B02_6E4B_6B
    dw OamList_B02_6E4B_6C
    dw OamList_B02_6E4B_6D
    dw OamList_B02_6E4B_6E
    dw OamList_B02_6E4B_6F
    dw OamList_B02_6E4B_70
    dw OamList_B02_6E4B_71
    dw OamList_B02_6E4B_72
    dw OamList_B02_6E4B_73
    dw OamList_B02_6E4B_74
    dw OamList_B02_6E4B_75
    dw OamList_B02_6E4B_76
    dw OamList_B02_6E4B_77
    dw OamList_B02_6E4B_78
    dw OamList_B02_6E4B_79

; C: OAM list 00 of the table 6E4B
OamList_B02_6E4B_00::
    db $10, $08, $de, $10
    db $10, $00, $dd, $10
    db $80

; C: OAM list 01 of the table 6E4B
OamList_B02_6E4B_01::
    db $08, $08, $de, $50
    db $08, $00, $dd, $50
    db $80

; C: OAM list 02 of the table 6E4B
OamList_B02_6E4B_02::
    db $18, $40, $cf, $10
    db $10, $40, $bf, $10
    db $18, $08, $cf, $10
    db $10, $08, $bf, $10
    db $80

; C: OAM list 03 of the table 6E4B
OamList_B02_6E4B_03::
    db $18, $40, $dc, $10
    db $10, $40, $db, $10
    db $18, $08, $dc, $10
    db $10, $08, $db, $10
    db $80

; C: OAM list 04 of the table 6E4B
OamList_B02_6E4B_04::
    db $10, $2b, $d0, $10
    db $10, $08, $d0, $10
    db $80

; C: OAM list 05 of the table 6E4B
OamList_B02_6E4B_05::
    db $10, $2b, $d1, $10
    db $10, $08, $d1, $10
    db $80

; C: OAM list 06 of the table 6E4B
OamList_B02_6E4B_06::
    db $0f, $2b, $d0, $50
    db $0f, $08, $d0, $50
    db $80

; C: OAM list 07 of the table 6E4B
OamList_B02_6E4B_07::
    db $10, $2b, $d2, $10
    db $10, $08, $d2, $10
    db $80

; C: OAM list 08 of the table 6E4B
OamList_B02_6E4B_08::
    db $18, $10, $da, $10
    db $18, $08, $d9, $10
    db $10, $10, $d8, $10
    db $10, $08, $d7, $10
    db $80

; C: OAM list 09 of the table 6E4B
OamList_B02_6E4B_09::
    db $18, $10, $d6, $10
    db $18, $08, $d5, $10
    db $10, $10, $d4, $10
    db $10, $08, $d3, $10
    db $80

; C: OAM list 0A of the table 6E4B
OamList_B02_6E4B_0A::
    db $10, $10, $da, $50
    db $10, $08, $d9, $50
    db $18, $10, $d8, $50
    db $18, $08, $d7, $50
    db $80

; C: OAM list 0B of the table 6E4B
OamList_B02_6E4B_0B::
    db $10, $10, $d6, $50
    db $10, $08, $d5, $50
    db $18, $10, $d4, $50
    db $18, $08, $d3, $50
    db $80

; C: OAM list 0C of the table 6E4B
OamList_B02_6E4B_0C::
    db $08, $08, $70, $00
    db $08, $00, $70, $00
    db $80

; C: OAM list 0D of the table 6E4B
OamList_B02_6E4B_0D::
    db $08, $18, $70, $00
    db $08, $10, $70, $00
    db $08, $e8, $70, $00
    db $08, $08, $70, $00
    db $08, $f0, $70, $00
    db $08, $00, $70, $00
    db $08, $f8, $70, $00
    db $80

; C: OAM list 0E of the table 6E4B
OamList_B02_6E4B_0E::
    db $0c, $18, $70, $00
    db $04, $18, $70, $00
    db $04, $10, $70, $00
    db $04, $e8, $70, $00
    db $04, $08, $70, $00
    db $04, $f0, $70, $00
    db $04, $00, $70, $00
    db $04, $f8, $70, $00
    db $0c, $10, $70, $00
    db $0c, $e8, $70, $00
    db $0c, $08, $70, $00
    db $0c, $f0, $70, $00
    db $0c, $00, $70, $00
    db $0c, $f8, $70, $00
    db $80

; C: OAM list 0F of the table 6E4B
OamList_B02_6E4B_0F::
    db $10, $18, $70, $00
    db $08, $18, $70, $00
    db $00, $18, $70, $00
    db $10, $10, $70, $00
    db $10, $e8, $70, $00
    db $10, $08, $70, $00
    db $10, $f0, $70, $00
    db $10, $00, $70, $00
    db $10, $f8, $70, $00
    db $00, $10, $70, $00
    db $00, $e8, $70, $00
    db $00, $08, $70, $00
    db $00, $f0, $70, $00
    db $00, $00, $70, $00
    db $00, $f8, $70, $00
    db $08, $10, $70, $00
    db $08, $e8, $70, $00
    db $08, $08, $70, $00
    db $08, $f0, $70, $00
    db $08, $00, $70, $00
    db $08, $f8, $70, $00
    db $80

; C: OAM list 10 of the table 6E4B
OamList_B02_6E4B_10::
    db $08, $e8, $7c, $10
    db $10, $e8, $7d, $10
    db $10, $e8, $70, $10
    db $08, $e8, $70, $10
    db $08, $f8, $7f, $10
    db $08, $08, $7e, $10
    db $10, $10, $7b, $10
    db $08, $10, $7a, $10
    db $10, $00, $79, $10
    db $08, $00, $78, $10
    db $10, $f0, $77, $10
    db $08, $f0, $76, $10
    db $10, $18, $70, $10
    db $00, $18, $70, $10
    db $08, $18, $70, $10
    db $00, $10, $75, $10
    db $00, $08, $74, $10
    db $00, $00, $73, $10
    db $00, $f8, $72, $10
    db $00, $f0, $71, $10
    db $10, $08, $70, $10
    db $10, $f8, $70, $10
    db $00, $e8, $70, $10
    db $80

; C: OAM list 11 of the table 6E4B
OamList_B02_6E4B_11::
    db $08, $f8, $7c, $10
    db $10, $f8, $7d, $10
    db $10, $e8, $70, $10
    db $08, $e8, $70, $10
    db $08, $f8, $7f, $10
    db $08, $08, $7e, $10
    db $10, $10, $7b, $10
    db $08, $10, $7a, $10
    db $10, $00, $79, $10
    db $08, $00, $78, $10
    db $10, $f0, $77, $10
    db $08, $f0, $76, $10
    db $10, $18, $70, $10
    db $00, $18, $70, $10
    db $08, $18, $70, $10
    db $00, $10, $75, $10
    db $00, $08, $74, $10
    db $00, $00, $73, $10
    db $00, $f8, $72, $10
    db $00, $f0, $71, $10
    db $10, $08, $70, $10
    db $10, $f8, $70, $10
    db $00, $e8, $70, $10
    db $80

; C: OAM list 12 of the table 6E4B
OamList_B02_6E4B_12::
    db $08, $08, $7c, $10
    db $10, $08, $7d, $10
    db $10, $e8, $70, $10
    db $08, $e8, $70, $10
    db $08, $f8, $7f, $10
    db $08, $08, $7e, $10
    db $10, $10, $7b, $10
    db $08, $10, $7a, $10
    db $10, $00, $79, $10
    db $08, $00, $78, $10
    db $10, $f0, $77, $10
    db $08, $f0, $76, $10
    db $10, $18, $70, $10
    db $00, $18, $70, $10
    db $08, $18, $70, $10
    db $00, $10, $75, $10
    db $00, $08, $74, $10
    db $00, $00, $73, $10
    db $00, $f8, $72, $10
    db $00, $f0, $71, $10
    db $10, $08, $70, $10
    db $10, $f8, $70, $10
    db $00, $e8, $70, $10
    db $80

; C: OAM list 13 of the table 6E4B
OamList_B02_6E4B_13::
    db $03, $18, $dc, $00
    db $fa, $fd, $d0, $00
    db $0b, $fd, $d6, $00
    db $fb, $10, $da, $00
    db $03, $05, $d4, $00
    db $fb, $0d, $d8, $00
    db $f3, $05, $d2, $00
    db $80

; C: OAM list 14 of the table 6E4B
OamList_B02_6E4B_14::
    db $fd, $13, $e2, $00
    db $09, $0b, $e6, $00
    db $09, $03, $e4, $00
    db $f9, $0b, $e0, $00
    db $f9, $03, $de, $00
    db $80

; C: OAM list 15 of the table 6E4B
OamList_B02_6E4B_15::
    db $f3, $ff, $e8, $00
    db $03, $0f, $ee, $00
    db $fb, $07, $ec, $00
    db $eb, $07, $ea, $00
    db $80

; C: OAM list 16 of the table 6E4B
OamList_B02_6E4B_16::
    db $f9, $11, $fa, $00
    db $f9, $19, $fc, $00
    db $00, $01, $f4, $00
    db $f0, $11, $f8, $00
    db $f8, $09, $f6, $00
    db $f0, $01, $f2, $00
    db $f0, $f9, $f0, $00
    db $80

; C: OAM list 17 of the table 6E4B
OamList_B02_6E4B_17::
    db $fc, $08, $04, $20
    db $fc, $10, $02, $20
    db $ec, $08, $00, $20
    db $ec, $10, $fe, $20
    db $fc, $00, $04, $00
    db $fc, $f8, $02, $00
    db $ec, $00, $00, $00
    db $ec, $f8, $fe, $00
    db $80

; C: OAM list 18 of the table 6E4B
OamList_B02_6E4B_18::
    db $fe, $08, $0c, $20
    db $fe, $10, $0a, $20
    db $ee, $08, $08, $20
    db $ee, $10, $06, $20
    db $fe, $00, $0c, $00
    db $fe, $f8, $0a, $00
    db $ee, $00, $08, $00
    db $ee, $f8, $06, $00
    db $80

; C: OAM list 19 of the table 6E4B
OamList_B02_6E4B_19::
    db $02, $08, $10, $20
    db $f2, $08, $0e, $20
    db $02, $00, $10, $00
    db $f2, $00, $0e, $00
    db $80

; C: OAM list 1A of the table 6E4B
OamList_B02_6E4B_1A::
    db $fd, $0c, $18, $20
    db $ed, $0c, $14, $20
    db $ed, $14, $12, $20
    db $fd, $fc, $18, $00
    db $f5, $04, $16, $00
    db $ed, $fc, $14, $00
    db $ed, $f4, $12, $00
    db $80

; C: OAM list 1B of the table 6E4B
OamList_B02_6E4B_1B::
    db $00, $00, $ae, $10
    db $00, $f8, $ac, $10
    db $80

; C: OAM list 1C of the table 6E4B
OamList_B02_6E4B_1C::
    db $f8, $00, $b0, $10
    db $00, $00, $ae, $10
    db $00, $f8, $ac, $10
    db $80

; C: OAM list 1D of the table 6E4B
OamList_B02_6E4B_1D::
    db $00, $fb, $ae, $10
    db $00, $f3, $ac, $10
    db $80

; C: OAM list 1E of the table 6E4B
OamList_B02_6E4B_1E::
    db $00, $f3, $28, $10
    db $0b, $eb, $26, $10
    db $0b, $e3, $24, $10
    db $80

; C: OAM list 1F of the table 6E4B
OamList_B02_6E4B_1F::
    db $00, $0c, $2e, $10
    db $00, $04, $2c, $10
    db $f8, $fc, $2a, $10
    db $80

; C: OAM list 20 of the table 6E4B
OamList_B02_6E4B_20::
    db $fa, $0a, $34, $10
    db $fa, $02, $32, $10
    db $fa, $fa, $30, $10
    db $80

; C: OAM list 21 of the table 6E4B
OamList_B02_6E4B_21::
    db $01, $0a, $3a, $10
    db $f9, $02, $38, $10
    db $f9, $fa, $36, $10
    db $80

; C: OAM list 22 of the table 6E4B
OamList_B02_6E4B_22::
    db $f7, $fa, $50, $10
    db $ff, $02, $52, $10
    db $ff, $0a, $54, $10
    db $80

; C: OAM list 23 of the table 6E4B
OamList_B02_6E4B_23::
    db $fc, $40, $5c, $10
    db $fc, $30, $5a, $10
    db $fc, $38, $44, $10
    db $fc, $28, $40, $10
    db $00, $20, $66, $10
    db $00, $18, $64, $10
    db $00, $10, $62, $10
    db $00, $08, $60, $10
    db $80

; C: OAM list 24 of the table 6E4B
OamList_B02_6E4B_24::
    db $fc, $40, $44, $10
    db $fc, $38, $5a, $10
    db $fc, $28, $56, $10
    db $fc, $30, $58, $10
    db $00, $20, $76, $10
    db $00, $18, $74, $10
    db $00, $10, $72, $10
    db $00, $08, $70, $10
    db $80

; C: OAM list 25 of the table 6E4B
OamList_B02_6E4B_25::
    db $fc, $3d, $44, $10
    db $fc, $38, $7c, $10
    db $fc, $30, $7a, $10
    db $fc, $28, $78, $10
    db $00, $20, $6e, $10
    db $00, $18, $6c, $10
    db $00, $10, $6a, $10
    db $00, $08, $68, $10
    db $80

; C: OAM list 26 of the table 6E4B
OamList_B02_6E4B_26::
    db $00, $14, $5e, $00
    db $00, $0c, $5e, $00
    db $00, $04, $5e, $00
    db $00, $fc, $5e, $00
    db $00, $f4, $5e, $00
    db $80

; C: OAM list 27 of the table 6E4B
OamList_B02_6E4B_27::
    db $00, $14, $46, $00
    db $00, $0c, $46, $00
    db $00, $04, $46, $00
    db $00, $fc, $46, $00
    db $00, $f4, $46, $00
    db $80

; C: OAM list 28 of the table 6E4B
OamList_B02_6E4B_28::
    db $00, $14, $cc, $00
    db $00, $0c, $ca, $00
    db $00, $04, $4e, $00
    db $00, $fc, $4c, $00
    db $00, $f4, $4a, $00
    db $80

; C: OAM list 29 of the table 6E4B
OamList_B02_6E4B_29::
    db $08, $16, $22, $00
    db $08, $0e, $20, $00
    db $08, $06, $1e, $00
    db $08, $fe, $1c, $00
    db $08, $f6, $1a, $00
    db $80

; C: OAM list 2A of the table 6E4B
OamList_B02_6E4B_2A::
    db $00, $1a, $22, $00
    db $00, $12, $20, $00
    db $00, $0a, $1e, $00
    db $00, $02, $1c, $00
    db $00, $fa, $1a, $00
    db $80

; C: OAM list 2B of the table 6E4B
OamList_B02_6E4B_2B::
    db $03, $17, $22, $00
    db $03, $0f, $20, $00
    db $03, $07, $1e, $00
    db $03, $ff, $1c, $00
    db $03, $f7, $1a, $00
    db $80

; C: OAM list 2C of the table 6E4B
OamList_B02_6E4B_2C::
    db $fb, $1f, $7e, $00
    db $80

; C: OAM list 2D of the table 6E4B
OamList_B02_6E4B_2D::
    db $d3, $19, $c6, $10
    db $d3, $11, $be, $10
    db $d3, $09, $bc, $10
    db $00, $01, $c2, $10
    db $f0, $01, $c2, $10
    db $e0, $01, $c2, $10
    db $d0, $01, $c0, $10
    db $80

; C: OAM list 2E of the table 6E4B
OamList_B02_6E4B_2E::
    db $d3, $19, $22, $10
    db $d3, $11, $20, $10
    db $d3, $09, $c8, $10
    db $00, $01, $c2, $10
    db $f0, $01, $c2, $10
    db $e0, $01, $c2, $10
    db $d0, $01, $c0, $10
    db $80

; C: OAM list 2F of the table 6E4B
OamList_B02_6E4B_2F::
    db $d3, $19, $1e, $10
    db $d3, $11, $1c, $10
    db $d3, $09, $1a, $10
    db $00, $01, $c2, $10
    db $f0, $01, $c2, $10
    db $e0, $01, $c2, $10
    db $d0, $01, $c0, $10
    db $80

; C: OAM list 30 of the table 6E4B
OamList_B02_6E4B_30::
    db $e1, $0f, $3c, $00
    db $f2, $10, $3e, $00
    db $80

; C: OAM list 31 of the table 6E4B
OamList_B02_6E4B_31::
    db $df, $13, $3c, $00
    db $f1, $14, $3e, $00
    db $80

; C: OAM list 32 of the table 6E4B
OamList_B02_6E4B_32::
    db $dd, $17, $3c, $00
    db $f2, $1b, $3e, $00
    db $80

; C: OAM list 33 of the table 6E4B
OamList_B02_6E4B_33::
    db $fc, $30, $42, $10
    db $fc, $28, $c4, $10
    db $00, $20, $66, $10
    db $00, $18, $64, $10
    db $00, $10, $62, $10
    db $00, $08, $60, $10
    db $80

; C: OAM list 34 of the table 6E4B
OamList_B02_6E4B_34::
    db $13, $30, $ba, $00
    db $13, $28, $b8, $00
    db $13, $20, $48, $00
    db $13, $18, $b6, $00
    db $13, $10, $b4, $00
    db $80

; C: OAM list 35 of the table 6E4B
OamList_B02_6E4B_35::
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

; C: OAM list 36 of the table 6E4B
OamList_B02_6E4B_36::
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

; C: OAM list 37 of the table 6E4B
OamList_B02_6E4B_37::
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

; C: OAM list 38 of the table 6E4B
OamList_B02_6E4B_38::
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

; C: OAM list 39 of the table 6E4B
OamList_B02_6E4B_39::
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

; C: OAM list 3A of the table 6E4B
OamList_B02_6E4B_3A::
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

; C: OAM list 3B of the table 6E4B
OamList_B02_6E4B_3B::
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

; C: OAM list 3C of the table 6E4B
OamList_B02_6E4B_3C::
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

; C: OAM list 3D of the table 6E4B
OamList_B02_6E4B_3D::
    db $0b, $0b, $10, $10
    db $03, $10, $01, $10
    db $03, $08, $00, $10
    db $fb, $10, $f1, $10
    db $fb, $08, $f0, $10
    db $80

; C: OAM list 3E of the table 6E4B
OamList_B02_6E4B_3E::
    db $03, $10, $03, $10
    db $03, $08, $02, $10
    db $fb, $10, $f3, $10
    db $fb, $08, $f2, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 3F of the table 6E4B
OamList_B02_6E4B_3F::
    db $fe, $0e, $f5, $10
    db $fe, $06, $f4, $10
    db $03, $10, $05, $10
    db $03, $08, $04, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 40 of the table 6E4B
OamList_B02_6E4B_40::
    db $fa, $08, $f0, $10
    db $fb, $0c, $95, $10
    db $03, $10, $07, $10
    db $03, $08, $06, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 41 of the table 6E4B
OamList_B02_6E4B_41::
    db $fb, $10, $f9, $10
    db $fb, $08, $f8, $10
    db $03, $10, $09, $10
    db $03, $08, $08, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 42 of the table 6E4B
OamList_B02_6E4B_42::
    db $fb, $10, $1f, $10
    db $03, $10, $1e, $10
    db $03, $08, $0f, $10
    db $fb, $08, $ff, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 43 of the table 6E4B
OamList_B02_6E4B_43::
    db $02, $15, $fc, $10
    db $08, $0d, $0b, $10
    db $08, $05, $0a, $10
    db $00, $0d, $fb, $10
    db $00, $05, $fa, $10
    db $80

; C: OAM list 44 of the table 6E4B
OamList_B02_6E4B_44::
    db $01, $16, $0c, $10
    db $09, $0e, $0e, $10
    db $09, $06, $0d, $10
    db $01, $0e, $fe, $10
    db $01, $06, $fd, $10
    db $80

; C: OAM list 45 of the table 6E4B
OamList_B02_6E4B_45::
    db $fb, $0b, $11, $10
    db $0b, $0b, $10, $10
    db $03, $10, $01, $10
    db $03, $08, $00, $10
    db $80

; C: OAM list 46 of the table 6E4B
OamList_B02_6E4B_46::
    db $03, $07, $09, $30
    db $fb, $0c, $12, $10
    db $03, $0e, $19, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 47 of the table 6E4B
OamList_B02_6E4B_47::
    db $fb, $0c, $13, $10
    db $03, $06, $1a, $10
    db $03, $0e, $1b, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 48 of the table 6E4B
OamList_B02_6E4B_48::
    db $fb, $0d, $15, $10
    db $fb, $05, $14, $10
    db $03, $0e, $1d, $10
    db $03, $06, $1c, $10
    db $0b, $0b, $10, $10
    db $80

; C: OAM list 49 of the table 6E4B
OamList_B02_6E4B_49::
    db $08, $08, $16, $10
    db $80

; C: OAM list 4A of the table 6E4B
OamList_B02_6E4B_4A::
    db $08, $08, $17, $10
    db $80

; C: OAM list 4B of the table 6E4B
OamList_B02_6E4B_4B::
    db $08, $08, $e4, $10
    db $80

; C: OAM list 4C of the table 6E4B
OamList_B02_6E4B_4C::
    db $08, $08, $17, $30
    db $80

; C: OAM list 4D of the table 6E4B
OamList_B02_6E4B_4D::
    db $08, $08, $16, $30
    db $80

; C: OAM list 4E of the table 6E4B
OamList_B02_6E4B_4E::
    db $08, $08, $88, $00
    db $80

; C: OAM list 4F of the table 6E4B
OamList_B02_6E4B_4F::
    db $08, $08, $89, $00
    db $80

; C: OAM list 50 of the table 6E4B
OamList_B02_6E4B_50::
    db $08, $08, $96, $00
    db $80

; C: OAM list 51 of the table 6E4B
OamList_B02_6E4B_51::
    db $08, $08, $89, $20
    db $80

; C: OAM list 52 of the table 6E4B
OamList_B02_6E4B_52::
    db $08, $08, $88, $20
    db $80

; C: OAM list 53 of the table 6E4B
OamList_B02_6E4B_53::
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

; C: OAM list 54 of the table 6E4B
OamList_B02_6E4B_54::
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

; C: OAM list 55 of the table 6E4B
OamList_B02_6E4B_55::
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

; C: OAM list 56 of the table 6E4B
OamList_B02_6E4B_56::
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

; C: OAM list 57 of the table 6E4B
OamList_B02_6E4B_57::
    db $0c, $08, $df, $10
    db $0c, $00, $de, $10
    db $04, $08, $dd, $10
    db $04, $00, $dc, $10
    db $80

; C: OAM list 58 of the table 6E4B
OamList_B02_6E4B_58::
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

; C: OAM list 59 of the table 6E4B
OamList_B02_6E4B_59::
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

; C: OAM list 5A of the table 6E4B
OamList_B02_6E4B_5A::
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

; C: OAM list 5B of the table 6E4B
OamList_B02_6E4B_5B::
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

; C: OAM list 5C of the table 6E4B
OamList_B02_6E4B_5C::
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

; C: OAM list 5D of the table 6E4B
OamList_B02_6E4B_5D::
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

; C: OAM list 5E of the table 6E4B
OamList_B02_6E4B_5E::
    db $08, $08, $74, $10
    db $80

; C: OAM list 5F of the table 6E4B
OamList_B02_6E4B_5F::
    db $08, $09, $74, $10
    db $80

; C: OAM list 60 of the table 6E4B
OamList_B02_6E4B_60::
    db $08, $08, $74, $30
    db $80

; C: OAM list 61 of the table 6E4B
OamList_B02_6E4B_61::
    db $08, $07, $74, $30
    db $80

; C: OAM list 62 of the table 6E4B
OamList_B02_6E4B_62::
    db $00, $10, $7e, $00
    db $00, $08, $7c, $00
    db $00, $00, $7a, $00
    db $00, $f8, $78, $00
    db $00, $f0, $76, $00
    db $80

; C: OAM list 63 of the table 6E4B
OamList_B02_6E4B_63::
    db $00, $10, $7e, $00
    db $00, $08, $7c, $00
    db $fe, $00, $7a, $10
    db $fe, $f8, $78, $10
    db $fe, $f0, $76, $10
    db $80

; C: OAM list 64 of the table 6E4B
OamList_B02_6E4B_64::
    db $00, $10, $7e, $00
    db $fe, $08, $7c, $10
    db $00, $00, $7a, $00
    db $fe, $f8, $78, $10
    db $fe, $f0, $76, $10
    db $80

; C: OAM list 65 of the table 6E4B
OamList_B02_6E4B_65::
    db $fe, $10, $7e, $10
    db $00, $08, $7c, $00
    db $00, $00, $7a, $00
    db $fe, $f8, $78, $10
    db $fe, $f0, $76, $10
    db $80

; C: OAM list 66 of the table 6E4B
OamList_B02_6E4B_66::
    db $08, $00, $46, $10
    db $80

; C: OAM list 67 of the table 6E4B
OamList_B02_6E4B_67::
    db $08, $ff, $46, $10
    db $80

; C: OAM list 68 of the table 6E4B
OamList_B02_6E4B_68::
    db $08, $08, $46, $30
    db $80

; C: OAM list 69 of the table 6E4B
OamList_B02_6E4B_69::
    db $08, $09, $46, $30
    db $80

; C: OAM list 6A of the table 6E4B
OamList_B02_6E4B_6A::
    db $08, $00, $48, $10
    db $80

; C: OAM list 6B of the table 6E4B
OamList_B02_6E4B_6B::
    db $08, $ff, $48, $10
    db $80

; C: OAM list 6C of the table 6E4B
OamList_B02_6E4B_6C::
    db $08, $08, $48, $30
    db $80

; C: OAM list 6D of the table 6E4B
OamList_B02_6E4B_6D::
    db $08, $09, $48, $30
    db $80

; C: OAM list 6E of the table 6E4B
OamList_B02_6E4B_6E::
    db $08, $00, $80, $10
    db $80

; C: OAM list 6F of the table 6E4B
OamList_B02_6E4B_6F::
    db $08, $00, $82, $10
    db $80

; C: OAM list 70 of the table 6E4B
OamList_B02_6E4B_70::
    db $08, $00, $84, $10
    db $80

; C: OAM list 71 of the table 6E4B
OamList_B02_6E4B_71::
    db $08, $10, $03, $00
    db $08, $08, $02, $00
    db $08, $00, $01, $00
    db $08, $f8, $00, $00
    db $80

; C: OAM list 72 of the table 6E4B
OamList_B02_6E4B_72::
    db $08, $10, $06, $00
    db $08, $08, $05, $00
    db $08, $00, $04, $00
    db $80

; C: OAM list 73 of the table 6E4B
OamList_B02_6E4B_73::
    db $08, $18, $0c, $00
    db $08, $10, $0b, $00
    db $08, $08, $0a, $00
    db $08, $00, $09, $00
    db $08, $f8, $08, $00
    db $08, $f0, $07, $00
    db $80

; C: OAM list 74 of the table 6E4B
OamList_B02_6E4B_74::
    db $08, $08, $11, $00
    db $08, $00, $10, $00
    db $80

; C: OAM list 75 of the table 6E4B
OamList_B02_6E4B_75::
    db $08, $08, $13, $00
    db $08, $00, $12, $00
    db $80

; C: OAM list 76 of the table 6E4B
OamList_B02_6E4B_76::
    db $08, $18, $18, $00
    db $08, $10, $17, $00
    db $08, $08, $16, $00
    db $08, $00, $15, $00
    db $08, $f8, $14, $00
    db $80

; C: OAM list 77 of the table 6E4B
OamList_B02_6E4B_77::
    db $08, $10, $1b, $00
    db $08, $08, $1a, $00
    db $08, $00, $19, $00
    db $80

; C: OAM list 78 of the table 6E4B
OamList_B02_6E4B_78::
    db $08, $10, $0f, $00
    db $08, $08, $0e, $00
    db $08, $00, $0d, $00
    db $80

; C: OAM list 79 of the table 6E4B
OamList_B02_6E4B_79::
    db $08, $08, $1c, $10
    db $80

; C: zero fill to the end of the bank
Bank02_Padding_7AB5::
    INCBIN "data/bank_02/Bank02_Padding_7AB5.bin" ; $7AB5, 1355 bytes

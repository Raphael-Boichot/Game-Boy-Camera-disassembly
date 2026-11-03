; Game Boy Camera Gold (USA), bank $02. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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


; C: renumbers the slots 0..n-1 in photo_vector_ram and stores photo_count; changed in this build (23 more bytes,
; 02:448A-44AF; the rest of bank 02 moves by +23): every vector entry equal to the rank is renumbered, not only the
; first (push de / pop de around the scan, d set to $FF as a found flag), then ...
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
    push de                                       ; $448A

jr_002_448b:
    cp [hl]                                       ; $448B
    jr nz, jr_002_4491                            ; $448C

    ld [hl], d                                    ; $448E
    ld d, $ff                                     ; $448F

jr_002_4491:
    inc hl                                        ; $4491
    dec c                                         ; $4492
    jr nz, jr_002_448b                            ; $4493

    ld a, d                                       ; $4495
    pop de                                        ; $4496
    cp $ff                                        ; $4497
    jr nz, jr_002_449c                            ; $4499

    inc d                                         ; $449B

jr_002_449c:
    inc e                                         ; $449C
    dec b                                         ; $449D
    jr nz, jr_002_4484                            ; $449E

    ld hl, wPhotoVectorRam                        ; $44A0
    ld b, $1e                                     ; $44A3

jr_002_44a5:
    ld a, [hl]                                    ; $44A5
    cp $1e                                        ; $44A6
    jr c, jr_002_44ac                             ; $44A8

    ld [hl], $ff                                  ; $44AA

jr_002_44ac:
    inc hl                                        ; $44AC
    dec b                                         ; $44AD
    jr nz, jr_002_44a5                            ; $44AE

    ld bc, $1e00                                  ; $44B0
    ld hl, wPhotoVectorRam                        ; $44B3

jr_002_44b6:
    ld a, [hl+]                                   ; $44B6
    cp $ff                                        ; $44B7
    jr z, jr_002_44bc                             ; $44B9

    inc c                                         ; $44BB

jr_002_44bc:
    dec b                                         ; $44BC
    jr nz, jr_002_44b6                            ; $44BD

    ld a, c                                       ; $44BF
    ld [wPhotoCount], a                           ; $44C0
    push af                                       ; $44C3
    xor a                                         ; $44C4
    ld [rRAMG], a                                 ; $44C5
    pop af                                        ; $44C8
    jp Far_Call_Return                            ; $44C9


; C: formats every block of the save (far call from bank 09)
Sram_FormatAll_Far::
    push af                                       ; $44CC
    ld a, $0a                                     ; $44CD
    ld [rRAMG], a                                 ; $44CF
    pop af                                        ; $44D2
    ld a, $01                                     ; $44D3
    ld [rRAMB], a                                 ; $44D5
    call Sram_FormatOwnerBlocks                   ; $44D8
    xor a                                         ; $44DB
    ld [rRAMB], a                                 ; $44DC
    call Sram_FormatVectorBlocks                  ; $44DF
    ld b, $1e                                     ; $44E2

jr_002_44e4:
    ld a, b                                       ; $44E4
    cpl                                           ; $44E5
    add $1f                                       ; $44E6
    srl a                                         ; $44E8
    inc a                                         ; $44EA
    ld [rRAMB], a                                 ; $44EB
    ld de, $0000                                  ; $44EE
    rl d                                          ; $44F1
    swap d                                        ; $44F3
    call Sram_FormatPhotoBank                     ; $44F5
    xor a                                         ; $44F8
    ld [rRAMB], a                                 ; $44F9
    call Sram_FreeSlotInVector                    ; $44FC
    dec b                                         ; $44FF
    jr nz, jr_002_44e4                            ; $4500

    xor a                                         ; $4502
    ld [rRAMB], a                                 ; $4503
    call Sram_FormatSettingsBlocks                ; $4506
    push af                                       ; $4509
    xor a                                         ; $450A
    ld [rRAMG], a                                 ; $450B
    pop af                                        ; $450E
    jp Far_Call_Return                            ; $450F


; C: A = photo number: marks the slot free
Photo_Erase_Far::
    ldh [hFarcallAArg], a                         ; $4512
    farcall Photo_FindSlot_Far                    ; $4514
    jp c, Far_Call_Return                         ; $451C

    push af                                       ; $451F
    ld a, $0a                                     ; $4520
    ld [rRAMG], a                                 ; $4522
    pop af                                        ; $4525
    push af                                       ; $4526
    xor a                                         ; $4527
    ld [rRAMB], a                                 ; $4528
    pop af                                        ; $452B
    ld c, a                                       ; $452C
    ld b, $00                                     ; $452D
    ld hl, wPhotoVectorRam                        ; $452F
    add hl, bc                                    ; $4532
    ld [hl], $ff                                  ; $4533
    call Sram_StorePhotoVector                    ; $4535
    push af                                       ; $4538
    xor a                                         ; $4539
    ld [rRAMG], a                                 ; $453A
    pop af                                        ; $453D
    jp Photo_RenumberVector                       ; $453E


; C: erases a photo then removes every reference to it from the hot spots and the animation list. L3 pass 2026-10-26:
; not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Photo_Erase_UnlinkAll_Far::
    ldh [hFarcallAArg], a                         ; $4541
    farcall Photo_FindSlot_Far                    ; $4543
    jp c, Far_Call_Return                         ; $454B

    ldh [hScratchA], a                            ; $454E
    ld a, [wPhotoCount]                           ; $4550
    dec a                                         ; $4553

jr_002_4554:
    ldh [hScratchB], a                            ; $4554
    ldh [hFarcallAArg], a                         ; $4556
    farcall Photo_LoadHotspots_Far                ; $4558
    ld hl, wHotspotBlock                          ; $4560
    ld de, wHotspotBlock + $19                    ; $4563
    ldh a, [hScratchA]                            ; $4566
    ld c, a                                       ; $4568
    ld b, $05                                     ; $4569

jr_002_456b:
    ld a, [hl]                                    ; $456B
    and a                                         ; $456C
    jr z, jr_002_4576                             ; $456D

    ld a, [de]                                    ; $456F
    cp c                                          ; $4570
    jr nz, jr_002_4576                            ; $4571

    ld a, $ff                                     ; $4573
    ld [de], a                                    ; $4575

jr_002_4576:
    inc hl                                        ; $4576
    inc de                                        ; $4577
    dec b                                         ; $4578
    jr nz, jr_002_456b                            ; $4579

    ldh a, [hScratchB]                            ; $457B
    ldh [hFarcallAArg], a                         ; $457D
    farcall Photo_StoreHotspots_Far               ; $457F
    ldh a, [hScratchB]                            ; $4587
    dec a                                         ; $4589
    bit 7, a                                      ; $458A
    jr z, jr_002_4554                             ; $458C

    ldh [hFarcallAArg], a                         ; $458E
    farcall Settings_LoadAnim_Far                 ; $4590
    ld hl, wAnimList                              ; $4598
    ldh a, [hScratchA]                            ; $459B
    ld c, a                                       ; $459D
    ld b, $2f                                     ; $459E

jr_002_45a0:
    ld a, [hl]                                    ; $45A0
    cp c                                          ; $45A1
    jr nz, jr_002_45a7                            ; $45A2

    ld a, $fe                                     ; $45A4
    ld [hl], a                                    ; $45A6

jr_002_45a7:
    inc hl                                        ; $45A7
    dec b                                         ; $45A8
    jr nz, jr_002_45a0                            ; $45A9

    ldh [hFarcallAArg], a                         ; $45AB
    farcall Settings_Store_Far                    ; $45AD
    jp Far_Call_Return                            ; $45B5


; C: saves the working image into a free slot with the copy flag set (copy badge); needs photo_count < 30. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Photo_SaveCopy_Far::
    ld c, a                                       ; $45B8
    ld a, [wPhotoCount]                           ; $45B9
    cp $1e                                        ; $45BC
    jp nc, Far_Call_Return                        ; $45BE

    ld a, $ff                                     ; $45C1
    ldh [hFarcallAArg], a                         ; $45C3
    farcall Photo_FindSlot_Far                    ; $45C5
    jp c, Far_Call_Return                         ; $45CD

    push af                                       ; $45D0
    ld a, $0a                                     ; $45D1
    ld [rRAMG], a                                 ; $45D3
    pop af                                        ; $45D6
    push bc                                       ; $45D7
    push hl                                       ; $45D8
    push af                                       ; $45D9
    ld d, HIGH(wThumbnail)                        ; $45DA
    call Thumb_DrawCopyBadge                      ; $45DC
    ld a, $01                                     ; $45DF
    ld [wSlotTagCopyFlag], a                      ; $45E1
    ld [wSlotTagEchoCopyFlag], a                  ; $45E4
    ld hl, wSlotTagOwnerCopy                      ; $45E7
    ld bc, $005a                                  ; $45EA
    call Sram_WriteChecksum                       ; $45ED
    ld hl, wSlotTagEcho                           ; $45F0
    ld bc, $005a                                  ; $45F3
    call Sram_WriteChecksum                       ; $45F6
    pop af                                        ; $45F9
    srl a                                         ; $45FA
    inc a                                         ; $45FC
    ld [rRAMB], a                                 ; $45FD
    ld de, $0000                                  ; $4600
    rl d                                          ; $4603
    swap d                                        ; $4605
    ld hl, $a000                                  ; $4607
    add hl, de                                    ; $460A
    ld de, wPhotoImage                            ; $460B
    ld bc, $0fb8                                  ; $460E

jr_002_4611:
    ld a, [de]                                    ; $4611
    ld [hl+], a                                   ; $4612
    inc de                                        ; $4613
    dec bc                                        ; $4614
    ld a, b                                       ; $4615
    or c                                          ; $4616
    jr nz, jr_002_4611                            ; $4617

    pop hl                                        ; $4619
    pop bc                                        ; $461A
    ld a, c                                       ; $461B
    cp $1e                                        ; $461C
    jr nc, jr_002_4636                            ; $461E

    push hl                                       ; $4620
    ld hl, wPhotoVectorRam                        ; $4621
    ld b, $1e                                     ; $4624

jr_002_4626:
    cp [hl]                                       ; $4626
    jr nc, jr_002_462e                            ; $4627

    bit 7, [hl]                                   ; $4629
    jr nz, jr_002_462e                            ; $462B

    inc [hl]                                      ; $462D

jr_002_462e:
    inc hl                                        ; $462E
    dec b                                         ; $462F
    jr nz, jr_002_4626                            ; $4630

    pop hl                                        ; $4632
    inc a                                         ; $4633
    jr jr_002_4639                                ; $4634

jr_002_4636:
    ld a, [wPhotoCount]                           ; $4636

jr_002_4639:
    ld [hl], a                                    ; $4639
    call Sram_StorePhotoVector                    ; $463A
    push af                                       ; $463D
    xor a                                         ; $463E
    ld [rRAMG], a                                 ; $463F
    pop af                                        ; $4642
    jp Photo_RenumberVector                       ; $4643


; C: link receive: stores the received photo and bumps the gender counters F12 / F13 of its tag
Photo_SaveReceived_Far::
    ldh [hFarcallAArg], a                         ; $4646
    farcall Owner_Load_Far                        ; $4648
    ld a, [wPhotoCount]                           ; $4650
    cp $1e                                        ; $4653
    jp nc, Far_Call_Return                        ; $4655

    ld a, $ff                                     ; $4658
    ldh [hFarcallAArg], a                         ; $465A
    farcall Photo_FindSlot_Far                    ; $465C
    jp c, Far_Call_Return                         ; $4664

    push af                                       ; $4667
    ld a, $0a                                     ; $4668
    ld [rRAMG], a                                 ; $466A
    pop af                                        ; $466D
    push hl                                       ; $466E
    push af                                       ; $466F
    ld de, $0000                                  ; $4670
    ld b, $02                                     ; $4673

jr_002_4675:
    push bc                                       ; $4675
    push de                                       ; $4676
    ld hl, wSlotTagRecvCounters                   ; $4677
    add hl, de                                    ; $467A
    ld a, [wOwnerGenderBlood]                     ; $467B
    ld b, a                                       ; $467E
    ld a, [hl]                                    ; $467F
    bit 0, b                                      ; $4680
    jr z, jr_002_4689                             ; $4682

    cp $63                                        ; $4684
    jr nc, jr_002_4689                            ; $4686

    inc a                                         ; $4688

jr_002_4689:
    ld [hl+], a                                   ; $4689
    ld a, [hl]                                    ; $468A
    bit 1, b                                      ; $468B
    jr z, jr_002_4694                             ; $468D

    cp $63                                        ; $468F
    jr nc, jr_002_4694                            ; $4691

    inc a                                         ; $4693

jr_002_4694:
    ld [hl+], a                                   ; $4694
    ld a, [hl]                                    ; $4695
    cp $63                                        ; $4696
    jr nc, jr_002_469b                            ; $4698

    inc a                                         ; $469A

jr_002_469b:
    ld [hl], a                                    ; $469B
    pop de                                        ; $469C
    push de                                       ; $469D
    ld hl, wSlotTagHotspotFields                  ; $469E
    add hl, de                                    ; $46A1
    ld c, $1e                                     ; $46A2
    call Sram_ZeroTagBytes                        ; $46A4
    pop de                                        ; $46A7
    push de                                       ; $46A8
    ld hl, wSlotTagMagic                          ; $46A9
    add hl, de                                    ; $46AC
    ld de, Sram_MagicString                       ; $46AD
    ld c, $05                                     ; $46B0

jr_002_46b2:
    ld a, [de]                                    ; $46B2
    ld [hl+], a                                   ; $46B3
    inc de                                        ; $46B4
    dec c                                         ; $46B5
    jr nz, jr_002_46b2                            ; $46B6

    pop de                                        ; $46B8
    push de                                       ; $46B9
    ld hl, wSlotTagOwnerCopy                      ; $46BA
    add hl, de                                    ; $46BD
    ld bc, $005a                                  ; $46BE
    call Sram_WriteChecksum                       ; $46C1
    pop de                                        ; $46C4
    pop bc                                        ; $46C5
    ld de, $005c                                  ; $46C6
    dec b                                         ; $46C9
    jr nz, jr_002_4675                            ; $46CA

    pop af                                        ; $46CC
    srl a                                         ; $46CD
    inc a                                         ; $46CF
    ld [rRAMB], a                                 ; $46D0
    ld de, $0000                                  ; $46D3
    rl d                                          ; $46D6
    swap d                                        ; $46D8
    ld hl, $a000                                  ; $46DA
    add hl, de                                    ; $46DD
    ld de, wPhotoImage                            ; $46DE
    ld bc, $0fb8                                  ; $46E1

jr_002_46e4:
    ld a, [de]                                    ; $46E4
    ld [hl+], a                                   ; $46E5
    inc de                                        ; $46E6
    dec bc                                        ; $46E7
    ld a, b                                       ; $46E8
    or c                                          ; $46E9
    jr nz, jr_002_46e4                            ; $46EA

    pop hl                                        ; $46EC
    ld a, [wPhotoCount]                           ; $46ED
    ld [hl], a                                    ; $46F0
    call Sram_StorePhotoVector                    ; $46F1
    push af                                       ; $46F4
    xor a                                         ; $46F5
    ld [rRAMG], a                                 ; $46F6
    pop af                                        ; $46F9
    jp Photo_RenumberVector                       ; $46FA


; I: 3 bytes 00 C0 00 between the jp of Photo_SaveReceived_Far (02:46E3) and Sram_ZeroTagBytes (02:46E9); read as code
; they would be nop / ret nz / nop but nothing jumps here. Evidence: never executed or read in the 18,739-entry replay
; coverage (organic or forced runs: only the forced runs touched the ...
Unused_Photo_SaveReceived_Far_Stray46FD::
    db $00, $c0, $00

; C: zeroes C bytes at HL. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: zeroes C bytes at HL (called from Photo_SaveShot_Far on its jr_002_4684 path)
Sram_ZeroTagBytes::
    xor a                                         ; $4700

jr_002_4701:
    ld [hl+], a                                   ; $4701
    inc de                                        ; $4702
    dec c                                         ; $4703
    jr nz, jr_002_4701                            ; $4704

    ret                                           ; $4706


; C: stores a new shot: checksums
Photo_SaveShot_Far::
    ldh [hFarcallAArg], a                         ; $4707
    farcall Owner_Load_Far                        ; $4709
    call Sram_ComputeImageChecksums               ; $4711
    ld a, [wPhotoCount]                           ; $4714
    cp $1e                                        ; $4717
    jp nc, Far_Call_Return                        ; $4719

    ld a, $ff                                     ; $471C
    ldh [hFarcallAArg], a                         ; $471E
    farcall Photo_FindSlot_Far                    ; $4720
    jp c, Far_Call_Return                         ; $4728

    push af                                       ; $472B
    ld a, $0a                                     ; $472C
    ld [rRAMG], a                                 ; $472E
    pop af                                        ; $4731
    push hl                                       ; $4732
    push af                                       ; $4733
    ld hl, wThumbnail                             ; $4734
    ld bc, $0100                                  ; $4737
    call Mem_Zero                                 ; $473A
    ld hl, Photo_SaveShot_Far_Tbl47CA             ; $473D
    ld bc, wThumbnail                             ; $4740
    call Img_ReduceToThumbnail                    ; $4743
    ld hl, wThumbnail                             ; $4746
    ld a, $03                                     ; $4749
    call Thumb_DrawFrame                          ; $474B
    ld de, $0000                                  ; $474E
    ld b, $02                                     ; $4751

jr_002_4753:
    push bc                                       ; $4753
    push de                                       ; $4754
    ld hl, wSlotTagOwnerCopy                      ; $4755
    add hl, de                                    ; $4758
    ld de, wOwnerId                               ; $4759
    ld c, $12                                     ; $475C
    call Mem_CopyShort                            ; $475E
    ld c, $43                                     ; $4761
    call Mem_ZeroShort                            ; $4763
    pop de                                        ; $4766
    push de                                       ; $4767
    ld hl, wSlotTagImageCheck                     ; $4768
    add hl, de                                    ; $476B
    ld a, [wTagImageCheck]                        ; $476C
    ld [hl+], a                                   ; $476F
    ld a, [wTagImageCheck + $1]                   ; $4770
    ld [hl], a                                    ; $4773
    pop de                                        ; $4774
    push de                                       ; $4775
    ld hl, wSlotTagMagic                          ; $4776
    add hl, de                                    ; $4779
    ld de, Sram_MagicString                       ; $477A
    ld c, $05                                     ; $477D

jr_002_477f:
    ld a, [de]                                    ; $477F
    ld [hl+], a                                   ; $4780
    inc de                                        ; $4781
    dec c                                         ; $4782
    jr nz, jr_002_477f                            ; $4783

    pop de                                        ; $4785
    push de                                       ; $4786
    ld hl, wSlotTagOwnerCopy                      ; $4787
    add hl, de                                    ; $478A
    ld bc, $005a                                  ; $478B
    call Sram_WriteChecksum                       ; $478E
    pop de                                        ; $4791
    pop bc                                        ; $4792
    ld de, $005c                                  ; $4793
    dec b                                         ; $4796
    jr nz, jr_002_4753                            ; $4797

    pop af                                        ; $4799
    srl a                                         ; $479A
    inc a                                         ; $479C
    ld [rRAMB], a                                 ; $479D
    ld de, $0000                                  ; $47A0
    rl d                                          ; $47A3
    swap d                                        ; $47A5
    ld hl, $a000                                  ; $47A7
    add hl, de                                    ; $47AA
    ld de, wPhotoImage                            ; $47AB
    ld bc, $0fb8                                  ; $47AE

jr_002_47b1:
    ld a, [de]                                    ; $47B1
    ld [hl+], a                                   ; $47B2
    inc de                                        ; $47B3
    dec bc                                        ; $47B4
    ld a, b                                       ; $47B5
    or c                                          ; $47B6
    jr nz, jr_002_47b1                            ; $47B7

    pop hl                                        ; $47B9
    ld a, [wPhotoCount]                           ; $47BA
    ld [hl], a                                    ; $47BD
    call Sram_StorePhotoVector                    ; $47BE
    push af                                       ; $47C1
    xor a                                         ; $47C2
    ld [rRAMG], a                                 ; $47C3
    pop af                                        ; $47C6
    jp Photo_RenumberVector                       ; $47C7


; C: auto: 3 bytes, bytes; referenced by Photo_SaveShot_Far. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Photo_SaveShot_Far_Tbl47CA::
    db $00, $c0, $00

; C: copies C bytes from DE to HL. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Mem_CopyShort::
    ld a, [de]                                    ; $47CD
    ld [hl+], a                                   ; $47CE
    inc de                                        ; $47CF
    dec c                                         ; $47D0
    jr nz, Mem_CopyShort                          ; $47D1

    ret                                           ; $47D3


; C: writes C zero bytes at HL. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Mem_ZeroShort::
    xor a                                         ; $47D4

jr_002_47d5:
    ld [hl+], a                                   ; $47D5
    inc de                                        ; $47D6
    dec c                                         ; $47D7
    jr nz, jr_002_47d5                            ; $47D8

    ret                                           ; $47DA


; C: rewrites the image + thumbnail of an existing slot. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Photo_StoreImage_Far::
    cp $1e                                        ; $47DB
    jp nc, Far_Call_Return                        ; $47DD

    ldh [hFarcallAArg], a                         ; $47E0
    farcall Photo_FindSlot_Far                    ; $47E2
    jp c, Far_Call_Return                         ; $47EA

    push af                                       ; $47ED
    ld a, $0a                                     ; $47EE
    ld [rRAMG], a                                 ; $47F0
    pop af                                        ; $47F3
    push af                                       ; $47F4
    ld hl, wThumbnail                             ; $47F5
    ld bc, $0100                                  ; $47F8
    call Mem_Zero                                 ; $47FB
    ld hl, Photo_StoreImage_Far_Tbl4846           ; $47FE
    ld bc, wThumbnail                             ; $4801
    call Img_ReduceToThumbnail                    ; $4804
    ld hl, wThumbnail                             ; $4807
    ld a, $03                                     ; $480A
    call Thumb_DrawFrame                          ; $480C
    ld a, [wSlotTagCopyFlag]                      ; $480F
    and a                                         ; $4812
    jr z, jr_002_481a                             ; $4813

    ld d, HIGH(wThumbnail)                        ; $4815
    call Thumb_DrawCopyBadge                      ; $4817

jr_002_481a:
    pop af                                        ; $481A
    srl a                                         ; $481B
    inc a                                         ; $481D
    ld [rRAMB], a                                 ; $481E
    ld de, $0000                                  ; $4821
    rl d                                          ; $4824
    swap d                                        ; $4826
    ld hl, $a000                                  ; $4828
    add hl, de                                    ; $482B
    ld de, wPhotoImage                            ; $482C
    ld bc, $0f00                                  ; $482F

jr_002_4832:
    ld a, [de]                                    ; $4832
    ld [hl+], a                                   ; $4833
    inc de                                        ; $4834
    dec bc                                        ; $4835
    ld a, b                                       ; $4836
    or c                                          ; $4837
    jr nz, jr_002_4832                            ; $4838

    call Sram_StorePhotoVector                    ; $483A
    push af                                       ; $483D
    xor a                                         ; $483E
    ld [rRAMG], a                                 ; $483F
    pop af                                        ; $4842
    jp Far_Call_Return                            ; $4843


; C: auto: 3 bytes, bytes; referenced by Photo_StoreImage_Far. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Photo_StoreImage_Far_Tbl4846::
    db $00, $c0, $00

; C: writes the 30-byte hot-spot block D643 into both tag copies
Photo_StoreHotspots_Far::
    cp $1e                                        ; $4849
    jp nc, Far_Call_Return                        ; $484B

    ldh [hFarcallAArg], a                         ; $484E
    farcall Photo_FindSlot_Far                    ; $4850
    jp c, Far_Call_Return                         ; $4858

    push af                                       ; $485B
    ld a, $0a                                     ; $485C
    ld [rRAMG], a                                 ; $485E
    pop af                                        ; $4861
    srl a                                         ; $4862
    inc a                                         ; $4864
    ld [rRAMB], a                                 ; $4865
    ld de, $0000                                  ; $4868
    rl d                                          ; $486B
    swap d                                        ; $486D
    ld b, $02                                     ; $486F

jr_002_4871:
    push bc                                       ; $4871
    push de                                       ; $4872
    ld hl, $af36                                  ; $4873
    add hl, de                                    ; $4876
    ld de, wHotspotBlock                          ; $4877
    ld c, $1e                                     ; $487A

jr_002_487c:
    ld a, [de]                                    ; $487C
    ld [hl+], a                                   ; $487D
    inc de                                        ; $487E
    dec c                                         ; $487F
    jr nz, jr_002_487c                            ; $4880

    pop de                                        ; $4882
    push de                                       ; $4883
    ld hl, $af00                                  ; $4884
    add hl, de                                    ; $4887
    ld bc, $005a                                  ; $4888
    call Sram_WriteChecksum                       ; $488B
    pop de                                        ; $488E
    pop bc                                        ; $488F
    ld a, e                                       ; $4890
    add $5c                                       ; $4891
    ld e, a                                       ; $4893
    jr nc, jr_002_4897                            ; $4894

    inc d                                         ; $4896

jr_002_4897:
    dec b                                         ; $4897
    jr nz, jr_002_4871                            ; $4898

    call Sram_StorePhotoVector                    ; $489A
    push af                                       ; $489D
    xor a                                         ; $489E
    ld [rRAMG], a                                 ; $489F
    pop af                                        ; $48A2
    jp Far_Call_Return                            ; $48A3


; C: as above but translates the five target photo numbers through the vector
Photo_StoreHotspotsTranslated_Far::
    cp $1e                                        ; $48A6
    jp nc, Far_Call_Return                        ; $48A8

    ldh [hFarcallAArg], a                         ; $48AB
    farcall Photo_FindSlot_Far                    ; $48AD
    jp c, Far_Call_Return                         ; $48B5

    push af                                       ; $48B8
    ld a, $0a                                     ; $48B9
    ld [rRAMG], a                                 ; $48BB
    pop af                                        ; $48BE
    srl a                                         ; $48BF
    inc a                                         ; $48C1
    ld [rRAMB], a                                 ; $48C2
    ld de, $0000                                  ; $48C5
    rl d                                          ; $48C8
    swap d                                        ; $48CA
    ld b, $02                                     ; $48CC

jr_002_48ce:
    push bc                                       ; $48CE
    push de                                       ; $48CF
    ld hl, $af36                                  ; $48D0
    add hl, de                                    ; $48D3
    ld de, wHotspotBlock                          ; $48D4
    ld c, $19                                     ; $48D7

jr_002_48d9:
    ld a, [de]                                    ; $48D9
    ld [hl+], a                                   ; $48DA
    inc de                                        ; $48DB
    dec c                                         ; $48DC
    jr nz, jr_002_48d9                            ; $48DD

    ld c, $05                                     ; $48DF

jr_002_48e1:
    ld a, [de]                                    ; $48E1
    call Vec_GetPhotoVectorByteFar                ; $48E2
    ld [hl+], a                                   ; $48E5
    inc de                                        ; $48E6
    dec c                                         ; $48E7
    jr nz, jr_002_48e1                            ; $48E8

    pop de                                        ; $48EA
    push de                                       ; $48EB
    ld hl, $af00                                  ; $48EC
    add hl, de                                    ; $48EF
    ld bc, $005a                                  ; $48F0
    call Sram_WriteChecksum                       ; $48F3
    pop de                                        ; $48F6
    pop bc                                        ; $48F7
    ld a, e                                       ; $48F8
    add $5c                                       ; $48F9
    ld e, a                                       ; $48FB
    jr nc, jr_002_48ff                            ; $48FC

    inc d                                         ; $48FE

jr_002_48ff:
    dec b                                         ; $48FF
    jr nz, jr_002_48ce                            ; $4900

    call Sram_StorePhotoVector                    ; $4902
    push af                                       ; $4905
    xor a                                         ; $4906
    ld [rRAMG], a                                 ; $4907
    pop af                                        ; $490A
    jp Far_Call_Return                            ; $490B


; C: writes the border number D7C1 into both tag copies
Photo_StoreBorder_Far::
    cp $1e                                        ; $490E
    jp nc, Far_Call_Return                        ; $4910

    ldh [hFarcallAArg], a                         ; $4913
    farcall Photo_FindSlot_Far                    ; $4915
    jp c, Far_Call_Return                         ; $491D

    push af                                       ; $4920
    ld a, $0a                                     ; $4921
    ld [rRAMG], a                                 ; $4923
    pop af                                        ; $4926
    srl a                                         ; $4927
    inc a                                         ; $4929
    ld [rRAMB], a                                 ; $492A
    ld de, $0000                                  ; $492D
    rl d                                          ; $4930
    swap d                                        ; $4932
    ld b, $02                                     ; $4934

jr_002_4936:
    push bc                                       ; $4936
    push de                                       ; $4937
    ld hl, $af54                                  ; $4938
    add hl, de                                    ; $493B
    ld a, [wBorderNumber]                         ; $493C
    ld [hl], a                                    ; $493F
    ld hl, $af00                                  ; $4940
    add hl, de                                    ; $4943
    ld bc, $005a                                  ; $4944
    call Sram_WriteChecksum                       ; $4947
    pop de                                        ; $494A
    pop bc                                        ; $494B
    ld a, e                                       ; $494C
    add $5c                                       ; $494D
    ld e, a                                       ; $494F
    jr nc, jr_002_4953                            ; $4950

    inc d                                         ; $4952

jr_002_4953:
    dec b                                         ; $4953
    jr nz, jr_002_4936                            ; $4954

    call Sram_StorePhotoVector                    ; $4956
    push af                                       ; $4959
    xor a                                         ; $495A
    ld [rRAMG], a                                 ; $495B
    pop af                                        ; $495E
    jp Far_Call_Return                            ; $495F


; C: copies the $36 owner / tag fields from DA5B into both tag copies
Photo_StoreTagFields_Far::
    cp $1e                                        ; $4962
    jp nc, Far_Call_Return                        ; $4964

    ldh [hFarcallAArg], a                         ; $4967
    farcall Photo_FindSlot_Far                    ; $4969
    jp c, Far_Call_Return                         ; $4971

    push af                                       ; $4974
    ld a, $0a                                     ; $4975
    ld [rRAMG], a                                 ; $4977
    pop af                                        ; $497A
    srl a                                         ; $497B
    inc a                                         ; $497D
    ld [rRAMB], a                                 ; $497E
    ld de, $0000                                  ; $4981
    rl d                                          ; $4984
    swap d                                        ; $4986
    ld b, $02                                     ; $4988

jr_002_498a:
    push bc                                       ; $498A
    push de                                       ; $498B
    ld hl, $af00                                  ; $498C
    add hl, de                                    ; $498F
    ld de, wTagOwnerId                            ; $4990
    ld c, $36                                     ; $4993

jr_002_4995:
    ld a, [de]                                    ; $4995
    ld [hl+], a                                   ; $4996
    inc de                                        ; $4997
    dec c                                         ; $4998
    jr nz, jr_002_4995                            ; $4999

    pop de                                        ; $499B
    push de                                       ; $499C
    ld hl, $af00                                  ; $499D
    add hl, de                                    ; $49A0
    ld bc, $005a                                  ; $49A1
    call Sram_WriteChecksum                       ; $49A4
    pop de                                        ; $49A7
    pop bc                                        ; $49A8
    ld a, e                                       ; $49A9
    add $5c                                       ; $49AA
    ld e, a                                       ; $49AC
    jr nc, jr_002_49b0                            ; $49AD

    inc d                                         ; $49AF

jr_002_49b0:
    dec b                                         ; $49B0
    jr nz, jr_002_498a                            ; $49B1

    call Sram_StorePhotoVector                    ; $49B3
    push af                                       ; $49B6
    xor a                                         ; $49B7
    ld [rRAMG], a                                 ; $49B8
    pop af                                        ; $49BB
    jp Far_Call_Return                            ; $49BC


; C: writes animation list
Settings_Store_Far::
    push af                                       ; $49BF
    ld a, $0a                                     ; $49C0
    ld [rRAMG], a                                 ; $49C2
    pop af                                        ; $49C5
    xor a                                         ; $49C6
    ld [rRAMB], a                                 ; $49C7
    ld de, $0000                                  ; $49CA
    ld b, $02                                     ; $49CD

jr_002_49cf:
    push bc                                       ; $49CF
    push de                                       ; $49D0
    ld hl, $b000                                  ; $49D1
    add hl, de                                    ; $49D4
    ld de, wAnimList                              ; $49D5
    ld c, $30                                     ; $49D8

jr_002_49da:
    ld a, [de]                                    ; $49DA
    ld [hl+], a                                   ; $49DB
    inc de                                        ; $49DC
    dec c                                         ; $49DD
    jr nz, jr_002_49da                            ; $49DE

    pop de                                        ; $49E0
    push de                                       ; $49E1
    ld hl, $b030                                  ; $49E2
    add hl, de                                    ; $49E5
    ld de, wAnimTiming                            ; $49E6
    ld c, $2f                                     ; $49E9

jr_002_49eb:
    ld a, [de]                                    ; $49EB
    ld [hl+], a                                   ; $49EC
    inc de                                        ; $49ED
    dec c                                         ; $49EE
    jr nz, jr_002_49eb                            ; $49EF

    pop de                                        ; $49F1
    ld hl, $b05f                                  ; $49F2
    add hl, de                                    ; $49F5
    ld a, [wAnimSpeed]                            ; $49F6
    ld [hl+], a                                   ; $49F9
    ld a, [wAnimBorder]                           ; $49FA
    ld [hl], a                                    ; $49FD
    push de                                       ; $49FE
    ld hl, $b000                                  ; $49FF
    add hl, de                                    ; $4A02
    ld bc, $00d7                                  ; $4A03
    call Sram_WriteChecksum                       ; $4A06
    pop de                                        ; $4A09
    pop bc                                        ; $4A0A
    ld a, e                                       ; $4A0B
    add $d9                                       ; $4A0C
    ld e, a                                       ; $4A0E
    jr nc, jr_002_4a12                            ; $4A0F

    inc d                                         ; $4A11

jr_002_4a12:
    dec b                                         ; $4A12
    jr nz, jr_002_49cf                            ; $4A13

    push af                                       ; $4A15
    xor a                                         ; $4A16
    ld [rRAMG], a                                 ; $4A17
    pop af                                        ; $4A1A
    jp Far_Call_Return                            ; $4A1B


; C: as 49A8 but translates the 47 animation entries photo number -> slot id
Settings_StoreAnimTranslated_Far::
    push af                                       ; $4A1E
    ld a, $0a                                     ; $4A1F
    ld [rRAMG], a                                 ; $4A21
    pop af                                        ; $4A24
    xor a                                         ; $4A25
    ld [rRAMB], a                                 ; $4A26
    ld de, $0000                                  ; $4A29
    ld b, $02                                     ; $4A2C

jr_002_4a2e:
    push bc                                       ; $4A2E
    push de                                       ; $4A2F
    ld hl, $b000                                  ; $4A30
    add hl, de                                    ; $4A33
    ld de, wAnimList                              ; $4A34
    ld c, $2f                                     ; $4A37

jr_002_4a39:
    ld a, [de]                                    ; $4A39
    call Vec_GetPhotoVectorByteFar                ; $4A3A
    ld [hl+], a                                   ; $4A3D
    inc de                                        ; $4A3E
    dec c                                         ; $4A3F
    jr nz, jr_002_4a39                            ; $4A40

    ld a, [de]                                    ; $4A42
    ld [hl], a                                    ; $4A43
    pop de                                        ; $4A44
    push de                                       ; $4A45
    ld hl, $b030                                  ; $4A46
    add hl, de                                    ; $4A49
    ld de, wAnimTiming                            ; $4A4A
    ld c, $2f                                     ; $4A4D

jr_002_4a4f:
    ld a, [de]                                    ; $4A4F
    ld [hl+], a                                   ; $4A50
    inc de                                        ; $4A51
    dec c                                         ; $4A52
    jr nz, jr_002_4a4f                            ; $4A53

    pop de                                        ; $4A55
    ld hl, $b05f                                  ; $4A56
    add hl, de                                    ; $4A59
    ld a, [wAnimSpeed]                            ; $4A5A
    ld [hl+], a                                   ; $4A5D
    ld a, [wAnimBorder]                           ; $4A5E
    ld [hl], a                                    ; $4A61
    push de                                       ; $4A62
    ld hl, $b000                                  ; $4A63
    add hl, de                                    ; $4A66
    ld bc, $00d7                                  ; $4A67
    call Sram_WriteChecksum                       ; $4A6A
    pop de                                        ; $4A6D
    pop bc                                        ; $4A6E
    ld a, e                                       ; $4A6F
    add $d9                                       ; $4A70
    ld e, a                                       ; $4A72
    jr nc, jr_002_4a76                            ; $4A73

    inc d                                         ; $4A75

jr_002_4a76:
    dec b                                         ; $4A76
    jr nz, jr_002_4a2e                            ; $4A77

    push af                                       ; $4A79
    xor a                                         ; $4A7A
    ld [rRAMG], a                                 ; $4A7B
    pop af                                        ; $4A7E
    jp Far_Call_Return                            ; $4A7F


; C: packs the D.J. tune from $D93D.. into the settings block (B061..) of both copies
Dj_StoreTune_Far::
    push af                                       ; $4A82
    ld a, $0a                                     ; $4A83
    ld [rRAMG], a                                 ; $4A85
    pop af                                        ; $4A88
    xor a                                         ; $4A89
    ld [rRAMB], a                                 ; $4A8A
    ld de, $0000                                  ; $4A8D
    ld b, $02                                     ; $4A90

; C: per-tune loop top: packs duty / length, envelope, modulation, notes and stereo codes of one tune from the editor
; shadows into the SRAM image (branch target; code read 2026-10-19)
Dj_StoreTune_Far_TuneLoop::
    push bc                                       ; $4A92
    push de                                       ; $4A93
    ld hl, $b061                                  ; $4A94
    add hl, de                                    ; $4A97
    ld de, wSound1DutyLen                         ; $4A98
    call Dj_PackDutyLength                        ; $4A9B
    ld de, wSound1Envelope                        ; $4A9E
    call Dj_PackEnvelope                          ; $4AA1
    ld de, wSound1Modulation                      ; $4AA4
    call Dj_PackModulation                        ; $4AA7
    ld de, wSound1Notes                           ; $4AAA
    call Dj_CopyNotes                             ; $4AAD
    ld de, wSound1Stereo                          ; $4AB0
    call Dj_PackStereoCodes                       ; $4AB3
    ld de, wSound2UserWave                        ; $4AB6
    call Dj_PackWave                              ; $4AB9
    ld de, wSound2WaveLen                         ; $4ABC
    call Dj_PackDutyLength                        ; $4ABF
    ld de, wSound2Modulation                      ; $4AC2
    call Dj_PackModulation                        ; $4AC5
    ld de, wSound2Notes                           ; $4AC8
    call Dj_CopyNotes                             ; $4ACB
    ld de, wSound2Stereo                          ; $4ACE
    call Dj_PackStereoCodes                       ; $4AD1
    ld de, wLoopLengths                           ; $4AD4
    ld a, [de]                                    ; $4AD7
    dec a                                         ; $4AD8
    inc de                                        ; $4AD9
    and $0f                                       ; $4ADA
    swap a                                        ; $4ADC
    ld c, a                                       ; $4ADE
    ld a, [de]                                    ; $4ADF
    dec a                                         ; $4AE0
    and $0f                                       ; $4AE1
    or c                                          ; $4AE3
    ld [hl+], a                                   ; $4AE4
    ld de, wNoiseEnvelope                         ; $4AE5
    call Dj_PackEnvelope                          ; $4AE8
    ld de, wNoiseGateLoop                         ; $4AEB
    ld a, [de]                                    ; $4AEE
    inc de                                        ; $4AEF
    and $0f                                       ; $4AF0
    swap a                                        ; $4AF2
    ld c, a                                       ; $4AF4
    ld a, [de]                                    ; $4AF5
    dec a                                         ; $4AF6
    and $0f                                       ; $4AF7
    or c                                          ; $4AF9
    ld [hl+], a                                   ; $4AFA
    ld de, wNoiseNotes                            ; $4AFB
    call Dj_CopyNotes                             ; $4AFE
    ld de, wNoiseStereoWidth                      ; $4B01
    call Dj_PackStereoCodes                       ; $4B04
    ld de, wNoiseStereoWidth                      ; $4B07
    call Dj_PackNoiseBits                         ; $4B0A
    ld a, [wTempo]                                ; $4B0D
    ld [hl+], a                                   ; $4B10
    ld [hl], $01                                  ; $4B11
    pop de                                        ; $4B13
    push de                                       ; $4B14
    ld hl, $b000                                  ; $4B15
    add hl, de                                    ; $4B18
    ld bc, $00d7                                  ; $4B19
    call Sram_WriteChecksum                       ; $4B1C
    pop de                                        ; $4B1F
    pop bc                                        ; $4B20
    ld a, e                                       ; $4B21
    add $d9                                       ; $4B22
    ld e, a                                       ; $4B24
    jr nc, jr_002_4b28                            ; $4B25

    inc d                                         ; $4B27

jr_002_4b28:
    dec b                                         ; $4B28
    jp nz, Dj_StoreTune_Far_TuneLoop              ; $4B29

    push af                                       ; $4B2C
    xor a                                         ; $4B2D
    ld [rRAMG], a                                 ; $4B2E
    pop af                                        ; $4B31
    jp Far_Call_Return                            ; $4B32


; C: packs duty (2 bits) and length (4 bits) into one byte. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: packs (duty & 3) << 4 | (length & $0F) into one byte,
; called by Dj_StoreTune_Far_TuneLoop (storing a D.J. tune to SRAM)
Dj_PackDutyLength::
    ld a, [de]                                    ; $4B35
    inc de                                        ; $4B36
    and $03                                       ; $4B37
    swap a                                        ; $4B39
    ld c, a                                       ; $4B3B
    ld a, [de]                                    ; $4B3C
    and $0f                                       ; $4B3D
    or c                                          ; $4B3F
    ld [hl+], a                                   ; $4B40
    ret                                           ; $4B41


; C: packs direction / period / initial volume. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB
; scenarios, core organic runs); C from the code: packs envelope direction (bit 7), step (bits 6-4) and volume (bits
; 3-0) into one byte, called by Dj_StoreTune_Far_TuneLoop
Dj_PackEnvelope::
    ld a, [de]                                    ; $4B42
    inc de                                        ; $4B43
    and $01                                       ; $4B44
    rrc a                                         ; $4B46
    ld c, a                                       ; $4B48
    ld a, [de]                                    ; $4B49
    inc de                                        ; $4B4A
    and $07                                       ; $4B4B
    swap a                                        ; $4B4D
    or c                                          ; $4B4F
    ld c, a                                       ; $4B50
    ld a, [de]                                    ; $4B51
    and $0f                                       ; $4B52
    or c                                          ; $4B54
    ld [hl+], a                                   ; $4B55
    ret                                           ; $4B56


; C: packs modulation depth and flags. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core
; organic runs); C from the code: packs the modulation fields into one byte, called by Dj_StoreTune_Far_TuneLoop
Dj_PackModulation::
    ld a, [de]                                    ; $4B57
    inc de                                        ; $4B58
    and $7f                                       ; $4B59
    ld [hl+], a                                   ; $4B5B
    ld a, [de]                                    ; $4B5C
    inc de                                        ; $4B5D
    and $7f                                       ; $4B5E
    ld [hl-], a                                   ; $4B60
    ld a, [de]                                    ; $4B61
    and $01                                       ; $4B62
    rrc a                                         ; $4B64
    or [hl]                                       ; $4B66
    ld [hl+], a                                   ; $4B67
    ld a, [de]                                    ; $4B68
    and $02                                       ; $4B69
    rrc a                                         ; $4B6B
    rrc a                                         ; $4B6D
    or [hl]                                       ; $4B6F
    ld [hl+], a                                   ; $4B70
    ret                                           ; $4B71


; C: copies 16 note bytes. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: copies the 16 note bytes, called by Dj_StoreTune_Far_TuneLoop
Dj_CopyNotes::
    ld b, $10                                     ; $4B72

jr_002_4b74:
    ld a, [de]                                    ; $4B74
    ld [hl+], a                                   ; $4B75
    inc de                                        ; $4B76
    dec b                                         ; $4B77
    jr nz, jr_002_4b74                            ; $4B78

    ret                                           ; $4B7A


; C: packs four 2-bit stereo codes per byte. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB
; scenarios, core organic runs); C from the code: packs the stereo codes, called by Dj_StoreTune_Far_TuneLoop
Dj_PackStereoCodes::
    ld b, $04                                     ; $4B7B

jr_002_4b7d:
    ld a, [de]                                    ; $4B7D
    inc de                                        ; $4B7E
    and $03                                       ; $4B7F
    rrc a                                         ; $4B81
    rrc a                                         ; $4B83
    ld c, a                                       ; $4B85
    ld a, [de]                                    ; $4B86
    inc de                                        ; $4B87
    and $03                                       ; $4B88
    swap a                                        ; $4B8A
    or c                                          ; $4B8C
    ld c, a                                       ; $4B8D
    ld a, [de]                                    ; $4B8E
    inc de                                        ; $4B8F
    and $03                                       ; $4B90
    sla a                                         ; $4B92
    sla a                                         ; $4B94
    or c                                          ; $4B96
    ld c, a                                       ; $4B97
    ld a, [de]                                    ; $4B98
    inc de                                        ; $4B99
    and $03                                       ; $4B9A
    or c                                          ; $4B9C
    ld [hl+], a                                   ; $4B9D
    dec b                                         ; $4B9E
    jr nz, jr_002_4b7d                            ; $4B9F

    ret                                           ; $4BA1


; C: packs 32 wave nibbles into 16 bytes. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios,
; core organic runs); C from the code: packs 32 wave nibbles into 16 bytes, called by Dj_StoreTune_Far_TuneLoop
Dj_PackWave::
    ld b, $10                                     ; $4BA2

jr_002_4ba4:
    ld a, [de]                                    ; $4BA4
    inc de                                        ; $4BA5
    and $0f                                       ; $4BA6
    swap a                                        ; $4BA8
    ld c, a                                       ; $4BAA
    ld a, [de]                                    ; $4BAB
    inc de                                        ; $4BAC
    and $0f                                       ; $4BAD
    or c                                          ; $4BAF
    ld [hl+], a                                   ; $4BB0
    dec b                                         ; $4BB1
    jr nz, jr_002_4ba4                            ; $4BB2

    ret                                           ; $4BB4


; C: packs the noise pattern bits. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core
; organic runs); C from the code: packs 2 x 8 noise flags into 2 bytes, called by Dj_StoreTune_Far_TuneLoop
Dj_PackNoiseBits::
    ld b, $02                                     ; $4BB5

jr_002_4bb7:
    ld c, $08                                     ; $4BB7

jr_002_4bb9:
    ld a, [de]                                    ; $4BB9
    inc de                                        ; $4BBA
    swap a                                        ; $4BBB
    srl a                                         ; $4BBD
    rl [hl]                                       ; $4BBF
    dec c                                         ; $4BC1
    jr nz, jr_002_4bb9                            ; $4BC2

    inc hl                                        ; $4BC4
    dec b                                         ; $4BC5
    jr nz, jr_002_4bb7                            ; $4BC6

    ret                                           ; $4BC8


; C: stores the counters block DA96.. ($16 bytes) into both settings copies with checksum
Counters_Store_Far::
    push af                                       ; $4BC9
    ld a, $0a                                     ; $4BCA
    ld [rRAMG], a                                 ; $4BCC
    pop af                                        ; $4BCF
    xor a                                         ; $4BD0
    ld [rRAMB], a                                 ; $4BD1
    ld de, $0000                                  ; $4BD4
    ld b, $02                                     ; $4BD7

jr_002_4bd9:
    push bc                                       ; $4BD9
    push de                                       ; $4BDA
    ld hl, $b0bb                                  ; $4BDB
    add hl, de                                    ; $4BDE
    ld de, wCntTaken                              ; $4BDF
    ld c, $16                                     ; $4BE2

jr_002_4be4:
    ld a, [de]                                    ; $4BE4
    ld [hl+], a                                   ; $4BE5
    inc de                                        ; $4BE6
    dec c                                         ; $4BE7
    jr nz, jr_002_4be4                            ; $4BE8

    pop de                                        ; $4BEA
    push de                                       ; $4BEB
    ld hl, $b000                                  ; $4BEC
    add hl, de                                    ; $4BEF
    ld bc, $00d7                                  ; $4BF0
    call Sram_WriteChecksum                       ; $4BF3
    pop de                                        ; $4BF6
    pop bc                                        ; $4BF7
    ld a, e                                       ; $4BF8
    add $d9                                       ; $4BF9
    ld e, a                                       ; $4BFB
    jr nc, jr_002_4bff                            ; $4BFC

    inc d                                         ; $4BFE

jr_002_4bff:
    dec b                                         ; $4BFF
    jr nz, jr_002_4bd9                            ; $4C00

    push af                                       ; $4C02
    xor a                                         ; $4C03
    ld [rRAMG], a                                 ; $4C04
    pop af                                        ; $4C07
    jp Far_Call_Return                            ; $4C08


; C: stores owner_id DA49.. ($12 bytes) into both owner block copies with checksum
Owner_Store_Far::
    push af                                       ; $4C0B
    ld a, $0a                                     ; $4C0C
    ld [rRAMG], a                                 ; $4C0E
    pop af                                        ; $4C11
    ld a, $01                                     ; $4C12
    ld [rRAMB], a                                 ; $4C14
    ld de, $0000                                  ; $4C17
    ld b, $02                                     ; $4C1A

jr_002_4c1c:
    push bc                                       ; $4C1C
    push de                                       ; $4C1D
    ld hl, $afb8                                  ; $4C1E
    add hl, de                                    ; $4C21
    ld de, wOwnerId                               ; $4C22
    ld c, $12                                     ; $4C25

jr_002_4c27:
    ld a, [de]                                    ; $4C27
    ld [hl+], a                                   ; $4C28
    inc de                                        ; $4C29
    dec c                                         ; $4C2A
    jr nz, jr_002_4c27                            ; $4C2B

    pop de                                        ; $4C2D
    push de                                       ; $4C2E
    ld hl, $afb8                                  ; $4C2F
    add hl, de                                    ; $4C32
    ld bc, $0017                                  ; $4C33
    call Sram_WriteChecksum                       ; $4C36
    pop de                                        ; $4C39
    pop bc                                        ; $4C3A
    ld a, e                                       ; $4C3B
    add $19                                       ; $4C3C
    ld e, a                                       ; $4C3E
    jr nc, jr_002_4c42                            ; $4C3F

    inc d                                         ; $4C41

jr_002_4c42:
    dec b                                         ; $4C42
    jr nz, jr_002_4c1c                            ; $4C43

    push af                                       ; $4C45
    xor a                                         ; $4C46
    ld [rRAMG], a                                 ; $4C47
    pop af                                        ; $4C4A
    jp Far_Call_Return                            ; $4C4B


; C: stores the $E00-byte Game Face image at B1FC and sets the flag B0D1
GameFace_Store_Far::
    push af                                       ; $4C4E
    ld a, $0a                                     ; $4C4F
    ld [rRAMG], a                                 ; $4C51
    pop af                                        ; $4C54
    xor a                                         ; $4C55
    ld [rRAMB], a                                 ; $4C56
    ld hl, $b1fc                                  ; $4C59
    ld de, wPhotoImage                            ; $4C5C
    ld bc, $0e00                                  ; $4C5F

jr_002_4c62:
    ld a, [de]                                    ; $4C62
    ld [hl+], a                                   ; $4C63
    inc de                                        ; $4C64
    dec bc                                        ; $4C65
    ld a, c                                       ; $4C66
    or b                                          ; $4C67
    jr nz, jr_002_4c62                            ; $4C68

    ld de, $0000                                  ; $4C6A
    ld b, $02                                     ; $4C6D

jr_002_4c6f:
    push bc                                       ; $4C6F
    ld hl, $b0d1                                  ; $4C70
    add hl, de                                    ; $4C73
    ld a, $01                                     ; $4C74
    ld [hl], a                                    ; $4C76
    push de                                       ; $4C77
    ld hl, $b000                                  ; $4C78
    add hl, de                                    ; $4C7B
    ld bc, $00d7                                  ; $4C7C
    call Sram_WriteChecksum                       ; $4C7F
    pop de                                        ; $4C82
    pop bc                                        ; $4C83
    ld a, e                                       ; $4C84
    add $d9                                       ; $4C85
    ld e, a                                       ; $4C87
    jr nc, jr_002_4c8b                            ; $4C88

    inc d                                         ; $4C8A

jr_002_4c8b:
    dec b                                         ; $4C8B
    jr nz, jr_002_4c6f                            ; $4C8C

    push af                                       ; $4C8E
    xor a                                         ; $4C8F
    ld [rRAMG], a                                 ; $4C90
    pop af                                        ; $4C93
    jp Far_Call_Return                            ; $4C94


; C: A = photo number: copies its image to $C000; numbers >= $1E are built-in images from bank $36 / table 02:5218; C:
; the routine is executed in this build's coverage run and at most a quarter of its Japanese instructions are unpaired
Photo_LoadImage_Far::
    cp $1e                                        ; $4C97
    jr nc, jr_002_4cde                            ; $4C99

    ld hl, wPhotoCount                            ; $4C9B
    cp [hl]                                       ; $4C9E
    jr nc, jr_002_4ccd                            ; $4C9F

    ldh [hFarcallAArg], a                         ; $4CA1
    farcall Photo_FindSlot_Far                    ; $4CA3
    srl a                                         ; $4CAB
    inc a                                         ; $4CAD
    ld [rRAMB], a                                 ; $4CAE
    ld de, $0000                                  ; $4CB1
    rl d                                          ; $4CB4
    swap d                                        ; $4CB6
    ld hl, $a000                                  ; $4CB8
    add hl, de                                    ; $4CBB
    ld de, wPhotoImage                            ; $4CBC
    ld bc, $0fb8                                  ; $4CBF

jr_002_4cc2:
    ld a, [hl+]                                   ; $4CC2
    ld [de], a                                    ; $4CC3
    inc de                                        ; $4CC4
    dec bc                                        ; $4CC5
    ld a, b                                       ; $4CC6
    or c                                          ; $4CC7
    jr nz, jr_002_4cc2                            ; $4CC8

    jp Far_Call_Return                            ; $4CCA


jr_002_4ccd:
    farcopy Mem_CopyFromBank, AlbumB_UnusedSlotB_Tiles, wPhotoImage, $0fb8 ; $4CCD
    jp Far_Call_Return                            ; $4CDB


jr_002_4cde:
    sub $1e                                       ; $4CDE
    cp $10                                        ; $4CE0
    jr c, jr_002_4cfa                             ; $4CE2

    call AlbumB_CheckGate                         ; $4CE4
    jr nz, jr_002_4cfa                            ; $4CE7

    farcopy Mem_CopyFromBank, AlbumB_UnusedSlotA_Tiles, wPhotoImage, $0fb8 ; $4CE9
    jp Far_Call_Return                            ; $4CF7


jr_002_4cfa:
    ld c, a                                       ; $4CFA
    sla a                                         ; $4CFB
    add c                                         ; $4CFD
    ld c, a                                       ; $4CFE
    ld b, $00                                     ; $4CFF
    ld hl, AlbumB_SlotTbl                         ; $4D01
    add hl, bc                                    ; $4D04
    ld c, [hl]                                    ; $4D05
    inc hl                                        ; $4D06
    ld b, [hl]                                    ; $4D07
    inc hl                                        ; $4D08
    ld a, [hl]                                    ; $4D09
    ld l, c                                       ; $4D0A
    ld h, b                                       ; $4D0B
    ld de, wPhotoImage                            ; $4D0C
    ld bc, $0fb8                                  ; $4D0F
    call Mem_CopyFromBank                         ; $4D12
    jp Far_Call_Return                            ; $4D15


; C: A = Album B photo id: tests the counter / score thresholds in a table; Z/NZ and the unlock bit mask; C: called
; from an instruction that the port pairs with a Japanese call to the Japanese routine (same callee, same context)
AlbumB_CheckGate::
    push de                                       ; $4D18
    push af                                       ; $4D19
    ldh [hFarcallAArg], a                         ; $4D1A
    farcall Counters_Load_Far                     ; $4D1C
    ld de, $0000                                  ; $4D24
    ld a, [wCntTaken + $1]                        ; $4D27
    and a                                         ; $4D2A
    jr nz, jr_002_4d34                            ; $4D2B

    ld a, [wCntTaken]                             ; $4D2D
    cp $60                                        ; $4D30
    jr c, jr_002_4d36                             ; $4D32

jr_002_4d34:
    set 0, e                                      ; $4D34

jr_002_4d36:
    ld a, [wCntErased + $1]                       ; $4D36
    and a                                         ; $4D39
    jr nz, jr_002_4d43                            ; $4D3A

    ld a, [wCntErased]                            ; $4D3C
    cp $60                                        ; $4D3F
    jr c, jr_002_4d45                             ; $4D41

jr_002_4d43:
    set 1, e                                      ; $4D43

jr_002_4d45:
    ld a, [wCntSent + $1]                         ; $4D45
    and a                                         ; $4D48
    jr nz, jr_002_4d52                            ; $4D49

    ld a, [wCntSent]                              ; $4D4B
    cp $15                                        ; $4D4E
    jr c, jr_002_4d54                             ; $4D50

jr_002_4d52:
    set 2, e                                      ; $4D52

jr_002_4d54:
    ld a, [wCntRecvA]                             ; $4D54
    cp $05                                        ; $4D57
    jr c, jr_002_4d5d                             ; $4D59

    set 3, e                                      ; $4D5B

jr_002_4d5d:
    ld a, [wCntRecvB]                             ; $4D5D
    cp $05                                        ; $4D60
    jr c, jr_002_4d66                             ; $4D62

    set 4, e                                      ; $4D64

jr_002_4d66:
    ld a, [wCntPrinted + $1]                      ; $4D66
    and a                                         ; $4D69
    jr nz, jr_002_4d73                            ; $4D6A

    ld a, [wCntPrinted]                           ; $4D6C
    cp $30                                        ; $4D6F
    jr c, jr_002_4d75                             ; $4D71

jr_002_4d73:
    set 5, e                                      ; $4D73

jr_002_4d75:
    ld a, [wBestShooter + $3]                     ; $4D75
    ld hl, wBestShooter + $2                      ; $4D78
    or [hl]                                       ; $4D7B
    jr nz, jr_002_4d8d                            ; $4D7C

    ld a, [wBestShooter + $1]                     ; $4D7E
    cp $30                                        ; $4D81
    jr c, jr_002_4d93                             ; $4D83

    cp $50                                        ; $4D85
    jr c, jr_002_4d91                             ; $4D87

    cp $70                                        ; $4D89
    jr c, jr_002_4d8f                             ; $4D8B

jr_002_4d8d:
    set 0, d                                      ; $4D8D

jr_002_4d8f:
    set 7, e                                      ; $4D8F

jr_002_4d91:
    set 6, e                                      ; $4D91

jr_002_4d93:
    ld a, [wBestBall + $1]                        ; $4D93
    cp $05                                        ; $4D96
    jr c, jr_002_4da8                             ; $4D98

    cp $07                                        ; $4D9A
    jr c, jr_002_4da6                             ; $4D9C

    cp $10                                        ; $4D9E
    jr c, jr_002_4da4                             ; $4DA0

    set 3, d                                      ; $4DA2

jr_002_4da4:
    set 2, d                                      ; $4DA4

jr_002_4da6:
    set 1, d                                      ; $4DA6

jr_002_4da8:
    ld a, [wBestRun + $1]                         ; $4DA8
    cp $82                                        ; $4DAB
    jr c, jr_002_4db7                             ; $4DAD

    cp $83                                        ; $4DAF
    jr c, jr_002_4db5                             ; $4DB1

    set 5, d                                      ; $4DB3

jr_002_4db5:
    set 4, d                                      ; $4DB5

jr_002_4db7:
    pop af                                        ; $4DB7
    push af                                       ; $4DB8
    sub $10                                       ; $4DB9
    sla a                                         ; $4DBB
    ld c, a                                       ; $4DBD
    ld b, $00                                     ; $4DBE
    ld hl, AlbumB_CheckGate_Tbl4DCE               ; $4DC0
    add hl, bc                                    ; $4DC3
    ld a, [hl+]                                   ; $4DC4
    and e                                         ; $4DC5
    ld e, a                                       ; $4DC6
    ld a, [hl]                                    ; $4DC7
    and d                                         ; $4DC8
    or e                                          ; $4DC9
    pop bc                                        ; $4DCA
    ld a, b                                       ; $4DCB
    pop de                                        ; $4DCC
    ret                                           ; $4DCD


; C: auto: 8 bytes, bytes; referenced by AlbumB_CheckGate. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the
; organic corpus, modes 18 (tcrf_check/assets/l3_names/); L3 owner: named after its reader AlbumB_CheckGate, which
; reads it here; Gold: bytes equal to the international block 02:4DB7 (L3, ...
AlbumB_CheckGate_Tbl4DCE::
    db $01, $00, $02, $00, $04, $00, $08, $00

    db $10
    db $00
    db $20
    db $00
    db $40
    db $00
    db $80
    db $00
    db $00
    db $01
    db $00
    db $02
    db $00
    db $04
    db $00
    db $08
    db $00
    db $10
    db $00
    db $20
    db $00
    db $40
    db $00

    db $80

; C: hot-spot block of a photo (30 bytes) -> $D643
Photo_LoadHotspots_Far::
    cp $1e                                        ; $4DEE
    jr nc, jr_002_4e1b                            ; $4DF0

    ldh [hFarcallAArg], a                         ; $4DF2
    farcall Photo_FindSlot_Far                    ; $4DF4
    srl a                                         ; $4DFC
    inc a                                         ; $4DFE
    ld [rRAMB], a                                 ; $4DFF
    ld de, $0000                                  ; $4E02
    rl d                                          ; $4E05
    swap d                                        ; $4E07
    ld hl, $af36                                  ; $4E09
    add hl, de                                    ; $4E0C
    ld de, wHotspotBlock                          ; $4E0D
    ld b, $1e                                     ; $4E10

jr_002_4e12:
    ld a, [hl+]                                   ; $4E12
    ld [de], a                                    ; $4E13
    inc de                                        ; $4E14
    dec b                                         ; $4E15
    jr nz, jr_002_4e12                            ; $4E16

    jp Far_Call_Return                            ; $4E18


jr_002_4e1b:
    sub $1e                                       ; $4E1B
    ld c, a                                       ; $4E1D
    sla a                                         ; $4E1E
    add c                                         ; $4E20
    ld c, a                                       ; $4E21
    ld b, $00                                     ; $4E22
    ld hl, AlbumB_SlotTbl                         ; $4E24
    add hl, bc                                    ; $4E27
    ld c, [hl]                                    ; $4E28
    inc hl                                        ; $4E29
    ld b, [hl]                                    ; $4E2A
    inc hl                                        ; $4E2B
    ld a, [hl]                                    ; $4E2C
    ld hl, $0f36                                  ; $4E2D
    add hl, bc                                    ; $4E30
    ld de, wHotspotBlock                          ; $4E31
    ld bc, $001e                                  ; $4E34
    call Mem_CopyFromBank                         ; $4E37
    jp Far_Call_Return                            ; $4E3A


; C: same
Photo_LoadHotspotsTranslated_Far::
    cp $1e                                        ; $4E3D
    jr nc, jr_002_4e75                            ; $4E3F

    ldh [hFarcallAArg], a                         ; $4E41
    farcall Photo_FindSlot_Far                    ; $4E43
    srl a                                         ; $4E4B
    inc a                                         ; $4E4D
    ld [rRAMB], a                                 ; $4E4E
    ld de, $0000                                  ; $4E51
    rl d                                          ; $4E54
    swap d                                        ; $4E56
    ld hl, $af36                                  ; $4E58
    add hl, de                                    ; $4E5B
    ld de, wHotspotBlock                          ; $4E5C
    ld b, $19                                     ; $4E5F

jr_002_4e61:
    ld a, [hl+]                                   ; $4E61
    ld [de], a                                    ; $4E62
    inc de                                        ; $4E63
    dec b                                         ; $4E64
    jr nz, jr_002_4e61                            ; $4E65

    ld b, $05                                     ; $4E67

jr_002_4e69:
    ld a, [hl+]                                   ; $4E69
    call Vec_GetPhotoVectorByte                   ; $4E6A
    ld [de], a                                    ; $4E6D
    inc de                                        ; $4E6E
    dec b                                         ; $4E6F
    jr nz, jr_002_4e69                            ; $4E70

    jp Far_Call_Return                            ; $4E72


jr_002_4e75:
    sub $1e                                       ; $4E75
    ld c, a                                       ; $4E77
    sla a                                         ; $4E78
    add c                                         ; $4E7A
    ld c, a                                       ; $4E7B
    ld b, $00                                     ; $4E7C
    ld hl, AlbumB_SlotTbl                         ; $4E7E
    add hl, bc                                    ; $4E81
    ld c, [hl]                                    ; $4E82
    inc hl                                        ; $4E83
    ld b, [hl]                                    ; $4E84
    inc hl                                        ; $4E85
    ld a, [hl]                                    ; $4E86
    ld hl, $0f36                                  ; $4E87
    add hl, bc                                    ; $4E8A
    ld de, wHotspotBlock                          ; $4E8B
    ld bc, $001e                                  ; $4E8E
    call Mem_CopyFromBank                         ; $4E91
    jp Far_Call_Return                            ; $4E94


; C: border number of a photo -> $D7C1 ($12 for built-in images)
Photo_LoadBorder_Far::
    cp $1e                                        ; $4E97
    jr nc, jr_002_4ebd                            ; $4E99

    ldh [hFarcallAArg], a                         ; $4E9B
    farcall Photo_FindSlot_Far                    ; $4E9D
    srl a                                         ; $4EA5
    inc a                                         ; $4EA7
    ld [rRAMB], a                                 ; $4EA8
    ld de, $0000                                  ; $4EAB
    rl d                                          ; $4EAE
    swap d                                        ; $4EB0
    ld hl, $af54                                  ; $4EB2
    add hl, de                                    ; $4EB5
    ld a, [hl]                                    ; $4EB6
    ld [wBorderNumber], a                         ; $4EB7
    jp Far_Call_Return                            ; $4EBA


jr_002_4ebd:
    ld a, $12                                     ; $4EBD
    ld [wBorderNumber], a                         ; $4EBF
    jp Far_Call_Return                            ; $4EC2


; C: $36 tag fields of a photo -> tag_owner_id $DA5B
Photo_LoadTagFields_Far::
    cp $1e                                        ; $4EC5
    jr nc, jr_002_4ef2                            ; $4EC7

    ldh [hFarcallAArg], a                         ; $4EC9
    farcall Photo_FindSlot_Far                    ; $4ECB
    srl a                                         ; $4ED3
    inc a                                         ; $4ED5
    ld [rRAMB], a                                 ; $4ED6
    ld de, $0000                                  ; $4ED9
    rl d                                          ; $4EDC
    swap d                                        ; $4EDE
    ld hl, $af00                                  ; $4EE0
    add hl, de                                    ; $4EE3
    ld de, wTagOwnerId                            ; $4EE4
    ld b, $36                                     ; $4EE7

jr_002_4ee9:
    ld a, [hl+]                                   ; $4EE9
    ld [de], a                                    ; $4EEA
    inc de                                        ; $4EEB
    dec b                                         ; $4EEC
    jr nz, jr_002_4ee9                            ; $4EED

    jp Far_Call_Return                            ; $4EEF


jr_002_4ef2:
    sub $1e                                       ; $4EF2
    ld c, a                                       ; $4EF4
    sla a                                         ; $4EF5
    add c                                         ; $4EF7
    ld c, a                                       ; $4EF8
    ld b, $00                                     ; $4EF9
    ld hl, AlbumB_SlotTbl                         ; $4EFB
    add hl, bc                                    ; $4EFE
    ld c, [hl]                                    ; $4EFF
    inc hl                                        ; $4F00
    ld b, [hl]                                    ; $4F01
    inc hl                                        ; $4F02
    ld a, [hl]                                    ; $4F03
    ld hl, $0f00                                  ; $4F04
    add hl, bc                                    ; $4F07
    ld de, wTagOwnerId                            ; $4F08
    ld bc, $0036                                  ; $4F0B
    call Mem_CopyFromBank                         ; $4F0E
    jp Far_Call_Return                            ; $4F11


; C: animation list / timing / speed / border from the settings block -> $D681..
Settings_LoadAnim_Far::
    xor a                                         ; $4F14
    ld [rRAMB], a                                 ; $4F15
    ld hl, $b000                                  ; $4F18
    ld de, wAnimList                              ; $4F1B
    ld c, $30                                     ; $4F1E

jr_002_4f20:
    ld a, [hl+]                                   ; $4F20
    ld [de], a                                    ; $4F21
    inc de                                        ; $4F22
    dec c                                         ; $4F23
    jr nz, jr_002_4f20                            ; $4F24

    xor a                                         ; $4F26
    ld [wAnimListGuard], a                        ; $4F27
    ld hl, $b030                                  ; $4F2A
    ld de, wAnimTiming                            ; $4F2D
    ld c, $2f                                     ; $4F30

jr_002_4f32:
    ld a, [hl+]                                   ; $4F32
    ld [de], a                                    ; $4F33
    inc de                                        ; $4F34
    dec c                                         ; $4F35
    jr nz, jr_002_4f32                            ; $4F36

    ld a, $ff                                     ; $4F38
    ld [wAnimTimingGuardLo], a                    ; $4F3A
    ld [wAnimTimingGuardHi], a                    ; $4F3D
    ld hl, $b05f                                  ; $4F40
    ld a, [hl+]                                   ; $4F43
    ld [wAnimSpeed], a                            ; $4F44
    ld a, [hl]                                    ; $4F47
    ld [wAnimBorder], a                           ; $4F48
    jp Far_Call_Return                            ; $4F4B


; C: same with the list entries translated slot -> photo number
Settings_LoadAnimTranslated_Far::
    xor a                                         ; $4F4E
    ld [rRAMB], a                                 ; $4F4F
    ld hl, $b000                                  ; $4F52
    ld de, wAnimList                              ; $4F55
    ld c, $2f                                     ; $4F58

jr_002_4f5a:
    ld a, [hl+]                                   ; $4F5A
    call Vec_GetPhotoVectorByte                   ; $4F5B
    ld [de], a                                    ; $4F5E
    inc de                                        ; $4F5F
    dec c                                         ; $4F60
    jr nz, jr_002_4f5a                            ; $4F61

    ld a, [hl]                                    ; $4F63
    ld [de], a                                    ; $4F64
    xor a                                         ; $4F65
    ld [wAnimListGuard], a                        ; $4F66
    ld hl, $b030                                  ; $4F69
    ld de, wAnimTiming                            ; $4F6C
    ld c, $2f                                     ; $4F6F

jr_002_4f71:
    ld a, [hl+]                                   ; $4F71
    ld [de], a                                    ; $4F72
    inc de                                        ; $4F73
    dec c                                         ; $4F74
    jr nz, jr_002_4f71                            ; $4F75

    ld a, $ff                                     ; $4F77
    ld [wAnimTimingGuardLo], a                    ; $4F79
    ld [wAnimTimingGuardHi], a                    ; $4F7C
    ld hl, $b05f                                  ; $4F7F
    ld a, [hl+]                                   ; $4F82
    ld [wAnimSpeed], a                            ; $4F83
    ld a, [hl]                                    ; $4F86
    ld [wAnimBorder], a                           ; $4F87
    jp Far_Call_Return                            ; $4F8A


; C: HL = DE then loads the D.J. tune. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz)
Dj_LoadTune_FromDE_Far::
    ld h, d                                       ; $4F8D
    ld l, e                                       ; $4F8E
    jr jr_002_4f98                                ; $4F8F

; C: unpacks the D.J. tune from the settings block B061.. into $D93D..
Dj_LoadTune_Far::
    xor a                                         ; $4F91
    ld [rRAMB], a                                 ; $4F92
    ld hl, $b061                                  ; $4F95

jr_002_4f98:
    ld de, wSound1DutyLen                         ; $4F98
    call Dj_UnpackDutyLength                      ; $4F9B
    ld de, wSound1Envelope                        ; $4F9E
    call Dj_UnpackEnvelope                        ; $4FA1
    ld de, wSound1Modulation                      ; $4FA4
    call Dj_UnpackModulation                      ; $4FA7
    ld de, wSound1Notes                           ; $4FAA
    call Dj_CopyNotesOut                          ; $4FAD
    ld de, wSound1Stereo                          ; $4FB0
    call Dj_UnpackStereoCodes                     ; $4FB3
    ld de, wSound2UserWave                        ; $4FB6
    call Dj_UnpackWave                            ; $4FB9
    ld de, wSound2WaveLen                         ; $4FBC
    call Dj_UnpackDutyLength                      ; $4FBF
    ld de, wSound2Modulation                      ; $4FC2
    call Dj_UnpackModulation                      ; $4FC5
    ld de, wSound2Notes                           ; $4FC8
    call Dj_CopyNotesOut                          ; $4FCB
    ld de, wSound2Stereo                          ; $4FCE
    call Dj_UnpackStereoCodes                     ; $4FD1
    ld de, wLoopLengths                           ; $4FD4
    ld a, [hl]                                    ; $4FD7
    and $f0                                       ; $4FD8
    swap a                                        ; $4FDA
    inc a                                         ; $4FDC
    ld [de], a                                    ; $4FDD
    inc de                                        ; $4FDE
    ld a, [hl+]                                   ; $4FDF
    and $0f                                       ; $4FE0
    inc a                                         ; $4FE2
    ld [de], a                                    ; $4FE3
    ld de, wNoiseEnvelope                         ; $4FE4
    call Dj_UnpackEnvelope                        ; $4FE7
    ld de, wNoiseGateLoop                         ; $4FEA
    ld a, [hl]                                    ; $4FED
    and $f0                                       ; $4FEE
    swap a                                        ; $4FF0
    ld [de], a                                    ; $4FF2
    inc de                                        ; $4FF3
    ld a, [hl+]                                   ; $4FF4
    and $0f                                       ; $4FF5
    inc a                                         ; $4FF7
    ld [de], a                                    ; $4FF8
    ld de, wNoiseNotes                            ; $4FF9
    call Dj_CopyNotesOut                          ; $4FFC
    ld de, wNoiseStereoWidth                      ; $4FFF
    call Dj_UnpackStereoCodes                     ; $5002
    ld de, wNoiseStereoWidth                      ; $5005
    call Dj_UnpackNoiseBits                       ; $5008
    ld a, [hl+]                                   ; $500B
    ld [wTempo], a                                ; $500C
    ld a, [hl]                                    ; $500F
    ld [wSavedTunePresent], a                     ; $5010
    jp Far_Call_Return                            ; $5013


; C: inverse of 4B1E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackDutyLength::
    ld a, [hl]                                    ; $5016
    and $30                                       ; $5017
    swap a                                        ; $5019
    ld [de], a                                    ; $501B
    inc de                                        ; $501C
    ld a, [hl+]                                   ; $501D
    and $0f                                       ; $501E
    ld [de], a                                    ; $5020
    ret                                           ; $5021


; C: inverse of 4B2B. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackEnvelope::
    ld a, [hl]                                    ; $5022
    and $80                                       ; $5023
    rlc a                                         ; $5025
    ld [de], a                                    ; $5027
    inc de                                        ; $5028
    ld a, [hl]                                    ; $5029
    and $70                                       ; $502A
    swap a                                        ; $502C
    ld [de], a                                    ; $502E
    inc de                                        ; $502F
    ld a, [hl+]                                   ; $5030
    and $0f                                       ; $5031
    ld [de], a                                    ; $5033
    ret                                           ; $5034


; C: inverse of 4B40. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackModulation::
    ld a, [hl+]                                   ; $5035
    and $7f                                       ; $5036
    ld [de], a                                    ; $5038
    inc de                                        ; $5039
    ld a, [hl-]                                   ; $503A
    and $7f                                       ; $503B
    ld [de], a                                    ; $503D
    inc de                                        ; $503E
    ld a, [hl+]                                   ; $503F
    and $80                                       ; $5040
    rlc a                                         ; $5042
    ld c, a                                       ; $5044
    ld a, [hl+]                                   ; $5045
    and $80                                       ; $5046
    rlc a                                         ; $5048
    rlc a                                         ; $504A
    or c                                          ; $504C
    ld [de], a                                    ; $504D
    ret                                           ; $504E


; C: copies 16 note bytes. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz)
Dj_CopyNotesOut::
    ld b, $10                                     ; $504F

jr_002_5051:
    ld a, [hl+]                                   ; $5051
    ld [de], a                                    ; $5052
    inc de                                        ; $5053
    dec b                                         ; $5054
    jr nz, jr_002_5051                            ; $5055

    ret                                           ; $5057


; C: inverse of 4B64. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackStereoCodes::
    ld b, $04                                     ; $5058

jr_002_505a:
    ld a, [hl]                                    ; $505A
    and $c0                                       ; $505B
    rlc a                                         ; $505D
    rlc a                                         ; $505F
    ld [de], a                                    ; $5061
    inc de                                        ; $5062
    ld a, [hl]                                    ; $5063
    and $30                                       ; $5064
    swap a                                        ; $5066
    ld [de], a                                    ; $5068
    inc de                                        ; $5069
    ld a, [hl]                                    ; $506A
    and $0c                                       ; $506B
    srl a                                         ; $506D
    srl a                                         ; $506F
    ld [de], a                                    ; $5071
    inc de                                        ; $5072
    ld a, [hl+]                                   ; $5073
    and $03                                       ; $5074
    ld [de], a                                    ; $5076
    inc de                                        ; $5077
    dec b                                         ; $5078
    jr nz, jr_002_505a                            ; $5079

    ret                                           ; $507B


; C: inverse of 4B8B. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackWave::
    ld b, $10                                     ; $507C

jr_002_507e:
    ld a, [hl]                                    ; $507E
    and $f0                                       ; $507F
    swap a                                        ; $5081
    ld [de], a                                    ; $5083
    inc de                                        ; $5084
    ld a, [hl+]                                   ; $5085
    and $0f                                       ; $5086
    ld [de], a                                    ; $5088
    inc de                                        ; $5089
    dec b                                         ; $508A
    jr nz, jr_002_507e                            ; $508B

    ret                                           ; $508D


; C: inverse of 4B9E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
Dj_UnpackNoiseBits::
    ld b, $02                                     ; $508E

jr_002_5090:
    ld a, [hl+]                                   ; $5090
    ld c, $08                                     ; $5091

jr_002_5093:
    sla a                                         ; $5093
    push af                                       ; $5095
    ld a, [de]                                    ; $5096
    jr nc, jr_002_509b                            ; $5097

    set 4, a                                      ; $5099

jr_002_509b:
    ld [de], a                                    ; $509B
    inc de                                        ; $509C
    pop af                                        ; $509D
    dec c                                         ; $509E
    jr nz, jr_002_5093                            ; $509F

    dec b                                         ; $50A1
    jr nz, jr_002_5090                            ; $50A2

    ret                                           ; $50A4


; C: counters block B0BB.. -> DA96..
Counters_Load_Far::
    xor a                                         ; $50A5
    ld [rRAMB], a                                 ; $50A6
    ld hl, $b0bb                                  ; $50A9
    ld de, wCntTaken                              ; $50AC
    ld c, $16                                     ; $50AF

jr_002_50b1:
    ld a, [hl+]                                   ; $50B1
    ld [de], a                                    ; $50B2
    inc de                                        ; $50B3
    dec c                                         ; $50B4
    jr nz, jr_002_50b1                            ; $50B5

    jp Far_Call_Return                            ; $50B7


; C: owner block AFB8.. -> owner_id DA49..
Owner_Load_Far::
    ld a, $01                                     ; $50BA
    ld [rRAMB], a                                 ; $50BC
    ld hl, $afb8                                  ; $50BF
    ld de, wOwnerId                               ; $50C2
    ld c, $12                                     ; $50C5

jr_002_50c7:
    ld a, [hl+]                                   ; $50C7
    ld [de], a                                    ; $50C8
    inc de                                        ; $50C9
    dec c                                         ; $50CA
    jr nz, jr_002_50c7                            ; $50CB

    jp Far_Call_Return                            ; $50CD


; C: reads the Game Face flag B0D1 into gameface_present and loads the image to $C000
GameFace_Load_Far::
    xor a                                         ; $50D0
    ld [rRAMB], a                                 ; $50D1
    ld a, [$b0d1]                                 ; $50D4
    ld [wGamefacePresent], a                      ; $50D7
    and a                                         ; $50DA
    jp z, Far_Call_Return                         ; $50DB

    ld hl, $b1fc                                  ; $50DE
    ld de, wPhotoImage                            ; $50E1
    ld bc, $0e00                                  ; $50E4

jr_002_50e7:
    ld a, [hl+]                                   ; $50E7
    ld [de], a                                    ; $50E8
    inc de                                        ; $50E9
    dec bc                                        ; $50EA
    ld a, c                                       ; $50EB
    or b                                          ; $50EC
    jr nz, jr_002_50e7                            ; $50ED

    jp Far_Call_Return                            ; $50EF


; C: loads the Game Face image in four 7x128 byte chunks
GameFace_LoadTiles_Far::
    xor a                                         ; $50F2
    ld [rRAMB], a                                 ; $50F3
    ld a, [$b0d1]                                 ; $50F6
    ld [wGamefacePresent], a                      ; $50F9
    and a                                         ; $50FC
    jp z, Far_Call_Return                         ; $50FD

    ld de, wPhotoImage                            ; $5100
    ld hl, $b1fc                                  ; $5103
    call GameFace_CopyChunk                       ; $5106
    ld hl, $b27c                                  ; $5109
    call GameFace_CopyChunk                       ; $510C
    ld hl, $b8fc                                  ; $510F
    call GameFace_CopyChunk                       ; $5112
    ld hl, $b97c                                  ; $5115
    call GameFace_CopyChunk                       ; $5118
    jp Far_Call_Return                            ; $511B


; C: copies 7 rows of 128 bytes with a 128 byte skip. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed
; in the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
GameFace_CopyChunk::
    ld b, $07                                     ; $511E

jr_002_5120:
    ld c, $80                                     ; $5120

jr_002_5122:
    ld a, [hl+]                                   ; $5122
    ld [de], a                                    ; $5123
    inc de                                        ; $5124
    dec c                                         ; $5125
    jr nz, jr_002_5122                            ; $5126

    ld a, l                                       ; $5128
    add $80                                       ; $5129
    ld l, a                                       ; $512B
    jr nc, jr_002_512f                            ; $512C

    inc h                                         ; $512E

jr_002_512f:
    dec b                                         ; $512F
    jr nz, jr_002_5120                            ; $5130

    ret                                           ; $5132


; C: loads the eight thumbnails of a page (AE00 area of the slots). L3 pass 2026-10-26: executed in BGB in the
; scenarios link_exchange 0E:03 (tcrf_check/assets/l3_names/scen_hits*.csv)
Album_LoadThumbPage_Far::
    and $18                                       ; $5133
    ld c, a                                       ; $5135
    ld de, wPhotoImage                            ; $5136
    ld b, $08                                     ; $5139

jr_002_513b:
    push bc                                       ; $513B
    push de                                       ; $513C
    ld a, c                                       ; $513D
    ldh [hFarcallAArg], a                         ; $513E
    farcall Photo_FindSlot_Far                    ; $5140
    jr nc, jr_002_514b                            ; $5148

    xor a                                         ; $514A

jr_002_514b:
    srl a                                         ; $514B
    inc a                                         ; $514D
    ld [rRAMB], a                                 ; $514E
    ld de, $0000                                  ; $5151
    rl d                                          ; $5154
    swap d                                        ; $5156
    ld hl, $ae00                                  ; $5158
    add hl, de                                    ; $515B
    pop de                                        ; $515C
    ld b, $40                                     ; $515D

jr_002_515f:
    ld a, [hl+]                                   ; $515F
    ld [de], a                                    ; $5160
    inc de                                        ; $5161
    ld a, [hl+]                                   ; $5162
    ld [de], a                                    ; $5163
    inc de                                        ; $5164
    ld a, [hl+]                                   ; $5165
    ld [de], a                                    ; $5166
    inc de                                        ; $5167
    ld a, [hl+]                                   ; $5168
    ld [de], a                                    ; $5169
    inc de                                        ; $516A
    dec b                                         ; $516B
    jr nz, jr_002_515f                            ; $516C

    pop bc                                        ; $516E
    inc c                                         ; $516F
    dec b                                         ; $5170
    jr nz, jr_002_513b                            ; $5171

    jp Far_Call_Return                            ; $5173


; C: loads a photo image and copies its tiles to VRAM (safe copy when the LCD is on)
Photo_LoadToVram_Far::
    ldh [hFarcallAArg], a                         ; $5176
    farcall Photo_LoadImage_Far                   ; $5178
    ld hl, $ff40                                  ; $5180
    bit 7, [hl]                                   ; $5183
    jr nz, jr_002_51b4                            ; $5185

    ld a, $00                                     ; $5187
    ld hl, wPhotoImage                            ; $5189
    ld de, $9000                                  ; $518C
    ld bc, $0800                                  ; $518F
    call Mem_CopyFromBank                         ; $5192
    ld a, $00                                     ; $5195
    ld hl, wPhotoImage + $800                     ; $5197
    ld de, $8800                                  ; $519A
    ld bc, $0100                                  ; $519D
    call Mem_CopyFromBank                         ; $51A0
    ld a, $00                                     ; $51A3
    ld hl, wPhotoImage + $900                     ; $51A5
    ld de, $8000                                  ; $51A8
    ld bc, $0500                                  ; $51AB
    call Mem_CopyFromBank                         ; $51AE
    jp Far_Call_Return                            ; $51B1


jr_002_51b4:
    ld a, $00                                     ; $51B4
    ld hl, wPhotoImage                            ; $51B6
    ld de, $9000                                  ; $51B9
    ld bc, $0800                                  ; $51BC
    call Vram_CopyFromBank                        ; $51BF
    ld a, $00                                     ; $51C2
    ld hl, wPhotoImage + $800                     ; $51C4
    ld de, $8800                                  ; $51C7
    ld bc, $0100                                  ; $51CA
    call Vram_CopyFromBank                        ; $51CD
    ld a, $00                                     ; $51D0
    ld hl, wPhotoImage + $900                     ; $51D2
    ld de, $8000                                  ; $51D5
    ld bc, $0500                                  ; $51D8
    call Vram_CopyFromBank                        ; $51DB
    jp Far_Call_Return                            ; $51DE


; C: A = photo number; returns the SRAM bank / address of its image (bank $36 for built-in images); C: the routine is
; executed in this build's coverage run and at most a quarter of its Japanese instructions are unpaired
Photo_GetSramAddress_Far::
    cp $1e                                        ; $51E1
    jr nc, jr_002_520b                            ; $51E3

    ld hl, wPhotoCount                            ; $51E5
    cp [hl]                                       ; $51E8
    jr nc, jr_002_5203                            ; $51E9

    ldh [hFarcallAArg], a                         ; $51EB
    farcall Photo_FindSlot_Far                    ; $51ED
    srl a                                         ; $51F5
    inc a                                         ; $51F7
    ld bc, $0500                                  ; $51F8
    rl b                                          ; $51FB
    swap b                                        ; $51FD
    and a                                         ; $51FF
    jp Far_Call_Return                            ; $5200


jr_002_5203:
    ld bc, AlbumB_UnusedSlotB_Tiles               ; $5203
    ld a, BANK(AlbumB_UnusedSlotB_Tiles)          ; $5206
    jp Far_Call_Return                            ; $5208


jr_002_520b:
    sub $1e                                       ; $520B
    cp $10                                        ; $520D
    jr c, jr_002_521e                             ; $520F

    call AlbumB_CheckGate                         ; $5211
    jr nz, jr_002_521e                            ; $5214

    ld bc, AlbumB_UnusedSlotA_Tiles               ; $5216
    ld a, BANK(AlbumB_UnusedSlotA_Tiles)          ; $5219
    jp Far_Call_Return                            ; $521B


jr_002_521e:
    ld c, a                                       ; $521E
    sla a                                         ; $521F
    add c                                         ; $5221
    ld c, a                                       ; $5222
    ld b, $00                                     ; $5223
    ld hl, AlbumB_SlotTbl                         ; $5225
    add hl, bc                                    ; $5228
    ld c, [hl]                                    ; $5229
    inc hl                                        ; $522A
    ld b, [hl]                                    ; $522B
    inc hl                                        ; $522C
    ld a, [hl]                                    ; $522D
    and a                                         ; $522E
    jp Far_Call_Return                            ; $522F


; C: if the owner id is all zero fills it with random BCD digits and stores the owner block
Owner_GenerateId_Far::
    ldh [hFarcallAArg], a                         ; $5232
    farcall Owner_Load_Far                        ; $5234
    xor a                                         ; $523C
    ld hl, wOwnerId                               ; $523D
    ld b, $04                                     ; $5240

jr_002_5242:
    or [hl]                                       ; $5242
    inc hl                                        ; $5243
    dec b                                         ; $5244
    jr nz, jr_002_5242                            ; $5245

    and a                                         ; $5247
    jp nz, Far_Call_Return                        ; $5248

    ld hl, wOwnerId                               ; $524B
    ld bc, $0800                                  ; $524E

jr_002_5251:
    call Rng_Next                                 ; $5251
    and $0f                                       ; $5254
    add c                                         ; $5256

jr_002_5257:
    cp $0a                                        ; $5257
    jr c, jr_002_525f                             ; $5259

    sub $0a                                       ; $525B
    jr jr_002_5257                                ; $525D

jr_002_525f:
    ld c, a                                       ; $525F
    inc a                                         ; $5260
    swap [hl]                                     ; $5261
    or [hl]                                       ; $5263
    ld [hl], a                                    ; $5264
    bit 0, b                                      ; $5265
    jr z, jr_002_526a                             ; $5267

    inc hl                                        ; $5269

jr_002_526a:
    dec b                                         ; $526A
    jr nz, jr_002_5251                            ; $526B

    ldh [hFarcallAArg], a                         ; $526D
    farcall Owner_Store_Far                       ; $526F
    jp Far_Call_Return                            ; $5277


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
; Oam_AddMeta_B02_5272 (00:247D); C: an operand pointing here is paired by the port with a Japanese operand pointing
; to the Japanese block; Gold: the international block 02:52BD with 222 bytes changed ...
OamPtrTbl_B02_52D4::
    dw OamList_B02_52D4_00
    dw OamList_B02_52D4_01
    dw OamList_B02_52D4_02
    dw OamList_B02_52D4_03
    dw OamList_B02_52D4_04
    dw OamList_B02_52D4_05
    dw OamList_B02_52D4_06
    dw OamList_B02_52D4_07
    dw OamList_B02_52D4_08
    dw OamList_B02_52D4_09
    dw OamList_B02_52D4_0A
    dw OamList_B02_52D4_0B
    dw OamList_B02_52D4_0C
    dw OamList_B02_52D4_0D
    dw OamList_B02_52D4_0E
    dw OamList_B02_52D4_0F
    dw OamList_B02_52D4_10
    dw OamList_B02_52D4_11
    dw OamList_B02_52D4_12
    dw OamList_B02_52D4_13
    dw OamList_B02_52D4_14
    dw OamList_B02_52D4_15
    dw OamList_B02_52D4_16
    dw OamList_B02_52D4_17
    dw OamList_B02_52D4_18
    dw OamList_B02_52D4_19
    dw OamList_B02_52D4_1A
    dw OamList_B02_52D4_1B
    dw OamList_B02_52D4_1C
    dw OamList_B02_52D4_1D
    dw OamList_B02_52D4_1E
    dw OamList_B02_52D4_1F
    dw OamList_B02_52D4_20
    dw OamList_B02_52D4_21
    dw OamList_B02_52D4_22
    dw OamList_B02_52D4_23
    dw OamList_B02_52D4_24
    dw OamList_B02_52D4_25
    dw OamList_B02_52D4_26
    dw OamList_B02_52D4_27
    dw OamList_B02_52D4_28
    dw OamList_B02_52D4_29
    dw OamList_B02_52D4_2A
    dw OamList_B02_52D4_2B
    dw OamList_B02_52D4_2C
    dw OamList_B02_52D4_2D
    dw OamList_B02_52D4_2E
    dw OamList_B02_52D4_2F
    dw OamList_B02_52D4_30
    dw OamList_B02_52D4_31
    dw OamList_B02_52D4_32
    dw OamList_B02_52D4_33
    dw OamList_B02_52D4_34
    dw OamList_B02_52D4_35
    dw OamList_B02_52D4_36
    dw OamList_B02_52D4_37
    dw OamList_B02_52D4_38
    dw OamList_B02_52D4_39
    dw OamList_B02_52D4_3A
    dw OamList_B02_52D4_3B
    dw OamList_B02_52D4_3C
    dw OamList_B02_52D4_3D
    dw OamList_B02_52D4_3E
    dw OamList_B02_52D4_3F
    dw OamList_B02_52D4_40
    dw OamList_B02_52D4_41
    dw OamList_B02_52D4_42
    dw OamList_B02_52D4_43
    dw OamList_B02_52D4_44
    dw OamList_B02_52D4_45
    dw OamList_B02_52D4_46
    dw OamList_B02_52D4_47
    dw OamList_B02_52D4_48
    dw OamList_B02_52D4_49
    dw OamList_B02_52D4_4A
    dw OamList_B02_52D4_4B
    dw OamList_B02_52D4_4C
    dw OamList_B02_52D4_4D
    dw OamList_B02_52D4_4E
    dw OamList_B02_52D4_4F
    dw OamList_B02_52D4_50
    dw OamList_B02_52D4_51
    dw OamList_B02_52D4_52
    dw OamList_B02_52D4_53
    dw OamList_B02_52D4_54
    dw OamList_B02_52D4_55
    dw OamList_B02_52D4_56
    dw OamList_B02_52D4_57
    dw OamList_B02_52D4_58
    dw OamList_B02_52D4_59
    dw OamList_B02_52D4_5A
    dw OamList_B02_52D4_5B
    dw OamList_B02_52D4_5C
    dw OamList_B02_52D4_5D
    dw OamList_B02_52D4_5E
    dw OamList_B02_52D4_5F
    dw OamList_B02_52D4_60
    dw OamList_B02_52D4_61
    dw OamList_B02_52D4_62
    dw OamList_B02_52D4_63
    dw OamList_B02_52D4_64
    dw OamList_B02_52D4_65
    dw OamList_B02_52D4_66
    dw OamList_B02_52D4_67
    dw OamList_B02_52D4_68
    dw OamList_B02_52D4_69
    dw OamList_B02_52D4_6A
    dw OamList_B02_52D4_6B
    dw OamList_B02_52D4_6C
    dw OamList_B02_52D4_6D
    dw OamList_B02_52D4_6E
    dw OamList_B02_52D4_6F
    dw OamList_B02_52D4_70
    dw OamList_B02_52D4_71
    dw OamList_B02_52D4_72
    dw OamList_B02_52D4_73
    dw OamList_B02_52D4_74
    dw OamList_B02_52D4_75
    dw OamList_B02_52D4_76
    dw OamList_B02_52D4_77
    dw OamList_B02_52D4_78
    dw OamList_B02_52D4_79
    dw OamList_B02_52D4_7A
    dw OamList_B02_52D4_7B
    dw OamList_B02_52D4_7C
    dw OamList_B02_52D4_7D
    dw OamList_B02_52D4_7E
    dw OamList_B02_52D4_7F
    dw OamList_B02_52D4_80
    dw OamList_B02_52D4_81
    dw OamList_B02_52D4_82
    dw OamList_B02_52D4_83
    dw OamList_B02_52D4_84
    dw OamList_B02_52D4_85
    dw OamList_B02_52D4_86
    dw OamList_B02_52D4_87
    dw OamList_B02_52D4_88
    dw OamList_B02_52D4_89
    dw OamList_B02_52D4_8A
    dw OamList_B02_52D4_8B
    dw OamList_B02_52D4_8C
    dw OamList_B02_52D4_8D
    dw OamList_B02_52D4_8E
    dw OamList_B02_52D4_8F
    dw OamList_B02_52D4_90
    dw OamList_B02_52D4_91
    dw OamList_B02_52D4_92
    dw OamList_B02_52D4_93
    dw OamList_B02_52D4_94
    dw OamList_B02_52D4_95
    dw OamList_B02_52D4_96
    dw OamList_B02_52D4_97
    dw OamList_B02_52D4_98
    dw OamList_B02_52D4_99
    dw OamList_B02_52D4_9A
    dw OamList_B02_52D4_9B
    dw OamList_B02_52D4_9C
    dw OamList_B02_52D4_9D
    dw OamList_B02_52D4_9E
    dw OamList_B02_52D4_9F
    dw OamList_B02_52D4_A0
    dw OamList_B02_52D4_A1
    dw OamList_B02_52D4_A2
    dw OamList_B02_52D4_A3
    dw OamList_B02_52D4_A4
    dw OamList_B02_52D4_A5
    dw OamList_B02_52D4_A6
    dw OamList_B02_52D4_A7
    dw OamList_B02_52D4_A8
    dw OamList_B02_52D4_A9
    dw OamList_B02_52D4_AA
    dw OamList_B02_52D4_AB
    dw OamList_B02_52D4_AC
    dw OamList_B02_52D4_AD
    dw OamList_B02_52D4_AE
    dw OamList_B02_52D4_AF
    dw OamList_B02_52D4_B0
    dw OamList_B02_52D4_B1
    dw OamList_B02_52D4_B2
    dw OamList_B02_52D4_B3
    dw OamList_B02_52D4_B4
    dw OamList_B02_52D4_B5
    dw OamList_B02_52D4_B6
    dw OamList_B02_52D4_B7
    dw OamList_B02_52D4_B8
    dw OamList_B02_52D4_B9
    dw OamList_B02_52D4_BA
    dw OamList_B02_52D4_BB
    dw OamList_B02_52D4_BC
    dw OamList_B02_52D4_BD
    dw OamList_B02_52D4_BE
    dw OamList_B02_52D4_BF
    dw OamList_B02_52D4_C0
    dw OamList_B02_52D4_C1
    dw OamList_B02_52D4_C2
    dw OamList_B02_52D4_C3
    dw OamList_B02_52D4_C4
    dw OamList_B02_52D4_C5
    dw OamList_B02_52D4_C6
    dw OamList_B02_52D4_C7
    dw OamList_B02_52D4_C8
    dw OamList_B02_52D4_C9
    dw OamList_B02_52D4_CA

; C: OAM list 00 of the table 5272
OamList_B02_52D4_00::
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
OamList_B02_52D4_01::
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

; C: OAM list 02 of the table 5272; C: entry $02 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_02::
    db $03
    db $ff
    db $5a
    db $00
    db $03
    db $f7
    db $58
    db $00
    db $80

; C: OAM list 03 of the table 5272; C: entry $03 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_03::
    db $02
    db $ff
    db $5a
    db $00
    db $02
    db $f7
    db $58
    db $00
    db $80

; C: OAM list 04 of the table 5272; C: entry $04 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_04::
    db $02
    db $fe
    db $5a
    db $00
    db $02
    db $f6
    db $58
    db $00
    db $80

; C: OAM list 05 of the table 5272; C: entry $05 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_05::
    db $03
    db $fe
    db $5a
    db $00
    db $03
    db $f6
    db $58
    db $00
    db $80

; C: OAM list 06 of the table 5272; C: entry $06 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_06::
    db $03
    db $08
    db $5a
    db $20
    db $03
    db $10
    db $58
    db $20
    db $80

; C: OAM list 07 of the table 5272; C: entry $07 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_07::
    db $02
    db $08
    db $5a
    db $20
    db $02
    db $10
    db $58
    db $20
    db $80

; C: OAM list 08 of the table 5272; C: entry $08 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_08::
    db $02
    db $09
    db $5a
    db $20
    db $02
    db $11
    db $58
    db $20
    db $80

; C: OAM list 09 of the table 5272; C: entry $09 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_09::
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
OamList_B02_52D4_0A::
    db $08
    db $00
    db $5c
    db $10
    db $80

; C: OAM list 0B of the table 5272
OamList_B02_52D4_0B::
    db $07
    db $00
    db $5c
    db $10
    db $80

; C: OAM list 0C of the table 5272
OamList_B02_52D4_0C::
    db $07
    db $ff
    db $5c
    db $10
    db $80

; C: OAM list 0D of the table 5272
OamList_B02_52D4_0D::
    db $08
    db $ff
    db $5c
    db $10
    db $80

; C: OAM list 0E of the table 5272
OamList_B02_52D4_0E::
    db $08
    db $08
    db $5c
    db $30
    db $80

; C: OAM list 0F of the table 5272
OamList_B02_52D4_0F::
    db $07
    db $08
    db $5c
    db $30
    db $80

; C: OAM list 10 of the table 5272
OamList_B02_52D4_10::
    db $07
    db $09
    db $5c
    db $30
    db $80

; C: OAM list 11 of the table 5272
OamList_B02_52D4_11::
    db $08
    db $09
    db $5c
    db $30
    db $80

; C: OAM list 12 of the table 5272
OamList_B02_52D4_12::
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
OamList_B02_52D4_13::
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
OamList_B02_52D4_14::
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
OamList_B02_52D4_15::
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
OamList_B02_52D4_16::
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
OamList_B02_52D4_17::
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
OamList_B02_52D4_18::
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
OamList_B02_52D4_19::
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
OamList_B02_52D4_1A::
    db $10
    db $04
    db $7e
    db $50
    db $80

; C: OAM list 1B of the table 5272
OamList_B02_52D4_1B::
    db $12
    db $04
    db $7e
    db $50
    db $80

; C: OAM list 1C of the table 5272
OamList_B02_52D4_1C::
    db $08
    db $04
    db $7e
    db $10
    db $80

; C: OAM list 1D of the table 5272
OamList_B02_52D4_1D::
    db $06
    db $04
    db $7e
    db $10
    db $80

; C: OAM list 1E of the table 5272
OamList_B02_52D4_1E::
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
OamList_B02_52D4_1F::
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
OamList_B02_52D4_20::
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
OamList_B02_52D4_21::
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

; C: OAM list 22 of the table 5272; C: entry $22 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_22::
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

; C: OAM list 23 of the table 5272; C: entry $23 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_23::
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

; C: OAM list 24 of the table 5272; C: entry $24 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_24::
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

; C: OAM list 25 of the table 5272; C: entry $25 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_25::
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

; C: OAM list 26 of the table 5272; C: entry $26 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_26::
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

; C: OAM list 27 of the table 5272; C: entry $27 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_27::
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
OamList_B02_52D4_28::
    db $0a
    db $fe
    db $5c
    db $50
    db $80

; C: OAM list 29 of the table 5272
OamList_B02_52D4_29::
    db $0a
    db $ff
    db $5c
    db $50
    db $80

; C: OAM list 2A of the table 5272
OamList_B02_52D4_2A::
    db $09
    db $ff
    db $5c
    db $50
    db $80

; C: OAM list 2B of the table 5272
OamList_B02_52D4_2B::
    db $09
    db $fe
    db $5c
    db $50
    db $80

; C: OAM list 2C of the table 5272
OamList_B02_52D4_2C::
    db $0a
    db $0a
    db $5c
    db $70
    db $80

; C: OAM list 2D of the table 5272
OamList_B02_52D4_2D::
    db $0a
    db $09
    db $5c
    db $70
    db $80

; C: OAM list 2E of the table 5272
OamList_B02_52D4_2E::
    db $09
    db $09
    db $5c
    db $70
    db $80

; C: OAM list 2F of the table 5272
OamList_B02_52D4_2F::
    db $09
    db $0a
    db $5c
    db $70
    db $80

; C: OAM list 30 of the table 5272; C: entry $30 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_30::
    db $08
    db $08
    db $00
    db $00
    db $80

; C: OAM list 31 of the table 5272; C: entry $31 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_31::
    db $08
    db $08
    db $01
    db $00
    db $80

; C: OAM list 32 of the table 5272; C: entry $32 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_32::
    db $08
    db $08
    db $02
    db $00
    db $80

; C: OAM list 33 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_33::
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

; C: OAM list 34 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_34::
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

; C: OAM list 35 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_35::
    db $08
    db $15
    db $10
    db $00
    db $80

; C: OAM list 36 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_36::
    db $08
    db $15
    db $11
    db $00
    db $80

; C: OAM list 37 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_37::
    db $08
    db $15
    db $12
    db $00
    db $80

; C: OAM list 38 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_38::
    db $08
    db $15
    db $13
    db $00
    db $80

; C: OAM list 39 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_39::
    db $08
    db $15
    db $14
    db $00
    db $80

; C: OAM list 3A of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_3A::
    db $08
    db $15
    db $15
    db $00
    db $80

; C: OAM list 3B of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_3B::
    db $08
    db $15
    db $16
    db $00
    db $80

; C: OAM list 3C of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_3C::
    db $08
    db $15
    db $09
    db $00
    db $80

; C: OAM list 3D of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_3D::
    db $08
    db $15
    db $0a
    db $00
    db $80

; C: OAM list 3E of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_3E::
    db $08
    db $10
    db $f9
    db $00
    db $80

; C: OAM list 3F of the table 5272; C: entry $3F of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_3F::
    db $08
    db $10
    db $f9
    db $00
    db $80

; C: OAM list 40 of the table 5272; C: entry $40 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_40::
    db $08
    db $10
    db $f9
    db $00
    db $80

; C: OAM list 41 of the table 5272; C: entry $41 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_41::
    db $08
    db $10
    db $f9
    db $00
    db $80

; C: OAM list 42 of the table 5272; C: entry $42 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_42::
    db $08
    db $06
    db $f9
    db $00
    db $80

; C: OAM list 43 of the table 5272; C: entry $43 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_43::
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

; C: OAM list 44 of the table 5272; C: entry $44 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_44::
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

; C: OAM list 45 of the table 5272; C: entry $45 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_45::
    db $08
    db $0b
    db $0f
    db $20
    db $08
    db $21
    db $0f
    db $00
    db $80

; C: OAM list 46 of the table 5272; C: entry $46 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_46::
    db $08
    db $0a
    db $0f
    db $20
    db $08
    db $22
    db $0f
    db $00
    db $80

; C: OAM list 47 of the table 5272; C: entry $47 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_47::
    db $08
    db $f8
    db $0f
    db $20
    db $08
    db $17
    db $0f
    db $00
    db $80

; C: OAM list 48 of the table 5272; C: entry $48 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_48::
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
OamList_B02_52D4_49::
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
OamList_B02_52D4_4A::
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
OamList_B02_52D4_4B::
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
OamList_B02_52D4_4C::
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
OamList_B02_52D4_4D::
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

; C: OAM list 4E of the table 5272; C: entry $4E of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_4E::
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
OamList_B02_52D4_4F::
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
OamList_B02_52D4_50::
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
OamList_B02_52D4_51::
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
OamList_B02_52D4_52::
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
OamList_B02_52D4_53::
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
OamList_B02_52D4_54::
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
OamList_B02_52D4_55::
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
OamList_B02_52D4_56::
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
OamList_B02_52D4_57::
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
OamList_B02_52D4_58::
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
OamList_B02_52D4_59::
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
OamList_B02_52D4_5A::
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
OamList_B02_52D4_5B::
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
OamList_B02_52D4_5C::
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
OamList_B02_52D4_5D::
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
OamList_B02_52D4_5E::
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
OamList_B02_52D4_5F::
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
OamList_B02_52D4_60::
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
OamList_B02_52D4_61::
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
OamList_B02_52D4_62::
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
OamList_B02_52D4_63::
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
OamList_B02_52D4_64::
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
OamList_B02_52D4_65::
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
OamList_B02_52D4_66::
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
OamList_B02_52D4_67::
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
OamList_B02_52D4_68::
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
OamList_B02_52D4_69::
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
OamList_B02_52D4_6A::
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
OamList_B02_52D4_6B::
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
OamList_B02_52D4_6C::
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
OamList_B02_52D4_6D::
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
OamList_B02_52D4_6E::
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
OamList_B02_52D4_6F::
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
OamList_B02_52D4_70::
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
OamList_B02_52D4_71::
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
OamList_B02_52D4_72::
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
OamList_B02_52D4_73::
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
OamList_B02_52D4_74::
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
OamList_B02_52D4_75::
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
OamList_B02_52D4_76::
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
OamList_B02_52D4_77::
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
OamList_B02_52D4_78::
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
OamList_B02_52D4_79::
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
OamList_B02_52D4_7A::
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
OamList_B02_52D4_7B::
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
OamList_B02_52D4_7C::
    db $18
    db $08
    db $02
    db $00
    db $80

; C: OAM list 7D of the table 5272
OamList_B02_52D4_7D::
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
OamList_B02_52D4_7E::
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
OamList_B02_52D4_7F::
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
OamList_B02_52D4_80::
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
OamList_B02_52D4_81::
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
OamList_B02_52D4_82::
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
OamList_B02_52D4_83::
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
OamList_B02_52D4_84::
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
OamList_B02_52D4_85::
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
OamList_B02_52D4_86::
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
OamList_B02_52D4_87::
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
OamList_B02_52D4_88::
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
OamList_B02_52D4_89::
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
OamList_B02_52D4_8A::
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
OamList_B02_52D4_8B::
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
OamList_B02_52D4_8C::
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
OamList_B02_52D4_8D::
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
OamList_B02_52D4_8E::
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
OamList_B02_52D4_8F::
    db $08
    db $08
    db $00
    db $00
    db $80

; C: OAM list 90 of the table 5272
OamList_B02_52D4_90::
    db $08
    db $08
    db $01
    db $00
    db $80

; C: OAM list 91 of the table 5272
OamList_B02_52D4_91::
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
OamList_B02_52D4_92::
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
OamList_B02_52D4_93::
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
OamList_B02_52D4_94::
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
OamList_B02_52D4_95::
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
OamList_B02_52D4_96::
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

; C: OAM list 97 of the table 5272; C: entry $97 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_97::
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

; C: OAM list 98 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_98::
    db $18
    db $15

; C: sprite layouts read by Oam_AddMeta_Common; the international OamList_B02_6125 moved by +23
OamList_B02_613C::
    db $41, $00, $18, $0d
    db $40, $00, $18, $05
    db $3f, $00, $10, $0d
    db $3e, $00, $10, $05
    db $3d, $00, $10, $fd
    db $3c, $00, $10, $f5
    db $3b, $00, $08, $0d
    db $3a, $00, $08, $05
    db $39, $00, $08, $fd
    db $38, $00, $00, $0c
    db $29, $00, $00, $04
    db $28, $00, $00, $fc
    db $27, $00, $00, $f4
    db $26, $00, $80

; C: OAM list 99 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_99::
    db $18, $15, $41, $00
    db $18, $0d, $40, $00
    db $18, $05, $3f, $00
    db $10, $0d, $3e, $00
    db $10, $05, $3d, $00
    db $10, $fd, $3c, $00
    db $10, $f5, $3b, $00
    db $08, $0d, $3a, $00
    db $08, $05, $39, $00
    db $08, $fd, $38, $00
    db $00, $0e, $29, $00
    db $00, $06, $28, $00
    db $00, $fe, $27, $00
    db $00, $f6, $26, $00
    db $80

; C: OAM list 9A of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_9A::
    db $18, $15, $41, $00
    db $18, $0d, $40, $00
    db $18, $05, $3f, $00
    db $10, $0d, $3e, $00
    db $10, $05, $3d, $00
    db $10, $fd, $3c, $00
    db $10, $f5, $3b, $00
    db $00, $0d, $37, $00
    db $00, $05, $36, $00
    db $00, $fd, $35, $00
    db $00, $f5, $34, $00
    db $08, $0d, $2c, $00
    db $08, $05, $2b, $00
    db $08, $fd, $2a, $00
    db $80

; C: OAM list 9B of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_9B::
    db $18, $15, $41, $00
    db $18, $0d, $40, $00
    db $18, $05, $3f, $00
    db $10, $0d, $3e, $00
    db $10, $05, $3d, $00
    db $10, $fd, $3c, $00
    db $10, $f5, $3b, $00
    db $00, $0d, $37, $00
    db $00, $05, $36, $00
    db $00, $fd, $35, $00
    db $00, $f5, $34, $00
    db $08, $0c, $2c

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

; C: OAM list 9C of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_9C::
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

; C: OAM list 9D of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_9D::
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

; C: OAM list 9E of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_9E::
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

; C: OAM list 9F of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_9F::
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
OamList_B02_52D4_A0::
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
OamList_B02_52D4_A1::
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
OamList_B02_52D4_A2::
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

; C: OAM list A3 of the table 5272; C: entry $A3 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_A3::
    db $16
    db $08
    db $44
    db $40

    db $80

; C: OAM list A4 of the table 5272
OamList_B02_52D4_A4::
    db $0c, $08, $45, $00
    db $80

; C: OAM list A5 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_A5::
    db $ef, $ea, $00, $00
    db $80

; C: OAM list A6 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_A6::
    db $f0, $e8, $00, $00
    db $80

; C: OAM list A7 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_A7::
    db $f0, $e4, $00, $00
    db $80

; C: OAM list A8 of the table 5272; C: entry of the same word table as the Japanese name (structure)
OamList_B02_52D4_A8::
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

; C: OAM list A9 of the table 5272; C: entry $A9 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_A9::
    db $10, $18, $3e, $10
    db $10, $10, $3c, $10
    db $10, $08, $3a, $10
    db $10, $00, $38, $10
    db $10, $f8, $36, $10
    db $10, $f0, $34, $10
    db $10, $e8, $32, $10
    db $80

; C: OAM list AA of the table 5272
OamList_B02_52D4_AA::
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
OamList_B02_52D4_AB::
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
OamList_B02_52D4_AC::
    db $08, $00, $8b, $10
    db $00, $00, $8a, $10
    db $08, $0b, $93, $30
    db $00, $0b, $92, $30
    db $08, $f5, $93, $10
    db $00, $f5, $92, $10
    db $80

; C: OAM list AD of the table 5272
OamList_B02_52D4_AD::
    db $0b, $0b, $95, $20
    db $03, $0b, $94, $20
    db $0b, $f5, $95, $00
    db $03, $f5, $94, $00
    db $08, $00, $8b, $10
    db $00, $00, $8a, $10
    db $80

; C: OAM list AE of the table 5272
OamList_B02_52D4_AE::
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
OamList_B02_52D4_AF::
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
OamList_B02_52D4_B0::
    db $18, $08, $af, $10
    db $18, $00, $ae, $10
    db $10, $08, $9f, $10
    db $10, $00, $9e, $10
    db $80

; C: OAM list B1 of the table 5272
OamList_B02_52D4_B1::
    db $10, $10, $a3, $10
    db $10, $08, $a2, $10
    db $08, $10, $a1, $10
    db $08, $08, $a0, $10
    db $80

; C: OAM list B2 of the table 5272
OamList_B02_52D4_B2::
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
OamList_B02_52D4_B3::
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
OamList_B02_52D4_B4::
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
OamList_B02_52D4_B5::
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
OamList_B02_52D4_B6::
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
OamList_B02_52D4_B7::
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
OamList_B02_52D4_B8::
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
OamList_B02_52D4_B9::
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
OamList_B02_52D4_BA::
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
OamList_B02_52D4_BB::
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
OamList_B02_52D4_BC::
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
OamList_B02_52D4_BD::
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
OamList_B02_52D4_BE::
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
OamList_B02_52D4_BF::
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
OamList_B02_52D4_C0::
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
OamList_B02_52D4_C1::
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
OamList_B02_52D4_C2::
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
OamList_B02_52D4_C3::
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
OamList_B02_52D4_C4::
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

; C: OAM list C5 of the table 5272; C: entry $C5 of OamPtrTbl_B02_52D4 points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_52D4_C5::
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
OamList_B02_52D4_C6::
    db $10, $08, $71, $10
    db $10, $00, $70, $10
    db $08, $08, $6f, $10
    db $08, $00, $6e, $10
    db $80

; C: OAM list C7 of the table 5272
OamList_B02_52D4_C7::
    db $08, $08, $6b, $10
    db $08, $00, $6a, $10
    db $10, $08, $6d, $10
    db $10, $00, $6c, $10
    db $80

; C: OAM list C8 of the table 5272
OamList_B02_52D4_C8::
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
OamList_B02_52D4_C9::
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
OamList_B02_52D4_CA::
    db $f0, $e0, $f4, $10
    db $e8, $e8, $f3, $10
    db $e8, $e0, $f2, $10
    db $e0, $e8, $f1, $10
    db $e0, $e0, $f0, $10
    db $80

; C: 122 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B02_6E4B (00:2464); C: an operand pointing here is paired by the port with a Japanese operand pointing
; to the Japanese block; Gold: the international block 02:6F16 with 127 bytes changed ...
OamPtrTbl_B02_6F2D::
    dw OamList_B02_6F2D_00
    dw OamList_B02_6F2D_01
    dw OamList_B02_6F2D_02
    dw OamList_B02_6F2D_03
    dw OamList_B02_6F2D_04
    dw OamList_B02_6F2D_05
    dw OamList_B02_6F2D_06
    dw OamList_B02_6F2D_07
    dw OamList_B02_6F2D_08
    dw OamList_B02_6F2D_09
    dw OamList_B02_6F2D_0A
    dw OamList_B02_6F2D_0B
    dw OamList_B02_6F2D_0C
    dw OamList_B02_6F2D_0D
    dw OamList_B02_6F2D_0E
    dw OamList_B02_6F2D_0F
    dw OamList_B02_6F2D_10
    dw OamList_B02_6F2D_11
    dw OamList_B02_6F2D_12
    dw OamList_B02_6F2D_13
    dw OamList_B02_6F2D_14
    dw OamList_B02_6F2D_15
    dw OamList_B02_6F2D_16
    dw OamList_B02_6F2D_17
    dw OamList_B02_6F2D_18
    dw OamList_B02_6F2D_19
    dw OamList_B02_6F2D_1A
    dw OamList_B02_6F2D_1B
    dw OamList_B02_6F2D_1C
    dw OamList_B02_6F2D_1D
    dw OamList_B02_6F2D_1E
    dw OamList_B02_6F2D_1F
    dw OamList_B02_6F2D_20
    dw OamList_B02_6F2D_21
    dw OamList_B02_6F2D_22
    dw OamList_B02_6F2D_23
    dw OamList_B02_6F2D_24
    dw OamList_B02_6F2D_25
    dw OamList_B02_6F2D_26
    dw OamList_B02_6F2D_27
    dw OamList_B02_6F2D_28
    dw OamList_B02_6F2D_29
    dw OamList_B02_6F2D_2A
    dw OamList_B02_6F2D_2B
    dw OamList_B02_6F2D_2C
    dw OamList_B02_6F2D_2D
    dw OamList_B02_6F2D_2E
    dw OamList_B02_6F2D_2F
    dw OamList_B02_6F2D_30
    dw OamList_B02_6F2D_31
    dw OamList_B02_6F2D_32
    dw OamList_B02_6F2D_33
    dw OamList_B02_6F2D_34
    dw OamList_B02_6F2D_35
    dw OamList_B02_6F2D_36
    dw OamList_B02_6F2D_37
    dw OamList_B02_6F2D_38
    dw OamList_B02_6F2D_39
    dw OamList_B02_6F2D_3A
    dw OamList_B02_6F2D_3B
    dw OamList_B02_6F2D_3C
    dw OamList_B02_6F2D_3D
    dw OamList_B02_6F2D_3E
    dw OamList_B02_6F2D_3F
    dw OamList_B02_6F2D_40
    dw OamList_B02_6F2D_41
    dw OamList_B02_6F2D_42
    dw OamList_B02_6F2D_43
    dw OamList_B02_6F2D_44
    dw OamList_B02_6F2D_45
    dw OamList_B02_6F2D_46
    dw OamList_B02_6F2D_47
    dw OamList_B02_6F2D_48
    dw OamList_B02_6F2D_49
    dw OamList_B02_6F2D_4A
    dw OamList_B02_6F2D_4B
    dw OamList_B02_6F2D_4C
    dw OamList_B02_6F2D_4D
    dw OamList_B02_6F2D_4E
    dw OamList_B02_6F2D_4F
    dw OamList_B02_6F2D_50
    dw OamList_B02_6F2D_51
    dw OamList_B02_6F2D_52
    dw OamList_B02_6F2D_53
    dw OamList_B02_6F2D_54
    dw OamList_B02_6F2D_55
    dw OamList_B02_6F2D_56
    dw OamList_B02_6F2D_57
    dw OamList_B02_6F2D_58
    dw OamList_B02_6F2D_59
    dw OamList_B02_6F2D_5A
    dw OamList_B02_6F2D_5B
    dw OamList_B02_6F2D_5C
    dw OamList_B02_6F2D_5D
    dw OamList_B02_6F2D_5E
    dw OamList_B02_6F2D_5F
    dw OamList_B02_6F2D_60
    dw OamList_B02_6F2D_61
    dw OamList_B02_6F2D_62
    dw OamList_B02_6F2D_63
    dw OamList_B02_6F2D_64
    dw OamList_B02_6F2D_65
    dw OamList_B02_6F2D_66
    dw OamList_B02_6F2D_67
    dw OamList_B02_6F2D_68
    dw OamList_B02_6F2D_69
    dw OamList_B02_6F2D_6A
    dw OamList_B02_6F2D_6B
    dw OamList_B02_6F2D_6C
    dw OamList_B02_6F2D_6D
    dw OamList_B02_6F2D_6E
    dw OamList_B02_6F2D_6F
    dw OamList_B02_6F2D_70
    dw OamList_B02_6F2D_71
    dw OamList_B02_6F2D_72
    dw OamList_B02_6F2D_73
    dw OamList_B02_6F2D_74
    dw OamList_B02_6F2D_75
    dw OamList_B02_6F2D_76
    dw OamList_B02_6F2D_77

; C: OAM list 00 of the table 6E4B
OamList_B02_6F2D_00::
    db $10
    db $08
    db $de
    db $10
    db $10
    db $00
    db $dd
    db $10
    db $80

; C: OAM list 01 of the table 6E4B
OamList_B02_6F2D_01::
    db $08
    db $08
    db $de
    db $50
    db $08
    db $00
    db $dd
    db $50
    db $80

; C: OAM list 02 of the table 6E4B
OamList_B02_6F2D_02::
    db $18
    db $40
    db $cf
    db $10
    db $10
    db $40
    db $bf
    db $10
    db $18
    db $08
    db $cf
    db $10
    db $10
    db $08
    db $bf
    db $10
    db $80

; C: OAM list 03 of the table 6E4B
OamList_B02_6F2D_03::
    db $18
    db $40
    db $dc
    db $10
    db $10
    db $40
    db $db
    db $10
    db $18
    db $08
    db $dc
    db $10
    db $10
    db $08
    db $db
    db $10
    db $80

; C: OAM list 04 of the table 6E4B
OamList_B02_6F2D_04::
    db $10
    db $2b
    db $d0
    db $10
    db $10
    db $08
    db $d0
    db $10
    db $80

; C: OAM list 05 of the table 6E4B
OamList_B02_6F2D_05::
    db $10
    db $2b
    db $d1
    db $10
    db $10
    db $08
    db $d1
    db $10
    db $80

; C: OAM list 06 of the table 6E4B
OamList_B02_6F2D_06::
    db $0f
    db $2b
    db $d0
    db $50
    db $0f
    db $08
    db $d0
    db $50
    db $80

; C: OAM list 07 of the table 6E4B
OamList_B02_6F2D_07::
    db $10
    db $2b
    db $d2
    db $10
    db $10
    db $08
    db $d2
    db $10
    db $80

; C: OAM list 08 of the table 6E4B
OamList_B02_6F2D_08::
    db $18
    db $10
    db $da
    db $10
    db $18
    db $08
    db $d9
    db $10
    db $10
    db $10
    db $d8
    db $10
    db $10
    db $08
    db $d7
    db $10
    db $80

; C: OAM list 09 of the table 6E4B
OamList_B02_6F2D_09::
    db $18
    db $10
    db $d6
    db $10
    db $18
    db $08
    db $d5
    db $10
    db $10
    db $10
    db $d4
    db $10
    db $10
    db $08
    db $d3
    db $10
    db $80

; C: OAM list 0A of the table 6E4B
OamList_B02_6F2D_0A::
    db $10
    db $10
    db $da
    db $50
    db $10
    db $08
    db $d9
    db $50
    db $18
    db $10
    db $d8
    db $50
    db $18
    db $08
    db $d7
    db $50
    db $80

; C: OAM list 0B of the table 6E4B
OamList_B02_6F2D_0B::
    db $10
    db $10
    db $d6
    db $50
    db $10
    db $08
    db $d5
    db $50
    db $18
    db $10
    db $d4
    db $50
    db $18
    db $08
    db $d3
    db $50
    db $80

; C: OAM list 0C of the table 6E4B; C: entry $0C of OamPtrTbl_B02_6F2D points here, as in the Japanese build (bytes
; changed, role kept)
OamList_B02_6F2D_0C::
    db $10
    db $08

    db $24
    db $10
    db $08
    db $08
    db $20
    db $10
    db $80

; C: OAM list 0D of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_0D::
    db $08
    db $08
    db $21
    db $10
    db $80

; C: OAM list 0E of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_0E::
    db $08
    db $08
    db $22
    db $10
    db $80

; C: OAM list 0F of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_0F::
    db $08
    db $08
    db $23
    db $10
    db $80

; C: OAM list 10 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_10::
    db $03
    db $18
    db $dc
    db $00
    db $fa
    db $fd
    db $d0
    db $00
    db $0b
    db $fd
    db $d6
    db $00
    db $fb
    db $10
    db $da
    db $00
    db $03
    db $05
    db $d4
    db $00
    db $fb
    db $0d
    db $d8
    db $00
    db $f3
    db $05
    db $d2
    db $00
    db $80

; C: OAM list 11 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_11::
    db $fd
    db $13
    db $e2
    db $00
    db $09
    db $0b
    db $e6
    db $00
    db $09
    db $03
    db $e4
    db $00
    db $f9
    db $0b
    db $e0
    db $00
    db $f9
    db $03
    db $de
    db $00
    db $80

; C: OAM list 12 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_12::
    db $f3
    db $ff
    db $e8
    db $00
    db $03
    db $0f
    db $ee
    db $00
    db $fb
    db $07
    db $ec
    db $00
    db $eb
    db $07
    db $ea
    db $00
    db $80

; C: OAM list 13 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_13::
    db $f9
    db $11
    db $fa
    db $00
    db $f9
    db $19
    db $fc
    db $00
    db $00
    db $01
    db $f4
    db $00
    db $f0
    db $11
    db $f8
    db $00
    db $f8
    db $09
    db $f6
    db $00
    db $f0
    db $01
    db $f2
    db $00
    db $f0
    db $f9
    db $f0
    db $00
    db $80

; C: OAM list 14 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_14::
    db $fc
    db $08
    db $04
    db $20
    db $fc
    db $10
    db $02
    db $20
    db $ec
    db $08
    db $00
    db $20
    db $ec
    db $10
    db $fe
    db $20
    db $fc
    db $00
    db $04
    db $00
    db $fc
    db $f8
    db $02
    db $00
    db $ec
    db $00
    db $00
    db $00
    db $ec
    db $f8
    db $fe
    db $00
    db $80

; C: OAM list 15 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_15::
    db $fe
    db $08
    db $0c
    db $20
    db $fe
    db $10
    db $0a
    db $20
    db $ee
    db $08
    db $08
    db $20
    db $ee
    db $10
    db $06
    db $20
    db $fe
    db $00
    db $0c
    db $00
    db $fe
    db $f8
    db $0a
    db $00
    db $ee
    db $00
    db $08
    db $00
    db $ee
    db $f8
    db $06
    db $00
    db $80

; C: OAM list 16 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_16::
    db $02
    db $08
    db $10
    db $20
    db $f2
    db $08
    db $0e
    db $20
    db $02
    db $00
    db $10
    db $00
    db $f2
    db $00
    db $0e
    db $00
    db $80

; C: OAM list 17 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_17::
    db $fd
    db $0c
    db $18
    db $20
    db $ed
    db $0c
    db $14
    db $20
    db $ed
    db $14
    db $12
    db $20
    db $fd
    db $fc
    db $18
    db $00
    db $f5
    db $04
    db $16
    db $00
    db $ed
    db $fc
    db $14
    db $00
    db $ed
    db $f4
    db $12
    db $00
    db $80

; C: OAM list 18 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_18::
    db $00
    db $00
    db $ae
    db $10
    db $00
    db $f8
    db $ac
    db $10
    db $80

; C: OAM list 19 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_19::
    db $f8
    db $00
    db $b0
    db $10
    db $00
    db $00
    db $ae
    db $10
    db $00
    db $f8
    db $ac
    db $10
    db $80

; C: OAM list 1A of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_1A::
    db $00
    db $fb
    db $ae
    db $10
    db $00
    db $f3
    db $ac
    db $10
    db $80

; C: OAM list 1B of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_1B::
    db $00
    db $f3
    db $28
    db $10
    db $0b
    db $eb
    db $26
    db $10
    db $0b
    db $e3
    db $24
    db $10
    db $80

; C: OAM list 1C of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_1C::
    db $00
    db $0c
    db $2e
    db $10
    db $00
    db $04
    db $2c
    db $10
    db $f8
    db $fc
    db $2a
    db $10
    db $80

; C: OAM list 1D of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_1D::
    db $fa
    db $0a
    db $34
    db $10
    db $fa
    db $02
    db $32
    db $10
    db $fa
    db $fa
    db $30
    db $10
    db $80

; C: OAM list 1E of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_1E::
    db $01
    db $0a
    db $3a
    db $10
    db $f9
    db $02
    db $38
    db $10
    db $f9
    db $fa
    db $36
    db $10
    db $80

; C: OAM list 1F of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_1F::
    db $f7
    db $fa
    db $50
    db $10
    db $ff
    db $02
    db $52
    db $10
    db $ff
    db $0a
    db $54
    db $10
    db $80

; C: OAM list 20 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_20::
    db $fc
    db $40
    db $5c
    db $10
    db $fc
    db $30
    db $5a
    db $10
    db $fc
    db $38
    db $44
    db $10
    db $fc
    db $28
    db $40
    db $10
    db $00
    db $20
    db $66
    db $10
    db $00
    db $18
    db $64
    db $10
    db $00
    db $10
    db $62
    db $10
    db $00
    db $08
    db $60
    db $10
    db $80

; C: OAM list 21 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_21::
    db $fc
    db $40
    db $44
    db $10
    db $fc
    db $38
    db $5a
    db $10
    db $fc
    db $28
    db $56
    db $10
    db $fc
    db $30
    db $58
    db $10
    db $00
    db $20
    db $76
    db $10
    db $00
    db $18
    db $74
    db $10
    db $00
    db $10
    db $72
    db $10
    db $00
    db $08
    db $70
    db $10
    db $80

; C: OAM list 22 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_22::
    db $fc
    db $3d
    db $44
    db $10
    db $fc
    db $38
    db $7c
    db $10
    db $fc
    db $30
    db $7a
    db $10
    db $fc
    db $28
    db $78
    db $10
    db $00
    db $20
    db $6e
    db $10
    db $00
    db $18
    db $6c
    db $10
    db $00
    db $10
    db $6a
    db $10
    db $00
    db $08
    db $68
    db $10
    db $80

; C: OAM list 23 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_23::
    db $00
    db $14
    db $5e
    db $00
    db $00
    db $0c
    db $5e
    db $00
    db $00
    db $04
    db $5e
    db $00
    db $00
    db $fc
    db $5e
    db $00
    db $00
    db $f4
    db $5e
    db $00
    db $80

; C: OAM list 24 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_24::
    db $00
    db $14
    db $46
    db $00
    db $00
    db $0c
    db $46
    db $00
    db $00
    db $04
    db $46
    db $00
    db $00
    db $fc
    db $46
    db $00
    db $00
    db $f4
    db $46
    db $00
    db $80

; C: OAM list 25 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_25::
    db $00
    db $14
    db $cc
    db $00
    db $00
    db $0c
    db $ca
    db $00
    db $00
    db $04
    db $4e
    db $00
    db $00
    db $fc
    db $4c
    db $00
    db $00
    db $f4
    db $4a
    db $00
    db $80

; C: OAM list 26 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_26::
    db $08
    db $16
    db $22
    db $00
    db $08
    db $0e
    db $20
    db $00
    db $08
    db $06
    db $1e
    db $00
    db $08
    db $fe
    db $1c
    db $00
    db $08
    db $f6
    db $1a
    db $00
    db $80

; C: OAM list 27 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_27::
    db $00
    db $1a
    db $22
    db $00
    db $00
    db $12
    db $20
    db $00
    db $00
    db $0a
    db $1e
    db $00
    db $00
    db $02
    db $1c
    db $00
    db $00
    db $fa
    db $1a
    db $00
    db $80

; C: OAM list 28 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_28::
    db $03
    db $17
    db $22
    db $00
    db $03
    db $0f
    db $20
    db $00
    db $03
    db $07
    db $1e
    db $00
    db $03
    db $ff
    db $1c
    db $00
    db $03
    db $f7
    db $1a
    db $00
    db $80

; C: OAM list 29 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_29::
    db $fb
    db $1f
    db $7e
    db $00
    db $80

; C: OAM list 2A of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_2A::
    db $d3
    db $19
    db $c6
    db $10
    db $d3
    db $11
    db $be
    db $10
    db $d3
    db $09
    db $bc
    db $10
    db $00
    db $01
    db $c2
    db $10
    db $f0
    db $01
    db $c2
    db $10
    db $e0
    db $01
    db $c2
    db $10
    db $d0
    db $01
    db $c0
    db $10
    db $80

; C: OAM list 2B of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_2B::
    db $d3
    db $19
    db $22
    db $10
    db $d3
    db $11
    db $20
    db $10
    db $d3
    db $09
    db $c8
    db $10
    db $00
    db $01
    db $c2
    db $10
    db $f0
    db $01
    db $c2
    db $10
    db $e0
    db $01
    db $c2
    db $10
    db $d0
    db $01
    db $c0
    db $10
    db $80

; C: OAM list 2C of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_2C::
    db $d3
    db $19
    db $1e
    db $10
    db $d3
    db $11
    db $1c
    db $10
    db $d3
    db $09
    db $1a
    db $10
    db $00
    db $01
    db $c2
    db $10
    db $f0
    db $01
    db $c2
    db $10
    db $e0
    db $01
    db $c2
    db $10
    db $d0
    db $01
    db $c0
    db $10
    db $80

; C: OAM list 2D of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_2D::
    db $e1
    db $0f
    db $3c
    db $00
    db $f2
    db $10
    db $3e
    db $00
    db $80

; C: OAM list 2E of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_2E::
    db $df
    db $13
    db $3c
    db $00
    db $f1
    db $14
    db $3e
    db $00
    db $80

; C: OAM list 2F of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_2F::
    db $dd
    db $17
    db $3c
    db $00
    db $f2
    db $1b
    db $3e
    db $00
    db $80

; C: OAM list 30 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_30::
    db $fc
    db $30
    db $42
    db $10
    db $fc
    db $28
    db $c4
    db $10
    db $00
    db $20
    db $66
    db $10
    db $00
    db $18
    db $64
    db $10
    db $00
    db $10
    db $62
    db $10
    db $00
    db $08
    db $60
    db $10
    db $80

; C: OAM list 31 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_31::
    db $13
    db $30
    db $ba
    db $00
    db $13
    db $28
    db $b8
    db $00
    db $13
    db $20
    db $48
    db $00
    db $13
    db $18
    db $b6
    db $00
    db $13
    db $10
    db $b4
    db $00
    db $80

; C: OAM list 32 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_32::
    db $20
    db $00
    db $ac
    db $10
    db $20
    db $f8
    db $ab
    db $10
    db $20
    db $f0
    db $aa
    db $10
    db $18
    db $00
    db $a9
    db $10
    db $18
    db $f8
    db $a8
    db $10
    db $18
    db $f0
    db $a7
    db $10
    db $10
    db $00
    db $a6
    db $10
    db $10
    db $f8
    db $a5
    db $10
    db $10
    db $f0
    db $a4
    db $10
    db $80

; C: OAM list 33 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_33::
    db $20
    db $00
    db $b5
    db $10
    db $20
    db $f8
    db $b4
    db $10
    db $20
    db $f0
    db $b3
    db $10
    db $18
    db $00
    db $b2
    db $10
    db $18
    db $f8
    db $b1
    db $10
    db $18
    db $f0
    db $b0
    db $10
    db $10
    db $00
    db $af
    db $10
    db $10
    db $f8
    db $ae
    db $10
    db $10
    db $f0
    db $ad
    db $10
    db $80

; C: OAM list 34 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_34::
    db $20
    db $00
    db $be
    db $10
    db $20
    db $f8
    db $bd
    db $10
    db $20
    db $f0
    db $bc
    db $10
    db $18
    db $00
    db $bb
    db $10
    db $18
    db $f8
    db $ba
    db $10
    db $18
    db $f0
    db $b9
    db $10
    db $10
    db $00
    db $b8
    db $10
    db $10
    db $f8
    db $b7
    db $10
    db $10
    db $f0
    db $b6
    db $10
    db $80

; C: OAM list 35 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_35::
    db $09
    db $18
    db $e2
    db $10
    db $09
    db $10
    db $e1
    db $10
    db $09
    db $08
    db $e0
    db $10
    db $01
    db $18
    db $d2
    db $10
    db $01
    db $10
    db $d1
    db $10
    db $01
    db $08
    db $d0
    db $10
    db $f9
    db $18
    db $c2
    db $10
    db $f9
    db $10
    db $c1
    db $10
    db $f9
    db $08
    db $c0
    db $10
    db $80

; C: OAM list 36 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_36::
    db $f9
    db $18
    db $e3
    db $10
    db $09
    db $18
    db $e2
    db $10
    db $09
    db $10
    db $e1
    db $10
    db $09
    db $08
    db $e0
    db $10
    db $01
    db $18
    db $d2
    db $10
    db $01
    db $10
    db $d1
    db $10
    db $01
    db $08
    db $d0
    db $10
    db $f9
    db $10
    db $c1
    db $10
    db $f9
    db $08
    db $c0
    db $10
    db $80

; C: OAM list 37 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_37::
    db $09
    db $18
    db $e2
    db $10
    db $09
    db $10
    db $e1
    db $10
    db $09
    db $08
    db $e0
    db $10
    db $01
    db $18
    db $d5
    db $10
    db $01
    db $10
    db $d4
    db $10
    db $01
    db $08
    db $d3
    db $10
    db $f9
    db $18
    db $c5
    db $10
    db $f9
    db $10
    db $c4
    db $10
    db $f9
    db $08
    db $c3
    db $10
    db $80

; C: OAM list 38 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_38::
    db $09
    db $18
    db $e6
    db $10
    db $f9
    db $07
    db $c5
    db $30
    db $f9
    db $0f
    db $c4
    db $30
    db $f9
    db $17
    db $c3
    db $30
    db $09
    db $10
    db $e1
    db $10
    db $09
    db $08
    db $e0
    db $10
    db $01
    db $18
    db $d8
    db $10
    db $01
    db $10
    db $d7
    db $10
    db $01
    db $08
    db $d6
    db $10
    db $80

; C: OAM list 39 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_39::
    db $09
    db $18
    db $c6
    db $10
    db $01
    db $18
    db $db
    db $10
    db $09
    db $10
    db $e1
    db $10
    db $09
    db $08
    db $e5
    db $10
    db $01
    db $10
    db $da
    db $10
    db $01
    db $08
    db $d9
    db $10
    db $f9
    db $18
    db $cb
    db $10
    db $f9
    db $10
    db $ca
    db $10
    db $f9
    db $08
    db $c9
    db $10
    db $80

; C: OAM list 3A of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_3A::
    db $0b
    db $0b
    db $10
    db $10
    db $03
    db $10
    db $01
    db $10
    db $03
    db $08
    db $00
    db $10
    db $fb
    db $10
    db $f1
    db $10
    db $fb
    db $08
    db $f0
    db $10
    db $80

; C: OAM list 3B of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_3B::
    db $03
    db $10
    db $03
    db $10
    db $03
    db $08
    db $02
    db $10
    db $fb
    db $10
    db $f3
    db $10
    db $fb
    db $08
    db $f2
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 3C of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_3C::
    db $fe
    db $0e
    db $f5
    db $10
    db $fe
    db $06
    db $f4
    db $10
    db $03
    db $10
    db $05
    db $10
    db $03
    db $08
    db $04
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 3D of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_3D::
    db $fa
    db $08
    db $f0
    db $10
    db $fb
    db $0c
    db $95
    db $10
    db $03
    db $10
    db $07
    db $10
    db $03
    db $08
    db $06
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 3E of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_3E::
    db $fb
    db $10
    db $f9
    db $10
    db $fb
    db $08
    db $f8
    db $10
    db $03
    db $10
    db $09
    db $10
    db $03
    db $08
    db $08
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 3F of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_3F::
    db $fb
    db $10
    db $1f
    db $10
    db $03
    db $10
    db $1e
    db $10
    db $03
    db $08
    db $0f
    db $10
    db $fb
    db $08
    db $ff
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 40 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_40::
    db $02
    db $15
    db $fc
    db $10
    db $08
    db $0d
    db $0b
    db $10
    db $08
    db $05
    db $0a
    db $10
    db $00
    db $0d
    db $fb
    db $10
    db $00
    db $05
    db $fa
    db $10
    db $80

; C: OAM list 41 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_41::
    db $01
    db $16
    db $0c
    db $10
    db $09
    db $0e
    db $0e
    db $10
    db $09
    db $06
    db $0d
    db $10
    db $01
    db $0e
    db $fe
    db $10
    db $01
    db $06
    db $fd
    db $10
    db $80

; C: OAM list 42 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_42::
    db $fb
    db $0b
    db $11
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $03
    db $10
    db $01
    db $10
    db $03
    db $08
    db $00
    db $10
    db $80

; C: OAM list 43 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_43::
    db $03
    db $07
    db $09
    db $30
    db $fb
    db $0c
    db $12
    db $10
    db $03
    db $0e
    db $19
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 44 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_44::
    db $fb
    db $0c
    db $13
    db $10
    db $03
    db $06
    db $1a
    db $10
    db $03
    db $0e
    db $1b
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 45 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_45::
    db $fb
    db $0d
    db $15
    db $10
    db $fb
    db $05
    db $14
    db $10
    db $03
    db $0e
    db $1d
    db $10
    db $03
    db $06
    db $1c
    db $10
    db $0b
    db $0b
    db $10
    db $10
    db $80

; C: OAM list 46 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_46::
    db $08
    db $08
    db $16
    db $10
    db $80

; C: OAM list 47 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_47::
    db $08
    db $08
    db $17
    db $10
    db $80

; C: OAM list 48 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_48::
    db $08
    db $08
    db $e4
    db $10
    db $80

; C: OAM list 49 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_49::
    db $08
    db $08
    db $17
    db $30
    db $80

; C: OAM list 4A of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_4A::
    db $08
    db $08
    db $16
    db $30
    db $80

; C: OAM list 4B of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_4B::
    db $08
    db $08
    db $88
    db $00
    db $80

; C: OAM list 4C of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_4C::
    db $08
    db $08
    db $89
    db $00
    db $80

; C: OAM list 4D of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_4D::
    db $08
    db $08
    db $96
    db $00
    db $80

; C: OAM list 4E of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_4E::
    db $08
    db $08
    db $89
    db $20
    db $80

; C: OAM list 4F of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_4F::
    db $08
    db $08
    db $88
    db $20
    db $80

; C: OAM list 50 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_50::
    db $0c
    db $fc
    db $28
    db $00
    db $0c
    db $0b
    db $29
    db $00
    db $04
    db $06
    db $27
    db $00
    db $04
    db $fe
    db $26
    db $00
    db $ef
    db $14
    db $23
    db $00
    db $ef
    db $0c
    db $22
    db $00
    db $fc
    db $04
    db $25
    db $00
    db $fc
    db $fc
    db $24
    db $00
    db $f4
    db $04
    db $21
    db $00
    db $f4
    db $fc
    db $20
    db $00
    db $80

; C: OAM list 51 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_51::
    db $fc
    db $0d
    db $31
    db $00
    db $0c
    db $0c
    db $36
    db $00
    db $0c
    db $fc
    db $35
    db $00
    db $04
    db $0c
    db $34
    db $00
    db $04
    db $04
    db $33
    db $00
    db $04
    db $fc
    db $32
    db $00
    db $fc
    db $04
    db $30
    db $00
    db $fc
    db $fc
    db $2f
    db $00
    db $f4
    db $14
    db $2e
    db $00
    db $f4
    db $0c
    db $2d
    db $00
    db $f4
    db $04
    db $2c
    db $00
    db $f4
    db $fc
    db $2b
    db $00
    db $80

; C: OAM list 52 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_52::
    db $f4
    db $07
    db $39
    db $00
    db $f4
    db $09
    db $37
    db $20
    db $fb
    db $07
    db $39
    db $00
    db $04
    db $09
    db $3a
    db $20
    db $fc
    db $09
    db $38
    db $20
    db $fd
    db $07
    db $39
    db $00
    db $04
    db $ff
    db $3a
    db $00
    db $fc
    db $ff
    db $38
    db $00
    db $f4
    db $ff
    db $37
    db $00
    db $0c
    db $09
    db $3b
    db $20
    db $0c
    db $ff
    db $3b
    db $00
    db $80

; C: OAM list 53 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_53::
    db $01
    db $09
    db $3e
    db $20
    db $f8
    db $ff
    db $3c
    db $00
    db $f8
    db $09
    db $3c
    db $20
    db $fe
    db $07
    db $39
    db $00
    db $f6
    db $07
    db $39
    db $00
    db $09
    db $09
    db $3d
    db $20
    db $ff
    db $07
    db $39
    db $00
    db $01
    db $ff
    db $3e
    db $00
    db $09
    db $ff
    db $3d
    db $00
    db $80

; C: OAM list 54 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_54::
    db $0c
    db $08
    db $df
    db $10
    db $0c
    db $00
    db $de
    db $10
    db $04
    db $08
    db $dd
    db $10
    db $04
    db $00
    db $dc
    db $10
    db $80

; C: OAM list 55 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_55::
    db $18
    db $24
    db $88
    db $00
    db $08
    db $04
    db $4a
    db $00
    db $18
    db $1c
    db $5e
    db $00
    db $18
    db $14
    db $5c
    db $00
    db $18
    db $0c
    db $5a
    db $00
    db $08
    db $24
    db $58
    db $00
    db $08
    db $1c
    db $56
    db $00
    db $08
    db $14
    db $54
    db $00
    db $08
    db $0c
    db $52
    db $00
    db $10
    db $fc
    db $64
    db $00
    db $10
    db $f4
    db $62
    db $00
    db $10
    db $ec
    db $60
    db $00
    db $18
    db $04
    db $42
    db $00
    db $00
    db $fc
    db $12
    db $10
    db $00
    db $f4
    db $10
    db $10
    db $00
    db $ec
    db $0e
    db $10
    db $00
    db $e4
    db $0c
    db $10
    db $00
    db $dc
    db $0a
    db $10
    db $f0
    db $fc
    db $08
    db $10
    db $f0
    db $f4
    db $06
    db $10
    db $f0
    db $ec
    db $04
    db $10
    db $f0
    db $e4
    db $02
    db $10
    db $f0
    db $dc
    db $00
    db $10
    db $80

; C: OAM list 56 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_56::
    db $18
    db $24
    db $88
    db $00
    db $08
    db $04
    db $4a
    db $00
    db $18
    db $1c
    db $5e
    db $00
    db $18
    db $14
    db $5c
    db $00
    db $18
    db $0c
    db $5a
    db $00
    db $08
    db $24
    db $58
    db $00
    db $08
    db $1c
    db $56
    db $00
    db $08
    db $14
    db $54
    db $00
    db $08
    db $0c
    db $52
    db $00
    db $10
    db $fc
    db $64
    db $00
    db $10
    db $f4
    db $62
    db $00
    db $10
    db $ec
    db $60
    db $00
    db $18
    db $04
    db $42
    db $00
    db $00
    db $fc
    db $12
    db $00
    db $00
    db $f4
    db $10
    db $00
    db $00
    db $ec
    db $0e
    db $00
    db $00
    db $e4
    db $0c
    db $00
    db $00
    db $dc
    db $0a
    db $00
    db $f0
    db $fc
    db $08
    db $00
    db $f0
    db $f4
    db $06
    db $00
    db $f0
    db $ec
    db $04
    db $00
    db $f0
    db $e4
    db $02
    db $00
    db $f0
    db $dc
    db $00
    db $00
    db $80

; C: OAM list 57 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_57::
    db $18
    db $24
    db $88
    db $00
    db $18
    db $1c
    db $5e
    db $00
    db $08
    db $24
    db $58
    db $00
    db $08
    db $1c
    db $56
    db $00
    db $10
    db $14
    db $6c
    db $00
    db $10
    db $0c
    db $6a
    db $00
    db $10
    db $fc
    db $68
    db $00
    db $10
    db $f4
    db $66
    db $00
    db $18
    db $ec
    db $3e
    db $00
    db $18
    db $e4
    db $3c
    db $00
    db $08
    db $ec
    db $36
    db $00
    db $08
    db $e4
    db $34
    db $00
    db $00
    db $14
    db $12
    db $10
    db $00
    db $0c
    db $22
    db $10
    db $00
    db $04
    db $20
    db $10
    db $00
    db $fc
    db $1e
    db $10
    db $00
    db $f4
    db $1c
    db $10
    db $f0
    db $14
    db $1a
    db $10
    db $f0
    db $0c
    db $18
    db $10
    db $f0
    db $04
    db $16
    db $10
    db $f0
    db $fc
    db $14
    db $10
    db $f0
    db $f4
    db $00
    db $10
    db $08
    db $0c
    db $38
    db $10
    db $08
    db $fc
    db $36
    db $10
    db $80

; C: OAM list 58 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_58::
    db $18
    db $24
    db $88
    db $00
    db $18
    db $1c
    db $5e
    db $00
    db $08
    db $24
    db $58
    db $00
    db $08
    db $1c
    db $56
    db $00
    db $10
    db $14
    db $6c
    db $00
    db $10
    db $0c
    db $6a
    db $00
    db $10
    db $fc
    db $68
    db $00
    db $10
    db $f4
    db $66
    db $00
    db $18
    db $ec
    db $3e
    db $00
    db $18
    db $e4
    db $3c
    db $00
    db $08
    db $ec
    db $36
    db $00
    db $08
    db $e4
    db $34
    db $00
    db $00
    db $14
    db $12
    db $00
    db $00
    db $0c
    db $22
    db $00
    db $00
    db $04
    db $20
    db $00
    db $00
    db $fc
    db $1e
    db $00
    db $00
    db $f4
    db $1c
    db $00
    db $f0
    db $14
    db $1a
    db $00
    db $f0
    db $0c
    db $18
    db $00
    db $f0
    db $04
    db $16
    db $00
    db $f0
    db $fc
    db $14
    db $00
    db $f0
    db $f4
    db $00
    db $00
    db $08
    db $0c
    db $38
    db $10
    db $08
    db $fc
    db $36
    db $10
    db $80

; C: OAM list 59 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_59::
    db $00
    db $2c
    db $86
    db $10
    db $f0
    db $0c
    db $84
    db $10
    db $10
    db $0c
    db $6e
    db $00
    db $10
    db $14
    db $70
    db $00
    db $10
    db $1c
    db $72
    db $00
    db $18
    db $04
    db $4c
    db $00
    db $08
    db $04
    db $44
    db $00
    db $18
    db $fc
    db $42
    db $00
    db $18
    db $f4
    db $40
    db $00
    db $18
    db $ec
    db $3e
    db $00
    db $18
    db $e4
    db $3c
    db $00
    db $08
    db $fc
    db $3a
    db $00
    db $08
    db $f4
    db $38
    db $00
    db $08
    db $ec
    db $36
    db $00
    db $08
    db $e4
    db $34
    db $00
    db $00
    db $24
    db $32
    db $10
    db $00
    db $1c
    db $30
    db $10
    db $00
    db $14
    db $2e
    db $10
    db $00
    db $0c
    db $2c
    db $10
    db $f0
    db $2c
    db $2a
    db $10
    db $f0
    db $24
    db $28
    db $10
    db $f0
    db $1c
    db $26
    db $10
    db $f0
    db $14
    db $24
    db $10
    db $80

; C: OAM list 5A of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_5A::
    db $00
    db $2c
    db $86
    db $00
    db $f0
    db $0c
    db $84
    db $00
    db $00
    db $24
    db $32
    db $00
    db $00
    db $1c
    db $30
    db $00
    db $00
    db $14
    db $2e
    db $00
    db $00
    db $0c
    db $2c
    db $00
    db $f0
    db $2c
    db $2a
    db $00
    db $f0
    db $24
    db $28
    db $00
    db $f0
    db $1c
    db $26
    db $00
    db $f0
    db $14
    db $24
    db $00
    db $10
    db $0c
    db $6e
    db $00
    db $10
    db $14
    db $70
    db $00
    db $10
    db $1c
    db $72
    db $00
    db $18
    db $04
    db $4c
    db $00
    db $08
    db $04
    db $44
    db $00
    db $18
    db $fc
    db $42
    db $00
    db $18
    db $f4
    db $40
    db $00
    db $18
    db $ec
    db $3e
    db $00
    db $18
    db $e4
    db $3c
    db $00
    db $08
    db $fc
    db $3a
    db $00
    db $08
    db $f4
    db $38
    db $00
    db $08
    db $ec
    db $36
    db $00
    db $08
    db $e4
    db $34
    db $00
    db $80

; C: OAM list 5B of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_5B::
    db $08
    db $08
    db $74
    db $10
    db $80

; C: OAM list 5C of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_5C::
    db $08
    db $09
    db $74
    db $10
    db $80

; C: OAM list 5D of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_5D::
    db $08
    db $08
    db $74
    db $30
    db $80

; C: OAM list 5E of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_5E::
    db $08
    db $07
    db $74
    db $30
    db $80

; C: OAM list 5F of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_5F::
    db $00
    db $10
    db $7e
    db $00
    db $00
    db $08
    db $7c
    db $00
    db $00
    db $00
    db $7a
    db $00
    db $00
    db $f8
    db $78
    db $00
    db $00
    db $f0
    db $76
    db $00
    db $80

; C: OAM list 60 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_60::
    db $00
    db $10
    db $7e
    db $00
    db $00
    db $08
    db $7c
    db $00
    db $fe
    db $00
    db $7a
    db $10
    db $fe
    db $f8
    db $78
    db $10
    db $fe
    db $f0
    db $76
    db $10
    db $80

; C: OAM list 61 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_61::
    db $00
    db $10
    db $7e
    db $00
    db $fe
    db $08
    db $7c
    db $10
    db $00
    db $00
    db $7a
    db $00
    db $fe
    db $f8
    db $78
    db $10
    db $fe
    db $f0
    db $76
    db $10
    db $80

; C: OAM list 62 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_62::
    db $fe
    db $10
    db $7e
    db $10
    db $00
    db $08
    db $7c
    db $00
    db $00
    db $00
    db $7a
    db $00
    db $fe
    db $f8
    db $78
    db $10
    db $fe
    db $f0
    db $76
    db $10
    db $80

; C: OAM list 63 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_63::
    db $08
    db $00
    db $46
    db $10
    db $80

; C: OAM list 64 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_64::
    db $08
    db $ff
    db $46
    db $10
    db $80

; C: OAM list 65 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_65::
    db $08
    db $08
    db $46
    db $30
    db $80

; C: OAM list 66 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_66::
    db $08
    db $09
    db $46
    db $30
    db $80

; C: OAM list 67 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_67::
    db $08
    db $00
    db $48
    db $10
    db $80

; C: OAM list 68 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_68::
    db $08
    db $ff
    db $48
    db $10
    db $80

; C: OAM list 69 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_69::
    db $08
    db $08
    db $48
    db $30
    db $80

; C: OAM list 6A of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_6A::
    db $08
    db $09
    db $48
    db $30
    db $80

; C: OAM list 6B of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_6B::
    db $08
    db $00
    db $80
    db $10
    db $80

; C: OAM list 6C of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_6C::
    db $08
    db $00
    db $82
    db $10
    db $80

; C: OAM list 6D of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_6D::
    db $08
    db $00
    db $84
    db $10
    db $80

; C: OAM list 6E of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_6E::
    db $08
    db $10
    db $03
    db $00
    db $08
    db $08
    db $02
    db $00
    db $08
    db $00
    db $01
    db $00
    db $08
    db $f8
    db $00
    db $00
    db $80

; C: OAM list 6F of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_6F::
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
    db $80

; C: OAM list 70 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_70::
    db $08
    db $18
    db $0c
    db $00
    db $08
    db $10
    db $0b
    db $00
    db $08
    db $08
    db $0a
    db $00
    db $08
    db $00
    db $09
    db $00
    db $08
    db $f8
    db $08
    db $00
    db $08
    db $f0
    db $07
    db $00
    db $80

; C: OAM list 71 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_71::
    db $08
    db $08
    db $11
    db $00
    db $08
    db $00
    db $10
    db $00
    db $80

; C: OAM list 72 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_72::
    db $08
    db $08
    db $13
    db $00
    db $08
    db $00
    db $12
    db $00
    db $80

; C: OAM list 73 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_73::
    db $08
    db $18
    db $18
    db $00
    db $08
    db $10
    db $17
    db $00
    db $08
    db $08
    db $16
    db $00
    db $08
    db $00
    db $15
    db $00
    db $08
    db $f8
    db $14
    db $00
    db $80

; C: OAM list 74 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_74::
    db $08
    db $10
    db $1b
    db $00
    db $08
    db $08
    db $1a
    db $00
    db $08
    db $00
    db $19
    db $00
    db $80

; C: OAM list 75 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_75::
    db $08
    db $10
    db $0f
    db $00
    db $08
    db $08
    db $0e
    db $00
    db $08
    db $00
    db $0d
    db $00
    db $80

; C: OAM list 76 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_76::
    db $08
    db $08
    db $1c
    db $10
    db $80

; C: OAM list 77 of the table 6E4B; C: entry of the same word table as the Japanese name (structure)
OamList_B02_6F2D_77::
    db $10
    db $0d
    db $ba
    db $00
    db $10
    db $08
    db $b9
    db $00
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
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
    ds $d5, $00

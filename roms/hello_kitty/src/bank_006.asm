; Pocket Camera Hello Kitty (Japan), bank $06. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

; C: handler of state $00 of mode $15 (word 0 of Mode15_StateTable)
Mode15_State00::
    di                                            ; $4000
    call Lcd_Off                                  ; $4001
    call Oam_ClearShadow                          ; $4004
    ld b, BANK(Objects_ClearAll)                  ; $4007
    ld hl, Objects_ClearAll                       ; $4009
    call Far_Call                                 ; $400C
    ld b, BANK(ScriptSlots_Clear)                 ; $400F
    ld hl, ScriptSlots_Clear                      ; $4011
    call Far_Call                                 ; $4014
    ld bc, $4850                                  ; $4017
    call Object_CreateWithParam                   ; $401A
    call Serial_SetFarCallback                    ; $401D

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $4023

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld b, MODE_FADE_OUT15                         ; $4031
    ld c, $01                                     ; $4033
    call Fade_GoTo                                ; $4035
    ei                                            ; $4038
    ret                                           ; $4039


; C: handler of state $01 of mode $15 (word 1 of Mode15_StateTable)
Mode15_State01::
    ld a, [wKeysNew]                              ; $403A
    bit PADB_SELECT, a                            ; $403D
    jr z, jr_006_4048                             ; $403F

    ld b, MODE_PLAY_MENU                          ; $4041
    ld c, $00                                     ; $4043
    call Fade_GoToB                               ; $4045

jr_006_4048:
    ret                                           ; $4048


; I: ModeTable entry $15: forced: goes to the fade (mode 1E) at once
Mode15_FadeOut15::
    ldh a, [hState]                               ; $4049
    ld hl, Mode15_StateTable                      ; $404B
    call JumpTable_ByA                            ; $404E
    jp Far_Return                                 ; $4051


; C: state table of mode $15, read by $0189 with hFF8E
Mode15_StateTable::
    dw Mode15_State00
    dw Mode15_State01

; C: handler of state $00 of mode $16 (word 0 of Mode16_StateTable)
Mode16_State00::
    di                                            ; $4058
    call Lcd_Off                                  ; $4059
    call Oam_ClearShadow                          ; $405C
    ld b, BANK(Objects_ClearAll)                  ; $405F
    ld hl, Objects_ClearAll                       ; $4061
    call Far_Call                                 ; $4064
    ld b, BANK(ScriptSlots_Clear)                 ; $4067
    ld hl, ScriptSlots_Clear                      ; $4069
    call Far_Call                                 ; $406C
    ld bc, $4850                                  ; $406F
    call Object_CreateWithParam                   ; $4072
    ld bc, $7070                                  ; $4075
    call Object_CreateWithParam                   ; $4078
    call Serial_SetFarCallback                    ; $407B

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $4081

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld b, MODE_FADE_OUT16                         ; $408F
    ld c, $01                                     ; $4091
    call Fade_GoTo                                ; $4093
    ei                                            ; $4096
    ret                                           ; $4097


; C: handler of state $01 of mode $16 (word 1 of Mode16_StateTable)
Mode16_State01::
    ld a, [wKeysNew]                              ; $4098
    bit PADB_SELECT, a                            ; $409B
    jr z, jr_006_40a6                             ; $409D

    ld b, MODE_PLAY_MENU                          ; $409F
    ld c, $00                                     ; $40A1
    call Fade_GoToB                               ; $40A3

jr_006_40a6:
    ret                                           ; $40A6


; I: ModeTable entry $16: forced: goes to the fade (mode 1E) at once
Mode16_FadeOut16::
    ldh a, [hState]                               ; $40A7
    ld hl, Mode16_StateTable                      ; $40A9
    call JumpTable_ByA                            ; $40AC
    jp Far_Return                                 ; $40AF


; C: state table of mode $16, read by $0189 with hFF8E
Mode16_StateTable::
    dw Mode16_State00
    dw Mode16_State01

; C: handler of state $00 of mode $17 (word 0 of Mode17_StateTable)
Mode17_State00::
    di                                            ; $40B6
    call Lcd_Off                                  ; $40B7
    call Oam_ClearShadow                          ; $40BA
    ld b, BANK(Objects_ClearAll)                  ; $40BD
    ld hl, Objects_ClearAll                       ; $40BF
    call Far_Call                                 ; $40C2
    ld b, BANK(ScriptSlots_Clear)                 ; $40C5
    ld hl, ScriptSlots_Clear                      ; $40C7
    call Far_Call                                 ; $40CA
    call Copy_FarInline                           ; $40CD

    db $00, $40, $14, $00, $80, $00, $18

    call Copy_FarInline                           ; $40D7

    db $20, $78, $2d, $00, $98, $00, $04

    call Serial_SetFarCallback                    ; $40E1

    dwb Bank05_FrameUpdate

    call Lcd_SetupInline                          ; $40E7

    db $93, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld b, MODE_PRINT_ERROR                        ; $40F5
    ld c, STATE_17_PRINT_ERROR_UNNUMBERED         ; $40F7
    call Fade_GoTo                                ; $40F9
    ei                                            ; $40FC
    ret                                           ; $40FD


; C: handler of state $01 of mode $17 (word 1 of Mode17_StateTable)
Mode17_State01::
    ld a, [wKeysNew]                              ; $40FE
    bit PADB_SELECT, a                            ; $4101
    jr z, jr_006_410c                             ; $4103

    ld b, MODE_PLAY_MENU                          ; $4105
    ld c, $00                                     ; $4107
    call Fade_GoToB                               ; $4109

jr_006_410c:
    ret                                           ; $410C


; I: ModeTable entry $17: forced BGB screen (print error)
Mode17_PrintError::
    ldh a, [hState]                               ; $410D
    ld hl, Mode17_StateTable                      ; $410F
    call JumpTable_ByA                            ; $4112
    jp Far_Return                                 ; $4115


; C: state table of mode $17, read by $0189 with hFF8E
Mode17_StateTable::
    dw Mode17_State00
    dw Mode17_State01

; I: state $00 of mode $18: loads Gfx_14_5800_PompompurinPicture and Map_2E_7800_PompompurinPicture, palette, then
; state $01 (06:415E, the only B = $18 of the ROM); unused: no code outside mode $18 sets mode $18 (all 195 mode-
; change calls checked) and the Play menu table 02:5AB7 has four items
Unused_Mode18_State00::
    di                                            ; $411C
    call Lcd_Off                                  ; $411D
    call Oam_ClearShadow                          ; $4120
    ld b, BANK(Objects_ClearAll)                  ; $4123
    ld hl, Objects_ClearAll                       ; $4125
    call Far_Call                                 ; $4128
    ld b, BANK(ScriptSlots_Clear)                 ; $412B
    ld hl, ScriptSlots_Clear                      ; $412D
    call Far_Call                                 ; $4130
    call Copy_FarInline                           ; $4133

    db $00, $58, $14, $00, $80, $00, $18

    call Copy_FarInline                           ; $413D

    db $00, $78, $2e, $00, $98, $00, $04

    call Stat_SetTileToggleAt4F                   ; $4147
    call Serial_SetFarCallback                    ; $414A

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $4150

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $40, $03

    ld b, MODE_POMPOMPURIN_PICTURE                ; $415E
    ld c, STATE_18_POMPOMPURIN_PICTURE            ; $4160
    call Fade_GoTo                                ; $4162
    ei                                            ; $4165
    ret                                           ; $4166


; I: state $01 of mode $18: Select (new key bit 2) fades to mode $04 state $00, the Play menu; unused like 06:411C
Unused_Mode18_State01::
    ld a, [wKeysNew]                              ; $4167
    bit PADB_SELECT, a                            ; $416A
    jr z, jr_006_4175                             ; $416C

    ld b, MODE_PLAY_MENU                          ; $416E
    ld c, $00                                     ; $4170
    call Fade_GoToB                               ; $4172

jr_006_4175:
    ret                                           ; $4175


; I: ModeTable entry $18 (the Pompompurin picture, BGB screen only when forced); unused: see 06:411C
Unused_Mode18_PompompurinPicture::
    ldh a, [hState]                               ; $4176
    ld hl, Mode18_StateTable                      ; $4178
    call JumpTable_ByA                            ; $417B
    jp Far_Return                                 ; $417E


; C: state table of mode $18, read by $0189 with hFF8E
Mode18_StateTable::
    dw Unused_Mode18_State00
    dw Unused_Mode18_State01

; C: handler of state $00 of mode $19 (word 0 of Mode19_StateTable)
Mode19_State00::
    di                                            ; $4185
    call Lcd_Off                                  ; $4186
    call Oam_ClearShadow                          ; $4189
    ld b, BANK(Objects_ClearAll)                  ; $418C
    ld hl, Objects_ClearAll                       ; $418E
    call Far_Call                                 ; $4191
    ld b, BANK(ScriptSlots_Clear)                 ; $4194
    ld hl, ScriptSlots_Clear                      ; $4196
    call Far_Call                                 ; $4199
    call Copy_FarInline                           ; $419C

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $41A6

    db $f0, $75, $31, $00, $98, $00, $04

    call Stat_SetTileToggleCAt1F                  ; $41B0
    ld bc, $3800                                  ; $41B3
    ld de, ObjScript_02_6DD0_Mode05_StampWindow_State06 + $30 ; $41B6
    call Object_CreateWithParam                   ; $41B9
    call Serial_SetFarCallback                    ; $41BC

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $41C2

    db $a3, $e4, $e4, $d0, $10, $10, $07, $90, $ff, $40, $03

    ei                                            ; $41D0
    ld a, $00                                     ; $41D1
    ld b, BANK(Photo_LoadToBufferAndVram)         ; $41D3
    ld hl, Photo_LoadToBufferAndVram              ; $41D5
    call Far_CallKeepA                            ; $41D8
    ld a, [wSlotTagBorder]                        ; $41DB
    ld [wMode06_State00_D931], a                  ; $41DE
    ld a, [wMode06_State00_D931]                  ; $41E1
    call FrameRec_LoadDefault                     ; $41E4
    ld b, MODE_EMPTY_FRAME19                      ; $41E7
    ld c, STATE_19_EMPTY_PHOTO_FRAME              ; $41E9
    call Fade_GoTo                                ; $41EB
    ret                                           ; $41EE


; C: handler of state $01 of mode $19 (word 1 of Mode19_StateTable)
Mode19_State01::
    ld a, [wKeysNew]                              ; $41EF
    bit PADB_B, a                                 ; $41F2
    jr z, jr_006_41fd                             ; $41F4

    ld b, MODE_PLAY_MENU                          ; $41F6
    ld c, $00                                     ; $41F8
    call Fade_GoToB                               ; $41FA

jr_006_41fd:
    ret                                           ; $41FD


; I: ModeTable entry $19: forced BGB screen (an empty photo frame)
Mode19_EmptyFrame19::
    ldh a, [hState]                               ; $41FE
    ld hl, Mode19_StateTable                      ; $4200
    call JumpTable_ByA                            ; $4203
    jp Far_Return                                 ; $4206


; C: state table of mode $19, read by $0189 with hFF8E
Mode19_StateTable::
    dw Mode19_State00
    dw Mode19_State01

; C: read in the runs by Mode14_State01, Mode14_State00; first read on the screen Mode14_MessageScreen_State01
; (trace/read_screens_kitty*.npz); read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: exchange_full)
Mode14_State01_Tbl420D::
    INCBIN "data/bank_06/Mode14_State01_Tbl420D.bin" ; $420D, 619 bytes
; C: handler of state $00 of mode $14 (word 0 of Mode14_StateTable)
Mode14_State00::
    di                                            ; $4478
    call Lcd_Off                                  ; $4479
    call Oam_ClearShadow                          ; $447C
    ld b, BANK(Objects_ClearAll)                  ; $447F
    ld hl, Objects_ClearAll                       ; $4481
    call Far_Call                                 ; $4484
    ld b, BANK(ScriptSlots_Clear)                 ; $4487
    ld hl, ScriptSlots_Clear                      ; $4489
    call Far_Call                                 ; $448C
    ld de, $ffff                                  ; $448F
    ld hl, $8000                                  ; $4492
    ld bc, $1800                                  ; $4495
    call Mem_FillWord                             ; $4498
    call Rng_Next                                 ; $449B
    and $03                                       ; $449E
    ld c, a                                       ; $44A0
    sla a                                         ; $44A1
    add c                                         ; $44A3
    ld c, a                                       ; $44A4
    ld b, $00                                     ; $44A5
    ld hl, Mode14_State01_Tbl420D + $257          ; $44A7
    add hl, bc                                    ; $44AA
    ld a, [hl+]                                   ; $44AB
    ld e, a                                       ; $44AC
    ld a, [hl+]                                   ; $44AD
    ld d, a                                       ; $44AE
    ld a, [hl+]                                   ; $44AF
    push af                                       ; $44B0
    ld hl, $9000                                  ; $44B1
    ld bc, $0800                                  ; $44B4
    call Copy_FarDEtoHL                           ; $44B7
    pop af                                        ; $44BA
    ld hl, $8000                                  ; $44BB
    ld bc, $0600                                  ; $44BE
    call Copy_FarDEtoHL                           ; $44C1
    ld a, [wMessage_Show_D8EC]                    ; $44C4
    sla a                                         ; $44C7
    ld c, a                                       ; $44C9
    ld b, $00                                     ; $44CA
    ld hl, Mode14_State01_Tbl420D + $243          ; $44CC
    add hl, bc                                    ; $44CF
    ld a, [hl+]                                   ; $44D0
    ld e, a                                       ; $44D1
    ld d, [hl]                                    ; $44D2
    ld hl, Gfx_1C_4000_Mode05_StampWindow_State06 + $17C0 ; $44D3
    add hl, de                                    ; $44D6
    ld e, l                                       ; $44D7
    ld d, h                                       ; $44D8
    ld hl, $8800                                  ; $44D9
    ld bc, $0280                                  ; $44DC
    ld a, $1c                                     ; $44DF
    call Copy_FarDEtoHL                           ; $44E1
    call Copy_FarInline                           ; $44E4

    db $00, $6a, $33, $00, $98, $40, $02

    xor a                                         ; $44EE
    ld [wMode14_State01_D8ED], a                  ; $44EF
    ld a, $14                                     ; $44F2
    ld [wMode14_State01_D8EE], a                  ; $44F4
    xor a                                         ; $44F7
    ld [wDoodleFromShutterbug], a                 ; $44F8
    ld a, $00                                     ; $44FB
    ld [wMode14_State01_D801], a                  ; $44FD
    ld a, $00                                     ; $4500
    ld [wMode14_State01_D8EF], a                  ; $4502
    ld a, $40                                     ; $4505
    ld [wMode14_State01_D8F0], a                  ; $4507
    ld a, $11                                     ; $450A
    ld [wMode14_State01_D8F1], a                  ; $450C
    call Stat_SetTileToggleBAt4F                  ; $450F
    call Serial_SetFarCallback                    ; $4512

    dwb Frame_UpdateAll

    call Rng_Next                                 ; $4518
    and $06                                       ; $451B
    ld c, a                                       ; $451D
    ld b, $00                                     ; $451E
    ld hl, Mode14_State01_Tbl420D + $263          ; $4520
    add hl, bc                                    ; $4523
    ld a, [hl+]                                   ; $4524
    ld [wSndMusicReq], a                          ; $4525
    call Lcd_SetupInline                          ; $4528

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $40, $03

    ei                                            ; $4536
    ld b, MODE_MESSAGE_SCREEN                     ; $4537
    ld c, STATE_14_PRINT_ERROR_01_04_PICTURE      ; $4539
    call Fade_GoTo                                ; $453B
    ret                                           ; $453E


; C: handler of state $01 of mode $14 (word 1 of Mode14_StateTable)
Mode14_State01::
    ld a, [wKeysNew]                              ; $453F
    and PADF_A | PADF_B                           ; $4542
    jr z, jr_006_4559                             ; $4544

    push af                                       ; $4546
    ld a, SFX1_11                                 ; $4547
    ld [wSndSfx1], a                              ; $4549
    pop af                                        ; $454C
    ld a, [wReturnModeB]                          ; $454D
    ld b, a                                       ; $4550
    ld a, [wReturnStateB]                         ; $4551
    ld c, a                                       ; $4554
    call Fade_GoToB                               ; $4555
    ret                                           ; $4558


jr_006_4559:
    ld a, [wMode14_State01_D801]                  ; $4559
    and $0f                                       ; $455C
    jp nz, Jump_006_461c                          ; $455E

jr_006_4561:
    ld a, [wMessage_Show_D8EC]                    ; $4561
    sla a                                         ; $4564
    ld c, a                                       ; $4566
    ld b, $00                                     ; $4567
    ld hl, Mode14_State01_Tbl420D + $22F          ; $4569
    add hl, bc                                    ; $456C
    ld a, [hl+]                                   ; $456D
    ld h, [hl]                                    ; $456E
    ld l, a                                       ; $456F
    ld a, [wMode14_State01_D8ED]                  ; $4570
    ld c, a                                       ; $4573
    ld b, $00                                     ; $4574
    add hl, bc                                    ; $4576
    ld a, [hl]                                    ; $4577
    cp $ff                                        ; $4578
    jr z, jr_006_45b1                             ; $457A

    cp $fe                                        ; $457C
    jr z, jr_006_4587                             ; $457E

    cp $fd                                        ; $4580
    jr z, jr_006_459c                             ; $4582

    jp Jump_006_45b7                              ; $4584


jr_006_4587:
    ld hl, wMode14_State01_D8ED                   ; $4587
    inc [hl]                                      ; $458A
    ld a, $00                                     ; $458B
    ld [wMode14_State01_D8EF], a                  ; $458D
    ld a, $40                                     ; $4590
    ld [wMode14_State01_D8F0], a                  ; $4592
    ld a, $11                                     ; $4595
    ld [wMode14_State01_D8F1], a                  ; $4597
    jr jr_006_4561                                ; $459A

jr_006_459c:
    ld hl, wMode14_State01_D8ED                   ; $459C
    inc [hl]                                      ; $459F
    ld a, $00                                     ; $45A0
    ld [wMode14_State01_D8EF], a                  ; $45A2
    ld a, $60                                     ; $45A5
    ld [wMode14_State01_D8F0], a                  ; $45A7
    ld a, $12                                     ; $45AA
    ld [wMode14_State01_D8F1], a                  ; $45AC
    jr jr_006_4561                                ; $45AF

jr_006_45b1:
    xor a                                         ; $45B1
    ld [wMode14_State01_D8ED], a                  ; $45B2
    jr jr_006_4561                                ; $45B5

Jump_006_45b7:
    ld c, a                                       ; $45B7
    ld b, $00                                     ; $45B8
    sla c                                         ; $45BA
    rl b                                          ; $45BC
    sla c                                         ; $45BE
    rl b                                          ; $45C0
    sla c                                         ; $45C2
    rl b                                          ; $45C4
    sla c                                         ; $45C6
    rl b                                          ; $45C8
    sla c                                         ; $45CA
    rl b                                          ; $45CC
    ld a, [wMode14_State01_D8EF]                  ; $45CE
    ld l, a                                       ; $45D1
    ld a, [wMode14_State01_D8F0]                  ; $45D2
    ld h, a                                       ; $45D5
    add hl, bc                                    ; $45D6
    ld e, l                                       ; $45D7
    ld d, h                                       ; $45D8
    ld hl, wMode14_State01_D810                   ; $45D9
    ld bc, $0020                                  ; $45DC
    ld a, [wMode14_State01_D8F1]                  ; $45DF
    call Copy_FarInverted                         ; $45E2
    ld a, [wMode14_State01_D8EE]                  ; $45E5
    and $1f                                       ; $45E8
    ld c, a                                       ; $45EA
    ld b, $00                                     ; $45EB
    sla c                                         ; $45ED
    rl b                                          ; $45EF
    sla c                                         ; $45F1
    rl b                                          ; $45F3
    sla c                                         ; $45F5
    rl b                                          ; $45F7
    sla c                                         ; $45F9
    rl b                                          ; $45FB
    sla c                                         ; $45FD
    rl b                                          ; $45FF
    ld hl, $8b00                                  ; $4601
    add hl, bc                                    ; $4604
    ld de, wMode14_State01_D810                   ; $4605
    ld bc, $0020                                  ; $4608
    call Vram_CopyHBlank                          ; $460B
    ld a, [wMode14_State01_D8ED]                  ; $460E
    inc a                                         ; $4611
    ld [wMode14_State01_D8ED], a                  ; $4612
    ld a, [wMode14_State01_D8EE]                  ; $4615
    inc a                                         ; $4618
    ld [wMode14_State01_D8EE], a                  ; $4619

Jump_006_461c:
    ld a, [wDoodleFromShutterbug]                 ; $461C
    ld l, a                                       ; $461F
    ld a, [wMode14_State01_D801]                  ; $4620
    ld h, a                                       ; $4623
    ld bc, $0080                                  ; $4624
    add hl, bc                                    ; $4627
    ld a, l                                       ; $4628
    ld [wDoodleFromShutterbug], a                 ; $4629
    ld a, h                                       ; $462C
    ld [wMode14_State01_D801], a                  ; $462D
    ret                                           ; $4630


; C: ModeTable entry $14: BGB screen 14:01 (print error; the same screen says there is no photo to give)
Mode14_MessageScreen::
    ldh a, [hState]                               ; $4631
    ld hl, Mode14_StateTable                      ; $4633
    call JumpTable_ByA                            ; $4636
    jp Far_Return                                 ; $4639


; C: state table of mode $14, read by $0189 with hFF8E
Mode14_StateTable::
dw Mode14_State00
dw Mode14_State01
    db $6c, $48
    dw Gfx_1B_5D00_Mode0B_NameCardEdit_State10
    db $6c, $48
    dw Gfx_1B_5D00_Mode0B_NameCardEdit_State10
    db $80, $48, $40, $5f, $bc, $48, $80, $61, $a8, $48, $c0, $63, $bc, $48, $00, $66


; C: the item record [$D8F4] (8 bytes at hFFD1-hFFD3) gives the cursor position hFFD2 / hFFD4, then a 4-byte record of
; 06:4640 by item; runs in the name card editor (mode $0B state $10)
NameCardEdit_CursorPlace::
    ldh a, [hMode07_StateTable_FFD1]              ; $4658
    ld c, a                                       ; $465A
    ldh a, [hMode07_StateTable_FFD3]              ; $465B
    ld b, a                                       ; $465D
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $465E
    ld l, a                                       ; $4661
    ld h, $00                                     ; $4662
    sla l                                         ; $4664
    rl h                                          ; $4666
    sla l                                         ; $4668
    rl h                                          ; $466A
    sla l                                         ; $466C
    rl h                                          ; $466E
    add hl, bc                                    ; $4670
    ld a, [hl+]                                   ; $4671
    ldh [hMode07_StateTable_FFD2], a              ; $4672
    ld a, [hl+]                                   ; $4674
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $4675
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4677
    sla a                                         ; $467A
    sla a                                         ; $467C
    ld c, a                                       ; $467E
    ld b, $00                                     ; $467F
    ld hl, Mode14_StateTable + $4                 ; $4681
    add hl, bc                                    ; $4684
    ld a, [hl+]                                   ; $4685
    ld e, a                                       ; $4686
    ld a, [hl+]                                   ; $4687
    ld d, a                                       ; $4688
    push de                                       ; $4689
    ld a, [hl+]                                   ; $468A
    ld e, a                                       ; $468B
    ld a, [hl+]                                   ; $468C
    ld d, a                                       ; $468D
    ld hl, $8500                                  ; $468E
    ld bc, $0240                                  ; $4691
    ld a, $1b                                     ; $4694
    call Vram_CopyHBlankFar                       ; $4696
    pop hl                                        ; $4699
    jp Far_Return                                 ; $469A


; C: 06:46A3 then Far_Return
Menu06_CursorCallback::
    call Menu06_CursorUpdate                      ; $469D
    jp Far_Return                                 ; $46A0


; C: menu cursor object: the D-pad picks the next item from the 8-byte item records (as the Play menu cursor 02:4CFD),
; A ($D8D9 bit 0) selects
Menu06_CursorUpdate::
    ld a, [wFadeRunning]                          ; $46A3
    and a                                         ; $46A6
    jr nz, jr_006_46cb                            ; $46A7

    ld a, [wKeysNewRepeat]                        ; $46A9
    ld de, $0002                                  ; $46AC
    bit 5, a                                      ; $46AF
    jr nz, jr_006_46eb                            ; $46B1

    inc e                                         ; $46B3
    bit 4, a                                      ; $46B4
    jr nz, jr_006_46eb                            ; $46B6

    inc e                                         ; $46B8
    bit 6, a                                      ; $46B9
    jr nz, jr_006_46eb                            ; $46BB

    inc e                                         ; $46BD
    bit 7, a                                      ; $46BE
    jr nz, jr_006_46eb                            ; $46C0

    inc e                                         ; $46C2
    ld a, [wKeysNew]                              ; $46C3
    bit PADB_A, a                                 ; $46C6
    jp nz, Jump_006_4754                          ; $46C8

jr_006_46cb:
    ldh a, [hMode07_StateTable_FFD1]              ; $46CB
    ld c, a                                       ; $46CD
    ldh a, [hMode07_StateTable_FFD3]              ; $46CE
    ld b, a                                       ; $46D0
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $46D1
    ld l, a                                       ; $46D4
    ld h, $00                                     ; $46D5
    sla l                                         ; $46D7
    rl h                                          ; $46D9
    sla l                                         ; $46DB
    rl h                                          ; $46DD
    sla l                                         ; $46DF
    rl h                                          ; $46E1
    add hl, bc                                    ; $46E3
    ld a, [hl+]                                   ; $46E4
    ldh [hMode07_StateTable_FFD2], a              ; $46E5
    ld a, [hl+]                                   ; $46E7
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $46E8
    ret                                           ; $46EA


jr_006_46eb:
    ldh a, [hMode07_StateTable_FFD1]              ; $46EB
    ld c, a                                       ; $46ED
    ldh a, [hMode07_StateTable_FFD3]              ; $46EE
    ld b, a                                       ; $46F0
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $46F1
    ld l, a                                       ; $46F4
    ld h, $00                                     ; $46F5
    sla l                                         ; $46F7
    rl h                                          ; $46F9
    sla l                                         ; $46FB
    rl h                                          ; $46FD
    sla l                                         ; $46FF
    rl h                                          ; $4701
    add hl, bc                                    ; $4703
    add hl, de                                    ; $4704
    ld a, [hl]                                    ; $4705
    cp $ff                                        ; $4706
    jr z, jr_006_4753                             ; $4708

    ld [wMenu07_CursorUpdate_D8F4], a             ; $470A
    ld l, a                                       ; $470D
    ld h, $00                                     ; $470E
    sla l                                         ; $4710
    rl h                                          ; $4712
    sla l                                         ; $4714
    rl h                                          ; $4716
    sla l                                         ; $4718
    rl h                                          ; $471A
    add hl, bc                                    ; $471C
    ld a, [hl+]                                   ; $471D
    ldh [hMode07_StateTable_FFD2], a              ; $471E
    ld a, [hl+]                                   ; $4720
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $4721
    ld bc, $0004                                  ; $4723
    add hl, bc                                    ; $4726
    ld a, [hl]                                    ; $4727
    ld [wNameCardEdit_PhotoCursorUpdate_D97E], a  ; $4728
    sla a                                         ; $472B
    sla a                                         ; $472D
    ld c, a                                       ; $472F
    ld b, $00                                     ; $4730
    ld hl, Menu06_CursorUpdate_Tbl4781 + $30      ; $4732
    add hl, bc                                    ; $4735
    ld a, [hl+]                                   ; $4736
    ld e, a                                       ; $4737
    ld a, [hl+]                                   ; $4738
    ld d, a                                       ; $4739
    call Call_000_2205                            ; $473A
    ld a, [hl+]                                   ; $473D
    ld e, a                                       ; $473E
    ld a, [hl+]                                   ; $473F
    ld d, a                                       ; $4740
    ld hl, $8500                                  ; $4741
    ld bc, $0240                                  ; $4744
    ld a, $1b                                     ; $4747
    call Vram_CopyHBlankFar                       ; $4749
    push af                                       ; $474C
    ld a, SFX1_03                                 ; $474D
    ld [wSndSfx1], a                              ; $474F
    pop af                                        ; $4752

jr_006_4753:
    ret                                           ; $4753


Jump_006_4754:
    ldh a, [hMode07_StateTable_FFD1]              ; $4754
    ld c, a                                       ; $4756
    ldh a, [hMode07_StateTable_FFD3]              ; $4757
    ld b, a                                       ; $4759
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $475A
    ld l, a                                       ; $475D
    ld h, $00                                     ; $475E
    sla l                                         ; $4760
    rl h                                          ; $4762
    sla l                                         ; $4764
    rl h                                          ; $4766
    sla l                                         ; $4768
    rl h                                          ; $476A
    add hl, bc                                    ; $476C
    add hl, de                                    ; $476D
    ld a, [hl+]                                   ; $476E
    ld [wNameCardEdit_PhotoCursorUpdate_D97E], a  ; $476F
    ld a, [hl+]                                   ; $4772
    ldh [hMenuState], a                           ; $4773
    ld a, $01                                     ; $4775
    ld [wMode07_StateTable_D8E0], a               ; $4777
    ld hl, wNameCardEdit_PhotoCursorUpdate_D97D   ; $477A
    inc [hl]                                      ; $477D
    jp Obj_End                                    ; $477E


; C: read in the runs by Menu06_CursorUpdate, NameCardEdit_CursorPlace; first read on the screen
; Mode0B_NameCardEdit_State02 (trace/read_screens_kitty*.npz)
Menu06_CursorUpdate_Tbl4781::
    db $1c, $2c, $ff, $02, $ff, $ff, $00, $03, $1c, $2c, $ff, $04, $ff, $ff, $00, $03
    db $5c, $20, $00, $03, $ff, $04, $01, $07, $8c, $20, $02, $ff, $ff, $05, $02, $09
    db $60, $38, $01, $05, $02, $ff, $03, $0b, $94, $38, $04, $ff, $03, $ff, $04, $0d
    db $6c, $48
    dw Gfx_1B_5D00_Mode0B_NameCardEdit_State10
    db $80, $48, $40, $5f, $bc, $48, $80, $61, $a8, $48, $c0, $63, $bc, $48, $00, $66

; C: 06:47CB then Far_Return
NameCardEdit_PhotoCursorCallback::
    call NameCardEdit_PhotoCursorUpdate           ; $47C5
    jp Far_Return                                 ; $47C8


; C: object callback in the photo choice of the name card (mode $0B state $04): position from [$DC5E] and $D984, steps
; by $D994; runs on its screen (0B:04) in the core replays (port/entry_modes_kitty.csv); code read
NameCardEdit_PhotoCursorUpdate::
    ld a, [wGfx_00_1DAB_Mode12_SlideShow_State00_DC5E] ; $47CB
    ld l, a                                       ; $47CE
    ld a, [wGfx_00_1DAB_Mode12_SlideShow_State00_DC5F] ; $47CF
    ld h, a                                       ; $47D2
    ld de, hGfx_00_1DAB_Mode12_SlideShow_State00_FFFA ; $47D3
    add hl, de                                    ; $47D6
    ld a, [wNameCardEdit_PhotoCursorUpdate_D984]  ; $47D7
    add [hl]                                      ; $47DA
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $47DB
    ld a, [wStamp_ObjSlideIn_D994]                ; $47DD
    and a                                         ; $47E0
    jr z, jr_006_47ea                             ; $47E1

    cp $02                                        ; $47E3
    jr z, jr_006_480f                             ; $47E5

    jr jr_006_4837                                ; $47E7

    db $c9

jr_006_47ea:
    call Obj_HideSprite                           ; $47EA
    ld a, $01                                     ; $47ED
    ld [wMode07_StateTable_D8E0], a               ; $47EF
    ld a, $01                                     ; $47F2
    ldh [hMenuState], a                           ; $47F4
    push hl                                       ; $47F6
    ld hl, wMode06_State0A_D896                   ; $47F7
    set 0, [hl]                                   ; $47FA
    pop hl                                        ; $47FC
    ld b, BANK(Sram_StoreIdCard)                  ; $47FD
    ld hl, Sram_StoreIdCard                       ; $47FF
    call Far_Call                                 ; $4802
    push hl                                       ; $4805
    ld hl, wMode06_State0A_D896                   ; $4806
    res 0, [hl]                                   ; $4809
    pop hl                                        ; $480B
    jp Obj_End                                    ; $480C


jr_006_480f:
    ld de, $0002                                  ; $480F
    ld a, [wKeysNewRepeat]                        ; $4812
    bit PADB_LEFT, a                              ; $4815
    jr nz, jr_006_487e                            ; $4817

    inc e                                         ; $4819
    bit 4, a                                      ; $481A
    jr nz, jr_006_487e                            ; $481C

    inc e                                         ; $481E
    bit 6, a                                      ; $481F
    jr nz, jr_006_487e                            ; $4821

    inc e                                         ; $4823
    bit 7, a                                      ; $4824
    jr nz, jr_006_487e                            ; $4826

    inc e                                         ; $4828
    ld a, [wKeysNew]                              ; $4829
    bit PADB_A, a                                 ; $482C
    jp nz, Jump_006_491d                          ; $482E

    inc e                                         ; $4831
    bit 1, a                                      ; $4832
    jp nz, Jump_006_49bb                          ; $4834

jr_006_4837:
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $4837
    sla a                                         ; $483A
    ld c, a                                       ; $483C
    ld b, $00                                     ; $483D
    ld hl, NameCardEdit_PhotoCursorUpdate_Tbl49D2 + $A ; $483F
    add hl, bc                                    ; $4842
    ld c, [hl]                                    ; $4843
    inc hl                                        ; $4844
    ld b, [hl]                                    ; $4845
    ld a, [wNameCardEdit_PhotoCursorUpdate_D983]  ; $4846
    ld l, a                                       ; $4849
    ld h, $00                                     ; $484A
    sla l                                         ; $484C
    rl h                                          ; $484E
    sla l                                         ; $4850
    rl h                                          ; $4852
    sla l                                         ; $4854
    rl h                                          ; $4856
    add hl, bc                                    ; $4858
    ld a, [hl+]                                   ; $4859
    ldh [hMode07_StateTable_FFD2], a              ; $485A
    ld a, [hl+]                                   ; $485C
    ld [wNameCardEdit_PhotoCursorUpdate_D984], a  ; $485D
    ld bc, $0004                                  ; $4860
    add hl, bc                                    ; $4863
    ld a, [hl]                                    ; $4864
    and $0f                                       ; $4865
    ld hl, hScratch_CursorUpdate_FFD9             ; $4867
    cp [hl]                                       ; $486A
    ret z                                         ; $486B

    ld [hl], a                                    ; $486C
    sla a                                         ; $486D
    ld c, a                                       ; $486F
    ld b, $00                                     ; $4870
    ld hl, NameCardEdit_PhotoCursorUpdate_Tbl49D2 ; $4872
    add hl, bc                                    ; $4875
    ld a, [hl+]                                   ; $4876
    ld e, a                                       ; $4877
    ld a, [hl+]                                   ; $4878
    ld d, a                                       ; $4879
    call Call_000_2205                            ; $487A
    ret                                           ; $487D


jr_006_487e:
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $487E
    sla a                                         ; $4881
    ld c, a                                       ; $4883
    ld b, $00                                     ; $4884
    ld hl, NameCardEdit_PhotoCursorUpdate_Tbl49D2 + $A ; $4886
    add hl, bc                                    ; $4889
    ld c, [hl]                                    ; $488A
    inc hl                                        ; $488B
    ld b, [hl]                                    ; $488C
    ld a, [wNameCardEdit_PhotoCursorUpdate_D983]  ; $488D
    ld l, a                                       ; $4890
    ld h, $00                                     ; $4891
    sla l                                         ; $4893
    rl h                                          ; $4895
    sla l                                         ; $4897
    rl h                                          ; $4899
    sla l                                         ; $489B
    rl h                                          ; $489D
    add hl, bc                                    ; $489F
    add hl, de                                    ; $48A0
    ld a, [hl]                                    ; $48A1
    cp $f8                                        ; $48A2
    jp z, Jump_006_48f2                           ; $48A4

    cp $f9                                        ; $48A7
    jp z, Jump_006_4900                           ; $48A9

    cp $ff                                        ; $48AC
    jr z, jr_006_48f1                             ; $48AE

    ld [wNameCardEdit_PhotoCursorUpdate_D983], a  ; $48B0
    ld l, a                                       ; $48B3
    ld h, $00                                     ; $48B4
    sla l                                         ; $48B6
    rl h                                          ; $48B8
    sla l                                         ; $48BA
    rl h                                          ; $48BC
    sla l                                         ; $48BE
    rl h                                          ; $48C0
    add hl, bc                                    ; $48C2
    ld a, [hl+]                                   ; $48C3
    ldh [hMode07_StateTable_FFD2], a              ; $48C4
    ld a, [hl+]                                   ; $48C6
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $48C7
    ld [wNameCardEdit_PhotoCursorUpdate_D984], a  ; $48C9
    ld bc, $0004                                  ; $48CC
    add hl, bc                                    ; $48CF
    ld a, [hl]                                    ; $48D0
    and $0f                                       ; $48D1
    ld hl, hScratch_CursorUpdate_FFD9             ; $48D3
    cp [hl]                                       ; $48D6
    jr z, jr_006_48ea                             ; $48D7

    ld [hl], a                                    ; $48D9
    sla a                                         ; $48DA
    ld c, a                                       ; $48DC
    ld b, $00                                     ; $48DD
    ld hl, NameCardEdit_PhotoCursorUpdate_Tbl49D2 ; $48DF
    add hl, bc                                    ; $48E2
    ld a, [hl+]                                   ; $48E3
    ld e, a                                       ; $48E4
    ld a, [hl+]                                   ; $48E5
    ld d, a                                       ; $48E6
    call Call_000_2205                            ; $48E7

jr_006_48ea:
    push af                                       ; $48EA
    ld a, SFX1_20                                 ; $48EB
    ld [wSndSfx1], a                              ; $48ED
    pop af                                        ; $48F0

jr_006_48f1:
    ret                                           ; $48F1


Jump_006_48f2:
    ld a, [wNameCardEdit_PhotoCursorUpdate_D982]  ; $48F2
    cp $00                                        ; $48F5
    jr z, jr_006_48ff                             ; $48F7

    dec a                                         ; $48F9
    ld [wNameCardEdit_PhotoCursorUpdate_D982], a  ; $48FA
    jr jr_006_490d                                ; $48FD

jr_006_48ff:
    ret                                           ; $48FF


Jump_006_4900:
    ld hl, wNameCardEdit_PhotoCursorUpdate_D985   ; $4900
    ld a, [wNameCardEdit_PhotoCursorUpdate_D982]  ; $4903
    inc a                                         ; $4906
    cp [hl]                                       ; $4907
    jr z, jr_006_48ff                             ; $4908

    ld [wNameCardEdit_PhotoCursorUpdate_D982], a  ; $490A

jr_006_490d:
    push af                                       ; $490D
    ld a, SFX1_20                                 ; $490E
    ld [wSndSfx1], a                              ; $4910
    pop af                                        ; $4913
    ld b, BANK(NameCardEdit_LoadFieldGlyphs)      ; $4914
    ld hl, NameCardEdit_LoadFieldGlyphs           ; $4916
    call Far_Call                                 ; $4919
    ret                                           ; $491C


Jump_006_491d:
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $491D
    sla a                                         ; $4920
    ld c, a                                       ; $4922
    ld b, $00                                     ; $4923
    ld hl, NameCardEdit_PhotoCursorUpdate_Tbl49D2 + $A ; $4925
    add hl, bc                                    ; $4928
    ld c, [hl]                                    ; $4929
    inc hl                                        ; $492A
    ld b, [hl]                                    ; $492B
    ld a, [wNameCardEdit_PhotoCursorUpdate_D983]  ; $492C
    ld l, a                                       ; $492F
    ld h, $00                                     ; $4930
    sla l                                         ; $4932
    rl h                                          ; $4934
    sla l                                         ; $4936
    rl h                                          ; $4938
    sla l                                         ; $493A
    rl h                                          ; $493C
    add hl, bc                                    ; $493E
    add hl, de                                    ; $493F
    ld a, [hl]                                    ; $4940
    and $f0                                       ; $4941
    jr z, jr_006_4952                             ; $4943

    cp $10                                        ; $4945
    jr z, jr_006_4983                             ; $4947

    cp $20                                        ; $4949
    jr z, jr_006_499a                             ; $494B

    cp $30                                        ; $494D
    jr z, jr_006_49b5                             ; $494F

    ret                                           ; $4951


jr_006_4952:
    ld hl, wNameCardEdit_PhotoCursorUpdate_D97D   ; $4952
    inc [hl]                                      ; $4955
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $4956
    and a                                         ; $4959
    jr nz, jr_006_4965                            ; $495A

    push af                                       ; $495C
    ld a, SFX1_38                                 ; $495D
    ld [wSndSfx1], a                              ; $495F
    pop af                                        ; $4962
    jr jr_006_496c                                ; $4963

jr_006_4965:
    push af                                       ; $4965
    ld a, SFX1_19                                 ; $4966
    ld [wSndSfx1], a                              ; $4968
    pop af                                        ; $496B

jr_006_496c:
    ld c, $05                                     ; $496C
    ld a, [wNameCardEdit_PhotoCursorUpdate_D982]  ; $496E
    call Mul_8x8                                  ; $4971
    ld a, [wNameCardEdit_PhotoCursorUpdate_D983]  ; $4974
    add l                                         ; $4977
    inc a                                         ; $4978
    ld b, BANK(NameCardEdit_FieldAction)          ; $4979
    ld hl, NameCardEdit_FieldAction               ; $497B
    call Far_CallKeepA                            ; $497E
    jr jr_006_49a7                                ; $4981

jr_006_4983:
    ld hl, wNameCardEdit_PhotoCursorUpdate_D97D   ; $4983
    inc [hl]                                      ; $4986
    push af                                       ; $4987
    ld a, SFX4_04                                 ; $4988
    ld [wSndSfx4], a                              ; $498A
    pop af                                        ; $498D
    ld a, $00                                     ; $498E
    ld b, BANK(NameCardEdit_FieldAction)          ; $4990
    ld hl, NameCardEdit_FieldAction               ; $4992
    call Far_CallKeepA                            ; $4995
    jr jr_006_49a7                                ; $4998

jr_006_499a:
    ld hl, wNameCardEdit_PhotoCursorUpdate_D97D   ; $499A
    inc [hl]                                      ; $499D
    push af                                       ; $499E
    ld a, SFX1_02                                 ; $499F
    ld [wSndSfx1], a                              ; $49A1
    pop af                                        ; $49A4
    jr jr_006_49a7                                ; $49A5

jr_006_49a7:
    ld hl, wNameCardEdit_PhotoCursorUpdate_D986   ; $49A7
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $49AA
    cp [hl]                                       ; $49AD
    jr z, jr_006_49b4                             ; $49AE

    inc a                                         ; $49B0
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $49B1

jr_006_49b4:
    ret                                           ; $49B4


jr_006_49b5:
    ld hl, wNameCardEdit_PhotoCursorUpdate_D981   ; $49B5
    res 0, [hl]                                   ; $49B8
    ret                                           ; $49BA


Jump_006_49bb:
    push af                                       ; $49BB
    ld a, SFX1_1D                                 ; $49BC
    ld [wSndSfx1], a                              ; $49BE
    pop af                                        ; $49C1
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $49C2
    cp $00                                        ; $49C5
    jr z, jr_006_49d1                             ; $49C7

    dec a                                         ; $49C9
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $49CA
    ld hl, wNameCardEdit_PhotoCursorUpdate_D97D   ; $49CD
    dec [hl]                                      ; $49D0

jr_006_49d1:
    ret                                           ; $49D1


; C: named by the code of NameCardEdit_PhotoCursorUpdate (06:4872 06:48DF); read in the runs by
; NameCardEdit_PhotoCursorUpdate; first read on the screen Mode0B_NameCardEdit_State08 (trace/read_screens_kitty*.npz)
NameCardEdit_PhotoCursorUpdate_Tbl49D2::
    INCBIN "data/bank_06/NameCardEdit_PhotoCursorUpdate_Tbl49D2.bin" ; $49D2, 364 bytes
; C: object callback: for step [$D97D] takes {frame, key mask} from 06:4B87 and ANDs the mask into the keys $D8D8;
; code read; runs in the name card editor (mode $0B)
Obj_KeyMaskStep::
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97D]  ; $4B3E
    sla a                                         ; $4B41
    ld c, a                                       ; $4B43
    ld b, $00                                     ; $4B44
    ld hl, Obj_KeyMaskStep + $49                  ; $4B46
    add hl, bc                                    ; $4B49
    ldh a, [hMode07_StateTable_FFD2]              ; $4B4A
    ld c, a                                       ; $4B4C
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97D]  ; $4B4D
    cp c                                          ; $4B50
    jr z, jr_006_4b69                             ; $4B51

    ld a, [hl+]                                   ; $4B53
    cp $ff                                        ; $4B54
    jr z, jr_006_4b6a                             ; $4B56

    ld [wNameCardEdit_PhotoCursorUpdate_D983], a  ; $4B58
    call Obj_ClearCallback                        ; $4B5B
    ld de, $7fc0                                  ; $4B5E
    call Call_000_2205                            ; $4B61
    jp Far_Return                                 ; $4B64


    db $18, $01

jr_006_4b69:
    inc hl                                        ; $4B69

jr_006_4b6a:
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97D]  ; $4B6A
    ldh [hMode07_StateTable_FFD2], a              ; $4B6D
    ld a, [wKeysHeld]                             ; $4B6F
    and [hl]                                      ; $4B72
    ld [wKeysHeld], a                             ; $4B73
    ld a, [wKeysNew]                              ; $4B76
    and [hl]                                      ; $4B79
    ld [wKeysNew], a                              ; $4B7A
    ld a, [wKeysNewRepeat]                        ; $4B7D
    and [hl]                                      ; $4B80
    ld [wKeysNewRepeat], a                        ; $4B81
    jp Far_Return                                 ; $4B84


    db $ff

; C: read in the runs by Obj_KeyMaskStep; first read on the screen Mode0B_NameCardEdit_State08
; (trace/read_screens_kitty*.npz)
ObjScript_06_4B88_Mode0B_NameCardEdit_State08::
    db $03, $ff, $03, $ff, $03, $ff, $03, $05, $00, $ff, $01, $ff, $f3, $ff, $f3, $ff
    db $f3, $ff, $f3, $ff, $f3, $ff, $f3, $ff, $f3, $ff, $f3, $ff, $f3, $0d, $00, $ff
    db $01, $ff, $31, $05, $00, $ff, $01, $ff, $f3, $ff, $f3, $ff, $f3, $ff, $f3, $ff
    db $f3, $ff, $f3, $ff, $f3, $ff, $f3, $0c, $00, $ff, $01, $ff, $31, $03

    db $00

; C: DE = $7C40 + 16 x A (the digit tiles of bank $0C)
Digit_TileAddr7C40::
    ld c, $10                                     ; $4BC7
    call Mul_8x8                                  ; $4BC9
    ld de, $7c40                                  ; $4BCC
    add hl, de                                    ; $4BCF
    ld e, l                                       ; $4BD0
    ld d, h                                       ; $4BD1
    ret                                           ; $4BD2


; C: the 8 digits of the ID number $DADB-$DADE into tiles $8AF0, or 8 blank tiles (0C:7CE0) while it is 0; mode $0A
IdCard_DrawIdNumber::
    ld hl, wIdCard                                ; $4BD3
    ld b, $04                                     ; $4BD6
    xor a                                         ; $4BD8

jr_006_4bd9:
    or [hl]                                       ; $4BD9
    inc hl                                        ; $4BDA
    dec b                                         ; $4BDB
    jr nz, jr_006_4bd9                            ; $4BDC

    and a                                         ; $4BDE
    jr nz, jr_006_4bf9                            ; $4BDF

    ld hl, $8af0                                  ; $4BE1
    ld b, $08                                     ; $4BE4

jr_006_4be6:
    push bc                                       ; $4BE6
    ld de, Gfx_0C_7CE0_Mode0C_RecordBook_State01  ; $4BE7
    ld bc, $0010                                  ; $4BEA
    ld a, $0c                                     ; $4BED
    call Vram_CopyHBlankFar                       ; $4BEF
    pop bc                                        ; $4BF2
    dec b                                         ; $4BF3
    jr nz, jr_006_4be6                            ; $4BF4

    jp Far_Return                                 ; $4BF6


jr_006_4bf9:
    ld hl, wIdCard                                ; $4BF9
    ld de, $8af0                                  ; $4BFC
    ld b, $04                                     ; $4BFF

jr_006_4c01:
    push bc                                       ; $4C01
    ld a, [hl]                                    ; $4C02
    and $0f                                       ; $4C03
    dec a                                         ; $4C05
    push hl                                       ; $4C06
    push de                                       ; $4C07
    call Digit_TileAddr7C40                       ; $4C08
    pop hl                                        ; $4C0B
    ld bc, $0010                                  ; $4C0C
    ld a, $0c                                     ; $4C0F
    call Vram_CopyHBlankFar                       ; $4C11
    ld e, l                                       ; $4C14
    ld d, h                                       ; $4C15
    pop hl                                        ; $4C16
    ld a, [hl+]                                   ; $4C17
    swap a                                        ; $4C18
    and $0f                                       ; $4C1A
    dec a                                         ; $4C1C
    push hl                                       ; $4C1D
    push de                                       ; $4C1E
    call Digit_TileAddr7C40                       ; $4C1F
    pop hl                                        ; $4C22
    ld bc, $0010                                  ; $4C23
    ld a, $0c                                     ; $4C26
    call Vram_CopyHBlankFar                       ; $4C28
    ld e, l                                       ; $4C2B
    ld d, h                                       ; $4C2C
    pop hl                                        ; $4C2D
    pop bc                                        ; $4C2E
    dec b                                         ; $4C2F
    jr nz, jr_006_4c01                            ; $4C30

    jp Far_Return                                 ; $4C32


; C: DE = $4000 + 32 x A: an 8x16 glyph of bank $11
IdCard_NameGlyphAddr::
    ld c, $20                                     ; $4C35
    call Mul_8x8                                  ; $4C37
    ld de, Mode15_State00                         ; $4C3A
    add hl, de                                    ; $4C3D
    ld e, l                                       ; $4C3E
    ld d, h                                       ; $4C3F
    ret                                           ; $4C40


; C: the 9 characters at $DADF as 8x16 glyphs of bank $11 into tiles $8DE0 (Vram_CopyHBlankFar)
IdCard_DrawName::
    ld hl, wIdCard + $4                           ; $4C41
    ld de, $8de0                                  ; $4C44
    ld b, $09                                     ; $4C47

jr_006_4c49:
    push bc                                       ; $4C49
    ld a, [hl+]                                   ; $4C4A
    dec a                                         ; $4C4B
    push hl                                       ; $4C4C
    push de                                       ; $4C4D
    call IdCard_NameGlyphAddr                     ; $4C4E
    pop hl                                        ; $4C51
    ld bc, $0020                                  ; $4C52
    ld a, $11                                     ; $4C55
    call Vram_CopyHBlankFar                       ; $4C57
    ld e, l                                       ; $4C5A
    ld d, h                                       ; $4C5B
    pop hl                                        ; $4C5C
    pop bc                                        ; $4C5D
    dec b                                         ; $4C5E
    jr nz, jr_006_4c49                            ; $4C5F

    jp Far_Return                                 ; $4C61


; C: the same into the print buffer $CDE0 (Copy_FarDEtoHL); first run while printing, mode $06 state $16
IdCard_DrawNameToPrintBuf::
    ld hl, wIdCard + $4                           ; $4C64
    ld de, $cde0                                  ; $4C67
    ld b, $09                                     ; $4C6A

jr_006_4c6c:
    push bc                                       ; $4C6C
    ld a, [hl+]                                   ; $4C6D
    dec a                                         ; $4C6E
    push hl                                       ; $4C6F
    push de                                       ; $4C70
    call IdCard_NameGlyphAddr                     ; $4C71
    pop hl                                        ; $4C74
    ld bc, $0020                                  ; $4C75
    ld a, $11                                     ; $4C78
    call Copy_FarDEtoHL                           ; $4C7A
    ld e, l                                       ; $4C7D
    ld d, h                                       ; $4C7E
    pop hl                                        ; $4C7F
    pop bc                                        ; $4C80
    dec b                                         ; $4C81
    jr nz, jr_006_4c6c                            ; $4C82

    jp Far_Return                                 ; $4C84


; C: the character [$D97F] of the name into its tile $8DE0 + 32 x [$D97F] while it is typed
IdCard_DrawNameChar::
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4C87
    ld c, a                                       ; $4C8A
    ld b, $00                                     ; $4C8B
    ld hl, wIdCard + $4                           ; $4C8D
    add hl, bc                                    ; $4C90
    ld a, [hl+]                                   ; $4C91
    dec a                                         ; $4C92
    call IdCard_NameGlyphAddr                     ; $4C93
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4C96
    ld c, $20                                     ; $4C99
    call Mul_8x8                                  ; $4C9B
    ld bc, $8de0                                  ; $4C9E
    add hl, bc                                    ; $4CA1
    ld bc, $0020                                  ; $4CA2
    ld a, $11                                     ; $4CA5
    call Vram_CopyHBlankFar                       ; $4CA7
    jp Far_Return                                 ; $4CAA


; C: DE = $6E50 + 32 x A (digit glyphs of bank $33)
IdCard_DigitGlyphAddr::
    ld c, $20                                     ; $4CAD
    call Mul_8x8                                  ; $4CAF
    ld de, $6e50                                  ; $4CB2
    add hl, de                                    ; $4CB5
    ld e, l                                       ; $4CB6
    ld d, h                                       ; $4CB7
    ret                                           ; $4CB8


; C: the 4 BCD bytes at $DAE9 as digit glyphs of bank $33 into tiles $8F00 (0 drawn as glyph $0A); the birthday (I);
; runs on its screen (0B:0F) in the core replays (port/entry_modes_kitty.csv); code read
IdCard_DrawBirthday::
    ld hl, wIdCard + $e                           ; $4CB9
    ld de, $8f00                                  ; $4CBC
    ld b, $04                                     ; $4CBF

jr_006_4cc1:
    push bc                                       ; $4CC1
    ld a, [hl]                                    ; $4CC2
    swap a                                        ; $4CC3
    and $0f                                       ; $4CC5
    dec a                                         ; $4CC7
    cp $ff                                        ; $4CC8
    jr nz, jr_006_4cce                            ; $4CCA

    ld a, $0a                                     ; $4CCC

jr_006_4cce:
    push hl                                       ; $4CCE
    push de                                       ; $4CCF
    call IdCard_DigitGlyphAddr                    ; $4CD0
    pop hl                                        ; $4CD3
    ld bc, $0020                                  ; $4CD4
    ld a, $33                                     ; $4CD7
    call Vram_CopyHBlankFar                       ; $4CD9
    ld e, l                                       ; $4CDC
    ld d, h                                       ; $4CDD
    pop hl                                        ; $4CDE
    ld a, [hl]                                    ; $4CDF
    and $0f                                       ; $4CE0
    dec a                                         ; $4CE2
    cp $ff                                        ; $4CE3
    jr nz, jr_006_4ce9                            ; $4CE5

    ld a, $0a                                     ; $4CE7

jr_006_4ce9:
    push hl                                       ; $4CE9
    push de                                       ; $4CEA
    call IdCard_DigitGlyphAddr                    ; $4CEB
    pop hl                                        ; $4CEE
    ld bc, $0020                                  ; $4CEF
    ld a, $33                                     ; $4CF2
    call Vram_CopyHBlankFar                       ; $4CF4
    ld e, l                                       ; $4CF7
    ld d, h                                       ; $4CF8
    pop hl                                        ; $4CF9
    inc hl                                        ; $4CFA
    pop bc                                        ; $4CFB
    dec b                                         ; $4CFC
    jr nz, jr_006_4cc1                            ; $4CFD

    jp Far_Return                                 ; $4CFF


; C: the same into the print buffer $CF00; mode $06 state $16; runs on its screen (06:16) in the core replays
; (port/entry_modes_kitty.csv); code read
IdCard_DrawBirthdayToPrintBuf::
    ld hl, wIdCard + $e                           ; $4D02
    ld de, $cf00                                  ; $4D05
    ld b, $04                                     ; $4D08

jr_006_4d0a:
    push bc                                       ; $4D0A
    ld a, [hl]                                    ; $4D0B
    swap a                                        ; $4D0C
    and $0f                                       ; $4D0E
    dec a                                         ; $4D10
    cp $ff                                        ; $4D11
    jr nz, jr_006_4d17                            ; $4D13

    ld a, $0a                                     ; $4D15

jr_006_4d17:
    push hl                                       ; $4D17
    push de                                       ; $4D18
    call IdCard_DigitGlyphAddr                    ; $4D19
    pop hl                                        ; $4D1C
    ld bc, $0020                                  ; $4D1D
    ld a, $33                                     ; $4D20
    call Copy_FarDEtoHL                           ; $4D22
    ld e, l                                       ; $4D25
    ld d, h                                       ; $4D26
    pop hl                                        ; $4D27
    ld a, [hl]                                    ; $4D28
    and $0f                                       ; $4D29
    dec a                                         ; $4D2B
    cp $ff                                        ; $4D2C
    jr nz, jr_006_4d32                            ; $4D2E

    ld a, $0a                                     ; $4D30

jr_006_4d32:
    push hl                                       ; $4D32
    push de                                       ; $4D33
    call IdCard_DigitGlyphAddr                    ; $4D34
    pop hl                                        ; $4D37
    ld bc, $0020                                  ; $4D38
    ld a, $33                                     ; $4D3B
    call Copy_FarDEtoHL                           ; $4D3D
    ld e, l                                       ; $4D40
    ld d, h                                       ; $4D41
    pop hl                                        ; $4D42
    inc hl                                        ; $4D43
    pop bc                                        ; $4D44
    dec b                                         ; $4D45
    jr nz, jr_006_4d0a                            ; $4D46

    jp Far_Return                                 ; $4D48


; C: the digit [$D97F] of $DAE9 while it is typed (mode $0B state $0C); runs on its screen (0B:0C) in the core replays
; (port/entry_modes_kitty.csv); code read
IdCard_DrawBirthdayDigit::
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4D4B
    sra a                                         ; $4D4E
    push af                                       ; $4D50
    ld c, a                                       ; $4D51
    ld b, $00                                     ; $4D52
    ld hl, wIdCard + $e                           ; $4D54
    add hl, bc                                    ; $4D57
    pop af                                        ; $4D58
    ld a, [hl+]                                   ; $4D59
    jr c, jr_006_4d5e                             ; $4D5A

    swap a                                        ; $4D5C

jr_006_4d5e:
    and $0f                                       ; $4D5E
    dec a                                         ; $4D60
    cp $ff                                        ; $4D61
    jr nz, jr_006_4d67                            ; $4D63

    ld a, $0a                                     ; $4D65

jr_006_4d67:
    call IdCard_DigitGlyphAddr                    ; $4D67
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4D6A
    ld c, $20                                     ; $4D6D
    call Mul_8x8                                  ; $4D6F
    ld bc, $8f00                                  ; $4D72
    add hl, bc                                    ; $4D75
    ld bc, $0020                                  ; $4D76
    ld a, $33                                     ; $4D79
    call Vram_CopyHBlankFar                       ; $4D7B
    jp Far_Return                                 ; $4D7E


; C: glyph ($DAE8 & 3) of 30:7FA0 into $8B70 (0 drawn as glyph 2); the blood type (I); runs in the name card editor
; (mode $0B)
IdCard_DrawBloodType::
    ld a, [wIdCard + $d]                          ; $4D81
    and $03                                       ; $4D84
    dec a                                         ; $4D86
    cp $ff                                        ; $4D87
    jr nz, jr_006_4d8d                            ; $4D89

    ld a, $02                                     ; $4D8B

jr_006_4d8d:
    ld c, $20                                     ; $4D8D
    call Mul_8x8                                  ; $4D8F
    ld de, Gfx_30_7FA0_Mode02_TakePhotos_State08  ; $4D92
    add hl, de                                    ; $4D95
    ld e, l                                       ; $4D96
    ld d, h                                       ; $4D97
    ld hl, $8b70                                  ; $4D98
    ld bc, $0020                                  ; $4D9B
    ld a, $30                                     ; $4D9E
    call Vram_CopyHBlankFar                       ; $4DA0
    jp Far_Return                                 ; $4DA3


; C: the same into the print buffer $CB70; runs on its screen (06:16) in the core replays
; (port/entry_modes_kitty.csv); code read
IdCard_DrawBloodTypeToPrintBuf::
    ld a, [wIdCard + $d]                          ; $4DA6
    and $03                                       ; $4DA9
    dec a                                         ; $4DAB
    cp $ff                                        ; $4DAC
    jr nz, jr_006_4db2                            ; $4DAE

    ld a, $02                                     ; $4DB0

jr_006_4db2:
    ld c, $20                                     ; $4DB2
    call Mul_8x8                                  ; $4DB4
    ld de, Gfx_30_7FA0_Mode02_TakePhotos_State08  ; $4DB7
    add hl, de                                    ; $4DBA
    ld e, l                                       ; $4DBB
    ld d, h                                       ; $4DBC
    ld hl, $cb70                                  ; $4DBD
    ld bc, $0020                                  ; $4DC0
    ld a, $30                                     ; $4DC3
    call Copy_FarDEtoHL                           ; $4DC5
    jp Far_Return                                 ; $4DC8


; C: glyph (($DAE8 >> 2) & 7) of 1D:7F40 into $8B90 (0 drawn as glyph 4); boy / girl (I); runs in the name card editor
; (mode $0B)
IdCard_DrawSex::
    ld a, [wIdCard + $d]                          ; $4DCB
    sra a                                         ; $4DCE
    sra a                                         ; $4DD0
    and $07                                       ; $4DD2
    dec a                                         ; $4DD4
    cp $ff                                        ; $4DD5
    jr nz, jr_006_4ddb                            ; $4DD7

    ld a, $04                                     ; $4DD9

jr_006_4ddb:
    ld c, $20                                     ; $4DDB
    call Mul_8x8                                  ; $4DDD
    ld de, Gfx_1D_7F40_Mode0B_NameCardEdit_State0A ; $4DE0
    add hl, de                                    ; $4DE3
    ld e, l                                       ; $4DE4
    ld d, h                                       ; $4DE5
    ld hl, $8b90                                  ; $4DE6
    ld bc, $0020                                  ; $4DE9
    ld a, $1d                                     ; $4DEC
    call Vram_CopyHBlankFar                       ; $4DEE
    jp Far_Return                                 ; $4DF1


; C: the same into the print buffer $CB90; runs on its screen (06:16) in the core replays
; (port/entry_modes_kitty.csv); code read
IdCard_DrawSexToPrintBuf::
    ld a, [wIdCard + $d]                          ; $4DF4
    sra a                                         ; $4DF7
    sra a                                         ; $4DF9
    and $07                                       ; $4DFB
    dec a                                         ; $4DFD
    cp $ff                                        ; $4DFE
    jr nz, jr_006_4e04                            ; $4E00

    ld a, $04                                     ; $4E02

jr_006_4e04:
    ld c, $20                                     ; $4E04
    call Mul_8x8                                  ; $4E06
    ld de, Gfx_1D_7F40_Mode0B_NameCardEdit_State0A ; $4E09
    add hl, de                                    ; $4E0C
    ld e, l                                       ; $4E0D
    ld d, h                                       ; $4E0E
    ld hl, $cb90                                  ; $4E0F
    ld bc, $0020                                  ; $4E12
    ld a, $1d                                     ; $4E15
    call Copy_FarDEtoHL                           ; $4E17
    jp Far_Return                                 ; $4E1A


; C: dispatch on the field being edited [$D97E] (0-4) and the position [$D97F]; mode $0B state $05; runs on its screen
; (0B:05) in the core replays (port/entry_modes_kitty.csv); code read
NameCardEdit_FieldAction::
    push af                                       ; $4E1D
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $4E1E
    cp $00                                        ; $4E21
    jp z, Jump_006_4e3d                           ; $4E23

    cp $01                                        ; $4E26
    jp z, Jump_006_4e63                           ; $4E28

    cp $02                                        ; $4E2B
    jp z, Jump_006_4e7a                           ; $4E2D

    cp $03                                        ; $4E30
    jp z, Jump_006_4e9c                           ; $4E32

    cp $04                                        ; $4E35
    jp z, Jump_006_4edd                           ; $4E37

    jp Far_Return                                 ; $4E3A


Jump_006_4e3d:
    pop af                                        ; $4E3D
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4E3E
    cp $00                                        ; $4E41
    jr z, jr_006_4e50                             ; $4E43

    cp $01                                        ; $4E45
    jr z, jr_006_4e50                             ; $4E47

    cp $02                                        ; $4E49
    jr z, jr_006_4e50                             ; $4E4B

    jp Far_Return                                 ; $4E4D


jr_006_4e50:
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4E50
    ld [wNameCardEdit_FieldAction_D980], a        ; $4E53
    ld a, $05                                     ; $4E56
    ldh [hState], a                               ; $4E58
    call Serial_SetFarCallback                    ; $4E5A

    dwb Far_ReturnJump

    jp Far_Return                                 ; $4E60


Jump_006_4e63:
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4E63
    ld c, a                                       ; $4E66
    ld b, $00                                     ; $4E67
    ld hl, wIdCard + $4                           ; $4E69
    add hl, bc                                    ; $4E6C
    pop af                                        ; $4E6D
    ld [hl], a                                    ; $4E6E
    ld b, BANK(IdCard_DrawNameChar)               ; $4E6F
    ld hl, IdCard_DrawNameChar                    ; $4E71
    call Far_Call                                 ; $4E74
    jp Far_Return                                 ; $4E77


Jump_006_4e7a:
    pop af                                        ; $4E7A
    cp $05                                        ; $4E7B
    jr nz, jr_006_4e80                            ; $4E7D

    xor a                                         ; $4E7F

jr_006_4e80:
    push af                                       ; $4E80
    ld hl, wIdCard + $d                           ; $4E81
    ld a, [hl]                                    ; $4E84
    and $03                                       ; $4E85
    ld [hl], a                                    ; $4E87
    pop af                                        ; $4E88
    and $07                                       ; $4E89
    sla a                                         ; $4E8B
    sla a                                         ; $4E8D
    or [hl]                                       ; $4E8F
    ld [hl], a                                    ; $4E90
    ld b, BANK(IdCard_DrawSex)                    ; $4E91
    ld hl, IdCard_DrawSex                         ; $4E93
    call Far_Call                                 ; $4E96
    jp Far_Return                                 ; $4E99


Jump_006_4e9c:
    pop af                                        ; $4E9C
    cp $0b                                        ; $4E9D
    jr c, jr_006_4ea3                             ; $4E9F

    ld a, $0b                                     ; $4EA1

jr_006_4ea3:
    push af                                       ; $4EA3
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $4EA4
    ld c, a                                       ; $4EA7
    sra c                                         ; $4EA8
    ld b, $00                                     ; $4EAA
    ld hl, wIdCard + $e                           ; $4EAC
    add hl, bc                                    ; $4EAF
    and $01                                       ; $4EB0
    jr z, jr_006_4ebf                             ; $4EB2

    ld a, [hl]                                    ; $4EB4
    and $f0                                       ; $4EB5
    ld [hl], a                                    ; $4EB7
    pop af                                        ; $4EB8
    and $0f                                       ; $4EB9
    or [hl]                                       ; $4EBB
    ld [hl], a                                    ; $4EBC
    jr jr_006_4eca                                ; $4EBD

jr_006_4ebf:
    ld a, [hl]                                    ; $4EBF
    and $0f                                       ; $4EC0
    ld [hl], a                                    ; $4EC2
    pop af                                        ; $4EC3
    and $0f                                       ; $4EC4
    swap a                                        ; $4EC6
    or [hl]                                       ; $4EC8
    ld [hl], a                                    ; $4EC9

jr_006_4eca:
    ld b, BANK(IdCard_DrawBirthdayDigit)          ; $4ECA
    ld hl, IdCard_DrawBirthdayDigit               ; $4ECC
    call Far_Call                                 ; $4ECF
    ld b, BANK(IdCard_ZeroDigitsToBlank)          ; $4ED2
    ld hl, IdCard_ZeroDigitsToBlank               ; $4ED4
    call Far_Call                                 ; $4ED7
    jp Far_Return                                 ; $4EDA


Jump_006_4edd:
    pop af                                        ; $4EDD
    cp $03                                        ; $4EDE
    jr nz, jr_006_4ee3                            ; $4EE0

    xor a                                         ; $4EE2

jr_006_4ee3:
    push af                                       ; $4EE3
    ld hl, wIdCard + $d                           ; $4EE4
    ld a, [hl]                                    ; $4EE7
    and $1c                                       ; $4EE8
    ld [hl], a                                    ; $4EEA
    pop af                                        ; $4EEB
    and $03                                       ; $4EEC
    or [hl]                                       ; $4EEE
    ld [hl], a                                    ; $4EEF
    ld b, BANK(IdCard_DrawBloodType)              ; $4EF0
    ld hl, IdCard_DrawBloodType                   ; $4EF2
    call Far_Call                                 ; $4EF5
    jp Far_Return                                 ; $4EF8


; C: in the 8 bytes from $DAE9 every 0 nibble becomes $B (the blank digit), by 06:4F15 / 06:4F1C
IdCard_ZeroDigitsToBlank::
    ld hl, wIdCard + $e                           ; $4EFB
    ld b, $08                                     ; $4EFE

jr_006_4f00:
    push bc                                       ; $4F00
    ld a, [hl]                                    ; $4F01
    and $f0                                       ; $4F02
    call z, Digit_HighZeroToBlank                 ; $4F04
    ld a, [hl]                                    ; $4F07
    and $0f                                       ; $4F08
    call z, Digit_LowZeroToBlank                  ; $4F0A
    inc hl                                        ; $4F0D
    pop bc                                        ; $4F0E
    dec b                                         ; $4F0F
    jr nz, jr_006_4f00                            ; $4F10

    jp Far_Return                                 ; $4F12


; C: [HL] high nibble = $B
Digit_HighZeroToBlank::
    ld a, [hl]                                    ; $4F15
    and $0f                                       ; $4F16
    or $b0                                        ; $4F18
    ld [hl], a                                    ; $4F1A
    ret                                           ; $4F1B


; C: [HL] low nibble = $B
Digit_LowZeroToBlank::
    ld a, [hl]                                    ; $4F1C
    and $f0                                       ; $4F1D
    or $0b                                        ; $4F1F
    ld [hl], a                                    ; $4F21
    ret                                           ; $4F22


; C: 10 glyphs (320 B) of bank $12 from $6000 + $A0 x [$D982] into tiles $8000
NameCardEdit_LoadKanaPage::
    ld bc, $00a0                                  ; $4F23
    ld a, [wNameCardEdit_PhotoCursorUpdate_D982]  ; $4F26
    call Mul_8x16                                 ; $4F29
    ld de, Gfx_12_5FE0_Mode0B_NameCardEdit_State08 + $20 ; $4F2C
    add hl, de                                    ; $4F2F
    ld e, l                                       ; $4F30
    ld d, h                                       ; $4F31
    ld hl, $8000                                  ; $4F32
    ld bc, $0140                                  ; $4F35
    ld a, $12                                     ; $4F38
    call Vram_CopyHBlankFar                       ; $4F3A
    jp Far_Return                                 ; $4F3D


; C: 10 glyphs of bank $33 from $6E50 + $A0 x [$D982] into tiles $8000
NameCardEdit_LoadDigitPage::
    ld bc, $00a0                                  ; $4F40
    ld a, [wNameCardEdit_PhotoCursorUpdate_D982]  ; $4F43
    call Mul_8x16                                 ; $4F46
    ld de, Gfx_33_6E50_Mode0B_NameCardEdit_State0C ; $4F49
    add hl, de                                    ; $4F4C
    ld e, l                                       ; $4F4D
    ld d, h                                       ; $4F4E
    ld hl, $8000                                  ; $4F4F
    ld bc, $0140                                  ; $4F52
    ld a, $33                                     ; $4F55
    call Vram_CopyHBlankFar                       ; $4F57
    jp Far_Return                                 ; $4F5A


; C: 3 glyphs of 30:7FA0 into $8000
NameCardEdit_LoadBloodGlyphs::
    ld de, Gfx_30_7FA0_Mode02_TakePhotos_State08  ; $4F5D
    ld hl, $8000                                  ; $4F60
    ld bc, $0060                                  ; $4F63
    ld a, $30                                     ; $4F66
    call Vram_CopyHBlankFar                       ; $4F68
    jp Far_Return                                 ; $4F6B


; C: 5 glyphs of 1D:7F40 into $8000
NameCardEdit_LoadSexGlyphs::
    ld de, Gfx_1D_7F40_Mode0B_NameCardEdit_State0A ; $4F6E
    ld hl, $8000                                  ; $4F71
    ld bc, $00a0                                  ; $4F74
    ld a, $1d                                     ; $4F77
    call Vram_CopyHBlankFar                       ; $4F79
    jp Far_Return                                 ; $4F7C


; C: the glyph page of field [$D97E]: kana (06:4F23), digits (06:4F40), blood type (06:4F5D), boy / girl (06:4F6E)
NameCardEdit_LoadFieldGlyphs::
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $4F7F
    cp $00                                        ; $4F82
    jr z, jr_006_4f96                             ; $4F84

    cp $01                                        ; $4F86
    jr z, jr_006_4f99                             ; $4F88

    cp $02                                        ; $4F8A
    jr z, jr_006_4fa4                             ; $4F8C

    cp $03                                        ; $4F8E
    jr z, jr_006_4faf                             ; $4F90

    cp $04                                        ; $4F92
    jr z, jr_006_4fba                             ; $4F94

jr_006_4f96:
    jp Far_Return                                 ; $4F96


jr_006_4f99:
    ld b, BANK(NameCardEdit_LoadKanaPage)         ; $4F99
    ld hl, NameCardEdit_LoadKanaPage              ; $4F9B
    call Far_Call                                 ; $4F9E
    jp Far_Return                                 ; $4FA1


jr_006_4fa4:
    ld b, BANK(NameCardEdit_LoadSexGlyphs)        ; $4FA4
    ld hl, NameCardEdit_LoadSexGlyphs             ; $4FA6
    call Far_Call                                 ; $4FA9
    jp Far_Return                                 ; $4FAC


jr_006_4faf:
    ld b, BANK(NameCardEdit_LoadDigitPage)        ; $4FAF
    ld hl, NameCardEdit_LoadDigitPage             ; $4FB1
    call Far_Call                                 ; $4FB4
    jp Far_Return                                 ; $4FB7


jr_006_4fba:
    ld b, BANK(NameCardEdit_LoadBloodGlyphs)      ; $4FBA
    ld hl, NameCardEdit_LoadBloodGlyphs           ; $4FBC
    call Far_Call                                 ; $4FBF
    jp Far_Return                                 ; $4FC2


; C: reads SRAM bank 0 from $A030, packs pairs of pixels (2:1) into $C000 (7 x 2 x 5 tiles); the photo of the card
; (mode $0B state $04); runs on its screen (0B:04) in the core replays (port/entry_modes_kitty.csv); code read
NameCardEdit_ShrinkPhoto::
    ldh a, [hSram_Format_FF8C]                    ; $4FC5
    push af                                       ; $4FC7
    ld a, $00                                     ; $4FC8
    ldh [hSram_Format_FF8C], a                    ; $4FCA
    ld [rRAMB], a                                 ; $4FCC
    ld de, $a030                                  ; $4FCF
    ld hl, $c000                                  ; $4FD2
    ld c, $07                                     ; $4FD5

Jump_006_4fd7:
    push bc                                       ; $4FD7
    ld c, $02                                     ; $4FD8

Jump_006_4fda:
    push bc                                       ; $4FDA
    ld c, $05                                     ; $4FDB

jr_006_4fdd:
    push bc                                       ; $4FDD
    push hl                                       ; $4FDE
    ld bc, $0004                                  ; $4FDF

jr_006_4fe2:
    ld a, [de]                                    ; $4FE2
    rla                                           ; $4FE3
    rl b                                          ; $4FE4
    rla                                           ; $4FE6
    rla                                           ; $4FE7
    rl b                                          ; $4FE8
    rla                                           ; $4FEA
    rla                                           ; $4FEB
    rl b                                          ; $4FEC
    rla                                           ; $4FEE
    rla                                           ; $4FEF
    rl b                                          ; $4FF0
    ld a, b                                       ; $4FF2
    swap a                                        ; $4FF3
    and $f0                                       ; $4FF5
    ld [hl+], a                                   ; $4FF7
    inc de                                        ; $4FF8
    ld a, [de]                                    ; $4FF9
    rla                                           ; $4FFA
    rl b                                          ; $4FFB
    rla                                           ; $4FFD
    rla                                           ; $4FFE
    rl b                                          ; $4FFF
    rla                                           ; $5001
    rla                                           ; $5002
    rl b                                          ; $5003
    rla                                           ; $5005
    rla                                           ; $5006
    rl b                                          ; $5007
    ld a, b                                       ; $5009
    swap a                                        ; $500A
    and $f0                                       ; $500C
    ld [hl+], a                                   ; $500E
    inc de                                        ; $500F
    inc de                                        ; $5010
    inc de                                        ; $5011
    dec c                                         ; $5012
    jr nz, jr_006_4fe2                            ; $5013

    pop hl                                        ; $5015
    ld bc, $0004                                  ; $5016

jr_006_5019:
    ld a, [de]                                    ; $5019
    rla                                           ; $501A
    rl b                                          ; $501B
    rla                                           ; $501D
    rla                                           ; $501E
    rl b                                          ; $501F
    rla                                           ; $5021
    rla                                           ; $5022
    rl b                                          ; $5023
    rla                                           ; $5025
    rla                                           ; $5026
    rl b                                          ; $5027
    ld a, b                                       ; $5029
    and $0f                                       ; $502A
    or [hl]                                       ; $502C
    ld [hl+], a                                   ; $502D
    inc de                                        ; $502E
    ld a, [de]                                    ; $502F
    rla                                           ; $5030
    rl b                                          ; $5031
    rla                                           ; $5033
    rla                                           ; $5034
    rl b                                          ; $5035
    rla                                           ; $5037
    rla                                           ; $5038
    rl b                                          ; $5039
    rla                                           ; $503B
    rla                                           ; $503C
    rl b                                          ; $503D
    ld a, b                                       ; $503F
    and $0f                                       ; $5040
    or [hl]                                       ; $5042
    ld [hl+], a                                   ; $5043
    inc de                                        ; $5044
    inc de                                        ; $5045
    inc de                                        ; $5046
    dec c                                         ; $5047
    jr nz, jr_006_5019                            ; $5048

    ld bc, $0008                                  ; $504A
    add hl, bc                                    ; $504D
    pop bc                                        ; $504E
    dec c                                         ; $504F
    jr nz, jr_006_4fdd                            ; $5050

    push hl                                       ; $5052
    ld l, e                                       ; $5053
    ld h, d                                       ; $5054
    ld bc, $0060                                  ; $5055
    add hl, bc                                    ; $5058
    ld e, l                                       ; $5059
    ld d, h                                       ; $505A
    pop hl                                        ; $505B
    ld bc, hPrevOrSign                            ; $505C
    add hl, bc                                    ; $505F
    pop bc                                        ; $5060
    dec c                                         ; $5061
    jp nz, Jump_006_4fda                          ; $5062

    ld bc, $0040                                  ; $5065
    add hl, bc                                    ; $5068
    pop bc                                        ; $5069
    dec c                                         ; $506A
    jp nz, Jump_006_4fd7                          ; $506B

    pop af                                        ; $506E
    ldh [hSram_Format_FF8C], a                    ; $506F
    ld [rRAMB], a                                 ; $5071
    jp Far_Return                                 ; $5074


; C: screen off, clears the objects and script slots, loads the tiles and maps of the editor again; first run in mode
; $0B state $0F; runs on its screen (0B:0F) in the core replays (port/entry_modes_kitty.csv); code read
NameCardEdit_RedrawScreen::
    di                                            ; $5077
    call Lcd_Off                                  ; $5078
    call Oam_ClearShadow                          ; $507B
    ld b, BANK(Objects_ClearAll)                  ; $507E
    ld hl, Objects_ClearAll                       ; $5080
    call Far_Call                                 ; $5083
    ld b, BANK(ScriptSlots_Clear)                 ; $5086
    ld hl, ScriptSlots_Clear                      ; $5088
    call Far_Call                                 ; $508B
    call Copy_FarInline                           ; $508E

    db $00, $40, $17, $00, $80, $00, $18

    call Copy_FarInline                           ; $5098

    db $40, $72, $22, $00, $98, $00, $04

    ld b, BANK(Sram_LoadCardPhotos)               ; $50A2
    ld hl, Sram_LoadCardPhotos                    ; $50A4
    call Far_Call                                 ; $50A7
    ld a, [wMode0B_State02_D8F9]                  ; $50AA
    ld [wMenu07_CursorUpdate_D8F4], a             ; $50AD
    xor a                                         ; $50B0
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $50B1
    xor a                                         ; $50B4
    ld [wNameCardEdit_RedrawScreen_D988], a       ; $50B5
    ld [wNameCardEdit_RedrawScreen_D98A], a       ; $50B8
    ld a, $88                                     ; $50BB
    ld [wNameCardEdit_PhotoCursorUpdate_D984], a  ; $50BD
    call Stat_SetTileToggleAt47                   ; $50C0
    call Serial_SetFarCallback                    ; $50C3

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $50C9

    db $e3, $e4, $d0, $e4, $00, $00, $00, $90, $ff, $40, $03

    call Keys_SetRepeatInline                     ; $50D7

    dw $0214

    push af                                       ; $50DC
    ld a, MUSIC_NAME_CARD_EDIT                    ; $50DD
    ld [wSndMusicReq], a                          ; $50DF
    pop af                                        ; $50E2
    ei                                            ; $50E3
    ld b, BANK(IdCard_DrawName)                   ; $50E4
    ld hl, IdCard_DrawName                        ; $50E6
    call Far_Call                                 ; $50E9
    ld b, BANK(IdCard_DrawBirthday)               ; $50EC
    ld hl, IdCard_DrawBirthday                    ; $50EE
    call Far_Call                                 ; $50F1
    ld b, BANK(IdCard_DrawBloodType)              ; $50F4
    ld hl, IdCard_DrawBloodType                   ; $50F6
    call Far_Call                                 ; $50F9
    ld b, BANK(IdCard_DrawSex)                    ; $50FC
    ld hl, IdCard_DrawSex                         ; $50FE
    call Far_Call                                 ; $5101
    ret                                           ; $5104


; C: handler of state $00 of mode $0B (word 0 of Mode0B_StateTable)
Mode0B_State00::
    call NameCardEdit_RedrawScreen                ; $5105
    ld de, ObjScript_02_79CD_Mode0B_NameCardEdit_State10 + $A ; $5108
    call Object_Create                            ; $510B
    ld de, ObjScript_02_7BC2_Mode0B_NameCardEdit_State10 ; $510E
    call Object_Create                            ; $5111
    ld b, MODE_NAME_CARD_EDIT                     ; $5114
    ld c, $02                                     ; $5116
    call Fade_GoTo                                ; $5118
    ret                                           ; $511B


; C: handler of state $01 of mode $0B (word 1 of Mode0B_StateTable)
Mode0B_State01::
    ld b, BANK(Objects_ClearAll)                  ; $511C
    ld hl, Objects_ClearAll                       ; $511E
    call Far_Call                                 ; $5121
    ld a, BANK(Mode06_State18)                    ; $5124
    ld [wFadeRunning], a                          ; $5126
    ld de, Mode06_State18 + $1A                   ; $5129
    ld hl, $9800                                  ; $512C
    ld bc, $0160                                  ; $512F
    ld a, $22                                     ; $5132
    call Vram_CopyHBlankFar                       ; $5134
    ld de, $0000                                  ; $5137
    ld hl, $8bb0                                  ; $513A
    ld bc, $0230                                  ; $513D
    call Vram_FillSafe                            ; $5140
    ld a, $00                                     ; $5143
    ld [wStamp_ObjSlideIn_D994], a                ; $5145
    ld hl, wNameCardEdit_PhotoCursorUpdate_D981   ; $5148
    res 0, [hl]                                   ; $514B
    ld b, BANK(Sram_LoadCardPhotos)               ; $514D
    ld hl, Sram_LoadCardPhotos                    ; $514F
    call Far_Call                                 ; $5152
    ld b, BANK(Counters_Load)                     ; $5155
    ld hl, Counters_Load                          ; $5157
    call Far_Call                                 ; $515A
    ld a, [wMode0B_State02_D8F9]                  ; $515D
    ld [wMenu07_CursorUpdate_D8F4], a             ; $5160
    ld a, [wNameCardMade]                         ; $5163
    and a                                         ; $5166
    jr nz, jr_006_51c4                            ; $5167

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5169
    and a                                         ; $516C
    jr z, jr_006_5199                             ; $516D

    ld c, a                                       ; $516F
    ld b, $00                                     ; $5170
    ld hl, Mode0B_State01_Tbl51DA                 ; $5172
    add hl, bc                                    ; $5175
    ld a, [hl]                                    ; $5176
    ld [wNameCardEdit_PhotoCursorUpdate_D97D], a  ; $5177
    ld c, a                                       ; $517A
    ld b, $00                                     ; $517B
    ld de, ObjScript_02_7BD4_Mode0B_NameCardEdit_State10 ; $517D
    call Object_CreateWithParam                   ; $5180
    ld de, ObjScript_02_79CD_Mode0B_NameCardEdit_State10 + $A ; $5183
    call Object_Create                            ; $5186
    ld de, ObjScript_02_7BC2_Mode0B_NameCardEdit_State10 ; $5189
    call Object_Create                            ; $518C
    call ModeState_SetInline                      ; $518F

    db MODE_NAME_CARD_EDIT, STATE_0B_NAME_CARD_TAKE_YOUR_PHOTO

    xor a                                         ; $5194
    ld [wFadeRunning], a                          ; $5195
    ret                                           ; $5198


jr_006_5199:
    push hl                                       ; $5199
    ld hl, wMode06_State0A_D896                   ; $519A
    set 0, [hl]                                   ; $519D
    pop hl                                        ; $519F
    ld a, $ff                                     ; $51A0
    ld [wNameCardMade], a                         ; $51A2
    ld b, BANK(Counters_Store)                    ; $51A5
    ld hl, Counters_Store                         ; $51A7
    call Far_Call                                 ; $51AA
    ld b, BANK(NameCard_MakeIdNumber)             ; $51AD
    ld hl, NameCard_MakeIdNumber                  ; $51AF
    call Far_Call                                 ; $51B2
    push hl                                       ; $51B5
    ld hl, wMode06_State0A_D896                   ; $51B6
    res 0, [hl]                                   ; $51B9
    pop hl                                        ; $51BB
    ld b, MODE_NAME_CARD                          ; $51BC
    ld c, $00                                     ; $51BE
    call Fade_GoToB                               ; $51C0
    ret                                           ; $51C3


jr_006_51c4:
    ld de, ObjScript_02_79CD_Mode0B_NameCardEdit_State10 + $A ; $51C4
    call Object_Create                            ; $51C7
    ld de, ObjScript_02_7BC2_Mode0B_NameCardEdit_State10 ; $51CA
    call Object_Create                            ; $51CD
    call ModeState_SetInline                      ; $51D0

    db MODE_NAME_CARD_EDIT, $02

    xor a                                         ; $51D5
    ld [wFadeRunning], a                          ; $51D6
    ret                                           ; $51D9


; C: named by the code of Mode0B_State01 (06:5172); read in the runs by Mode0B_State01; first read on the screen
; Mode0B_NameCardEdit_State10 (trace/read_screens_kitty*.npz)
Mode0B_State01_Tbl51DA::
    db $00, $00, $05, $10, $13, $1d

; C: handler of state $02 of mode $0B (word 2 of Mode0B_StateTable)
Mode0B_State02::
    ld a, [wStamp_ObjSlideIn_D994]                ; $51E0
    cp $00                                        ; $51E3
    jr nz, jr_006_5219                            ; $51E5

    ld a, [wKeysNew]                              ; $51E7
    bit PADB_B, a                                 ; $51EA
    jr z, jr_006_5219                             ; $51EC

    push af                                       ; $51EE
    ld a, SFX3_09                                 ; $51EF
    ld [wSndSfx3], a                              ; $51F1
    pop af                                        ; $51F4
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $51F5
    ld [wMode0B_State02_D8F9], a                  ; $51F8
    push hl                                       ; $51FB
    ld hl, wMode06_State0A_D896                   ; $51FC
    set 0, [hl]                                   ; $51FF
    pop hl                                        ; $5201
    ld b, BANK(NameCard_MakeIdNumber)             ; $5202
    ld hl, NameCard_MakeIdNumber                  ; $5204
    call Far_Call                                 ; $5207
    push hl                                       ; $520A
    ld hl, wMode06_State0A_D896                   ; $520B
    res 0, [hl]                                   ; $520E
    pop hl                                        ; $5210
    ld b, MODE_NAME_CARD                          ; $5211
    ld c, $00                                     ; $5213
    call Fade_GoToB                               ; $5215
    ret                                           ; $5218


jr_006_5219:
    ld a, [wMode07_StateTable_D8E0]               ; $5219
    bit 0, a                                      ; $521C
    jr z, jr_006_5236                             ; $521E

    push af                                       ; $5220
    ld a, SFX1_19                                 ; $5221
    ld [wSndSfx1], a                              ; $5223
    pop af                                        ; $5226
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5227
    ld [wMode0B_State02_D8F9], a                  ; $522A
    ld b, MODE_NAME_CARD_EDIT                     ; $522D
    ldh a, [hMenuState]                           ; $522F
    ld c, a                                       ; $5231
    call ModeState_Set                            ; $5232
    ret                                           ; $5235


jr_006_5236:
    ret                                           ; $5236


; C: Object_RunAll, 00:21BE, 00:03D5, Far_Return (as Bank05_FrameUpdate)
Bank06_FrameUpdate::
    ld b, $00                                     ; $5237
    ld hl, Object_RunAll                          ; $5239
    call Far_Call                                 ; $523C
    call Objects_DrawAll                          ; $523F
    call Oam_HideUnused                           ; $5242
    jp Far_Return                                 ; $5245


; C: Bank06_FrameUpdate then a callback change when $D8E0 bit 0 is set; runs on its screen (0B:04) in the core replays
; (port/entry_modes_kitty.csv); code read
Bank06_FrameCallback::
    ld b, BANK(Bank06_FrameUpdate)                ; $5248
    ld hl, Bank06_FrameUpdate                     ; $524A
    call Far_Call                                 ; $524D
    ld a, [wMode07_StateTable_D8E0]               ; $5250
    bit 0, a                                      ; $5253
    jr z, jr_006_5267                             ; $5255

    call Serial_SetFarCallback                    ; $5257

    dwb Bank06_FrameUpdate

    ld b, MODE_NAME_CARD_EDIT                     ; $525D
    ld c, $06                                     ; $525F
    call ModeState_Set                            ; $5261
    jp Far_Return                                 ; $5264


jr_006_5267:
    jp Far_Return                                 ; $5267


; C: handler of state $03 of mode $0B (word 3 of Mode0B_StateTable)
Mode0B_State03::
    ld de, Map_22_7640_Mode0B_NameCardEdit_State04 ; $526A
    ld hl, $9800                                  ; $526D
    ld bc, $0160                                  ; $5270
    ld a, $22                                     ; $5273
    call Vram_CopyHBlankFar                       ; $5275
    ld de, Map_22_7A40_Mode0B_NameCardEdit_State03 ; $5278
    ld hl, $9c00                                  ; $527B
    ld bc, $0100                                  ; $527E
    ld a, $22                                     ; $5281
    call Vram_CopyHBlankFar                       ; $5283
    ld de, Gfx_1B_5800_Mode0B_NameCardEdit_State04 ; $5286
    ld hl, $8800                                  ; $5289
    ld bc, $00e0                                  ; $528C
    ld a, $1b                                     ; $528F
    call Vram_CopyHBlankFar                       ; $5291
    ld a, $01                                     ; $5294
    ld [wStamp_ObjSlideIn_D994], a                ; $5296
    ld hl, wNameCardEdit_PhotoCursorUpdate_D981   ; $5299
    set 0, [hl]                                   ; $529C
    ld a, $01                                     ; $529E
    ld [wNameCardEdit_PhotoCursorUpdate_D985], a  ; $52A0
    ld a, $02                                     ; $52A3
    ld [wNameCardEdit_PhotoCursorUpdate_D986], a  ; $52A5
    xor a                                         ; $52A8
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $52A9
    ld [wNameCardEdit_PhotoCursorUpdate_D982], a  ; $52AC
    xor a                                         ; $52AF
    ld [wNameCardEdit_PhotoCursorUpdate_D983], a  ; $52B0
    ld a, $07                                     ; $52B3
    ld [wCamBrightnessSetpoint], a                ; $52B5
    ld a, $08                                     ; $52B8
    ld [wCamContrastRow], a                       ; $52BA
    ld a, $01                                     ; $52BD
    ld [wCamDitherMode], a                        ; $52BF
    ld a, [wCamContrastRow]                       ; $52C2
    ld c, a                                       ; $52C5
    ld a, [wCamGainSel]                           ; $52C6
    ld b, a                                       ; $52C9
    ld b, BANK(Cam_BuildDitherMatrix_Far)         ; $52CA
    ld hl, Cam_BuildDitherMatrix_Far              ; $52CC
    call Far_CallKeepA                            ; $52CF
    ld de, ObjScript_02_7A35_NameCardEdit_ObjFieldTick + $40 ; $52D2
    call Object_Create                            ; $52D5
    ld de, ObjScript_02_7B22_Mode0B_NameCardEdit_State04 + $2B ; $52D8
    call Object_Create                            ; $52DB
    ld de, ObjScript_02_7B7B_Mode0B_NameCardEdit_State10 ; $52DE
    call Object_Create                            ; $52E1
    call Serial_SetFarCallback                    ; $52E4

    dwb Bank06_FrameCallback

    call ModeState_SetInline                      ; $52EA

    dw Rng_Init

    ret                                           ; $52EF


; C: handler of state $04 of mode $0B (word 4 of Mode0B_StateTable)
Mode0B_State04::
    ldh a, [hSram_Format_FF8C]                    ; $52F0
    push af                                       ; $52F2
    ld b, BANK(NameCardEdit_ShrinkPhoto)          ; $52F3
    ld hl, NameCardEdit_ShrinkPhoto               ; $52F5
    call Far_Call                                 ; $52F8
    ld a, $10                                     ; $52FB
    ldh [hSram_Format_FF8C], a                    ; $52FD
    ld [rRAMB], a                                 ; $52FF
    ld a, [wCamA000Shadow]                        ; $5302
    set 0, a                                      ; $5305
    ld [$a000], a                                 ; $5307
    ld de, $c000                                  ; $530A
    ld hl, wMode0B_State04_D400                   ; $530D
    ld bc, $0050                                  ; $5310
    call Copy_DEtoHL                              ; $5313
    ld de, $000e                                  ; $5316
    ld hl, wMode0B_State04_D400                   ; $5319
    ld a, $ff                                     ; $531C
    ld c, $05                                     ; $531E

jr_006_5320:
    ld [hl+], a                                   ; $5320
    ld [hl+], a                                   ; $5321
    add hl, de                                    ; $5322
    dec c                                         ; $5323
    jr nz, jr_006_5320                            ; $5324

    ld de, wMode0B_State04_D400                   ; $5326
    ld hl, $8bb0                                  ; $5329
    ld bc, $0050                                  ; $532C
    call Vram_CopyHBlank                          ; $532F
    ld de, $c050                                  ; $5332
    ld hl, $8c00                                  ; $5335
    ld bc, $01e0                                  ; $5338
    call Vram_CopyHBlank                          ; $533B
    ld a, $10                                     ; $533E
    ldh [hSram_Format_FF8C], a                    ; $5340
    ld [rRAMB], a                                 ; $5342

jr_006_5345:
    ld hl, $a000                                  ; $5345
    bit 0, [hl]                                   ; $5348
    jr nz, jr_006_5345                            ; $534A

    ld a, [wCamBrightnessSetpoint]                ; $534C
    ld b, BANK(Cam_PopcountLevelByIndex)          ; $534F
    ld hl, Cam_PopcountLevelByIndex               ; $5351
    call Far_CallKeepA                            ; $5354
    ld a, [wCamContrastRow]                       ; $5357
    ld c, a                                       ; $535A
    ld a, [wCamGainSel]                           ; $535B
    ld b, a                                       ; $535E
    ld b, BANK(Cam_BuildDitherMatrix_Far)         ; $535F
    ld hl, Cam_BuildDitherMatrix_Far              ; $5361
    call Far_CallKeepA                            ; $5364
    pop af                                        ; $5367
    ldh [hSram_Format_FF8C], a                    ; $5368
    ld [rRAMB], a                                 ; $536A
    ret                                           ; $536D


; C: handler of state $05 of mode $0B (word 5 of Mode0B_StateTable)
Mode0B_State05::
    ld a, [wNameCardEdit_FieldAction_D980]        ; $536E
    cp $00                                        ; $5371
    jr z, jr_006_537e                             ; $5373

    cp $01                                        ; $5375
    jr z, jr_006_5398                             ; $5377

    cp $02                                        ; $5379
    jr z, jr_006_53b2                             ; $537B

    ret                                           ; $537D


jr_006_537e:
    ld de, $c000                                  ; $537E
    ld hl, $c230                                  ; $5381
    ld bc, $0230                                  ; $5384
    call Copy_DEtoHL                              ; $5387
    ld de, $c000                                  ; $538A
    ld hl, $9170                                  ; $538D
    ld bc, $0230                                  ; $5390
    call Vram_CopyHBlank                          ; $5393
    jr jr_006_53cc                                ; $5396

jr_006_5398:
    ld de, $c000                                  ; $5398
    ld hl, $c460                                  ; $539B
    ld bc, $0230                                  ; $539E
    call Copy_DEtoHL                              ; $53A1
    ld de, $c000                                  ; $53A4
    ld hl, $93a0                                  ; $53A7
    ld bc, $0230                                  ; $53AA
    call Vram_CopyHBlank                          ; $53AD
    jr jr_006_53cc                                ; $53B0

jr_006_53b2:
    ld de, $c000                                  ; $53B2
    ld hl, $c690                                  ; $53B5
    ld bc, $0230                                  ; $53B8
    call Copy_DEtoHL                              ; $53BB
    ld de, $c000                                  ; $53BE
    ld hl, $95d0                                  ; $53C1
    ld bc, $0230                                  ; $53C4
    call Vram_CopyHBlank                          ; $53C7
    jr jr_006_53cc                                ; $53CA

jr_006_53cc:
    ld a, $04                                     ; $53CC
    ldh [hState], a                               ; $53CE
    call Serial_SetFarCallback                    ; $53D0

    dwb Bank06_FrameCallback

    ret                                           ; $53D6


; C: handler of state $06 of mode $0B (word 6 of Mode0B_StateTable)
Mode0B_State06::
    push hl                                       ; $53D7
    ld hl, wMode06_State0A_D896                   ; $53D8
    set 0, [hl]                                   ; $53DB
    pop hl                                        ; $53DD
    ld b, BANK(Sram_StoreCardPhotos)              ; $53DE
    ld hl, Sram_StoreCardPhotos                   ; $53E0
    call Far_Call                                 ; $53E3
    push hl                                       ; $53E6
    ld hl, wMode06_State0A_D896                   ; $53E7
    res 0, [hl]                                   ; $53EA
    pop hl                                        ; $53EC
    ld b, MODE_NAME_CARD_EDIT                     ; $53ED
    ld c, $01                                     ; $53EF
    call ModeState_Set                            ; $53F1
    ret                                           ; $53F4


; C: handler of state $08 of mode $0B (word 8 of Mode0B_StateTable)
Mode0B_State08::
    ld a, [wMode07_StateTable_D8E0]               ; $53F5
    bit 0, a                                      ; $53F8
    jr z, jr_006_5405                             ; $53FA

    ld b, MODE_NAME_CARD_EDIT                     ; $53FC
    ldh a, [hMenuState]                           ; $53FE
    ld c, a                                       ; $5400
    call ModeState_Set                            ; $5401
    ret                                           ; $5404


jr_006_5405:
    ret                                           ; $5405


; C: handler of state $07 of mode $0B (word 7 of Mode0B_StateTable)
Mode0B_State07::
    ld de, Map_22_7B40_Mode0B_NameCardEdit_State08 ; $5406
    ld hl, $9c00                                  ; $5409
    ld bc, $0100                                  ; $540C
    ld a, $22                                     ; $540F
    call Vram_CopyHBlankFar                       ; $5411
    ld de, Gfx_1B_5900_Mode0B_NameCardEdit_State08 ; $5414
    ld hl, $8800                                  ; $5417
    ld bc, $00e0                                  ; $541A
    ld a, $1b                                     ; $541D
    call Vram_CopyHBlankFar                       ; $541F
    ld a, $01                                     ; $5422
    ld [wStamp_ObjSlideIn_D994], a                ; $5424
    ld hl, wNameCardEdit_PhotoCursorUpdate_D981   ; $5427
    set 0, [hl]                                   ; $542A
    ld a, [wMode0B_State07_D987]                  ; $542C
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $542F
    ld a, $30                                     ; $5432
    ld [wNameCardEdit_PhotoCursorUpdate_D985], a  ; $5434
    ld a, $08                                     ; $5437
    ld [wNameCardEdit_PhotoCursorUpdate_D986], a  ; $5439
    ld a, [wNameCardEdit_RedrawScreen_D988]       ; $543C
    ld [wNameCardEdit_PhotoCursorUpdate_D982], a  ; $543F
    xor a                                         ; $5442
    ld [wNameCardEdit_PhotoCursorUpdate_D983], a  ; $5443
    ld de, ObjScript_02_7A35_NameCardEdit_ObjFieldTick + $40 ; $5446
    call Object_Create                            ; $5449
    ld de, ObjScript_02_7B22_Mode0B_NameCardEdit_State04 + $2B ; $544C
    call Object_Create                            ; $544F
    ld de, ObjScript_02_7B7B_Mode0B_NameCardEdit_State10 ; $5452
    call Object_Create                            ; $5455
    call ModeState_SetInline                      ; $5458

    db MODE_NAME_CARD_EDIT, STATE_0B_NAME_CARD_TYPE_YOUR_NAME

    ret                                           ; $545D


; C: handler of state $09 of mode $0B (word 9 of Mode0B_StateTable)
Mode0B_State09::
    ld de, Map_22_7D40_Mode0B_NameCardEdit_State0A ; $545E
    ld hl, $9c00                                  ; $5461
    ld bc, $0100                                  ; $5464
    ld a, $22                                     ; $5467
    call Vram_CopyHBlankFar                       ; $5469
    ld de, Gfx_1B_5B00_Mode0B_NameCardEdit_State0A ; $546C
    ld hl, $8800                                  ; $546F
    ld bc, $00e0                                  ; $5472
    ld a, $1b                                     ; $5475
    call Vram_CopyHBlankFar                       ; $5477
    ld a, $01                                     ; $547A
    ld [wStamp_ObjSlideIn_D994], a                ; $547C
    ld hl, wNameCardEdit_PhotoCursorUpdate_D981   ; $547F
    set 0, [hl]                                   ; $5482
    xor a                                         ; $5484
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $5485
    ld a, $01                                     ; $5488
    ld [wNameCardEdit_PhotoCursorUpdate_D985], a  ; $548A
    ld a, $00                                     ; $548D
    ld [wNameCardEdit_PhotoCursorUpdate_D986], a  ; $548F
    ld [wNameCardEdit_PhotoCursorUpdate_D982], a  ; $5492
    xor a                                         ; $5495
    ld [wNameCardEdit_PhotoCursorUpdate_D983], a  ; $5496
    ld de, ObjScript_02_7A35_NameCardEdit_ObjFieldTick + $40 ; $5499
    call Object_Create                            ; $549C
    ld de, ObjScript_02_7B22_Mode0B_NameCardEdit_State04 + $2B ; $549F
    call Object_Create                            ; $54A2
    ld de, ObjScript_02_7B7B_Mode0B_NameCardEdit_State10 ; $54A5
    call Object_Create                            ; $54A8
    call ModeState_SetInline                      ; $54AB

    db MODE_NAME_CARD_EDIT, STATE_0B_NAME_CARD_CHOOSE_BLOOD_TYPE

    ret                                           ; $54B0


; C: handler of state $0B of mode $0B (word 11 of Mode0B_StateTable)
Mode0B_State0B::
    ld de, Map_22_7C40_Mode0B_NameCardEdit_State0C ; $54B1
    ld hl, $9c00                                  ; $54B4
    ld bc, $0100                                  ; $54B7
    ld a, $22                                     ; $54BA
    call Vram_CopyHBlankFar                       ; $54BC
    ld de, Gfx_1B_5A00_Mode0B_NameCardEdit_State0C ; $54BF
    ld hl, $8800                                  ; $54C2
    ld bc, $00e0                                  ; $54C5
    ld a, $1b                                     ; $54C8
    call Vram_CopyHBlankFar                       ; $54CA
    ld a, $01                                     ; $54CD
    ld [wStamp_ObjSlideIn_D994], a                ; $54CF
    ld hl, wNameCardEdit_PhotoCursorUpdate_D981   ; $54D2
    set 0, [hl]                                   ; $54D5
    ld a, [wMode0B_State0B_D989]                  ; $54D7
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $54DA
    ld a, $02                                     ; $54DD
    ld [wNameCardEdit_PhotoCursorUpdate_D985], a  ; $54DF
    ld a, $07                                     ; $54E2
    ld [wNameCardEdit_PhotoCursorUpdate_D986], a  ; $54E4
    ld a, [wNameCardEdit_RedrawScreen_D98A]       ; $54E7
    ld [wNameCardEdit_PhotoCursorUpdate_D982], a  ; $54EA
    xor a                                         ; $54ED
    ld [wNameCardEdit_PhotoCursorUpdate_D983], a  ; $54EE
    ld de, ObjScript_02_7A35_NameCardEdit_ObjFieldTick + $40 ; $54F1
    call Object_Create                            ; $54F4
    ld de, ObjScript_02_7B22_Mode0B_NameCardEdit_State04 + $2B ; $54F7
    call Object_Create                            ; $54FA
    ld de, ObjScript_02_7B7B_Mode0B_NameCardEdit_State10 ; $54FD
    call Object_Create                            ; $5500
    call ModeState_SetInline                      ; $5503

    db MODE_NAME_CARD_EDIT, STATE_0B_NAME_CARD_TYPE_BIRTHDAY

    ret                                           ; $5508


; C: handler of state $0D of mode $0B (word 13 of Mode0B_StateTable)
Mode0B_State0D::
    ld de, Map_22_77A0_Mode0B_NameCardEdit_State0E ; $5509
    ld hl, $9c00                                  ; $550C
    ld bc, $0100                                  ; $550F
    ld a, $22                                     ; $5512
    call Vram_CopyHBlankFar                       ; $5514
    ld de, Gfx_1B_5C00_Mode0B_NameCardEdit_State0E ; $5517
    ld hl, $8800                                  ; $551A
    ld bc, $00e0                                  ; $551D
    ld a, $1b                                     ; $5520
    call Vram_CopyHBlankFar                       ; $5522
    ld a, $01                                     ; $5525
    ld [wStamp_ObjSlideIn_D994], a                ; $5527
    ld hl, wNameCardEdit_PhotoCursorUpdate_D981   ; $552A
    set 0, [hl]                                   ; $552D
    xor a                                         ; $552F
    ld [wNameCardEdit_PhotoCursorUpdate_D97F], a  ; $5530
    ld a, $01                                     ; $5533
    ld [wNameCardEdit_PhotoCursorUpdate_D985], a  ; $5535
    ld a, $00                                     ; $5538
    ld [wNameCardEdit_PhotoCursorUpdate_D986], a  ; $553A
    ld [wNameCardEdit_PhotoCursorUpdate_D982], a  ; $553D
    xor a                                         ; $5540
    ld [wNameCardEdit_PhotoCursorUpdate_D983], a  ; $5541
    ld de, ObjScript_02_7A35_NameCardEdit_ObjFieldTick + $40 ; $5544
    call Object_Create                            ; $5547
    ld de, ObjScript_02_7B22_Mode0B_NameCardEdit_State04 + $2B ; $554A
    call Object_Create                            ; $554D
    ld de, ObjScript_02_7B7B_Mode0B_NameCardEdit_State10 ; $5550
    call Object_Create                            ; $5553
    call ModeState_SetInline                      ; $5556

    db MODE_NAME_CARD_EDIT, STATE_0B_NAME_CARD_CHOOSE_BOY_OR

    ret                                           ; $555B


; C: handler of state $0F of mode $0B (word 15 of Mode0B_StateTable)
Mode0B_State0F::
    call NameCardEdit_RedrawScreen                ; $555C
    ld a, $01                                     ; $555F
    ld [wMenu07_CursorUpdate_D8F4], a             ; $5561
    xor a                                         ; $5564
    ld [wNameCardEdit_PhotoCursorUpdate_D97D], a  ; $5565
    ld bc, $0000                                  ; $5568
    ld de, ObjScript_02_7BD4_Mode0B_NameCardEdit_State10 ; $556B
    call Object_CreateWithParam                   ; $556E
    ld de, ObjScript_02_79CD_Mode0B_NameCardEdit_State10 + $A ; $5571
    call Object_Create                            ; $5574
    ld de, ObjScript_02_7BC2_Mode0B_NameCardEdit_State10 ; $5577
    call Object_Create                            ; $557A
    ld b, MODE_NAME_CARD_EDIT                     ; $557D
    ld c, STATE_0B_NAME_CARD_TAKE_YOUR_PHOTO      ; $557F
    call Fade_GoTo                                ; $5581
    ret                                           ; $5584


; C: handler of state $10 of mode $0B (word 16 of Mode0B_StateTable)
Mode0B_State10::
    call Rng_Next                                 ; $5585
    ld hl, wNameCard_MakeIdNumber_D8E2            ; $5588
    inc [hl]                                      ; $558B
    ld a, [wKeysNew]                              ; $558C
    bit PADB_B, a                                 ; $558F
    jr z, jr_006_55a2                             ; $5591

    push af                                       ; $5593
    ld a, SFX3_09                                 ; $5594
    ld [wSndSfx3], a                              ; $5596
    pop af                                        ; $5599
    ld b, MODE_MAIN_MENU                          ; $559A
    ld c, $03                                     ; $559C
    call Fade_GoToB                               ; $559E
    ret                                           ; $55A1


jr_006_55a2:
    ld a, [wMode07_StateTable_D8E0]               ; $55A2
    bit 0, a                                      ; $55A5
    jr z, jr_006_55c5                             ; $55A7

    push af                                       ; $55A9
    ld a, SFX1_19                                 ; $55AA
    ld [wSndSfx1], a                              ; $55AC
    pop af                                        ; $55AF
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $55B0
    inc a                                         ; $55B3
    cp $06                                        ; $55B4
    jr nz, jr_006_55b9                            ; $55B6

    xor a                                         ; $55B8

jr_006_55b9:
    ld [wMode0B_State02_D8F9], a                  ; $55B9
    ld b, MODE_NAME_CARD_EDIT                     ; $55BC
    ldh a, [hMenuState]                           ; $55BE
    ld c, a                                       ; $55C0
    call ModeState_Set                            ; $55C1
    ret                                           ; $55C4


jr_006_55c5:
    ret                                           ; $55C5


; C: ModeTable entry $0B: BGB screens 0B:04 / 08 / 0A / 0C / 0E / 10 (photos
Mode0B_NameCardEdit::
    ldh a, [hState]                               ; $55C6
    ld hl, Mode0B_StateTable                      ; $55C8
    call JumpTable_ByA                            ; $55CB
    jp Far_Return                                 ; $55CE


; C: state table of mode $0B, read by $0189 with hFF8E
Mode0B_StateTable::
    dw Mode0B_State00
    dw Mode0B_State01
    dw Mode0B_State02
    dw Mode0B_State03
    dw Mode0B_State04
    dw Mode0B_State05
    dw Mode0B_State06
    dw Mode0B_State07
    dw Mode0B_State08
    dw Mode0B_State09
    dw Mode0B_State08
    dw Mode0B_State0B
    dw Mode0B_State08
    dw Mode0B_State0D
    dw Mode0B_State08
    dw Mode0B_State0F
    dw Mode0B_State10

; C: $680 bytes of tiles into $9000 from the 6-byte record A of 00:0BF9 (address, bank); mode $0A state $00; runs on
; its screen (0A:00) in the core replays (port/entry_modes_kitty.csv); code read
NameCard_LoadBackgroundTiles::
    ld c, $06                                     ; $55F3
    call Mul_8x8                                  ; $55F5
    ld bc, $0bf9                                   ; $55F8
    add hl, bc                                    ; $55FB
    ld a, [hl+]                                   ; $55FC
    ld e, a                                       ; $55FD
    ld a, [hl+]                                   ; $55FE
    ld d, a                                       ; $55FF
    ld a, [hl+]                                   ; $5600
    push hl                                       ; $5601
    ld hl, $9000                                  ; $5602
    ld bc, $0680                                  ; $5605
    call Vram_CopyHBlankFar                       ; $5608
    pop hl                                        ; $560B
    jp Far_Return                                 ; $560C


; C: handler of state $00 of mode $0A (word 0 of Mode0A_StateTable)
Mode0A_State00::
    di                                            ; $560F
    call Lcd_Off                                  ; $5610
    call Oam_ClearShadow                          ; $5613
    ld b, BANK(Objects_ClearAll)                  ; $5616
    ld hl, Objects_ClearAll                       ; $5618
    call Far_Call                                 ; $561B
    ld b, BANK(ScriptSlots_Clear)                 ; $561E
    ld hl, ScriptSlots_Clear                      ; $5620
    call Far_Call                                 ; $5623
    call Copy_FarInline                           ; $5626

    db $00, $7f, $0b, $00, $8a, $00, $01

    call Copy_FarInline                           ; $5630

    db $50, $74, $23, $00, $87, $00, $01

    call Copy_FarInline                           ; $563A

    db $40, $7a, $32, $00, $98, $40, $02

    ld a, [wCardBackground]                       ; $5644
    ld [wCardBackgroundSel], a                    ; $5647
    call Stat_SetTileToggleDAt07                  ; $564A
    xor a                                         ; $564D
    ld [wDoodleFromShutterbug], a                 ; $564E
    call Serial_SetFarCallback                    ; $5651

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $5657

    db $e7, $e4, $d0, $e4, $00, $00, $00, $90, $ff, $40, $03

    ld b, BANK(Sram_LoadCardPhotos)               ; $5665
    ld hl, Sram_LoadCardPhotos                    ; $5667
    call Far_Call                                 ; $566A
    call Keys_SetRepeatInline                     ; $566D

    dw $0214

    push af                                       ; $5672
    ld a, MUSIC_NAME_CARD                         ; $5673
    ld [wSndMusicReq], a                          ; $5675
    pop af                                        ; $5678
    ei                                            ; $5679
    ld b, BANK(IdCard_DrawIdNumber)               ; $567A
    ld hl, IdCard_DrawIdNumber                    ; $567C
    call Far_Call                                 ; $567F
    ld b, BANK(IdCard_DrawName)                   ; $5682
    ld hl, IdCard_DrawName                        ; $5684
    call Far_Call                                 ; $5687
    ld b, BANK(IdCard_DrawBirthday)               ; $568A
    ld hl, IdCard_DrawBirthday                    ; $568C
    call Far_Call                                 ; $568F
    ld b, BANK(IdCard_DrawBloodType)              ; $5692
    ld hl, IdCard_DrawBloodType                   ; $5694
    call Far_Call                                 ; $5697
    ld b, BANK(IdCard_DrawSex)                    ; $569A
    ld hl, IdCard_DrawSex                         ; $569C
    call Far_Call                                 ; $569F
    ld a, [wCardBackgroundSel]                    ; $56A2
    ld b, BANK(NameCard_LoadBackgroundTiles)      ; $56A5
    ld hl, NameCard_LoadBackgroundTiles           ; $56A7
    call Far_CallKeepA                            ; $56AA
    ld a, [hl+]                                   ; $56AD
    ld e, a                                       ; $56AE
    ld a, [hl+]                                   ; $56AF
    ld d, a                                       ; $56B0
    ld a, [hl+]                                   ; $56B1
    ld hl, $9820                                  ; $56B2
    ld bc, $01a0                                  ; $56B5
    call Vram_CopyHBlankFar                       ; $56B8
    ld de, ObjScript_02_79B4_Mode0A_NameCard_State01 ; $56BB
    call Object_Create                            ; $56BE
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $20 ; $56C1
    call Object_Create                            ; $56C4
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $26 ; $56C7
    call Object_Create                            ; $56CA
    ld b, MODE_NAME_CARD                          ; $56CD
    ld c, STATE_0A_NAME_CARD_FINISHED_ID_CARD     ; $56CF
    call Fade_GoTo                                ; $56D1
    ret                                           ; $56D4


; C: handler of state $03 of mode $0A (word 3 of Mode0A_StateTable)
Mode0A_State03::
    ret                                           ; $56D5


; C: handler of state $01 of mode $0A (word 1 of Mode0A_StateTable)
Mode0A_State01::
    ld a, [wKeysNew]                              ; $56D6
    bit PADB_B, a                                 ; $56D9
    jr z, jr_006_5708                             ; $56DB

    push af                                       ; $56DD
    ld a, SFX3_09                                 ; $56DE
    ld [wSndSfx3], a                              ; $56E0
    pop af                                        ; $56E3
    push hl                                       ; $56E4
    ld hl, wMode06_State0A_D896                   ; $56E5
    set 0, [hl]                                   ; $56E8
    pop hl                                        ; $56EA
    ld a, [wCardBackgroundSel]                    ; $56EB
    ld [wCardBackground], a                       ; $56EE
    ld b, BANK(Counters_Store)                    ; $56F1
    ld hl, Counters_Store                         ; $56F3
    call Far_Call                                 ; $56F6
    push hl                                       ; $56F9
    ld hl, wMode06_State0A_D896                   ; $56FA
    res 0, [hl]                                   ; $56FD
    pop hl                                        ; $56FF
    ld b, MODE_MAIN_MENU                          ; $5700
    ld c, $03                                     ; $5702
    call Fade_GoToB                               ; $5704
    ret                                           ; $5707


jr_006_5708:
    ld a, [wKeysNew]                              ; $5708
    bit PADB_A, a                                 ; $570B
    jr z, jr_006_5728                             ; $570D

    push af                                       ; $570F
    ld a, SFX1_19                                 ; $5710
    ld [wSndSfx1], a                              ; $5712
    pop af                                        ; $5715
    ld a, $07                                     ; $5716
    ld b, BANK(KeyPrompt_LoadSounds)              ; $5718
    ld hl, KeyPrompt_LoadSounds                   ; $571A
    call Far_CallKeepA                            ; $571D
    ld b, MODE_NAME_CARD                          ; $5720
    ld c, STATE_0A_NAME_CARD_CHANGE_PRINT_CANCEL  ; $5722
    call ModeState_Set                            ; $5724
    ret                                           ; $5727


jr_006_5728:
    ld a, [wKeysNew]                              ; $5728
    bit PADB_LEFT, a                              ; $572B
    jr z, jr_006_5756                             ; $572D

    ld a, [wCardBackgroundSel]                    ; $572F
    dec a                                         ; $5732
    cp $ff                                        ; $5733
    jr nz, jr_006_5739                            ; $5735

    ld a, $06                                     ; $5737

jr_006_5739:
    ld [wCardBackgroundSel], a                    ; $5739
    push af                                       ; $573C
    ld a, SFX1_03                                 ; $573D
    ld [wSndSfx1], a                              ; $573F
    pop af                                        ; $5742
    ld de, $5673                                  ; $5743
    ld b, BANK(ScriptSlots_Add)                   ; $5746
    ld hl, ScriptSlots_Add                        ; $5748
    call Far_Call                                 ; $574B
    ld b, MODE_NAME_CARD                          ; $574E
    ld c, $03                                     ; $5750
    call ModeState_Set                            ; $5752
    ret                                           ; $5755


jr_006_5756:
    ld a, [wKeysNew]                              ; $5756
    bit PADB_RIGHT, a                             ; $5759
    jr z, jr_006_5784                             ; $575B

    ld a, [wCardBackgroundSel]                    ; $575D
    inc a                                         ; $5760
    cp $07                                        ; $5761
    jr nz, jr_006_5767                            ; $5763

    ld a, $00                                     ; $5765

jr_006_5767:
    ld [wCardBackgroundSel], a                    ; $5767
    push af                                       ; $576A
    ld a, SFX1_03                                 ; $576B
    ld [wSndSfx1], a                              ; $576D
    pop af                                        ; $5770
    ld de, $5589                                  ; $5771
    ld b, BANK(ScriptSlots_Add)                   ; $5774
    ld hl, ScriptSlots_Add                        ; $5776
    call Far_Call                                 ; $5779
    ld b, MODE_NAME_CARD                          ; $577C
    ld c, $03                                     ; $577E
    call ModeState_Set                            ; $5780
    ret                                           ; $5783


jr_006_5784:
    ret                                           ; $5784


; C: handler of state $02 of mode $0A (word 2 of Mode0A_StateTable)
Mode0A_State02::
    ld a, [wMode06_State0A_D8DF]                  ; $5785
    bit 1, a                                      ; $5788
    jr z, jr_006_579a                             ; $578A

    ld de, ObjScript_02_79B4_Mode0A_NameCard_State01 ; $578C
    call Object_Create                            ; $578F
    ld b, MODE_NAME_CARD                          ; $5792
    ld c, STATE_0A_NAME_CARD_FINISHED_ID_CARD     ; $5794
    call ModeState_Set                            ; $5796
    ret                                           ; $5799


jr_006_579a:
    ld a, [wMode06_State0A_D8DF]                  ; $579A
    bit 3, a                                      ; $579D
    jr z, jr_006_57c5                             ; $579F

    push hl                                       ; $57A1
    ld hl, wMode06_State0A_D896                   ; $57A2
    set 0, [hl]                                   ; $57A5
    pop hl                                        ; $57A7
    ld a, [wCardBackgroundSel]                    ; $57A8
    ld [wCardBackground], a                       ; $57AB
    ld b, BANK(Counters_Store)                    ; $57AE
    ld hl, Counters_Store                         ; $57B0
    call Far_Call                                 ; $57B3
    push hl                                       ; $57B6
    ld hl, wMode06_State0A_D896                   ; $57B7
    res 0, [hl]                                   ; $57BA
    pop hl                                        ; $57BC
    ld b, MODE_NAME_CARD_EDIT                     ; $57BD
    ld c, $00                                     ; $57BF
    call Fade_GoToB                               ; $57C1
    ret                                           ; $57C4


jr_006_57c5:
    ld a, [wMode06_State0A_D8DF]                  ; $57C5
    bit 0, a                                      ; $57C8
    jr z, jr_006_57fe                             ; $57CA

    push hl                                       ; $57CC
    ld hl, wMode06_State0A_D896                   ; $57CD
    set 0, [hl]                                   ; $57D0
    pop hl                                        ; $57D2
    ld a, [wCardBackgroundSel]                    ; $57D3
    ld [wCardBackground], a                       ; $57D6
    ld b, BANK(Counters_Store)                    ; $57D9
    ld hl, Counters_Store                         ; $57DB
    call Far_Call                                 ; $57DE
    push hl                                       ; $57E1
    ld hl, wMode06_State0A_D896                   ; $57E2
    res 0, [hl]                                   ; $57E5
    pop hl                                        ; $57E7
    ld b, MODE_NAME_CARD                          ; $57E8
    ld c, $00                                     ; $57EA
    call Mode_SaveReturnD93D                      ; $57EC
    ld b, MODE_NAME_CARD                          ; $57EF
    ld c, $00                                     ; $57F1
    call Mode_SaveReturnD8F2                      ; $57F3
    ld b, MODE_PRINTING                           ; $57F6
    ld c, $16                                     ; $57F8
    call Fade_GoToB                               ; $57FA
    ret                                           ; $57FD


jr_006_57fe:
    ret                                           ; $57FE


; C: ModeTable entry $0A: BGB screens 0A:01 (the finished card) and 0A:02 (change / print / cancel)
Mode0A_NameCard::
    ldh a, [hState]                               ; $57FF
    ld hl, Mode0A_StateTable                      ; $5801
    call JumpTable_ByA                            ; $5804
    jp Far_Return                                 ; $5807


; C: state table of mode $0A, read by $0189 with hFF8E
Mode0A_StateTable::
    dw Mode0A_State00
    dw Mode0A_State01
    dw Mode0A_State02
    dw Mode0A_State03

; C: C bytes of BCD from [HL] downwards as 8x16 digits of 0C:7D00 into DE, leading zeros blank ($D938 = a non-zero
; digit seen); screen off
Bcd_DrawNumberTall::
    xor a                                         ; $5812
    ld [wBcd_DrawDigitTall_D938], a               ; $5813
    ld a, c                                       ; $5816
    sla a                                         ; $5817

jr_006_5819:
    ld [wBcd_DrawNumberTall_D937], a              ; $5819
    ld a, [hl-]                                   ; $581C
    push hl                                       ; $581D
    push af                                       ; $581E
    swap a                                        ; $581F
    and $0f                                       ; $5821
    call Bcd_DrawDigitTall                        ; $5823
    ld e, l                                       ; $5826
    ld d, h                                       ; $5827
    pop af                                        ; $5828
    ld hl, wBcd_DrawNumberTall_D937               ; $5829
    dec [hl]                                      ; $582C
    and $0f                                       ; $582D
    call Bcd_DrawDigitTall                        ; $582F
    ld e, l                                       ; $5832
    ld d, h                                       ; $5833
    pop hl                                        ; $5834
    ld a, [wBcd_DrawNumberTall_D937]              ; $5835
    dec a                                         ; $5838
    jr nz, jr_006_5819                            ; $5839

    ret                                           ; $583B


; C: one digit of 06:5812
Bcd_DrawDigitTall::
    push de                                       ; $583C
    and $0f                                       ; $583D
    jr z, jr_006_5844                             ; $583F

    ld [wBcd_DrawDigitTall_D938], a               ; $5841

jr_006_5844:
    swap a                                        ; $5844
    ld c, a                                       ; $5846
    ld b, $00                                     ; $5847
    sla c                                         ; $5849
    rl b                                          ; $584B
    ld hl, Gfx_0C_7CE0_Mode0C_RecordBook_State01 + $20 ; $584D
    add hl, bc                                    ; $5850
    ld e, l                                       ; $5851
    ld d, h                                       ; $5852
    ld a, [wBcd_DrawDigitTall_D938]               ; $5853
    or c                                          ; $5856
    or b                                          ; $5857
    jr nz, jr_006_5864                            ; $5858

    ld a, [wBcd_DrawNumberTall_D937]              ; $585A
    cp $01                                        ; $585D
    jr z, jr_006_5864                             ; $585F

    ld de, Gfx_0C_7920_Mode02_TakePhotos_State06  ; $5861

jr_006_5864:
    pop hl                                        ; $5864
    ld bc, $0020                                  ; $5865
    ld a, $0c                                     ; $5868
    call Copy_FarDEtoHL                           ; $586A
    ret                                           ; $586D


    db $af, $ea, $38, $d9, $79, $cb, $27, $ea, $37, $d9, $3a, $e5, $f5, $cb, $37, $e6
    db $0f, $cd, $98, $58, $5d, $54, $f1, $21, $37, $d9, $35, $e6, $0f, $cd, $98, $58
    db $5d, $54, $e1, $fa, $37, $d9, $3d, $20, $de, $c9, $d5, $e6, $0f, $28, $03, $ea
    db $38, $d9, $cb, $37, $4f, $06, $00, $cb, $21, $cb, $10, $21, $00, $7d, $09, $5d
    db $54, $fa, $38, $d9, $b1, $b0, $20, $0a, $fa, $37, $d9, $fe, $01, $28, $03, $11
    db $20, $79, $e1, $01, $20, $00, $3e, $0c, $cd, $26, $07, $c9

; C: the same with 8x8 digits of 0C:7C40 (Copy_FarDEtoHL; screen off)
Bcd_DrawNumber::
    xor a                                         ; $58CA
    ld [wBcd_DrawDigitTall_D938], a               ; $58CB
    ld a, c                                       ; $58CE
    sla a                                         ; $58CF

jr_006_58d1:
    ld [wBcd_DrawNumberTall_D937], a              ; $58D1
    ld a, [hl-]                                   ; $58D4
    push hl                                       ; $58D5
    push af                                       ; $58D6
    swap a                                        ; $58D7
    and $0f                                       ; $58D9
    call Bcd_DrawDigit                            ; $58DB
    ld e, l                                       ; $58DE
    ld d, h                                       ; $58DF
    pop af                                        ; $58E0
    ld hl, wBcd_DrawNumberTall_D937               ; $58E1
    dec [hl]                                      ; $58E4
    and $0f                                       ; $58E5
    call Bcd_DrawDigit                            ; $58E7
    ld e, l                                       ; $58EA
    ld d, h                                       ; $58EB
    pop hl                                        ; $58EC
    ld a, [wBcd_DrawNumberTall_D937]              ; $58ED
    dec a                                         ; $58F0
    jr nz, jr_006_58d1                            ; $58F1

    ret                                           ; $58F3


; C: one digit of 06:58CA
Bcd_DrawDigit::
    push de                                       ; $58F4
    and $0f                                       ; $58F5
    jr z, jr_006_58fc                             ; $58F7

    ld [wBcd_DrawDigitTall_D938], a               ; $58F9

jr_006_58fc:
    swap a                                        ; $58FC
    ld c, a                                       ; $58FE
    ld b, $00                                     ; $58FF
    ld hl, Gfx_0C_7C40_Mode0A_NameCard_State01    ; $5901
    add hl, bc                                    ; $5904
    ld e, l                                       ; $5905
    ld d, h                                       ; $5906
    ld a, [wBcd_DrawDigitTall_D938]               ; $5907
    or c                                          ; $590A
    or b                                          ; $590B
    jr nz, jr_006_5918                            ; $590C

    ld a, [wBcd_DrawNumberTall_D937]              ; $590E
    cp $01                                        ; $5911
    jr z, jr_006_5918                             ; $5913

    ld de, Gfx_0C_7CE0_Mode0C_RecordBook_State01  ; $5915

jr_006_5918:
    pop hl                                        ; $5918
    ld bc, $0010                                  ; $5919
    ld a, $0c                                     ; $591C
    call Copy_FarDEtoHL                           ; $591E
    ret                                           ; $5921


; C: the same through Vram_CopyHBlankFar (screen on)
Bcd_DrawNumberVram::
    xor a                                         ; $5922
    ld [wBcd_DrawDigitTall_D938], a               ; $5923
    ld a, c                                       ; $5926
    sla a                                         ; $5927

jr_006_5929:
    ld [wBcd_DrawNumberTall_D937], a              ; $5929
    ld a, [hl-]                                   ; $592C
    push hl                                       ; $592D
    push af                                       ; $592E
    swap a                                        ; $592F
    and $0f                                       ; $5931
    call Bcd_DrawDigitVram                        ; $5933
    ld e, l                                       ; $5936
    ld d, h                                       ; $5937
    pop af                                        ; $5938
    ld hl, wBcd_DrawNumberTall_D937               ; $5939
    dec [hl]                                      ; $593C
    and $0f                                       ; $593D
    call Bcd_DrawDigitVram                        ; $593F
    ld e, l                                       ; $5942
    ld d, h                                       ; $5943
    pop hl                                        ; $5944
    ld a, [wBcd_DrawNumberTall_D937]              ; $5945
    dec a                                         ; $5948
    jr nz, jr_006_5929                            ; $5949

    ret                                           ; $594B


; C: one digit of 06:5922
Bcd_DrawDigitVram::
    push de                                       ; $594C
    and $0f                                       ; $594D
    jr z, jr_006_5954                             ; $594F

    ld [wBcd_DrawDigitTall_D938], a               ; $5951

jr_006_5954:
    swap a                                        ; $5954
    ld c, a                                       ; $5956
    ld b, $00                                     ; $5957
    ld hl, Gfx_0C_7C40_Mode0A_NameCard_State01    ; $5959
    add hl, bc                                    ; $595C
    ld e, l                                       ; $595D
    ld d, h                                       ; $595E
    ld a, [wBcd_DrawDigitTall_D938]               ; $595F
    or c                                          ; $5962
    or b                                          ; $5963
    jr nz, jr_006_5970                            ; $5964

    ld a, [wBcd_DrawNumberTall_D937]              ; $5966
    cp $01                                        ; $5969
    jr z, jr_006_5970                             ; $596B

    ld de, Gfx_0C_7CE0_Mode0C_RecordBook_State01  ; $596D

jr_006_5970:
    pop hl                                        ; $5970
    ld bc, $0010                                  ; $5971
    ld a, $0c                                     ; $5974
    call Vram_CopyHBlankFar                       ; $5976
    ret                                           ; $5979


; C: the counters as tall digits: taken $DAC9 into $9300, thrown away into $9380, exchanged into $9400, received into
; $9480, ...; mode $0C
RecordBook_DrawCounters::
    ld hl, wCountTaken + $1                       ; $597A
    ld de, $9300                                  ; $597D
    ld c, $02                                     ; $5980
    call Bcd_DrawNumberTall                       ; $5982
    ld hl, wCountErased + $1                      ; $5985
    ld de, $9380                                  ; $5988
    ld c, $02                                     ; $598B
    call Bcd_DrawNumberTall                       ; $598D
    ld hl, wCountExchanged + $1                   ; $5990
    ld de, $9400                                  ; $5993
    ld c, $02                                     ; $5996
    call Bcd_DrawNumberTall                       ; $5998
    ld hl, wCountReceivedBoy                      ; $599B
    ld de, $9480                                  ; $599E
    ld c, $01                                     ; $59A1
    call Bcd_DrawNumberTall                       ; $59A3
    ld hl, wCountReceivedGirl                     ; $59A6
    ld de, $94c0                                  ; $59A9
    ld c, $01                                     ; $59AC
    call Bcd_DrawNumberTall                       ; $59AE
    ld hl, wCountPrinted + $1                     ; $59B1
    ld de, $9500                                  ; $59B4
    ld c, $02                                     ; $59B7
    call Bcd_DrawNumberTall                       ; $59B9
    ld hl, wKitts + $2                            ; $59BC
    ld de, $9580                                  ; $59BF
    ld bc, $0003                                  ; $59C2
    call Bcd_DrawNumber                           ; $59C5
    jp Far_Return                                 ; $59C8


    db $21, $ca, $da, $11, $00, $93, $0e, $02, $cd, $6e, $58, $21, $cc, $da, $11, $80
    db $93, $0e, $02, $cd, $6e, $58, $21, $ce, $da, $11, $00, $94, $0e, $02, $cd, $6e
    db $58, $21, $d1, $da, $11, $80, $94, $0e, $01, $cd, $6e, $58, $21, $d2, $da, $11
    db $c0, $94, $0e, $01, $cd, $6e, $58, $21, $d0, $da, $11, $00, $95, $0e, $02, $cd
    db $6e, $58, $21, $d5, $da, $11, $80, $95, $01, $03, $00, $cd, $22, $59, $c3, $73
    db $01

; C: the Kitts ($DAD3-$DAD5) by Bcd_DrawNumberVram into $8F20
Kitts_DrawAt8F20::
    ld hl, wKitts + $2                            ; $5A1C
    ld de, $8f20                                  ; $5A1F
    ld bc, $0003                                  ; $5A22
    call Bcd_DrawNumberVram                       ; $5A25
    jp Far_Return                                 ; $5A28


; C: the Kitts by Bcd_DrawNumber into $9420 (screen off)
Kitts_DrawAt9420::
    ld hl, wKitts + $2                            ; $5A2B
    ld de, $9420                                  ; $5A2E
    ld bc, $0003                                  ; $5A31
    call Bcd_DrawNumber                           ; $5A34
    jp Far_Return                                 ; $5A37


; C: the Kitts by Bcd_DrawNumberVram into $9420
Kitts_DrawAt9420Vram::
    ld hl, wKitts + $2                            ; $5A3A
    ld de, $9420                                  ; $5A3D
    ld bc, $0003                                  ; $5A40
    call Bcd_DrawNumberVram                       ; $5A43
    jp Far_Return                                 ; $5A46


; C: counters loaded (01:4E97), photos taken $DAC9 + 1 in BCD ($0CB4), saved (01:4EB6); first run in mode $02 state
; $06
Counters_AddTaken::
    ld b, BANK(Counters_Load)                     ; $5A49
    ld hl, Counters_Load                          ; $5A4B
    call Far_Call                                 ; $5A4E
    ld hl, wCountTaken                            ; $5A51
    ld de, $0001                                  ; $5A54
    ld c, $02                                     ; $5A57
    call Bcd_Add                                  ; $5A59
    ld b, BANK(Counters_Store)                    ; $5A5C
    ld hl, Counters_Store                         ; $5A5E
    call Far_Call                                 ; $5A61
    jp Far_Return                                 ; $5A64


; C: the same for photos thrown away $DACB (mode $03 state $0E)
Counters_AddErased::
    ld b, BANK(Counters_Load)                     ; $5A67
    ld hl, Counters_Load                          ; $5A69
    call Far_Call                                 ; $5A6C
    ld hl, wCountErased                           ; $5A6F
    ld de, $0001                                  ; $5A72
    ld c, $02                                     ; $5A75
    call Bcd_Add                                  ; $5A77
    ld b, BANK(Counters_Store)                    ; $5A7A
    ld hl, Counters_Store                         ; $5A7C
    call Far_Call                                 ; $5A7F
    jp Far_Return                                 ; $5A82


; C: the same for photos exchanged $DACD
Counters_AddExchanged::
    ld b, BANK(Counters_Load)                     ; $5A85
    ld hl, Counters_Load                          ; $5A87
    call Far_Call                                 ; $5A8A
    ld hl, wCountExchanged                        ; $5A8D
    ld de, $0001                                  ; $5A90
    ld c, $02                                     ; $5A93
    call Bcd_Add                                  ; $5A95
    ld b, BANK(Counters_Store)                    ; $5A98
    ld hl, Counters_Store                         ; $5A9A
    call Far_Call                                 ; $5A9D
    jp Far_Return                                 ; $5AA0


    db $06, $01, $21, $97, $4e, $cd, $5b, $01, $21, $d1, $da, $11, $01, $00, $0e, $01
    db $cd, $b4, $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01, $06, $01
    db $21, $97, $4e, $cd, $5b, $01, $21, $d2, $da, $11, $01, $00, $0e, $01, $cd, $b4
    db $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01

; C: the same for photos printed $DACF
Counters_AddPrinted::
    ld b, BANK(Counters_Load)                     ; $5ADF
    ld hl, Counters_Load                          ; $5AE1
    call Far_Call                                 ; $5AE4
    ld hl, wCountPrinted                          ; $5AE7
    ld de, $0001                                  ; $5AEA
    ld c, $02                                     ; $5AED
    call Bcd_Add                                  ; $5AEF
    ld b, BANK(Counters_Store)                    ; $5AF2
    ld hl, Counters_Store                         ; $5AF4
    call Far_Call                                 ; $5AF7
    jp Far_Return                                 ; $5AFA


    db $06, $01, $21, $97, $4e, $cd, $5b, $01, $21, $d3, $da, $11, $01, $00, $0e, $03
    db $cd, $b4, $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01

; C: the Kitts $DAD3 (3 bytes BCD) + DE ($0CB4), saved; carry returned
Kitts_Add::
    push de                                       ; $5B1B
    ld b, BANK(Counters_Load)                     ; $5B1C
    ld hl, Counters_Load                          ; $5B1E
    call Far_Call                                 ; $5B21
    pop de                                        ; $5B24
    ld hl, wKitts                                 ; $5B25
    ld c, $03                                     ; $5B28
    call Bcd_Add                                  ; $5B2A
    push af                                       ; $5B2D
    ld b, BANK(Counters_Store)                    ; $5B2E
    ld hl, Counters_Store                         ; $5B30
    call Far_Call                                 ; $5B33
    pop af                                        ; $5B36
    jp Far_ReturnSramBank                         ; $5B37


; C: the Kitts - DE by 00:0CD3 (the BCD subtraction beside $0CB4), saved; carry returned; runs on its screen (0E:08
; 0E:14) in the core replays (port/entry_modes_kitty.csv); code read
Kitts_Subtract::
    push de                                       ; $5B3A
    ld b, BANK(Counters_Load)                     ; $5B3B
    ld hl, Counters_Load                          ; $5B3D
    call Far_Call                                 ; $5B40
    pop de                                        ; $5B43
    ld hl, wKitts                                 ; $5B44
    ld c, $03                                     ; $5B47
    call Bcd_Sub                                  ; $5B49
    push af                                       ; $5B4C
    ld b, BANK(Counters_Store)                    ; $5B4D
    ld hl, Counters_Store                         ; $5B4F
    call Far_Call                                 ; $5B52
    pop af                                        ; $5B55
    jp Far_ReturnSramBank                         ; $5B56


; C: a copy of the Kitts in $D949 minus DE (00:0CD3), nothing saved: the carry says whether DE Kitts can be paid; runs
; on its screen (0E:08 0E:14 11:02) in the core replays (port/entry_modes_kitty.csv); code read
Kitts_CheckAfford::
    push de                                       ; $5B59
    ld b, BANK(Counters_Load)                     ; $5B5A
    ld hl, Counters_Load                          ; $5B5C
    call Far_Call                                 ; $5B5F
    pop de                                        ; $5B62
    ld a, [wKitts]                                ; $5B63
    ld [wKittsCheckTmp], a                        ; $5B66
    ld a, [wKitts + $1]                           ; $5B69
    ld [wKittsCheckTmp + $1], a                   ; $5B6C
    ld a, [wKitts + $2]                           ; $5B6F
    ld [wKittsCheckTmp + $2], a                   ; $5B72
    ld hl, wKittsCheckTmp                         ; $5B75
    ld c, $03                                     ; $5B78
    call Bcd_Sub                                  ; $5B7A
    jp Far_ReturnSramBank                         ; $5B7D


    db $d5, $06, $01, $21, $97, $4e, $cd, $5b, $01, $d1, $21, $c9, $da, $0e, $02, $cd
    db $b4, $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01, $d5, $06, $01
    db $21, $97, $4e, $cd, $5b, $01, $d1, $21, $cb, $da, $0e, $02, $cd, $b4, $0c, $06
    db $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01, $d5, $06, $01, $21, $97, $4e
    db $cd, $5b, $01, $d1, $21, $cd, $da, $0e, $02, $cd, $b4, $0c, $06, $01, $21, $b6
    db $4e, $cd, $5b, $01, $c3, $73, $01, $d5, $06, $01, $21, $97, $4e, $cd, $5b, $01
    db $d1, $21, $d1, $da, $0e, $01, $cd, $b4, $0c, $06, $01, $21, $b6, $4e, $cd, $5b
    db $01, $c3, $73, $01, $d5, $06, $01, $21, $97, $4e, $cd, $5b, $01, $d1, $21, $d2
    db $da, $0e, $01, $cd, $b4, $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73
    db $01, $d5, $06, $01, $21, $97, $4e, $cd, $5b, $01, $d1, $21, $cf, $da, $0e, $02
    db $cd, $b4, $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01, $d5, $06
    db $01, $21, $97, $4e, $cd, $5b, $01, $d1, $21, $c9, $da, $0e, $02, $cd, $d3, $0c
    db $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01, $d5, $06, $01, $21, $97
    db $4e, $cd, $5b, $01, $d1, $21, $cb, $da, $0e, $02, $cd, $d3, $0c, $06, $01, $21
    db $b6, $4e, $cd, $5b, $01, $c3, $73, $01, $d5, $06, $01, $21, $97, $4e, $cd, $5b
    db $01, $d1, $21, $cd, $da, $0e, $02, $cd, $d3, $0c, $06, $01, $21, $b6, $4e, $cd
    db $5b, $01, $c3, $73, $01, $d5, $06, $01, $21, $97, $4e, $cd, $5b, $01, $d1, $21
    db $d1, $da, $0e, $01, $cd, $d3, $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3
    db $73, $01, $d5, $06, $01, $21, $97, $4e, $cd, $5b, $01, $d1, $21, $d2, $da, $0e
    db $01, $cd, $d3, $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01, $d5
    db $06, $01, $21, $97, $4e, $cd, $5b, $01, $d1, $21, $cf, $da, $0e, $02, $cd, $d3
    db $0c, $06, $01, $21, $b6, $4e, $cd, $5b, $01, $c3, $73, $01

; C: handler of state $00 of mode $0C (word 0 of Mode0C_StateTable)
Mode0C_State00::
    di                                            ; $5CDC
    call Lcd_Off                                  ; $5CDD
    call Oam_ClearShadow                          ; $5CE0
    ld b, BANK(Objects_ClearAll)                  ; $5CE3
    ld hl, Objects_ClearAll                       ; $5CE5
    call Far_Call                                 ; $5CE8
    ld b, BANK(ScriptSlots_Clear)                 ; $5CEB
    ld hl, ScriptSlots_Clear                      ; $5CED
    call Far_Call                                 ; $5CF0
    call Copy_FarInline                           ; $5CF3

    db $00, $70, $25, $00, $8f, $00, $09

    call Copy_FarInline                           ; $5CFD

    db $e0, $6e, $31, $00, $98, $60, $02

    ld b, BANK(RecordBook_DrawCounters)           ; $5D07
    ld hl, RecordBook_DrawCounters                ; $5D09
    call Far_Call                                 ; $5D0C
    call Serial_SetFarCallback                    ; $5D0F

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $5D15

    db $e7, $e4, $e4, $d0, $00, $04, $00, $90, $ff, $40, $01

    call Keys_SetRepeatInline                     ; $5D23

    dw $0214

    push af                                       ; $5D28
    ld a, MUSIC_RECORD_BOOK                       ; $5D29
    ld [wSndMusicReq], a                          ; $5D2B
    pop af                                        ; $5D2E
    ei                                            ; $5D2F
    ld de, ObjScript_02_7E32_Mode0C_RecordBook_State01 + $20 ; $5D30
    call Object_Create                            ; $5D33
    ld de, $5732                                  ; $5D36
    ld b, BANK(ScriptSlots_Add)                   ; $5D39
    ld hl, ScriptSlots_Add                        ; $5D3B
    call Far_Call                                 ; $5D3E
    ld de, $574c                                  ; $5D41
    ld b, BANK(ScriptSlots_Add)                   ; $5D44
    ld hl, ScriptSlots_Add                        ; $5D46
    call Far_Call                                 ; $5D49
    ld de, $5779                                  ; $5D4C
    ld b, BANK(ScriptSlots_Add)                   ; $5D4F
    ld hl, ScriptSlots_Add                        ; $5D51
    call Far_Call                                 ; $5D54
    ld de, $57c1                                  ; $5D57
    ld b, BANK(ScriptSlots_Add)                   ; $5D5A
    ld hl, ScriptSlots_Add                        ; $5D5C
    call Far_Call                                 ; $5D5F
    ld de, $57ee                                  ; $5D62
    ld b, BANK(ScriptSlots_Add)                   ; $5D65
    ld hl, ScriptSlots_Add                        ; $5D67
    call Far_Call                                 ; $5D6A
    ld b, MODE_RECORD_BOOK                        ; $5D6D
    ld c, STATE_0C_RECORD_BOOK_PHOTO_COUNTERS_KITTS ; $5D6F
    call Fade_GoTo                                ; $5D71
    ret                                           ; $5D74


; C: handler of state $01 of mode $0C (word 1 of Mode0C_StateTable)
Mode0C_State01::
    ld a, [wKeysNew]                              ; $5D75
    bit PADB_B, a                                 ; $5D78
    jr z, jr_006_5d8b                             ; $5D7A

    push af                                       ; $5D7C
    ld a, SFX3_09                                 ; $5D7D
    ld [wSndSfx3], a                              ; $5D7F
    pop af                                        ; $5D82
    ld b, MODE_MAIN_MENU                          ; $5D83
    ld c, $03                                     ; $5D85
    call Fade_GoToB                               ; $5D87
    ret                                           ; $5D8A


jr_006_5d8b:
    ret                                           ; $5D8B


; C: ModeTable entry $0C: BGB screen 0C:01 (photo counters and Kitts)
Mode0C_RecordBook::
    ldh a, [hState]                               ; $5D8C
    ld hl, Mode0C_StateTable                      ; $5D8E
    call JumpTable_ByA                            ; $5D91
    jp Far_Return                                 ; $5D94


; C: state table of mode $0C, read by $0189 with hFF8E
Mode0C_StateTable::
    dw Mode0C_State00
    dw Mode0C_State01

    db $29, $01, $06, $01, $3a, $01, $00, $54, $10, $00, $88, $a0, $00, $20, $20, $73
    db $4c, $00, $61, $10, $00, $86, $00, $01, $50, $5e, $c1, $4c, $00, $57, $10, $00
    db $88, $a0, $00, $30, $74, $b5, $4c, $00, $55, $10, $00, $89, $a0, $00, $70, $74
    db $bb, $4c, $00, $00, $00

    db $0e, $04, $0a, $03, $00, $00, $00, $54, $10, $00, $88, $a0, $00, $20, $20, $67
    db $4c, $00, $54, $10, $00, $88, $a0, $00, $30, $74, $a9, $4c, $00, $56, $10, $00
    db $89, $a0, $00, $70, $74, $af, $4c, $00, $00, $00

; C: read in the runs by KeyPrompt_LoadSounds, KeyPrompt_LoadSoundsB; first read on the screen
; Mode05_StampWindow_State03 (trace/read_screens_kitty*.npz); read in BGB by a read watchpoint
; (trace/bgb_reads_kitty.csv: exchange)
KeyPrompt_LoadSounds_Tbl5DFA::
    INCBIN "data/bank_06/KeyPrompt_LoadSounds_Tbl5DFA.bin" ; $5DFA, 411 bytes
; C: the three key-prompt sound pairs $D8E6-$D8EB from record A of the pointer table 06:5F7F (read by KeyPrompt_*);
; runs in the camera (mode $02)
KeyPrompt_LoadSounds::
    sla a                                         ; $5F95
    ld c, a                                       ; $5F97
    ld b, $00                                     ; $5F98
    ld hl, KeyPrompt_LoadSounds_Tbl5DFA + $185    ; $5F9A
    add hl, bc                                    ; $5F9D
    ld a, [hl+]                                   ; $5F9E
    ld c, a                                       ; $5F9F
    ld a, [hl+]                                   ; $5FA0
    ld l, c                                       ; $5FA1
    ld h, a                                       ; $5FA2
    ld de, wKeyPrompt_Keys4ADB_D8E6               ; $5FA3
    ld c, $03                                     ; $5FA6

jr_006_5fa8:
    ld a, [hl+]                                   ; $5FA8
    ld [de], a                                    ; $5FA9
    inc de                                        ; $5FAA
    ld a, [hl+]                                   ; $5FAB
    dec a                                         ; $5FAC
    ld [de], a                                    ; $5FAD
    inc de                                        ; $5FAE
    dec c                                         ; $5FAF
    jr nz, jr_006_5fa8                            ; $5FB0

    ld a, $01                                     ; $5FB2
    ldh [hFrame_UpdateAll_FF9A], a                ; $5FB4
    xor a                                         ; $5FB6
    ld [wKeysNew], a                              ; $5FB7
    ld [wMode06_State0A_D8DF], a                  ; $5FBA
    ld [wKeyPrompt_TickA_D8E1], a                 ; $5FBD

jr_006_5fc0:
    push hl                                       ; $5FC0
    ld a, [hl+]                                   ; $5FC1
    ld e, a                                       ; $5FC2
    ld a, [hl+]                                   ; $5FC3
    ld d, a                                       ; $5FC4
    push de                                       ; $5FC5
    ld a, [hl+]                                   ; $5FC6
    push af                                       ; $5FC7
    or e                                          ; $5FC8
    or d                                          ; $5FC9
    jr z, jr_006_5fef                             ; $5FCA

    ld a, [hl+]                                   ; $5FCC
    ld e, a                                       ; $5FCD
    ld a, [hl+]                                   ; $5FCE
    ld d, a                                       ; $5FCF
    push de                                       ; $5FD0
    ld a, [hl+]                                   ; $5FD1
    ld c, a                                       ; $5FD2
    ld a, [hl+]                                   ; $5FD3
    ld b, a                                       ; $5FD4
    pop hl                                        ; $5FD5
    pop af                                        ; $5FD6
    pop de                                        ; $5FD7
    call Vram_CopyHBlankFar                       ; $5FD8
    pop hl                                        ; $5FDB
    ld bc, $0007                                  ; $5FDC
    add hl, bc                                    ; $5FDF
    ld a, [hl+]                                   ; $5FE0
    ld c, a                                       ; $5FE1
    ld a, [hl+]                                   ; $5FE2
    ld b, a                                       ; $5FE3
    ld a, [hl+]                                   ; $5FE4
    ld e, a                                       ; $5FE5
    ld a, [hl+]                                   ; $5FE6
    ld d, a                                       ; $5FE7
    push hl                                       ; $5FE8
    call Object_CreateWithParam                   ; $5FE9
    pop hl                                        ; $5FEC
    jr jr_006_5fc0                                ; $5FED

jr_006_5fef:
    pop af                                        ; $5FEF
    pop de                                        ; $5FF0
    pop hl                                        ; $5FF1
    xor a                                         ; $5FF2
    ldh [hFrame_UpdateAll_FF9A], a                ; $5FF3
    jp Far_Return                                 ; $5FF5


; C: KeyPrompt_LoadSounds again (the same code), called only from Mode09_State0C with A = $0A (06:6B76): the giving
; unit asked for a photo by a leading receiver; run in the linked cores (tools/kitty_core_link.py, recv_leads,
; 2026-11-22)
KeyPrompt_LoadSoundsB::
    sla a                                         ; $5FF8
    ld c, a                                       ; $5FFA
    ld b, $00                                     ; $5FFB
    ld hl, KeyPrompt_LoadSounds_Tbl5DFA + $185    ; $5FFD
    add hl, bc                                    ; $6000
    ld a, [hl+]                                   ; $6001
    ld c, a                                       ; $6002
    ld a, [hl+]                                   ; $6003
    ld l, c                                       ; $6004
    ld h, a                                       ; $6005
    ld de, wKeyPrompt_Keys4ADB_D8E6               ; $6006
    ld c, $03                                     ; $6009

jr_006_600b:
    ld a, [hl+]                                   ; $600B
    ld [de], a                                    ; $600C
    inc de                                        ; $600D
    ld a, [hl+]                                   ; $600E
    dec a                                         ; $600F
    ld [de], a                                    ; $6010
    inc de                                        ; $6011
    dec c                                         ; $6012
    jr nz, jr_006_600b                            ; $6013

    ld a, $01                                     ; $6015
    ldh [hFrame_UpdateAll_FF9A], a                ; $6017
    xor a                                         ; $6019
    ld [wKeysNew], a                              ; $601A
    ld [wMode06_State0A_D8DF], a                  ; $601D
    ld [wKeyPrompt_TickA_D8E1], a                 ; $6020

jr_006_6023:
    push hl                                       ; $6023
    ld a, [hl+]                                   ; $6024
    ld e, a                                       ; $6025
    ld a, [hl+]                                   ; $6026
    ld d, a                                       ; $6027
    push de                                       ; $6028
    ld a, [hl+]                                   ; $6029
    push af                                       ; $602A
    or e                                          ; $602B
    or d                                          ; $602C
    jr z, jr_006_6052                             ; $602D

    ld a, [hl+]                                   ; $602F
    ld e, a                                       ; $6030
    ld a, [hl+]                                   ; $6031
    ld d, a                                       ; $6032
    push de                                       ; $6033
    ld a, [hl+]                                   ; $6034
    ld c, a                                       ; $6035
    ld a, [hl+]                                   ; $6036
    ld b, a                                       ; $6037
    pop hl                                        ; $6038
    pop af                                        ; $6039
    pop de                                        ; $603A
    call Copy_FarDEtoHL                           ; $603B
    pop hl                                        ; $603E
    ld bc, $0007                                  ; $603F
    add hl, bc                                    ; $6042
    ld a, [hl+]                                   ; $6043
    ld c, a                                       ; $6044
    ld a, [hl+]                                   ; $6045
    ld b, a                                       ; $6046
    ld a, [hl+]                                   ; $6047
    ld e, a                                       ; $6048
    ld a, [hl+]                                   ; $6049
    ld d, a                                       ; $604A
    push hl                                       ; $604B
    call Object_CreateWithParam                   ; $604C
    pop hl                                        ; $604F
    jr jr_006_6023                                ; $6050

jr_006_6052:
    pop af                                        ; $6052
    pop de                                        ; $6053
    pop hl                                        ; $6054
    xor a                                         ; $6055
    ldh [hFrame_UpdateAll_FF9A], a                ; $6056
    jp Far_Return                                 ; $6058


; C: same code as the Japanese Unused_Link_SumSlotBuffer (07:4BEA, 30 bytes); here it runs: mode $09 state $01 on the
; giving unit of the linked exchange (BGB 2026-11-08)
Link_SumSlotBuffer::
    ld hl, wPhotoImage                            ; $605B
    ld bc, $1000                                  ; $605E
    ld de, $0000                                  ; $6061

jr_006_6064:
    ld a, d                                       ; $6064
    add [hl]                                      ; $6065
    ld d, a                                       ; $6066
    ld a, e                                       ; $6067
    xor [hl]                                      ; $6068
    ld e, a                                       ; $6069
    dec bc                                        ; $606A
    ld a, b                                       ; $606B
    or c                                          ; $606C
    inc hl                                        ; $606D
    jr nz, jr_006_6064                            ; $606E

    ld a, e                                       ; $6070
    ld [wUnusedLinkBufXor], a                     ; $6071
    ld a, d                                       ; $6074
    ld [wUnusedLinkBufSum], a                     ; $6075
    ret                                           ; $6078


; C: $DA00-$DA01 - 1; Z when it reaches 0
Link_CountdownDA00::
    ld hl, wMode09_State0A_DA00                   ; $6079
    dec [hl]                                      ; $607C
    ld a, [hl+]                                   ; $607D
    cp $ff                                        ; $607E
    jr nz, jr_006_6083                            ; $6080

    dec [hl]                                      ; $6082

jr_006_6083:
    ld a, [hl-]                                   ; $6083
    or [hl]                                       ; $6084
    ret                                           ; $6085


; C: received boy $DAD1 and girl $DAD2 + 1 in BCD (at most 99) by the bits 0 / 1 of [$CFFF], counters loaded and saved
Counters_AddReceived::
    ld b, BANK(Counters_Load)                     ; $6086
    ld hl, Counters_Load                          ; $6088
    call Far_Call                                 ; $608B
    ld hl, wCountReceivedBoy                      ; $608E
    ld a, [wLinkSenderGender]                     ; $6091
    ld b, a                                       ; $6094
    ld a, [hl]                                    ; $6095
    bit 0, b                                      ; $6096
    jr z, jr_006_60a1                             ; $6098

    cp $99                                        ; $609A
    jr z, jr_006_60a1                             ; $609C

    add $01                                       ; $609E
    daa                                           ; $60A0

jr_006_60a1:
    ld [hl+], a                                   ; $60A1
    ld a, [hl]                                    ; $60A2
    bit 1, b                                      ; $60A3
    jr z, jr_006_60ae                             ; $60A5

    cp $99                                        ; $60A7
    jr z, jr_006_60ae                             ; $60A9

    add $01                                       ; $60AB
    daa                                           ; $60AD

jr_006_60ae:
    ld [hl], a                                    ; $60AE
    ld b, BANK(Counters_Store)                    ; $60AF
    ld hl, Counters_Store                         ; $60B1
    call Far_Call                                 ; $60B4
    ret                                           ; $60B7


; C: runs in mode $08 state $01 in the linked exchange (BGB 2026-11-08, two units)
Exchange_RequestPage::
    push af                                       ; $60B8
    ld a, [wMode07_State02_D9FD]                  ; $60B9
    and a                                         ; $60BC
    jr nz, jr_006_60cb                            ; $60BD

    pop af                                        ; $60BF
    ld b, BANK(Photos_LoadPage8)                  ; $60C0
    ld hl, Photos_LoadPage8                       ; $60C2
    call Far_CallKeepA                            ; $60C5
    jp Far_ReturnSramBank                         ; $60C8


jr_006_60cb:
    pop af                                        ; $60CB
    ld [wLnkSlot], a                              ; $60CC
    call Link_QueuePageRequest                    ; $60CF
    ld a, $b4                                     ; $60D2
    ld [wMode09_State0A_DA00], a                  ; $60D4
    xor a                                         ; $60D7
    ld [wMode09_State0A_DA01], a                  ; $60D8

jr_006_60db:
    call Link_CountdownDA00                       ; $60DB
    jr z, jr_006_6125                             ; $60DE

    rst Rst08_WaitVBlank                          ; $60E0
    ld a, [wLnkHalfDone]                          ; $60E1
    and a                                         ; $60E4
    jr z, jr_006_60db                             ; $60E5

    ld hl, wMode07_StateTable_D9FC                ; $60E7
    ld a, [wExchange_RequestPage_D9FF]            ; $60EA
    sra a                                         ; $60ED
    sra a                                         ; $60EF
    sra a                                         ; $60F1
    cp [hl]                                       ; $60F3
    jr c, jr_006_60fa                             ; $60F4

    jr z, jr_006_60fe                             ; $60F6

    jr jr_006_6121                                ; $60F8

jr_006_60fa:
    ld a, $08                                     ; $60FA
    jr jr_006_6105                                ; $60FC

jr_006_60fe:
    ld a, [wExchange_RequestPage_D9FF]            ; $60FE
    cpl                                           ; $6101
    and $07                                       ; $6102
    inc a                                         ; $6104

jr_006_6105:
    ld c, a                                       ; $6105
    cpl                                           ; $6106
    inc a                                         ; $6107
    and $07                                       ; $6108
    ld e, $00                                     ; $610A
    ld d, a                                       ; $610C
    ld hl, $c000                                  ; $610D
    add hl, de                                    ; $6110

jr_006_6111:
    push bc                                       ; $6111
    ld de, Gfx_17_7800_Mode08_ExchangePhotoTrain_State00 ; $6112
    ld a, $17                                     ; $6115
    ld bc, $0100                                  ; $6117
    call Copy_FarDEtoHL                           ; $611A
    pop bc                                        ; $611D
    dec c                                         ; $611E
    jr nz, jr_006_6111                            ; $611F

jr_006_6121:
    and a                                         ; $6121
    jp Far_ReturnSramBank                         ; $6122


jr_006_6125:
    scf                                           ; $6125
    jp Far_ReturnSramBank                         ; $6126


; C: named by the code of PhotoTrain_LoadPageMap (06:613A); read in the runs by PhotoTrain_LoadPageMap; first read on
; the screen Mode08_ExchangePhotoTrain_State00 (trace/read_screens_kitty*.npz)
PhotoTrain_LoadPageMap_Tbl6129::
    db $00, $70

    db $00, $74, $00, $78, $00, $7c, $21, $00, $98

; C: the map of page A (pointer table 06:6129, bank $16) into HL ($9800 in mode $08 state $00); runs in the linked
; exchange (BGB 2026-11-08)
PhotoTrain_LoadPageMap::
    push de                                       ; $6134
    sla a                                         ; $6135
    ld c, a                                       ; $6137
    ld b, $00                                     ; $6138
    ld hl, PhotoTrain_LoadPageMap_Tbl6129         ; $613A
    add hl, bc                                    ; $613D
    ld a, [hl+]                                   ; $613E
    ld e, a                                       ; $613F
    ld a, [hl+]                                   ; $6140
    ld d, a                                       ; $6141
    pop hl                                        ; $6142
    ld bc, $0260                                  ; $6143
    ld a, $16                                     ; $6146
    call Copy_FarDEtoHL                           ; $6148
    jp Far_Return                                 ; $614B


    db $d5, $cb, $27, $4f, $06, $00, $21, $29, $61, $09, $2a, $5f, $2a, $57, $e1, $01
    db $60, $02, $3e, $16, $cd, $26, $07, $c3, $73, $01

; C: 8 x the same 256 bytes of 17:7800 (the empty-slot picture) into $9000-$97FF; mode $08 state $00, runs in the
; linked exchange (BGB 2026-11-08)
PhotoTrain_FillEmptyTiles::
    ld hl, $9000                                  ; $6168
    ld b, $08                                     ; $616B

jr_006_616d:
    push bc                                       ; $616D
    ld de, Gfx_17_7800_Mode08_ExchangePhotoTrain_State00 ; $616E
    ld bc, $0100                                  ; $6171
    ld a, $17                                     ; $6174
    call Copy_FarDEtoHL                           ; $6176
    pop bc                                        ; $6179
    dec b                                         ; $617A
    jr nz, jr_006_616d                            ; $617B

    jp Far_Return                                 ; $617D


    db $21, $00, $90, $06, $08, $c5, $11, $00, $78, $01, $00, $01, $3e, $17, $cd, $26
    db $07, $c1, $05, $20, $f0, $c3, $73, $01

; C: handler of state $00 of mode $07 (word 0 of Mode07_StateTable)
Mode07_State00::
    di                                            ; $6198
    call Lcd_Off                                  ; $6199
    call Oam_ClearShadow                          ; $619C
    ld b, BANK(Objects_ClearAll)                  ; $619F
    ld hl, Objects_ClearAll                       ; $61A1
    call Far_Call                                 ; $61A4
    ld b, BANK(ScriptSlots_Clear)                 ; $61A7
    ld hl, ScriptSlots_Clear                      ; $61A9
    call Far_Call                                 ; $61AC
    call Copy_FarInline                           ; $61AF

    db $00, $6b, $1d, $00, $80, $40, $14

    call Copy_FarInline                           ; $61B9

    db $e0, $71, $26, $00, $98, $40, $02

    call Copy_FarInline                           ; $61C3

    db $e0, $75, $26, $00, $9c, $40, $02

    xor a                                         ; $61CD
    ld [wMode08_State02_D8FA], a                  ; $61CE
    xor a                                         ; $61D1
    ld [wMode07_StateTable_D9FC], a               ; $61D2
    ld a, $01                                     ; $61D5
    ld [wMode07_StateTable_D9FB], a               ; $61D7
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $61DA
    ld c, $00                                     ; $61DC
    call Mode_SaveReturnD8F2                      ; $61DE
    call Serial_SetFarCallback                    ; $61E1

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $61E7

    db $87, $e4, $d0, $e4, $00, $00, $00, $00, $ff, $00, $01

    xor a                                         ; $61F5
    ldh [rSB], a                                  ; $61F6
    ldh [rSC], a                                  ; $61F8
    ld [wLnkPages], a                             ; $61FA
    xor a                                         ; $61FD
    ld [wLnkConnected], a                         ; $61FE
    push af                                       ; $6201
    ld a, MUSIC_EXCHANGE                          ; $6202
    ld [wSndMusicReq], a                          ; $6204
    pop af                                        ; $6207
    ld a, $02                                     ; $6208
    ld [wFrame_UpdateAll_D8E5], a                 ; $620A
    xor a                                         ; $620D
    ld [wFrame_UpdateAll_DD40], a                 ; $620E
    ld de, ObjScript_02_7C68_Mode07_Exchange_State02 + $1C ; $6211
    call Object_Create                            ; $6214
    ld de, ObjScript_02_7C68_Mode07_Exchange_State02 + $2A ; $6217
    call Object_Create                            ; $621A
    ld de, ObjScript_02_7C68_Mode07_Exchange_State02 + $38 ; $621D
    call Object_Create                            ; $6220
    ld bc, $580e                                  ; $6223
    ld de, ObjScript_02_7C68_Mode07_Exchange_State02 + $3E ; $6226
    call Object_CreateWithParam                   ; $6229
    ld b, MODE_EXCHANGE                           ; $622C
    ld c, $01                                     ; $622E
    call Fade_GoTo                                ; $6230
    ei                                            ; $6233
    ret                                           ; $6234


; C: handler of state $01 of mode $07 (word 1 of Mode07_StateTable)
Mode07_State01::
    di                                            ; $6235
    ld a, $02                                     ; $6236
    ldh [hState], a                               ; $6238
    call Link_Init                                ; $623A
    ld a, [wAlbum_SlotOp6D18_D932]                ; $623D
    cp $1e                                        ; $6240
    ccf                                           ; $6242
    rl a                                          ; $6243
    and $01                                       ; $6245
    ld [wLnkAlbumFull], a                         ; $6247
    ld a, [wAlbum_SlotOp6D18_D932]                ; $624A
    ld [wLnkOwnCount], a                          ; $624D
    ld b, $d2                                     ; $6250

jr_006_6252:
    dec b                                         ; $6252
    jr nz, jr_006_6252                            ; $6253

    ei                                            ; $6255

; C: handler of state $02 of mode $07 (word 2 of Mode07_StateTable)
Mode07_State02::
    ld a, [wFadeRunning]                          ; $6256
    and a                                         ; $6259
    ret nz                                        ; $625A

    call Link_UpdateInfoByte                      ; $625B
    jr z, jr_006_6279                             ; $625E

    ld a, [wLnkRoleRx]                            ; $6260
    ld [wMode07_State02_D9FD], a                  ; $6263
    push af                                       ; $6266
    ld a, SFX1_29                                 ; $6267
    ld [wSndSfx1], a                              ; $6269
    pop af                                        ; $626C
    xor a                                         ; $626D
    ld [wMode07_StateTable_D8E0], a               ; $626E
    ld b, MODE_EXCHANGE                           ; $6271
    ld c, $04                                     ; $6273
    call ModeState_Set                            ; $6275
    ret                                           ; $6278


jr_006_6279:
    ld a, [wKeysNew]                              ; $6279
    bit PADB_LEFT, a                              ; $627C
    jr z, jr_006_628b                             ; $627E

    push af                                       ; $6280
    ld a, SFX1_EXCHANGE_1E                        ; $6281
    ld [wSndSfx1], a                              ; $6283
    pop af                                        ; $6286
    xor a                                         ; $6287
    ld [wMode07_State02_D9FD], a                  ; $6288

jr_006_628b:
    ld a, [wKeysNew]                              ; $628B
    bit PADB_RIGHT, a                             ; $628E
    jr z, jr_006_629e                             ; $6290

    push af                                       ; $6292
    ld a, SFX1_EXCHANGE_1E                        ; $6293
    ld [wSndSfx1], a                              ; $6295
    pop af                                        ; $6298
    ld a, $01                                     ; $6299
    ld [wMode07_State02_D9FD], a                  ; $629B

jr_006_629e:
    ld a, [wKeysNew]                              ; $629E
    bit PADB_A, a                                 ; $62A1
    jr z, jr_006_62b8                             ; $62A3

    ld a, [wMode07_State02_D9FD]                  ; $62A5
    and a                                         ; $62A8
    jr z, jr_006_62ad                             ; $62A9

    ld a, $80                                     ; $62AB

jr_006_62ad:
    ld hl, wLnkOwnCount                           ; $62AD
    res 7, [hl]                                   ; $62B0
    or [hl]                                       ; $62B2
    ld [hl], a                                    ; $62B3
    call Link_SendHello29                         ; $62B4
    ret                                           ; $62B7


jr_006_62b8:
    ld a, [wKeysNew]                              ; $62B8
    bit PADB_B, a                                 ; $62BB
    jr z, jr_006_62d7                             ; $62BD

    push af                                       ; $62BF
    ld a, SFX3_09                                 ; $62C0
    ld [wSndSfx3], a                              ; $62C2
    pop af                                        ; $62C5
    call Link_Stop                                ; $62C6
    jr nz, jr_006_62d7                            ; $62C9

    xor a                                         ; $62CB
    ld [wLnkConnected], a                         ; $62CC
    ld b, MODE_MAIN_MENU                          ; $62CF
    ld c, $03                                     ; $62D1
    call Fade_GoToB                               ; $62D3
    ret                                           ; $62D6


jr_006_62d7:
    ld a, [wLnkAbortReason]                       ; $62D7
    and a                                         ; $62DA
    jr z, jr_006_62e8                             ; $62DB

    ld c, a                                       ; $62DD
    ld b, $00                                     ; $62DE
    ld hl, Mode07_State02_62E8                    ; $62E0
    add hl, bc                                    ; $62E3
    ld a, [hl]                                    ; $62E4
    call Message_Show                             ; $62E5

jr_006_62e8:
Mode07_State02_62E8:
    ret                                           ; $62E8


; C: read in the runs by Mode07_State02; first read on the screen Mode14_MessageScreen_State00
; (trace/read_screens_kitty*.npz)
Mode07_State02_Tbl62E9::
    db $00, $08, $02, $01

; C: handler of state $03 of mode $07 (word 3 of Mode07_StateTable)
Mode07_State03::
    xor a                                         ; $62ED
    ld [wMode07_StateTable_D8E0], a               ; $62EE
    ld b, MODE_EXCHANGE                           ; $62F1
    ld c, $04                                     ; $62F3
    call ModeState_Set                            ; $62F5
    ret                                           ; $62F8


; C: handler of state $04 of mode $07 (word 4 of Mode07_StateTable)
Mode07_State04::
    ld a, [wMode07_StateTable_D8E0]               ; $62F9
    bit 2, a                                      ; $62FC
    jr z, jr_006_6317                             ; $62FE

    ld a, [wLnkInitiator]                         ; $6300
    cp $01                                        ; $6303
    jr nz, jr_006_630f                            ; $6305

    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $6307
    ld c, $00                                     ; $6309
    call Fade_GoToB                               ; $630B
    ret                                           ; $630E


jr_006_630f:
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $630F
    ld c, $08                                     ; $6311
    call Fade_GoToB                               ; $6313
    ret                                           ; $6316


jr_006_6317:
    ret                                           ; $6317


; C: ModeTable entry $07: BGB screen 07:02 (give / receive)
Mode07_Exchange::
    ldh a, [hState]                               ; $6318
    ld hl, Mode07_StateTable                      ; $631A
    call JumpTable_ByA                            ; $631D
    jp Far_Return                                 ; $6320


; C: state table of mode $07, read by $0189 with hFF8E
Mode07_StateTable::
    dw Mode07_State00
    dw Mode07_State01
    dw Mode07_State02
    dw Mode07_State03
    dw Mode07_State04

    db $40, $1c, $ff, $02, $ff, $03, $01, $00

    db $40, $1c, $00, $02, $ff, $04, $01, $00, $68, $1c, $01, $49, $ff, $05, $02, $00
    db $20, $4c, $ff, $04, $00, $06, $03, $00, $48, $4c, $03, $05, $01, $07, $04, $00
    db $70, $4c, $04, $4c, $02, $08, $05, $00, $28, $7c, $ff, $07, $03, $ff, $06, $00
    db $50, $7c, $06, $08, $04, $ff, $07, $00, $78, $7c, $07, $4f, $05, $ff, $08, $00
    db $40, $1c, $82, $0b, $ff, $0c, $09, $00, $40, $1c, $82, $0b, $ff, $0d, $09, $00
    db $68, $1c, $0a, $52, $ff, $0e, $0a, $00, $20, $4c, $85, $0d, $09, $0f, $0b, $00
    db $48, $4c, $0c, $0e, $0a, $10, $0c, $00, $70, $4c, $0d, $55, $0b, $11, $0d, $00
    db $28, $7c, $88, $10, $0c, $ff, $0e, $00, $50, $7c, $0f, $11, $0d, $ff, $0f, $00
    db $78, $7c, $10, $58, $0e, $ff, $10, $00, $40, $1c, $8b, $14, $ff, $15, $11, $00
    db $40, $1c, $8b, $14, $ff, $16, $11, $00, $68, $1c, $13, $5b, $ff, $17, $12, $00
    db $20, $4c, $8e, $16, $12, $18, $13, $00, $48, $4c, $15, $17, $13, $19, $14, $00
    db $70, $4c, $16, $5e, $14, $1a, $15, $00, $28, $7c, $91, $19, $15, $ff, $16, $00
    db $50, $7c, $18, $1a, $16, $ff, $17, $00, $78, $7c, $19, $61, $17, $ff, $18, $00
    db $40, $1c, $94, $1d, $ff, $1e, $19, $00, $40, $1c, $94, $1d, $ff, $1f, $19, $00
    db $68, $1c, $1c, $ff, $ff, $20, $1a, $00, $20, $4c, $97, $1f, $1b, $21, $1b, $00
    db $48, $4c, $1e, $20, $1c, $ff, $1c, $00, $70, $4c, $1f, $ff, $1d, $ff, $1d, $00
    db $28, $7c, $9a, $ff, $1e, $ff, $1e, $00

    call Call_006_6443                            ; $643D
    jp Far_Return                                 ; $6440


Call_006_6443:
    ld a, [wFadeRunning]                          ; $6443
    and a                                         ; $6446
    jr nz, jr_006_646a                            ; $6447

    ld de, $0002                                  ; $6449
    ld a, [wKeysNewRepeat]                        ; $644C
    bit PADB_LEFT, a                              ; $644F
    jr nz, jr_006_648a                            ; $6451

    inc e                                         ; $6453
    bit 4, a                                      ; $6454
    jr nz, jr_006_648a                            ; $6456

    inc e                                         ; $6458
    bit 6, a                                      ; $6459
    jr nz, jr_006_648a                            ; $645B

    inc e                                         ; $645D
    bit 7, a                                      ; $645E
    jr nz, jr_006_648a                            ; $6460

    inc e                                         ; $6462
    ld a, [wKeysNew]                              ; $6463
    bit PADB_A, a                                 ; $6466
    jr nz, jr_006_64e0                            ; $6468

jr_006_646a:
    ldh a, [hMode07_StateTable_FFD1]              ; $646A
    ld c, a                                       ; $646C
    ldh a, [hMode07_StateTable_FFD3]              ; $646D
    ld b, a                                       ; $646F
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $6470
    ld l, a                                       ; $6473
    ld h, $00                                     ; $6474
    sla l                                         ; $6476
    rl h                                          ; $6478
    sla l                                         ; $647A
    rl h                                          ; $647C
    sla l                                         ; $647E
    rl h                                          ; $6480
    add hl, bc                                    ; $6482
    ld a, [hl+]                                   ; $6483
    ldh [hMode07_StateTable_FFD2], a              ; $6484
    ld a, [hl+]                                   ; $6486
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $6487
    ret                                           ; $6489


jr_006_648a:
    ldh a, [hMode07_StateTable_FFD1]              ; $648A
    ld c, a                                       ; $648C
    ldh a, [hMode07_StateTable_FFD3]              ; $648D
    ld b, a                                       ; $648F
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $6490
    ld l, a                                       ; $6493
    ld h, $00                                     ; $6494
    sla l                                         ; $6496
    rl h                                          ; $6498
    sla l                                         ; $649A
    rl h                                          ; $649C
    sla l                                         ; $649E
    rl h                                          ; $64A0
    add hl, bc                                    ; $64A2
    add hl, de                                    ; $64A3
    ld a, [hl]                                    ; $64A4
    cp $ff                                        ; $64A5
    jr z, jr_006_64df                             ; $64A7

    push af                                       ; $64A9
    and $3f                                       ; $64AA
    ld [wMenu07_CursorUpdate_D8F4], a             ; $64AC
    ld l, a                                       ; $64AF
    ld h, $00                                     ; $64B0
    sla l                                         ; $64B2
    rl h                                          ; $64B4
    sla l                                         ; $64B6
    rl h                                          ; $64B8
    sla l                                         ; $64BA
    rl h                                          ; $64BC
    add hl, bc                                    ; $64BE
    ld a, [hl+]                                   ; $64BF
    ldh [hMode07_StateTable_FFD2], a              ; $64C0
    ld a, [hl+]                                   ; $64C2
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $64C3
    ld bc, $0004                                  ; $64C5
    add hl, bc                                    ; $64C8
    ld a, [hl]                                    ; $64C9
    ld [wMode07_StateTable_D9FB], a               ; $64CA
    pop af                                        ; $64CD
    bit 7, a                                      ; $64CE
    jp nz, Jump_006_6554                          ; $64D0

    bit 6, a                                      ; $64D3
    jp nz, Jump_006_6573                          ; $64D5

    push af                                       ; $64D8
    ld a, SFX1_20                                 ; $64D9
    ld [wSndSfx1], a                              ; $64DB
    pop af                                        ; $64DE

jr_006_64df:
    ret                                           ; $64DF


jr_006_64e0:
    ld hl, wExchange_RequestPage_D9FF             ; $64E0
    ld a, [wMode07_StateTable_D9FB]               ; $64E3
    dec a                                         ; $64E6
    cp [hl]                                       ; $64E7
    ccf                                           ; $64E8
    ret c                                         ; $64E9

    push af                                       ; $64EA
    ld a, SFX1_19                                 ; $64EB
    ld [wSndSfx1], a                              ; $64ED
    pop af                                        ; $64F0
    ldh a, [hMode07_StateTable_FFD1]              ; $64F1
    ld c, a                                       ; $64F3
    ldh a, [hMode07_StateTable_FFD3]              ; $64F4
    ld b, a                                       ; $64F6
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $64F7
    ld l, a                                       ; $64FA
    ld h, $00                                     ; $64FB
    sla l                                         ; $64FD
    rl h                                          ; $64FF
    sla l                                         ; $6501
    rl h                                          ; $6503
    sla l                                         ; $6505
    rl h                                          ; $6507
    add hl, bc                                    ; $6509
    add hl, de                                    ; $650A
    ld a, [hl+]                                   ; $650B
    ldh [hMenuMode], a                            ; $650C
    ld a, [hl+]                                   ; $650E
    ldh [hMenuState], a                           ; $650F
    ld a, $01                                     ; $6511
    ld [wMode07_StateTable_D8E0], a               ; $6513
    ldh a, [hMode07_StateTable_FFD2]              ; $6516
    ldh [hExchange_ObjFollowD9FD_FFD8], a         ; $6518
    cp $50                                        ; $651A
    jr c, jr_006_6526                             ; $651C

    ld de, $7dfc                                  ; $651E
    call Call_000_2205                            ; $6521
    jr jr_006_652c                                ; $6524

jr_006_6526:
    ld de, $7df0                                  ; $6526
    call Call_000_2205                            ; $6529

jr_006_652c:
    ld a, $d0                                     ; $652C
    ldh [hMode07_StateTable_FFD2], a              ; $652E
    ld a, [wMode07_StateTable_D9FB]               ; $6530
    dec a                                         ; $6533
    and $07                                       ; $6534
    ld c, $00                                     ; $6536
    ld b, a                                       ; $6538
    ld hl, $c000                                  ; $6539
    add hl, bc                                    ; $653C
    push hl                                       ; $653D
    ld e, l                                       ; $653E
    ld d, h                                       ; $653F
    ld hl, $8700                                  ; $6540
    ld bc, $0100                                  ; $6543
    call Vram_CopyHBlank                          ; $6546
    pop hl                                        ; $6549
    ld de, $0000                                  ; $654A
    ld bc, $0100                                  ; $654D
    call Mem_FillWord                             ; $6550
    ret                                           ; $6553


Jump_006_6554:
    ld a, $04                                     ; $6554
    ld [wMode07_StateTable_D8E0], a               ; $6556
    xor a                                         ; $6559
    ldh [hCopyReqSrcDstCnt + $4], a               ; $655A
    ldh [hMode07_StateTable_FFD0], a              ; $655C
    push af                                       ; $655E
    ld a, SFX3_MODE07_EXCHANGE_01                 ; $655F
    ld [wSndSfx3], a                              ; $6561
    pop af                                        ; $6564
    ld a, [wMode07_StateTable_D9FC]               ; $6565
    dec a                                         ; $6568
    ld [wMode07_StateTable_D9FC], a               ; $6569
    ld de, $7cb5                                  ; $656C
    call Call_000_2205                            ; $656F
    ret                                           ; $6572


Jump_006_6573:
    ld a, $04                                     ; $6573
    ld [wMode07_StateTable_D8E0], a               ; $6575
    xor a                                         ; $6578
    ldh [hCopyReqSrcDstCnt + $4], a               ; $6579
    ldh [hMode07_StateTable_FFD0], a              ; $657B
    push af                                       ; $657D
    ld a, SFX3_MODE07_EXCHANGE_01                 ; $657E
    ld [wSndSfx3], a                              ; $6580
    pop af                                        ; $6583
    ld a, [wMode07_StateTable_D9FC]               ; $6584
    inc a                                         ; $6587
    ld [wMode07_StateTable_D9FC], a               ; $6588
    ld de, $7d45                                  ; $658B
    call Call_000_2205                            ; $658E
    ret                                           ; $6591


    ldh a, [hMode07_StateTable_FFD1]              ; $6592
    ld c, a                                       ; $6594
    ldh a, [hMode07_StateTable_FFD3]              ; $6595
    ld b, a                                       ; $6597
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $6598
    ld l, a                                       ; $659B
    ld h, $00                                     ; $659C
    sla l                                         ; $659E
    rl h                                          ; $65A0
    sla l                                         ; $65A2
    rl h                                          ; $65A4
    sla l                                         ; $65A6
    rl h                                          ; $65A8
    add hl, bc                                    ; $65AA
    ld a, [hl+]                                   ; $65AB
    ldh [hMode07_StateTable_FFD2], a              ; $65AC
    ldh [hExchange_ObjFollowD9FD_FFD8], a         ; $65AE
    ld a, [hl+]                                   ; $65B0
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $65B1
    jp Far_Return                                 ; $65B3


; C: handler of state $00 of mode $08 (word 0 of Mode08_StateTable)
Mode08_State00::
    ld hl, wStatShadow                            ; $65B6
    res 6, [hl]                                   ; $65B9
    ld hl, rIE                                    ; $65BB
    res 1, [hl]                                   ; $65BE
    ld hl, wLcdcShadow                            ; $65C0
    res 7, [hl]                                   ; $65C3
    ld hl, $ff40                                  ; $65C5

jr_006_65c8:
    bit 7, [hl]                                   ; $65C8
    jr nz, jr_006_65c8                            ; $65CA

    call Oam_ClearShadow                          ; $65CC
    ld b, BANK(Objects_ClearAll)                  ; $65CF
    ld hl, Objects_ClearAll                       ; $65D1
    call Far_Call                                 ; $65D4
    ld b, BANK(ScriptSlots_Clear)                 ; $65D7
    ld hl, ScriptSlots_Clear                      ; $65D9
    call Far_Call                                 ; $65DC
    call Copy_FarInline                           ; $65DF

    db $00, $70, $17, $00, $80, $00, $10

    ld a, [wMode08_State02_D8FA]                  ; $65E9
    ld [wMenu07_CursorUpdate_D8F4], a             ; $65EC
    ld a, [wLnkRoleRx]                            ; $65EF
    and a                                         ; $65F2
    jr nz, jr_006_65fc                            ; $65F3

    ld a, [wLnkOwnCount]                          ; $65F5
    res 7, a                                      ; $65F8
    jr jr_006_65ff                                ; $65FA

jr_006_65fc:
    ld a, [wLnkPeerCount]                         ; $65FC

jr_006_65ff:
    ld [wExchange_RequestPage_D9FF], a            ; $65FF
    call Serial_SetFarCallback                    ; $6602

    dwb Frame_UpdateAll

    ld b, BANK(PhotoTrain_FillEmptyTiles)         ; $6608
    ld hl, PhotoTrain_FillEmptyTiles              ; $660A
    call Far_Call                                 ; $660D
    ld a, [wMode07_StateTable_D9FC]               ; $6610
    ld de, $9800                                  ; $6613
    ld b, BANK(PhotoTrain_LoadPageMap)            ; $6616
    ld hl, PhotoTrain_LoadPageMap                 ; $6618
    call Far_CallKeepA                            ; $661B
    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $661E
    ld c, $01                                     ; $6620
    call Fade_GoTo                                ; $6622
    call Lcd_SetupInlineNoIE                      ; $6625

    db $c3, $e4, $e4, $d0, $00, $04, $a0, $04, $ff, $00

    ld hl, wStatShadow                            ; $6632
    res 6, [hl]                                   ; $6635
    ld hl, rIE                                    ; $6637
    res 1, [hl]                                   ; $663A
    push af                                       ; $663C
    ld a, MUSIC_EXCHANGE_PHOTO_TRAIN              ; $663D
    ld [wSndMusicReq], a                          ; $663F
    pop af                                        ; $6642
    ret                                           ; $6643


; C: handler of state $01 of mode $08 (word 1 of Mode08_StateTable)
Mode08_State01::
    ld a, [wMode07_StateTable_D9FC]               ; $6644
    ld b, BANK(Exchange_RequestPage)              ; $6647
    ld hl, Exchange_RequestPage                   ; $6649
    call Far_CallKeepA                            ; $664C
    jp c, Jump_006_666c                           ; $664F

    ld de, $c000                                  ; $6652
    ld hl, $9000                                  ; $6655
    ld bc, $0800                                  ; $6658
    call Vram_CopyHBlank                          ; $665B
    ld de, ObjScript_02_7E32_Mode0C_RecordBook_State01 ; $665E
    call Object_Create                            ; $6661
    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $6664
    ld c, STATE_08_EXCHANGE_PICK_PHOTO_GIVE       ; $6666
    call ModeState_Set                            ; $6668
    ret                                           ; $666B


Jump_006_666c:
    ld a, $03                                     ; $666C
    call Message_Show                             ; $666E
    ret                                           ; $6671


    db $06, $09, $0e, $00, $cd, $c8, $01, $c9

; C: handler of state $02 of mode $08 (word 2 of Mode08_StateTable)
Mode08_State02::
    ld a, [wMode07_StateTable_D8E0]               ; $667A
    bit 2, a                                      ; $667D
    jr z, jr_006_6689                             ; $667F

    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $6681
    ld c, $03                                     ; $6683
    call ModeState_Set                            ; $6685
    ret                                           ; $6688


jr_006_6689:
    ld a, [wMode07_StateTable_D8E0]               ; $6689
    bit 0, a                                      ; $668C
    jr z, jr_006_669e                             ; $668E

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $6690
    ld [wMode08_State02_D8FA], a                  ; $6693
    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $6696
    ld c, $04                                     ; $6698
    call ModeState_Set                            ; $669A
    ret                                           ; $669D


jr_006_669e:
    ld a, [wKeysNew]                              ; $669E
    bit PADB_B, a                                 ; $66A1
    jr z, jr_006_66c2                             ; $66A3

    push af                                       ; $66A5
    ld a, SFX3_09                                 ; $66A6
    ld [wSndSfx3], a                              ; $66A8
    pop af                                        ; $66AB
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $66AC
    ld [wMode08_State02_D8FA], a                  ; $66AF
    ld a, $ef                                     ; $66B2
    ld [wLnkCmdTx], a                             ; $66B4
    call Link_QueueCommand                        ; $66B7
    ld b, MODE_MAIN_MENU                          ; $66BA
    ld c, $03                                     ; $66BC
    call Fade_GoToB                               ; $66BE
    ret                                           ; $66C1


jr_006_66c2:
    ret                                           ; $66C2


; C: handler of state $04 of mode $08 (word 4 of Mode08_StateTable)
Mode08_State04::
    xor a                                         ; $66C3
    ld [wMode07_StateTable_D8E0], a               ; $66C4
    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $66C7
    ld c, $05                                     ; $66C9
    call ModeState_Set                            ; $66CB
    ret                                           ; $66CE


; C: handler of state $05 of mode $08 (word 5 of Mode08_StateTable)
Mode08_State05::
    ld a, [wMode07_StateTable_D8E0]               ; $66CF
    bit 0, a                                      ; $66D2
    jr z, jr_006_66f3                             ; $66D4

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $66D6
    ld [wMode08_State02_D8FA], a                  ; $66D9
    ld a, [wMode07_State02_D9FD]                  ; $66DC
    and a                                         ; $66DF
    jp nz, Jump_006_66eb                          ; $66E0

    ld b, MODE_EXCHANGE_COMMUNICATING             ; $66E3
    ld c, $01                                     ; $66E5
    call Fade_GoToB                               ; $66E7
    ret                                           ; $66EA


Jump_006_66eb:
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $66EB
    ld c, $03                                     ; $66ED
    call Fade_GoToB                               ; $66EF
    ret                                           ; $66F2


jr_006_66f3:
    ret                                           ; $66F3


; C: handler of state $03 of mode $08 (word 3 of Mode08_StateTable)
Mode08_State03::
    xor a                                         ; $66F4
    ld [wMode07_StateTable_D8E0], a               ; $66F5
    ld a, [wMode07_StateTable_D9FC]               ; $66F8
    ld b, BANK(Exchange_RequestPage)              ; $66FB
    ld hl, Exchange_RequestPage                   ; $66FD
    call Far_CallKeepA                            ; $6700
    jp c, Jump_006_670e                           ; $6703

    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $6706
    ld c, STATE_08_EXCHANGE_PICK_PHOTO_GIVE       ; $6708
    call ModeState_Set                            ; $670A
    ret                                           ; $670D


Jump_006_670e:
    ld a, $03                                     ; $670E
    call Message_Show                             ; $6710
    ret                                           ; $6713


    db $06, $09, $0e, $00, $cd, $c8, $01, $c9

; C: ModeTable entry $08: BGB linked exchange (two units): the giving unit chooses its photo on the photo train
; (states $00-$05)
Mode08_ExchangePhotoTrain::
    ldh a, [hState]                               ; $671C
    ld hl, Mode08_StateTable                      ; $671E
    call JumpTable_ByA                            ; $6721
    jp Far_Return                                 ; $6724


; C: state table of mode $08, read by $0189 with hFF8E
Mode08_StateTable::
    dw Mode08_State00
    dw Mode08_State01
    dw Mode08_State02
    dw Mode08_State03
    dw Mode08_State04
    dw Mode08_State05

; C: handler of state $00 of mode $09 (word 0 of Mode09_StateTable)
Mode09_State00::
    call Delay_Inline                             ; $6733

    dw $0001

    call Link_Stop                                ; $6738
    jr nz, Mode09_State00                         ; $673B

    xor a                                         ; $673D
    ld [wLnkConnected], a                         ; $673E
    ld b, MODE_MAIN_MENU                          ; $6741
    ld c, $03                                     ; $6743
    call ModeState_Set                            ; $6745
    ret                                           ; $6748


; C: handler of state $01 of mode $09 (word 1 of Mode09_StateTable)
Mode09_State01::
    ld hl, wStatShadow                            ; $6749
    res 6, [hl]                                   ; $674C
    ld hl, $ff41                                  ; $674E
    res 6, [hl]                                   ; $6751
    ld hl, rIE                                    ; $6753
    res 1, [hl]                                   ; $6756
    ld hl, wLcdcShadow                            ; $6758
    res 7, [hl]                                   ; $675B
    ld hl, $ff40                                  ; $675D

jr_006_6760:
    bit 7, [hl]                                   ; $6760
    jr nz, jr_006_6760                            ; $6762

    call Oam_ClearShadow                          ; $6764
    ld b, BANK(Objects_ClearAll)                  ; $6767
    ld hl, Objects_ClearAll                       ; $6769
    call Far_Call                                 ; $676C
    ld b, BANK(ScriptSlots_Clear)                 ; $676F
    ld hl, ScriptSlots_Clear                      ; $6771
    call Far_Call                                 ; $6774
    call Mem_ZeroInline                           ; $6777

    db $00, $c0, $00, $10

    call Copy_FarInline                           ; $677E

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $6788

    db $f0, $75, $31, $00, $98, $00, $04

    call Stat_SetTileToggleAt4F                   ; $6792
    call Serial_SetFarCallback                    ; $6795

    dwb Frame_UpdateAll

    call Lcd_SetupInlineNoIE                      ; $679B

    db $87, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40

    ld a, [wMode07_StateTable_D9FB]               ; $67A8
    ld b, BANK(Photo_FindSlotA)                   ; $67AB
    ld hl, Photo_FindSlotA                        ; $67AD
    call Far_CallKeepA                            ; $67B0
    jr c, jr_006_67c8                             ; $67B3

    ld b, BANK(Photo_LoadToBufferAndVram)         ; $67B5
    ld hl, Photo_LoadToBufferAndVram              ; $67B7
    call Far_CallKeepA                            ; $67BA
    ld a, $28                                     ; $67BD
    call FrameRec_LoadDefault                     ; $67BF
    xor a                                         ; $67C2
    ld [wSlotTagBorder], a                        ; $67C3
    jr jr_006_67d2                                ; $67C6

jr_006_67c8:
    ld a, $01                                     ; $67C8
    call Photo_LoadEmptyPicture                   ; $67CA
    ld a, $00                                     ; $67CD
    call FrameRec_LoadDefault                     ; $67CF

jr_006_67d2:
    ld de, wSlotTagOwnerCopy                      ; $67D2
    ld hl, $cf00                                  ; $67D5
    ld bc, $0055                                  ; $67D8
    call Copy_DEtoHL                              ; $67DB
    ld a, $01                                     ; $67DE
    ld [wFadeRunning], a                          ; $67E0
    ld a, $05                                     ; $67E3
    ld b, BANK(KeyPrompt_LoadSounds)              ; $67E5
    ld hl, KeyPrompt_LoadSounds                   ; $67E7
    call Far_CallKeepA                            ; $67EA
    ld a, [wIdCard + $d]                          ; $67ED
    ld [wLinkSenderGender], a                     ; $67F0
    call Link_SumSlotBuffer                       ; $67F3
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $67F6
    ld c, $02                                     ; $67F8
    call Fade_GoTo                                ; $67FA
    ld hl, wStatShadow                            ; $67FD
    set 6, [hl]                                   ; $6800
    ld hl, rIE                                    ; $6802
    set 1, [hl]                                   ; $6805
    ret                                           ; $6807


; C: handler of state $02 of mode $09 (word 2 of Mode09_StateTable)
Mode09_State02::
    ld a, [wMode06_State0A_D8DF]                  ; $6808
    bit 0, a                                      ; $680B
    jr z, jr_006_6817                             ; $680D

    ld b, MODE_EXCHANGE_COMMUNICATING             ; $680F
    ld c, $03                                     ; $6811
    call Fade_GoToB                               ; $6813
    ret                                           ; $6816


jr_006_6817:
    ld a, [wMode06_State0A_D8DF]                  ; $6817
    bit 1, a                                      ; $681A
    jr z, jr_006_6826                             ; $681C

    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $681E
    ld c, $00                                     ; $6820
    call Fade_GoToB                               ; $6822
    ret                                           ; $6825


jr_006_6826:
    ret                                           ; $6826


; C: handler of state $03 of mode $09 (word 3 of Mode09_StateTable)
Mode09_State03::
    ld hl, wStatShadow                            ; $6827
    res 6, [hl]                                   ; $682A
    ld hl, rIE                                    ; $682C
    res 1, [hl]                                   ; $682F
    ld hl, wLcdcShadow                            ; $6831
    res 7, [hl]                                   ; $6834
    ld hl, $ff40                                  ; $6836

jr_006_6839:
    bit 7, [hl]                                   ; $6839
    jr nz, jr_006_6839                            ; $683B

    call Oam_ClearShadow                          ; $683D
    ld b, BANK(Objects_ClearAll)                  ; $6840
    ld hl, Objects_ClearAll                       ; $6842
    call Far_Call                                 ; $6845
    ld b, BANK(ScriptSlots_Clear)                 ; $6848
    ld hl, ScriptSlots_Clear                      ; $684A
    call Far_Call                                 ; $684D
    call Copy_FarInline                           ; $6850

    db $00, $56, $1d, $00, $80, $00, $15

    call Copy_FarInline                           ; $685A

    db $80, $7c, $32, $00, $98, $40, $02

    ld a, $00                                     ; $6864
    ld [wMode09_State0A_DA00], a                  ; $6866
    ld a, $02                                     ; $6869
    ld [wMode09_State0A_DA01], a                  ; $686B
    call Serial_SetFarCallback                    ; $686E

    dwb Frame_UpdateAll

    call Lcd_SetupInlineNoIE                      ; $6874

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00

    ld hl, wStatShadow                            ; $6881
    res 6, [hl]                                   ; $6884
    ld hl, rIE                                    ; $6886
    res 1, [hl]                                   ; $6889
    push af                                       ; $688B
    ld a, MUSIC_EXCHANGE_COMMUNICATING            ; $688C
    ld [wSndMusicReq], a                          ; $688E
    pop af                                        ; $6891
    ld de, ObjScript_00_1EB4_Mode09_ExchangeCommunicating_State03; $6892
    call Object_Create                            ; $6895
    ld de, ObjScript_00_1E1B_Mode09_ExchangeCommunicating_State03; $6898
    call Object_Create                            ; $689B
    ld de, ObjScript_00_1E44_Mode09_ExchangeCommunicating_State03; $689E
    call Object_Create                            ; $68A1
    ld a, [wMode07_State02_D9FD]                  ; $68A4
    and a                                         ; $68A7
    jr nz, jr_006_68c0                            ; $68A8

    ld a, [wMode07_StateTable_D9FC]               ; $68AA
    ld [wLnkSlot], a                              ; $68AD
    ld a, $01                                     ; $68B0
    ld [wLnkReadyTx], a                           ; $68B2
    call Link_QueueCommand                        ; $68B5
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $68B8
    ld c, $05                                     ; $68BA
    call Fade_GoTo                                ; $68BC
    ret                                           ; $68BF


jr_006_68c0:
    ld a, [wMode07_StateTable_D9FB]               ; $68C0
    dec a                                         ; $68C3
    ld [wLnkSlot], a                              ; $68C4
    call Link_QueueCommand                        ; $68C7
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $68CA
    ld c, $04                                     ; $68CC
    call Fade_GoTo                                ; $68CE
    ret                                           ; $68D1


; C: handler of state $04 of mode $09 (word 4 of Mode09_StateTable)
Mode09_State04::
    ld a, $01                                     ; $68D2
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $68D4
    ld a, [wLnkHalfDone]                          ; $68D7
    cp $01                                        ; $68DA
    jr nz, jr_006_68ec                            ; $68DC

    ld b, $14                                     ; $68DE

jr_006_68e0:
    rst Rst08_WaitVBlank                          ; $68E0
    dec b                                         ; $68E1
    jr nz, jr_006_68e0                            ; $68E2

    ld b, MODE_EXCHANGE_PHOTO_TRAIN               ; $68E4
    ld c, $00                                     ; $68E6
    call Fade_GoToB                               ; $68E8
    ret                                           ; $68EB


jr_006_68ec:
    ld a, [wLnkIndex + $1]                        ; $68EC
    bit 7, a                                      ; $68EF
    ret nz                                        ; $68F1

    cp $04                                        ; $68F2
    ret c                                         ; $68F4

    ld a, $05                                     ; $68F5
    ldh [hState], a                               ; $68F7
    ret                                           ; $68F9


; C: handler of state $05 of mode $09 (word 5 of Mode09_StateTable)
Mode09_State05::
    xor a                                         ; $68FA
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $68FB
    call Link_CountdownDA00                       ; $68FE
    jr nz, jr_006_6909                            ; $6901

    ld a, $03                                     ; $6903
    call Message_Show                             ; $6905
    ret                                           ; $6908


jr_006_6909:
    ld a, [wLnkEnded]                             ; $6909
    and a                                         ; $690C
    ret z                                         ; $690D

    ld a, $ff                                     ; $690E
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $6910
    push af                                       ; $6913
    ld a, SFX1_EXCHANGE_COMMUNICATING_17          ; $6914
    ld [wSndSfx1], a                              ; $6916
    pop af                                        ; $6919
    ld a, $06                                     ; $691A
    ldh [hState], a                               ; $691C
    ret                                           ; $691E


; C: handler of state $06 of mode $09 (word 6 of Mode09_StateTable)
Mode09_State06::
    ld a, [wMode07_State02_D9FD]                  ; $691F
    and a                                         ; $6922
    jr nz, jr_006_696f                            ; $6923

    push hl                                       ; $6925
    ld hl, wMode06_State0A_D896                   ; $6926
    set 0, [hl]                                   ; $6929
    pop hl                                        ; $692B
    ld b, BANK(Counters_AddExchanged)             ; $692C
    ld hl, Counters_AddExchanged                  ; $692E
    call Far_Call                                 ; $6931
    ld a, [wMode07_StateTable_D9FB]               ; $6934
    ld b, BANK(Photo_FindSlotA)                   ; $6937
    ld hl, Photo_FindSlotA                        ; $6939
    call Far_CallKeepA                            ; $693C
    jr c, jr_006_695b                             ; $693F

    push af                                       ; $6941
    ld b, BANK(Photo_RemoveFromVector)            ; $6942
    ld hl, Photo_RemoveFromVector                 ; $6944
    call Far_CallKeepA                            ; $6947
    ld b, BANK(Sram_StoreVector)                  ; $694A
    ld hl, Sram_StoreVector                       ; $694C
    call Far_Call                                 ; $694F
    pop af                                        ; $6952
    ld b, BANK(Sram_WritePhotoInfo)               ; $6953
    ld hl, Sram_WritePhotoInfo                    ; $6955
    call Far_CallKeepA                            ; $6958

jr_006_695b:
    ld de, $0010                                  ; $695B
    ld b, BANK(Kitts_Add)                         ; $695E
    ld hl, Kitts_Add                              ; $6960
    call Far_Call                                 ; $6963
    push hl                                       ; $6966
    ld hl, wMode06_State0A_D896                   ; $6967
    res 0, [hl]                                   ; $696A
    pop hl                                        ; $696C
    jr jr_006_69cd                                ; $696D

jr_006_696f:
    push hl                                       ; $696F
    ld hl, wMode06_State0A_D896                   ; $6970
    set 0, [hl]                                   ; $6973
    pop hl                                        ; $6975
    ld b, BANK(Counters_AddExchanged)             ; $6976
    ld hl, Counters_AddExchanged                  ; $6978
    call Far_Call                                 ; $697B
    call Link_SumSlotBuffer                       ; $697E
    call Counters_AddReceived                     ; $6981
    ld de, $cf00                                  ; $6984
    ld hl, wSlotTagOwnerCopy                      ; $6987
    ld bc, $0055                                  ; $698A
    call Copy_DEtoHL                              ; $698D
    call CardStats_IncDA64                        ; $6990
    ld a, $ff                                     ; $6993
    ld b, BANK(Photo_FindSlotA)                   ; $6995
    ld hl, Photo_FindSlotA                        ; $6997
    call Far_CallKeepA                            ; $699A
    push af                                       ; $699D
    ld b, BANK(Photo_AddToVector)                 ; $699E
    ld hl, Photo_AddToVector                      ; $69A0
    call Far_CallKeepA                            ; $69A3
    ld b, BANK(Sram_StoreVector)                  ; $69A6
    ld hl, Sram_StoreVector                       ; $69A8
    call Far_Call                                 ; $69AB
    xor a                                         ; $69AE
    ld [wSlotTagBorder], a                        ; $69AF
    pop af                                        ; $69B2
    ld b, BANK(Photo_Store)                       ; $69B3
    ld hl, Photo_Store                            ; $69B5
    call Far_CallKeepA                            ; $69B8
    ld de, $0010                                  ; $69BB
    ld b, BANK(Kitts_Add)                         ; $69BE
    ld hl, Kitts_Add                              ; $69C0
    call Far_Call                                 ; $69C3
    push hl                                       ; $69C6
    ld hl, wMode06_State0A_D896                   ; $69C7
    res 0, [hl]                                   ; $69CA
    pop hl                                        ; $69CC

jr_006_69cd:
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $69CD
    ld c, $07                                     ; $69CF
    call ModeState_Set                            ; $69D1
    ret                                           ; $69D4


; C: runs in mode $09 state $08 on the receiving unit of the linked exchange (BGB 2026-11-08)
Exchange_InitScreen::
    ld hl, wStatShadow                            ; $69D5
    res 6, [hl]                                   ; $69D8
    ld hl, rIE                                    ; $69DA
    res 1, [hl]                                   ; $69DD
    ld hl, wLcdcShadow                            ; $69DF
    res 7, [hl]                                   ; $69E2
    ld hl, $ff40                                  ; $69E4

jr_006_69e7:
    bit 7, [hl]                                   ; $69E7
    jr nz, jr_006_69e7                            ; $69E9

    call Oam_ClearShadow                          ; $69EB
    ld b, BANK(Objects_ClearAll)                  ; $69EE
    ld hl, Objects_ClearAll                       ; $69F0
    call Far_Call                                 ; $69F3
    ld b, BANK(ScriptSlots_Clear)                 ; $69F6
    ld hl, ScriptSlots_Clear                      ; $69F8
    call Far_Call                                 ; $69FB
    call Copy_FarInline                           ; $69FE

    db $00, $56, $1d, $00, $80, $00, $15

    call Copy_FarInline                           ; $6A08

    db $80, $7c, $32, $00, $98, $40, $02

    ld a, $01                                     ; $6A12
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $6A14
    call Serial_SetFarCallback                    ; $6A17

    dwb Frame_UpdateAll

    call Lcd_SetupInlineNoIE                      ; $6A1D

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00

    ld hl, wStatShadow                            ; $6A2A
    res 6, [hl]                                   ; $6A2D
    ld hl, rIE                                    ; $6A2F
    res 1, [hl]                                   ; $6A32
    push af                                       ; $6A34
    ld a, MUSIC_EXCHANGE_COMMUNICATING            ; $6A35
    ld [wSndMusicReq], a                          ; $6A37
    pop af                                        ; $6A3A
    ld de, ObjScript_00_1EB4_Mode09_ExchangeCommunicating_State03; $6A3B
    call Object_Create                            ; $6A3E
    ld de, ObjScript_00_1E1B_Mode09_ExchangeCommunicating_State03; $6A41
    call Object_Create                            ; $6A44
    ld de, ObjScript_00_1E44_Mode09_ExchangeCommunicating_State03; $6A47
    call Object_Create                            ; $6A4A
    ret                                           ; $6A4D


; C: handler of state $08 of mode $09 (word 8 of Mode09_StateTable)
Mode09_State08::
    call Exchange_InitScreen                      ; $6A4E
    ld b, $09                                     ; $6A51
    ld c, $0a                                     ; $6A53
    call Fade_GoToC                               ; $6A55
    ret                                           ; $6A58


; C: handler of state $0A of mode $09 (word 10 of Mode09_StateTable)
Mode09_State0A::
    ld a, $01                                     ; $6A59
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $6A5B
    ld a, [wLnkCmdRx]                             ; $6A5E
    bit 7, a                                      ; $6A61
    jr z, jr_006_6a8a                             ; $6A63

    cp $ef                                        ; $6A65
    jr z, jr_006_6ab3                             ; $6A67

    and $03                                       ; $6A69
    ld b, BANK(Photos_LoadPage8)                  ; $6A6B
    ld hl, Photos_LoadPage8                       ; $6A6D
    call Far_CallKeepA                            ; $6A70
    ld a, $01                                     ; $6A73
    ld [wLnkReadyTx], a                           ; $6A75
    xor a                                         ; $6A78
    ld [wLnkHalfDone], a                          ; $6A79
    ld a, $b4                                     ; $6A7C
    ld [wMode09_State0A_DA00], a                  ; $6A7E
    xor a                                         ; $6A81
    ld [wMode09_State0A_DA01], a                  ; $6A82
    ld a, $0b                                     ; $6A85
    ldh [hState], a                               ; $6A87
    ret                                           ; $6A89


jr_006_6a8a:
    bit 6, a                                      ; $6A8A
    ret z                                         ; $6A8C

    and $1f                                       ; $6A8D
    inc a                                         ; $6A8F
    ld [wMode07_StateTable_D9FB], a               ; $6A90
    ld a, $00                                     ; $6A93
    ld [wMode09_State0A_DA00], a                  ; $6A95
    ld a, $02                                     ; $6A98
    ld [wMode09_State0A_DA01], a                  ; $6A9A
    ld a, [wMode07_State02_D9FD]                  ; $6A9D
    and a                                         ; $6AA0
    jr nz, jr_006_6aab                            ; $6AA1

    ld b, MODE_EXCHANGE_COMMUNICATING             ; $6AA3
    ld c, $0c                                     ; $6AA5
    call Fade_GoToB                               ; $6AA7
    ret                                           ; $6AAA


jr_006_6aab:
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $6AAB
    ld c, $0e                                     ; $6AAD
    call ModeState_Set                            ; $6AAF
    ret                                           ; $6AB2


jr_006_6ab3:
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $6AB3
    ld c, $00                                     ; $6AB5
    call ModeState_Set                            ; $6AB7
    ret                                           ; $6ABA


; C: handler of state $0B of mode $09 (word 11 of Mode09_StateTable)
Mode09_State0B::
    xor a                                         ; $6ABB
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $6ABC
    call Link_CountdownDA00                       ; $6ABF
    jr nz, jr_006_6aca                            ; $6AC2

    ld a, $03                                     ; $6AC4
    call Message_Show                             ; $6AC6
    ret                                           ; $6AC9


jr_006_6aca:
    ld a, [wLnkHalfDone]                          ; $6ACA
    and a                                         ; $6ACD
    ret z                                         ; $6ACE

    ld a, $0a                                     ; $6ACF
    ldh [hState], a                               ; $6AD1
    ret                                           ; $6AD3


; C: handler of state $0C of mode $09 (word 12 of Mode09_StateTable)
Mode09_State0C::
    ld hl, wStatShadow                            ; $6AD4
    res 6, [hl]                                   ; $6AD7
    ld hl, $ff41                                  ; $6AD9
    res 6, [hl]                                   ; $6ADC
    ld hl, rIE                                    ; $6ADE
    res 1, [hl]                                   ; $6AE1
    ld hl, wLcdcShadow                            ; $6AE3
    res 7, [hl]                                   ; $6AE6
    ld hl, $ff40                                  ; $6AE8

jr_006_6aeb:
    bit 7, [hl]                                   ; $6AEB
    jr nz, jr_006_6aeb                            ; $6AED

    call Oam_ClearShadow                          ; $6AEF
    ld b, BANK(Objects_ClearAll)                  ; $6AF2
    ld hl, Objects_ClearAll                       ; $6AF4
    call Far_Call                                 ; $6AF7
    ld b, BANK(ScriptSlots_Clear)                 ; $6AFA
    ld hl, ScriptSlots_Clear                      ; $6AFC
    call Far_Call                                 ; $6AFF
    call Mem_ZeroInline                           ; $6B02

    db $00, $c0, $00, $10

    call Copy_FarInline                           ; $6B09

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $6B13

    db $d0, $78, $2c, $00, $98, $00, $04

    ld hl, wDoodleFromShutterbug                  ; $6B1D
    ld bc, $0080                                  ; $6B20
    call Call_000_01fe                            ; $6B23
    call Stat_SetTileToggleAt4F_B                 ; $6B26
    call Serial_SetFarCallback                    ; $6B29

    dwb Frame_UpdateAll

    ld a, [wMode07_StateTable_D9FB]               ; $6B2F
    ld b, BANK(Photo_FindSlotA)                   ; $6B32
    ld hl, Photo_FindSlotA                        ; $6B34
    call Far_CallKeepA                            ; $6B37
    jr c, jr_006_6b4f                             ; $6B3A

    ld b, BANK(Photo_LoadToVramScreenOff)         ; $6B3C
    ld hl, Photo_LoadToVramScreenOff              ; $6B3E
    call Far_CallKeepA                            ; $6B41
    ld a, $28                                     ; $6B44
    call FrameRec_LoadDefaultScreenOff            ; $6B46
    xor a                                         ; $6B49
    ld [wSlotTagBorder], a                        ; $6B4A
    jr jr_006_6b53                                ; $6B4D

jr_006_6b4f:
    ld a, $01                                     ; $6B4F
    ld a, $00                                     ; $6B51

jr_006_6b53:
    ld de, wSlotTagOwnerCopy                      ; $6B53
    ld hl, $cf00                                  ; $6B56
    ld bc, $0055                                  ; $6B59
    call Copy_DEtoHL                              ; $6B5C
    ld a, [wIdCard + $d]                          ; $6B5F
    ld [wLinkSenderGender], a                     ; $6B62
    ld de, $c800                                  ; $6B65
    ld hl, $8e00                                  ; $6B68
    ld bc, $0100                                  ; $6B6B
    call Copy_DEtoHL                              ; $6B6E
    ld a, $01                                     ; $6B71
    ld [wFadeRunning], a                          ; $6B73
    ld a, $0a                                     ; $6B76
    ld b, BANK(KeyPrompt_LoadSoundsB)             ; $6B78
    ld hl, KeyPrompt_LoadSoundsB                  ; $6B7A
    call Far_CallKeepA                            ; $6B7D
    call Lcd_SetupInlineNoIE                      ; $6B80

    db $87, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40

    ld b, MODE_EXCHANGE_COMMUNICATING             ; $6B8D
    ld c, $0d                                     ; $6B8F
    call Fade_GoTo                                ; $6B91
    ld hl, wStatShadow                            ; $6B94
    set 6, [hl]                                   ; $6B97
    ld hl, rIE                                    ; $6B99
    set 1, [hl]                                   ; $6B9C
    ret                                           ; $6B9E


; C: handler of state $0D of mode $09 (word 13 of Mode09_StateTable)
Mode09_State0D::
    ld a, [wMode06_State0A_D8DF]                  ; $6B9F
    bit 0, a                                      ; $6BA2
    jr z, jr_006_6bae                             ; $6BA4

    ld b, MODE_EXCHANGE_COMMUNICATING             ; $6BA6
    ld c, $09                                     ; $6BA8
    call Fade_GoToB                               ; $6BAA
    ret                                           ; $6BAD


jr_006_6bae:
    ld a, [wMode06_State0A_D8DF]                  ; $6BAE
    bit 1, a                                      ; $6BB1
    jr z, jr_006_6bc2                             ; $6BB3

    ld a, $ef                                     ; $6BB5
    ld [wLnkReadyTx], a                           ; $6BB7
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $6BBA
    ld c, $08                                     ; $6BBC
    call Fade_GoToB                               ; $6BBE
    ret                                           ; $6BC1


jr_006_6bc2:
    ret                                           ; $6BC2


; C: handler of state $09 of mode $09 (word 9 of Mode09_StateTable)
Mode09_State09::
    call Exchange_InitScreen                      ; $6BC3
    ld a, $01                                     ; $6BC6
    ld [wLnkReadyTx], a                           ; $6BC8
    ld b, $09                                     ; $6BCB
    ld c, $0e                                     ; $6BCD
    call Fade_GoToC                               ; $6BCF
    ret                                           ; $6BD2


; C: handler of state $0E of mode $09 (word 14 of Mode09_StateTable)
Mode09_State0E::
    xor a                                         ; $6BD3
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $6BD4
    call Link_CountdownDA00                       ; $6BD7
    jr nz, jr_006_6be2                            ; $6BDA

    ld a, $03                                     ; $6BDC
    call Message_Show                             ; $6BDE
    ret                                           ; $6BE1


jr_006_6be2:
    ld a, [wLnkEnded]                             ; $6BE2
    and a                                         ; $6BE5
    ret z                                         ; $6BE6

    ld a, $ff                                     ; $6BE7
    ld [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE], a ; $6BE9
    push af                                       ; $6BEC
    ld a, SFX1_EXCHANGE_COMMUNICATING_17          ; $6BED
    ld [wSndSfx1], a                              ; $6BEF
    pop af                                        ; $6BF2
    ld a, $0f                                     ; $6BF3
    ldh [hState], a                               ; $6BF5
    ret                                           ; $6BF7


; C: handler of state $0F of mode $09 (word 15 of Mode09_StateTable)
Mode09_State0F::
    ld a, [wMode07_State02_D9FD]                  ; $6BF8
    and a                                         ; $6BFB
    jr nz, jr_006_6c48                            ; $6BFC

    push hl                                       ; $6BFE
    ld hl, wMode06_State0A_D896                   ; $6BFF
    set 0, [hl]                                   ; $6C02
    pop hl                                        ; $6C04
    ld b, BANK(Counters_AddExchanged)             ; $6C05
    ld hl, Counters_AddExchanged                  ; $6C07
    call Far_Call                                 ; $6C0A
    ld a, [wMode07_StateTable_D9FB]               ; $6C0D
    ld b, BANK(Photo_FindSlotA)                   ; $6C10
    ld hl, Photo_FindSlotA                        ; $6C12
    call Far_CallKeepA                            ; $6C15
    jr c, jr_006_6c34                             ; $6C18

    push af                                       ; $6C1A
    ld b, BANK(Photo_RemoveFromVector)            ; $6C1B
    ld hl, Photo_RemoveFromVector                 ; $6C1D
    call Far_CallKeepA                            ; $6C20
    ld b, BANK(Sram_StoreVector)                  ; $6C23
    ld hl, Sram_StoreVector                       ; $6C25
    call Far_Call                                 ; $6C28
    pop af                                        ; $6C2B
    ld b, BANK(Sram_WritePhotoInfo)               ; $6C2C
    ld hl, Sram_WritePhotoInfo                    ; $6C2E
    call Far_CallKeepA                            ; $6C31

jr_006_6c34:
    ld de, $0010                                  ; $6C34
    ld b, BANK(Kitts_Add)                         ; $6C37
    ld hl, Kitts_Add                              ; $6C39
    call Far_Call                                 ; $6C3C
    push hl                                       ; $6C3F
    ld hl, wMode06_State0A_D896                   ; $6C40
    res 0, [hl]                                   ; $6C43
    pop hl                                        ; $6C45
    jr jr_006_6ca3                                ; $6C46

jr_006_6c48:
    push hl                                       ; $6C48
    ld hl, wMode06_State0A_D896                   ; $6C49
    set 0, [hl]                                   ; $6C4C
    pop hl                                        ; $6C4E
    ld b, BANK(Counters_AddExchanged)             ; $6C4F
    ld hl, Counters_AddExchanged                  ; $6C51
    call Far_Call                                 ; $6C54
    call Counters_AddReceived                     ; $6C57
    ld de, $cf00                                  ; $6C5A
    ld hl, wSlotTagOwnerCopy                      ; $6C5D
    ld bc, $0055                                  ; $6C60
    call Copy_DEtoHL                              ; $6C63
    call CardStats_IncDA64                        ; $6C66
    ld a, $ff                                     ; $6C69
    ld b, BANK(Photo_FindSlotA)                   ; $6C6B
    ld hl, Photo_FindSlotA                        ; $6C6D
    call Far_CallKeepA                            ; $6C70
    push af                                       ; $6C73
    ld b, BANK(Photo_AddToVector)                 ; $6C74
    ld hl, Photo_AddToVector                      ; $6C76
    call Far_CallKeepA                            ; $6C79
    ld b, BANK(Sram_StoreVector)                  ; $6C7C
    ld hl, Sram_StoreVector                       ; $6C7E
    call Far_Call                                 ; $6C81
    xor a                                         ; $6C84
    ld [wSlotTagBorder], a                        ; $6C85
    pop af                                        ; $6C88
    ld b, BANK(Photo_Store)                       ; $6C89
    ld hl, Photo_Store                            ; $6C8B
    call Far_CallKeepA                            ; $6C8E
    ld de, $0010                                  ; $6C91
    ld b, BANK(Kitts_Add)                         ; $6C94
    ld hl, Kitts_Add                              ; $6C96
    call Far_Call                                 ; $6C99
    push hl                                       ; $6C9C
    ld hl, wMode06_State0A_D896                   ; $6C9D
    res 0, [hl]                                   ; $6CA0
    pop hl                                        ; $6CA2

jr_006_6ca3:
    ld b, MODE_EXCHANGE_COMMUNICATING             ; $6CA3
    ld c, $10                                     ; $6CA5
    call ModeState_Set                            ; $6CA7
    ret                                           ; $6CAA


; C: handler of state $07 of mode $09 (word 7 of Mode09_StateTable)
Mode09_State07::
    ld a, [wObjScript_00_1E44_Mode09_ExchangeCommunicating_State03_D9FE] ; $6CAB
    cp $f0                                        ; $6CAE
    jr nz, jr_006_6cba                            ; $6CB0

    ld b, MODE_EXCHANGE                           ; $6CB2
    ld c, $00                                     ; $6CB4
    call Fade_GoToB                               ; $6CB6
    ret                                           ; $6CB9


jr_006_6cba:
    ret                                           ; $6CBA


; C: $DA64 / $DA65 + 1 (at most 99) by the bits 0 / 1 of $DAE8, then $DA66 + 1; called by the receiving branch of mode
; $09 states $06 / $0F; the receiving unit of the linked BGB exchange (2026-11-08) ran state $0F and got the photo
CardStats_IncDA64::
    ld hl, wSlotTagRecvCounters                   ; $6CBB
    ld a, [wIdCard + $d]                          ; $6CBE
    ld b, a                                       ; $6CC1
    ld a, [hl]                                    ; $6CC2
    bit 0, b                                      ; $6CC3
    jr z, jr_006_6ccc                             ; $6CC5

    cp $63                                        ; $6CC7
    jr nc, jr_006_6ccc                            ; $6CC9

    inc a                                         ; $6CCB

jr_006_6ccc:
    ld [hl+], a                                   ; $6CCC
    ld a, [hl]                                    ; $6CCD
    bit 1, b                                      ; $6CCE
    jr z, jr_006_6cd7                             ; $6CD0

    cp $63                                        ; $6CD2
    jr nc, jr_006_6cd7                            ; $6CD4

    inc a                                         ; $6CD6

jr_006_6cd7:
    ld [hl], a                                    ; $6CD7
    ld hl, wSlotTagRecvCounters + $2              ; $6CD8
    ld a, [hl]                                    ; $6CDB
    cp $63                                        ; $6CDC
    jr nc, jr_006_6ce1                            ; $6CDE

    inc a                                         ; $6CE0

jr_006_6ce1:
    ld [hl], a                                    ; $6CE1
    ld hl, wSlotTagHotspotFields                  ; $6CE2
    ld bc, $001e                                  ; $6CE5
    call Call_000_01fe                            ; $6CE8
    ret                                           ; $6CEB


; C: ModeTable entry $09: BGB linked exchange (two units): giving states $01-$05
Mode09_ExchangeCommunicating::
    ldh a, [hState]                               ; $6CEC
    ld hl, Mode09_StateTable                      ; $6CEE
    call JumpTable_ByA                            ; $6CF1
    jp Far_Return                                 ; $6CF4


; C: state table of mode $09, read by $0189 with hFF8E
Mode09_StateTable::
    dw Mode09_State00
    dw Mode09_State01
    dw Mode09_State02
    dw Mode09_State03
    dw Mode09_State04
    dw Mode09_State05
    dw Mode09_State06
    dw Mode09_State07
    dw Mode09_State08
    dw Mode09_State09
    dw Mode09_State0A
    dw Mode09_State0B
    dw Mode09_State0C
    dw Mode09_State0D
    dw Mode09_State0E
    dw Mode09_State0F
    dw Mode09_State07

; C: handler of state $00 of mode $1D (word 0 of Mode1D_StateTable)
Mode1D_State00::
    di                                            ; $6D19
    ld b, BANK(Objects_ClearAll)                  ; $6D1A
    ld hl, Objects_ClearAll                       ; $6D1C
    call Far_Call                                 ; $6D1F
    call Stat_SetIdle                             ; $6D22
    call Copy_FarInline                           ; $6D25

    db $00, $90, $00, $08, $cd, $45, $02

    nop                                           ; $6D2F
    sbc b                                         ; $6D30
    nop                                           ; $6D31
    inc b                                         ; $6D32
    call Serial_SetFarCallback                    ; $6D33

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $6D39

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $40, $03

    ld a, $01                                     ; $6D47
    ldh [hState], a                               ; $6D49
    ei                                            ; $6D4B
    ret                                           ; $6D4C


; C: handler of state $01 of mode $1D (word 1 of Mode1D_StateTable)
Mode1D_State01::
    ld a, [wKeysNew]                              ; $6D4D
    bit PADB_SELECT, a                            ; $6D50
    jr z, jr_006_6d5c                             ; $6D52

    ld hl, hState                                 ; $6D54
    inc [hl]                                      ; $6D57
    xor a                                         ; $6D58
    ld [wLcdcShadow], a                           ; $6D59

jr_006_6d5c:
    ld hl, wDoodleFromShutterbug                  ; $6D5C
    inc [hl]                                      ; $6D5F
    ret                                           ; $6D60


; C: handler of state $02 of mode $1D (word 2 of Mode1D_StateTable)
Mode1D_State02::
    di                                            ; $6D61
    ld b, BANK(Objects_ClearAll)                  ; $6D62
    ld hl, Objects_ClearAll                       ; $6D64
    call Far_Call                                 ; $6D67
    ld b, BANK(ScriptSlots_Clear)                 ; $6D6A
    ld hl, ScriptSlots_Clear                      ; $6D6C
    call Far_Call                                 ; $6D6F
    call Stat_SetIdle                             ; $6D72
    ld a, $01                                     ; $6D75
    ldh [hState], a                               ; $6D77
    call Lcd_SetupInline                          ; $6D79

    db $93, $e4, $e4, $d0, $00, $00, $00, $00, $00, $40, $01

    ld a, $03                                     ; $6D87
    ldh [hState], a                               ; $6D89
    ei                                            ; $6D8B
    ret                                           ; $6D8C


; C: handler of state $03 of mode $1D (word 3 of Mode1D_StateTable)
Mode1D_State03::
    xor a                                         ; $6D8D
    ld [wOamUsedEnd], a                           ; $6D8E
    ld hl, wDoodleFromShutterbug                  ; $6D91
    inc [hl]                                      ; $6D94
    ret                                           ; $6D95


; I: ModeTable entry $1D: forced: returns to mode 01 at once (no screen of its own)
Mode1D_BackToMainMenu1D::
    ldh a, [hState]                               ; $6D96
    ld hl, Mode1D_StateTable                      ; $6D98
    call JumpTable_ByA                            ; $6D9B
    jp Far_Return                                 ; $6D9E


; C: state table of mode $1D, read by $0189 with hFF8E
Mode1D_StateTable::
    dw Mode1D_State00
    dw Mode1D_State01
    dw Mode1D_State02
    dw Mode1D_State03

    ; padding
    ds $1257, $00

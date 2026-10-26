; Pocket Camera (Japan) (Rev A), bank $00. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $000", ROM0[$0]

RST_00::
    di                                            ; $0000
    jp Boot                                       ; $0001


    db $00, $00, $00, $00

; C: returns if LCD off; clears vblank_tick then halts until the VBlank handler bumps it (one frame)
Rst08_WaitVBlank::
    ldh a, [rLCDC]                                ; $0008
    bit 7, a                                      ; $000A
    ret z                                         ; $000C

    ld hl, hVblankTick                            ; $000D

; C: HL = flag byte: clears it and halts until non-zero
Rst10_WaitFlagSet::
    xor a                                         ; $0010
    ld [hl], a                                    ; $0011

jr_000_0012:
    halt                                          ; $0012
    ld a, [hl]                                    ; $0013
    and a                                         ; $0014
    jr z, jr_000_0012                             ; $0015

    ret                                           ; $0017


; C: A = index; inline word table follows the rst; pops return address as table base
Rst18_JumpTable::
    sla a                                         ; $0018
    pop hl                                        ; $001A
    push de                                       ; $001B
    ld e, a                                       ; $001C
    ld d, $00                                     ; $001D
    add hl, de                                    ; $001F

; C: load word at HL and jp (shared tail)
Rst18_JumpTable_Fetch::
    ld e, [hl]                                    ; $0020
    inc hl                                        ; $0021
    ld d, [hl]                                    ; $0022
    ld l, e                                       ; $0023
    ld h, d                                       ; $0024
    pop de                                        ; $0025
    jp hl                                         ; $0026


    ; padding
    ds $1, $00

RST_28::
    nop                                           ; $0028
    nop                                           ; $0029
    nop                                           ; $002A
    nop                                           ; $002B
    nop                                           ; $002C
    nop                                           ; $002D
    nop                                           ; $002E
    nop                                           ; $002F

RST_30::
    nop                                           ; $0030
    nop                                           ; $0031
    nop                                           ; $0032
    nop                                           ; $0033
    nop                                           ; $0034
    nop                                           ; $0035
    nop                                           ; $0036
    nop                                           ; $0037

RST_38::
    nop                                           ; $0038
    nop                                           ; $0039
    nop                                           ; $003A
    nop                                           ; $003B
    nop                                           ; $003C
    nop                                           ; $003D
    nop                                           ; $003E
    nop                                           ; $003F

; C: jp 02A3
Vec_VBlank::
    jp Irq_VBlank                                 ; $0040


    db $00, $00, $00, $00, $00

; C: jp 033B
Vec_Stat::
    jp Irq_Stat                                   ; $0048


    db $00, $00, $00, $00, $00

; C: jp 2D50
Vec_Timer::
    jp Link_TimerIrq                              ; $0050


    db $00, $00, $00, $00, $00

; C: jp 0368
Vec_Serial::
    jp Irq_Serial                                 ; $0058


    db $00, $00, $00, $00, $00

; C: jp 0389
Vec_Joypad::
    jp Irq_Joypad                                 ; $0060


    ; padding
    ds $9d, $00

Boot::
    nop                                           ; $0100
    jp Boot_ColdStart                             ; $0101


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
    db "POCKETCAMERA", $00, $00, $00, $00

HeaderNewLicenseeCode::
    db $30, $31

HeaderSGBFlag::
    db $03

HeaderCartridgeType::
    db $fc

HeaderROMSize::
    db $05

HeaderRAMSize::
    db $04

HeaderDestinationCode::
    db $00

HeaderOldLicenseeCode::
    db $33

HeaderMaskROMVersion::
    db $01

HeaderComplementCheck::
    db $db

HeaderGlobalChecksum::
    db $93, $62

; C
Boot_ColdStart::
    ld sp, hBootSp                                ; $0150
    di                                            ; $0153
    xor a                                         ; $0154
    ldh [rIF], a                                  ; $0155
    ldh a, [rLCDC]                                ; $0157
    bit 7, a                                      ; $0159
    jr nz, jr_000_0161                            ; $015B

    set 7, a                                      ; $015D
    ldh [rLCDC], a                                ; $015F

jr_000_0161:
    ld bc, $0002                                  ; $0161
    call Delay_Frames_Busy                        ; $0164

jr_000_0167:
    ldh a, [rLY]                                  ; $0167
    cp $91                                        ; $0169
    jr c, jr_000_0167                             ; $016B

    ld a, LCDCF_ON                                ; $016D
    ldh [rLCDC], a                                ; $016F
    xor a                                         ; $0171
    ldh [rBGP], a                                 ; $0172
    ldh [rOBP0], a                                ; $0174
    ldh [rOBP1], a                                ; $0176
    ld bc, $0002                                  ; $0178
    call Delay_Frames_Busy                        ; $017B
    call Lcd_Off                                  ; $017E
    ld hl, _RAM                                   ; $0181
    ld bc, $1fff                                  ; $0184
    call Mem_Zero                                 ; $0187
    ld a, $00                                     ; $018A
    ld [$0000], a                                 ; $018C
    ld a, $01                                     ; $018F
    ld [$2000], a                                 ; $0191
    ld a, $00                                     ; $0194
    ld [$4000], a                                 ; $0196
    ld a, $01                                     ; $0199
    ldh [hRomBankShadow], a                       ; $019B
    ld sp, wStackTop                              ; $019D
    ld hl, hOamDmaRoutine                         ; $01A0
    ld bc, $007e                                  ; $01A3
    call Mem_Zero                                 ; $01A6
    call OamDma_InstallRoutine                    ; $01A9
    call Oam_ClearShadow                          ; $01AC
    call Vram_ClearBgMap0                         ; $01AF
    call Vram_ClearBgMap1                         ; $01B2
    xor a                                         ; $01B5
    ld [wVqWriteIdx], a                           ; $01B6
    ld [wVqReadIdx], a                            ; $01B9
    ld [wUnusedD522], a                           ; $01BC
    ldh [hStatHandlerIndex], a                    ; $01BF
    ldh [hSerialHandlerIndex], a                  ; $01C1
    ldh [hCopyReqFlag], a                         ; $01C3
    ldh [hFillReqFlag], a                         ; $01C5
    ld [wPrnPollEnable], a                        ; $01C7
    ld [wSoftResetEnable], a                      ; $01CA
    ldh [hSgbMaskActive], a                       ; $01CD
    ld hl, hLcdcShadow                            ; $01CF
    xor a                                         ; $01D2
    ld [hl+], a                                   ; $01D3
    ld [hl+], a                                   ; $01D4
    ld [hl+], a                                   ; $01D5
    ld [hl+], a                                   ; $01D6
    ld [hl+], a                                   ; $01D7
    ld [hl+], a                                   ; $01D8
    ld [hl+], a                                   ; $01D9
    ld [hl+], a                                   ; $01DA
    ld a, $8f                                     ; $01DB
    ld [hl+], a                                   ; $01DD
    ld a, $a6                                     ; $01DE
    ld [hl+], a                                   ; $01E0
    call Snd_Init_Tramp                           ; $01E1
    call Sgb_Probe                                ; $01E4
    rl a                                          ; $01E7
    and $01                                       ; $01E9
    ldh [hSgbPresent], a                          ; $01EB
    call Sgb_SendInitSequence                     ; $01ED
    ld a, IEF_VBLANK                              ; $01F0
    ldh [rIE], a                                  ; $01F2
    ei                                            ; $01F4
    ld a, $ff                                     ; $01F5
    ld [wRngModulus], a                           ; $01F7
    call Rng_Init                                 ; $01FA
    xor a                                         ; $01FD
    ldh [hFarcallAArg], a                         ; $01FE
    ld a, BANK(Boot_EraseAllPrompt_Far)           ; $0200
    ld hl, Boot_EraseAllPrompt_Far                ; $0202
    call Far_Call                                 ; $0205
    ld a, $00                                     ; $0208
    ld hl, Main_Entry                             ; $020A
    call Far_Jump                                 ; $020D

; C: A+B+Start+Select reset path
Boot_SoftReset::
    ld sp, hBootSp                                ; $0210
    xor a                                         ; $0213
    ldh [hBgpShadow], a                           ; $0214
    ldh [hObp0Shadow], a                          ; $0216
    ldh [hObp1Shadow], a                          ; $0218
    ld bc, $0002                                  ; $021A
    call Delay_Frames_Busy                        ; $021D
    di                                            ; $0220
    xor a                                         ; $0221
    ldh [rIF], a                                  ; $0222
    ld sp, hBootSp                                ; $0224
    call Lcd_Off                                  ; $0227
    ld a, $00                                     ; $022A
    ld [$0000], a                                 ; $022C
    ld a, $01                                     ; $022F
    ld [$2000], a                                 ; $0231
    ld a, $00                                     ; $0234
    ld [$4000], a                                 ; $0236
    ld a, $01                                     ; $0239
    ldh [hRomBankShadow], a                       ; $023B
    ld hl, _RAM                                   ; $023D
    ld bc, $2000                                  ; $0240
    call Mem_Zero                                 ; $0243
    ld sp, wStackTop                              ; $0246
    call OamDma_InstallRoutine                    ; $0249
    call Oam_ClearShadow                          ; $024C
    call Vram_ClearBgMap0                         ; $024F
    call Vram_ClearBgMap1                         ; $0252
    xor a                                         ; $0255
    ld [wVqWriteIdx], a                           ; $0256
    ld [wVqReadIdx], a                            ; $0259
    ld [wUnusedD522], a                           ; $025C
    ldh [hStatHandlerIndex], a                    ; $025F
    ldh [hSerialHandlerIndex], a                  ; $0261
    ldh [hCopyReqFlag], a                         ; $0263
    ldh [hFillReqFlag], a                         ; $0265
    ld [wPrnPollEnable], a                        ; $0267
    ld [wSoftResetEnable], a                      ; $026A
    ld hl, hLcdcShadow                            ; $026D
    xor a                                         ; $0270
    ld [hl+], a                                   ; $0271
    ld [hl+], a                                   ; $0272
    ld [hl+], a                                   ; $0273
    ld [hl+], a                                   ; $0274
    ld [hl+], a                                   ; $0275
    ld [hl+], a                                   ; $0276
    ld [hl+], a                                   ; $0277
    ld [hl+], a                                   ; $0278
    ld a, $8f                                     ; $0279
    ld [hl+], a                                   ; $027B
    ld a, $a6                                     ; $027C
    ld [hl+], a                                   ; $027E
    call Snd_Init_Tramp                           ; $027F
    ld a, IEF_VBLANK                              ; $0282
    ldh [rIE], a                                  ; $0284
    ei                                            ; $0286
    ld a, $ff                                     ; $0287
    ld [wRngModulus], a                           ; $0289
    call Rng_Init                                 ; $028C
    ld a, $01                                     ; $028F
    ldh [hFarcallAArg], a                         ; $0291
    ld a, BANK(Boot_EraseAllPrompt_Far)           ; $0293
    ld hl, Boot_EraseAllPrompt_Far                ; $0295
    call Far_Call                                 ; $0298
    ld a, $00                                     ; $029B
    ld hl, Main_Entry                             ; $029D
    call Far_Jump                                 ; $02A0

; C: OAM DMA; VRAM queue; copy/fill requests; LCD shadows; joypad; soft-reset test; frame counters; sound tick
Irq_VBlank::
    push af                                       ; $02A3
    push bc                                       ; $02A4
    push de                                       ; $02A5
    push hl                                       ; $02A6
    call $ff80                                    ; $02A7
    ei                                            ; $02AA
    call Vq_Process                               ; $02AB
    call Irq_VBlank_CopyRequest                   ; $02AE
    call Irq_VBlank_FillRequest                   ; $02B1
    ld hl, hLcdcShadow                            ; $02B4
    ld c, $40                                     ; $02B7
    ld a, [hl+]                                   ; $02B9
    ldh [c], a                                    ; $02BA
    inc c                                         ; $02BB
    ld a, [hl+]                                   ; $02BC
    ldh [c], a                                    ; $02BD
    inc c                                         ; $02BE
    ld a, [hl+]                                   ; $02BF
    ldh [c], a                                    ; $02C0
    inc c                                         ; $02C1
    ld a, [hl+]                                   ; $02C2
    ldh [c], a                                    ; $02C3
    inc c                                         ; $02C4
    inc c                                         ; $02C5
    ld a, [hl+]                                   ; $02C6
    ldh [c], a                                    ; $02C7
    inc c                                         ; $02C8
    inc c                                         ; $02C9
    ld a, [hl+]                                   ; $02CA
    ldh [c], a                                    ; $02CB
    inc c                                         ; $02CC
    ld a, [hl+]                                   ; $02CD
    ldh [c], a                                    ; $02CE
    inc c                                         ; $02CF
    ld a, [hl+]                                   ; $02D0
    ldh [c], a                                    ; $02D1
    inc c                                         ; $02D2
    ld a, [hl+]                                   ; $02D3
    ldh [c], a                                    ; $02D4
    inc c                                         ; $02D5
    ld a, [hl+]                                   ; $02D6
    ldh [c], a                                    ; $02D7
    ldh a, [hLycShadowSplit1]                     ; $02D8
    ldh [hSplit1Latch], a                         ; $02DA
    ldh a, [hSplit2Line]                          ; $02DC
    ldh [hSplit2Latch], a                         ; $02DE
    ldh a, [hScxBand1]                            ; $02E0
    ldh [hScxBand1Latch], a                       ; $02E2
    ldh a, [hScyBand1]                            ; $02E4
    ldh [hScyBand1Latch], a                       ; $02E6
    ldh a, [hScxBand2]                            ; $02E8
    ldh [hScxBand2Latch], a                       ; $02EA
    ldh a, [hScyBand2]                            ; $02EC
    ldh [hScyBand2Latch], a                       ; $02EE
    call Joy_Read                                 ; $02F0
    ld a, [wSoftResetEnable]                      ; $02F3
    and a                                         ; $02F6
    jr z, jr_000_031c                             ; $02F7

    ldh a, [hKeysHeld]                            ; $02F9
    cp PADF_BUTTONS                               ; $02FB
    jr nz, jr_000_031c                            ; $02FD

    ldh a, [hKeysNew]                             ; $02FF
    and PADF_BUTTONS                              ; $0301
    jr z, jr_000_031c                             ; $0303

    xor a                                         ; $0305
    ldh [rBGP], a                                 ; $0306
    ldh [rOBP0], a                                ; $0308
    ldh [rOBP1], a                                ; $030A
    ld [$0000], a                                 ; $030C
    ldh [rSB], a                                  ; $030F
    ldh [rSC], a                                  ; $0311
    ldh [rIE], a                                  ; $0313
    ldh [rNR52], a                                ; $0315
    ld hl, Boot_SoftReset                         ; $0317
    push hl                                       ; $031A
    reti                                          ; $031B


jr_000_031c:
    ld hl, hVblankTick                            ; $031C
    ld a, [hl]                                    ; $031F
    inc [hl]                                      ; $0320
    and a                                         ; $0321
    jr nz, jr_000_0328                            ; $0322

    ld hl, hFrameCounter                          ; $0324
    inc [hl]                                      ; $0327

jr_000_0328:
    ld hl, hVblankCounter                         ; $0328
    inc [hl]                                      ; $032B
    ld a, [wPrnPollEnable]                        ; $032C
    and a                                         ; $032F
    call nz, Prn_VBlankPoll                       ; $0330
    call Snd_Tick_Tramp                           ; $0333
    pop hl                                        ; $0336
    pop de                                        ; $0337
    pop bc                                        ; $0338
    pop af                                        ; $0339
    reti                                          ; $033A


; C: dispatch through Irq_Stat_HandlerTable by stat_handler_index
Irq_Stat::
    push af                                       ; $033B
    push bc                                       ; $033C
    push de                                       ; $033D
    push hl                                       ; $033E
    ldh a, [hStatHandlerIndex]                    ; $033F
    sla a                                         ; $0341
    ld c, a                                       ; $0343
    ld b, $00                                     ; $0344
    ld hl, Irq_Stat_HandlerTable                  ; $0346
    add hl, bc                                    ; $0349
    ld a, [hl+]                                   ; $034A
    ld h, [hl]                                    ; $034B
    ld l, a                                       ; $034C
    jp hl                                         ; $034D


; C: sets stat_seen_flag then pops and reti
Irq_Stat_Exit::
    ld a, $01                                     ; $034E
    ldh [hStatSeenFlag], a                        ; $0350
    pop hl                                        ; $0352
    pop de                                        ; $0353
    pop bc                                        ; $0354
    pop af                                        ; $0355
    reti                                          ; $0356


; C: 8 words
Irq_Stat_HandlerTable::
    dw Stat_00_None
    dw Stat_01_TileDataToggle
    dw Stat_02_ScrollOneBand
    dw Stat_03_ScrollTwoBands_Map1
    dw Stat_04_WindowOff
    dw Stat_05_ScrollTwoBands_Split67
    dw Stat_06_ThreeBands
    dw Stat_07_ScrollTwoBands_Map1b

; I: unreferenced reti
Reti_Unused::
    reti                                          ; $0367


; C: dispatch through Irq_Serial_HandlerTable by serial_handler_index
Irq_Serial::
    push af                                       ; $0368
    push bc                                       ; $0369
    push de                                       ; $036A
    push hl                                       ; $036B
    ld hl, Irq_Serial_Exit                        ; $036C
    push hl                                       ; $036F
    ldh a, [hSerialHandlerIndex]                  ; $0370
    sla a                                         ; $0372
    ld c, a                                       ; $0374
    ld b, $00                                     ; $0375
    ld hl, Irq_Serial_HandlerTable                ; $0377
    add hl, bc                                    ; $037A
    ld c, [hl]                                    ; $037B
    inc hl                                        ; $037C
    ld b, [hl]                                    ; $037D
    push bc                                       ; $037E
    ret                                           ; $037F


; C
Irq_Serial_Exit::
    pop hl                                        ; $0380
    pop de                                        ; $0381
    pop bc                                        ; $0382
    pop af                                        ; $0383
    reti                                          ; $0384


; C: 2 words: printer 0F16 / link 2AE9
Irq_Serial_HandlerTable::
    dw Prn_SerialIrq
    dw Link_SerialIrq

; C: reti
Irq_Joypad::
    reti                                          ; $0389


; C: A = index; inline table of {addr
Call_InlineTable3::
    ld e, a                                       ; $038A
    add a                                         ; $038B
    add e                                         ; $038C
    pop hl                                        ; $038D
    ld e, a                                       ; $038E
    ld d, $00                                     ; $038F
    add hl, de                                    ; $0391
    ld e, [hl]                                    ; $0392
    inc hl                                        ; $0393
    ld d, [hl]                                    ; $0394
    inc hl                                        ; $0395
    ldh a, [hRomBankShadow]                       ; $0396
    push af                                       ; $0398
    ld a, [hl]                                    ; $0399
    ldh [hRomBankShadow], a                       ; $039A
    ld [$2000], a                                 ; $039C
    ld l, e                                       ; $039F
    ld h, d                                       ; $03A0
    ld de, Call_InlineTable3_Return               ; $03A1
    push de                                       ; $03A4
    jp hl                                         ; $03A5


; C: restores the bank
Call_InlineTable3_Return::
    pop af                                        ; $03A6
    ldh [hRomBankShadow], a                       ; $03A7
    ld [$2000], a                                 ; $03A9
    ret                                           ; $03AC


; C: waits for VBlank (LY=$91) then clears LCDC bit 7
Lcd_Off::
    ldh a, [rLCDC]                                ; $03AD
    bit 7, a                                      ; $03AF
    ret z                                         ; $03B1

    ldh a, [rIE]                                  ; $03B2
    push af                                       ; $03B4
    and $fc                                       ; $03B5
    ldh [rIE], a                                  ; $03B7

jr_000_03b9:
    ldh a, [rLY]                                  ; $03B9
    cp $91                                        ; $03BB
    jr nz, jr_000_03b9                            ; $03BD

    ldh a, [hLcdcShadow]                          ; $03BF
    res 7, a                                      ; $03C1
    ldh [rLCDC], a                                ; $03C3
    ldh [hLcdcShadow], a                          ; $03C5
    pop af                                        ; $03C7
    ldh [rIE], a                                  ; $03C8
    ret                                           ; $03CA


; C
Lcd_On::
    ldh a, [hLcdcShadow]                          ; $03CB
    set 7, a                                      ; $03CD
    ldh [rLCDC], a                                ; $03CF
    ldh [hLcdcShadow], a                          ; $03D1
    ret                                           ; $03D3


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Irq_DisableVBlank::
    ldh a, [rIE]                                  ; $03D4
    res 0, a                                      ; $03D6
    ldh [rIE], a                                  ; $03D8
    ret                                           ; $03DA


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Irq_EnableVBlank::
    ldh a, [rIE]                                  ; $03DB
    set 0, a                                      ; $03DD
    ldh [rIE], a                                  ; $03DF
    ret                                           ; $03E1


; C: copies 10 bytes from OamDma_RomImage to HRAM $FF80
OamDma_InstallRoutine::
    ld c, $80                                     ; $03E2
    ld b, $0a                                     ; $03E4
    ld hl, OamDma_RomImage                        ; $03E6

jr_000_03e9:
    ld a, [hl+]                                   ; $03E9
    ldh [c], a                                    ; $03EA
    inc c                                         ; $03EB
    dec b                                         ; $03EC
    jr nz, jr_000_03e9                            ; $03ED

    ret                                           ; $03EF


; C: the code copied to HRAM: ld a
OamDma_RomImage::
    ld a, $d4                                     ; $03F0
    ldh [rDMA], a                                 ; $03F2
    ld a, $28                                     ; $03F4

jr_000_03f6:
    dec a                                         ; $03F6
    jr nz, jr_000_03f6                            ; $03F7

    ret                                           ; $03F9


; C: waits STAT mode 0 then a short delay
Vram_WaitHBlank::
    ldh a, [rSTAT]                                ; $03FA
    and $03                                       ; $03FC
    jr nz, Vram_WaitHBlank                        ; $03FE

    ld a, $0a                                     ; $0400

jr_000_0402:
    dec a                                         ; $0402
    jr nz, jr_000_0402                            ; $0403

    ret                                           ; $0405


; C: waits for LY in 1..$8D and STAT mode 0 (sync before a short VRAM burst). L3 pass 2026-10-26: executed in BGB in
; 203 replay(s) of the organic corpus, modes 00 01 02 03 06 07 08 09 0A 0E 0F 10 11 12 14 15 16 17 18 19 1A 1B 1C 1E
; 20 (tcrf_check/assets/l3_names/)
Vram_WaitHBlankLine::
    ldh a, [rLY]                                  ; $0406
    cp $01                                        ; $0408
    jr c, jr_000_0410                             ; $040A

    cp $8e                                        ; $040C
    jr c, jr_000_0428                             ; $040E

jr_000_0410:
    ldh a, [rLY]                                  ; $0410
    cp $01                                        ; $0412
    jr c, jr_000_0410                             ; $0414

    cp $8e                                        ; $0416
    jr nc, jr_000_0410                            ; $0418

jr_000_041a:
    ldh a, [rSTAT]                                ; $041A
    and $03                                       ; $041C
    jr nz, jr_000_041a                            ; $041E

    ld a, $15                                     ; $0420

jr_000_0422:
    dec a                                         ; $0422
    jr nz, jr_000_0422                            ; $0423

    nop                                           ; $0425
    nop                                           ; $0426
    nop                                           ; $0427

jr_000_0428:
    ret                                           ; $0428


; C: fills BC+1 bytes at HL with A
Mem_FillBc1::
    dec bc                                        ; $0429

jr_000_042a:
    ld [hl+], a                                   ; $042A
    dec bc                                        ; $042B
    bit 7, b                                      ; $042C
    jr z, jr_000_042a                             ; $042E

    ret                                           ; $0430


; C: fills BC/2 words at HL with DE
Mem_FillWords::
    srl b                                         ; $0431
    rr c                                          ; $0433

jr_000_0435:
    ld a, e                                       ; $0435
    ld [hl+], a                                   ; $0436
    ld a, d                                       ; $0437
    ld [hl+], a                                   ; $0438
    dec bc                                        ; $0439
    ld a, b                                       ; $043A
    or c                                          ; $043B
    jr nz, jr_000_0435                            ; $043C

    ret                                           ; $043E


; C: clears BC bytes at HL (BC>=1)
Mem_Zero::
    xor a                                         ; $043F
    ld [hl+], a                                   ; $0440
    dec bc                                        ; $0441
    ld a, c                                       ; $0442
    or b                                          ; $0443
    jr nz, Mem_Zero                               ; $0444

    ret                                           ; $0446


; C: HL -> DE BC bytes (BC>=1)
Mem_Copy::
    ld a, [hl+]                                   ; $0447
    ld [de], a                                    ; $0448
    inc de                                        ; $0449
    dec bc                                        ; $044A
    ld a, c                                       ; $044B
    or b                                          ; $044C
    jr nz, Mem_Copy                               ; $044D

    ret                                           ; $044F


; C: A = ROM bank (HL<$8000) or SRAM bank (HL>=$8000); HL -> DE BC bytes
Mem_CopyFromBank::
    bit 7, h                                      ; $0450
    jr nz, jr_000_0463                            ; $0452

    ldh [hBankTmp], a                             ; $0454
    ldh a, [hRomBankShadow]                       ; $0456
    push af                                       ; $0458
    ldh a, [hBankTmp]                             ; $0459
    ldh [hRomBankShadow], a                       ; $045B
    ld [$2000], a                                 ; $045D
    scf                                           ; $0460
    jr jr_000_0467                                ; $0461

jr_000_0463:
    ld [$4000], a                                 ; $0463
    and a                                         ; $0466

jr_000_0467:
    push af                                       ; $0467

jr_000_0468:
    ld a, [hl+]                                   ; $0468
    ld [de], a                                    ; $0469
    inc de                                        ; $046A
    dec bc                                        ; $046B
    ld a, c                                       ; $046C
    or b                                          ; $046D
    jr nz, jr_000_0468                            ; $046E

    pop af                                        ; $0470
    ret nc                                        ; $0471

    pop af                                        ; $0472
    ldh [hRomBankShadow], a                       ; $0473
    ld [$2000], a                                 ; $0475
    ret                                           ; $0478


; C: LCD off: Mem_CopyFromBank; LCD on: Vram_CopyFromBank
Vram_CopyFromBankAuto::
    push hl                                       ; $0479
    ld hl, $ff40                                  ; $047A
    bit 7, [hl]                                   ; $047D
    pop hl                                        ; $047F
    jp z, Mem_CopyFromBank                        ; $0480

    jp Vram_CopyFromBank                          ; $0483


; C: copies a 20-tile-wide screen map (HL source, bank in A or SRAM bit; DE = VRAM $98xx) adding C to every tile
; number, 32-tile row stride in VRAM; no STAT wait (LCD off); callers 08:5079 (border picker, C = $90)
Border_CopyFrameAddTile_LcdOff::
    bit 7, h                                      ; $0486
    jr nz, jr_000_0499                            ; $0488

    ldh [hBankTmp], a                             ; $048A
    ldh a, [hRomBankShadow]                       ; $048C
    push af                                       ; $048E
    ldh a, [hBankTmp]                             ; $048F
    ldh [hRomBankShadow], a                       ; $0491
    ld [$2000], a                                 ; $0493
    scf                                           ; $0496
    jr jr_000_049d                                ; $0497

jr_000_0499:
    ld [$4000], a                                 ; $0499
    and a                                         ; $049C

jr_000_049d:
    push af                                       ; $049D
    push de                                       ; $049E
    ld b, $02                                     ; $049F

jr_000_04a1:
    push bc                                       ; $04A1
    ld b, $02                                     ; $04A2

jr_000_04a4:
    push bc                                       ; $04A4
    ld b, $14                                     ; $04A5

jr_000_04a7:
    ld a, [hl+]                                   ; $04A7
    add c                                         ; $04A8
    ld [de], a                                    ; $04A9
    inc e                                         ; $04AA
    dec b                                         ; $04AB
    jr nz, jr_000_04a7                            ; $04AC

    pop bc                                        ; $04AE
    ld a, e                                       ; $04AF
    add $0c                                       ; $04B0
    ld e, a                                       ; $04B2
    jr nc, jr_000_04b6                            ; $04B3

    inc d                                         ; $04B5

jr_000_04b6:
    dec b                                         ; $04B6
    jr nz, jr_000_04a4                            ; $04B7

    ld a, e                                       ; $04B9
    add $c0                                       ; $04BA
    ld e, a                                       ; $04BC
    ld a, d                                       ; $04BD
    adc $01                                       ; $04BE
    ld d, a                                       ; $04C0
    pop bc                                        ; $04C1
    dec b                                         ; $04C2
    jr nz, jr_000_04a1                            ; $04C3

    pop de                                        ; $04C5
    ld a, e                                       ; $04C6
    add $40                                       ; $04C7
    ld e, a                                       ; $04C9
    jr nc, jr_000_04cd                            ; $04CA

    inc d                                         ; $04CC

jr_000_04cd:
    ld b, $0e                                     ; $04CD

jr_000_04cf:
    ld a, [hl+]                                   ; $04CF
    add c                                         ; $04D0
    ld [de], a                                    ; $04D1
    inc e                                         ; $04D2
    ld a, [hl+]                                   ; $04D3
    add c                                         ; $04D4
    ld [de], a                                    ; $04D5
    inc e                                         ; $04D6
    set 4, e                                      ; $04D7
    ld a, [hl+]                                   ; $04D9
    add c                                         ; $04DA
    ld [de], a                                    ; $04DB
    inc e                                         ; $04DC
    ld a, [hl+]                                   ; $04DD
    add c                                         ; $04DE
    ld [de], a                                    ; $04DF
    ld a, e                                       ; $04E0
    add $0d                                       ; $04E1
    ld e, a                                       ; $04E3
    jr nc, jr_000_04e7                            ; $04E4

    inc d                                         ; $04E6

jr_000_04e7:
    dec b                                         ; $04E7
    jr nz, jr_000_04cf                            ; $04E8

    pop af                                        ; $04EA
    ret nc                                        ; $04EB

    pop af                                        ; $04EC
    ldh [hRomBankShadow], a                       ; $04ED
    ld [$2000], a                                 ; $04EF
    ret                                           ; $04F2


; C: same copy as Border_CopyFrameAddTile_LcdOff with STAT waits (LCD on); callers 08:50C1 and 08:50F2 (border picker)
Border_CopyFrameAddTile_Safe::
    bit 7, h                                      ; $04F3
    jr nz, jr_000_0506                            ; $04F5

    ldh [hBankTmp], a                             ; $04F7
    ldh a, [hRomBankShadow]                       ; $04F9
    push af                                       ; $04FB
    ldh a, [hBankTmp]                             ; $04FC
    ldh [hRomBankShadow], a                       ; $04FE
    ld [$2000], a                                 ; $0500
    scf                                           ; $0503
    jr jr_000_050a                                ; $0504

jr_000_0506:
    ld [$4000], a                                 ; $0506
    and a                                         ; $0509

jr_000_050a:
    push af                                       ; $050A
    push de                                       ; $050B
    ld b, $02                                     ; $050C

jr_000_050e:
    push bc                                       ; $050E
    ld b, $02                                     ; $050F

jr_000_0511:
    push bc                                       ; $0511
    ld b, $0a                                     ; $0512

jr_000_0514:
    ldh a, [rSTAT]                                ; $0514
    and $03                                       ; $0516
    jr nz, jr_000_0514                            ; $0518

    ld a, [hl+]                                   ; $051A
    add c                                         ; $051B
    ld [de], a                                    ; $051C
    inc e                                         ; $051D
    ld a, [hl+]                                   ; $051E
    add c                                         ; $051F
    ld [de], a                                    ; $0520
    inc e                                         ; $0521
    call Vram_WaitHBlankLine                      ; $0522
    dec b                                         ; $0525
    jr nz, jr_000_0514                            ; $0526

    pop bc                                        ; $0528
    ld a, e                                       ; $0529
    add $0c                                       ; $052A
    ld e, a                                       ; $052C
    jr nc, jr_000_0530                            ; $052D

    inc d                                         ; $052F

jr_000_0530:
    dec b                                         ; $0530
    jr nz, jr_000_0511                            ; $0531

    ld a, e                                       ; $0533
    add $c0                                       ; $0534
    ld e, a                                       ; $0536
    ld a, d                                       ; $0537
    adc $01                                       ; $0538
    ld d, a                                       ; $053A
    pop bc                                        ; $053B
    dec b                                         ; $053C
    jr nz, jr_000_050e                            ; $053D

    pop de                                        ; $053F
    ld a, e                                       ; $0540
    add $40                                       ; $0541
    ld e, a                                       ; $0543
    jr nc, jr_000_0547                            ; $0544

    inc d                                         ; $0546

jr_000_0547:
    ld b, $0e                                     ; $0547

jr_000_0549:
    ldh a, [rSTAT]                                ; $0549
    and $03                                       ; $054B
    jr nz, jr_000_0549                            ; $054D

    ld a, [hl+]                                   ; $054F
    add c                                         ; $0550
    ld [de], a                                    ; $0551
    inc e                                         ; $0552
    ld a, [hl+]                                   ; $0553
    add c                                         ; $0554
    ld [de], a                                    ; $0555
    inc e                                         ; $0556
    set 4, e                                      ; $0557
    call Vram_WaitHBlankLine                      ; $0559

jr_000_055c:
    ldh a, [rSTAT]                                ; $055C
    and $03                                       ; $055E
    jr nz, jr_000_055c                            ; $0560

    ld a, [hl+]                                   ; $0562
    add c                                         ; $0563
    ld [de], a                                    ; $0564
    inc e                                         ; $0565
    ld a, [hl+]                                   ; $0566
    add c                                         ; $0567
    ld [de], a                                    ; $0568
    ld a, e                                       ; $0569
    add $0d                                       ; $056A
    ld e, a                                       ; $056C
    jr nc, jr_000_0570                            ; $056D

    inc d                                         ; $056F

jr_000_0570:
    call Vram_WaitHBlankLine                      ; $0570
    dec b                                         ; $0573
    jr nz, jr_000_0549                            ; $0574

    pop af                                        ; $0576
    ret nc                                        ; $0577

    pop af                                        ; $0578
    ldh [hRomBankShadow], a                       ; $0579
    ld [$2000], a                                 ; $057B
    ret                                           ; $057E


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Delay_Short::
    ld a, $02                                     ; $057F

jr_000_0581:
    nop                                           ; $0581
    dec a                                         ; $0582
    jr nz, jr_000_0581                            ; $0583

    ret                                           ; $0585


; C: 4 bytes per HBlank window. L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 07 10
; 20 (tcrf_check/assets/l3_names/)
Vram_CopyFromBank_4::
    bit 7, h                                      ; $0586
    jr nz, jr_000_0599                            ; $0588

    ldh [hBankTmp], a                             ; $058A
    ldh a, [hRomBankShadow]                       ; $058C
    push af                                       ; $058E
    ldh a, [hBankTmp]                             ; $058F
    ldh [hRomBankShadow], a                       ; $0591
    ld [$2000], a                                 ; $0593
    scf                                           ; $0596
    jr jr_000_059d                                ; $0597

jr_000_0599:
    ld [$4000], a                                 ; $0599
    and a                                         ; $059C

jr_000_059d:
    push af                                       ; $059D
    call Vram_WaitHBlank                          ; $059E

jr_000_05a1:
    call Vram_WaitHBlankLine                      ; $05A1

jr_000_05a4:
    ldh a, [rSTAT]                                ; $05A4
    and $03                                       ; $05A6
    jr nz, jr_000_05a4                            ; $05A8

    ld a, [hl+]                                   ; $05AA
    ld [de], a                                    ; $05AB
    inc de                                        ; $05AC
    ld a, [hl+]                                   ; $05AD
    ld [de], a                                    ; $05AE
    inc de                                        ; $05AF
    ld a, [hl+]                                   ; $05B0
    ld [de], a                                    ; $05B1
    inc de                                        ; $05B2
    ld a, [hl+]                                   ; $05B3
    ld [de], a                                    ; $05B4
    inc de                                        ; $05B5
    nop                                           ; $05B6
    nop                                           ; $05B7
    nop                                           ; $05B8
    nop                                           ; $05B9
    nop                                           ; $05BA
    nop                                           ; $05BB
    nop                                           ; $05BC
    nop                                           ; $05BD
    nop                                           ; $05BE
    nop                                           ; $05BF
    nop                                           ; $05C0
    nop                                           ; $05C1
    dec bc                                        ; $05C2
    dec bc                                        ; $05C3
    dec bc                                        ; $05C4
    dec bc                                        ; $05C5
    nop                                           ; $05C6
    nop                                           ; $05C7
    nop                                           ; $05C8
    nop                                           ; $05C9
    ld a, b                                       ; $05CA
    and a                                         ; $05CB
    jr nz, jr_000_05a1                            ; $05CC

    ld a, c                                       ; $05CE
    cp $04                                        ; $05CF
    jr nc, jr_000_05a1                            ; $05D1

    cp $02                                        ; $05D3
    jr z, jr_000_05e0                             ; $05D5

    pop af                                        ; $05D7
    ret nc                                        ; $05D8

    pop af                                        ; $05D9
    ldh [hRomBankShadow], a                       ; $05DA
    ld [$2000], a                                 ; $05DC
    ret                                           ; $05DF


jr_000_05e0:
    call Vram_WaitHBlankLine                      ; $05E0

jr_000_05e3:
    ldh a, [rSTAT]                                ; $05E3
    and $03                                       ; $05E5
    jr nz, jr_000_05e3                            ; $05E7

    ld a, [hl+]                                   ; $05E9
    ld [de], a                                    ; $05EA
    inc de                                        ; $05EB
    ld a, [hl+]                                   ; $05EC
    ld [de], a                                    ; $05ED
    inc de                                        ; $05EE
    pop af                                        ; $05EF
    ret nc                                        ; $05F0

    pop af                                        ; $05F1
    ldh [hRomBankShadow], a                       ; $05F2
    ld [$2000], a                                 ; $05F4
    ret                                           ; $05F7


; C: bank-aware VRAM copy during display: 6 bytes per HBlank window
Vram_CopyFromBank::
    bit 7, h                                      ; $05F8
    jr nz, jr_000_060b                            ; $05FA

    ldh [hBankTmp], a                             ; $05FC
    ldh a, [hRomBankShadow]                       ; $05FE
    push af                                       ; $0600
    ldh a, [hBankTmp]                             ; $0601
    ldh [hRomBankShadow], a                       ; $0603
    ld [$2000], a                                 ; $0605
    scf                                           ; $0608
    jr jr_000_060f                                ; $0609

jr_000_060b:
    ld [$4000], a                                 ; $060B
    and a                                         ; $060E

jr_000_060f:
    push af                                       ; $060F
    push hl                                       ; $0610
    push de                                       ; $0611
    pop hl                                        ; $0612
    pop de                                        ; $0613
    call Vram_WaitHBlank                          ; $0614

jr_000_0617:
    nop                                           ; $0617
    nop                                           ; $0618
    nop                                           ; $0619
    nop                                           ; $061A
    nop                                           ; $061B

jr_000_061c:
    push bc                                       ; $061C
    ld a, [de]                                    ; $061D
    ld c, a                                       ; $061E
    inc de                                        ; $061F
    ld a, [de]                                    ; $0620
    ld b, a                                       ; $0621
    inc de                                        ; $0622
    call Vram_WaitHBlankLine                      ; $0623

jr_000_0626:
    ldh a, [rSTAT]                                ; $0626
    and $03                                       ; $0628
    jr nz, jr_000_0626                            ; $062A

    ld a, c                                       ; $062C
    ld [hl+], a                                   ; $062D
    ld a, b                                       ; $062E
    ld [hl+], a                                   ; $062F
    ld a, [de]                                    ; $0630
    ld [hl+], a                                   ; $0631
    inc de                                        ; $0632
    ld a, [de]                                    ; $0633
    ld [hl+], a                                   ; $0634
    inc de                                        ; $0635
    ld a, [de]                                    ; $0636
    ld [hl+], a                                   ; $0637
    inc de                                        ; $0638
    ld a, [de]                                    ; $0639
    ld [hl+], a                                   ; $063A
    inc de                                        ; $063B
    pop bc                                        ; $063C
    dec bc                                        ; $063D
    dec bc                                        ; $063E
    dec bc                                        ; $063F
    dec bc                                        ; $0640
    dec bc                                        ; $0641
    dec bc                                        ; $0642
    ld a, b                                       ; $0643
    and a                                         ; $0644
    jr nz, jr_000_0617                            ; $0645

    ld a, c                                       ; $0647
    cp $06                                        ; $0648
    jr nc, jr_000_061c                            ; $064A

    cp $04                                        ; $064C
    jr z, jr_000_0661                             ; $064E

    cp $02                                        ; $0650
    jr z, jr_000_0683                             ; $0652

    push hl                                       ; $0654
    push de                                       ; $0655
    pop hl                                        ; $0656
    pop de                                        ; $0657
    pop af                                        ; $0658
    ret nc                                        ; $0659

    pop af                                        ; $065A
    ldh [hRomBankShadow], a                       ; $065B
    ld [$2000], a                                 ; $065D
    ret                                           ; $0660


jr_000_0661:
    call Vram_WaitHBlankLine                      ; $0661

jr_000_0664:
    ldh a, [rSTAT]                                ; $0664
    and $03                                       ; $0666
    jr nz, jr_000_0664                            ; $0668

    ld a, [de]                                    ; $066A
    ld [hl+], a                                   ; $066B
    inc de                                        ; $066C
    ld a, [de]                                    ; $066D
    ld [hl+], a                                   ; $066E
    inc de                                        ; $066F
    ld a, [de]                                    ; $0670
    ld [hl+], a                                   ; $0671
    inc de                                        ; $0672
    ld a, [de]                                    ; $0673
    ld [hl+], a                                   ; $0674
    inc de                                        ; $0675
    push hl                                       ; $0676
    push de                                       ; $0677
    pop hl                                        ; $0678
    pop de                                        ; $0679
    pop af                                        ; $067A
    ret nc                                        ; $067B

    pop af                                        ; $067C
    ldh [hRomBankShadow], a                       ; $067D
    ld [$2000], a                                 ; $067F
    ret                                           ; $0682


jr_000_0683:
    call Vram_WaitHBlankLine                      ; $0683

jr_000_0686:
    ldh a, [rSTAT]                                ; $0686
    and $03                                       ; $0688
    jr nz, jr_000_0686                            ; $068A

    ld a, [de]                                    ; $068C
    ld [hl+], a                                   ; $068D
    inc de                                        ; $068E
    ld a, [de]                                    ; $068F
    ld [hl+], a                                   ; $0690
    inc de                                        ; $0691
    push hl                                       ; $0692
    push de                                       ; $0693
    pop hl                                        ; $0694
    pop de                                        ; $0695
    pop af                                        ; $0696
    ret nc                                        ; $0697

    pop af                                        ; $0698
    ldh [hRomBankShadow], a                       ; $0699
    ld [$2000], a                                 ; $069B
    ret                                           ; $069E


; I: unreferenced; 8 bytes per window with page-wrapping source. Dead-code root: nothing calls it; assembled as code
; tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Vram_CopyFromBank_8::
    bit 7, h                                      ; $069F
    jr nz, jr_000_06b2                            ; $06A1

    ldh [hBankTmp], a                             ; $06A3
    ldh a, [hRomBankShadow]                       ; $06A5
    push af                                       ; $06A7
    ldh a, [hBankTmp]                             ; $06A8
    ldh [hRomBankShadow], a                       ; $06AA
    ld [$2000], a                                 ; $06AC
    scf                                           ; $06AF
    jr jr_000_06b6                                ; $06B0

jr_000_06b2:
    ld [$4000], a                                 ; $06B2
    and a                                         ; $06B5

jr_000_06b6:
    push af                                       ; $06B6
    srl b                                         ; $06B7
    rr c                                          ; $06B9
    srl b                                         ; $06BB
    rr c                                          ; $06BD
    srl b                                         ; $06BF
    rr c                                          ; $06C1
    push de                                       ; $06C3
    push hl                                       ; $06C4
    pop de                                        ; $06C5
    pop hl                                        ; $06C6
    call Vram_WaitHBlank                          ; $06C7

jr_000_06ca:
    push bc                                       ; $06CA
    ld a, [de]                                    ; $06CB
    ld b, a                                       ; $06CC
    inc e                                         ; $06CD
    ld a, [de]                                    ; $06CE
    ld c, a                                       ; $06CF
    inc e                                         ; $06D0
    call Vram_WaitHBlankLine                      ; $06D1

jr_000_06d4:
    ldh a, [rSTAT]                                ; $06D4
    and $03                                       ; $06D6
    jr nz, jr_000_06d4                            ; $06D8

    ld a, b                                       ; $06DA
    ld [hl+], a                                   ; $06DB
    ld a, c                                       ; $06DC
    ld [hl+], a                                   ; $06DD
    ld a, [de]                                    ; $06DE
    ld [hl+], a                                   ; $06DF
    inc e                                         ; $06E0
    ld a, [de]                                    ; $06E1
    ld [hl+], a                                   ; $06E2
    inc e                                         ; $06E3
    ld a, [de]                                    ; $06E4
    ld [hl+], a                                   ; $06E5
    inc e                                         ; $06E6
    ld a, [de]                                    ; $06E7
    ld [hl+], a                                   ; $06E8
    inc e                                         ; $06E9
    ld a, [de]                                    ; $06EA
    ld [hl+], a                                   ; $06EB
    inc e                                         ; $06EC
    ld a, [de]                                    ; $06ED
    ld [hl+], a                                   ; $06EE
    inc de                                        ; $06EF
    pop bc                                        ; $06F0
    dec bc                                        ; $06F1
    ld a, b                                       ; $06F2
    or c                                          ; $06F3
    jr nz, jr_000_06ca                            ; $06F4

    pop af                                        ; $06F6
    ret nc                                        ; $06F7

    pop af                                        ; $06F8
    ldh [hRomBankShadow], a                       ; $06F9
    ld [$2000], a                                 ; $06FB
    ret                                           ; $06FE


; C: zero BC bytes of VRAM at HL
Vram_ClearSafe::
    call Vram_WaitHBlank                          ; $06FF

jr_000_0702:
    call Vram_WaitHBlankLine                      ; $0702

jr_000_0705:
    ldh a, [rSTAT]                                ; $0705
    and $03                                       ; $0707
    jr nz, jr_000_0705                            ; $0709

    xor a                                         ; $070B
    ld [hl+], a                                   ; $070C
    ld [hl+], a                                   ; $070D
    ld [hl+], a                                   ; $070E
    ld [hl+], a                                   ; $070F
    ld [hl+], a                                   ; $0710
    ld [hl+], a                                   ; $0711
    ld [hl+], a                                   ; $0712
    ld [hl+], a                                   ; $0713
    dec bc                                        ; $0714
    dec bc                                        ; $0715
    dec bc                                        ; $0716
    dec bc                                        ; $0717
    dec bc                                        ; $0718
    dec bc                                        ; $0719
    dec bc                                        ; $071A
    dec bc                                        ; $071B
    ld a, b                                       ; $071C
    or c                                          ; $071D
    jr nz, jr_000_0702                            ; $071E

    ret                                           ; $0720


; C: fill BC bytes of VRAM with $FF
Vram_FillFFSafe::
    call Vram_WaitHBlank                          ; $0721

jr_000_0724:
    call Vram_WaitHBlankLine                      ; $0724

jr_000_0727:
    ldh a, [rSTAT]                                ; $0727
    and $03                                       ; $0729
    jr nz, jr_000_0727                            ; $072B

    ld a, $ff                                     ; $072D
    ld [hl+], a                                   ; $072F
    ld [hl+], a                                   ; $0730
    ld [hl+], a                                   ; $0731
    ld [hl+], a                                   ; $0732
    ld [hl+], a                                   ; $0733
    ld [hl+], a                                   ; $0734
    ld [hl+], a                                   ; $0735
    ld [hl+], a                                   ; $0736
    dec bc                                        ; $0737
    dec bc                                        ; $0738
    dec bc                                        ; $0739
    dec bc                                        ; $073A
    dec bc                                        ; $073B
    dec bc                                        ; $073C
    dec bc                                        ; $073D
    dec bc                                        ; $073E
    ld a, b                                       ; $073F
    or c                                          ; $0740
    jr nz, jr_000_0724                            ; $0741

    ret                                           ; $0743


; C: A -> [HL] after an HBlank sync
Vram_WriteByteSafe::
    push af                                       ; $0744
    call Vram_WaitHBlankLine                      ; $0745

jr_000_0748:
    ldh a, [rSTAT]                                ; $0748
    and $03                                       ; $074A
    jr nz, jr_000_0748                            ; $074C

    pop af                                        ; $074E
    ld [hl], a                                    ; $074F
    ret                                           ; $0750


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Vram_OrByteSafe::
    push af                                       ; $0751
    call Vram_WaitHBlank                          ; $0752
    call Vram_WaitHBlankLine                      ; $0755

jr_000_0758:
    ldh a, [rSTAT]                                ; $0758
    and $03                                       ; $075A
    jr nz, jr_000_0758                            ; $075C

    pop af                                        ; $075E
    or [hl]                                       ; $075F
    ld [hl], a                                    ; $0760
    ret                                           ; $0761


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Vram_AndByteSafe::
    push af                                       ; $0762
    call Vram_WaitHBlank                          ; $0763
    call Vram_WaitHBlankLine                      ; $0766

jr_000_0769:
    ldh a, [rSTAT]                                ; $0769
    and $03                                       ; $076B
    jr nz, jr_000_0769                            ; $076D

    pop af                                        ; $076F
    and [hl]                                      ; $0770
    ld [hl], a                                    ; $0771
    ret                                           ; $0772


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Vram_ReadByteSafe::
    call Vram_WaitHBlank                          ; $0773
    call Vram_WaitHBlankLine                      ; $0776

jr_000_0779:
    ldh a, [rSTAT]                                ; $0779
    and $03                                       ; $077B
    jr nz, jr_000_0779                            ; $077D

    ld a, [hl]                                    ; $077F
    ret                                           ; $0780


; I: unreferenced; posts the word-copy request in chunks and waits for each. Dead-code root: nothing calls it;
; assembled as code tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Vram_CopyViaVBlank::
    bit 7, h                                      ; $0781
    jr nz, jr_000_0794                            ; $0783

    ldh [hBankTmp], a                             ; $0785
    ldh a, [hRomBankShadow]                       ; $0787
    push af                                       ; $0789
    ldh a, [hBankTmp]                             ; $078A
    ldh [hRomBankShadow], a                       ; $078C
    ld [$2000], a                                 ; $078E
    scf                                           ; $0791
    jr jr_000_0798                                ; $0792

jr_000_0794:
    ld [$4000], a                                 ; $0794
    and a                                         ; $0797

jr_000_0798:
    push af                                       ; $0798

jr_000_0799:
    ld a, h                                       ; $0799
    ldh [hCopyReqSrcDstCnt], a                    ; $079A
    ld a, l                                       ; $079C
    ldh [hCopyReqSrcDstCnt + $1], a               ; $079D
    ld a, d                                       ; $079F
    ldh [hCopyReqSrcDstCnt + $2], a               ; $07A0
    ld a, e                                       ; $07A2
    ldh [hCopyReqSrcDstCnt + $3], a               ; $07A3
    ld a, $20                                     ; $07A5
    ldh [hCopyReqSrcDstCnt + $4], a               ; $07A7
    ld a, b                                       ; $07A9
    and a                                         ; $07AA
    jr nz, jr_000_07b6                            ; $07AB

    ld a, c                                       ; $07AD
    cp $40                                        ; $07AE
    jr nc, jr_000_07b6                            ; $07B0

    srl a                                         ; $07B2
    ldh [hCopyReqSrcDstCnt + $4], a               ; $07B4

jr_000_07b6:
    ld a, $01                                     ; $07B6
    ldh [hCopyReqFlag], a                         ; $07B8
    push hl                                       ; $07BA
    push de                                       ; $07BB
    push bc                                       ; $07BC

jr_000_07bd:
    rst Rst08_WaitVBlank                          ; $07BD
    ldh a, [hCopyReqFlag]                         ; $07BE
    and a                                         ; $07C0
    jr nz, jr_000_07bd                            ; $07C1

    pop bc                                        ; $07C3
    ld hl, hCopyReqSrcDstCnt + $4                 ; $07C4
    sla [hl]                                      ; $07C7
    ld a, c                                       ; $07C9
    sub [hl]                                      ; $07CA
    ld c, a                                       ; $07CB
    jr nc, jr_000_07cf                            ; $07CC

    dec b                                         ; $07CE

jr_000_07cf:
    pop de                                        ; $07CF
    ldh a, [hCopyReqSrcDstCnt + $4]               ; $07D0
    add e                                         ; $07D2
    ld e, a                                       ; $07D3
    jr nc, jr_000_07d7                            ; $07D4

    inc d                                         ; $07D6

jr_000_07d7:
    pop hl                                        ; $07D7
    ldh a, [hCopyReqSrcDstCnt + $4]               ; $07D8
    add l                                         ; $07DA
    ld l, a                                       ; $07DB
    jr nc, jr_000_07df                            ; $07DC

    inc h                                         ; $07DE

jr_000_07df:
    ld a, b                                       ; $07DF
    or c                                          ; $07E0
    jr nz, jr_000_0799                            ; $07E1

    pop af                                        ; $07E3
    ret nc                                        ; $07E4

    pop af                                        ; $07E5
    ldh [hRomBankShadow], a                       ; $07E6
    ld [$2000], a                                 ; $07E8
    ret                                           ; $07EB


; C: executes the word-copy request at $FFCB-$FFCF
Irq_VBlank_CopyRequest::
    ldh a, [hCopyReqFlag]                         ; $07EC
    and a                                         ; $07EE
    ret z                                         ; $07EF

    ldh a, [hCopyReqSrcDstCnt]                    ; $07F0
    ld h, a                                       ; $07F2
    ldh a, [hCopyReqSrcDstCnt + $1]               ; $07F3
    ld l, a                                       ; $07F5
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $07F6
    ld d, a                                       ; $07F8
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $07F9
    ld e, a                                       ; $07FB
    ldh a, [hCopyReqSrcDstCnt + $4]               ; $07FC
    ld c, a                                       ; $07FE

jr_000_07ff:
    ld a, [hl+]                                   ; $07FF
    ld [de], a                                    ; $0800
    inc de                                        ; $0801
    ld a, [hl+]                                   ; $0802
    ld [de], a                                    ; $0803
    inc de                                        ; $0804
    dec c                                         ; $0805
    jr nz, jr_000_07ff                            ; $0806

    xor a                                         ; $0808
    ldh [hCopyReqFlag], a                         ; $0809
    ret                                           ; $080B


; C: posts the zero-fill request in chunks
Vram_FillViaVBlank::
    bit 7, h                                      ; $080C
    jr nz, jr_000_081f                            ; $080E

    ldh [hBankTmp], a                             ; $0810
    ldh a, [hRomBankShadow]                       ; $0812
    push af                                       ; $0814
    ldh a, [hBankTmp]                             ; $0815
    ldh [hRomBankShadow], a                       ; $0817
    ld [$2000], a                                 ; $0819
    scf                                           ; $081C
    jr jr_000_0823                                ; $081D

jr_000_081f:
    ld [$4000], a                                 ; $081F
    and a                                         ; $0822

jr_000_0823:
    push af                                       ; $0823

jr_000_0824:
    ld a, h                                       ; $0824
    ldh [hFillReqDst], a                          ; $0825
    ld a, l                                       ; $0827
    ldh [hFillReqDst + $1], a                     ; $0828
    ld a, $20                                     ; $082A
    ldh [hFillReqWords], a                        ; $082C
    ld a, b                                       ; $082E
    and a                                         ; $082F
    jr nz, jr_000_083b                            ; $0830

    ld a, c                                       ; $0832
    cp $40                                        ; $0833
    jr nc, jr_000_083b                            ; $0835

    srl a                                         ; $0837
    ldh [hFillReqWords], a                        ; $0839

jr_000_083b:
    ld a, $01                                     ; $083B
    ldh [hFillReqFlag], a                         ; $083D
    push hl                                       ; $083F
    push bc                                       ; $0840

jr_000_0841:
    rst Rst08_WaitVBlank                          ; $0841
    ldh a, [hFillReqFlag]                         ; $0842
    and a                                         ; $0844
    jr nz, jr_000_0841                            ; $0845

    pop bc                                        ; $0847
    ld hl, hFillReqWords                          ; $0848
    sla [hl]                                      ; $084B
    ld a, c                                       ; $084D
    sub [hl]                                      ; $084E
    ld c, a                                       ; $084F
    jr nc, jr_000_0853                            ; $0850

    dec b                                         ; $0852

jr_000_0853:
    pop hl                                        ; $0853
    ldh a, [hFillReqWords]                        ; $0854
    add l                                         ; $0856
    ld l, a                                       ; $0857
    jr nc, jr_000_085b                            ; $0858

    inc h                                         ; $085A

jr_000_085b:
    ld a, b                                       ; $085B
    or c                                          ; $085C
    jr nz, jr_000_0824                            ; $085D

    pop af                                        ; $085F
    ret nc                                        ; $0860

    pop af                                        ; $0861
    ldh [hRomBankShadow], a                       ; $0862
    ld [$2000], a                                 ; $0864
    ret                                           ; $0867


; C: executes the zero-fill request at $FFD1-$FFD4
Irq_VBlank_FillRequest::
    ldh a, [hFillReqFlag]                         ; $0868
    and a                                         ; $086A
    ret z                                         ; $086B

    ldh a, [hFillReqDst]                          ; $086C
    ld h, a                                       ; $086E
    ldh a, [hFillReqDst + $1]                     ; $086F
    ld l, a                                       ; $0871
    ldh a, [hFillReqWords]                        ; $0872
    ld c, a                                       ; $0874
    xor a                                         ; $0875

jr_000_0876:
    ld [hl+], a                                   ; $0876
    ld [hl+], a                                   ; $0877
    dec c                                         ; $0878
    jr nz, jr_000_0876                            ; $0879

    xor a                                         ; $087B
    ldh [hFillReqFlag], a                         ; $087C
    ret                                           ; $087E


; C: fills $9800-$9BFF with $FF
Vram_ClearBgMap0::
    ld a, $ff                                     ; $087F
    ld hl, $9800                                  ; $0881

jr_000_0884:
    ld [hl+], a                                   ; $0884
    bit 2, h                                      ; $0885
    jr z, jr_000_0884                             ; $0887

    ret                                           ; $0889


; C: fills $9C00-$9FFF with $FF
Vram_ClearBgMap1::
    ld a, $ff                                     ; $088A
    ld hl, $9c00                                  ; $088C

jr_000_088f:
    ld [hl+], a                                   ; $088F
    bit 5, h                                      ; $0890
    jr z, jr_000_088f                             ; $0892

    ret                                           ; $0894


; C: all 160 bytes = $F0 and cursor 0
Oam_ClearShadow::
    ld hl, wOamShadow                             ; $0895
    ld b, $a0                                     ; $0898
    ld a, $f0                                     ; $089A

jr_000_089c:
    ld [hl+], a                                   ; $089C
    dec b                                         ; $089D
    jr nz, jr_000_089c                            ; $089E

    xor a                                         ; $08A0
    ldh [hOamCursor], a                           ; $08A1
    ret                                           ; $08A3


; C: hides the unused tail of the OAM shadow and resets the cursor
Oam_HideUnused::
    ldh a, [hOamCursor]                           ; $08A4
    cp $a0                                        ; $08A6
    jr nc, jr_000_08b7                            ; $08A8

    ld l, a                                       ; $08AA
    ld h, HIGH(wOamShadow)                        ; $08AB
    cpl                                           ; $08AD
    add $a1                                       ; $08AE
    ld b, a                                       ; $08B0
    ld a, $f0                                     ; $08B1

jr_000_08b3:
    ld [hl+], a                                   ; $08B3
    dec b                                         ; $08B4
    jr nz, jr_000_08b3                            ; $08B5

jr_000_08b7:
    xor a                                         ; $08B7
    ldh [hOamCursor], a                           ; $08B8
    ret                                           ; $08BA


; C: A = bank; jp HL
Far_Jump::
    ldh [hRomBankShadow], a                       ; $08BB
    ld [$2000], a                                 ; $08BD
    jp hl                                         ; $08C0


; C: A = bank; HL = routine; $FF9E passed as A
Far_Call::
    ldh [hBankTmp], a                             ; $08C1
    ldh a, [hRomBankShadow]                       ; $08C3
    push af                                       ; $08C5
    ldh a, [hBankTmp]                             ; $08C6
    ldh [hRomBankShadow], a                       ; $08C8
    ld [$2000], a                                 ; $08CA
    ldh a, [hFarcallAArg]                         ; $08CD
    jp hl                                         ; $08CF


; C: restores the caller's bank (return address pushed by Far_Call)
Far_Call_Return::
    push af                                       ; $08D0
    push hl                                       ; $08D1
    ld hl, sp+$05                                 ; $08D2
    ld a, [hl]                                    ; $08D4
    ldh [hRomBankShadow], a                       ; $08D5
    ld [$2000], a                                 ; $08D7
    pop hl                                        ; $08DA
    pop af                                        ; $08DB
    inc sp                                        ; $08DC
    inc sp                                        ; $08DD
    ret                                           ; $08DE


; C: BC frames via rst 08
Wait_Frames::
    push bc                                       ; $08DF
    rst Rst08_WaitVBlank                          ; $08E0
    pop bc                                        ; $08E1
    dec bc                                        ; $08E2
    ld a, c                                       ; $08E3
    or b                                          ; $08E4
    jr nz, Wait_Frames                            ; $08E5

    ret                                           ; $08E7


; C: BC x about one frame busy-wait
Delay_Frames_Busy::
    ld de, $06d6                                  ; $08E8

jr_000_08eb:
    nop                                           ; $08EB
    nop                                           ; $08EC
    nop                                           ; $08ED
    dec de                                        ; $08EE
    ld a, d                                       ; $08EF
    or e                                          ; $08F0
    jr nz, jr_000_08eb                            ; $08F1

    dec bc                                        ; $08F3
    ld a, b                                       ; $08F4
    or c                                          ; $08F5
    jr nz, Delay_Frames_Busy                      ; $08F6

    ret                                           ; $08F8


; C: next byte of the 55-byte subtractive generator
Rng_Next::
    push bc                                       ; $08F9
    push de                                       ; $08FA
    push hl                                       ; $08FB
    ld a, [wRngIndex]                             ; $08FC
    ld c, a                                       ; $08FF
    ld b, $00                                     ; $0900
    inc a                                         ; $0902
    cp $37                                        ; $0903
    jr nz, jr_000_090e                            ; $0905

    call Rng_Refill                               ; $0907
    xor a                                         ; $090A
    ld bc, $0000                                  ; $090B

jr_000_090e:
    ld [wRngIndex], a                             ; $090E
    ld hl, wRngTable                              ; $0911
    add hl, bc                                    ; $0914
    ld a, [hl]                                    ; $0915
    pop hl                                        ; $0916
    pop de                                        ; $0917
    pop bc                                        ; $0918
    ret                                           ; $0919


; C: fills the 55-byte table from SRAM $AFFF seed and stores a new seed back
Rng_Init::
    ld a, [wRngModulus]                           ; $091A
    ld d, a                                       ; $091D
    ld a, $01                                     ; $091E
    ld [$4000], a                                 ; $0920
    ld a, [$afff]                                 ; $0923

jr_000_0926:
    cp d                                          ; $0926
    jr c, jr_000_092c                             ; $0927

    sub d                                         ; $0929
    jr jr_000_0926                                ; $092A

jr_000_092c:
    ld [wRngSeedTmp], a                           ; $092C
    ld [wRngTable + $36], a                       ; $092F
    ld e, $01                                     ; $0932
    ld hl, Rng_InitOrder                          ; $0934
    ld a, $36                                     ; $0937

jr_000_0939:
    push af                                       ; $0939
    ld c, [hl]                                    ; $093A
    inc hl                                        ; $093B
    ld b, $00                                     ; $093C
    push hl                                       ; $093E
    ld hl, wRngTable                              ; $093F
    add hl, bc                                    ; $0942
    ld [hl], e                                    ; $0943
    ld a, [wRngSeedTmp]                           ; $0944
    sub e                                         ; $0947
    jr nc, jr_000_094b                            ; $0948

    add d                                         ; $094A

jr_000_094b:
    ld e, a                                       ; $094B
    ld a, [hl]                                    ; $094C
    ld [wRngSeedTmp], a                           ; $094D
    pop hl                                        ; $0950
    pop af                                        ; $0951
    dec a                                         ; $0952
    jr nz, jr_000_0939                            ; $0953

    call Rng_Refill                               ; $0955
    call Rng_Refill                               ; $0958
    call Rng_Refill                               ; $095B
    push af                                       ; $095E
    ld a, $0a                                     ; $095F
    ld [$0000], a                                 ; $0961
    pop af                                        ; $0964
    ld a, $01                                     ; $0965
    ld [$4000], a                                 ; $0967
    call Rng_Next                                 ; $096A
    ld [$afff], a                                 ; $096D
    push af                                       ; $0970
    xor a                                         ; $0971
    ld [$0000], a                                 ; $0972
    pop af                                        ; $0975
    ret                                           ; $0976


; C: 54-byte index order used by Rng_Init
Rng_InitOrder::
    db $14, $29, $07, $1c, $31, $0f, $24, $02, $17, $2c, $0a, $1f, $34, $12, $27, $05
    db $1a, $2f, $0d, $22, $00, $15, $2a, $08, $1d, $32, $10, $25, $03, $18, $2d, $0b
    db $20, $35, $13, $28, $06, $1b, $30, $0e, $23, $01, $16, $2b, $09, $1e, $33, $11
    db $26, $04, $19, $2e, $0c, $21

; C: one pass of the subtractive recurrence over the table
Rng_Refill::
    ld a, [wRngModulus]                           ; $09AD
    ld d, a                                       ; $09B0
    ld bc, wRngTable                              ; $09B1
    ld hl, wRngTable + $1f                        ; $09B4
    ld e, $18                                     ; $09B7

jr_000_09b9:
    ld a, [bc]                                    ; $09B9
    sub [hl]                                      ; $09BA
    jr nc, jr_000_09be                            ; $09BB

    add d                                         ; $09BD

jr_000_09be:
    ld [bc], a                                    ; $09BE
    dec e                                         ; $09BF
    jr nz, jr_000_09b9                            ; $09C0

    ld bc, wRngTable + $18                        ; $09C2
    ld hl, wRngTable                              ; $09C5
    ld e, $1f                                     ; $09C8

jr_000_09ca:
    ld a, [bc]                                    ; $09CA
    sub [hl]                                      ; $09CB
    jr nc, jr_000_09cf                            ; $09CC

    add d                                         ; $09CE

jr_000_09cf:
    ld [bc], a                                    ; $09CF
    dec e                                         ; $09D0
    jr nz, jr_000_09ca                            ; $09D1

    ret                                           ; $09D3


; C: A = n (0-31): returns floor(Rng_Next x n / 256), i.e. a random value 0..n-1; builds L = n x 8 from
; Rng_Scaled_Mul8Tbl, multiplies with Math_MulAL and shifts H right 3 times; n >= 32 reads past the table
Rng_Scaled::
    push bc                                       ; $09D4
    push hl                                       ; $09D5
    ld c, a                                       ; $09D6
    ld b, $00                                     ; $09D7
    ld hl, Rng_Scaled_Mul8Tbl                     ; $09D9
    add hl, bc                                    ; $09DC
    ld l, [hl]                                    ; $09DD
    call Rng_Next                                 ; $09DE
    call Math_MulAL                               ; $09E1
    srl h                                         ; $09E4
    srl h                                         ; $09E6
    srl h                                         ; $09E8
    ld a, h                                       ; $09EA
    pop hl                                        ; $09EB
    pop bc                                        ; $09EC
    ret                                           ; $09ED


; C: 32 entries n x 8 ($00 $08 ... $F8), read by Rng_Scaled as L for Math_MulAL (the multiplier n x 8 is shifted back
; by the 3 srl h)
Rng_Scaled_Mul8Tbl::
    db $00, $08, $10, $18, $20, $28, $30, $38, $40, $48, $50, $58, $60, $68, $70, $78
    db $80, $88, $90, $98, $a0, $a8, $b0, $b8, $c0, $c8, $d0, $d8, $e0, $e8, $f0, $f8

; C: reads the pad; keys_held / new / released / repeat / sticky
Joy_Read::
    ld a, P1F_GET_DPAD                            ; $0A0E
    ldh [rP1], a                                  ; $0A10
    ldh a, [rP1]                                  ; $0A12
    ldh a, [rP1]                                  ; $0A14
    and $0f                                       ; $0A16
    swap a                                        ; $0A18
    ld b, a                                       ; $0A1A
    ld a, P1F_GET_NONE                            ; $0A1B
    ldh [rP1], a                                  ; $0A1D
    ld a, P1F_GET_BTN                             ; $0A1F
    ldh [rP1], a                                  ; $0A21
    ldh a, [rP1]                                  ; $0A23
    ldh a, [rP1]                                  ; $0A25
    ldh a, [rP1]                                  ; $0A27
    ldh a, [rP1]                                  ; $0A29
    ldh a, [rP1]                                  ; $0A2B
    ldh a, [rP1]                                  ; $0A2D
    and $0f                                       ; $0A2F
    or b                                          ; $0A31
    cpl                                           ; $0A32
    ldh [hKeysHeld], a                            ; $0A33
    ld a, P1F_GET_NONE                            ; $0A35
    ldh [rP1], a                                  ; $0A37
    ldh a, [hKeysHeld]                            ; $0A39
    ld hl, hKeysPrev                              ; $0A3B
    xor [hl]                                      ; $0A3E
    push af                                       ; $0A3F
    ld hl, hKeysHeld                              ; $0A40
    and [hl]                                      ; $0A43
    ldh [hKeysNew], a                             ; $0A44
    ldh [hKeysNewRepeat], a                       ; $0A46
    pop af                                        ; $0A48
    ld hl, hKeysPrev                              ; $0A49
    and [hl]                                      ; $0A4C
    ldh [hKeysReleased], a                        ; $0A4D
    ldh a, [hKeysHeld]                            ; $0A4F
    and a                                         ; $0A51
    jr z, jr_000_0a6a                             ; $0A52

    ld hl, hKeysPrev                              ; $0A54
    cp [hl]                                       ; $0A57
    jr nz, jr_000_0a6a                            ; $0A58

    ld hl, hKeyRepeatCounter                      ; $0A5A
    dec [hl]                                      ; $0A5D
    jr nz, jr_000_0a6e                            ; $0A5E

    ldh a, [hKeysHeld]                            ; $0A60
    ldh [hKeysNewRepeat], a                       ; $0A62
    ldh a, [hKeyRepeatPeriod]                     ; $0A64
    ldh [hKeyRepeatCounter], a                    ; $0A66
    jr jr_000_0a6e                                ; $0A68

jr_000_0a6a:
    ldh a, [hKeyRepeatDelay]                      ; $0A6A
    ldh [hKeyRepeatCounter], a                    ; $0A6C

jr_000_0a6e:
    ldh a, [hKeysHeld]                            ; $0A6E
    ldh [hKeysPrev], a                            ; $0A70
    ld hl, hKeysHeldSticky                        ; $0A72
    ldh a, [hKeysHeld]                            ; $0A75
    or [hl]                                       ; $0A77
    ld [hl+], a                                   ; $0A78
    ldh a, [hKeysNew]                             ; $0A79
    or [hl]                                       ; $0A7B
    ld [hl+], a                                   ; $0A7C
    ldh a, [hKeysNewRepeat]                       ; $0A7D
    or [hl]                                       ; $0A7F
    ld [hl+], a                                   ; $0A80
    ret                                           ; $0A81


; C
Joy_ClearSticky::
    ld hl, hKeysHeldSticky                        ; $0A82
    xor a                                         ; $0A85
    ld [hl+], a                                   ; $0A86
    ld [hl+], a                                   ; $0A87
    ld [hl], a                                    ; $0A88
    ret                                           ; $0A89


; C: queues a block (BC = data pointer
Vq_Push::
    push af                                       ; $0A8A
    ld hl, wVqWriteIdx                            ; $0A8B
    ld l, [hl]                                    ; $0A8E
    ld h, HIGH(wVramQueue)                        ; $0A8F
    ld a, $ff                                     ; $0A91
    ld [hl], a                                    ; $0A93
    inc l                                         ; $0A94
    pop af                                        ; $0A95
    ld [hl], c                                    ; $0A96
    inc l                                         ; $0A97
    ld [hl], b                                    ; $0A98
    inc l                                         ; $0A99
    ld [hl], a                                    ; $0A9A
    inc l                                         ; $0A9B
    xor a                                         ; $0A9C
    ld [hl], a                                    ; $0A9D
    ld a, [wVqWriteIdx]                           ; $0A9E
    add $04                                       ; $0AA1
    ld [wVqWriteIdx], a                           ; $0AA3
    ldh a, [rLCDC]                                ; $0AA6
    bit 7, a                                      ; $0AA8
    ret nz                                        ; $0AAA

    ldh a, [rIE]                                  ; $0AAB
    push af                                       ; $0AAD
    res 0, a                                      ; $0AAE
    ldh [rIE], a                                  ; $0AB0
    call Vq_Process                               ; $0AB2
    pop af                                        ; $0AB5
    ldh [rIE], a                                  ; $0AB6
    ret                                           ; $0AB8


; C: VBlank: runs queued blocks
Vq_Process::
    ld a, [wVqWriteIdx]                           ; $0AB9
    ld hl, wVqReadIdx                             ; $0ABC
    cp [hl]                                       ; $0ABF
    ret z                                         ; $0AC0

    ld l, [hl]                                    ; $0AC1
    ld h, HIGH(wVramQueue)                        ; $0AC2

jr_000_0ac4:
    ld a, [hl]                                    ; $0AC4
    and a                                         ; $0AC5
    jr z, jr_000_0ae2                             ; $0AC6

    inc l                                         ; $0AC8
    ld e, [hl]                                    ; $0AC9
    inc l                                         ; $0ACA
    ld d, [hl]                                    ; $0ACB
    inc l                                         ; $0ACC
    ldh a, [hRomBankShadow]                       ; $0ACD
    push af                                       ; $0ACF
    ld a, [hl]                                    ; $0AD0
    ldh [hRomBankShadow], a                       ; $0AD1
    ld [$2000], a                                 ; $0AD3
    inc l                                         ; $0AD6
    call Vq_RunStream                             ; $0AD7
    pop af                                        ; $0ADA
    ldh [hRomBankShadow], a                       ; $0ADB
    ld [$2000], a                                 ; $0ADD
    jr jr_000_0ac4                                ; $0AE0

jr_000_0ae2:
    ld a, l                                       ; $0AE2
    ld [wVqReadIdx], a                            ; $0AE3
    ret                                           ; $0AE6


; C: decodes one stream: dest hi/lo + control (bit7 column step
Vq_RunStream::
    ldh a, [rIE]                                  ; $0AE7
    push af                                       ; $0AE9
    res 0, a                                      ; $0AEA
    ldh [rIE], a                                  ; $0AEC
    push hl                                       ; $0AEE

jr_000_0aef:
    ld a, [de]                                    ; $0AEF
    ld h, a                                       ; $0AF0
    inc de                                        ; $0AF1
    ld a, [de]                                    ; $0AF2
    ld l, a                                       ; $0AF3
    inc de                                        ; $0AF4
    ld a, [de]                                    ; $0AF5
    inc de                                        ; $0AF6
    bit 7, a                                      ; $0AF7
    jr nz, jr_000_0b15                            ; $0AF9

    bit 6, a                                      ; $0AFB
    jr nz, jr_000_0b0a                            ; $0AFD

    and $3f                                       ; $0AFF
    ld b, a                                       ; $0B01

jr_000_0b02:
    ld a, [de]                                    ; $0B02
    ld [hl+], a                                   ; $0B03
    inc de                                        ; $0B04
    dec b                                         ; $0B05
    jr nz, jr_000_0b02                            ; $0B06

    jr jr_000_0b37                                ; $0B08

jr_000_0b0a:
    and $3f                                       ; $0B0A
    ld b, a                                       ; $0B0C
    ld a, [de]                                    ; $0B0D

jr_000_0b0e:
    ld [hl+], a                                   ; $0B0E
    dec b                                         ; $0B0F
    jr nz, jr_000_0b0e                            ; $0B10

    inc de                                        ; $0B12
    jr jr_000_0b37                                ; $0B13

jr_000_0b15:
    bit 6, a                                      ; $0B15
    jr nz, jr_000_0b29                            ; $0B17

    and $3f                                       ; $0B19
    ld bc, $0020                                  ; $0B1B

jr_000_0b1e:
    push af                                       ; $0B1E
    ld a, [de]                                    ; $0B1F
    ld [hl], a                                    ; $0B20
    inc de                                        ; $0B21
    add hl, bc                                    ; $0B22
    pop af                                        ; $0B23
    dec a                                         ; $0B24
    jr nz, jr_000_0b1e                            ; $0B25

    jr jr_000_0b37                                ; $0B27

jr_000_0b29:
    and $3f                                       ; $0B29
    ld bc, $0020                                  ; $0B2B

jr_000_0b2e:
    push af                                       ; $0B2E
    ld a, [de]                                    ; $0B2F
    ld [hl], a                                    ; $0B30
    add hl, bc                                    ; $0B31
    pop af                                        ; $0B32
    dec a                                         ; $0B33
    jr nz, jr_000_0b2e                            ; $0B34

    inc de                                        ; $0B36

jr_000_0b37:
    ld a, [de]                                    ; $0B37
    and a                                         ; $0B38
    jr nz, jr_000_0aef                            ; $0B39

    pop hl                                        ; $0B3B
    pop af                                        ; $0B3C
    ldh [rIE], a                                  ; $0B3D
    ret                                           ; $0B3F


; C: jp Irq_Stat_Exit
Stat_00_None::
    jp Irq_Stat_Exit                              ; $0B40


; C: flips LCDC bit 4 (BG tile data $8000/$8800) at the split line
Stat_01_TileDataToggle::
    ld hl, hSplit1Latch                           ; $0B43
    ld c, [hl]                                    ; $0B46
    ldh a, [rLY]                                  ; $0B47
    cp c                                          ; $0B49
    jp c, Irq_Stat_Exit                           ; $0B4A

    inc c                                         ; $0B4D
    inc c                                         ; $0B4E
    inc c                                         ; $0B4F
    inc c                                         ; $0B50
    cp c                                          ; $0B51
    jp nc, Irq_Stat_Exit                          ; $0B52

    ld hl, $ff41                                  ; $0B55

jr_000_0b58:
    ld a, [hl]                                    ; $0B58
    and $03                                       ; $0B59
    jr nz, jr_000_0b58                            ; $0B5B

    ldh a, [hLcdcShadow]                          ; $0B5D
    xor $10                                       ; $0B5F
    ldh [rLCDC], a                                ; $0B61
    jp Irq_Stat_Exit                              ; $0B63


; C: loads SCX/SCY of band 1 at the split line
Stat_02_ScrollOneBand::
    ld hl, hSplit1Latch                           ; $0B66
    ldh a, [rLY]                                  ; $0B69
    cp [hl]                                       ; $0B6B
    jp nz, Irq_Stat_Exit                          ; $0B6C

    ldh a, [hScxBand1]                            ; $0B6F
    ld b, a                                       ; $0B71
    ldh a, [hScyBand1]                            ; $0B72
    ld c, a                                       ; $0B74
    ld hl, $ff41                                  ; $0B75

jr_000_0b78:
    ld a, [hl]                                    ; $0B78
    and $03                                       ; $0B79
    jr nz, jr_000_0b78                            ; $0B7B

    ld a, b                                       ; $0B7D
    ldh [rSCX], a                                 ; $0B7E
    ld a, c                                       ; $0B80
    ldh [rSCY], a                                 ; $0B81
    jp Irq_Stat_Exit                              ; $0B83


; C: band 2 switches the BG map to $9C00 (LCDC bit 3)
Stat_03_ScrollTwoBands_Map1::
    ld hl, hSplit1Latch                           ; $0B86
    ldh a, [rLY]                                  ; $0B89
    cp [hl]                                       ; $0B8B
    jr nz, jr_000_0bb1                            ; $0B8C

    ldh a, [hScxBand1Latch]                       ; $0B8E
    ld b, a                                       ; $0B90
    ldh a, [hScyBand1Latch]                       ; $0B91
    ld c, a                                       ; $0B93
    ldh a, [hLcdcShadow]                          ; $0B94
    set 3, a                                      ; $0B96
    ld e, a                                       ; $0B98
    ld hl, $ff41                                  ; $0B99

jr_000_0b9c:
    ld a, [hl]                                    ; $0B9C
    and $03                                       ; $0B9D
    jr nz, jr_000_0b9c                            ; $0B9F

    ld a, b                                       ; $0BA1
    ldh [rSCX], a                                 ; $0BA2
    ld a, c                                       ; $0BA4
    ldh [rSCY], a                                 ; $0BA5
    ld a, e                                       ; $0BA7
    ldh [rLCDC], a                                ; $0BA8
    ldh a, [hSplit2Latch]                         ; $0BAA
    ldh [rLYC], a                                 ; $0BAC
    jp Irq_Stat_Exit                              ; $0BAE


jr_000_0bb1:
    ld hl, hSplit2Latch                           ; $0BB1
    ldh a, [rLY]                                  ; $0BB4
    cp [hl]                                       ; $0BB6
    jp nz, Irq_Stat_Exit                          ; $0BB7

    ldh a, [hScxBand2Latch]                       ; $0BBA
    ld b, a                                       ; $0BBC
    ldh a, [hScyBand2Latch]                       ; $0BBD
    ld c, a                                       ; $0BBF
    ldh a, [hLcdcShadow]                          ; $0BC0
    ld e, a                                       ; $0BC2
    ld hl, $ff41                                  ; $0BC3

jr_000_0bc6:
    ld a, [hl]                                    ; $0BC6
    and $03                                       ; $0BC7
    jr nz, jr_000_0bc6                            ; $0BC9

    ld a, b                                       ; $0BCB
    ldh [rSCX], a                                 ; $0BCC
    ld a, c                                       ; $0BCE
    ldh [rSCY], a                                 ; $0BCF
    ld a, e                                       ; $0BD1
    ldh [rLCDC], a                                ; $0BD2
    jp Irq_Stat_Exit                              ; $0BD4


; C: LCDC bit 5 off and WX=$A5 at the split line
Stat_04_WindowOff::
    ld hl, hSplit1Latch                           ; $0BD7
    ldh a, [rLY]                                  ; $0BDA
    cp [hl]                                       ; $0BDC
    jp nz, Irq_Stat_Exit                          ; $0BDD

    ld hl, $ff41                                  ; $0BE0

jr_000_0be3:
    ld a, [hl]                                    ; $0BE3
    and $03                                       ; $0BE4
    jr nz, jr_000_0be3                            ; $0BE6

    ldh a, [hLcdcShadow]                          ; $0BE8
    res 5, a                                      ; $0BEA
    ldh [rLCDC], a                                ; $0BEC
    ld a, $a5                                     ; $0BEE
    ldh [rWX], a                                  ; $0BF0
    jp Irq_Stat_Exit                              ; $0BF2


; C: second split fixed at LY=$67 with BG map $9C00
Stat_05_ScrollTwoBands_Split67::
    ld hl, hSplit1Latch                           ; $0BF5
    ldh a, [rLY]                                  ; $0BF8
    cp [hl]                                       ; $0BFA
    jr nz, jr_000_0c18                            ; $0BFB

    ldh a, [hScxBand1]                            ; $0BFD
    ld b, a                                       ; $0BFF
    ldh a, [hScyBand1]                            ; $0C00
    ld c, a                                       ; $0C02
    ld hl, $ff41                                  ; $0C03

jr_000_0c06:
    ld a, [hl]                                    ; $0C06
    and $03                                       ; $0C07
    jr nz, jr_000_0c06                            ; $0C09

    ld a, b                                       ; $0C0B
    ldh [rSCX], a                                 ; $0C0C
    ld a, c                                       ; $0C0E
    ldh [rSCY], a                                 ; $0C0F
    ld a, $67                                     ; $0C11
    ldh [rLYC], a                                 ; $0C13
    jp Irq_Stat_Exit                              ; $0C15


jr_000_0c18:
    ldh a, [rLY]                                  ; $0C18
    cp $67                                        ; $0C1A
    jp nz, Irq_Stat_Exit                          ; $0C1C

    ldh a, [hScxBand2]                            ; $0C1F
    ld b, a                                       ; $0C21
    ldh a, [hScyBand2]                            ; $0C22
    ld c, a                                       ; $0C24
    ldh a, [hLcdcShadow]                          ; $0C25
    set 3, a                                      ; $0C27
    ld e, a                                       ; $0C29
    ld hl, $ff41                                  ; $0C2A

jr_000_0c2d:
    ld a, [hl]                                    ; $0C2D
    and $03                                       ; $0C2E
    jr nz, jr_000_0c2d                            ; $0C30

    ld a, b                                       ; $0C32
    ldh [rSCX], a                                 ; $0C33
    ld a, c                                       ; $0C35
    ldh [rSCY], a                                 ; $0C36
    ld a, e                                       ; $0C38
    ldh [rLCDC], a                                ; $0C39
    jp Irq_Stat_Exit                              ; $0C3B


; C: splits at the latch line then LY=$4F then LY=$67
Stat_06_ThreeBands::
    ld hl, hSplit1Latch                           ; $0C3E
    ldh a, [rLY]                                  ; $0C41
    cp [hl]                                       ; $0C43
    jr nz, jr_000_0c61                            ; $0C44

    ldh a, [hScxBand1Latch]                       ; $0C46
    ld b, a                                       ; $0C48
    ldh a, [hScyBand1Latch]                       ; $0C49
    ld c, a                                       ; $0C4B
    ld hl, $ff41                                  ; $0C4C

jr_000_0c4f:
    ld a, [hl]                                    ; $0C4F
    and $03                                       ; $0C50
    jr nz, jr_000_0c4f                            ; $0C52

    ld a, b                                       ; $0C54
    ldh [rSCX], a                                 ; $0C55
    ld a, c                                       ; $0C57
    ldh [rSCY], a                                 ; $0C58
    ld a, $4f                                     ; $0C5A
    ldh [rLYC], a                                 ; $0C5C
    jp Irq_Stat_Exit                              ; $0C5E


jr_000_0c61:
    ldh a, [rLY]                                  ; $0C61
    cp $4f                                        ; $0C63
    jr nz, jr_000_0c8c                            ; $0C65

    ldh a, [hScxBand2Latch]                       ; $0C67
    ld b, a                                       ; $0C69
    ldh a, [hScyBand2Latch]                       ; $0C6A
    ld c, a                                       ; $0C6C
    ldh a, [hLcdcShadow]                          ; $0C6D
    set 3, a                                      ; $0C6F
    set 4, a                                      ; $0C71
    ld e, a                                       ; $0C73
    ld hl, $ff41                                  ; $0C74

jr_000_0c77:
    ld a, [hl]                                    ; $0C77
    and $03                                       ; $0C78
    jr nz, jr_000_0c77                            ; $0C7A

    ld a, b                                       ; $0C7C
    ldh [rSCX], a                                 ; $0C7D
    ld a, c                                       ; $0C7F
    ldh [rSCY], a                                 ; $0C80
    ld a, e                                       ; $0C82
    ldh [rLCDC], a                                ; $0C83
    ld a, $67                                     ; $0C85
    ldh [rLYC], a                                 ; $0C87
    jp Irq_Stat_Exit                              ; $0C89


jr_000_0c8c:
    ldh a, [rLY]                                  ; $0C8C
    cp $67                                        ; $0C8E
    jp nz, Irq_Stat_Exit                          ; $0C90

    ld bc, $0030                                  ; $0C93
    ld hl, $ff41                                  ; $0C96

jr_000_0c99:
    ld a, [hl]                                    ; $0C99
    and $03                                       ; $0C9A
    jr nz, jr_000_0c99                            ; $0C9C

    ld a, b                                       ; $0C9E
    ldh [rSCX], a                                 ; $0C9F
    ld a, c                                       ; $0CA1
    ldh [rSCY], a                                 ; $0CA2
    jp Irq_Stat_Exit                              ; $0CA4


; C: like 03 with the second split from split2_latch
Stat_07_ScrollTwoBands_Map1b::
    ld hl, hSplit1Latch                           ; $0CA7
    ldh a, [rLY]                                  ; $0CAA
    cp [hl]                                       ; $0CAC
    jr nz, jr_000_0cca                            ; $0CAD

    ldh a, [hScxBand1Latch]                       ; $0CAF
    ld b, a                                       ; $0CB1
    ldh a, [hScyBand1Latch]                       ; $0CB2
    ld c, a                                       ; $0CB4
    ld hl, $ff41                                  ; $0CB5

jr_000_0cb8:
    ld a, [hl]                                    ; $0CB8
    and $03                                       ; $0CB9
    jr nz, jr_000_0cb8                            ; $0CBB

    ld a, b                                       ; $0CBD
    ldh [rSCX], a                                 ; $0CBE
    ld a, c                                       ; $0CC0
    ldh [rSCY], a                                 ; $0CC1
    ldh a, [hSplit2Latch]                         ; $0CC3
    ldh [rLYC], a                                 ; $0CC5
    jp Irq_Stat_Exit                              ; $0CC7


jr_000_0cca:
    ld hl, hSplit2Latch                           ; $0CCA
    ldh a, [rLY]                                  ; $0CCD
    cp [hl]                                       ; $0CCF
    jp nz, Irq_Stat_Exit                          ; $0CD0

    ldh a, [hScxBand2Latch]                       ; $0CD3
    ld b, a                                       ; $0CD5
    ldh a, [hScyBand2Latch]                       ; $0CD6
    ld c, a                                       ; $0CD8
    ldh a, [hLcdcShadow]                          ; $0CD9
    set 3, a                                      ; $0CDB
    ld e, a                                       ; $0CDD
    ld hl, $ff41                                  ; $0CDE

jr_000_0ce1:
    ld a, [hl]                                    ; $0CE1
    and $03                                       ; $0CE2
    jr nz, jr_000_0ce1                            ; $0CE4

    ld a, b                                       ; $0CE6
    ldh [rSCX], a                                 ; $0CE7
    ld a, c                                       ; $0CE9
    ldh [rSCY], a                                 ; $0CEA
    ld a, e                                       ; $0CEC
    ldh [rLCDC], a                                ; $0CED
    jp Irq_Stat_Exit                              ; $0CEF


; C: returns 1/2/3/4 for the first set of bits 5/4/6/7 (left right up down). L3 pass 2026-10-26: executed in BGB in 2
; replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Joy_DpadBitToIndex::
    bit 5, a                                      ; $0CF2
    jr z, jr_000_0cf9                             ; $0CF4

    ld a, $01                                     ; $0CF6
    ret                                           ; $0CF8


jr_000_0cf9:
    bit 4, a                                      ; $0CF9
    jr z, jr_000_0d00                             ; $0CFB

    ld a, $02                                     ; $0CFD
    ret                                           ; $0CFF


jr_000_0d00:
    bit 6, a                                      ; $0D00
    jr z, jr_000_0d07                             ; $0D02

    ld a, $03                                     ; $0D04
    ret                                           ; $0D06


jr_000_0d07:
    bit 7, a                                      ; $0D07
    jr z, jr_000_0d0e                             ; $0D09

    ld a, $04                                     ; $0D0B
    ret                                           ; $0D0D


jr_000_0d0e:
    xor a                                         ; $0D0E
    ret                                           ; $0D0F


; C: BGP/OBP0/OBP1 shadows = 0
Pal_AllWhite::
    xor a                                         ; $0D10
    ldh [hBgpShadow], a                           ; $0D11
    ldh [hObp0Shadow], a                          ; $0D13
    ldh [hObp1Shadow], a                          ; $0D15
    ret                                           ; $0D17


; C: 3 steps (2 frames each) from white to palette_target
Pal_FadeIn::
    ld hl, hBgpShadow                             ; $0D18
    ld de, wPaletteTarget                         ; $0D1B
    ld b, $03                                     ; $0D1E

jr_000_0d20:
    ld a, [de]                                    ; $0D20
    and $55                                       ; $0D21
    ld c, a                                       ; $0D23
    ld a, [de]                                    ; $0D24
    and $aa                                       ; $0D25
    srl a                                         ; $0D27
    and c                                         ; $0D29
    ld [hl+], a                                   ; $0D2A
    inc de                                        ; $0D2B
    dec b                                         ; $0D2C
    jr nz, jr_000_0d20                            ; $0D2D

    ld bc, $0002                                  ; $0D2F
    call Wait_Frames                              ; $0D32
    ld hl, hBgpShadow                             ; $0D35
    ld de, wPaletteTarget                         ; $0D38
    ld b, $03                                     ; $0D3B

jr_000_0d3d:
    ld a, [de]                                    ; $0D3D
    and $aa                                       ; $0D3E
    srl a                                         ; $0D40
    add [hl]                                      ; $0D42
    ld [hl+], a                                   ; $0D43
    inc de                                        ; $0D44
    dec b                                         ; $0D45
    jr nz, jr_000_0d3d                            ; $0D46

    ld bc, $0002                                  ; $0D48
    call Wait_Frames                              ; $0D4B
    ld hl, hBgpShadow                             ; $0D4E
    ld de, wPaletteTarget                         ; $0D51
    ld b, $03                                     ; $0D54

jr_000_0d56:
    ld a, [de]                                    ; $0D56
    and $55                                       ; $0D57
    ld c, a                                       ; $0D59
    ld a, [de]                                    ; $0D5A
    and $aa                                       ; $0D5B
    srl a                                         ; $0D5D
    or c                                          ; $0D5F
    add [hl]                                      ; $0D60
    ld [hl+], a                                   ; $0D61
    inc de                                        ; $0D62
    dec b                                         ; $0D63
    jr nz, jr_000_0d56                            ; $0D64

    ld bc, $0002                                  ; $0D66
    call Wait_Frames                              ; $0D69
    ret                                           ; $0D6C


; C: 3 steps down to 0
Pal_FadeOut::
    ld hl, hBgpShadow                             ; $0D6D
    ld b, $03                                     ; $0D70

jr_000_0d72:
    push bc                                       ; $0D72
    push hl                                       ; $0D73
    ld b, $03                                     ; $0D74

jr_000_0d76:
    ld a, [hl]                                    ; $0D76
    and $55                                       ; $0D77
    ld c, a                                       ; $0D79
    ld a, [hl]                                    ; $0D7A
    and $aa                                       ; $0D7B
    srl a                                         ; $0D7D
    or c                                          ; $0D7F
    cpl                                           ; $0D80
    inc a                                         ; $0D81
    add [hl]                                      ; $0D82
    ld [hl+], a                                   ; $0D83
    dec b                                         ; $0D84
    jr nz, jr_000_0d76                            ; $0D85

    ld bc, $0002                                  ; $0D87
    call Wait_Frames                              ; $0D8A
    pop hl                                        ; $0D8D
    pop bc                                        ; $0D8E
    dec b                                         ; $0D8F
    jr nz, jr_000_0d72                            ; $0D90

    xor a                                         ; $0D92
    ld hl, hBgpShadow                             ; $0D93
    ld [hl+], a                                   ; $0D96
    ld [hl+], a                                   ; $0D97
    ld [hl], a                                    ; $0D98
    ld bc, $0002                                  ; $0D99
    call Wait_Frames                              ; $0D9C
    ret                                           ; $0D9F


; C: draws a BG map (HL. L3 pass 2026-10-26: executed in BGB in 89 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Map_SpiralWipeIn::
    push af                                       ; $0DA0
    push hl                                       ; $0DA1
    ld a, $00                                     ; $0DA2
    ld hl, Gfx_WipeTile                           ; $0DA4
    ld de, $8ff0                                  ; $0DA7
    ld bc, $0010                                  ; $0DAA
    call Vram_CopyFromBank                        ; $0DAD
    ld a, $00                                     ; $0DB0
    ld hl, $9800                                  ; $0DB2
    ld bc, $0400                                  ; $0DB5
    call Vram_FillFFSafe                          ; $0DB8
    ld a, [wPaletteTarget]                        ; $0DBB
    ldh [hBgpShadow], a                           ; $0DBE
    pop hl                                        ; $0DC0
    pop af                                        ; $0DC1
    ldh [hBankTmp], a                             ; $0DC2
    ldh a, [hRomBankShadow]                       ; $0DC4
    push af                                       ; $0DC6
    ldh a, [hBankTmp]                             ; $0DC7
    ldh [hRomBankShadow], a                       ; $0DC9
    ld [$2000], a                                 ; $0DCB
    ld de, $0128                                  ; $0DCE
    ld bc, $0301                                  ; $0DD1

; C: per-cell loop top of the spiral wipe: writes one map byte through Vram_WriteByteSafe, waits a frame every 8th
; cell (branch target; code read 2026-10-19)
Map_SpiralWipeIn_CellLoop::
    push bc                                       ; $0DD4

jr_000_0dd5:
    push bc                                       ; $0DD5
    push de                                       ; $0DD6
    push hl                                       ; $0DD7
    add hl, de                                    ; $0DD8
    ld a, [hl]                                    ; $0DD9
    ld hl, $9800                                  ; $0DDA
    add hl, de                                    ; $0DDD
    call Vram_WriteByteSafe                       ; $0DDE
    ld a, b                                       ; $0DE1
    and $07                                       ; $0DE2
    jr nz, jr_000_0de7                            ; $0DE4

    rst Rst08_WaitVBlank                          ; $0DE6

jr_000_0de7:
    pop hl                                        ; $0DE7
    pop de                                        ; $0DE8
    pop bc                                        ; $0DE9
    inc de                                        ; $0DEA
    dec b                                         ; $0DEB
    jr nz, jr_000_0dd5                            ; $0DEC

    pop bc                                        ; $0DEE
    inc b                                         ; $0DEF
    push bc                                       ; $0DF0

jr_000_0df1:
    push bc                                       ; $0DF1
    push de                                       ; $0DF2
    push hl                                       ; $0DF3
    add hl, de                                    ; $0DF4
    ld a, [hl]                                    ; $0DF5
    ld hl, $9800                                  ; $0DF6
    add hl, de                                    ; $0DF9
    call Vram_WriteByteSafe                       ; $0DFA
    ld a, c                                       ; $0DFD
    and $07                                       ; $0DFE
    jr nz, jr_000_0e03                            ; $0E00

    rst Rst08_WaitVBlank                          ; $0E02

jr_000_0e03:
    pop hl                                        ; $0E03
    pop de                                        ; $0E04
    pop bc                                        ; $0E05
    ld a, e                                       ; $0E06
    add $e0                                       ; $0E07
    ld e, a                                       ; $0E09
    ld a, d                                       ; $0E0A
    adc $ff                                       ; $0E0B
    ld d, a                                       ; $0E0D
    dec c                                         ; $0E0E
    jr nz, jr_000_0df1                            ; $0E0F

    pop bc                                        ; $0E11
    inc c                                         ; $0E12
    push bc                                       ; $0E13

jr_000_0e14:
    push bc                                       ; $0E14
    push de                                       ; $0E15
    push hl                                       ; $0E16
    add hl, de                                    ; $0E17
    ld a, [hl]                                    ; $0E18
    ld hl, $9800                                  ; $0E19
    add hl, de                                    ; $0E1C
    call Vram_WriteByteSafe                       ; $0E1D
    ld a, b                                       ; $0E20
    and $07                                       ; $0E21
    jr nz, jr_000_0e26                            ; $0E23

    rst Rst08_WaitVBlank                          ; $0E25

jr_000_0e26:
    pop hl                                        ; $0E26
    pop de                                        ; $0E27
    pop bc                                        ; $0E28
    dec de                                        ; $0E29
    dec b                                         ; $0E2A
    jr nz, jr_000_0e14                            ; $0E2B

    pop bc                                        ; $0E2D
    inc b                                         ; $0E2E
    ld a, b                                       ; $0E2F
    cp $15                                        ; $0E30
    jr z, jr_000_0e5a                             ; $0E32

    push bc                                       ; $0E34

jr_000_0e35:
    push bc                                       ; $0E35
    push de                                       ; $0E36
    push hl                                       ; $0E37
    add hl, de                                    ; $0E38
    ld a, [hl]                                    ; $0E39
    ld hl, $9800                                  ; $0E3A
    add hl, de                                    ; $0E3D
    call Vram_WriteByteSafe                       ; $0E3E
    ld a, c                                       ; $0E41
    and $07                                       ; $0E42
    jr nz, jr_000_0e47                            ; $0E44

    rst Rst08_WaitVBlank                          ; $0E46

jr_000_0e47:
    pop hl                                        ; $0E47
    pop de                                        ; $0E48
    pop bc                                        ; $0E49
    ld a, e                                       ; $0E4A
    add $20                                       ; $0E4B
    ld e, a                                       ; $0E4D
    ld a, d                                       ; $0E4E
    adc $00                                       ; $0E4F
    ld d, a                                       ; $0E51
    dec c                                         ; $0E52
    jr nz, jr_000_0e35                            ; $0E53

    pop bc                                        ; $0E55
    inc c                                         ; $0E56
    jp Map_SpiralWipeIn_CellLoop                  ; $0E57


jr_000_0e5a:
    ld bc, $0004                                  ; $0E5A
    call Wait_Frames                              ; $0E5D
    pop af                                        ; $0E60
    ldh [hRomBankShadow], a                       ; $0E61
    ld [$2000], a                                 ; $0E63
    ret                                           ; $0E66


; C: fills the BG map with $FF in a spiral order (20x17). L3 pass 2026-10-26: executed in BGB in 85 replay(s) of the
; organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Map_SpiralWipeOut::
    ld a, $00                                     ; $0E67
    ld hl, Gfx_WipeTile                           ; $0E69
    ld de, $8ff0                                  ; $0E6C
    ld bc, $0010                                  ; $0E6F
    call Vram_CopyFromBank                        ; $0E72
    ld hl, $9800                                  ; $0E75
    ld bc, $1411                                  ; $0E78

jr_000_0e7b:
    ld a, b                                       ; $0E7B
    and a                                         ; $0E7C
    jr z, jr_000_0efb                             ; $0E7D

    push bc                                       ; $0E7F

jr_000_0e80:
    push bc                                       ; $0E80
    ld a, $ff                                     ; $0E81
    call Vram_WriteByteSafe                       ; $0E83
    ld a, b                                       ; $0E86
    and $07                                       ; $0E87
    jr nz, jr_000_0e8e                            ; $0E89

    push hl                                       ; $0E8B
    rst Rst08_WaitVBlank                          ; $0E8C
    pop hl                                        ; $0E8D

jr_000_0e8e:
    pop bc                                        ; $0E8E
    inc hl                                        ; $0E8F
    dec b                                         ; $0E90
    jr nz, jr_000_0e80                            ; $0E91

    pop bc                                        ; $0E93
    ld de, $001f                                  ; $0E94
    add hl, de                                    ; $0E97
    dec b                                         ; $0E98
    ld a, c                                       ; $0E99
    and a                                         ; $0E9A
    jr z, jr_000_0efb                             ; $0E9B

    push bc                                       ; $0E9D

jr_000_0e9e:
    push bc                                       ; $0E9E
    ld a, $ff                                     ; $0E9F
    call Vram_WriteByteSafe                       ; $0EA1
    ld a, c                                       ; $0EA4
    and $07                                       ; $0EA5
    jr nz, jr_000_0eac                            ; $0EA7

    push hl                                       ; $0EA9
    rst Rst08_WaitVBlank                          ; $0EAA
    pop hl                                        ; $0EAB

jr_000_0eac:
    pop bc                                        ; $0EAC
    ld de, $0020                                  ; $0EAD
    add hl, de                                    ; $0EB0
    dec c                                         ; $0EB1
    jr nz, jr_000_0e9e                            ; $0EB2

    pop bc                                        ; $0EB4
    ld de, $ffdf                                  ; $0EB5
    add hl, de                                    ; $0EB8
    dec c                                         ; $0EB9
    ld a, b                                       ; $0EBA
    and a                                         ; $0EBB
    jr z, jr_000_0efb                             ; $0EBC

    push bc                                       ; $0EBE

jr_000_0ebf:
    push bc                                       ; $0EBF
    ld a, $ff                                     ; $0EC0
    call Vram_WriteByteSafe                       ; $0EC2
    ld a, b                                       ; $0EC5
    and $07                                       ; $0EC6
    jr nz, jr_000_0ecd                            ; $0EC8

    push hl                                       ; $0ECA
    rst Rst08_WaitVBlank                          ; $0ECB
    pop hl                                        ; $0ECC

jr_000_0ecd:
    pop bc                                        ; $0ECD
    dec hl                                        ; $0ECE
    dec b                                         ; $0ECF
    jr nz, jr_000_0ebf                            ; $0ED0

    pop bc                                        ; $0ED2
    ld de, $ffe1                                  ; $0ED3
    add hl, de                                    ; $0ED6
    dec b                                         ; $0ED7
    ld a, c                                       ; $0ED8
    and a                                         ; $0ED9
    jr z, jr_000_0efb                             ; $0EDA

    push bc                                       ; $0EDC

jr_000_0edd:
    push bc                                       ; $0EDD
    ld a, $ff                                     ; $0EDE
    call Vram_WriteByteSafe                       ; $0EE0
    ld a, c                                       ; $0EE3
    and $07                                       ; $0EE4
    jr nz, jr_000_0eeb                            ; $0EE6

    push hl                                       ; $0EE8
    rst Rst08_WaitVBlank                          ; $0EE9
    pop hl                                        ; $0EEA

jr_000_0eeb:
    pop bc                                        ; $0EEB
    ld de, $ffe0                                  ; $0EEC
    add hl, de                                    ; $0EEF
    dec c                                         ; $0EF0
    jr nz, jr_000_0edd                            ; $0EF1

    pop bc                                        ; $0EF3
    ld de, $0021                                  ; $0EF4
    add hl, de                                    ; $0EF7
    dec c                                         ; $0EF8
    jr jr_000_0e7b                                ; $0EF9

jr_000_0efb:
    ld a, $ff                                     ; $0EFB
    ldh [hBgpShadow], a                           ; $0EFD
    ld bc, $0004                                  ; $0EFF
    call Wait_Frames                              ; $0F02
    ret                                           ; $0F05


; C: 16-byte tile used by the wipes. L3 pass 2026-10-26: read in BGB in 89 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Gfx_WipeTile::
    INCBIN "data/bank_00/Gfx_WipeTile.2bpp" ; $0F06, 16 bytes
; C: serial interrupt body of the printer driver
Prn_SerialIrq::
    push af                                       ; $0F16
    ldh a, [rSC]                                  ; $0F17
    bit 7, a                                      ; $0F19
    jr nz, jr_000_0f2b                            ; $0F1B

    push bc                                       ; $0F1D
    push de                                       ; $0F1E
    push hl                                       ; $0F1F
    ld a, $01                                     ; $0F20
    ld [wPrnIrqSeen], a                           ; $0F22
    call Prn_SerialStep                           ; $0F25
    pop hl                                        ; $0F28
    pop de                                        ; $0F29
    pop bc                                        ; $0F2A

jr_000_0f2b:
    pop af                                        ; $0F2B
    reti                                          ; $0F2C


; C: every 6th VBlank sends the status poll when the printer is idle
Prn_VBlankPoll::
    ld a, [wPrnState]                             ; $0F2D
    cp $01                                        ; $0F30
    ret nz                                        ; $0F32

    ld a, [wPrnStatus]                            ; $0F33
    cp $ff                                        ; $0F36
    ret z                                         ; $0F38

    ld a, [wPrnTxBusy]                            ; $0F39
    and a                                         ; $0F3C
    ret nz                                        ; $0F3D

    ld hl, wPrnPollCnt                            ; $0F3E
    inc [hl]                                      ; $0F41
    ld a, [hl]                                    ; $0F42
    cp $06                                        ; $0F43
    ret c                                         ; $0F45

    xor a                                         ; $0F46
    ld [hl], a                                    ; $0F47
    ld [wPrnBusySeen], a                          ; $0F48
    call Prn_SendInquiry                          ; $0F4B
    ret                                           ; $0F4E


; C: HL = A * L (8x8 shift-add)
Math_MulAL::
    push bc                                       ; $0F4F
    ld c, l                                       ; $0F50
    ld b, $00                                     ; $0F51
    ld hl, $0000                                  ; $0F53
    bit 0, a                                      ; $0F56
    jr z, jr_000_0f5b                             ; $0F58

    add hl, bc                                    ; $0F5A

jr_000_0f5b:
    sla c                                         ; $0F5B
    rl b                                          ; $0F5D
    bit 1, a                                      ; $0F5F
    jr z, jr_000_0f64                             ; $0F61

    add hl, bc                                    ; $0F63

jr_000_0f64:
    sla c                                         ; $0F64
    rl b                                          ; $0F66
    bit 2, a                                      ; $0F68
    jr z, jr_000_0f6d                             ; $0F6A

    add hl, bc                                    ; $0F6C

jr_000_0f6d:
    sla c                                         ; $0F6D
    rl b                                          ; $0F6F
    bit 3, a                                      ; $0F71
    jr z, jr_000_0f76                             ; $0F73

    add hl, bc                                    ; $0F75

jr_000_0f76:
    sla c                                         ; $0F76
    rl b                                          ; $0F78
    bit 4, a                                      ; $0F7A
    jr z, jr_000_0f7f                             ; $0F7C

    add hl, bc                                    ; $0F7E

jr_000_0f7f:
    sla c                                         ; $0F7F
    rl b                                          ; $0F81
    bit 5, a                                      ; $0F83
    jr z, jr_000_0f88                             ; $0F85

    add hl, bc                                    ; $0F87

jr_000_0f88:
    sla c                                         ; $0F88
    rl b                                          ; $0F8A
    bit 6, a                                      ; $0F8C
    jr z, jr_000_0f91                             ; $0F8E

    add hl, bc                                    ; $0F90

jr_000_0f91:
    sla c                                         ; $0F91
    rl b                                          ; $0F93
    bit 7, a                                      ; $0F95
    jr z, jr_000_0f9a                             ; $0F97

    add hl, bc                                    ; $0F99

jr_000_0f9a:
    pop bc                                        ; $0F9A
    ret                                           ; $0F9B


; C: adds A (BCD) to the B-byte BCD number at HL; saturates at all $99
Bcd_AddSaturate::
    push bc                                       ; $0F9C
    push hl                                       ; $0F9D

jr_000_0f9e:
    add [hl]                                      ; $0F9E
    daa                                           ; $0F9F
    ld [hl+], a                                   ; $0FA0
    jr nc, jr_000_0fa8                            ; $0FA1

    ld a, $01                                     ; $0FA3
    dec b                                         ; $0FA5
    jr nz, jr_000_0f9e                            ; $0FA6

jr_000_0fa8:
    pop hl                                        ; $0FA8
    pop bc                                        ; $0FA9
    ret nc                                        ; $0FAA

    ld a, $99                                     ; $0FAB

jr_000_0fad:
    ld [hl+], a                                   ; $0FAD
    dec b                                         ; $0FAE
    jr nz, jr_000_0fad                            ; $0FAF

    ret                                           ; $0FB1


; C: quarter-wave table lookup: A = angle 0..255
Math_Sin::
    bit 7, a                                      ; $0FB2
    push af                                       ; $0FB4
    bit 6, a                                      ; $0FB5
    jr z, jr_000_0fba                             ; $0FB7

    cpl                                           ; $0FB9

jr_000_0fba:
    and $3f                                       ; $0FBA
    ld c, a                                       ; $0FBC
    ld b, $00                                     ; $0FBD
    ld hl, Math_SinTable                          ; $0FBF
    add hl, bc                                    ; $0FC2
    ld c, [hl]                                    ; $0FC3
    pop af                                        ; $0FC4
    ld a, c                                       ; $0FC5
    ret                                           ; $0FC6


; C: Math_Sin(A+$40)
Math_Cos::
    add $40                                       ; $0FC7
    jr Math_Sin                                   ; $0FC9

; C: 64-byte quarter-wave table
Math_SinTable::
    db $00, $06, $0c, $12, $19, $1f, $25, $2b, $31, $38, $3e, $44, $4a, $50, $56, $5c
    db $61, $67, $6d, $73, $78, $7e, $83, $88, $8e, $93, $98, $9d, $a2, $a7, $ab, $b0
    db $b5, $b9, $bd, $c1, $c5, $c9, $cd, $d1, $d4, $d8, $db, $de, $e1, $e4, $e7, $ea
    db $ec, $ee, $f1, $f3, $f4, $f6, $f8, $f9, $fb, $fc, $fd, $fe, $fe, $ff, $ff, $ff

; C: clears the 32-byte sprite-animation slot area at $D500
Anim_ClearSlots::
    ld hl, wSpriteAnimFrame                       ; $100B
    xor a                                         ; $100E
    ld b, $10                                     ; $100F

jr_000_1011:
    ld [hl+], a                                   ; $1011
    ld [hl+], a                                   ; $1012
    dec b                                         ; $1013
    jr nz, jr_000_1011                            ; $1014

    ret                                           ; $1016


; C: D.J. editor sound engine: steps the three channels then writes NR2x NR3x NR4x NR51 at LY=$80
DjSnd_Tick::
    ld a, [wTickFlag]                             ; $1017
    and a                                         ; $101A
    jp z, DjSnd_ModulationOnly                    ; $101B

    call DjSnd_StepSoundI                         ; $101E
    call DjSnd_StepSoundII                        ; $1021
    call DjSnd_StepNoise                          ; $1024

jr_000_1027:
    ldh a, [rLY]                                  ; $1027
    cp $80                                        ; $1029
    jr nz, jr_000_1027                            ; $102B

    ld a, [wPerfChannelState]                     ; $102D
    and a                                         ; $1030
    jr z, jr_000_1051                             ; $1031

    ld a, [wRestFlags]                            ; $1033
    and a                                         ; $1036
    jr nz, jr_000_1051                            ; $1037

    ld a, [wNr21Nr22Shadow]                       ; $1039
    ldh [rNR21], a                                ; $103C
    ld a, [wNr21Nr22Shadow + $1]                  ; $103E
    ldh [rNR22], a                                ; $1041
    ld hl, wNr24ControlShadow                     ; $1043
    ld a, [wSound1FreqCur]                        ; $1046
    ldh [rNR23], a                                ; $1049
    ld a, [wSound1FreqCur + $1]                   ; $104B
    or [hl]                                       ; $104E
    ldh [rNR24], a                                ; $104F

jr_000_1051:
    ld a, [wPerfChannelState + $1]                ; $1051
    and a                                         ; $1054
    jr z, jr_000_1080                             ; $1055

    ld a, [wRestFlags + $1]                       ; $1057
    and a                                         ; $105A
    jr nz, jr_000_1080                            ; $105B

    xor a                                         ; $105D
    ldh [rNR30], a                                ; $105E
    call DjSnd_LoadWaveRam                        ; $1060
    ld a, [wNr30Nr32Shadow]                       ; $1063
    ldh [rNR30], a                                ; $1066
    ld a, [wNr30Nr32Shadow + $1]                  ; $1068
    ldh [rNR31], a                                ; $106B
    ld a, [wNr30Nr32Shadow + $2]                  ; $106D
    ldh [rNR32], a                                ; $1070
    ld hl, wNr34ControlShadow                     ; $1072
    ld a, [wSound2FreqCur]                        ; $1075
    ldh [rNR33], a                                ; $1078
    ld a, [wSound2FreqCur + $1]                   ; $107A
    or [hl]                                       ; $107D
    ldh [rNR34], a                                ; $107E

jr_000_1080:
    ld a, [wPerfChannelState + $2]                ; $1080
    and a                                         ; $1083
    jr z, jr_000_10a0                             ; $1084

    ld a, [wRestFlags + $2]                       ; $1086
    and a                                         ; $1089
    jr nz, jr_000_10a0                            ; $108A

    ld a, [wNr41Nr42Shadow]                       ; $108C
    ldh [rNR41], a                                ; $108F
    ld a, [wNr41Nr42Shadow + $1]                  ; $1091
    ldh [rNR42], a                                ; $1094
    ld a, [wNoiseNr43]                            ; $1096
    ldh [rNR43], a                                ; $1099
    ld a, [wNr44ControlShadow]                    ; $109B
    ldh [rNR44], a                                ; $109E

jr_000_10a0:
    ld a, [wNr51PanShadow]                        ; $10A0
    or $11                                        ; $10A3
    ld hl, wPerfNr51Mask                          ; $10A5
    and [hl]                                      ; $10A8
    ldh [rNR51], a                                ; $10A9
    ret                                           ; $10AB


; I: unreferenced; loads NR10-NR14 from Snd_UiEffect_Table
Snd_UiEffect_Dead::
    ld a, [wUiSfxRequest]                         ; $10AC
    and a                                         ; $10AF
    ret z                                         ; $10B0

    dec a                                         ; $10B1
    ld c, a                                       ; $10B2
    ld b, $00                                     ; $10B3
    ld hl, Snd_UiEffect_Table                     ; $10B5
    add hl, bc                                    ; $10B8
    ld c, [hl]                                    ; $10B9
    add hl, bc                                    ; $10BA
    ld c, $10                                     ; $10BB
    ld a, [hl+]                                   ; $10BD
    ldh [c], a                                    ; $10BE
    inc c                                         ; $10BF
    ld a, [hl+]                                   ; $10C0
    ldh [c], a                                    ; $10C1
    inc c                                         ; $10C2
    ld a, [hl+]                                   ; $10C3
    ldh [c], a                                    ; $10C4
    inc c                                         ; $10C5
    ld a, [hl+]                                   ; $10C6
    ldh [c], a                                    ; $10C7
    inc c                                         ; $10C8
    ld a, [hl]                                    ; $10C9
    ldh [c], a                                    ; $10CA
    xor a                                         ; $10CB
    ld [wUiSfxRequest], a                         ; $10CC
    ret                                           ; $10CF


; I
Snd_UiEffect_Table::
    db $08, $0c, $10, $14, $18, $1c, $20, $24, $17, $78, $f1, $00, $c7, $17, $7d, $f1
    db $40, $c7, $1f, $7d, $f1, $40, $c7, $77, $60, $f3, $80, $c7, $7f, $60, $8b, $80
    db $c7, $17, $7e, $f0, $c0, $c7, $1f, $7e, $f0, $c0, $c7, $17, $7e, $f1, $00, $c7

; C: SOUND I (NR21-NR24) next step
DjSnd_StepSoundI::
    ldh a, [hRomBankShadow]                       ; $1100
    push af                                       ; $1102
    ld a, $1f                                     ; $1103
    ldh [hRomBankShadow], a                       ; $1105
    ld [$2000], a                                 ; $1107
    ld hl, wNr24ControlShadow                     ; $110A
    ld [hl], $c0                                  ; $110D
    ld a, [wSound1DutyLen + $1]                   ; $110F
    and a                                         ; $1112
    jr nz, jr_000_1118                            ; $1113

    res 6, [hl]                                   ; $1115
    inc a                                         ; $1117

jr_000_1118:
    dec a                                         ; $1118
    ld c, a                                       ; $1119
    ld b, $00                                     ; $111A
    ld hl, $4025                                  ; $111C
    add hl, bc                                    ; $111F
    ld a, [wSound1DutyLen]                        ; $1120
    swap a                                        ; $1123
    sla a                                         ; $1125
    sla a                                         ; $1127
    or [hl]                                       ; $1129
    ld [wNr21Nr22Shadow], a                       ; $112A
    ld a, [wSound1VolAtten]                       ; $112D
    ld c, a                                       ; $1130
    ld a, [wSound1Envelope + $2]                  ; $1131
    sub c                                         ; $1134
    jr nc, jr_000_1138                            ; $1135

    xor a                                         ; $1137

jr_000_1138:
    swap a                                        ; $1138
    ld c, a                                       ; $113A
    ld a, [wSound1Envelope]                       ; $113B
    xor $01                                       ; $113E
    sla a                                         ; $1140
    sla a                                         ; $1142
    sla a                                         ; $1144
    or c                                          ; $1146
    ld c, a                                       ; $1147
    ld a, [wSound1Envelope + $1]                  ; $1148
    or c                                          ; $114B
    ld [wNr21Nr22Shadow + $1], a                  ; $114C
    xor a                                         ; $114F
    ld [wRestFlags], a                            ; $1150
    ld a, [wSound1PlayStep]                       ; $1153
    ld c, a                                       ; $1156
    ld b, $00                                     ; $1157
    ld hl, wSound1Notes                           ; $1159
    add hl, bc                                    ; $115C
    ld a, [hl]                                    ; $115D
    and a                                         ; $115E
    jr z, jr_000_1169                             ; $115F

    ld hl, wPerfPitchShift                        ; $1161
    add [hl]                                      ; $1164
    cp $26                                        ; $1165
    jr c, jr_000_118c                             ; $1167

jr_000_1169:
    ld a, $01                                     ; $1169
    ld [wRestFlags], a                            ; $116B
    ld a, [wRestCounters]                         ; $116E
    ld hl, wLoopLengths                           ; $1171
    cp [hl]                                       ; $1174
    jr c, jr_000_1181                             ; $1175

    ld a, [wNr51PanShadow]                        ; $1177
    and $dd                                       ; $117A
    ld [wNr51PanShadow], a                        ; $117C
    jr jr_000_1185                                ; $117F

jr_000_1181:
    inc a                                         ; $1181
    ld [wRestCounters], a                         ; $1182

jr_000_1185:
    pop af                                        ; $1185
    ldh [hRomBankShadow], a                       ; $1186
    ld [$2000], a                                 ; $1188
    ret                                           ; $118B


jr_000_118c:
    dec a                                         ; $118C
    ld c, a                                       ; $118D
    ld b, $00                                     ; $118E
    ld hl, $41be                                  ; $1190
    add hl, bc                                    ; $1193
    ld a, [hl]                                    ; $1194
    ld [wSound1ModBase], a                        ; $1195
    sla c                                         ; $1198
    rl b                                          ; $119A
    ld hl, $4051                                  ; $119C
    add hl, bc                                    ; $119F
    ld a, [hl+]                                   ; $11A0
    ld [wSound1FreqCur], a                        ; $11A1
    ld [wSound1FreqBase], a                       ; $11A4
    ld a, [hl]                                    ; $11A7
    ld [wSound1FreqCur + $1], a                   ; $11A8
    ld [wSound1FreqBase + $1], a                  ; $11AB
    xor a                                         ; $11AE
    ld [wSound1ModPhase], a                       ; $11AF
    ld [wSound1ModPhase + $1], a                  ; $11B2
    ld a, [wSound1PlayStep]                       ; $11B5
    ld c, a                                       ; $11B8
    ld b, $00                                     ; $11B9
    ld hl, wSound1Stereo                          ; $11BB
    add hl, bc                                    ; $11BE
    ld c, [hl]                                    ; $11BF
    ld hl, DjSnd_StereoMaskI                      ; $11C0
    add hl, bc                                    ; $11C3
    ld a, [wNr51PanShadow]                        ; $11C4
    and $dd                                       ; $11C7
    or [hl]                                       ; $11C9
    ld [wNr51PanShadow], a                        ; $11CA
    xor a                                         ; $11CD
    ld [wRestCounters], a                         ; $11CE
    pop af                                        ; $11D1
    ldh [hRomBankShadow], a                       ; $11D2
    ld [$2000], a                                 ; $11D4
    ret                                           ; $11D7


; C: 3 bytes NR51 masks
DjSnd_StereoMaskI::
    db $20, $22, $02

; C: SOUND II (wave channel NR30-NR34) next step
DjSnd_StepSoundII::
    ldh a, [hRomBankShadow]                       ; $11DB
    push af                                       ; $11DD
    ld a, $1f                                     ; $11DE
    ldh [hRomBankShadow], a                       ; $11E0
    ld [$2000], a                                 ; $11E2
    ld hl, wNr34ControlShadow                     ; $11E5
    ld [hl], $c0                                  ; $11E8
    ld a, [wSound2WaveLen + $1]                   ; $11EA
    and a                                         ; $11ED
    jr nz, jr_000_11f3                            ; $11EE

    res 6, [hl]                                   ; $11F0
    inc a                                         ; $11F2

jr_000_11f3:
    dec a                                         ; $11F3
    ld c, a                                       ; $11F4
    ld b, $00                                     ; $11F5
    ld hl, $4025                                  ; $11F7
    add hl, bc                                    ; $11FA
    ld a, [hl]                                    ; $11FB
    or $c0                                        ; $11FC
    ld [wNr30Nr32Shadow + $1], a                  ; $11FE
    ld a, $80                                     ; $1201
    ld [wNr30Nr32Shadow], a                       ; $1203
    ld a, $20                                     ; $1206
    ld [wNr30Nr32Shadow + $2], a                  ; $1208
    xor a                                         ; $120B
    ld [wRestFlags + $1], a                       ; $120C
    ld a, [wSound2PlayStep]                       ; $120F
    ld c, a                                       ; $1212
    ld b, $00                                     ; $1213
    ld hl, wSound2Notes                           ; $1215
    add hl, bc                                    ; $1218
    ld a, [hl]                                    ; $1219
    and a                                         ; $121A
    jr z, jr_000_1225                             ; $121B

    ld hl, wPerfPitchShift                        ; $121D
    add [hl]                                      ; $1220
    cp $26                                        ; $1221
    jr c, jr_000_1248                             ; $1223

jr_000_1225:
    ld a, $01                                     ; $1225
    ld [wRestFlags + $1], a                       ; $1227
    ld a, [wRestCounters + $1]                    ; $122A
    ld hl, wLoopLengths + $1                      ; $122D
    cp [hl]                                       ; $1230
    jr c, jr_000_123d                             ; $1231

    ld a, [wNr51PanShadow]                        ; $1233
    and $bb                                       ; $1236
    ld [wNr51PanShadow], a                        ; $1238
    jr jr_000_1241                                ; $123B

jr_000_123d:
    inc a                                         ; $123D
    ld [wRestCounters + $1], a                    ; $123E

jr_000_1241:
    pop af                                        ; $1241
    ldh [hRomBankShadow], a                       ; $1242
    ld [$2000], a                                 ; $1244
    ret                                           ; $1247


jr_000_1248:
    dec a                                         ; $1248
    ld c, a                                       ; $1249
    ld b, $00                                     ; $124A
    ld hl, $41be                                  ; $124C
    add hl, bc                                    ; $124F
    ld a, [hl]                                    ; $1250
    ld [wSound2ModBase], a                        ; $1251
    sla c                                         ; $1254
    rl b                                          ; $1256
    ld hl, $4051                                  ; $1258
    add hl, bc                                    ; $125B
    ld a, [hl+]                                   ; $125C
    ld [wSound2FreqCur], a                        ; $125D
    ld [wSound2FreqBase], a                       ; $1260
    ld a, [hl]                                    ; $1263
    ld [wSound2FreqCur + $1], a                   ; $1264
    ld [wSound2FreqBase + $1], a                  ; $1267
    xor a                                         ; $126A
    ld [wSound2ModPhase], a                       ; $126B
    ld [wSound2ModPhase + $1], a                  ; $126E
    ld a, [wSound2PlayStep]                       ; $1271
    ld c, a                                       ; $1274
    ld b, $00                                     ; $1275
    ld hl, wSound2Stereo                          ; $1277
    add hl, bc                                    ; $127A
    ld c, [hl]                                    ; $127B
    ld hl, DjSnd_StereoMaskII                     ; $127C
    add hl, bc                                    ; $127F
    ld a, [wNr51PanShadow]                        ; $1280
    and $bb                                       ; $1283
    or [hl]                                       ; $1285
    ld [wNr51PanShadow], a                        ; $1286
    xor a                                         ; $1289
    ld [wRestCounters + $1], a                    ; $128A
    pop af                                        ; $128D
    ldh [hRomBankShadow], a                       ; $128E
    ld [$2000], a                                 ; $1290
    ret                                           ; $1293


; C: 3 bytes NR51 masks
DjSnd_StereoMaskII::
    db $40, $44, $04

; C: NOISE (NR41-NR44) next step
DjSnd_StepNoise::
    ldh a, [hRomBankShadow]                       ; $1297
    push af                                       ; $1299
    ld a, $1f                                     ; $129A
    ldh [hRomBankShadow], a                       ; $129C
    ld [$2000], a                                 ; $129E
    ld hl, wNr44ControlShadow                     ; $12A1
    ld a, $c0                                     ; $12A4
    ld [hl], a                                    ; $12A6
    ld a, [wNoiseGateLoop]                        ; $12A7
    and a                                         ; $12AA
    jr nz, jr_000_12b0                            ; $12AB

    res 6, [hl]                                   ; $12AD
    inc a                                         ; $12AF

jr_000_12b0:
    dec a                                         ; $12B0
    ld c, a                                       ; $12B1
    ld b, $00                                     ; $12B2
    ld hl, $4025                                  ; $12B4
    add hl, bc                                    ; $12B7
    ld a, [hl]                                    ; $12B8
    ld [wNr41Nr42Shadow], a                       ; $12B9
    ld a, [wNoiseVolAtten]                        ; $12BC
    ld c, a                                       ; $12BF
    ld a, [wNoiseEnvelope + $2]                   ; $12C0
    sub c                                         ; $12C3
    jr nc, jr_000_12c7                            ; $12C4

    xor a                                         ; $12C6

jr_000_12c7:
    swap a                                        ; $12C7
    ld c, a                                       ; $12C9
    ld a, [wNoiseEnvelope]                        ; $12CA
    xor $01                                       ; $12CD
    sla a                                         ; $12CF
    sla a                                         ; $12D1
    sla a                                         ; $12D3
    or c                                          ; $12D5
    ld c, a                                       ; $12D6
    ld a, [wNoiseEnvelope + $1]                   ; $12D7
    or c                                          ; $12DA
    ld [wNr41Nr42Shadow + $1], a                  ; $12DB
    xor a                                         ; $12DE
    ld [wRestFlags + $2], a                       ; $12DF
    ld a, [wNoisePlayStep]                        ; $12E2
    ld c, a                                       ; $12E5
    ld b, $00                                     ; $12E6
    ld hl, wNoiseNotes                            ; $12E8
    add hl, bc                                    ; $12EB
    ld a, [hl]                                    ; $12EC
    and a                                         ; $12ED
    jr nz, jr_000_1313                            ; $12EE

    ld a, $01                                     ; $12F0
    ld [wRestFlags + $2], a                       ; $12F2
    ld a, [wRestCounters + $2]                    ; $12F5
    ld hl, wNoiseGateLoop + $1                    ; $12F8
    cp [hl]                                       ; $12FB
    jr c, jr_000_1308                             ; $12FC

    ld a, [wNr51PanShadow]                        ; $12FE
    and $77                                       ; $1301
    ld [wNr51PanShadow], a                        ; $1303
    jr jr_000_130c                                ; $1306

jr_000_1308:
    inc a                                         ; $1308
    ld [wRestCounters + $2], a                    ; $1309

jr_000_130c:
    pop af                                        ; $130C
    ldh [hRomBankShadow], a                       ; $130D
    ld [$2000], a                                 ; $130F
    ret                                           ; $1312


jr_000_1313:
    dec a                                         ; $1313
    ld c, a                                       ; $1314
    ld b, $00                                     ; $1315
    ld hl, $4000                                  ; $1317
    add hl, bc                                    ; $131A
    ld a, [hl]                                    ; $131B
    ld [wNoiseNr43], a                            ; $131C
    ld a, [wNoisePlayStep]                        ; $131F
    ld c, a                                       ; $1322
    ld b, $00                                     ; $1323
    ld hl, wNoiseStereoWidth                      ; $1325
    add hl, bc                                    ; $1328
    ld a, [hl]                                    ; $1329
    push af                                       ; $132A
    and $0f                                       ; $132B
    ld c, a                                       ; $132D
    ld hl, DjSnd_StepNoise_Tbl1350                ; $132E
    add hl, bc                                    ; $1331
    ld a, [wNr51PanShadow]                        ; $1332
    and $77                                       ; $1335
    or [hl]                                       ; $1337
    ld [wNr51PanShadow], a                        ; $1338
    pop af                                        ; $133B
    and $10                                       ; $133C
    srl a                                         ; $133E
    ld hl, wNoiseNr43                             ; $1340
    or [hl]                                       ; $1343
    ld [hl], a                                    ; $1344
    xor a                                         ; $1345
    ld [wRestCounters + $2], a                    ; $1346
    pop af                                        ; $1349
    ldh [hRomBankShadow], a                       ; $134A
    ld [$2000], a                                 ; $134C
    ret                                           ; $134F


; C: auto: 3 bytes, bytes; referenced by DjSnd_StepNoise. L3 pass 2026-10-26: read in BGB in the scenarios dj_editor
; 1F:05, dj_editor 1F:09, dj_editor_sound2 1F:05, dj_editor_sound2 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjSnd_StepNoise_Tbl1350::
    db $80, $88, $08

; C: writes the 32-nibble staging buffer to wave RAM $FF30-$FF3F
DjSnd_LoadWaveRam::
    ld c, $30                                     ; $1353
    ld hl, wWaveStaging                           ; $1355
    ld a, [hl+]                                   ; $1358
    swap a                                        ; $1359
    or [hl]                                       ; $135B
    ldh [c], a                                    ; $135C
    inc hl                                        ; $135D
    inc c                                         ; $135E
    ld a, [hl+]                                   ; $135F
    swap a                                        ; $1360
    or [hl]                                       ; $1362
    ldh [c], a                                    ; $1363
    inc hl                                        ; $1364
    inc c                                         ; $1365
    ld a, [hl+]                                   ; $1366
    swap a                                        ; $1367
    or [hl]                                       ; $1369
    ldh [c], a                                    ; $136A
    inc hl                                        ; $136B
    inc c                                         ; $136C
    ld a, [hl+]                                   ; $136D
    swap a                                        ; $136E
    or [hl]                                       ; $1370
    ldh [c], a                                    ; $1371
    inc hl                                        ; $1372
    inc c                                         ; $1373
    ld a, [hl+]                                   ; $1374
    swap a                                        ; $1375
    or [hl]                                       ; $1377
    ldh [c], a                                    ; $1378
    inc hl                                        ; $1379
    inc c                                         ; $137A
    ld a, [hl+]                                   ; $137B
    swap a                                        ; $137C
    or [hl]                                       ; $137E
    ldh [c], a                                    ; $137F
    inc hl                                        ; $1380
    inc c                                         ; $1381
    ld a, [hl+]                                   ; $1382
    swap a                                        ; $1383
    or [hl]                                       ; $1385
    ldh [c], a                                    ; $1386
    inc hl                                        ; $1387
    inc c                                         ; $1388
    ld a, [hl+]                                   ; $1389
    swap a                                        ; $138A
    or [hl]                                       ; $138C
    ldh [c], a                                    ; $138D
    inc hl                                        ; $138E
    inc c                                         ; $138F
    ld a, [hl+]                                   ; $1390
    swap a                                        ; $1391
    or [hl]                                       ; $1393
    ldh [c], a                                    ; $1394
    inc hl                                        ; $1395
    inc c                                         ; $1396
    ld a, [hl+]                                   ; $1397
    swap a                                        ; $1398
    or [hl]                                       ; $139A
    ldh [c], a                                    ; $139B
    inc hl                                        ; $139C
    inc c                                         ; $139D
    ld a, [hl+]                                   ; $139E
    swap a                                        ; $139F
    or [hl]                                       ; $13A1
    ldh [c], a                                    ; $13A2
    inc hl                                        ; $13A3
    inc c                                         ; $13A4
    ld a, [hl+]                                   ; $13A5
    swap a                                        ; $13A6
    or [hl]                                       ; $13A8
    ldh [c], a                                    ; $13A9
    inc hl                                        ; $13AA
    inc c                                         ; $13AB
    ld a, [hl+]                                   ; $13AC
    swap a                                        ; $13AD
    or [hl]                                       ; $13AF
    ldh [c], a                                    ; $13B0
    inc hl                                        ; $13B1
    inc c                                         ; $13B2
    ld a, [hl+]                                   ; $13B3
    swap a                                        ; $13B4
    or [hl]                                       ; $13B6
    ldh [c], a                                    ; $13B7
    inc hl                                        ; $13B8
    inc c                                         ; $13B9
    ld a, [hl+]                                   ; $13BA
    swap a                                        ; $13BB
    or [hl]                                       ; $13BD
    ldh [c], a                                    ; $13BE
    inc hl                                        ; $13BF
    inc c                                         ; $13C0
    ld a, [hl+]                                   ; $13C1
    swap a                                        ; $13C2
    or [hl]                                       ; $13C4
    ldh [c], a                                    ; $13C5
    inc hl                                        ; $13C6
    inc c                                         ; $13C7
    ret                                           ; $13C8


; C: copies the selected wave (D985) to the staging buffer minus the volume attenuation
DjSnd_BuildWaveStaging::
    ld a, [wSound2WaveLen]                        ; $13C9
    sla a                                         ; $13CC
    ld c, a                                       ; $13CE
    ld b, $00                                     ; $13CF
    ld hl, DjSnd_WavePtrs                         ; $13D1
    add hl, bc                                    ; $13D4
    ld a, [hl+]                                   ; $13D5
    ld h, [hl]                                    ; $13D6
    ld l, a                                       ; $13D7
    ld de, wWaveStaging                           ; $13D8
    ld a, [wSound2VolAtten]                       ; $13DB
    sub $01                                       ; $13DE
    jr nc, jr_000_13e3                            ; $13E0

    xor a                                         ; $13E2

jr_000_13e3:
    ld c, a                                       ; $13E3
    ld b, $20                                     ; $13E4

jr_000_13e6:
    ld a, [hl+]                                   ; $13E6
    sub c                                         ; $13E7
    jr nc, jr_000_13eb                            ; $13E8

    xor a                                         ; $13EA

jr_000_13eb:
    ld [de], a                                    ; $13EB
    inc de                                        ; $13EC
    dec b                                         ; $13ED
    jr nz, jr_000_13e6                            ; $13EE

    ret                                           ; $13F0


; C: pointer table of the built-in waves. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0E 1F)
DjSnd_WavePtrs::
    db $f7, $13, $17, $14, $65, $d9

; C: 32 nibbles. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjSnd_WaveA::
    db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f

; C: 32 nibbles. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from
; the code: wave 2 of DjSnd_WavePtrs (00:13F1, read by the wave loader at 00:13D1)
DjSnd_WaveB::
    dw $0209
    dw $0604
    dw $020b
    dw $040d
    dw $0b09
    dw $0d02
    dw $0904
    dw $0609
    dw $0a06
    dw $0606
    dw $020b
    dw $030d
    dw $0b09
    dw $0d02
    dw $0904
    dw $0609

; C: per-frame vibrato and frequency write when no new step
DjSnd_ModulationOnly::
    call DjSnd_ModulateSoundI                     ; $1437
    call DjSnd_ModulateSoundII                    ; $143A

jr_000_143d:
    ldh a, [rLY]                                  ; $143D
    cp $80                                        ; $143F
    jr nz, jr_000_143d                            ; $1441

    ld a, [wNr24ControlShadow]                    ; $1443
    res 7, a                                      ; $1446
    ld c, a                                       ; $1448
    ld a, [wSound1FreqCur]                        ; $1449
    ldh [rNR23], a                                ; $144C
    ld a, [wSound1FreqCur + $1]                   ; $144E
    or c                                          ; $1451
    ldh [rNR24], a                                ; $1452
    ld a, [wNr34ControlShadow]                    ; $1454
    res 7, a                                      ; $1457
    ld c, a                                       ; $1459
    ld a, [wSound2FreqCur]                        ; $145A
    ldh [rNR33], a                                ; $145D
    ld a, [wSound2FreqCur + $1]                   ; $145F
    or c                                          ; $1462
    ldh [rNR34], a                                ; $1463
    ld a, [wNr51PanShadow]                        ; $1465
    or $11                                        ; $1468
    ld hl, wPerfNr51Mask                          ; $146A
    and [hl]                                      ; $146D
    ldh [rNR51], a                                ; $146E
    ret                                           ; $1470


; C: vibrato / LFO of SOUND I (sine
DjSnd_ModulateSoundI::
    ld a, [wSound1Modulation]                     ; $1471
    ld l, a                                       ; $1474
    ld a, [wSound1ModBase]                        ; $1475
    call Math_MulAL                               ; $1478
    ld l, h                                       ; $147B
    push hl                                       ; $147C
    ld a, [wSound1Modulation + $1]                ; $147D
    cpl                                           ; $1480
    add $64                                       ; $1481
    ld l, $80                                     ; $1483
    call Math_MulAL                               ; $1485
    ld bc, $0d80                                  ; $1488
    add hl, bc                                    ; $148B
    ld c, l                                       ; $148C
    ld b, h                                       ; $148D
    ld hl, wSound1ModPhase                        ; $148E
    ld a, [hl]                                    ; $1491
    add c                                         ; $1492
    ld [hl+], a                                   ; $1493
    ld a, [hl]                                    ; $1494
    adc b                                         ; $1495
    ld [hl], a                                    ; $1496
    ld a, [wSound1Modulation + $2]                ; $1497
    and a                                         ; $149A
    jr z, jr_000_14e0                             ; $149B

    dec a                                         ; $149D
    jr z, jr_000_14e6                             ; $149E

    ld a, [wModRandPhase]                         ; $14A0
    xor [hl]                                      ; $14A3
    bit 6, a                                      ; $14A4
    jr nz, jr_000_14d2                            ; $14A6

    pop hl                                        ; $14A8
    ret                                           ; $14A9


jr_000_14aa:
    pop hl                                        ; $14AA
    push af                                       ; $14AB
    call Math_MulAL                               ; $14AC
    pop af                                        ; $14AF
    jr nz, jr_000_14c2                            ; $14B0

    ld a, [wSound1FreqBase]                       ; $14B2
    add h                                         ; $14B5
    ld [wSound1FreqCur], a                        ; $14B6
    ld a, [wSound1FreqBase + $1]                  ; $14B9
    adc $00                                       ; $14BC
    ld [wSound1FreqCur + $1], a                   ; $14BE
    ret                                           ; $14C1


jr_000_14c2:
    ld a, [wSound1FreqBase]                       ; $14C2
    sub h                                         ; $14C5
    ld [wSound1FreqCur], a                        ; $14C6
    ld a, [wSound1FreqBase + $1]                  ; $14C9
    sbc $00                                       ; $14CC
    ld [wSound1FreqCur + $1], a                   ; $14CE
    ret                                           ; $14D1


jr_000_14d2:
    ld a, [hl]                                    ; $14D2
    ld [wModRandPhase], a                         ; $14D3
    xor a                                         ; $14D6
    push af                                       ; $14D7
    call Rng_Next                                 ; $14D8
    ld c, a                                       ; $14DB
    pop af                                        ; $14DC
    ld a, c                                       ; $14DD
    jr jr_000_14aa                                ; $14DE

jr_000_14e0:
    ld a, [hl]                                    ; $14E0
    call Math_Sin                                 ; $14E1
    jr jr_000_14aa                                ; $14E4

jr_000_14e6:
    ld a, [hl]                                    ; $14E6
    bit 7, a                                      ; $14E7
    ld a, $ff                                     ; $14E9
    jr jr_000_14aa                                ; $14EB

; C: vibrato / LFO of SOUND II
DjSnd_ModulateSoundII::
    ld a, [wSound2Modulation]                     ; $14ED
    ld l, a                                       ; $14F0
    ld a, [wSound2ModBase]                        ; $14F1
    call Math_MulAL                               ; $14F4
    ld l, h                                       ; $14F7
    push hl                                       ; $14F8
    ld a, [wSound2Modulation + $1]                ; $14F9
    cpl                                           ; $14FC
    add $64                                       ; $14FD
    ld l, $80                                     ; $14FF
    call Math_MulAL                               ; $1501
    ld bc, $0d80                                  ; $1504
    add hl, bc                                    ; $1507
    ld c, l                                       ; $1508
    ld b, h                                       ; $1509
    ld hl, wSound2ModPhase                        ; $150A
    ld a, [hl]                                    ; $150D
    add c                                         ; $150E
    ld [hl+], a                                   ; $150F
    ld a, [hl]                                    ; $1510
    adc b                                         ; $1511
    ld [hl], a                                    ; $1512
    ld a, [wSound2Modulation + $2]                ; $1513
    and a                                         ; $1516
    jr z, jr_000_155c                             ; $1517

    dec a                                         ; $1519
    jr z, jr_000_1562                             ; $151A

    ld a, [wModRandPhase + $1]                    ; $151C
    xor [hl]                                      ; $151F
    bit 6, a                                      ; $1520
    jr nz, jr_000_154e                            ; $1522

    pop hl                                        ; $1524
    ret                                           ; $1525


jr_000_1526:
    pop hl                                        ; $1526
    push af                                       ; $1527
    call Math_MulAL                               ; $1528
    pop af                                        ; $152B
    jr nz, jr_000_153e                            ; $152C

    ld a, [wSound2FreqBase]                       ; $152E
    add h                                         ; $1531
    ld [wSound2FreqCur], a                        ; $1532
    ld a, [wSound2FreqBase + $1]                  ; $1535
    adc $00                                       ; $1538
    ld [wSound2FreqCur + $1], a                   ; $153A
    ret                                           ; $153D


jr_000_153e:
    ld a, [wSound2FreqBase]                       ; $153E
    sub h                                         ; $1541
    ld [wSound2FreqCur], a                        ; $1542
    ld a, [wSound2FreqBase + $1]                  ; $1545
    sbc $00                                       ; $1548
    ld [wSound2FreqCur + $1], a                   ; $154A
    ret                                           ; $154D


jr_000_154e:
    ld a, [hl]                                    ; $154E
    ld [wModRandPhase + $1], a                    ; $154F
    xor a                                         ; $1552
    push af                                       ; $1553
    call Rng_Next                                 ; $1554
    ld c, a                                       ; $1557
    pop af                                        ; $1558
    ld a, c                                       ; $1559
    jr jr_000_1526                                ; $155A

jr_000_155c:
    ld a, [hl]                                    ; $155C
    call Math_Sin                                 ; $155D
    jr jr_000_1526                                ; $1560

jr_000_1562:
    ld a, [hl]                                    ; $1562
    bit 7, a                                      ; $1563
    ld a, $ff                                     ; $1565
    jr jr_000_1526                                ; $1567

; C: ANDs a 7x8-tile image (pointer from Img_AndMaskTiles_Ptrs indexed by $D7E4) with the mask at 27:5BB0, 2 image
; bytes per mask byte; callers in bank 6
Img_AndMaskTiles_Bank27::
    ldh a, [hRomBankShadow]                       ; $1569
    push af                                       ; $156B
    ld a, $27                                     ; $156C
    ldh [hRomBankShadow], a                       ; $156E
    ld [$2000], a                                 ; $1570
    ld a, [wShootPhase]                           ; $1573
    sla a                                         ; $1576
    ld c, a                                       ; $1578
    ld b, $00                                     ; $1579
    ld hl, Img_AndMaskTiles_Ptrs                  ; $157B
    add hl, bc                                    ; $157E
    ld e, [hl]                                    ; $157F
    inc hl                                        ; $1580
    ld d, [hl]                                    ; $1581
    ld hl, $5bb0                                  ; $1582
    ld b, $07                                     ; $1585

jr_000_1587:
    ld c, $08                                     ; $1587

jr_000_1589:
    ld a, [de]                                    ; $1589
    and [hl]                                      ; $158A
    ld [de], a                                    ; $158B
    inc de                                        ; $158C
    ld a, [de]                                    ; $158D
    and [hl]                                      ; $158E
    ld [de], a                                    ; $158F
    inc de                                        ; $1590
    inc hl                                        ; $1591
    ld a, [de]                                    ; $1592
    and [hl]                                      ; $1593
    ld [de], a                                    ; $1594
    inc de                                        ; $1595
    ld a, [de]                                    ; $1596
    and [hl]                                      ; $1597
    ld [de], a                                    ; $1598
    inc de                                        ; $1599
    inc hl                                        ; $159A
    ld a, [de]                                    ; $159B
    and [hl]                                      ; $159C
    ld [de], a                                    ; $159D
    inc de                                        ; $159E
    ld a, [de]                                    ; $159F
    and [hl]                                      ; $15A0
    ld [de], a                                    ; $15A1
    inc de                                        ; $15A2
    inc hl                                        ; $15A3
    ld a, [de]                                    ; $15A4
    and [hl]                                      ; $15A5
    ld [de], a                                    ; $15A6
    inc de                                        ; $15A7
    ld a, [de]                                    ; $15A8
    and [hl]                                      ; $15A9
    ld [de], a                                    ; $15AA
    inc de                                        ; $15AB
    inc hl                                        ; $15AC
    ld a, [de]                                    ; $15AD
    and [hl]                                      ; $15AE
    ld [de], a                                    ; $15AF
    inc de                                        ; $15B0
    ld a, [de]                                    ; $15B1
    and [hl]                                      ; $15B2
    ld [de], a                                    ; $15B3
    inc de                                        ; $15B4
    inc hl                                        ; $15B5
    ld a, [de]                                    ; $15B6
    and [hl]                                      ; $15B7
    ld [de], a                                    ; $15B8
    inc de                                        ; $15B9
    ld a, [de]                                    ; $15BA
    and [hl]                                      ; $15BB
    ld [de], a                                    ; $15BC
    inc de                                        ; $15BD
    inc hl                                        ; $15BE
    ld a, [de]                                    ; $15BF
    and [hl]                                      ; $15C0
    ld [de], a                                    ; $15C1
    inc de                                        ; $15C2
    ld a, [de]                                    ; $15C3
    and [hl]                                      ; $15C4
    ld [de], a                                    ; $15C5
    inc de                                        ; $15C6
    inc hl                                        ; $15C7
    ld a, [de]                                    ; $15C8
    and [hl]                                      ; $15C9
    ld [de], a                                    ; $15CA
    inc de                                        ; $15CB
    ld a, [de]                                    ; $15CC
    and [hl]                                      ; $15CD
    ld [de], a                                    ; $15CE
    inc de                                        ; $15CF
    inc hl                                        ; $15D0
    dec c                                         ; $15D1
    jr nz, jr_000_1589                            ; $15D2

    ld a, e                                       ; $15D4
    add $80                                       ; $15D5
    ld e, a                                       ; $15D7
    jr nc, jr_000_15db                            ; $15D8

    inc d                                         ; $15DA

jr_000_15db:
    dec b                                         ; $15DB
    jr nz, jr_000_1587                            ; $15DC

    pop af                                        ; $15DE
    ldh [hRomBankShadow], a                       ; $15DF
    ld [$2000], a                                 ; $15E1
    ret                                           ; $15E4


; C: pointer table indexed by $D7E4 x 2: image pointers for Img_AndMaskTiles_Bank27
Img_AndMaskTiles_Ptrs::
    db $00, $c0, $80, $c0, $00, $c7, $80, $c7

; C: A<$80: A = photo_vector_ram[A]. L3 pass 2026-10-26: executed in BGB in 55 replay(s) of the organic corpus, modes
; 0F 12 1A (tcrf_check/assets/l3_names/)
Vec_GetPhotoVectorByte::
    push bc                                       ; $15ED
    push de                                       ; $15EE
    push hl                                       ; $15EF
    bit 7, a                                      ; $15F0
    jr nz, jr_000_15fc                            ; $15F2

    ld c, a                                       ; $15F4
    ld b, $00                                     ; $15F5
    ld hl, wPhotoVectorRam                        ; $15F7
    add hl, bc                                    ; $15FA
    ld a, [hl]                                    ; $15FB

jr_000_15fc:
    pop hl                                        ; $15FC
    pop de                                        ; $15FD
    pop bc                                        ; $15FE
    ret                                           ; $15FF


; C: A<$80: far call 02:444D. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Vec_GetPhotoVectorByteFar::
    push bc                                       ; $1600
    push de                                       ; $1601
    push hl                                       ; $1602
    bit 7, a                                      ; $1603
    jr nz, jr_000_1611                            ; $1605

    ldh [hFarcallAArg], a                         ; $1607
    ld a, BANK(Photo_FindSlot_Far)                ; $1609
    ld hl, Photo_FindSlot_Far                     ; $160B
    call Far_Call                                 ; $160E

jr_000_1611:
    pop hl                                        ; $1611
    pop de                                        ; $1612
    pop bc                                        ; $1613
    ret                                           ; $1614


; C: glyph A of the font table of bank $10 ($7600 + 16 x A, 160 slots up to $7FFF) copied as 16 bytes to DE; the DJ
; print renderer (05:60EE) calls it twice per character: glyph code and code + $10 (an 8x16 character, two tiles one
; over the other, to $C200 + col x 16 and +$130 for the second row), except ...
Gfx_Copy16FromBank10::
    push bc                                       ; $1615
    push hl                                       ; $1616
    swap a                                        ; $1617
    push af                                       ; $1619
    and $f0                                       ; $161A
    ld c, a                                       ; $161C
    pop af                                        ; $161D
    and $0f                                       ; $161E
    ld b, a                                       ; $1620
    ld hl, $7600                                  ; $1621
    add hl, bc                                    ; $1624
    ldh a, [hRomBankShadow]                       ; $1625
    push af                                       ; $1627
    ld a, $10                                     ; $1628
    ldh [hRomBankShadow], a                       ; $162A
    ld [$2000], a                                 ; $162C
    ld a, [hl+]                                   ; $162F
    ld [de], a                                    ; $1630
    inc e                                         ; $1631
    ld a, [hl+]                                   ; $1632
    ld [de], a                                    ; $1633
    inc e                                         ; $1634
    ld a, [hl+]                                   ; $1635
    ld [de], a                                    ; $1636
    inc e                                         ; $1637
    ld a, [hl+]                                   ; $1638
    ld [de], a                                    ; $1639
    inc e                                         ; $163A
    ld a, [hl+]                                   ; $163B
    ld [de], a                                    ; $163C
    inc e                                         ; $163D
    ld a, [hl+]                                   ; $163E
    ld [de], a                                    ; $163F
    inc e                                         ; $1640
    ld a, [hl+]                                   ; $1641
    ld [de], a                                    ; $1642
    inc e                                         ; $1643
    ld a, [hl+]                                   ; $1644
    ld [de], a                                    ; $1645
    inc e                                         ; $1646
    ld a, [hl+]                                   ; $1647
    ld [de], a                                    ; $1648
    inc e                                         ; $1649
    ld a, [hl+]                                   ; $164A
    ld [de], a                                    ; $164B
    inc e                                         ; $164C
    ld a, [hl+]                                   ; $164D
    ld [de], a                                    ; $164E
    inc e                                         ; $164F
    ld a, [hl+]                                   ; $1650
    ld [de], a                                    ; $1651
    inc e                                         ; $1652
    ld a, [hl+]                                   ; $1653
    ld [de], a                                    ; $1654
    inc e                                         ; $1655
    ld a, [hl+]                                   ; $1656
    ld [de], a                                    ; $1657
    inc e                                         ; $1658
    ld a, [hl+]                                   ; $1659
    ld [de], a                                    ; $165A
    inc e                                         ; $165B
    ld a, [hl+]                                   ; $165C
    ld [de], a                                    ; $165D
    inc de                                        ; $165E
    pop af                                        ; $165F
    ldh [hRomBankShadow], a                       ; $1660
    ld [$2000], a                                 ; $1662
    pop hl                                        ; $1665
    pop bc                                        ; $1666
    ret                                           ; $1667


; C: builds the three boss collision masks at D000/D040/D080 (via 05:7F69 and 16C4)
Sf2_BuildBossMasks::
    call Sf2_BossVariantToGroup                   ; $1668
    push af                                       ; $166B
    ld c, $02                                     ; $166C
    ldh [hFarcallAArg], a                         ; $166E
    ld a, BANK(Photo_FarGetAddress)               ; $1670
    ld hl, Photo_FarGetAddress                    ; $1672
    call Far_Call                                 ; $1675
    ld de, wCollisionMask0                        ; $1678
    call Gfx_BuildCellMask                        ; $167B
    pop af                                        ; $167E
    push af                                       ; $167F
    ld c, $00                                     ; $1680
    ldh [hFarcallAArg], a                         ; $1682
    ld a, BANK(Photo_FarGetAddress)               ; $1684
    ld hl, Photo_FarGetAddress                    ; $1686
    call Far_Call                                 ; $1689
    ld de, wCollisionMask1                        ; $168C
    call Gfx_BuildCellMask                        ; $168F
    pop af                                        ; $1692
    ld c, $01                                     ; $1693
    ldh [hFarcallAArg], a                         ; $1695
    ld a, BANK(Photo_FarGetAddress)               ; $1697
    ld hl, Photo_FarGetAddress                    ; $1699
    call Far_Call                                 ; $169C
    ld de, wCollisionMask2                        ; $169F
    call Gfx_BuildCellMask                        ; $16A2
    ret                                           ; $16A5


; C: boss variant -> graphics group (variant 2 depends on gameface_present)
Sf2_BossVariantToGroup::
    push bc                                       ; $16A6
    ld a, [wShootBossVariant]                     ; $16A7
    cp $02                                        ; $16AA
    jr nz, jr_000_16b6                            ; $16AC

    ld hl, wGamefacePresent                       ; $16AE
    bit 0, [hl]                                   ; $16B1
    jr nz, jr_000_16b6                            ; $16B3

    inc a                                         ; $16B5

jr_000_16b6:
    ld c, a                                       ; $16B6
    ld b, $00                                     ; $16B7
    ld hl, Sf2_BossGroupTable                     ; $16B9
    add hl, bc                                    ; $16BC
    ld a, [hl]                                    ; $16BD
    pop bc                                        ; $16BE
    ret                                           ; $16BF


; C: 4 bytes
Sf2_BossGroupTable::
    db $05, $04, $06, $01

; C: 56 cells of 16 bytes OR-ed to one byte each (tile non-empty mask)
Gfx_BuildCellMask::
    bit 7, h                                      ; $16C4
    jr nz, jr_000_16d7                            ; $16C6

    ldh [hBankTmp], a                             ; $16C8
    ldh a, [hRomBankShadow]                       ; $16CA
    push af                                       ; $16CC
    ldh a, [hBankTmp]                             ; $16CD
    ldh [hRomBankShadow], a                       ; $16CF
    ld [$2000], a                                 ; $16D1
    scf                                           ; $16D4
    jr jr_000_16db                                ; $16D5

jr_000_16d7:
    ld [$4000], a                                 ; $16D7
    and a                                         ; $16DA

jr_000_16db:
    push af                                       ; $16DB
    ld b, $38                                     ; $16DC

jr_000_16de:
    xor a                                         ; $16DE
    ld c, $10                                     ; $16DF

jr_000_16e1:
    or [hl]                                       ; $16E1
    inc hl                                        ; $16E2
    dec c                                         ; $16E3
    jr nz, jr_000_16e1                            ; $16E4

    ld [de], a                                    ; $16E6
    inc de                                        ; $16E7
    dec b                                         ; $16E8
    jr nz, jr_000_16de                            ; $16E9

    pop af                                        ; $16EB
    ret nc                                        ; $16EC

    pop af                                        ; $16ED
    ldh [hRomBankShadow], a                       ; $16EE
    ld [$2000], a                                 ; $16F0
    ret                                           ; $16F3


; C: splits the slot's image checksum (F34 = sum, F35 = xor of the 3,584 photo bytes, copied to $DA8F/$DA90) into four
; nibbles $DD03-$DD06 and requests sfx1 $10 = the P.VOICE; BGB 2026-10-14: the four nibbles equal F34/F35 for the 21
; copied stock pictures in the slide show (P.VOICE option) and for a ...
Snd_PlayTagDigits::
    ld a, [wTagImageCheck]                        ; $16F4
    swap a                                        ; $16F7
    and $0f                                       ; $16F9
    ld [wSndDurTabHi], a                          ; $16FB
    ld a, [wTagImageCheck]                        ; $16FE
    and $0f                                       ; $1701
    ld [wSndSfx10Digits], a                       ; $1703
    ld a, [wTagImageCheck + $1]                   ; $1706
    swap a                                        ; $1709
    and $0f                                       ; $170B
    ld [wSndSfx10Digits + $1], a                  ; $170D
    ld a, [wTagImageCheck + $1]                   ; $1710
    and $0f                                       ; $1713
    ld [wSndSfx10Digits + $2], a                  ; $1715
    push af                                       ; $1718
    ld a, SFX1_TAG_DIGITS_JINGLE                  ; $1719
    call Snd_Sfx1                                 ; $171B
    pop af                                        ; $171E
    ret                                           ; $171F


; C: A = bank, HL = source, DE = row buffer: copies 32-byte row records (1 + 3 + 28 bytes) until 18 rows are copied or
; a record pair closes (first byte non-zero toggles bit 7 of C); returns the row count in B; only caller 09:403E
; ScrollEngine_Sub1_FetchRow (credits text scroller, bank $29 script); was ...
ScrollEngine_CopyRowRecords::
    ldh [hBankTmp], a                             ; $1720
    ldh a, [hRomBankShadow]                       ; $1722
    push af                                       ; $1724
    ldh a, [hBankTmp]                             ; $1725
    ldh [hRomBankShadow], a                       ; $1727
    ld [$2000], a                                 ; $1729
    ld bc, $0000                                  ; $172C

jr_000_172f:
    ld a, [hl+]                                   ; $172F
    ld [de], a                                    ; $1730
    inc de                                        ; $1731
    and a                                         ; $1732
    jr z, jr_000_1739                             ; $1733

    ld a, c                                       ; $1735
    xor $80                                       ; $1736
    ld c, a                                       ; $1738

jr_000_1739:
    ld a, [hl+]                                   ; $1739
    ld [de], a                                    ; $173A
    inc de                                        ; $173B
    ld a, [hl+]                                   ; $173C
    ld [de], a                                    ; $173D
    inc de                                        ; $173E
    ld a, [hl+]                                   ; $173F
    ld [de], a                                    ; $1740
    inc de                                        ; $1741
    and a                                         ; $1742
    jr z, jr_000_1746                             ; $1743

    inc c                                         ; $1745

jr_000_1746:
    push bc                                       ; $1746
    ld b, $07                                     ; $1747

jr_000_1749:
    ld a, [hl+]                                   ; $1749
    ld [de], a                                    ; $174A
    inc de                                        ; $174B
    ld a, [hl+]                                   ; $174C
    ld [de], a                                    ; $174D
    inc de                                        ; $174E
    ld a, [hl+]                                   ; $174F
    ld [de], a                                    ; $1750
    inc de                                        ; $1751
    ld a, [hl+]                                   ; $1752
    ld [de], a                                    ; $1753
    inc de                                        ; $1754
    dec b                                         ; $1755
    jr nz, jr_000_1749                            ; $1756

    pop bc                                        ; $1758
    inc b                                         ; $1759
    ld a, c                                       ; $175A
    bit 7, a                                      ; $175B
    jr nz, jr_000_1763                            ; $175D

    and $7f                                       ; $175F
    jr nz, jr_000_1768                            ; $1761

jr_000_1763:
    ld a, b                                       ; $1763
    cp $12                                        ; $1764
    jr nz, jr_000_172f                            ; $1766

jr_000_1768:
    pop af                                        ; $1768
    ldh [hRomBankShadow], a                       ; $1769
    ld [$2000], a                                 ; $176B
    ret                                           ; $176E


; C: one serial IRQ step of the printer packet state machine
Prn_SerialStep::
    ld a, [wPrnAbort]                             ; $176F
    and a                                         ; $1772
    jp nz, Prn_ReceiveStatus_Ret                  ; $1773

    ld a, [wPrnState]                             ; $1776
    cp $07                                        ; $1779
    jp z, Prn_ReceiveStatus                       ; $177B

    ld a, [wPrnSyncDone]                          ; $177E
    and a                                         ; $1781
    jr nz, jr_000_178a                            ; $1782

    call Prn_SendSyncByte                         ; $1784
    jp Prn_SerialStep_Exit                        ; $1787


jr_000_178a:
    ld a, [wPrnHdrDone]                           ; $178A
    and a                                         ; $178D
    jr z, jr_000_17a7                             ; $178E

    ld a, [wPrnDataDone]                          ; $1790
    and a                                         ; $1793
    jr z, jr_000_17a7                             ; $1794

    ld a, [wPrnChkIdx]                            ; $1796
    cp $02                                        ; $1799
    jr z, jr_000_17a2                             ; $179B

    call Prn_SendChecksumByte                     ; $179D
    jr jr_000_17aa                                ; $17A0

jr_000_17a2:
    call Prn_SendTrailerByte                      ; $17A2
    jr jr_000_17aa                                ; $17A5

jr_000_17a7:
    call Prn_SendPacketByte                       ; $17A7

jr_000_17aa:
    jp Prn_SerialStep_Exit                        ; $17AA


; C: sends $88 $33
Prn_SendSyncByte::
    ld hl, wPrnTxIdx                              ; $17AD
    ld c, [hl]                                    ; $17B0
    inc [hl]                                      ; $17B1
    ld b, $00                                     ; $17B2
    ld hl, Prn_SyncBytes                          ; $17B4
    add hl, bc                                    ; $17B7
    ld a, [hl]                                    ; $17B8
    ldh [rSB], a                                  ; $17B9
    ld a, SCF_SOURCE                              ; $17BB
    ldh [rSC], a                                  ; $17BD
    ld a, SCF_START | SCF_SOURCE                  ; $17BF
    ldh [rSC], a                                  ; $17C1
    ld a, [wPrnTxIdx]                             ; $17C3
    cp $02                                        ; $17C6
    ret nz                                        ; $17C8

    xor a                                         ; $17C9
    ld [wPrnTxIdx], a                             ; $17CA
    inc a                                         ; $17CD
    ld [wPrnSyncDone], a                          ; $17CE
    ret                                           ; $17D1


; C: sends one header/data byte and adds it to the checksum
Prn_SendPacketByte::
    ld a, [wPrnTxIdx]                             ; $17D2
    ld c, a                                       ; $17D5
    ld a, [wPrnTxIdx + $1]                        ; $17D6
    ld b, a                                       ; $17D9
    ld a, [wPrnSrcPtr]                            ; $17DA
    ld l, a                                       ; $17DD
    ld a, [wPrnSrcPtr + $1]                       ; $17DE
    ld h, a                                       ; $17E1
    add hl, bc                                    ; $17E2
    ldh a, [rSB]                                  ; $17E3
    ld [wPrnPrevRx], a                            ; $17E5
    ld a, [hl]                                    ; $17E8
    ldh [rSB], a                                  ; $17E9
    ld l, a                                       ; $17EB
    ld a, [wPrnChecksum]                          ; $17EC
    add l                                         ; $17EF
    ld [wPrnChecksum], a                          ; $17F0
    ld a, [wPrnChecksum + $1]                     ; $17F3
    adc $00                                       ; $17F6
    ld [wPrnChecksum + $1], a                     ; $17F8
    ld a, SCF_SOURCE                              ; $17FB
    ldh [rSC], a                                  ; $17FD
    ld a, SCF_START | SCF_SOURCE                  ; $17FF
    ldh [rSC], a                                  ; $1801
    ld hl, wPrnTxIdx                              ; $1803
    inc [hl]                                      ; $1806
    jr nz, jr_000_180b                            ; $1807

    inc hl                                        ; $1809
    inc [hl]                                      ; $180A

jr_000_180b:
    ld hl, wPrnTxIdx                              ; $180B
    ld a, [wPrnTargetLen]                         ; $180E
    cp [hl]                                       ; $1811
    jr nz, jr_000_181b                            ; $1812

    inc hl                                        ; $1814
    ld a, [wPrnTargetLen + $1]                    ; $1815
    cp [hl]                                       ; $1818
    jr z, jr_000_181d                             ; $1819

jr_000_181b:
    jr jr_000_185b                                ; $181B

jr_000_181d:
    ld hl, wPrnHdrDone                            ; $181D
    ld a, [hl]                                    ; $1820
    and a                                         ; $1821
    jr z, jr_000_1827                             ; $1822

    ld hl, wPrnDataDone                           ; $1824

jr_000_1827:
    inc [hl]                                      ; $1827
    ld a, [wPrnHasData]                           ; $1828
    and a                                         ; $182B
    jr z, jr_000_1860                             ; $182C

    ld a, [wPrnState]                             ; $182E
    cp $06                                        ; $1831
    jr z, jr_000_1860                             ; $1833

    ld hl, wPrnDataDone                           ; $1835
    ld a, [hl]                                    ; $1838
    and a                                         ; $1839
    jr nz, jr_000_185c                            ; $183A

    xor a                                         ; $183C
    ld [wPrnTxIdx], a                             ; $183D
    ld [wPrnTxIdx + $1], a                        ; $1840
    ld a, [wPrnDataPtr]                           ; $1843
    ld [wPrnSrcPtr], a                            ; $1846
    ld a, [wPrnDataPtr + $1]                      ; $1849
    ld [wPrnSrcPtr + $1], a                       ; $184C
    ld a, [wPrnDataLen]                           ; $184F
    ld [wPrnTargetLen], a                         ; $1852
    ld a, [wPrnDataLen + $1]                      ; $1855
    ld [wPrnTargetLen + $1], a                    ; $1858

jr_000_185b:
    ret                                           ; $185B


jr_000_185c:
    call Prn_RestoreHeaderPtr                     ; $185C
    ret                                           ; $185F


jr_000_1860:
    ld a, [wPrnPrevRx]                            ; $1860
    ld [wPrnDevId], a                             ; $1863

jr_000_1866:
    ld a, $07                                     ; $1866
    ld [wPrnState], a                             ; $1868
    ld a, $01                                     ; $186B
    ld [wPrnTxPhase], a                           ; $186D
    call Prn_ResetPacketState                     ; $1870

; C: restores length and pointer for the next section
Prn_RestoreHeaderPtr::
    ld a, [wPrnHdrLen]                            ; $1873
    ld [wPrnTargetLen], a                         ; $1876
    ld a, [wPrnHdrLen + $1]                       ; $1879
    ld [wPrnTargetLen + $1], a                    ; $187C
    ld a, [wPrnHdrPtr]                            ; $187F
    ld [wPrnSrcPtr], a                            ; $1882
    ld a, [wPrnHdrPtr + $1]                       ; $1885
    ld [wPrnSrcPtr + $1], a                       ; $1888
    ret                                           ; $188B


; C
Prn_SendChecksumByte::
    ld c, a                                       ; $188C
    ld b, $00                                     ; $188D
    ld hl, wPrnChecksum                           ; $188F
    add hl, bc                                    ; $1892
    ld a, [hl]                                    ; $1893
    ldh [rSB], a                                  ; $1894
    ld a, SCF_SOURCE                              ; $1896
    ldh [rSC], a                                  ; $1898
    ld a, SCF_START | SCF_SOURCE                  ; $189A
    ldh [rSC], a                                  ; $189C
    ld hl, wPrnChkIdx                             ; $189E
    inc [hl]                                      ; $18A1
    ret                                           ; $18A2


; C: two dummy bytes after the checksum; reads device id
Prn_SendTrailerByte::
    ldh a, [rSB]                                  ; $18A3
    ld [wPrnDevId], a                             ; $18A5
    xor a                                         ; $18A8
    ldh [rSB], a                                  ; $18A9
    ld a, SCF_SOURCE                              ; $18AB
    ldh [rSC], a                                  ; $18AD
    ld a, SCF_START | SCF_SOURCE                  ; $18AF
    ldh [rSC], a                                  ; $18B1
    ld hl, wPrnTrailCnt                           ; $18B3
    inc [hl]                                      ; $18B6
    ld a, [hl]                                    ; $18B7
    cp $02                                        ; $18B8
    jr z, jr_000_1866                             ; $18BA

    ret                                           ; $18BC


; C: end of packet: stores the status byte and sets the engine state
Prn_ReceiveStatus::
    ld a, [wPrnPktType]                           ; $18BD
    ld [wPrnLastType], a                          ; $18C0
    ld a, [wPrnStatus]                            ; $18C3
    ld [wPrinterPrevStatus + $1], a               ; $18C6
    cp $ff                                        ; $18C9
    jr z, jr_000_18d0                             ; $18CB

    ld [wPrinterPrevStatus], a                    ; $18CD

jr_000_18d0:
    ldh a, [rSB]                                  ; $18D0
    ld [wPrnStatus], a                            ; $18D2
    cp $ff                                        ; $18D5
    jr nz, jr_000_18e5                            ; $18D7

    ld a, $00                                     ; $18D9
    ld [wPrnTxBusy], a                            ; $18DB
    ld [wPrnState], a                             ; $18DE
    ld a, $02                                     ; $18E1
    jr jr_000_18fd                                ; $18E3

jr_000_18e5:
    bit 1, a                                      ; $18E5
    jr z, jr_000_18ee                             ; $18E7

    ld a, $01                                     ; $18E9
    ld [wPrnBusySeen], a                          ; $18EB

jr_000_18ee:
    bit 4, a                                      ; $18EE
    ld a, $00                                     ; $18F0
    ld [wPrnState], a                             ; $18F2
    ld a, $01                                     ; $18F5
    jr nz, jr_000_18fc                            ; $18F7

    ld [wPrnState], a                             ; $18F9

jr_000_18fc:
    inc a                                         ; $18FC

jr_000_18fd:
    ld [wPrnTxPhase], a                           ; $18FD
    ld a, [wPrnHasData]                           ; $1900
    and a                                         ; $1903
    jr nz, Prn_ReceiveStatus_Ret                  ; $1904

    xor a                                         ; $1906
    ld [wPrnTxBusy], a                            ; $1907

; C: RET shared by the status-byte tail of Prn_SerialStep (taken when the abort flag DC3C is set) (branch target; code
; read 2026-10-19)
Prn_ReceiveStatus_Ret::
    ret                                           ; $190A


; I: unreferenced
Prn_StopSerial_Dead::
    xor a                                         ; $190B
    ldh [rSC], a                                  ; $190C

; C: RET at 190E shared by the live sync-byte and packet-byte branches of Prn_SerialStep (the dead Prn_StopSerial_Dead
; bytes sit around it) (branch target; code read 2026-10-19)
Prn_SerialStep_Exit::
    ret                                           ; $190E


; I: unreferenced
Prn_StopSerial2_Dead::
    xor a                                         ; $190F
    ldh [rSC], a                                  ; $1910
    ldh [rSB], a                                  ; $1912

; C: clears serial and state; status = $FF
Prn_EngineStop::
    xor a                                         ; $1914
    ldh [rSB], a                                  ; $1915
    ldh [rSC], a                                  ; $1917
    ld [wPrnState], a                             ; $1919
    dec a                                         ; $191C
    ld [wPrnStatus], a                            ; $191D
    ld [wPrnDevId], a                             ; $1920
    call Prn_ClearTxFlags                         ; $1923
    ret                                           ; $1926


; C
Prn_ClearTxFlags::
    xor a                                         ; $1927
    ld [wPrnTxPhase], a                           ; $1928
    ld [wPrnIrqSeen], a                           ; $192B
    ld [wPrnTxBusy], a                            ; $192E

; C
Prn_ResetPacketState::
    xor a                                         ; $1931
    ld [wPrnSyncDone], a                          ; $1932
    ld [wPrnHdrDone], a                           ; $1935
    ld [wPrnDataDone], a                          ; $1938
    ld [wPrnChkIdx], a                            ; $193B
    ld [wPrnTrailCnt], a                          ; $193E
    ld [wPrnChecksum], a                          ; $1941
    ld [wPrnChecksum + $1], a                     ; $1944
    ld [wPrnTxIdx], a                             ; $1947
    ld [wPrnTxIdx + $1], a                        ; $194A
    ld [wPrnAbort], a                             ; $194D
    ld [wPrnBusySeen], a                          ; $1950
    ret                                           ; $1953


; C: queues the INITIALIZE command (A=0 ready)
Prn_SendInit::
    ld a, [wPrnTxBusy]                            ; $1954
    and a                                         ; $1957
    jr z, jr_000_195e                             ; $1958

    call Prn_CheckTxDone                          ; $195A
    ret nc                                        ; $195D

jr_000_195e:
    ld a, [wPrnLastType]                          ; $195E
    cp $01                                        ; $1961
    jr nz, jr_000_1969                            ; $1963

    call Prn_CheckTxDone                          ; $1965
    ret nc                                        ; $1968

jr_000_1969:
    call Prn_QueueInit                            ; $1969
    jp Prn_StartTransmit                          ; $196C


; C: completion routine: carry = packet must be re-sent
Prn_CheckTxDone::
    ld a, [wPrnTxPhase]                           ; $196F
    cp $02                                        ; $1972
    jr nz, jr_000_19ae                            ; $1974

    xor a                                         ; $1976
    ld [wPrnPollCnt], a                           ; $1977
    ld [wPrnLastType], a                          ; $197A
    inc a                                         ; $197D
    ld [wPrnState], a                             ; $197E
    ld a, [wPrnStatus]                            ; $1981
    cp $ff                                        ; $1984
    jr z, jr_000_19a7                             ; $1986

    bit 0, a                                      ; $1988
    jr nz, jr_000_19a0                            ; $198A

    bit 1, a                                      ; $198C
    jr nz, jr_000_19a0                            ; $198E

    bit 4, a                                      ; $1990
    jr z, jr_000_19ac                             ; $1992

    xor a                                         ; $1994
    ld [wPrnState], a                             ; $1995
    ld [wPrnLastType], a                          ; $1998
    ld a, [wPrnStatus]                            ; $199B
    jr jr_000_19ac                                ; $199E

jr_000_19a0:
    scf                                           ; $19A0
    ret                                           ; $19A1


; I: unreferenced
Prn_Unused19A2::
    xor a                                         ; $19A2
    ld [wPrnLastType], a                          ; $19A3
    dec a                                         ; $19A6

jr_000_19a7:
    inc a                                         ; $19A7
    ld [wPrnState], a                             ; $19A8
    dec a                                         ; $19AB

jr_000_19ac:
    and a                                         ; $19AC
    ret                                           ; $19AD


jr_000_19ae:
    xor a                                         ; $19AE
    ld a, $f0                                     ; $19AF
    ret                                           ; $19B1


; C: queues the PRINT command; returns $F0 while busy
Prn_SendPrint::
    ld a, [wPrnState]                             ; $19B2
    cp $01                                        ; $19B5
    jr z, jr_000_19c4                             ; $19B7

    cp $02                                        ; $19B9
    jr z, jr_000_19c4                             ; $19BB

    and a                                         ; $19BD
    ld a, $ff                                     ; $19BE
    ret z                                         ; $19C0

jr_000_19c1:
    ld a, $f0                                     ; $19C1
    ret                                           ; $19C3


jr_000_19c4:
    ld a, [wPrnBusySeen]                          ; $19C4
    and a                                         ; $19C7
    jr nz, jr_000_19c1                            ; $19C8

    ld a, [wPrnTxBusy]                            ; $19CA
    and a                                         ; $19CD
    jr z, jr_000_19d4                             ; $19CE

    call Prn_CheckTxDone                          ; $19D0
    ret nc                                        ; $19D3

jr_000_19d4:
    ld a, [wPrnLastType]                          ; $19D4
    cp $02                                        ; $19D7
    jr nz, jr_000_19df                            ; $19D9

    call Prn_CheckTxDone                          ; $19DB
    ret nc                                        ; $19DE

jr_000_19df:
    ld a, [wPrnStatus]                            ; $19DF
    cp $ff                                        ; $19E2
    ret z                                         ; $19E4

    call Prn_QueuePrint                           ; $19E5
    jp Prn_StartTransmit                          ; $19E8


; C: queues a DATA packet (HL = band
Prn_SendData::
    ld c, a                                       ; $19EB
    ld a, [wPrnState]                             ; $19EC
    and a                                         ; $19EF
    ld a, [wPrnStatus]                            ; $19F0
    ret z                                         ; $19F3

    ld a, [wPrnState]                             ; $19F4
    cp $01                                        ; $19F7
    jr z, jr_000_1a02                             ; $19F9

    cp $03                                        ; $19FB
    jr z, jr_000_1a02                             ; $19FD

    ld a, $f0                                     ; $19FF
    ret                                           ; $1A01


jr_000_1a02:
    ld a, [wPrnTxBusy]                            ; $1A02
    and a                                         ; $1A05
    jr nz, jr_000_1a51                            ; $1A06

    ld a, c                                       ; $1A08
    inc a                                         ; $1A09
    ld [wPrnChunkCnt], a                          ; $1A0A
    ld a, l                                       ; $1A0D
    ld [wPrnBandPtrCopy], a                       ; $1A0E
    ld a, h                                       ; $1A11
    ld [wPrnBandPtrCopy + $1], a                  ; $1A12
    ld a, [wPrnStatus]                            ; $1A15
    cp $ff                                        ; $1A18
    ret z                                         ; $1A1A

    ld a, [wPrnCompEnable]                        ; $1A1B
    ld [wPrnBandCompFlag], a                      ; $1A1E
    and a                                         ; $1A21
    jr z, jr_000_1a48                             ; $1A22

    ld a, [wPrnChunkCnt]                          ; $1A24
    dec a                                         ; $1A27
    dec a                                         ; $1A28
    push af                                       ; $1A29
    ld c, a                                       ; $1A2A
    ld b, $00                                     ; $1A2B
    push hl                                       ; $1A2D
    ld hl, wPrinterDc0cTable                      ; $1A2E
    add hl, bc                                    ; $1A31
    ld a, [hl]                                    ; $1A32
    pop hl                                        ; $1A33
    ld [wPrnBandCompFlag], a                      ; $1A34
    pop af                                        ; $1A37
    add a                                         ; $1A38
    ld c, a                                       ; $1A39
    ld b, $00                                     ; $1A3A
    push hl                                       ; $1A3C
    ld hl, wPrinterLenTable                       ; $1A3D
    add hl, bc                                    ; $1A40
    ld a, [hl+]                                   ; $1A41
    ld b, [hl]                                    ; $1A42
    pop hl                                        ; $1A43
    ld c, a                                       ; $1A44
    jp Prn_SendData_QueueAndStart                 ; $1A45


jr_000_1a48:
    ld bc, $0280                                  ; $1A48

; C: BC = length, HL = source: Prn_QueueData then Prn_StartTransmit (shared tail of the DATA packet cases) (branch
; target; code read 2026-10-19)
Prn_SendData_QueueAndStart::
    call Prn_QueueData                            ; $1A4B
    jp Prn_StartTransmit                          ; $1A4E


jr_000_1a51:
    ld a, [wPrnTxPhase]                           ; $1A51
    cp $02                                        ; $1A54
    ld a, $f0                                     ; $1A56
    jp nz, Prn_SendData_RetBusy                   ; $1A58

    ld hl, wPrnChunkCnt                           ; $1A5B
    ld a, [wPrnStatus]                            ; $1A5E
    bit 4, a                                      ; $1A61
    jp nz, Prn_SendData_Abort                     ; $1A63

    bit 1, a                                      ; $1A66
    jp nz, Prn_SendData_NextChunk                 ; $1A68

    bit 0, a                                      ; $1A6B
    jp nz, Prn_SendData_NextChunk                 ; $1A6D

    dec [hl]                                      ; $1A70
    ld a, [wPrnStatus]                            ; $1A71
    jr z, jr_000_1ad2                             ; $1A74

; C: next band chunk: last chunk when the counter DC3E = 1, else length $0280 or the table value at DBEC (branch
; target; code read 2026-10-19)
Prn_SendData_NextChunk::
    ld a, [hl]                                    ; $1A76
    cp $01                                        ; $1A77
    jr z, jr_000_1adc                             ; $1A79

    ld bc, $0280                                  ; $1A7B
    ld a, [wPrnCompEnable]                        ; $1A7E
    ld [wPrnBandCompFlag], a                      ; $1A81
    and a                                         ; $1A84
    jr z, jr_000_1aa8                             ; $1A85

    ld a, [wPrnChunkCnt]                          ; $1A87
    dec a                                         ; $1A8A
    dec a                                         ; $1A8B
    push af                                       ; $1A8C
    ld c, a                                       ; $1A8D
    ld b, $00                                     ; $1A8E
    push hl                                       ; $1A90
    ld hl, wPrinterDc0cTable                      ; $1A91
    add hl, bc                                    ; $1A94
    ld a, [hl]                                    ; $1A95
    pop hl                                        ; $1A96
    ld [wPrnBandCompFlag], a                      ; $1A97
    pop af                                        ; $1A9A
    add a                                         ; $1A9B
    ld c, a                                       ; $1A9C
    ld b, $00                                     ; $1A9D
    push hl                                       ; $1A9F
    ld hl, wPrinterLenTable                       ; $1AA0
    add hl, bc                                    ; $1AA3
    ld a, [hl+]                                   ; $1AA4
    ld b, [hl]                                    ; $1AA5
    pop hl                                        ; $1AA6
    ld c, a                                       ; $1AA7

jr_000_1aa8:
    ld a, [wPrnStatus]                            ; $1AA8
    bit 1, a                                      ; $1AAB
    jp nz, Prn_SendData_QueueFromPtr              ; $1AAD

    ld a, [wPrnDataPtr]                           ; $1AB0
    add $80                                       ; $1AB3
    ld [wPrnDataPtr], a                           ; $1AB5
    ld a, [wPrnDataPtr + $1]                      ; $1AB8
    adc $02                                       ; $1ABB
    ld [wPrnDataPtr + $1], a                      ; $1ABD

; C: reload HL from the data pointer DC1F:DC20 and queue (retry sends the same chunk, otherwise the pointer was
; advanced by $0280) (branch target; code read 2026-10-19)
Prn_SendData_QueueFromPtr::
    ld a, [wPrnDataPtr]                           ; $1AC0
    ld l, a                                       ; $1AC3
    ld a, [wPrnDataPtr + $1]                      ; $1AC4
    ld h, a                                       ; $1AC7
    jp Prn_SendData_QueueAndStart                 ; $1AC8


; C: status bit 4 (packet error): sets the abort flag DC3C, clears has-data DC2C and busy DC3B (branch target; code
; read 2026-10-19)
Prn_SendData_Abort::
    push af                                       ; $1ACB
    ld a, $01                                     ; $1ACC
    ld [wPrnAbort], a                             ; $1ACE
    pop af                                        ; $1AD1

jr_000_1ad2:
    push af                                       ; $1AD2
    xor a                                         ; $1AD3
    ld [wPrnHasData], a                           ; $1AD4
    ld [wPrnTxBusy], a                            ; $1AD7
    pop af                                        ; $1ADA

; C: RET with A = $F0 (printer engine busy) (branch target; code read 2026-10-19)
Prn_SendData_RetBusy::
    ret                                           ; $1ADB


jr_000_1adc:
    ld a, [wPrnLastChunk]                         ; $1ADC
    and a                                         ; $1ADF
    ld a, [wPrnStatus]                            ; $1AE0
    jr z, jr_000_1ad2                             ; $1AE3

    call Prn_QueueDataEnd                         ; $1AE5
    jp Prn_StartTransmit                          ; $1AE8


; I: unreferenced
Prn_SendBreak_Dead::
    ld a, [wPrnState]                             ; $1AEB
    cp $01                                        ; $1AEE
    jr z, jr_000_1afd                             ; $1AF0

    cp $03                                        ; $1AF2
    jr z, jr_000_1afd                             ; $1AF4

    and a                                         ; $1AF6
    ld a, $ff                                     ; $1AF7
    ret z                                         ; $1AF9

    ld a, $f0                                     ; $1AFA
    ret                                           ; $1AFC


jr_000_1afd:
    ld a, [wPrnTxBusy]                            ; $1AFD
    and a                                         ; $1B00
    jr z, jr_000_1b07                             ; $1B01

    call Prn_CheckTxDone                          ; $1B03
    ret nc                                        ; $1B06

jr_000_1b07:
    ld a, [wPrnLastType]                          ; $1B07
    cp $04                                        ; $1B0A
    jr nz, jr_000_1b12                            ; $1B0C

    call Prn_CheckTxDone                          ; $1B0E
    ret nc                                        ; $1B11

jr_000_1b12:
    ld a, [wPrnStatus]                            ; $1B12
    cp $ff                                        ; $1B15
    ret z                                         ; $1B17

    call Unused_Prn_QueueBreak                    ; $1B18
    jp Prn_StartTransmit                          ; $1B1B


; C: queues the INQUIRY command (status poll)
Prn_SendInquiry::
    ld a, [wPrnState]                             ; $1B1E
    cp $01                                        ; $1B21
    jr z, jr_000_1b30                             ; $1B23

    cp $03                                        ; $1B25
    jr z, jr_000_1b30                             ; $1B27

    and a                                         ; $1B29
    ld a, $ff                                     ; $1B2A
    ret z                                         ; $1B2C

    ld a, $f0                                     ; $1B2D
    ret                                           ; $1B2F


jr_000_1b30:
    ld a, [wPrnTxBusy]                            ; $1B30
    and a                                         ; $1B33
    jr z, jr_000_1b3a                             ; $1B34

    call Prn_CheckTxDone                          ; $1B36
    ret nc                                        ; $1B39

jr_000_1b3a:
    ld a, [wPrnStatus]                            ; $1B3A
    cp $ff                                        ; $1B3D
    ret z                                         ; $1B3F

    call Prn_QueueInquiry                         ; $1B40
    jp Prn_StartTransmit                          ; $1B43


; C: A = type
Prn_QueuePacket::
    ld [wPrnPktType], a                           ; $1B46
    ld a, d                                       ; $1B49
    ld [wPrnHasData], a                           ; $1B4A
    ld a, l                                       ; $1B4D
    ld [wPrnSrcPtr], a                            ; $1B4E
    ld [wPrnHdrPtr], a                            ; $1B51
    ld a, h                                       ; $1B54
    ld [wPrnSrcPtr + $1], a                       ; $1B55
    ld [wPrnHdrPtr + $1], a                       ; $1B58
    ld a, c                                       ; $1B5B
    ld [wPrnTargetLen], a                         ; $1B5C
    ld [wPrnHdrLen], a                            ; $1B5F
    ld a, b                                       ; $1B62
    ld [wPrnTargetLen + $1], a                    ; $1B63
    ld [wPrnHdrLen + $1], a                       ; $1B66
    xor a                                         ; $1B69
    ld [wPrnTxPhase], a                           ; $1B6A
    call Prn_ResetPacketState                     ; $1B6D
    ret                                           ; $1B70


; C: $88 $33
Prn_SyncBytes::
    dw Mode1D_State06_LoadWaitScreen

; C: INITIALIZE packet
Prn_PktInit::
    db $01, $00, $00, $00, $01, $00, $00, $00

; C: PRINT header bytes
Prn_PktPrintHdr::
    db $02, $00, $04, $00

; C: empty DATA packet (end of data)
Prn_PktDataEnd::
    db $04, $00, $00, $00, $04, $00, $00, $00

; C
Prn_PktBreak::
    db $08, $00, $00, $00, $08, $00, $00, $00

; C
Prn_PktInquiry::
    db $0f, $00, $00, $00, $0f, $00, $00, $00

; C
Prn_QueueInit::
    ld a, $01                                     ; $1B97
    ld d, $00                                     ; $1B99
    ld hl, Prn_PktInit                            ; $1B9B
    ld bc, $0008                                  ; $1B9E
    jp Prn_QueuePacket                            ; $1BA1


; C: builds the PRINT body from sheets / margin / palette / intensity
Prn_QueuePrint::
    ld a, $02                                     ; $1BA4
    ld d, $00                                     ; $1BA6
    ld hl, wPrnPktBuf                             ; $1BA8
    ld bc, $000c                                  ; $1BAB
    call Prn_QueuePacket                          ; $1BAE
    ld hl, Prn_PktPrintHdr                        ; $1BB1
    ld de, wPrnPktBuf                             ; $1BB4
    ld bc, $0004                                  ; $1BB7
    call Mem_Copy                                 ; $1BBA
    ld de, $0006                                  ; $1BBD
    ld a, [wPrnSheets]                            ; $1BC0
    ld [wPrnPktBuf + $4], a                       ; $1BC3
    call Prn_AddToChecksumDE                      ; $1BC6
    ld a, [wPrnMargin]                            ; $1BC9
    ld [wPrnPktBuf + $5], a                       ; $1BCC
    call Prn_AddToChecksumDE                      ; $1BCF
    ld a, [wPrnPalette]                           ; $1BD2
    ld [wPrnPktBuf + $6], a                       ; $1BD5
    call Prn_AddToChecksumDE                      ; $1BD8
    ld a, [wPrintIntensity]                       ; $1BDB
    ld [wPrnPktBuf + $7], a                       ; $1BDE
    call Prn_AddToChecksumDE                      ; $1BE1
    ld a, e                                       ; $1BE4
    ld [wPrnPktBuf + $8], a                       ; $1BE5
    ld a, d                                       ; $1BE8
    ld [wPrnPktBuf + $9], a                       ; $1BE9
    xor a                                         ; $1BEC
    ld [wPrnPktBuf + $a], a                       ; $1BED
    ld [wPrnPktBuf + $b], a                       ; $1BF0
    ret                                           ; $1BF3


; C: DE += A
Prn_AddToChecksumDE::
    add e                                         ; $1BF4
    ld e, a                                       ; $1BF5
    ld a, d                                       ; $1BF6
    adc $00                                       ; $1BF7
    ld d, a                                       ; $1BF9
    ret                                           ; $1BFA


; C
Prn_QueueData::
    ld a, l                                       ; $1BFB
    ld [wPrnDataPtr], a                           ; $1BFC
    ld a, h                                       ; $1BFF
    ld [wPrnDataPtr + $1], a                      ; $1C00
    ld a, c                                       ; $1C03
    ld [wPrnDataLen], a                           ; $1C04
    ld a, b                                       ; $1C07
    ld [wPrnDataLen + $1], a                      ; $1C08
    push bc                                       ; $1C0B
    ld a, $03                                     ; $1C0C
    ld d, $01                                     ; $1C0E
    ld hl, wPrnPktBuf                             ; $1C10
    ld bc, $0004                                  ; $1C13
    call Prn_QueuePacket                          ; $1C16
    ld a, [Prn_PktDataEnd]                        ; $1C19
    ld [wPrnPktBuf], a                            ; $1C1C
    ld a, [wPrnBandCompFlag]                      ; $1C1F
    ld [wPrnPktBuf + $1], a                       ; $1C22
    pop bc                                        ; $1C25
    ld a, c                                       ; $1C26
    ld [wPrnPktBuf + $2], a                       ; $1C27
    ld a, b                                       ; $1C2A
    ld [wPrnPktBuf + $3], a                       ; $1C2B
    ret                                           ; $1C2E


; C: Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Prn_QueueBreak::
    ld a, $04                                     ; $1C2F
    ld d, $00                                     ; $1C31
    ld hl, Prn_PktBreak                           ; $1C33
    ld bc, $0008                                  ; $1C36
    jp Prn_QueuePacket                            ; $1C39


; C
Prn_QueueInquiry::
    ld a, $05                                     ; $1C3C
    ld d, $00                                     ; $1C3E
    ld hl, Prn_PktInquiry                         ; $1C40
    ld bc, $0008                                  ; $1C43
    jp Prn_QueuePacket                            ; $1C46


; C
Prn_QueueDataEnd::
    ld a, $06                                     ; $1C49
    ld d, $01                                     ; $1C4B
    ld hl, Prn_PktDataEnd                         ; $1C4D
    ld bc, $0008                                  ; $1C50
    jp Prn_QueuePacket                            ; $1C53


; C: Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Prn_Ret::
    ret                                           ; $1C56


; C: starts the queued packet and sends the first sync byte
Prn_StartTransmit::
    ld a, [wPrnState]                             ; $1C57
    cp $01                                        ; $1C5A
    jr z, jr_000_1c6a                             ; $1C5C

    and a                                         ; $1C5E
    jr nz, jr_000_1c68                            ; $1C5F

    ld a, [wPrnPktType]                           ; $1C61
    cp $01                                        ; $1C64
    jr z, jr_000_1c74                             ; $1C66

jr_000_1c68:
    scf                                           ; $1C68
    ret                                           ; $1C69


jr_000_1c6a:
    ld a, [wPrnPktType]                           ; $1C6A
    cp $01                                        ; $1C6D
    jr z, jr_000_1c68                             ; $1C6F

    ld [wPrnState], a                             ; $1C71

jr_000_1c74:
    xor a                                         ; $1C74
    ld [wPrnTxPhase], a                           ; $1C75
    ld [wPrnLastType], a                          ; $1C78
    ld a, $01                                     ; $1C7B
    ld [wPrnTxIdx], a                             ; $1C7D
    ld [wPrnTxBusy], a                            ; $1C80
    ld a, [Prn_SyncBytes]                         ; $1C83
    ldh [rSB], a                                  ; $1C86
    ld a, SCF_SOURCE                              ; $1C88
    ldh [rSC], a                                  ; $1C8A
    ld a, SCF_START | SCF_SOURCE                  ; $1C8C
    ldh [rSC], a                                  ; $1C8E
    ld a, $f0                                     ; $1C90
    ret                                           ; $1C92


; C: A = bank; HL = packets (16 bytes each
Sgb_SendPacket::
    ldh [hBankTmp], a                             ; $1C93
    ldh a, [hRomBankShadow]                       ; $1C95
    push af                                       ; $1C97
    ldh a, [hBankTmp]                             ; $1C98
    ldh [hRomBankShadow], a                       ; $1C9A
    ld [$2000], a                                 ; $1C9C
    ld a, [hl]                                    ; $1C9F
    and $07                                       ; $1CA0
    jr z, jr_000_1cd7                             ; $1CA2

    ld b, a                                       ; $1CA4
    ld c, $00                                     ; $1CA5

jr_000_1ca7:
    push bc                                       ; $1CA7
    ld a, $00                                     ; $1CA8
    ldh [c], a                                    ; $1CAA
    ld a, $30                                     ; $1CAB
    ldh [c], a                                    ; $1CAD
    ld b, $10                                     ; $1CAE

jr_000_1cb0:
    ld e, $08                                     ; $1CB0
    ld a, [hl+]                                   ; $1CB2
    ld d, a                                       ; $1CB3

jr_000_1cb4:
    bit 0, d                                      ; $1CB4
    ld a, $10                                     ; $1CB6
    jr nz, jr_000_1cbc                            ; $1CB8

    ld a, $20                                     ; $1CBA

jr_000_1cbc:
    ldh [c], a                                    ; $1CBC
    ld a, $30                                     ; $1CBD
    ldh [c], a                                    ; $1CBF
    rr d                                          ; $1CC0
    dec e                                         ; $1CC2
    jr nz, jr_000_1cb4                            ; $1CC3

    dec b                                         ; $1CC5
    jr nz, jr_000_1cb0                            ; $1CC6

    ld a, $20                                     ; $1CC8
    ldh [c], a                                    ; $1CCA
    ld a, $30                                     ; $1CCB
    ldh [c], a                                    ; $1CCD
    pop bc                                        ; $1CCE
    dec b                                         ; $1CCF
    jr z, jr_000_1cd7                             ; $1CD0

    call Sgb_Delay                                ; $1CD2
    jr jr_000_1ca7                                ; $1CD5

jr_000_1cd7:
    pop af                                        ; $1CD7
    ldh [hRomBankShadow], a                       ; $1CD8
    ld [$2000], a                                 ; $1CDA
    ret                                           ; $1CDD


; C
Sgb_Delay::
    ld de, $1b58                                  ; $1CDE

jr_000_1ce1:
    nop                                           ; $1CE1
    nop                                           ; $1CE2
    nop                                           ; $1CE3
    dec de                                        ; $1CE4
    ld a, d                                       ; $1CE5
    or e                                          ; $1CE6
    jr nz, jr_000_1ce1                            ; $1CE7

    ret                                           ; $1CE9


; C: MLT_REQ probe; carry set when a Super Game Boy answers
Sgb_Probe::
    ld a, $0b                                     ; $1CEA
    ld hl, $4010                                  ; $1CEC
    call Sgb_SendPacket                           ; $1CEF
    call Sgb_Delay                                ; $1CF2
    ldh a, [rP1]                                  ; $1CF5
    and $03                                       ; $1CF7
    cp $03                                        ; $1CF9
    jr nz, Sgb_Probe_Found                        ; $1CFB

    ld a, P1F_GET_DPAD                            ; $1CFD
    ldh [rP1], a                                  ; $1CFF
    ldh a, [rP1]                                  ; $1D01
    ldh a, [rP1]                                  ; $1D03
    ld a, P1F_GET_NONE                            ; $1D05
    ldh [rP1], a                                  ; $1D07
    ld a, P1F_GET_BTN                             ; $1D09
    ldh [rP1], a                                  ; $1D0B
    ldh a, [rP1]                                  ; $1D0D
    ldh a, [rP1]                                  ; $1D0F
    ldh a, [rP1]                                  ; $1D11
    ldh a, [rP1]                                  ; $1D13
    ldh a, [rP1]                                  ; $1D15
    ldh a, [rP1]                                  ; $1D17
    ld a, P1F_GET_NONE                            ; $1D19
    ldh [rP1], a                                  ; $1D1B
    ldh a, [rP1]                                  ; $1D1D
    ldh a, [rP1]                                  ; $1D1F
    ldh a, [rP1]                                  ; $1D21
    ldh a, [rP1]                                  ; $1D23
    and $03                                       ; $1D25
    cp $03                                        ; $1D27
    jr nz, Sgb_Probe_Found                        ; $1D29

    ld a, BANK(Sgb_MltReqPackets)                 ; $1D2B
    ld hl, Sgb_MltReqPackets                      ; $1D2D
    call Sgb_SendPacket                           ; $1D30
    call Sgb_Delay                                ; $1D33
    and a                                         ; $1D36
    ret                                           ; $1D37


; C
Sgb_Probe_Found::
    ld a, BANK(Sgb_MltReqPackets)                 ; $1D38
    ld hl, Sgb_MltReqPackets                      ; $1D3A
    call Sgb_SendPacket                           ; $1D3D
    call Sgb_Delay                                ; $1D40
    scf                                           ; $1D43
    ret                                           ; $1D44


; C: copies the $1000 bytes following the packet to VRAM $8800 and sends the packet
Sgb_SendVramTransfer::
    ldh [hBankTmp], a                             ; $1D45
    ldh a, [hRomBankShadow]                       ; $1D47
    push af                                       ; $1D49
    ldh a, [hBankTmp]                             ; $1D4A
    ldh [hRomBankShadow], a                       ; $1D4C
    ld [$2000], a                                 ; $1D4E
    push af                                       ; $1D51
    push hl                                       ; $1D52
    ld a, $e4                                     ; $1D53
    ldh [rBGP], a                                 ; $1D55
    ld bc, $0010                                  ; $1D57
    add hl, bc                                    ; $1D5A
    ld de, $8800                                  ; $1D5B
    ld bc, $1000                                  ; $1D5E
    call Mem_Copy                                 ; $1D61
    ld hl, $9800                                  ; $1D64
    ld de, $000c                                  ; $1D67
    ld a, $80                                     ; $1D6A
    ld c, $0d                                     ; $1D6C

jr_000_1d6e:
    ld b, $14                                     ; $1D6E

jr_000_1d70:
    ld [hl+], a                                   ; $1D70
    inc a                                         ; $1D71
    dec b                                         ; $1D72
    jr nz, jr_000_1d70                            ; $1D73

    add hl, de                                    ; $1D75
    dec c                                         ; $1D76
    jr nz, jr_000_1d6e                            ; $1D77

    ld a, LCDCF_ON | LCDCF_BGON                   ; $1D79
    ldh [rLCDC], a                                ; $1D7B
    ld bc, $0005                                  ; $1D7D
    call Delay_Frames_Busy                        ; $1D80
    pop hl                                        ; $1D83
    pop af                                        ; $1D84
    call Sgb_SendPacket                           ; $1D85
    ld bc, $0006                                  ; $1D88
    call Delay_Frames_Busy                        ; $1D8B
    ldh a, [hBgpShadow]                           ; $1D8E
    ldh [rBGP], a                                 ; $1D90
    ldh a, [hLcdcShadow]                          ; $1D92
    ldh [rLCDC], a                                ; $1D94
    pop af                                        ; $1D96
    ldh [hRomBankShadow], a                       ; $1D97
    ld [$2000], a                                 ; $1D99
    ret                                           ; $1D9C


; C: boot: after 120 frames sends the 0B:69E6.. packets then the border VRAM transfers; only when an SGB is present
Sgb_SendInitSequence::
    ldh a, [hSgbPresent]                          ; $1D9D
    and a                                         ; $1D9F
    ret z                                         ; $1DA0

    ld bc, $0078                                  ; $1DA1
    call Delay_Frames_Busy                        ; $1DA4
    call Sgb_MaskFreeze                           ; $1DA7
    ld a, BANK(Sgb_DataSndPackets)                ; $1DAA
    ld hl, Sgb_DataSndPackets                     ; $1DAC
    call Sgb_SendPacket                           ; $1DAF
    ld bc, $0004                                  ; $1DB2
    call Delay_Frames_Busy                        ; $1DB5
    ld a, $0b                                     ; $1DB8
    ld hl, $69f6                                  ; $1DBA
    call Sgb_SendPacket                           ; $1DBD
    ld bc, $0004                                  ; $1DC0
    call Delay_Frames_Busy                        ; $1DC3
    ld a, $0b                                     ; $1DC6
    ld hl, $6a06                                  ; $1DC8
    call Sgb_SendPacket                           ; $1DCB
    ld bc, $0004                                  ; $1DCE
    call Delay_Frames_Busy                        ; $1DD1
    ld a, $0b                                     ; $1DD4
    ld hl, $6a16                                  ; $1DD6
    call Sgb_SendPacket                           ; $1DD9
    ld bc, $0004                                  ; $1DDC
    call Delay_Frames_Busy                        ; $1DDF
    ld a, $0b                                     ; $1DE2
    ld hl, $6a26                                  ; $1DE4
    call Sgb_SendPacket                           ; $1DE7
    ld bc, $0004                                  ; $1DEA
    call Delay_Frames_Busy                        ; $1DED
    ld a, $0b                                     ; $1DF0
    ld hl, $6a36                                  ; $1DF2
    call Sgb_SendPacket                           ; $1DF5
    ld bc, $0004                                  ; $1DF8
    call Delay_Frames_Busy                        ; $1DFB
    ld a, $0b                                     ; $1DFE
    ld hl, $6a46                                  ; $1E00
    call Sgb_SendPacket                           ; $1E03
    ld bc, $0004                                  ; $1E06
    call Delay_Frames_Busy                        ; $1E09
    ld a, $0b                                     ; $1E0C
    ld hl, $6a56                                  ; $1E0E
    call Sgb_SendPacket                           ; $1E11
    ld bc, $0004                                  ; $1E14
    call Delay_Frames_Busy                        ; $1E17
    ld a, BANK(Sgb_PalTrnPacket)                  ; $1E1A
    ld hl, Sgb_PalTrnPacket                       ; $1E1C
    call Sgb_SendVramTransfer                     ; $1E1F
    ld bc, $0004                                  ; $1E22
    call Delay_Frames_Busy                        ; $1E25
    ld a, BANK(Sgb_AttrTrnPacket)                 ; $1E28
    ld hl, Sgb_AttrTrnPacket                      ; $1E2A
    call Sgb_SendVramTransfer                     ; $1E2D
    ld bc, $0004                                  ; $1E30
    call Delay_Frames_Busy                        ; $1E33
    ld a, BANK(Sgb_PalSetPacket)                  ; $1E36
    ld hl, Sgb_PalSetPacket                       ; $1E38
    call Sgb_SendPacket                           ; $1E3B
    ld bc, $0004                                  ; $1E3E
    call Delay_Frames_Busy                        ; $1E41
    ld a, BANK(Sgb_ChrTrnPacket0)                 ; $1E44
    ld hl, Sgb_ChrTrnPacket0                      ; $1E46
    call Sgb_SendVramTransfer                     ; $1E49
    ld bc, $0004                                  ; $1E4C
    call Delay_Frames_Busy                        ; $1E4F
    ld a, BANK(Sgb_ChrTrnPacket1)                 ; $1E52
    ld hl, Sgb_ChrTrnPacket1                      ; $1E54
    call Sgb_SendVramTransfer                     ; $1E57
    ld bc, $0004                                  ; $1E5A
    call Delay_Frames_Busy                        ; $1E5D
    ld a, BANK(Sgb_PctTrnPacket)                  ; $1E60
    ld hl, Sgb_PctTrnPacket                       ; $1E62
    call Sgb_SendVramTransfer                     ; $1E65
    ret                                           ; $1E68


; C: MASK_EN freeze ($B9 $01) once; sets sgb_mask_active
Sgb_MaskFreeze::
    ldh a, [hSgbPresent]                          ; $1E69
    and a                                         ; $1E6B
    ret z                                         ; $1E6C

    ldh a, [hSgbMaskActive]                       ; $1E6D
    and a                                         ; $1E6F
    ret nz                                        ; $1E70

    ld a, BANK(Sgb_MaskEnPackets)                 ; $1E71
    ld hl, Sgb_MaskEnPackets                      ; $1E73
    call Sgb_SendPacket                           ; $1E76
    ld bc, $0004                                  ; $1E79
    call Delay_Frames_Busy                        ; $1E7C
    ld a, $ff                                     ; $1E7F
    ldh [hSgbMaskActive], a                       ; $1E81
    ret                                           ; $1E83


; C: MASK_EN cancel ($B9 $00) if the freeze is on
Sgb_MaskCancel::
    ldh a, [hSgbPresent]                          ; $1E84
    and a                                         ; $1E86
    ret z                                         ; $1E87

    ld bc, $0002                                  ; $1E88
    call Delay_Frames_Busy                        ; $1E8B
    ldh a, [hSgbMaskActive]                       ; $1E8E
    and a                                         ; $1E90
    ret z                                         ; $1E91

    ld a, $0b                                     ; $1E92
    ld hl, $6a76                                  ; $1E94
    call Sgb_SendPacket                           ; $1E97
    ld bc, $0004                                  ; $1E9A
    call Delay_Frames_Busy                        ; $1E9D
    xor a                                         ; $1EA0
    ldh [hSgbMaskActive], a                       ; $1EA1
    ret                                           ; $1EA3


; C: software sprite-to-BG blit; HL = 8-byte descriptor (width / height / source A / source B)
Blit_SpriteToBg::
    push bc                                       ; $1EA4
    ld de, hBlitWidth                             ; $1EA5
    ld b, $08                                     ; $1EA8

jr_000_1eaa:
    ld a, [hl+]                                   ; $1EAA
    ld [de], a                                    ; $1EAB
    inc de                                        ; $1EAC
    dec b                                         ; $1EAD
    jr nz, jr_000_1eaa                            ; $1EAE

    ld hl, hBlitWidth                             ; $1EB0
    ld a, [hl]                                    ; $1EB3
    and $80                                       ; $1EB4
    ldh [hBlitFlagMaskFromA], a                   ; $1EB6
    res 7, [hl]                                   ; $1EB8
    ld a, [hl]                                    ; $1EBA
    and $40                                       ; $1EBB
    ldh [hBlitFlagStride], a                      ; $1EBD
    res 6, [hl]                                   ; $1EBF
    pop bc                                        ; $1EC1
    call Blit_BuildPatchList                      ; $1EC2
    push bc                                       ; $1EC5
    call Blit_PrepareMasks                        ; $1EC6
    ldh a, [hBlitFlagMaskFromA]                   ; $1EC9
    and a                                         ; $1ECB
    jr nz, jr_000_1ed3                            ; $1ECC

    call Blit_MaskPass_SrcB                       ; $1ECE
    jr jr_000_1ed6                                ; $1ED1

jr_000_1ed3:
    call Blit_MaskPass_SrcA                       ; $1ED3

jr_000_1ed6:
    call Blit_ImagePass                           ; $1ED6
    pop bc                                        ; $1ED9
    call Blit_ApplyPatchList                      ; $1EDA
    ret                                           ; $1EDD


; I: 16 bytes identical to 1FA2; no reader found
Blit_MaskTbl_Copy_Dead::
    db $ff, $7f, $3f, $1f, $0f, $07, $03, $01, $ff, $80, $c0, $e0, $f0, $f8, $fc, $fe

; C: computes the tile address for one cell through the row table 00:2170 and stores a patch record. L3 pass
; 2026-10-26: executed in BGB in 7 replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_MakePatchEntry::
    push de                                       ; $1EEE
    ld a, c                                       ; $1EEF
    and $f8                                       ; $1EF0
    srl a                                         ; $1EF2
    srl a                                         ; $1EF4
    ld e, a                                       ; $1EF6
    ld d, $00                                     ; $1EF7
    ld hl, Blit_TileRowPtrTbl                     ; $1EF9
    add hl, de                                    ; $1EFC
    ld a, [hl+]                                   ; $1EFD
    ld h, [hl]                                    ; $1EFE
    ld l, a                                       ; $1EFF
    ld a, b                                       ; $1F00
    and $f8                                       ; $1F01
    srl a                                         ; $1F03
    srl a                                         ; $1F05
    ld e, a                                       ; $1F07
    add hl, de                                    ; $1F08
    pop de                                        ; $1F09
    ld a, c                                       ; $1F0A
    and $07                                       ; $1F0B
    sla a                                         ; $1F0D
    add [hl]                                      ; $1F0F
    ld [de], a                                    ; $1F10
    inc hl                                        ; $1F11
    inc de                                        ; $1F12
    ld a, [hl]                                    ; $1F13
    ld [de], a                                    ; $1F14
    inc de                                        ; $1F15
    inc de                                        ; $1F16
    inc de                                        ; $1F17
    inc de                                        ; $1F18
    ret                                           ; $1F19


; C: builds the 5-byte patch list at $C800 for the destination rectangle. L3 pass 2026-10-26: executed in BGB in 7
; replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_BuildPatchList::
    push bc                                       ; $1F1A
    ld hl, hBlitWidth                             ; $1F1B
    ld a, b                                       ; $1F1E
    and $07                                       ; $1F1F
    add [hl]                                      ; $1F21
    dec a                                         ; $1F22
    srl a                                         ; $1F23
    srl a                                         ; $1F25
    srl a                                         ; $1F27
    inc a                                         ; $1F29
    ldh [hBlitDstTiles], a                        ; $1F2A
    ldh a, [hBlitHeight]                          ; $1F2C
    ldh [hBlitRows], a                            ; $1F2E
    ld de, wBlitPatchList                         ; $1F30
    ldh a, [hBlitRows]                            ; $1F33

jr_000_1f35:
    push af                                       ; $1F35
    push bc                                       ; $1F36
    ldh a, [hBlitDstTiles]                        ; $1F37

jr_000_1f39:
    push af                                       ; $1F39
    call Blit_MakePatchEntry                      ; $1F3A
    ld a, b                                       ; $1F3D
    add $08                                       ; $1F3E
    ld b, a                                       ; $1F40
    pop af                                        ; $1F41
    dec a                                         ; $1F42
    jr nz, jr_000_1f39                            ; $1F43

    pop bc                                        ; $1F45
    pop af                                        ; $1F46
    inc c                                         ; $1F47
    dec a                                         ; $1F48
    jr nz, jr_000_1f35                            ; $1F49

    pop bc                                        ; $1F4B
    xor a                                         ; $1F4C
    ld [de], a                                    ; $1F4D
    inc de                                        ; $1F4E
    ld [de], a                                    ; $1F4F
    ret                                           ; $1F50


; C: derives the shift page and the left / right edge masks from the x offset and width. L3 pass 2026-10-26: executed
; in BGB in 7 replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_PrepareMasks::
    ld a, b                                       ; $1F51
    and $07                                       ; $1F52
    add $38                                       ; $1F54
    ldh [hBlitShiftPage], a                       ; $1F56
    ld a, b                                       ; $1F58
    and $07                                       ; $1F59
    ld e, a                                       ; $1F5B
    ld d, $00                                     ; $1F5C
    ld hl, Blit_LeftMaskTbl                       ; $1F5E
    add hl, de                                    ; $1F61
    ld a, [hl]                                    ; $1F62
    ldh [hBlitLeftMask], a                        ; $1F63
    cpl                                           ; $1F65
    ldh [hBlitLeftMask + $1], a                   ; $1F66
    ld hl, hBlitWidth                             ; $1F68
    ld a, b                                       ; $1F6B
    add [hl]                                      ; $1F6C
    and $07                                       ; $1F6D
    ld e, a                                       ; $1F6F
    ld d, $00                                     ; $1F70
    ld hl, Blit_RightMaskTbl                      ; $1F72
    add hl, de                                    ; $1F75
    ld a, [hl]                                    ; $1F76
    ldh [hBlitRightMask], a                       ; $1F77
    cpl                                           ; $1F79
    ldh [hBlitRightMask + $1], a                  ; $1F7A
    ldh a, [hBlitWidth]                           ; $1F7C
    dec a                                         ; $1F7E
    srl a                                         ; $1F7F
    srl a                                         ; $1F81
    srl a                                         ; $1F83
    inc a                                         ; $1F85
    ldh [hBlitSrcTiles], a                        ; $1F86
    ldh a, [hBlitFlagStride]                      ; $1F88
    and a                                         ; $1F8A
    jr nz, jr_000_1f9d                            ; $1F8B

    ldh a, [hBlitWidth]                           ; $1F8D
    srl a                                         ; $1F8F
    srl a                                         ; $1F91
    srl a                                         ; $1F93
    dec a                                         ; $1F95
    swap a                                        ; $1F96
    and $f0                                       ; $1F98
    ldh [hBlitStride], a                          ; $1F9A
    ret                                           ; $1F9C


jr_000_1f9d:
    ld a, $f0                                     ; $1F9D
    ldh [hBlitStride], a                          ; $1F9F
    ret                                           ; $1FA1


; C: 8 byte mask table indexed by x mod 8. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes
; 10 11 (tcrf_check/assets/l3_names/)
Blit_LeftMaskTbl::
    db $ff, $7f, $3f, $1f, $0f, $07, $03, $01

; C: 9 byte mask table indexed by (x+w) mod 8. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus,
; modes 10 11 (tcrf_check/assets/l3_names/)
Blit_RightMaskTbl::
    db $ff, $80, $c0, $e0, $f0, $f8, $fc, $fe

; C: mask pass using source B as the explicit 1-bit mask
Blit_MaskPass_SrcB::
    ldh a, [hBlitSrcB]                            ; $1FB2
    ld l, a                                       ; $1FB4
    ldh a, [hBlitSrcB + $1]                       ; $1FB5
    ld h, a                                       ; $1FB7
    ldh a, [hRomBankShadow]                       ; $1FB8
    push af                                       ; $1FBA
    ldh a, [hBlitSrcB + $2]                       ; $1FBB
    ldh [hRomBankShadow], a                       ; $1FBD
    ld [$2000], a                                 ; $1FBF
    ld de, wBlitFirstAndMask                      ; $1FC2
    ld b, $08                                     ; $1FC5
    ldh a, [hBlitRows]                            ; $1FC7

jr_000_1fc9:
    push af                                       ; $1FC9
    push hl                                       ; $1FCA
    ldh a, [hBlitLeftMask + $1]                   ; $1FCB
    ld [de], a                                    ; $1FCD
    ldh a, [hBlitSrcTiles]                        ; $1FCE
    ld c, a                                       ; $1FD0
    ldh a, [hBlitDstTiles]                        ; $1FD1

jr_000_1fd3:
    push af                                       ; $1FD3
    push bc                                       ; $1FD4
    ld a, c                                       ; $1FD5
    and a                                         ; $1FD6
    jr z, jr_000_1fde                             ; $1FD7

    ld a, [hl]                                    ; $1FD9
    ld bc, $0008                                  ; $1FDA
    add hl, bc                                    ; $1FDD

jr_000_1fde:
    push hl                                       ; $1FDE
    ld l, a                                       ; $1FDF
    ldh a, [hBlitShiftPage]                       ; $1FE0
    ld h, a                                       ; $1FE2
    ld a, [hl]                                    ; $1FE3
    ldh [hBlitTmp], a                             ; $1FE4
    ld hl, hBlitLeftMask                          ; $1FE6
    and [hl]                                      ; $1FE9
    ld l, e                                       ; $1FEA
    ld h, d                                       ; $1FEB
    or [hl]                                       ; $1FEC
    ld [hl], a                                    ; $1FED
    inc de                                        ; $1FEE
    inc de                                        ; $1FEF
    inc de                                        ; $1FF0
    inc de                                        ; $1FF1
    inc de                                        ; $1FF2
    ldh a, [hBlitTmp]                             ; $1FF3
    ld hl, hBlitLeftMask + $1                     ; $1FF5
    and [hl]                                      ; $1FF8
    ld [de], a                                    ; $1FF9
    pop hl                                        ; $1FFA
    pop bc                                        ; $1FFB
    pop af                                        ; $1FFC
    dec c                                         ; $1FFD
    dec a                                         ; $1FFE
    jr nz, jr_000_1fd3                            ; $1FFF

    push de                                       ; $2001
    dec de                                        ; $2002
    dec de                                        ; $2003
    dec de                                        ; $2004
    dec de                                        ; $2005
    dec de                                        ; $2006
    ld hl, hBlitRightMask + $1                    ; $2007
    ld a, [de]                                    ; $200A
    or [hl]                                       ; $200B
    ld [de], a                                    ; $200C
    pop de                                        ; $200D
    pop hl                                        ; $200E
    inc hl                                        ; $200F
    dec b                                         ; $2010
    jr nz, jr_000_201b                            ; $2011

    ldh a, [hBlitStride]                          ; $2013
    srl a                                         ; $2015
    ld c, a                                       ; $2017
    add hl, bc                                    ; $2018
    ld b, $08                                     ; $2019

jr_000_201b:
    pop af                                        ; $201B
    dec a                                         ; $201C
    jr nz, jr_000_1fc9                            ; $201D

    pop af                                        ; $201F
    ldh [hRomBankShadow], a                       ; $2020
    ld [$2000], a                                 ; $2022
    ret                                           ; $2025


; C: mask pass deriving the mask from source A (OR of both planes)
Blit_MaskPass_SrcA::
    ldh a, [hBlitSrcA]                            ; $2026
    ld l, a                                       ; $2028
    ldh a, [hBlitSrcA + $1]                       ; $2029
    ld h, a                                       ; $202B
    ldh a, [hRomBankShadow]                       ; $202C
    push af                                       ; $202E
    ldh a, [hBlitSrcA + $2]                       ; $202F
    ldh [hRomBankShadow], a                       ; $2031
    ld [$2000], a                                 ; $2033
    ld de, wBlitFirstAndMask                      ; $2036
    ld b, $08                                     ; $2039
    ldh a, [hBlitRows]                            ; $203B

jr_000_203d:
    push af                                       ; $203D
    push hl                                       ; $203E
    ldh a, [hBlitLeftMask + $1]                   ; $203F
    ld [de], a                                    ; $2041
    ldh a, [hBlitSrcTiles]                        ; $2042
    ld c, a                                       ; $2044
    ldh a, [hBlitDstTiles]                        ; $2045

jr_000_2047:
    push af                                       ; $2047
    push bc                                       ; $2048
    ld a, c                                       ; $2049
    and a                                         ; $204A
    jr z, jr_000_2055                             ; $204B

    ld a, [hl+]                                   ; $204D
    or [hl]                                       ; $204E
    cpl                                           ; $204F
    dec hl                                        ; $2050
    ld bc, $0010                                  ; $2051
    add hl, bc                                    ; $2054

jr_000_2055:
    push hl                                       ; $2055
    ld l, a                                       ; $2056
    ldh a, [hBlitShiftPage]                       ; $2057
    ld h, a                                       ; $2059
    ld a, [hl]                                    ; $205A
    ldh [hBlitTmp], a                             ; $205B
    ld hl, hBlitLeftMask                          ; $205D
    and [hl]                                      ; $2060
    ld l, e                                       ; $2061
    ld h, d                                       ; $2062
    or [hl]                                       ; $2063
    ld [hl], a                                    ; $2064
    inc de                                        ; $2065
    inc de                                        ; $2066
    inc de                                        ; $2067
    inc de                                        ; $2068
    inc de                                        ; $2069
    ldh a, [hBlitTmp]                             ; $206A
    ld hl, hBlitLeftMask + $1                     ; $206C
    and [hl]                                      ; $206F
    ld [de], a                                    ; $2070
    pop hl                                        ; $2071
    pop bc                                        ; $2072
    pop af                                        ; $2073
    dec c                                         ; $2074
    dec a                                         ; $2075
    jr nz, jr_000_2047                            ; $2076

    push de                                       ; $2078
    dec de                                        ; $2079
    dec de                                        ; $207A
    dec de                                        ; $207B
    dec de                                        ; $207C
    dec de                                        ; $207D
    ld hl, hBlitRightMask + $1                    ; $207E
    ld a, [de]                                    ; $2081
    or [hl]                                       ; $2082
    ld [de], a                                    ; $2083
    pop de                                        ; $2084
    pop hl                                        ; $2085
    inc hl                                        ; $2086
    inc hl                                        ; $2087
    dec b                                         ; $2088
    jr nz, jr_000_2091                            ; $2089

    ldh a, [hBlitStride]                          ; $208B
    ld c, a                                       ; $208D
    add hl, bc                                    ; $208E
    ld b, $08                                     ; $208F

jr_000_2091:
    pop af                                        ; $2091
    dec a                                         ; $2092
    jr nz, jr_000_203d                            ; $2093

    pop af                                        ; $2095
    ldh [hRomBankShadow], a                       ; $2096
    ld [$2000], a                                 ; $2098
    ret                                           ; $209B


; C: image pass (2-bit source A)
Blit_ImagePass::
    ldh a, [hBlitSrcA]                            ; $209C
    ld l, a                                       ; $209E
    ldh a, [hBlitSrcA + $1]                       ; $209F
    ld h, a                                       ; $20A1
    ldh a, [hRomBankShadow]                       ; $20A2
    push af                                       ; $20A4
    ldh a, [hBlitSrcA + $2]                       ; $20A5
    ldh [hRomBankShadow], a                       ; $20A7
    ld [$2000], a                                 ; $20A9
    ld de, wBlitFirstOrBytes                      ; $20AC
    ld b, $08                                     ; $20AF
    ldh a, [hBlitRows]                            ; $20B1

; C: loop top of the image pass: saves AF/HL, clears two bytes at DE, runs the next 8 lines (branch target; code read
; 2026-10-19)
Blit_ImagePass_Loop::
    push af                                       ; $20B3
    push hl                                       ; $20B4
    xor a                                         ; $20B5
    ld [de], a                                    ; $20B6
    inc de                                        ; $20B7
    ld [de], a                                    ; $20B8
    dec de                                        ; $20B9
    ldh a, [hBlitSrcTiles]                        ; $20BA
    ld c, a                                       ; $20BC
    ldh a, [hBlitDstTiles]                        ; $20BD

jr_000_20bf:
    push af                                       ; $20BF
    push bc                                       ; $20C0
    ld a, c                                       ; $20C1
    and a                                         ; $20C2
    jr z, jr_000_20de                             ; $20C3

    ld a, [hl+]                                   ; $20C5
    push hl                                       ; $20C6
    ld l, a                                       ; $20C7
    ldh a, [hBlitShiftPage]                       ; $20C8
    ld h, a                                       ; $20CA
    ld a, [hl]                                    ; $20CB
    ldh [hBlitTmp], a                             ; $20CC
    pop hl                                        ; $20CE
    ld a, [hl]                                    ; $20CF
    ld bc, $000f                                  ; $20D0
    add hl, bc                                    ; $20D3
    push hl                                       ; $20D4
    ld l, a                                       ; $20D5
    ldh a, [hBlitShiftPage]                       ; $20D6
    ld h, a                                       ; $20D8
    ld a, [hl]                                    ; $20D9
    ldh [hBlitTmp + $1], a                        ; $20DA
    jr jr_000_20e3                                ; $20DC

jr_000_20de:
    ldh [hBlitTmp], a                             ; $20DE
    ldh [hBlitTmp + $1], a                        ; $20E0
    push hl                                       ; $20E2

jr_000_20e3:
    ldh a, [hBlitTmp]                             ; $20E3
    ld hl, hBlitLeftMask                          ; $20E5
    and [hl]                                      ; $20E8
    ld l, e                                       ; $20E9
    ld h, d                                       ; $20EA
    or [hl]                                       ; $20EB
    ld [hl], a                                    ; $20EC
    inc de                                        ; $20ED
    ldh a, [hBlitTmp + $1]                        ; $20EE
    ld hl, hBlitLeftMask                          ; $20F0
    and [hl]                                      ; $20F3
    ld l, e                                       ; $20F4
    ld h, d                                       ; $20F5
    or [hl]                                       ; $20F6
    ld [hl], a                                    ; $20F7
    inc de                                        ; $20F8
    inc de                                        ; $20F9
    inc de                                        ; $20FA
    inc de                                        ; $20FB
    ldh a, [hBlitTmp]                             ; $20FC
    ld hl, hBlitLeftMask + $1                     ; $20FE
    and [hl]                                      ; $2101
    ld [de], a                                    ; $2102
    inc de                                        ; $2103
    ldh a, [hBlitTmp + $1]                        ; $2104
    ld hl, hBlitLeftMask + $1                     ; $2106
    and [hl]                                      ; $2109
    ld [de], a                                    ; $210A
    dec de                                        ; $210B
    pop hl                                        ; $210C
    pop bc                                        ; $210D
    pop af                                        ; $210E
    dec c                                         ; $210F
    dec a                                         ; $2110
    jr nz, jr_000_20bf                            ; $2111

    push de                                       ; $2113
    dec de                                        ; $2114
    dec de                                        ; $2115
    dec de                                        ; $2116
    dec de                                        ; $2117
    dec de                                        ; $2118
    ld hl, hBlitRightMask                         ; $2119
    ld a, [de]                                    ; $211C
    and [hl]                                      ; $211D
    ld [de], a                                    ; $211E
    inc de                                        ; $211F
    ld a, [de]                                    ; $2120
    and [hl]                                      ; $2121
    ld [de], a                                    ; $2122
    dec de                                        ; $2123
    pop de                                        ; $2124
    pop hl                                        ; $2125
    inc hl                                        ; $2126
    inc hl                                        ; $2127
    dec b                                         ; $2128
    jr nz, jr_000_2131                            ; $2129

    ldh a, [hBlitStride]                          ; $212B
    ld c, a                                       ; $212D
    add hl, bc                                    ; $212E
    ld b, $08                                     ; $212F

jr_000_2131:
    pop af                                        ; $2131
    dec a                                         ; $2132
    jp nz, Blit_ImagePass_Loop                    ; $2133

    pop af                                        ; $2136
    ldh [hRomBankShadow], a                       ; $2137
    ld [$2000], a                                 ; $2139
    ret                                           ; $213C


; C: applies the $C800 patch list to the tile buffer
Blit_ApplyPatchList::
    ld hl, wBlitPatchList                         ; $213D

jr_000_2140:
    ld a, $04                                     ; $2140

jr_000_2142:
    nop                                           ; $2142
    dec a                                         ; $2143
    jr nz, jr_000_2142                            ; $2144

    ld a, [hl+]                                   ; $2146
    ld e, a                                       ; $2147
    ld d, [hl]                                    ; $2148
    or d                                          ; $2149
    ret z                                         ; $214A

    inc hl                                        ; $214B
    ld a, [hl+]                                   ; $214C
    ld c, [hl]                                    ; $214D
    inc hl                                        ; $214E
    ld b, [hl]                                    ; $214F
    inc hl                                        ; $2150
    push hl                                       ; $2151
    ld l, a                                       ; $2152

jr_000_2153:
    ldh a, [rLY]                                  ; $2153
    cp $20                                        ; $2155
    jr c, jr_000_2153                             ; $2157

    cp $88                                        ; $2159
    jr nc, jr_000_2153                            ; $215B

jr_000_215d:
    ldh a, [rSTAT]                                ; $215D
    and $03                                       ; $215F
    jr nz, jr_000_215d                            ; $2161

    ld a, [de]                                    ; $2163
    and l                                         ; $2164
    or c                                          ; $2165
    ld [de], a                                    ; $2166
    inc de                                        ; $2167
    ld a, [de]                                    ; $2168
    and l                                         ; $2169
    or b                                          ; $216A
    ld [de], a                                    ; $216B
    inc de                                        ; $216C
    pop hl                                        ; $216D
    jr jr_000_2140                                ; $216E

; C: 18 words: pointer to the VRAM address row of each tile row. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the
; organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_TileRowPtrTbl::
    dw Blit_TileAddrTbl
    dw $21bc
    dw $21e4
    dw $220c
    dw $2234
    dw $225c
    dw $2284
    dw $22ac
    dw $22d4
    dw $22fc
    dw $2324
    dw $234c
    dw $2374
    dw $239c
    dw $23c4
    dw $23ec
    dw $2414
    dw $243c

; C: 18 rows x 20 words: low/high byte of the VRAM address of each tile cell (2 bytes per entry). L3 pass 2026-10-26:
; read in BGB in 7 replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_TileAddrTbl::
    INCBIN "data/bank_00/Blit_TileAddrTbl.bin" ; $2194, 720 bytes
; C: adds an OAM list from the pointer table 02:6E4B (A = index) at the OAM cursor; BC = Y/X offset
Oam_AddMeta_B02_6E4B::
    push bc                                       ; $2464
    push de                                       ; $2465
    push hl                                       ; $2466
    ld e, a                                       ; $2467
    ld d, $00                                     ; $2468
    sla e                                         ; $246A
    rl d                                          ; $246C
    ldh a, [hRomBankShadow]                       ; $246E
    push af                                       ; $2470
    ld a, $02                                     ; $2471
    ldh [hRomBankShadow], a                       ; $2473
    ld [$2000], a                                 ; $2475
    ld hl, $6e4b                                  ; $2478
    jr Oam_AddMeta_Common                         ; $247B

; C: same with the table 02:5272
Oam_AddMeta_B02_5272::
    push bc                                       ; $247D
    push de                                       ; $247E
    push hl                                       ; $247F
    ld e, a                                       ; $2480
    ld d, $00                                     ; $2481
    sla e                                         ; $2483
    rl d                                          ; $2485
    ldh a, [hRomBankShadow]                       ; $2487
    push af                                       ; $2489
    ld a, $02                                     ; $248A
    ldh [hRomBankShadow], a                       ; $248C
    ld [$2000], a                                 ; $248E
    ld hl, $5272                                  ; $2491
    jr Oam_AddMeta_Common                         ; $2494

; C: same with the table 01:5D47 (246 entries)
Oam_AddMeta_B01_5D47::
    push bc                                       ; $2496
    push de                                       ; $2497
    push hl                                       ; $2498
    ld e, a                                       ; $2499
    ld d, $00                                     ; $249A
    sla e                                         ; $249C
    rl d                                          ; $249E
    ldh a, [hRomBankShadow]                       ; $24A0
    push af                                       ; $24A2
    ld a, $01                                     ; $24A3
    ldh [hRomBankShadow], a                       ; $24A5
    ld [$2000], a                                 ; $24A7
    ld hl, $5d47                                  ; $24AA
    jr Oam_AddMeta_Common                         ; $24AD

; C: same with the table 01:4000 (249 entries)
Oam_AddMeta_B01_4000::
    push bc                                       ; $24AF
    push de                                       ; $24B0
    push hl                                       ; $24B1
    ld e, a                                       ; $24B2
    ld d, $00                                     ; $24B3
    sla e                                         ; $24B5
    rl d                                          ; $24B7
    ldh a, [hRomBankShadow]                       ; $24B9
    push af                                       ; $24BB
    ld a, $01                                     ; $24BC
    ldh [hRomBankShadow], a                       ; $24BE
    ld [$2000], a                                 ; $24C0
    ld hl, $4000                                  ; $24C3

; C: shared tail: copies 4-byte records (Y+C
Oam_AddMeta_Common::
    add hl, de                                    ; $24C6
    ld a, [hl+]                                   ; $24C7
    ld e, a                                       ; $24C8
    ld a, [hl]                                    ; $24C9
    ld d, a                                       ; $24CA
    ldh a, [hOamCursor]                           ; $24CB
    ld l, a                                       ; $24CD
    ld h, HIGH(wOamShadow)                        ; $24CE

jr_000_24d0:
    ld a, [de]                                    ; $24D0
    cp $80                                        ; $24D1
    jr z, jr_000_24e4                             ; $24D3

    add c                                         ; $24D5
    ld [hl+], a                                   ; $24D6
    inc de                                        ; $24D7
    ld a, [de]                                    ; $24D8
    add b                                         ; $24D9
    ld [hl+], a                                   ; $24DA
    inc de                                        ; $24DB
    ld a, [de]                                    ; $24DC
    ld [hl+], a                                   ; $24DD
    inc de                                        ; $24DE
    ld a, [de]                                    ; $24DF
    ld [hl+], a                                   ; $24E0
    inc de                                        ; $24E1
    jr jr_000_24d0                                ; $24E2

jr_000_24e4:
    ld a, l                                       ; $24E4
    ldh [hOamCursor], a                           ; $24E5
    pop af                                        ; $24E7
    ldh [hRomBankShadow], a                       ; $24E8
    ld [$2000], a                                 ; $24EA
    pop hl                                        ; $24ED
    pop de                                        ; $24EE
    pop bc                                        ; $24EF
    ret                                           ; $24F0


; I: variant of the adder that also adds B to the tile number; unreferenced
Oam_AddMetaTile_B02_6E4B_Dead::
    push bc                                       ; $24F1
    push de                                       ; $24F2
    push hl                                       ; $24F3
    ld e, a                                       ; $24F4
    ld d, $00                                     ; $24F5
    sla e                                         ; $24F7
    rl d                                          ; $24F9
    ldh a, [hRomBankShadow]                       ; $24FB
    push af                                       ; $24FD
    ld a, $02                                     ; $24FE
    ldh [hRomBankShadow], a                       ; $2500
    ld [$2000], a                                 ; $2502
    ld hl, $6e4b                                  ; $2505
    jr jr_000_2553                                ; $2508

; C: variant that also adds B to the tile number (one caller 09:5046)
Oam_AddMetaTile_B02_5272::
    push bc                                       ; $250A
    push de                                       ; $250B
    push hl                                       ; $250C
    ld e, a                                       ; $250D
    ld d, $00                                     ; $250E
    sla e                                         ; $2510
    rl d                                          ; $2512
    ldh a, [hRomBankShadow]                       ; $2514
    push af                                       ; $2516
    ld a, $02                                     ; $2517
    ldh [hRomBankShadow], a                       ; $2519
    ld [$2000], a                                 ; $251B
    ld hl, $5272                                  ; $251E
    jr jr_000_2553                                ; $2521

; I: variant with tile offset; unreferenced
Oam_AddMetaTile_B01_5D47_Dead::
    push bc                                       ; $2523
    push de                                       ; $2524
    push hl                                       ; $2525
    ld e, a                                       ; $2526
    ld d, $00                                     ; $2527
    sla e                                         ; $2529
    rl d                                          ; $252B
    ldh a, [hRomBankShadow]                       ; $252D
    push af                                       ; $252F
    ld a, $01                                     ; $2530
    ldh [hRomBankShadow], a                       ; $2532
    ld [$2000], a                                 ; $2534
    ld hl, $5d47                                  ; $2537
    jr jr_000_2553                                ; $253A

; I: variant with tile offset; unreferenced
Oam_AddMetaTile_B01_4000_Dead::
    push bc                                       ; $253C
    push de                                       ; $253D
    push hl                                       ; $253E
    ld e, a                                       ; $253F
    ld d, $00                                     ; $2540
    sla e                                         ; $2542
    rl d                                          ; $2544
    ldh a, [hRomBankShadow]                       ; $2546
    push af                                       ; $2548
    ld a, $01                                     ; $2549
    ldh [hRomBankShadow], a                       ; $254B
    ld [$2000], a                                 ; $254D
    ld hl, $4000                                  ; $2550

jr_000_2553:
    add hl, de                                    ; $2553
    ld a, [hl+]                                   ; $2554
    ld e, a                                       ; $2555
    ld a, [hl]                                    ; $2556
    ld d, a                                       ; $2557
    ldh a, [hOamCursor]                           ; $2558
    ld l, a                                       ; $255A
    ld h, HIGH(wOamShadow)                        ; $255B

jr_000_255d:
    ld a, [de]                                    ; $255D
    cp $80                                        ; $255E
    jr z, jr_000_2576                             ; $2560

    add c                                         ; $2562
    ld [hl+], a                                   ; $2563
    inc de                                        ; $2564
    ld a, [de]                                    ; $2565
    add b                                         ; $2566
    ld [hl+], a                                   ; $2567
    inc de                                        ; $2568
    ld a, [de]                                    ; $2569
    push hl                                       ; $256A
    ld hl, sp+$07                                 ; $256B
    add [hl]                                      ; $256D
    pop hl                                        ; $256E
    ld [hl+], a                                   ; $256F
    inc de                                        ; $2570
    ld a, [de]                                    ; $2571
    ld [hl+], a                                   ; $2572
    inc de                                        ; $2573
    jr jr_000_255d                                ; $2574

jr_000_2576:
    ld a, l                                       ; $2576
    ldh [hOamCursor], a                           ; $2577
    pop af                                        ; $2579
    ldh [hRomBankShadow], a                       ; $257A
    ld [$2000], a                                 ; $257C
    pop hl                                        ; $257F
    pop de                                        ; $2580
    pop bc                                        ; $2581
    ret                                           ; $2582


; C: photo -> 32x28 thumbnail (4x4 blocks with the quantizer); callers 02:472C / 02:47ED
Img_ReduceToThumbnail::
    push bc                                       ; $2583
    push de                                       ; $2584
    push hl                                       ; $2585
    ld e, [hl]                                    ; $2586
    inc hl                                        ; $2587
    ld a, [hl+]                                   ; $2588
    ld d, a                                       ; $2589
    cp $a0                                        ; $258A
    ld a, [hl]                                    ; $258C
    jr nc, jr_000_259e                            ; $258D

    ldh [hBankTmp], a                             ; $258F
    ldh a, [hRomBankShadow]                       ; $2591
    push af                                       ; $2593
    ldh a, [hBankTmp]                             ; $2594
    ldh [hRomBankShadow], a                       ; $2596
    ld [$2000], a                                 ; $2598
    scf                                           ; $259B
    jr jr_000_25a2                                ; $259C

jr_000_259e:
    ld [$4000], a                                 ; $259E
    and a                                         ; $25A1

jr_000_25a2:
    push af                                       ; $25A2
    ld h, b                                       ; $25A3
    ld l, c                                       ; $25A4
    ld c, $04                                     ; $25A5

jr_000_25a7:
    push bc                                       ; $25A7
    ld b, $04                                     ; $25A8
    ld a, c                                       ; $25AA
    cp $01                                        ; $25AB
    jr nz, jr_000_25b1                            ; $25AD

    ld b, $02                                     ; $25AF

jr_000_25b1:
    ld c, $04                                     ; $25B1
    push hl                                       ; $25B3

jr_000_25b4:
    push bc                                       ; $25B4
    push hl                                       ; $25B5
    ld hl, wReducerAccum                          ; $25B6
    ld b, $08                                     ; $25B9

jr_000_25bb:
    ld c, $04                                     ; $25BB
    xor a                                         ; $25BD
    ld [hl+], a                                   ; $25BE
    ld [hl], a                                    ; $25BF

jr_000_25c0:
    call Img_PairLookup                           ; $25C0
    push af                                       ; $25C3
    and $0f                                       ; $25C4
    add [hl]                                      ; $25C6
    ld [hl-], a                                   ; $25C7
    pop af                                        ; $25C8
    swap a                                        ; $25C9
    and $0f                                       ; $25CB
    add [hl]                                      ; $25CD
    ld [hl+], a                                   ; $25CE
    dec c                                         ; $25CF
    jr nz, jr_000_25c0                            ; $25D0

    inc hl                                        ; $25D2
    dec b                                         ; $25D3
    jr nz, jr_000_25bb                            ; $25D4

    pop hl                                        ; $25D6
    push de                                       ; $25D7
    push hl                                       ; $25D8
    ld hl, wReducerAccum                          ; $25D9
    ld de, $0080                                  ; $25DC
    call Img_PackQuadBits                         ; $25DF
    pop hl                                        ; $25E2
    ld [hl], c                                    ; $25E3
    inc hl                                        ; $25E4
    ld [hl], b                                    ; $25E5
    inc hl                                        ; $25E6
    push hl                                       ; $25E7
    ld hl, wReducerAccum + $2                     ; $25E8
    ld de, $0008                                  ; $25EB
    call Img_PackQuadBits                         ; $25EE
    pop hl                                        ; $25F1
    ld [hl], c                                    ; $25F2
    inc hl                                        ; $25F3
    ld [hl], b                                    ; $25F4
    ld bc, $000d                                  ; $25F5
    add hl, bc                                    ; $25F8
    pop de                                        ; $25F9
    pop bc                                        ; $25FA
    dec c                                         ; $25FB
    jr nz, jr_000_25b4                            ; $25FC

    pop hl                                        ; $25FE
    inc hl                                        ; $25FF
    inc hl                                        ; $2600
    inc hl                                        ; $2601
    inc hl                                        ; $2602
    dec b                                         ; $2603
    jr nz, jr_000_25b1                            ; $2604

    ld bc, $0030                                  ; $2606
    add hl, bc                                    ; $2609
    pop bc                                        ; $260A
    dec c                                         ; $260B
    jr nz, jr_000_25a7                            ; $260C

    pop af                                        ; $260E
    jr nc, jr_000_2617                            ; $260F

    pop af                                        ; $2611
    ldh [hRomBankShadow], a                       ; $2612
    ld [$2000], a                                 ; $2614

jr_000_2617:
    pop hl                                        ; $2617
    pop de                                        ; $2618
    pop bc                                        ; $2619
    ret                                           ; $261A


; C: two bytes through the table at $37xx -> one 2-bit value (b + 2*c). L3 pass 2026-10-26: executed in BGB in 3
; replay(s) of the organic corpus, modes 10 14 (tcrf_check/assets/l3_names/)
Img_PairLookup::
    push bc                                       ; $261B
    push hl                                       ; $261C
    ld b, $00                                     ; $261D
    ld a, [de]                                    ; $261F
    inc de                                        ; $2620
    ld l, a                                       ; $2621
    ld h, $37                                     ; $2622
    ld b, [hl]                                    ; $2624
    ld a, [de]                                    ; $2625
    inc de                                        ; $2626
    ld l, a                                       ; $2627
    ld h, $37                                     ; $2628
    ld a, [hl]                                    ; $262A
    sla a                                         ; $262B
    add b                                         ; $262D
    pop hl                                        ; $262E
    pop bc                                        ; $262F
    ret                                           ; $2630


; C: packs four rows of 2-bit values into BC after adding the dither offsets D / E. L3 pass 2026-10-26: executed in
; BGB in 3 replay(s) of the organic corpus, modes 10 14 (tcrf_check/assets/l3_names/)
Img_PackQuadBits::
    ld bc, $0000                                  ; $2631
    ld a, $04                                     ; $2634

jr_000_2636:
    push af                                       ; $2636
    ld a, [hl+]                                   ; $2637
    add d                                         ; $2638
    swap a                                        ; $2639
    srl a                                         ; $263B
    rl c                                          ; $263D
    srl a                                         ; $263F
    rl b                                          ; $2641
    ld a, [hl+]                                   ; $2643
    add e                                         ; $2644
    swap a                                        ; $2645
    srl a                                         ; $2647
    rl c                                          ; $2649
    srl a                                         ; $264B
    rl b                                          ; $264D
    inc hl                                        ; $264F
    inc hl                                        ; $2650
    pop af                                        ; $2651
    dec a                                         ; $2652
    jr nz, jr_000_2636                            ; $2653

    ret                                           ; $2655


; C: photo -> 64x56 preview at $C000
Img_ReduceTo64x56::
    push bc                                       ; $2656
    push de                                       ; $2657
    push hl                                       ; $2658
    ld e, [hl]                                    ; $2659
    inc hl                                        ; $265A
    ld a, [hl+]                                   ; $265B
    ld d, a                                       ; $265C
    cp $a0                                        ; $265D
    ld a, [hl]                                    ; $265F
    jr nc, jr_000_2671                            ; $2660

    ldh [hBankTmp], a                             ; $2662
    ldh a, [hRomBankShadow]                       ; $2664
    push af                                       ; $2666
    ldh a, [hBankTmp]                             ; $2667
    ldh [hRomBankShadow], a                       ; $2669
    ld [$2000], a                                 ; $266B
    scf                                           ; $266E
    jr jr_000_2675                                ; $266F

jr_000_2671:
    ld [$4000], a                                 ; $2671
    and a                                         ; $2674

jr_000_2675:
    push af                                       ; $2675
    ld h, b                                       ; $2676
    ld l, c                                       ; $2677
    ld c, $07                                     ; $2678

; C: row-group loop top of the 64x56 reducer (B = 2, C = 8 reloaded) (branch target; code read 2026-10-19)
Img_ReduceTo64x56_RowLoop::
    push bc                                       ; $267A
    ld b, $02                                     ; $267B

; C: column loop top of the 64x56 reducer (C = 8 reloaded, B counts down) (branch target; code read 2026-10-19)
Img_ReduceTo64x56_ColLoop::
    ld c, $08                                     ; $267D
    push hl                                       ; $267F

jr_000_2680:
    push bc                                       ; $2680
    push hl                                       ; $2681
    ld hl, wReducerAccum                          ; $2682
    ld b, $08                                     ; $2685

jr_000_2687:
    ld c, $02                                     ; $2687
    xor a                                         ; $2689
    ld [hl+], a                                   ; $268A
    ld [hl+], a                                   ; $268B
    ld [hl+], a                                   ; $268C
    ld [hl], a                                    ; $268D

jr_000_268e:
    call Img_CombineNibbleMap                     ; $268E
    ld a, [wReducerResult]                        ; $2691
    push af                                       ; $2694
    and $0f                                       ; $2695
    add [hl]                                      ; $2697
    ld [hl-], a                                   ; $2698
    pop af                                        ; $2699
    swap a                                        ; $269A
    and $0f                                       ; $269C
    add [hl]                                      ; $269E
    ld [hl-], a                                   ; $269F
    ld a, [wReducerResult + $1]                   ; $26A0
    push af                                       ; $26A3
    and $0f                                       ; $26A4
    add [hl]                                      ; $26A6
    ld [hl-], a                                   ; $26A7
    pop af                                        ; $26A8
    swap a                                        ; $26A9
    and $0f                                       ; $26AB
    add [hl]                                      ; $26AD
    ld [hl+], a                                   ; $26AE
    inc hl                                        ; $26AF
    inc hl                                        ; $26B0
    dec c                                         ; $26B1
    jr nz, jr_000_268e                            ; $26B2

    inc hl                                        ; $26B4
    dec b                                         ; $26B5
    jr nz, jr_000_2687                            ; $26B6

    pop hl                                        ; $26B8
    push de                                       ; $26B9
    push hl                                       ; $26BA
    ld hl, wReducerAccum                          ; $26BB
    ld de, $0020                                  ; $26BE
    call Img_QuantizeBlockDither                  ; $26C1
    pop hl                                        ; $26C4
    ld [hl], c                                    ; $26C5
    inc hl                                        ; $26C6
    ld [hl], b                                    ; $26C7
    inc hl                                        ; $26C8
    push hl                                       ; $26C9
    ld de, $0002                                  ; $26CA
    ld hl, wReducerAccum + $4                     ; $26CD
    call Img_QuantizeBlockDither                  ; $26D0
    pop hl                                        ; $26D3
    ld [hl], c                                    ; $26D4
    inc hl                                        ; $26D5
    ld [hl], b                                    ; $26D6
    inc hl                                        ; $26D7
    push hl                                       ; $26D8
    ld de, $0020                                  ; $26D9
    ld hl, wReducerAccum + $8                     ; $26DC
    call Img_QuantizeBlockDither                  ; $26DF
    pop hl                                        ; $26E2
    ld [hl], c                                    ; $26E3
    inc hl                                        ; $26E4
    ld [hl], b                                    ; $26E5
    inc hl                                        ; $26E6
    push hl                                       ; $26E7
    ld de, $0002                                  ; $26E8
    ld hl, wReducerAccum + $c                     ; $26EB
    call Img_QuantizeBlockDither                  ; $26EE
    pop hl                                        ; $26F1
    ld [hl], c                                    ; $26F2
    inc hl                                        ; $26F3
    ld [hl], b                                    ; $26F4
    ld bc, $0009                                  ; $26F5
    add hl, bc                                    ; $26F8
    pop de                                        ; $26F9
    pop bc                                        ; $26FA
    dec c                                         ; $26FB
    jr nz, jr_000_2680                            ; $26FC

    pop hl                                        ; $26FE
    push bc                                       ; $26FF
    ld bc, $0008                                  ; $2700
    add hl, bc                                    ; $2703
    pop bc                                        ; $2704
    dec b                                         ; $2705
    jp nz, Img_ReduceTo64x56_ColLoop              ; $2706

    ld bc, $0070                                  ; $2709
    add hl, bc                                    ; $270C
    pop bc                                        ; $270D
    ldh a, [hKeysHeld]                            ; $270E
    and PADF_B | PADF_SELECT | PADF_START | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $2710
    jr nz, jr_000_2726                            ; $2712

    dec c                                         ; $2714
    jp nz, Img_ReduceTo64x56_RowLoop              ; $2715

    pop af                                        ; $2718
    jr nc, jr_000_2721                            ; $2719

    pop af                                        ; $271B
    ldh [hRomBankShadow], a                       ; $271C
    ld [$2000], a                                 ; $271E

jr_000_2721:
    pop hl                                        ; $2721
    pop de                                        ; $2722
    pop bc                                        ; $2723
    and a                                         ; $2724
    ret                                           ; $2725


jr_000_2726:
    pop af                                        ; $2726
    jr nc, jr_000_272f                            ; $2727

    pop af                                        ; $2729
    ldh [hRomBankShadow], a                       ; $272A
    ld [$2000], a                                 ; $272C

jr_000_272f:
    pop hl                                        ; $272F
    pop de                                        ; $2730
    pop bc                                        ; $2731
    scf                                           ; $2732
    ret                                           ; $2733


; C: quadrant -> 4x4 tile grid at $C000-$C0FF
Img_ReduceQuadrantTo4x4Tiles::
    push bc                                       ; $2734
    push de                                       ; $2735
    push hl                                       ; $2736
    ld e, [hl]                                    ; $2737
    inc hl                                        ; $2738
    ld a, [hl+]                                   ; $2739
    ld d, a                                       ; $273A
    cp $a0                                        ; $273B
    ld a, [hl]                                    ; $273D
    jr nc, jr_000_274f                            ; $273E

    ldh [hBankTmp], a                             ; $2740
    ldh a, [hRomBankShadow]                       ; $2742
    push af                                       ; $2744
    ldh a, [hBankTmp]                             ; $2745
    ldh [hRomBankShadow], a                       ; $2747
    ld [$2000], a                                 ; $2749
    scf                                           ; $274C
    jr jr_000_2753                                ; $274D

jr_000_274f:
    ld [$4000], a                                 ; $274F
    and a                                         ; $2752

jr_000_2753:
    push af                                       ; $2753
    ld h, b                                       ; $2754
    ld l, c                                       ; $2755
    ld c, $04                                     ; $2756

; C: row-group loop top of the quadrant reducer (B = 2, C = 4 reloaded) (branch target; code read 2026-10-19)
Img_ReduceQuadrantTo4x4Tiles_RowLoop::
    push bc                                       ; $2758
    ld b, $02                                     ; $2759

; C: column loop top of the quadrant reducer (C = 4 reloaded, B counts down) (branch target; code read 2026-10-19)
Img_ReduceQuadrantTo4x4Tiles_ColLoop::
    ld c, $04                                     ; $275B
    push hl                                       ; $275D

jr_000_275e:
    push bc                                       ; $275E
    push hl                                       ; $275F
    ld hl, wReducerAccum                          ; $2760
    ld b, $08                                     ; $2763

jr_000_2765:
    ld c, $02                                     ; $2765
    xor a                                         ; $2767
    ld [hl+], a                                   ; $2768
    ld [hl+], a                                   ; $2769
    ld [hl+], a                                   ; $276A
    ld [hl], a                                    ; $276B

jr_000_276c:
    call Img_CombineNibbleMap                     ; $276C
    ld a, [wReducerResult]                        ; $276F
    push af                                       ; $2772
    and $0f                                       ; $2773
    add [hl]                                      ; $2775
    ld [hl-], a                                   ; $2776
    pop af                                        ; $2777
    swap a                                        ; $2778
    and $0f                                       ; $277A
    add [hl]                                      ; $277C
    ld [hl-], a                                   ; $277D
    ld a, [wReducerResult + $1]                   ; $277E
    push af                                       ; $2781
    and $0f                                       ; $2782
    add [hl]                                      ; $2784
    ld [hl-], a                                   ; $2785
    pop af                                        ; $2786
    swap a                                        ; $2787
    and $0f                                       ; $2789
    add [hl]                                      ; $278B
    ld [hl+], a                                   ; $278C
    inc hl                                        ; $278D
    inc hl                                        ; $278E
    dec c                                         ; $278F
    jr nz, jr_000_276c                            ; $2790

    inc hl                                        ; $2792
    dec b                                         ; $2793
    jr nz, jr_000_2765                            ; $2794

    ld hl, wReducerAccum                          ; $2796
    call Img_QuantizeBlockRound                   ; $2799
    pop hl                                        ; $279C
    ld [hl], c                                    ; $279D
    inc hl                                        ; $279E
    ld [hl], b                                    ; $279F
    inc hl                                        ; $27A0
    push hl                                       ; $27A1
    ld hl, wReducerAccum + $4                     ; $27A2
    call Img_QuantizeBlockRound                   ; $27A5
    pop hl                                        ; $27A8
    ld [hl], c                                    ; $27A9
    inc hl                                        ; $27AA
    ld [hl], b                                    ; $27AB
    inc hl                                        ; $27AC
    push hl                                       ; $27AD
    ld hl, wReducerAccum + $8                     ; $27AE
    call Img_QuantizeBlockRound                   ; $27B1
    pop hl                                        ; $27B4
    ld [hl], c                                    ; $27B5
    inc hl                                        ; $27B6
    ld [hl], b                                    ; $27B7
    inc hl                                        ; $27B8
    push hl                                       ; $27B9
    ld hl, wReducerAccum + $c                     ; $27BA
    call Img_QuantizeBlockRound                   ; $27BD
    pop hl                                        ; $27C0
    ld [hl], c                                    ; $27C1
    inc hl                                        ; $27C2
    ld [hl], b                                    ; $27C3
    ld bc, $0009                                  ; $27C4
    add hl, bc                                    ; $27C7
    pop bc                                        ; $27C8
    dec c                                         ; $27C9
    jr nz, jr_000_275e                            ; $27CA

    ld a, e                                       ; $27CC
    add $80                                       ; $27CD
    ld e, a                                       ; $27CF
    jr nc, jr_000_27d3                            ; $27D0

    inc d                                         ; $27D2

jr_000_27d3:
    pop hl                                        ; $27D3
    push bc                                       ; $27D4
    ld bc, $0008                                  ; $27D5
    add hl, bc                                    ; $27D8
    pop bc                                        ; $27D9
    dec b                                         ; $27DA
    jp nz, Img_ReduceQuadrantTo4x4Tiles_ColLoop   ; $27DB

    ld bc, $0030                                  ; $27DE
    add hl, bc                                    ; $27E1
    pop bc                                        ; $27E2
    dec c                                         ; $27E3
    jp nz, Img_ReduceQuadrantTo4x4Tiles_RowLoop   ; $27E4

    pop af                                        ; $27E7
    jr nc, jr_000_27f0                            ; $27E8

    pop af                                        ; $27EA
    ldh [hRomBankShadow], a                       ; $27EB
    ld [$2000], a                                 ; $27ED

jr_000_27f0:
    pop hl                                        ; $27F0
    pop de                                        ; $27F1
    pop bc                                        ; $27F2
    ret                                           ; $27F3


; C: 2:1 reduction to $C000-$C1BF (6 callers in bank 06). L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the
; organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Img_ReduceHalfTo224Wide::
    push bc                                       ; $27F4
    push de                                       ; $27F5
    push hl                                       ; $27F6
    ld e, [hl]                                    ; $27F7
    inc hl                                        ; $27F8
    ld a, [hl+]                                   ; $27F9
    ld d, a                                       ; $27FA
    cp $a0                                        ; $27FB
    ld a, [hl]                                    ; $27FD
    jr nc, jr_000_280f                            ; $27FE

    ldh [hBankTmp], a                             ; $2800
    ldh a, [hRomBankShadow]                       ; $2802
    push af                                       ; $2804
    ldh a, [hBankTmp]                             ; $2805
    ldh [hRomBankShadow], a                       ; $2807
    ld [$2000], a                                 ; $2809
    scf                                           ; $280C
    jr jr_000_2813                                ; $280D

jr_000_280f:
    ld [$4000], a                                 ; $280F
    and a                                         ; $2812

jr_000_2813:
    push af                                       ; $2813
    ld h, b                                       ; $2814
    ld l, c                                       ; $2815
    ld c, $07                                     ; $2816

; C: row-group loop top of the half-size reducer (B = 2, C = 8) (branch target; code read 2026-10-19)
Img_ReduceHalfTo224Wide_RowLoop::
    push bc                                       ; $2818
    ld b, $02                                     ; $2819

jr_000_281b:
    ld c, $08                                     ; $281B
    push hl                                       ; $281D

jr_000_281e:
    push bc                                       ; $281E
    push hl                                       ; $281F
    ld hl, wReducerAccum                          ; $2820
    ld b, $04                                     ; $2823

jr_000_2825:
    ld c, $02                                     ; $2825
    xor a                                         ; $2827
    ld [hl+], a                                   ; $2828
    ld [hl+], a                                   ; $2829
    ld [hl+], a                                   ; $282A
    ld [hl], a                                    ; $282B

jr_000_282c:
    call Img_CombineNibbleMap                     ; $282C
    ld a, [wReducerResult]                        ; $282F
    push af                                       ; $2832
    and $0f                                       ; $2833
    add [hl]                                      ; $2835
    ld [hl-], a                                   ; $2836
    pop af                                        ; $2837
    swap a                                        ; $2838
    and $0f                                       ; $283A
    add [hl]                                      ; $283C
    ld [hl-], a                                   ; $283D
    ld a, [wReducerResult + $1]                   ; $283E
    push af                                       ; $2841
    and $0f                                       ; $2842
    add [hl]                                      ; $2844
    ld [hl-], a                                   ; $2845
    pop af                                        ; $2846
    swap a                                        ; $2847
    and $0f                                       ; $2849
    add [hl]                                      ; $284B
    ld [hl+], a                                   ; $284C
    inc hl                                        ; $284D
    inc hl                                        ; $284E
    dec c                                         ; $284F
    jr nz, jr_000_282c                            ; $2850

    inc de                                        ; $2852
    inc de                                        ; $2853
    inc de                                        ; $2854
    inc de                                        ; $2855
    inc hl                                        ; $2856
    inc hl                                        ; $2857
    inc hl                                        ; $2858
    inc hl                                        ; $2859
    inc hl                                        ; $285A
    dec b                                         ; $285B
    jr nz, jr_000_2825                            ; $285C

    ld hl, wReducerAccum                          ; $285E
    call Img_QuantizeBlockRound                   ; $2861
    pop hl                                        ; $2864
    ld [hl], c                                    ; $2865
    inc hl                                        ; $2866
    ld [hl], b                                    ; $2867
    inc hl                                        ; $2868
    push hl                                       ; $2869
    ld hl, wReducerAccum + $8                     ; $286A
    call Img_QuantizeBlockRound                   ; $286D
    pop hl                                        ; $2870
    ld [hl], c                                    ; $2871
    inc hl                                        ; $2872
    ld [hl], b                                    ; $2873
    ld bc, $0005                                  ; $2874
    add hl, bc                                    ; $2877
    pop bc                                        ; $2878
    dec c                                         ; $2879
    jr nz, jr_000_281e                            ; $287A

    pop hl                                        ; $287C
    push bc                                       ; $287D
    ld bc, $0004                                  ; $287E
    add hl, bc                                    ; $2881
    pop bc                                        ; $2882
    dec b                                         ; $2883
    jr nz, jr_000_281b                            ; $2884

    ld bc, $0038                                  ; $2886
    add hl, bc                                    ; $2889
    pop bc                                        ; $288A
    dec c                                         ; $288B
    jp nz, Img_ReduceHalfTo224Wide_RowLoop        ; $288C

    pop af                                        ; $288F
    jr nc, jr_000_2898                            ; $2890

    pop af                                        ; $2892
    ldh [hRomBankShadow], a                       ; $2893
    ld [$2000], a                                 ; $2895

jr_000_2898:
    pop hl                                        ; $2898
    pop de                                        ; $2899
    pop bc                                        ; $289A
    ret                                           ; $289B


; C: maps the nibbles of two bytes through the 16-entry table at 00:36F0 -> $D000 / $D001
Img_CombineNibbleMap::
    push bc                                       ; $289C
    push hl                                       ; $289D
    ld a, [de]                                    ; $289E
    and $0f                                       ; $289F
    add $f0                                       ; $28A1
    ld l, a                                       ; $28A3
    ld h, $36                                     ; $28A4
    ld a, [hl]                                    ; $28A6
    ld c, a                                       ; $28A7
    ld a, [de]                                    ; $28A8
    swap a                                        ; $28A9
    and $0f                                       ; $28AB
    add $f0                                       ; $28AD
    ld l, a                                       ; $28AF
    ld h, $36                                     ; $28B0
    ld b, [hl]                                    ; $28B2
    inc de                                        ; $28B3
    ld a, [de]                                    ; $28B4
    and $0f                                       ; $28B5
    add $f0                                       ; $28B7
    ld l, a                                       ; $28B9
    ld h, $36                                     ; $28BA
    ld a, [hl]                                    ; $28BC
    sla a                                         ; $28BD
    add c                                         ; $28BF
    ld [wReducerResult], a                        ; $28C0
    ld a, [de]                                    ; $28C3
    swap a                                        ; $28C4
    and $0f                                       ; $28C6
    add $f0                                       ; $28C8
    ld l, a                                       ; $28CA
    ld h, $36                                     ; $28CB
    ld a, [hl]                                    ; $28CD
    sla a                                         ; $28CE
    add b                                         ; $28D0
    ld [wReducerResult + $1], a                   ; $28D1
    inc de                                        ; $28D4
    pop hl                                        ; $28D5
    pop bc                                        ; $28D6
    ret                                           ; $28D7


; C: adds 2 and keeps 2-bit level planes of an 8x2 block. L3 pass 2026-10-26: executed in BGB in 19 replay(s) of the
; organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Img_QuantizeBlockRound::
    push de                                       ; $28D8
    ld de, $000c                                  ; $28D9
    ld bc, $0000                                  ; $28DC
    ld a, $02                                     ; $28DF

jr_000_28e1:
    push af                                       ; $28E1
    ld a, [hl+]                                   ; $28E2
    add $02                                       ; $28E3
    srl a                                         ; $28E5
    srl a                                         ; $28E7
    srl a                                         ; $28E9
    rl c                                          ; $28EB
    srl a                                         ; $28ED
    rl b                                          ; $28EF
    ld a, [hl+]                                   ; $28F1
    add $02                                       ; $28F2
    srl a                                         ; $28F4
    srl a                                         ; $28F6
    srl a                                         ; $28F8
    rl c                                          ; $28FA
    srl a                                         ; $28FC
    rl b                                          ; $28FE
    ld a, [hl+]                                   ; $2900
    add $02                                       ; $2901
    srl a                                         ; $2903
    srl a                                         ; $2905
    srl a                                         ; $2907
    rl c                                          ; $2909
    srl a                                         ; $290B
    rl b                                          ; $290D
    ld a, [hl+]                                   ; $290F
    add $02                                       ; $2910
    srl a                                         ; $2912
    srl a                                         ; $2914
    srl a                                         ; $2916
    rl c                                          ; $2918
    srl a                                         ; $291A
    rl b                                          ; $291C
    add hl, de                                    ; $291E
    pop af                                        ; $291F
    dec a                                         ; $2920
    jr nz, jr_000_28e1                            ; $2921

    pop de                                        ; $2923
    ret                                           ; $2924


; C: same with the dither offsets D / E. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus,
; modes 12 1E (tcrf_check/assets/l3_names/)
Img_QuantizeBlockDither::
    ld bc, $0000                                  ; $2925
    ld a, $02                                     ; $2928

jr_000_292a:
    push af                                       ; $292A
    ld a, [hl+]                                   ; $292B
    add d                                         ; $292C
    srl a                                         ; $292D
    srl a                                         ; $292F
    srl a                                         ; $2931
    rl c                                          ; $2933
    srl a                                         ; $2935
    rl b                                          ; $2937
    ld a, [hl+]                                   ; $2939
    add e                                         ; $293A
    srl a                                         ; $293B
    srl a                                         ; $293D
    srl a                                         ; $293F
    rl c                                          ; $2941
    srl a                                         ; $2943
    rl b                                          ; $2945
    ld a, [hl+]                                   ; $2947
    add d                                         ; $2948
    srl a                                         ; $2949
    srl a                                         ; $294B
    srl a                                         ; $294D
    rl c                                          ; $294F
    srl a                                         ; $2951
    rl b                                          ; $2953
    ld a, [hl+]                                   ; $2955
    add e                                         ; $2956
    srl a                                         ; $2957
    srl a                                         ; $2959
    srl a                                         ; $295B
    rl c                                          ; $295D
    srl a                                         ; $295F
    rl b                                          ; $2961
    ld a, l                                       ; $2963
    add $0c                                       ; $2964
    ld l, a                                       ; $2966
    jr nc, jr_000_296a                            ; $2967

    inc h                                         ; $2969

jr_000_296a:
    pop af                                        ; $296A
    dec a                                         ; $296B
    jr nz, jr_000_292a                            ; $296C

    ret                                           ; $296E


; C: draws the thumbnail frame and the bottom line at pixel row 27. L3 pass 2026-10-26: executed in BGB in 3 replay(s)
; of the organic corpus, modes 10 14 (tcrf_check/assets/l3_names/)
Thumb_DrawFrame::
    push bc                                       ; $296F
    push de                                       ; $2970
    push hl                                       ; $2971
    ld de, $0000                                  ; $2972
    bit 0, a                                      ; $2975
    jr z, jr_000_297b                             ; $2977

    ld e, $ff                                     ; $2979

jr_000_297b:
    bit 1, a                                      ; $297B
    jr z, jr_000_2981                             ; $297D

    ld d, $ff                                     ; $297F

jr_000_2981:
    push hl                                       ; $2981
    ld bc, $000f                                  ; $2982
    ld a, $04                                     ; $2985

jr_000_2987:
    ld [hl], e                                    ; $2987
    inc hl                                        ; $2988
    ld [hl], d                                    ; $2989
    add hl, bc                                    ; $298A
    dec a                                         ; $298B
    jr nz, jr_000_2987                            ; $298C

    ld bc, $0086                                  ; $298E
    add hl, bc                                    ; $2991
    ld bc, $000f                                  ; $2992
    ld a, $04                                     ; $2995

jr_000_2997:
    ld [hl], e                                    ; $2997
    inc hl                                        ; $2998
    ld [hl], d                                    ; $2999
    add hl, bc                                    ; $299A
    dec a                                         ; $299B
    jr nz, jr_000_2997                            ; $299C

    pop hl                                        ; $299E
    push de                                       ; $299F
    push hl                                       ; $29A0
    ld a, e                                       ; $29A1
    and $80                                       ; $29A2
    ld e, a                                       ; $29A4
    ld a, d                                       ; $29A5
    and $80                                       ; $29A6
    ld d, a                                       ; $29A8
    ld b, $04                                     ; $29A9

jr_000_29ab:
    push bc                                       ; $29AB
    ld c, $08                                     ; $29AC
    dec b                                         ; $29AE
    jr nz, jr_000_29b3                            ; $29AF

    ld c, $04                                     ; $29B1

jr_000_29b3:
    ld a, [hl]                                    ; $29B3
    and $7f                                       ; $29B4
    or e                                          ; $29B6
    ld [hl+], a                                   ; $29B7
    ld a, [hl]                                    ; $29B8
    and $7f                                       ; $29B9
    or d                                          ; $29BB
    ld [hl+], a                                   ; $29BC
    dec c                                         ; $29BD
    jr nz, jr_000_29b3                            ; $29BE

    ld bc, $0030                                  ; $29C0
    add hl, bc                                    ; $29C3
    pop bc                                        ; $29C4
    dec b                                         ; $29C5
    jr nz, jr_000_29ab                            ; $29C6

    pop hl                                        ; $29C8
    pop de                                        ; $29C9
    ld bc, $0030                                  ; $29CA
    add hl, bc                                    ; $29CD
    ld a, e                                       ; $29CE
    and $01                                       ; $29CF
    ld e, a                                       ; $29D1
    ld a, d                                       ; $29D2
    and $01                                       ; $29D3
    ld d, a                                       ; $29D5
    ld b, $04                                     ; $29D6

jr_000_29d8:
    push bc                                       ; $29D8
    ld c, $08                                     ; $29D9
    dec b                                         ; $29DB
    jr nz, jr_000_29e0                            ; $29DC

    ld c, $04                                     ; $29DE

jr_000_29e0:
    ld a, [hl]                                    ; $29E0
    and $fe                                       ; $29E1
    or e                                          ; $29E3
    ld [hl+], a                                   ; $29E4
    ld a, [hl]                                    ; $29E5
    and $fe                                       ; $29E6
    or d                                          ; $29E8
    ld [hl+], a                                   ; $29E9
    dec c                                         ; $29EA
    jr nz, jr_000_29e0                            ; $29EB

    ld bc, $0030                                  ; $29ED
    add hl, bc                                    ; $29F0
    pop bc                                        ; $29F1
    dec b                                         ; $29F2
    jr nz, jr_000_29d8                            ; $29F3

    pop hl                                        ; $29F5
    pop de                                        ; $29F6
    pop bc                                        ; $29F7
    ret                                           ; $29F8


; C: 6 records {row byte offset, OR mask, XOR mask}: for the two bytes at DE+offset sets bits 7-2 to (b OR $FC) XOR
; mask, which draws a white C cut out of a black 6 x 6 block on tile rows 1-6 of the tile at D:E (D = $CE from
; 02:47FE); only called when the work-buffer copy flag $CF33 is not 0 (album ...
Thumb_DrawCopyBadge::
    ld hl, Thumb_CopyBadgeTbl                     ; $29F9
    ld b, $06                                     ; $29FC

jr_000_29fe:
    ld e, [hl]                                    ; $29FE
    inc hl                                        ; $29FF
    ld a, [de]                                    ; $2A00
    or [hl]                                       ; $2A01
    inc hl                                        ; $2A02
    xor [hl]                                      ; $2A03
    ld [de], a                                    ; $2A04
    inc de                                        ; $2A05
    dec hl                                        ; $2A06
    ld a, [de]                                    ; $2A07
    or [hl]                                       ; $2A08
    inc hl                                        ; $2A09
    xor [hl]                                      ; $2A0A
    ld [de], a                                    ; $2A0B
    inc hl                                        ; $2A0C
    dec b                                         ; $2A0D
    jr nz, jr_000_29fe                            ; $2A0E

    ret                                           ; $2A10


; C: 6 x 3 bytes {offset, OR mask $FC, XOR mask}: 02 FC 30 / 04 FC 48 / 06 FC 40 / 08 FC 48 / 0A FC 30 / 0C FC 00 =
; the rows of the copy badge
Thumb_CopyBadgeTbl::
    db $02, $fc, $30, $04, $fc, $48, $06, $fc, $40, $08, $fc, $48, $0a, $fc, $30, $0c
    db $fc, $00

; C: calls 1F:7FF6 (sound init) from bank 0. L3 pass 2026-10-26: executed in BGB in 204 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Snd_Init_Tramp::
    ldh a, [hRomBankShadow]                       ; $2A23
    push af                                       ; $2A25
    ld a, $1f                                     ; $2A26
    ldh [hRomBankShadow], a                       ; $2A28
    ld [$2000], a                                 ; $2A2A
    call $7ff6                                    ; $2A2D
    pop af                                        ; $2A30
    ldh [hRomBankShadow], a                       ; $2A31
    ld [$2000], a                                 ; $2A33
    ret                                           ; $2A36


; C: calls the sound tick 1F:7FF0 from the timer-or-frame hook 00:0333
Snd_Tick_Tramp::
    ldh a, [hRomBankShadow]                       ; $2A37
    push af                                       ; $2A39
    ld a, $1f                                     ; $2A3A
    ldh [hRomBankShadow], a                       ; $2A3C
    ld [$2000], a                                 ; $2A3E
    call $7ff0                                    ; $2A41
    pop af                                        ; $2A44
    ldh [hRomBankShadow], a                       ; $2A45
    ld [$2000], a                                 ; $2A47
    ret                                           ; $2A4A


; C: HL = list of {sound
Snd_PlayFromList::
    push bc                                       ; $2A4B
    sla a                                         ; $2A4C
    ld c, a                                       ; $2A4E
    ld b, $00                                     ; $2A4F
    add hl, bc                                    ; $2A51
    inc hl                                        ; $2A52
    ld a, [hl-]                                   ; $2A53
    cp $01                                        ; $2A54
    jr nz, jr_000_2a5e                            ; $2A56

    ld a, [hl]                                    ; $2A58
    ld [wSndSfx1], a                              ; $2A59
    pop bc                                        ; $2A5C
    ret                                           ; $2A5D


jr_000_2a5e:
    cp $02                                        ; $2A5E
    jr nz, jr_000_2a68                            ; $2A60

    ld a, [hl]                                    ; $2A62
    ld [wSndMusicReq], a                          ; $2A63
    pop bc                                        ; $2A66
    ret                                           ; $2A67


jr_000_2a68:
    cp $03                                        ; $2A68
    jr nz, jr_000_2a72                            ; $2A6A

    ld a, [hl]                                    ; $2A6C
    ld [wSndSfx3], a                              ; $2A6D
    pop bc                                        ; $2A70
    ret                                           ; $2A71


jr_000_2a72:
    cp $04                                        ; $2A72
    jr nz, jr_000_2a7a                            ; $2A74

    ld a, [hl]                                    ; $2A76
    ld [wSndSfx4], a                              ; $2A77

jr_000_2a7a:
    pop bc                                        ; $2A7A
    ret                                           ; $2A7B


; C: A -> $DD60 (channel 1 effect)
Snd_Sfx1::
    ld [wSndSfx1], a                              ; $2A7C
    ret                                           ; $2A7F


; C: A -> $DD70 (channel 3 effect)
Snd_Sfx3::
    ld [wSndSfx3], a                              ; $2A80
    ret                                           ; $2A83


; C: A -> $DD78 (channel 4 effect)
Snd_Sfx4::
    ld [wSndSfx4], a                              ; $2A84
    ret                                           ; $2A87


; C: A -> $DD68 (song / jingle request)
Snd_Music::
    ld [wSndMusicReq], a                          ; $2A88
    ret                                           ; $2A8B


; C: plays a blip for each held key (menus of bank 06)
Snd_KeyBlips::
    push af                                       ; $2A8C
    ldh a, [hKeysHeld]                            ; $2A8D
    bit PADB_A, a                                 ; $2A8F
    jr z, jr_000_2a9a                             ; $2A91

    push af                                       ; $2A93
    ld a, SFX1_KEY_A                              ; $2A94
    call Snd_Sfx1                                 ; $2A96
    pop af                                        ; $2A99

jr_000_2a9a:
    bit 1, a                                      ; $2A9A
    jr z, jr_000_2aa5                             ; $2A9C

    push af                                       ; $2A9E
    ld a, SFX1_KEY_B                              ; $2A9F
    call Snd_Sfx1                                 ; $2AA1
    pop af                                        ; $2AA4

jr_000_2aa5:
    bit 5, a                                      ; $2AA5
    jr z, jr_000_2ab0                             ; $2AA7

    push af                                       ; $2AA9
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $2AAA
    call Snd_Sfx1                                 ; $2AAC
    pop af                                        ; $2AAF

jr_000_2ab0:
    bit 4, a                                      ; $2AB0
    jr z, jr_000_2abb                             ; $2AB2

    push af                                       ; $2AB4
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $2AB5
    call Snd_Sfx1                                 ; $2AB7
    pop af                                        ; $2ABA

jr_000_2abb:
    bit 6, a                                      ; $2ABB
    jr z, jr_000_2ac6                             ; $2ABD

    push af                                       ; $2ABF
    ld a, SFX1_KEY_UP_DOWN                        ; $2AC0
    call Snd_Sfx1                                 ; $2AC2
    pop af                                        ; $2AC5

jr_000_2ac6:
    bit 7, a                                      ; $2AC6
    jr z, jr_000_2ad1                             ; $2AC8

    push af                                       ; $2ACA
    ld a, SFX1_KEY_UP_DOWN                        ; $2ACB
    call Snd_Sfx1                                 ; $2ACD
    pop af                                        ; $2AD0

jr_000_2ad1:
    bit 3, a                                      ; $2AD1
    jr z, jr_000_2adc                             ; $2AD3

    push af                                       ; $2AD5
    ld a, SFX1_KEY_START                          ; $2AD6
    call Snd_Sfx1                                 ; $2AD8
    pop af                                        ; $2ADB

jr_000_2adc:
    bit 2, a                                      ; $2ADC
    jr z, jr_000_2ae7                             ; $2ADE

    push af                                       ; $2AE0
    ld a, SFX1_KEY_SELECT                         ; $2AE1
    call Snd_Sfx1                                 ; $2AE3
    pop af                                        ; $2AE6

jr_000_2ae7:
    pop af                                        ; $2AE7
    ret                                           ; $2AE8


; C: serial interrupt handler of the camera link (stages: hello / info / command / data)
Link_SerialIrq::
    push af                                       ; $2AE9
    push bc                                       ; $2AEA
    push de                                       ; $2AEB
    push hl                                       ; $2AEC
    ld a, [wLnkConnected]                         ; $2AED
    and a                                         ; $2AF0
    jp nz, Link_Irq_Connected                     ; $2AF1

    ld a, [wLnkStage]                             ; $2AF4
    and a                                         ; $2AF7
    jr nz, Link_Irq_InfoStage                     ; $2AF8

    ldh a, [rSB]                                  ; $2AFA
    cp $12                                        ; $2AFC
    jr z, jr_000_2b25                             ; $2AFE

    cp $55                                        ; $2B00
    jr z, jr_000_2b20                             ; $2B02

    cp $29                                        ; $2B04
    jr nz, jr_000_2b0e                            ; $2B06

    ld a, [wLnkInitiator]                         ; $2B08
    and a                                         ; $2B0B
    jr z, jr_000_2b2d                             ; $2B0C

jr_000_2b0e:
    xor a                                         ; $2B0E
    ld [wLnkTurn], a                              ; $2B0F
    ld [wLnkInitiator], a                         ; $2B12
    ld a, $12                                     ; $2B15
    ldh [rSB], a                                  ; $2B17
    ld a, SCF_START                               ; $2B19
    ldh [rSC], a                                  ; $2B1B
    jp Link_Irq_Exit                              ; $2B1D


jr_000_2b20:
    ld a, $01                                     ; $2B20
    ld [wLnkFlag55], a                            ; $2B22

jr_000_2b25:
    ld a, $01                                     ; $2B25
    ld [wLnkInitiator], a                         ; $2B27
    ld [wLnkTurn], a                              ; $2B2A

jr_000_2b2d:
    ld a, $01                                     ; $2B2D
    ld [wLnkStage], a                             ; $2B2F
    ld a, [wLnkInfoTx]                            ; $2B32
    ldh [rSB], a                                  ; $2B35
    jp Link_Irq_StartTimer                        ; $2B37


; C: stage 0 byte after the hello: role decision from the info bytes
Link_Irq_InfoStage::
    ldh a, [rSB]                                  ; $2B3A
    ld [wLnkInfoRx], a                            ; $2B3C
    and $1f                                       ; $2B3F
    ld [wLnkPeerCount], a                         ; $2B41
    ld a, $01                                     ; $2B44
    ld [wLnkRoleRx], a                            ; $2B46
    ld a, [wLnkInitiator]                         ; $2B49
    and a                                         ; $2B4C
    jr nz, jr_000_2b5c                            ; $2B4D

    ld a, [wLnkInfoRx]                            ; $2B4F
    and $80                                       ; $2B52
    jr z, jr_000_2b63                             ; $2B54

    xor a                                         ; $2B56
    ld [wLnkRoleRx], a                            ; $2B57
    jr jr_000_2b82                                ; $2B5A

jr_000_2b5c:
    ld a, [wLnkOwnCount]                          ; $2B5C
    and $80                                       ; $2B5F
    jr z, jr_000_2b82                             ; $2B61

jr_000_2b63:
    ld a, [wLnkPeerCount]                         ; $2B63
    and $3f                                       ; $2B66
    jr z, jr_000_2b7a                             ; $2B68

    ld a, [wLnkInfoTx]                            ; $2B6A
    and $40                                       ; $2B6D
    and a                                         ; $2B6F
    jr z, jr_000_2ba4                             ; $2B70

    ld a, $01                                     ; $2B72
    ld [wLnkAbortReason], a                       ; $2B74
    jp Link_Irq_Abort                             ; $2B77


jr_000_2b7a:
    ld a, $03                                     ; $2B7A
    ld [wLnkAbortReason], a                       ; $2B7C
    jp Link_Irq_Abort                             ; $2B7F


jr_000_2b82:
    xor a                                         ; $2B82
    ld [wLnkRoleRx], a                            ; $2B83
    ld a, [wLnkOwnCount]                          ; $2B86
    and $3f                                       ; $2B89
    jr z, jr_000_2b9c                             ; $2B8B

    ld a, [wLnkInfoRx]                            ; $2B8D
    and $40                                       ; $2B90
    jr z, jr_000_2ba4                             ; $2B92

    ld a, $02                                     ; $2B94
    ld [wLnkAbortReason], a                       ; $2B96
    jp Link_Irq_Abort                             ; $2B99


jr_000_2b9c:
    ld a, $04                                     ; $2B9C
    ld [wLnkAbortReason], a                       ; $2B9E
    jp Link_Irq_Abort                             ; $2BA1


jr_000_2ba4:
    ld a, $01                                     ; $2BA4
    ld [wLnkConnected], a                         ; $2BA6
    xor a                                         ; $2BA9
    ld [wLnkEnded], a                             ; $2BAA
    ldh [rSB], a                                  ; $2BAD
    ld a, $ff                                     ; $2BAF
    ld [wLnkIndex], a                             ; $2BB1
    ld [wLnkIndex + $1], a                        ; $2BB4
    ld a, SCF_START                               ; $2BB7
    ldh [rSC], a                                  ; $2BB9
    ld a, [wLnkTurn]                              ; $2BBB
    xor $01                                       ; $2BBE
    ld [wLnkTurn], a                              ; $2BC0
    jp Link_Irq_Exit                              ; $2BC3


; C: connected: bulk data / sync exchange. L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:08,
; link_exchange 0E:0B, link_exchange 0E:10, link_exchange 0E:12 (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_Irq_Connected::
    ld a, [wLnkStage]                             ; $2BC6
    and a                                         ; $2BC9
    jp z, Link_Irq_BulkData                       ; $2BCA

    inc a                                         ; $2BCD
    ld [wLnkStage], a                             ; $2BCE
    cp $03                                        ; $2BD1
    jr z, jr_000_2c21                             ; $2BD3

    cp $04                                        ; $2BD5
    jr z, jr_000_2bec                             ; $2BD7

    ld a, [wLnkCmdTx]                             ; $2BD9
    cp $ef                                        ; $2BDC
    jr nz, jr_000_2be3                            ; $2BDE

    ld [wLnkCancelSent], a                        ; $2BE0

jr_000_2be3:
    ldh [rSB], a                                  ; $2BE3
    xor a                                         ; $2BE5
    ld [wLnkHalfDone], a                          ; $2BE6
    jp Link_Irq_StartTimer                        ; $2BE9


jr_000_2bec:
    dec a                                         ; $2BEC
    ld [wLnkStage], a                             ; $2BED
    ld a, [wLnkReadySent]                         ; $2BF0
    and a                                         ; $2BF3
    jr z, jr_000_2bf8                             ; $2BF4

    jr jr_000_2bfd                                ; $2BF6

jr_000_2bf8:
    ldh a, [rSB]                                  ; $2BF8
    and a                                         ; $2BFA
    jr z, jr_000_2c10                             ; $2BFB

jr_000_2bfd:
    cp $ef                                        ; $2BFD
    ld a, $00                                     ; $2BFF
    ld [wLnkStage], a                             ; $2C01
    ld [wLnkReadySent], a                         ; $2C04
    ld [wLnkReadyTx], a                           ; $2C07
    jp z, Link_Irq_HalfDone                       ; $2C0A

    jp Link_Irq_StartTimer                        ; $2C0D


jr_000_2c10:
    ld a, [wLnkReadyTx]                           ; $2C10
    and a                                         ; $2C13
    jr z, jr_000_2c19                             ; $2C14

    ld [wLnkReadySent], a                         ; $2C16

jr_000_2c19:
    ld a, [wLnkReadyTx]                           ; $2C19
    ldh [rSB], a                                  ; $2C1C
    jp Link_Irq_StartTimer                        ; $2C1E


jr_000_2c21:
    ldh a, [rSB]                                  ; $2C21
    ld [wLnkCmdRx], a                             ; $2C23
    cp $ef                                        ; $2C26
    ld a, $00                                     ; $2C28
    jp z, Link_Irq_Abort_ClearState               ; $2C2A

    ld a, [wLnkCancelSent]                        ; $2C2D
    and a                                         ; $2C30
    jr z, jr_000_2c3b                             ; $2C31

    ld [wLnkCmdRx], a                             ; $2C33
    ld a, $00                                     ; $2C36
    jp Link_Irq_Abort_ClearState                  ; $2C38


jr_000_2c3b:
    xor a                                         ; $2C3B
    ldh [rSB], a                                  ; $2C3C
    ld a, [wLnkInitiator]                         ; $2C3E
    and a                                         ; $2C41
    jr z, jr_000_2c6b                             ; $2C42

    ld a, [wLnkCmdTx]                             ; $2C44
    and $80                                       ; $2C47
    jr z, jr_000_2c5b                             ; $2C49

    ld a, $08                                     ; $2C4B
    ld [wLnkPages], a                             ; $2C4D
    ld a, [wLnkCmdRx]                             ; $2C50
    and $3f                                       ; $2C53
    ld [wLnkSlot], a                              ; $2C55
    jp Link_Irq_StartTimer                        ; $2C58


jr_000_2c5b:
    ld a, $10                                     ; $2C5B
    ld [wLnkPages], a                             ; $2C5D
    ld a, [wLnkCmdRx]                             ; $2C60
    and $3f                                       ; $2C63
    ld [wLnkSlot], a                              ; $2C65
    jp Link_Irq_StartTimer                        ; $2C68


jr_000_2c6b:
    ld a, [wLnkCmdRx]                             ; $2C6B
    ld b, a                                       ; $2C6E
    and $80                                       ; $2C6F
    jr z, jr_000_2c7a                             ; $2C71

    ld a, $08                                     ; $2C73
    ld [wLnkPages], a                             ; $2C75
    jr jr_000_2c7f                                ; $2C78

jr_000_2c7a:
    ld a, $10                                     ; $2C7A
    ld [wLnkPages], a                             ; $2C7C

jr_000_2c7f:
    ld a, b                                       ; $2C7F
    and $3f                                       ; $2C80
    ld [wLnkSlot], a                              ; $2C82
    jp Link_Irq_StartTimer                        ; $2C85


; C: bulk transfer: stores each received byte at [DC48:DC49] + index
Link_Irq_BulkData::
    ld a, [wLnkRxBase]                            ; $2C88
    ld h, a                                       ; $2C8B
    ld a, [wLnkRxBase + $1]                       ; $2C8C
    ld l, a                                       ; $2C8F
    ld a, [wLnkIndex + $1]                        ; $2C90
    ld e, a                                       ; $2C93
    ld a, [wLnkIndex]                             ; $2C94
    ld d, a                                       ; $2C97
    cp $ff                                        ; $2C98
    jr z, jr_000_2ca0                             ; $2C9A

    add hl, de                                    ; $2C9C
    ldh a, [rSB]                                  ; $2C9D
    ld [hl], a                                    ; $2C9F

jr_000_2ca0:
    inc de                                        ; $2CA0
    ld a, [wLnkTxBase]                            ; $2CA1
    ld h, a                                       ; $2CA4
    ld a, [wLnkTxBase + $1]                       ; $2CA5
    ld l, a                                       ; $2CA8
    add hl, de                                    ; $2CA9
    ld a, [hl]                                    ; $2CAA
    ldh [rSB], a                                  ; $2CAB
    ld a, d                                       ; $2CAD
    ld [wLnkIndex], a                             ; $2CAE
    ld a, e                                       ; $2CB1
    ld [wLnkIndex + $1], a                        ; $2CB2
    ld a, [wLnkIndex]                             ; $2CB5
    ld b, a                                       ; $2CB8
    ld a, [wLnkPages]                             ; $2CB9
    cp b                                          ; $2CBC
    jp nz, Link_Irq_StartTimer                    ; $2CBD

    ld a, [wLnkPages]                             ; $2CC0
    cp $10                                        ; $2CC3
    jr z, Link_Irq_Abort                          ; $2CC5

; C: end of one direction
Link_Irq_HalfDone::
    xor a                                         ; $2CC7
    ld [wLnkCmdArmed], a                          ; $2CC8
    ld [wLnkPages], a                             ; $2CCB
    ld [wLnkCmdTx], a                             ; $2CCE
    ld [wLnkCmdRx], a                             ; $2CD1
    dec a                                         ; $2CD4
    ld [wLnkIndex], a                             ; $2CD5
    ld [wLnkIndex + $1], a                        ; $2CD8
    ld a, $01                                     ; $2CDB
    ld [wLnkHalfDone], a                          ; $2CDD
    ld [wLnkStage], a                             ; $2CE0
    ld a, SCF_START                               ; $2CE3
    ldh [rSC], a                                  ; $2CE5
    ld a, [wLnkInitiator]                         ; $2CE7
    ld [wLnkTurn], a                              ; $2CEA
    jr Link_Irq_Exit                              ; $2CED

; C: exchange refused or cancelled: reset
Link_Irq_Abort::
    xor a                                         ; $2CEF
    ld [wLnkCmdRx], a                             ; $2CF0

; C: A = 0 on both paths: clears the link state bytes DC43-DC5E and SB/SC, sets DC4C/DC4D = $FF, masks the serial and
; timer interrupts (IE and $F3), DC4E = 1, then Link_Irq_Exit (branch target; code read 2026-10-19)
Link_Irq_Abort_ClearState::
    ld [wLnkConnected], a                         ; $2CF3
    ld [wLnkTurn], a                              ; $2CF6
    ld [wLnkInitiator], a                         ; $2CF9
    ld [wLnkRxBase], a                            ; $2CFC
    ld [wLnkRxBase + $1], a                       ; $2CFF
    ld [wLnkTxBase], a                            ; $2D02
    ld [wLnkTxBase + $1], a                       ; $2D05
    ld [wLnkCmdArmed], a                          ; $2D08
    ld [wLnkCmdTx], a                             ; $2D0B
    ld [wLnkOwnCount], a                          ; $2D0E
    ld [wLnkPeerCount], a                         ; $2D11
    ld [wLnkFlag55], a                            ; $2D14
    ld [wLnkCancelSent], a                        ; $2D17
    ld [wLnkStage], a                             ; $2D1A
    ldh [rSB], a                                  ; $2D1D
    ldh [rSC], a                                  ; $2D1F
    dec a                                         ; $2D21
    ld [wLnkIndex], a                             ; $2D22
    ld [wLnkIndex + $1], a                        ; $2D25
    ldh a, [rIE]                                  ; $2D28
    and $f3                                       ; $2D2A
    ldh [rIE], a                                  ; $2D2C
    ld a, $01                                     ; $2D2E
    ld [wLnkEnded], a                             ; $2D30
    jr Link_Irq_Exit                              ; $2D33

; C: re-arms the timer for the next byte. L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:01,
; link_exchange 0E:08, link_exchange 0E:0B, link_exchange 0E:10 (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_Irq_StartTimer::
    ld a, SCF_START                               ; $2D35
    ldh [rSC], a                                  ; $2D37
    ld a, [wLnkTurn]                              ; $2D39
    xor $01                                       ; $2D3C
    ld [wLnkTurn], a                              ; $2D3E
    ld a, [wLnkTurn]                              ; $2D41
    and a                                         ; $2D44
    jr z, Link_Irq_Exit                           ; $2D45

    ld a, $06                                     ; $2D47
    ldh [rTAC], a                                 ; $2D49

; C: pops and reti
Link_Irq_Exit::
    pop hl                                        ; $2D4B
    pop de                                        ; $2D4C
    pop bc                                        ; $2D4D
    pop af                                        ; $2D4E
    reti                                          ; $2D4F


; C: timer interrupt: restarts the serial transfer as master
Link_TimerIrq::
    push af                                       ; $2D50
    ld a, $02                                     ; $2D51
    ldh [rTAC], a                                 ; $2D53
    ld a, $ee                                     ; $2D55
    ldh [rTIMA], a                                ; $2D57
    ld a, SCF_START | SCF_SOURCE                  ; $2D59
    ldh [rSC], a                                  ; $2D5B
    pop af                                        ; $2D5D
    reti                                          ; $2D5E


; C: reset of the link variables and enable of the serial + timer interrupts
Link_Init::
    ld a, $10                                     ; $2D5F
    ld [wLnkPages], a                             ; $2D61
    ld a, $12                                     ; $2D64
    ldh [rSB], a                                  ; $2D66
    ld a, SCF_START                               ; $2D68
    ldh [rSC], a                                  ; $2D6A
    xor a                                         ; $2D6C
    ld [wLnkTurn], a                              ; $2D6D
    ld [wLnkConnected], a                         ; $2D70
    ld [wLnkInitiator], a                         ; $2D73
    ld [wLnkCmdArmed], a                          ; $2D76
    ld [wLnkIndex], a                             ; $2D79
    ld [wLnkIndex + $1], a                        ; $2D7C
    ld [wLnkEnded], a                             ; $2D7F
    ld [wLnkHalfDone], a                          ; $2D82
    ld [wLnkAbortReason], a                       ; $2D85
    ld [wLnkStage], a                             ; $2D88
    ld [wLnkRoleRx], a                            ; $2D8B
    ld [wLnkAlbumFull], a                         ; $2D8E
    ld [wLnkInfoTx], a                            ; $2D91
    ld [wLnkOwnCount], a                          ; $2D94
    ld [wLnkCmdTx], a                             ; $2D97
    ld [wLnkInfoRx], a                            ; $2D9A
    ld [wLnkPeerCount], a                         ; $2D9D
    ld [wLnkCmdRx], a                             ; $2DA0
    ld [wLnkSlot], a                              ; $2DA3
    ld [wLnkReadyTx], a                           ; $2DA6
    ld [wLnkReadySent], a                         ; $2DA9
    ld [wLnkFlag55], a                            ; $2DAC
    ld [wLnkCancelSent], a                        ; $2DAF
    ld a, $c0                                     ; $2DB2
    ld [wLnkRxBase], a                            ; $2DB4
    ld a, $00                                     ; $2DB7
    ld [wLnkRxBase + $1], a                       ; $2DB9
    ld hl, wLinkBuffer                            ; $2DBC
    ld a, h                                       ; $2DBF
    ld [wLnkTxBase], a                            ; $2DC0
    ld a, l                                       ; $2DC3
    ld [wLnkTxBase + $1], a                       ; $2DC4
    ld a, $ee                                     ; $2DC7
    ldh [rTMA], a                                 ; $2DC9
    ldh [rTIMA], a                                ; $2DCB
    ld a, $02                                     ; $2DCD
    ldh [rTAC], a                                 ; $2DCF
    ldh a, [rIE]                                  ; $2DD1
    or $0c                                        ; $2DD3
    ldh [rIE], a                                  ; $2DD5
    ret                                           ; $2DD7


; C: tear-down; disables the serial + timer interrupts when stage = 0
Link_Stop::
    xor a                                         ; $2DD8
    ldh [rSB], a                                  ; $2DD9
    ld a, [wLnkStage]                             ; $2DDB
    and a                                         ; $2DDE
    ret nz                                        ; $2DDF

    ldh [rSC], a                                  ; $2DE0
    ld [wLnkPages], a                             ; $2DE2
    ldh a, [rIE]                                  ; $2DE5
    and $f3                                       ; $2DE7
    ldh [rIE], a                                  ; $2DE9
    xor a                                         ; $2DEB
    ret                                           ; $2DEC


; C: sends the hello byte $29 as initiator
Link_SendHello29::
    ld a, [wLnkStage]                             ; $2DED
    and a                                         ; $2DF0
    ret nz                                        ; $2DF1

    ld a, [wLnkAlbumFull]                         ; $2DF2
    and a                                         ; $2DF5
    jr z, jr_000_2dfa                             ; $2DF6

    ld a, $40                                     ; $2DF8

jr_000_2dfa:
    ld c, a                                       ; $2DFA
    ld a, [wLnkOwnCount]                          ; $2DFB
    or c                                          ; $2DFE
    ld [wLnkInfoTx], a                            ; $2DFF
    ld a, $29                                     ; $2E02
    ldh [rSB], a                                  ; $2E04
    ld a, SCF_START | SCF_SOURCE                  ; $2E06
    ldh [rSC], a                                  ; $2E08
    ld [wLnkInitiator], a                         ; $2E0A
    ret                                           ; $2E0D


; C: sends the command byte $40 + slot (or the $EF cancel)
Link_QueueCommand::
    ld a, [wLnkInitiator]                         ; $2E0E
    and a                                         ; $2E11
    ret z                                         ; $2E12

    ld a, [wLnkCmdArmed]                          ; $2E13
    and a                                         ; $2E16
    ret nz                                        ; $2E17

    ld a, [wLnkTurn]                              ; $2E18
    and a                                         ; $2E1B
    ret z                                         ; $2E1C

    ld hl, wLinkBuffer                            ; $2E1D
    ld a, h                                       ; $2E20
    ld [wLnkTxBase], a                            ; $2E21
    ld a, l                                       ; $2E24
    ld [wLnkTxBase + $1], a                       ; $2E25
    ld a, [wLnkCmdTx]                             ; $2E28
    cp $ef                                        ; $2E2B
    jr z, jr_000_2e39                             ; $2E2D

    ld a, [wLnkSlot]                              ; $2E2F
    ld b, a                                       ; $2E32
    ld a, $40                                     ; $2E33
    or b                                          ; $2E35
    ld [wLnkCmdTx], a                             ; $2E36

jr_000_2e39:
    ld a, SCF_START | SCF_SOURCE                  ; $2E39
    ldh [rSC], a                                  ; $2E3B
    ld [wLnkCmdArmed], a                          ; $2E3D
    ret                                           ; $2E40


; C: sends the command byte $80 + slot
Link_QueuePageRequest::
    ld a, [wLnkInitiator]                         ; $2E41
    and a                                         ; $2E44
    ret z                                         ; $2E45

    ld a, [wLnkCmdArmed]                          ; $2E46
    and a                                         ; $2E49
    ret nz                                        ; $2E4A

    ld hl, wLinkBuffer                            ; $2E4B
    ld a, h                                       ; $2E4E
    ld [wLnkTxBase], a                            ; $2E4F
    ld a, l                                       ; $2E52
    ld [wLnkTxBase + $1], a                       ; $2E53
    ld a, [wLnkSlot]                              ; $2E56
    ld b, a                                       ; $2E59
    ld a, $80                                     ; $2E5A
    or b                                          ; $2E5C
    ld [wLnkCmdTx], a                             ; $2E5D
    ld a, SCF_START | SCF_SOURCE                  ; $2E60
    ldh [rSC], a                                  ; $2E62
    ld [wLnkCmdArmed], a                          ; $2E64
    ret                                           ; $2E67


; C: ORs own photo count / album-full bits into the info byte
Link_UpdateInfoByte::
    ld a, [wLnkInfoTx]                            ; $2E68
    ld b, a                                       ; $2E6B
    ld a, [wLnkAlbumFull]                         ; $2E6C
    and a                                         ; $2E6F
    jr z, jr_000_2e74                             ; $2E70

    ld a, $40                                     ; $2E72

jr_000_2e74:
    ld c, a                                       ; $2E74
    ld a, [wLnkOwnCount]                          ; $2E75
    or b                                          ; $2E78
    or c                                          ; $2E79
    ld [wLnkInfoTx], a                            ; $2E7A
    ld a, [wLnkConnected]                         ; $2E7D
    and a                                         ; $2E80
    ret                                           ; $2E81


; C: dec bc until zero. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Delay_BC::
    dec bc                                        ; $2E82
    ld a, b                                       ; $2E83
    or c                                          ; $2E84
    jr nz, Unused_Delay_BC                        ; $2E85

    ret                                           ; $2E87


; I: ASCII 'MAIN PASS',0 right after Delay_BC; no immediate load of its address in the trace
Unused_Str_MainPass::
    db "MAIN PASS", $00

; C: far-jumped from the reset code; runs the self-test
Main_Entry::
    ld a, $0b                                     ; $2E92
    ldh [hKeyRepeatDelay], a                      ; $2E94
    ld a, $04                                     ; $2E96
    ldh [hKeyRepeatPeriod], a                     ; $2E98
    ldh [hFarcallAArg], a                         ; $2E9A
    ld a, BANK(Cam_BootSelfTest_Entry)            ; $2E9C
    ld hl, Cam_BootSelfTest_Entry                 ; $2E9E
    call Far_Call                                 ; $2EA1
    ld a, MODE_TITLE_SCREENS                      ; $2EA4
    ld [wMode], a                                 ; $2EA6
    xor a                                         ; $2EA9
    ld [wState], a                                ; $2EAA
    ld [wPhotoIndex], a                           ; $2EAD
    ld hl, wMode1CursorA                          ; $2EB0
    ld b, $21                                     ; $2EB3

jr_000_2eb5:
    ld [hl+], a                                   ; $2EB5
    dec b                                         ; $2EB6
    jr nz, jr_000_2eb5                            ; $2EB7

    ld hl, wCategoryPosB                          ; $2EB9
    ld b, $17                                     ; $2EBC

jr_000_2ebe:
    ld [hl+], a                                   ; $2EBE
    dec b                                         ; $2EBF
    jr nz, jr_000_2ebe                            ; $2EC0

    ld hl, wCompose4Cursor                        ; $2EC2
    ld b, $08                                     ; $2EC5

jr_000_2ec7:
    ld [hl+], a                                   ; $2EC7
    dec b                                         ; $2EC8
    jr nz, jr_000_2ec7                            ; $2EC9

    ld [wShutterSound], a                         ; $2ECB
    ld [wPickMusic], a                            ; $2ECE
    ld [wPickCharacter], a                        ; $2ED1
    ld [wStartPerformerSet], a                    ; $2ED4
    ld [wPickCharacter21], a                      ; $2ED7
    ld [wPlayerMusic], a                          ; $2EDA
    ld [wPlayOptA], a                             ; $2EDD
    ld [wStartTuneSource], a                      ; $2EE0
    ld [wStartFactorySong], a                     ; $2EE3
    ld [wPenPattern], a                           ; $2EE6
    ld [wMenuItem], a                             ; $2EE9
    ld [wMenuUpCol], a                            ; $2EEC
    ld [wMenuSelUpper], a                         ; $2EEF
    ld a, $01                                     ; $2EF2
    ld [wPlayOptB], a                             ; $2EF4
    ld [wPenSpeed], a                             ; $2EF7
    ld [wPenSize], a                              ; $2EFA
    ld a, $ff                                     ; $2EFD
    ld [wBurstPhotos], a                          ; $2EFF
    ld [wBurstPhotos + $1], a                     ; $2F02
    ld [wBurstPhotos + $2], a                     ; $2F05
    ld [wBurstPhotos + $3], a                     ; $2F08
    ld a, BANK(Main_Entry_Tbl5573)                ; $2F0B
    ld hl, Main_Entry_Tbl5573                     ; $2F0D
    ld de, wCategoryPosA                          ; $2F10
    ld bc, $0014                                  ; $2F13
    call Mem_CopyFromBank                         ; $2F16
    ld a, $03                                     ; $2F19
    ld [wPrintMarginLines], a                     ; $2F1B
    ld a, $01                                     ; $2F1E
    ld [wSoftResetEnable], a                      ; $2F20
    ld a, [wPhotoCount]                           ; $2F23
    and a                                         ; $2F26
    jr nz, Main_Loop                              ; $2F27

    xor a                                         ; $2F29
    ld [wPhotoIndex], a                           ; $2F2A

; C: mode dispatcher + OAM hide + sticky keys + wait vblank
Main_Loop::
    call Mode_Dispatch                            ; $2F2D
    call Oam_HideUnused                           ; $2F30
    call Joy_ClearSticky                          ; $2F33
    rst Rst08_WaitVBlank                          ; $2F36
    jr Main_Loop                                  ; $2F37

; C: A = mode; 3-byte entries {lo
Mode_Dispatch::
    ld a, [wMode]                                 ; $2F39
    call Call_InlineTable3                        ; $2F3C

; C: 34 entries of {lo
Mode_Table::
    dw Mode00_MainMenu
    db BANK(Mode00_MainMenu)
    dw Mode01_ShootParlor
    db BANK(Mode01_ShootParlor)
    dw Mode02_ViewMenu
    db BANK(Mode02_ViewMenu)
    dw Mode03_SpecialMenu
    db BANK(Mode03_SpecialMenu)
    dw Mode04_DoodleMenu
    db BANK(Mode04_DoodleMenu)
    dw Mode05_EditMenu
    db BANK(Mode05_EditMenu)
    dw Mode06_LinkMenu
    db BANK(Mode06_LinkMenu)
    dw Mode07_ArcadeSpaceFever
    db BANK(Mode07_ArcadeSpaceFever)
    dw Mode08_UserScreens
    db BANK(Mode08_UserScreens)
    dw Mode09_AlbumEdit
    db BANK(Mode09_AlbumEdit)
    dw Mode0A_AlbumView
    db BANK(Mode0A_AlbumView)
    dw Mode0B_ShowMenu
    db BANK(Mode0B_ShowMenu)
    dw Mode0C_HotSpotViewer
    db BANK(Mode0C_HotSpotViewer)
    dw Mode0D_SlideShow
    db BANK(Mode0D_SlideShow)
    dw Mode0E_LinkTransfer
    db BANK(Mode0E_LinkTransfer)
    dw Mode0F_DeletePhoto
    db BANK(Mode0F_DeletePhoto)
    dw Mode10_Paint
    db BANK(Mode10_Paint)
    dw Mode11_Stamp
    db BANK(Mode11_Stamp)
    dw Mode12_AnimationEditor
    db BANK(Mode12_AnimationEditor)
    dw Mode13_AnimationPlayer
    db BANK(Mode13_AnimationPlayer)
    dw Mode14_ShootLiveView
    db BANK(Mode14_ShootLiveView)
    dw Mode15_SelfTimerInterval
    db BANK(Mode15_SelfTimerInterval)
    dw Mode16_ShutterbugMagic
    db BANK(Mode16_ShutterbugMagic)
    dw Mode17_SplitFusion
    db BANK(Mode17_SplitFusion)
    dw Mode18_PanoramaPrint
    db BANK(Mode18_PanoramaPrint)
    dw Mode19_TitleScreens
    db BANK(Mode19_TitleScreens)
    dw Mode1A_HotSpotEditor
    db BANK(Mode1A_HotSpotEditor)
    dw Mode1B_PrintMenu
    db BANK(Mode1B_PrintMenu)
    dw Mode1C_PrintPhotoPicker
    db BANK(Mode1C_PrintPhotoPicker)
    dw Mode1D_PrintJob
    db BANK(Mode1D_PrintJob)
    dw Mode1E_PrintOption
    db BANK(Mode1E_PrintOption)
    dw Mode1F_DjEditor
    db BANK(Mode1F_DjEditor)
    dw Mode20_Ball
    db BANK(Mode20_Ball)
    dw Mode21_RunRunRun
    db BANK(Mode21_RunRunRun)

; C: 16 signed deltas added to scroll Y per frame for the popup slide (03:43EF). L3 pass 2026-10-26: read in BGB in 91
; replay(s) of the organic corpus, modes 09 0A 12 14 1C (tcrf_check/assets/l3_names/)
Slide_ScyDeltaTbl::
    db $ff, $fa, $f7, $fa, $ff, $03, $04, $03, $00, $ff, $fe, $ff, $00, $00, $01, $00

; C: auto: 48 bytes, bytes; referenced by Mode09_State03_PageLeft, Mode09_State04_PageRight, Mode09_State05_PageUp. L3
; pass 2026-10-26: read in BGB in 66 replay(s) of the organic corpus, modes 09 0A 14 (tcrf_check/assets/l3_names/)
Mode09_State03_PageLeft_Tbl2FB5::
    db $ff, $fa, $f7, $fa, $ff, $03, $04, $03, $00, $ff, $fe, $ff, $00, $00, $01, $00
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00, $00, $04, $04
    db $02, $02, $02, $02, $00, $00, $fd, $fd, $fd, $fd, $fe, $fe, $fe, $fe, $fe, $fe

; C: 36 deltas added to window Y per frame for the window slide (03:5F55). L3 pass 2026-10-26: read in BGB in 25
; replay(s) of the organic corpus, modes 10 11 12 1A (tcrf_check/assets/l3_names/)
Slide_WyDeltaTbl::
    db $18, $16, $0b, $02, $ff, $fd, $fa, $f9, $fa, $ff, $07, $09, $06, $02, $00, $00
    db $ff, $fe, $fe, $ff, $00, $03, $03, $01, $00, $00, $00, $00, $ff, $00, $00, $01
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: print job state machine (the data transfer screen; TV with dancing figures); also called Transferring in the
; README
Mode1D_PrintJob::
    ld a, [wState]                                ; $3015
    rst Rst18_JumpTable                           ; $3018

; C: 12 words for rst $18
Mode1D_StateTable::
    dw Mode1D_State00_Init
    dw Mode1D_State01_LoadScreen
    dw Mode1D_State02_SendInit
    dw Mode1D_State03_BuildBand
    dw Mode1D_State04_SendBand
    dw Mode1D_State05_SendPrint
    dw Mode1D_State06_LoadWaitScreen
    dw Mode1D_State07_WaitPrinted
    dw Mode1D_State08_Exit
    dw Mode1D_State09_Cleanup
    dw Mode1D_State0A_ErrorScreen
    dw Mode1D_State0B_Return

; C: clears the print counters; enables the printer serial handler
Mode1D_State00_Init::
    xor a                                         ; $3031
    ld [wPrintLastPage], a                        ; $3032
    ld [wPrintScriptOff], a                       ; $3035
    ld [wPrintScriptOff + $1], a                  ; $3038
    ld [wPrintPageNo], a                          ; $303B
    ld [wPrintAbortFlag], a                       ; $303E
    ld a, $01                                     ; $3041
    ld [wPrintFirstPage], a                       ; $3043
    ld hl, rIE                                    ; $3046
    set 3, [hl]                                   ; $3049
    ld a, $00                                     ; $304B
    ldh [hSerialHandlerIndex], a                  ; $304D
    ld a, $01                                     ; $304F
    ld [wPrnPollEnable], a                        ; $3051
    ld hl, wState                                 ; $3054
    inc [hl]                                      ; $3057
    ret                                           ; $3058


; C: loads the transfer screen graphics (banks $20 / $25)
Mode1D_State01_LoadScreen::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $3059
    ldh [hLcdcShadow], a                          ; $305B
    ld a, $e4                                     ; $305D
    ld [wPaletteTarget], a                        ; $305F
    ld [wPaletteTarget + $1], a                   ; $3062
    ld [wPaletteTarget + $2], a                   ; $3065
    xor a                                         ; $3068
    ldh [hScxShadow], a                           ; $3069
    ldh [hScyShadow], a                           ; $306B
    ld a, BANK(Gfx_20_7500_Mode1D_State01_LoadScreen); $306D
    ld hl, Gfx_20_7500_Mode1D_State01_LoadScreen  ; $306F
    ld de, $9000                                  ; $3072
    ld bc, $0800                                  ; $3075
    call Mem_CopyFromBank                         ; $3078
    ld a, BANK(Gfx_20_7D00_Mode1D_State01_LoadScreen); $307B
    ld hl, Gfx_20_7D00_Mode1D_State01_LoadScreen  ; $307D
    ld de, $8800                                  ; $3080
    ld bc, $0400                                  ; $3083
    call Mem_CopyFromBank                         ; $3086
    ld a, BANK(Map_25_63E0_Mode1D_State01_LoadScreen); $3089
    ld hl, Map_25_63E0_Mode1D_State01_LoadScreen  ; $308B
    ld de, $9800                                  ; $308E
    ld bc, $0240                                  ; $3091
    call Mem_CopyFromBank                         ; $3094
    call Oam_ClearShadow                          ; $3097
    call Pal_AllWhite                             ; $309A
    call Lcd_On                                   ; $309D
    call Mode1D_DrawTvAnimation                   ; $30A0
    call Pal_FadeIn                               ; $30A3
    ld hl, wState                                 ; $30A6
    inc [hl]                                      ; $30A9
    ret                                           ; $30AA


; C: sends INITIALIZE and checks the device id $81
Mode1D_State02_SendInit::
    call Mode1D_DrawTvAnimation                   ; $30AB
    call Prn_SendInit                             ; $30AE
    cp $f0                                        ; $30B1
    ret z                                         ; $30B3

    cp $ff                                        ; $30B4
    jp z, Mode1D_Abort                            ; $30B6

    ld a, [wPrnDevId]                             ; $30B9
    cp $81                                        ; $30BC
    jp nz, Mode1D_Abort                           ; $30BE

    push af                                       ; $30C1
    ld a, MUSIC_TRANSFER_SEND                     ; $30C2
    call Snd_Music                                ; $30C4
    pop af                                        ; $30C7
    xor a                                         ; $30C8
    ld [wPrintBandNo], a                          ; $30C9
    ld [wPrintLastBand], a                        ; $30CC
    ld [wPrintProgressAcc], a                     ; $30CF
    ld [wPrintProgressAcc + $1], a                ; $30D2
    call Mode1D_LoadProgressStep                  ; $30D5
    ld hl, wState                                 ; $30D8
    inc [hl]                                      ; $30DB
    ret                                           ; $30DC


; C: reads the progress step of the page from the table at 30F9
Mode1D_LoadProgressStep::
    ld a, [wPrintLayoutType]                      ; $30DD
    ld c, a                                       ; $30E0
    ld b, $00                                     ; $30E1
    ld hl, Mode1D_ProgressTbl                     ; $30E3
    add hl, bc                                    ; $30E6
    ld c, [hl]                                    ; $30E7
    add hl, bc                                    ; $30E8
    ld a, [wPrintPageNo]                          ; $30E9
    sla a                                         ; $30EC
    ld c, a                                       ; $30EE
    add hl, bc                                    ; $30EF
    ld a, [hl+]                                   ; $30F0
    ld [wPrintProgressStep], a                    ; $30F1
    ld a, [hl]                                    ; $30F4
    ld [wPrintProgressStep + $1], a               ; $30F5
    ret                                           ; $30F8


; C: per layout offsets then per page progress words
Mode1D_ProgressTbl::
    db $05, $06, $0b, $12, $19, $5b, $00, $11, $01, $75, $00, $a3, $00, $75, $00, $75
    db $00, $75, $00, $75, $00, $66, $00, $66, $00, $66, $00, $66, $00, $5b, $00

; C: copies the band descriptors of the layout and renders the band
Mode1D_State03_BuildBand::
    call Mode1D_DrawTvAnimation                   ; $3118
    ld a, [wPrintLayoutType]                      ; $311B
    sla a                                         ; $311E
    ld c, a                                       ; $3120
    ld b, $00                                     ; $3121
    ld hl, Mode1D_LayoutScriptPtrs                ; $3123
    add hl, bc                                    ; $3126
    ld a, [hl+]                                   ; $3127
    ld h, [hl]                                    ; $3128
    ld l, a                                       ; $3129
    ld a, [wPrintScriptOff]                       ; $312A
    ld c, a                                       ; $312D
    ld a, [wPrintScriptOff + $1]                  ; $312E
    ld b, a                                       ; $3131
    push bc                                       ; $3132
    add hl, bc                                    ; $3133
    ld a, $08                                     ; $3134
    ld de, wPrintBandDesc                         ; $3136
    ld c, $14                                     ; $3139
    call Mode1D_CopyDescriptors                   ; $313B
    pop hl                                        ; $313E
    ld bc, $0050                                  ; $313F
    add hl, bc                                    ; $3142
    ld a, l                                       ; $3143
    ld [wPrintScriptOff], a                       ; $3144
    ld a, h                                       ; $3147
    ld [wPrintScriptOff + $1], a                  ; $3148
    call Mode1D_RenderBand                        ; $314B
    ld hl, wPrintBandNo                           ; $314E
    inc [hl]                                      ; $3151
    ld a, [hl]                                    ; $3152
    cp $09                                        ; $3153
    jr nz, jr_000_315c                            ; $3155

    ld a, $01                                     ; $3157
    ld [wPrintLastBand], a                        ; $3159

jr_000_315c:
    ld hl, wState                                 ; $315C
    inc [hl]                                      ; $315F
    ret                                           ; $3160


; C: renders one band of descriptors to $CF00
Mode1D_RenderBand::
    ld hl, wPrintBandDesc                         ; $3161
    ld de, wSlotTagOwnerCopy                      ; $3164
    ld b, $28                                     ; $3167

jr_000_3169:
    push bc                                       ; $3169
    push hl                                       ; $316A
    push de                                       ; $316B
    ld a, [hl+]                                   ; $316C
    bit 5, [hl]                                   ; $316D
    call z, Mode1D_SplitNibbles                   ; $316F
    call nz, Mode1D_ByteToDE                      ; $3172
    push de                                       ; $3175
    ld a, [hl]                                    ; $3176
    ld b, a                                       ; $3177
    ld hl, wPrintSrcTable                         ; $3178
    call Mode1D_ReadSrcEntry                      ; $317B
    pop hl                                        ; $317E
    add hl, de                                    ; $317F
    pop de                                        ; $3180
    bit 7, b                                      ; $3181
    jr z, jr_000_318c                             ; $3183

    push af                                       ; $3185
    ld a, $01                                     ; $3186
    ld [wPrintLastBand], a                        ; $3188
    pop af                                        ; $318B

jr_000_318c:
    bit 6, b                                      ; $318C
    jr z, jr_000_3197                             ; $318E

    ld c, $04                                     ; $3190
    call Mode1D_FillBlank                         ; $3192
    jr jr_000_31be                                ; $3195

jr_000_3197:
    bit 5, b                                      ; $3197
    jr z, jr_000_31ae                             ; $3199

    push de                                       ; $319B
    call Mode1D_ReadByteFromBank                  ; $319C
    ld a, c                                       ; $319F
    call Mode1D_SplitNibbles                      ; $31A0
    push de                                       ; $31A3
    ld a, b                                       ; $31A4
    ld hl, wPrintSrcTable2                        ; $31A5
    call Mode1D_ReadSrcEntry                      ; $31A8
    pop hl                                        ; $31AB
    add hl, de                                    ; $31AC
    pop de                                        ; $31AD

jr_000_31ae:
    bit 4, b                                      ; $31AE
    jr z, jr_000_31b9                             ; $31B0

    ld c, $04                                     ; $31B2
    call Mode1D_InterleaveTileRows                ; $31B4
    jr jr_000_31be                                ; $31B7

jr_000_31b9:
    ld c, $04                                     ; $31B9
    call Mode1D_CopyDescriptors                   ; $31BB

jr_000_31be:
    bit 3, b                                      ; $31BE
    jr z, jr_000_31c7                             ; $31C0

    ld a, $01                                     ; $31C2
    ld [wPrintLastPage], a                        ; $31C4

jr_000_31c7:
    pop hl                                        ; $31C7
    pop bc                                        ; $31C8
    inc hl                                        ; $31C9
    inc hl                                        ; $31CA
    dec b                                         ; $31CB
    jr nz, jr_000_3169                            ; $31CC

    ret                                           ; $31CE


; C: A -> D (high nibble) and E (low nibble << 4); BGB watchpoint pass 2026-10-25: ran only in mode 1D (1840 hits in 2
; runs: 1D:03 x1840; tcrf_check/assets/mode_state_wp/)
Mode1D_SplitNibbles::
    push af                                       ; $31CF
    swap a                                        ; $31D0
    push af                                       ; $31D2
    and $f0                                       ; $31D3
    ld e, a                                       ; $31D5
    pop af                                        ; $31D6
    and $0f                                       ; $31D7
    ld d, a                                       ; $31D9
    pop af                                        ; $31DA
    ret                                           ; $31DB


; C: A -> DE; BGB watchpoint pass 2026-10-25: ran only in mode 1D (272 hits in 1 runs: 1D:03 x272;
; tcrf_check/assets/mode_state_wp/)
Mode1D_ByteToDE::
    push af                                       ; $31DC
    ld e, a                                       ; $31DD
    ld d, $00                                     ; $31DE
    pop af                                        ; $31E0
    ret                                           ; $31E1


; C: A and 3 selects a 4-byte entry of a source table; returns DE; BGB watchpoint pass 2026-10-25: ran only in mode 1D
; (2112 hits in 2 runs: 1D:03 x2112; tcrf_check/assets/mode_state_wp/)
Mode1D_ReadSrcEntry::
    and $03                                       ; $31E2
    sla a                                         ; $31E4
    sla a                                         ; $31E6
    ld e, a                                       ; $31E8
    ld d, $00                                     ; $31E9
    add hl, de                                    ; $31EB
    ld e, [hl]                                    ; $31EC
    inc hl                                        ; $31ED
    ld d, [hl]                                    ; $31EE
    inc hl                                        ; $31EF
    ld a, [hl]                                    ; $31F0
    ret                                           ; $31F1


; C: reads [HL] of bank A into C; BGB watchpoint pass 2026-10-25: ran only in mode 1D (272 hits in 1 runs: 1D:03 x272;
; tcrf_check/assets/mode_state_wp/)
Mode1D_ReadByteFromBank::
    bit 7, h                                      ; $31F2
    jr nz, jr_000_3205                            ; $31F4

    ldh [hBankTmp], a                             ; $31F6
    ldh a, [hRomBankShadow]                       ; $31F8
    push af                                       ; $31FA
    ldh a, [hBankTmp]                             ; $31FB
    ldh [hRomBankShadow], a                       ; $31FD
    ld [$2000], a                                 ; $31FF
    scf                                           ; $3202
    jr jr_000_3209                                ; $3203

jr_000_3205:
    ld [$4000], a                                 ; $3205
    and a                                         ; $3208

jr_000_3209:
    push af                                       ; $3209
    ld c, [hl]                                    ; $320A
    pop af                                        ; $320B
    ret nc                                        ; $320C

    pop af                                        ; $320D
    ldh [hRomBankShadow], a                       ; $320E
    ld [$2000], a                                 ; $3210
    ret                                           ; $3213


; C: copies C records of 4 bytes from bank A to DE
Mode1D_CopyDescriptors::
    cp $ff                                        ; $3214
    jp z, Mode1D_FillBlank                        ; $3216

    bit 7, h                                      ; $3219
    jr nz, jr_000_322c                            ; $321B

    ldh [hBankTmp], a                             ; $321D
    ldh a, [hRomBankShadow]                       ; $321F
    push af                                       ; $3221
    ldh a, [hBankTmp]                             ; $3222
    ldh [hRomBankShadow], a                       ; $3224
    ld [$2000], a                                 ; $3226
    scf                                           ; $3229
    jr jr_000_3230                                ; $322A

jr_000_322c:
    ld [$4000], a                                 ; $322C
    and a                                         ; $322F

jr_000_3230:
    push af                                       ; $3230

jr_000_3231:
    ld a, [hl+]                                   ; $3231
    ld [de], a                                    ; $3232
    inc de                                        ; $3233
    ld a, [hl+]                                   ; $3234
    ld [de], a                                    ; $3235
    inc de                                        ; $3236
    ld a, [hl+]                                   ; $3237
    ld [de], a                                    ; $3238
    inc de                                        ; $3239
    ld a, [hl+]                                   ; $323A
    ld [de], a                                    ; $323B
    inc de                                        ; $323C
    dec c                                         ; $323D
    jr nz, jr_000_3231                            ; $323E

    pop af                                        ; $3240
    ret nc                                        ; $3241

    pop af                                        ; $3242
    ldh [hRomBankShadow], a                       ; $3243
    ld [$2000], a                                 ; $3245
    ret                                           ; $3248


; C: interleaves bitplanes of a row of 8x8 tiles into the band buffer; called only at 00:31B4 for descriptors whose
; flag byte has bit 4, which only Print_Layout3_FourPhotosRotated (08:656E) has (252 descriptors): the 4-photo
; panorama print of the row pick (wOpt3ToggleB = 0); BGB 2026-10-25 ...
Mode1D_InterleaveTileRows::
    cp $ff                                        ; $3249
    jp z, Mode1D_FillBlank                        ; $324B

    bit 7, h                                      ; $324E
    jr nz, jr_000_3261                            ; $3250

    ldh [hBankTmp], a                             ; $3252
    ldh a, [hRomBankShadow]                       ; $3254
    push af                                       ; $3256
    ldh a, [hBankTmp]                             ; $3257
    ldh [hRomBankShadow], a                       ; $3259
    ld [$2000], a                                 ; $325B
    scf                                           ; $325E
    jr jr_000_3265                                ; $325F

jr_000_3261:
    ld [$4000], a                                 ; $3261
    and a                                         ; $3264

jr_000_3265:
    push af                                       ; $3265
    srl c                                         ; $3266
    srl c                                         ; $3268

jr_000_326a:
    push bc                                       ; $326A
    ld c, $08                                     ; $326B

jr_000_326d:
    ld a, [hl+]                                   ; $326D
    ld b, [hl]                                    ; $326E
    push hl                                       ; $326F
    ld h, d                                       ; $3270
    ld l, e                                       ; $3271
    sla a                                         ; $3272
    rr [hl]                                       ; $3274
    inc hl                                        ; $3276
    sla b                                         ; $3277
    rr [hl]                                       ; $3279
    inc hl                                        ; $327B
    sla a                                         ; $327C
    rr [hl]                                       ; $327E
    inc hl                                        ; $3280
    sla b                                         ; $3281
    rr [hl]                                       ; $3283
    inc hl                                        ; $3285
    sla a                                         ; $3286
    rr [hl]                                       ; $3288
    inc hl                                        ; $328A
    sla b                                         ; $328B
    rr [hl]                                       ; $328D
    inc hl                                        ; $328F
    sla a                                         ; $3290
    rr [hl]                                       ; $3292
    inc hl                                        ; $3294
    sla b                                         ; $3295
    rr [hl]                                       ; $3297
    inc hl                                        ; $3299
    sla a                                         ; $329A
    rr [hl]                                       ; $329C
    inc hl                                        ; $329E
    sla b                                         ; $329F
    rr [hl]                                       ; $32A1
    inc hl                                        ; $32A3
    sla a                                         ; $32A4
    rr [hl]                                       ; $32A6
    inc hl                                        ; $32A8
    sla b                                         ; $32A9
    rr [hl]                                       ; $32AB
    inc hl                                        ; $32AD
    sla a                                         ; $32AE
    rr [hl]                                       ; $32B0
    inc hl                                        ; $32B2
    sla b                                         ; $32B3
    rr [hl]                                       ; $32B5
    inc hl                                        ; $32B7
    sla a                                         ; $32B8
    rr [hl]                                       ; $32BA
    inc hl                                        ; $32BC
    sla b                                         ; $32BD
    rr [hl]                                       ; $32BF
    inc hl                                        ; $32C1
    pop hl                                        ; $32C2
    inc hl                                        ; $32C3
    dec c                                         ; $32C4
    jr nz, jr_000_326d                            ; $32C5

    pop bc                                        ; $32C7
    ld a, e                                       ; $32C8
    add $10                                       ; $32C9
    ld e, a                                       ; $32CB
    jr nc, jr_000_32cf                            ; $32CC

    inc d                                         ; $32CE

jr_000_32cf:
    dec c                                         ; $32CF
    jr nz, jr_000_326a                            ; $32D0

    pop af                                        ; $32D2
    ret nc                                        ; $32D3

    pop af                                        ; $32D4
    ldh [hRomBankShadow], a                       ; $32D5
    ld [$2000], a                                 ; $32D7
    ret                                           ; $32DA


; C: fills the band buffer with zero bytes; BGB watchpoint pass 2026-10-25: ran only in mode 1D (224 hits in 1 runs:
; 1D:03 x224; tcrf_check/assets/mode_state_wp/)
Mode1D_FillBlank::
    xor a                                         ; $32DB

jr_000_32dc:
    ld [de], a                                    ; $32DC
    inc de                                        ; $32DD
    ld [de], a                                    ; $32DE
    inc de                                        ; $32DF
    ld [de], a                                    ; $32E0
    inc de                                        ; $32E1
    ld [de], a                                    ; $32E2
    inc de                                        ; $32E3
    dec c                                         ; $32E4
    jr nz, jr_000_32dc                            ; $32E5

    ret                                           ; $32E7


; C: one word per layout type
Mode1D_LayoutScriptPtrs::
    dw $552e
    dw $57fe
    dw $5cae
    dw $656e
    dw $6f6e

; C: sends the DATA packet of the band
Mode1D_State04_SendBand::
    call Mode1D_DrawTvAnimation                   ; $32F2
    ld a, [wPrintLastBand]                        ; $32F5
    ld [wPrnLastChunk], a                         ; $32F8
    ld hl, wSlotTagOwnerCopy                      ; $32FB
    ld a, $01                                     ; $32FE
    call Prn_SendData                             ; $3300
    cp $ff                                        ; $3303
    jp z, Mode1D_Abort                            ; $3305

    cp $f0                                        ; $3308
    jr nz, jr_000_3317                            ; $330A

    ldh a, [hKeysNew]                             ; $330C
    bit PADB_B, a                                 ; $330E
    jp nz, Mode1D_UserCancel                      ; $3310

    call Mode1D_AdvanceProgress                   ; $3313
    ret                                           ; $3316


jr_000_3317:
    ld a, [wPrintLastBand]                        ; $3317
    and a                                         ; $331A
    jr z, jr_000_3334                             ; $331B

    ld hl, wPrintPageNo                           ; $331D
    inc [hl]                                      ; $3320
    ld a, [wPrintPages]                           ; $3321
    and a                                         ; $3324
    jr z, jr_000_332f                             ; $3325

    cp [hl]                                       ; $3327
    jr nz, jr_000_332f                            ; $3328

    ld a, $01                                     ; $332A
    ld [wPrintLastPage], a                        ; $332C

jr_000_332f:
    ld hl, wState                                 ; $332F
    inc [hl]                                      ; $3332
    ret                                           ; $3333


jr_000_3334:
    ld hl, wState                                 ; $3334
    dec [hl]                                      ; $3337
    ret                                           ; $3338


; C: sends the PRINT command with margin and palette
Mode1D_State05_SendPrint::
    call Mode1D_DrawTvAnimation                   ; $3339
    ld a, $01                                     ; $333C
    ld [wPrnSheets], a                            ; $333E
    ld de, $1003                                  ; $3341
    ld a, [wPrintCustomMargin]                    ; $3344
    and a                                         ; $3347
    jr z, jr_000_3356                             ; $3348

    ld a, [wPrintMarginByte]                      ; $334A
    and $f0                                       ; $334D
    ld d, a                                       ; $334F
    ld a, [wPrintMarginByte]                      ; $3350
    and $0f                                       ; $3353
    ld e, a                                       ; $3355

jr_000_3356:
    ld bc, $0000                                  ; $3356
    ld a, [wPrintFirstPage]                       ; $3359
    and a                                         ; $335C
    jr z, jr_000_3360                             ; $335D

    ld b, d                                       ; $335F

jr_000_3360:
    ld a, [wPrintLastPage]                        ; $3360
    and a                                         ; $3363
    jr z, jr_000_3367                             ; $3364

    ld c, e                                       ; $3366

jr_000_3367:
    ld a, b                                       ; $3367
    or c                                          ; $3368
    ld [wPrnMargin], a                            ; $3369
    ld a, $e4                                     ; $336C
    ld [wPrnPalette], a                           ; $336E
    call Prn_SendPrint                            ; $3371
    cp $ff                                        ; $3374
    jp z, Mode1D_Abort                            ; $3376

    cp $f0                                        ; $3379
    ret z                                         ; $337B

    push af                                       ; $337C
    ld a, MUSIC_TRANSFER_PRINT                    ; $337D
    call Snd_Music                                ; $337F
    pop af                                        ; $3382
    ld hl, wState                                 ; $3383
    inc [hl]                                      ; $3386
    ret                                           ; $3387


; C: waits for the printer then loads the printing screen
Mode1D_State06_LoadWaitScreen::
    ld bc, $000c                                  ; $3388
    call Wait_Frames                              ; $338B
    call Pal_FadeOut                              ; $338E

jr_000_3391:
    rst Rst08_WaitVBlank                          ; $3391
    ld a, [wPrnPollCnt]                           ; $3392
    cp $01                                        ; $3395
    jr nz, jr_000_3391                            ; $3397

    call Lcd_Off                                  ; $3399
    ld a, BANK(Gfx_1B_7100_Mode1D_State06_LoadWaitScreen); $339C
    ld hl, Gfx_1B_7100_Mode1D_State06_LoadWaitScreen; $339E
    ld de, $9000                                  ; $33A1
    ld bc, $0800                                  ; $33A4
    call Mem_CopyFromBank                         ; $33A7
    ld a, BANK(Gfx_1B_7900_Mode1D_State06_LoadWaitScreen); $33AA
    ld hl, Gfx_1B_7900_Mode1D_State06_LoadWaitScreen; $33AC
    ld de, $8800                                  ; $33AF
    ld bc, $0650                                  ; $33B2
    call Mem_CopyFromBank                         ; $33B5
    ld a, BANK(Map_26_5C40_Mode1D_State06_LoadWaitScreen); $33B8
    ld hl, Map_26_5C40_Mode1D_State06_LoadWaitScreen; $33BA
    ld de, $9800                                  ; $33BD
    ld bc, $0240                                  ; $33C0
    call Mem_CopyFromBank                         ; $33C3
    call Lcd_On                                   ; $33C6
    ld a, $04                                     ; $33C9
    ld [wPrnPollCnt], a                           ; $33CB
    call Oam_ClearShadow                          ; $33CE
    call Mode1D_DrawBusyIcon                      ; $33D1
    call Pal_FadeIn                               ; $33D4
    ld hl, wState                                 ; $33D7
    inc [hl]                                      ; $33DA
    ret                                           ; $33DB


; C: polls the status until the page is done
Mode1D_State07_WaitPrinted::
    call Mode1D_DrawBusyIcon                      ; $33DC
    ld a, [wPrnStatus]                            ; $33DF
    ld b, a                                       ; $33E2
    cp $ff                                        ; $33E3
    jr z, Mode1D_Abort                            ; $33E5

    and $f0                                       ; $33E7
    jr nz, Mode1D_Abort                           ; $33E9

    bit 1, b                                      ; $33EB
    ret nz                                        ; $33ED

    ld a, [wPrintLastPage]                        ; $33EE
    and a                                         ; $33F1
    jr nz, jr_000_3404                            ; $33F2

    call Pal_FadeOut                              ; $33F4
    call Lcd_Off                                  ; $33F7
    xor a                                         ; $33FA
    ld [wPrintFirstPage], a                       ; $33FB
    ld a, STATE_1D_LOAD_SCREEN                    ; $33FE
    ld [wState], a                                ; $3400
    ret                                           ; $3403


jr_000_3404:
    call Print_CountPrintedPhoto                  ; $3404
    call Prn_EngineStop                           ; $3407
    ld hl, wState                                 ; $340A
    inc [hl]                                      ; $340D
    ret                                           ; $340E


; C: maps the printer status to the error message
Mode1D_Abort::
    ld a, [wPrnStatus]                            ; $340F
    cp $ff                                        ; $3412
    jr z, jr_000_342e                             ; $3414

    bit 7, a                                      ; $3416
    jr z, jr_000_341e                             ; $3418

    ld a, $00                                     ; $341A
    jr jr_000_343b                                ; $341C

jr_000_341e:
    bit 6, a                                      ; $341E
    jr z, jr_000_3426                             ; $3420

    ld a, $03                                     ; $3422
    jr jr_000_343b                                ; $3424

jr_000_3426:
    bit 5, a                                      ; $3426
    jr z, jr_000_342e                             ; $3428

    ld a, $02                                     ; $342A
    jr jr_000_343b                                ; $342C

jr_000_342e:
    ld a, [wPrnDevId]                             ; $342E
    cp $81                                        ; $3431
    jr z, jr_000_3439                             ; $3433

    ld a, $01                                     ; $3435
    jr jr_000_343b                                ; $3437

jr_000_3439:
    ld a, $01                                     ; $3439

jr_000_343b:
    ld [wResultMsgId], a                          ; $343B
    ld a, $01                                     ; $343E
    ld [wPrintAbortFlag], a                       ; $3440
    call Prn_EngineStop                           ; $3443
    ld a, STATE_1D_CLEANUP                        ; $3446
    ld [wState], a                                ; $3448
    ret                                           ; $344B


; C: B pressed
Mode1D_UserCancel::
    ld a, $01                                     ; $344C
    ld [wPrintAbortFlag], a                       ; $344E
    call Prn_EngineStop                           ; $3451
    ld a, STATE_1D_EXIT                           ; $3454
    ld [wState], a                                ; $3456
    ret                                           ; $3459


; C: fade out and return to the calling mode through 00:3483
Mode1D_State08_Exit::
    call Pal_FadeOut                              ; $345A
    call Lcd_Off                                  ; $345D
    ld hl, rIE                                    ; $3460
    res 3, [hl]                                   ; $3463
    xor a                                         ; $3465
    ld [wPrnPollEnable], a                        ; $3466

; C: sets mode / state from the table at 3483 using DB6E
Mode1D_ReturnToCaller::
    ld a, $01                                     ; $3469
    ld [wAbResult], a                             ; $346B
    ld a, [wPrintReturnIdx]                       ; $346E
    sla a                                         ; $3471
    ld c, a                                       ; $3473
    ld b, $00                                     ; $3474
    ld hl, Mode1D_ReturnTbl                       ; $3476
    add hl, bc                                    ; $3479
    ld a, [hl+]                                   ; $347A
    ld [wMode], a                                 ; $347B
    ld a, [hl]                                    ; $347E
    ld [wState], a                                ; $347F
    ret                                           ; $3482


; C: 5 x {mode
Mode1D_ReturnTbl::
    db MODE_PRINT_PHOTO_PICKER, STATE_1C_PRINT_JOB, MODE_PRINT_PHOTO_PICKER, STATE_1C_PRINT_JOB, MODE_PANORAMA_PRINT, STATE_18_INIT, MODE_PANORAMA_PRINT, STATE_18_INIT, MODE_PRINT_OPTION, STATE_1E_PRINT_JOB

; C: printer error clean-up
Mode1D_State09_Cleanup::
    call Pal_FadeOut                              ; $348D
    call Lcd_Off                                  ; $3490
    ld hl, rIE                                    ; $3493
    res 3, [hl]                                   ; $3496
    xor a                                         ; $3498
    ld [wPrnPollEnable], a                        ; $3499
    xor a                                         ; $349C
    ld [wSubstate], a                             ; $349D
    ld hl, wState                                 ; $34A0
    inc [hl]                                      ; $34A3
    ret                                           ; $34A4


; C: far call 09:7290 (shared result / error screen)
Mode1D_State0A_ErrorScreen::
    ldh [hFarcallAArg], a                         ; $34A5
    ld a, BANK(ResultScreen_Far)                  ; $34A7
    ld hl, ResultScreen_Far                       ; $34A9
    call Far_Call                                 ; $34AC
    ret                                           ; $34AF


; C: jp 3469
Mode1D_State0B_Return::
    jp Mode1D_ReturnToCaller                      ; $34B0


; C: blinking sprite while printing; BGB watchpoint pass 2026-10-25: ran only in mode 1D (246 hits in 2 runs: 1D:06 x3
; 1D:07 x243; tcrf_check/assets/mode_state_wp/)
Mode1D_DrawBusyIcon::
    ldh a, [hFrameCounter]                        ; $34B3
    srl a                                         ; $34B5
    srl a                                         ; $34B7
    srl a                                         ; $34B9
    and $01                                       ; $34BB
    add $aa                                       ; $34BD
    ld bc, $2664                                  ; $34BF
    call Oam_AddMeta_B02_5272                     ; $34C2
    ret                                           ; $34C5


; C: 15 sprite pieces of the TV animation; BGB watchpoint pass 2026-10-25: ran only in mode 1D (2284 hits in 11 runs:
; 1D:01 x30 1D:02 x60 1D:03 x46 1D:04 x2136 1D:05 x12; tcrf_check/assets/mode_state_wp/)
Mode1D_DrawTvAnimation::
    ld hl, Mode1D_TvAnimTbl                       ; $34C6
    ldh a, [hFrameCounter]                        ; $34C9
    sub $04                                       ; $34CB
    swap a                                        ; $34CD
    and $01                                       ; $34CF
    add $f7                                       ; $34D1
    ld e, a                                       ; $34D3
    ldh a, [hFrameCounter]                        ; $34D4
    swap a                                        ; $34D6
    and $01                                       ; $34D8
    add $f7                                       ; $34DA
    ld d, $0f                                     ; $34DC

jr_000_34de:
    push af                                       ; $34DE
    ld c, [hl]                                    ; $34DF
    inc hl                                        ; $34E0
    ld b, [hl]                                    ; $34E1
    inc hl                                        ; $34E2
    ldh [hScratchA], a                            ; $34E3
    ld a, d                                       ; $34E5
    cp $07                                        ; $34E6
    jr nz, jr_000_34ed                            ; $34E8

    ld a, e                                       ; $34EA
    jr jr_000_34ef                                ; $34EB

jr_000_34ed:
    ldh a, [hScratchA]                            ; $34ED

jr_000_34ef:
    call Oam_AddMeta_B01_4000                     ; $34EF
    pop af                                        ; $34F2
    dec d                                         ; $34F3
    jr nz, jr_000_34de                            ; $34F4

    ret                                           ; $34F6


; C: 15 x {x; BGB watchpoint pass 2026-10-25: ran only in mode 1D (33360 hits in 4 runs: 1D:01 x150 1D:02 x300 1D:03
; x690 1D:04 x32040 1D:05 x180; tcrf_check/assets/mode_state_wp/)
Mode1D_TvAnimTbl::
    db $22, $25, $22, $35, $22, $45, $22, $55, $22, $65, $32, $25, $32, $35, $32, $45
    db $32, $55, $32, $65, $42, $25, $42, $35, $42, $45, $42, $55, $42, $65

; C: adds the page progress step and queues the progress-bar tile row (VRAM queue)
Mode1D_AdvanceProgress::
    ld a, [wPrnHdrDone]                           ; $3515
    and a                                         ; $3518
    ret z                                         ; $3519

    ld a, [wPrnDataDone]                          ; $351A
    and a                                         ; $351D
    ret nz                                        ; $351E

    ld hl, wPrintProgressAcc                      ; $351F
    ld de, wPrintProgressStep                     ; $3522
    ld a, [de]                                    ; $3525
    add [hl]                                      ; $3526
    ld [hl+], a                                   ; $3527
    inc de                                        ; $3528
    ld a, [de]                                    ; $3529
    adc [hl]                                      ; $352A
    ld [hl], a                                    ; $352B
    srl a                                         ; $352C
    srl a                                         ; $352E
    srl a                                         ; $3530
    cp $0f                                        ; $3532
    jr c, jr_000_3538                             ; $3534

    ld a, $0f                                     ; $3536

jr_000_3538:
    ld c, a                                       ; $3538
    sla a                                         ; $3539
    sla a                                         ; $353B
    add c                                         ; $353D
    ld c, a                                       ; $353E
    ld b, $00                                     ; $353F
    ld hl, $54de                                  ; $3541
    add hl, bc                                    ; $3544
    ld b, h                                       ; $3545
    ld c, l                                       ; $3546
    ld a, $08                                     ; $3547
    call Vq_Push                                  ; $3549
    ret                                           ; $354C


; C: far calls 02:503F then adds 1 to the printed-photos counter (BCD saturating) and far calls 02:4BB2
Print_CountPrintedPhoto::
    ldh [hFarcallAArg], a                         ; $354D
    ld a, BANK(Counters_Load_Far)                 ; $354F
    ld hl, Counters_Load_Far                      ; $3551
    call Far_Call                                 ; $3554
    ld a, $01                                     ; $3557
    ld hl, wCntPrinted                            ; $3559
    ld b, $02                                     ; $355C
    call Bcd_AddSaturate                          ; $355E
    ldh [hFarcallAArg], a                         ; $3561
    ld a, BANK(Counters_Store_Far)                ; $3563
    ld hl, Counters_Store_Far                     ; $3565
    call Far_Call                                 ; $3568
    ret                                           ; $356B


; C: 388 zero bytes (padding)
Bank00_ZeroFill::
    INCBIN "data/bank_00/Bank00_ZeroFill.bin" ; $356C, 388 bytes
; C: 16 entries: (popcount of bits 3-2) << 4 | popcount of bits 1-0 of the nibble; the old 1 + 15 byte split was a
; typing artefact
Img_NibbleMapTbl::
    db $00, $01, $01, $02, $10, $11, $11, $12, $10, $11, $11, $12, $20, $21, $21, $22

; C: 256 entries; index = pixel pair byte | the false labels at 3780 (ld bc,$3780 of AlbumPage_DrawDown = a sprite
; position) were removed: this table is the whole 3700-37FF
Img_PairLookupTbl::
    INCBIN "data/bank_00/Img_PairLookupTbl.bin" ; $3700, 256 bytes
; C: 8 pages of 256 bytes: page k = source byte shifted for an x offset of k pixels (page 0 = identity) | 2,048 bytes
; = 8 pages of 256 (3800-3FFF); the labels that used to cut it at 3818, 3878, 3910, 3D81, 3E54 and 3F78 were sprite
; positions (`ld bc,$3818` etc. before Oam_AddMeta calls of ...
Blit_ShiftTbl::
    INCBIN "data/bank_00/Blit_ShiftTbl.bin" ; $3800, 2048 bytes

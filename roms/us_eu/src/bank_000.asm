; Game Boy Camera (USA, Europe), bank $00. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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
    db "GAMEBOYCAMERA", $00, $00, $00

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
    db $01

HeaderOldLicenseeCode::
    db $33

HeaderMaskROMVersion::
    db $00

HeaderComplementCheck::
    db $9d

HeaderGlobalChecksum::
    db $ba, $f9

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
    ld [rRAMG], a                                 ; $018C
    ld a, $01                                     ; $018F
    ld [rROMB0], a                                ; $0191
    ld a, $00                                     ; $0194
    ld [rRAMB], a                                 ; $0196
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
    farcall Boot_EraseAllPrompt_Far               ; $0200
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
    ld [rRAMG], a                                 ; $022C
    ld a, $01                                     ; $022F
    ld [rROMB0], a                                ; $0231
    ld a, $00                                     ; $0234
    ld [rRAMB], a                                 ; $0236
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
    farcall Boot_EraseAllPrompt_Far               ; $0293
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
    ld [rRAMG], a                                 ; $030C
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


; I: 8 words
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


; I: 2 words: printer 0F16 / link 2AE9
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
    ld [rROMB0], a                                ; $039C
    ld l, e                                       ; $039F
    ld h, d                                       ; $03A0
    ld de, Call_InlineTable3_Return               ; $03A1
    push de                                       ; $03A4
    jp hl                                         ; $03A5


; C: restores the bank
Call_InlineTable3_Return::
    pop af                                        ; $03A6
    ldh [hRomBankShadow], a                       ; $03A7
    ld [rROMB0], a                                ; $03A9
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


Call_000_0429:
    ldh a, [rLY]                                  ; $0429
    cp $10                                        ; $042B
    jr c, jr_000_0433                             ; $042D

    cp $8e                                        ; $042F
    jr c, jr_000_044b                             ; $0431

jr_000_0433:
    ldh a, [rLY]                                  ; $0433
    cp $10                                        ; $0435
    jr c, jr_000_0433                             ; $0437

    cp $8e                                        ; $0439
    jr nc, jr_000_0433                            ; $043B

jr_000_043d:
    ldh a, [rSTAT]                                ; $043D
    and $03                                       ; $043F
    jr nz, jr_000_043d                            ; $0441

    ld a, $15                                     ; $0443

jr_000_0445:
    dec a                                         ; $0445
    jr nz, jr_000_0445                            ; $0446

    nop                                           ; $0448
    nop                                           ; $0449
    nop                                           ; $044A

jr_000_044b:
    ret                                           ; $044B


; C: fills BC+1 bytes at HL with A
Mem_FillBc1::
    dec bc                                        ; $044C

jr_000_044d:
    ld [hl+], a                                   ; $044D
    dec bc                                        ; $044E
    bit 7, b                                      ; $044F
    jr z, jr_000_044d                             ; $0451

    ret                                           ; $0453


; C: fills BC/2 words at HL with DE
Mem_FillWords::
    srl b                                         ; $0454
    rr c                                          ; $0456

jr_000_0458:
    ld a, e                                       ; $0458
    ld [hl+], a                                   ; $0459
    ld a, d                                       ; $045A
    ld [hl+], a                                   ; $045B
    dec bc                                        ; $045C
    ld a, b                                       ; $045D
    or c                                          ; $045E
    jr nz, jr_000_0458                            ; $045F

    ret                                           ; $0461


; C: clears BC bytes at HL (BC>=1)
Mem_Zero::
    xor a                                         ; $0462
    ld [hl+], a                                   ; $0463
    dec bc                                        ; $0464
    ld a, c                                       ; $0465
    or b                                          ; $0466
    jr nz, Mem_Zero                               ; $0467

    ret                                           ; $0469


; C: HL -> DE BC bytes (BC>=1)
Mem_Copy::
    ld a, [hl+]                                   ; $046A
    ld [de], a                                    ; $046B
    inc de                                        ; $046C
    dec bc                                        ; $046D
    ld a, c                                       ; $046E
    or b                                          ; $046F
    jr nz, Mem_Copy                               ; $0470

    ret                                           ; $0472


; C: A = ROM bank (HL<$8000) or SRAM bank (HL>=$8000); HL -> DE BC bytes
Mem_CopyFromBank::
    bit 7, h                                      ; $0473
    jr nz, jr_000_0486                            ; $0475

    ldh [hBankTmp], a                             ; $0477
    ldh a, [hRomBankShadow]                       ; $0479
    push af                                       ; $047B
    ldh a, [hBankTmp]                             ; $047C
    ldh [hRomBankShadow], a                       ; $047E
    ld [rROMB0], a                                ; $0480
    scf                                           ; $0483
    jr jr_000_048a                                ; $0484

jr_000_0486:
    ld [rRAMB], a                                 ; $0486
    and a                                         ; $0489

jr_000_048a:
    push af                                       ; $048A

jr_000_048b:
    ld a, [hl+]                                   ; $048B
    ld [de], a                                    ; $048C
    inc de                                        ; $048D
    dec bc                                        ; $048E
    ld a, c                                       ; $048F
    or b                                          ; $0490
    jr nz, jr_000_048b                            ; $0491

    pop af                                        ; $0493
    ret nc                                        ; $0494

    pop af                                        ; $0495
    ldh [hRomBankShadow], a                       ; $0496
    ld [rROMB0], a                                ; $0498
    ret                                           ; $049B


; C: LCD off: Mem_CopyFromBank; LCD on: Vram_CopyFromBank
Vram_CopyFromBankAuto::
    push hl                                       ; $049C
    ld hl, $ff40                                  ; $049D
    bit 7, [hl]                                   ; $04A0
    pop hl                                        ; $04A2
    jp z, Mem_CopyFromBank                        ; $04A3

    jp Vram_CopyFromBank                          ; $04A6


; C: copies a 20-tile-wide screen map (HL source, bank in A or SRAM bit; DE = VRAM $98xx) adding C to every tile
; number, 32-tile row stride in VRAM; no STAT wait (LCD off); callers 08:5079 (border picker, C = $90)
Border_CopyFrameAddTile_LcdOff::
    bit 7, h                                      ; $04A9
    jr nz, jr_000_04bc                            ; $04AB

    ldh [hBankTmp], a                             ; $04AD
    ldh a, [hRomBankShadow]                       ; $04AF
    push af                                       ; $04B1
    ldh a, [hBankTmp]                             ; $04B2
    ldh [hRomBankShadow], a                       ; $04B4
    ld [rROMB0], a                                ; $04B6
    scf                                           ; $04B9
    jr jr_000_04c0                                ; $04BA

jr_000_04bc:
    ld [rRAMB], a                                 ; $04BC
    and a                                         ; $04BF

jr_000_04c0:
    push af                                       ; $04C0
    push de                                       ; $04C1
    ld b, $02                                     ; $04C2

jr_000_04c4:
    push bc                                       ; $04C4
    ld b, $02                                     ; $04C5

jr_000_04c7:
    push bc                                       ; $04C7
    ld b, $14                                     ; $04C8

jr_000_04ca:
    ld a, [hl+]                                   ; $04CA
    add c                                         ; $04CB
    ld [de], a                                    ; $04CC
    inc e                                         ; $04CD
    dec b                                         ; $04CE
    jr nz, jr_000_04ca                            ; $04CF

    pop bc                                        ; $04D1
    ld a, e                                       ; $04D2
    add $0c                                       ; $04D3
    ld e, a                                       ; $04D5
    jr nc, jr_000_04d9                            ; $04D6

    inc d                                         ; $04D8

jr_000_04d9:
    dec b                                         ; $04D9
    jr nz, jr_000_04c7                            ; $04DA

    ld a, e                                       ; $04DC
    add $c0                                       ; $04DD
    ld e, a                                       ; $04DF
    ld a, d                                       ; $04E0
    adc $01                                       ; $04E1
    ld d, a                                       ; $04E3
    pop bc                                        ; $04E4
    dec b                                         ; $04E5
    jr nz, jr_000_04c4                            ; $04E6

    pop de                                        ; $04E8
    ld a, e                                       ; $04E9
    add $40                                       ; $04EA
    ld e, a                                       ; $04EC
    jr nc, jr_000_04f0                            ; $04ED

    inc d                                         ; $04EF

jr_000_04f0:
    ld b, $0e                                     ; $04F0

jr_000_04f2:
    ld a, [hl+]                                   ; $04F2
    add c                                         ; $04F3
    ld [de], a                                    ; $04F4
    inc e                                         ; $04F5
    ld a, [hl+]                                   ; $04F6
    add c                                         ; $04F7
    ld [de], a                                    ; $04F8
    inc e                                         ; $04F9
    set 4, e                                      ; $04FA
    ld a, [hl+]                                   ; $04FC
    add c                                         ; $04FD
    ld [de], a                                    ; $04FE
    inc e                                         ; $04FF
    ld a, [hl+]                                   ; $0500
    add c                                         ; $0501
    ld [de], a                                    ; $0502
    ld a, e                                       ; $0503
    add $0d                                       ; $0504
    ld e, a                                       ; $0506
    jr nc, jr_000_050a                            ; $0507

    inc d                                         ; $0509

jr_000_050a:
    dec b                                         ; $050A
    jr nz, jr_000_04f2                            ; $050B

    pop af                                        ; $050D
    ret nc                                        ; $050E

    pop af                                        ; $050F
    ldh [hRomBankShadow], a                       ; $0510
    ld [rROMB0], a                                ; $0512
    ret                                           ; $0515


; C: same copy as Border_CopyFrameAddTile_LcdOff with STAT waits (LCD on); callers 08:50C1 and 08:50F2 (border picker)
Border_CopyFrameAddTile_Safe::
    bit 7, h                                      ; $0516
    jr nz, jr_000_0529                            ; $0518

    ldh [hBankTmp], a                             ; $051A
    ldh a, [hRomBankShadow]                       ; $051C
    push af                                       ; $051E
    ldh a, [hBankTmp]                             ; $051F
    ldh [hRomBankShadow], a                       ; $0521
    ld [rROMB0], a                                ; $0523
    scf                                           ; $0526
    jr jr_000_052d                                ; $0527

jr_000_0529:
    ld [rRAMB], a                                 ; $0529
    and a                                         ; $052C

jr_000_052d:
    push af                                       ; $052D
    push de                                       ; $052E
    ld b, $02                                     ; $052F

jr_000_0531:
    push bc                                       ; $0531
    ld b, $02                                     ; $0532

jr_000_0534:
    push bc                                       ; $0534
    ld b, $0a                                     ; $0535

jr_000_0537:
    ldh a, [rSTAT]                                ; $0537
    and $03                                       ; $0539
    jr nz, jr_000_0537                            ; $053B

    ld a, [hl+]                                   ; $053D
    add c                                         ; $053E
    ld [de], a                                    ; $053F
    inc e                                         ; $0540
    ld a, [hl+]                                   ; $0541
    add c                                         ; $0542
    ld [de], a                                    ; $0543
    inc e                                         ; $0544
    call Vram_WaitHBlankLine                      ; $0545
    dec b                                         ; $0548
    jr nz, jr_000_0537                            ; $0549

    pop bc                                        ; $054B
    ld a, e                                       ; $054C
    add $0c                                       ; $054D
    ld e, a                                       ; $054F
    jr nc, jr_000_0553                            ; $0550

    inc d                                         ; $0552

jr_000_0553:
    dec b                                         ; $0553
    jr nz, jr_000_0534                            ; $0554

    ld a, e                                       ; $0556
    add $c0                                       ; $0557
    ld e, a                                       ; $0559
    ld a, d                                       ; $055A
    adc $01                                       ; $055B
    ld d, a                                       ; $055D
    pop bc                                        ; $055E
    dec b                                         ; $055F
    jr nz, jr_000_0531                            ; $0560

    pop de                                        ; $0562
    ld a, e                                       ; $0563
    add $40                                       ; $0564
    ld e, a                                       ; $0566
    jr nc, jr_000_056a                            ; $0567

    inc d                                         ; $0569

jr_000_056a:
    ld b, $0e                                     ; $056A

jr_000_056c:
    ldh a, [rSTAT]                                ; $056C
    and $03                                       ; $056E
    jr nz, jr_000_056c                            ; $0570

    ld a, [hl+]                                   ; $0572
    add c                                         ; $0573
    ld [de], a                                    ; $0574
    inc e                                         ; $0575
    ld a, [hl+]                                   ; $0576
    add c                                         ; $0577
    ld [de], a                                    ; $0578
    inc e                                         ; $0579
    set 4, e                                      ; $057A
    call Vram_WaitHBlankLine                      ; $057C

jr_000_057f:
    ldh a, [rSTAT]                                ; $057F
    and $03                                       ; $0581
    jr nz, jr_000_057f                            ; $0583

    ld a, [hl+]                                   ; $0585
    add c                                         ; $0586
    ld [de], a                                    ; $0587
    inc e                                         ; $0588
    ld a, [hl+]                                   ; $0589
    add c                                         ; $058A
    ld [de], a                                    ; $058B
    ld a, e                                       ; $058C
    add $0d                                       ; $058D
    ld e, a                                       ; $058F
    jr nc, jr_000_0593                            ; $0590

    inc d                                         ; $0592

jr_000_0593:
    call Vram_WaitHBlankLine                      ; $0593
    dec b                                         ; $0596
    jr nz, jr_000_056c                            ; $0597

    pop af                                        ; $0599
    ret nc                                        ; $059A

    pop af                                        ; $059B
    ldh [hRomBankShadow], a                       ; $059C
    ld [rROMB0], a                                ; $059E
    ret                                           ; $05A1


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Delay_Short::
    ld a, $02                                     ; $05A2

jr_000_05a4:
    nop                                           ; $05A4
    dec a                                         ; $05A5
    jr nz, jr_000_05a4                            ; $05A6

    ret                                           ; $05A8


Call_000_05a9:
    bit 7, h                                      ; $05A9
    jr nz, jr_000_05bc                            ; $05AB

    ldh [hBankTmp], a                             ; $05AD
    ldh a, [hRomBankShadow]                       ; $05AF
    push af                                       ; $05B1
    ldh a, [hBankTmp]                             ; $05B2
    ldh [hRomBankShadow], a                       ; $05B4
    ld [rROMB0], a                                ; $05B6
    scf                                           ; $05B9
    jr jr_000_05c0                                ; $05BA

jr_000_05bc:
    ld [rRAMB], a                                 ; $05BC
    and a                                         ; $05BF

jr_000_05c0:
    push af                                       ; $05C0
    call Vram_WaitHBlank                          ; $05C1

jr_000_05c4:
    call Call_000_0429                            ; $05C4

jr_000_05c7:
    ldh a, [rSTAT]                                ; $05C7
    and $03                                       ; $05C9
    jr nz, jr_000_05c7                            ; $05CB

    ld a, [hl+]                                   ; $05CD
    ld [de], a                                    ; $05CE
    inc de                                        ; $05CF
    ld a, [hl+]                                   ; $05D0
    ld [de], a                                    ; $05D1
    inc de                                        ; $05D2
    ld a, [hl+]                                   ; $05D3
    ld [de], a                                    ; $05D4
    inc de                                        ; $05D5
    ld a, [hl+]                                   ; $05D6
    ld [de], a                                    ; $05D7
    inc de                                        ; $05D8
    nop                                           ; $05D9
    nop                                           ; $05DA
    nop                                           ; $05DB
    nop                                           ; $05DC
    nop                                           ; $05DD
    nop                                           ; $05DE
    nop                                           ; $05DF
    nop                                           ; $05E0
    nop                                           ; $05E1
    nop                                           ; $05E2
    nop                                           ; $05E3
    nop                                           ; $05E4
    dec bc                                        ; $05E5
    dec bc                                        ; $05E6
    dec bc                                        ; $05E7
    dec bc                                        ; $05E8
    nop                                           ; $05E9
    nop                                           ; $05EA
    nop                                           ; $05EB
    nop                                           ; $05EC
    ld a, b                                       ; $05ED
    and a                                         ; $05EE
    jr nz, jr_000_05c4                            ; $05EF

    ld a, c                                       ; $05F1
    cp $04                                        ; $05F2
    jr nc, jr_000_05c4                            ; $05F4

    cp $02                                        ; $05F6
    jr z, jr_000_0603                             ; $05F8

    pop af                                        ; $05FA
    ret nc                                        ; $05FB

    pop af                                        ; $05FC
    ldh [hRomBankShadow], a                       ; $05FD
    ld [rROMB0], a                                ; $05FF
    ret                                           ; $0602


jr_000_0603:
    call Vram_WaitHBlankLine                      ; $0603

jr_000_0606:
    ldh a, [rSTAT]                                ; $0606
    and $03                                       ; $0608
    jr nz, jr_000_0606                            ; $060A

    ld a, [hl+]                                   ; $060C
    ld [de], a                                    ; $060D
    inc de                                        ; $060E
    ld a, [hl+]                                   ; $060F
    ld [de], a                                    ; $0610
    inc de                                        ; $0611
    pop af                                        ; $0612
    ret nc                                        ; $0613

    pop af                                        ; $0614
    ldh [hRomBankShadow], a                       ; $0615
    ld [rROMB0], a                                ; $0617
    ret                                           ; $061A


; C: 4 bytes per HBlank window. L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 07 10
; 20 (tcrf_check/assets/l3_names/)
Vram_CopyFromBank_4::
    bit 7, h                                      ; $061B
    jr nz, jr_000_062e                            ; $061D

    ldh [hBankTmp], a                             ; $061F
    ldh a, [hRomBankShadow]                       ; $0621
    push af                                       ; $0623
    ldh a, [hBankTmp]                             ; $0624
    ldh [hRomBankShadow], a                       ; $0626
    ld [rROMB0], a                                ; $0628
    scf                                           ; $062B
    jr jr_000_0632                                ; $062C

jr_000_062e:
    ld [rRAMB], a                                 ; $062E
    and a                                         ; $0631

jr_000_0632:
    push af                                       ; $0632
    call Vram_WaitHBlank                          ; $0633

jr_000_0636:
    call Vram_WaitHBlankLine                      ; $0636

jr_000_0639:
    ldh a, [rSTAT]                                ; $0639
    and $03                                       ; $063B
    jr nz, jr_000_0639                            ; $063D

    ld a, [hl+]                                   ; $063F
    ld [de], a                                    ; $0640
    inc de                                        ; $0641
    ld a, [hl+]                                   ; $0642
    ld [de], a                                    ; $0643
    inc de                                        ; $0644
    ld a, [hl+]                                   ; $0645
    ld [de], a                                    ; $0646
    inc de                                        ; $0647
    ld a, [hl+]                                   ; $0648
    ld [de], a                                    ; $0649
    inc de                                        ; $064A
    nop                                           ; $064B
    nop                                           ; $064C
    nop                                           ; $064D
    nop                                           ; $064E
    nop                                           ; $064F
    nop                                           ; $0650
    nop                                           ; $0651
    nop                                           ; $0652
    nop                                           ; $0653
    nop                                           ; $0654
    nop                                           ; $0655
    nop                                           ; $0656
    dec bc                                        ; $0657
    dec bc                                        ; $0658
    dec bc                                        ; $0659
    dec bc                                        ; $065A
    nop                                           ; $065B
    nop                                           ; $065C
    nop                                           ; $065D
    nop                                           ; $065E
    ld a, b                                       ; $065F
    and a                                         ; $0660
    jr nz, jr_000_0636                            ; $0661

    ld a, c                                       ; $0663
    cp $04                                        ; $0664
    jr nc, jr_000_0636                            ; $0666

    cp $02                                        ; $0668
    jr z, jr_000_0675                             ; $066A

    pop af                                        ; $066C
    ret nc                                        ; $066D

    pop af                                        ; $066E
    ldh [hRomBankShadow], a                       ; $066F
    ld [rROMB0], a                                ; $0671
    ret                                           ; $0674


jr_000_0675:
    call Vram_WaitHBlankLine                      ; $0675

jr_000_0678:
    ldh a, [rSTAT]                                ; $0678
    and $03                                       ; $067A
    jr nz, jr_000_0678                            ; $067C

    ld a, [hl+]                                   ; $067E
    ld [de], a                                    ; $067F
    inc de                                        ; $0680
    ld a, [hl+]                                   ; $0681
    ld [de], a                                    ; $0682
    inc de                                        ; $0683
    pop af                                        ; $0684
    ret nc                                        ; $0685

    pop af                                        ; $0686
    ldh [hRomBankShadow], a                       ; $0687
    ld [rROMB0], a                                ; $0689
    ret                                           ; $068C


; C: bank-aware VRAM copy during display: 6 bytes per HBlank window
Vram_CopyFromBank::
    bit 7, h                                      ; $068D
    jr nz, jr_000_06a0                            ; $068F

    ldh [hBankTmp], a                             ; $0691
    ldh a, [hRomBankShadow]                       ; $0693
    push af                                       ; $0695
    ldh a, [hBankTmp]                             ; $0696
    ldh [hRomBankShadow], a                       ; $0698
    ld [rROMB0], a                                ; $069A
    scf                                           ; $069D
    jr jr_000_06a4                                ; $069E

jr_000_06a0:
    ld [rRAMB], a                                 ; $06A0
    and a                                         ; $06A3

jr_000_06a4:
    push af                                       ; $06A4
    push hl                                       ; $06A5
    push de                                       ; $06A6
    pop hl                                        ; $06A7
    pop de                                        ; $06A8
    call Vram_WaitHBlank                          ; $06A9

jr_000_06ac:
    nop                                           ; $06AC
    nop                                           ; $06AD
    nop                                           ; $06AE
    nop                                           ; $06AF
    nop                                           ; $06B0

jr_000_06b1:
    push bc                                       ; $06B1
    ld a, [de]                                    ; $06B2
    ld c, a                                       ; $06B3
    inc de                                        ; $06B4
    ld a, [de]                                    ; $06B5
    ld b, a                                       ; $06B6
    inc de                                        ; $06B7
    call Vram_WaitHBlankLine                      ; $06B8

jr_000_06bb:
    ldh a, [rSTAT]                                ; $06BB
    and $03                                       ; $06BD
    jr nz, jr_000_06bb                            ; $06BF

    ld a, c                                       ; $06C1
    ld [hl+], a                                   ; $06C2
    ld a, b                                       ; $06C3
    ld [hl+], a                                   ; $06C4
    ld a, [de]                                    ; $06C5
    ld [hl+], a                                   ; $06C6
    inc de                                        ; $06C7
    ld a, [de]                                    ; $06C8
    ld [hl+], a                                   ; $06C9
    inc de                                        ; $06CA
    ld a, [de]                                    ; $06CB
    ld [hl+], a                                   ; $06CC
    inc de                                        ; $06CD
    ld a, [de]                                    ; $06CE
    ld [hl+], a                                   ; $06CF
    inc de                                        ; $06D0
    pop bc                                        ; $06D1
    dec bc                                        ; $06D2
    dec bc                                        ; $06D3
    dec bc                                        ; $06D4
    dec bc                                        ; $06D5
    dec bc                                        ; $06D6
    dec bc                                        ; $06D7
    ld a, b                                       ; $06D8
    and a                                         ; $06D9
    jr nz, jr_000_06ac                            ; $06DA

    ld a, c                                       ; $06DC
    cp $06                                        ; $06DD
    jr nc, jr_000_06b1                            ; $06DF

    cp $04                                        ; $06E1
    jr z, jr_000_06f6                             ; $06E3

    cp $02                                        ; $06E5
    jr z, jr_000_0718                             ; $06E7

    push hl                                       ; $06E9
    push de                                       ; $06EA
    pop hl                                        ; $06EB
    pop de                                        ; $06EC
    pop af                                        ; $06ED
    ret nc                                        ; $06EE

    pop af                                        ; $06EF
    ldh [hRomBankShadow], a                       ; $06F0
    ld [rROMB0], a                                ; $06F2
    ret                                           ; $06F5


jr_000_06f6:
    call Vram_WaitHBlankLine                      ; $06F6

jr_000_06f9:
    ldh a, [rSTAT]                                ; $06F9
    and $03                                       ; $06FB
    jr nz, jr_000_06f9                            ; $06FD

    ld a, [de]                                    ; $06FF
    ld [hl+], a                                   ; $0700
    inc de                                        ; $0701
    ld a, [de]                                    ; $0702
    ld [hl+], a                                   ; $0703
    inc de                                        ; $0704
    ld a, [de]                                    ; $0705
    ld [hl+], a                                   ; $0706
    inc de                                        ; $0707
    ld a, [de]                                    ; $0708
    ld [hl+], a                                   ; $0709
    inc de                                        ; $070A
    push hl                                       ; $070B
    push de                                       ; $070C
    pop hl                                        ; $070D
    pop de                                        ; $070E
    pop af                                        ; $070F
    ret nc                                        ; $0710

    pop af                                        ; $0711
    ldh [hRomBankShadow], a                       ; $0712
    ld [rROMB0], a                                ; $0714
    ret                                           ; $0717


jr_000_0718:
    call Vram_WaitHBlankLine                      ; $0718

jr_000_071b:
    ldh a, [rSTAT]                                ; $071B
    and $03                                       ; $071D
    jr nz, jr_000_071b                            ; $071F

    ld a, [de]                                    ; $0721
    ld [hl+], a                                   ; $0722
    inc de                                        ; $0723
    ld a, [de]                                    ; $0724
    ld [hl+], a                                   ; $0725
    inc de                                        ; $0726
    push hl                                       ; $0727
    push de                                       ; $0728
    pop hl                                        ; $0729
    pop de                                        ; $072A
    pop af                                        ; $072B
    ret nc                                        ; $072C

    pop af                                        ; $072D
    ldh [hRomBankShadow], a                       ; $072E
    ld [rROMB0], a                                ; $0730
    ret                                           ; $0733


; I: unreferenced; 8 bytes per window with page-wrapping source. Dead-code root: nothing calls it; assembled as code
; tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Vram_CopyFromBank_8::
    bit 7, h                                      ; $0734
    jr nz, jr_000_0747                            ; $0736

    ldh [hBankTmp], a                             ; $0738
    ldh a, [hRomBankShadow]                       ; $073A
    push af                                       ; $073C
    ldh a, [hBankTmp]                             ; $073D
    ldh [hRomBankShadow], a                       ; $073F
    ld [rROMB0], a                                ; $0741
    scf                                           ; $0744
    jr jr_000_074b                                ; $0745

jr_000_0747:
    ld [rRAMB], a                                 ; $0747
    and a                                         ; $074A

jr_000_074b:
    push af                                       ; $074B
    srl b                                         ; $074C
    rr c                                          ; $074E
    srl b                                         ; $0750
    rr c                                          ; $0752
    srl b                                         ; $0754
    rr c                                          ; $0756
    push de                                       ; $0758
    push hl                                       ; $0759
    pop de                                        ; $075A
    pop hl                                        ; $075B
    call Vram_WaitHBlank                          ; $075C

jr_000_075f:
    push bc                                       ; $075F
    ld a, [de]                                    ; $0760
    ld b, a                                       ; $0761
    inc e                                         ; $0762
    ld a, [de]                                    ; $0763
    ld c, a                                       ; $0764
    inc e                                         ; $0765
    call Vram_WaitHBlankLine                      ; $0766

jr_000_0769:
    ldh a, [rSTAT]                                ; $0769
    and $03                                       ; $076B
    jr nz, jr_000_0769                            ; $076D

    ld a, b                                       ; $076F
    ld [hl+], a                                   ; $0770
    ld a, c                                       ; $0771
    ld [hl+], a                                   ; $0772
    ld a, [de]                                    ; $0773
    ld [hl+], a                                   ; $0774
    inc e                                         ; $0775
    ld a, [de]                                    ; $0776
    ld [hl+], a                                   ; $0777
    inc e                                         ; $0778
    ld a, [de]                                    ; $0779
    ld [hl+], a                                   ; $077A
    inc e                                         ; $077B
    ld a, [de]                                    ; $077C
    ld [hl+], a                                   ; $077D
    inc e                                         ; $077E
    ld a, [de]                                    ; $077F
    ld [hl+], a                                   ; $0780
    inc e                                         ; $0781
    ld a, [de]                                    ; $0782
    ld [hl+], a                                   ; $0783
    inc de                                        ; $0784
    pop bc                                        ; $0785
    dec bc                                        ; $0786
    ld a, b                                       ; $0787
    or c                                          ; $0788
    jr nz, jr_000_075f                            ; $0789

    pop af                                        ; $078B
    ret nc                                        ; $078C

    pop af                                        ; $078D
    ldh [hRomBankShadow], a                       ; $078E
    ld [rROMB0], a                                ; $0790
    ret                                           ; $0793


; C: zero BC bytes of VRAM at HL
Vram_ClearSafe::
    call Vram_WaitHBlank                          ; $0794

jr_000_0797:
    call Vram_WaitHBlankLine                      ; $0797

jr_000_079a:
    ldh a, [rSTAT]                                ; $079A
    and $03                                       ; $079C
    jr nz, jr_000_079a                            ; $079E

    xor a                                         ; $07A0
    ld [hl+], a                                   ; $07A1
    ld [hl+], a                                   ; $07A2
    ld [hl+], a                                   ; $07A3
    ld [hl+], a                                   ; $07A4
    ld [hl+], a                                   ; $07A5
    ld [hl+], a                                   ; $07A6
    ld [hl+], a                                   ; $07A7
    ld [hl+], a                                   ; $07A8
    dec bc                                        ; $07A9
    dec bc                                        ; $07AA
    dec bc                                        ; $07AB
    dec bc                                        ; $07AC
    dec bc                                        ; $07AD
    dec bc                                        ; $07AE
    dec bc                                        ; $07AF
    dec bc                                        ; $07B0
    ld a, b                                       ; $07B1
    or c                                          ; $07B2
    jr nz, jr_000_0797                            ; $07B3

    ret                                           ; $07B5


; C: fill BC bytes of VRAM with $FF
Vram_FillFFSafe::
    call Vram_WaitHBlank                          ; $07B6

jr_000_07b9:
    call Vram_WaitHBlankLine                      ; $07B9

jr_000_07bc:
    ldh a, [rSTAT]                                ; $07BC
    and $03                                       ; $07BE
    jr nz, jr_000_07bc                            ; $07C0

    ld a, $ff                                     ; $07C2
    ld [hl+], a                                   ; $07C4
    ld [hl+], a                                   ; $07C5
    ld [hl+], a                                   ; $07C6
    ld [hl+], a                                   ; $07C7
    ld [hl+], a                                   ; $07C8
    ld [hl+], a                                   ; $07C9
    ld [hl+], a                                   ; $07CA
    ld [hl+], a                                   ; $07CB
    dec bc                                        ; $07CC
    dec bc                                        ; $07CD
    dec bc                                        ; $07CE
    dec bc                                        ; $07CF
    dec bc                                        ; $07D0
    dec bc                                        ; $07D1
    dec bc                                        ; $07D2
    dec bc                                        ; $07D3
    ld a, b                                       ; $07D4
    or c                                          ; $07D5
    jr nz, jr_000_07b9                            ; $07D6

    ret                                           ; $07D8


; C: A -> [HL] after an HBlank sync
Vram_WriteByteSafe::
    push af                                       ; $07D9
    call Vram_WaitHBlankLine                      ; $07DA

jr_000_07dd:
    ldh a, [rSTAT]                                ; $07DD
    and $03                                       ; $07DF
    jr nz, jr_000_07dd                            ; $07E1

    pop af                                        ; $07E3
    ld [hl], a                                    ; $07E4
    ret                                           ; $07E5


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Vram_OrByteSafe::
    push af                                       ; $07E6
    call Vram_WaitHBlank                          ; $07E7
    call Vram_WaitHBlankLine                      ; $07EA

jr_000_07ed:
    ldh a, [rSTAT]                                ; $07ED
    and $03                                       ; $07EF
    jr nz, jr_000_07ed                            ; $07F1

    pop af                                        ; $07F3
    or [hl]                                       ; $07F4
    ld [hl], a                                    ; $07F5
    ret                                           ; $07F6


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Vram_AndByteSafe::
    push af                                       ; $07F7
    call Vram_WaitHBlank                          ; $07F8
    call Vram_WaitHBlankLine                      ; $07FB

jr_000_07fe:
    ldh a, [rSTAT]                                ; $07FE
    and $03                                       ; $0800
    jr nz, jr_000_07fe                            ; $0802

    pop af                                        ; $0804
    and [hl]                                      ; $0805
    ld [hl], a                                    ; $0806
    ret                                           ; $0807


; I: unreferenced. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Vram_ReadByteSafe::
    call Vram_WaitHBlank                          ; $0808
    call Vram_WaitHBlankLine                      ; $080B

jr_000_080e:
    ldh a, [rSTAT]                                ; $080E
    and $03                                       ; $0810
    jr nz, jr_000_080e                            ; $0812

    ld a, [hl]                                    ; $0814
    ret                                           ; $0815


; I: unreferenced; posts the word-copy request in chunks and waits for each. Dead-code root: nothing calls it;
; assembled as code tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Vram_CopyViaVBlank::
    bit 7, h                                      ; $0816
    jr nz, jr_000_0829                            ; $0818

    ldh [hBankTmp], a                             ; $081A
    ldh a, [hRomBankShadow]                       ; $081C
    push af                                       ; $081E
    ldh a, [hBankTmp]                             ; $081F
    ldh [hRomBankShadow], a                       ; $0821
    ld [rROMB0], a                                ; $0823
    scf                                           ; $0826
    jr jr_000_082d                                ; $0827

jr_000_0829:
    ld [rRAMB], a                                 ; $0829
    and a                                         ; $082C

jr_000_082d:
    push af                                       ; $082D

jr_000_082e:
    ld a, h                                       ; $082E
    ldh [hCopyReqSrcDstCnt], a                    ; $082F
    ld a, l                                       ; $0831
    ldh [hCopyReqSrcDstCnt + $1], a               ; $0832
    ld a, d                                       ; $0834
    ldh [hCopyReqSrcDstCnt + $2], a               ; $0835
    ld a, e                                       ; $0837
    ldh [hCopyReqSrcDstCnt + $3], a               ; $0838
    ld a, $20                                     ; $083A
    ldh [hCopyReqSrcDstCnt + $4], a               ; $083C
    ld a, b                                       ; $083E
    and a                                         ; $083F
    jr nz, jr_000_084b                            ; $0840

    ld a, c                                       ; $0842
    cp $40                                        ; $0843
    jr nc, jr_000_084b                            ; $0845

    srl a                                         ; $0847
    ldh [hCopyReqSrcDstCnt + $4], a               ; $0849

jr_000_084b:
    ld a, $01                                     ; $084B
    ldh [hCopyReqFlag], a                         ; $084D
    push hl                                       ; $084F
    push de                                       ; $0850
    push bc                                       ; $0851

jr_000_0852:
    rst Rst08_WaitVBlank                          ; $0852
    ldh a, [hCopyReqFlag]                         ; $0853
    and a                                         ; $0855
    jr nz, jr_000_0852                            ; $0856

    pop bc                                        ; $0858
    ld hl, hCopyReqSrcDstCnt + $4                 ; $0859
    sla [hl]                                      ; $085C
    ld a, c                                       ; $085E
    sub [hl]                                      ; $085F
    ld c, a                                       ; $0860
    jr nc, jr_000_0864                            ; $0861

    dec b                                         ; $0863

jr_000_0864:
    pop de                                        ; $0864
    ldh a, [hCopyReqSrcDstCnt + $4]               ; $0865
    add e                                         ; $0867
    ld e, a                                       ; $0868
    jr nc, jr_000_086c                            ; $0869

    inc d                                         ; $086B

jr_000_086c:
    pop hl                                        ; $086C
    ldh a, [hCopyReqSrcDstCnt + $4]               ; $086D
    add l                                         ; $086F
    ld l, a                                       ; $0870
    jr nc, jr_000_0874                            ; $0871

    inc h                                         ; $0873

jr_000_0874:
    ld a, b                                       ; $0874
    or c                                          ; $0875
    jr nz, jr_000_082e                            ; $0876

    pop af                                        ; $0878
    ret nc                                        ; $0879

    pop af                                        ; $087A
    ldh [hRomBankShadow], a                       ; $087B
    ld [rROMB0], a                                ; $087D
    ret                                           ; $0880


; C: executes the word-copy request at $FFCB-$FFCF
Irq_VBlank_CopyRequest::
    ldh a, [hCopyReqFlag]                         ; $0881
    and a                                         ; $0883
    ret z                                         ; $0884

    ldh a, [hCopyReqSrcDstCnt]                    ; $0885
    ld h, a                                       ; $0887
    ldh a, [hCopyReqSrcDstCnt + $1]               ; $0888
    ld l, a                                       ; $088A
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $088B
    ld d, a                                       ; $088D
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $088E
    ld e, a                                       ; $0890
    ldh a, [hCopyReqSrcDstCnt + $4]               ; $0891
    ld c, a                                       ; $0893

jr_000_0894:
    ld a, [hl+]                                   ; $0894
    ld [de], a                                    ; $0895
    inc de                                        ; $0896
    ld a, [hl+]                                   ; $0897
    ld [de], a                                    ; $0898
    inc de                                        ; $0899
    dec c                                         ; $089A
    jr nz, jr_000_0894                            ; $089B

    xor a                                         ; $089D
    ldh [hCopyReqFlag], a                         ; $089E
    ret                                           ; $08A0


; C: posts the zero-fill request in chunks
Vram_FillViaVBlank::
    bit 7, h                                      ; $08A1
    jr nz, jr_000_08b4                            ; $08A3

    ldh [hBankTmp], a                             ; $08A5
    ldh a, [hRomBankShadow]                       ; $08A7
    push af                                       ; $08A9
    ldh a, [hBankTmp]                             ; $08AA
    ldh [hRomBankShadow], a                       ; $08AC
    ld [rROMB0], a                                ; $08AE
    scf                                           ; $08B1
    jr jr_000_08b8                                ; $08B2

jr_000_08b4:
    ld [rRAMB], a                                 ; $08B4
    and a                                         ; $08B7

jr_000_08b8:
    push af                                       ; $08B8

jr_000_08b9:
    ld a, h                                       ; $08B9
    ldh [hFillReqDst], a                          ; $08BA
    ld a, l                                       ; $08BC
    ldh [hFillReqDst + $1], a                     ; $08BD
    ld a, $20                                     ; $08BF
    ldh [hFillReqWords], a                        ; $08C1
    ld a, b                                       ; $08C3
    and a                                         ; $08C4
    jr nz, jr_000_08d0                            ; $08C5

    ld a, c                                       ; $08C7
    cp $40                                        ; $08C8
    jr nc, jr_000_08d0                            ; $08CA

    srl a                                         ; $08CC
    ldh [hFillReqWords], a                        ; $08CE

jr_000_08d0:
    ld a, $01                                     ; $08D0
    ldh [hFillReqFlag], a                         ; $08D2
    push hl                                       ; $08D4
    push bc                                       ; $08D5

jr_000_08d6:
    rst Rst08_WaitVBlank                          ; $08D6
    ldh a, [hFillReqFlag]                         ; $08D7
    and a                                         ; $08D9
    jr nz, jr_000_08d6                            ; $08DA

    pop bc                                        ; $08DC
    ld hl, hFillReqWords                          ; $08DD
    sla [hl]                                      ; $08E0
    ld a, c                                       ; $08E2
    sub [hl]                                      ; $08E3
    ld c, a                                       ; $08E4
    jr nc, jr_000_08e8                            ; $08E5

    dec b                                         ; $08E7

jr_000_08e8:
    pop hl                                        ; $08E8
    ldh a, [hFillReqWords]                        ; $08E9
    add l                                         ; $08EB
    ld l, a                                       ; $08EC
    jr nc, jr_000_08f0                            ; $08ED

    inc h                                         ; $08EF

jr_000_08f0:
    ld a, b                                       ; $08F0
    or c                                          ; $08F1
    jr nz, jr_000_08b9                            ; $08F2

    pop af                                        ; $08F4
    ret nc                                        ; $08F5

    pop af                                        ; $08F6
    ldh [hRomBankShadow], a                       ; $08F7
    ld [rROMB0], a                                ; $08F9
    ret                                           ; $08FC


; C: executes the zero-fill request at $FFD1-$FFD4
Irq_VBlank_FillRequest::
    ldh a, [hFillReqFlag]                         ; $08FD
    and a                                         ; $08FF
    ret z                                         ; $0900

    ldh a, [hFillReqDst]                          ; $0901
    ld h, a                                       ; $0903
    ldh a, [hFillReqDst + $1]                     ; $0904
    ld l, a                                       ; $0906
    ldh a, [hFillReqWords]                        ; $0907
    ld c, a                                       ; $0909
    xor a                                         ; $090A

jr_000_090b:
    ld [hl+], a                                   ; $090B
    ld [hl+], a                                   ; $090C
    dec c                                         ; $090D
    jr nz, jr_000_090b                            ; $090E

    xor a                                         ; $0910
    ldh [hFillReqFlag], a                         ; $0911
    ret                                           ; $0913


; C: fills $9800-$9BFF with $FF
Vram_ClearBgMap0::
    ld a, $ff                                     ; $0914
    ld hl, $9800                                  ; $0916

jr_000_0919:
    ld [hl+], a                                   ; $0919
    bit 2, h                                      ; $091A
    jr z, jr_000_0919                             ; $091C

    ret                                           ; $091E


; C: fills $9C00-$9FFF with $FF
Vram_ClearBgMap1::
    ld a, $ff                                     ; $091F
    ld hl, $9c00                                  ; $0921

jr_000_0924:
    ld [hl+], a                                   ; $0924
    bit 5, h                                      ; $0925
    jr z, jr_000_0924                             ; $0927

    ret                                           ; $0929


; C: all 160 bytes = $F0 and cursor 0
Oam_ClearShadow::
    ld hl, wOamShadow                             ; $092A
    ld b, $a0                                     ; $092D
    ld a, $f0                                     ; $092F

jr_000_0931:
    ld [hl+], a                                   ; $0931
    dec b                                         ; $0932
    jr nz, jr_000_0931                            ; $0933

    xor a                                         ; $0935
    ldh [hOamCursor], a                           ; $0936
    ret                                           ; $0938


; C: hides the unused tail of the OAM shadow and resets the cursor
Oam_HideUnused::
    ldh a, [hOamCursor]                           ; $0939
    cp $a0                                        ; $093B
    jr nc, jr_000_094c                            ; $093D

    ld l, a                                       ; $093F
    ld h, HIGH(wOamShadow)                        ; $0940
    cpl                                           ; $0942
    add $a1                                       ; $0943
    ld b, a                                       ; $0945
    ld a, $f0                                     ; $0946

jr_000_0948:
    ld [hl+], a                                   ; $0948
    dec b                                         ; $0949
    jr nz, jr_000_0948                            ; $094A

jr_000_094c:
    xor a                                         ; $094C
    ldh [hOamCursor], a                           ; $094D
    ret                                           ; $094F


; C: A = bank; jp HL
Far_Jump::
    ldh [hRomBankShadow], a                       ; $0950
    ld [rROMB0], a                                ; $0952
    jp hl                                         ; $0955


; C: A = bank; HL = routine; $FF9E passed as A
Far_Call::
    ldh [hBankTmp], a                             ; $0956
    ldh a, [hRomBankShadow]                       ; $0958
    push af                                       ; $095A
    ldh a, [hBankTmp]                             ; $095B
    ldh [hRomBankShadow], a                       ; $095D
    ld [rROMB0], a                                ; $095F
    ldh a, [hFarcallAArg]                         ; $0962
    jp hl                                         ; $0964


; C: restores the caller's bank (return address pushed by Far_Call)
Far_Call_Return::
    push af                                       ; $0965
    push hl                                       ; $0966
    ld hl, sp+$05                                 ; $0967
    ld a, [hl]                                    ; $0969
    ldh [hRomBankShadow], a                       ; $096A
    ld [rROMB0], a                                ; $096C
    pop hl                                        ; $096F
    pop af                                        ; $0970
    inc sp                                        ; $0971
    inc sp                                        ; $0972
    ret                                           ; $0973


; C: BC frames via rst 08
Wait_Frames::
    push bc                                       ; $0974
    rst Rst08_WaitVBlank                          ; $0975
    pop bc                                        ; $0976
    dec bc                                        ; $0977
    ld a, c                                       ; $0978
    or b                                          ; $0979
    jr nz, Wait_Frames                            ; $097A

    ret                                           ; $097C


; C: BC x about one frame busy-wait
Delay_Frames_Busy::
    ld de, $06d6                                  ; $097D

jr_000_0980:
    nop                                           ; $0980
    nop                                           ; $0981
    nop                                           ; $0982
    dec de                                        ; $0983
    ld a, d                                       ; $0984
    or e                                          ; $0985
    jr nz, jr_000_0980                            ; $0986

    dec bc                                        ; $0988
    ld a, b                                       ; $0989
    or c                                          ; $098A
    jr nz, Delay_Frames_Busy                      ; $098B

    ret                                           ; $098D


; C: next byte of the 55-byte subtractive generator
Rng_Next::
    push bc                                       ; $098E
    push de                                       ; $098F
    push hl                                       ; $0990
    ld a, [wRngIndex]                             ; $0991
    ld c, a                                       ; $0994
    ld b, $00                                     ; $0995
    inc a                                         ; $0997
    cp $37                                        ; $0998
    jr nz, jr_000_09a3                            ; $099A

    call Rng_Refill                               ; $099C
    xor a                                         ; $099F
    ld bc, $0000                                  ; $09A0

jr_000_09a3:
    ld [wRngIndex], a                             ; $09A3
    ld hl, wRngTable                              ; $09A6
    add hl, bc                                    ; $09A9
    ld a, [hl]                                    ; $09AA
    pop hl                                        ; $09AB
    pop de                                        ; $09AC
    pop bc                                        ; $09AD
    ret                                           ; $09AE


; C: fills the 55-byte table from SRAM $AFFF seed and stores a new seed back
Rng_Init::
    ld a, [wRngModulus]                           ; $09AF
    ld d, a                                       ; $09B2
    ld a, $01                                     ; $09B3
    ld [rRAMB], a                                 ; $09B5
    ld a, [$afff]                                 ; $09B8

jr_000_09bb:
    cp d                                          ; $09BB
    jr c, jr_000_09c1                             ; $09BC

    sub d                                         ; $09BE
    jr jr_000_09bb                                ; $09BF

jr_000_09c1:
    ld [wRngSeedTmp], a                           ; $09C1
    ld [wRngTable + $36], a                       ; $09C4
    ld e, $01                                     ; $09C7
    ld hl, Rng_InitOrder                          ; $09C9
    ld a, $36                                     ; $09CC

jr_000_09ce:
    push af                                       ; $09CE
    ld c, [hl]                                    ; $09CF
    inc hl                                        ; $09D0
    ld b, $00                                     ; $09D1
    push hl                                       ; $09D3
    ld hl, wRngTable                              ; $09D4
    add hl, bc                                    ; $09D7
    ld [hl], e                                    ; $09D8
    ld a, [wRngSeedTmp]                           ; $09D9
    sub e                                         ; $09DC
    jr nc, jr_000_09e0                            ; $09DD

    add d                                         ; $09DF

jr_000_09e0:
    ld e, a                                       ; $09E0
    ld a, [hl]                                    ; $09E1
    ld [wRngSeedTmp], a                           ; $09E2
    pop hl                                        ; $09E5
    pop af                                        ; $09E6
    dec a                                         ; $09E7
    jr nz, jr_000_09ce                            ; $09E8

    call Rng_Refill                               ; $09EA
    call Rng_Refill                               ; $09ED
    call Rng_Refill                               ; $09F0
    push af                                       ; $09F3
    ld a, $0a                                     ; $09F4
    ld [rRAMG], a                                 ; $09F6
    pop af                                        ; $09F9
    ld a, $01                                     ; $09FA
    ld [rRAMB], a                                 ; $09FC
    call Rng_Next                                 ; $09FF
    ld [$afff], a                                 ; $0A02
    push af                                       ; $0A05
    xor a                                         ; $0A06
    ld [rRAMG], a                                 ; $0A07
    pop af                                        ; $0A0A
    ret                                           ; $0A0B


; C: 54-byte index order used by Rng_Init
Rng_InitOrder::
    db $14, $29, $07, $1c, $31, $0f, $24, $02, $17, $2c, $0a, $1f, $34, $12, $27, $05
    db $1a, $2f, $0d, $22, $00, $15, $2a, $08, $1d, $32, $10, $25, $03, $18, $2d, $0b
    db $20, $35, $13, $28, $06, $1b, $30, $0e, $23, $01, $16, $2b, $09, $1e, $33, $11
    db $26, $04, $19, $2e, $0c, $21

; C: one pass of the subtractive recurrence over the table
Rng_Refill::
    ld a, [wRngModulus]                           ; $0A42
    ld d, a                                       ; $0A45
    ld bc, wRngTable                              ; $0A46
    ld hl, wRngTable + $1f                        ; $0A49
    ld e, $18                                     ; $0A4C

jr_000_0a4e:
    ld a, [bc]                                    ; $0A4E
    sub [hl]                                      ; $0A4F
    jr nc, jr_000_0a53                            ; $0A50

    add d                                         ; $0A52

jr_000_0a53:
    ld [bc], a                                    ; $0A53
    dec e                                         ; $0A54
    jr nz, jr_000_0a4e                            ; $0A55

    ld bc, wRngTable + $18                        ; $0A57
    ld hl, wRngTable                              ; $0A5A
    ld e, $1f                                     ; $0A5D

jr_000_0a5f:
    ld a, [bc]                                    ; $0A5F
    sub [hl]                                      ; $0A60
    jr nc, jr_000_0a64                            ; $0A61

    add d                                         ; $0A63

jr_000_0a64:
    ld [bc], a                                    ; $0A64
    dec e                                         ; $0A65
    jr nz, jr_000_0a5f                            ; $0A66

    ret                                           ; $0A68


; C: A = n (0-31): returns floor(Rng_Next x n / 256), i.e. a random value 0..n-1; builds L = n x 8 from
; Rng_Scaled_Mul8Tbl, multiplies with Math_MulAL and shifts H right 3 times; n >= 32 reads past the table
Rng_Scaled::
    push bc                                       ; $0A69
    push hl                                       ; $0A6A
    ld c, a                                       ; $0A6B
    ld b, $00                                     ; $0A6C
    ld hl, Rng_Scaled_Mul8Tbl                     ; $0A6E
    add hl, bc                                    ; $0A71
    ld l, [hl]                                    ; $0A72
    call Rng_Next                                 ; $0A73
    call Math_MulAL                               ; $0A76
    srl h                                         ; $0A79
    srl h                                         ; $0A7B
    srl h                                         ; $0A7D
    ld a, h                                       ; $0A7F
    pop hl                                        ; $0A80
    pop bc                                        ; $0A81
    ret                                           ; $0A82


; C: 32 entries n x 8 ($00 $08 ... $F8), read by Rng_Scaled as L for Math_MulAL (the multiplier n x 8 is shifted back
; by the 3 srl h)
Rng_Scaled_Mul8Tbl::
    db $00, $08, $10, $18, $20, $28, $30, $38, $40, $48, $50, $58, $60, $68, $70, $78
    db $80, $88, $90, $98, $a0, $a8, $b0, $b8, $c0, $c8, $d0, $d8, $e0, $e8, $f0, $f8

; C: reads the pad; keys_held / new / released / repeat / sticky
Joy_Read::
    ld a, P1F_GET_DPAD                            ; $0AA3
    ldh [rP1], a                                  ; $0AA5
    ldh a, [rP1]                                  ; $0AA7
    ldh a, [rP1]                                  ; $0AA9
    and $0f                                       ; $0AAB
    swap a                                        ; $0AAD
    ld b, a                                       ; $0AAF
    ld a, P1F_GET_NONE                            ; $0AB0
    ldh [rP1], a                                  ; $0AB2
    ld a, P1F_GET_BTN                             ; $0AB4
    ldh [rP1], a                                  ; $0AB6
    ldh a, [rP1]                                  ; $0AB8
    ldh a, [rP1]                                  ; $0ABA
    ldh a, [rP1]                                  ; $0ABC
    ldh a, [rP1]                                  ; $0ABE
    ldh a, [rP1]                                  ; $0AC0
    ldh a, [rP1]                                  ; $0AC2
    and $0f                                       ; $0AC4
    or b                                          ; $0AC6
    cpl                                           ; $0AC7
    ldh [hKeysHeld], a                            ; $0AC8
    ld a, P1F_GET_NONE                            ; $0ACA
    ldh [rP1], a                                  ; $0ACC
    ldh a, [hKeysHeld]                            ; $0ACE
    ld hl, hKeysPrev                              ; $0AD0
    xor [hl]                                      ; $0AD3
    push af                                       ; $0AD4
    ld hl, hKeysHeld                              ; $0AD5
    and [hl]                                      ; $0AD8
    ldh [hKeysNew], a                             ; $0AD9
    ldh [hKeysNewRepeat], a                       ; $0ADB
    pop af                                        ; $0ADD
    ld hl, hKeysPrev                              ; $0ADE
    and [hl]                                      ; $0AE1
    ldh [hKeysReleased], a                        ; $0AE2
    ldh a, [hKeysHeld]                            ; $0AE4
    and a                                         ; $0AE6
    jr z, jr_000_0aff                             ; $0AE7

    ld hl, hKeysPrev                              ; $0AE9
    cp [hl]                                       ; $0AEC
    jr nz, jr_000_0aff                            ; $0AED

    ld hl, hKeyRepeatCounter                      ; $0AEF
    dec [hl]                                      ; $0AF2
    jr nz, jr_000_0b03                            ; $0AF3

    ldh a, [hKeysHeld]                            ; $0AF5
    ldh [hKeysNewRepeat], a                       ; $0AF7
    ldh a, [hKeyRepeatPeriod]                     ; $0AF9
    ldh [hKeyRepeatCounter], a                    ; $0AFB
    jr jr_000_0b03                                ; $0AFD

jr_000_0aff:
    ldh a, [hKeyRepeatDelay]                      ; $0AFF
    ldh [hKeyRepeatCounter], a                    ; $0B01

jr_000_0b03:
    ldh a, [hKeysHeld]                            ; $0B03
    ldh [hKeysPrev], a                            ; $0B05
    ld hl, hKeysHeldSticky                        ; $0B07
    ldh a, [hKeysHeld]                            ; $0B0A
    or [hl]                                       ; $0B0C
    ld [hl+], a                                   ; $0B0D
    ldh a, [hKeysNew]                             ; $0B0E
    or [hl]                                       ; $0B10
    ld [hl+], a                                   ; $0B11
    ldh a, [hKeysNewRepeat]                       ; $0B12
    or [hl]                                       ; $0B14
    ld [hl+], a                                   ; $0B15
    ret                                           ; $0B16


; C
Joy_ClearSticky::
    ld hl, hKeysHeldSticky                        ; $0B17
    xor a                                         ; $0B1A
    ld [hl+], a                                   ; $0B1B
    ld [hl+], a                                   ; $0B1C
    ld [hl], a                                    ; $0B1D
    ret                                           ; $0B1E


; C: queues a block (BC = data pointer
Vq_Push::
    push af                                       ; $0B1F
    ld hl, wVqWriteIdx                            ; $0B20
    ld l, [hl]                                    ; $0B23
    ld h, HIGH(wVramQueue)                        ; $0B24
    ld a, $ff                                     ; $0B26
    ld [hl], a                                    ; $0B28
    inc l                                         ; $0B29
    pop af                                        ; $0B2A
    ld [hl], c                                    ; $0B2B
    inc l                                         ; $0B2C
    ld [hl], b                                    ; $0B2D
    inc l                                         ; $0B2E
    ld [hl], a                                    ; $0B2F
    inc l                                         ; $0B30
    xor a                                         ; $0B31
    ld [hl], a                                    ; $0B32
    ld a, [wVqWriteIdx]                           ; $0B33
    add $04                                       ; $0B36
    ld [wVqWriteIdx], a                           ; $0B38
    ldh a, [rLCDC]                                ; $0B3B
    bit 7, a                                      ; $0B3D
    ret nz                                        ; $0B3F

    ldh a, [rIE]                                  ; $0B40
    push af                                       ; $0B42
    res 0, a                                      ; $0B43
    ldh [rIE], a                                  ; $0B45
    call Vq_Process                               ; $0B47
    pop af                                        ; $0B4A
    ldh [rIE], a                                  ; $0B4B
    ret                                           ; $0B4D


; C: VBlank: runs queued blocks
Vq_Process::
    ld a, [wVqWriteIdx]                           ; $0B4E
    ld hl, wVqReadIdx                             ; $0B51
    cp [hl]                                       ; $0B54
    ret z                                         ; $0B55

    ld l, [hl]                                    ; $0B56
    ld h, HIGH(wVramQueue)                        ; $0B57

jr_000_0b59:
    ld a, [hl]                                    ; $0B59
    and a                                         ; $0B5A
    jr z, jr_000_0b77                             ; $0B5B

    inc l                                         ; $0B5D
    ld e, [hl]                                    ; $0B5E
    inc l                                         ; $0B5F
    ld d, [hl]                                    ; $0B60
    inc l                                         ; $0B61
    ldh a, [hRomBankShadow]                       ; $0B62
    push af                                       ; $0B64
    ld a, [hl]                                    ; $0B65
    ldh [hRomBankShadow], a                       ; $0B66
    ld [rROMB0], a                                ; $0B68
    inc l                                         ; $0B6B
    call Vq_RunStream                             ; $0B6C
    pop af                                        ; $0B6F
    ldh [hRomBankShadow], a                       ; $0B70
    ld [rROMB0], a                                ; $0B72
    jr jr_000_0b59                                ; $0B75

jr_000_0b77:
    ld a, l                                       ; $0B77
    ld [wVqReadIdx], a                            ; $0B78
    ret                                           ; $0B7B


; C: decodes one stream: dest hi/lo + control (bit7 column step
Vq_RunStream::
    ldh a, [rIE]                                  ; $0B7C
    push af                                       ; $0B7E
    res 0, a                                      ; $0B7F
    ldh [rIE], a                                  ; $0B81
    push hl                                       ; $0B83

jr_000_0b84:
    ld a, [de]                                    ; $0B84
    ld h, a                                       ; $0B85
    inc de                                        ; $0B86
    ld a, [de]                                    ; $0B87
    ld l, a                                       ; $0B88
    inc de                                        ; $0B89
    ld a, [de]                                    ; $0B8A
    inc de                                        ; $0B8B
    bit 7, a                                      ; $0B8C
    jr nz, jr_000_0baa                            ; $0B8E

    bit 6, a                                      ; $0B90
    jr nz, jr_000_0b9f                            ; $0B92

    and $3f                                       ; $0B94
    ld b, a                                       ; $0B96

jr_000_0b97:
    ld a, [de]                                    ; $0B97
    ld [hl+], a                                   ; $0B98
    inc de                                        ; $0B99
    dec b                                         ; $0B9A
    jr nz, jr_000_0b97                            ; $0B9B

    jr jr_000_0bcc                                ; $0B9D

jr_000_0b9f:
    and $3f                                       ; $0B9F
    ld b, a                                       ; $0BA1
    ld a, [de]                                    ; $0BA2

jr_000_0ba3:
    ld [hl+], a                                   ; $0BA3
    dec b                                         ; $0BA4
    jr nz, jr_000_0ba3                            ; $0BA5

    inc de                                        ; $0BA7
    jr jr_000_0bcc                                ; $0BA8

jr_000_0baa:
    bit 6, a                                      ; $0BAA
    jr nz, jr_000_0bbe                            ; $0BAC

    and $3f                                       ; $0BAE
    ld bc, $0020                                  ; $0BB0

jr_000_0bb3:
    push af                                       ; $0BB3
    ld a, [de]                                    ; $0BB4
    ld [hl], a                                    ; $0BB5
    inc de                                        ; $0BB6
    add hl, bc                                    ; $0BB7
    pop af                                        ; $0BB8
    dec a                                         ; $0BB9
    jr nz, jr_000_0bb3                            ; $0BBA

    jr jr_000_0bcc                                ; $0BBC

jr_000_0bbe:
    and $3f                                       ; $0BBE
    ld bc, $0020                                  ; $0BC0

jr_000_0bc3:
    push af                                       ; $0BC3
    ld a, [de]                                    ; $0BC4
    ld [hl], a                                    ; $0BC5
    add hl, bc                                    ; $0BC6
    pop af                                        ; $0BC7
    dec a                                         ; $0BC8
    jr nz, jr_000_0bc3                            ; $0BC9

    inc de                                        ; $0BCB

jr_000_0bcc:
    ld a, [de]                                    ; $0BCC
    and a                                         ; $0BCD
    jr nz, jr_000_0b84                            ; $0BCE

    pop hl                                        ; $0BD0
    pop af                                        ; $0BD1
    ldh [rIE], a                                  ; $0BD2
    ret                                           ; $0BD4


; C: jp Irq_Stat_Exit
Stat_00_None::
    jp Irq_Stat_Exit                              ; $0BD5


; C: flips LCDC bit 4 (BG tile data $8000/$8800) at the split line
Stat_01_TileDataToggle::
    ld hl, hSplit1Latch                           ; $0BD8
    ld c, [hl]                                    ; $0BDB
    ldh a, [rLY]                                  ; $0BDC
    cp c                                          ; $0BDE
    jp c, Irq_Stat_Exit                           ; $0BDF

    inc c                                         ; $0BE2
    inc c                                         ; $0BE3
    inc c                                         ; $0BE4
    inc c                                         ; $0BE5
    cp c                                          ; $0BE6
    jp nc, Irq_Stat_Exit                          ; $0BE7

    ld hl, $ff41                                  ; $0BEA

jr_000_0bed:
    ld a, [hl]                                    ; $0BED
    and $03                                       ; $0BEE
    jr nz, jr_000_0bed                            ; $0BF0

    ldh a, [hLcdcShadow]                          ; $0BF2
    xor $10                                       ; $0BF4
    ldh [rLCDC], a                                ; $0BF6
    jp Irq_Stat_Exit                              ; $0BF8


; C: loads SCX/SCY of band 1 at the split line
Stat_02_ScrollOneBand::
    ld hl, hSplit1Latch                           ; $0BFB
    ldh a, [rLY]                                  ; $0BFE
    cp [hl]                                       ; $0C00
    jp nz, Irq_Stat_Exit                          ; $0C01

    ldh a, [hScxBand1]                            ; $0C04
    ld b, a                                       ; $0C06
    ldh a, [hScyBand1]                            ; $0C07
    ld c, a                                       ; $0C09
    ld hl, $ff41                                  ; $0C0A

jr_000_0c0d:
    ld a, [hl]                                    ; $0C0D
    and $03                                       ; $0C0E
    jr nz, jr_000_0c0d                            ; $0C10

    ld a, b                                       ; $0C12
    ldh [rSCX], a                                 ; $0C13
    ld a, c                                       ; $0C15
    ldh [rSCY], a                                 ; $0C16
    jp Irq_Stat_Exit                              ; $0C18


; C: band 2 switches the BG map to $9C00 (LCDC bit 3)
Stat_03_ScrollTwoBands_Map1::
    ld hl, hSplit1Latch                           ; $0C1B
    ldh a, [rLY]                                  ; $0C1E
    cp [hl]                                       ; $0C20
    jr nz, jr_000_0c46                            ; $0C21

    ldh a, [hScxBand1Latch]                       ; $0C23
    ld b, a                                       ; $0C25
    ldh a, [hScyBand1Latch]                       ; $0C26
    ld c, a                                       ; $0C28
    ldh a, [hLcdcShadow]                          ; $0C29
    set 3, a                                      ; $0C2B
    ld e, a                                       ; $0C2D
    ld hl, $ff41                                  ; $0C2E

jr_000_0c31:
    ld a, [hl]                                    ; $0C31
    and $03                                       ; $0C32
    jr nz, jr_000_0c31                            ; $0C34

    ld a, b                                       ; $0C36
    ldh [rSCX], a                                 ; $0C37
    ld a, c                                       ; $0C39
    ldh [rSCY], a                                 ; $0C3A
    ld a, e                                       ; $0C3C
    ldh [rLCDC], a                                ; $0C3D
    ldh a, [hSplit2Latch]                         ; $0C3F
    ldh [rLYC], a                                 ; $0C41
    jp Irq_Stat_Exit                              ; $0C43


jr_000_0c46:
    ld hl, hSplit2Latch                           ; $0C46
    ldh a, [rLY]                                  ; $0C49
    cp [hl]                                       ; $0C4B
    jp nz, Irq_Stat_Exit                          ; $0C4C

    ldh a, [hScxBand2Latch]                       ; $0C4F
    ld b, a                                       ; $0C51
    ldh a, [hScyBand2Latch]                       ; $0C52
    ld c, a                                       ; $0C54
    ldh a, [hLcdcShadow]                          ; $0C55
    ld e, a                                       ; $0C57
    ld hl, $ff41                                  ; $0C58

jr_000_0c5b:
    ld a, [hl]                                    ; $0C5B
    and $03                                       ; $0C5C
    jr nz, jr_000_0c5b                            ; $0C5E

    ld a, b                                       ; $0C60
    ldh [rSCX], a                                 ; $0C61
    ld a, c                                       ; $0C63
    ldh [rSCY], a                                 ; $0C64
    ld a, e                                       ; $0C66
    ldh [rLCDC], a                                ; $0C67
    jp Irq_Stat_Exit                              ; $0C69


; C: LCDC bit 5 off and WX=$A5 at the split line
Stat_04_WindowOff::
    ld hl, hSplit1Latch                           ; $0C6C
    ldh a, [rLY]                                  ; $0C6F
    cp [hl]                                       ; $0C71
    jp nz, Irq_Stat_Exit                          ; $0C72

    ld hl, $ff41                                  ; $0C75

jr_000_0c78:
    ld a, [hl]                                    ; $0C78
    and $03                                       ; $0C79
    jr nz, jr_000_0c78                            ; $0C7B

    ldh a, [hLcdcShadow]                          ; $0C7D
    res 5, a                                      ; $0C7F
    ldh [rLCDC], a                                ; $0C81
    ld a, $a5                                     ; $0C83
    ldh [rWX], a                                  ; $0C85
    jp Irq_Stat_Exit                              ; $0C87


; C: second split fixed at LY=$67 with BG map $9C00
Stat_05_ScrollTwoBands_Split67::
    ld hl, hSplit1Latch                           ; $0C8A
    ldh a, [rLY]                                  ; $0C8D
    cp [hl]                                       ; $0C8F
    jr nz, jr_000_0cad                            ; $0C90

    ldh a, [hScxBand1]                            ; $0C92
    ld b, a                                       ; $0C94
    ldh a, [hScyBand1]                            ; $0C95
    ld c, a                                       ; $0C97
    ld hl, $ff41                                  ; $0C98

jr_000_0c9b:
    ld a, [hl]                                    ; $0C9B
    and $03                                       ; $0C9C
    jr nz, jr_000_0c9b                            ; $0C9E

    ld a, b                                       ; $0CA0
    ldh [rSCX], a                                 ; $0CA1
    ld a, c                                       ; $0CA3
    ldh [rSCY], a                                 ; $0CA4
    ld a, $67                                     ; $0CA6
    ldh [rLYC], a                                 ; $0CA8
    jp Irq_Stat_Exit                              ; $0CAA


jr_000_0cad:
    ldh a, [rLY]                                  ; $0CAD
    cp $67                                        ; $0CAF
    jp nz, Irq_Stat_Exit                          ; $0CB1

    ldh a, [hScxBand2]                            ; $0CB4
    ld b, a                                       ; $0CB6
    ldh a, [hScyBand2]                            ; $0CB7
    ld c, a                                       ; $0CB9
    ldh a, [hLcdcShadow]                          ; $0CBA
    set 3, a                                      ; $0CBC
    ld e, a                                       ; $0CBE
    ld hl, $ff41                                  ; $0CBF

jr_000_0cc2:
    ld a, [hl]                                    ; $0CC2
    and $03                                       ; $0CC3
    jr nz, jr_000_0cc2                            ; $0CC5

    ld a, b                                       ; $0CC7
    ldh [rSCX], a                                 ; $0CC8
    ld a, c                                       ; $0CCA
    ldh [rSCY], a                                 ; $0CCB
    ld a, e                                       ; $0CCD
    ldh [rLCDC], a                                ; $0CCE
    jp Irq_Stat_Exit                              ; $0CD0


; C: splits at the latch line then LY=$4F then LY=$67
Stat_06_ThreeBands::
    ld hl, hSplit1Latch                           ; $0CD3
    ldh a, [rLY]                                  ; $0CD6
    cp [hl]                                       ; $0CD8
    jr nz, jr_000_0cf6                            ; $0CD9

    ldh a, [hScxBand1Latch]                       ; $0CDB
    ld b, a                                       ; $0CDD
    ldh a, [hScyBand1Latch]                       ; $0CDE
    ld c, a                                       ; $0CE0
    ld hl, $ff41                                  ; $0CE1

jr_000_0ce4:
    ld a, [hl]                                    ; $0CE4
    and $03                                       ; $0CE5
    jr nz, jr_000_0ce4                            ; $0CE7

    ld a, b                                       ; $0CE9
    ldh [rSCX], a                                 ; $0CEA
    ld a, c                                       ; $0CEC
    ldh [rSCY], a                                 ; $0CED
    ld a, $4f                                     ; $0CEF
    ldh [rLYC], a                                 ; $0CF1
    jp Irq_Stat_Exit                              ; $0CF3


jr_000_0cf6:
    ldh a, [rLY]                                  ; $0CF6
    cp $4f                                        ; $0CF8
    jr nz, jr_000_0d21                            ; $0CFA

    ldh a, [hScxBand2Latch]                       ; $0CFC
    ld b, a                                       ; $0CFE
    ldh a, [hScyBand2Latch]                       ; $0CFF
    ld c, a                                       ; $0D01
    ldh a, [hLcdcShadow]                          ; $0D02
    set 3, a                                      ; $0D04
    set 4, a                                      ; $0D06
    ld e, a                                       ; $0D08
    ld hl, $ff41                                  ; $0D09

jr_000_0d0c:
    ld a, [hl]                                    ; $0D0C
    and $03                                       ; $0D0D
    jr nz, jr_000_0d0c                            ; $0D0F

    ld a, b                                       ; $0D11
    ldh [rSCX], a                                 ; $0D12
    ld a, c                                       ; $0D14
    ldh [rSCY], a                                 ; $0D15
    ld a, e                                       ; $0D17
    ldh [rLCDC], a                                ; $0D18
    ld a, $67                                     ; $0D1A
    ldh [rLYC], a                                 ; $0D1C
    jp Irq_Stat_Exit                              ; $0D1E


jr_000_0d21:
    ldh a, [rLY]                                  ; $0D21
    cp $67                                        ; $0D23
    jp nz, Irq_Stat_Exit                          ; $0D25

    ld bc, $0030                                  ; $0D28
    ld hl, $ff41                                  ; $0D2B

jr_000_0d2e:
    ld a, [hl]                                    ; $0D2E
    and $03                                       ; $0D2F
    jr nz, jr_000_0d2e                            ; $0D31

    ld a, b                                       ; $0D33
    ldh [rSCX], a                                 ; $0D34
    ld a, c                                       ; $0D36
    ldh [rSCY], a                                 ; $0D37
    jp Irq_Stat_Exit                              ; $0D39


; C: like 03 with the second split from split2_latch
Stat_07_ScrollTwoBands_Map1b::
    ld hl, hSplit1Latch                           ; $0D3C
    ldh a, [rLY]                                  ; $0D3F
    cp [hl]                                       ; $0D41
    jr nz, jr_000_0d5f                            ; $0D42

    ldh a, [hScxBand1Latch]                       ; $0D44
    ld b, a                                       ; $0D46
    ldh a, [hScyBand1Latch]                       ; $0D47
    ld c, a                                       ; $0D49
    ld hl, $ff41                                  ; $0D4A

jr_000_0d4d:
    ld a, [hl]                                    ; $0D4D
    and $03                                       ; $0D4E
    jr nz, jr_000_0d4d                            ; $0D50

    ld a, b                                       ; $0D52
    ldh [rSCX], a                                 ; $0D53
    ld a, c                                       ; $0D55
    ldh [rSCY], a                                 ; $0D56
    ldh a, [hSplit2Latch]                         ; $0D58
    ldh [rLYC], a                                 ; $0D5A
    jp Irq_Stat_Exit                              ; $0D5C


jr_000_0d5f:
    ld hl, hSplit2Latch                           ; $0D5F
    ldh a, [rLY]                                  ; $0D62
    cp [hl]                                       ; $0D64
    jp nz, Irq_Stat_Exit                          ; $0D65

    ldh a, [hScxBand2Latch]                       ; $0D68
    ld b, a                                       ; $0D6A
    ldh a, [hScyBand2Latch]                       ; $0D6B
    ld c, a                                       ; $0D6D
    ldh a, [hLcdcShadow]                          ; $0D6E
    set 3, a                                      ; $0D70
    ld e, a                                       ; $0D72
    ld hl, $ff41                                  ; $0D73

jr_000_0d76:
    ld a, [hl]                                    ; $0D76
    and $03                                       ; $0D77
    jr nz, jr_000_0d76                            ; $0D79

    ld a, b                                       ; $0D7B
    ldh [rSCX], a                                 ; $0D7C
    ld a, c                                       ; $0D7E
    ldh [rSCY], a                                 ; $0D7F
    ld a, e                                       ; $0D81
    ldh [rLCDC], a                                ; $0D82
    jp Irq_Stat_Exit                              ; $0D84


; C: returns 1/2/3/4 for the first set of bits 5/4/6/7 (left right up down). L3 pass 2026-10-26: executed in BGB in 2
; replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Joy_DpadBitToIndex::
    bit 5, a                                      ; $0D87
    jr z, jr_000_0d8e                             ; $0D89

    ld a, $01                                     ; $0D8B
    ret                                           ; $0D8D


jr_000_0d8e:
    bit 4, a                                      ; $0D8E
    jr z, jr_000_0d95                             ; $0D90

    ld a, $02                                     ; $0D92
    ret                                           ; $0D94


jr_000_0d95:
    bit 6, a                                      ; $0D95
    jr z, jr_000_0d9c                             ; $0D97

    ld a, $03                                     ; $0D99
    ret                                           ; $0D9B


jr_000_0d9c:
    bit 7, a                                      ; $0D9C
    jr z, jr_000_0da3                             ; $0D9E

    ld a, $04                                     ; $0DA0
    ret                                           ; $0DA2


jr_000_0da3:
    xor a                                         ; $0DA3
    ret                                           ; $0DA4


; C: BGP/OBP0/OBP1 shadows = 0
Pal_AllWhite::
    xor a                                         ; $0DA5
    ldh [hBgpShadow], a                           ; $0DA6
    ldh [hObp0Shadow], a                          ; $0DA8
    ldh [hObp1Shadow], a                          ; $0DAA
    ret                                           ; $0DAC


; C: 3 steps (2 frames each) from white to palette_target
Pal_FadeIn::
    ld hl, hBgpShadow                             ; $0DAD
    ld de, wPaletteTarget                         ; $0DB0
    ld b, $03                                     ; $0DB3

jr_000_0db5:
    ld a, [de]                                    ; $0DB5
    and $55                                       ; $0DB6
    ld c, a                                       ; $0DB8
    ld a, [de]                                    ; $0DB9
    and $aa                                       ; $0DBA
    srl a                                         ; $0DBC
    and c                                         ; $0DBE
    ld [hl+], a                                   ; $0DBF
    inc de                                        ; $0DC0
    dec b                                         ; $0DC1
    jr nz, jr_000_0db5                            ; $0DC2

    ld bc, $0002                                  ; $0DC4
    call Wait_Frames                              ; $0DC7
    ld hl, hBgpShadow                             ; $0DCA
    ld de, wPaletteTarget                         ; $0DCD
    ld b, $03                                     ; $0DD0

jr_000_0dd2:
    ld a, [de]                                    ; $0DD2
    and $aa                                       ; $0DD3
    srl a                                         ; $0DD5
    add [hl]                                      ; $0DD7
    ld [hl+], a                                   ; $0DD8
    inc de                                        ; $0DD9
    dec b                                         ; $0DDA
    jr nz, jr_000_0dd2                            ; $0DDB

    ld bc, $0002                                  ; $0DDD
    call Wait_Frames                              ; $0DE0
    ld hl, hBgpShadow                             ; $0DE3
    ld de, wPaletteTarget                         ; $0DE6
    ld b, $03                                     ; $0DE9

jr_000_0deb:
    ld a, [de]                                    ; $0DEB
    and $55                                       ; $0DEC
    ld c, a                                       ; $0DEE
    ld a, [de]                                    ; $0DEF
    and $aa                                       ; $0DF0
    srl a                                         ; $0DF2
    or c                                          ; $0DF4
    add [hl]                                      ; $0DF5
    ld [hl+], a                                   ; $0DF6
    inc de                                        ; $0DF7
    dec b                                         ; $0DF8
    jr nz, jr_000_0deb                            ; $0DF9

    ld bc, $0002                                  ; $0DFB
    call Wait_Frames                              ; $0DFE
    ret                                           ; $0E01


; C: 3 steps down to 0
Pal_FadeOut::
    ld hl, hBgpShadow                             ; $0E02
    ld b, $03                                     ; $0E05

jr_000_0e07:
    push bc                                       ; $0E07
    push hl                                       ; $0E08
    ld b, $03                                     ; $0E09

jr_000_0e0b:
    ld a, [hl]                                    ; $0E0B
    and $55                                       ; $0E0C
    ld c, a                                       ; $0E0E
    ld a, [hl]                                    ; $0E0F
    and $aa                                       ; $0E10
    srl a                                         ; $0E12
    or c                                          ; $0E14
    cpl                                           ; $0E15
    inc a                                         ; $0E16
    add [hl]                                      ; $0E17
    ld [hl+], a                                   ; $0E18
    dec b                                         ; $0E19
    jr nz, jr_000_0e0b                            ; $0E1A

    ld bc, $0002                                  ; $0E1C
    call Wait_Frames                              ; $0E1F
    pop hl                                        ; $0E22
    pop bc                                        ; $0E23
    dec b                                         ; $0E24
    jr nz, jr_000_0e07                            ; $0E25

    xor a                                         ; $0E27
    ld hl, hBgpShadow                             ; $0E28
    ld [hl+], a                                   ; $0E2B
    ld [hl+], a                                   ; $0E2C
    ld [hl], a                                    ; $0E2D
    ld bc, $0002                                  ; $0E2E
    call Wait_Frames                              ; $0E31
    ret                                           ; $0E34


; C: draws a BG map (HL. L3 pass 2026-10-26: executed in BGB in 89 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Map_SpiralWipeIn::
    push af                                       ; $0E35
    push hl                                       ; $0E36
    ld a, $00                                     ; $0E37
    ld hl, Gfx_WipeTile                           ; $0E39
    ld de, $8ff0                                  ; $0E3C
    ld bc, $0010                                  ; $0E3F
    call Vram_CopyFromBank                        ; $0E42
    ld a, $00                                     ; $0E45
    ld hl, $9800                                  ; $0E47
    ld bc, $0400                                  ; $0E4A
    call Vram_FillFFSafe                          ; $0E4D
    ld a, [wPaletteTarget]                        ; $0E50
    ldh [hBgpShadow], a                           ; $0E53
    pop hl                                        ; $0E55
    pop af                                        ; $0E56
    ldh [hBankTmp], a                             ; $0E57
    ldh a, [hRomBankShadow]                       ; $0E59
    push af                                       ; $0E5B
    ldh a, [hBankTmp]                             ; $0E5C
    ldh [hRomBankShadow], a                       ; $0E5E
    ld [rROMB0], a                                ; $0E60
    ld de, $0128                                  ; $0E63
    ld bc, $0301                                  ; $0E66

; C: per-cell loop top of the spiral wipe: writes one map byte through Vram_WriteByteSafe, waits a frame every 8th
; cell (branch target; code read 2026-10-19)
Map_SpiralWipeIn_CellLoop::
    push bc                                       ; $0E69

jr_000_0e6a:
    push bc                                       ; $0E6A
    push de                                       ; $0E6B
    push hl                                       ; $0E6C
    add hl, de                                    ; $0E6D
    ld a, [hl]                                    ; $0E6E
    ld hl, $9800                                  ; $0E6F
    add hl, de                                    ; $0E72
    call Vram_WriteByteSafe                       ; $0E73
    ld a, b                                       ; $0E76
    and $07                                       ; $0E77
    jr nz, jr_000_0e7c                            ; $0E79

    rst Rst08_WaitVBlank                          ; $0E7B

jr_000_0e7c:
    pop hl                                        ; $0E7C
    pop de                                        ; $0E7D
    pop bc                                        ; $0E7E
    inc de                                        ; $0E7F
    dec b                                         ; $0E80
    jr nz, jr_000_0e6a                            ; $0E81

    pop bc                                        ; $0E83
    inc b                                         ; $0E84
    push bc                                       ; $0E85

jr_000_0e86:
    push bc                                       ; $0E86
    push de                                       ; $0E87
    push hl                                       ; $0E88
    add hl, de                                    ; $0E89
    ld a, [hl]                                    ; $0E8A
    ld hl, $9800                                  ; $0E8B
    add hl, de                                    ; $0E8E
    call Vram_WriteByteSafe                       ; $0E8F
    ld a, c                                       ; $0E92
    and $07                                       ; $0E93
    jr nz, jr_000_0e98                            ; $0E95

    rst Rst08_WaitVBlank                          ; $0E97

jr_000_0e98:
    pop hl                                        ; $0E98
    pop de                                        ; $0E99
    pop bc                                        ; $0E9A
    ld a, e                                       ; $0E9B
    add $e0                                       ; $0E9C
    ld e, a                                       ; $0E9E
    ld a, d                                       ; $0E9F
    adc $ff                                       ; $0EA0
    ld d, a                                       ; $0EA2
    dec c                                         ; $0EA3
    jr nz, jr_000_0e86                            ; $0EA4

    pop bc                                        ; $0EA6
    inc c                                         ; $0EA7
    push bc                                       ; $0EA8

jr_000_0ea9:
    push bc                                       ; $0EA9
    push de                                       ; $0EAA
    push hl                                       ; $0EAB
    add hl, de                                    ; $0EAC
    ld a, [hl]                                    ; $0EAD
    ld hl, $9800                                  ; $0EAE
    add hl, de                                    ; $0EB1
    call Vram_WriteByteSafe                       ; $0EB2
    ld a, b                                       ; $0EB5
    and $07                                       ; $0EB6
    jr nz, jr_000_0ebb                            ; $0EB8

    rst Rst08_WaitVBlank                          ; $0EBA

jr_000_0ebb:
    pop hl                                        ; $0EBB
    pop de                                        ; $0EBC
    pop bc                                        ; $0EBD
    dec de                                        ; $0EBE
    dec b                                         ; $0EBF
    jr nz, jr_000_0ea9                            ; $0EC0

    pop bc                                        ; $0EC2
    inc b                                         ; $0EC3
    ld a, b                                       ; $0EC4
    cp $15                                        ; $0EC5
    jr z, jr_000_0eef                             ; $0EC7

    push bc                                       ; $0EC9

jr_000_0eca:
    push bc                                       ; $0ECA
    push de                                       ; $0ECB
    push hl                                       ; $0ECC
    add hl, de                                    ; $0ECD
    ld a, [hl]                                    ; $0ECE
    ld hl, $9800                                  ; $0ECF
    add hl, de                                    ; $0ED2
    call Vram_WriteByteSafe                       ; $0ED3
    ld a, c                                       ; $0ED6
    and $07                                       ; $0ED7
    jr nz, jr_000_0edc                            ; $0ED9

    rst Rst08_WaitVBlank                          ; $0EDB

jr_000_0edc:
    pop hl                                        ; $0EDC
    pop de                                        ; $0EDD
    pop bc                                        ; $0EDE
    ld a, e                                       ; $0EDF
    add $20                                       ; $0EE0
    ld e, a                                       ; $0EE2
    ld a, d                                       ; $0EE3
    adc $00                                       ; $0EE4
    ld d, a                                       ; $0EE6
    dec c                                         ; $0EE7
    jr nz, jr_000_0eca                            ; $0EE8

    pop bc                                        ; $0EEA
    inc c                                         ; $0EEB
    jp Map_SpiralWipeIn_CellLoop                  ; $0EEC


jr_000_0eef:
    ld bc, $0004                                  ; $0EEF
    call Wait_Frames                              ; $0EF2
    pop af                                        ; $0EF5
    ldh [hRomBankShadow], a                       ; $0EF6
    ld [rROMB0], a                                ; $0EF8
    ret                                           ; $0EFB


; C: fills the BG map with $FF in a spiral order (20x17). L3 pass 2026-10-26: executed in BGB in 85 replay(s) of the
; organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Map_SpiralWipeOut::
    ld a, $00                                     ; $0EFC
    ld hl, Gfx_WipeTile                           ; $0EFE
    ld de, $8ff0                                  ; $0F01
    ld bc, $0010                                  ; $0F04
    call Vram_CopyFromBank                        ; $0F07
    ld hl, $9800                                  ; $0F0A
    ld bc, $1411                                  ; $0F0D

jr_000_0f10:
    ld a, b                                       ; $0F10
    and a                                         ; $0F11
    jr z, jr_000_0f90                             ; $0F12

    push bc                                       ; $0F14

jr_000_0f15:
    push bc                                       ; $0F15
    ld a, $ff                                     ; $0F16
    call Vram_WriteByteSafe                       ; $0F18
    ld a, b                                       ; $0F1B
    and $07                                       ; $0F1C
    jr nz, jr_000_0f23                            ; $0F1E

    push hl                                       ; $0F20
    rst Rst08_WaitVBlank                          ; $0F21
    pop hl                                        ; $0F22

jr_000_0f23:
    pop bc                                        ; $0F23
    inc hl                                        ; $0F24
    dec b                                         ; $0F25
    jr nz, jr_000_0f15                            ; $0F26

    pop bc                                        ; $0F28
    ld de, $001f                                  ; $0F29
    add hl, de                                    ; $0F2C
    dec b                                         ; $0F2D
    ld a, c                                       ; $0F2E
    and a                                         ; $0F2F
    jr z, jr_000_0f90                             ; $0F30

    push bc                                       ; $0F32

jr_000_0f33:
    push bc                                       ; $0F33
    ld a, $ff                                     ; $0F34
    call Vram_WriteByteSafe                       ; $0F36
    ld a, c                                       ; $0F39
    and $07                                       ; $0F3A
    jr nz, jr_000_0f41                            ; $0F3C

    push hl                                       ; $0F3E
    rst Rst08_WaitVBlank                          ; $0F3F
    pop hl                                        ; $0F40

jr_000_0f41:
    pop bc                                        ; $0F41
    ld de, $0020                                  ; $0F42
    add hl, de                                    ; $0F45
    dec c                                         ; $0F46
    jr nz, jr_000_0f33                            ; $0F47

    pop bc                                        ; $0F49
    ld de, $ffdf                                  ; $0F4A
    add hl, de                                    ; $0F4D
    dec c                                         ; $0F4E
    ld a, b                                       ; $0F4F
    and a                                         ; $0F50
    jr z, jr_000_0f90                             ; $0F51

    push bc                                       ; $0F53

jr_000_0f54:
    push bc                                       ; $0F54
    ld a, $ff                                     ; $0F55
    call Vram_WriteByteSafe                       ; $0F57
    ld a, b                                       ; $0F5A
    and $07                                       ; $0F5B
    jr nz, jr_000_0f62                            ; $0F5D

    push hl                                       ; $0F5F
    rst Rst08_WaitVBlank                          ; $0F60
    pop hl                                        ; $0F61

jr_000_0f62:
    pop bc                                        ; $0F62
    dec hl                                        ; $0F63
    dec b                                         ; $0F64
    jr nz, jr_000_0f54                            ; $0F65

    pop bc                                        ; $0F67
    ld de, $ffe1                                  ; $0F68
    add hl, de                                    ; $0F6B
    dec b                                         ; $0F6C
    ld a, c                                       ; $0F6D
    and a                                         ; $0F6E
    jr z, jr_000_0f90                             ; $0F6F

    push bc                                       ; $0F71

jr_000_0f72:
    push bc                                       ; $0F72
    ld a, $ff                                     ; $0F73
    call Vram_WriteByteSafe                       ; $0F75
    ld a, c                                       ; $0F78
    and $07                                       ; $0F79
    jr nz, jr_000_0f80                            ; $0F7B

    push hl                                       ; $0F7D
    rst Rst08_WaitVBlank                          ; $0F7E
    pop hl                                        ; $0F7F

jr_000_0f80:
    pop bc                                        ; $0F80
    ld de, $ffe0                                  ; $0F81
    add hl, de                                    ; $0F84
    dec c                                         ; $0F85
    jr nz, jr_000_0f72                            ; $0F86

    pop bc                                        ; $0F88
    ld de, $0021                                  ; $0F89
    add hl, de                                    ; $0F8C
    dec c                                         ; $0F8D
    jr jr_000_0f10                                ; $0F8E

jr_000_0f90:
    ld a, $ff                                     ; $0F90
    ldh [hBgpShadow], a                           ; $0F92
    ld bc, $0004                                  ; $0F94
    call Wait_Frames                              ; $0F97
    ret                                           ; $0F9A


; C: 16-byte tile used by the wipes. L3 pass 2026-10-26: read in BGB in 89 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Gfx_WipeTile::
    INCBIN "data/bank_00/Gfx_WipeTile.2bpp" ; $0F9B, 16 bytes
; C: serial interrupt body of the printer driver
Prn_SerialIrq::
    push af                                       ; $0FAB
    ldh a, [rSC]                                  ; $0FAC
    bit 7, a                                      ; $0FAE
    jr nz, jr_000_0fc0                            ; $0FB0

    push bc                                       ; $0FB2
    push de                                       ; $0FB3
    push hl                                       ; $0FB4
    ld a, $01                                     ; $0FB5
    ld [wPrnIrqSeen], a                           ; $0FB7
    call Prn_SerialStep                           ; $0FBA
    pop hl                                        ; $0FBD
    pop de                                        ; $0FBE
    pop bc                                        ; $0FBF

jr_000_0fc0:
    pop af                                        ; $0FC0
    reti                                          ; $0FC1


; C: every 6th VBlank sends the status poll when the printer is idle
Prn_VBlankPoll::
    ld a, [wPrnState]                             ; $0FC2
    cp $01                                        ; $0FC5
    ret nz                                        ; $0FC7

    ld a, [wPrnStatus]                            ; $0FC8
    cp $ff                                        ; $0FCB
    ret z                                         ; $0FCD

    ld a, [wPrnTxBusy]                            ; $0FCE
    and a                                         ; $0FD1
    ret nz                                        ; $0FD2

    ld hl, wPrnPollCnt                            ; $0FD3
    inc [hl]                                      ; $0FD6
    ld a, [hl]                                    ; $0FD7
    cp $06                                        ; $0FD8
    ret c                                         ; $0FDA

    xor a                                         ; $0FDB
    ld [hl], a                                    ; $0FDC
    ld [wPrnBusySeen], a                          ; $0FDD
    call Prn_SendInquiry                          ; $0FE0
    ret                                           ; $0FE3


; C: HL = A * L (8x8 shift-add)
Math_MulAL::
    push bc                                       ; $0FE4
    ld c, l                                       ; $0FE5
    ld b, $00                                     ; $0FE6
    ld hl, $0000                                  ; $0FE8
    bit 0, a                                      ; $0FEB
    jr z, jr_000_0ff0                             ; $0FED

    add hl, bc                                    ; $0FEF

jr_000_0ff0:
    sla c                                         ; $0FF0
    rl b                                          ; $0FF2
    bit 1, a                                      ; $0FF4
    jr z, jr_000_0ff9                             ; $0FF6

    add hl, bc                                    ; $0FF8

jr_000_0ff9:
    sla c                                         ; $0FF9
    rl b                                          ; $0FFB
    bit 2, a                                      ; $0FFD
    jr z, jr_000_1002                             ; $0FFF

    add hl, bc                                    ; $1001

jr_000_1002:
    sla c                                         ; $1002
    rl b                                          ; $1004
    bit 3, a                                      ; $1006
    jr z, jr_000_100b                             ; $1008

    add hl, bc                                    ; $100A

jr_000_100b:
    sla c                                         ; $100B
    rl b                                          ; $100D
    bit 4, a                                      ; $100F
    jr z, jr_000_1014                             ; $1011

    add hl, bc                                    ; $1013

jr_000_1014:
    sla c                                         ; $1014
    rl b                                          ; $1016
    bit 5, a                                      ; $1018
    jr z, jr_000_101d                             ; $101A

    add hl, bc                                    ; $101C

jr_000_101d:
    sla c                                         ; $101D
    rl b                                          ; $101F
    bit 6, a                                      ; $1021
    jr z, jr_000_1026                             ; $1023

    add hl, bc                                    ; $1025

jr_000_1026:
    sla c                                         ; $1026
    rl b                                          ; $1028
    bit 7, a                                      ; $102A
    jr z, jr_000_102f                             ; $102C

    add hl, bc                                    ; $102E

jr_000_102f:
    pop bc                                        ; $102F
    ret                                           ; $1030


; C: adds A (BCD) to the B-byte BCD number at HL; saturates at all $99
Bcd_AddSaturate::
    push bc                                       ; $1031
    push hl                                       ; $1032

jr_000_1033:
    add [hl]                                      ; $1033
    daa                                           ; $1034
    ld [hl+], a                                   ; $1035
    jr nc, jr_000_103d                            ; $1036

    ld a, $01                                     ; $1038
    dec b                                         ; $103A
    jr nz, jr_000_1033                            ; $103B

jr_000_103d:
    pop hl                                        ; $103D
    pop bc                                        ; $103E
    ret nc                                        ; $103F

    ld a, $99                                     ; $1040

jr_000_1042:
    ld [hl+], a                                   ; $1042
    dec b                                         ; $1043
    jr nz, jr_000_1042                            ; $1044

    ret                                           ; $1046


; C: quarter-wave table lookup: A = angle 0..255
Math_Sin::
    bit 7, a                                      ; $1047
    push af                                       ; $1049
    bit 6, a                                      ; $104A
    jr z, jr_000_104f                             ; $104C

    cpl                                           ; $104E

jr_000_104f:
    and $3f                                       ; $104F
    ld c, a                                       ; $1051
    ld b, $00                                     ; $1052
    ld hl, Math_SinTable                          ; $1054
    add hl, bc                                    ; $1057
    ld c, [hl]                                    ; $1058
    pop af                                        ; $1059
    ld a, c                                       ; $105A
    ret                                           ; $105B


; C: Math_Sin(A+$40)
Math_Cos::
    add $40                                       ; $105C
    jr Math_Sin                                   ; $105E

; C: 64-byte quarter-wave table
Math_SinTable::
    db $00, $06, $0c, $12, $19, $1f, $25, $2b, $31, $38, $3e, $44, $4a, $50, $56, $5c
    db $61, $67, $6d, $73, $78, $7e, $83, $88, $8e, $93, $98, $9d, $a2, $a7, $ab, $b0
    db $b5, $b9, $bd, $c1, $c5, $c9, $cd, $d1, $d4, $d8, $db, $de, $e1, $e4, $e7, $ea
    db $ec, $ee, $f1, $f3, $f4, $f6, $f8, $f9, $fb, $fc, $fd, $fe, $fe, $ff, $ff, $ff

; C: clears the 32-byte sprite-animation slot area at $D500
Anim_ClearSlots::
    ld hl, wSpriteAnimFrame                       ; $10A0
    xor a                                         ; $10A3
    ld b, $10                                     ; $10A4

jr_000_10a6:
    ld [hl+], a                                   ; $10A6
    ld [hl+], a                                   ; $10A7
    dec b                                         ; $10A8
    jr nz, jr_000_10a6                            ; $10A9

    ret                                           ; $10AB


; C: D.J. editor sound engine: steps the three channels then writes NR2x NR3x NR4x NR51 at LY=$80
DjSnd_Tick::
    ld a, [wTickFlag]                             ; $10AC
    and a                                         ; $10AF
    jp z, DjSnd_ModulationOnly                    ; $10B0

    call DjSnd_StepSoundI                         ; $10B3
    call DjSnd_StepSoundII                        ; $10B6
    call DjSnd_StepNoise                          ; $10B9
    call Call_000_1144                            ; $10BC

jr_000_10bf:
    ldh a, [rLY]                                  ; $10BF
    cp $80                                        ; $10C1
    jr nz, jr_000_10bf                            ; $10C3

    ld a, [wPerfChannelState]                     ; $10C5
    and a                                         ; $10C8
    jr z, jr_000_10e9                             ; $10C9

    ld a, [wRestFlags]                            ; $10CB
    and a                                         ; $10CE
    jr nz, jr_000_10e9                            ; $10CF

    ld a, [wNr21Nr22Shadow]                       ; $10D1
    ldh [rNR21], a                                ; $10D4
    ld a, [wNr21Nr22Shadow + $1]                  ; $10D6
    ldh [rNR22], a                                ; $10D9
    ld hl, wNr24ControlShadow                     ; $10DB
    ld a, [wSound1FreqCur]                        ; $10DE
    ldh [rNR23], a                                ; $10E1
    ld a, [wSound1FreqCur + $1]                   ; $10E3
    or [hl]                                       ; $10E6
    ldh [rNR24], a                                ; $10E7

jr_000_10e9:
    ld a, [wPerfChannelState + $1]                ; $10E9
    and a                                         ; $10EC
    jr z, jr_000_1118                             ; $10ED

    ld a, [wRestFlags + $1]                       ; $10EF
    and a                                         ; $10F2
    jr nz, jr_000_1118                            ; $10F3

    xor a                                         ; $10F5
    ldh [rNR30], a                                ; $10F6
    call DjSnd_LoadWaveRam                        ; $10F8
    ld a, [wNr30Nr32Shadow]                       ; $10FB
    ldh [rNR30], a                                ; $10FE
    ld a, [wNr30Nr32Shadow + $1]                  ; $1100
    ldh [rNR31], a                                ; $1103
    ld a, [wNr30Nr32Shadow + $2]                  ; $1105
    ldh [rNR32], a                                ; $1108
    ld hl, wNr34ControlShadow                     ; $110A
    ld a, [wSound2FreqCur]                        ; $110D
    ldh [rNR33], a                                ; $1110
    ld a, [wSound2FreqCur + $1]                   ; $1112
    or [hl]                                       ; $1115
    ldh [rNR34], a                                ; $1116

jr_000_1118:
    ld a, [wPerfChannelState + $2]                ; $1118
    and a                                         ; $111B
    jr z, jr_000_1138                             ; $111C

    ld a, [wRestFlags + $2]                       ; $111E
    and a                                         ; $1121
    jr nz, jr_000_1138                            ; $1122

    ld a, [wNr41Nr42Shadow]                       ; $1124
    ldh [rNR41], a                                ; $1127
    ld a, [wNr41Nr42Shadow + $1]                  ; $1129
    ldh [rNR42], a                                ; $112C
    ld a, [wNoiseNr43]                            ; $112E
    ldh [rNR43], a                                ; $1131
    ld a, [wNr44ControlShadow]                    ; $1133
    ldh [rNR44], a                                ; $1136

jr_000_1138:
    ld a, [wNr51PanShadow]                        ; $1138
    or $11                                        ; $113B
    ld hl, wPerfNr51Mask                          ; $113D
    and [hl]                                      ; $1140
    ldh [rNR51], a                                ; $1141
    ret                                           ; $1143


Call_000_1144:
    ld hl, wPerfStepIncrement                     ; $1144
    ld a, [wSound1PlayStep]                       ; $1147
    add [hl]                                      ; $114A
    ld [wSound1PlayStep], a                       ; $114B
    ld a, [wSound2PlayStep]                       ; $114E
    add [hl]                                      ; $1151
    ld [wSound2PlayStep], a                       ; $1152
    ld a, [wNoisePlayStep]                        ; $1155
    add [hl]                                      ; $1158
    ld [wNoisePlayStep], a                        ; $1159
    ld a, [wSound1PlayStep]                       ; $115C
    bit 7, a                                      ; $115F
    jr z, jr_000_116a                             ; $1161

    ld a, [wLoopLengths]                          ; $1163
    dec a                                         ; $1166
    ld [wSound1PlayStep], a                       ; $1167

jr_000_116a:
    ld a, [wSound2PlayStep]                       ; $116A
    bit 7, a                                      ; $116D
    jr z, jr_000_1178                             ; $116F

    ld a, [wLoopLengths + $1]                     ; $1171
    dec a                                         ; $1174
    ld [wSound2PlayStep], a                       ; $1175

jr_000_1178:
    ld a, [wNoisePlayStep]                        ; $1178
    bit 7, a                                      ; $117B
    jr z, jr_000_1186                             ; $117D

    ld a, [wNoiseGateLoop + $1]                   ; $117F
    dec a                                         ; $1182
    ld [wNoisePlayStep], a                        ; $1183

jr_000_1186:
    ld a, [wSound1PlayStep]                       ; $1186
    ld hl, wLoopLengths                           ; $1189
    cp [hl]                                       ; $118C
    jr c, jr_000_1193                             ; $118D

    xor a                                         ; $118F
    ld [wSound1PlayStep], a                       ; $1190

jr_000_1193:
    ld a, [wSound2PlayStep]                       ; $1193
    ld hl, wLoopLengths + $1                      ; $1196
    cp [hl]                                       ; $1199
    jr c, jr_000_11a0                             ; $119A

    xor a                                         ; $119C
    ld [wSound2PlayStep], a                       ; $119D

jr_000_11a0:
    ld a, [wNoisePlayStep]                        ; $11A0
    ld hl, wNoiseGateLoop + $1                    ; $11A3
    cp [hl]                                       ; $11A6
    jr c, jr_000_11ad                             ; $11A7

    xor a                                         ; $11A9
    ld [wNoisePlayStep], a                        ; $11AA

jr_000_11ad:
    ret                                           ; $11AD


; I: unreferenced; loads NR10-NR14 from Snd_UiEffect_Table
Snd_UiEffect_Dead::
    ld a, [wUiSfxRequest]                         ; $11AE
    and a                                         ; $11B1
    ret z                                         ; $11B2

    dec a                                         ; $11B3
    ld c, a                                       ; $11B4
    ld b, $00                                     ; $11B5
    ld hl, Snd_UiEffect_Table                     ; $11B7
    add hl, bc                                    ; $11BA
    ld c, [hl]                                    ; $11BB
    add hl, bc                                    ; $11BC
    ld c, $10                                     ; $11BD
    ld a, [hl+]                                   ; $11BF
    ldh [c], a                                    ; $11C0
    inc c                                         ; $11C1
    ld a, [hl+]                                   ; $11C2
    ldh [c], a                                    ; $11C3
    inc c                                         ; $11C4
    ld a, [hl+]                                   ; $11C5
    ldh [c], a                                    ; $11C6
    inc c                                         ; $11C7
    ld a, [hl+]                                   ; $11C8
    ldh [c], a                                    ; $11C9
    inc c                                         ; $11CA
    ld a, [hl]                                    ; $11CB
    ldh [c], a                                    ; $11CC
    xor a                                         ; $11CD
    ld [wUiSfxRequest], a                         ; $11CE
    ret                                           ; $11D1


; I
Snd_UiEffect_Table::
    db $08, $0c, $10, $14, $18, $1c, $20, $24, $17, $78, $f1, $00, $c7, $17, $7d, $f1
    db $40, $c7, $1f, $7d, $f1, $40, $c7, $77, $60, $f3, $80, $c7, $7f, $60, $8b, $80
    db $c7, $17, $7e, $f0, $c0, $c7, $1f, $7e, $f0, $c0, $c7, $17, $7e, $f1, $00, $c7

; C: SOUND I (NR21-NR24) next step
DjSnd_StepSoundI::
    ldh a, [hRomBankShadow]                       ; $1202
    push af                                       ; $1204
    ld a, $1f                                     ; $1205
    ldh [hRomBankShadow], a                       ; $1207
    ld [rROMB0], a                                ; $1209
    ld hl, wNr24ControlShadow                     ; $120C
    ld [hl], $c0                                  ; $120F
    ld a, [wSound1DutyLen + $1]                   ; $1211
    and a                                         ; $1214
    jr nz, jr_000_121a                            ; $1215

    res 6, [hl]                                   ; $1217
    inc a                                         ; $1219

jr_000_121a:
    dec a                                         ; $121A
    ld c, a                                       ; $121B
    ld b, $00                                     ; $121C
    ld hl, Snd_LengthTbl                          ; $121E
    add hl, bc                                    ; $1221
    ld a, [wSound1DutyLen]                        ; $1222
    swap a                                        ; $1225
    sla a                                         ; $1227
    sla a                                         ; $1229
    or [hl]                                       ; $122B
    ld [wNr21Nr22Shadow], a                       ; $122C
    ld a, [wSound1VolAtten]                       ; $122F
    ld c, a                                       ; $1232
    ld a, [wSound1Envelope + $2]                  ; $1233
    sub c                                         ; $1236
    jr nc, jr_000_123a                            ; $1237

    xor a                                         ; $1239

jr_000_123a:
    swap a                                        ; $123A
    ld c, a                                       ; $123C
    ld a, [wSound1Envelope]                       ; $123D
    xor $01                                       ; $1240
    sla a                                         ; $1242
    sla a                                         ; $1244
    sla a                                         ; $1246
    or c                                          ; $1248
    ld c, a                                       ; $1249
    ld a, [wSound1Envelope + $1]                  ; $124A
    or c                                          ; $124D
    ld [wNr21Nr22Shadow + $1], a                  ; $124E
    xor a                                         ; $1251
    ld [wRestFlags], a                            ; $1252
    ld a, [wSound1PlayStep]                       ; $1255
    ld c, a                                       ; $1258
    ld b, $00                                     ; $1259
    ld hl, wSound1Notes                           ; $125B
    add hl, bc                                    ; $125E
    ld a, [hl]                                    ; $125F
    and a                                         ; $1260
    jr z, jr_000_126b                             ; $1261

    ld hl, wPerfPitchShift                        ; $1263
    add [hl]                                      ; $1266
    cp $26                                        ; $1267
    jr c, jr_000_128e                             ; $1269

jr_000_126b:
    ld a, $01                                     ; $126B
    ld [wRestFlags], a                            ; $126D
    ld a, [wRestCounters]                         ; $1270
    ld hl, wLoopLengths                           ; $1273
    cp [hl]                                       ; $1276
    jr c, jr_000_1283                             ; $1277

    ld a, [wNr51PanShadow]                        ; $1279
    and $dd                                       ; $127C
    ld [wNr51PanShadow], a                        ; $127E
    jr jr_000_1287                                ; $1281

jr_000_1283:
    inc a                                         ; $1283
    ld [wRestCounters], a                         ; $1284

jr_000_1287:
    pop af                                        ; $1287
    ldh [hRomBankShadow], a                       ; $1288
    ld [rROMB0], a                                ; $128A
    ret                                           ; $128D


jr_000_128e:
    dec a                                         ; $128E
    ld c, a                                       ; $128F
    ld b, $00                                     ; $1290
    ld hl, Snd_ModBaseTbl                         ; $1292
    add hl, bc                                    ; $1295
    ld a, [hl]                                    ; $1296
    ld [wSound1ModBase], a                        ; $1297
    sla c                                         ; $129A
    rl b                                          ; $129C
    ld hl, Snd_FreqTbl + $18                      ; $129E
    add hl, bc                                    ; $12A1
    ld a, [hl+]                                   ; $12A2
    ld [wSound1FreqCur], a                        ; $12A3
    ld [wSound1FreqBase], a                       ; $12A6
    ld a, [hl]                                    ; $12A9
    ld [wSound1FreqCur + $1], a                   ; $12AA
    ld [wSound1FreqBase + $1], a                  ; $12AD
    xor a                                         ; $12B0
    ld [wSound1ModPhase], a                       ; $12B1
    ld [wSound1ModPhase + $1], a                  ; $12B4
    ld a, [wSound1PlayStep]                       ; $12B7
    ld c, a                                       ; $12BA
    ld b, $00                                     ; $12BB
    ld hl, wSound1Stereo                          ; $12BD
    add hl, bc                                    ; $12C0
    ld c, [hl]                                    ; $12C1
    ld hl, DjSnd_StereoMaskI                      ; $12C2
    add hl, bc                                    ; $12C5
    ld a, [wNr51PanShadow]                        ; $12C6
    and $dd                                       ; $12C9
    or [hl]                                       ; $12CB
    ld [wNr51PanShadow], a                        ; $12CC
    xor a                                         ; $12CF
    ld [wRestCounters], a                         ; $12D0
    pop af                                        ; $12D3
    ldh [hRomBankShadow], a                       ; $12D4
    ld [rROMB0], a                                ; $12D6
    ret                                           ; $12D9


; C: 3 bytes NR51 masks
DjSnd_StereoMaskI::
    db $20, $22, $02

; C: SOUND II (wave channel NR30-NR34) next step
DjSnd_StepSoundII::
    ldh a, [hRomBankShadow]                       ; $12DD
    push af                                       ; $12DF
    ld a, $1f                                     ; $12E0
    ldh [hRomBankShadow], a                       ; $12E2
    ld [rROMB0], a                                ; $12E4
    ld hl, wNr34ControlShadow                     ; $12E7
    ld [hl], $c0                                  ; $12EA
    ld a, [wSound2WaveLen + $1]                   ; $12EC
    and a                                         ; $12EF
    jr nz, jr_000_12f5                            ; $12F0

    res 6, [hl]                                   ; $12F2
    inc a                                         ; $12F4

jr_000_12f5:
    dec a                                         ; $12F5
    ld c, a                                       ; $12F6
    ld b, $00                                     ; $12F7
    ld hl, Snd_LengthTbl                          ; $12F9
    add hl, bc                                    ; $12FC
    ld a, [hl]                                    ; $12FD
    or $c0                                        ; $12FE
    ld [wNr30Nr32Shadow + $1], a                  ; $1300
    ld a, $80                                     ; $1303
    ld [wNr30Nr32Shadow], a                       ; $1305
    ld a, $20                                     ; $1308
    ld [wNr30Nr32Shadow + $2], a                  ; $130A
    xor a                                         ; $130D
    ld [wRestFlags + $1], a                       ; $130E
    ld a, [wSound2PlayStep]                       ; $1311
    ld c, a                                       ; $1314
    ld b, $00                                     ; $1315
    ld hl, wSound2Notes                           ; $1317
    add hl, bc                                    ; $131A
    ld a, [hl]                                    ; $131B
    and a                                         ; $131C
    jr z, jr_000_1327                             ; $131D

    ld hl, wPerfPitchShift                        ; $131F
    add [hl]                                      ; $1322
    cp $26                                        ; $1323
    jr c, jr_000_134a                             ; $1325

jr_000_1327:
    ld a, $01                                     ; $1327
    ld [wRestFlags + $1], a                       ; $1329
    ld a, [wRestCounters + $1]                    ; $132C
    ld hl, wLoopLengths + $1                      ; $132F
    cp [hl]                                       ; $1332
    jr c, jr_000_133f                             ; $1333

    ld a, [wNr51PanShadow]                        ; $1335
    and $bb                                       ; $1338
    ld [wNr51PanShadow], a                        ; $133A
    jr jr_000_1343                                ; $133D

jr_000_133f:
    inc a                                         ; $133F
    ld [wRestCounters + $1], a                    ; $1340

jr_000_1343:
    pop af                                        ; $1343
    ldh [hRomBankShadow], a                       ; $1344
    ld [rROMB0], a                                ; $1346
    ret                                           ; $1349


jr_000_134a:
    dec a                                         ; $134A
    ld c, a                                       ; $134B
    ld b, $00                                     ; $134C
    ld hl, Snd_ModBaseTbl                         ; $134E
    add hl, bc                                    ; $1351
    ld a, [hl]                                    ; $1352
    ld [wSound2ModBase], a                        ; $1353
    sla c                                         ; $1356
    rl b                                          ; $1358
    ld hl, Snd_FreqTbl + $18                      ; $135A
    add hl, bc                                    ; $135D
    ld a, [hl+]                                   ; $135E
    ld [wSound2FreqCur], a                        ; $135F
    ld [wSound2FreqBase], a                       ; $1362
    ld a, [hl]                                    ; $1365
    ld [wSound2FreqCur + $1], a                   ; $1366
    ld [wSound2FreqBase + $1], a                  ; $1369
    xor a                                         ; $136C
    ld [wSound2ModPhase], a                       ; $136D
    ld [wSound2ModPhase + $1], a                  ; $1370
    ld a, [wSound2PlayStep]                       ; $1373
    ld c, a                                       ; $1376
    ld b, $00                                     ; $1377
    ld hl, wSound2Stereo                          ; $1379
    add hl, bc                                    ; $137C
    ld c, [hl]                                    ; $137D
    ld hl, DjSnd_StereoMaskII                     ; $137E
    add hl, bc                                    ; $1381
    ld a, [wNr51PanShadow]                        ; $1382
    and $bb                                       ; $1385
    or [hl]                                       ; $1387
    ld [wNr51PanShadow], a                        ; $1388
    xor a                                         ; $138B
    ld [wRestCounters + $1], a                    ; $138C
    pop af                                        ; $138F
    ldh [hRomBankShadow], a                       ; $1390
    ld [rROMB0], a                                ; $1392
    ret                                           ; $1395


; C: 3 bytes NR51 masks
DjSnd_StereoMaskII::
    db $40, $44, $04

; C: NOISE (NR41-NR44) next step
DjSnd_StepNoise::
    ldh a, [hRomBankShadow]                       ; $1399
    push af                                       ; $139B
    ld a, $1f                                     ; $139C
    ldh [hRomBankShadow], a                       ; $139E
    ld [rROMB0], a                                ; $13A0
    ld hl, wNr44ControlShadow                     ; $13A3
    ld a, $c0                                     ; $13A6
    ld [hl], a                                    ; $13A8
    ld a, [wNoiseGateLoop]                        ; $13A9
    and a                                         ; $13AC
    jr nz, jr_000_13b2                            ; $13AD

    res 6, [hl]                                   ; $13AF
    inc a                                         ; $13B1

jr_000_13b2:
    dec a                                         ; $13B2
    ld c, a                                       ; $13B3
    ld b, $00                                     ; $13B4
    ld hl, Snd_LengthTbl                          ; $13B6
    add hl, bc                                    ; $13B9
    ld a, [hl]                                    ; $13BA
    ld [wNr41Nr42Shadow], a                       ; $13BB
    ld a, [wNoiseVolAtten]                        ; $13BE
    ld c, a                                       ; $13C1
    ld a, [wNoiseEnvelope + $2]                   ; $13C2
    sub c                                         ; $13C5
    jr nc, jr_000_13c9                            ; $13C6

    xor a                                         ; $13C8

jr_000_13c9:
    swap a                                        ; $13C9
    ld c, a                                       ; $13CB
    ld a, [wNoiseEnvelope]                        ; $13CC
    xor $01                                       ; $13CF
    sla a                                         ; $13D1
    sla a                                         ; $13D3
    sla a                                         ; $13D5
    or c                                          ; $13D7
    ld c, a                                       ; $13D8
    ld a, [wNoiseEnvelope + $1]                   ; $13D9
    or c                                          ; $13DC
    ld [wNr41Nr42Shadow + $1], a                  ; $13DD
    xor a                                         ; $13E0
    ld [wRestFlags + $2], a                       ; $13E1
    ld a, [wNoisePlayStep]                        ; $13E4
    ld c, a                                       ; $13E7
    ld b, $00                                     ; $13E8
    ld hl, wNoiseNotes                            ; $13EA
    add hl, bc                                    ; $13ED
    ld a, [hl]                                    ; $13EE
    and a                                         ; $13EF
    jr nz, jr_000_1415                            ; $13F0

    ld a, $01                                     ; $13F2
    ld [wRestFlags + $2], a                       ; $13F4
    ld a, [wRestCounters + $2]                    ; $13F7
    ld hl, wNoiseGateLoop + $1                    ; $13FA
    cp [hl]                                       ; $13FD
    jr c, jr_000_140a                             ; $13FE

    ld a, [wNr51PanShadow]                        ; $1400
    and $77                                       ; $1403
    ld [wNr51PanShadow], a                        ; $1405
    jr jr_000_140e                                ; $1408

jr_000_140a:
    inc a                                         ; $140A
    ld [wRestCounters + $2], a                    ; $140B

jr_000_140e:
    pop af                                        ; $140E
    ldh [hRomBankShadow], a                       ; $140F
    ld [rROMB0], a                                ; $1411
    ret                                           ; $1414


jr_000_1415:
    dec a                                         ; $1415
    ld c, a                                       ; $1416
    ld b, $00                                     ; $1417
    ld hl, Snd_NoiseNR43Tbl                       ; $1419
    add hl, bc                                    ; $141C
    ld a, [hl]                                    ; $141D
    ld [wNoiseNr43], a                            ; $141E
    ld a, [wNoisePlayStep]                        ; $1421
    ld c, a                                       ; $1424
    ld b, $00                                     ; $1425
    ld hl, wNoiseStereoWidth                      ; $1427
    add hl, bc                                    ; $142A
    ld a, [hl]                                    ; $142B
    push af                                       ; $142C
    and $0f                                       ; $142D
    ld c, a                                       ; $142F
    ld hl, DjSnd_StepNoise_Tbl1452                ; $1430
    add hl, bc                                    ; $1433
    ld a, [wNr51PanShadow]                        ; $1434
    and $77                                       ; $1437
    or [hl]                                       ; $1439
    ld [wNr51PanShadow], a                        ; $143A
    pop af                                        ; $143D
    and $10                                       ; $143E
    srl a                                         ; $1440
    ld hl, wNoiseNr43                             ; $1442
    or [hl]                                       ; $1445
    ld [hl], a                                    ; $1446
    xor a                                         ; $1447
    ld [wRestCounters + $2], a                    ; $1448
    pop af                                        ; $144B
    ldh [hRomBankShadow], a                       ; $144C
    ld [rROMB0], a                                ; $144E
    ret                                           ; $1451


; C: auto: 3 bytes, bytes; referenced by DjSnd_StepNoise. L3 pass 2026-10-26: read in BGB in the scenarios dj_editor
; 1F:05, dj_editor 1F:09, dj_editor_sound2 1F:05, dj_editor_sound2 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjSnd_StepNoise_Tbl1452::
    db $80, $88, $08

; C: writes the 32-nibble staging buffer to wave RAM $FF30-$FF3F
DjSnd_LoadWaveRam::
    ld c, $30                                     ; $1455
    ld hl, wWaveStaging                           ; $1457
    ld a, [hl+]                                   ; $145A
    swap a                                        ; $145B
    or [hl]                                       ; $145D
    ldh [c], a                                    ; $145E
    inc hl                                        ; $145F
    inc c                                         ; $1460
    ld a, [hl+]                                   ; $1461
    swap a                                        ; $1462
    or [hl]                                       ; $1464
    ldh [c], a                                    ; $1465
    inc hl                                        ; $1466
    inc c                                         ; $1467
    ld a, [hl+]                                   ; $1468
    swap a                                        ; $1469
    or [hl]                                       ; $146B
    ldh [c], a                                    ; $146C
    inc hl                                        ; $146D
    inc c                                         ; $146E
    ld a, [hl+]                                   ; $146F
    swap a                                        ; $1470
    or [hl]                                       ; $1472
    ldh [c], a                                    ; $1473
    inc hl                                        ; $1474
    inc c                                         ; $1475
    ld a, [hl+]                                   ; $1476
    swap a                                        ; $1477
    or [hl]                                       ; $1479
    ldh [c], a                                    ; $147A
    inc hl                                        ; $147B
    inc c                                         ; $147C
    ld a, [hl+]                                   ; $147D
    swap a                                        ; $147E
    or [hl]                                       ; $1480
    ldh [c], a                                    ; $1481
    inc hl                                        ; $1482
    inc c                                         ; $1483
    ld a, [hl+]                                   ; $1484
    swap a                                        ; $1485
    or [hl]                                       ; $1487
    ldh [c], a                                    ; $1488
    inc hl                                        ; $1489
    inc c                                         ; $148A
    ld a, [hl+]                                   ; $148B
    swap a                                        ; $148C
    or [hl]                                       ; $148E
    ldh [c], a                                    ; $148F
    inc hl                                        ; $1490
    inc c                                         ; $1491
    ld a, [hl+]                                   ; $1492
    swap a                                        ; $1493
    or [hl]                                       ; $1495
    ldh [c], a                                    ; $1496
    inc hl                                        ; $1497
    inc c                                         ; $1498
    ld a, [hl+]                                   ; $1499
    swap a                                        ; $149A
    or [hl]                                       ; $149C
    ldh [c], a                                    ; $149D
    inc hl                                        ; $149E
    inc c                                         ; $149F
    ld a, [hl+]                                   ; $14A0
    swap a                                        ; $14A1
    or [hl]                                       ; $14A3
    ldh [c], a                                    ; $14A4
    inc hl                                        ; $14A5
    inc c                                         ; $14A6
    ld a, [hl+]                                   ; $14A7
    swap a                                        ; $14A8
    or [hl]                                       ; $14AA
    ldh [c], a                                    ; $14AB
    inc hl                                        ; $14AC
    inc c                                         ; $14AD
    ld a, [hl+]                                   ; $14AE
    swap a                                        ; $14AF
    or [hl]                                       ; $14B1
    ldh [c], a                                    ; $14B2
    inc hl                                        ; $14B3
    inc c                                         ; $14B4
    ld a, [hl+]                                   ; $14B5
    swap a                                        ; $14B6
    or [hl]                                       ; $14B8
    ldh [c], a                                    ; $14B9
    inc hl                                        ; $14BA
    inc c                                         ; $14BB
    ld a, [hl+]                                   ; $14BC
    swap a                                        ; $14BD
    or [hl]                                       ; $14BF
    ldh [c], a                                    ; $14C0
    inc hl                                        ; $14C1
    inc c                                         ; $14C2
    ld a, [hl+]                                   ; $14C3
    swap a                                        ; $14C4
    or [hl]                                       ; $14C6
    ldh [c], a                                    ; $14C7
    inc hl                                        ; $14C8
    inc c                                         ; $14C9
    ret                                           ; $14CA


; C: copies the selected wave (D985) to the staging buffer minus the volume attenuation
DjSnd_BuildWaveStaging::
    ld a, [wSound2WaveLen]                        ; $14CB
    sla a                                         ; $14CE
    ld c, a                                       ; $14D0
    ld b, $00                                     ; $14D1
    ld hl, DjSnd_WavePtrs                         ; $14D3
    add hl, bc                                    ; $14D6
    ld a, [hl+]                                   ; $14D7
    ld h, [hl]                                    ; $14D8
    ld l, a                                       ; $14D9
    ld de, wWaveStaging                           ; $14DA
    ld a, [wSound2VolAtten]                       ; $14DD
    sub $01                                       ; $14E0
    jr nc, jr_000_14e5                            ; $14E2

    xor a                                         ; $14E4

jr_000_14e5:
    ld c, a                                       ; $14E5
    ld b, $20                                     ; $14E6

jr_000_14e8:
    ld a, [hl+]                                   ; $14E8
    sub c                                         ; $14E9
    jr nc, jr_000_14ed                            ; $14EA

    xor a                                         ; $14EC

jr_000_14ed:
    ld [de], a                                    ; $14ED
    inc de                                        ; $14EE
    dec b                                         ; $14EF
    jr nz, jr_000_14e8                            ; $14F0

    ret                                           ; $14F2


; I: pointer table of the built-in waves. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0E 1F)
DjSnd_WavePtrs::
    db $f9, $14, $19, $15, $65, $d9

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
    call DjSnd_ModulateSoundI                     ; $1539
    call DjSnd_ModulateSoundII                    ; $153C

jr_000_153f:
    ldh a, [rLY]                                  ; $153F
    cp $80                                        ; $1541
    jr nz, jr_000_153f                            ; $1543

    ld a, [wNr24ControlShadow]                    ; $1545
    res 7, a                                      ; $1548
    ld c, a                                       ; $154A
    ld a, [wSound1FreqCur]                        ; $154B
    ldh [rNR23], a                                ; $154E
    ld a, [wSound1FreqCur + $1]                   ; $1550
    or c                                          ; $1553
    ldh [rNR24], a                                ; $1554
    ld a, [wNr34ControlShadow]                    ; $1556
    res 7, a                                      ; $1559
    ld c, a                                       ; $155B
    ld a, [wSound2FreqCur]                        ; $155C
    ldh [rNR33], a                                ; $155F
    ld a, [wSound2FreqCur + $1]                   ; $1561
    or c                                          ; $1564
    ldh [rNR34], a                                ; $1565
    ld a, [wNr51PanShadow]                        ; $1567
    or $11                                        ; $156A
    ld hl, wPerfNr51Mask                          ; $156C
    and [hl]                                      ; $156F
    ldh [rNR51], a                                ; $1570
    ret                                           ; $1572


; C: vibrato / LFO of SOUND I (sine
DjSnd_ModulateSoundI::
    ld a, [wSound1Modulation]                     ; $1573
    ld l, a                                       ; $1576
    ld a, [wSound1ModBase]                        ; $1577
    call Math_MulAL                               ; $157A
    ld l, h                                       ; $157D
    push hl                                       ; $157E
    ld a, [wSound1Modulation + $1]                ; $157F
    cpl                                           ; $1582
    add $64                                       ; $1583
    ld l, $80                                     ; $1585
    call Math_MulAL                               ; $1587
    ld bc, $0d80                                  ; $158A
    add hl, bc                                    ; $158D
    ld c, l                                       ; $158E
    ld b, h                                       ; $158F
    ld hl, wSound1ModPhase                        ; $1590
    ld a, [hl]                                    ; $1593
    add c                                         ; $1594
    ld [hl+], a                                   ; $1595
    ld a, [hl]                                    ; $1596
    adc b                                         ; $1597
    ld [hl], a                                    ; $1598
    ld a, [wSound1Modulation + $2]                ; $1599
    and a                                         ; $159C
    jr z, jr_000_15e2                             ; $159D

    dec a                                         ; $159F
    jr z, jr_000_15e8                             ; $15A0

    ld a, [wModRandPhase]                         ; $15A2
    xor [hl]                                      ; $15A5
    bit 6, a                                      ; $15A6
    jr nz, jr_000_15d4                            ; $15A8

    pop hl                                        ; $15AA
    ret                                           ; $15AB


jr_000_15ac:
    pop hl                                        ; $15AC
    push af                                       ; $15AD
    call Math_MulAL                               ; $15AE
    pop af                                        ; $15B1
    jr nz, jr_000_15c4                            ; $15B2

    ld a, [wSound1FreqBase]                       ; $15B4
    add h                                         ; $15B7
    ld [wSound1FreqCur], a                        ; $15B8
    ld a, [wSound1FreqBase + $1]                  ; $15BB
    adc $00                                       ; $15BE
    ld [wSound1FreqCur + $1], a                   ; $15C0
    ret                                           ; $15C3


jr_000_15c4:
    ld a, [wSound1FreqBase]                       ; $15C4
    sub h                                         ; $15C7
    ld [wSound1FreqCur], a                        ; $15C8
    ld a, [wSound1FreqBase + $1]                  ; $15CB
    sbc $00                                       ; $15CE
    ld [wSound1FreqCur + $1], a                   ; $15D0
    ret                                           ; $15D3


jr_000_15d4:
    ld a, [hl]                                    ; $15D4
    ld [wModRandPhase], a                         ; $15D5
    xor a                                         ; $15D8
    push af                                       ; $15D9
    call Rng_Next                                 ; $15DA
    ld c, a                                       ; $15DD
    pop af                                        ; $15DE
    ld a, c                                       ; $15DF
    jr jr_000_15ac                                ; $15E0

jr_000_15e2:
    ld a, [hl]                                    ; $15E2
    call Math_Sin                                 ; $15E3
    jr jr_000_15ac                                ; $15E6

jr_000_15e8:
    ld a, [hl]                                    ; $15E8
    bit 7, a                                      ; $15E9
    ld a, $ff                                     ; $15EB
    jr jr_000_15ac                                ; $15ED

; C: vibrato / LFO of SOUND II
DjSnd_ModulateSoundII::
    ld a, [wSound2Modulation]                     ; $15EF
    ld l, a                                       ; $15F2
    ld a, [wSound2ModBase]                        ; $15F3
    call Math_MulAL                               ; $15F6
    ld l, h                                       ; $15F9
    push hl                                       ; $15FA
    ld a, [wSound2Modulation + $1]                ; $15FB
    cpl                                           ; $15FE
    add $64                                       ; $15FF
    ld l, $80                                     ; $1601
    call Math_MulAL                               ; $1603
    ld bc, $0d80                                  ; $1606
    add hl, bc                                    ; $1609
    ld c, l                                       ; $160A
    ld b, h                                       ; $160B
    ld hl, wSound2ModPhase                        ; $160C
    ld a, [hl]                                    ; $160F
    add c                                         ; $1610
    ld [hl+], a                                   ; $1611
    ld a, [hl]                                    ; $1612
    adc b                                         ; $1613
    ld [hl], a                                    ; $1614
    ld a, [wSound2Modulation + $2]                ; $1615
    and a                                         ; $1618
    jr z, jr_000_165e                             ; $1619

    dec a                                         ; $161B
    jr z, jr_000_1664                             ; $161C

    ld a, [wModRandPhase + $1]                    ; $161E
    xor [hl]                                      ; $1621
    bit 6, a                                      ; $1622
    jr nz, jr_000_1650                            ; $1624

    pop hl                                        ; $1626
    ret                                           ; $1627


jr_000_1628:
    pop hl                                        ; $1628
    push af                                       ; $1629
    call Math_MulAL                               ; $162A
    pop af                                        ; $162D
    jr nz, jr_000_1640                            ; $162E

    ld a, [wSound2FreqBase]                       ; $1630
    add h                                         ; $1633
    ld [wSound2FreqCur], a                        ; $1634
    ld a, [wSound2FreqBase + $1]                  ; $1637
    adc $00                                       ; $163A
    ld [wSound2FreqCur + $1], a                   ; $163C
    ret                                           ; $163F


jr_000_1640:
    ld a, [wSound2FreqBase]                       ; $1640
    sub h                                         ; $1643
    ld [wSound2FreqCur], a                        ; $1644
    ld a, [wSound2FreqBase + $1]                  ; $1647
    sbc $00                                       ; $164A
    ld [wSound2FreqCur + $1], a                   ; $164C
    ret                                           ; $164F


jr_000_1650:
    ld a, [hl]                                    ; $1650
    ld [wModRandPhase + $1], a                    ; $1651
    xor a                                         ; $1654
    push af                                       ; $1655
    call Rng_Next                                 ; $1656
    ld c, a                                       ; $1659
    pop af                                        ; $165A
    ld a, c                                       ; $165B
    jr jr_000_1628                                ; $165C

jr_000_165e:
    ld a, [hl]                                    ; $165E
    call Math_Sin                                 ; $165F
    jr jr_000_1628                                ; $1662

jr_000_1664:
    ld a, [hl]                                    ; $1664
    bit 7, a                                      ; $1665
    ld a, $ff                                     ; $1667
    jr jr_000_1628                                ; $1669

; C: ANDs a 7x8-tile image (pointer from Img_AndMaskTiles_Ptrs indexed by $D7E4) with the mask at 27:5BB0, 2 image
; bytes per mask byte; callers in bank 6
Img_AndMaskTiles_Bank27::
    ldh a, [hRomBankShadow]                       ; $166B
    push af                                       ; $166D
    ld a, $27                                     ; $166E
    ldh [hRomBankShadow], a                       ; $1670
    ld [rROMB0], a                                ; $1672
    ld a, [wShootPhase]                           ; $1675
    sla a                                         ; $1678
    ld c, a                                       ; $167A
    ld b, $00                                     ; $167B
    ld hl, Img_AndMaskTiles_Ptrs                  ; $167D
    add hl, bc                                    ; $1680
    ld e, [hl]                                    ; $1681
    inc hl                                        ; $1682
    ld d, [hl]                                    ; $1683
    ld hl, Mask_27_6210_Img_AndMaskTiles_Oval     ; $1684
    ld b, $07                                     ; $1687

jr_000_1689:
    ld c, $08                                     ; $1689

jr_000_168b:
    ld a, [de]                                    ; $168B
    and [hl]                                      ; $168C
    ld [de], a                                    ; $168D
    inc de                                        ; $168E
    ld a, [de]                                    ; $168F
    and [hl]                                      ; $1690
    ld [de], a                                    ; $1691
    inc de                                        ; $1692
    inc hl                                        ; $1693
    ld a, [de]                                    ; $1694
    and [hl]                                      ; $1695
    ld [de], a                                    ; $1696
    inc de                                        ; $1697
    ld a, [de]                                    ; $1698
    and [hl]                                      ; $1699
    ld [de], a                                    ; $169A
    inc de                                        ; $169B
    inc hl                                        ; $169C
    ld a, [de]                                    ; $169D
    and [hl]                                      ; $169E
    ld [de], a                                    ; $169F
    inc de                                        ; $16A0
    ld a, [de]                                    ; $16A1
    and [hl]                                      ; $16A2
    ld [de], a                                    ; $16A3
    inc de                                        ; $16A4
    inc hl                                        ; $16A5
    ld a, [de]                                    ; $16A6
    and [hl]                                      ; $16A7
    ld [de], a                                    ; $16A8
    inc de                                        ; $16A9
    ld a, [de]                                    ; $16AA
    and [hl]                                      ; $16AB
    ld [de], a                                    ; $16AC
    inc de                                        ; $16AD
    inc hl                                        ; $16AE
    ld a, [de]                                    ; $16AF
    and [hl]                                      ; $16B0
    ld [de], a                                    ; $16B1
    inc de                                        ; $16B2
    ld a, [de]                                    ; $16B3
    and [hl]                                      ; $16B4
    ld [de], a                                    ; $16B5
    inc de                                        ; $16B6
    inc hl                                        ; $16B7
    ld a, [de]                                    ; $16B8
    and [hl]                                      ; $16B9
    ld [de], a                                    ; $16BA
    inc de                                        ; $16BB
    ld a, [de]                                    ; $16BC
    and [hl]                                      ; $16BD
    ld [de], a                                    ; $16BE
    inc de                                        ; $16BF
    inc hl                                        ; $16C0
    ld a, [de]                                    ; $16C1
    and [hl]                                      ; $16C2
    ld [de], a                                    ; $16C3
    inc de                                        ; $16C4
    ld a, [de]                                    ; $16C5
    and [hl]                                      ; $16C6
    ld [de], a                                    ; $16C7
    inc de                                        ; $16C8
    inc hl                                        ; $16C9
    ld a, [de]                                    ; $16CA
    and [hl]                                      ; $16CB
    ld [de], a                                    ; $16CC
    inc de                                        ; $16CD
    ld a, [de]                                    ; $16CE
    and [hl]                                      ; $16CF
    ld [de], a                                    ; $16D0
    inc de                                        ; $16D1
    inc hl                                        ; $16D2
    dec c                                         ; $16D3
    jr nz, jr_000_168b                            ; $16D4

    ld a, e                                       ; $16D6
    add $80                                       ; $16D7
    ld e, a                                       ; $16D9
    jr nc, jr_000_16dd                            ; $16DA

    inc d                                         ; $16DC

jr_000_16dd:
    dec b                                         ; $16DD
    jr nz, jr_000_1689                            ; $16DE

    pop af                                        ; $16E0
    ldh [hRomBankShadow], a                       ; $16E1
    ld [rROMB0], a                                ; $16E3
    ret                                           ; $16E6


; C: pointer table indexed by $D7E4 x 2: image pointers for Img_AndMaskTiles_Bank27
Img_AndMaskTiles_Ptrs::
    db $00, $c0, $80, $c0, $00, $c7, $80, $c7

; C: A<$80: A = photo_vector_ram[A]. L3 pass 2026-10-26: executed in BGB in 55 replay(s) of the organic corpus, modes
; 0F 12 1A (tcrf_check/assets/l3_names/)
Vec_GetPhotoVectorByte::
    push bc                                       ; $16EF
    push de                                       ; $16F0
    push hl                                       ; $16F1
    bit 7, a                                      ; $16F2
    jr nz, jr_000_16fe                            ; $16F4

    ld c, a                                       ; $16F6
    ld b, $00                                     ; $16F7
    ld hl, wPhotoVectorRam                        ; $16F9
    add hl, bc                                    ; $16FC
    ld a, [hl]                                    ; $16FD

jr_000_16fe:
    pop hl                                        ; $16FE
    pop de                                        ; $16FF
    pop bc                                        ; $1700
    ret                                           ; $1701


; C: A<$80: far call 02:444D. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Vec_GetPhotoVectorByteFar::
    push bc                                       ; $1702
    push de                                       ; $1703
    push hl                                       ; $1704
    bit 7, a                                      ; $1705
    jr nz, jr_000_1713                            ; $1707

    ldh [hFarcallAArg], a                         ; $1709
    farcall Photo_FindSlot_Far                    ; $170B

jr_000_1713:
    pop hl                                        ; $1713
    pop de                                        ; $1714
    pop bc                                        ; $1715
    ret                                           ; $1716


; C: glyph A of the font table of bank $10 ($7600 + 16 x A, 160 slots up to $7FFF) copied as 16 bytes to DE; the DJ
; print renderer (05:60EE) calls it twice per character: glyph code and code + $10 (an 8x16 character, two tiles one
; over the other, to $C200 + col x 16 and +$130 for the second row), except ...
Gfx_Copy16FromBank10::
    push bc                                       ; $1717
    push hl                                       ; $1718
    swap a                                        ; $1719
    push af                                       ; $171B
    and $f0                                       ; $171C
    ld c, a                                       ; $171E
    pop af                                        ; $171F
    and $0f                                       ; $1720
    ld b, a                                       ; $1722
    ld hl, Gfx_10_7600_DjPrintFont_Tiles00to2A    ; $1723
    add hl, bc                                    ; $1726
    ldh a, [hRomBankShadow]                       ; $1727
    push af                                       ; $1729
    ld a, $10                                     ; $172A
    ldh [hRomBankShadow], a                       ; $172C
    ld [rROMB0], a                                ; $172E
    REPT 15                                       ; $1731
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 15 copies of 3 bytes
    ld a, [hl+]                                   ; $175E
    ld [de], a                                    ; $175F
    inc de                                        ; $1760
    pop af                                        ; $1761
    ldh [hRomBankShadow], a                       ; $1762
    ld [rROMB0], a                                ; $1764
    pop hl                                        ; $1767
    pop bc                                        ; $1768
    ret                                           ; $1769


; I: builds the three boss collision masks at D000/D040/D080 (via 05:7F69 and 16C4)
Sf2_BuildBossMasks::
    call Sf2_BossVariantToGroup                   ; $176A
    push af                                       ; $176D
    ld c, $02                                     ; $176E
    ldh [hFarcallAArg], a                         ; $1770
    ld a, BANK(Album_LoadNumeralTileB)            ; $1772
    ld hl, Album_LoadNumeralTileB_7CE3            ; $1774
    call Far_Call                                 ; $1777
    ld de, wCollisionMask0                        ; $177A
    call Gfx_BuildCellMask                        ; $177D
    pop af                                        ; $1780
    push af                                       ; $1781
    ld c, $00                                     ; $1782
    ldh [hFarcallAArg], a                         ; $1784
    ld a, BANK(Album_LoadNumeralTileB)            ; $1786
    ld hl, Album_LoadNumeralTileB_7CE3            ; $1788
    call Far_Call                                 ; $178B
    ld de, wCollisionMask1                        ; $178E
    call Gfx_BuildCellMask                        ; $1791
    pop af                                        ; $1794
    ld c, $01                                     ; $1795
    ldh [hFarcallAArg], a                         ; $1797
    ld a, BANK(Album_LoadNumeralTileB)            ; $1799
    ld hl, Album_LoadNumeralTileB_7CE3            ; $179B
    call Far_Call                                 ; $179E
    ld de, wCollisionMask2                        ; $17A1
    call Gfx_BuildCellMask                        ; $17A4
    ret                                           ; $17A7


; C: boss variant -> graphics group (variant 2 depends on gameface_present)
Sf2_BossVariantToGroup::
    push bc                                       ; $17A8
    ld a, [wShootBossVariant]                     ; $17A9
    cp $02                                        ; $17AC
    jr nz, jr_000_17b8                            ; $17AE

    ld hl, wGamefacePresent                       ; $17B0
    bit 0, [hl]                                   ; $17B3
    jr nz, jr_000_17b8                            ; $17B5

    inc a                                         ; $17B7

jr_000_17b8:
    ld c, a                                       ; $17B8
    ld b, $00                                     ; $17B9
    ld hl, Sf2_BossGroupTable                     ; $17BB
    add hl, bc                                    ; $17BE
    ld a, [hl]                                    ; $17BF
    pop bc                                        ; $17C0
    ret                                           ; $17C1


; C: 4 bytes
Sf2_BossGroupTable::
    db $05, $04, $06, $01

; C: 56 cells of 16 bytes OR-ed to one byte each (tile non-empty mask)
Gfx_BuildCellMask::
    bit 7, h                                      ; $17C6
    jr nz, jr_000_17d9                            ; $17C8

    ldh [hBankTmp], a                             ; $17CA
    ldh a, [hRomBankShadow]                       ; $17CC
    push af                                       ; $17CE
    ldh a, [hBankTmp]                             ; $17CF
    ldh [hRomBankShadow], a                       ; $17D1
    ld [rROMB0], a                                ; $17D3
    scf                                           ; $17D6
    jr jr_000_17dd                                ; $17D7

jr_000_17d9:
    ld [rRAMB], a                                 ; $17D9
    and a                                         ; $17DC

jr_000_17dd:
    push af                                       ; $17DD
    ld b, $38                                     ; $17DE

jr_000_17e0:
    xor a                                         ; $17E0
    ld c, $10                                     ; $17E1

jr_000_17e3:
    or [hl]                                       ; $17E3
    inc hl                                        ; $17E4
    dec c                                         ; $17E5
    jr nz, jr_000_17e3                            ; $17E6

    ld [de], a                                    ; $17E8
    inc de                                        ; $17E9
    dec b                                         ; $17EA
    jr nz, jr_000_17e0                            ; $17EB

    pop af                                        ; $17ED
    ret nc                                        ; $17EE

    pop af                                        ; $17EF
    ldh [hRomBankShadow], a                       ; $17F0
    ld [rROMB0], a                                ; $17F2
    ret                                           ; $17F5


; C: splits the slot's image checksum (F34 = sum, F35 = xor of the 3,584 photo bytes, copied to $DA8F/$DA90) into four
; nibbles $DD03-$DD06 and requests sfx1 $10 = the P.VOICE; BGB 2026-10-14: the four nibbles equal F34/F35 for the 21
; copied stock pictures in the slide show (P.VOICE option) and for a ...
Snd_PlayTagDigits::
    ld a, [wTagImageCheck]                        ; $17F6
    swap a                                        ; $17F9
    and $0f                                       ; $17FB
    ld [wSndDurTabHi], a                          ; $17FD
    ld a, [wTagImageCheck]                        ; $1800
    and $0f                                       ; $1803
    ld [wSndSfx10Digits], a                       ; $1805
    ld a, [wTagImageCheck + $1]                   ; $1808
    swap a                                        ; $180B
    and $0f                                       ; $180D
    ld [wSndSfx10Digits + $1], a                  ; $180F
    ld a, [wTagImageCheck + $1]                   ; $1812
    and $0f                                       ; $1815
    ld [wSndSfx10Digits + $2], a                  ; $1817
    play_sfx1 SFX1_TAG_DIGITS_JINGLE              ; $181A
    ret                                           ; $1821


; C: A = bank, HL = source, DE = row buffer: copies 32-byte row records (1 + 3 + 28 bytes) until 18 rows are copied or
; a record pair closes (first byte non-zero toggles bit 7 of C); returns the row count in B; only caller 09:403E
; ScrollEngine_Sub1_FetchRow (credits text scroller, bank $29 script); was ...
ScrollEngine_CopyRowRecords::
    ldh [hBankTmp], a                             ; $1822
    ldh a, [hRomBankShadow]                       ; $1824
    push af                                       ; $1826
    ldh a, [hBankTmp]                             ; $1827
    ldh [hRomBankShadow], a                       ; $1829
    ld [rROMB0], a                                ; $182B
    ld bc, $0000                                  ; $182E

jr_000_1831:
    ld a, [hl+]                                   ; $1831
    ld [de], a                                    ; $1832
    inc de                                        ; $1833
    and a                                         ; $1834
    jr z, jr_000_183b                             ; $1835

    ld a, c                                       ; $1837
    xor $80                                       ; $1838
    ld c, a                                       ; $183A

jr_000_183b:
    ld a, [hl+]                                   ; $183B
    ld [de], a                                    ; $183C
    inc de                                        ; $183D
    ld a, [hl+]                                   ; $183E
    ld [de], a                                    ; $183F
    inc de                                        ; $1840
    ld a, [hl+]                                   ; $1841
    ld [de], a                                    ; $1842
    inc de                                        ; $1843
    and a                                         ; $1844
    jr z, jr_000_1848                             ; $1845

    inc c                                         ; $1847

jr_000_1848:
    push bc                                       ; $1848
    ld b, $07                                     ; $1849

jr_000_184b:
    ld a, [hl+]                                   ; $184B
    ld [de], a                                    ; $184C
    inc de                                        ; $184D
    ld a, [hl+]                                   ; $184E
    ld [de], a                                    ; $184F
    inc de                                        ; $1850
    ld a, [hl+]                                   ; $1851
    ld [de], a                                    ; $1852
    inc de                                        ; $1853
    ld a, [hl+]                                   ; $1854
    ld [de], a                                    ; $1855
    inc de                                        ; $1856
    dec b                                         ; $1857
    jr nz, jr_000_184b                            ; $1858

    pop bc                                        ; $185A
    inc b                                         ; $185B
    ld a, c                                       ; $185C
    bit 7, a                                      ; $185D
    jr nz, jr_000_1865                            ; $185F

    and $7f                                       ; $1861
    jr nz, jr_000_186a                            ; $1863

jr_000_1865:
    ld a, b                                       ; $1865
    cp $12                                        ; $1866
    jr nz, jr_000_1831                            ; $1868

jr_000_186a:
    pop af                                        ; $186A
    ldh [hRomBankShadow], a                       ; $186B
    ld [rROMB0], a                                ; $186D
    ret                                           ; $1870


; C: one serial IRQ step of the printer packet state machine
Prn_SerialStep::
    ld a, [wPrnAbort]                             ; $1871
    and a                                         ; $1874
    jp nz, Prn_ReceiveStatus_Ret                  ; $1875

    ld a, [wPrnState]                             ; $1878
    cp $07                                        ; $187B
    jp z, Prn_ReceiveStatus                       ; $187D

    ld a, [wPrnSyncDone]                          ; $1880
    and a                                         ; $1883
    jr nz, jr_000_188c                            ; $1884

    call Prn_SendSyncByte                         ; $1886
    jp Prn_SerialStep_Exit                        ; $1889


jr_000_188c:
    ld a, [wPrnHdrDone]                           ; $188C
    and a                                         ; $188F
    jr z, jr_000_18a9                             ; $1890

    ld a, [wPrnDataDone]                          ; $1892
    and a                                         ; $1895
    jr z, jr_000_18a9                             ; $1896

    ld a, [wPrnChkIdx]                            ; $1898
    cp $02                                        ; $189B
    jr z, jr_000_18a4                             ; $189D

    call Prn_SendChecksumByte                     ; $189F
    jr jr_000_18ac                                ; $18A2

jr_000_18a4:
    call Prn_SendTrailerByte                      ; $18A4
    jr jr_000_18ac                                ; $18A7

jr_000_18a9:
    call Prn_SendPacketByte                       ; $18A9

jr_000_18ac:
    jp Prn_SerialStep_Exit                        ; $18AC


; C: sends $88 $33
Prn_SendSyncByte::
    ld hl, wPrnTxIdx                              ; $18AF
    ld c, [hl]                                    ; $18B2
    inc [hl]                                      ; $18B3
    ld b, $00                                     ; $18B4
    ld hl, Prn_SyncBytes                          ; $18B6
    add hl, bc                                    ; $18B9
    ld a, [hl]                                    ; $18BA
    ldh [rSB], a                                  ; $18BB
    ld a, SCF_SOURCE                              ; $18BD
    ldh [rSC], a                                  ; $18BF
    ld a, SCF_START | SCF_SOURCE                  ; $18C1
    ldh [rSC], a                                  ; $18C3
    ld a, [wPrnTxIdx]                             ; $18C5
    cp $02                                        ; $18C8
    ret nz                                        ; $18CA

    xor a                                         ; $18CB
    ld [wPrnTxIdx], a                             ; $18CC
    inc a                                         ; $18CF
    ld [wPrnSyncDone], a                          ; $18D0
    ret                                           ; $18D3


; C: sends one header/data byte and adds it to the checksum
Prn_SendPacketByte::
    ld a, [wPrnTxIdx]                             ; $18D4
    ld c, a                                       ; $18D7
    ld a, [wPrnTxIdx + $1]                        ; $18D8
    ld b, a                                       ; $18DB
    ld a, [wPrnSrcPtr]                            ; $18DC
    ld l, a                                       ; $18DF
    ld a, [wPrnSrcPtr + $1]                       ; $18E0
    ld h, a                                       ; $18E3
    add hl, bc                                    ; $18E4
    ldh a, [rSB]                                  ; $18E5
    ld [wPrnPrevRx], a                            ; $18E7
    ld a, [hl]                                    ; $18EA
    ldh [rSB], a                                  ; $18EB
    ld l, a                                       ; $18ED
    ld a, [wPrnChecksum]                          ; $18EE
    add l                                         ; $18F1
    ld [wPrnChecksum], a                          ; $18F2
    ld a, [wPrnChecksum + $1]                     ; $18F5
    adc $00                                       ; $18F8
    ld [wPrnChecksum + $1], a                     ; $18FA
    ld a, SCF_SOURCE                              ; $18FD
    ldh [rSC], a                                  ; $18FF
    ld a, SCF_START | SCF_SOURCE                  ; $1901
    ldh [rSC], a                                  ; $1903
    ld hl, wPrnTxIdx                              ; $1905
    inc [hl]                                      ; $1908
    jr nz, jr_000_190d                            ; $1909

    inc hl                                        ; $190B
    inc [hl]                                      ; $190C

jr_000_190d:
    ld hl, wPrnTxIdx                              ; $190D
    ld a, [wPrnTargetLen]                         ; $1910
    cp [hl]                                       ; $1913
    jr nz, jr_000_191d                            ; $1914

    inc hl                                        ; $1916
    ld a, [wPrnTargetLen + $1]                    ; $1917
    cp [hl]                                       ; $191A
    jr z, jr_000_191f                             ; $191B

jr_000_191d:
    jr jr_000_195d                                ; $191D

jr_000_191f:
    ld hl, wPrnHdrDone                            ; $191F
    ld a, [hl]                                    ; $1922
    and a                                         ; $1923
    jr z, jr_000_1929                             ; $1924

    ld hl, wPrnDataDone                           ; $1926

jr_000_1929:
    inc [hl]                                      ; $1929
    ld a, [wPrnHasData]                           ; $192A
    and a                                         ; $192D
    jr z, jr_000_1962                             ; $192E

    ld a, [wPrnState]                             ; $1930
    cp $06                                        ; $1933
    jr z, jr_000_1962                             ; $1935

    ld hl, wPrnDataDone                           ; $1937
    ld a, [hl]                                    ; $193A
    and a                                         ; $193B
    jr nz, jr_000_195e                            ; $193C

    xor a                                         ; $193E
    ld [wPrnTxIdx], a                             ; $193F
    ld [wPrnTxIdx + $1], a                        ; $1942
    ld a, [wPrnDataPtr]                           ; $1945
    ld [wPrnSrcPtr], a                            ; $1948
    ld a, [wPrnDataPtr + $1]                      ; $194B
    ld [wPrnSrcPtr + $1], a                       ; $194E
    ld a, [wPrnDataLen]                           ; $1951
    ld [wPrnTargetLen], a                         ; $1954
    ld a, [wPrnDataLen + $1]                      ; $1957
    ld [wPrnTargetLen + $1], a                    ; $195A

jr_000_195d:
    ret                                           ; $195D


jr_000_195e:
    call Prn_RestoreHeaderPtr                     ; $195E
    ret                                           ; $1961


jr_000_1962:
    ld a, [wPrnPrevRx]                            ; $1962
    ld [wPrnDevId], a                             ; $1965

jr_000_1968:
    ld a, $07                                     ; $1968
    ld [wPrnState], a                             ; $196A
    ld a, $01                                     ; $196D
    ld [wPrnTxPhase], a                           ; $196F
    call Prn_ResetPacketState                     ; $1972

; C: restores length and pointer for the next section
Prn_RestoreHeaderPtr::
    ld a, [wPrnHdrLen]                            ; $1975
    ld [wPrnTargetLen], a                         ; $1978
    ld a, [wPrnHdrLen + $1]                       ; $197B
    ld [wPrnTargetLen + $1], a                    ; $197E
    ld a, [wPrnHdrPtr]                            ; $1981
    ld [wPrnSrcPtr], a                            ; $1984
    ld a, [wPrnHdrPtr + $1]                       ; $1987
    ld [wPrnSrcPtr + $1], a                       ; $198A
    ret                                           ; $198D


; C
Prn_SendChecksumByte::
    ld c, a                                       ; $198E
    ld b, $00                                     ; $198F
    ld hl, wPrnChecksum                           ; $1991
    add hl, bc                                    ; $1994
    ld a, [hl]                                    ; $1995
    ldh [rSB], a                                  ; $1996
    ld a, SCF_SOURCE                              ; $1998
    ldh [rSC], a                                  ; $199A
    ld a, SCF_START | SCF_SOURCE                  ; $199C
    ldh [rSC], a                                  ; $199E
    ld hl, wPrnChkIdx                             ; $19A0
    inc [hl]                                      ; $19A3
    ret                                           ; $19A4


; C: two dummy bytes after the checksum; reads device id
Prn_SendTrailerByte::
    ldh a, [rSB]                                  ; $19A5
    ld [wPrnDevId], a                             ; $19A7
    xor a                                         ; $19AA
    ldh [rSB], a                                  ; $19AB
    ld a, SCF_SOURCE                              ; $19AD
    ldh [rSC], a                                  ; $19AF
    ld a, SCF_START | SCF_SOURCE                  ; $19B1
    ldh [rSC], a                                  ; $19B3
    ld hl, wPrnTrailCnt                           ; $19B5
    inc [hl]                                      ; $19B8
    ld a, [hl]                                    ; $19B9
    cp $02                                        ; $19BA
    jr z, jr_000_1968                             ; $19BC

    ret                                           ; $19BE


; C: end of packet: stores the status byte and sets the engine state
Prn_ReceiveStatus::
    ld a, [wPrnPktType]                           ; $19BF
    ld [wPrnLastType], a                          ; $19C2
    ld a, [wPrnStatus]                            ; $19C5
    ld [wPrinterPrevStatus + $1], a               ; $19C8
    cp $ff                                        ; $19CB
    jr z, jr_000_19d2                             ; $19CD

    ld [wPrinterPrevStatus], a                    ; $19CF

jr_000_19d2:
    ldh a, [rSB]                                  ; $19D2
    ld [wPrnStatus], a                            ; $19D4
    cp $ff                                        ; $19D7
    jr nz, jr_000_19e7                            ; $19D9

    ld a, $00                                     ; $19DB
    ld [wPrnTxBusy], a                            ; $19DD
    ld [wPrnState], a                             ; $19E0
    ld a, $02                                     ; $19E3
    jr jr_000_19ff                                ; $19E5

jr_000_19e7:
    bit 1, a                                      ; $19E7
    jr z, jr_000_19f0                             ; $19E9

    ld a, $01                                     ; $19EB
    ld [wPrnBusySeen], a                          ; $19ED

jr_000_19f0:
    bit 4, a                                      ; $19F0
    ld a, $00                                     ; $19F2
    ld [wPrnState], a                             ; $19F4
    ld a, $01                                     ; $19F7
    jr nz, jr_000_19fe                            ; $19F9

    ld [wPrnState], a                             ; $19FB

jr_000_19fe:
    inc a                                         ; $19FE

jr_000_19ff:
    ld [wPrnTxPhase], a                           ; $19FF
    ld a, [wPrnHasData]                           ; $1A02
    and a                                         ; $1A05
    jr nz, Prn_ReceiveStatus_Ret                  ; $1A06

    xor a                                         ; $1A08
    ld [wPrnTxBusy], a                            ; $1A09

; C: RET shared by the status-byte tail of Prn_SerialStep (taken when the abort flag DC3C is set) (branch target; code
; read 2026-10-19)
Prn_ReceiveStatus_Ret::
    ret                                           ; $1A0C


; I: unreferenced
Prn_StopSerial_Dead::
    xor a                                         ; $1A0D
    ldh [rSC], a                                  ; $1A0E

; C: RET at 190E shared by the live sync-byte and packet-byte branches of Prn_SerialStep (the dead Prn_StopSerial_Dead
; bytes sit around it) (branch target; code read 2026-10-19)
Prn_SerialStep_Exit::
    ret                                           ; $1A10


; I: unreferenced
Prn_StopSerial2_Dead::
    xor a                                         ; $1A11
    ldh [rSC], a                                  ; $1A12
    ldh [rSB], a                                  ; $1A14

; C: clears serial and state; status = $FF
Prn_EngineStop::
    xor a                                         ; $1A16
    ldh [rSB], a                                  ; $1A17
    ldh [rSC], a                                  ; $1A19
    ld [wPrnState], a                             ; $1A1B
    dec a                                         ; $1A1E
    ld [wPrnStatus], a                            ; $1A1F
    ld [wPrnDevId], a                             ; $1A22
    call Prn_ClearTxFlags                         ; $1A25
    ret                                           ; $1A28


; C
Prn_ClearTxFlags::
    xor a                                         ; $1A29
    ld [wPrnTxPhase], a                           ; $1A2A
    ld [wPrnIrqSeen], a                           ; $1A2D
    ld [wPrnTxBusy], a                            ; $1A30

; C
Prn_ResetPacketState::
    xor a                                         ; $1A33
    ld [wPrnSyncDone], a                          ; $1A34
    ld [wPrnHdrDone], a                           ; $1A37
    ld [wPrnDataDone], a                          ; $1A3A
    ld [wPrnChkIdx], a                            ; $1A3D
    ld [wPrnTrailCnt], a                          ; $1A40
    ld [wPrnChecksum], a                          ; $1A43
    ld [wPrnChecksum + $1], a                     ; $1A46
    ld [wPrnTxIdx], a                             ; $1A49
    ld [wPrnTxIdx + $1], a                        ; $1A4C
    ld [wPrnAbort], a                             ; $1A4F
    ld [wPrnBusySeen], a                          ; $1A52
    ret                                           ; $1A55


; C: queues the INITIALIZE command (A=0 ready)
Prn_SendInit::
    ld a, [wPrnTxBusy]                            ; $1A56
    and a                                         ; $1A59
    jr z, jr_000_1a60                             ; $1A5A

    call Prn_CheckTxDone                          ; $1A5C
    ret nc                                        ; $1A5F

jr_000_1a60:
    ld a, [wPrnLastType]                          ; $1A60
    cp $01                                        ; $1A63
    jr nz, jr_000_1a6b                            ; $1A65

    call Prn_CheckTxDone                          ; $1A67
    ret nc                                        ; $1A6A

jr_000_1a6b:
    call Prn_QueueInit                            ; $1A6B
    jp Prn_StartTransmit                          ; $1A6E


; C: completion routine: carry = packet must be re-sent
Prn_CheckTxDone::
    ld a, [wPrnTxPhase]                           ; $1A71
    cp $02                                        ; $1A74
    jr nz, jr_000_1ab0                            ; $1A76

    xor a                                         ; $1A78
    ld [wPrnPollCnt], a                           ; $1A79
    ld [wPrnLastType], a                          ; $1A7C
    inc a                                         ; $1A7F
    ld [wPrnState], a                             ; $1A80
    ld a, [wPrnStatus]                            ; $1A83
    cp $ff                                        ; $1A86
    jr z, jr_000_1aa9                             ; $1A88

    bit 0, a                                      ; $1A8A
    jr nz, jr_000_1aa2                            ; $1A8C

    bit 1, a                                      ; $1A8E
    jr nz, jr_000_1aa2                            ; $1A90

    bit 4, a                                      ; $1A92
    jr z, jr_000_1aae                             ; $1A94

    xor a                                         ; $1A96
    ld [wPrnState], a                             ; $1A97
    ld [wPrnLastType], a                          ; $1A9A
    ld a, [wPrnStatus]                            ; $1A9D
    jr jr_000_1aae                                ; $1AA0

jr_000_1aa2:
    scf                                           ; $1AA2
    ret                                           ; $1AA3


; I: unreferenced
Prn_Unused1AA4::
    xor a                                         ; $1AA4
    ld [wPrnLastType], a                          ; $1AA5
    dec a                                         ; $1AA8

jr_000_1aa9:
    inc a                                         ; $1AA9
    ld [wPrnState], a                             ; $1AAA
    dec a                                         ; $1AAD

jr_000_1aae:
    and a                                         ; $1AAE
    ret                                           ; $1AAF


jr_000_1ab0:
    xor a                                         ; $1AB0
    ld a, $f0                                     ; $1AB1
    ret                                           ; $1AB3


; C: queues the PRINT command; returns $F0 while busy
Prn_SendPrint::
    ld a, [wPrnState]                             ; $1AB4
    cp $01                                        ; $1AB7
    jr z, jr_000_1ac6                             ; $1AB9

    cp $02                                        ; $1ABB
    jr z, jr_000_1ac6                             ; $1ABD

    and a                                         ; $1ABF
    ld a, $ff                                     ; $1AC0
    ret z                                         ; $1AC2

jr_000_1ac3:
    ld a, $f0                                     ; $1AC3
    ret                                           ; $1AC5


jr_000_1ac6:
    ld a, [wPrnBusySeen]                          ; $1AC6
    and a                                         ; $1AC9
    jr nz, jr_000_1ac3                            ; $1ACA

    ld a, [wPrnTxBusy]                            ; $1ACC
    and a                                         ; $1ACF
    jr z, jr_000_1ad6                             ; $1AD0

    call Prn_CheckTxDone                          ; $1AD2
    ret nc                                        ; $1AD5

jr_000_1ad6:
    ld a, [wPrnLastType]                          ; $1AD6
    cp $02                                        ; $1AD9
    jr nz, jr_000_1ae1                            ; $1ADB

    call Prn_CheckTxDone                          ; $1ADD
    ret nc                                        ; $1AE0

jr_000_1ae1:
    ld a, [wPrnStatus]                            ; $1AE1
    cp $ff                                        ; $1AE4
    ret z                                         ; $1AE6

    call Prn_QueuePrint                           ; $1AE7
    jp Prn_StartTransmit                          ; $1AEA


; C: queues a DATA packet (HL = band
Prn_SendData::
    ld c, a                                       ; $1AED
    ld a, [wPrnState]                             ; $1AEE
    and a                                         ; $1AF1
    ld a, [wPrnStatus]                            ; $1AF2
    ret z                                         ; $1AF5

    ld a, [wPrnState]                             ; $1AF6
    cp $01                                        ; $1AF9
    jr z, jr_000_1b04                             ; $1AFB

    cp $03                                        ; $1AFD
    jr z, jr_000_1b04                             ; $1AFF

    ld a, $f0                                     ; $1B01
    ret                                           ; $1B03


jr_000_1b04:
    ld a, [wPrnTxBusy]                            ; $1B04
    and a                                         ; $1B07
    jr nz, jr_000_1b53                            ; $1B08

    ld a, c                                       ; $1B0A
    inc a                                         ; $1B0B
    ld [wPrnChunkCnt], a                          ; $1B0C
    ld a, l                                       ; $1B0F
    ld [wPrnBandPtrCopy], a                       ; $1B10
    ld a, h                                       ; $1B13
    ld [wPrnBandPtrCopy + $1], a                  ; $1B14
    ld a, [wPrnStatus]                            ; $1B17
    cp $ff                                        ; $1B1A
    ret z                                         ; $1B1C

    ld a, [wPrnCompEnable]                        ; $1B1D
    ld [wPrnBandCompFlag], a                      ; $1B20
    and a                                         ; $1B23
    jr z, jr_000_1b4a                             ; $1B24

    ld a, [wPrnChunkCnt]                          ; $1B26
    dec a                                         ; $1B29
    dec a                                         ; $1B2A
    push af                                       ; $1B2B
    ld c, a                                       ; $1B2C
    ld b, $00                                     ; $1B2D
    push hl                                       ; $1B2F
    ld hl, wPrinterDc0cTable                      ; $1B30
    add hl, bc                                    ; $1B33
    ld a, [hl]                                    ; $1B34
    pop hl                                        ; $1B35
    ld [wPrnBandCompFlag], a                      ; $1B36
    pop af                                        ; $1B39
    add a                                         ; $1B3A
    ld c, a                                       ; $1B3B
    ld b, $00                                     ; $1B3C
    push hl                                       ; $1B3E
    ld hl, wPrinterLenTable                       ; $1B3F
    add hl, bc                                    ; $1B42
    ld a, [hl+]                                   ; $1B43
    ld b, [hl]                                    ; $1B44
    pop hl                                        ; $1B45
    ld c, a                                       ; $1B46
    jp Prn_SendData_QueueAndStart                 ; $1B47


jr_000_1b4a:
    ld bc, $0280                                  ; $1B4A

; C: BC = length, HL = source: Prn_QueueData then Prn_StartTransmit (shared tail of the DATA packet cases) (branch
; target; code read 2026-10-19)
Prn_SendData_QueueAndStart::
    call Prn_QueueData                            ; $1B4D
    jp Prn_StartTransmit                          ; $1B50


jr_000_1b53:
    ld a, [wPrnTxPhase]                           ; $1B53
    cp $02                                        ; $1B56
    ld a, $f0                                     ; $1B58
    jp nz, Prn_SendData_RetBusy                   ; $1B5A

    ld hl, wPrnChunkCnt                           ; $1B5D
    ld a, [wPrnStatus]                            ; $1B60
    bit 4, a                                      ; $1B63
    jp nz, Prn_SendData_Abort                     ; $1B65

    bit 1, a                                      ; $1B68
    jp nz, Prn_SendData_NextChunk                 ; $1B6A

    bit 0, a                                      ; $1B6D
    jp nz, Prn_SendData_NextChunk                 ; $1B6F

    dec [hl]                                      ; $1B72
    ld a, [wPrnStatus]                            ; $1B73
    jr z, jr_000_1bd4                             ; $1B76

; C: next band chunk: last chunk when the counter DC3E = 1, else length $0280 or the table value at DBEC (branch
; target; code read 2026-10-19)
Prn_SendData_NextChunk::
    ld a, [hl]                                    ; $1B78
    cp $01                                        ; $1B79
    jr z, jr_000_1bde                             ; $1B7B

    ld bc, $0280                                  ; $1B7D
    ld a, [wPrnCompEnable]                        ; $1B80
    ld [wPrnBandCompFlag], a                      ; $1B83
    and a                                         ; $1B86
    jr z, jr_000_1baa                             ; $1B87

    ld a, [wPrnChunkCnt]                          ; $1B89
    dec a                                         ; $1B8C
    dec a                                         ; $1B8D
    push af                                       ; $1B8E
    ld c, a                                       ; $1B8F
    ld b, $00                                     ; $1B90
    push hl                                       ; $1B92
    ld hl, wPrinterDc0cTable                      ; $1B93
    add hl, bc                                    ; $1B96
    ld a, [hl]                                    ; $1B97
    pop hl                                        ; $1B98
    ld [wPrnBandCompFlag], a                      ; $1B99
    pop af                                        ; $1B9C
    add a                                         ; $1B9D
    ld c, a                                       ; $1B9E
    ld b, $00                                     ; $1B9F
    push hl                                       ; $1BA1
    ld hl, wPrinterLenTable                       ; $1BA2
    add hl, bc                                    ; $1BA5
    ld a, [hl+]                                   ; $1BA6
    ld b, [hl]                                    ; $1BA7
    pop hl                                        ; $1BA8
    ld c, a                                       ; $1BA9

jr_000_1baa:
    ld a, [wPrnStatus]                            ; $1BAA
    bit 1, a                                      ; $1BAD
    jp nz, Prn_SendData_QueueFromPtr              ; $1BAF

    ld a, [wPrnDataPtr]                           ; $1BB2
    add $80                                       ; $1BB5
    ld [wPrnDataPtr], a                           ; $1BB7
    ld a, [wPrnDataPtr + $1]                      ; $1BBA
    adc $02                                       ; $1BBD
    ld [wPrnDataPtr + $1], a                      ; $1BBF

; C: reload HL from the data pointer DC1F:DC20 and queue (retry sends the same chunk, otherwise the pointer was
; advanced by $0280) (branch target; code read 2026-10-19)
Prn_SendData_QueueFromPtr::
    ld a, [wPrnDataPtr]                           ; $1BC2
    ld l, a                                       ; $1BC5
    ld a, [wPrnDataPtr + $1]                      ; $1BC6
    ld h, a                                       ; $1BC9
    jp Prn_SendData_QueueAndStart                 ; $1BCA


; C: status bit 4 (packet error): sets the abort flag DC3C, clears has-data DC2C and busy DC3B (branch target; code
; read 2026-10-19)
Prn_SendData_Abort::
    push af                                       ; $1BCD
    ld a, $01                                     ; $1BCE
    ld [wPrnAbort], a                             ; $1BD0
    pop af                                        ; $1BD3

jr_000_1bd4:
    push af                                       ; $1BD4
    xor a                                         ; $1BD5
    ld [wPrnHasData], a                           ; $1BD6
    ld [wPrnTxBusy], a                            ; $1BD9
    pop af                                        ; $1BDC

; C: RET with A = $F0 (printer engine busy) (branch target; code read 2026-10-19)
Prn_SendData_RetBusy::
    ret                                           ; $1BDD


jr_000_1bde:
    ld a, [wPrnLastChunk]                         ; $1BDE
    and a                                         ; $1BE1
    ld a, [wPrnStatus]                            ; $1BE2
    jr z, jr_000_1bd4                             ; $1BE5

    call Prn_QueueDataEnd                         ; $1BE7
    jp Prn_StartTransmit                          ; $1BEA


; I: unreferenced
Prn_SendBreak_Dead::
    ld a, [wPrnState]                             ; $1BED
    cp $01                                        ; $1BF0
    jr z, jr_000_1bff                             ; $1BF2

    cp $03                                        ; $1BF4
    jr z, jr_000_1bff                             ; $1BF6

    and a                                         ; $1BF8
    ld a, $ff                                     ; $1BF9
    ret z                                         ; $1BFB

    ld a, $f0                                     ; $1BFC
    ret                                           ; $1BFE


jr_000_1bff:
    ld a, [wPrnTxBusy]                            ; $1BFF
    and a                                         ; $1C02
    jr z, jr_000_1c09                             ; $1C03

    call Prn_CheckTxDone                          ; $1C05
    ret nc                                        ; $1C08

jr_000_1c09:
    ld a, [wPrnLastType]                          ; $1C09
    cp $04                                        ; $1C0C
    jr nz, jr_000_1c14                            ; $1C0E

    call Prn_CheckTxDone                          ; $1C10
    ret nc                                        ; $1C13

jr_000_1c14:
    ld a, [wPrnStatus]                            ; $1C14
    cp $ff                                        ; $1C17
    ret z                                         ; $1C19

    call Unused_Prn_QueueBreak                    ; $1C1A
    jp Prn_StartTransmit                          ; $1C1D


; C: queues the INQUIRY command (status poll)
Prn_SendInquiry::
    ld a, [wPrnState]                             ; $1C20
    cp $01                                        ; $1C23
    jr z, jr_000_1c32                             ; $1C25

    cp $03                                        ; $1C27
    jr z, jr_000_1c32                             ; $1C29

    and a                                         ; $1C2B
    ld a, $ff                                     ; $1C2C
    ret z                                         ; $1C2E

    ld a, $f0                                     ; $1C2F
    ret                                           ; $1C31


jr_000_1c32:
    ld a, [wPrnTxBusy]                            ; $1C32
    and a                                         ; $1C35
    jr z, jr_000_1c3c                             ; $1C36

    call Prn_CheckTxDone                          ; $1C38
    ret nc                                        ; $1C3B

jr_000_1c3c:
    ld a, [wPrnStatus]                            ; $1C3C
    cp $ff                                        ; $1C3F
    ret z                                         ; $1C41

    call Prn_QueueInquiry                         ; $1C42
    jp Prn_StartTransmit                          ; $1C45


; C: A = type
Prn_QueuePacket::
    ld [wPrnPktType], a                           ; $1C48
    ld a, d                                       ; $1C4B
    ld [wPrnHasData], a                           ; $1C4C
    ld a, l                                       ; $1C4F
    ld [wPrnSrcPtr], a                            ; $1C50
    ld [wPrnHdrPtr], a                            ; $1C53
    ld a, h                                       ; $1C56
    ld [wPrnSrcPtr + $1], a                       ; $1C57
    ld [wPrnHdrPtr + $1], a                       ; $1C5A
    ld a, c                                       ; $1C5D
    ld [wPrnTargetLen], a                         ; $1C5E
    ld [wPrnHdrLen], a                            ; $1C61
    ld a, b                                       ; $1C64
    ld [wPrnTargetLen + $1], a                    ; $1C65
    ld [wPrnHdrLen + $1], a                       ; $1C68
    xor a                                         ; $1C6B
    ld [wPrnTxPhase], a                           ; $1C6C
    call Prn_ResetPacketState                     ; $1C6F
    ret                                           ; $1C72


; C: $88 $33
Prn_SyncBytes::
    dw $3388

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
    ld a, $01                                     ; $1C99
    ld d, $00                                     ; $1C9B
    ld hl, Prn_PktInit                            ; $1C9D
    ld bc, $0008                                  ; $1CA0
    jp Prn_QueuePacket                            ; $1CA3


; C: builds the PRINT body from sheets / margin / palette / intensity
Prn_QueuePrint::
    ld a, $02                                     ; $1CA6
    ld d, $00                                     ; $1CA8
    ld hl, wPrnPktBuf                             ; $1CAA
    ld bc, $000c                                  ; $1CAD
    call Prn_QueuePacket                          ; $1CB0
    ld hl, Prn_PktPrintHdr                        ; $1CB3
    ld de, wPrnPktBuf                             ; $1CB6
    ld bc, $0004                                  ; $1CB9
    call Mem_Copy                                 ; $1CBC
    ld de, $0006                                  ; $1CBF
    ld a, [wPrnSheets]                            ; $1CC2
    ld [wPrnPktBuf + $4], a                       ; $1CC5
    call Prn_AddToChecksumDE                      ; $1CC8
    ld a, [wPrnMargin]                            ; $1CCB
    ld [wPrnPktBuf + $5], a                       ; $1CCE
    call Prn_AddToChecksumDE                      ; $1CD1
    ld a, [wPrnPalette]                           ; $1CD4
    ld [wPrnPktBuf + $6], a                       ; $1CD7
    call Prn_AddToChecksumDE                      ; $1CDA
    ld a, [wPrintIntensity]                       ; $1CDD
    ld [wPrnPktBuf + $7], a                       ; $1CE0
    call Prn_AddToChecksumDE                      ; $1CE3
    ld a, e                                       ; $1CE6
    ld [wPrnPktBuf + $8], a                       ; $1CE7
    ld a, d                                       ; $1CEA
    ld [wPrnPktBuf + $9], a                       ; $1CEB
    xor a                                         ; $1CEE
    ld [wPrnPktBuf + $a], a                       ; $1CEF
    ld [wPrnPktBuf + $b], a                       ; $1CF2
    ret                                           ; $1CF5


; C: DE += A
Prn_AddToChecksumDE::
    add e                                         ; $1CF6
    ld e, a                                       ; $1CF7
    ld a, d                                       ; $1CF8
    adc $00                                       ; $1CF9
    ld d, a                                       ; $1CFB
    ret                                           ; $1CFC


; C
Prn_QueueData::
    ld a, l                                       ; $1CFD
    ld [wPrnDataPtr], a                           ; $1CFE
    ld a, h                                       ; $1D01
    ld [wPrnDataPtr + $1], a                      ; $1D02
    ld a, c                                       ; $1D05
    ld [wPrnDataLen], a                           ; $1D06
    ld a, b                                       ; $1D09
    ld [wPrnDataLen + $1], a                      ; $1D0A
    push bc                                       ; $1D0D
    ld a, $03                                     ; $1D0E
    ld d, $01                                     ; $1D10
    ld hl, wPrnPktBuf                             ; $1D12
    ld bc, $0004                                  ; $1D15
    call Prn_QueuePacket                          ; $1D18
    ld a, [Prn_PktDataEnd]                        ; $1D1B
    ld [wPrnPktBuf], a                            ; $1D1E
    ld a, [wPrnBandCompFlag]                      ; $1D21
    ld [wPrnPktBuf + $1], a                       ; $1D24
    pop bc                                        ; $1D27
    ld a, c                                       ; $1D28
    ld [wPrnPktBuf + $2], a                       ; $1D29
    ld a, b                                       ; $1D2C
    ld [wPrnPktBuf + $3], a                       ; $1D2D
    ret                                           ; $1D30


; C: Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Prn_QueueBreak::
    ld a, $04                                     ; $1D31
    ld d, $00                                     ; $1D33
    ld hl, Prn_PktBreak                           ; $1D35
    ld bc, $0008                                  ; $1D38
    jp Prn_QueuePacket                            ; $1D3B


; C
Prn_QueueInquiry::
    ld a, $05                                     ; $1D3E
    ld d, $00                                     ; $1D40
    ld hl, Prn_PktInquiry                         ; $1D42
    ld bc, $0008                                  ; $1D45
    jp Prn_QueuePacket                            ; $1D48


; C
Prn_QueueDataEnd::
    ld a, $06                                     ; $1D4B
    ld d, $01                                     ; $1D4D
    ld hl, Prn_PktDataEnd                         ; $1D4F
    ld bc, $0008                                  ; $1D52
    jp Prn_QueuePacket                            ; $1D55


; C: Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26, README 13.6).
Unused_Prn_Ret::
    ret                                           ; $1D58


; C: starts the queued packet and sends the first sync byte
Prn_StartTransmit::
    ld a, [wPrnState]                             ; $1D59
    cp $01                                        ; $1D5C
    jr z, jr_000_1d6c                             ; $1D5E

    and a                                         ; $1D60
    jr nz, jr_000_1d6a                            ; $1D61

    ld a, [wPrnPktType]                           ; $1D63
    cp $01                                        ; $1D66
    jr z, jr_000_1d76                             ; $1D68

jr_000_1d6a:
    scf                                           ; $1D6A
    ret                                           ; $1D6B


jr_000_1d6c:
    ld a, [wPrnPktType]                           ; $1D6C
    cp $01                                        ; $1D6F
    jr z, jr_000_1d6a                             ; $1D71

    ld [wPrnState], a                             ; $1D73

jr_000_1d76:
    xor a                                         ; $1D76
    ld [wPrnTxPhase], a                           ; $1D77
    ld [wPrnLastType], a                          ; $1D7A
    ld a, $01                                     ; $1D7D
    ld [wPrnTxIdx], a                             ; $1D7F
    ld [wPrnTxBusy], a                            ; $1D82
    ld a, [Prn_SyncBytes]                         ; $1D85
    ldh [rSB], a                                  ; $1D88
    ld a, SCF_SOURCE                              ; $1D8A
    ldh [rSC], a                                  ; $1D8C
    ld a, SCF_START | SCF_SOURCE                  ; $1D8E
    ldh [rSC], a                                  ; $1D90
    ld a, $f0                                     ; $1D92
    ret                                           ; $1D94


; C: A = bank; HL = packets (16 bytes each
Sgb_SendPacket::
    ldh [hBankTmp], a                             ; $1D95
    ldh a, [hRomBankShadow]                       ; $1D97
    push af                                       ; $1D99
    ldh a, [hBankTmp]                             ; $1D9A
    ldh [hRomBankShadow], a                       ; $1D9C
    ld [rROMB0], a                                ; $1D9E
    ld a, [hl]                                    ; $1DA1
    and $07                                       ; $1DA2
    jr z, jr_000_1dd9                             ; $1DA4

    ld b, a                                       ; $1DA6
    ld c, $00                                     ; $1DA7

jr_000_1da9:
    push bc                                       ; $1DA9
    ld a, $00                                     ; $1DAA
    ldh [c], a                                    ; $1DAC
    ld a, $30                                     ; $1DAD
    ldh [c], a                                    ; $1DAF
    ld b, $10                                     ; $1DB0

jr_000_1db2:
    ld e, $08                                     ; $1DB2
    ld a, [hl+]                                   ; $1DB4
    ld d, a                                       ; $1DB5

jr_000_1db6:
    bit 0, d                                      ; $1DB6
    ld a, $10                                     ; $1DB8
    jr nz, jr_000_1dbe                            ; $1DBA

    ld a, $20                                     ; $1DBC

jr_000_1dbe:
    ldh [c], a                                    ; $1DBE
    ld a, $30                                     ; $1DBF
    ldh [c], a                                    ; $1DC1
    rr d                                          ; $1DC2
    dec e                                         ; $1DC4
    jr nz, jr_000_1db6                            ; $1DC5

    dec b                                         ; $1DC7
    jr nz, jr_000_1db2                            ; $1DC8

    ld a, $20                                     ; $1DCA
    ldh [c], a                                    ; $1DCC
    ld a, $30                                     ; $1DCD
    ldh [c], a                                    ; $1DCF
    pop bc                                        ; $1DD0
    dec b                                         ; $1DD1
    jr z, jr_000_1dd9                             ; $1DD2

    call Sgb_Delay                                ; $1DD4
    jr jr_000_1da9                                ; $1DD7

jr_000_1dd9:
    pop af                                        ; $1DD9
    ldh [hRomBankShadow], a                       ; $1DDA
    ld [rROMB0], a                                ; $1DDC
    ret                                           ; $1DDF


; C
Sgb_Delay::
    ld de, $1b58                                  ; $1DE0

jr_000_1de3:
    nop                                           ; $1DE3
    nop                                           ; $1DE4
    nop                                           ; $1DE5
    dec de                                        ; $1DE6
    ld a, d                                       ; $1DE7
    or e                                          ; $1DE8
    jr nz, jr_000_1de3                            ; $1DE9

    ret                                           ; $1DEB


; C: MLT_REQ probe; carry set when a Super Game Boy answers
Sgb_Probe::
    ld a, BANK(Sgb_MltReqPackets)                 ; $1DEC
    ld hl, Sgb_MltReqPackets + $10                ; $1DEE
    call Sgb_SendPacket                           ; $1DF1
    call Sgb_Delay                                ; $1DF4
    ldh a, [rP1]                                  ; $1DF7
    and $03                                       ; $1DF9
    cp $03                                        ; $1DFB
    jr nz, Sgb_Probe_Found                        ; $1DFD

    ld a, P1F_GET_DPAD                            ; $1DFF
    ldh [rP1], a                                  ; $1E01
    ldh a, [rP1]                                  ; $1E03
    ldh a, [rP1]                                  ; $1E05
    ld a, P1F_GET_NONE                            ; $1E07
    ldh [rP1], a                                  ; $1E09
    ld a, P1F_GET_BTN                             ; $1E0B
    ldh [rP1], a                                  ; $1E0D
    ldh a, [rP1]                                  ; $1E0F
    ldh a, [rP1]                                  ; $1E11
    ldh a, [rP1]                                  ; $1E13
    ldh a, [rP1]                                  ; $1E15
    ldh a, [rP1]                                  ; $1E17
    ldh a, [rP1]                                  ; $1E19
    ld a, P1F_GET_NONE                            ; $1E1B
    ldh [rP1], a                                  ; $1E1D
    ldh a, [rP1]                                  ; $1E1F
    ldh a, [rP1]                                  ; $1E21
    ldh a, [rP1]                                  ; $1E23
    ldh a, [rP1]                                  ; $1E25
    and $03                                       ; $1E27
    cp $03                                        ; $1E29
    jr nz, Sgb_Probe_Found                        ; $1E2B

    ld a, BANK(Sgb_MltReqPackets)                 ; $1E2D
    ld hl, Sgb_MltReqPackets                      ; $1E2F
    call Sgb_SendPacket                           ; $1E32
    call Sgb_Delay                                ; $1E35
    and a                                         ; $1E38
    ret                                           ; $1E39


; C
Sgb_Probe_Found::
    ld a, BANK(Sgb_MltReqPackets)                 ; $1E3A
    ld hl, Sgb_MltReqPackets                      ; $1E3C
    call Sgb_SendPacket                           ; $1E3F
    call Sgb_Delay                                ; $1E42
    scf                                           ; $1E45
    ret                                           ; $1E46


; C: copies the $1000 bytes following the packet to VRAM $8800 and sends the packet
Sgb_SendVramTransfer::
    ldh [hBankTmp], a                             ; $1E47
    ldh a, [hRomBankShadow]                       ; $1E49
    push af                                       ; $1E4B
    ldh a, [hBankTmp]                             ; $1E4C
    ldh [hRomBankShadow], a                       ; $1E4E
    ld [rROMB0], a                                ; $1E50
    push af                                       ; $1E53
    push hl                                       ; $1E54
    ld a, $e4                                     ; $1E55
    ldh [rBGP], a                                 ; $1E57
    ld bc, $0010                                  ; $1E59
    add hl, bc                                    ; $1E5C
    ld de, $8800                                  ; $1E5D
    ld bc, $1000                                  ; $1E60
    call Mem_Copy                                 ; $1E63
    ld hl, $9800                                  ; $1E66
    ld de, $000c                                  ; $1E69
    ld a, $80                                     ; $1E6C
    ld c, $0d                                     ; $1E6E

jr_000_1e70:
    ld b, $14                                     ; $1E70

jr_000_1e72:
    ld [hl+], a                                   ; $1E72
    inc a                                         ; $1E73
    dec b                                         ; $1E74
    jr nz, jr_000_1e72                            ; $1E75

    add hl, de                                    ; $1E77
    dec c                                         ; $1E78
    jr nz, jr_000_1e70                            ; $1E79

    ld a, LCDCF_ON | LCDCF_BGON                   ; $1E7B
    ldh [rLCDC], a                                ; $1E7D
    ld bc, $0005                                  ; $1E7F
    call Delay_Frames_Busy                        ; $1E82
    pop hl                                        ; $1E85
    pop af                                        ; $1E86
    call Sgb_SendPacket                           ; $1E87
    ld bc, $0006                                  ; $1E8A
    call Delay_Frames_Busy                        ; $1E8D
    ldh a, [hBgpShadow]                           ; $1E90
    ldh [rBGP], a                                 ; $1E92
    ldh a, [hLcdcShadow]                          ; $1E94
    ldh [rLCDC], a                                ; $1E96
    pop af                                        ; $1E98
    ldh [hRomBankShadow], a                       ; $1E99
    ld [rROMB0], a                                ; $1E9B
    ret                                           ; $1E9E


; C: boot: after 120 frames sends the 0B:69E6.. packets then the border VRAM transfers; only when an SGB is present
Sgb_SendInitSequence::
    ldh a, [hSgbPresent]                          ; $1E9F
    and a                                         ; $1EA1
    ret z                                         ; $1EA2

    ld bc, $0078                                  ; $1EA3
    call Delay_Frames_Busy                        ; $1EA6
    call Sgb_MaskFreeze                           ; $1EA9
    ld a, BANK(Sgb_DataSndPackets)                ; $1EAC
    ld hl, Sgb_DataSndPackets                     ; $1EAE
    call Sgb_SendPacket                           ; $1EB1
    ld bc, $0004                                  ; $1EB4
    call Delay_Frames_Busy                        ; $1EB7
    ld a, BANK(Sgb_DataSndPackets)                ; $1EBA
    ld hl, Sgb_DataSndPackets + $10               ; $1EBC
    call Sgb_SendPacket                           ; $1EBF
    ld bc, $0004                                  ; $1EC2
    call Delay_Frames_Busy                        ; $1EC5
    ld a, BANK(Sgb_DataSndPackets)                ; $1EC8
    ld hl, Sgb_DataSndPackets + $20               ; $1ECA
    call Sgb_SendPacket                           ; $1ECD
    ld bc, $0004                                  ; $1ED0
    call Delay_Frames_Busy                        ; $1ED3
    ld a, BANK(Sgb_DataSndPackets)                ; $1ED6
    ld hl, Sgb_DataSndPackets + $30               ; $1ED8
    call Sgb_SendPacket                           ; $1EDB
    ld bc, $0004                                  ; $1EDE
    call Delay_Frames_Busy                        ; $1EE1
    ld a, BANK(Sgb_DataSndPackets)                ; $1EE4
    ld hl, Sgb_DataSndPackets + $40               ; $1EE6
    call Sgb_SendPacket                           ; $1EE9
    ld bc, $0004                                  ; $1EEC
    call Delay_Frames_Busy                        ; $1EEF
    ld a, BANK(Sgb_DataSndPackets)                ; $1EF2
    ld hl, Sgb_DataSndPackets + $50               ; $1EF4
    call Sgb_SendPacket                           ; $1EF7
    ld bc, $0004                                  ; $1EFA
    call Delay_Frames_Busy                        ; $1EFD
    ld a, BANK(Sgb_DataSndPackets)                ; $1F00
    ld hl, Sgb_DataSndPackets + $60               ; $1F02
    call Sgb_SendPacket                           ; $1F05
    ld bc, $0004                                  ; $1F08
    call Delay_Frames_Busy                        ; $1F0B
    ld a, BANK(Sgb_DataSndPackets)                ; $1F0E
    ld hl, Sgb_DataSndPackets + $70               ; $1F10
    call Sgb_SendPacket                           ; $1F13
    ld bc, $0004                                  ; $1F16
    call Delay_Frames_Busy                        ; $1F19
    ld a, BANK(Sgb_PalTrnPacket)                  ; $1F1C
    ld hl, Sgb_PalTrnPacket                       ; $1F1E
    call Sgb_SendVramTransfer                     ; $1F21
    ld bc, $0004                                  ; $1F24
    call Delay_Frames_Busy                        ; $1F27
    ld a, BANK(Sgb_AttrTrnPacket)                 ; $1F2A
    ld hl, Sgb_AttrTrnPacket                      ; $1F2C
    call Sgb_SendVramTransfer                     ; $1F2F
    ld bc, $0004                                  ; $1F32
    call Delay_Frames_Busy                        ; $1F35
    ld a, BANK(Sgb_PalSetPacket)                  ; $1F38
    ld hl, Sgb_PalSetPacket                       ; $1F3A
    call Sgb_SendPacket                           ; $1F3D
    ld bc, $0004                                  ; $1F40
    call Delay_Frames_Busy                        ; $1F43
    ld a, BANK(Sgb_ChrTrnPacket0)                 ; $1F46
    ld hl, Sgb_ChrTrnPacket0                      ; $1F48
    call Sgb_SendVramTransfer                     ; $1F4B
    ld bc, $0004                                  ; $1F4E
    call Delay_Frames_Busy                        ; $1F51
    ld a, BANK(Sgb_ChrTrnPacket1)                 ; $1F54
    ld hl, Sgb_ChrTrnPacket1                      ; $1F56
    call Sgb_SendVramTransfer                     ; $1F59
    ld bc, $0004                                  ; $1F5C
    call Delay_Frames_Busy                        ; $1F5F
    ld a, BANK(Sgb_PctTrnPacket)                  ; $1F62
    ld hl, Sgb_PctTrnPacket                       ; $1F64
    call Sgb_SendVramTransfer                     ; $1F67
    ret                                           ; $1F6A


; C: MASK_EN freeze ($B9 $01) once; sets sgb_mask_active
Sgb_MaskFreeze::
    ldh a, [hSgbPresent]                          ; $1F6B
    and a                                         ; $1F6D
    ret z                                         ; $1F6E

    ldh a, [hSgbMaskActive]                       ; $1F6F
    and a                                         ; $1F71
    ret nz                                        ; $1F72

    ld a, BANK(Sgb_MaskEnPackets)                 ; $1F73
    ld hl, Sgb_MaskEnPackets                      ; $1F75
    call Sgb_SendPacket                           ; $1F78
    ld bc, $0004                                  ; $1F7B
    call Delay_Frames_Busy                        ; $1F7E
    ld a, $ff                                     ; $1F81
    ldh [hSgbMaskActive], a                       ; $1F83
    ret                                           ; $1F85


; C: MASK_EN cancel ($B9 $00) if the freeze is on
Sgb_MaskCancel::
    ldh a, [hSgbPresent]                          ; $1F86
    and a                                         ; $1F88
    ret z                                         ; $1F89

    ld bc, $0002                                  ; $1F8A
    call Delay_Frames_Busy                        ; $1F8D
    ldh a, [hSgbMaskActive]                       ; $1F90
    and a                                         ; $1F92
    ret z                                         ; $1F93

    ld a, BANK(Sgb_MaskEnPackets)                 ; $1F94
    ld hl, Sgb_MaskEnPackets + $10                ; $1F96
    call Sgb_SendPacket                           ; $1F99
    ld bc, $0004                                  ; $1F9C
    call Delay_Frames_Busy                        ; $1F9F
    xor a                                         ; $1FA2
    ldh [hSgbMaskActive], a                       ; $1FA3
    ret                                           ; $1FA5


; C: software sprite-to-BG blit; HL = 8-byte descriptor (width / height / source A / source B)
Blit_SpriteToBg::
    push bc                                       ; $1FA6
    ld de, hBlitWidth                             ; $1FA7
    ld b, $08                                     ; $1FAA

jr_000_1fac:
    ld a, [hl+]                                   ; $1FAC
    ld [de], a                                    ; $1FAD
    inc de                                        ; $1FAE
    dec b                                         ; $1FAF
    jr nz, jr_000_1fac                            ; $1FB0

    ld hl, hBlitWidth                             ; $1FB2
    ld a, [hl]                                    ; $1FB5
    and $80                                       ; $1FB6
    ldh [hBlitFlagMaskFromA], a                   ; $1FB8
    res 7, [hl]                                   ; $1FBA
    ld a, [hl]                                    ; $1FBC
    and $40                                       ; $1FBD
    ldh [hBlitFlagStride], a                      ; $1FBF
    res 6, [hl]                                   ; $1FC1
    pop bc                                        ; $1FC3
    call Blit_BuildPatchList                      ; $1FC4
    push bc                                       ; $1FC7
    call Blit_PrepareMasks                        ; $1FC8
    ldh a, [hBlitFlagMaskFromA]                   ; $1FCB
    and a                                         ; $1FCD
    jr nz, jr_000_1fd5                            ; $1FCE

    call Blit_MaskPass_SrcB                       ; $1FD0
    jr jr_000_1fd8                                ; $1FD3

jr_000_1fd5:
    call Blit_MaskPass_SrcA                       ; $1FD5

jr_000_1fd8:
    call Blit_ImagePass                           ; $1FD8
    pop bc                                        ; $1FDB
    call Blit_ApplyPatchList                      ; $1FDC
    ret                                           ; $1FDF


; I: 16 bytes identical to 1FA2; no reader found
Blit_MaskTbl_Copy_Dead::
    db $ff, $7f, $3f, $1f, $0f, $07, $03, $01, $ff, $80, $c0, $e0, $f0, $f8, $fc, $fe

; C: computes the tile address for one cell through the row table 00:2170 and stores a patch record. L3 pass
; 2026-10-26: executed in BGB in 7 replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_MakePatchEntry::
    push de                                       ; $1FF0
    ld a, c                                       ; $1FF1
    and $f8                                       ; $1FF2
    srl a                                         ; $1FF4
    srl a                                         ; $1FF6
    ld e, a                                       ; $1FF8
    ld d, $00                                     ; $1FF9
    ld hl, Blit_TileRowPtrTbl                     ; $1FFB
    add hl, de                                    ; $1FFE
    ld a, [hl+]                                   ; $1FFF
    ld h, [hl]                                    ; $2000
    ld l, a                                       ; $2001
    ld a, b                                       ; $2002
    and $f8                                       ; $2003
    srl a                                         ; $2005
    srl a                                         ; $2007
    ld e, a                                       ; $2009
    add hl, de                                    ; $200A
    pop de                                        ; $200B
    ld a, c                                       ; $200C
    and $07                                       ; $200D
    sla a                                         ; $200F
    add [hl]                                      ; $2011
    ld [de], a                                    ; $2012
    inc hl                                        ; $2013
    inc de                                        ; $2014
    ld a, [hl]                                    ; $2015
    ld [de], a                                    ; $2016
    inc de                                        ; $2017
    inc de                                        ; $2018
    inc de                                        ; $2019
    inc de                                        ; $201A
    ret                                           ; $201B


; C: builds the 5-byte patch list at $C800 for the destination rectangle. L3 pass 2026-10-26: executed in BGB in 7
; replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_BuildPatchList::
    push bc                                       ; $201C
    ld hl, hBlitWidth                             ; $201D
    ld a, b                                       ; $2020
    and $07                                       ; $2021
    add [hl]                                      ; $2023
    dec a                                         ; $2024
    srl a                                         ; $2025
    srl a                                         ; $2027
    srl a                                         ; $2029
    inc a                                         ; $202B
    ldh [hBlitDstTiles], a                        ; $202C
    ldh a, [hBlitHeight]                          ; $202E
    ldh [hBlitRows], a                            ; $2030
    ld de, wBlitPatchList                         ; $2032
    ldh a, [hBlitRows]                            ; $2035

jr_000_2037:
    push af                                       ; $2037
    push bc                                       ; $2038
    ldh a, [hBlitDstTiles]                        ; $2039

jr_000_203b:
    push af                                       ; $203B
    call Blit_MakePatchEntry                      ; $203C
    ld a, b                                       ; $203F
    add $08                                       ; $2040
    ld b, a                                       ; $2042
    pop af                                        ; $2043
    dec a                                         ; $2044
    jr nz, jr_000_203b                            ; $2045

    pop bc                                        ; $2047
    pop af                                        ; $2048
    inc c                                         ; $2049
    dec a                                         ; $204A
    jr nz, jr_000_2037                            ; $204B

    pop bc                                        ; $204D
    xor a                                         ; $204E
    ld [de], a                                    ; $204F
    inc de                                        ; $2050
    ld [de], a                                    ; $2051
    ret                                           ; $2052


; C: derives the shift page and the left / right edge masks from the x offset and width. L3 pass 2026-10-26: executed
; in BGB in 7 replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_PrepareMasks::
    ld a, b                                       ; $2053
    and $07                                       ; $2054
    add HIGH(Blit_ShiftTbl)                       ; $2056
    ldh [hBlitShiftPage], a                       ; $2058
    ld a, b                                       ; $205A
    and $07                                       ; $205B
    ld e, a                                       ; $205D
    ld d, $00                                     ; $205E
    ld hl, Blit_LeftMaskTbl                       ; $2060
    add hl, de                                    ; $2063
    ld a, [hl]                                    ; $2064
    ldh [hBlitLeftMask], a                        ; $2065
    cpl                                           ; $2067
    ldh [hBlitLeftMask + $1], a                   ; $2068
    ld hl, hBlitWidth                             ; $206A
    ld a, b                                       ; $206D
    add [hl]                                      ; $206E
    and $07                                       ; $206F
    ld e, a                                       ; $2071
    ld d, $00                                     ; $2072
    ld hl, Blit_RightMaskTbl                      ; $2074
    add hl, de                                    ; $2077
    ld a, [hl]                                    ; $2078
    ldh [hBlitRightMask], a                       ; $2079
    cpl                                           ; $207B
    ldh [hBlitRightMask + $1], a                  ; $207C
    ldh a, [hBlitWidth]                           ; $207E
    dec a                                         ; $2080
    srl a                                         ; $2081
    srl a                                         ; $2083
    srl a                                         ; $2085
    inc a                                         ; $2087
    ldh [hBlitSrcTiles], a                        ; $2088
    ldh a, [hBlitFlagStride]                      ; $208A
    and a                                         ; $208C
    jr nz, jr_000_209f                            ; $208D

    ldh a, [hBlitWidth]                           ; $208F
    srl a                                         ; $2091
    srl a                                         ; $2093
    srl a                                         ; $2095
    dec a                                         ; $2097
    swap a                                        ; $2098
    and $f0                                       ; $209A
    ldh [hBlitStride], a                          ; $209C
    ret                                           ; $209E


jr_000_209f:
    ld a, $f0                                     ; $209F
    ldh [hBlitStride], a                          ; $20A1
    ret                                           ; $20A3


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
    ldh a, [hBlitSrcB]                            ; $20B4
    ld l, a                                       ; $20B6
    ldh a, [hBlitSrcB + $1]                       ; $20B7
    ld h, a                                       ; $20B9
    ldh a, [hRomBankShadow]                       ; $20BA
    push af                                       ; $20BC
    ldh a, [hBlitSrcB + $2]                       ; $20BD
    ldh [hRomBankShadow], a                       ; $20BF
    ld [rROMB0], a                                ; $20C1
    ld de, wBlitFirstAndMask                      ; $20C4
    ld b, $08                                     ; $20C7
    ldh a, [hBlitRows]                            ; $20C9

jr_000_20cb:
    push af                                       ; $20CB
    push hl                                       ; $20CC
    ldh a, [hBlitLeftMask + $1]                   ; $20CD
    ld [de], a                                    ; $20CF
    ldh a, [hBlitSrcTiles]                        ; $20D0
    ld c, a                                       ; $20D2
    ldh a, [hBlitDstTiles]                        ; $20D3

jr_000_20d5:
    push af                                       ; $20D5
    push bc                                       ; $20D6
    ld a, c                                       ; $20D7
    and a                                         ; $20D8
    jr z, jr_000_20e0                             ; $20D9

    ld a, [hl]                                    ; $20DB
    ld bc, $0008                                  ; $20DC
    add hl, bc                                    ; $20DF

jr_000_20e0:
    push hl                                       ; $20E0
    ld l, a                                       ; $20E1
    ldh a, [hBlitShiftPage]                       ; $20E2
    ld h, a                                       ; $20E4
    ld a, [hl]                                    ; $20E5
    ldh [hBlitTmp], a                             ; $20E6
    ld hl, hBlitLeftMask                          ; $20E8
    and [hl]                                      ; $20EB
    ld l, e                                       ; $20EC
    ld h, d                                       ; $20ED
    or [hl]                                       ; $20EE
    ld [hl], a                                    ; $20EF
    inc de                                        ; $20F0
    inc de                                        ; $20F1
    inc de                                        ; $20F2
    inc de                                        ; $20F3
    inc de                                        ; $20F4
    ldh a, [hBlitTmp]                             ; $20F5
    ld hl, hBlitLeftMask + $1                     ; $20F7
    and [hl]                                      ; $20FA
    ld [de], a                                    ; $20FB
    pop hl                                        ; $20FC
    pop bc                                        ; $20FD
    pop af                                        ; $20FE
    dec c                                         ; $20FF
    dec a                                         ; $2100
    jr nz, jr_000_20d5                            ; $2101

    push de                                       ; $2103
    dec de                                        ; $2104
    dec de                                        ; $2105
    dec de                                        ; $2106
    dec de                                        ; $2107
    dec de                                        ; $2108
    ld hl, hBlitRightMask + $1                    ; $2109
    ld a, [de]                                    ; $210C
    or [hl]                                       ; $210D
    ld [de], a                                    ; $210E
    pop de                                        ; $210F
    pop hl                                        ; $2110
    inc hl                                        ; $2111
    dec b                                         ; $2112
    jr nz, jr_000_211d                            ; $2113

    ldh a, [hBlitStride]                          ; $2115
    srl a                                         ; $2117
    ld c, a                                       ; $2119
    add hl, bc                                    ; $211A
    ld b, $08                                     ; $211B

jr_000_211d:
    pop af                                        ; $211D
    dec a                                         ; $211E
    jr nz, jr_000_20cb                            ; $211F

    pop af                                        ; $2121
    ldh [hRomBankShadow], a                       ; $2122
    ld [rROMB0], a                                ; $2124
    ret                                           ; $2127


; C: mask pass deriving the mask from source A (OR of both planes)
Blit_MaskPass_SrcA::
    ldh a, [hBlitSrcA]                            ; $2128
    ld l, a                                       ; $212A
    ldh a, [hBlitSrcA + $1]                       ; $212B
    ld h, a                                       ; $212D
    ldh a, [hRomBankShadow]                       ; $212E
    push af                                       ; $2130
    ldh a, [hBlitSrcA + $2]                       ; $2131
    ldh [hRomBankShadow], a                       ; $2133
    ld [rROMB0], a                                ; $2135
    ld de, wBlitFirstAndMask                      ; $2138
    ld b, $08                                     ; $213B
    ldh a, [hBlitRows]                            ; $213D

jr_000_213f:
    push af                                       ; $213F
    push hl                                       ; $2140
    ldh a, [hBlitLeftMask + $1]                   ; $2141
    ld [de], a                                    ; $2143
    ldh a, [hBlitSrcTiles]                        ; $2144
    ld c, a                                       ; $2146
    ldh a, [hBlitDstTiles]                        ; $2147

jr_000_2149:
    push af                                       ; $2149
    push bc                                       ; $214A
    ld a, c                                       ; $214B
    and a                                         ; $214C
    jr z, jr_000_2157                             ; $214D

    ld a, [hl+]                                   ; $214F
    or [hl]                                       ; $2150
    cpl                                           ; $2151
    dec hl                                        ; $2152
    ld bc, $0010                                  ; $2153
    add hl, bc                                    ; $2156

jr_000_2157:
    push hl                                       ; $2157
    ld l, a                                       ; $2158
    ldh a, [hBlitShiftPage]                       ; $2159
    ld h, a                                       ; $215B
    ld a, [hl]                                    ; $215C
    ldh [hBlitTmp], a                             ; $215D
    ld hl, hBlitLeftMask                          ; $215F
    and [hl]                                      ; $2162
    ld l, e                                       ; $2163
    ld h, d                                       ; $2164
    or [hl]                                       ; $2165
    ld [hl], a                                    ; $2166
    inc de                                        ; $2167
    inc de                                        ; $2168
    inc de                                        ; $2169
    inc de                                        ; $216A
    inc de                                        ; $216B
    ldh a, [hBlitTmp]                             ; $216C
    ld hl, hBlitLeftMask + $1                     ; $216E
    and [hl]                                      ; $2171
    ld [de], a                                    ; $2172
    pop hl                                        ; $2173
    pop bc                                        ; $2174
    pop af                                        ; $2175
    dec c                                         ; $2176
    dec a                                         ; $2177
    jr nz, jr_000_2149                            ; $2178

    push de                                       ; $217A
    dec de                                        ; $217B
    dec de                                        ; $217C
    dec de                                        ; $217D
    dec de                                        ; $217E
    dec de                                        ; $217F
    ld hl, hBlitRightMask + $1                    ; $2180
    ld a, [de]                                    ; $2183
    or [hl]                                       ; $2184
    ld [de], a                                    ; $2185
    pop de                                        ; $2186
    pop hl                                        ; $2187
    inc hl                                        ; $2188
    inc hl                                        ; $2189
    dec b                                         ; $218A
    jr nz, jr_000_2193                            ; $218B

    ldh a, [hBlitStride]                          ; $218D
    ld c, a                                       ; $218F
    add hl, bc                                    ; $2190
    ld b, $08                                     ; $2191

jr_000_2193:
    pop af                                        ; $2193
    dec a                                         ; $2194
    jr nz, jr_000_213f                            ; $2195

    pop af                                        ; $2197
    ldh [hRomBankShadow], a                       ; $2198
    ld [rROMB0], a                                ; $219A
    ret                                           ; $219D


; C: image pass (2-bit source A)
Blit_ImagePass::
    ldh a, [hBlitSrcA]                            ; $219E
    ld l, a                                       ; $21A0
    ldh a, [hBlitSrcA + $1]                       ; $21A1
    ld h, a                                       ; $21A3
    ldh a, [hRomBankShadow]                       ; $21A4
    push af                                       ; $21A6
    ldh a, [hBlitSrcA + $2]                       ; $21A7
    ldh [hRomBankShadow], a                       ; $21A9
    ld [rROMB0], a                                ; $21AB
    ld de, wBlitFirstOrBytes                      ; $21AE
    ld b, $08                                     ; $21B1
    ldh a, [hBlitRows]                            ; $21B3

; C: loop top of the image pass: saves AF/HL, clears two bytes at DE, runs the next 8 lines (branch target; code read
; 2026-10-19)
Blit_ImagePass_Loop::
    push af                                       ; $21B5
    push hl                                       ; $21B6
    xor a                                         ; $21B7
    ld [de], a                                    ; $21B8
    inc de                                        ; $21B9
    ld [de], a                                    ; $21BA
    dec de                                        ; $21BB
    ldh a, [hBlitSrcTiles]                        ; $21BC
    ld c, a                                       ; $21BE
    ldh a, [hBlitDstTiles]                        ; $21BF

jr_000_21c1:
    push af                                       ; $21C1
    push bc                                       ; $21C2
    ld a, c                                       ; $21C3
    and a                                         ; $21C4
    jr z, jr_000_21e0                             ; $21C5

    ld a, [hl+]                                   ; $21C7
    push hl                                       ; $21C8
    ld l, a                                       ; $21C9
    ldh a, [hBlitShiftPage]                       ; $21CA
    ld h, a                                       ; $21CC
    ld a, [hl]                                    ; $21CD
    ldh [hBlitTmp], a                             ; $21CE
    pop hl                                        ; $21D0
    ld a, [hl]                                    ; $21D1
    ld bc, $000f                                  ; $21D2
    add hl, bc                                    ; $21D5
    push hl                                       ; $21D6
    ld l, a                                       ; $21D7
    ldh a, [hBlitShiftPage]                       ; $21D8
    ld h, a                                       ; $21DA
    ld a, [hl]                                    ; $21DB
    ldh [hBlitTmp + $1], a                        ; $21DC
    jr jr_000_21e5                                ; $21DE

jr_000_21e0:
    ldh [hBlitTmp], a                             ; $21E0
    ldh [hBlitTmp + $1], a                        ; $21E2
    push hl                                       ; $21E4

jr_000_21e5:
    ldh a, [hBlitTmp]                             ; $21E5
    ld hl, hBlitLeftMask                          ; $21E7
    and [hl]                                      ; $21EA
    ld l, e                                       ; $21EB
    ld h, d                                       ; $21EC
    or [hl]                                       ; $21ED
    ld [hl], a                                    ; $21EE
    inc de                                        ; $21EF
    ldh a, [hBlitTmp + $1]                        ; $21F0
    ld hl, hBlitLeftMask                          ; $21F2
    and [hl]                                      ; $21F5
    ld l, e                                       ; $21F6
    ld h, d                                       ; $21F7
    or [hl]                                       ; $21F8
    ld [hl], a                                    ; $21F9
    inc de                                        ; $21FA
    inc de                                        ; $21FB
    inc de                                        ; $21FC
    inc de                                        ; $21FD
    ldh a, [hBlitTmp]                             ; $21FE
    ld hl, hBlitLeftMask + $1                     ; $2200
    and [hl]                                      ; $2203
    ld [de], a                                    ; $2204
    inc de                                        ; $2205
    ldh a, [hBlitTmp + $1]                        ; $2206
    ld hl, hBlitLeftMask + $1                     ; $2208
    and [hl]                                      ; $220B
    ld [de], a                                    ; $220C
    dec de                                        ; $220D
    pop hl                                        ; $220E
    pop bc                                        ; $220F
    pop af                                        ; $2210
    dec c                                         ; $2211
    dec a                                         ; $2212
    jr nz, jr_000_21c1                            ; $2213

    push de                                       ; $2215
    dec de                                        ; $2216
    dec de                                        ; $2217
    dec de                                        ; $2218
    dec de                                        ; $2219
    dec de                                        ; $221A
    ld hl, hBlitRightMask                         ; $221B
    ld a, [de]                                    ; $221E
    and [hl]                                      ; $221F
    ld [de], a                                    ; $2220
    inc de                                        ; $2221
    ld a, [de]                                    ; $2222
    and [hl]                                      ; $2223
    ld [de], a                                    ; $2224
    dec de                                        ; $2225
    pop de                                        ; $2226
    pop hl                                        ; $2227
    inc hl                                        ; $2228
    inc hl                                        ; $2229
    dec b                                         ; $222A
    jr nz, jr_000_2233                            ; $222B

    ldh a, [hBlitStride]                          ; $222D
    ld c, a                                       ; $222F
    add hl, bc                                    ; $2230
    ld b, $08                                     ; $2231

jr_000_2233:
    pop af                                        ; $2233
    dec a                                         ; $2234
    jp nz, Blit_ImagePass_Loop                    ; $2235

    pop af                                        ; $2238
    ldh [hRomBankShadow], a                       ; $2239
    ld [rROMB0], a                                ; $223B
    ret                                           ; $223E


; C: applies the $C800 patch list to the tile buffer
Blit_ApplyPatchList::
    ld hl, wBlitPatchList                         ; $223F

jr_000_2242:
    ld a, $04                                     ; $2242

jr_000_2244:
    nop                                           ; $2244
    dec a                                         ; $2245
    jr nz, jr_000_2244                            ; $2246

    ld a, [hl+]                                   ; $2248
    ld e, a                                       ; $2249
    ld d, [hl]                                    ; $224A
    or d                                          ; $224B
    ret z                                         ; $224C

    inc hl                                        ; $224D
    ld a, [hl+]                                   ; $224E
    ld c, [hl]                                    ; $224F
    inc hl                                        ; $2250
    ld b, [hl]                                    ; $2251
    inc hl                                        ; $2252
    push hl                                       ; $2253
    ld l, a                                       ; $2254

jr_000_2255:
    ldh a, [rLY]                                  ; $2255
    cp $20                                        ; $2257
    jr c, jr_000_2255                             ; $2259

    cp $88                                        ; $225B
    jr nc, jr_000_2255                            ; $225D

jr_000_225f:
    ldh a, [rSTAT]                                ; $225F
    and $03                                       ; $2261
    jr nz, jr_000_225f                            ; $2263

    ld a, [de]                                    ; $2265
    and l                                         ; $2266
    or c                                          ; $2267
    ld [de], a                                    ; $2268
    inc de                                        ; $2269
    ld a, [de]                                    ; $226A
    and l                                         ; $226B
    or b                                          ; $226C
    ld [de], a                                    ; $226D
    inc de                                        ; $226E
    pop hl                                        ; $226F
    jr jr_000_2242                                ; $2270

; I: 18 words: pointer to the VRAM address row of each tile row. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the
; organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_TileRowPtrTbl::
    dw Blit_TileAddrTbl
    dw Blit_TileAddrTbl + $28
    dw Blit_TileAddrTbl + $50
    dw Blit_TileAddrTbl + $78
    dw Blit_TileAddrTbl + $A0
    dw Blit_TileAddrTbl + $C8
    dw Blit_TileAddrTbl + $F0
    dw Blit_TileAddrTbl + $118
    dw Blit_TileAddrTbl + $140
    dw Blit_TileAddrTbl + $168
    dw Blit_TileAddrTbl + $190
    dw Blit_TileAddrTbl + $1B8
    dw Blit_TileAddrTbl + $1E0
    dw Blit_TileAddrTbl + $208
    dw Blit_TileAddrTbl + $230
    dw Blit_TileAddrTbl + $258
    dw Blit_TileAddrTbl + $280
    dw Blit_TileAddrTbl + $2A8

; C: 18 rows x 20 words: low/high byte of the VRAM address of each tile cell (2 bytes per entry). L3 pass 2026-10-26:
; read in BGB in 7 replay(s) of the organic corpus, modes 10 11 (tcrf_check/assets/l3_names/)
Blit_TileAddrTbl::
    INCBIN "data/bank_00/Blit_TileAddrTbl.bin" ; $2296, 720 bytes
; C: adds an OAM list from the pointer table 02:6E4B (A = index) at the OAM cursor; BC = Y/X offset
Oam_AddMeta_B02_6F16::
    push bc                                       ; $2566
    push de                                       ; $2567
    push hl                                       ; $2568
    ld e, a                                       ; $2569
    ld d, $00                                     ; $256A
    sla e                                         ; $256C
    rl d                                          ; $256E
    ldh a, [hRomBankShadow]                       ; $2570
    push af                                       ; $2572
    ld a, $02                                     ; $2573
    ldh [hRomBankShadow], a                       ; $2575
    ld [rROMB0], a                                ; $2577
    ld hl, OamPtrTbl_B02_6F16                     ; $257A
    jr Oam_AddMeta_Common                         ; $257D

; C: same with the table 02:5272
Oam_AddMeta_B02_52BD::
    push bc                                       ; $257F
    push de                                       ; $2580
    push hl                                       ; $2581
    ld e, a                                       ; $2582
    ld d, $00                                     ; $2583
    sla e                                         ; $2585
    rl d                                          ; $2587
    ldh a, [hRomBankShadow]                       ; $2589
    push af                                       ; $258B
    ld a, $02                                     ; $258C
    ldh [hRomBankShadow], a                       ; $258E
    ld [rROMB0], a                                ; $2590
    ld hl, OamPtrTbl_B02_52BD                     ; $2593
    jr Oam_AddMeta_Common                         ; $2596

; C: same with the table 01:5D47 (246 entries)
Oam_AddMeta_B01_5D2B::
    push bc                                       ; $2598
    push de                                       ; $2599
    push hl                                       ; $259A
    ld e, a                                       ; $259B
    ld d, $00                                     ; $259C
    sla e                                         ; $259E
    rl d                                          ; $25A0
    ldh a, [hRomBankShadow]                       ; $25A2
    push af                                       ; $25A4
    ld a, $01                                     ; $25A5
    ldh [hRomBankShadow], a                       ; $25A7
    ld [rROMB0], a                                ; $25A9
    ld hl, OamPtrTbl_B01_5D2B                     ; $25AC
    jr Oam_AddMeta_Common                         ; $25AF

; C: same with the table 01:4000 (249 entries)
Oam_AddMeta_B01_4000::
    push bc                                       ; $25B1
    push de                                       ; $25B2
    push hl                                       ; $25B3
    ld e, a                                       ; $25B4
    ld d, $00                                     ; $25B5
    sla e                                         ; $25B7
    rl d                                          ; $25B9
    ldh a, [hRomBankShadow]                       ; $25BB
    push af                                       ; $25BD
    ld a, $01                                     ; $25BE
    ldh [hRomBankShadow], a                       ; $25C0
    ld [rROMB0], a                                ; $25C2
    ld hl, OamPtrTbl_B01_4000                     ; $25C5

; C: shared tail: copies 4-byte records (Y+C
Oam_AddMeta_Common::
    add hl, de                                    ; $25C8
    ld a, [hl+]                                   ; $25C9
    ld e, a                                       ; $25CA
    ld a, [hl]                                    ; $25CB
    ld d, a                                       ; $25CC
    ldh a, [hOamCursor]                           ; $25CD
    ld l, a                                       ; $25CF
    ld h, HIGH(wOamShadow)                        ; $25D0

jr_000_25d2:
    ld a, [de]                                    ; $25D2
    cp $80                                        ; $25D3
    jr z, jr_000_25e6                             ; $25D5

    add c                                         ; $25D7
    ld [hl+], a                                   ; $25D8
    inc de                                        ; $25D9
    ld a, [de]                                    ; $25DA
    add b                                         ; $25DB
    ld [hl+], a                                   ; $25DC
    inc de                                        ; $25DD
    ld a, [de]                                    ; $25DE
    ld [hl+], a                                   ; $25DF
    inc de                                        ; $25E0
    ld a, [de]                                    ; $25E1
    ld [hl+], a                                   ; $25E2
    inc de                                        ; $25E3
    jr jr_000_25d2                                ; $25E4

jr_000_25e6:
    ld a, l                                       ; $25E6
    ldh [hOamCursor], a                           ; $25E7
    pop af                                        ; $25E9
    ldh [hRomBankShadow], a                       ; $25EA
    ld [rROMB0], a                                ; $25EC
    pop hl                                        ; $25EF
    pop de                                        ; $25F0
    pop bc                                        ; $25F1
    ret                                           ; $25F2


; I: variant of the adder that also adds B to the tile number; unreferenced
Oam_AddMetaTile_B02_6F16_Dead::
    push bc                                       ; $25F3
    push de                                       ; $25F4
    push hl                                       ; $25F5
    ld e, a                                       ; $25F6
    ld d, $00                                     ; $25F7
    sla e                                         ; $25F9
    rl d                                          ; $25FB
    ldh a, [hRomBankShadow]                       ; $25FD
    push af                                       ; $25FF
    ld a, $02                                     ; $2600
    ldh [hRomBankShadow], a                       ; $2602
    ld [rROMB0], a                                ; $2604
    ld hl, OamPtrTbl_B02_6F16                     ; $2607
    jr jr_000_2655                                ; $260A

; C: variant that also adds B to the tile number (one caller 09:5046)
Oam_AddMetaTile_B02_52BD::
    push bc                                       ; $260C
    push de                                       ; $260D
    push hl                                       ; $260E
    ld e, a                                       ; $260F
    ld d, $00                                     ; $2610
    sla e                                         ; $2612
    rl d                                          ; $2614
    ldh a, [hRomBankShadow]                       ; $2616
    push af                                       ; $2618
    ld a, $02                                     ; $2619
    ldh [hRomBankShadow], a                       ; $261B
    ld [rROMB0], a                                ; $261D
    ld hl, OamPtrTbl_B02_52BD                     ; $2620
    jr jr_000_2655                                ; $2623

; I: variant with tile offset; unreferenced
Oam_AddMetaTile_B01_5D2B_Dead::
    push bc                                       ; $2625
    push de                                       ; $2626
    push hl                                       ; $2627
    ld e, a                                       ; $2628
    ld d, $00                                     ; $2629
    sla e                                         ; $262B
    rl d                                          ; $262D
    ldh a, [hRomBankShadow]                       ; $262F
    push af                                       ; $2631
    ld a, $01                                     ; $2632
    ldh [hRomBankShadow], a                       ; $2634
    ld [rROMB0], a                                ; $2636
    ld hl, OamPtrTbl_B01_5D2B                     ; $2639
    jr jr_000_2655                                ; $263C

; I: variant with tile offset; unreferenced
Oam_AddMetaTile_B01_4000_Dead::
    push bc                                       ; $263E
    push de                                       ; $263F
    push hl                                       ; $2640
    ld e, a                                       ; $2641
    ld d, $00                                     ; $2642
    sla e                                         ; $2644
    rl d                                          ; $2646
    ldh a, [hRomBankShadow]                       ; $2648
    push af                                       ; $264A
    ld a, $01                                     ; $264B
    ldh [hRomBankShadow], a                       ; $264D
    ld [rROMB0], a                                ; $264F
    ld hl, OamPtrTbl_B01_4000                     ; $2652

jr_000_2655:
    add hl, de                                    ; $2655
    ld a, [hl+]                                   ; $2656
    ld e, a                                       ; $2657
    ld a, [hl]                                    ; $2658
    ld d, a                                       ; $2659
    ldh a, [hOamCursor]                           ; $265A
    ld l, a                                       ; $265C
    ld h, HIGH(wOamShadow)                        ; $265D

jr_000_265f:
    ld a, [de]                                    ; $265F
    cp $80                                        ; $2660
    jr z, jr_000_2678                             ; $2662

    add c                                         ; $2664
    ld [hl+], a                                   ; $2665
    inc de                                        ; $2666
    ld a, [de]                                    ; $2667
    add b                                         ; $2668
    ld [hl+], a                                   ; $2669
    inc de                                        ; $266A
    ld a, [de]                                    ; $266B
    push hl                                       ; $266C
    ld hl, sp+$07                                 ; $266D
    add [hl]                                      ; $266F
    pop hl                                        ; $2670
    ld [hl+], a                                   ; $2671
    inc de                                        ; $2672
    ld a, [de]                                    ; $2673
    ld [hl+], a                                   ; $2674
    inc de                                        ; $2675
    jr jr_000_265f                                ; $2676

jr_000_2678:
    ld a, l                                       ; $2678
    ldh [hOamCursor], a                           ; $2679
    pop af                                        ; $267B
    ldh [hRomBankShadow], a                       ; $267C
    ld [rROMB0], a                                ; $267E
    pop hl                                        ; $2681
    pop de                                        ; $2682
    pop bc                                        ; $2683
    ret                                           ; $2684


; C: photo -> 32x28 thumbnail (4x4 blocks with the quantizer); callers 02:472C / 02:47ED
Img_ReduceToThumbnail::
    push bc                                       ; $2685
    push de                                       ; $2686
    push hl                                       ; $2687
    ld e, [hl]                                    ; $2688
    inc hl                                        ; $2689
    ld a, [hl+]                                   ; $268A
    ld d, a                                       ; $268B
    cp $a0                                        ; $268C
    ld a, [hl]                                    ; $268E
    jr nc, jr_000_26a0                            ; $268F

    ldh [hBankTmp], a                             ; $2691
    ldh a, [hRomBankShadow]                       ; $2693
    push af                                       ; $2695
    ldh a, [hBankTmp]                             ; $2696
    ldh [hRomBankShadow], a                       ; $2698
    ld [rROMB0], a                                ; $269A
    scf                                           ; $269D
    jr jr_000_26a4                                ; $269E

jr_000_26a0:
    ld [rRAMB], a                                 ; $26A0
    and a                                         ; $26A3

jr_000_26a4:
    push af                                       ; $26A4
    ld h, b                                       ; $26A5
    ld l, c                                       ; $26A6
    ld c, $04                                     ; $26A7

jr_000_26a9:
    push bc                                       ; $26A9
    ld b, $04                                     ; $26AA
    ld a, c                                       ; $26AC
    cp $01                                        ; $26AD
    jr nz, jr_000_26b3                            ; $26AF

    ld b, $02                                     ; $26B1

jr_000_26b3:
    ld c, $04                                     ; $26B3
    push hl                                       ; $26B5

jr_000_26b6:
    push bc                                       ; $26B6
    push hl                                       ; $26B7
    ld hl, wReducerAccum                          ; $26B8
    ld b, $08                                     ; $26BB

jr_000_26bd:
    ld c, $04                                     ; $26BD
    xor a                                         ; $26BF
    ld [hl+], a                                   ; $26C0
    ld [hl], a                                    ; $26C1

jr_000_26c2:
    call Img_PairLookup                           ; $26C2
    push af                                       ; $26C5
    and $0f                                       ; $26C6
    add [hl]                                      ; $26C8
    ld [hl-], a                                   ; $26C9
    pop af                                        ; $26CA
    swap a                                        ; $26CB
    and $0f                                       ; $26CD
    add [hl]                                      ; $26CF
    ld [hl+], a                                   ; $26D0
    dec c                                         ; $26D1
    jr nz, jr_000_26c2                            ; $26D2

    inc hl                                        ; $26D4
    dec b                                         ; $26D5
    jr nz, jr_000_26bd                            ; $26D6

    pop hl                                        ; $26D8
    push de                                       ; $26D9
    push hl                                       ; $26DA
    ld hl, wReducerAccum                          ; $26DB
    ld de, $0080                                  ; $26DE
    call Img_PackQuadBits                         ; $26E1
    pop hl                                        ; $26E4
    ld [hl], c                                    ; $26E5
    inc hl                                        ; $26E6
    ld [hl], b                                    ; $26E7
    inc hl                                        ; $26E8
    push hl                                       ; $26E9
    ld hl, wReducerAccum + $2                     ; $26EA
    ld de, $0008                                  ; $26ED
    call Img_PackQuadBits                         ; $26F0
    pop hl                                        ; $26F3
    ld [hl], c                                    ; $26F4
    inc hl                                        ; $26F5
    ld [hl], b                                    ; $26F6
    ld bc, $000d                                  ; $26F7
    add hl, bc                                    ; $26FA
    pop de                                        ; $26FB
    pop bc                                        ; $26FC
    dec c                                         ; $26FD
    jr nz, jr_000_26b6                            ; $26FE

    pop hl                                        ; $2700
    inc hl                                        ; $2701
    inc hl                                        ; $2702
    inc hl                                        ; $2703
    inc hl                                        ; $2704
    dec b                                         ; $2705
    jr nz, jr_000_26b3                            ; $2706

    ld bc, $0030                                  ; $2708
    add hl, bc                                    ; $270B
    pop bc                                        ; $270C
    dec c                                         ; $270D
    jr nz, jr_000_26a9                            ; $270E

    pop af                                        ; $2710
    jr nc, jr_000_2719                            ; $2711

    pop af                                        ; $2713
    ldh [hRomBankShadow], a                       ; $2714
    ld [rROMB0], a                                ; $2716

jr_000_2719:
    pop hl                                        ; $2719
    pop de                                        ; $271A
    pop bc                                        ; $271B
    ret                                           ; $271C


; C: two bytes through the table at $37xx -> one 2-bit value (b + 2*c). L3 pass 2026-10-26: executed in BGB in 3
; replay(s) of the organic corpus, modes 10 14 (tcrf_check/assets/l3_names/)
Img_PairLookup::
    push bc                                       ; $271D
    push hl                                       ; $271E
    ld b, $00                                     ; $271F
    ld a, [de]                                    ; $2721
    inc de                                        ; $2722
    ld l, a                                       ; $2723
    ld h, HIGH(Img_PairLookupTbl)                 ; $2724
    ld b, [hl]                                    ; $2726
    ld a, [de]                                    ; $2727
    inc de                                        ; $2728
    ld l, a                                       ; $2729
    ld h, HIGH(Img_PairLookupTbl)                 ; $272A
    ld a, [hl]                                    ; $272C
    sla a                                         ; $272D
    add b                                         ; $272F
    pop hl                                        ; $2730
    pop bc                                        ; $2731
    ret                                           ; $2732


; C: packs four rows of 2-bit values into BC after adding the dither offsets D / E. L3 pass 2026-10-26: executed in
; BGB in 3 replay(s) of the organic corpus, modes 10 14 (tcrf_check/assets/l3_names/)
Img_PackQuadBits::
    ld bc, $0000                                  ; $2733
    ld a, $04                                     ; $2736

jr_000_2738:
    push af                                       ; $2738
    ld a, [hl+]                                   ; $2739
    add d                                         ; $273A
    swap a                                        ; $273B
    srl a                                         ; $273D
    rl c                                          ; $273F
    srl a                                         ; $2741
    rl b                                          ; $2743
    ld a, [hl+]                                   ; $2745
    add e                                         ; $2746
    swap a                                        ; $2747
    srl a                                         ; $2749
    rl c                                          ; $274B
    srl a                                         ; $274D
    rl b                                          ; $274F
    inc hl                                        ; $2751
    inc hl                                        ; $2752
    pop af                                        ; $2753
    dec a                                         ; $2754
    jr nz, jr_000_2738                            ; $2755

    ret                                           ; $2757


; C: photo -> 64x56 preview at $C000
Img_ReduceTo64x56::
    push bc                                       ; $2758
    push de                                       ; $2759
    push hl                                       ; $275A
    ld e, [hl]                                    ; $275B
    inc hl                                        ; $275C
    ld a, [hl+]                                   ; $275D
    ld d, a                                       ; $275E
    cp $a0                                        ; $275F
    ld a, [hl]                                    ; $2761
    jr nc, jr_000_2773                            ; $2762

    ldh [hBankTmp], a                             ; $2764
    ldh a, [hRomBankShadow]                       ; $2766
    push af                                       ; $2768
    ldh a, [hBankTmp]                             ; $2769
    ldh [hRomBankShadow], a                       ; $276B
    ld [rROMB0], a                                ; $276D
    scf                                           ; $2770
    jr jr_000_2777                                ; $2771

jr_000_2773:
    ld [rRAMB], a                                 ; $2773
    and a                                         ; $2776

jr_000_2777:
    push af                                       ; $2777
    ld h, b                                       ; $2778
    ld l, c                                       ; $2779
    ld c, $07                                     ; $277A

; C: row-group loop top of the 64x56 reducer (B = 2, C = 8 reloaded) (branch target; code read 2026-10-19)
Img_ReduceTo64x56_RowLoop::
    push bc                                       ; $277C
    ld b, $02                                     ; $277D

; C: column loop top of the 64x56 reducer (C = 8 reloaded, B counts down) (branch target; code read 2026-10-19)
Img_ReduceTo64x56_ColLoop::
    ld c, $08                                     ; $277F
    push hl                                       ; $2781

jr_000_2782:
    push bc                                       ; $2782
    push hl                                       ; $2783
    ld hl, wReducerAccum                          ; $2784
    ld b, $08                                     ; $2787

jr_000_2789:
    ld c, $02                                     ; $2789
    xor a                                         ; $278B
    ld [hl+], a                                   ; $278C
    ld [hl+], a                                   ; $278D
    ld [hl+], a                                   ; $278E
    ld [hl], a                                    ; $278F

jr_000_2790:
    call Img_CombineNibbleMap                     ; $2790
    ld a, [wReducerResult]                        ; $2793
    push af                                       ; $2796
    and $0f                                       ; $2797
    add [hl]                                      ; $2799
    ld [hl-], a                                   ; $279A
    pop af                                        ; $279B
    swap a                                        ; $279C
    and $0f                                       ; $279E
    add [hl]                                      ; $27A0
    ld [hl-], a                                   ; $27A1
    ld a, [wReducerResult + $1]                   ; $27A2
    push af                                       ; $27A5
    and $0f                                       ; $27A6
    add [hl]                                      ; $27A8
    ld [hl-], a                                   ; $27A9
    pop af                                        ; $27AA
    swap a                                        ; $27AB
    and $0f                                       ; $27AD
    add [hl]                                      ; $27AF
    ld [hl+], a                                   ; $27B0
    inc hl                                        ; $27B1
    inc hl                                        ; $27B2
    dec c                                         ; $27B3
    jr nz, jr_000_2790                            ; $27B4

    inc hl                                        ; $27B6
    dec b                                         ; $27B7
    jr nz, jr_000_2789                            ; $27B8

    pop hl                                        ; $27BA
    push de                                       ; $27BB
    push hl                                       ; $27BC
    ld hl, wReducerAccum                          ; $27BD
    ld de, $0020                                  ; $27C0
    call Img_QuantizeBlockDither                  ; $27C3
    pop hl                                        ; $27C6
    ld [hl], c                                    ; $27C7
    inc hl                                        ; $27C8
    ld [hl], b                                    ; $27C9
    inc hl                                        ; $27CA
    push hl                                       ; $27CB
    ld de, $0002                                  ; $27CC
    ld hl, wReducerAccum + $4                     ; $27CF
    call Img_QuantizeBlockDither                  ; $27D2
    pop hl                                        ; $27D5
    ld [hl], c                                    ; $27D6
    inc hl                                        ; $27D7
    ld [hl], b                                    ; $27D8
    inc hl                                        ; $27D9
    push hl                                       ; $27DA
    ld de, $0020                                  ; $27DB
    ld hl, wReducerAccum + $8                     ; $27DE
    call Img_QuantizeBlockDither                  ; $27E1
    pop hl                                        ; $27E4
    ld [hl], c                                    ; $27E5
    inc hl                                        ; $27E6
    ld [hl], b                                    ; $27E7
    inc hl                                        ; $27E8
    push hl                                       ; $27E9
    ld de, $0002                                  ; $27EA
    ld hl, wReducerAccum + $c                     ; $27ED
    call Img_QuantizeBlockDither                  ; $27F0
    pop hl                                        ; $27F3
    ld [hl], c                                    ; $27F4
    inc hl                                        ; $27F5
    ld [hl], b                                    ; $27F6
    ld bc, $0009                                  ; $27F7
    add hl, bc                                    ; $27FA
    pop de                                        ; $27FB
    pop bc                                        ; $27FC
    dec c                                         ; $27FD
    jr nz, jr_000_2782                            ; $27FE

    pop hl                                        ; $2800
    push bc                                       ; $2801
    ld bc, $0008                                  ; $2802
    add hl, bc                                    ; $2805
    pop bc                                        ; $2806
    dec b                                         ; $2807
    jp nz, Img_ReduceTo64x56_ColLoop              ; $2808

    ld bc, $0070                                  ; $280B
    add hl, bc                                    ; $280E
    pop bc                                        ; $280F
    ldh a, [hKeysHeld]                            ; $2810
    and PADF_B | PADF_SELECT | PADF_START | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $2812
    jr nz, jr_000_2828                            ; $2814

    dec c                                         ; $2816
    jp nz, Img_ReduceTo64x56_RowLoop              ; $2817

    pop af                                        ; $281A
    jr nc, jr_000_2823                            ; $281B

    pop af                                        ; $281D
    ldh [hRomBankShadow], a                       ; $281E
    ld [rROMB0], a                                ; $2820

jr_000_2823:
    pop hl                                        ; $2823
    pop de                                        ; $2824
    pop bc                                        ; $2825
    and a                                         ; $2826
    ret                                           ; $2827


jr_000_2828:
    pop af                                        ; $2828
    jr nc, jr_000_2831                            ; $2829

    pop af                                        ; $282B
    ldh [hRomBankShadow], a                       ; $282C
    ld [rROMB0], a                                ; $282E

jr_000_2831:
    pop hl                                        ; $2831
    pop de                                        ; $2832
    pop bc                                        ; $2833
    scf                                           ; $2834
    ret                                           ; $2835


; C: quadrant -> 4x4 tile grid at $C000-$C0FF
Img_ReduceQuadrantTo4x4Tiles::
    push bc                                       ; $2836
    push de                                       ; $2837
    push hl                                       ; $2838
    ld e, [hl]                                    ; $2839
    inc hl                                        ; $283A
    ld a, [hl+]                                   ; $283B
    ld d, a                                       ; $283C
    cp $a0                                        ; $283D
    ld a, [hl]                                    ; $283F
    jr nc, jr_000_2851                            ; $2840

    ldh [hBankTmp], a                             ; $2842
    ldh a, [hRomBankShadow]                       ; $2844
    push af                                       ; $2846
    ldh a, [hBankTmp]                             ; $2847
    ldh [hRomBankShadow], a                       ; $2849
    ld [rROMB0], a                                ; $284B
    scf                                           ; $284E
    jr jr_000_2855                                ; $284F

jr_000_2851:
    ld [rRAMB], a                                 ; $2851
    and a                                         ; $2854

jr_000_2855:
    push af                                       ; $2855
    ld h, b                                       ; $2856
    ld l, c                                       ; $2857
    ld c, $04                                     ; $2858

; C: row-group loop top of the quadrant reducer (B = 2, C = 4 reloaded) (branch target; code read 2026-10-19)
Img_ReduceQuadrantTo4x4Tiles_RowLoop::
    push bc                                       ; $285A
    ld b, $02                                     ; $285B

; C: column loop top of the quadrant reducer (C = 4 reloaded, B counts down) (branch target; code read 2026-10-19)
Img_ReduceQuadrantTo4x4Tiles_ColLoop::
    ld c, $04                                     ; $285D
    push hl                                       ; $285F

jr_000_2860:
    push bc                                       ; $2860
    push hl                                       ; $2861
    ld hl, wReducerAccum                          ; $2862
    ld b, $08                                     ; $2865

jr_000_2867:
    ld c, $02                                     ; $2867
    xor a                                         ; $2869
    ld [hl+], a                                   ; $286A
    ld [hl+], a                                   ; $286B
    ld [hl+], a                                   ; $286C
    ld [hl], a                                    ; $286D

jr_000_286e:
    call Img_CombineNibbleMap                     ; $286E
    ld a, [wReducerResult]                        ; $2871
    push af                                       ; $2874
    and $0f                                       ; $2875
    add [hl]                                      ; $2877
    ld [hl-], a                                   ; $2878
    pop af                                        ; $2879
    swap a                                        ; $287A
    and $0f                                       ; $287C
    add [hl]                                      ; $287E
    ld [hl-], a                                   ; $287F
    ld a, [wReducerResult + $1]                   ; $2880
    push af                                       ; $2883
    and $0f                                       ; $2884
    add [hl]                                      ; $2886
    ld [hl-], a                                   ; $2887
    pop af                                        ; $2888
    swap a                                        ; $2889
    and $0f                                       ; $288B
    add [hl]                                      ; $288D
    ld [hl+], a                                   ; $288E
    inc hl                                        ; $288F
    inc hl                                        ; $2890
    dec c                                         ; $2891
    jr nz, jr_000_286e                            ; $2892

    inc hl                                        ; $2894
    dec b                                         ; $2895
    jr nz, jr_000_2867                            ; $2896

    ld hl, wReducerAccum                          ; $2898
    call Img_QuantizeBlockRound                   ; $289B
    pop hl                                        ; $289E
    ld [hl], c                                    ; $289F
    inc hl                                        ; $28A0
    ld [hl], b                                    ; $28A1
    inc hl                                        ; $28A2
    push hl                                       ; $28A3
    ld hl, wReducerAccum + $4                     ; $28A4
    call Img_QuantizeBlockRound                   ; $28A7
    pop hl                                        ; $28AA
    ld [hl], c                                    ; $28AB
    inc hl                                        ; $28AC
    ld [hl], b                                    ; $28AD
    inc hl                                        ; $28AE
    push hl                                       ; $28AF
    ld hl, wReducerAccum + $8                     ; $28B0
    call Img_QuantizeBlockRound                   ; $28B3
    pop hl                                        ; $28B6
    ld [hl], c                                    ; $28B7
    inc hl                                        ; $28B8
    ld [hl], b                                    ; $28B9
    inc hl                                        ; $28BA
    push hl                                       ; $28BB
    ld hl, wReducerAccum + $c                     ; $28BC
    call Img_QuantizeBlockRound                   ; $28BF
    pop hl                                        ; $28C2
    ld [hl], c                                    ; $28C3
    inc hl                                        ; $28C4
    ld [hl], b                                    ; $28C5
    ld bc, $0009                                  ; $28C6
    add hl, bc                                    ; $28C9
    pop bc                                        ; $28CA
    dec c                                         ; $28CB
    jr nz, jr_000_2860                            ; $28CC

    ld a, e                                       ; $28CE
    add $80                                       ; $28CF
    ld e, a                                       ; $28D1
    jr nc, jr_000_28d5                            ; $28D2

    inc d                                         ; $28D4

jr_000_28d5:
    pop hl                                        ; $28D5
    push bc                                       ; $28D6
    ld bc, $0008                                  ; $28D7
    add hl, bc                                    ; $28DA
    pop bc                                        ; $28DB
    dec b                                         ; $28DC
    jp nz, Img_ReduceQuadrantTo4x4Tiles_ColLoop   ; $28DD

    ld bc, $0030                                  ; $28E0
    add hl, bc                                    ; $28E3
    pop bc                                        ; $28E4
    dec c                                         ; $28E5
    jp nz, Img_ReduceQuadrantTo4x4Tiles_RowLoop   ; $28E6

    pop af                                        ; $28E9
    jr nc, jr_000_28f2                            ; $28EA

    pop af                                        ; $28EC
    ldh [hRomBankShadow], a                       ; $28ED
    ld [rROMB0], a                                ; $28EF

jr_000_28f2:
    pop hl                                        ; $28F2
    pop de                                        ; $28F3
    pop bc                                        ; $28F4
    ret                                           ; $28F5


; C: 2:1 reduction to $C000-$C1BF (6 callers in bank 06). L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the
; organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Img_ReduceHalfTo224Wide::
    push bc                                       ; $28F6
    push de                                       ; $28F7
    push hl                                       ; $28F8
    ld e, [hl]                                    ; $28F9
    inc hl                                        ; $28FA
    ld a, [hl+]                                   ; $28FB
    ld d, a                                       ; $28FC
    cp $a0                                        ; $28FD
    ld a, [hl]                                    ; $28FF
    jr nc, jr_000_2911                            ; $2900

    ldh [hBankTmp], a                             ; $2902
    ldh a, [hRomBankShadow]                       ; $2904
    push af                                       ; $2906
    ldh a, [hBankTmp]                             ; $2907
    ldh [hRomBankShadow], a                       ; $2909
    ld [rROMB0], a                                ; $290B
    scf                                           ; $290E
    jr jr_000_2915                                ; $290F

jr_000_2911:
    ld [rRAMB], a                                 ; $2911
    and a                                         ; $2914

jr_000_2915:
    push af                                       ; $2915
    ld h, b                                       ; $2916
    ld l, c                                       ; $2917
    ld c, $07                                     ; $2918

; C: row-group loop top of the half-size reducer (B = 2, C = 8) (branch target; code read 2026-10-19)
Img_ReduceHalfTo224Wide_RowLoop::
    push bc                                       ; $291A
    ld b, $02                                     ; $291B

jr_000_291d:
    ld c, $08                                     ; $291D
    push hl                                       ; $291F

jr_000_2920:
    push bc                                       ; $2920
    push hl                                       ; $2921
    ld hl, wReducerAccum                          ; $2922
    ld b, $04                                     ; $2925

jr_000_2927:
    ld c, $02                                     ; $2927
    xor a                                         ; $2929
    ld [hl+], a                                   ; $292A
    ld [hl+], a                                   ; $292B
    ld [hl+], a                                   ; $292C
    ld [hl], a                                    ; $292D

jr_000_292e:
    call Img_CombineNibbleMap                     ; $292E
    ld a, [wReducerResult]                        ; $2931
    push af                                       ; $2934
    and $0f                                       ; $2935
    add [hl]                                      ; $2937
    ld [hl-], a                                   ; $2938
    pop af                                        ; $2939
    swap a                                        ; $293A
    and $0f                                       ; $293C
    add [hl]                                      ; $293E
    ld [hl-], a                                   ; $293F
    ld a, [wReducerResult + $1]                   ; $2940
    push af                                       ; $2943
    and $0f                                       ; $2944
    add [hl]                                      ; $2946
    ld [hl-], a                                   ; $2947
    pop af                                        ; $2948
    swap a                                        ; $2949
    and $0f                                       ; $294B
    add [hl]                                      ; $294D
    ld [hl+], a                                   ; $294E
    inc hl                                        ; $294F
    inc hl                                        ; $2950
    dec c                                         ; $2951
    jr nz, jr_000_292e                            ; $2952

    inc de                                        ; $2954
    inc de                                        ; $2955
    inc de                                        ; $2956
    inc de                                        ; $2957
    inc hl                                        ; $2958
    inc hl                                        ; $2959
    inc hl                                        ; $295A
    inc hl                                        ; $295B
    inc hl                                        ; $295C
    dec b                                         ; $295D
    jr nz, jr_000_2927                            ; $295E

    ld hl, wReducerAccum                          ; $2960
    call Img_QuantizeBlockRound                   ; $2963
    pop hl                                        ; $2966
    ld [hl], c                                    ; $2967
    inc hl                                        ; $2968
    ld [hl], b                                    ; $2969
    inc hl                                        ; $296A
    push hl                                       ; $296B
    ld hl, wReducerAccum + $8                     ; $296C
    call Img_QuantizeBlockRound                   ; $296F
    pop hl                                        ; $2972
    ld [hl], c                                    ; $2973
    inc hl                                        ; $2974
    ld [hl], b                                    ; $2975
    ld bc, $0005                                  ; $2976
    add hl, bc                                    ; $2979
    pop bc                                        ; $297A
    dec c                                         ; $297B
    jr nz, jr_000_2920                            ; $297C

    pop hl                                        ; $297E
    push bc                                       ; $297F
    ld bc, $0004                                  ; $2980
    add hl, bc                                    ; $2983
    pop bc                                        ; $2984
    dec b                                         ; $2985
    jr nz, jr_000_291d                            ; $2986

    ld bc, $0038                                  ; $2988
    add hl, bc                                    ; $298B
    pop bc                                        ; $298C
    dec c                                         ; $298D
    jp nz, Img_ReduceHalfTo224Wide_RowLoop        ; $298E

    pop af                                        ; $2991
    jr nc, jr_000_299a                            ; $2992

    pop af                                        ; $2994
    ldh [hRomBankShadow], a                       ; $2995
    ld [rROMB0], a                                ; $2997

jr_000_299a:
    pop hl                                        ; $299A
    pop de                                        ; $299B
    pop bc                                        ; $299C
    ret                                           ; $299D


; C: maps the nibbles of two bytes through the 16-entry table at 00:36F0 -> $D000 / $D001
Img_CombineNibbleMap::
    push bc                                       ; $299E
    push hl                                       ; $299F
    ld a, [de]                                    ; $29A0
    and $0f                                       ; $29A1
    add $f0                                       ; $29A3
    ld l, a                                       ; $29A5
    ld h, $36                                     ; $29A6
    ld a, [hl]                                    ; $29A8
    ld c, a                                       ; $29A9
    ld a, [de]                                    ; $29AA
    swap a                                        ; $29AB
    and $0f                                       ; $29AD
    add $f0                                       ; $29AF
    ld l, a                                       ; $29B1
    ld h, $36                                     ; $29B2
    ld b, [hl]                                    ; $29B4
    inc de                                        ; $29B5
    ld a, [de]                                    ; $29B6
    and $0f                                       ; $29B7
    add $f0                                       ; $29B9
    ld l, a                                       ; $29BB
    ld h, $36                                     ; $29BC
    ld a, [hl]                                    ; $29BE
    sla a                                         ; $29BF
    add c                                         ; $29C1
    ld [wReducerResult], a                        ; $29C2
    ld a, [de]                                    ; $29C5
    swap a                                        ; $29C6
    and $0f                                       ; $29C8
    add $f0                                       ; $29CA
    ld l, a                                       ; $29CC
    ld h, $36                                     ; $29CD
    ld a, [hl]                                    ; $29CF
    sla a                                         ; $29D0
    add b                                         ; $29D2
    ld [wReducerResult + $1], a                   ; $29D3
    inc de                                        ; $29D6
    pop hl                                        ; $29D7
    pop bc                                        ; $29D8
    ret                                           ; $29D9


; C: adds 2 and keeps 2-bit level planes of an 8x2 block. L3 pass 2026-10-26: executed in BGB in 19 replay(s) of the
; organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Img_QuantizeBlockRound::
    push de                                       ; $29DA
    ld de, $000c                                  ; $29DB
    ld bc, $0000                                  ; $29DE
    ld a, $02                                     ; $29E1

jr_000_29e3:
    push af                                       ; $29E3
    ld a, [hl+]                                   ; $29E4
    add $02                                       ; $29E5
    srl a                                         ; $29E7
    srl a                                         ; $29E9
    srl a                                         ; $29EB
    rl c                                          ; $29ED
    srl a                                         ; $29EF
    rl b                                          ; $29F1
    ld a, [hl+]                                   ; $29F3
    add $02                                       ; $29F4
    srl a                                         ; $29F6
    srl a                                         ; $29F8
    srl a                                         ; $29FA
    rl c                                          ; $29FC
    srl a                                         ; $29FE
    rl b                                          ; $2A00
    ld a, [hl+]                                   ; $2A02
    add $02                                       ; $2A03
    srl a                                         ; $2A05
    srl a                                         ; $2A07
    srl a                                         ; $2A09
    rl c                                          ; $2A0B
    srl a                                         ; $2A0D
    rl b                                          ; $2A0F
    ld a, [hl+]                                   ; $2A11
    add $02                                       ; $2A12
    srl a                                         ; $2A14
    srl a                                         ; $2A16
    srl a                                         ; $2A18
    rl c                                          ; $2A1A
    srl a                                         ; $2A1C
    rl b                                          ; $2A1E
    add hl, de                                    ; $2A20
    pop af                                        ; $2A21
    dec a                                         ; $2A22
    jr nz, jr_000_29e3                            ; $2A23

    pop de                                        ; $2A25
    ret                                           ; $2A26


; C: same with the dither offsets D / E. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus,
; modes 12 1E (tcrf_check/assets/l3_names/)
Img_QuantizeBlockDither::
    ld bc, $0000                                  ; $2A27
    ld a, $02                                     ; $2A2A

jr_000_2a2c:
    push af                                       ; $2A2C
    ld a, [hl+]                                   ; $2A2D
    add d                                         ; $2A2E
    srl a                                         ; $2A2F
    srl a                                         ; $2A31
    srl a                                         ; $2A33
    rl c                                          ; $2A35
    srl a                                         ; $2A37
    rl b                                          ; $2A39
    ld a, [hl+]                                   ; $2A3B
    add e                                         ; $2A3C
    srl a                                         ; $2A3D
    srl a                                         ; $2A3F
    srl a                                         ; $2A41
    rl c                                          ; $2A43
    srl a                                         ; $2A45
    rl b                                          ; $2A47
    ld a, [hl+]                                   ; $2A49
    add d                                         ; $2A4A
    srl a                                         ; $2A4B
    srl a                                         ; $2A4D
    srl a                                         ; $2A4F
    rl c                                          ; $2A51
    srl a                                         ; $2A53
    rl b                                          ; $2A55
    ld a, [hl+]                                   ; $2A57
    add e                                         ; $2A58
    srl a                                         ; $2A59
    srl a                                         ; $2A5B
    srl a                                         ; $2A5D
    rl c                                          ; $2A5F
    srl a                                         ; $2A61
    rl b                                          ; $2A63
    ld a, l                                       ; $2A65
    add $0c                                       ; $2A66
    ld l, a                                       ; $2A68
    jr nc, jr_000_2a6c                            ; $2A69

    inc h                                         ; $2A6B

jr_000_2a6c:
    pop af                                        ; $2A6C
    dec a                                         ; $2A6D
    jr nz, jr_000_2a2c                            ; $2A6E

    ret                                           ; $2A70


; C: draws the thumbnail frame and the bottom line at pixel row 27. L3 pass 2026-10-26: executed in BGB in 3 replay(s)
; of the organic corpus, modes 10 14 (tcrf_check/assets/l3_names/)
Thumb_DrawFrame::
    push bc                                       ; $2A71
    push de                                       ; $2A72
    push hl                                       ; $2A73
    ld de, $0000                                  ; $2A74
    bit 0, a                                      ; $2A77
    jr z, jr_000_2a7d                             ; $2A79

    ld e, $ff                                     ; $2A7B

jr_000_2a7d:
    bit 1, a                                      ; $2A7D
    jr z, jr_000_2a83                             ; $2A7F

    ld d, $ff                                     ; $2A81

jr_000_2a83:
    push hl                                       ; $2A83
    ld bc, $000f                                  ; $2A84
    ld a, $04                                     ; $2A87

jr_000_2a89:
    ld [hl], e                                    ; $2A89
    inc hl                                        ; $2A8A
    ld [hl], d                                    ; $2A8B
    add hl, bc                                    ; $2A8C
    dec a                                         ; $2A8D
    jr nz, jr_000_2a89                            ; $2A8E

    ld bc, $0086                                  ; $2A90
    add hl, bc                                    ; $2A93
    ld bc, $000f                                  ; $2A94
    ld a, $04                                     ; $2A97

jr_000_2a99:
    ld [hl], e                                    ; $2A99
    inc hl                                        ; $2A9A
    ld [hl], d                                    ; $2A9B
    add hl, bc                                    ; $2A9C
    dec a                                         ; $2A9D
    jr nz, jr_000_2a99                            ; $2A9E

    pop hl                                        ; $2AA0
    push de                                       ; $2AA1
    push hl                                       ; $2AA2
    ld a, e                                       ; $2AA3
    and $80                                       ; $2AA4
    ld e, a                                       ; $2AA6
    ld a, d                                       ; $2AA7
    and $80                                       ; $2AA8
    ld d, a                                       ; $2AAA
    ld b, $04                                     ; $2AAB

jr_000_2aad:
    push bc                                       ; $2AAD
    ld c, $08                                     ; $2AAE
    dec b                                         ; $2AB0
    jr nz, jr_000_2ab5                            ; $2AB1

    ld c, $04                                     ; $2AB3

jr_000_2ab5:
    ld a, [hl]                                    ; $2AB5
    and $7f                                       ; $2AB6
    or e                                          ; $2AB8
    ld [hl+], a                                   ; $2AB9
    ld a, [hl]                                    ; $2ABA
    and $7f                                       ; $2ABB
    or d                                          ; $2ABD
    ld [hl+], a                                   ; $2ABE
    dec c                                         ; $2ABF
    jr nz, jr_000_2ab5                            ; $2AC0

    ld bc, $0030                                  ; $2AC2
    add hl, bc                                    ; $2AC5
    pop bc                                        ; $2AC6
    dec b                                         ; $2AC7
    jr nz, jr_000_2aad                            ; $2AC8

    pop hl                                        ; $2ACA
    pop de                                        ; $2ACB
    ld bc, $0030                                  ; $2ACC
    add hl, bc                                    ; $2ACF
    ld a, e                                       ; $2AD0
    and $01                                       ; $2AD1
    ld e, a                                       ; $2AD3
    ld a, d                                       ; $2AD4
    and $01                                       ; $2AD5
    ld d, a                                       ; $2AD7
    ld b, $04                                     ; $2AD8

jr_000_2ada:
    push bc                                       ; $2ADA
    ld c, $08                                     ; $2ADB
    dec b                                         ; $2ADD
    jr nz, jr_000_2ae2                            ; $2ADE

    ld c, $04                                     ; $2AE0

jr_000_2ae2:
    ld a, [hl]                                    ; $2AE2
    and $fe                                       ; $2AE3
    or e                                          ; $2AE5
    ld [hl+], a                                   ; $2AE6
    ld a, [hl]                                    ; $2AE7
    and $fe                                       ; $2AE8
    or d                                          ; $2AEA
    ld [hl+], a                                   ; $2AEB
    dec c                                         ; $2AEC
    jr nz, jr_000_2ae2                            ; $2AED

    ld bc, $0030                                  ; $2AEF
    add hl, bc                                    ; $2AF2
    pop bc                                        ; $2AF3
    dec b                                         ; $2AF4
    jr nz, jr_000_2ada                            ; $2AF5

    pop hl                                        ; $2AF7
    pop de                                        ; $2AF8
    pop bc                                        ; $2AF9
    ret                                           ; $2AFA


; C: 6 records {row byte offset, OR mask, XOR mask}: for the two bytes at DE+offset sets bits 7-2 to (b OR $FC) XOR
; mask, which draws a white C cut out of a black 6 x 6 block on tile rows 1-6 of the tile at D:E (D = $CE from
; 02:47FE); only called when the work-buffer copy flag $CF33 is not 0 (album ...
Thumb_DrawCopyBadge::
    ld hl, Thumb_CopyBadgeTbl                     ; $2AFB
    ld b, $06                                     ; $2AFE

jr_000_2b00:
    ld e, [hl]                                    ; $2B00
    inc hl                                        ; $2B01
    ld a, [de]                                    ; $2B02
    or [hl]                                       ; $2B03
    inc hl                                        ; $2B04
    xor [hl]                                      ; $2B05
    ld [de], a                                    ; $2B06
    inc de                                        ; $2B07
    dec hl                                        ; $2B08
    ld a, [de]                                    ; $2B09
    or [hl]                                       ; $2B0A
    inc hl                                        ; $2B0B
    xor [hl]                                      ; $2B0C
    ld [de], a                                    ; $2B0D
    inc hl                                        ; $2B0E
    dec b                                         ; $2B0F
    jr nz, jr_000_2b00                            ; $2B10

    ret                                           ; $2B12


; C: 6 x 3 bytes {offset, OR mask $FC, XOR mask}: 02 FC 30 / 04 FC 48 / 06 FC 40 / 08 FC 48 / 0A FC 30 / 0C FC 00 =
; the rows of the copy badge
Thumb_CopyBadgeTbl::
    db $02, $fc, $30, $04, $fc, $48, $06, $fc, $40, $08, $fc, $48, $0a, $fc, $30, $0c
    db $fc, $00

; C: calls 1F:7FF6 (sound init) from bank 0. L3 pass 2026-10-26: executed in BGB in 204 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Snd_Init_Tramp::
    ldh a, [hRomBankShadow]                       ; $2B25
    push af                                       ; $2B27
    ld a, $1f                                     ; $2B28
    ldh [hRomBankShadow], a                       ; $2B2A
    ld [rROMB0], a                                ; $2B2C
    call Snd_InitEntry                            ; $2B2F
    pop af                                        ; $2B32
    ldh [hRomBankShadow], a                       ; $2B33
    ld [rROMB0], a                                ; $2B35
    ret                                           ; $2B38


; C: calls the sound tick 1F:7FF0 from the timer-or-frame hook 00:0333
Snd_Tick_Tramp::
    ldh a, [hRomBankShadow]                       ; $2B39
    push af                                       ; $2B3B
    ld a, $1f                                     ; $2B3C
    ldh [hRomBankShadow], a                       ; $2B3E
    ld [rROMB0], a                                ; $2B40
    call Snd_TickEntry                            ; $2B43
    pop af                                        ; $2B46
    ldh [hRomBankShadow], a                       ; $2B47
    ld [rROMB0], a                                ; $2B49
    ret                                           ; $2B4C


; C: HL = list of {sound
Snd_PlayFromList::
    push bc                                       ; $2B4D
    sla a                                         ; $2B4E
    ld c, a                                       ; $2B50
    ld b, $00                                     ; $2B51
    add hl, bc                                    ; $2B53
    inc hl                                        ; $2B54
    ld a, [hl-]                                   ; $2B55
    cp $01                                        ; $2B56
    jr nz, jr_000_2b60                            ; $2B58

    ld a, [hl]                                    ; $2B5A
    ld [wSndSfx1], a                              ; $2B5B
    pop bc                                        ; $2B5E
    ret                                           ; $2B5F


jr_000_2b60:
    cp $02                                        ; $2B60
    jr nz, jr_000_2b6a                            ; $2B62

    ld a, [hl]                                    ; $2B64
    ld [wSndMusicReq], a                          ; $2B65
    pop bc                                        ; $2B68
    ret                                           ; $2B69


jr_000_2b6a:
    cp $03                                        ; $2B6A
    jr nz, jr_000_2b74                            ; $2B6C

    ld a, [hl]                                    ; $2B6E
    ld [wSndSfx3], a                              ; $2B6F
    pop bc                                        ; $2B72
    ret                                           ; $2B73


jr_000_2b74:
    cp $04                                        ; $2B74
    jr nz, jr_000_2b7c                            ; $2B76

    ld a, [hl]                                    ; $2B78
    ld [wSndSfx4], a                              ; $2B79

jr_000_2b7c:
    pop bc                                        ; $2B7C
    ret                                           ; $2B7D


; C: A -> $DD60 (channel 1 effect)
Snd_Sfx1::
    ld [wSndSfx1], a                              ; $2B7E
    ret                                           ; $2B81


; C: A -> $DD70 (channel 3 effect)
Snd_Sfx3::
    ld [wSndSfx3], a                              ; $2B82
    ret                                           ; $2B85


; C: A -> $DD78 (channel 4 effect)
Snd_Sfx4::
    ld [wSndSfx4], a                              ; $2B86
    ret                                           ; $2B89


; C: A -> $DD68 (song / jingle request)
Snd_Music::
    ld [wSndMusicReq], a                          ; $2B8A
    ret                                           ; $2B8D


; C: plays a blip for each held key (menus of bank 06)
Snd_KeyBlips::
    push af                                       ; $2B8E
    ldh a, [hKeysHeld]                            ; $2B8F
    bit PADB_A, a                                 ; $2B91
    jr z, jr_000_2b9c                             ; $2B93

    play_sfx1 SFX1_KEY_A                          ; $2B95

jr_000_2b9c:
    bit 1, a                                      ; $2B9C
    jr z, jr_000_2ba7                             ; $2B9E

    play_sfx1 SFX1_KEY_B                          ; $2BA0

jr_000_2ba7:
    bit 5, a                                      ; $2BA7
    jr z, jr_000_2bb2                             ; $2BA9

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $2BAB

jr_000_2bb2:
    bit 4, a                                      ; $2BB2
    jr z, jr_000_2bbd                             ; $2BB4

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $2BB6

jr_000_2bbd:
    bit 6, a                                      ; $2BBD
    jr z, jr_000_2bc8                             ; $2BBF

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $2BC1

jr_000_2bc8:
    bit 7, a                                      ; $2BC8
    jr z, jr_000_2bd3                             ; $2BCA

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $2BCC

jr_000_2bd3:
    bit 3, a                                      ; $2BD3
    jr z, jr_000_2bde                             ; $2BD5

    play_sfx1 SFX1_KEY_START                      ; $2BD7

jr_000_2bde:
    bit 2, a                                      ; $2BDE
    jr z, jr_000_2be9                             ; $2BE0

    play_sfx1 SFX1_KEY_SELECT                     ; $2BE2

jr_000_2be9:
    pop af                                        ; $2BE9
    ret                                           ; $2BEA


; C: serial interrupt handler of the camera link (stages: hello / info / command / data)
Link_SerialIrq::
    push af                                       ; $2BEB
    push bc                                       ; $2BEC
    push de                                       ; $2BED
    push hl                                       ; $2BEE
    ld a, [wLnkConnected]                         ; $2BEF
    and a                                         ; $2BF2
    jp nz, Link_Irq_Connected                     ; $2BF3

    ld a, [wLnkStage]                             ; $2BF6
    and a                                         ; $2BF9
    jr nz, Link_Irq_InfoStage                     ; $2BFA

    ldh a, [rSB]                                  ; $2BFC
    cp $12                                        ; $2BFE
    jr z, jr_000_2c27                             ; $2C00

    cp $55                                        ; $2C02
    jr z, jr_000_2c22                             ; $2C04

    cp $29                                        ; $2C06
    jr nz, jr_000_2c10                            ; $2C08

    ld a, [wLnkInitiator]                         ; $2C0A
    and a                                         ; $2C0D
    jr z, jr_000_2c2f                             ; $2C0E

jr_000_2c10:
    xor a                                         ; $2C10
    ld [wLnkTurn], a                              ; $2C11
    ld [wLnkInitiator], a                         ; $2C14
    ld a, $12                                     ; $2C17
    ldh [rSB], a                                  ; $2C19
    ld a, SCF_START                               ; $2C1B
    ldh [rSC], a                                  ; $2C1D
    jp Link_Irq_Exit                              ; $2C1F


jr_000_2c22:
    ld a, $01                                     ; $2C22
    ld [wLnkFlag55], a                            ; $2C24

jr_000_2c27:
    ld a, $01                                     ; $2C27
    ld [wLnkInitiator], a                         ; $2C29
    ld [wLnkTurn], a                              ; $2C2C

jr_000_2c2f:
    ld a, $01                                     ; $2C2F
    ld [wLnkStage], a                             ; $2C31
    ld a, [wLnkInfoTx]                            ; $2C34
    ldh [rSB], a                                  ; $2C37
    jp Link_Irq_StartTimer                        ; $2C39


; C: stage 0 byte after the hello: role decision from the info bytes
Link_Irq_InfoStage::
    ldh a, [rSB]                                  ; $2C3C
    ld [wLnkInfoRx], a                            ; $2C3E
    and $1f                                       ; $2C41
    ld [wLnkPeerCount], a                         ; $2C43
    ld a, $01                                     ; $2C46
    ld [wLnkRoleRx], a                            ; $2C48
    ld a, [wLnkInitiator]                         ; $2C4B
    and a                                         ; $2C4E
    jr nz, jr_000_2c5e                            ; $2C4F

    ld a, [wLnkInfoRx]                            ; $2C51
    and $80                                       ; $2C54
    jr z, jr_000_2c65                             ; $2C56

    xor a                                         ; $2C58
    ld [wLnkRoleRx], a                            ; $2C59
    jr jr_000_2c84                                ; $2C5C

jr_000_2c5e:
    ld a, [wLnkOwnCount]                          ; $2C5E
    and $80                                       ; $2C61
    jr z, jr_000_2c84                             ; $2C63

jr_000_2c65:
    ld a, [wLnkPeerCount]                         ; $2C65
    and $3f                                       ; $2C68
    jr z, jr_000_2c7c                             ; $2C6A

    ld a, [wLnkInfoTx]                            ; $2C6C
    and $40                                       ; $2C6F
    and a                                         ; $2C71
    jr z, jr_000_2ca6                             ; $2C72

    ld a, $01                                     ; $2C74
    ld [wLnkAbortReason], a                       ; $2C76
    jp Link_Irq_Abort                             ; $2C79


jr_000_2c7c:
    ld a, $03                                     ; $2C7C
    ld [wLnkAbortReason], a                       ; $2C7E
    jp Link_Irq_Abort                             ; $2C81


jr_000_2c84:
    xor a                                         ; $2C84
    ld [wLnkRoleRx], a                            ; $2C85
    ld a, [wLnkOwnCount]                          ; $2C88
    and $3f                                       ; $2C8B
    jr z, jr_000_2c9e                             ; $2C8D

    ld a, [wLnkInfoRx]                            ; $2C8F
    and $40                                       ; $2C92
    jr z, jr_000_2ca6                             ; $2C94

    ld a, $02                                     ; $2C96
    ld [wLnkAbortReason], a                       ; $2C98
    jp Link_Irq_Abort                             ; $2C9B


jr_000_2c9e:
    ld a, $04                                     ; $2C9E
    ld [wLnkAbortReason], a                       ; $2CA0
    jp Link_Irq_Abort                             ; $2CA3


jr_000_2ca6:
    ld a, $01                                     ; $2CA6
    ld [wLnkConnected], a                         ; $2CA8
    xor a                                         ; $2CAB
    ld [wLnkEnded], a                             ; $2CAC
    ldh [rSB], a                                  ; $2CAF
    ld a, $ff                                     ; $2CB1
    ld [wLnkIndex], a                             ; $2CB3
    ld [wLnkIndex + $1], a                        ; $2CB6
    ld a, SCF_START                               ; $2CB9
    ldh [rSC], a                                  ; $2CBB
    ld a, [wLnkTurn]                              ; $2CBD
    xor $01                                       ; $2CC0
    ld [wLnkTurn], a                              ; $2CC2
    jp Link_Irq_Exit                              ; $2CC5


; C: connected: bulk data / sync exchange. L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:08,
; link_exchange 0E:0B, link_exchange 0E:10, link_exchange 0E:12 (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_Irq_Connected::
    ld a, [wLnkStage]                             ; $2CC8
    and a                                         ; $2CCB
    jp z, Link_Irq_BulkData                       ; $2CCC

    inc a                                         ; $2CCF
    ld [wLnkStage], a                             ; $2CD0
    cp $03                                        ; $2CD3
    jr z, jr_000_2d23                             ; $2CD5

    cp $04                                        ; $2CD7
    jr z, jr_000_2cee                             ; $2CD9

    ld a, [wLnkCmdTx]                             ; $2CDB
    cp $ef                                        ; $2CDE
    jr nz, jr_000_2ce5                            ; $2CE0

    ld [wLnkCancelSent], a                        ; $2CE2

jr_000_2ce5:
    ldh [rSB], a                                  ; $2CE5
    xor a                                         ; $2CE7
    ld [wLnkHalfDone], a                          ; $2CE8
    jp Link_Irq_StartTimer                        ; $2CEB


jr_000_2cee:
    dec a                                         ; $2CEE
    ld [wLnkStage], a                             ; $2CEF
    ld a, [wLnkReadySent]                         ; $2CF2
    and a                                         ; $2CF5
    jr z, jr_000_2cfa                             ; $2CF6

    jr jr_000_2cff                                ; $2CF8

jr_000_2cfa:
    ldh a, [rSB]                                  ; $2CFA
    and a                                         ; $2CFC
    jr z, jr_000_2d12                             ; $2CFD

jr_000_2cff:
    cp $ef                                        ; $2CFF
    ld a, $00                                     ; $2D01
    ld [wLnkStage], a                             ; $2D03
    ld [wLnkReadySent], a                         ; $2D06
    ld [wLnkReadyTx], a                           ; $2D09
    jp z, Link_Irq_HalfDone                       ; $2D0C

    jp Link_Irq_StartTimer                        ; $2D0F


jr_000_2d12:
    ld a, [wLnkReadyTx]                           ; $2D12
    and a                                         ; $2D15
    jr z, jr_000_2d1b                             ; $2D16

    ld [wLnkReadySent], a                         ; $2D18

jr_000_2d1b:
    ld a, [wLnkReadyTx]                           ; $2D1B
    ldh [rSB], a                                  ; $2D1E
    jp Link_Irq_StartTimer                        ; $2D20


jr_000_2d23:
    ldh a, [rSB]                                  ; $2D23
    ld [wLnkCmdRx], a                             ; $2D25
    cp $ef                                        ; $2D28
    ld a, $00                                     ; $2D2A
    jp z, Link_Irq_Abort_ClearState               ; $2D2C

    ld a, [wLnkCancelSent]                        ; $2D2F
    and a                                         ; $2D32
    jr z, jr_000_2d3d                             ; $2D33

    ld [wLnkCmdRx], a                             ; $2D35
    ld a, $00                                     ; $2D38
    jp Link_Irq_Abort_ClearState                  ; $2D3A


jr_000_2d3d:
    xor a                                         ; $2D3D
    ldh [rSB], a                                  ; $2D3E
    ld a, [wLnkInitiator]                         ; $2D40
    and a                                         ; $2D43
    jr z, jr_000_2d6d                             ; $2D44

    ld a, [wLnkCmdTx]                             ; $2D46
    and $80                                       ; $2D49
    jr z, jr_000_2d5d                             ; $2D4B

    ld a, $08                                     ; $2D4D
    ld [wLnkPages], a                             ; $2D4F
    ld a, [wLnkCmdRx]                             ; $2D52
    and $3f                                       ; $2D55
    ld [wLnkSlot], a                              ; $2D57
    jp Link_Irq_StartTimer                        ; $2D5A


jr_000_2d5d:
    ld a, $10                                     ; $2D5D
    ld [wLnkPages], a                             ; $2D5F
    ld a, [wLnkCmdRx]                             ; $2D62
    and $3f                                       ; $2D65
    ld [wLnkSlot], a                              ; $2D67
    jp Link_Irq_StartTimer                        ; $2D6A


jr_000_2d6d:
    ld a, [wLnkCmdRx]                             ; $2D6D
    ld b, a                                       ; $2D70
    and $80                                       ; $2D71
    jr z, jr_000_2d7c                             ; $2D73

    ld a, $08                                     ; $2D75
    ld [wLnkPages], a                             ; $2D77
    jr jr_000_2d81                                ; $2D7A

jr_000_2d7c:
    ld a, $10                                     ; $2D7C
    ld [wLnkPages], a                             ; $2D7E

jr_000_2d81:
    ld a, b                                       ; $2D81
    and $3f                                       ; $2D82
    ld [wLnkSlot], a                              ; $2D84
    jp Link_Irq_StartTimer                        ; $2D87


; C: bulk transfer: stores each received byte at [DC48:DC49] + index
Link_Irq_BulkData::
    ld a, [wLnkRxBase]                            ; $2D8A
    ld h, a                                       ; $2D8D
    ld a, [wLnkRxBase + $1]                       ; $2D8E
    ld l, a                                       ; $2D91
    ld a, [wLnkIndex + $1]                        ; $2D92
    ld e, a                                       ; $2D95
    ld a, [wLnkIndex]                             ; $2D96
    ld d, a                                       ; $2D99
    cp $ff                                        ; $2D9A
    jr z, jr_000_2da2                             ; $2D9C

    add hl, de                                    ; $2D9E
    ldh a, [rSB]                                  ; $2D9F
    ld [hl], a                                    ; $2DA1

jr_000_2da2:
    inc de                                        ; $2DA2
    ld a, [wLnkTxBase]                            ; $2DA3
    ld h, a                                       ; $2DA6
    ld a, [wLnkTxBase + $1]                       ; $2DA7
    ld l, a                                       ; $2DAA
    add hl, de                                    ; $2DAB
    ld a, [hl]                                    ; $2DAC
    ldh [rSB], a                                  ; $2DAD
    ld a, d                                       ; $2DAF
    ld [wLnkIndex], a                             ; $2DB0
    ld a, e                                       ; $2DB3
    ld [wLnkIndex + $1], a                        ; $2DB4
    ld a, [wLnkIndex]                             ; $2DB7
    ld b, a                                       ; $2DBA
    ld a, [wLnkPages]                             ; $2DBB
    cp b                                          ; $2DBE
    jp nz, Link_Irq_StartTimer                    ; $2DBF

    ld a, [wLnkPages]                             ; $2DC2
    cp $10                                        ; $2DC5
    jr z, Link_Irq_Abort                          ; $2DC7

; C: end of one direction
Link_Irq_HalfDone::
    xor a                                         ; $2DC9
    ld [wLnkCmdArmed], a                          ; $2DCA
    ld [wLnkPages], a                             ; $2DCD
    ld [wLnkCmdTx], a                             ; $2DD0
    ld [wLnkCmdRx], a                             ; $2DD3
    dec a                                         ; $2DD6
    ld [wLnkIndex], a                             ; $2DD7
    ld [wLnkIndex + $1], a                        ; $2DDA
    ld a, $01                                     ; $2DDD
    ld [wLnkHalfDone], a                          ; $2DDF
    ld [wLnkStage], a                             ; $2DE2
    ld a, SCF_START                               ; $2DE5
    ldh [rSC], a                                  ; $2DE7
    ld a, [wLnkInitiator]                         ; $2DE9
    ld [wLnkTurn], a                              ; $2DEC
    jr Link_Irq_Exit                              ; $2DEF

; C: exchange refused or cancelled: reset
Link_Irq_Abort::
    xor a                                         ; $2DF1
    ld [wLnkCmdRx], a                             ; $2DF2

; C: A = 0 on both paths: clears the link state bytes DC43-DC5E and SB/SC, sets DC4C/DC4D = $FF, masks the serial and
; timer interrupts (IE and $F3), DC4E = 1, then Link_Irq_Exit (branch target; code read 2026-10-19)
Link_Irq_Abort_ClearState::
    ld [wLnkConnected], a                         ; $2DF5
    ld [wLnkTurn], a                              ; $2DF8
    ld [wLnkInitiator], a                         ; $2DFB
    ld [wLnkRxBase], a                            ; $2DFE
    ld [wLnkRxBase + $1], a                       ; $2E01
    ld [wLnkTxBase], a                            ; $2E04
    ld [wLnkTxBase + $1], a                       ; $2E07
    ld [wLnkCmdArmed], a                          ; $2E0A
    ld [wLnkCmdTx], a                             ; $2E0D
    ld [wLnkOwnCount], a                          ; $2E10
    ld [wLnkPeerCount], a                         ; $2E13
    ld [wLnkFlag55], a                            ; $2E16
    ld [wLnkCancelSent], a                        ; $2E19
    ld [wLnkStage], a                             ; $2E1C
    ldh [rSB], a                                  ; $2E1F
    ldh [rSC], a                                  ; $2E21
    dec a                                         ; $2E23
    ld [wLnkIndex], a                             ; $2E24
    ld [wLnkIndex + $1], a                        ; $2E27
    ldh a, [rIE]                                  ; $2E2A
    and $f3                                       ; $2E2C
    ldh [rIE], a                                  ; $2E2E
    ld a, $01                                     ; $2E30
    ld [wLnkEnded], a                             ; $2E32
    jr Link_Irq_Exit                              ; $2E35

; C: re-arms the timer for the next byte. L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:01,
; link_exchange 0E:08, link_exchange 0E:0B, link_exchange 0E:10 (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_Irq_StartTimer::
    ld a, SCF_START                               ; $2E37
    ldh [rSC], a                                  ; $2E39
    ld a, [wLnkTurn]                              ; $2E3B
    xor $01                                       ; $2E3E
    ld [wLnkTurn], a                              ; $2E40
    ld a, [wLnkTurn]                              ; $2E43
    and a                                         ; $2E46
    jr z, Link_Irq_Exit                           ; $2E47

    ld a, $06                                     ; $2E49
    ldh [rTAC], a                                 ; $2E4B

; C: pops and reti
Link_Irq_Exit::
    pop hl                                        ; $2E4D
    pop de                                        ; $2E4E
    pop bc                                        ; $2E4F
    pop af                                        ; $2E50
    reti                                          ; $2E51


; C: timer interrupt: restarts the serial transfer as master
Link_TimerIrq::
    push af                                       ; $2E52
    ld a, $02                                     ; $2E53
    ldh [rTAC], a                                 ; $2E55
    ld a, $ee                                     ; $2E57
    ldh [rTIMA], a                                ; $2E59
    ld a, SCF_START | SCF_SOURCE                  ; $2E5B
    ldh [rSC], a                                  ; $2E5D
    pop af                                        ; $2E5F
    reti                                          ; $2E60


; C: reset of the link variables and enable of the serial + timer interrupts
Link_Init::
    ld a, $10                                     ; $2E61
    ld [wLnkPages], a                             ; $2E63
    ld a, $12                                     ; $2E66
    ldh [rSB], a                                  ; $2E68
    ld a, SCF_START                               ; $2E6A
    ldh [rSC], a                                  ; $2E6C
    xor a                                         ; $2E6E
    ld [wLnkTurn], a                              ; $2E6F
    ld [wLnkConnected], a                         ; $2E72
    ld [wLnkInitiator], a                         ; $2E75
    ld [wLnkCmdArmed], a                          ; $2E78
    ld [wLnkIndex], a                             ; $2E7B
    ld [wLnkIndex + $1], a                        ; $2E7E
    ld [wLnkEnded], a                             ; $2E81
    ld [wLnkHalfDone], a                          ; $2E84
    ld [wLnkAbortReason], a                       ; $2E87
    ld [wLnkStage], a                             ; $2E8A
    ld [wLnkRoleRx], a                            ; $2E8D
    ld [wLnkAlbumFull], a                         ; $2E90
    ld [wLnkInfoTx], a                            ; $2E93
    ld [wLnkOwnCount], a                          ; $2E96
    ld [wLnkCmdTx], a                             ; $2E99
    ld [wLnkInfoRx], a                            ; $2E9C
    ld [wLnkPeerCount], a                         ; $2E9F
    ld [wLnkCmdRx], a                             ; $2EA2
    ld [wLnkSlot], a                              ; $2EA5
    ld [wLnkReadyTx], a                           ; $2EA8
    ld [wLnkReadySent], a                         ; $2EAB
    ld [wLnkFlag55], a                            ; $2EAE
    ld [wLnkCancelSent], a                        ; $2EB1
    ld a, $c0                                     ; $2EB4
    ld [wLnkRxBase], a                            ; $2EB6
    ld a, $00                                     ; $2EB9
    ld [wLnkRxBase + $1], a                       ; $2EBB
    ld hl, wLinkBuffer                            ; $2EBE
    ld a, h                                       ; $2EC1
    ld [wLnkTxBase], a                            ; $2EC2
    ld a, l                                       ; $2EC5
    ld [wLnkTxBase + $1], a                       ; $2EC6
    ld a, $ee                                     ; $2EC9
    ldh [rTMA], a                                 ; $2ECB
    ldh [rTIMA], a                                ; $2ECD
    ld a, $02                                     ; $2ECF
    ldh [rTAC], a                                 ; $2ED1
    ldh a, [rIE]                                  ; $2ED3
    or $0c                                        ; $2ED5
    ldh [rIE], a                                  ; $2ED7
    ret                                           ; $2ED9


; C: tear-down; disables the serial + timer interrupts when stage = 0
Link_Stop::
    xor a                                         ; $2EDA
    ldh [rSB], a                                  ; $2EDB
    ld a, [wLnkStage]                             ; $2EDD
    and a                                         ; $2EE0
    ret nz                                        ; $2EE1

    ldh [rSC], a                                  ; $2EE2
    ld [wLnkPages], a                             ; $2EE4
    ldh a, [rIE]                                  ; $2EE7
    and $f3                                       ; $2EE9
    ldh [rIE], a                                  ; $2EEB
    xor a                                         ; $2EED
    ret                                           ; $2EEE


; C: sends the hello byte $29 as initiator
Link_SendHello29::
    ld a, [wLnkStage]                             ; $2EEF
    and a                                         ; $2EF2
    ret nz                                        ; $2EF3

    ld a, [wLnkAlbumFull]                         ; $2EF4
    and a                                         ; $2EF7
    jr z, jr_000_2efc                             ; $2EF8

    ld a, $40                                     ; $2EFA

jr_000_2efc:
    ld c, a                                       ; $2EFC
    ld a, [wLnkOwnCount]                          ; $2EFD
    or c                                          ; $2F00
    ld [wLnkInfoTx], a                            ; $2F01
    ld a, $29                                     ; $2F04
    ldh [rSB], a                                  ; $2F06
    ld a, SCF_START | SCF_SOURCE                  ; $2F08
    ldh [rSC], a                                  ; $2F0A
    ld [wLnkInitiator], a                         ; $2F0C
    ret                                           ; $2F0F


; C: sends the command byte $40 + slot (or the $EF cancel)
Link_QueueCommand::
    ld a, [wLnkInitiator]                         ; $2F10
    and a                                         ; $2F13
    ret z                                         ; $2F14

    ld a, [wLnkCmdArmed]                          ; $2F15
    and a                                         ; $2F18
    ret nz                                        ; $2F19

    ld a, [wLnkTurn]                              ; $2F1A
    and a                                         ; $2F1D
    ret z                                         ; $2F1E

    ld hl, wLinkBuffer                            ; $2F1F
    ld a, h                                       ; $2F22
    ld [wLnkTxBase], a                            ; $2F23
    ld a, l                                       ; $2F26
    ld [wLnkTxBase + $1], a                       ; $2F27
    ld a, [wLnkCmdTx]                             ; $2F2A
    cp $ef                                        ; $2F2D
    jr z, jr_000_2f3b                             ; $2F2F

    ld a, [wLnkSlot]                              ; $2F31
    ld b, a                                       ; $2F34
    ld a, $40                                     ; $2F35
    or b                                          ; $2F37
    ld [wLnkCmdTx], a                             ; $2F38

jr_000_2f3b:
    ld a, SCF_START | SCF_SOURCE                  ; $2F3B
    ldh [rSC], a                                  ; $2F3D
    ld [wLnkCmdArmed], a                          ; $2F3F
    ret                                           ; $2F42


; C: sends the command byte $80 + slot
Link_QueuePageRequest::
    ld a, [wLnkInitiator]                         ; $2F43
    and a                                         ; $2F46
    ret z                                         ; $2F47

    ld a, [wLnkCmdArmed]                          ; $2F48
    and a                                         ; $2F4B
    ret nz                                        ; $2F4C

    ld hl, wLinkBuffer                            ; $2F4D
    ld a, h                                       ; $2F50
    ld [wLnkTxBase], a                            ; $2F51
    ld a, l                                       ; $2F54
    ld [wLnkTxBase + $1], a                       ; $2F55
    ld a, [wLnkSlot]                              ; $2F58
    ld b, a                                       ; $2F5B
    ld a, $80                                     ; $2F5C
    or b                                          ; $2F5E
    ld [wLnkCmdTx], a                             ; $2F5F
    ld a, SCF_START | SCF_SOURCE                  ; $2F62
    ldh [rSC], a                                  ; $2F64
    ld [wLnkCmdArmed], a                          ; $2F66
    ret                                           ; $2F69


; C: ORs own photo count / album-full bits into the info byte
Link_UpdateInfoByte::
    ld a, [wLnkInfoTx]                            ; $2F6A
    ld b, a                                       ; $2F6D
    ld a, [wLnkAlbumFull]                         ; $2F6E
    and a                                         ; $2F71
    jr z, jr_000_2f76                             ; $2F72

    ld a, $40                                     ; $2F74

jr_000_2f76:
    ld c, a                                       ; $2F76
    ld a, [wLnkOwnCount]                          ; $2F77
    or b                                          ; $2F7A
    or c                                          ; $2F7B
    ld [wLnkInfoTx], a                            ; $2F7C
    ld a, [wLnkConnected]                         ; $2F7F
    and a                                         ; $2F82
    ret                                           ; $2F83


; C: dec bc until zero. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision 2026-10-26,
; README 13.6).
Unused_Delay_BC::
    dec bc                                        ; $2F84
    ld a, b                                       ; $2F85
    or c                                          ; $2F86
    jr nz, Unused_Delay_BC                        ; $2F87

    ret                                           ; $2F89


; I: ASCII 'MAIN PASS',0 right after Delay_BC; no immediate load of its address in the trace
Unused_Str_MainPass::
    db "MAIN PASS", $00

; C: far-jumped from the reset code; runs the self-test
Main_Entry::
    ld a, $0b                                     ; $2F94
    ldh [hKeyRepeatDelay], a                      ; $2F96
    ld a, $04                                     ; $2F98
    ldh [hKeyRepeatPeriod], a                     ; $2F9A
    ldh [hFarcallAArg], a                         ; $2F9C
    farcall Cam_BootSelfTest_Entry                ; $2F9E
    ld a, MODE_TITLE_SCREENS                      ; $2FA6
    ld [wMode], a                                 ; $2FA8
    xor a                                         ; $2FAB
    ld [wState], a                                ; $2FAC
    ld [wPhotoIndex], a                           ; $2FAF
    ld hl, wMode1CursorA                          ; $2FB2
    ld b, $21                                     ; $2FB5

jr_000_2fb7:
    ld [hl+], a                                   ; $2FB7
    dec b                                         ; $2FB8
    jr nz, jr_000_2fb7                            ; $2FB9

    ld hl, wCategoryPosB                          ; $2FBB
    ld b, $17                                     ; $2FBE

jr_000_2fc0:
    ld [hl+], a                                   ; $2FC0
    dec b                                         ; $2FC1
    jr nz, jr_000_2fc0                            ; $2FC2

    ld hl, wCompose4Cursor                        ; $2FC4
    ld b, $08                                     ; $2FC7

jr_000_2fc9:
    ld [hl+], a                                   ; $2FC9
    dec b                                         ; $2FCA
    jr nz, jr_000_2fc9                            ; $2FCB

    ld [wShutterSound], a                         ; $2FCD
    ld [wPickMusic], a                            ; $2FD0
    ld [wPickCharacter], a                        ; $2FD3
    ld [wStartPerformerSet], a                    ; $2FD6
    ld [wPickCharacter21], a                      ; $2FD9
    ld [wPlayerMusic], a                          ; $2FDC
    ld [wPlayOptA], a                             ; $2FDF
    ld [wStartTuneSource], a                      ; $2FE2
    ld [wStartFactorySong], a                     ; $2FE5
    ld [wPenPattern], a                           ; $2FE8
    ld [wMenuItem], a                             ; $2FEB
    ld [wMenuUpCol], a                            ; $2FEE
    ld [wMenuSelUpper], a                         ; $2FF1
    ld a, $01                                     ; $2FF4
    ld [wPlayOptB], a                             ; $2FF6
    ld [wPenSpeed], a                             ; $2FF9
    ld [wPenSize], a                              ; $2FFC
    ld a, $ff                                     ; $2FFF
    ld [wBurstPhotos], a                          ; $3001
    ld [wBurstPhotos + $1], a                     ; $3004
    ld [wBurstPhotos + $2], a                     ; $3007
    ld [wBurstPhotos + $3], a                     ; $300A
    farcopy Mem_CopyFromBank, Src_04_5537_Main_Entry, wCategoryPosA, $0014 ; $300D
    ld a, $03                                     ; $301B
    ld [wPrintMarginLines], a                     ; $301D
    ld a, $01                                     ; $3020
    ld [wSoftResetEnable], a                      ; $3022
    ld a, [wPhotoCount]                           ; $3025
    and a                                         ; $3028
    jr nz, Main_Loop                              ; $3029

    xor a                                         ; $302B
    ld [wPhotoIndex], a                           ; $302C

; C: mode dispatcher + OAM hide + sticky keys + wait vblank
Main_Loop::
    call Mode_Dispatch                            ; $302F
    call Oam_HideUnused                           ; $3032
    call Joy_ClearSticky                          ; $3035
    rst Rst08_WaitVBlank                          ; $3038
    jr Main_Loop                                  ; $3039

; C: A = mode; 3-byte entries {lo
Mode_Dispatch::
    ld a, [wMode]                                 ; $303B
    call Call_InlineTable3                        ; $303E

; I: 34 entries of {lo
Mode_Table::
    dwb Mode00_MainMenu
    dwb Mode01_ShootParlor
    dwb Mode02_ViewMenu
    dwb Mode03_SpecialMenu
    dwb Mode04_DoodleMenu
    dwb Mode05_EditMenu
    dwb Mode06_LinkMenu
    dwb Mode07_ArcadeSpaceFever
    dwb Mode08_UserScreens
    dwb Mode09_AlbumEdit
    dwb Mode0A_AlbumView
    dwb Mode0B_ShowMenu
    dwb Mode0C_HotSpotViewer
    dwb Mode0D_SlideShow
    dwb Mode0E_LinkTransfer
    dwb Mode0F_DeletePhoto
    dwb Mode10_Paint
    dwb Mode11_Stamp
    dwb Mode12_AnimationEditor
    dwb Mode13_AnimationPlayer
    dwb Mode14_ShootLiveView
    dwb Mode15_SelfTimerInterval
    dwb Mode16_ShutterbugMagic
    dwb Mode17_SplitFusion
    dwb Mode18_PanoramaPrint
    dwb Mode19_TitleScreens
    dwb Mode1A_HotSpotEditor
    dwb Mode1B_PrintMenu
    dwb Mode1C_PrintPhotoPicker
    dwb Mode1D_PrintJob
    dwb Mode1E_PrintOption
    dwb Mode1F_DjEditor
    dwb Mode20_Ball
    dwb Mode21_RunRunRun

; C: 16 signed deltas added to scroll Y per frame for the popup slide (03:43EF). L3 pass 2026-10-26: read in BGB in 91
; replay(s) of the organic corpus, modes 09 0A 12 14 1C (tcrf_check/assets/l3_names/)
Slide_ScyDeltaTbl::
    db $ff, $fa, $f7, $fa, $ff, $03, $04, $03, $00, $ff, $fe, $ff, $00, $00, $01, $00

; C: auto: 48 bytes, bytes; referenced by Mode09_State03_PageLeft, Mode09_State04_PageRight, Mode09_State05_PageUp. L3
; pass 2026-10-26: read in BGB in 66 replay(s) of the organic corpus, modes 09 0A 14 (tcrf_check/assets/l3_names/)
Mode09_State03_PageLeft_Tbl30B7::
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
    ld a, [wState]                                ; $3117
    rst Rst18_JumpTable                           ; $311A

; I: 12 words for rst $18
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
    xor a                                         ; $3133
    ld [wPrintLastPage], a                        ; $3134
    ld [wPrintScriptOff], a                       ; $3137
    ld [wPrintScriptOff + $1], a                  ; $313A
    ld [wPrintPageNo], a                          ; $313D
    ld [wPrintAbortFlag], a                       ; $3140
    ld a, $01                                     ; $3143
    ld [wPrintFirstPage], a                       ; $3145
    ld hl, rIE                                    ; $3148
    set 3, [hl]                                   ; $314B
    ld a, $00                                     ; $314D
    ldh [hSerialHandlerIndex], a                  ; $314F
    ld a, $01                                     ; $3151
    ld [wPrnPollEnable], a                        ; $3153
    next_state                                    ; $3156
    ret                                           ; $315A


; I: loads the transfer screen graphics (banks $20 / $25)
Mode1D_State01_LoadScreen::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $315B
    ldh [hLcdcShadow], a                          ; $315D
    ld a, $e4                                     ; $315F
    ld [wPaletteTarget], a                        ; $3161
    ld [wPaletteTarget + $1], a                   ; $3164
    ld [wPaletteTarget + $2], a                   ; $3167
    xor a                                         ; $316A
    ldh [hScxShadow], a                           ; $316B
    ldh [hScyShadow], a                           ; $316D
    farcopy Mem_CopyFromBank, Gfx_27_4000_Mode1D_State01_LoadScreen, $9000, $0800 ; $316F
    farcopy Mem_CopyFromBank, Gfx_27_4800_Mode1D_State01_LoadScreen, $8800, $0400 ; $317D
    farcopy Mem_CopyFromBank, Map_25_61A0_Mode1D_State01_LoadScreen, $9800, $0240 ; $318B
    screen_on                                     ; $3199
    call Mode1D_DrawTvAnimation                   ; $31A2
    call Pal_FadeIn                               ; $31A5
    next_state                                    ; $31A8
    ret                                           ; $31AC


; C: sends INITIALIZE and checks the device id $81
Mode1D_State02_SendInit::
    call Mode1D_DrawTvAnimation                   ; $31AD
    call Prn_SendInit                             ; $31B0
    cp $f0                                        ; $31B3
    ret z                                         ; $31B5

    cp $ff                                        ; $31B6
    jp z, Mode1D_Abort                            ; $31B8

    ld a, [wPrnDevId]                             ; $31BB
    cp $81                                        ; $31BE
    jp nz, Mode1D_Abort                           ; $31C0

    play_music MUSIC_TRANSFER_SEND                ; $31C3
    xor a                                         ; $31CA
    ld [wPrintBandNo], a                          ; $31CB
    ld [wPrintLastBand], a                        ; $31CE
    ld [wPrintProgressAcc], a                     ; $31D1
    ld [wPrintProgressAcc + $1], a                ; $31D4
    call Mode1D_LoadProgressStep                  ; $31D7
    next_state                                    ; $31DA
    ret                                           ; $31DE


; C: reads the progress step of the page from the table at 30F9
Mode1D_LoadProgressStep::
    ld a, [wPrintLayoutType]                      ; $31DF
    ld c, a                                       ; $31E2
    ld b, $00                                     ; $31E3
    ld hl, Mode1D_ProgressTbl                     ; $31E5
    add hl, bc                                    ; $31E8
    ld c, [hl]                                    ; $31E9
    add hl, bc                                    ; $31EA
    ld a, [wPrintPageNo]                          ; $31EB
    sla a                                         ; $31EE
    ld c, a                                       ; $31F0
    add hl, bc                                    ; $31F1
    ld a, [hl+]                                   ; $31F2
    ld [wPrintProgressStep], a                    ; $31F3
    ld a, [hl]                                    ; $31F6
    ld [wPrintProgressStep + $1], a               ; $31F7
    ret                                           ; $31FA


; C: per layout offsets then per page progress words
Mode1D_ProgressTbl::
    db $05, $06, $0b, $12, $19, $5b, $00, $11, $01, $75, $00, $a3, $00, $75, $00, $75
    db $00, $75, $00, $75, $00, $66, $00, $66, $00, $66, $00, $66, $00, $5b, $00

; C: copies the band descriptors of the layout and renders the band
Mode1D_State03_BuildBand::
    call Mode1D_DrawTvAnimation                   ; $321A
    ld a, [wPrintLayoutType]                      ; $321D
    sla a                                         ; $3220
    ld c, a                                       ; $3222
    ld b, $00                                     ; $3223
    ld hl, Mode1D_LayoutScriptPtrs                ; $3225
    add hl, bc                                    ; $3228
    ld a, [hl+]                                   ; $3229
    ld h, [hl]                                    ; $322A
    ld l, a                                       ; $322B
    ld a, [wPrintScriptOff]                       ; $322C
    ld c, a                                       ; $322F
    ld a, [wPrintScriptOff + $1]                  ; $3230
    ld b, a                                       ; $3233
    push bc                                       ; $3234
    add hl, bc                                    ; $3235
    ld a, $08                                     ; $3236
    ld de, wPrintBandDesc                         ; $3238
    ld c, $14                                     ; $323B
    call Mode1D_CopyDescriptors                   ; $323D
    pop hl                                        ; $3240
    ld bc, $0050                                  ; $3241
    add hl, bc                                    ; $3244
    ld a, l                                       ; $3245
    ld [wPrintScriptOff], a                       ; $3246
    ld a, h                                       ; $3249
    ld [wPrintScriptOff + $1], a                  ; $324A
    call Mode1D_RenderBand                        ; $324D
    ld hl, wPrintBandNo                           ; $3250
    inc [hl]                                      ; $3253
    ld a, [hl]                                    ; $3254
    cp $09                                        ; $3255
    jr nz, jr_000_325e                            ; $3257

    ld a, $01                                     ; $3259
    ld [wPrintLastBand], a                        ; $325B

jr_000_325e:
    next_state                                    ; $325E
    ret                                           ; $3262


; C: renders one band of descriptors to $CF00
Mode1D_RenderBand::
    ld hl, wPrintBandDesc                         ; $3263
    ld de, wSlotTagOwnerCopy                      ; $3266
    ld b, $28                                     ; $3269

jr_000_326b:
    push bc                                       ; $326B
    push hl                                       ; $326C
    push de                                       ; $326D
    ld a, [hl+]                                   ; $326E
    bit 5, [hl]                                   ; $326F
    call z, Mode1D_SplitNibbles                   ; $3271
    call nz, Mode1D_ByteToDE                      ; $3274
    push de                                       ; $3277
    ld a, [hl]                                    ; $3278
    ld b, a                                       ; $3279
    ld hl, wPrintSrcTable                         ; $327A
    call Mode1D_ReadSrcEntry                      ; $327D
    pop hl                                        ; $3280
    add hl, de                                    ; $3281
    pop de                                        ; $3282
    bit 7, b                                      ; $3283
    jr z, jr_000_328e                             ; $3285

    push af                                       ; $3287
    ld a, $01                                     ; $3288
    ld [wPrintLastBand], a                        ; $328A
    pop af                                        ; $328D

jr_000_328e:
    bit 6, b                                      ; $328E
    jr z, jr_000_3299                             ; $3290

    ld c, $04                                     ; $3292
    call Mode1D_FillBlank                         ; $3294
    jr jr_000_32c0                                ; $3297

jr_000_3299:
    bit 5, b                                      ; $3299
    jr z, jr_000_32b0                             ; $329B

    push de                                       ; $329D
    call Mode1D_ReadByteFromBank                  ; $329E
    ld a, c                                       ; $32A1
    call Mode1D_SplitNibbles                      ; $32A2
    push de                                       ; $32A5
    ld a, b                                       ; $32A6
    ld hl, wPrintSrcTable2                        ; $32A7
    call Mode1D_ReadSrcEntry                      ; $32AA
    pop hl                                        ; $32AD
    add hl, de                                    ; $32AE
    pop de                                        ; $32AF

jr_000_32b0:
    bit 4, b                                      ; $32B0
    jr z, jr_000_32bb                             ; $32B2

    ld c, $04                                     ; $32B4
    call Mode1D_InterleaveTileRows                ; $32B6
    jr jr_000_32c0                                ; $32B9

jr_000_32bb:
    ld c, $04                                     ; $32BB
    call Mode1D_CopyDescriptors                   ; $32BD

jr_000_32c0:
    bit 3, b                                      ; $32C0
    jr z, jr_000_32c9                             ; $32C2

    ld a, $01                                     ; $32C4
    ld [wPrintLastPage], a                        ; $32C6

jr_000_32c9:
    pop hl                                        ; $32C9
    pop bc                                        ; $32CA
    inc hl                                        ; $32CB
    inc hl                                        ; $32CC
    dec b                                         ; $32CD
    jr nz, jr_000_326b                            ; $32CE

    ret                                           ; $32D0


; C: A -> D (high nibble) and E (low nibble << 4); BGB watchpoint pass 2026-10-25: ran only in mode 1D (1840 hits in 2
; runs: 1D:03 x1840; tcrf_check/assets/mode_state_wp/)
Mode1D_SplitNibbles::
    push af                                       ; $32D1
    swap a                                        ; $32D2
    push af                                       ; $32D4
    and $f0                                       ; $32D5
    ld e, a                                       ; $32D7
    pop af                                        ; $32D8
    and $0f                                       ; $32D9
    ld d, a                                       ; $32DB
    pop af                                        ; $32DC
    ret                                           ; $32DD


; C: A -> DE; BGB watchpoint pass 2026-10-25: ran only in mode 1D (272 hits in 1 runs: 1D:03 x272;
; tcrf_check/assets/mode_state_wp/)
Mode1D_ByteToDE::
    push af                                       ; $32DE
    ld e, a                                       ; $32DF
    ld d, $00                                     ; $32E0
    pop af                                        ; $32E2
    ret                                           ; $32E3


; C: A and 3 selects a 4-byte entry of a source table; returns DE; BGB watchpoint pass 2026-10-25: ran only in mode 1D
; (2112 hits in 2 runs: 1D:03 x2112; tcrf_check/assets/mode_state_wp/)
Mode1D_ReadSrcEntry::
    and $03                                       ; $32E4
    sla a                                         ; $32E6
    sla a                                         ; $32E8
    ld e, a                                       ; $32EA
    ld d, $00                                     ; $32EB
    add hl, de                                    ; $32ED
    ld e, [hl]                                    ; $32EE
    inc hl                                        ; $32EF
    ld d, [hl]                                    ; $32F0
    inc hl                                        ; $32F1
    ld a, [hl]                                    ; $32F2
    ret                                           ; $32F3


; C: reads [HL] of bank A into C; BGB watchpoint pass 2026-10-25: ran only in mode 1D (272 hits in 1 runs: 1D:03 x272;
; tcrf_check/assets/mode_state_wp/)
Mode1D_ReadByteFromBank::
    bit 7, h                                      ; $32F4
    jr nz, jr_000_3307                            ; $32F6

    ldh [hBankTmp], a                             ; $32F8
    ldh a, [hRomBankShadow]                       ; $32FA
    push af                                       ; $32FC
    ldh a, [hBankTmp]                             ; $32FD
    ldh [hRomBankShadow], a                       ; $32FF
    ld [rROMB0], a                                ; $3301
    scf                                           ; $3304
    jr jr_000_330b                                ; $3305

jr_000_3307:
    ld [rRAMB], a                                 ; $3307
    and a                                         ; $330A

jr_000_330b:
    push af                                       ; $330B
    ld c, [hl]                                    ; $330C
    pop af                                        ; $330D
    ret nc                                        ; $330E

    pop af                                        ; $330F
    ldh [hRomBankShadow], a                       ; $3310
    ld [rROMB0], a                                ; $3312
    ret                                           ; $3315


; C: copies C records of 4 bytes from bank A to DE
Mode1D_CopyDescriptors::
    cp $ff                                        ; $3316
    jp z, Mode1D_FillBlank                        ; $3318

    bit 7, h                                      ; $331B
    jr nz, jr_000_332e                            ; $331D

    ldh [hBankTmp], a                             ; $331F
    ldh a, [hRomBankShadow]                       ; $3321
    push af                                       ; $3323
    ldh a, [hBankTmp]                             ; $3324
    ldh [hRomBankShadow], a                       ; $3326
    ld [rROMB0], a                                ; $3328
    scf                                           ; $332B
    jr jr_000_3332                                ; $332C

jr_000_332e:
    ld [rRAMB], a                                 ; $332E
    and a                                         ; $3331

jr_000_3332:
    push af                                       ; $3332

jr_000_3333:
    ld a, [hl+]                                   ; $3333
    ld [de], a                                    ; $3334
    inc de                                        ; $3335
    ld a, [hl+]                                   ; $3336
    ld [de], a                                    ; $3337
    inc de                                        ; $3338
    ld a, [hl+]                                   ; $3339
    ld [de], a                                    ; $333A
    inc de                                        ; $333B
    ld a, [hl+]                                   ; $333C
    ld [de], a                                    ; $333D
    inc de                                        ; $333E
    dec c                                         ; $333F
    jr nz, jr_000_3333                            ; $3340

    pop af                                        ; $3342
    ret nc                                        ; $3343

    pop af                                        ; $3344
    ldh [hRomBankShadow], a                       ; $3345
    ld [rROMB0], a                                ; $3347
    ret                                           ; $334A


; C: interleaves bitplanes of a row of 8x8 tiles into the band buffer; called only at 00:31B4 for descriptors whose
; flag byte has bit 4, which only Print_Layout3_FourPhotosRotated (08:656E) has (252 descriptors): the 4-photo
; panorama print of the row pick (wOpt3ToggleB = 0); BGB 2026-10-25 ...
Mode1D_InterleaveTileRows::
    cp $ff                                        ; $334B
    jp z, Mode1D_FillBlank                        ; $334D

    bit 7, h                                      ; $3350
    jr nz, jr_000_3363                            ; $3352

    ldh [hBankTmp], a                             ; $3354
    ldh a, [hRomBankShadow]                       ; $3356
    push af                                       ; $3358
    ldh a, [hBankTmp]                             ; $3359
    ldh [hRomBankShadow], a                       ; $335B
    ld [rROMB0], a                                ; $335D
    scf                                           ; $3360
    jr jr_000_3367                                ; $3361

jr_000_3363:
    ld [rRAMB], a                                 ; $3363
    and a                                         ; $3366

jr_000_3367:
    push af                                       ; $3367
    srl c                                         ; $3368
    srl c                                         ; $336A

jr_000_336c:
    push bc                                       ; $336C
    ld c, $08                                     ; $336D

jr_000_336f:
    ld a, [hl+]                                   ; $336F
    ld b, [hl]                                    ; $3370
    push hl                                       ; $3371
    ld h, d                                       ; $3372
    ld l, e                                       ; $3373
    sla a                                         ; $3374
    rr [hl]                                       ; $3376
    inc hl                                        ; $3378
    sla b                                         ; $3379
    rr [hl]                                       ; $337B
    inc hl                                        ; $337D
    sla a                                         ; $337E
    rr [hl]                                       ; $3380
    inc hl                                        ; $3382
    sla b                                         ; $3383
    rr [hl]                                       ; $3385
    inc hl                                        ; $3387
    sla a                                         ; $3388
    rr [hl]                                       ; $338A
    inc hl                                        ; $338C
    sla b                                         ; $338D
    rr [hl]                                       ; $338F
    inc hl                                        ; $3391
    sla a                                         ; $3392
    rr [hl]                                       ; $3394
    inc hl                                        ; $3396
    sla b                                         ; $3397
    rr [hl]                                       ; $3399
    inc hl                                        ; $339B
    sla a                                         ; $339C
    rr [hl]                                       ; $339E
    inc hl                                        ; $33A0
    sla b                                         ; $33A1
    rr [hl]                                       ; $33A3
    inc hl                                        ; $33A5
    sla a                                         ; $33A6
    rr [hl]                                       ; $33A8
    inc hl                                        ; $33AA
    sla b                                         ; $33AB
    rr [hl]                                       ; $33AD
    inc hl                                        ; $33AF
    sla a                                         ; $33B0
    rr [hl]                                       ; $33B2
    inc hl                                        ; $33B4
    sla b                                         ; $33B5
    rr [hl]                                       ; $33B7
    inc hl                                        ; $33B9
    sla a                                         ; $33BA
    rr [hl]                                       ; $33BC
    inc hl                                        ; $33BE
    sla b                                         ; $33BF
    rr [hl]                                       ; $33C1
    inc hl                                        ; $33C3
    pop hl                                        ; $33C4
    inc hl                                        ; $33C5
    dec c                                         ; $33C6
    jr nz, jr_000_336f                            ; $33C7

    pop bc                                        ; $33C9
    ld a, e                                       ; $33CA
    add $10                                       ; $33CB
    ld e, a                                       ; $33CD
    jr nc, jr_000_33d1                            ; $33CE

    inc d                                         ; $33D0

jr_000_33d1:
    dec c                                         ; $33D1
    jr nz, jr_000_336c                            ; $33D2

    pop af                                        ; $33D4
    ret nc                                        ; $33D5

    pop af                                        ; $33D6
    ldh [hRomBankShadow], a                       ; $33D7
    ld [rROMB0], a                                ; $33D9
    ret                                           ; $33DC


; C: fills the band buffer with zero bytes; BGB watchpoint pass 2026-10-25: ran only in mode 1D (224 hits in 1 runs:
; 1D:03 x224; tcrf_check/assets/mode_state_wp/)
Mode1D_FillBlank::
    xor a                                         ; $33DD

jr_000_33de:
    ld [de], a                                    ; $33DE
    inc de                                        ; $33DF
    ld [de], a                                    ; $33E0
    inc de                                        ; $33E1
    ld [de], a                                    ; $33E2
    inc de                                        ; $33E3
    ld [de], a                                    ; $33E4
    inc de                                        ; $33E5
    dec c                                         ; $33E6
    jr nz, jr_000_33de                            ; $33E7

    ret                                           ; $33E9


; I: one word per layout type
Mode1D_LayoutScriptPtrs::
    dw Print_Layout0_Plain
    dw Print_Layout1_Framed
    dw Print_Layout2_FourPhotos
    dw Print_Layout3_FourPhotosRotated
    dw Print_Layout4_InfoPage

; C: sends the DATA packet of the band
Mode1D_State04_SendBand::
    call Mode1D_DrawTvAnimation                   ; $33F4
    ld a, [wPrintLastBand]                        ; $33F7
    ld [wPrnLastChunk], a                         ; $33FA
    ld hl, wSlotTagOwnerCopy                      ; $33FD
    ld a, $01                                     ; $3400
    call Prn_SendData                             ; $3402
    cp $ff                                        ; $3405
    jp z, Mode1D_Abort                            ; $3407

    cp $f0                                        ; $340A
    jr nz, jr_000_3419                            ; $340C

    ldh a, [hKeysNew]                             ; $340E
    bit PADB_B, a                                 ; $3410
    jp nz, Mode1D_UserCancel                      ; $3412

    call Mode1D_AdvanceProgress                   ; $3415
    ret                                           ; $3418


jr_000_3419:
    ld a, [wPrintLastBand]                        ; $3419
    and a                                         ; $341C
    jr z, jr_000_3436                             ; $341D

    ld hl, wPrintPageNo                           ; $341F
    inc [hl]                                      ; $3422
    ld a, [wPrintPages]                           ; $3423
    and a                                         ; $3426
    jr z, jr_000_3431                             ; $3427

    cp [hl]                                       ; $3429
    jr nz, jr_000_3431                            ; $342A

    ld a, $01                                     ; $342C
    ld [wPrintLastPage], a                        ; $342E

jr_000_3431:
    next_state                                    ; $3431
    ret                                           ; $3435


jr_000_3436:
    ld hl, wState                                 ; $3436
    dec [hl]                                      ; $3439
    ret                                           ; $343A


; C: sends the PRINT command with margin and palette
Mode1D_State05_SendPrint::
    call Mode1D_DrawTvAnimation                   ; $343B
    ld a, $01                                     ; $343E
    ld [wPrnSheets], a                            ; $3440
    ld de, $1003                                  ; $3443
    ld a, [wPrintCustomMargin]                    ; $3446
    and a                                         ; $3449
    jr z, jr_000_3458                             ; $344A

    ld a, [wPrintMarginByte]                      ; $344C
    and $f0                                       ; $344F
    ld d, a                                       ; $3451
    ld a, [wPrintMarginByte]                      ; $3452
    and $0f                                       ; $3455
    ld e, a                                       ; $3457

jr_000_3458:
    ld bc, $0000                                  ; $3458
    ld a, [wPrintFirstPage]                       ; $345B
    and a                                         ; $345E
    jr z, jr_000_3462                             ; $345F

    ld b, d                                       ; $3461

jr_000_3462:
    ld a, [wPrintLastPage]                        ; $3462
    and a                                         ; $3465
    jr z, jr_000_3469                             ; $3466

    ld c, e                                       ; $3468

jr_000_3469:
    ld a, b                                       ; $3469
    or c                                          ; $346A
    ld [wPrnMargin], a                            ; $346B
    ld a, $e4                                     ; $346E
    ld [wPrnPalette], a                           ; $3470
    call Prn_SendPrint                            ; $3473
    cp $ff                                        ; $3476
    jp z, Mode1D_Abort                            ; $3478

    cp $f0                                        ; $347B
    ret z                                         ; $347D

    play_music MUSIC_TRANSFER_PRINT               ; $347E
    next_state                                    ; $3485
    ret                                           ; $3489


; C: waits for the printer then loads the printing screen
Mode1D_State06_LoadWaitScreen::
    ld bc, $000c                                  ; $348A
    call Wait_Frames                              ; $348D
    call Pal_FadeOut                              ; $3490

jr_000_3493:
    rst Rst08_WaitVBlank                          ; $3493
    ld a, [wPrnStatus]                            ; $3494
    cp $ff                                        ; $3497
    jp z, Mode1D_Abort                            ; $3499

    and $f0                                       ; $349C
    jp nz, Mode1D_Abort                           ; $349E

    ld a, [wPrnPollCnt]                           ; $34A1
    cp $01                                        ; $34A4
    jr nz, jr_000_3493                            ; $34A6

    call Lcd_Off                                  ; $34A8
    farcopy Mem_CopyFromBank, Gfx_1B_7100_Mode1D_State06_LoadWaitScreen, $9000, $0800 ; $34AB
    farcopy Mem_CopyFromBank, Gfx_1B_7900_Mode1D_State06_LoadWaitScreen, $8800, $0650 ; $34B9
    farcopy Mem_CopyFromBank, Map_26_5A00_Mode1D_State06_LoadWaitScreen, $9800, $0240 ; $34C7
    call Lcd_On                                   ; $34D5
    ld a, $04                                     ; $34D8
    ld [wPrnPollCnt], a                           ; $34DA
    call Oam_ClearShadow                          ; $34DD
    call Mode1D_DrawBusyIcon                      ; $34E0
    call Pal_FadeIn                               ; $34E3
    next_state                                    ; $34E6
    ret                                           ; $34EA


; C: polls the status until the page is done
Mode1D_State07_WaitPrinted::
    call Mode1D_DrawBusyIcon                      ; $34EB
    ld a, [wPrnStatus]                            ; $34EE
    ld b, a                                       ; $34F1
    cp $ff                                        ; $34F2
    jr z, Mode1D_Abort                            ; $34F4

    and $f0                                       ; $34F6
    jr nz, Mode1D_Abort                           ; $34F8

    bit 1, b                                      ; $34FA
    ret nz                                        ; $34FC

    ld a, [wPrintLastPage]                        ; $34FD
    and a                                         ; $3500
    jr nz, jr_000_3513                            ; $3501

    screen_off                                    ; $3503
    xor a                                         ; $3509
    ld [wPrintFirstPage], a                       ; $350A
    set_state STATE_1D_LOAD_SCREEN                ; $350D
    ret                                           ; $3512


jr_000_3513:
    call Print_CountPrintedPhoto                  ; $3513
    call Prn_EngineStop                           ; $3516
    next_state                                    ; $3519
    ret                                           ; $351D


; C: maps the printer status to the error message
Mode1D_Abort::
    ld a, [wPrnStatus]                            ; $351E
    cp $ff                                        ; $3521
    jr z, jr_000_353d                             ; $3523

    bit 7, a                                      ; $3525
    jr z, jr_000_352d                             ; $3527

    ld a, $00                                     ; $3529
    jr jr_000_354a                                ; $352B

jr_000_352d:
    bit 6, a                                      ; $352D
    jr z, jr_000_3535                             ; $352F

    ld a, $03                                     ; $3531
    jr jr_000_354a                                ; $3533

jr_000_3535:
    bit 5, a                                      ; $3535
    jr z, jr_000_353d                             ; $3537

    ld a, $02                                     ; $3539
    jr jr_000_354a                                ; $353B

jr_000_353d:
    ld a, [wPrnDevId]                             ; $353D
    cp $81                                        ; $3540
    jr z, jr_000_3548                             ; $3542

    ld a, $01                                     ; $3544
    jr jr_000_354a                                ; $3546

jr_000_3548:
    ld a, $01                                     ; $3548

jr_000_354a:
    ld [wResultMsgId], a                          ; $354A
    ld a, $01                                     ; $354D
    ld [wPrintAbortFlag], a                       ; $354F
    call Prn_EngineStop                           ; $3552
    set_state STATE_1D_CLEANUP                    ; $3555
    ret                                           ; $355A


; C: B pressed
Mode1D_UserCancel::
    ld a, $01                                     ; $355B
    ld [wPrintAbortFlag], a                       ; $355D
    call Prn_EngineStop                           ; $3560
    set_state STATE_1D_EXIT                       ; $3563
    ret                                           ; $3568


; C: fade out and return to the calling mode through 00:3483
Mode1D_State08_Exit::
    screen_off                                    ; $3569
    ld hl, rIE                                    ; $356F
    res 3, [hl]                                   ; $3572
    xor a                                         ; $3574
    ld [wPrnPollEnable], a                        ; $3575

; C: sets mode / state from the table at 3483 using DB6E
Mode1D_ReturnToCaller::
    ld a, $01                                     ; $3578
    ld [wAbResult], a                             ; $357A
    ld a, [wPrintReturnIdx]                       ; $357D
    sla a                                         ; $3580
    ld c, a                                       ; $3582
    ld b, $00                                     ; $3583
    ld hl, Mode1D_ReturnTbl                       ; $3585
    add hl, bc                                    ; $3588
    ld a, [hl+]                                   ; $3589
    ld [wMode], a                                 ; $358A
    ld a, [hl]                                    ; $358D
    ld [wState], a                                ; $358E
    ret                                           ; $3591


; C: 5 x {mode
Mode1D_ReturnTbl::
    db MODE_PRINT_PHOTO_PICKER, STATE_1C_PRINT_JOB, MODE_PRINT_PHOTO_PICKER, STATE_1C_PRINT_JOB, MODE_PANORAMA_PRINT, STATE_18_INIT, MODE_PANORAMA_PRINT, STATE_18_INIT, MODE_PRINT_OPTION, STATE_1E_PRINT_JOB

; C: printer error clean-up
Mode1D_State09_Cleanup::
    screen_off                                    ; $359C
    ld hl, rIE                                    ; $35A2
    res 3, [hl]                                   ; $35A5
    xor a                                         ; $35A7
    ld [wPrnPollEnable], a                        ; $35A8
    xor a                                         ; $35AB
    ld [wSubstate], a                             ; $35AC
    next_state                                    ; $35AF
    ret                                           ; $35B3


; C: far call 09:7290 (shared result / error screen)
Mode1D_State0A_ErrorScreen::
    ldh [hFarcallAArg], a                         ; $35B4
    farcall ResultScreen_Far                      ; $35B6
    ret                                           ; $35BE


; C: jp 3469
Mode1D_State0B_Return::
    jp Mode1D_ReturnToCaller                      ; $35BF


; C: blinking sprite while printing; BGB watchpoint pass 2026-10-25: ran only in mode 1D (246 hits in 2 runs: 1D:06 x3
; 1D:07 x243; tcrf_check/assets/mode_state_wp/)
Mode1D_DrawBusyIcon::
    ldh a, [hFrameCounter]                        ; $35C2
    srl a                                         ; $35C4
    srl a                                         ; $35C6
    srl a                                         ; $35C8
    and $01                                       ; $35CA
    add $aa                                       ; $35CC
    ld bc, $2664                                  ; $35CE
    call Oam_AddMeta_B02_52BD                     ; $35D1
    ret                                           ; $35D4


; C: 15 sprite pieces of the TV animation; BGB watchpoint pass 2026-10-25: ran only in mode 1D (2284 hits in 11 runs:
; 1D:01 x30 1D:02 x60 1D:03 x46 1D:04 x2136 1D:05 x12; tcrf_check/assets/mode_state_wp/)
Mode1D_DrawTvAnimation::
    ld hl, Mode1D_TvAnimTbl                       ; $35D5
    ldh a, [hFrameCounter]                        ; $35D8
    sub $04                                       ; $35DA
    swap a                                        ; $35DC
    and $01                                       ; $35DE
    add $f7                                       ; $35E0
    ld e, a                                       ; $35E2
    ldh a, [hFrameCounter]                        ; $35E3
    swap a                                        ; $35E5
    and $01                                       ; $35E7
    add $f7                                       ; $35E9
    ld d, $0f                                     ; $35EB

jr_000_35ed:
    push af                                       ; $35ED
    ld c, [hl]                                    ; $35EE
    inc hl                                        ; $35EF
    ld b, [hl]                                    ; $35F0
    inc hl                                        ; $35F1
    ldh [hScratchA], a                            ; $35F2
    ld a, d                                       ; $35F4
    cp $07                                        ; $35F5
    jr nz, jr_000_35fc                            ; $35F7

    ld a, e                                       ; $35F9
    jr jr_000_35fe                                ; $35FA

jr_000_35fc:
    ldh a, [hScratchA]                            ; $35FC

jr_000_35fe:
    call Oam_AddMeta_B01_4000                     ; $35FE
    pop af                                        ; $3601
    dec d                                         ; $3602
    jr nz, jr_000_35ed                            ; $3603

    ret                                           ; $3605


; C: 15 x {x; BGB watchpoint pass 2026-10-25: ran only in mode 1D (33360 hits in 4 runs: 1D:01 x150 1D:02 x300 1D:03
; x690 1D:04 x32040 1D:05 x180; tcrf_check/assets/mode_state_wp/)
Mode1D_TvAnimTbl::
    db $22, $25, $22, $35, $22, $45, $22, $55, $22, $65, $32, $25, $32, $35, $32, $45
    db $32, $55, $32, $65, $42, $25, $42, $35, $42, $45, $42, $55, $42, $65

; C: adds the page progress step and queues the progress-bar tile row (VRAM queue)
Mode1D_AdvanceProgress::
    ld a, [wPrnHdrDone]                           ; $3624
    and a                                         ; $3627
    ret z                                         ; $3628

    ld a, [wPrnDataDone]                          ; $3629
    and a                                         ; $362C
    ret nz                                        ; $362D

    ld hl, wPrintProgressAcc                      ; $362E
    ld de, wPrintProgressStep                     ; $3631
    ld a, [de]                                    ; $3634
    add [hl]                                      ; $3635
    ld [hl+], a                                   ; $3636
    inc de                                        ; $3637
    ld a, [de]                                    ; $3638
    adc [hl]                                      ; $3639
    ld [hl], a                                    ; $363A
    srl a                                         ; $363B
    srl a                                         ; $363D
    srl a                                         ; $363F
    cp $0f                                        ; $3641
    jr c, jr_000_3647                             ; $3643

    ld a, $0f                                     ; $3645

jr_000_3647:
    ld c, a                                       ; $3647
    sla a                                         ; $3648
    sla a                                         ; $364A
    add c                                         ; $364C
    ld c, a                                       ; $364D
    ld b, $00                                     ; $364E
    ld hl, Print_ProgressPackets                  ; $3650
    add hl, bc                                    ; $3653
    ld b, h                                       ; $3654
    ld c, l                                       ; $3655
    ld a, BANK(Print_ProgressPackets)             ; $3656
    call Vq_Push                                  ; $3658
    ret                                           ; $365B


; C: far calls 02:503F then adds 1 to the printed-photos counter (BCD saturating) and far calls 02:4BB2
Print_CountPrintedPhoto::
    ldh [hFarcallAArg], a                         ; $365C
    farcall Counters_Load_Far                     ; $365E
    ld a, $01                                     ; $3666
    ld hl, wCntPrinted                            ; $3668
    ld b, $02                                     ; $366B
    call Bcd_AddSaturate                          ; $366D
    ldh [hFarcallAArg], a                         ; $3670
    farcall Counters_Store_Far                    ; $3672
    ret                                           ; $367A


; I: 388 zero bytes (padding)
Bank00_ZeroFill::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00

; C: 16 entries: (popcount of bits 3-2) << 4 | popcount of bits 1-0 of the nibble; the old 1 + 15 byte split was a
; typing artefact
Img_NibbleMapTbl::
    db $00, $01, $01, $02, $10, $11, $11, $12, $10, $11, $11, $12, $20, $21, $21, $22

; C: 256 entries; index = pixel pair byte | the false labels at 3780 (ld bc,$3780 of AlbumPage_DrawDown = a sprite
; position) were removed: this table is the whole 3700-37FF
Img_PairLookupTbl::
    ASSERT LOW(Img_PairLookupTbl) == 0 ; read as a page: HIGH(Img_PairLookupTbl) with the index in the low byte
    INCBIN "data/bank_00/Img_PairLookupTbl.bin" ; $3700, 256 bytes
; C: 8 pages of 256 bytes: page k = source byte shifted for an x offset of k pixels (page 0 = identity) | 2,048 bytes
; = 8 pages of 256 (3800-3FFF); the labels that used to cut it at 3818, 3878, 3910, 3D81, 3E54 and 3F78 were sprite
; positions (`ld bc,$3818` etc. before Oam_AddMeta calls of ...
Blit_ShiftTbl::
    ASSERT LOW(Blit_ShiftTbl) == 0 ; read as a page: HIGH(Blit_ShiftTbl) with the index in the low byte
    INCBIN "data/bank_00/Blit_ShiftTbl.bin" ; $3800, 2048 bytes

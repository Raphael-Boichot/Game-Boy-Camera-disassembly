; Pocket Camera Hello Kitty (Japan), bank $00. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $000", ROM0[$0]

; C: read in the runs by Snd_Trk_LoadFirstPattern; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_00_0000_Mode00_BootAndTitle_State00::
    db $f3, $c3, $00, $01, $00, $00, $00, $00

; C: rst $08: with the screen on, halts until the VBlank flag hFF9C is set (same code as the Japanese
; Rst08_WaitVBlank)
Rst08_WaitVBlank::
    ldh a, [rLCDC]                                ; $0008
    bit 7, a                                      ; $000A
    ret z                                         ; $000C

    ld hl, hVBlankDone                            ; $000D

; C: rst $10: clears [HL] and halts until it is set again
Rst10_WaitFlagSet::
    xor a                                         ; $0010
    ld [hl], a                                    ; $0011

jr_000_0012:
    halt                                          ; $0012
    ld a, [hl]                                    ; $0013
    and a                                         ; $0014
    jr z, jr_000_0012                             ; $0015

    ret                                           ; $0017


; C: rst $18: jumps to word A of the inline table after the call
Rst18_JumpTable::
    add a                                         ; $0018
    pop hl                                        ; $0019
    ld e, a                                       ; $001A
    ld d, $00                                     ; $001B
    add hl, de                                    ; $001D
    ld e, [hl]                                    ; $001E
    inc hl                                        ; $001F

RST_20::
    ld d, [hl]                                    ; $0020
    ld l, e                                       ; $0021
    ld h, d                                       ; $0022
    jp hl                                         ; $0023


; C: read in the runs by Album_CursorUpdate; first read on the screen Mode03_ViewAlbum_State02
; (trace/read_screens_kitty.npz)
Album_CursorUpdate_Tbl0024::
    db $00, $00, $00, $00

RST_28::
    nop                                           ; $0028
    nop                                           ; $0029

    ; padding
    ds $6, $00

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

; C: interrupt vector: jp 00:1AE0
Vec_VBlank::
    jp Jump_000_1ae0                              ; $0040


    db $00, $00, $00, $00, $00

; C: interrupt vector: jp 00:18D3
Vec_Stat::
    jp Jump_000_18d3                              ; $0048


    db $00, $00, $00, $00, $00

; C: interrupt vector: jp Link_TimerIrq
Vec_Timer::
    jp Link_TimerIrq                              ; $0050


    db $00, $00, $00, $00, $00

; C: interrupt vector: jp 00:1BDA
Vec_Serial::
    jp Jump_000_1bda                              ; $0058


    db $00, $00, $00, $00, $00

; C: interrupt vector: jp 00:1BF4
Vec_Joypad::
    jp Jump_000_1bf4                              ; $0060


    ; padding
    ds $9d, $00

; C: cartridge entry point: nop; jp $176A
Entry::
    nop                                           ; $0100
    jp Boot                                       ; $0101


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
    db "POCKETCAMERA_SN", $00

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
    db $00

HeaderComplementCheck::
    db $dc

HeaderGlobalChecksum::
    db $00, $29

; C: jp hl: a call to $0150 calls the routine at HL
Call_HL::
    jp hl                                         ; $0150


; C: push bc; ret: calls the routine at BC
Call_BC::
    push bc                                       ; $0151
    ret                                           ; $0152


; C: push de; ret: calls the routine at DE
Call_DE::
    push de                                       ; $0153
    ret                                           ; $0154


; C: one-way far jump: A = bank (hFF8B and $2100); jp hl
Far_Jump::
    ldh [hRomBankShadow], a                       ; $0155
    ld [$2100], a                                 ; $0157
    jp hl                                         ; $015A


; C: far call: B = bank; pushes the caller's bank; the callee returns through jp $0173
Far_Call::
    ldh a, [hRomBankShadow]                       ; $015B
    push af                                       ; $015D
    ld a, b                                       ; $015E
    ldh [hRomBankShadow], a                       ; $015F
    ld [$2100], a                                 ; $0161
    jp hl                                         ; $0164


; C: far call keeping A through hFF8A: B = bank; HL = target
Far_CallKeepA::
    ldh [hBankTmp], a                             ; $0165
    ldh a, [hRomBankShadow]                       ; $0167
    push af                                       ; $0169
    ld a, b                                       ; $016A
    ldh [hRomBankShadow], a                       ; $016B
    ld [$2100], a                                 ; $016D
    ldh a, [hBankTmp]                             ; $0170
    jp hl                                         ; $0172


; C: pops the caller's bank; switches back; ret
Far_Return::
    pop af                                        ; $0173
    ldh [hRomBankShadow], a                       ; $0174
    ld [$2100], a                                 ; $0176
    ret                                           ; $0179


; C: return restoring a bank read from the stack (SRAM routines)
Far_ReturnSramBank::
    push af                                       ; $017A
    push hl                                       ; $017B
    ld hl, sp+$05                                 ; $017C
    ld a, [hl]                                    ; $017E
    ldh [hRomBankShadow], a                       ; $017F
    ld [$2100], a                                 ; $0181
    pop hl                                        ; $0184
    pop af                                        ; $0185
    inc sp                                        ; $0186
    inc sp                                        ; $0187
    ret                                           ; $0188


; C: jump to word A of the table at HL
JumpTable_ByA::
    ld e, a                                       ; $0189
    ld d, $00                                     ; $018A
    add hl, de                                    ; $018C
    add hl, de                                    ; $018D
    ld a, [hl+]                                   ; $018E
    ld e, a                                       ; $018F
    ld a, [hl+]                                   ; $0190
    ld l, e                                       ; $0191
    ld h, a                                       ; $0192
    jp hl                                         ; $0193


; C: jump to word A of the table that follows the call
JumpTable_Inline::
    pop hl                                        ; $0194
    ld e, a                                       ; $0195
    ld d, $00                                     ; $0196
    add hl, de                                    ; $0198
    add hl, de                                    ; $0199
    ld a, [hl+]                                   ; $019A
    ld e, a                                       ; $019B
    ld a, [hl+]                                   ; $019C
    ld l, e                                       ; $019D
    ld h, a                                       ; $019E
    jp hl                                         ; $019F


; C: far call of record A of the {lo; hi; bank} table at HL through $015B
FarJumpTable_ByA::
    ld e, a                                       ; $01A0
    ld d, $00                                     ; $01A1
    add hl, de                                    ; $01A3
    add hl, de                                    ; $01A4
    add hl, de                                    ; $01A5
    ld a, [hl+]                                   ; $01A6
    ld e, a                                       ; $01A7
    ld a, [hl+]                                   ; $01A8
    ld d, a                                       ; $01A9
    ld a, [hl+]                                   ; $01AA
    ld b, a                                       ; $01AB
    ld l, e                                       ; $01AC
    ld h, d                                       ; $01AD
    call Far_Call                                 ; $01AE
    ret                                           ; $01B1


; C: mode = A (hFF8D)
Mode_Set::
    push af                                       ; $01B2
    ldh a, [hMode]                                ; $01B3
    ldh [hMode_Set_FF8F], a                       ; $01B5
    pop af                                        ; $01B7
    ldh [hMode], a                                ; $01B8
    ldh [hMenuMode], a                            ; $01BA
    ret                                           ; $01BC


; C: state = A (hFF8E)
State_Set::
    push af                                       ; $01BD
    ldh a, [hState]                               ; $01BE
    ldh [hMode06_State03_FF90], a                 ; $01C0
    pop af                                        ; $01C2
    ldh [hState], a                               ; $01C3
    ldh [hMenuState], a                           ; $01C5
    ret                                           ; $01C7


; C: mode = B; state = C
ModeState_Set::
    ld a, b                                       ; $01C8
    call Mode_Set                                 ; $01C9
    ld a, c                                       ; $01CC
    call State_Set                                ; $01CD
    ret                                           ; $01D0


; C: mode and state from the two bytes after the call
ModeState_SetInline::
    pop hl                                        ; $01D1
    ld a, [hl+]                                   ; $01D2
    call Mode_Set                                 ; $01D3
    ld a, [hl+]                                   ; $01D6
    call State_Set                                ; $01D7
    jp hl                                         ; $01DA


    db $e1, $2a, $e0, $8d, $2a, $e0, $8e, $2a, $e0, $8f, $2a, $e0, $90, $e9, $f0, $8f
    db $e0, $8d, $f0, $90, $e0, $8e, $c9

; C: inline {address, length}: that many bytes set to 0
Mem_ZeroInline::
    pop hl                                        ; $01F2
    ld a, [hl+]                                   ; $01F3
    ld e, a                                       ; $01F4
    ld a, [hl+]                                   ; $01F5
    ld d, a                                       ; $01F6
    ld a, [hl+]                                   ; $01F7
    ld c, a                                       ; $01F8
    ld a, [hl+]                                   ; $01F9
    ld b, a                                       ; $01FA
    push hl                                       ; $01FB
    ld l, e                                       ; $01FC
    ld h, d                                       ; $01FD

Call_000_01fe:
jr_000_01fe:
    xor a                                         ; $01FE
    ld [hl+], a                                   ; $01FF
    dec bc                                        ; $0200
    ld a, c                                       ; $0201
    or b                                          ; $0202
    jr nz, jr_000_01fe                            ; $0203

    ret                                           ; $0205


; C: copy with inline {source; destination; count} after the call
Copy_Inline::
    pop hl                                        ; $0206
    ld a, [hl+]                                   ; $0207
    ld e, a                                       ; $0208
    ld a, [hl+]                                   ; $0209
    ld d, a                                       ; $020A
    ld a, [hl+]                                   ; $020B
    ldh [hCopy_Inline_FF9E], a                    ; $020C
    ld a, [hl+]                                   ; $020E
    ldh [hCopy_Inline_FF9F], a                    ; $020F
    ld a, [hl+]                                   ; $0211
    ld c, a                                       ; $0212
    ld a, [hl+]                                   ; $0213
    ld b, a                                       ; $0214
    push hl                                       ; $0215
    ldh a, [hCopy_Inline_FF9E]                    ; $0216
    ld l, a                                       ; $0218
    ldh a, [hCopy_Inline_FF9F]                    ; $0219
    ld h, a                                       ; $021B

; C: copy BC bytes from DE to HL
Copy_DEtoHL::
    ld a, [de]                                    ; $021C
    ld [hl+], a                                   ; $021D
    inc de                                        ; $021E
    dec bc                                        ; $021F
    ld a, c                                       ; $0220
    or b                                          ; $0221
    jr nz, Copy_DEtoHL                            ; $0222

    ret                                           ; $0224


    db $1a, $22, $13, $0b, $1a, $22, $13, $0b, $79, $b0, $20, $f4, $c9

; C: BC bytes of E at HL
Mem_FillByte::
    ld a, e                                       ; $0232
    ld [hl+], a                                   ; $0233
    dec bc                                        ; $0234
    ld a, c                                       ; $0235
    or b                                          ; $0236
    jr nz, Mem_FillByte                           ; $0237

    ret                                           ; $0239


; C: BC bytes of the pattern E, D at HL (used by Sram_Format with DE = 0)
Mem_FillWord::
    ld a, e                                       ; $023A
    ld [hl+], a                                   ; $023B
    dec bc                                        ; $023C
    ld a, d                                       ; $023D
    ld [hl+], a                                   ; $023E
    dec bc                                        ; $023F
    ld a, c                                       ; $0240
    or b                                          ; $0241
    jr nz, Mem_FillWord                           ; $0242

    ret                                           ; $0244


; C: copy with inline {source; bank; destination; count} after the call
Copy_FarInline::
    pop hl                                        ; $0245
    ld a, [hl+]                                   ; $0246
    ld e, a                                       ; $0247
    ld a, [hl+]                                   ; $0248
    ld d, a                                       ; $0249
    ld a, [hl+]                                   ; $024A
    ldh [hCopy_FarInline_FFA0], a                 ; $024B
    ld a, [hl+]                                   ; $024D
    ldh [hCopy_Inline_FF9E], a                    ; $024E
    ld a, [hl+]                                   ; $0250
    ldh [hCopy_Inline_FF9F], a                    ; $0251
    ld a, [hl+]                                   ; $0253
    ld c, a                                       ; $0254
    ld a, [hl+]                                   ; $0255
    ld b, a                                       ; $0256
    push hl                                       ; $0257
    ldh a, [hCopy_Inline_FF9E]                    ; $0258
    ld l, a                                       ; $025A
    ldh a, [hCopy_Inline_FF9F]                    ; $025B
    ld h, a                                       ; $025D
    ldh a, [hCopy_FarInline_FFA0]                 ; $025E

; C: copy BC bytes from DE in bank A to HL
Copy_FarDEtoHL::
    ldh [hBankTmp], a                             ; $0260
    ldh a, [hRomBankShadow]                       ; $0262
    push af                                       ; $0264
    ldh a, [hBankTmp]                             ; $0265
    ldh [hRomBankShadow], a                       ; $0267
    ld [$2100], a                                 ; $0269
    call Copy_DEtoHL                              ; $026C
    pop af                                        ; $026F
    ldh [hRomBankShadow], a                       ; $0270
    ld [$2100], a                                 ; $0272
    ret                                           ; $0275


; C: bank A: BC bytes from DE to HL, each complemented (xor $FF)
Copy_FarInverted::
    ldh [hBankTmp], a                             ; $0276
    ldh a, [hRomBankShadow]                       ; $0278
    push af                                       ; $027A
    ldh a, [hBankTmp]                             ; $027B
    ldh [hRomBankShadow], a                       ; $027D
    ld [$2100], a                                 ; $027F

jr_000_0282:
    ld a, [de]                                    ; $0282
    xor $ff                                       ; $0283
    ld [hl+], a                                   ; $0285
    inc de                                        ; $0286
    dec bc                                        ; $0287
    ld a, c                                       ; $0288
    or b                                          ; $0289
    jr nz, jr_000_0282                            ; $028A

    pop af                                        ; $028C
    ldh [hRomBankShadow], a                       ; $028D
    ld [$2100], a                                 ; $028F
    ret                                           ; $0292


; C: unrolled copy of $20 x 8 = $100 bytes from DE to HL; code read
Copy_Unrolled::
    ld c, $20                                     ; $0293

jr_000_0295:
    ld a, [de]                                    ; $0295
    ld [hl+], a                                   ; $0296
    inc de                                        ; $0297
    ld a, [de]                                    ; $0298
    ld [hl+], a                                   ; $0299
    inc de                                        ; $029A
    ld a, [de]                                    ; $029B
    ld [hl+], a                                   ; $029C
    inc de                                        ; $029D
    ld a, [de]                                    ; $029E
    ld [hl+], a                                   ; $029F
    inc de                                        ; $02A0
    ld a, [de]                                    ; $02A1
    ld [hl+], a                                   ; $02A2
    inc de                                        ; $02A3
    ld a, [de]                                    ; $02A4
    ld [hl+], a                                   ; $02A5
    inc de                                        ; $02A6
    ld a, [de]                                    ; $02A7
    ld [hl+], a                                   ; $02A8
    inc de                                        ; $02A9
    ld a, [de]                                    ; $02AA
    ld [hl+], a                                   ; $02AB
    inc de                                        ; $02AC
    dec c                                         ; $02AD
    jr nz, jr_000_0295                            ; $02AE

    ret                                           ; $02B0


; C: Copy_Unrolled from bank A; code read
Copy_FarUnrolled::
    ldh [hBankTmp], a                             ; $02B1
    ldh a, [hRomBankShadow]                       ; $02B3
    push af                                       ; $02B5
    ldh a, [hBankTmp]                             ; $02B6
    ldh [hRomBankShadow], a                       ; $02B8
    ld [$2100], a                                 ; $02BA
    call Copy_Unrolled                            ; $02BD
    pop af                                        ; $02C0
    ldh [hRomBankShadow], a                       ; $02C1
    ld [$2100], a                                 ; $02C3
    ret                                           ; $02C6


    db $6f, $26, $40, $f0, $8b, $f5, $3e, $01, $e0, $8b, $ea, $00, $21, $7e, $4f, $24
    db $7e, $47, $f1, $e0, $8b, $ea, $00, $21, $c9, $6f, $26, $42, $f0, $8b, $f5, $3e
    db $01, $e0, $8b, $ea, $00, $21, $7e, $4f, $24, $7e, $47, $f1, $e0, $8b, $ea, $00
    db $21, $c9

; C: 11 inline bytes: LCDC; BGP; OBP0; OBP1; SCY; SCX; WY; WX; -; STAT; IE
Lcd_SetupInline::
    pop hl                                        ; $02F9
    ld a, [hl+]                                   ; $02FA
    ld [wLcdcShadow], a                           ; $02FB
    ld a, [hl+]                                   ; $02FE
    ld [wPaletteTarget], a                        ; $02FF
    ld a, [hl+]                                   ; $0302
    ld [wPaletteTarget + $1], a                   ; $0303
    ld a, [hl+]                                   ; $0306
    ld [wPaletteTarget + $2], a                   ; $0307
    ld a, [hl+]                                   ; $030A
    ld [wScxShadow], a                            ; $030B
    ld a, [hl+]                                   ; $030E
    ld [wScyShadow], a                            ; $030F
    ld a, [hl+]                                   ; $0312
    ld [wWxShadow], a                             ; $0313
    ld a, [hl+]                                   ; $0316
    ld [wWyShadow], a                             ; $0317
    ld a, [hl+]                                   ; $031A
    ld a, [hl+]                                   ; $031B
    ld [wStatShadow], a                           ; $031C
    ld a, [wLcdcShadow]                           ; $031F
    ldh [rLCDC], a                                ; $0322
    ld a, [wStatShadow]                           ; $0324
    ldh [rSTAT], a                                ; $0327
    ld a, [hl+]                                   ; $0329
    ldh [rIE], a                                  ; $032A
    jp hl                                         ; $032C


; C: 10 inline bytes: the same without IE
Lcd_SetupInlineNoIE::
    pop hl                                        ; $032D
    ld a, [hl+]                                   ; $032E
    ld [wLcdcShadow], a                           ; $032F
    ld a, [hl+]                                   ; $0332
    ld [wPaletteTarget], a                        ; $0333
    ld a, [hl+]                                   ; $0336
    ld [wPaletteTarget + $1], a                   ; $0337
    ld a, [hl+]                                   ; $033A
    ld [wPaletteTarget + $2], a                   ; $033B
    ld a, [hl+]                                   ; $033E
    ld [wScxShadow], a                            ; $033F
    ld a, [hl+]                                   ; $0342
    ld [wScyShadow], a                            ; $0343
    ld a, [hl+]                                   ; $0346
    ld [wWxShadow], a                             ; $0347
    ld a, [hl+]                                   ; $034A
    ld [wWyShadow], a                             ; $034B
    ld a, [hl+]                                   ; $034E
    ld a, [hl+]                                   ; $034F
    ld [wStatShadow], a                           ; $0350
    ld a, [wLcdcShadow]                           ; $0353
    ldh [rLCDC], a                                ; $0356
    ld a, [wStatShadow]                           ; $0358
    ldh [rSTAT], a                                ; $035B
    jp hl                                         ; $035D


; C: inline word BC: Delay_Frames_Busy with that count
Delay_Inline::
    pop hl                                        ; $035E
    ld a, [hl+]                                   ; $035F
    ld c, a                                       ; $0360
    ld a, [hl+]                                   ; $0361
    ld b, a                                       ; $0362
    push hl                                       ; $0363

; C: same code as the Japanese Delay_Frames_Busy (00:08E8, 17 bytes, exact match)
Delay_Frames_Busy::
    ld de, $06d6                                  ; $0364

jr_000_0367:
    nop                                           ; $0367
    nop                                           ; $0368
    nop                                           ; $0369
    dec de                                        ; $036A
    ld a, d                                       ; $036B
    or e                                          ; $036C
    jr nz, jr_000_0367                            ; $036D

    dec bc                                        ; $036F
    ld a, b                                       ; $0370
    or c                                          ; $0371
    jr nz, Delay_Frames_Busy                      ; $0372

    ret                                           ; $0374


; C: with the screen on: STAT interrupts off, waits for line $91, LCDC off
Lcd_Off::
    ldh a, [rLCDC]                                ; $0375
    bit 7, a                                      ; $0377
    ret z                                         ; $0379

    ldh a, [rIE]                                  ; $037A
    push af                                       ; $037C
    and $fc                                       ; $037D
    ldh [rIE], a                                  ; $037F

jr_000_0381:
    ldh a, [rLY]                                  ; $0381
    cp $91                                        ; $0383
    jr nz, jr_000_0381                            ; $0385

    pop af                                        ; $0387
    ldh [rIE], a                                  ; $0388
    xor a                                         ; $038A
    ldh [rLCDC], a                                ; $038B
    ld [wBgpShadow], a                            ; $038D
    ld [wObp0Shadow], a                           ; $0390
    ld [wObp1Shadow], a                           ; $0393
    ret                                           ; $0396


    db $fa, $82, $d8, $cb, $ff, $ea, $82, $d8, $e0, $40, $c9

; C: BC bytes from HL to DE
Mem_Copy::
    ld a, [hl+]                                   ; $03A2
    ld [de], a                                    ; $03A3
    inc de                                        ; $03A4
    dec bc                                        ; $03A5
    ld a, c                                       ; $03A6
    or b                                          ; $03A7
    jr nz, Mem_Copy                               ; $03A8

    ret                                           ; $03AA


    db $3e, $00, $21, $00, $98, $22, $cb, $54, $28, $fb, $c9, $3e, $00, $21, $00, $9c
    db $22, $cb, $6c, $28, $fb, $c9

; C: every OAM entry of the shadow $D600 hidden (y = $F0)
Oam_ClearShadow::
    ld a, $f0                                     ; $03C1
    ld hl, wOamShadow                             ; $03C3

jr_000_03c6:
    ld [hl+], a                                   ; $03C6
    bit 0, h                                      ; $03C7
    inc hl                                        ; $03C9
    inc hl                                        ; $03CA
    inc hl                                        ; $03CB
    bit 0, h                                      ; $03CC
    jr z, jr_000_03c6                             ; $03CE

    xor a                                         ; $03D0
    ld [wOamUsedEnd], a                           ; $03D1
    ret                                           ; $03D4


; C: the OAM shadow entries from [$D880] on hidden (y = $F0)
Oam_HideUnused::
    ld a, [wOamUsedEnd]                           ; $03D5
    ld l, a                                       ; $03D8
    ld h, $d6                                     ; $03D9
    ld a, $f0                                     ; $03DB

jr_000_03dd:
    ld [hl+], a                                   ; $03DD
    inc hl                                        ; $03DE
    inc hl                                        ; $03DF
    inc hl                                        ; $03E0
    bit 0, h                                      ; $03E1
    jr z, jr_000_03dd                             ; $03E3

    xor a                                         ; $03E5
    ld [wOamUsedEnd], a                           ; $03E6
    ret                                           ; $03E9


; C: same code as the Japanese Rng_Next (00:08F9, 33 bytes, masked match)
Rng_Next::
    push bc                                       ; $03EA
    push de                                       ; $03EB
    push hl                                       ; $03EC
    ld a, [wRngIndex]                             ; $03ED
    ld c, a                                       ; $03F0
    ld b, $00                                     ; $03F1
    inc a                                         ; $03F3
    cp $37                                        ; $03F4
    jr nz, jr_000_03ff                            ; $03F6

    call Rng_Refill                               ; $03F8
    xor a                                         ; $03FB
    ld bc, $0000                                  ; $03FC

jr_000_03ff:
    ld [wRngIndex], a                             ; $03FF
    ld hl, wRngTable                              ; $0402
    add hl, bc                                    ; $0405
    ld a, [hl]                                    ; $0406
    pop hl                                        ; $0407
    pop de                                        ; $0408
    pop bc                                        ; $0409
    ret                                           ; $040A


; C: same code as the Japanese Rng_Init (00:091A, 93 bytes, masked match)
Rng_Init::
    ld a, [wRngModulus]                           ; $040B
    ld d, a                                       ; $040E
    ld a, $01                                     ; $040F
    ld [rRAMB], a                                 ; $0411
    ld a, [$afff]                                 ; $0414

jr_000_0417:
    cp d                                          ; $0417
    jr c, jr_000_041d                             ; $0418

    sub d                                         ; $041A
    jr jr_000_0417                                ; $041B

jr_000_041d:
    ld [wRngSeedTmp], a                           ; $041D
    ld [wRngTable + $36], a                       ; $0420
    ld e, $01                                     ; $0423
    ld hl, Rng_InitOrder                          ; $0425
    ld a, $36                                     ; $0428

jr_000_042a:
    push af                                       ; $042A
    ld c, [hl]                                    ; $042B
    inc hl                                        ; $042C
    ld b, $00                                     ; $042D
    push hl                                       ; $042F
    ld hl, wRngTable                              ; $0430
    add hl, bc                                    ; $0433
    ld [hl], e                                    ; $0434
    ld a, [wRngSeedTmp]                           ; $0435
    sub e                                         ; $0438
    jr nc, jr_000_043c                            ; $0439

    add d                                         ; $043B

jr_000_043c:
    ld e, a                                       ; $043C
    ld a, [hl]                                    ; $043D
    ld [wRngSeedTmp], a                           ; $043E
    pop hl                                        ; $0441
    pop af                                        ; $0442
    dec a                                         ; $0443
    jr nz, jr_000_042a                            ; $0444

    call Rng_Refill                               ; $0446
    call Rng_Refill                               ; $0449
    call Rng_Refill                               ; $044C
    push af                                       ; $044F
    ld a, $0a                                     ; $0450
    ld [rRAMG], a                                 ; $0452
    pop af                                        ; $0455
    ld a, $01                                     ; $0456
    ld [rRAMB], a                                 ; $0458
    call Rng_Next                                 ; $045B
    ld [$afff], a                                 ; $045E
    push af                                       ; $0461
    xor a                                         ; $0462
    ld [rRAMG], a                                 ; $0463
    pop af                                        ; $0466
    ret                                           ; $0467


; C: the same 54 bytes as the Japanese Rng_InitOrder (00:0977); read in the runs by Rng_Init; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz)
Rng_InitOrder::
    db $14, $29, $07, $1c, $31, $0f, $24, $02, $17, $2c, $0a, $1f, $34, $12, $27, $05
    db $1a, $2f, $0d, $22, $00, $15, $2a, $08, $1d, $32, $10, $25, $03, $18, $2d, $0b
    db $20, $35, $13, $28, $06, $1b, $30, $0e, $23, $01, $16, $2b, $09, $1e, $33, $11
    db $26, $04, $19, $2e, $0c, $21

; C: same code as the Japanese Rng_Refill (00:09AD, 39 bytes, masked match)
Rng_Refill::
    ld a, [wRngModulus]                           ; $049E
    ld d, a                                       ; $04A1
    ld bc, wRngTable                              ; $04A2
    ld hl, wRngTable + $1f                        ; $04A5
    ld e, $18                                     ; $04A8

jr_000_04aa:
    ld a, [bc]                                    ; $04AA
    sub [hl]                                      ; $04AB
    jr nc, jr_000_04af                            ; $04AC

    add d                                         ; $04AE

jr_000_04af:
    ld [bc], a                                    ; $04AF
    dec e                                         ; $04B0
    jr nz, jr_000_04aa                            ; $04B1

    ld bc, wRngTable + $18                        ; $04B3
    ld hl, wRngTable                              ; $04B6
    ld e, $1f                                     ; $04B9

jr_000_04bb:
    ld a, [bc]                                    ; $04BB
    sub [hl]                                      ; $04BC
    jr nc, jr_000_04c0                            ; $04BD

    add d                                         ; $04BF

jr_000_04c0:
    ld [bc], a                                    ; $04C0
    dec e                                         ; $04C1
    jr nz, jr_000_04bb                            ; $04C2

    ret                                           ; $04C4


; C: same code as the Japanese Math_MulAL (00:0F4F, 77 bytes, exact match)
Math_MulAL::
    push bc                                       ; $04C5
    ld c, l                                       ; $04C6
    ld b, $00                                     ; $04C7
    ld hl, $0000                                  ; $04C9
    bit 0, a                                      ; $04CC
    jr z, jr_000_04d1                             ; $04CE

    add hl, bc                                    ; $04D0

jr_000_04d1:
    sla c                                         ; $04D1
    rl b                                          ; $04D3
    bit 1, a                                      ; $04D5
    jr z, jr_000_04da                             ; $04D7

    add hl, bc                                    ; $04D9

jr_000_04da:
    sla c                                         ; $04DA
    rl b                                          ; $04DC
    bit 2, a                                      ; $04DE
    jr z, jr_000_04e3                             ; $04E0

    add hl, bc                                    ; $04E2

jr_000_04e3:
    sla c                                         ; $04E3
    rl b                                          ; $04E5
    bit 3, a                                      ; $04E7
    jr z, jr_000_04ec                             ; $04E9

    add hl, bc                                    ; $04EB

jr_000_04ec:
    sla c                                         ; $04EC
    rl b                                          ; $04EE
    bit 4, a                                      ; $04F0
    jr z, jr_000_04f5                             ; $04F2

    add hl, bc                                    ; $04F4

jr_000_04f5:
    sla c                                         ; $04F5
    rl b                                          ; $04F7
    bit 5, a                                      ; $04F9
    jr z, jr_000_04fe                             ; $04FB

    add hl, bc                                    ; $04FD

jr_000_04fe:
    sla c                                         ; $04FE
    rl b                                          ; $0500
    bit 6, a                                      ; $0502
    jr z, jr_000_0507                             ; $0504

    add hl, bc                                    ; $0506

jr_000_0507:
    sla c                                         ; $0507
    rl b                                          ; $0509
    bit 7, a                                      ; $050B
    jr z, jr_000_0510                             ; $050D

    add hl, bc                                    ; $050F

jr_000_0510:
    pop bc                                        ; $0510
    ret                                           ; $0511


; C: same code as the Japanese Rng_Scaled (00:09D4, 26 bytes, masked match)
Rng_Scaled::
    push bc                                       ; $0512
    push hl                                       ; $0513
    ld c, a                                       ; $0514
    ld b, $00                                     ; $0515
    ld hl, Rng_Scaled + $1A                       ; $0517
    add hl, bc                                    ; $051A
    ld l, [hl]                                    ; $051B
    call Rng_Next                                 ; $051C
    call Math_MulAL                               ; $051F
    srl h                                         ; $0522
    srl h                                         ; $0524
    srl h                                         ; $0526
    ld a, h                                       ; $0528
    pop hl                                        ; $0529
    pop bc                                        ; $052A
    ret                                           ; $052B


    db $00

; C: read in the runs by Rng_Scaled; first read on the screen Mode12_SlideShow_State02 (trace/read_screens_kitty.npz)
Rng_Scaled_Tbl052D::
    db $08, $10, $18, $20, $28, $30, $38, $40

    db $48, $50, $58, $60, $68, $70, $78, $80, $88, $90, $98, $a0, $a8, $b0, $b8, $c0
    db $c8, $d0, $d8, $e0, $e8, $f0, $f8

; C: same code as the Japanese Vram_WaitHBlankLine (00:0406, 35 bytes, exact match)
Vram_WaitHBlankLine::
    ldh a, [rLY]                                  ; $054C
    cp $01                                        ; $054E
    jr c, jr_000_0556                             ; $0550

    cp $8e                                        ; $0552
    jr c, jr_000_056e                             ; $0554

jr_000_0556:
    ldh a, [rLY]                                  ; $0556
    cp $01                                        ; $0558
    jr c, jr_000_0556                             ; $055A

    cp $8e                                        ; $055C
    jr nc, jr_000_0556                            ; $055E

jr_000_0560:
    ldh a, [rSTAT]                                ; $0560
    and $03                                       ; $0562
    jr nz, jr_000_0560                            ; $0564

    ld a, $15                                     ; $0566

jr_000_0568:
    dec a                                         ; $0568
    jr nz, jr_000_0568                            ; $0569

    nop                                           ; $056B
    nop                                           ; $056C
    nop                                           ; $056D

jr_000_056e:
    ret                                           ; $056E


; C: copies from DE to HL during HBlank (Vram_WaitHBlankLine, then mode 0/1); code read
Vram_CopyBytesSafe::
    push bc                                       ; $056F
    call Vram_WaitHBlankLine                      ; $0570

jr_000_0573:
    ldh a, [rSTAT]                                ; $0573
    and $03                                       ; $0575
    jr z, jr_000_0573                             ; $0577

jr_000_0579:
    ldh a, [rSTAT]                                ; $0579
    and $03                                       ; $057B
    jr nz, jr_000_0579                            ; $057D

    ld a, [de]                                    ; $057F
    ld [hl+], a                                   ; $0580
    inc de                                        ; $0581
    ld a, [de]                                    ; $0582
    ld [hl+], a                                   ; $0583
    inc de                                        ; $0584
    ld a, [de]                                    ; $0585
    ld [hl+], a                                   ; $0586
    inc de                                        ; $0587
    ld a, [de]                                    ; $0588
    ld [hl+], a                                   ; $0589
    inc de                                        ; $058A
    pop bc                                        ; $058B
    dec bc                                        ; $058C
    ld a, b                                       ; $058D
    or c                                          ; $058E
    jr nz, Vram_CopyBytesSafe                     ; $058F

    ret                                           ; $0591


    db $e0, $8a, $f0, $8b, $f5, $f0, $8a, $e0, $8b, $ea, $00, $21, $cd, $6f, $05, $f1
    db $e0, $8b, $ea, $00, $21, $c9, $c5, $1a, $4f, $13, $1a, $47, $13, $f0, $41, $e6
    db $03, $28, $fa, $f0, $41, $e6, $03, $20, $fa, $79, $22, $78, $22, $1a, $22, $13
    db $1a, $22, $13, $1a, $22, $13, $c1, $0d, $20, $dc, $c9, $e0, $8a, $f0, $8b, $f5
    db $f0, $8a, $e0, $8b, $ea, $00, $21, $cd, $a8, $05, $f1, $e0, $8b, $ea, $00, $21
    db $c9

; C: fills BC bytes with E at HL, 6 bytes per HBlank; code read
Vram_FillSafe::
    push bc                                       ; $05E3
    call Vram_WaitHBlankLine                      ; $05E4

jr_000_05e7:
    ldh a, [rSTAT]                                ; $05E7
    and $03                                       ; $05E9
    jr z, jr_000_05e7                             ; $05EB

jr_000_05ed:
    ldh a, [rSTAT]                                ; $05ED
    and $03                                       ; $05EF
    jr nz, jr_000_05ed                            ; $05F1

    ld a, e                                       ; $05F3
    ld [hl+], a                                   ; $05F4
    ld [hl+], a                                   ; $05F5
    ld [hl+], a                                   ; $05F6
    ld [hl+], a                                   ; $05F7
    ld [hl+], a                                   ; $05F8
    ld [hl+], a                                   ; $05F9
    pop bc                                        ; $05FA
    dec bc                                        ; $05FB
    dec bc                                        ; $05FC
    dec bc                                        ; $05FD
    dec bc                                        ; $05FE
    dec bc                                        ; $05FF
    dec bc                                        ; $0600
    ld a, b                                       ; $0601
    and a                                         ; $0602
    jr nz, Vram_FillSafe                          ; $0603

    ld a, c                                       ; $0605
    cp $06                                        ; $0606
    jr nc, Vram_FillSafe                          ; $0608

    dec a                                         ; $060A
    jr z, jr_000_061a                             ; $060B

    dec a                                         ; $060D
    jr z, jr_000_0628                             ; $060E

    dec a                                         ; $0610
    jr z, jr_000_0638                             ; $0611

    dec a                                         ; $0613
    jr z, jr_000_0649                             ; $0614

    dec a                                         ; $0616
    jr z, jr_000_065b                             ; $0617

    ret                                           ; $0619


jr_000_061a:
    ldh a, [rSTAT]                                ; $061A
    and $03                                       ; $061C
    jr z, jr_000_061a                             ; $061E

jr_000_0620:
    ldh a, [rSTAT]                                ; $0620
    and $03                                       ; $0622
    jr nz, jr_000_0620                            ; $0624

    ld [hl+], a                                   ; $0626
    ret                                           ; $0627


jr_000_0628:
    ldh a, [rSTAT]                                ; $0628
    and $03                                       ; $062A
    jr z, jr_000_0628                             ; $062C

jr_000_062e:
    ldh a, [rSTAT]                                ; $062E
    and $03                                       ; $0630
    jr nz, jr_000_062e                            ; $0632

    ld a, e                                       ; $0634
    ld [hl+], a                                   ; $0635
    ld [hl+], a                                   ; $0636
    ret                                           ; $0637


jr_000_0638:
    ldh a, [rSTAT]                                ; $0638
    and $03                                       ; $063A
    jr z, jr_000_0638                             ; $063C

jr_000_063e:
    ldh a, [rSTAT]                                ; $063E
    and $03                                       ; $0640
    jr nz, jr_000_063e                            ; $0642

    ld a, e                                       ; $0644
    ld [hl+], a                                   ; $0645
    ld [hl+], a                                   ; $0646
    ld [hl+], a                                   ; $0647
    ret                                           ; $0648


jr_000_0649:
    ldh a, [rSTAT]                                ; $0649
    and $03                                       ; $064B
    jr z, jr_000_0649                             ; $064D

jr_000_064f:
    ldh a, [rSTAT]                                ; $064F
    and $03                                       ; $0651
    jr nz, jr_000_064f                            ; $0653

    ld a, e                                       ; $0655
    ld [hl+], a                                   ; $0656
    ld [hl+], a                                   ; $0657
    ld [hl+], a                                   ; $0658
    ld [hl+], a                                   ; $0659
    ret                                           ; $065A


jr_000_065b:
    ldh a, [rSTAT]                                ; $065B
    and $03                                       ; $065D
    jr z, jr_000_065b                             ; $065F

jr_000_0661:
    ldh a, [rSTAT]                                ; $0661
    and $03                                       ; $0663
    jr nz, jr_000_0661                            ; $0665

    ld a, e                                       ; $0667
    ld [hl+], a                                   ; $0668
    ld [hl+], a                                   ; $0669
    ld [hl+], a                                   ; $066A
    ld [hl+], a                                   ; $066B
    ld [hl+], a                                   ; $066C
    ret                                           ; $066D


; C: copy BC bytes from DE to VRAM at HL in H-blank steps (current bank)
Vram_CopyHBlank::
    push bc                                       ; $066E
    ld a, [de]                                    ; $066F
    ld c, a                                       ; $0670
    inc de                                        ; $0671
    ld a, [de]                                    ; $0672
    ld b, a                                       ; $0673
    inc de                                        ; $0674
    call Vram_WaitHBlankLine                      ; $0675

jr_000_0678:
    ldh a, [rSTAT]                                ; $0678
    and $03                                       ; $067A
    jr z, jr_000_0678                             ; $067C

jr_000_067e:
    ldh a, [rSTAT]                                ; $067E
    and $03                                       ; $0680
    jr nz, jr_000_067e                            ; $0682

    ld a, c                                       ; $0684
    ld [hl+], a                                   ; $0685
    ld a, b                                       ; $0686
    ld [hl+], a                                   ; $0687
    ld a, [de]                                    ; $0688
    ld [hl+], a                                   ; $0689
    inc de                                        ; $068A
    ld a, [de]                                    ; $068B
    ld [hl+], a                                   ; $068C
    inc de                                        ; $068D
    ld a, [de]                                    ; $068E
    ld [hl+], a                                   ; $068F
    inc de                                        ; $0690
    ld a, [de]                                    ; $0691
    ld [hl+], a                                   ; $0692
    inc de                                        ; $0693
    pop bc                                        ; $0694
    dec bc                                        ; $0695
    dec bc                                        ; $0696
    dec bc                                        ; $0697
    dec bc                                        ; $0698
    dec bc                                        ; $0699
    dec bc                                        ; $069A
    ld a, b                                       ; $069B
    and a                                         ; $069C
    jr nz, Vram_CopyHBlank                        ; $069D

    ld a, c                                       ; $069F
    cp $06                                        ; $06A0
    jr nc, Vram_CopyHBlank                        ; $06A2

    dec a                                         ; $06A4
    jr z, jr_000_06b4                             ; $06A5

    dec a                                         ; $06A7
    jr z, jr_000_06c4                             ; $06A8

    dec a                                         ; $06AA
    jr z, jr_000_06d7                             ; $06AB

    dec a                                         ; $06AD
    jr z, jr_000_06ed                             ; $06AE

    dec a                                         ; $06B0
    jr z, jr_000_0706                             ; $06B1

    ret                                           ; $06B3


jr_000_06b4:
    ldh a, [rSTAT]                                ; $06B4
    and $03                                       ; $06B6
    jr z, jr_000_06b4                             ; $06B8

jr_000_06ba:
    ldh a, [rSTAT]                                ; $06BA
    and $03                                       ; $06BC
    jr nz, jr_000_06ba                            ; $06BE

    ld a, [de]                                    ; $06C0
    ld [hl+], a                                   ; $06C1
    inc de                                        ; $06C2
    ret                                           ; $06C3


jr_000_06c4:
    ldh a, [rSTAT]                                ; $06C4
    and $03                                       ; $06C6
    jr z, jr_000_06c4                             ; $06C8

jr_000_06ca:
    ldh a, [rSTAT]                                ; $06CA
    and $03                                       ; $06CC
    jr nz, jr_000_06ca                            ; $06CE

    ld a, [de]                                    ; $06D0
    ld [hl+], a                                   ; $06D1
    inc de                                        ; $06D2
    ld a, [de]                                    ; $06D3
    ld [hl+], a                                   ; $06D4
    inc de                                        ; $06D5
    ret                                           ; $06D6


jr_000_06d7:
    ldh a, [rSTAT]                                ; $06D7
    and $03                                       ; $06D9
    jr z, jr_000_06d7                             ; $06DB

jr_000_06dd:
    ldh a, [rSTAT]                                ; $06DD
    and $03                                       ; $06DF
    jr nz, jr_000_06dd                            ; $06E1

    ld a, [de]                                    ; $06E3
    ld [hl+], a                                   ; $06E4
    inc de                                        ; $06E5
    ld a, [de]                                    ; $06E6
    ld [hl+], a                                   ; $06E7
    inc de                                        ; $06E8
    ld a, [de]                                    ; $06E9
    ld [hl+], a                                   ; $06EA
    inc de                                        ; $06EB
    ret                                           ; $06EC


jr_000_06ed:
    ldh a, [rSTAT]                                ; $06ED
    and $03                                       ; $06EF
    jr z, jr_000_06ed                             ; $06F1

jr_000_06f3:
    ldh a, [rSTAT]                                ; $06F3
    and $03                                       ; $06F5
    jr nz, jr_000_06f3                            ; $06F7

    ld a, [de]                                    ; $06F9
    ld [hl+], a                                   ; $06FA
    inc de                                        ; $06FB
    ld a, [de]                                    ; $06FC
    ld [hl+], a                                   ; $06FD
    inc de                                        ; $06FE
    ld a, [de]                                    ; $06FF
    ld [hl+], a                                   ; $0700
    inc de                                        ; $0701
    ld a, [de]                                    ; $0702
    ld [hl+], a                                   ; $0703
    inc de                                        ; $0704
    ret                                           ; $0705


jr_000_0706:
    ldh a, [rSTAT]                                ; $0706
    and $03                                       ; $0708
    jr z, jr_000_0706                             ; $070A

jr_000_070c:
    ldh a, [rSTAT]                                ; $070C
    and $03                                       ; $070E
    jr nz, jr_000_070c                            ; $0710

    ld a, [de]                                    ; $0712
    ld c, a                                       ; $0713
    inc de                                        ; $0714
    ld a, [de]                                    ; $0715
    ld b, a                                       ; $0716
    inc de                                        ; $0717
    ld a, c                                       ; $0718
    ld [hl+], a                                   ; $0719
    ld a, b                                       ; $071A
    ld [hl+], a                                   ; $071B
    ld a, [de]                                    ; $071C
    ld [hl+], a                                   ; $071D
    inc de                                        ; $071E
    ld a, [de]                                    ; $071F
    ld [hl+], a                                   ; $0720
    inc de                                        ; $0721
    ld a, [de]                                    ; $0722
    ld [hl+], a                                   ; $0723
    inc de                                        ; $0724
    ret                                           ; $0725


; C: the same from bank A
Vram_CopyHBlankFar::
    ldh [hBankTmp], a                             ; $0726
    ldh a, [hRomBankShadow]                       ; $0728
    push af                                       ; $072A
    ldh a, [hBankTmp]                             ; $072B
    ldh [hRomBankShadow], a                       ; $072D
    ld [$2100], a                                 ; $072F
    call Vram_CopyHBlank                          ; $0732
    pop af                                        ; $0735
    ldh [hRomBankShadow], a                       ; $0736
    ld [$2100], a                                 ; $0738
    ret                                           ; $073B


    db $c5, $1a, $4f, $1c, $1a, $47, $1c, $f0, $41, $e6, $03, $28, $fa, $f0, $41, $e6
    db $03, $20, $fa, $79, $22, $78, $22, $1a, $22, $1c, $1a, $22, $1c, $1a, $22, $1c
    db $1a, $22, $1c, $1a, $22, $1c, $1a, $22, $13, $c1, $0d, $20, $d3, $c9, $f0, $8b
    db $f5, $78, $e0, $8b, $ea, $00, $21, $cd, $3c, $07, $f1, $e0, $8b, $ea, $00, $21
    db $c9

; C: frame A: the 6-byte record A of 05:69E7 (bank 5) and its tiles (frames $2C and $2F have their own path);
; FramePick_Load; code read
FrameRec_LoadTiles::
    ld b, a                                       ; $077D
    ldh a, [hRomBankShadow]                       ; $077E
    push af                                       ; $0780
    ld a, b                                       ; $0781
    push af                                       ; $0782
    ld c, $06                                     ; $0783
    call Mul_8x8                                  ; $0785
    ld bc, Src_05_68D7_Mode02_TakePhotos_State01 + $110 ; $0788
    add hl, bc                                    ; $078B
    ld a, $05                                     ; $078C
    ldh [hRomBankShadow], a                       ; $078E
    ld [$2100], a                                 ; $0790
    pop af                                        ; $0793
    cp $2c                                        ; $0794
    jr z, jr_000_079c                             ; $0796

    cp $2f                                        ; $0798
    jr nz, jr_000_07ae                            ; $079A

jr_000_079c:
    push hl                                       ; $079C
    ld de, Gfx_23_7530_Mode02_TakePhotos_State00  ; $079D
    ld a, $23                                     ; $07A0
    ld hl, $8fe0                                  ; $07A2
    ld bc, $0020                                  ; $07A5
    call Vram_CopyHBlankFar                       ; $07A8
    pop hl                                        ; $07AB
    jr jr_000_07c7                                ; $07AC

jr_000_07ae:
    ld a, [hl+]                                   ; $07AE
    ld [wPrintSrcTable2 + $4], a                  ; $07AF
    ld e, a                                       ; $07B2
    ld a, [hl+]                                   ; $07B3
    ld [wPrintSrcTable2 + $5], a                  ; $07B4
    ld d, a                                       ; $07B7
    ld a, [hl+]                                   ; $07B8
    push hl                                       ; $07B9
    ld [wPrintSrcTable2 + $6], a                  ; $07BA
    ld hl, $8a00                                  ; $07BD
    ld bc, $05e0                                  ; $07C0
    call Vram_CopyHBlankFar                       ; $07C3
    pop hl                                        ; $07C6

jr_000_07c7:
    pop af                                        ; $07C7
    ldh [hRomBankShadow], a                       ; $07C8
    ld [$2100], a                                 ; $07CA
    ret                                           ; $07CD


; C: frame A: the map of record A of 05:69E7; code read: into the BG map from $9842
FrameRec_LoadMap::
    ld b, a                                       ; $07CE
    ldh a, [hRomBankShadow]                       ; $07CF
    push af                                       ; $07D1
    ld a, b                                       ; $07D2
    ld c, $06                                     ; $07D3
    call Mul_8x8                                  ; $07D5
    ld bc, Src_05_68D7_Mode02_TakePhotos_State01 + $110 ; $07D8
    add hl, bc                                    ; $07DB
    ld a, $05                                     ; $07DC
    ldh [hRomBankShadow], a                       ; $07DE
    ld [$2100], a                                 ; $07E0
    inc hl                                        ; $07E3
    inc hl                                        ; $07E4
    inc hl                                        ; $07E5
    ld a, [hl+]                                   ; $07E6
    ld [wPrintSrcTable + $4], a                   ; $07E7
    ld e, a                                       ; $07EA
    ld a, [hl+]                                   ; $07EB
    ld [wPrintSrcTable + $5], a                   ; $07EC
    ld d, a                                       ; $07EF
    ld a, [hl+]                                   ; $07F0
    ld [wPrintSrcTable + $6], a                   ; $07F1
    ldh [hRomBankShadow], a                       ; $07F4
    ld [$2100], a                                 ; $07F6
    ld hl, $9842                                  ; $07F9
    ld c, $04                                     ; $07FC
    call Map_Write5PlusA0Safe                     ; $07FE
    ld bc, $000c                                  ; $0801
    add hl, bc                                    ; $0804
    ld c, $04                                     ; $0805
    call Map_Write5PlusA0Safe                     ; $0807
    ld hl, $9a42                                  ; $080A
    ld c, $04                                     ; $080D
    call Map_Write5PlusA0Safe                     ; $080F
    ld bc, $000c                                  ; $0812
    add hl, bc                                    ; $0815
    ld c, $04                                     ; $0816
    call Map_Write5PlusA0Safe                     ; $0818
    ld hl, $9882                                  ; $081B
    ld c, $0e                                     ; $081E

jr_000_0820:
    push bc                                       ; $0820
    ld b, $a0                                     ; $0821

jr_000_0823:
    ldh a, [rSTAT]                                ; $0823
    and $03                                       ; $0825
    jr z, jr_000_0823                             ; $0827

jr_000_0829:
    ldh a, [rSTAT]                                ; $0829
    and $03                                       ; $082B
    jr nz, jr_000_0829                            ; $082D

    ld a, [de]                                    ; $082F
    add b                                         ; $0830
    ld [hl+], a                                   ; $0831
    inc de                                        ; $0832
    ld a, [de]                                    ; $0833
    add b                                         ; $0834
    ld [hl+], a                                   ; $0835
    inc de                                        ; $0836
    ld bc, $0010                                  ; $0837
    add hl, bc                                    ; $083A
    ld b, $a0                                     ; $083B

jr_000_083d:
    ldh a, [rSTAT]                                ; $083D
    and $03                                       ; $083F
    jr z, jr_000_083d                             ; $0841

jr_000_0843:
    ldh a, [rSTAT]                                ; $0843
    and $03                                       ; $0845
    jr nz, jr_000_0843                            ; $0847

    ld a, [de]                                    ; $0849
    add b                                         ; $084A
    ld [hl+], a                                   ; $084B
    inc de                                        ; $084C
    ld a, [de]                                    ; $084D
    add b                                         ; $084E
    ld [hl+], a                                   ; $084F
    inc de                                        ; $0850
    ld bc, $000c                                  ; $0851
    add hl, bc                                    ; $0854
    pop bc                                        ; $0855
    dec c                                         ; $0856
    jr nz, jr_000_0820                            ; $0857

    pop af                                        ; $0859
    ldh [hRomBankShadow], a                       ; $085A
    ld [$2100], a                                 ; $085C
    ret                                           ; $085F


; C: the map of record A of 05:69E7 into the window map from $9C42 (the window copy of FrameRec_LoadMap); code read
FrameRec_LoadMapWin::
    ld b, a                                       ; $0860
    ldh a, [hRomBankShadow]                       ; $0861
    push af                                       ; $0863
    ld a, b                                       ; $0864
    ld c, $06                                     ; $0865
    call Mul_8x8                                  ; $0867
    ld bc, Src_05_68D7_Mode02_TakePhotos_State01 + $110 ; $086A
    add hl, bc                                    ; $086D
    ld a, $05                                     ; $086E
    ldh [hRomBankShadow], a                       ; $0870
    ld [$2100], a                                 ; $0872
    inc hl                                        ; $0875
    inc hl                                        ; $0876
    inc hl                                        ; $0877
    ld a, [hl+]                                   ; $0878
    ld [wPrintSrcTable + $4], a                   ; $0879
    ld e, a                                       ; $087C
    ld a, [hl+]                                   ; $087D
    ld [wPrintSrcTable + $5], a                   ; $087E
    ld d, a                                       ; $0881
    ld a, [hl+]                                   ; $0882
    ld [wPrintSrcTable + $6], a                   ; $0883
    ldh [hRomBankShadow], a                       ; $0886
    ld [$2100], a                                 ; $0888
    ld hl, $9c42                                  ; $088B
    ld c, $04                                     ; $088E
    call Map_Write5PlusA0Safe                     ; $0890
    ld bc, $000c                                  ; $0893
    add hl, bc                                    ; $0896
    ld c, $04                                     ; $0897
    call Map_Write5PlusA0Safe                     ; $0899
    ld hl, $9e42                                  ; $089C
    ld c, $04                                     ; $089F
    call Map_Write5PlusA0Safe                     ; $08A1
    ld bc, $000c                                  ; $08A4
    add hl, bc                                    ; $08A7
    ld c, $04                                     ; $08A8
    call Map_Write5PlusA0Safe                     ; $08AA
    ld hl, $9c82                                  ; $08AD
    ld c, $0e                                     ; $08B0

jr_000_08b2:
    push bc                                       ; $08B2
    ld b, $a0                                     ; $08B3

jr_000_08b5:
    ldh a, [rSTAT]                                ; $08B5
    and $03                                       ; $08B7
    jr z, jr_000_08b5                             ; $08B9

jr_000_08bb:
    ldh a, [rSTAT]                                ; $08BB
    and $03                                       ; $08BD
    jr nz, jr_000_08bb                            ; $08BF

    ld a, [de]                                    ; $08C1
    add b                                         ; $08C2
    ld [hl+], a                                   ; $08C3
    inc de                                        ; $08C4
    ld a, [de]                                    ; $08C5
    add b                                         ; $08C6
    ld [hl+], a                                   ; $08C7
    inc de                                        ; $08C8
    ld bc, $0010                                  ; $08C9
    add hl, bc                                    ; $08CC
    ld b, $a0                                     ; $08CD

jr_000_08cf:
    ldh a, [rSTAT]                                ; $08CF
    and $03                                       ; $08D1
    jr z, jr_000_08cf                             ; $08D3

jr_000_08d5:
    ldh a, [rSTAT]                                ; $08D5
    and $03                                       ; $08D7
    jr nz, jr_000_08d5                            ; $08D9

    ld a, [de]                                    ; $08DB
    add b                                         ; $08DC
    ld [hl+], a                                   ; $08DD
    inc de                                        ; $08DE
    ld a, [de]                                    ; $08DF
    add b                                         ; $08E0
    ld [hl+], a                                   ; $08E1
    inc de                                        ; $08E2
    ld bc, $000c                                  ; $08E3
    add hl, bc                                    ; $08E6
    pop bc                                        ; $08E7
    dec c                                         ; $08E8
    jr nz, jr_000_08b2                            ; $08E9

    pop af                                        ; $08EB
    ldh [hRomBankShadow], a                       ; $08EC
    ld [$2100], a                                 ; $08EE
    ret                                           ; $08F1


; C: C groups of 5 bytes from DE, each + $A0, written at HL one group per HBlank; code read
Map_Write5PlusA0Safe::
    push bc                                       ; $08F2
    ld a, [de]                                    ; $08F3
    add $a0                                       ; $08F4
    ld c, a                                       ; $08F6
    inc de                                        ; $08F7
    ld a, [de]                                    ; $08F8
    add $a0                                       ; $08F9
    ld b, a                                       ; $08FB
    inc de                                        ; $08FC
    call Vram_WaitHBlankLine                      ; $08FD

jr_000_0900:
    ldh a, [rSTAT]                                ; $0900
    and $03                                       ; $0902
    jr z, jr_000_0900                             ; $0904

jr_000_0906:
    ldh a, [rSTAT]                                ; $0906
    and $03                                       ; $0908
    jr nz, jr_000_0906                            ; $090A

    ld a, c                                       ; $090C
    ld [hl+], a                                   ; $090D
    ld a, b                                       ; $090E
    ld [hl+], a                                   ; $090F
    ld a, [de]                                    ; $0910
    add $a0                                       ; $0911
    ld [hl+], a                                   ; $0913
    inc de                                        ; $0914
    ld a, [de]                                    ; $0915
    add $a0                                       ; $0916
    ld [hl+], a                                   ; $0918
    inc de                                        ; $0919
    ld a, [de]                                    ; $091A
    add $a0                                       ; $091B
    ld [hl+], a                                   ; $091D
    inc de                                        ; $091E
    pop bc                                        ; $091F
    dec c                                         ; $0920
    jr nz, Map_Write5PlusA0Safe                   ; $0921

    ret                                           ; $0923


; C: one tile of 23:7530 into $8FE0, then the map of frame $2F; code read
FrameRec_LoadDefault::
    push af                                       ; $0924
    ld de, Gfx_23_7530_Mode02_TakePhotos_State00  ; $0925
    ld a, $23                                     ; $0928
    ld hl, $8fe0                                  ; $092A
    ld bc, $0020                                  ; $092D
    call Vram_CopyHBlankFar                       ; $0930
    ld a, $2f                                     ; $0933
    call FrameRec_LoadMap                         ; $0935
    pop af                                        ; $0938

; C: FrameRec_LoadTiles then FrameRec_LoadMap with the same A
FrameRec_LoadTilesAndMap::
    push af                                       ; $0939
    call FrameRec_LoadTiles                       ; $093A
    pop af                                        ; $093D
    call FrameRec_LoadMap                         ; $093E
    ret                                           ; $0941


; C: FrameRec_LoadTiles with plain copies (screen off); code read
FrameRec_LoadTilesScreenOff::
    ld b, a                                       ; $0942
    ldh a, [hRomBankShadow]                       ; $0943
    push af                                       ; $0945
    ld a, b                                       ; $0946
    push af                                       ; $0947
    ld c, $06                                     ; $0948
    call Mul_8x8                                  ; $094A
    ld bc, Src_05_68D7_Mode02_TakePhotos_State01 + $110 ; $094D
    add hl, bc                                    ; $0950
    ld a, $05                                     ; $0951
    ldh [hRomBankShadow], a                       ; $0953
    ld [$2100], a                                 ; $0955
    pop af                                        ; $0958
    cp $2c                                        ; $0959
    jr z, jr_000_0961                             ; $095B

    cp $2f                                        ; $095D
    jr nz, jr_000_0973                            ; $095F

jr_000_0961:
    push hl                                       ; $0961
    ld de, Gfx_23_7530_Mode02_TakePhotos_State00  ; $0962
    ld a, $23                                     ; $0965
    ld hl, $8fe0                                  ; $0967
    ld bc, $0020                                  ; $096A
    call Copy_FarDEtoHL                           ; $096D
    pop hl                                        ; $0970
    jr jr_000_098c                                ; $0971

jr_000_0973:
    ld a, [hl+]                                   ; $0973
    ld [wPrintSrcTable2 + $4], a                  ; $0974
    ld e, a                                       ; $0977
    ld a, [hl+]                                   ; $0978
    ld [wPrintSrcTable2 + $5], a                  ; $0979
    ld d, a                                       ; $097C
    ld a, [hl+]                                   ; $097D
    push hl                                       ; $097E
    ld [wPrintSrcTable2 + $6], a                  ; $097F
    ld hl, $8a00                                  ; $0982
    ld bc, $05e0                                  ; $0985
    call Copy_FarDEtoHL                           ; $0988
    pop hl                                        ; $098B

jr_000_098c:
    pop af                                        ; $098C
    ldh [hRomBankShadow], a                       ; $098D
    ld [$2100], a                                 ; $098F
    ret                                           ; $0992


; C: FrameRec_LoadMap with plain copies (screen off); code read
FrameRec_LoadMapScreenOff::
    ld b, a                                       ; $0993
    ldh a, [hRomBankShadow]                       ; $0994
    push af                                       ; $0996
    ld a, b                                       ; $0997
    ld c, $06                                     ; $0998
    call Mul_8x8                                  ; $099A
    ld bc, Src_05_68D7_Mode02_TakePhotos_State01 + $110 ; $099D
    add hl, bc                                    ; $09A0
    ld a, $05                                     ; $09A1
    ldh [hRomBankShadow], a                       ; $09A3
    ld [$2100], a                                 ; $09A5
    inc hl                                        ; $09A8
    inc hl                                        ; $09A9
    inc hl                                        ; $09AA
    ld a, [hl+]                                   ; $09AB
    ld [wPrintSrcTable + $4], a                   ; $09AC
    ld e, a                                       ; $09AF
    ld a, [hl+]                                   ; $09B0
    ld [wPrintSrcTable + $5], a                   ; $09B1
    ld d, a                                       ; $09B4
    ld a, [hl+]                                   ; $09B5
    ld [wPrintSrcTable + $6], a                   ; $09B6
    ldh [hRomBankShadow], a                       ; $09B9
    ld [$2100], a                                 ; $09BB
    ld hl, $9842                                  ; $09BE
    ld c, $04                                     ; $09C1
    call Map_WritePairsPlusA0                     ; $09C3
    ld bc, $000c                                  ; $09C6
    add hl, bc                                    ; $09C9
    ld c, $04                                     ; $09CA
    call Map_WritePairsPlusA0                     ; $09CC
    ld hl, $9a42                                  ; $09CF
    ld c, $04                                     ; $09D2
    call Map_WritePairsPlusA0                     ; $09D4
    ld bc, $000c                                  ; $09D7
    add hl, bc                                    ; $09DA
    ld c, $04                                     ; $09DB
    call Map_WritePairsPlusA0                     ; $09DD
    ld hl, $9882                                  ; $09E0
    ld c, $0e                                     ; $09E3

jr_000_09e5:
    push bc                                       ; $09E5
    ld b, $a0                                     ; $09E6
    ld a, [de]                                    ; $09E8
    add b                                         ; $09E9
    ld [hl+], a                                   ; $09EA
    inc de                                        ; $09EB
    ld a, [de]                                    ; $09EC
    add b                                         ; $09ED
    ld [hl+], a                                   ; $09EE
    inc de                                        ; $09EF
    ld bc, $0010                                  ; $09F0
    add hl, bc                                    ; $09F3
    ld b, $a0                                     ; $09F4
    ld a, [de]                                    ; $09F6
    add b                                         ; $09F7
    ld [hl+], a                                   ; $09F8
    inc de                                        ; $09F9
    ld a, [de]                                    ; $09FA
    add b                                         ; $09FB
    ld [hl+], a                                   ; $09FC
    inc de                                        ; $09FD
    ld bc, $000c                                  ; $09FE
    add hl, bc                                    ; $0A01
    pop bc                                        ; $0A02
    dec c                                         ; $0A03
    jr nz, jr_000_09e5                            ; $0A04

    pop af                                        ; $0A06
    ldh [hRomBankShadow], a                       ; $0A07
    ld [$2100], a                                 ; $0A09
    ret                                           ; $0A0C


; C: 08F2 with plain writes (screen off); code read
Map_WritePairsPlusA0::
    push bc                                       ; $0A0D
    ld a, [de]                                    ; $0A0E
    add $a0                                       ; $0A0F
    ld c, a                                       ; $0A11
    inc de                                        ; $0A12
    ld a, [de]                                    ; $0A13
    add $a0                                       ; $0A14
    ld b, a                                       ; $0A16
    inc de                                        ; $0A17
    ld a, c                                       ; $0A18
    ld [hl+], a                                   ; $0A19
    ld a, b                                       ; $0A1A
    ld [hl+], a                                   ; $0A1B
    ld a, [de]                                    ; $0A1C
    add $a0                                       ; $0A1D
    ld [hl+], a                                   ; $0A1F
    inc de                                        ; $0A20
    ld a, [de]                                    ; $0A21
    add $a0                                       ; $0A22
    ld [hl+], a                                   ; $0A24
    inc de                                        ; $0A25
    ld a, [de]                                    ; $0A26
    add $a0                                       ; $0A27
    ld [hl+], a                                   ; $0A29
    inc de                                        ; $0A2A
    pop bc                                        ; $0A2B
    dec c                                         ; $0A2C
    jr nz, Map_WritePairsPlusA0                   ; $0A2D

    ret                                           ; $0A2F


; C: FrameRec_LoadDefault with plain copies; code read
FrameRec_LoadDefaultScreenOff::
    push af                                       ; $0A30
    ld de, Gfx_23_7530_Mode02_TakePhotos_State00  ; $0A31
    ld a, $23                                     ; $0A34
    ld hl, $8fe0                                  ; $0A36
    ld bc, $0020                                  ; $0A39
    call Copy_FarDEtoHL                           ; $0A3C
    ld a, $2f                                     ; $0A3F
    call FrameRec_LoadMapScreenOff                ; $0A41
    pop af                                        ; $0A44
    push af                                       ; $0A45
    call FrameRec_LoadTilesScreenOff              ; $0A46
    pop af                                        ; $0A49
    call FrameRec_LoadMapScreenOff                ; $0A4A
    ret                                           ; $0A4D


; C: the 6-byte record A of 05:69E7: bytes 0-2 into $D396-$D398, bytes 3-5 into $D386-$D388 (screen off variant, no
; drawing); code read
FrameRec_SetRecords::
    ld b, a                                       ; $0A4E
    ldh a, [hRomBankShadow]                       ; $0A4F
    push af                                       ; $0A51
    ld a, b                                       ; $0A52
    ld c, $06                                     ; $0A53
    call Mul_8x8                                  ; $0A55
    ld bc, Src_05_68D7_Mode02_TakePhotos_State01 + $110 ; $0A58
    add hl, bc                                    ; $0A5B
    ld a, $05                                     ; $0A5C
    ldh [hRomBankShadow], a                       ; $0A5E
    ld [$2100], a                                 ; $0A60
    ld a, [hl+]                                   ; $0A63
    ld [wPrintSrcTable2 + $4], a                  ; $0A64
    ld a, [hl+]                                   ; $0A67
    ld [wPrintSrcTable2 + $5], a                  ; $0A68
    ld a, [hl+]                                   ; $0A6B
    ld [wPrintSrcTable2 + $6], a                  ; $0A6C
    ld a, [hl+]                                   ; $0A6F
    ld [wPrintSrcTable + $4], a                   ; $0A70
    ld a, [hl+]                                   ; $0A73
    ld [wPrintSrcTable + $5], a                   ; $0A74
    ld a, [hl+]                                   ; $0A77
    ld [wPrintSrcTable + $6], a                   ; $0A78
    pop af                                        ; $0A7B
    ldh [hRomBankShadow], a                       ; $0A7C
    ld [$2100], a                                 ; $0A7E
    ret                                           ; $0A81


; C: 14-byte rows from the records of [$D386] (bank [$D388]) into the map at HL
MapRows_Copy14::
    ldh a, [hRomBankShadow]                       ; $0A82
    push af                                       ; $0A84
    ld a, [wPrintSrcTable + $6]                   ; $0A85
    ldh [hRomBankShadow], a                       ; $0A88
    ld [$2100], a                                 ; $0A8A
    ld c, $0e                                     ; $0A8D

jr_000_0a8f:
    push bc                                       ; $0A8F
    ld b, $a0                                     ; $0A90
    call Vram_WaitHBlankLine                      ; $0A92

jr_000_0a95:
    ldh a, [rSTAT]                                ; $0A95
    and $03                                       ; $0A97
    jr z, jr_000_0a95                             ; $0A99

jr_000_0a9b:
    ldh a, [rSTAT]                                ; $0A9B
    and $03                                       ; $0A9D
    jr nz, jr_000_0a9b                            ; $0A9F

    ld a, [de]                                    ; $0AA1
    add b                                         ; $0AA2
    ld [hl+], a                                   ; $0AA3
    inc de                                        ; $0AA4
    ld a, [de]                                    ; $0AA5
    add b                                         ; $0AA6
    ld [hl+], a                                   ; $0AA7
    inc de                                        ; $0AA8
    inc de                                        ; $0AA9
    inc de                                        ; $0AAA
    ld bc, $001e                                  ; $0AAB
    add hl, bc                                    ; $0AAE
    pop bc                                        ; $0AAF
    dec c                                         ; $0AB0
    jr nz, jr_000_0a8f                            ; $0AB1

    pop af                                        ; $0AB3
    ldh [hRomBankShadow], a                       ; $0AB4
    ld [$2100], a                                 ; $0AB6
    ret                                           ; $0AB9


; C: 7-byte rows from the records of [$D386] into the map at HL
MapRows_Copy7::
    ld c, $07                                     ; $0ABA
    jr jr_000_0ac0                                ; $0ABC

; C: 13-byte rows from the records of [$D386] into the map at HL
MapRows_Copy13::
    ld c, $0d                                     ; $0ABE

jr_000_0ac0:
    ldh a, [hRomBankShadow]                       ; $0AC0
    push af                                       ; $0AC2
    ld a, [wPrintSrcTable + $6]                   ; $0AC3
    ldh [hRomBankShadow], a                       ; $0AC6
    ld [$2100], a                                 ; $0AC8

jr_000_0acb:
    push bc                                       ; $0ACB
    ld b, $a0                                     ; $0ACC
    call Vram_WaitHBlankLine                      ; $0ACE

jr_000_0ad1:
    ldh a, [rSTAT]                                ; $0AD1
    and $03                                       ; $0AD3
    jr z, jr_000_0ad1                             ; $0AD5

jr_000_0ad7:
    ldh a, [rSTAT]                                ; $0AD7
    and $03                                       ; $0AD9
    jr nz, jr_000_0ad7                            ; $0ADB

    ld a, [de]                                    ; $0ADD
    add b                                         ; $0ADE
    ld [hl+], a                                   ; $0ADF
    inc de                                        ; $0AE0
    pop bc                                        ; $0AE1
    dec c                                         ; $0AE2
    jr nz, jr_000_0acb                            ; $0AE3

    pop af                                        ; $0AE5
    ldh [hRomBankShadow], a                       ; $0AE6
    ld [$2100], a                                 ; $0AE8
    ret                                           ; $0AEB


; C: same instructions as the Japanese Vram_WriteByteSafe (00:0744) over the whole routine (8 instructions, to the
; first ret / jp), only the addresses differ; code compared
Vram_WriteByteSafe::
    push af                                       ; $0AEC
    call Vram_WaitHBlankLine                      ; $0AED

jr_000_0af0:
    ldh a, [rSTAT]                                ; $0AF0
    and $03                                       ; $0AF2
    jr nz, jr_000_0af0                            ; $0AF4

    pop af                                        ; $0AF6
    ld [hl], a                                    ; $0AF7
    ret                                           ; $0AF8


; C: $D8F2-$D8F3 = B, C (a mode and state to return to)
Mode_SaveReturnD8F2::
    ld a, b                                       ; $0AF9
    ld [wReturnModeB], a                          ; $0AFA
    ld a, c                                       ; $0AFD
    ld [wReturnStateB], a                         ; $0AFE
    ret                                           ; $0B01


; C: $D8EC = A, then a fade to mode $14 state $00 (the message screen)
Message_Show::
    ld [wMessage_Show_D8EC], a                    ; $0B02
    ld b, MODE_MESSAGE_SCREEN                     ; $0B05
    ld c, $00                                     ; $0B07
    call Fade_GoToB                               ; $0B09
    ret                                           ; $0B0C


; C: $D93D-$D93E = B, C (a mode and state to return to)
Mode_SaveReturnD93D::
    ld a, b                                       ; $0B0D
    ld [wReturnMode], a                           ; $0B0E
    ld a, c                                       ; $0B11
    ld [wReturnState], a                          ; $0B12
    ret                                           ; $0B15


; C: fade object 02:7ECA with the parameters B (mode) and C (state), then mode $1E (the fade screen);
; Fade_SetModeFromObject sets B / C at its end
Fade_GoTo::
    ld de, ObjScript_02_7EB2_Mode00_BootAndTitle_State00 + $18 ; $0B16
    call Object_CreateWithParam                   ; $0B19
    call ModeState_SetInline                      ; $0B1C

    db MODE_SCREEN_FADE, STATE_1E_SCREEN_FADE_BETWEEN_MODES

    ret                                           ; $0B21


; C: the same with the fade object 02:7F91
Fade_GoToB::
    ld de, ObjScript_02_7F75_Mode00_BootAndTitle_State00 + $1C ; $0B22
    call Object_CreateWithParam                   ; $0B25
    call ModeState_SetInline                      ; $0B28

    db MODE_SCREEN_FADE, STATE_1E_SCREEN_FADE_BETWEEN_MODES

    ret                                           ; $0B2D


; C: the same with the fade object 02:7EE8 (not run in the core)
Fade_GoToC::
    ld de, ObjScript_02_7EB2_Mode00_BootAndTitle_State00 + $36 ; $0B2E
    call Object_CreateWithParam                   ; $0B31
    call ModeState_SetInline                      ; $0B34

    db MODE_SCREEN_FADE, STATE_1E_SCREEN_FADE_BETWEEN_MODES

    ret                                           ; $0B39


    db $11, $b3, $7f, $cd, $5d, $20, $cd, $d1, $01, $1e, $00, $c9, $47, $f0, $8b, $f5
    db $78, $e0, $8b, $ea, $00, $21, $06, $12, $0e, $14, $1a, $22, $0d, $20, $fb, $78
    db $01, $0c, $00, $09, $47, $05, $20, $f0, $f1, $e0, $8b, $ea, $00, $21, $c9

; C: unrolled copy of $20 x 4 = $80 bytes; code read
Copy_Unrolled_B::
    ld c, $20                                     ; $0B69

jr_000_0b6b:
    ld a, [de]                                    ; $0B6B
    ld [hl+], a                                   ; $0B6C
    inc de                                        ; $0B6D
    ld a, [de]                                    ; $0B6E
    ld [hl+], a                                   ; $0B6F
    inc de                                        ; $0B70
    ld a, [de]                                    ; $0B71
    ld [hl+], a                                   ; $0B72
    inc de                                        ; $0B73
    ld a, [de]                                    ; $0B74
    ld [hl+], a                                   ; $0B75
    inc de                                        ; $0B76
    dec c                                         ; $0B77
    jr nz, jr_000_0b6b                            ; $0B78

    ret                                           ; $0B7A


; C: bank A: seven blocks of $80 bytes from DE to HL, $100 apart (half-width picture rows into a 16-tile-wide buffer)
Copy_PictureHalfRows::
    ldh [hBankTmp], a                             ; $0B7B
    ldh a, [hRomBankShadow]                       ; $0B7D
    push af                                       ; $0B7F
    ldh a, [hBankTmp]                             ; $0B80
    ldh [hRomBankShadow], a                       ; $0B82
    ld [$2100], a                                 ; $0B84
    call Copy_Unrolled_B                          ; $0B87
    ld bc, $0080                                  ; $0B8A
    add hl, bc                                    ; $0B8D
    call Copy_Unrolled_B                          ; $0B8E
    ld bc, $0080                                  ; $0B91
    add hl, bc                                    ; $0B94
    call Copy_Unrolled_B                          ; $0B95
    ld bc, $0080                                  ; $0B98
    add hl, bc                                    ; $0B9B
    call Copy_Unrolled_B                          ; $0B9C
    ld bc, $0080                                  ; $0B9F
    add hl, bc                                    ; $0BA2
    call Copy_Unrolled_B                          ; $0BA3
    ld bc, $0080                                  ; $0BA6
    add hl, bc                                    ; $0BA9
    call Copy_Unrolled_B                          ; $0BAA
    ld bc, $0080                                  ; $0BAD
    add hl, bc                                    ; $0BB0
    call Copy_Unrolled_B                          ; $0BB1
    pop af                                        ; $0BB4
    ldh [hRomBankShadow], a                       ; $0BB5
    ld [$2100], a                                 ; $0BB7
    ret                                           ; $0BBA


; C: 13 rows of 4 bytes of the map record at HL (bank, column A / 8, rows $20 apart) into $D810; code read
Map_CopyColumnToD810::
    ld c, a                                       ; $0BBB
    ldh a, [hRomBankShadow]                       ; $0BBC
    push af                                       ; $0BBE
    ld a, [hl+]                                   ; $0BBF
    ld e, a                                       ; $0BC0
    ld a, [hl+]                                   ; $0BC1
    ld d, a                                       ; $0BC2
    ld a, [hl+]                                   ; $0BC3
    ldh [hRomBankShadow], a                       ; $0BC4
    ld [$2100], a                                 ; $0BC6
    srl c                                         ; $0BC9
    srl c                                         ; $0BCB
    srl c                                         ; $0BCD
    ld b, $00                                     ; $0BCF
    ld l, e                                       ; $0BD1
    ld h, d                                       ; $0BD2
    add hl, bc                                    ; $0BD3
    ld e, l                                       ; $0BD4
    ld d, h                                       ; $0BD5
    ld hl, wMode14_State01_D810                   ; $0BD6
    ld c, $0d                                     ; $0BD9

jr_000_0bdb:
    push de                                       ; $0BDB
    ld b, $04                                     ; $0BDC

jr_000_0bde:
    ld a, [de]                                    ; $0BDE
    ld [hl+], a                                   ; $0BDF
    inc de                                        ; $0BE0
    dec b                                         ; $0BE1
    jr nz, jr_000_0bde                            ; $0BE2

    pop de                                        ; $0BE4
    push hl                                       ; $0BE5
    ld l, e                                       ; $0BE6
    ld h, d                                       ; $0BE7
    ld de, $0020                                  ; $0BE8
    add hl, de                                    ; $0BEB
    ld e, l                                       ; $0BEC
    ld d, h                                       ; $0BED
    pop hl                                        ; $0BEE
    dec c                                         ; $0BEF
    jr nz, jr_000_0bdb                            ; $0BF0

    pop af                                        ; $0BF2
    ldh [hRomBankShadow], a                       ; $0BF3
    ld [$2100], a                                 ; $0BF5
    ret                                           ; $0BF8


; C: named by the code of NameCard_LoadBackgroundTiles (06:55F8); read in the runs by NameCard_LoadBackgroundTiles,
; Map_CopyColumnToD810, Mode0A_State00; first read on the screen Mode0A_NameCard_State03
; (trace/read_screens_kitty.npz)
Src_00_0BF9_NameCard_LoadBackgroundTiles::
    INCBIN "data/bank_00/Src_00_0BF9_NameCard_LoadBackgroundTiles.bin" ; $0BF9, 42 bytes
; C: HL = A x C (B = 0)
Mul_8x8::
    ld b, $00                                     ; $0C23

; C: HL = A x BC (shift and add)
Mul_8x16::
    ld hl, $0000                                  ; $0C25
    jr jr_000_0c2f                                ; $0C28

jr_000_0c2a:
    add hl, bc                                    ; $0C2A

jr_000_0c2b:
    sla c                                         ; $0C2B
    rl b                                          ; $0C2D

jr_000_0c2f:
    srl a                                         ; $0C2F
    jr c, jr_000_0c2a                             ; $0C31

    jr nz, jr_000_0c2b                            ; $0C33

    ret                                           ; $0C35


    db $f5, $c5, $cd, $23, $0c, $6c, $67, $c1, $48, $47, $f1, $18, $e5, $b8, $d2, $4a
    db $0c, $0e, $00, $c9, $6f, $af, $4f, $26, $08, $cb, $21, $cb, $25, $17, $b8, $38
    db $02, $90, $0c, $25, $20, $f3, $c9, $78, $b1, $20, $04, $11, $ff, $ff, $c9, $79
    db $2f, $4f, $78, $2f, $47, $03, $7d, $e0, $9e, $7c, $e0, $9f, $21, $00, $00, $11
    db $00, $00, $3e, $10, $f5, $cb, $23, $cb, $12, $f0, $9e, $cb, $27, $e0, $9e, $f0
    db $9f, $17, $e0, $9f, $cb, $15, $cb, $14, $e5, $09, $e1, $30, $02, $09, $13, $f1
    db $3d, $20, $e1, $c9

; C: A to BCD: B = hundreds, C = tens and units
Bin_ToBcd::
    ld bc, $0000                                  ; $0C9A
    jr jr_000_0ca0                                ; $0C9D

jr_000_0c9f:
    inc b                                         ; $0C9F

jr_000_0ca0:
    sub $64                                       ; $0CA0
    jr nc, jr_000_0c9f                            ; $0CA2

    add $64                                       ; $0CA4
    jr jr_000_0ca9                                ; $0CA6

jr_000_0ca8:
    inc c                                         ; $0CA8

jr_000_0ca9:
    sub $0a                                       ; $0CA9
    jr nc, jr_000_0ca8                            ; $0CAB

    add $0a                                       ; $0CAD
    swap c                                        ; $0CAF
    or c                                          ; $0CB1
    ld c, a                                       ; $0CB2
    ret                                           ; $0CB3


; C: C bytes of BCD at HL + DE (daa), low byte first; carry out
Bcd_Add::
    push hl                                       ; $0CB4
    push bc                                       ; $0CB5
    ld a, [hl]                                    ; $0CB6
    add e                                         ; $0CB7
    daa                                           ; $0CB8
    ld [hl+], a                                   ; $0CB9
    dec c                                         ; $0CBA
    jr z, jr_000_0cc9                             ; $0CBB

    ld a, [hl]                                    ; $0CBD
    adc d                                         ; $0CBE
    daa                                           ; $0CBF
    ld [hl+], a                                   ; $0CC0
    dec c                                         ; $0CC1
    jr z, jr_000_0cc9                             ; $0CC2

    ld a, [hl]                                    ; $0CC4
    adc $00                                       ; $0CC5
    daa                                           ; $0CC7
    ld [hl+], a                                   ; $0CC8

jr_000_0cc9:
    pop bc                                        ; $0CC9
    pop hl                                        ; $0CCA
    ret nc                                        ; $0CCB

    ld a, $99                                     ; $0CCC

jr_000_0cce:
    ld [hl+], a                                   ; $0CCE
    dec c                                         ; $0CCF
    jr nz, jr_000_0cce                            ; $0CD0

    ret                                           ; $0CD2


; C: C bytes of BCD at HL - DE (daa), low byte first; carry when negative
Bcd_Sub::
    push hl                                       ; $0CD3
    push bc                                       ; $0CD4
    ld a, [hl]                                    ; $0CD5
    sub e                                         ; $0CD6
    daa                                           ; $0CD7
    ld [hl+], a                                   ; $0CD8
    dec c                                         ; $0CD9
    jr z, jr_000_0ce8                             ; $0CDA

    ld a, [hl]                                    ; $0CDC
    sbc d                                         ; $0CDD
    daa                                           ; $0CDE
    ld [hl+], a                                   ; $0CDF
    dec c                                         ; $0CE0
    jr z, jr_000_0ce8                             ; $0CE1

    ld a, [hl]                                    ; $0CE3
    sbc $00                                       ; $0CE4
    daa                                           ; $0CE6
    ld [hl+], a                                   ; $0CE7

jr_000_0ce8:
    pop bc                                        ; $0CE8
    pop hl                                        ; $0CE9
    ret nc                                        ; $0CEA

    ld a, $00                                     ; $0CEB

jr_000_0ced:
    ld [hl+], a                                   ; $0CED
    dec c                                         ; $0CEE
    jr nz, jr_000_0ced                            ; $0CEF

    ret                                           ; $0CF1


; C: calls the mode routine of ModeTable through $01A0 every frame
Main_Loop::
    call Prn_EngineStop                           ; $0CF2

jr_000_0cf5:
    ldh a, [hMode]                                ; $0CF5
    ld hl, ModeTable                              ; $0CF7
    call FarJumpTable_ByA                         ; $0CFA
    rst Rst08_WaitVBlank                          ; $0CFD
    jr jr_000_0cf5                                ; $0CFE

; C: the 31 {lo, hi, bank} mode entries read by the main loop through $01A0 at 00:0CFD (hFF8D = mode)
ModeTable::
    dwb Mode00_BootAndTitle
    dwb Mode01_MainMenu
    dwb Mode02_TakePhotos
    dwb Mode03_ViewAlbum
    dwb Mode04_PlayMenu
    dwb Mode05_StampWindow
    dwb Mode06_Printing
    dwb Mode07_Exchange
    dwb Mode08_ExchangePhotoTrain
    dwb Mode09_ExchangeCommunicating
    dwb Mode0A_NameCard
    dwb Mode0B_NameCardEdit
    dwb Mode0C_RecordBook
    dwb Mode0D_FactoryCheck
    dwb Mode0E_KittGamesHost
    dwb Mode0F_FifteenPuzzle
    dwb Mode10_ScratchCard
    dwb Mode11_StrawberryChannel
    dwb Mode12_SlideShow
    dwb Mode13_BackToMainMenu13
    dwb Mode14_MessageScreen
    dwb Mode15_FadeOut15
    dwb Mode16_FadeOut16
    dwb Mode17_PrintError
    dwb Unused_Mode18_PompompurinPicture
    dwb Mode19_EmptyFrame19
    dwb Mode1A_EmptyFrame1A
    dwb Mode1B_PrintingAppleGame
    dwb Mode1C_EmptyFrame1C
    dwb Mode1D_BackToMainMenu1D

; C: read in the runs by FarJumpTable_ByA; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz)
FarJumpTable_ByA_Tbl0D5A::
    dwb Mode1E_ScreenFade

; C: ModeTable entry $1E: BGB screen 1E:00 (the screen fading between modes)
Mode1E_ScreenFade::
    jp Far_Return                                 ; $0D5D


    db $c9, $60, $0d

; C: same code as the Japanese Prn_SerialIrq (00:0F16, 23 bytes, masked match)
Prn_SerialIrq::
    push af                                       ; $0D63
    ldh a, [rSC]                                  ; $0D64
    bit 7, a                                      ; $0D66
    jr nz, jr_000_0d78                            ; $0D68

    push bc                                       ; $0D6A
    push de                                       ; $0D6B
    push hl                                       ; $0D6C
    ld a, $01                                     ; $0D6D
    ld [wPrnIrqSeen], a                           ; $0D6F
    call Prn_SerialStep                           ; $0D72
    pop hl                                        ; $0D75
    pop de                                        ; $0D76
    pop bc                                        ; $0D77

jr_000_0d78:
    pop af                                        ; $0D78
    reti                                          ; $0D79


; C: same code as the Japanese Prn_VBlankPoll (00:0F2D, 34 bytes, masked match)
Prn_VBlankPoll::
    ld a, [wPrnState]                             ; $0D7A
    cp $01                                        ; $0D7D
    ret nz                                        ; $0D7F

    ld a, [wPrnStatus]                            ; $0D80
    cp $ff                                        ; $0D83
    ret z                                         ; $0D85

    ld a, [wPrnTxBusy]                            ; $0D86
    and a                                         ; $0D89
    ret nz                                        ; $0D8A

    ld hl, wPrnPollCnt                            ; $0D8B
    inc [hl]                                      ; $0D8E
    ld a, [hl]                                    ; $0D8F
    cp $06                                        ; $0D90
    ret c                                         ; $0D92

    xor a                                         ; $0D93
    ld [hl], a                                    ; $0D94
    ld [wPrnBusySeen], a                          ; $0D95
    call Prn_SendInquiry                          ; $0D98
    ret                                           ; $0D9B


    db $af, $e0, $02, $e0, $01

; C: the Japanese Prn_EngineStop (00:1914), 10 instructions against 9, with 1 small edits (variables moved between
; HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Prn_EngineStop::
    xor a                                         ; $0DA1
    ldh [rSB], a                                  ; $0DA2
    ldh [rSC], a                                  ; $0DA4
    ld [wPrnState], a                             ; $0DA6
    ld [wFrame_UpdateAll_DD40], a                 ; $0DA9
    dec a                                         ; $0DAC
    ld [wPrnStatus], a                            ; $0DAD
    ld [wPrnDevId], a                             ; $0DB0
    call Prn_ClearTxFlags                         ; $0DB3
    ret                                           ; $0DB6


; C: same code as the Japanese Prn_ClearTxFlags (00:1927)
Prn_ClearTxFlags::
    xor a                                         ; $0DB7
    ld [wPrnTxPhase], a                           ; $0DB8
    ld [wPrnIrqSeen], a                           ; $0DBB
    ld [wPrnTxBusy], a                            ; $0DBE

; C: same code as the Japanese Prn_ResetPacketState (00:1931, 35 bytes, masked match)
Prn_ResetPacketState::
    xor a                                         ; $0DC1
    ld [wPrnSyncDone], a                          ; $0DC2
    ld [wPrnHdrDone], a                           ; $0DC5
    ld [wPrnDataDone], a                          ; $0DC8
    ld [wPrnChkIdx], a                            ; $0DCB
    ld [wPrnTrailCnt], a                          ; $0DCE
    ld [wPrnChecksum], a                          ; $0DD1
    ld [wPrnChecksum + $1], a                     ; $0DD4
    ld [wPrnTxIdx], a                             ; $0DD7
    ld [wPrnTxIdx + $1], a                        ; $0DDA
    ld [wPrnAbort], a                             ; $0DDD
    ld [wPrnBusySeen], a                          ; $0DE0
    ret                                           ; $0DE3


; C: same code as the Japanese Prn_SendInit (00:1954, 27 bytes, masked match)
Prn_SendInit::
    ld a, [wPrnTxBusy]                            ; $0DE4
    and a                                         ; $0DE7
    jr z, jr_000_0dee                             ; $0DE8

    call Prn_CheckTxDone                          ; $0DEA
    ret nc                                        ; $0DED

jr_000_0dee:
    ld a, [wPrnLastType]                          ; $0DEE
    cp $01                                        ; $0DF1
    jr nz, jr_000_0df9                            ; $0DF3

    call Prn_CheckTxDone                          ; $0DF5
    ret nc                                        ; $0DF8

jr_000_0df9:
    call Prn_QueueInit                            ; $0DF9
    jp Prn_StartTransmit                          ; $0DFC


; C: same code as the Japanese Prn_CheckTxDone (00:196F, 51 bytes, masked match)
Prn_CheckTxDone::
    ld a, [wPrnTxPhase]                           ; $0DFF
    cp $02                                        ; $0E02
    jr nz, jr_000_0e3e                            ; $0E04

    xor a                                         ; $0E06
    ld [wPrnPollCnt], a                           ; $0E07
    ld [wPrnLastType], a                          ; $0E0A
    inc a                                         ; $0E0D
    ld [wPrnState], a                             ; $0E0E
    ld a, [wPrnStatus]                            ; $0E11
    cp $ff                                        ; $0E14
    jr z, jr_000_0e37                             ; $0E16

    bit 0, a                                      ; $0E18
    jr nz, jr_000_0e30                            ; $0E1A

    bit 1, a                                      ; $0E1C
    jr nz, jr_000_0e30                            ; $0E1E

    bit 4, a                                      ; $0E20
    jr z, jr_000_0e3c                             ; $0E22

    xor a                                         ; $0E24
    ld [wPrnState], a                             ; $0E25
    ld [wPrnLastType], a                          ; $0E28
    ld a, [wPrnStatus]                            ; $0E2B
    jr jr_000_0e3c                                ; $0E2E

jr_000_0e30:
    scf                                           ; $0E30
    ret                                           ; $0E31


    db $af, $ea, $0d, $dd, $3d

jr_000_0e37:
    inc a                                         ; $0E37
    ld [wPrnState], a                             ; $0E38
    dec a                                         ; $0E3B

jr_000_0e3c:
    and a                                         ; $0E3C
    ret                                           ; $0E3D


jr_000_0e3e:
    xor a                                         ; $0E3E
    ld a, $f0                                     ; $0E3F
    ret                                           ; $0E41


; C: same code as the Japanese Prn_SendPrint (00:19B2, 57 bytes, masked match)
Prn_SendPrint::
    ld a, [wPrnState]                             ; $0E42
    cp $01                                        ; $0E45
    jr z, jr_000_0e54                             ; $0E47

    cp $02                                        ; $0E49
    jr z, jr_000_0e54                             ; $0E4B

    and a                                         ; $0E4D
    ld a, $ff                                     ; $0E4E
    ret z                                         ; $0E50

jr_000_0e51:
    ld a, $f0                                     ; $0E51
    ret                                           ; $0E53


jr_000_0e54:
    ld a, [wPrnBusySeen]                          ; $0E54
    and a                                         ; $0E57
    jr nz, jr_000_0e51                            ; $0E58

    ld a, [wPrnTxBusy]                            ; $0E5A
    and a                                         ; $0E5D
    jr z, jr_000_0e64                             ; $0E5E

    call Prn_CheckTxDone                          ; $0E60
    ret nc                                        ; $0E63

jr_000_0e64:
    ld a, [wPrnLastType]                          ; $0E64
    cp $02                                        ; $0E67
    jr nz, jr_000_0e6f                            ; $0E69

    call Prn_CheckTxDone                          ; $0E6B
    ret nc                                        ; $0E6E

jr_000_0e6f:
    ld a, [wPrnStatus]                            ; $0E6F
    cp $ff                                        ; $0E72
    ret z                                         ; $0E74

    call Prn_QueuePrint                           ; $0E75
    jp Prn_StartTransmit                          ; $0E78


; C: same code as the Japanese Prn_SendData (00:19EB, 96 bytes, masked match)
Prn_SendData::
    ld c, a                                       ; $0E7B
    ld a, [wPrnState]                             ; $0E7C
    and a                                         ; $0E7F
    ld a, [wPrnStatus]                            ; $0E80
    ret z                                         ; $0E83

    ld a, [wPrnState]                             ; $0E84
    cp $01                                        ; $0E87
    jr z, jr_000_0e92                             ; $0E89

    cp $03                                        ; $0E8B
    jr z, jr_000_0e92                             ; $0E8D

    ld a, $f0                                     ; $0E8F
    ret                                           ; $0E91


jr_000_0e92:
    ld a, [wPrnTxBusy]                            ; $0E92
    and a                                         ; $0E95
    jr nz, jr_000_0ee1                            ; $0E96

    ld a, c                                       ; $0E98
    inc a                                         ; $0E99
    ld [wPrnChunkCnt], a                          ; $0E9A
    ld a, l                                       ; $0E9D
    ld [wPrnBandPtrCopy], a                       ; $0E9E
    ld a, h                                       ; $0EA1
    ld [wPrnBandPtrCopy + $1], a                  ; $0EA2
    ld a, [wPrnStatus]                            ; $0EA5
    cp $ff                                        ; $0EA8
    ret z                                         ; $0EAA

    ld a, [wPrnCompEnable]                        ; $0EAB
    ld [wPrnBandCompFlag], a                      ; $0EAE
    and a                                         ; $0EB1
    jr z, jr_000_0ed8                             ; $0EB2

    ld a, [wPrnChunkCnt]                          ; $0EB4
    dec a                                         ; $0EB7
    dec a                                         ; $0EB8
    push af                                       ; $0EB9
    ld c, a                                       ; $0EBA
    ld b, $00                                     ; $0EBB
    push hl                                       ; $0EBD
    ld hl, wPrinterDc0cTable                      ; $0EBE
    add hl, bc                                    ; $0EC1
    ld a, [hl]                                    ; $0EC2
    pop hl                                        ; $0EC3
    ld [wPrnBandCompFlag], a                      ; $0EC4
    pop af                                        ; $0EC7
    add a                                         ; $0EC8
    ld c, a                                       ; $0EC9
    ld b, $00                                     ; $0ECA
    push hl                                       ; $0ECC
    ld hl, wPrinterLenTable                       ; $0ECD
    add hl, bc                                    ; $0ED0
    ld a, [hl+]                                   ; $0ED1
    ld b, [hl]                                    ; $0ED2
    pop hl                                        ; $0ED3
    ld c, a                                       ; $0ED4
    jp Jump_000_0edb                              ; $0ED5


jr_000_0ed8:
    ld bc, $0280                                  ; $0ED8

Jump_000_0edb:
    call Prn_QueueData                            ; $0EDB
    jp Prn_StartTransmit                          ; $0EDE


jr_000_0ee1:
    ld a, [wPrnTxPhase]                           ; $0EE1
    cp $02                                        ; $0EE4
    ld a, $f0                                     ; $0EE6
    jp nz, Jump_000_0f7b                          ; $0EE8

    ld hl, wPrnChunkCnt                           ; $0EEB
    ld a, [wPrnStatus]                            ; $0EEE
    bit 4, a                                      ; $0EF1
    jp nz, Prn_SendData_Abort                     ; $0EF3

    bit 1, a                                      ; $0EF6
    jp nz, Jump_000_0f13                          ; $0EF8

    bit 0, a                                      ; $0EFB
    jp nz, Jump_000_0f13                          ; $0EFD

Prn_SendData_0F00:
    ld a, [hl]                                    ; $0F00
    and a                                         ; $0F01
    ld a, [wPrnStatus]                            ; $0F02
    jr z, jr_000_0f72                             ; $0F05

    ld a, [hl]                                    ; $0F07
    cp $01                                        ; $0F08
    jp z, Jump_000_0f7c                           ; $0F0A

    dec [hl]                                      ; $0F0D
    ld a, [wPrnStatus]                            ; $0F0E
    jr z, jr_000_0f72                             ; $0F11

Jump_000_0f13:
    ld a, [hl]                                    ; $0F13
    cp $01                                        ; $0F14
    ld a, $f0                                     ; $0F16
    jp z, Jump_000_0f7b                           ; $0F18

    ld bc, $0280                                  ; $0F1B
    ld a, [wPrnCompEnable]                        ; $0F1E
    ld [wPrnBandCompFlag], a                      ; $0F21
    and a                                         ; $0F24
    jr z, jr_000_0f48                             ; $0F25

    ld a, [wPrnChunkCnt]                          ; $0F27
    dec a                                         ; $0F2A
    dec a                                         ; $0F2B
    push af                                       ; $0F2C
    ld c, a                                       ; $0F2D
    ld b, $00                                     ; $0F2E
    push hl                                       ; $0F30
    ld hl, wPrinterDc0cTable                      ; $0F31
    add hl, bc                                    ; $0F34
    ld a, [hl]                                    ; $0F35
    pop hl                                        ; $0F36
    ld [wPrnBandCompFlag], a                      ; $0F37
    pop af                                        ; $0F3A
    add a                                         ; $0F3B
    ld c, a                                       ; $0F3C
    ld b, $00                                     ; $0F3D
    push hl                                       ; $0F3F
    ld hl, wPrinterLenTable                       ; $0F40
    add hl, bc                                    ; $0F43
    ld a, [hl+]                                   ; $0F44
    ld b, [hl]                                    ; $0F45
    pop hl                                        ; $0F46
    ld c, a                                       ; $0F47

jr_000_0f48:
    ld a, [wPrnStatus]                            ; $0F48
    bit 1, a                                      ; $0F4B
    jp nz, Jump_000_0f60                          ; $0F4D

    ld a, [wPrnDataPtr]                           ; $0F50
    add $80                                       ; $0F53
    ld [wPrnDataPtr], a                           ; $0F55
    ld a, [wPrnDataPtr + $1]                      ; $0F58
    adc $02                                       ; $0F5B
    ld [wPrnDataPtr + $1], a                      ; $0F5D

Jump_000_0f60:
    ld a, [wPrnDataPtr]                           ; $0F60
    ld l, a                                       ; $0F63
    ld a, [wPrnDataPtr + $1]                      ; $0F64
    ld h, a                                       ; $0F67
    jp Jump_000_0edb                              ; $0F68


; C: same code as the Japanese Prn_SendData_Abort (00:1ACB, 16 bytes, masked match)
Prn_SendData_Abort::
    push af                                       ; $0F6B
    ld a, $01                                     ; $0F6C
    ld [wPrnAbort], a                             ; $0F6E
    pop af                                        ; $0F71

jr_000_0f72:
    push af                                       ; $0F72
    xor a                                         ; $0F73
    ld [wPrnHasData], a                           ; $0F74
    ld [wPrnTxBusy], a                            ; $0F77
    pop af                                        ; $0F7A

Jump_000_0f7b:
    ret                                           ; $0F7B


Jump_000_0f7c:
    ld a, [wPrn_SendData_Abort_DD3C]              ; $0F7C
    and a                                         ; $0F7F
    ld a, [wPrnStatus]                            ; $0F80
    jr z, jr_000_0f72                             ; $0F83

    dec [hl]                                      ; $0F85
    call Prn_QueueDataEnd                         ; $0F86
    jp Prn_StartTransmit                          ; $0F89


    db $fa, $0c, $dd, $fe, $01, $28, $0b, $fe, $03, $28, $07, $a7, $3e, $ff, $c8, $3e
    db $f0, $c9, $fa, $3a, $dd, $a7, $28, $04, $cd, $ff, $0d, $d0, $fa, $0d, $dd, $fe
    db $04, $20, $04, $cd, $ff, $0d, $d0, $fa, $26, $dd, $fe, $ff, $c8, $cd, $d0, $10
    db $c3, $f8, $10

; C: same code as the Japanese Prn_SendInquiry (00:1B1E, 40 bytes, masked match)
Prn_SendInquiry::
    ld a, [wPrnState]                             ; $0FBF
    cp $01                                        ; $0FC2
    jr z, jr_000_0fd1                             ; $0FC4

    cp $03                                        ; $0FC6
    jr z, jr_000_0fd1                             ; $0FC8

    and a                                         ; $0FCA
    ld a, $ff                                     ; $0FCB
    ret z                                         ; $0FCD

    ld a, $f0                                     ; $0FCE
    ret                                           ; $0FD0


jr_000_0fd1:
    ld a, [wPrnTxBusy]                            ; $0FD1
    and a                                         ; $0FD4
    jr z, jr_000_0fdb                             ; $0FD5

    call Prn_CheckTxDone                          ; $0FD7
    ret nc                                        ; $0FDA

jr_000_0fdb:
    ld a, [wPrnStatus]                            ; $0FDB
    cp $ff                                        ; $0FDE
    ret z                                         ; $0FE0

    call Prn_QueueInquiry                         ; $0FE1
    jp Prn_StartTransmit                          ; $0FE4


; C: same code as the Japanese Prn_QueuePacket (00:1B46, 43 bytes, masked match)
Prn_QueuePacket::
    ld [wPrnPktType], a                           ; $0FE7
    ld a, d                                       ; $0FEA
    ld [wPrnHasData], a                           ; $0FEB
    ld a, l                                       ; $0FEE
    ld [wPrnSrcPtr], a                            ; $0FEF
    ld [wPrnHdrPtr], a                            ; $0FF2
    ld a, h                                       ; $0FF5
    ld [wPrnSrcPtr + $1], a                       ; $0FF6
    ld [wPrnHdrPtr + $1], a                       ; $0FF9
    ld a, c                                       ; $0FFC
    ld [wPrnTargetLen], a                         ; $0FFD
    ld [wPrnHdrLen], a                            ; $1000
    ld a, b                                       ; $1003
    ld [wPrnTargetLen + $1], a                    ; $1004
    ld [wPrnHdrLen + $1], a                       ; $1007
    xor a                                         ; $100A
    ld [wPrnTxPhase], a                           ; $100B
    call Prn_ResetPacketState                     ; $100E
    ret                                           ; $1011


; C: the same 38 bytes as the Japanese Prn_SyncBytes (00:1B71); named by the code of Prn_StartTransmit,
; Prn_SendSyncByte (00:1124 00:1173); read in the runs by Prn_SendPacketByte, Mem_Copy, Prn_StartTransmit; first read
; on the screen Mode14_MessageScreen_State01 (trace/read_screens_kitty.npz)
Prn_SyncBytes::
    db $88, $33, $01, $00, $00, $00, $01, $00, $00, $00, $02, $00, $04, $00, $04, $00
    db $00, $00, $04, $00, $00, $00, $08, $00, $00, $00, $08, $00, $00, $00, $0f, $00
    db $00, $00, $0f, $00, $00, $00

; C: same instructions as the Japanese Prn_QueueInit (00:1B97) over the whole routine (5 instructions, to the first
; ret / jp), only the addresses differ; code compared
Prn_QueueInit::
    ld a, $01                                     ; $1038
    ld d, $00                                     ; $103A
    ld hl, $1014                                  ; $103C
    ld bc, $0008                                  ; $103F
    jp Prn_QueuePacket                            ; $1042


; C: same code as the Japanese Prn_QueuePrint (00:1BA4, 80 bytes, masked match)
Prn_QueuePrint::
    ld a, $02                                     ; $1045
    ld d, $00                                     ; $1047
    ld hl, wPrnPktBuf                             ; $1049
    ld bc, $000c                                  ; $104C
    call Prn_QueuePacket                          ; $104F
    ld hl, Prn_SyncBytes + $A                     ; $1052
    ld de, wPrnPktBuf                             ; $1055
    ld bc, $0004                                  ; $1058
    call Mem_Copy                                 ; $105B
    ld de, $0006                                  ; $105E
    ld a, [wPrnSheets]                            ; $1061
    ld [wPrnPktBuf + $4], a                       ; $1064
    call Prn_AddToChecksumDE                      ; $1067
    ld a, [wPrnMargin]                            ; $106A
    ld [wPrnPktBuf + $5], a                       ; $106D
    call Prn_AddToChecksumDE                      ; $1070
    ld a, [wPrnPalette]                           ; $1073
    ld [wPrnPktBuf + $6], a                       ; $1076
    call Prn_AddToChecksumDE                      ; $1079
    ld a, [wPrintIntensity]                       ; $107C
    ld [wPrnPktBuf + $7], a                       ; $107F
    call Prn_AddToChecksumDE                      ; $1082
    ld a, e                                       ; $1085
    ld [wPrnPktBuf + $8], a                       ; $1086
    ld a, d                                       ; $1089
    ld [wPrnPktBuf + $9], a                       ; $108A
    xor a                                         ; $108D
    ld [wPrnPktBuf + $a], a                       ; $108E
    ld [wPrnPktBuf + $b], a                       ; $1091
    ret                                           ; $1094


; C: same code as the Japanese Prn_AddToChecksumDE (00:1BF4)
Prn_AddToChecksumDE::
    add e                                         ; $1095
    ld e, a                                       ; $1096
    ld a, d                                       ; $1097
    adc $00                                       ; $1098
    ld d, a                                       ; $109A
    ret                                           ; $109B


; C: same code as the Japanese Prn_QueueData (00:1BFB, 52 bytes, masked match)
Prn_QueueData::
    ld a, l                                       ; $109C
    ld [wPrnDataPtr], a                           ; $109D
    ld a, h                                       ; $10A0
    ld [wPrnDataPtr + $1], a                      ; $10A1
    ld a, c                                       ; $10A4
    ld [wPrnDataLen], a                           ; $10A5
    ld a, b                                       ; $10A8
    ld [wPrnDataLen + $1], a                      ; $10A9
    push bc                                       ; $10AC
    ld a, $03                                     ; $10AD
    ld d, $01                                     ; $10AF
    ld hl, wPrnPktBuf                             ; $10B1
    ld bc, $0004                                  ; $10B4
    call Prn_QueuePacket                          ; $10B7
    ld a, [Prn_SyncBytes + $E]                    ; $10BA
    ld [wPrnPktBuf], a                            ; $10BD
    ld a, [wPrnBandCompFlag]                      ; $10C0
    ld [wPrnPktBuf + $1], a                       ; $10C3
    pop bc                                        ; $10C6
    ld a, c                                       ; $10C7
    ld [wPrnPktBuf + $2], a                       ; $10C8
    ld a, b                                       ; $10CB
    ld [wPrnPktBuf + $3], a                       ; $10CC
    ret                                           ; $10CF


    db $3e, $04, $16, $00, $21, $28, $10, $01, $08, $00, $c3, $e7, $0f

; C: same instructions as the Japanese Prn_QueueInquiry (00:1C3C) over the whole routine (5 instructions, to the first
; ret / jp), only the addresses differ; code compared
Prn_QueueInquiry::
    ld a, $05                                     ; $10DD
    ld d, $00                                     ; $10DF
    ld hl, $1030                                  ; $10E1
    ld bc, $0008                                  ; $10E4
    jp Prn_QueuePacket                            ; $10E7


; C: same instructions as the Japanese Prn_QueueDataEnd (00:1C49) over the whole routine (5 instructions, to the first
; ret / jp), only the addresses differ; code compared
Prn_QueueDataEnd::
    ld a, $06                                     ; $10EA
    ld d, $01                                     ; $10EC
    ld hl, $1020                                  ; $10EE
    ld bc, $0008                                  ; $10F1
    jp Prn_QueuePacket                            ; $10F4


    db $c9

; C: same code as the Japanese Prn_StartTransmit (00:1C57, 60 bytes, masked match)
Prn_StartTransmit::
    ld a, [wPrnState]                             ; $10F8
    cp $01                                        ; $10FB
    jr z, jr_000_110b                             ; $10FD

    and a                                         ; $10FF
    jr nz, jr_000_1109                            ; $1100

    ld a, [wPrnPktType]                           ; $1102
    cp $01                                        ; $1105
    jr z, jr_000_1115                             ; $1107

jr_000_1109:
    scf                                           ; $1109
    ret                                           ; $110A


jr_000_110b:
    ld a, [wPrnPktType]                           ; $110B
    cp $01                                        ; $110E
    jr z, jr_000_1109                             ; $1110

    ld [wPrnState], a                             ; $1112

jr_000_1115:
    xor a                                         ; $1115
    ld [wPrnTxPhase], a                           ; $1116
    ld [wPrnLastType], a                          ; $1119
    ld a, $01                                     ; $111C
    ld [wPrnTxIdx], a                             ; $111E
    ld [wPrnTxBusy], a                            ; $1121
    ld a, [Prn_SyncBytes]                         ; $1124
    ldh [rSB], a                                  ; $1127
    ld a, SCF_SOURCE                              ; $1129
    ldh [rSC], a                                  ; $112B
    ld a, SCF_START | SCF_SOURCE                  ; $112D
    ldh [rSC], a                                  ; $112F
    ld a, $f0                                     ; $1131
    ret                                           ; $1133


; C: the Japanese Prn_SerialStep (00:176F), 11 instructions against 11, with 1 small edits (variables moved between
; HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Prn_SerialStep::
    ld a, [wPrnAbort]                             ; $1134
    and a                                         ; $1137
    jp nz, Jump_000_12c8                          ; $1138

    ld a, [wPrnState]                             ; $113B
    cp $07                                        ; $113E
    jp z, Prn_ReceiveStatus                       ; $1140

    ld a, [wPrnSyncDone]                          ; $1143
    and a                                         ; $1146
    jr nz, jr_000_114d                            ; $1147

    call Prn_SendSyncByte                         ; $1149
    ret                                           ; $114C


jr_000_114d:
    ld a, [wPrnHdrDone]                           ; $114D
    and a                                         ; $1150
    jr z, jr_000_1168                             ; $1151

    ld a, [wPrnDataDone]                          ; $1153
    and a                                         ; $1156
    jr z, jr_000_1168                             ; $1157

    ld a, [wPrnChkIdx]                            ; $1159
    cp $02                                        ; $115C
    jr z, jr_000_1164                             ; $115E

    call Prn_SendChecksumByte                     ; $1160
    ret                                           ; $1163


jr_000_1164:
    call Prn_SendTrailerByte                      ; $1164
    ret                                           ; $1167


jr_000_1168:
    call Prn_SendPacketByte                       ; $1168
    ret                                           ; $116B


; C: same code as the Japanese Prn_SendSyncByte (00:17AD, 37 bytes, masked match)
Prn_SendSyncByte::
    ld hl, wPrnTxIdx                              ; $116C
    ld c, [hl]                                    ; $116F
    inc [hl]                                      ; $1170
    ld b, $00                                     ; $1171
    ld hl, Prn_SyncBytes                          ; $1173
    add hl, bc                                    ; $1176
    ld a, [hl]                                    ; $1177
    ldh [rSB], a                                  ; $1178
    ld a, SCF_SOURCE                              ; $117A
    ldh [rSC], a                                  ; $117C
    ld a, SCF_START | SCF_SOURCE                  ; $117E
    ldh [rSC], a                                  ; $1180
    ld a, [wPrnTxIdx]                             ; $1182
    cp $02                                        ; $1185
    ret nz                                        ; $1187

    xor a                                         ; $1188
    ld [wPrnTxIdx], a                             ; $1189
    inc a                                         ; $118C
    ld [wPrnSyncDone], a                          ; $118D
    ret                                           ; $1190


; C: the Japanese Prn_SendPacketByte (00:17D2), 38 instructions against 38, with 1 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Prn_SendPacketByte::
    ld a, [wPrnTxIdx]                             ; $1191
    ld c, a                                       ; $1194
    ld a, [wPrnTxIdx + $1]                        ; $1195
    ld b, a                                       ; $1198
    ld a, [wPrnSrcPtr]                            ; $1199
    ld l, a                                       ; $119C
    ld a, [wPrnSrcPtr + $1]                       ; $119D
    ld h, a                                       ; $11A0
    add hl, bc                                    ; $11A1
    ldh a, [rSB]                                  ; $11A2
    ld [wPrnPrevRx], a                            ; $11A4
    ld a, [hl]                                    ; $11A7
    ldh [rSB], a                                  ; $11A8
    ld l, a                                       ; $11AA
    ld a, [wPrnChecksum]                          ; $11AB
    add l                                         ; $11AE
    ld [wPrnChecksum], a                          ; $11AF
    ld a, [wPrnChecksum + $1]                     ; $11B2
    adc $00                                       ; $11B5
    ld [wPrnChecksum + $1], a                     ; $11B7
    ld a, SCF_SOURCE                              ; $11BA
    ldh [rSC], a                                  ; $11BC
    ld a, SCF_START | SCF_SOURCE                  ; $11BE
    ldh [rSC], a                                  ; $11C0
    ld hl, wPrnTxIdx                              ; $11C2
    inc [hl]                                      ; $11C5
    jr nz, jr_000_11ca                            ; $11C6

    inc hl                                        ; $11C8
    inc [hl]                                      ; $11C9

jr_000_11ca:
    ld hl, wPrnTxIdx                              ; $11CA
    ld a, [wPrnTargetLen]                         ; $11CD
    cp [hl]                                       ; $11D0
    jr nz, jr_000_11da                            ; $11D1

    inc hl                                        ; $11D3
    ld a, [wPrnTargetLen + $1]                    ; $11D4
    cp [hl]                                       ; $11D7
    jr z, jr_000_11db                             ; $11D8

jr_000_11da:
    ret                                           ; $11DA


jr_000_11db:
    ld hl, wPrnHdrDone                            ; $11DB
    ld a, [hl]                                    ; $11DE
    and a                                         ; $11DF
    jr z, jr_000_11e5                             ; $11E0

    ld hl, wPrnDataDone                           ; $11E2

jr_000_11e5:
    inc [hl]                                      ; $11E5
    ld a, [wPrnHasData]                           ; $11E6
    and a                                         ; $11E9
    jr z, jr_000_121e                             ; $11EA

    ld a, [wPrnState]                             ; $11EC
    cp $06                                        ; $11EF
    jr z, jr_000_121e                             ; $11F1

    ld hl, wPrnDataDone                           ; $11F3
    ld a, [hl]                                    ; $11F6
    and a                                         ; $11F7
    jr nz, jr_000_121a                            ; $11F8

    xor a                                         ; $11FA
    ld [wPrnTxIdx], a                             ; $11FB
    ld [wPrnTxIdx + $1], a                        ; $11FE
    ld a, [wPrnDataPtr]                           ; $1201
    ld [wPrnSrcPtr], a                            ; $1204
    ld a, [wPrnDataPtr + $1]                      ; $1207
    ld [wPrnSrcPtr + $1], a                       ; $120A
    ld a, [wPrnDataLen]                           ; $120D
    ld [wPrnTargetLen], a                         ; $1210
    ld a, [wPrnDataLen + $1]                      ; $1213
    ld [wPrnTargetLen + $1], a                    ; $1216
    ret                                           ; $1219


jr_000_121a:
    call Prn_RestoreHeaderPtr                     ; $121A
    ret                                           ; $121D


jr_000_121e:
    ld a, [wPrnPrevRx]                            ; $121E
    ld [wPrnDevId], a                             ; $1221

jr_000_1224:
    ld a, $07                                     ; $1224
    ld [wPrnState], a                             ; $1226
    ld a, $01                                     ; $1229
    ld [wPrnTxPhase], a                           ; $122B
    call Prn_ResetPacketState                     ; $122E

; C: same code as the Japanese Prn_RestoreHeaderPtr (00:1873)
Prn_RestoreHeaderPtr::
    ld a, [wPrnHdrLen]                            ; $1231
    ld [wPrnTargetLen], a                         ; $1234
    ld a, [wPrnHdrLen + $1]                       ; $1237
    ld [wPrnTargetLen + $1], a                    ; $123A
    ld a, [wPrnHdrPtr]                            ; $123D
    ld [wPrnSrcPtr], a                            ; $1240
    ld a, [wPrnHdrPtr + $1]                       ; $1243
    ld [wPrnSrcPtr + $1], a                       ; $1246
    ret                                           ; $1249


; C: same code as the Japanese Prn_SendChecksumByte (00:188C, 23 bytes, masked match)
Prn_SendChecksumByte::
    ld c, a                                       ; $124A
    ld b, $00                                     ; $124B
    ld hl, wPrnChecksum                           ; $124D
    add hl, bc                                    ; $1250
    ld a, [hl]                                    ; $1251
    ldh [rSB], a                                  ; $1252
    ld a, SCF_SOURCE                              ; $1254
    ldh [rSC], a                                  ; $1256
    ld a, SCF_START | SCF_SOURCE                  ; $1258
    ldh [rSC], a                                  ; $125A
    ld hl, wPrnChkIdx                             ; $125C
    inc [hl]                                      ; $125F
    ret                                           ; $1260


; C: same code as the Japanese Prn_SendTrailerByte (00:18A3, 26 bytes, masked match)
Prn_SendTrailerByte::
    ldh a, [rSB]                                  ; $1261
    ld [wPrnDevId], a                             ; $1263
    xor a                                         ; $1266
    ldh [rSB], a                                  ; $1267
    ld a, SCF_SOURCE                              ; $1269
    ldh [rSC], a                                  ; $126B
    ld a, SCF_START | SCF_SOURCE                  ; $126D
    ldh [rSC], a                                  ; $126F
    ld hl, wPrnTrailCnt                           ; $1271
    inc [hl]                                      ; $1274
    ld a, [hl]                                    ; $1275
    cp $02                                        ; $1276
    jr z, jr_000_1224                             ; $1278

    ret                                           ; $127A


; C: same code as the Japanese Prn_ReceiveStatus (00:18BD, 77 bytes, masked match)
Prn_ReceiveStatus::
    ld a, [wPrnPktType]                           ; $127B
    ld [wPrnLastType], a                          ; $127E
    ld a, [wPrnStatus]                            ; $1281
    ld [wPrinterPrevStatus + $1], a               ; $1284
    cp $ff                                        ; $1287
    jr z, jr_000_128e                             ; $1289

    ld [wPrinterPrevStatus], a                    ; $128B

jr_000_128e:
    ldh a, [rSB]                                  ; $128E
    ld [wPrnStatus], a                            ; $1290
    cp $ff                                        ; $1293
    jr nz, jr_000_12a3                            ; $1295

    ld a, $00                                     ; $1297
    ld [wPrnTxBusy], a                            ; $1299
    ld [wPrnState], a                             ; $129C
    ld a, $02                                     ; $129F
    jr jr_000_12bb                                ; $12A1

jr_000_12a3:
    bit 1, a                                      ; $12A3
    jr z, jr_000_12ac                             ; $12A5

    ld a, $01                                     ; $12A7
    ld [wPrnBusySeen], a                          ; $12A9

jr_000_12ac:
    bit 4, a                                      ; $12AC
    ld a, $00                                     ; $12AE
    ld [wPrnState], a                             ; $12B0
    ld a, $01                                     ; $12B3
    jr nz, jr_000_12ba                            ; $12B5

    ld [wPrnState], a                             ; $12B7

jr_000_12ba:
    inc a                                         ; $12BA

jr_000_12bb:
    ld [wPrnTxPhase], a                           ; $12BB
    ld a, [wPrnHasData]                           ; $12BE
    and a                                         ; $12C1
    jr nz, jr_000_12c8                            ; $12C2

    xor a                                         ; $12C4
    ld [wPrnTxBusy], a                            ; $12C5

Jump_000_12c8:
jr_000_12c8:
    ret                                           ; $12C8


; C: same code as the Japanese Link_SerialIrq (00:2AE9, 81 bytes, masked match)
Link_SerialIrq::
    push af                                       ; $12C9
    push bc                                       ; $12CA
    push de                                       ; $12CB
    push hl                                       ; $12CC
    ld a, [wLnkConnected]                         ; $12CD
    and a                                         ; $12D0
    jp nz, Link_Irq_Connected                     ; $12D1

    ld a, [wLnkStage]                             ; $12D4
    and a                                         ; $12D7
    jr nz, Link_Irq_InfoStage                     ; $12D8

    ldh a, [rSB]                                  ; $12DA
    cp $12                                        ; $12DC
    jr z, jr_000_1305                             ; $12DE

    cp $55                                        ; $12E0
    jr z, jr_000_1300                             ; $12E2

    cp $29                                        ; $12E4
    jr nz, jr_000_12ee                            ; $12E6

    ld a, [wLnkInitiator]                         ; $12E8
    and a                                         ; $12EB
    jr z, jr_000_130d                             ; $12EC

jr_000_12ee:
    xor a                                         ; $12EE
    ld [wLnkTurn], a                              ; $12EF
    ld [wLnkInitiator], a                         ; $12F2
    ld a, $12                                     ; $12F5
    ldh [rSB], a                                  ; $12F7
    ld a, SCF_START                               ; $12F9
    ldh [rSC], a                                  ; $12FB
    jp Jump_000_152b                              ; $12FD


jr_000_1300:
    ld a, $01                                     ; $1300
    ld [wLnkFlag55], a                            ; $1302

jr_000_1305:
    ld a, $01                                     ; $1305
    ld [wLnkInitiator], a                         ; $1307
    ld [wLnkTurn], a                              ; $130A

jr_000_130d:
    ld a, $01                                     ; $130D
    ld [wLnkStage], a                             ; $130F
    ld a, [wLnkInfoTx]                            ; $1312
    ldh [rSB], a                                  ; $1315
    jp Link_Irq_StartTimer                        ; $1317


; C: same code as the Japanese Link_Irq_InfoStage (00:2B3A, 140 bytes, masked match)
Link_Irq_InfoStage::
    ldh a, [rSB]                                  ; $131A
    ld [wLnkInfoRx], a                            ; $131C
    and $1f                                       ; $131F
    ld [wLnkPeerCount], a                         ; $1321
    ld a, $01                                     ; $1324
    ld [wLnkRoleRx], a                            ; $1326
    ld a, [wLnkInitiator]                         ; $1329
    and a                                         ; $132C
    jr nz, jr_000_133c                            ; $132D

    ld a, [wLnkInfoRx]                            ; $132F
    and $80                                       ; $1332
    jr z, jr_000_1343                             ; $1334

    xor a                                         ; $1336
    ld [wLnkRoleRx], a                            ; $1337
    jr jr_000_1362                                ; $133A

jr_000_133c:
    ld a, [wLnkOwnCount]                          ; $133C
    and $80                                       ; $133F
    jr z, jr_000_1362                             ; $1341

jr_000_1343:
    ld a, [wLnkPeerCount]                         ; $1343
    and $3f                                       ; $1346
    jr z, jr_000_135a                             ; $1348

    ld a, [wLnkInfoTx]                            ; $134A
    and $40                                       ; $134D
    and a                                         ; $134F
    jr z, jr_000_1384                             ; $1350

    ld a, $01                                     ; $1352
    ld [wLnkAbortReason], a                       ; $1354
    jp Jump_000_14cf                              ; $1357


jr_000_135a:
    ld a, $03                                     ; $135A
    ld [wLnkAbortReason], a                       ; $135C
    jp Jump_000_14cf                              ; $135F


jr_000_1362:
    xor a                                         ; $1362
    ld [wLnkRoleRx], a                            ; $1363
    ld a, [wLnkOwnCount]                          ; $1366
    and $3f                                       ; $1369
    jr z, jr_000_137c                             ; $136B

    ld a, [wLnkInfoRx]                            ; $136D
    and $40                                       ; $1370
    jr z, jr_000_1384                             ; $1372

    ld a, $02                                     ; $1374
    ld [wLnkAbortReason], a                       ; $1376
    jp Jump_000_14cf                              ; $1379


jr_000_137c:
    ld a, $04                                     ; $137C
    ld [wLnkAbortReason], a                       ; $137E
    jp Jump_000_14cf                              ; $1381


jr_000_1384:
    ld a, $01                                     ; $1384
    ld [wLnkConnected], a                         ; $1386
    xor a                                         ; $1389
    ld [wLnkEnded], a                             ; $138A
    ldh [rSB], a                                  ; $138D
    ld a, $ff                                     ; $138F
    ld [wLnkIndex], a                             ; $1391
    ld [wLnkIndex + $1], a                        ; $1394
    ld a, SCF_START                               ; $1397
    ldh [rSC], a                                  ; $1399
    ld a, [wLnkTurn]                              ; $139B
    xor $01                                       ; $139E
    ld [wLnkTurn], a                              ; $13A0
    jp Jump_000_152b                              ; $13A3


; C: same code as the Japanese Link_Irq_Connected (00:2BC6, 194 bytes, masked match)
Link_Irq_Connected::
    ld a, [wLnkStage]                             ; $13A6
    and a                                         ; $13A9
    jp z, Link_Irq_BulkData                       ; $13AA

    inc a                                         ; $13AD
    ld [wLnkStage], a                             ; $13AE
    cp $03                                        ; $13B1
    jr z, jr_000_1401                             ; $13B3

    cp $04                                        ; $13B5
    jr z, jr_000_13cc                             ; $13B7

    ld a, [wLnkCmdTx]                             ; $13B9
    cp $ef                                        ; $13BC
    jr nz, jr_000_13c3                            ; $13BE

    ld [wLnkCancelSent], a                        ; $13C0

jr_000_13c3:
    ldh [rSB], a                                  ; $13C3
    xor a                                         ; $13C5
    ld [wLnkHalfDone], a                          ; $13C6
    jp Link_Irq_StartTimer                        ; $13C9


jr_000_13cc:
    dec a                                         ; $13CC
    ld [wLnkStage], a                             ; $13CD
    ld a, [wLnkReadySent]                         ; $13D0
    and a                                         ; $13D3
    jr z, jr_000_13d8                             ; $13D4

    jr jr_000_13dd                                ; $13D6

jr_000_13d8:
    ldh a, [rSB]                                  ; $13D8
    and a                                         ; $13DA
    jr z, jr_000_13f0                             ; $13DB

jr_000_13dd:
    cp $ef                                        ; $13DD
    ld a, $00                                     ; $13DF
    ld [wLnkStage], a                             ; $13E1
    ld [wLnkReadySent], a                         ; $13E4
    ld [wLnkReadyTx], a                           ; $13E7
    jp z, Link_Irq_HalfDone                       ; $13EA

    jp Link_Irq_StartTimer                        ; $13ED


jr_000_13f0:
    ld a, [wLnkReadyTx]                           ; $13F0
    and a                                         ; $13F3
    jr z, jr_000_13f9                             ; $13F4

    ld [wLnkReadySent], a                         ; $13F6

jr_000_13f9:
    ld a, [wLnkReadyTx]                           ; $13F9
    ldh [rSB], a                                  ; $13FC
    jp Link_Irq_StartTimer                        ; $13FE


jr_000_1401:
    ldh a, [rSB]                                  ; $1401
    ld [wLnkCmdRx], a                             ; $1403
    cp $ef                                        ; $1406
    ld a, $00                                     ; $1408
    jp z, Link_Irq_Abort_ClearState               ; $140A

    ld a, [wLnkCancelSent]                        ; $140D
    and a                                         ; $1410
    jr z, jr_000_141b                             ; $1411

    ld [wLnkCmdRx], a                             ; $1413
    ld a, $00                                     ; $1416
    jp Link_Irq_Abort_ClearState                  ; $1418


jr_000_141b:
    xor a                                         ; $141B
    ldh [rSB], a                                  ; $141C
    ld a, [wLnkInitiator]                         ; $141E
    and a                                         ; $1421
    jr z, jr_000_144b                             ; $1422

    ld a, [wLnkCmdTx]                             ; $1424
    and $80                                       ; $1427
    jr z, jr_000_143b                             ; $1429

    ld a, $08                                     ; $142B
    ld [wLnkPages], a                             ; $142D
    ld a, [wLnkCmdRx]                             ; $1430
    and $3f                                       ; $1433
    ld [wLnkSlot], a                              ; $1435
    jp Link_Irq_StartTimer                        ; $1438


jr_000_143b:
    ld a, $10                                     ; $143B
    ld [wLnkPages], a                             ; $143D
    ld a, [wLnkCmdRx]                             ; $1440
    and $3f                                       ; $1443
    ld [wLnkSlot], a                              ; $1445
    jp Link_Irq_StartTimer                        ; $1448


jr_000_144b:
    ld a, [wLnkCmdRx]                             ; $144B
    ld b, a                                       ; $144E
    and $80                                       ; $144F
    jr z, jr_000_145a                             ; $1451

    ld a, $08                                     ; $1453
    ld [wLnkPages], a                             ; $1455
    jr jr_000_145f                                ; $1458

jr_000_145a:
    ld a, $10                                     ; $145A
    ld [wLnkPages], a                             ; $145C

jr_000_145f:
    ld a, b                                       ; $145F
    and $3f                                       ; $1460
    ld [wLnkSlot], a                              ; $1462
    jp Link_Irq_StartTimer                        ; $1465


; C: same code as the Japanese Link_Irq_BulkData (00:2C88, 63 bytes, masked match)
Link_Irq_BulkData::
    ld a, [wLnkRxBase]                            ; $1468
    ld h, a                                       ; $146B
    ld a, [wLnkRxBase + $1]                       ; $146C
    ld l, a                                       ; $146F
    ld a, [wLnkIndex + $1]                        ; $1470
    ld e, a                                       ; $1473
    ld a, [wLnkIndex]                             ; $1474
    ld d, a                                       ; $1477
    cp $ff                                        ; $1478
    jr z, jr_000_1480                             ; $147A

    add hl, de                                    ; $147C
    ldh a, [rSB]                                  ; $147D
    ld [hl], a                                    ; $147F

jr_000_1480:
    inc de                                        ; $1480
    ld a, [wLnkTxBase]                            ; $1481
    ld h, a                                       ; $1484
    ld a, [wLnkTxBase + $1]                       ; $1485
    ld l, a                                       ; $1488
    add hl, de                                    ; $1489
    ld a, [hl]                                    ; $148A
    ldh [rSB], a                                  ; $148B
    ld a, d                                       ; $148D
    ld [wLnkIndex], a                             ; $148E
    ld a, e                                       ; $1491
    ld [wLnkIndex + $1], a                        ; $1492
    ld a, [wLnkIndex]                             ; $1495
    ld b, a                                       ; $1498
    ld a, [wLnkPages]                             ; $1499
    cp b                                          ; $149C
    jp nz, Link_Irq_StartTimer                    ; $149D

    ld a, [wLnkPages]                             ; $14A0
    cp $10                                        ; $14A3
    jr z, jr_000_14cf                             ; $14A5

; C: same code as the Japanese Link_Irq_HalfDone (00:2CC7, 40 bytes, masked match)
Link_Irq_HalfDone::
    xor a                                         ; $14A7
    ld [wLnkCmdArmed], a                          ; $14A8
    ld [wLnkPages], a                             ; $14AB
    ld [wLnkCmdTx], a                             ; $14AE
    ld [wLnkCmdRx], a                             ; $14B1
    dec a                                         ; $14B4
    ld [wLnkIndex], a                             ; $14B5
    ld [wLnkIndex + $1], a                        ; $14B8
    ld a, $01                                     ; $14BB
    ld [wLnkHalfDone], a                          ; $14BD
    ld [wLnkStage], a                             ; $14C0
    ld a, SCF_START                               ; $14C3
    ldh [rSC], a                                  ; $14C5
    ld a, [wLnkInitiator]                         ; $14C7
    ld [wLnkTurn], a                              ; $14CA
    jr jr_000_152b                                ; $14CD

Jump_000_14cf:
jr_000_14cf:
    xor a                                         ; $14CF
    ld [wLnkCmdRx], a                             ; $14D0

; C: same code as the Japanese Link_Irq_Abort_ClearState (00:2CF3, 66 bytes, masked match)
Link_Irq_Abort_ClearState::
    ld [wLnkConnected], a                         ; $14D3
    ld [wLnkTurn], a                              ; $14D6
    ld [wLnkInitiator], a                         ; $14D9
    ld [wLnkRxBase], a                            ; $14DC
    ld [wLnkRxBase + $1], a                       ; $14DF
    ld [wLnkTxBase], a                            ; $14E2
    ld [wLnkTxBase + $1], a                       ; $14E5
    ld [wLnkCmdArmed], a                          ; $14E8
    ld [wLnkCmdTx], a                             ; $14EB
    ld [wLnkOwnCount], a                          ; $14EE
    ld [wLnkPeerCount], a                         ; $14F1
    ld [wLnkFlag55], a                            ; $14F4
    ld [wLnkCancelSent], a                        ; $14F7
    ld [wLnkStage], a                             ; $14FA
    ldh [rSB], a                                  ; $14FD
    ldh [rSC], a                                  ; $14FF
    dec a                                         ; $1501
    ld [wLnkIndex], a                             ; $1502
    ld [wLnkIndex + $1], a                        ; $1505
    ldh a, [rIE]                                  ; $1508
    and $f3                                       ; $150A
    ldh [rIE], a                                  ; $150C
    ld a, $01                                     ; $150E
    ld [wLnkEnded], a                             ; $1510
    jr jr_000_152b                                ; $1513

; C: same code as the Japanese Link_Irq_StartTimer (00:2D35, 22 bytes, masked match)
Link_Irq_StartTimer::
    ld a, SCF_START                               ; $1515
    ldh [rSC], a                                  ; $1517
    ld a, [wLnkTurn]                              ; $1519
    xor $01                                       ; $151C
    ld [wLnkTurn], a                              ; $151E
    ld a, [wLnkTurn]                              ; $1521
    and a                                         ; $1524
    jr z, jr_000_152b                             ; $1525

    ld a, $06                                     ; $1527
    ldh [rTAC], a                                 ; $1529

Jump_000_152b:
jr_000_152b:
    pop hl                                        ; $152B
    pop de                                        ; $152C
    pop bc                                        ; $152D
    pop af                                        ; $152E
    reti                                          ; $152F


; C: same instructions as the Japanese Link_TimerIrq (00:2D50) over the whole routine (9 instructions, to the first
; ret / jp), only the addresses differ; code compared
Link_TimerIrq::
    push af                                       ; $1530
    ld a, $02                                     ; $1531
    ldh [rTAC], a                                 ; $1533
    ld a, $ee                                     ; $1535
    ldh [rTIMA], a                                ; $1537
    ld a, SCF_START | SCF_SOURCE                  ; $1539
    ldh [rSC], a                                  ; $153B
    pop af                                        ; $153D
    reti                                          ; $153E


; C: same code as the Japanese Link_Init (00:2D5F, 121 bytes, masked match)
Link_Init::
    ld a, $10                                     ; $153F
    ld [wLnkPages], a                             ; $1541
    ld a, $12                                     ; $1544
    ldh [rSB], a                                  ; $1546
    ld a, SCF_START                               ; $1548
    ldh [rSC], a                                  ; $154A
    xor a                                         ; $154C
    ld [wLnkTurn], a                              ; $154D
    ld [wLnkConnected], a                         ; $1550
    ld [wLnkInitiator], a                         ; $1553
    ld [wLnkCmdArmed], a                          ; $1556
    ld [wLnkIndex], a                             ; $1559
    ld [wLnkIndex + $1], a                        ; $155C
    ld [wLnkEnded], a                             ; $155F
    ld [wLnkHalfDone], a                          ; $1562
    ld [wLnkAbortReason], a                       ; $1565
    ld [wLnkStage], a                             ; $1568
    ld [wLnkRoleRx], a                            ; $156B
    ld [wLnkAlbumFull], a                         ; $156E
    ld [wLnkInfoTx], a                            ; $1571
    ld [wLnkOwnCount], a                          ; $1574
    ld [wLnkCmdTx], a                             ; $1577
    ld [wLnkInfoRx], a                            ; $157A
    ld [wLnkPeerCount], a                         ; $157D
    ld [wLnkCmdRx], a                             ; $1580
    ld [wLnkSlot], a                              ; $1583
    ld [wLnkReadyTx], a                           ; $1586
    ld [wLnkReadySent], a                         ; $1589
    ld [wLnkFlag55], a                            ; $158C
    ld [wLnkCancelSent], a                        ; $158F
    ld a, $c0                                     ; $1592
    ld [wLnkRxBase], a                            ; $1594
    ld a, $00                                     ; $1597
    ld [wLnkRxBase + $1], a                       ; $1599
    ld hl, wLinkBuffer                            ; $159C
    ld a, h                                       ; $159F
    ld [wLnkTxBase], a                            ; $15A0
    ld a, l                                       ; $15A3
    ld [wLnkTxBase + $1], a                       ; $15A4
    ld a, $ee                                     ; $15A7
    ldh [rTMA], a                                 ; $15A9
    ldh [rTIMA], a                                ; $15AB
    ld a, $02                                     ; $15AD
    ldh [rTAC], a                                 ; $15AF
    ldh a, [rIE]                                  ; $15B1
    or $0c                                        ; $15B3
    ldh [rIE], a                                  ; $15B5
    ret                                           ; $15B7


; C: same code as the Japanese Link_Stop (00:2DD8, 21 bytes, masked match)
Link_Stop::
    xor a                                         ; $15B8
    ldh [rSB], a                                  ; $15B9
    ld a, [wLnkStage]                             ; $15BB
    and a                                         ; $15BE
    ret nz                                        ; $15BF

    ldh [rSC], a                                  ; $15C0
    ld [wLnkPages], a                             ; $15C2
    ldh a, [rIE]                                  ; $15C5
    and $f3                                       ; $15C7
    ldh [rIE], a                                  ; $15C9
    xor a                                         ; $15CB
    ret                                           ; $15CC


; C: same code as the Japanese Link_SendHello29 (00:2DED, 33 bytes, masked match)
Link_SendHello29::
    ld a, [wLnkStage]                             ; $15CD
    and a                                         ; $15D0
    ret nz                                        ; $15D1

    ld a, [wLnkAlbumFull]                         ; $15D2
    and a                                         ; $15D5
    jr z, jr_000_15da                             ; $15D6

    ld a, $40                                     ; $15D8

jr_000_15da:
    ld c, a                                       ; $15DA
    ld a, [wLnkOwnCount]                          ; $15DB
    or c                                          ; $15DE
    ld [wLnkInfoTx], a                            ; $15DF
    ld a, $29                                     ; $15E2
    ldh [rSB], a                                  ; $15E4
    ld a, SCF_START | SCF_SOURCE                  ; $15E6
    ldh [rSC], a                                  ; $15E8
    ld [wLnkInitiator], a                         ; $15EA
    ret                                           ; $15ED


; C: same code as the Japanese Link_QueueCommand (00:2E0E, 51 bytes, masked match)
Link_QueueCommand::
    ld a, [wLnkInitiator]                         ; $15EE
    and a                                         ; $15F1
    ret z                                         ; $15F2

    ld a, [wLnkCmdArmed]                          ; $15F3
    and a                                         ; $15F6
    ret nz                                        ; $15F7

    ld a, [wLnkTurn]                              ; $15F8
    and a                                         ; $15FB
    ret z                                         ; $15FC

    ld hl, wLinkBuffer                            ; $15FD
    ld a, h                                       ; $1600
    ld [wLnkTxBase], a                            ; $1601
    ld a, l                                       ; $1604
    ld [wLnkTxBase + $1], a                       ; $1605
    ld a, [wLnkCmdTx]                             ; $1608
    cp $ef                                        ; $160B
    jr z, jr_000_1619                             ; $160D

    ld a, [wLnkSlot]                              ; $160F
    ld b, a                                       ; $1612
    ld a, $40                                     ; $1613
    or b                                          ; $1615
    ld [wLnkCmdTx], a                             ; $1616

jr_000_1619:
    ld a, SCF_START | SCF_SOURCE                  ; $1619
    ldh [rSC], a                                  ; $161B
    ld [wLnkCmdArmed], a                          ; $161D
    ret                                           ; $1620


; C: same code as the Japanese Link_QueuePageRequest (00:2E41, 39 bytes, masked match)
Link_QueuePageRequest::
    ld a, [wLnkInitiator]                         ; $1621
    and a                                         ; $1624
    ret z                                         ; $1625

    ld a, [wLnkCmdArmed]                          ; $1626
    and a                                         ; $1629
    ret nz                                        ; $162A

    ld hl, wLinkBuffer                            ; $162B
    ld a, h                                       ; $162E
    ld [wLnkTxBase], a                            ; $162F
    ld a, l                                       ; $1632
    ld [wLnkTxBase + $1], a                       ; $1633
    ld a, [wLnkSlot]                              ; $1636
    ld b, a                                       ; $1639
    ld a, $80                                     ; $163A
    or b                                          ; $163C
    ld [wLnkCmdTx], a                             ; $163D
    ld a, SCF_START | SCF_SOURCE                  ; $1640
    ldh [rSC], a                                  ; $1642
    ld [wLnkCmdArmed], a                          ; $1644
    ret                                           ; $1647


; C: same code as the Japanese Link_UpdateInfoByte (00:2E68, 26 bytes, masked match)
Link_UpdateInfoByte::
    ld a, [wLnkInfoTx]                            ; $1648
    ld b, a                                       ; $164B
    ld a, [wLnkAlbumFull]                         ; $164C
    and a                                         ; $164F
    jr z, jr_000_1654                             ; $1650

    ld a, $40                                     ; $1652

jr_000_1654:
    ld c, a                                       ; $1654
    ld a, [wLnkOwnCount]                          ; $1655
    or b                                          ; $1658
    or c                                          ; $1659
    ld [wLnkInfoTx], a                            ; $165A
    ld a, [wLnkConnected]                         ; $165D
    and a                                         ; $1660
    ret                                           ; $1661


    db $0b, $78, $b1, $20, $fb, $c9

; C: same instructions as the Japanese OamDma_InstallRoutine (00:03E2) over the whole routine (9 instructions, to the
; first ret / jp), only the addresses differ; code compared
OamDma_InstallRoutine::
    ld c, $80                                     ; $1668
    ld b, $0a                                     ; $166A
    ld hl, OamDma_InstallRoutine_Tbl1676          ; $166C

jr_000_166f:
    ld a, [hl+]                                   ; $166F
    ldh [c], a                                    ; $1670
    inc c                                         ; $1671
    dec b                                         ; $1672
    jr nz, jr_000_166f                            ; $1673

    ret                                           ; $1675


; C: read in the runs by OamDma_InstallRoutine; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz)
OamDma_InstallRoutine_Tbl1676::
    db $3e, $d6, $e0, $46, $3e, $28, $3d, $20, $fd, $c9

; C: inline 2 bytes: the key repeat delays $D8D6-$D8D7
Keys_SetRepeatInline::
    pop hl                                        ; $1680
    ld a, [hl+]                                   ; $1681
    ld [wKeyRepeatDelay], a                       ; $1682
    ld a, [hl+]                                   ; $1685
    ld [wKeyRepeatPeriod], a                      ; $1686
    push hl                                       ; $1689
    ret                                           ; $168A


; C: reads the joypad (P1) into $D8D8, the old keys into $D8DB, new keys and repeats
Joy_Read::
    ld a, [wKeysHeld]                             ; $168B
    ld [wKeysPrev], a                             ; $168E
    ld c, a                                       ; $1691
    ld a, P1F_GET_DPAD                            ; $1692
    ldh [rP1], a                                  ; $1694
    ldh a, [rP1]                                  ; $1696
    ldh a, [rP1]                                  ; $1698
    and $0f                                       ; $169A
    swap a                                        ; $169C
    ld b, a                                       ; $169E
    ld a, P1F_GET_NONE                            ; $169F
    ldh [rP1], a                                  ; $16A1
    ld a, P1F_GET_BTN                             ; $16A3
    ldh [rP1], a                                  ; $16A5
    ldh a, [rP1]                                  ; $16A7
    ldh a, [rP1]                                  ; $16A9
    ldh a, [rP1]                                  ; $16AB
    ldh a, [rP1]                                  ; $16AD
    ldh a, [rP1]                                  ; $16AF
    ldh a, [rP1]                                  ; $16B1
    and $0f                                       ; $16B3
    or b                                          ; $16B5
    cpl                                           ; $16B6
    ld [wKeysHeld], a                             ; $16B7
    ld b, a                                       ; $16BA
    xor c                                         ; $16BB
    and b                                         ; $16BC
    ld [wKeysNew], a                              ; $16BD
    ld d, a                                       ; $16C0
    ld hl, wKeyRepeatCounter                      ; $16C1
    ld a, b                                       ; $16C4
    cp c                                          ; $16C5
    ld a, [wKeyRepeatDelay]                       ; $16C6
    jr nz, jr_000_16d5                            ; $16C9

    ld d, $00                                     ; $16CB
    ld a, [hl]                                    ; $16CD
    dec a                                         ; $16CE
    jr nz, jr_000_16d5                            ; $16CF

    ld d, b                                       ; $16D1
    ld a, [wKeyRepeatPeriod]                      ; $16D2

jr_000_16d5:
    ld [hl], a                                    ; $16D5
    ld a, d                                       ; $16D6
    ld [wKeysNewRepeat], a                        ; $16D7
    ld a, P1F_GET_NONE                            ; $16DA
    ldh [rP1], a                                  ; $16DC
    ret                                           ; $16DE


    db $c9, $fa, $81, $d8, $5f, $16, $d7, $e1, $2a, $12, $1c, $2a, $12, $1c, $2a, $12
    db $1c, $2a, $12, $1c, $2a, $12, $1c, $2a, $12, $1c, $7b, $ea, $81, $d8, $e9, $e5
    db $fa, $81, $d8, $6f, $26, $d7, $7b, $22, $7a, $22, $78, $22, $d1, $7b, $22, $7a
    db $22, $79, $22, $7d, $ea, $81, $d8, $c9

; C: runs the queue of copies at $D700 (records: address, bank, ...); code read
VramQueue_Run::
    ld hl, wVramQueue                             ; $1717
    jr jr_000_1763                                ; $171A

jr_000_171c:
    ld a, [hl+]                                   ; $171C
    ld e, a                                       ; $171D
    ld a, [hl+]                                   ; $171E
    ld d, a                                       ; $171F
    ld a, [hl+]                                   ; $1720
    ldh [hRomBankShadow], a                       ; $1721
    ld [$2100], a                                 ; $1723
    ld a, [hl+]                                   ; $1726
    ld c, a                                       ; $1727
    ld a, [hl+]                                   ; $1728
    ld b, a                                       ; $1729
    ld a, [hl+]                                   ; $172A
    push hl                                       ; $172B
    ld l, c                                       ; $172C
    ld h, b                                       ; $172D
    ld c, a                                       ; $172E

jr_000_172f:
    ld a, [de]                                    ; $172F
    ld [hl+], a                                   ; $1730
    inc e                                         ; $1731
    ld a, [de]                                    ; $1732
    ld [hl+], a                                   ; $1733
    inc de                                        ; $1734
    ld a, [de]                                    ; $1735
    ld [hl+], a                                   ; $1736
    inc e                                         ; $1737
    ld a, [de]                                    ; $1738
    ld [hl+], a                                   ; $1739
    inc de                                        ; $173A
    ld a, [de]                                    ; $173B
    ld [hl+], a                                   ; $173C
    inc e                                         ; $173D
    ld a, [de]                                    ; $173E
    ld [hl+], a                                   ; $173F
    inc de                                        ; $1740
    ld a, [de]                                    ; $1741
    ld [hl+], a                                   ; $1742
    inc e                                         ; $1743
    ld a, [de]                                    ; $1744
    ld [hl+], a                                   ; $1745
    inc de                                        ; $1746
    ld a, [de]                                    ; $1747
    ld [hl+], a                                   ; $1748
    inc e                                         ; $1749
    ld a, [de]                                    ; $174A
    ld [hl+], a                                   ; $174B
    inc de                                        ; $174C
    ld a, [de]                                    ; $174D
    ld [hl+], a                                   ; $174E
    inc e                                         ; $174F
    ld a, [de]                                    ; $1750
    ld [hl+], a                                   ; $1751
    inc de                                        ; $1752
    ld a, [de]                                    ; $1753
    ld [hl+], a                                   ; $1754
    inc e                                         ; $1755
    ld a, [de]                                    ; $1756
    ld [hl+], a                                   ; $1757
    inc de                                        ; $1758
    ld a, [de]                                    ; $1759
    ld [hl+], a                                   ; $175A
    inc e                                         ; $175B
    ld a, [de]                                    ; $175C
    ld [hl+], a                                   ; $175D
    inc de                                        ; $175E
    dec c                                         ; $175F
    jr nz, jr_000_172f                            ; $1760

    pop hl                                        ; $1762

jr_000_1763:
    ld a, [wVramQueueCount]                       ; $1763
    cp l                                          ; $1766
    jr nz, jr_000_171c                            ; $1767

    ret                                           ; $1769


; C: the entry jumps here
Boot::
    ld sp, hBoot_FFFE                             ; $176A
    di                                            ; $176D
    xor a                                         ; $176E
    ldh [rIF], a                                  ; $176F
    ldh [rIE], a                                  ; $1771

jr_000_1773:
    ldh a, [rLY]                                  ; $1773
    cp $91                                        ; $1775
    jr c, jr_000_1773                             ; $1777

    xor a                                         ; $1779
    ldh [rLCDC], a                                ; $177A
    ldh [rBGP], a                                 ; $177C
    ldh [rOBP0], a                                ; $177E
    ldh [rOBP1], a                                ; $1780
    call Mem_ZeroInline                           ; $1782

    db $00, $c0, $00, $20

    call Mem_ZeroInline                           ; $1789

    db $00, $80, $00, $20

    ld sp, wBoot_DFFF                             ; $1790
    call Mem_ZeroInline                           ; $1793

    db $80, $ff, $7f, $00

    ld a, $0a                                     ; $179A
    ld [$0100], a                                 ; $179C
    ld a, $01                                     ; $179F
    ld [$2100], a                                 ; $17A1
    ldh [hRomBankShadow], a                       ; $17A4
    xor a                                         ; $17A6
    ld [$4100], a                                 ; $17A7
    ldh [hSram_Format_FF8C], a                    ; $17AA
    ld a, $00                                     ; $17AC
    ld [rRAMG], a                                 ; $17AE
    call OamDma_InstallRoutine                    ; $17B1
    call Serial_SetFarCallback                    ; $17B4

    dwb Frame_UpdateAll

    call Keys_SetRepeatInline                     ; $17BA

    dw $0a14

    ld a, $ff                                     ; $17BF
    ld [wRngModulus], a                           ; $17C1
    call Rng_Init                                 ; $17C4
    xor a                                         ; $17C7
    ld [wOamUsedEnd], a                           ; $17C8
    ld [wVramQueueCount], a                       ; $17CB
    ld [wBoot_D8E4], a                            ; $17CE
    ld a, [wBoot_D8D2]                            ; $17D1
    and a                                         ; $17D4
    jr nz, jr_000_17da                            ; $17D5

    call Snd_Init_Tramp                           ; $17D7

jr_000_17da:
    call Serial_SetFarCallback                    ; $17DA

    dwb Far_ReturnJump

    call Stat_SetIdle                             ; $17E0
    ld b, BANK(Sgb_Detect)                        ; $17E3
    ld hl, Sgb_Detect                             ; $17E5
    call Far_Call                                 ; $17E8
    rl a                                          ; $17EB
    and $01                                       ; $17ED
    ld [wBoot_D8E3], a                            ; $17EF
    ld b, BANK(Sgb_InitDataSnd)                   ; $17F2
    ld hl, Sgb_InitDataSnd                        ; $17F4
    call Far_Call                                 ; $17F7
    ld a, $10                                     ; $17FA
    ldh [hSram_Format_FF8C], a                    ; $17FC
    ld [rRAMB], a                                 ; $17FE
    ld hl, $a000                                  ; $1801

jr_000_1804:
    bit 0, [hl]                                   ; $1804
    jr nz, jr_000_1804                            ; $1806

    ld hl, wMode06_State0A_D896                   ; $1808
    set 7, [hl]                                   ; $180B
    jp Main_Loop                                  ; $180D


Jump_000_1810:
    ld sp, hBoot_FFFE                             ; $1810
    di                                            ; $1813
    xor a                                         ; $1814
    ldh [rIF], a                                  ; $1815
    ldh [rIE], a                                  ; $1817
    xor a                                         ; $1819
    ldh [rBGP], a                                 ; $181A
    ldh [rOBP0], a                                ; $181C
    ldh [rOBP1], a                                ; $181E

jr_000_1820:
    ldh a, [rLY]                                  ; $1820
    cp $91                                        ; $1822
    jr c, jr_000_1820                             ; $1824

    xor a                                         ; $1826
    ldh [rLCDC], a                                ; $1827
    call Mem_ZeroInline                           ; $1829

    db $00, $c0, $00, $20

    call Mem_ZeroInline                           ; $1830

    db $00, $80, $00, $20

    ld sp, wBoot_DFFF                             ; $1837
    call Mem_ZeroInline                           ; $183A

    db $80, $ff, $7f, $00

    ld a, $0a                                     ; $1841
    ld [$0100], a                                 ; $1843
    ld a, $01                                     ; $1846
    ld [$2100], a                                 ; $1848
    ldh [hRomBankShadow], a                       ; $184B
    xor a                                         ; $184D
    ld [$4100], a                                 ; $184E
    ldh [hSram_Format_FF8C], a                    ; $1851
    ld a, $00                                     ; $1853
    ld [rRAMG], a                                 ; $1855
    call OamDma_InstallRoutine                    ; $1858
    call Serial_SetFarCallback                    ; $185B

    dwb Frame_UpdateAll

    call Keys_SetRepeatInline                     ; $1861

    dw $0a14

    ld a, $ff                                     ; $1866
    ld [wRngModulus], a                           ; $1868
    call Rng_Init                                 ; $186B
    xor a                                         ; $186E
    ld [wOamUsedEnd], a                           ; $186F
    ld [wVramQueueCount], a                       ; $1872
    ld [wBoot_D8E4], a                            ; $1875
    call Snd_Init_Tramp                           ; $1878
    call Serial_SetFarCallback                    ; $187B

    dwb Far_ReturnJump

    call Stat_SetIdle                             ; $1881
    ld a, $01                                     ; $1884
    ld [wBoot_D895], a                            ; $1886
    ld hl, wMode06_State0A_D896                   ; $1889
    set 7, [hl]                                   ; $188C
    jp Main_Loop                                  ; $188E


    db $c3, $de, $18, $21, $8a, $d8, $4e, $f0, $44, $b9, $da, $de, $18, $0c, $0c, $0c
    db $0c, $b9, $d2, $de, $18, $21, $41, $ff, $7e, $e6, $03, $20, $fb, $fa, $82, $d8
    db $ee, $10, $e0, $40, $c3, $de, $18

; C: stores the LCDC-interrupt callback (DE) for the next frame (hFFA6/A7)
Lcdc_SetCallbackNext::
    ld a, e                                       ; $18B8
    ldh [hFrame_UpdateAll_FFA6], a                ; $18B9
    ld a, d                                       ; $18BB
    ldh [hFrame_UpdateAll_FFA7], a                ; $18BC
    ret                                           ; $18BE


; C: stores the LCDC-interrupt callback (DE) in hFFA4/A5
Lcdc_SetCallback::
    ld a, e                                       ; $18BF
    ldh [hLcdc_SetCallback_FFA4], a               ; $18C0
    ld a, d                                       ; $18C2
    ldh [hLcdc_SetCallback_FFA5], a               ; $18C3
    ret                                           ; $18C5


Jump_000_18c6:
    call Lcdc_SetCallbackNext                     ; $18C6
    ld de, Stat_Idle                              ; $18C9
    jp Lcdc_SetCallback                           ; $18CC


    db $91, $18, $94, $18

Jump_000_18d3:
    push af                                       ; $18D3
    push bc                                       ; $18D4
    push de                                       ; $18D5
    push hl                                       ; $18D6
    ldh a, [hLcdc_SetCallback_FFA4]               ; $18D7
    ld l, a                                       ; $18D9
    ldh a, [hLcdc_SetCallback_FFA5]               ; $18DA
    ld h, a                                       ; $18DC
    jp hl                                         ; $18DD


Jump_000_18de:
    ld a, $01                                     ; $18DE
    ldh [hLcdc_SetCallback_FFA3], a               ; $18E0
    pop hl                                        ; $18E2
    pop de                                        ; $18E3
    pop bc                                        ; $18E4
    pop af                                        ; $18E5
    reti                                          ; $18E6


; C: STAT callback that does nothing (jp 00:18DE)
Stat_Idle::
    jp Jump_000_18de                              ; $18E7


; C: $D88A = $FF and the STAT callback 00:18E7
Stat_SetIdle::
    ld a, $ff                                     ; $18EA
    ld [wLycShadow], a                            ; $18EC
    ld de, Stat_Idle                              ; $18EF
    jp Lcdc_SetCallbackNext                       ; $18F2


; C: STAT callback: from line hFFA8 switches the tile data area at a line (same code as the Japanese
; Stat_01_TileDataToggle)
Stat_TileToggle::
    ld hl, hSplit1Latch                           ; $18F5
    ld c, [hl]                                    ; $18F8
    ldh a, [rLY]                                  ; $18F9
    cp c                                          ; $18FB
    jp c, Jump_000_18de                           ; $18FC

    inc c                                         ; $18FF
    inc c                                         ; $1900
    inc c                                         ; $1901
    inc c                                         ; $1902
    cp c                                          ; $1903
    jp nc, Jump_000_18de                          ; $1904

    ld hl, $ff41                                  ; $1907

jr_000_190a:
    ld a, [hl]                                    ; $190A
    and $03                                       ; $190B
    jr nz, jr_000_190a                            ; $190D

    ldh a, [hLcdcShadow]                          ; $190F
    xor $10                                       ; $1911
    ldh [rLCDC], a                                ; $1913
    jp Jump_000_18de                              ; $1915


; C: line $4F, callback Stat_TileToggle
Stat_SetTileToggleAt4F::
    ld a, $4f                                     ; $1918
    ld [wLycShadow], a                            ; $191A
    ld de, Stat_TileToggle                        ; $191D
    jp Lcdc_SetCallbackNext                       ; $1920


; C: the same through 00:18C6
Stat_SetTileToggleAt4F_B::
    ld a, $4f                                     ; $1923
    ld [wLycShadow], a                            ; $1925
    ld de, Stat_TileToggle                        ; $1928
    jp Jump_000_18c6                              ; $192B


; C: STAT callback like Stat_TileToggle (another register pattern)
Stat_TileToggleB::
    ld hl, hSplit1Latch                           ; $192E
    ld c, [hl]                                    ; $1931
    ldh a, [rLY]                                  ; $1932
    cp c                                          ; $1934
    jp c, Jump_000_18de                           ; $1935

    inc c                                         ; $1938
    inc c                                         ; $1939
    inc c                                         ; $193A
    inc c                                         ; $193B
    cp c                                          ; $193C
    jp nc, Jump_000_18de                          ; $193D

    ld hl, $ff41                                  ; $1940

jr_000_1943:
    ld a, [hl]                                    ; $1943
    and $03                                       ; $1944
    jr nz, jr_000_1943                            ; $1946

    ldh a, [hLcdcShadow]                          ; $1948
    xor $10                                       ; $194A
    ldh [rLCDC], a                                ; $194C
    ld a, $7f                                     ; $194E
    ldh [rLYC], a                                 ; $1950
    ld de, Stat_TileToggleAt7F                    ; $1952
    call Lcdc_SetCallback                         ; $1955
    jp Jump_000_18de                              ; $1958


; C: STAT callback: the switch at line $7F
Stat_TileToggleAt7F::
    ld c, $7f                                     ; $195B
    ldh a, [rLY]                                  ; $195D
    cp c                                          ; $195F
    jp c, Jump_000_18de                           ; $1960

    inc c                                         ; $1963
    inc c                                         ; $1964
    inc c                                         ; $1965
    inc c                                         ; $1966
    cp c                                          ; $1967
    jp nc, Jump_000_18de                          ; $1968

    ld hl, $ff41                                  ; $196B

jr_000_196e:
    ld a, [hl]                                    ; $196E
    and $03                                       ; $196F
    jr nz, jr_000_196e                            ; $1971

    ld a, [wMode14_State01_D801]                  ; $1973
    ldh [rSCX], a                                 ; $1976
    ld de, Stat_TileToggleB                       ; $1978
    call Lcdc_SetCallbackNext                     ; $197B
    jp Jump_000_18de                              ; $197E


; C: line $4F, callback Stat_TileToggleB
Stat_SetTileToggleBAt4F::
    ld a, $4f                                     ; $1981
    ld [wLycShadow], a                            ; $1983
    ld de, Stat_TileToggleB                       ; $1986
    jp Lcdc_SetCallbackNext                       ; $1989


; C: STAT callback like Stat_TileToggle (another register pattern)
Stat_TileToggleC::
    ld hl, hSplit1Latch                           ; $198C
    ld c, [hl]                                    ; $198F
    ldh a, [rLY]                                  ; $1990
    cp c                                          ; $1992
    jp c, Jump_000_18de                           ; $1993

    inc c                                         ; $1996
    inc c                                         ; $1997
    inc c                                         ; $1998
    inc c                                         ; $1999
    cp c                                          ; $199A
    jp nc, Jump_000_18de                          ; $199B

    ld hl, $ff41                                  ; $199E

jr_000_19a1:
    ld a, [hl]                                    ; $19A1
    and $03                                       ; $19A2
    jr nz, jr_000_19a1                            ; $19A4

    ld a, [wDoodleFromShutterbug]                 ; $19A6
    ldh [rWY], a                                  ; $19A9
    ld a, $4f                                     ; $19AB
    ldh [rLYC], a                                 ; $19AD
    ld de, Stat_TileToggleAt4F                    ; $19AF
    call Lcdc_SetCallback                         ; $19B2
    jp Jump_000_18de                              ; $19B5


; C: STAT callback: the switch at line $4F
Stat_TileToggleAt4F::
    ld c, $4f                                     ; $19B8
    ldh a, [rLY]                                  ; $19BA
    cp c                                          ; $19BC
    jp c, Jump_000_18de                           ; $19BD

    inc c                                         ; $19C0
    inc c                                         ; $19C1
    inc c                                         ; $19C2
    inc c                                         ; $19C3
    cp c                                          ; $19C4
    jp nc, Jump_000_18de                          ; $19C5

    ld hl, $ff41                                  ; $19C8

jr_000_19cb:
    ld a, [hl]                                    ; $19CB
    and $03                                       ; $19CC
    jr nz, jr_000_19cb                            ; $19CE

    ldh a, [hLcdcShadow]                          ; $19D0
    xor $10                                       ; $19D2
    ldh [rLCDC], a                                ; $19D4
    ld de, Stat_TileToggleC                       ; $19D6
    call Lcdc_SetCallbackNext                     ; $19D9
    jp Jump_000_18de                              ; $19DC


; C: line $1F, callback Stat_TileToggleC
Stat_SetTileToggleCAt1F::
    ld a, $1f                                     ; $19DF
    ld [wLycShadow], a                            ; $19E1
    ld de, Stat_TileToggleC                       ; $19E4
    jp Lcdc_SetCallbackNext                       ; $19E7


; C: STAT callback like Stat_TileToggle (another register pattern)
Stat_TileToggleD::
    ld hl, hSplit1Latch                           ; $19EA
    ld c, [hl]                                    ; $19ED
    ldh a, [rLY]                                  ; $19EE
    cp c                                          ; $19F0
    jp c, Jump_000_18de                           ; $19F1

    inc c                                         ; $19F4
    inc c                                         ; $19F5
    inc c                                         ; $19F6
    inc c                                         ; $19F7
    cp c                                          ; $19F8
    jp nc, Jump_000_18de                          ; $19F9

    ld hl, $ff41                                  ; $19FC

jr_000_19ff:
    ld a, [hl]                                    ; $19FF
    and $03                                       ; $1A00
    jr nz, jr_000_19ff                            ; $1A02

    ld a, [wDoodleFromShutterbug]                 ; $1A04
    ldh [rSCX], a                                 ; $1A07
    ld a, $6f                                     ; $1A09
    ldh [rLYC], a                                 ; $1A0B
    ld de, Stat_TileToggleAt6F                    ; $1A0D
    call Lcdc_SetCallback                         ; $1A10
    jp Jump_000_18de                              ; $1A13


; C: STAT callback: the switch at line $6F
Stat_TileToggleAt6F::
    ld c, $6f                                     ; $1A16
    ldh a, [rLY]                                  ; $1A18
    cp c                                          ; $1A1A
    jp c, Jump_000_18de                           ; $1A1B

    inc c                                         ; $1A1E
    inc c                                         ; $1A1F
    inc c                                         ; $1A20
    inc c                                         ; $1A21
    cp c                                          ; $1A22
    jp nc, Jump_000_18de                          ; $1A23

    ld hl, $ff41                                  ; $1A26

jr_000_1a29:
    ld a, [hl]                                    ; $1A29
    and $03                                       ; $1A2A
    jr nz, jr_000_1a29                            ; $1A2C

    ld a, [wScxShadow]                            ; $1A2E
    ldh [rSCX], a                                 ; $1A31
    ld de, Stat_TileToggleD                       ; $1A33
    call Lcdc_SetCallbackNext                     ; $1A36
    jp Jump_000_18de                              ; $1A39


; C: line $07, callback Stat_TileToggleD
Stat_SetTileToggleDAt07::
    ld a, $07                                     ; $1A3C
    ld [wLycShadow], a                            ; $1A3E
    ld de, Stat_TileToggleD                       ; $1A41
    jp Lcdc_SetCallbackNext                       ; $1A44


; C: STAT callback like Stat_TileToggle (another register pattern)
Stat_TileToggleE::
    ld hl, hSplit1Latch                           ; $1A47
    ld c, [hl]                                    ; $1A4A
    ldh a, [rLY]                                  ; $1A4B
    cp c                                          ; $1A4D
    jp c, Jump_000_18de                           ; $1A4E

    inc c                                         ; $1A51
    inc c                                         ; $1A52
    inc c                                         ; $1A53
    inc c                                         ; $1A54
    cp c                                          ; $1A55
    jp nc, Jump_000_18de                          ; $1A56

    ld hl, $ff41                                  ; $1A59

jr_000_1a5c:
    ld a, [hl]                                    ; $1A5C
    and $03                                       ; $1A5D
    jr nz, jr_000_1a5c                            ; $1A5F

    ldh a, [hLcdcShadow]                          ; $1A61
    xor $10                                       ; $1A63
    ldh [rLCDC], a                                ; $1A65
    jp Jump_000_18de                              ; $1A67


; C: line $4F, callback Stat_TileToggleE
Stat_SetTileToggleEAt4F::
    ld a, $4f                                     ; $1A6A
    ld [wLycShadow], a                            ; $1A6C
    ld de, Stat_TileToggleE                       ; $1A6F
    jp Lcdc_SetCallbackNext                       ; $1A72


; C: line $17, callback Stat_TileToggle
Stat_SetTileToggleAt17::
    ld a, $17                                     ; $1A75
    ld [wLycShadow], a                            ; $1A77
    ld de, Stat_TileToggle                        ; $1A7A
    jp Lcdc_SetCallbackNext                       ; $1A7D


; C: line $27, callback Stat_TileToggle
Stat_SetTileToggleAt27::
    ld a, $27                                     ; $1A80
    ld [wLycShadow], a                            ; $1A82
    ld de, Stat_TileToggle                        ; $1A85
    jp Lcdc_SetCallbackNext                       ; $1A88


; C: line $37, callback Stat_TileToggle
Stat_SetTileToggleAt37::
    ld a, $37                                     ; $1A8B
    ld [wLycShadow], a                            ; $1A8D
    ld de, Stat_TileToggle                        ; $1A90
    jp Lcdc_SetCallbackNext                       ; $1A93


; C: line $47, callback Stat_TileToggle
Stat_SetTileToggleAt47::
    ld a, $47                                     ; $1A96
    ld [wLycShadow], a                            ; $1A98
    ld de, Stat_TileToggle                        ; $1A9B
    jp Lcdc_SetCallbackNext                       ; $1A9E


; C: line $57, callback Stat_TileToggle
Stat_SetTileToggleAt57::
    ld a, $57                                     ; $1AA1
    ld [wLycShadow], a                            ; $1AA3
    ld de, Stat_TileToggle                        ; $1AA6
    jp Lcdc_SetCallbackNext                       ; $1AA9


; C: line $67, callback Stat_TileToggle
Stat_SetTileToggleAt67::
    ld a, $67                                     ; $1AAC
    ld [wLycShadow], a                            ; $1AAE
    ld de, Stat_TileToggle                        ; $1AB1
    jp Lcdc_SetCallbackNext                       ; $1AB4


; C: 3 inline bytes: a far callback {lo; hi; bank} stored in hFF97-99
Serial_SetFarCallback::
    pop hl                                        ; $1AB7
    ld a, [hl+]                                   ; $1AB8
    ldh [hSerial_SetFarCallback_FF97], a          ; $1AB9
    ld a, [hl+]                                   ; $1ABB
    ldh [hSerial_SetFarCallback_FF98], a          ; $1ABC
    ld a, [hl+]                                   ; $1ABE
    ldh [hSerial_SetFarCallback_FF99], a          ; $1ABF
    jp hl                                         ; $1AC1


; C: jp Far_Return
Far_ReturnJump::
    jp Far_Return                                 ; $1AC2


; C: Object_RunAll, ScriptSlots_Run, Objects_DrawAll, Oam_HideUnused
Frame_UpdateAll::
    ld b, $00                                     ; $1AC5
    ld hl, Object_RunAll                          ; $1AC7
    call Far_Call                                 ; $1ACA
    ld b, BANK(ScriptSlots_Run)                   ; $1ACD
    ld hl, ScriptSlots_Run                        ; $1ACF
    call Far_Call                                 ; $1AD2
    call Objects_DrawAll                          ; $1AD5
    call Oam_HideUnused                           ; $1AD8
    jp Far_Return                                 ; $1ADB


    db $18, $fe

Jump_000_1ae0:
    push af                                       ; $1AE0
    push bc                                       ; $1AE1
    push de                                       ; $1AE2
    push hl                                       ; $1AE3
    ldh a, [hBankTmp]                             ; $1AE4
    push af                                       ; $1AE6
    ldh a, [hRomBankShadow]                       ; $1AE7
    push af                                       ; $1AE9
    ldh a, [hSram_Format_FF8C]                    ; $1AEA
    push af                                       ; $1AEC
    call $ff80                                    ; $1AED
    ei                                            ; $1AF0
    ld hl, hFrame_UpdateAll_FF9A                  ; $1AF1
    ld a, [hl+]                                   ; $1AF4
    or [hl]                                       ; $1AF5
    jp nz, Jump_000_1b8f                          ; $1AF6

    ld a, $01                                     ; $1AF9
    ldh [hFrame_UpdateAll_FF9A], a                ; $1AFB
    call VramQueue_Run                            ; $1AFD
    call ScriptSlots_Tick                         ; $1B00
    ld hl, wLcdcShadow                            ; $1B03
    ld a, [hl+]                                   ; $1B06
    ldh [rLCDC], a                                ; $1B07
    ldh [hLcdcShadow], a                          ; $1B09
    ld a, [hl+]                                   ; $1B0B
    ldh [rBGP], a                                 ; $1B0C
    ld a, [hl+]                                   ; $1B0E
    ldh [rOBP0], a                                ; $1B0F
    ld a, [hl+]                                   ; $1B11
    ldh [rOBP1], a                                ; $1B12
    ld a, [hl+]                                   ; $1B14
    ldh [rSCX], a                                 ; $1B15
    ld a, [hl+]                                   ; $1B17
    ldh [rSCY], a                                 ; $1B18
    ld a, [hl+]                                   ; $1B1A
    add $07                                       ; $1B1B
    ldh [rWX], a                                  ; $1B1D
    ld a, [hl+]                                   ; $1B1F
    ldh [rWY], a                                  ; $1B20
    ld a, [hl+]                                   ; $1B22
    ldh [hSplit1Latch], a                         ; $1B23
    ldh [rLYC], a                                 ; $1B25
    ldh a, [hFrame_UpdateAll_FFA6]                ; $1B27
    ldh [hLcdc_SetCallback_FFA4], a               ; $1B29
    ldh a, [hFrame_UpdateAll_FFA7]                ; $1B2B
    ldh [hLcdc_SetCallback_FFA5], a               ; $1B2D
    ld a, [wFrame_UpdateAll_DD40]                 ; $1B2F
    and a                                         ; $1B32
    call nz, Prn_VBlankPoll                       ; $1B33
    ld a, [wBoot_D8D2]                            ; $1B36
    and a                                         ; $1B39
    jr nz, jr_000_1b3f                            ; $1B3A

    call Snd_Tick_Tramp                           ; $1B3C

jr_000_1b3f:
    ldh a, [hFrameCounter]                        ; $1B3F
    inc a                                         ; $1B41
    ldh [hFrameCounter], a                        ; $1B42
    ld a, $01                                     ; $1B44
    ldh [hVBlankDone], a                          ; $1B46
    xor a                                         ; $1B48
    ld [wOamUsedEnd], a                           ; $1B49
    ld [wVramQueueCount], a                       ; $1B4C
    call Joy_Read                                 ; $1B4F
    ld a, [wMode06_State0A_D896]                  ; $1B52
    and a                                         ; $1B55
    jr nz, jr_000_1b60                            ; $1B56

    ld a, [wKeysHeld]                             ; $1B58
    cp PADF_BUTTONS                               ; $1B5B
    jp z, Jump_000_1810                           ; $1B5D

jr_000_1b60:
    ld a, [wKeysHeld]                             ; $1B60
    cp PADF_BUTTONS                               ; $1B63
    jr z, jr_000_1b6c                             ; $1B65

    ld hl, wMode06_State0A_D896                   ; $1B67
    res 7, [hl]                                   ; $1B6A

jr_000_1b6c:
    ldh a, [hSerial_SetFarCallback_FF99]          ; $1B6C
    ld b, a                                       ; $1B6E
    ldh a, [hSerial_SetFarCallback_FF97]          ; $1B6F
    ld l, a                                       ; $1B71
    ldh a, [hSerial_SetFarCallback_FF98]          ; $1B72
    ld h, a                                       ; $1B74
    call Far_Call                                 ; $1B75
    xor a                                         ; $1B78
    ldh [hFrame_UpdateAll_FF9A], a                ; $1B79
    pop af                                        ; $1B7B
    ldh [hSram_Format_FF8C], a                    ; $1B7C
    ld [rRAMB], a                                 ; $1B7E
    pop af                                        ; $1B81
    ldh [hRomBankShadow], a                       ; $1B82
    ld [$2100], a                                 ; $1B84
    pop af                                        ; $1B87
    ldh [hBankTmp], a                             ; $1B88
    pop hl                                        ; $1B8A
    pop de                                        ; $1B8B
    pop bc                                        ; $1B8C
    pop af                                        ; $1B8D
    reti                                          ; $1B8E


Jump_000_1b8f:
    ld hl, wLcdcShadow                            ; $1B8F
    ld a, [hl+]                                   ; $1B92
    ldh [rLCDC], a                                ; $1B93
    ldh [hLcdcShadow], a                          ; $1B95
    ld a, [hl+]                                   ; $1B97
    ldh [rBGP], a                                 ; $1B98
    ld a, [hl+]                                   ; $1B9A
    ldh [rOBP0], a                                ; $1B9B
    ld a, [hl+]                                   ; $1B9D
    ldh [rOBP1], a                                ; $1B9E
    ld a, [hl+]                                   ; $1BA0
    ldh [rSCX], a                                 ; $1BA1
    ld a, [hl+]                                   ; $1BA3
    ldh [rSCY], a                                 ; $1BA4
    ld a, [hl+]                                   ; $1BA6
    add $07                                       ; $1BA7
    ldh [rWX], a                                  ; $1BA9
    ld a, [hl+]                                   ; $1BAB
    ldh [rWY], a                                  ; $1BAC
    ld a, [hl+]                                   ; $1BAE
    ldh [hSplit1Latch], a                         ; $1BAF
    ldh [rLYC], a                                 ; $1BB1
    ldh a, [hFrame_UpdateAll_FFA6]                ; $1BB3
    ldh [hLcdc_SetCallback_FFA4], a               ; $1BB5
    ldh a, [hFrame_UpdateAll_FFA7]                ; $1BB7
    ldh [hLcdc_SetCallback_FFA5], a               ; $1BB9
    ld a, [wFrame_UpdateAll_DD40]                 ; $1BBB
    and a                                         ; $1BBE
    call nz, Prn_VBlankPoll                       ; $1BBF
    call Snd_Tick_Tramp                           ; $1BC2
    pop af                                        ; $1BC5
    ldh [hSram_Format_FF8C], a                    ; $1BC6
    ld [rRAMB], a                                 ; $1BC8
    pop af                                        ; $1BCB
    ldh [hRomBankShadow], a                       ; $1BCC
    ld [$2100], a                                 ; $1BCE
    pop af                                        ; $1BD1
    ldh [hBankTmp], a                             ; $1BD2
    pop hl                                        ; $1BD4
    pop de                                        ; $1BD5
    pop bc                                        ; $1BD6
    pop af                                        ; $1BD7
    reti                                          ; $1BD8


    db $d9

Jump_000_1bda:
    push af                                       ; $1BDA
    push bc                                       ; $1BDB
    push de                                       ; $1BDC
    push hl                                       ; $1BDD
    ld a, [wFrame_UpdateAll_D8E5]                 ; $1BDE
    and a                                         ; $1BE1
    jr z, jr_000_1bec                             ; $1BE2

    call Link_SerialIrq                           ; $1BE4
    pop hl                                        ; $1BE7
    pop de                                        ; $1BE8
    pop bc                                        ; $1BE9
    pop af                                        ; $1BEA
    reti                                          ; $1BEB


jr_000_1bec:
    call Prn_SerialIrq                            ; $1BEC
    pop hl                                        ; $1BEF
    pop de                                        ; $1BF0
    pop bc                                        ; $1BF1
    pop af                                        ; $1BF2
    reti                                          ; $1BF3


Jump_000_1bf4:
    reti                                          ; $1BF4


; C: read in the runs by Object_RunAll, ObjCmd_SetPos, ObjCmd_CopyAtLine20; first read on the screen
; Mode03_ViewAlbum_State13 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_00_1BF5_Mode03_ViewAlbum_State13::
    db $3a, $1f, $20, $20, $08, $80, $e8, $5b, $3a, $1f, $30, $20, $08, $80, $e8, $5b
    db $3a, $1f, $40, $20, $08, $80, $e8, $5b, $3a, $1f, $50, $20, $08, $80, $e8, $5b
    db $3a, $1f, $60, $20, $08, $80, $e8, $5b, $3a, $1f, $70, $20, $08, $80, $e8, $5b
    db $02, $1f, $f5, $1b, $b9, $7f, $05, $4c, $93, $1c, $cc, $1f, $07, $00, $00, $4e
    db $82, $9c, $c0, $01, $22, $9f, $1c, $cc, $1f, $07, $00

; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll; first read on the screen Mode03_ViewAlbum_State13
; (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py; the rest of Data_00_1BF5
; after a leftover stretch
Gfx_00_1C40_Mode03_ViewAlbum_State13::
    INCBIN "data/bank_00/Gfx_00_1C40_Mode03_ViewAlbum_State13.bin" ; $1C40, 76 bytes
; C: $D8E0 = $FF (script callback)
Script_SetD8E0FF::
    ld a, $ff                                     ; $1C8C
    ld [wMode06_State21_D8E0], a                  ; $1C8E
    scf                                           ; $1C91
    ret                                           ; $1C92


; C: $D882 bit 3 cleared, waits 1 frame
Script_ClearD882Bit3Wait::
    push hl                                       ; $1C93
    ld hl, wLcdcShadow                            ; $1C94
    res 3, [hl]                                   ; $1C97
    pop hl                                        ; $1C99
    ld bc, $0001                                  ; $1C9A
    and a                                         ; $1C9D
    ret                                           ; $1C9E


; C: $D882 bit 3 set, waits 1 frame
Script_SetD882Bit3Wait::
    push hl                                       ; $1C9F
    ld hl, wLcdcShadow                            ; $1CA0
    set 3, [hl]                                   ; $1CA3
    pop hl                                        ; $1CA5
    ld bc, $0001                                  ; $1CA6
    and a                                         ; $1CA9
    ret                                           ; $1CAA


; C: named by the code of Mode03_State12 (05:75CB); read in the runs by Object_CreateWithParam; first read on the
; screen Mode03_ViewAlbum_State13 (trace/read_screens_kitty.npz)
ObjScript_00_1CAB_Mode03_ViewAlbum_State12::
    db $2d, $1c, $b9, $7f, $b9, $7f

; C: Menu07_CursorCallback
Obj_Menu07Cursor::
    ld b, BANK(Menu07_CursorCallback)             ; $1CB1
    ld hl, Menu07_CursorCallback                  ; $1CB3
    call Far_Call                                 ; $1CB6
    ret                                           ; $1CB9


; C: read in the runs by Object_RunAll, ObjCmd_CopyAtLine20, ObjCmd_Jump; first read on the screen
; Mode12_SlideShow_State01 (trace/read_screens_kitty.npz); kind T_UI from the evidence of tools/kitty_layout_kinds.py
Gfx_00_1CBA_Mode12_SlideShow_State01::
    INCBIN "data/bank_00/Gfx_00_1CBA_Mode12_SlideShow_State01.bin" ; $1CBA, 141 bytes
; C: hFFD8 = $D907 (script callback)
SlideShow_ObjSaveD907::
    ld a, [wMenu07_CursorUpdate_D907]             ; $1D47
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $1D4A
    scf                                           ; $1D4C
    ret                                           ; $1D4D


; C: restarts the script 00:1CD4 when $D907 changes
SlideShow_ObjFollowD907::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $1D4E
    ld a, [wMenu07_CursorUpdate_D907]             ; $1D51
    cp [hl]                                       ; $1D54
    ld de, $1cd4                                  ; $1D55
    jp nz, Jump_000_2205                          ; $1D58

    ret                                           ; $1D5B


; C: named by the code of Mode12_State00 (07:4903); read in the runs by Object_RunAll, ObjCmd_CopyAtLine20,
; Object_CreateWithParam; first read on the screen Mode12_SlideShow_State01 (trace/read_screens_kitty.npz); kind T_UI
; from the evidence of tools/kitty_layout_kinds.py
Gfx_00_1D5C_Mode12_SlideShow_State00::
    INCBIN "data/bank_00/Gfx_00_1D5C_Mode12_SlideShow_State00.bin" ; $1D5C, 58 bytes
; C: hFFD8 = $D908 (script callback)
SlideShow_ObjSaveD908::
    ld a, [wMenu07_CursorUpdate_D908]             ; $1D96
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $1D99
    scf                                           ; $1D9B
    ret                                           ; $1D9C


; C: restarts the script 00:1D62 when $D908 changes
SlideShow_ObjFollowD908::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $1D9D
    ld a, [wMenu07_CursorUpdate_D908]             ; $1DA0
    cp [hl]                                       ; $1DA3
    ld de, $1d62                                  ; $1DA4
    jp nz, Jump_000_2205                          ; $1DA7

    ret                                           ; $1DAA


; C: named by the code of Mode12_State00 (07:4909); read in the runs by Copy_DEtoHL, Object_CreateWithParam; first
; read on the screen Mode12_SlideShow_State01 (trace/read_screens_kitty.npz); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py
Gfx_00_1DAB_Mode12_SlideShow_State00::
    INCBIN "data/bank_00/Gfx_00_1DAB_Mode12_SlideShow_State00.bin" ; $1DAB, 271 bytes
; C: {id, channel 0-3}: the sound into $D060 / $D068 / $D070 / $D078
ObjCmd_Sound::
    push hl                                       ; $1EBA
    ld a, [hl+]                                   ; $1EBB
    push af                                       ; $1EBC
    ld a, [hl]                                    ; $1EBD
    call JumpTable_Inline                         ; $1EBE

; C: read in the runs by JumpTable_Inline; first read on the screen Mode02_TakePhotos_State08
; (trace/read_screens_kitty.npz)
ObjCmd_Sound_JumpTbl1EC1::
    dw ObjCmd_SoundCh0
    dw ObjCmd_SoundCh1
    dw ObjCmd_SoundCh2
    dw ObjCmd_SoundCh3

; C: channel 0 of ObjCmd_Sound: $D060
ObjCmd_SoundCh0::
    pop af                                        ; $1EC9
    ld [wSndSfx1], a                              ; $1ECA
    jr jr_000_1edf                                ; $1ECD

; C: channel 1 of ObjCmd_Sound: $D068
ObjCmd_SoundCh1::
    pop af                                        ; $1ECF
    ld [wSndMusicReq], a                          ; $1ED0
    jr jr_000_1edf                                ; $1ED3

; C: channel 2 of ObjCmd_Sound: $D070
ObjCmd_SoundCh2::
    pop af                                        ; $1ED5
    ld [wSndSfx3], a                              ; $1ED6
    jr jr_000_1edf                                ; $1ED9

; C: channel 3 of ObjCmd_Sound: $D078
ObjCmd_SoundCh3::
    pop af                                        ; $1EDB
    ld [wSndSfx4], a                              ; $1EDC

jr_000_1edf:
    pop hl                                        ; $1EDF
    inc hl                                        ; $1EE0
    inc hl                                        ; $1EE1
    scf                                           ; $1EE2
    ret                                           ; $1EE3


; C: $DC61-$DC62 = the next word
ObjCmd_SetDC61::
    ld a, [hl+]                                   ; $1EE4
    ld [wObjCmd_SetDC61], a                       ; $1EE5
    ld a, [hl+]                                   ; $1EE8
    ld [wObjCmd_SetDC61_DC62], a                  ; $1EE9
    scf                                           ; $1EEC
    ret                                           ; $1EED


; C: $DC63-$DC64 = the next word
ObjCmd_SetDC63::
    ld a, [hl+]                                   ; $1EEE
    ld [wObjCmd_SetDC63], a                       ; $1EEF
    ld a, [hl+]                                   ; $1EF2
    ld [wObjCmd_SetDC63_DC64], a                  ; $1EF3
    scf                                           ; $1EF6
    ret                                           ; $1EF7


; C: $DC65-$DC66 = the next word
ObjCmd_SetDC65::
    ld a, [hl+]                                   ; $1EF8
    ld [wObjCmd_SetDC65], a                       ; $1EF9
    ld a, [hl+]                                   ; $1EFC
    ld [wObjCmd_SetDC65_DC66], a                  ; $1EFD
    scf                                           ; $1F00
    ret                                           ; $1F01


; C: hFFC3-hFFC4 = 0 (the slot is free), stops
ObjCmd_End::
    xor a                                         ; $1F02
    ldh [hObjCmd_End_FFC3], a                     ; $1F03
    ldh [hObjCmd_End_FFC4], a                     ; $1F05
    and a                                         ; $1F07
    ret                                           ; $1F08


; C: stays on this command ($7FFF frames, HL back by 2)
ObjCmd_Halt::
    dec hl                                        ; $1F09
    dec hl                                        ; $1F0A
    ld bc, $7fff                                  ; $1F0B
    and a                                         ; $1F0E
    ret                                           ; $1F0F


; C: BC = the next word (frames to wait)
ObjCmd_Wait::
    ld a, [hl+]                                   ; $1F10
    ld c, a                                       ; $1F11
    ld a, [hl+]                                   ; $1F12
    ld b, a                                       ; $1F13
    and a                                         ; $1F14
    ret                                           ; $1F15


; C: hFFC7-hFFC8 = the next word (the per-frame callback)
ObjCmd_SetCallback::
    ld a, [hl+]                                   ; $1F16
    ldh [hObjCmd_SetCallback_FFC7], a             ; $1F17
    ld a, [hl+]                                   ; $1F19
    ldh [hObjCmd_SetCallback_FFC8], a             ; $1F1A
    scf                                           ; $1F1C
    ret                                           ; $1F1D


; C: HL = the next word
ObjCmd_Jump::
    ld a, [hl+]                                   ; $1F1E
    ld c, a                                       ; $1F1F
    ld a, [hl]                                    ; $1F20
    ld l, c                                       ; $1F21
    ld h, a                                       ; $1F22
    scf                                           ; $1F23
    ret                                           ; $1F24


; C: hFFD7 = the next byte
ObjCmd_SetLoop::
    ld a, [hl+]                                   ; $1F25
    ldh [hObjCmd_Loop_FFD7], a                    ; $1F26
    scf                                           ; $1F28
    ret                                           ; $1F29


; C: hFFD7 - 1; jumps to the next word while not 0
ObjCmd_Loop::
    ldh a, [hObjCmd_Loop_FFD7]                    ; $1F2A
    dec a                                         ; $1F2C
    ldh [hObjCmd_Loop_FFD7], a                    ; $1F2D
    jr nz, ObjCmd_Jump                            ; $1F2F

    inc hl                                        ; $1F31
    inc hl                                        ; $1F32
    scf                                           ; $1F33
    ret                                           ; $1F34


    db $2a, $e0, $d5, $37, $c9

; C: hFFD2 / hFFD4 = the next two bytes, fractions hFFD1 / hFFD3 = 0
ObjCmd_SetPos::
    xor a                                         ; $1F3A
    ldh [hPlayMenu_CursorUpdate_FFD1], a          ; $1F3B
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $1F3D
    ld a, [hl+]                                   ; $1F3F
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $1F40
    ld a, [hl+]                                   ; $1F42
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $1F43
    scf                                           ; $1F45
    ret                                           ; $1F46


; C: hFFD2 / hFFD4 = hFFD8 / hFFD9 + the next two bytes
ObjCmd_SetPosRel::
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $1F47
    add [hl]                                      ; $1F49
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $1F4A
    inc hl                                        ; $1F4C
    ldh a, [hScratch_CursorUpdate_FFD9]           ; $1F4D
    add [hl]                                      ; $1F4F
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $1F50
    inc hl                                        ; $1F52
    scf                                           ; $1F53
    ret                                           ; $1F54


    db $2a, $e0, $d1, $2a, $e0, $d2, $37, $c9, $2a, $e0, $d3, $2a, $e0, $d4, $37, $c9

; C: hFFD1 / hFFD3 = the next two bytes
ObjCmd_SetFrac::
    ld a, [hl+]                                   ; $1F65
    ldh [hPlayMenu_CursorUpdate_FFD1], a          ; $1F66
    ld a, [hl+]                                   ; $1F68
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $1F69
    scf                                           ; $1F6B
    ret                                           ; $1F6C


; C: hFFCB-hFFCC = the next word (speed)
ObjCmd_SetSpeed::
    ld a, [hl+]                                   ; $1F6D
    ldh [hCopyReqSrcDstCnt], a                    ; $1F6E
    ld a, [hl+]                                   ; $1F70
    ldh [hCopyReqSrcDstCnt + $1], a               ; $1F71
    scf                                           ; $1F73
    ret                                           ; $1F74


; C: hFFD8 = the next byte
ObjCmd_SetD8::
    ld a, [hl+]                                   ; $1F75
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $1F76
    scf                                           ; $1F78
    ret                                           ; $1F79


    db $2a, $e0, $d9, $37, $c9

; C: hFFCD-hFFCE = the next word (the sprite layout)
ObjCmd_SetSprite::
    ld a, [hl+]                                   ; $1F7F
    ldh [hCopyReqSrcDstCnt + $2], a               ; $1F80
    ld a, [hl+]                                   ; $1F82
    ldh [hCopyReqSrcDstCnt + $3], a               ; $1F83
    scf                                           ; $1F85
    ret                                           ; $1F86


    db $fa, $d9, $d8, $a6, $20, $08, $2b, $2b, $01, $01, $00, $37, $3f, $c9, $23, $37
    db $c9

; C: {address, mask, target}: jumps when [address] & mask is not 0
ObjCmd_JumpIfBits::
    ld a, [hl+]                                   ; $1F98
    ld c, a                                       ; $1F99
    ld a, [hl+]                                   ; $1F9A
    ld b, a                                       ; $1F9B
    ld a, [bc]                                    ; $1F9C
    and [hl]                                      ; $1F9D
    jr nz, jr_000_1fb4                            ; $1F9E

    jr z, jr_000_1faa                             ; $1FA0

; C: {address, mask, target}: jumps when [address] & mask is 0
ObjCmd_JumpIfNoBits::
    ld a, [hl+]                                   ; $1FA2
    ld c, a                                       ; $1FA3
    ld a, [hl+]                                   ; $1FA4
    ld b, a                                       ; $1FA5
    ld a, [bc]                                    ; $1FA6
    and [hl]                                      ; $1FA7
    jr z, jr_000_1fb4                             ; $1FA8

jr_000_1faa:
    dec hl                                        ; $1FAA
    dec hl                                        ; $1FAB
    dec hl                                        ; $1FAC
    dec hl                                        ; $1FAD
    ld bc, $0001                                  ; $1FAE
    scf                                           ; $1FB1
    ccf                                           ; $1FB2
    ret                                           ; $1FB3


jr_000_1fb4:
    inc hl                                        ; $1FB4
    scf                                           ; $1FB5
    ret                                           ; $1FB6


    db $2a, $4f, $2a, $47, $0a, $be, $28, $0a, $2b, $2b, $2b, $2b, $01, $01, $00, $37
    db $3f, $c9, $23, $37, $c9

; C: waits for line $20, then a copy from the record that follows; code read
ObjCmd_CopyAtLine20::
    ldh a, [rLY]                                  ; $1FCC
    cp $20                                        ; $1FCE
    jr nz, ObjCmd_CopyAtLine20                    ; $1FD0

    push hl                                       ; $1FD2
    ld a, [hl+]                                   ; $1FD3
    ld c, a                                       ; $1FD4
    ld a, [hl+]                                   ; $1FD5
    ld b, a                                       ; $1FD6
    push bc                                       ; $1FD7
    ld a, [hl+]                                   ; $1FD8
    ld e, a                                       ; $1FD9
    ld a, [hl+]                                   ; $1FDA
    ld d, a                                       ; $1FDB
    ld a, [hl+]                                   ; $1FDC
    ld c, a                                       ; $1FDD
    ld a, [hl+]                                   ; $1FDE
    ld b, a                                       ; $1FDF
    push bc                                       ; $1FE0
    ld a, [hl+]                                   ; $1FE1
    ld c, a                                       ; $1FE2
    ld a, [hl+]                                   ; $1FE3
    ld b, a                                       ; $1FE4
    ld a, [hl+]                                   ; $1FE5
    pop hl                                        ; $1FE6
    call Vram_CopyHBlankFar                       ; $1FE7
    pop bc                                        ; $1FEA
    pop hl                                        ; $1FEB
    ld de, $0009                                  ; $1FEC
    add hl, de                                    ; $1FEF
    ld a, c                                       ; $1FF0
    or b                                          ; $1FF1
    jr z, jr_000_1ff6                             ; $1FF2

    and a                                         ; $1FF4
    ret                                           ; $1FF5


jr_000_1ff6:
    scf                                           ; $1FF6
    ret                                           ; $1FF7


; C: object script command {n, n words}: Rng_Scaled picks one of the n words and the script jumps there; first run in
; the core replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game,
; mode $06 states $23 / $24); code read
ObjCmd_JumpRandom::
    ld a, [hl+]                                   ; $1FF8
    push hl                                       ; $1FF9
    call Rng_Scaled                               ; $1FFA
    sla a                                         ; $1FFD
    ld c, a                                       ; $1FFF
    ld b, $00                                     ; $2000
    pop hl                                        ; $2002
    add hl, bc                                    ; $2003
    ld a, [hl+]                                   ; $2004
    ld h, [hl]                                    ; $2005
    ld l, a                                       ; $2006
    scf                                           ; $2007
    ret                                           ; $2008


; C: reads the byte at the address of the next word and jumps through the word table that follows
ObjCmd_JumpByByte::
    ld a, [hl+]                                   ; $2009
    ld e, a                                       ; $200A
    ld a, [hl+]                                   ; $200B
    ld d, a                                       ; $200C
    ld a, [de]                                    ; $200D
    push hl                                       ; $200E
    sla a                                         ; $200F
    ld c, a                                       ; $2011
    ld b, $00                                     ; $2012
    pop hl                                        ; $2014
    add hl, bc                                    ; $2015
    ld a, [hl+]                                   ; $2016
    ld h, [hl]                                    ; $2017
    ld l, a                                       ; $2018
    scf                                           ; $2019
    ret                                           ; $201A


    db $2a, $e0, $d6, $37, $c9, $f0, $d6, $b6, $e0, $d6, $23, $37, $c9, $f0, $d6, $a6
    db $e0, $d6, $23, $37, $c9

; C: object script command {descriptor}: Object_Create with DE = the word that follows; first run in the core replays
; of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23
; / $24); code read
ObjCmd_CreateObject::
    ld a, [hl+]                                   ; $2030
    ld e, a                                       ; $2031
    ld a, [hl+]                                   ; $2032
    ld d, a                                       ; $2033
    push hl                                       ; $2034
    call Object_Create                            ; $2035
    pop hl                                        ; $2038
    scf                                           ; $2039
    ret                                           ; $203A


    db $2a, $5f, $2a, $57, $2a, $4f, $2a, $47, $e5, $cd, $5d, $20, $e1, $37, $c9

; C: ScriptSlots_Add with the next word
ObjCmd_StartSlotScript::
    ld a, [hl+]                                   ; $204A
    ld e, a                                       ; $204B
    ld a, [hl+]                                   ; $204C
    ld d, a                                       ; $204D
    push hl                                       ; $204E
    ld b, BANK(ScriptSlots_Add)                   ; $204F
    ld hl, ScriptSlots_Add                        ; $2051
    call Far_Call                                 ; $2054
    pop hl                                        ; $2057
    scf                                           ; $2058
    ret                                           ; $2059


; C: object creation with BC = 0; falls into Object_CreateWithParam
Object_Create::
    ld bc, $0000                                  ; $205A

; C: DE = descriptor in bank 2; BC = parameter; fills a 23-byte slot at $DAEE
Object_CreateWithParam::
    ldh a, [hRomBankShadow]                       ; $205D
    push af                                       ; $205F
    ld a, $02                                     ; $2060
    ldh [hRomBankShadow], a                       ; $2062
    ld [$2100], a                                 ; $2064
    push bc                                       ; $2067
    push de                                       ; $2068
    ld de, $0017                                  ; $2069
    ld hl, wObject_CreateWithParam_DAEE           ; $206C
    ld b, $10                                     ; $206F

jr_000_2071:
    inc hl                                        ; $2071
    ld a, [hl-]                                   ; $2072
    cp $80                                        ; $2073
    jr z, jr_000_207a                             ; $2075

    or [hl]                                       ; $2077
    jr z, jr_000_2087                             ; $2078

jr_000_207a:
    add hl, de                                    ; $207A
    dec b                                         ; $207B
    jr nz, jr_000_2071                            ; $207C

    pop de                                        ; $207E
    pop bc                                        ; $207F
    pop af                                        ; $2080
    ldh [hRomBankShadow], a                       ; $2081
    ld [$2100], a                                 ; $2083
    ret                                           ; $2086


jr_000_2087:
    pop de                                        ; $2087
    pop bc                                        ; $2088
    push de                                       ; $2089
    push hl                                       ; $208A
    push hl                                       ; $208B
    xor a                                         ; $208C
    ld [hl+], a                                   ; $208D
    ld a, $80                                     ; $208E
    ld [hl+], a                                   ; $2090
    ld a, [de]                                    ; $2091
    ld [hl+], a                                   ; $2092
    inc de                                        ; $2093
    ld a, [de]                                    ; $2094
    ld [hl+], a                                   ; $2095
    inc de                                        ; $2096
    ld a, [de]                                    ; $2097
    ld [hl+], a                                   ; $2098
    inc de                                        ; $2099
    ld a, [de]                                    ; $209A
    ld [hl+], a                                   ; $209B
    inc de                                        ; $209C
    ld a, $01                                     ; $209D
    ld [hl+], a                                   ; $209F
    xor a                                         ; $20A0
    ld [hl+], a                                   ; $20A1
    xor a                                         ; $20A2
    ld [hl+], a                                   ; $20A3
    ld [hl+], a                                   ; $20A4
    ld [hl+], a                                   ; $20A5
    ld [hl+], a                                   ; $20A6
    ld a, $00                                     ; $20A7
    ld [hl+], a                                   ; $20A9
    ld a, $00                                     ; $20AA
    ld [hl+], a                                   ; $20AC
    xor a                                         ; $20AD
    ld [hl+], a                                   ; $20AE
    ld a, c                                       ; $20AF
    ld [hl+], a                                   ; $20B0
    xor a                                         ; $20B1
    ld [hl+], a                                   ; $20B2
    ld a, b                                       ; $20B3
    ld [hl+], a                                   ; $20B4
    ld a, $03                                     ; $20B5
    ld [hl+], a                                   ; $20B7
    xor a                                         ; $20B8
    ld [hl+], a                                   ; $20B9
    ld [hl+], a                                   ; $20BA
    ld [hl+], a                                   ; $20BB
    ld [hl+], a                                   ; $20BC
    ld a, [de]                                    ; $20BD
    ld c, a                                       ; $20BE
    inc de                                        ; $20BF
    ld a, [de]                                    ; $20C0
    ld b, a                                       ; $20C1
    inc de                                        ; $20C2
    pop hl                                        ; $20C3
    call Call_BC                                  ; $20C4
    pop hl                                        ; $20C7
    pop de                                        ; $20C8
    ld a, e                                       ; $20C9
    ld [hl+], a                                   ; $20CA
    ld a, d                                       ; $20CB
    ld [hl+], a                                   ; $20CC
    pop af                                        ; $20CD
    ldh [hRomBankShadow], a                       ; $20CE
    ld [$2100], a                                 ; $20D0
    ret                                           ; $20D3


; C: $DC60 = $FF (Object_RunAll does nothing)
Objects_Freeze::
    ld a, $ff                                     ; $20D4
    ld [wObjects_Freeze_DC60], a                  ; $20D6
    ret                                           ; $20D9


; C: $DC60 = 0
Objects_Unfreeze::
    xor a                                         ; $20DA
    ld [wObjects_Freeze_DC60], a                  ; $20DB
    ret                                           ; $20DE


; C: the per-frame pass over the object slots (far-called from 00:1ACA; runs the slot routines at 00:2113 and
; 00:212F); code read
Object_RunAll::
    ld a, [wObjects_Freeze_DC60]                  ; $20DF
    and a                                         ; $20E2
    jr z, jr_000_20e8                             ; $20E3

    jp Far_Return                                 ; $20E5


jr_000_20e8:
    ldh a, [hRomBankShadow]                       ; $20E8
    push af                                       ; $20EA
    ld a, $02                                     ; $20EB
    ldh [hRomBankShadow], a                       ; $20ED
    ld [$2100], a                                 ; $20EF
    ld hl, wObject_CreateWithParam_DAEE           ; $20F2
    ld b, $10                                     ; $20F5

jr_000_20f7:
    push bc                                       ; $20F7
    push hl                                       ; $20F8
    ld a, l                                       ; $20F9
    ld [wObject_RunAll_DC5E], a                   ; $20FA
    ld a, h                                       ; $20FD
    ld [wObject_RunAll_DC5F], a                   ; $20FE
    inc hl                                        ; $2101
    ld a, [hl-]                                   ; $2102
    cp $80                                        ; $2103
    jr z, jr_000_2153                             ; $2105

    or [hl]                                       ; $2107
    jr z, jr_000_2153                             ; $2108

    call Obj_LoadSlotToHram                       ; $210A
    ldh a, [hObjCmd_SetCallback_FFC7]             ; $210D
    ld l, a                                       ; $210F
    ldh a, [hObjCmd_SetCallback_FFC8]             ; $2110
    ld h, a                                       ; $2112
    call Call_HL                                  ; $2113
    ldh a, [hObject_RunAll_FFC9]                  ; $2116
    ld c, a                                       ; $2118
    ldh a, [hObject_RunAll_FFCA]                  ; $2119
    ld b, a                                       ; $211B
    dec bc                                        ; $211C
    ld a, b                                       ; $211D
    or c                                          ; $211E
    jr nz, jr_000_2145                            ; $211F

    ldh a, [hObject_RunAll_FFC5]                  ; $2121
    ld l, a                                       ; $2123
    ldh a, [hObject_RunAll_FFC6]                  ; $2124
    ld h, a                                       ; $2126

jr_000_2127:
    ld a, [hl+]                                   ; $2127
    ld c, a                                       ; $2128
    ld a, [hl+]                                   ; $2129
    bit 7, a                                      ; $212A
    jr nz, jr_000_2136                            ; $212C

    ld b, a                                       ; $212E
    call Call_BC                                  ; $212F
    jr c, jr_000_2127                             ; $2132

    jr nc, jr_000_213f                            ; $2134

jr_000_2136:
    and $7f                                       ; $2136
    ld b, a                                       ; $2138
    ld a, [hl+]                                   ; $2139
    ldh [hCopyReqSrcDstCnt + $4], a               ; $213A
    ld a, [hl+]                                   ; $213C
    ldh [hObject_RunAll_FFD0], a                  ; $213D

jr_000_213f:
    ld a, l                                       ; $213F
    ldh [hObject_RunAll_FFC5], a                  ; $2140
    ld a, h                                       ; $2142
    ldh [hObject_RunAll_FFC6], a                  ; $2143

jr_000_2145:
    ld a, c                                       ; $2145
    ldh [hObject_RunAll_FFC9], a                  ; $2146
    ld a, b                                       ; $2148
    ldh [hObject_RunAll_FFCA], a                  ; $2149
    call Obj_ApplySpeed                           ; $214B
    pop hl                                        ; $214E
    push hl                                       ; $214F
    call Obj_SaveSlotFromHram                     ; $2150

jr_000_2153:
    pop hl                                        ; $2153
    ld de, $0017                                  ; $2154
    add hl, de                                    ; $2157
    pop bc                                        ; $2158
    dec b                                         ; $2159
    jr nz, jr_000_20f7                            ; $215A

    pop af                                        ; $215C
    ldh [hRomBankShadow], a                       ; $215D
    ld [$2100], a                                 ; $215F
    jp Far_Return                                 ; $2162


; C: the 23 bytes of the slot at HL into hFFC3-hFFD9
Obj_LoadSlotToHram::
    ld b, $17                                     ; $2165
    ld c, $c3                                     ; $2167

jr_000_2169:
    ld a, [hl+]                                   ; $2169
    ldh [c], a                                    ; $216A
    inc c                                         ; $216B
    dec b                                         ; $216C
    jr nz, jr_000_2169                            ; $216D

    ret                                           ; $216F


; C: hFFC3-hFFD9 into the 23 bytes at HL
Obj_SaveSlotFromHram::
    ld b, $17                                     ; $2170
    ld c, $c3                                     ; $2172

jr_000_2174:
    ldh a, [c]                                    ; $2174
    ld [hl+], a                                   ; $2175
    inc c                                         ; $2176
    dec b                                         ; $2177
    jr nz, jr_000_2174                            ; $2178

    ret                                           ; $217A


; C: position (hFFD1-hFFD4) + speed (hFFCB-hFFCC)
Obj_ApplySpeed::
    ldh a, [hCopyReqSrcDstCnt]                    ; $217B
    ld c, a                                       ; $217D
    ldh a, [hCopyReqSrcDstCnt + $1]               ; $217E
    ld b, a                                       ; $2180
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $2181
    add c                                         ; $2183
    ldh [hPlayMenu_CursorUpdate_FFD1], a          ; $2184
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $2186
    adc b                                         ; $2188
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $2189
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $218B
    ld c, a                                       ; $218D
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $218E
    ld b, a                                       ; $2190
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $2191
    add c                                         ; $2193
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $2194
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $2196
    adc b                                         ; $2198
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $2199
    ret                                           ; $219B


; C: bank A: the OAM entries of the sprite layout at HL at the object position, into the OAM shadow from [$D880]
Obj_DrawSprite::
    ldh [hRomBankShadow], a                       ; $219C
    ld [$2100], a                                 ; $219E
    ld a, [wOamUsedEnd]                           ; $21A1
    ld e, a                                       ; $21A4
    ld d, $d6                                     ; $21A5

jr_000_21a7:
    ld a, [hl+]                                   ; $21A7
    add c                                         ; $21A8
    ld [de], a                                    ; $21A9
    inc e                                         ; $21AA
    ld a, [hl+]                                   ; $21AB
    add b                                         ; $21AC
    ld [de], a                                    ; $21AD
    inc e                                         ; $21AE
    ld a, [hl+]                                   ; $21AF
    ld [de], a                                    ; $21B0
    inc e                                         ; $21B1
    ld a, [hl+]                                   ; $21B2
    ld [de], a                                    ; $21B3
    inc e                                         ; $21B4
    and $01                                       ; $21B5
    jr z, jr_000_21a7                             ; $21B7

    ld a, e                                       ; $21B9
    ld [wOamUsedEnd], a                           ; $21BA
    ret                                           ; $21BD


; C: draws the sprite of every visible slot of $DAEE (each frame after Object_RunAll); code read
Objects_DrawAll::
    ldh a, [hRomBankShadow]                       ; $21BE
    push af                                       ; $21C0
    ld hl, wObject_CreateWithParam_DAEE           ; $21C1
    ld b, $10                                     ; $21C4

jr_000_21c6:
    inc hl                                        ; $21C6
    ld a, [hl-]                                   ; $21C7
    cp $80                                        ; $21C8
    jr z, jr_000_21f7                             ; $21CA

    or [hl]                                       ; $21CC
    jr z, jr_000_21f7                             ; $21CD

    push bc                                       ; $21CF
    push hl                                       ; $21D0
    ld bc, $000c                                  ; $21D1
    add hl, bc                                    ; $21D4
    ld a, [hl+]                                   ; $21D5
    ld e, a                                       ; $21D6
    ld a, [hl+]                                   ; $21D7
    ld d, a                                       ; $21D8
    or e                                          ; $21D9
    jr z, jr_000_21f5                             ; $21DA

    inc hl                                        ; $21DC
    ld a, [hl+]                                   ; $21DD
    ld b, a                                       ; $21DE
    inc hl                                        ; $21DF
    ld a, [hl+]                                   ; $21E0
    ld c, a                                       ; $21E1
    ld a, [hl+]                                   ; $21E2
    bit 0, [hl]                                   ; $21E3
    jr z, jr_000_21f0                             ; $21E5

    push af                                       ; $21E7
    ld a, [wPrintGame_SaveKittyPos_D94C]          ; $21E8
    cpl                                           ; $21EB
    inc a                                         ; $21EC
    add b                                         ; $21ED
    ld b, a                                       ; $21EE
    pop af                                        ; $21EF

jr_000_21f0:
    ld l, e                                       ; $21F0
    ld h, d                                       ; $21F1
    call Obj_DrawSprite                           ; $21F2

jr_000_21f5:
    pop hl                                        ; $21F5
    pop bc                                        ; $21F6

jr_000_21f7:
    ld de, $0017                                  ; $21F7
    add hl, de                                    ; $21FA
    dec b                                         ; $21FB
    jr nz, jr_000_21c6                            ; $21FC

    pop af                                        ; $21FE
    ldh [hRomBankShadow], a                       ; $21FF
    ld [$2100], a                                 ; $2201
    ret                                           ; $2204


Call_000_2205:
Jump_000_2205:
    ld a, e                                       ; $2205
    ldh [hObject_RunAll_FFC5], a                  ; $2206
    ld a, d                                       ; $2208
    ldh [hObject_RunAll_FFC6], a                  ; $2209
    xor a                                         ; $220B
    ldh [hObject_RunAll_FFCA], a                  ; $220C
    inc a                                         ; $220E
    ldh [hObject_RunAll_FFC9], a                  ; $220F
    ret                                           ; $2211


; C: Obj_ClearCallback and the end script 02:7FC0
Obj_End::
    call Obj_ClearCallback                        ; $2212
    ld de, $7fc0                                  ; $2215
    jp Jump_000_2205                              ; $2218


    db $c9

; C: hFFC7-hFFC8 = Obj_NullCallback
Obj_ClearCallback::
    ld a, $b9                                     ; $221C
    ldh [hObjCmd_SetCallback_FFC7], a             ; $221E
    ld a, $7f                                     ; $2220
    ldh [hObjCmd_SetCallback_FFC8], a             ; $2222
    ret                                           ; $2224


; C: hFFC7-hFFC8 = DE
Obj_SetCallback::
    ld a, e                                       ; $2225
    ldh [hObjCmd_SetCallback_FFC7], a             ; $2226
    ld a, d                                       ; $2228
    ldh [hObjCmd_SetCallback_FFC8], a             ; $2229
    ret                                           ; $222B


; C: hFFCF-hFFD0 = 0
Obj_HideSprite::
    ld a, $00                                     ; $222C
    ldh [hCopyReqSrcDstCnt + $4], a               ; $222E
    ld a, $00                                     ; $2230
    ldh [hObject_RunAll_FFD0], a                  ; $2232
    ret                                           ; $2234


    db $7b, $e0, $cf, $7a, $e0, $d0, $c9

; C: {id, channel 0-3} at HL: the sound into $D060 / $D068 / $D070 / $D078
Obj_Sound::
    push de                                       ; $223C
    ld a, [hl+]                                   ; $223D
    push af                                       ; $223E
    ld a, [hl]                                    ; $223F
    call JumpTable_Inline                         ; $2240

; C: read in the runs by JumpTable_Inline; first read on the screen Mode01_MainMenu_State02
; (trace/read_screens_kitty.npz)
Obj_Sound_JumpTbl2243::
    dw Obj_SoundCh0
    dw Obj_SoundCh1
    dw Obj_SoundCh2
    dw Obj_SoundCh3

; C: channel 0 of Obj_Sound: $D060
Obj_SoundCh0::
    pop af                                        ; $224B
    ld [wSndSfx1], a                              ; $224C
    jr jr_000_2261                                ; $224F

; C: channel 1 of Obj_Sound: $D068
Obj_SoundCh1::
    pop af                                        ; $2251
    ld [wSndMusicReq], a                          ; $2252
    jr jr_000_2261                                ; $2255

; C: channel 2 of Obj_Sound: $D070
Obj_SoundCh2::
    pop af                                        ; $2257
    ld [wSndSfx3], a                              ; $2258
    jr jr_000_2261                                ; $225B

; C: channel 3 of Obj_Sound: $D078
Obj_SoundCh3::
    pop af                                        ; $225D
    ld [wSndSfx4], a                              ; $225E

jr_000_2261:
    pop de                                        ; $2261
    ret                                           ; $2262


; C: the slot script hFFDC-hFFDD = DE, hFFE1 = 0, hFFE0 = 1
ScriptSlot_StartScript::
    ld a, e                                       ; $2263
    ldh [hScriptSlots_Run_FFDC], a                ; $2264
    ld a, d                                       ; $2266
    ldh [hScriptSlots_Run_FFDD], a                ; $2267
    xor a                                         ; $2269
    ldh [hScriptSlot_StartScript_FFE1], a         ; $226A
    inc a                                         ; $226C
    ldh [hScriptSlots_Run_FFE0], a                ; $226D
    ret                                           ; $226F


; C: goes over the 6 script slots of $DC67; code read
ScriptSlots_Tick::
    ld hl, wScriptSlots_Tick_DC67                 ; $2270
    ld b, $06                                     ; $2273

jr_000_2275:
    ld a, [hl+]                                   ; $2275
    ld a, [hl]                                    ; $2276
    bit 7, a                                      ; $2277
    jr z, jr_000_229e                             ; $2279

    cp $80                                        ; $227B
    jr z, jr_000_229e                             ; $227D

    res 7, [hl]                                   ; $227F
    push bc                                       ; $2281
    push hl                                       ; $2282
    ld bc, $0006                                  ; $2283
    add hl, bc                                    ; $2286
    ld a, [hl+]                                   ; $2287
    ld b, a                                       ; $2288
    ld a, [hl+]                                   ; $2289
    ld c, a                                       ; $228A
    ld a, [hl+]                                   ; $228B
    ld e, a                                       ; $228C
    ld a, [hl+]                                   ; $228D
    ld d, a                                       ; $228E
    ld a, [hl+]                                   ; $228F
    or d                                          ; $2290
    ld d, a                                       ; $2291
    push de                                       ; $2292
    ld a, [hl+]                                   ; $2293
    ld e, a                                       ; $2294
    ld a, [hl+]                                   ; $2295
    ld d, a                                       ; $2296
    ld a, [hl+]                                   ; $2297
    pop hl                                        ; $2298
    call Map_CopyRect                             ; $2299
    pop hl                                        ; $229C
    pop bc                                        ; $229D

jr_000_229e:
    ld de, $0013                                  ; $229E
    add hl, de                                    ; $22A1
    dec b                                         ; $22A2
    jr nz, jr_000_2275                            ; $22A3

    ret                                           ; $22A5


; C: bank A: C rows of B bytes from DE into the map at HL (the rest of each 32-byte row skipped); code read
Map_CopyRect::
    ldh [hRomBankShadow], a                       ; $22A6
    ld [$2100], a                                 ; $22A8
    ld a, b                                       ; $22AB
    ldh [hCopy_Inline_FF9E], a                    ; $22AC
    ld a, $20                                     ; $22AE
    sub b                                         ; $22B0
    ldh [hCopy_Inline_FF9F], a                    ; $22B1

jr_000_22b3:
    ldh a, [hCopy_Inline_FF9E]                    ; $22B3
    ld b, a                                       ; $22B5

jr_000_22b6:
    ld a, [de]                                    ; $22B6
    ld [hl+], a                                   ; $22B7
    inc de                                        ; $22B8
    dec b                                         ; $22B9
    jr nz, jr_000_22b6                            ; $22BA

    ldh a, [hCopy_Inline_FF9F]                    ; $22BC
    add l                                         ; $22BE
    ld l, a                                       ; $22BF
    jr nc, jr_000_22c3                            ; $22C0

    inc h                                         ; $22C2

jr_000_22c3:
    dec c                                         ; $22C3
    jr nz, jr_000_22b3                            ; $22C4

    ret                                           ; $22C6


; C: same code as the Japanese Mode1D_RenderBand (00:3161, 110 bytes, masked match)
Mode1D_RenderBand::
    ld hl, wPrintBandDesc                         ; $22C7
    ld de, wSlotTagOwnerCopy_D100                 ; $22CA
    ld b, $28                                     ; $22CD

jr_000_22cf:
    push bc                                       ; $22CF
    push hl                                       ; $22D0
    push de                                       ; $22D1
    ld a, [hl+]                                   ; $22D2
    bit 5, [hl]                                   ; $22D3
    call z, Mode1D_SplitNibbles                   ; $22D5
    call nz, Obj_AToDE                            ; $22D8
    push de                                       ; $22DB
    ld a, [hl]                                    ; $22DC
    ld b, a                                       ; $22DD
    ld hl, wPrintSrcTable                         ; $22DE
    call Mode1D_ReadSrcEntry                      ; $22E1
    pop hl                                        ; $22E4
    add hl, de                                    ; $22E5
    pop de                                        ; $22E6
    bit 7, b                                      ; $22E7
    jr z, jr_000_22f2                             ; $22E9

    push af                                       ; $22EB
    ld a, $01                                     ; $22EC
    ld [wPrintLastBand], a                        ; $22EE
    pop af                                        ; $22F1

jr_000_22f2:
    bit 6, b                                      ; $22F2
    jr z, jr_000_22fd                             ; $22F4

    ld c, $04                                     ; $22F6
    call Mode1D_FillBlank                         ; $22F8
    jr jr_000_2324                                ; $22FB

jr_000_22fd:
    bit 5, b                                      ; $22FD
    jr z, jr_000_2314                             ; $22FF

    push de                                       ; $2301
    call Mode1D_ReadByteFromBank                  ; $2302
    ld a, c                                       ; $2305
    call Mode1D_SplitNibbles                      ; $2306
    push de                                       ; $2309
    ld a, b                                       ; $230A
    ld hl, wPrintSrcTable2                        ; $230B
    call Mode1D_ReadSrcEntry                      ; $230E
    pop hl                                        ; $2311
    add hl, de                                    ; $2312
    pop de                                        ; $2313

jr_000_2314:
    bit 4, b                                      ; $2314
    jr z, jr_000_231f                             ; $2316

    ld c, $04                                     ; $2318
    call Mode1D_InterleaveTileRows                ; $231A
    jr jr_000_2324                                ; $231D

jr_000_231f:
    ld c, $04                                     ; $231F
    call Mode1D_CopyDescriptors                   ; $2321

jr_000_2324:
    bit 3, b                                      ; $2324
    jr z, jr_000_232d                             ; $2326

    ld a, $01                                     ; $2328
    ld [wPrintLastPage], a                        ; $232A

jr_000_232d:
    pop hl                                        ; $232D
    pop bc                                        ; $232E
    inc hl                                        ; $232F
    inc hl                                        ; $2330
    dec b                                         ; $2331
    jr nz, jr_000_22cf                            ; $2332

    ret                                           ; $2334


; C: same instructions as the Japanese Mode1D_SplitNibbles (00:31CF) over the whole routine (10 instructions, to the
; first ret / jp), only the addresses differ; code compared
Mode1D_SplitNibbles::
    push af                                       ; $2335
    swap a                                        ; $2336
    push af                                       ; $2338
    and $f0                                       ; $2339
    ld e, a                                       ; $233B
    pop af                                        ; $233C
    and $0f                                       ; $233D
    ld d, a                                       ; $233F
    pop af                                        ; $2340
    ret                                           ; $2341


; C: DE = A
Obj_AToDE::
    push af                                       ; $2342
    ld e, a                                       ; $2343
    ld d, $00                                     ; $2344
    pop af                                        ; $2346
    ret                                           ; $2347


; C: same code as the Japanese Mode1D_ReadSrcEntry (00:31E2, 16 bytes, exact match)
Mode1D_ReadSrcEntry::
    and $03                                       ; $2348
    sla a                                         ; $234A
    sla a                                         ; $234C
    ld e, a                                       ; $234E
    ld d, $00                                     ; $234F
    add hl, de                                    ; $2351
    ld e, [hl]                                    ; $2352
    inc hl                                        ; $2353
    ld d, [hl]                                    ; $2354
    inc hl                                        ; $2355
    ld a, [hl]                                    ; $2356
    ret                                           ; $2357


; C: same code as the Japanese Mode1D_ReadByteFromBank (00:31F2, 34 bytes, masked match)
Mode1D_ReadByteFromBank::
    bit 7, h                                      ; $2358
    jr nz, jr_000_236b                            ; $235A

    ldh [hBankTmp], a                             ; $235C
    ldh a, [hRomBankShadow]                       ; $235E
    push af                                       ; $2360
    ldh a, [hBankTmp]                             ; $2361
    ldh [hRomBankShadow], a                       ; $2363
    ld [rROMB0], a                                ; $2365
    scf                                           ; $2368
    jr jr_000_236f                                ; $2369

jr_000_236b:
    ld [rRAMB], a                                 ; $236B
    and a                                         ; $236E

jr_000_236f:
    push af                                       ; $236F
    ld c, [hl]                                    ; $2370
    pop af                                        ; $2371
    ret nc                                        ; $2372

    pop af                                        ; $2373
    ldh [hRomBankShadow], a                       ; $2374
    ld [rROMB0], a                                ; $2376
    ret                                           ; $2379


; C: same code as the Japanese Mode1D_CopyDescriptors (00:3214, 53 bytes, masked match)
Mode1D_CopyDescriptors::
    cp $ff                                        ; $237A
    jp z, Mode1D_FillBlank                        ; $237C

    bit 7, h                                      ; $237F
    jr nz, jr_000_2392                            ; $2381

    ldh [hBankTmp], a                             ; $2383
    ldh a, [hRomBankShadow]                       ; $2385
    push af                                       ; $2387
    ldh a, [hBankTmp]                             ; $2388
    ldh [hRomBankShadow], a                       ; $238A
    ld [rROMB0], a                                ; $238C
    scf                                           ; $238F
    jr jr_000_2396                                ; $2390

jr_000_2392:
    ld [rRAMB], a                                 ; $2392
    and a                                         ; $2395

jr_000_2396:
    push af                                       ; $2396

jr_000_2397:
    ld a, [hl+]                                   ; $2397
    ld [de], a                                    ; $2398
    inc de                                        ; $2399
    ld a, [hl+]                                   ; $239A
    ld [de], a                                    ; $239B
    inc de                                        ; $239C
    ld a, [hl+]                                   ; $239D
    ld [de], a                                    ; $239E
    inc de                                        ; $239F
    ld a, [hl+]                                   ; $23A0
    ld [de], a                                    ; $23A1
    inc de                                        ; $23A2
    dec c                                         ; $23A3
    jr nz, jr_000_2397                            ; $23A4

    pop af                                        ; $23A6
    ret nc                                        ; $23A7

    pop af                                        ; $23A8
    ldh [hRomBankShadow], a                       ; $23A9
    ld [rROMB0], a                                ; $23AB
    ret                                           ; $23AE


; C: same code as the Japanese Mode1D_InterleaveTileRows (00:3249, 146 bytes, masked match)
Mode1D_InterleaveTileRows::
    cp $ff                                        ; $23AF
    jp z, Mode1D_FillBlank                        ; $23B1

    bit 7, h                                      ; $23B4
    jr nz, jr_000_23c7                            ; $23B6

    ldh [hBankTmp], a                             ; $23B8
    ldh a, [hRomBankShadow]                       ; $23BA
    push af                                       ; $23BC
    ldh a, [hBankTmp]                             ; $23BD
    ldh [hRomBankShadow], a                       ; $23BF
    ld [rROMB0], a                                ; $23C1
    scf                                           ; $23C4
    jr jr_000_23cb                                ; $23C5

jr_000_23c7:
    ld [rRAMB], a                                 ; $23C7
    and a                                         ; $23CA

jr_000_23cb:
    push af                                       ; $23CB
    srl c                                         ; $23CC
    srl c                                         ; $23CE

jr_000_23d0:
    push bc                                       ; $23D0
    ld c, $08                                     ; $23D1

jr_000_23d3:
    ld a, [hl+]                                   ; $23D3
    ld b, [hl]                                    ; $23D4
    push hl                                       ; $23D5
    ld h, d                                       ; $23D6
    ld l, e                                       ; $23D7
    sla a                                         ; $23D8
    rr [hl]                                       ; $23DA
    inc hl                                        ; $23DC
    sla b                                         ; $23DD
    rr [hl]                                       ; $23DF
    inc hl                                        ; $23E1
    sla a                                         ; $23E2
    rr [hl]                                       ; $23E4
    inc hl                                        ; $23E6
    sla b                                         ; $23E7
    rr [hl]                                       ; $23E9
    inc hl                                        ; $23EB
    sla a                                         ; $23EC
    rr [hl]                                       ; $23EE
    inc hl                                        ; $23F0
    sla b                                         ; $23F1
    rr [hl]                                       ; $23F3
    inc hl                                        ; $23F5
    sla a                                         ; $23F6
    rr [hl]                                       ; $23F8
    inc hl                                        ; $23FA
    sla b                                         ; $23FB
    rr [hl]                                       ; $23FD
    inc hl                                        ; $23FF
    sla a                                         ; $2400
    rr [hl]                                       ; $2402
    inc hl                                        ; $2404
    sla b                                         ; $2405
    rr [hl]                                       ; $2407
    inc hl                                        ; $2409
    sla a                                         ; $240A
    rr [hl]                                       ; $240C
    inc hl                                        ; $240E
    sla b                                         ; $240F
    rr [hl]                                       ; $2411
    inc hl                                        ; $2413
    sla a                                         ; $2414
    rr [hl]                                       ; $2416
    inc hl                                        ; $2418
    sla b                                         ; $2419
    rr [hl]                                       ; $241B
    inc hl                                        ; $241D
    sla a                                         ; $241E
    rr [hl]                                       ; $2420
    inc hl                                        ; $2422
    sla b                                         ; $2423
    rr [hl]                                       ; $2425
    inc hl                                        ; $2427
    pop hl                                        ; $2428
    inc hl                                        ; $2429
    dec c                                         ; $242A
    jr nz, jr_000_23d3                            ; $242B

    pop bc                                        ; $242D
    ld a, e                                       ; $242E
    add $10                                       ; $242F
    ld e, a                                       ; $2431
    jr nc, jr_000_2435                            ; $2432

    inc d                                         ; $2434

jr_000_2435:
    dec c                                         ; $2435
    jr nz, jr_000_23d0                            ; $2436

    pop af                                        ; $2438
    ret nc                                        ; $2439

    pop af                                        ; $243A
    ldh [hRomBankShadow], a                       ; $243B
    ld [rROMB0], a                                ; $243D
    ret                                           ; $2440


; C: same instructions as the Japanese Mode1D_FillBlank (00:32DB) over the whole routine (12 instructions, to the
; first ret / jp), only the addresses differ; code compared
Mode1D_FillBlank::
    xor a                                         ; $2441

jr_000_2442:
    ld [de], a                                    ; $2442
    inc de                                        ; $2443
    ld [de], a                                    ; $2444
    inc de                                        ; $2445
    ld [de], a                                    ; $2446
    inc de                                        ; $2447
    ld [de], a                                    ; $2448
    inc de                                        ; $2449
    dec c                                         ; $244A
    jr nz, jr_000_2442                            ; $244B

    ret                                           ; $244D


; C: 2 rows of 20 bytes of the stream [$D3F4] (bank [$D3F6]): each byte picks 16 bytes of $C000 for
; Mode1D_CopyDescriptors into $D100; the pointer advanced; code read; runs while printing (mode $06)
Print_StreamFromD3F4::
    ldh a, [hRomBankShadow]                       ; $244E
    push af                                       ; $2450
    ld a, [wPrint_SetFrameSide_D3F6]              ; $2451
    ldh [hRomBankShadow], a                       ; $2454
    ld [$2100], a                                 ; $2456
    ld a, [wPrint_StreamFromD3F4]                 ; $2459
    ld l, a                                       ; $245C
    ld a, [wPrint_StreamFromD3F4_D3F5]            ; $245D
    ld h, a                                       ; $2460
    ld de, $d100                                  ; $2461
    ld b, $02                                     ; $2464

jr_000_2466:
    push bc                                       ; $2466
    ld b, $14                                     ; $2467

jr_000_2469:
    push bc                                       ; $2469
    push hl                                       ; $246A
    ld a, [hl+]                                   ; $246B
    swap a                                        ; $246C
    push af                                       ; $246E
    and $f0                                       ; $246F
    ld c, a                                       ; $2471
    pop af                                        ; $2472
    and $0f                                       ; $2473
    ld b, a                                       ; $2475
    ld hl, $c000                                  ; $2476
    add hl, bc                                    ; $2479
    ld c, $04                                     ; $247A
    xor a                                         ; $247C
    call Mode1D_CopyDescriptors                   ; $247D
    pop hl                                        ; $2480
    inc hl                                        ; $2481
    pop bc                                        ; $2482
    dec b                                         ; $2483
    jr nz, jr_000_2469                            ; $2484

    ld bc, $000c                                  ; $2486
    add hl, bc                                    ; $2489
    ld a, l                                       ; $248A
    ld [wPrint_StreamFromD3F4], a                 ; $248B
    ld a, h                                       ; $248E
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $248F
    pop bc                                        ; $2492
    dec b                                         ; $2493
    jr nz, jr_000_2466                            ; $2494

    pop af                                        ; $2496
    ldh [hRomBankShadow], a                       ; $2497
    ld [$2100], a                                 ; $2499
    ret                                           ; $249C


    db $00, $60, $11, $00, $70, $11, $00, $80, $11

; C: record A of 00:249D (A = 1 at every call: 11:7000) loaded as $800 bytes of tiles at $9000 and $600 at $8000: the
; picture shown for a slot without a photo (called when Photo_FindSlotA returns carry); code read
Photo_LoadEmptyPicture::
    ld b, a                                       ; $24A6
    ldh a, [hRomBankShadow]                       ; $24A7
    push af                                       ; $24A9
    ld a, b                                       ; $24AA
    sla a                                         ; $24AB
    add b                                         ; $24AD
    ld c, a                                       ; $24AE
    ld b, $00                                     ; $24AF
    ld hl, Print_StreamFromD3F4 + $4F             ; $24B1
    add hl, bc                                    ; $24B4
    ld a, [hl+]                                   ; $24B5
    ld e, a                                       ; $24B6
    ld a, [hl+]                                   ; $24B7
    ld d, a                                       ; $24B8
    ld a, [hl+]                                   ; $24B9
    ldh [hRomBankShadow], a                       ; $24BA
    ld [$2100], a                                 ; $24BC
    push de                                       ; $24BF
    ld hl, $9000                                  ; $24C0
    ld bc, $0800                                  ; $24C3
    call Vram_CopyHBlank                          ; $24C6
    pop hl                                        ; $24C9
    ld de, $0800                                  ; $24CA
    add hl, de                                    ; $24CD
    ld e, l                                       ; $24CE
    ld d, h                                       ; $24CF
    ld hl, $8000                                  ; $24D0
    ld bc, $0600                                  ; $24D3
    call Vram_CopyHBlank                          ; $24D6
    pop af                                        ; $24D9
    ldh [hRomBankShadow], a                       ; $24DA
    ld [$2100], a                                 ; $24DC
    ret                                           ; $24DF


; C: expands a stored picture into the buffer at HL ($C000) (7 x 2 x 8 loops); code read
Img_ExpandThumb::
    ld c, $07                                     ; $24E0

Jump_000_24e2:
    push bc                                       ; $24E2
    ld c, $02                                     ; $24E3

jr_000_24e5:
    push bc                                       ; $24E5
    ld c, $08                                     ; $24E6

jr_000_24e8:
    push bc                                       ; $24E8
    push hl                                       ; $24E9
    ld bc, $0004                                  ; $24EA

jr_000_24ed:
    ld a, [de]                                    ; $24ED
    rla                                           ; $24EE
    rl b                                          ; $24EF
    rla                                           ; $24F1
    rla                                           ; $24F2
    rl b                                          ; $24F3
    rla                                           ; $24F5
    rla                                           ; $24F6
    rl b                                          ; $24F7
    rla                                           ; $24F9
    rla                                           ; $24FA
    rl b                                          ; $24FB
    ld a, b                                       ; $24FD
    swap a                                        ; $24FE
    and $f0                                       ; $2500
    ld [hl+], a                                   ; $2502
    inc de                                        ; $2503
    ld a, [de]                                    ; $2504
    rla                                           ; $2505
    rl b                                          ; $2506
    rla                                           ; $2508
    rla                                           ; $2509
    rl b                                          ; $250A
    rla                                           ; $250C
    rla                                           ; $250D
    rl b                                          ; $250E
    rla                                           ; $2510
    rla                                           ; $2511
    rl b                                          ; $2512
    ld a, b                                       ; $2514
    swap a                                        ; $2515
    and $f0                                       ; $2517
    ld [hl+], a                                   ; $2519
    inc de                                        ; $251A
    inc de                                        ; $251B
    inc de                                        ; $251C
    dec c                                         ; $251D
    jr nz, jr_000_24ed                            ; $251E

    pop hl                                        ; $2520
    ld bc, $0004                                  ; $2521

jr_000_2524:
    ld a, [de]                                    ; $2524
    rla                                           ; $2525
    rl b                                          ; $2526
    rla                                           ; $2528
    rla                                           ; $2529
    rl b                                          ; $252A
    rla                                           ; $252C
    rla                                           ; $252D
    rl b                                          ; $252E
    rla                                           ; $2530
    rla                                           ; $2531
    rl b                                          ; $2532
    ld a, b                                       ; $2534
    and $0f                                       ; $2535
    or [hl]                                       ; $2537
    ld [hl+], a                                   ; $2538
    inc de                                        ; $2539
    ld a, [de]                                    ; $253A
    rla                                           ; $253B
    rl b                                          ; $253C
    rla                                           ; $253E
    rla                                           ; $253F
    rl b                                          ; $2540
    rla                                           ; $2542
    rla                                           ; $2543
    rl b                                          ; $2544
    rla                                           ; $2546
    rla                                           ; $2547
    rl b                                          ; $2548
    ld a, b                                       ; $254A
    and $0f                                       ; $254B
    or [hl]                                       ; $254D
    ld [hl+], a                                   ; $254E
    inc de                                        ; $254F
    inc de                                        ; $2550
    inc de                                        ; $2551
    dec c                                         ; $2552
    jr nz, jr_000_2524                            ; $2553

    ld bc, $0008                                  ; $2555
    add hl, bc                                    ; $2558
    pop bc                                        ; $2559
    dec c                                         ; $255A
    jr nz, jr_000_24e8                            ; $255B

    ld bc, hImg_ExpandThumb_FF88                  ; $255D
    add hl, bc                                    ; $2560
    pop bc                                        ; $2561
    dec c                                         ; $2562
    jr nz, jr_000_24e5                            ; $2563

    ld bc, $0070                                  ; $2565
    add hl, bc                                    ; $2568
    pop bc                                        ; $2569
    dec c                                         ; $256A
    jp nz, Jump_000_24e2                          ; $256B

    ret                                           ; $256E


; C: the same record expanded by Img_ExpandThumb into $C000 and $380 bytes into $9000: the thumbnail of a slot without
; a photo; code read
Photo_LoadEmptyThumb::
    ld b, a                                       ; $256F
    ldh a, [hRomBankShadow]                       ; $2570
    push af                                       ; $2572
    ld a, b                                       ; $2573
    sla a                                         ; $2574
    add b                                         ; $2576
    ld c, a                                       ; $2577
    ld b, $00                                     ; $2578
    ld hl, Print_StreamFromD3F4 + $4F             ; $257A
    add hl, bc                                    ; $257D
    ld a, [hl+]                                   ; $257E
    ld e, a                                       ; $257F
    ld a, [hl+]                                   ; $2580
    ld d, a                                       ; $2581
    ld a, [hl+]                                   ; $2582
    ldh [hRomBankShadow], a                       ; $2583
    ld [$2100], a                                 ; $2585
    ld hl, $c000                                  ; $2588
    call Img_ExpandThumb                          ; $258B
    ld de, $c000                                  ; $258E
    ld hl, $9000                                  ; $2591
    ld bc, $0380                                  ; $2594
    call Vram_CopyHBlank                          ; $2597
    pop af                                        ; $259A
    ldh [hRomBankShadow], a                       ; $259B
    ld [$2100], a                                 ; $259D
    ret                                           ; $25A0


; C: same instructions as the Japanese Img_ReduceToThumbnail (00:2583) over the whole routine (18 instructions, to the
; first ret / jp), only the addresses differ; code compared
Img_ReduceToThumbnail::
    push bc                                       ; $25A1
    push de                                       ; $25A2
    push hl                                       ; $25A3
    ld e, [hl]                                    ; $25A4
    inc hl                                        ; $25A5
    ld a, [hl+]                                   ; $25A6
    ld d, a                                       ; $25A7
    cp $a0                                        ; $25A8
    ld a, [hl]                                    ; $25AA
    jr nc, jr_000_25bc                            ; $25AB

    ldh [hBankTmp], a                             ; $25AD
    ldh a, [hRomBankShadow]                       ; $25AF
    push af                                       ; $25B1
    ldh a, [hBankTmp]                             ; $25B2
    ldh [hRomBankShadow], a                       ; $25B4
    ld [$2100], a                                 ; $25B6
    scf                                           ; $25B9
    jr jr_000_25c9                                ; $25BA

jr_000_25bc:
    ldh [hBankTmp], a                             ; $25BC
    ldh a, [hSram_Format_FF8C]                    ; $25BE
    push af                                       ; $25C0
    ldh a, [hBankTmp]                             ; $25C1
    ldh [hSram_Format_FF8C], a                    ; $25C3
    ld [rRAMB], a                                 ; $25C5
    and a                                         ; $25C8

jr_000_25c9:
    push af                                       ; $25C9
    ld h, b                                       ; $25CA
    ld l, c                                       ; $25CB
    ld c, $04                                     ; $25CC

jr_000_25ce:
    push bc                                       ; $25CE
    ld b, $04                                     ; $25CF
    ld a, c                                       ; $25D1
    cp $01                                        ; $25D2
    jr nz, jr_000_25d8                            ; $25D4

    ld b, $02                                     ; $25D6

jr_000_25d8:
    ld c, $04                                     ; $25D8
    push hl                                       ; $25DA

jr_000_25db:
    push bc                                       ; $25DB
    push hl                                       ; $25DC
    ld hl, $d102                                  ; $25DD
    ld b, $08                                     ; $25E0

jr_000_25e2:
    ld c, $04                                     ; $25E2
    xor a                                         ; $25E4
    ld [hl+], a                                   ; $25E5
    ld [hl], a                                    ; $25E6

jr_000_25e7:
    call Img_PairLookup                           ; $25E7
    push af                                       ; $25EA
    and $0f                                       ; $25EB
    add [hl]                                      ; $25ED
    ld [hl-], a                                   ; $25EE
    pop af                                        ; $25EF
    swap a                                        ; $25F0
    and $0f                                       ; $25F2
    add [hl]                                      ; $25F4
    ld [hl+], a                                   ; $25F5
    dec c                                         ; $25F6
    jr nz, jr_000_25e7                            ; $25F7

    inc hl                                        ; $25F9
    dec b                                         ; $25FA
    jr nz, jr_000_25e2                            ; $25FB

    pop hl                                        ; $25FD
    push de                                       ; $25FE
    push hl                                       ; $25FF
    ld hl, $d102                                  ; $2600
    ld de, $0080                                  ; $2603
    call Img_PackQuadBits                         ; $2606
    pop hl                                        ; $2609
    ld [hl], c                                    ; $260A
    inc hl                                        ; $260B
    ld [hl], b                                    ; $260C
    inc hl                                        ; $260D
    push hl                                       ; $260E
    ld hl, $d104                                  ; $260F
    ld de, $0008                                  ; $2612
    call Img_PackQuadBits                         ; $2615
    pop hl                                        ; $2618
    ld [hl], c                                    ; $2619
    inc hl                                        ; $261A
    ld [hl], b                                    ; $261B
    ld bc, $000d                                  ; $261C
    add hl, bc                                    ; $261F
    pop de                                        ; $2620
    pop bc                                        ; $2621
    dec c                                         ; $2622
    jr nz, jr_000_25db                            ; $2623

    pop hl                                        ; $2625
    inc hl                                        ; $2626
    inc hl                                        ; $2627
    inc hl                                        ; $2628
    inc hl                                        ; $2629
    dec b                                         ; $262A
    jr nz, jr_000_25d8                            ; $262B

    ld bc, $0030                                  ; $262D
    add hl, bc                                    ; $2630
    pop bc                                        ; $2631
    dec c                                         ; $2632
    jr nz, jr_000_25ce                            ; $2633

    pop af                                        ; $2635
    jr nc, jr_000_2642                            ; $2636

    pop af                                        ; $2638
    ldh [hRomBankShadow], a                       ; $2639
    ld [$2100], a                                 ; $263B
    pop hl                                        ; $263E
    pop de                                        ; $263F
    pop bc                                        ; $2640
    ret                                           ; $2641


jr_000_2642:
    pop af                                        ; $2642
    ldh [hSram_Format_FF8C], a                    ; $2643
    ld [rRAMB], a                                 ; $2645
    pop hl                                        ; $2648
    pop de                                        ; $2649
    pop bc                                        ; $264A
    ret                                           ; $264B


; C: same code as the Japanese Img_PairLookup (00:261B, 22 bytes, exact match)
Img_PairLookup::
    push bc                                       ; $264C
    push hl                                       ; $264D
    ld b, $00                                     ; $264E
    ld a, [de]                                    ; $2650
    inc de                                        ; $2651
    ld l, a                                       ; $2652
    ld h, HIGH(Img_PairLookupTbl)                 ; $2653
    ld b, [hl]                                    ; $2655
    ld a, [de]                                    ; $2656
    inc de                                        ; $2657
    ld l, a                                       ; $2658
    ld h, HIGH(Img_PairLookupTbl)                 ; $2659
    ld a, [hl]                                    ; $265B
    sla a                                         ; $265C
    add b                                         ; $265E
    pop hl                                        ; $265F
    pop bc                                        ; $2660
    ret                                           ; $2661


; C: same code as the Japanese Img_PackQuadBits (00:2631, 37 bytes, exact match)
Img_PackQuadBits::
    ld bc, $0000                                  ; $2662
    ld a, $04                                     ; $2665

jr_000_2667:
    push af                                       ; $2667
    ld a, [hl+]                                   ; $2668
    add d                                         ; $2669
    swap a                                        ; $266A
    srl a                                         ; $266C
    rl c                                          ; $266E
    srl a                                         ; $2670
    rl b                                          ; $2672
    ld a, [hl+]                                   ; $2674
    add e                                         ; $2675
    swap a                                        ; $2676
    srl a                                         ; $2678
    rl c                                          ; $267A
    srl a                                         ; $267C
    rl b                                          ; $267E
    inc hl                                        ; $2680
    inc hl                                        ; $2681
    pop af                                        ; $2682
    dec a                                         ; $2683
    jr nz, jr_000_2667                            ; $2684

    ret                                           ; $2686


    db $c5, $d5, $e5, $5e, $23, $2a, $57, $fe, $a0, $7e, $30, $0f, $e0, $8a, $f0, $8b
    db $f5, $f0, $8a, $e0, $8b, $ea, $00, $21, $37, $18, $0d, $e0, $8a, $f0, $8c, $f5
    db $f0, $8a, $e0, $8c, $ea, $00, $40, $a7, $f5, $60, $69, $0e, $07, $c5, $06, $02
    db $0e, $08, $e5, $c5, $e5, $21, $02, $d1, $06, $08, $0e, $02, $af, $22, $22, $22
    db $77, $cd, $08, $29, $fa, $00, $d1, $f5, $e6, $0f, $86, $32, $f1, $cb, $37, $e6
    db $0f, $86, $32, $fa, $01, $d1, $f5, $e6, $0f, $86, $32, $f1, $cb, $37, $e6, $0f
    db $86, $22, $23, $23, $0d, $20, $da, $23, $05, $20, $cf, $e1, $d5, $e5, $21, $02
    db $d1, $11, $20, $00, $cd, $91, $29, $e1, $71, $23, $70, $23, $e5, $11, $02, $00
    db $21, $06, $d1, $cd, $91, $29, $e1, $71, $23, $70, $23, $e5, $11, $20, $00, $21
    db $0a, $d1, $cd, $91, $29, $e1, $71, $23, $70, $23, $e5, $11, $02, $00, $21, $0e
    db $d1, $cd, $91, $29, $e1, $71, $23, $70, $01, $09, $00, $09, $d1, $c1, $0d, $20
    db $82, $e1, $c5, $01, $08, $00, $09, $c1, $05, $c2, $b7, $26, $01, $70, $00, $09
    db $c1, $fa, $d8, $d8, $e6, $fe, $20, $12, $0d, $c2, $b4, $26, $f1, $30, $06, $f1
    db $e0, $8b, $ea, $00, $21, $e1, $d1, $c1, $a7, $c9, $f1, $30, $0b, $f1, $e0, $8b
    db $ea, $00, $21, $e1, $d1, $c1, $37, $c9, $f1, $e0, $8c, $ea, $00, $40, $e1, $d1
    db $c1, $37, $c9, $c5, $d5, $e5, $5e, $23, $2a, $57, $fe, $a0, $7e, $30, $0f, $e0
    db $8a, $f0, $8b, $f5, $f0, $8a, $e0, $8b, $ea, $00, $21, $37, $18, $0d, $e0, $8a
    db $f0, $8c, $f5, $f0, $8a, $e0, $8c, $ea, $00, $40, $a7, $f5, $60, $69, $0e, $04
    db $c5, $06, $02, $0e, $04, $e5, $c5, $e5, $21, $02, $d1, $06, $08, $0e, $02, $af
    db $22, $22, $22, $77, $cd, $08, $29, $fa, $00, $d1, $f5, $e6, $0f, $86, $32, $f1
    db $cb, $37, $e6, $0f, $86, $32, $fa, $01, $d1, $f5, $e6, $0f, $86, $32, $f1, $cb
    db $37, $e6, $0f, $86, $22, $23, $23, $0d, $20, $da, $23, $05, $20, $cf, $21, $02
    db $d1, $cd, $44, $29, $e1, $71, $23, $70, $23, $e5, $21, $06, $d1, $cd, $44, $29
    db $e1, $71, $23, $70, $23, $e5, $21, $0a, $d1, $cd, $44, $29, $e1, $71, $23, $70
    db $23, $e5, $21, $0e, $d1, $cd, $44, $29, $e1, $71, $23, $70, $01, $09, $00, $09
    db $c1, $0d, $20, $92, $7b, $c6, $80, $5f, $30, $01, $14, $e1, $c5, $01, $08, $00
    db $09, $c1, $05, $c2, $aa, $27, $01, $30, $00, $09, $c1, $0d, $c2, $a7, $27, $f1
    db $30, $0a, $f1, $e0, $8b, $ea, $00, $21, $e1, $d1, $c1, $c9, $f1, $e0, $8c, $ea
    db $00, $40, $e1, $d1, $c1, $c9, $c5, $d5, $e5, $5e, $23, $2a, $57, $fe, $a0, $7e
    db $30, $0f, $e0, $8a, $f0, $8b, $f5, $f0, $8a, $e0, $8b, $ea, $00, $21, $37, $18
    db $0d, $e0, $8a, $f0, $8c, $f5, $f0, $8a, $e0, $8c, $ea, $00, $40, $a7, $f5, $60
    db $69, $0e, $07, $c5, $06, $02, $0e, $08, $e5, $c5, $e5, $21, $02, $d1, $06, $04
    db $0e, $02, $af, $22, $22, $22, $77, $cd, $08, $29, $fa, $00, $d1, $f5, $e6, $0f
    db $86, $32, $f1, $cb, $37, $e6, $0f, $86, $32, $fa, $01, $d1, $f5, $e6, $0f, $86
    db $32, $f1, $cb, $37, $e6, $0f, $86, $22, $23, $23, $0d, $20, $da, $13, $13, $13
    db $13, $23, $23, $23, $23, $23, $05, $20, $c7, $21, $02, $d1, $cd, $44, $29, $e1
    db $71, $23, $70, $23, $e5, $21, $0a, $d1, $cd, $44, $29, $e1, $71, $23, $70, $01
    db $05, $00, $09, $c1, $0d, $20, $a2, $e1, $c5, $01, $04, $00, $09, $c1, $05, $20
    db $95, $01, $38, $00, $09, $c1, $0d, $c2, $7a, $28, $f1, $30, $0a, $f1, $e0, $8b
    db $ea, $00, $21, $e1, $d1, $c1, $c9, $f1, $e0, $8c, $ea, $00, $40, $e1, $d1, $c1
    db $c9, $c5, $e5, $1a, $e6, $0f, $c6, $f0, $6f, $26, $36, $7e, $4f, $1a, $cb, $37
    db $e6, $0f, $c6, $f0, $6f, $26, $36, $46, $13, $1a, $e6, $0f, $c6, $f0, $6f, $26
    db $36, $7e, $cb, $27, $81, $ea, $00, $d1, $1a, $cb, $37, $e6, $0f, $c6, $f0, $6f
    db $26, $36, $7e, $cb, $27, $80, $ea, $01, $d1, $13, $e1, $c1, $c9, $d5, $11, $0c
    db $00, $01, $00, $00, $3e, $02, $f5, $2a, $c6, $02, $cb, $3f, $cb, $3f, $cb, $3f
    db $cb, $11, $cb, $3f, $cb, $10, $2a, $c6, $02, $cb, $3f, $cb, $3f, $cb, $3f, $cb
    db $11, $cb, $3f, $cb, $10, $2a, $c6, $02, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $11
    db $cb, $3f, $cb, $10, $2a, $c6, $02, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $11, $cb
    db $3f, $cb, $10, $19, $f1, $3d, $20, $be, $d1, $c9, $01, $00, $00, $3e, $02, $f5
    db $2a, $82, $cb, $3f, $cb, $3f, $cb, $3f, $cb, $11, $cb, $3f, $cb, $10, $2a, $83
    db $cb, $3f, $cb, $3f, $cb, $3f, $cb, $11, $cb, $3f, $cb, $10, $2a, $82, $cb, $3f
    db $cb, $3f, $cb, $3f, $cb, $11, $cb, $3f, $cb, $10, $2a, $83, $cb, $3f, $cb, $3f
    db $cb, $3f, $cb, $11, $cb, $3f, $cb, $10, $7d, $c6, $0c, $6f, $30, $01, $24, $f1
    db $3d, $20, $bc, $c9

; C: same code as the Japanese Thumb_DrawFrame (00:296F, 138 bytes, exact match)
Thumb_DrawFrame::
    push bc                                       ; $29DB
    push de                                       ; $29DC
    push hl                                       ; $29DD
    ld de, $0000                                  ; $29DE
    bit 0, a                                      ; $29E1
    jr z, jr_000_29e7                             ; $29E3

    ld e, $ff                                     ; $29E5

jr_000_29e7:
    bit 1, a                                      ; $29E7
    jr z, jr_000_29ed                             ; $29E9

    ld d, $ff                                     ; $29EB

jr_000_29ed:
    push hl                                       ; $29ED
    ld bc, $000f                                  ; $29EE
    ld a, $04                                     ; $29F1

jr_000_29f3:
    ld [hl], e                                    ; $29F3
    inc hl                                        ; $29F4
    ld [hl], d                                    ; $29F5
    add hl, bc                                    ; $29F6
    dec a                                         ; $29F7
    jr nz, jr_000_29f3                            ; $29F8

    ld bc, $0086                                  ; $29FA
    add hl, bc                                    ; $29FD
    ld bc, $000f                                  ; $29FE
    ld a, $04                                     ; $2A01

jr_000_2a03:
    ld [hl], e                                    ; $2A03
    inc hl                                        ; $2A04
    ld [hl], d                                    ; $2A05
    add hl, bc                                    ; $2A06
    dec a                                         ; $2A07
    jr nz, jr_000_2a03                            ; $2A08

    pop hl                                        ; $2A0A
    push de                                       ; $2A0B
    push hl                                       ; $2A0C
    ld a, e                                       ; $2A0D
    and $80                                       ; $2A0E
    ld e, a                                       ; $2A10
    ld a, d                                       ; $2A11
    and $80                                       ; $2A12
    ld d, a                                       ; $2A14
    ld b, $04                                     ; $2A15

jr_000_2a17:
    push bc                                       ; $2A17
    ld c, $08                                     ; $2A18
    dec b                                         ; $2A1A
    jr nz, jr_000_2a1f                            ; $2A1B

    ld c, $04                                     ; $2A1D

jr_000_2a1f:
    ld a, [hl]                                    ; $2A1F
    and $7f                                       ; $2A20
    or e                                          ; $2A22
    ld [hl+], a                                   ; $2A23
    ld a, [hl]                                    ; $2A24
    and $7f                                       ; $2A25
    or d                                          ; $2A27
    ld [hl+], a                                   ; $2A28
    dec c                                         ; $2A29
    jr nz, jr_000_2a1f                            ; $2A2A

    ld bc, $0030                                  ; $2A2C
    add hl, bc                                    ; $2A2F
    pop bc                                        ; $2A30
    dec b                                         ; $2A31
    jr nz, jr_000_2a17                            ; $2A32

    pop hl                                        ; $2A34
    pop de                                        ; $2A35
    ld bc, $0030                                  ; $2A36
    add hl, bc                                    ; $2A39
    ld a, e                                       ; $2A3A
    and $01                                       ; $2A3B
    ld e, a                                       ; $2A3D
    ld a, d                                       ; $2A3E
    and $01                                       ; $2A3F
    ld d, a                                       ; $2A41
    ld b, $04                                     ; $2A42

jr_000_2a44:
    push bc                                       ; $2A44
    ld c, $08                                     ; $2A45
    dec b                                         ; $2A47
    jr nz, jr_000_2a4c                            ; $2A48

    ld c, $04                                     ; $2A4A

jr_000_2a4c:
    ld a, [hl]                                    ; $2A4C
    and $fe                                       ; $2A4D
    or e                                          ; $2A4F
    ld [hl+], a                                   ; $2A50
    ld a, [hl]                                    ; $2A51
    and $fe                                       ; $2A52
    or d                                          ; $2A54
    ld [hl+], a                                   ; $2A55
    dec c                                         ; $2A56
    jr nz, jr_000_2a4c                            ; $2A57

    ld bc, $0030                                  ; $2A59
    add hl, bc                                    ; $2A5C
    pop bc                                        ; $2A5D
    dec b                                         ; $2A5E
    jr nz, jr_000_2a44                            ; $2A5F

    pop hl                                        ; $2A61
    pop de                                        ; $2A62
    pop bc                                        ; $2A63
    ret                                           ; $2A64


; C: same code as the Japanese Thumb_DrawCopyBadge (00:29F9, 24 bytes, masked match)
Thumb_DrawCopyBadge::
    ld hl, Thumb_CopyBadgeTbl                     ; $2A65
    ld b, $06                                     ; $2A68

jr_000_2a6a:
    ld e, [hl]                                    ; $2A6A
    inc hl                                        ; $2A6B
    ld a, [de]                                    ; $2A6C
    or [hl]                                       ; $2A6D
    inc hl                                        ; $2A6E
    xor [hl]                                      ; $2A6F
    ld [de], a                                    ; $2A70
    inc de                                        ; $2A71
    dec hl                                        ; $2A72
    ld a, [de]                                    ; $2A73
    or [hl]                                       ; $2A74
    inc hl                                        ; $2A75
    xor [hl]                                      ; $2A76
    ld [de], a                                    ; $2A77
    inc hl                                        ; $2A78
    dec b                                         ; $2A79
    jr nz, jr_000_2a6a                            ; $2A7A

    ret                                           ; $2A7C


; C: the same 18 bytes as the Japanese Thumb_CopyBadgeTbl (00:2A11); named by the code of Thumb_DrawCopyBadge
; (00:2A65); read in the runs by Thumb_DrawCopyBadge; first read on the screen Mode03_ViewAlbum_State13
; (trace/read_screens_kitty.npz)
Thumb_CopyBadgeTbl::
    db $02, $fc, $30, $04, $fc, $48, $06, $fc, $40, $08, $fc, $48, $0a, $fc, $30, $0c
    db $fc, $00

; C: $CE00 cleared, Img_ReduceToThumbnail of the picture into $CE00, ...; code read
Photo_MakeThumbnail::
    ld hl, $ce00                                  ; $2A8F
    ld bc, $0100                                  ; $2A92
    call Call_000_01fe                            ; $2A95
    ld hl, Photo_MakeThumbnail_Tbl2AB6            ; $2A98
    ld bc, $ce00                                  ; $2A9B
    call Img_ReduceToThumbnail                    ; $2A9E
    ld hl, $ce00                                  ; $2AA1
    ld a, $03                                     ; $2AA4
    call Thumb_DrawFrame                          ; $2AA6
    ld a, [wSlotTagCopyFlag]                      ; $2AA9
    and a                                         ; $2AAC
    jr z, jr_000_2ab5                             ; $2AAD

    ld de, $ce00                                  ; $2AAF
    call Thumb_DrawCopyBadge                      ; $2AB2

jr_000_2ab5:
    ret                                           ; $2AB5


; C: named by the code of Photo_MakeThumbnail (00:2A98); read in the runs by Img_ReduceToThumbnail; first read on the
; screen Mode02_TakePhotos_State06 (trace/read_screens_kitty.npz)
Photo_MakeThumbnail_Tbl2AB6::
    db $00, $c0, $00

; C: the Japanese Blit_MaskPass_SrcB (00:1FB2), 81 instructions against 81, with 11 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Blit_MaskPass_SrcB::
    ld a, [wBlit_MaskPass_SrcB_D9F6]              ; $2AB9
    ld l, a                                       ; $2ABC
    ld a, [wBlit_MaskPass_SrcB_D9F7]              ; $2ABD
    ld h, a                                       ; $2AC0
    ldh a, [hRomBankShadow]                       ; $2AC1
    push af                                       ; $2AC3
    ld a, [wBlit_MaskPass_SrcB_D9F8]              ; $2AC4
    ldh [hRomBankShadow], a                       ; $2AC7
    ld [$2100], a                                 ; $2AC9
    ld de, $c802                                  ; $2ACC
    ld b, $08                                     ; $2ACF
    ld a, [wBlit_BuildPatchList_D9E6]             ; $2AD1

jr_000_2ad4:
    push af                                       ; $2AD4
    push hl                                       ; $2AD5
    ld a, [wBlit_MaskPass_SrcB_D9EE]              ; $2AD6
    ld [de], a                                    ; $2AD9
    ld a, [wBlit_MaskPass_SrcB_D9E8]              ; $2ADA
    ld c, a                                       ; $2ADD
    ld a, [wBlit_BuildPatchList_D9E7]             ; $2ADE

jr_000_2ae1:
    push af                                       ; $2AE1
    push bc                                       ; $2AE2
    ld a, c                                       ; $2AE3
    and a                                         ; $2AE4
    jr z, jr_000_2aec                             ; $2AE5

    ld a, [hl]                                    ; $2AE7
    ld bc, $0008                                  ; $2AE8
    add hl, bc                                    ; $2AEB

jr_000_2aec:
    push hl                                       ; $2AEC
    ld l, a                                       ; $2AED
    ld a, [wStamp_BlitFromD9F3_D9EA]              ; $2AEE
    ld h, a                                       ; $2AF1
    ld a, [hl]                                    ; $2AF2
    ld [wStamp_BlitFromD9F3_D9EB], a              ; $2AF3
    ld hl, wStamp_BlitFromD9F3_D9ED               ; $2AF6
    and [hl]                                      ; $2AF9
    ld l, e                                       ; $2AFA
    ld h, d                                       ; $2AFB
    or [hl]                                       ; $2AFC
    ld [hl], a                                    ; $2AFD
    inc de                                        ; $2AFE
    inc de                                        ; $2AFF
    inc de                                        ; $2B00
    inc de                                        ; $2B01
    inc de                                        ; $2B02
    ld a, [wStamp_BlitFromD9F3_D9EB]              ; $2B03
    ld hl, wBlit_MaskPass_SrcB_D9EE               ; $2B06
    and [hl]                                      ; $2B09
    ld [de], a                                    ; $2B0A
    pop hl                                        ; $2B0B
    pop bc                                        ; $2B0C
    pop af                                        ; $2B0D
    dec c                                         ; $2B0E
    dec a                                         ; $2B0F
    jr nz, jr_000_2ae1                            ; $2B10

    push de                                       ; $2B12
    dec de                                        ; $2B13
    dec de                                        ; $2B14
    dec de                                        ; $2B15
    dec de                                        ; $2B16
    dec de                                        ; $2B17
    ld hl, wBlit_MaskPass_SrcB_D9F0               ; $2B18
    ld a, [de]                                    ; $2B1B
    or [hl]                                       ; $2B1C
    ld [de], a                                    ; $2B1D
    pop de                                        ; $2B1E
    pop hl                                        ; $2B1F
    inc hl                                        ; $2B20
    dec b                                         ; $2B21
    jr nz, jr_000_2b2d                            ; $2B22

    ld a, [wStamp_SetShiftMasks_D9E9]             ; $2B24
    srl a                                         ; $2B27
    ld c, a                                       ; $2B29
    add hl, bc                                    ; $2B2A
    ld b, $08                                     ; $2B2B

jr_000_2b2d:
    pop af                                        ; $2B2D
    dec a                                         ; $2B2E
    jr nz, jr_000_2ad4                            ; $2B2F

    pop af                                        ; $2B31
    ldh [hRomBankShadow], a                       ; $2B32
    ld [$2100], a                                 ; $2B34
    ret                                           ; $2B37


; C: the Japanese Blit_MaskPass_SrcA (00:2026), 84 instructions against 84, with 11 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Blit_MaskPass_SrcA::
    ld a, [wBlit_MaskPass_SrcA_D9F3]              ; $2B38
    ld l, a                                       ; $2B3B
    ld a, [wBlit_MaskPass_SrcA_D9F4]              ; $2B3C
    ld h, a                                       ; $2B3F
    ldh a, [hRomBankShadow]                       ; $2B40
    push af                                       ; $2B42
    ld a, [wBlit_MaskPass_SrcA_D9F5]              ; $2B43
    ldh [hRomBankShadow], a                       ; $2B46
    ld [$2100], a                                 ; $2B48
    ld de, $c802                                  ; $2B4B
    ld b, $08                                     ; $2B4E
    ld a, [wBlit_BuildPatchList_D9E6]             ; $2B50

jr_000_2b53:
    push af                                       ; $2B53
    push hl                                       ; $2B54
    ld a, [wBlit_MaskPass_SrcB_D9EE]              ; $2B55
    ld [de], a                                    ; $2B58
    ld a, [wBlit_MaskPass_SrcB_D9E8]              ; $2B59
    ld c, a                                       ; $2B5C
    ld a, [wBlit_BuildPatchList_D9E7]             ; $2B5D

jr_000_2b60:
    push af                                       ; $2B60
    push bc                                       ; $2B61
    ld a, c                                       ; $2B62
    and a                                         ; $2B63
    jr z, jr_000_2b6e                             ; $2B64

    ld a, [hl+]                                   ; $2B66
    or [hl]                                       ; $2B67
    cpl                                           ; $2B68
    dec hl                                        ; $2B69
    ld bc, $0010                                  ; $2B6A
    add hl, bc                                    ; $2B6D

jr_000_2b6e:
    push hl                                       ; $2B6E
    ld l, a                                       ; $2B6F
    ld a, [wStamp_BlitFromD9F3_D9EA]              ; $2B70
    ld h, a                                       ; $2B73
    ld a, [hl]                                    ; $2B74
    ld [wStamp_BlitFromD9F3_D9EB], a              ; $2B75
    ld hl, wStamp_BlitFromD9F3_D9ED               ; $2B78
    and [hl]                                      ; $2B7B
    ld l, e                                       ; $2B7C
    ld h, d                                       ; $2B7D
    or [hl]                                       ; $2B7E
    ld [hl], a                                    ; $2B7F
    inc de                                        ; $2B80
    inc de                                        ; $2B81
    inc de                                        ; $2B82
    inc de                                        ; $2B83
    inc de                                        ; $2B84
    ld a, [wStamp_BlitFromD9F3_D9EB]              ; $2B85
    ld hl, wBlit_MaskPass_SrcB_D9EE               ; $2B88
    and [hl]                                      ; $2B8B
    ld [de], a                                    ; $2B8C
    pop hl                                        ; $2B8D
    pop bc                                        ; $2B8E
    pop af                                        ; $2B8F
    dec c                                         ; $2B90
    dec a                                         ; $2B91
    jr nz, jr_000_2b60                            ; $2B92

    push de                                       ; $2B94
    dec de                                        ; $2B95
    dec de                                        ; $2B96
    dec de                                        ; $2B97
    dec de                                        ; $2B98
    dec de                                        ; $2B99
    ld hl, wBlit_MaskPass_SrcB_D9F0               ; $2B9A
    ld a, [de]                                    ; $2B9D
    or [hl]                                       ; $2B9E
    ld [de], a                                    ; $2B9F
    pop de                                        ; $2BA0
    pop hl                                        ; $2BA1
    inc hl                                        ; $2BA2
    inc hl                                        ; $2BA3
    dec b                                         ; $2BA4
    jr nz, jr_000_2bae                            ; $2BA5

    ld a, [wStamp_SetShiftMasks_D9E9]             ; $2BA7
    ld c, a                                       ; $2BAA
    add hl, bc                                    ; $2BAB
    ld b, $08                                     ; $2BAC

jr_000_2bae:
    pop af                                        ; $2BAE
    dec a                                         ; $2BAF
    jr nz, jr_000_2b53                            ; $2BB0

    pop af                                        ; $2BB2
    ldh [hRomBankShadow], a                       ; $2BB3
    ld [$2100], a                                 ; $2BB5
    ret                                           ; $2BB8


; C: reads the stamp source [$D9F3] in bank [$D9F5] (part of Stamp_BlitOnPhoto); code read
Stamp_BlitFromD9F3::
    ld a, [wBlit_MaskPass_SrcA_D9F3]              ; $2BB9
    ld l, a                                       ; $2BBC
    ld a, [wBlit_MaskPass_SrcA_D9F4]              ; $2BBD
    ld h, a                                       ; $2BC0
    ldh a, [hRomBankShadow]                       ; $2BC1
    push af                                       ; $2BC3
    ld a, [wBlit_MaskPass_SrcA_D9F5]              ; $2BC4
    ldh [hRomBankShadow], a                       ; $2BC7
    ld [$2100], a                                 ; $2BC9
    ld de, $c803                                  ; $2BCC
    ld b, $08                                     ; $2BCF
    ld a, [wBlit_BuildPatchList_D9E6]             ; $2BD1

Jump_000_2bd4:
    push af                                       ; $2BD4
    push hl                                       ; $2BD5
    xor a                                         ; $2BD6
    ld [de], a                                    ; $2BD7
    inc de                                        ; $2BD8
    ld [de], a                                    ; $2BD9
    dec de                                        ; $2BDA
    ld a, [wBlit_MaskPass_SrcB_D9E8]              ; $2BDB
    ld c, a                                       ; $2BDE
    ld a, [wBlit_BuildPatchList_D9E7]             ; $2BDF

jr_000_2be2:
    push af                                       ; $2BE2
    push bc                                       ; $2BE3
    ld a, c                                       ; $2BE4
    and a                                         ; $2BE5
    jr z, jr_000_2c05                             ; $2BE6

    ld a, [hl+]                                   ; $2BE8
    push hl                                       ; $2BE9
    ld l, a                                       ; $2BEA
    ld a, [wStamp_BlitFromD9F3_D9EA]              ; $2BEB
    ld h, a                                       ; $2BEE
    ld a, [hl]                                    ; $2BEF
    ld [wStamp_BlitFromD9F3_D9EB], a              ; $2BF0
    pop hl                                        ; $2BF3
    ld a, [hl]                                    ; $2BF4
    ld bc, $000f                                  ; $2BF5
    add hl, bc                                    ; $2BF8
    push hl                                       ; $2BF9
    ld l, a                                       ; $2BFA
    ld a, [wStamp_BlitFromD9F3_D9EA]              ; $2BFB
    ld h, a                                       ; $2BFE
    ld a, [hl]                                    ; $2BFF
    ld [wStamp_BlitFromD9F3_D9EC], a              ; $2C00
    jr jr_000_2c0c                                ; $2C03

jr_000_2c05:
    ld [wStamp_BlitFromD9F3_D9EB], a              ; $2C05
    ld [wStamp_BlitFromD9F3_D9EC], a              ; $2C08
    push hl                                       ; $2C0B

jr_000_2c0c:
    ld a, [wStamp_BlitFromD9F3_D9EB]              ; $2C0C
    ld hl, wStamp_BlitFromD9F3_D9ED               ; $2C0F
    and [hl]                                      ; $2C12
    ld l, e                                       ; $2C13
    ld h, d                                       ; $2C14
    or [hl]                                       ; $2C15
    ld [hl], a                                    ; $2C16
    inc de                                        ; $2C17
    ld a, [wStamp_BlitFromD9F3_D9EC]              ; $2C18
    ld hl, wStamp_BlitFromD9F3_D9ED               ; $2C1B
    and [hl]                                      ; $2C1E
    ld l, e                                       ; $2C1F
    ld h, d                                       ; $2C20
    or [hl]                                       ; $2C21
    ld [hl], a                                    ; $2C22
    inc de                                        ; $2C23
    inc de                                        ; $2C24
    inc de                                        ; $2C25
    inc de                                        ; $2C26
    ld a, [wStamp_BlitFromD9F3_D9EB]              ; $2C27
    ld hl, wBlit_MaskPass_SrcB_D9EE               ; $2C2A
    and [hl]                                      ; $2C2D
    ld [de], a                                    ; $2C2E
    inc de                                        ; $2C2F
    ld a, [wStamp_BlitFromD9F3_D9EC]              ; $2C30
    ld hl, wBlit_MaskPass_SrcB_D9EE               ; $2C33
    and [hl]                                      ; $2C36
    ld [de], a                                    ; $2C37
    dec de                                        ; $2C38
    pop hl                                        ; $2C39
    pop bc                                        ; $2C3A
    pop af                                        ; $2C3B
    dec c                                         ; $2C3C
    dec a                                         ; $2C3D
    jr nz, jr_000_2be2                            ; $2C3E

    push de                                       ; $2C40
    dec de                                        ; $2C41
    dec de                                        ; $2C42
    dec de                                        ; $2C43
    dec de                                        ; $2C44
    dec de                                        ; $2C45
    ld hl, wStamp_BlitFromD9F3_D9EF               ; $2C46
    ld a, [de]                                    ; $2C49
    and [hl]                                      ; $2C4A
    ld [de], a                                    ; $2C4B
    inc de                                        ; $2C4C
    ld a, [de]                                    ; $2C4D
    and [hl]                                      ; $2C4E
    ld [de], a                                    ; $2C4F
    dec de                                        ; $2C50
    pop de                                        ; $2C51
    pop hl                                        ; $2C52
    inc hl                                        ; $2C53
    inc hl                                        ; $2C54
    dec b                                         ; $2C55
    jr nz, jr_000_2c5f                            ; $2C56

    ld a, [wStamp_SetShiftMasks_D9E9]             ; $2C58
    ld c, a                                       ; $2C5B
    add hl, bc                                    ; $2C5C
    ld b, $08                                     ; $2C5D

jr_000_2c5f:
    pop af                                        ; $2C5F
    dec a                                         ; $2C60
    jp nz, Jump_000_2bd4                          ; $2C61

    pop af                                        ; $2C64
    ldh [hRomBankShadow], a                       ; $2C65
    ld [$2100], a                                 ; $2C67
    ret                                           ; $2C6A


; C: calls Snd_Init (0F:5308) in the sound bank
Snd_Init_Tramp::
    ldh a, [hRomBankShadow]                       ; $2C6B
    push af                                       ; $2C6D
    ld a, $0f                                     ; $2C6E
    ldh [hRomBankShadow], a                       ; $2C70
    ld [$2100], a                                 ; $2C72
    call Snd_Init                                 ; $2C75
    pop af                                        ; $2C78
    ldh [hRomBankShadow], a                       ; $2C79
    ld [$2100], a                                 ; $2C7B
    ret                                           ; $2C7E


; C: calls Snd_Tick (0F:5337) in the sound bank: the effects of channels 1, 3 and 4 and the music, then the requests
; $D060-$D078 cleared; code read
Snd_Tick_Tramp::
    ldh a, [hRomBankShadow]                       ; $2C7F
    push af                                       ; $2C81
    ld a, $0f                                     ; $2C82
    ldh [hRomBankShadow], a                       ; $2C84
    ld [$2100], a                                 ; $2C86
    call Snd_Tick                                 ; $2C89
    pop af                                        ; $2C8C
    ldh [hRomBankShadow], a                       ; $2C8D
    ld [$2100], a                                 ; $2C8F
    ret                                           ; $2C92


    db $f0, $8b, $f5, $3e, $0f, $e0, $8b, $ea, $00, $21, $cd, $63, $52, $f1, $e0, $8b
    db $ea, $00, $21, $c9

    ; padding
    ds $159, $00

; C: read in the runs by Copy_DEtoHL, Snd_Tick_Tramp; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Src_00_2E00_Mode05_StampWindow_State06::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $871, $00

    db $01, $01, $02, $10, $11, $11, $12, $10, $11, $11, $12, $20, $21, $21, $22

; C: the same 2304 bytes as the Japanese Img_PairLookupTbl (00:3700); read in the runs by Stamp_BlitFromD9F3,
; Blit_MaskPass_SrcB, Img_PairLookup; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
Img_PairLookupTbl::
    ASSERT LOW(Img_PairLookupTbl) == 0 ; read as a page: HIGH(Img_PairLookupTbl) with the index in the low byte
    INCBIN "data/bank_00/Img_PairLookupTbl.bin" ; $3700, 2304 bytes

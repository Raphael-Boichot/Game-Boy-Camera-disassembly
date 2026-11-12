; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $00. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $000", ROM0[$0]

RST_00::
    db $00, $c3, $50, $01, $ff, $ff, $00, $00

RST_08::
    jp RESET                                      ; $0008


    rst RST_38                                    ; $000B
    rst RST_38                                    ; $000C
    rst RST_38                                    ; $000D
    rst RST_38                                    ; $000E
    rst RST_38                                    ; $000F

RST_10::
    rst RST_38                                    ; $0010
    rst RST_38                                    ; $0011
    rst RST_38                                    ; $0012
    rst RST_38                                    ; $0013
    rst RST_38                                    ; $0014
    rst RST_38                                    ; $0015
    rst RST_38                                    ; $0016
    rst RST_38                                    ; $0017

RST_18::
    rst RST_38                                    ; $0018
    rst RST_38                                    ; $0019
    rst RST_38                                    ; $001A
    rst RST_38                                    ; $001B
    rst RST_38                                    ; $001C
    rst RST_38                                    ; $001D
    rst RST_38                                    ; $001E
    rst RST_38                                    ; $001F

RST_20::
    rst RST_38                                    ; $0020
    rst RST_38                                    ; $0021
    rst RST_38                                    ; $0022
    rst RST_38                                    ; $0023
    rst RST_38                                    ; $0024
    rst RST_38                                    ; $0025
    rst RST_38                                    ; $0026
    rst RST_38                                    ; $0027

RST_28::
    add a                                         ; $0028
    pop hl                                        ; $0029
    ld d, $00                                     ; $002A
    ld e, a                                       ; $002C
    add hl, de                                    ; $002D
    ld e, [hl]                                    ; $002E
    inc hl                                        ; $002F

RST_30::
    ld d, [hl]                                    ; $0030
    ld h, d                                       ; $0031
    ld l, e                                       ; $0032
    jp hl                                         ; $0033


    rst RST_38                                    ; $0034
    rst RST_38                                    ; $0035
    rst RST_38                                    ; $0036
    rst RST_38                                    ; $0037

RST_38::
    rst RST_38                                    ; $0038
    rst RST_38                                    ; $0039
    rst RST_38                                    ; $003A
    rst RST_38                                    ; $003B
    rst RST_38                                    ; $003C
    rst RST_38                                    ; $003D
    rst RST_38                                    ; $003E
    rst RST_38                                    ; $003F

; C: interrupt vector $40: jp VBLANK handler 00:01E3
Vec_VBlank::
    jp Jump_000_01e3                              ; $0040


; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_0043::
    db $ff, $ff, $ff, $ff, $ff

; C: interrupt vector $48: jp HBLK 00:1250
Vec_LcdStat::
    jp HBLK                                       ; $0048


; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_004B::
    db $d9, $ff, $ff, $ff, $ff

; C: interrupt vector $50: jp TIMER_INT 00:1266 (never enabled by a constant write to IE: observed_proto.md)
Vec_Timer::
    jp TIMER_INT                                  ; $0050


; I: leftover: 5 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_0053::
    db $d9, $ff, $ff, $ff, $ff

; C: interrupt vector $58: jp SIO_INT 00:034B
Vec_Serial::
    jp SIO_INT                                    ; $0058


; I: leftover: 6 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_005B::
    db $d9, $ff, $ff, $ff, $ff

JoypadTransitionInterrupt::
    reti                                          ; $0060


    rst RST_38                                    ; $0061
    rst RST_38                                    ; $0062
    rst RST_38                                    ; $0063
    rst RST_38                                    ; $0064
    rst RST_38                                    ; $0065
    rst RST_38                                    ; $0066
    rst RST_38                                    ; $0067

    rst RST_38                                    ; $0068
    rst RST_38                                    ; $0069
    rst RST_38                                    ; $006A
    rst RST_38                                    ; $006B
    rst RST_38                                    ; $006C
    rst RST_38                                    ; $006D
    rst RST_38                                    ; $006E
    rst RST_38                                    ; $006F
    rst RST_38                                    ; $0070
    rst RST_38                                    ; $0071
    rst RST_38                                    ; $0072
    rst RST_38                                    ; $0073
    rst RST_38                                    ; $0074
    rst RST_38                                    ; $0075
    rst RST_38                                    ; $0076
    rst RST_38                                    ; $0077
    rst RST_38                                    ; $0078
    rst RST_38                                    ; $0079
    rst RST_38                                    ; $007A
    rst RST_38                                    ; $007B
    rst RST_38                                    ; $007C
    rst RST_38                                    ; $007D
    rst RST_38                                    ; $007E
    rst RST_38                                    ; $007F
    rst RST_38                                    ; $0080
    rst RST_38                                    ; $0081
    rst RST_38                                    ; $0082
    rst RST_38                                    ; $0083
    rst RST_38                                    ; $0084
    rst RST_38                                    ; $0085
    rst RST_38                                    ; $0086
    rst RST_38                                    ; $0087
    rst RST_38                                    ; $0088
    rst RST_38                                    ; $0089
    rst RST_38                                    ; $008A
    rst RST_38                                    ; $008B
    rst RST_38                                    ; $008C
    rst RST_38                                    ; $008D
    rst RST_38                                    ; $008E
    rst RST_38                                    ; $008F
    rst RST_38                                    ; $0090
    rst RST_38                                    ; $0091
    rst RST_38                                    ; $0092
    rst RST_38                                    ; $0093
    rst RST_38                                    ; $0094
    rst RST_38                                    ; $0095
    rst RST_38                                    ; $0096
    rst RST_38                                    ; $0097
    rst RST_38                                    ; $0098
    rst RST_38                                    ; $0099
    rst RST_38                                    ; $009A
    rst RST_38                                    ; $009B
    rst RST_38                                    ; $009C
    rst RST_38                                    ; $009D
    rst RST_38                                    ; $009E
    rst RST_38                                    ; $009F
    rst RST_38                                    ; $00A0
    rst RST_38                                    ; $00A1
    rst RST_38                                    ; $00A2
    rst RST_38                                    ; $00A3
    rst RST_38                                    ; $00A4
    rst RST_38                                    ; $00A5
    rst RST_38                                    ; $00A6
    rst RST_38                                    ; $00A7
    rst RST_38                                    ; $00A8
    rst RST_38                                    ; $00A9
    rst RST_38                                    ; $00AA
    rst RST_38                                    ; $00AB
    rst RST_38                                    ; $00AC
    rst RST_38                                    ; $00AD
    rst RST_38                                    ; $00AE
    rst RST_38                                    ; $00AF
    rst RST_38                                    ; $00B0
    rst RST_38                                    ; $00B1
    rst RST_38                                    ; $00B2
    rst RST_38                                    ; $00B3
    rst RST_38                                    ; $00B4
    rst RST_38                                    ; $00B5
    rst RST_38                                    ; $00B6
    rst RST_38                                    ; $00B7
    rst RST_38                                    ; $00B8
    rst RST_38                                    ; $00B9
    rst RST_38                                    ; $00BA
    rst RST_38                                    ; $00BB
    rst RST_38                                    ; $00BC
    rst RST_38                                    ; $00BD
    rst RST_38                                    ; $00BE
    rst RST_38                                    ; $00BF
    rst RST_38                                    ; $00C0
    rst RST_38                                    ; $00C1
    rst RST_38                                    ; $00C2
    rst RST_38                                    ; $00C3
    rst RST_38                                    ; $00C4
    rst RST_38                                    ; $00C5
    rst RST_38                                    ; $00C6
    rst RST_38                                    ; $00C7
    rst RST_38                                    ; $00C8
    rst RST_38                                    ; $00C9
    rst RST_38                                    ; $00CA
    rst RST_38                                    ; $00CB
    rst RST_38                                    ; $00CC
    rst RST_38                                    ; $00CD
    rst RST_38                                    ; $00CE
    rst RST_38                                    ; $00CF
    rst RST_38                                    ; $00D0
    rst RST_38                                    ; $00D1
    rst RST_38                                    ; $00D2
    rst RST_38                                    ; $00D3
    rst RST_38                                    ; $00D4
    rst RST_38                                    ; $00D5
    rst RST_38                                    ; $00D6
    rst RST_38                                    ; $00D7
    rst RST_38                                    ; $00D8
    rst RST_38                                    ; $00D9
    rst RST_38                                    ; $00DA
    rst RST_38                                    ; $00DB
    rst RST_38                                    ; $00DC
    rst RST_38                                    ; $00DD
    rst RST_38                                    ; $00DE
    rst RST_38                                    ; $00DF
    rst RST_38                                    ; $00E0
    rst RST_38                                    ; $00E1
    rst RST_38                                    ; $00E2
    rst RST_38                                    ; $00E3
    rst RST_38                                    ; $00E4
    rst RST_38                                    ; $00E5
    rst RST_38                                    ; $00E6
    rst RST_38                                    ; $00E7
    rst RST_38                                    ; $00E8
    rst RST_38                                    ; $00E9
    rst RST_38                                    ; $00EA
    rst RST_38                                    ; $00EB
    rst RST_38                                    ; $00EC
    rst RST_38                                    ; $00ED
    rst RST_38                                    ; $00EE
    rst RST_38                                    ; $00EF
    rst RST_38                                    ; $00F0
    rst RST_38                                    ; $00F1
    rst RST_38                                    ; $00F2
    rst RST_38                                    ; $00F3
    rst RST_38                                    ; $00F4
    rst RST_38                                    ; $00F5
    rst RST_38                                    ; $00F6
    rst RST_38                                    ; $00F7
    rst RST_38                                    ; $00F8
    rst RST_38                                    ; $00F9
    rst RST_38                                    ; $00FA
    rst RST_38                                    ; $00FB
    rst RST_38                                    ; $00FC
    rst RST_38                                    ; $00FD
    rst RST_38                                    ; $00FE
    rst RST_38                                    ; $00FF

; C: cartridge entry point: nop; jp $0150
Entry::
    nop                                           ; $0100
    jp RESET                                      ; $0101


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

HeaderNewLicenseeCode::
    db $30, $31

HeaderSGBFlag::
    db $03

HeaderCartridgeType::
    db $01

HeaderROMSize::
    db $03

HeaderRAMSize::
    db $00

HeaderDestinationCode::
    db $00

HeaderOldLicenseeCode::
    db $33

HeaderMaskROMVersion::
    db $00

HeaderComplementCheck::
    db $4c

HeaderGlobalChecksum::
    db $00, $00

; C: the boot code: Entry (00:0100), rst $00, rst $08 and the A+B+Select+Start reset (00:01C7) jump here; RESET at
; $0150 in both old symbol tables (the Japanese ROM calls its own Boot_ColdStart)
RESET::
    di                                            ; $0150
    xor a                                         ; $0151
    ldh [rSCY], a                                 ; $0152
    ldh [rSCX], a                                 ; $0154
    ldh [hSCXW], a                                ; $0156
    ldh [rSTAT], a                                ; $0158
    ldh [rSB], a                                  ; $015A
    ldh [rSC], a                                  ; $015C
    ldh [rWY], a                                  ; $015E
    ldh [rWX], a                                  ; $0160
    ldh [rTMA], a                                 ; $0162
    ld sp, wRESET_DFFF                            ; $0164
    xor a                                         ; $0167
    ld hl, $8000                                  ; $0168
    ld bc, $2000                                  ; $016B

jr_000_016e:
    ld [hl+], a                                   ; $016E
    dec c                                         ; $016F
    jr nz, jr_000_016e                            ; $0170

    dec b                                         ; $0172
    jr nz, jr_000_016e                            ; $0173

    ld hl, wOBJRAM                                ; $0175
    ld bc, $1000                                  ; $0178

jr_000_017b:
    ld [hl+], a                                   ; $017B
    dec c                                         ; $017C
    jr nz, jr_000_017b                            ; $017D

    dec b                                         ; $017F
    jr nz, jr_000_017b                            ; $0180

    ld hl, wB_ADR                                 ; $0182
    ld bc, $1000                                  ; $0185

jr_000_0188:
    ld [hl+], a                                   ; $0188
    dec c                                         ; $0189
    jr nz, jr_000_0188                            ; $018A

    dec b                                         ; $018C
    jr nz, jr_000_0188                            ; $018D

    ld hl, $fe00                                  ; $018F
    ld c, $00                                     ; $0192

jr_000_0194:
    ld [hl+], a                                   ; $0194
    dec c                                         ; $0195
    jr nz, jr_000_0194                            ; $0196

    ld hl, hCNT1                                  ; $0198
    ld c, $7f                                     ; $019B

jr_000_019d:
    ld [hl+], a                                   ; $019D
    dec c                                         ; $019E
    jr nz, jr_000_019d                            ; $019F

    ld c, $b6                                     ; $01A1
    ld b, $0a                                     ; $01A3
    ld hl, DMADATA                                ; $01A5

jr_000_01a8:
    ld a, [hl+]                                   ; $01A8
    ldh [c], a                                    ; $01A9
    inc c                                         ; $01AA
    dec b                                         ; $01AB
    jr nz, jr_000_01a8                            ; $01AC

    ld a, $01                                     ; $01AE
    ld [$2100], a                                 ; $01B0
    ldh [hBANK_BUF], a                            ; $01B3
    call VRAM_CLR                                 ; $01B5
    ld a, $80                                     ; $01B8
    ldh [rLCDC], a                                ; $01BA
    xor a                                         ; $01BC
    ldh [rIF], a                                  ; $01BD
    ld a, $09                                     ; $01BF
    ldh [rIE], a                                  ; $01C1
    ei                                            ; $01C3

jr_000_01c4:
    call INKEY                                    ; $01C4
    ldh a, [hCNT1]                                ; $01C7
    and $0f                                       ; $01C9
    cp $0f                                        ; $01CB
    jp z, RESET                                   ; $01CD

    call MAIN_SUB                                 ; $01D0
    or $ff                                        ; $01D3
    ldh [hMAIN_AFURE], a                          ; $01D5

jr_000_01d7:
    ldh a, [hVBFLG]                               ; $01D7
    and a                                         ; $01D9
    jr z, jr_000_01d7                             ; $01DA

    xor a                                         ; $01DC
    ldh [hVBFLG], a                               ; $01DD
    ldh [hMAIN_AFURE], a                          ; $01DF
    jr jr_000_01c4                                ; $01E1

Jump_000_01e3:
    push af                                       ; $01E3
    push bc                                       ; $01E4
    push de                                       ; $01E5
    push hl                                       ; $01E6
    ld a, [wRESET_C008]                           ; $01E7
    ldh a, [hMAIN_AFURE]                          ; $01EA
    and a                                         ; $01EC
    jr z, jr_000_01f6                             ; $01ED

    call VBLANK_SUB                               ; $01EF
    or $ff                                        ; $01F2
    ldh [hVBFLG], a                               ; $01F4

jr_000_01f6:
    ld a, [$fe08]                                 ; $01F6
    pop hl                                        ; $01F9
    pop de                                        ; $01FA
    pop bc                                        ; $01FB
    pop af                                        ; $01FC
    reti                                          ; $01FD


; C: developers' name: same code as MAIN_SUB in the old build of table 2A at old 0204 and 35 at old 0204 (124 bytes,
; masked match)
MAIN_SUB::
    ld hl, hFLMCNT                                ; $01FE
    inc [hl]                                      ; $0201
    ld a, [wGAME_SEQ]                             ; $0202
    or a                                          ; $0205
    jr nz, jr_000_020c                            ; $0206

    call GAME_INIT                                ; $0208
    ret                                           ; $020B


jr_000_020c:
    cp SEQ_TITL                                   ; $020C
    jr nz, jr_000_0214                            ; $020E

    call GAME_TITL                                ; $0210
    ret                                           ; $0213


jr_000_0214:
    cp SEQ_MAIN_MENU                              ; $0214
    jr nz, jr_000_021c                            ; $0216

    call MAIN_MENU                                ; $0218
    ret                                           ; $021B


jr_000_021c:
    cp SEQ_BANK_TEST                              ; $021C
    jr nz, jr_000_0224                            ; $021E

    call BANK_TEST                                ; $0220
    ret                                           ; $0223


jr_000_0224:
    cp SEQ_SRAM_MENU                              ; $0224
    jr nz, jr_000_022c                            ; $0226

    call SRAM_MENU                                ; $0228
    ret                                           ; $022B


jr_000_022c:
    cp SEQ_SRAM_DATA_SEL                          ; $022C
    jr nz, jr_000_0234                            ; $022E

    call SRAM_DATA_SEL                            ; $0230
    ret                                           ; $0233


jr_000_0234:
    cp SEQ_MOVIE                                  ; $0234
    jr nz, jr_000_023c                            ; $0236

    call Seq06_MovieMain                          ; $0238
    ret                                           ; $023B


jr_000_023c:
    cp SEQ_SRAM_AGING                             ; $023C
    jr nz, jr_000_0244                            ; $023E

    call SRAM_AGING                               ; $0240
    ret                                           ; $0243


jr_000_0244:
    cp SEQ_SRAM_DUMP                              ; $0244
    jr nz, jr_000_024c                            ; $0246

    call SRAM_DUMP                                ; $0248
    ret                                           ; $024B


jr_000_024c:
    cp SEQ_CONFIG                                 ; $024C
    jr nz, jr_000_0254                            ; $024E

    call Seq09_ConfigMain                         ; $0250
    ret                                           ; $0253


jr_000_0254:
    cp SEQ_PROTECT_TEST                           ; $0254
    jr nz, jr_000_025c                            ; $0256

    call PROTECT_TEST                             ; $0258
    ret                                           ; $025B


jr_000_025c:
    cp SEQ_EMI                                    ; $025C
    jr nz, jr_000_0264                            ; $025E

    call EMI_MAIN                                 ; $0260
    ret                                           ; $0263


jr_000_0264:
    cp SEQ_PIC_SAVE                               ; $0264
    jr nz, jr_000_026c                            ; $0266

    call PIC_SAVE                                 ; $0268
    ret                                           ; $026B


jr_000_026c:
    cp SEQ_GALLERY                                ; $026C
    jr nz, jr_000_0274                            ; $026E

    call Seq0D_GalleryMain                        ; $0270
    ret                                           ; $0273


jr_000_0274:
    cp $0e                                        ; $0274
    jr nz, jr_000_0279                            ; $0276

    ret                                           ; $0278


jr_000_0279:
    ret                                           ; $0279


; C: developers' name: same code as VBLANK_SUB in the old build of table 2A at old 0280 and 35 at old 0280 (63 bytes,
; masked match)
VBLANK_SUB::
    call $ffb6                                    ; $027A
    ld a, [wGAME_SEQ]                             ; $027D
    cp SEQ_MOVIE                                  ; $0280
    jr nz, jr_000_0288                            ; $0282

    call VB_MOVIE                                 ; $0284
    ret                                           ; $0287


jr_000_0288:
    cp SEQ_SRAM_MENU                              ; $0288
    jr nz, jr_000_0290                            ; $028A

    call VB_SRAM_MENU                             ; $028C
    ret                                           ; $028F


jr_000_0290:
    cp SEQ_SRAM_AGING                             ; $0290
    jr nz, jr_000_0298                            ; $0292

    call VB_SRAM_AGING                            ; $0294
    ret                                           ; $0297


jr_000_0298:
    cp SEQ_PROTECT_TEST                           ; $0298
    jr nz, jr_000_02a0                            ; $029A

    call VB_PROTECT                               ; $029C
    ret                                           ; $029F


jr_000_02a0:
    cp SEQ_CONFIG                                 ; $02A0
    jr nz, jr_000_02a8                            ; $02A2

    call Config_PutItem                           ; $02A4
    ret                                           ; $02A7


jr_000_02a8:
    cp SEQ_EMI                                    ; $02A8
    jr nz, jr_000_02ad                            ; $02AA

    ret                                           ; $02AC


jr_000_02ad:
    cp SEQ_GALLERY                                ; $02AD
    jr nz, jr_000_02b4                            ; $02AF

    call OamDma_Run                               ; $02B1

jr_000_02b4:
    cp $0e                                        ; $02B4
    jr nz, jr_000_02b8                            ; $02B6

jr_000_02b8:
    ret                                           ; $02B8


; I: developers' name: same code as DATA_MOV in the old build of table 2A at old 02BF and 35 at old 02BF (9 bytes,
; exact match)
DATA_MOV::
    ld a, [hl+]                                   ; $02B9
    ld [de], a                                    ; $02BA
    inc de                                        ; $02BB
    dec bc                                        ; $02BC
    ld a, b                                       ; $02BD
    or c                                          ; $02BE
    jr nz, DATA_MOV                               ; $02BF

    ret                                           ; $02C1


; I: developers' name: same code as DMACLR in the old build of table 2A at old 02C8 and 35 at old 05CF (11 bytes,
; exact match)
DMACLR::
    xor a                                         ; $02C2
    ld hl, wOBJRAM                                ; $02C3
    ld b, $a0                                     ; $02C6

jr_000_02c8:
    ld [hl+], a                                   ; $02C8
    dec b                                         ; $02C9
    jr nz, jr_000_02c8                            ; $02CA

    ret                                           ; $02CC


; C: developers' name: same code as LCDCOFF in the old build of table 2A at old 02D3 and 35 at old 05DA (25 bytes,
; exact match)
LCDCOFF::
    ldh a, [rIE]                                  ; $02CD
    ldh [hR1], a                                  ; $02CF
    res 0, a                                      ; $02D1
    ldh [rIE], a                                  ; $02D3

jr_000_02d5:
    ldh a, [rLY]                                  ; $02D5
    cp $91                                        ; $02D7
    jr nz, jr_000_02d5                            ; $02D9

    ldh a, [rLCDC]                                ; $02DB
    and $7f                                       ; $02DD
    ldh [rLCDC], a                                ; $02DF
    ldh a, [hR1]                                  ; $02E1
    ldh [rIE], a                                  ; $02E3
    ret                                           ; $02E5


; C: developers' name: same code as INKEY in the old build of table 2A at old 02EC and 35 at old 05F3 (49 bytes, exact
; match)
INKEY::
    ld a, $20                                     ; $02E6
    ldh [rP1], a                                  ; $02E8
    ldh a, [rP1]                                  ; $02EA
    ldh a, [rP1]                                  ; $02EC
    cpl                                           ; $02EE
    and $0f                                       ; $02EF
    swap a                                        ; $02F1
    ld b, a                                       ; $02F3
    ld a, $10                                     ; $02F4
    ldh [rP1], a                                  ; $02F6
    ldh a, [rP1]                                  ; $02F8
    ldh a, [rP1]                                  ; $02FA
    ldh a, [rP1]                                  ; $02FC
    ldh a, [rP1]                                  ; $02FE
    ldh a, [rP1]                                  ; $0300
    ldh a, [rP1]                                  ; $0302
    cpl                                           ; $0304
    and $0f                                       ; $0305
    or b                                          ; $0307
    ld c, a                                       ; $0308
    ldh a, [hCNT1]                                ; $0309
    xor c                                         ; $030B
    and c                                         ; $030C
    ldh [hTRG1], a                                ; $030D
    ld a, c                                       ; $030F
    ldh [hCNT1], a                                ; $0310
    ld a, $30                                     ; $0312
    ldh [rP1], a                                  ; $0314
    ret                                           ; $0316


; I: developers' name: the same bytes as the data label DMADATA in the old build of table 2A at old 031D and 35 at old
; 0624 (10 bytes, data match)
DMADATA::
    db $3e, $c0, $e0, $46, $3e, $40, $3d, $20, $fd, $c9

; C: developers' name: the same bytes as the data label CLRCHR_SET in the old build of table 2A at old 0327 and 35 at
; old 062E (26 bytes, data match)
CLRCHR_SET::
    db $21, $00, $c0, $11, $a5, $ff, $1a, $87, $87, $06, $00, $4f, $09, $1a, $fe, $28
    db $c8, $3c, $12, $af, $22, $22, $22, $22, $18, $f3

; C: developers' name: same code as VRAM_CLR in the old build of table 2A at old 0341 and 35 at old 0648 (16 bytes,
; exact match)
VRAM_CLR::
    ld hl, $9800                                  ; $033B
    ld a, $ff                                     ; $033E
    ld bc, $0800                                  ; $0340

jr_000_0343:
    ld [hl+], a                                   ; $0343
    dec c                                         ; $0344
    jr nz, jr_000_0343                            ; $0345

    dec b                                         ; $0347
    jr nz, jr_000_0343                            ; $0348

    ret                                           ; $034A


; C: developers' name: same code as SIO_INT in the old build of table 2A at old 0351 (65 bytes, masked match)
SIO_INT::
    push af                                       ; $034B
    push bc                                       ; $034C
    push de                                       ; $034D
    push hl                                       ; $034E
    ld a, $80                                     ; $034F
    ldh [rSC], a                                  ; $0351
    ld a, [wN_COM_FLG]                            ; $0353
    and a                                         ; $0356
    jr nz, jr_000_037c                            ; $0357

    ldh a, [rSB]                                  ; $0359
    cp $00                                        ; $035B
    jr z, jr_000_0371                             ; $035D

    cp $fe                                        ; $035F
    jr z, jr_000_036a                             ; $0361

    ld a, $fe                                     ; $0363
    ldh [rSB], a                                  ; $0365
    jp Jump_000_0387                              ; $0367


jr_000_036a:
    ld a, $02                                     ; $036A
    ld [wN_COM_FLG], a                            ; $036C
    jr jr_000_0376                                ; $036F

jr_000_0371:
    ld a, $01                                     ; $0371
    ld [wN_COM_FLG], a                            ; $0373

jr_000_0376:
    xor a                                         ; $0376
    ldh [rSB], a                                  ; $0377
    ld [wS_DATA], a                               ; $0379

jr_000_037c:
    ldh a, [rSB]                                  ; $037C
    ld [wR_DATA], a                               ; $037E
    inc a                                         ; $0381
    ld [wS_DATA], a                               ; $0382
    ldh [rSB], a                                  ; $0385

Jump_000_0387:
    pop hl                                        ; $0387
    pop de                                        ; $0388
    pop bc                                        ; $0389
    pop af                                        ; $038A
    reti                                          ; $038B


; C: developers' name: same code as GAME_INIT in the old build of table 2A at old 0392 and 35 at old 0658 (31 bytes,
; masked match)
GAME_INIT::
    call LCDCOFF                                  ; $038C
    call VRAM_CLR                                 ; $038F
    call DMACLR                                   ; $0392
    ld hl, wMABIKI2                               ; $0395

jr_000_0398:
    xor a                                         ; $0398
    ld [hl+], a                                   ; $0399
    ld a, l                                       ; $039A
    cp $f0                                        ; $039B
    jr nz, jr_000_0398                            ; $039D

    ld a, $a0                                     ; $039F
    ld [wDUMP_ADR_H], a                           ; $03A1
    xor a                                         ; $03A4
    ld [wDUMP_ADR_L], a                           ; $03A5
    ld [wDUMP_BANK], a                            ; $03A8
    ld a, $01                                     ; $03AB
    ld [wDITHER], a                               ; $03AD
    ld a, $0a                                     ; $03B0
    ld [wCONTRAST], a                             ; $03B2
    call SET_DITH_MATRIX                          ; $03B5
    xor a                                         ; $03B8
    ld [wYURAGI], a                               ; $03B9
    ld a, $04                                     ; $03BC
    ld [wB_MODE], a                               ; $03BE
    ld a, $18                                     ; $03C1
    ld [wB_CNTR2], a                              ; $03C3
    ld a, $00                                     ; $03C6
    ld [wB_CNTR3], a                              ; $03C8
    ld a, $a0                                     ; $03CB
    ld [wB_CNTR5], a                              ; $03CD
    ld a, $01                                     ; $03D0
    ld [wCONF_MODE], a                            ; $03D2
    ld [wAUTO_MODE], a                            ; $03D5
    ld a, $3a                                     ; $03D8
    ld [wAKARUSA], a                              ; $03DA
    xor a                                         ; $03DD
    ld [wTITLE_FLAG], a                           ; $03DE
    ld [wCHANGE_TH_FLAG], a                       ; $03E1
    ld [wIKKAI_FLAG], a                           ; $03E4
    ld [wMABIKI2], a                              ; $03E7
    ld [wPALETTE], a                              ; $03EA
    ld [wBUNKATU_MODE], a                         ; $03ED
    ld a, $15                                     ; $03F0
    ld [wCNF_CUR], a                              ; $03F2
    call TITL_GAMEN                               ; $03F5
    call SCYX_SET0                                ; $03F8
    call OBJP_DEF_SET                             ; $03FB
    call Bgp_SetDefault                           ; $03FE
    ld a, $04                                     ; $0401
    ldh [rWX], a                                  ; $0403
    ld a, $60                                     ; $0405
    ldh [rWY], a                                  ; $0407
    ld a, SEQ_TITL                                ; $0409
    ld [wGAME_SEQ], a                             ; $040B
    ld a, $c7                                     ; $040E
    ldh [rLCDC], a                                ; $0410
    ret                                           ; $0412


; I: developers' name: same code as OBJP_DEF_SET in the old build of table 2A at old 0419 and 35 at old 0713 (13
; bytes, exact match)
OBJP_DEF_SET::
    ld a, $e4                                     ; $0413
    ldh [rOBP0], a                                ; $0415
    ldh [hOBP0W], a                               ; $0417
    ld a, $e4                                     ; $0419
    ldh [rOBP1], a                                ; $041B
    ldh [hOBP1W], a                               ; $041D
    ret                                           ; $041F


; C: ld a,$E4; ldh [rBGP],a; ldh [BGPW $FFAE],a: the default palette and its shadow
Bgp_SetDefault::
    ld a, $e4                                     ; $0420

; I: developers' name: same code as BGP_SET in the old build of table 2A at old 0428 and 35 at old 0722 (5 bytes,
; exact match)
BGP_SET::
    ldh [rBGP], a                                 ; $0422
    ldh [hBGPW], a                                ; $0424
    ret                                           ; $0426


; I: leftover: 7 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_0427::
    db $f0, $ae, $0f, $cd, $22, $04, $c9

; I: developers' name: same code as SCYX_SET0 in the old build of table 2A at old 0434 and 35 at old 072E (15 bytes,
; exact match)
SCYX_SET0::
    ld a, $00                                     ; $042E
    ldh [rSCY], a                                 ; $0430
    ldh [hSCYW], a                                ; $0432
    ldh [hSCYD], a                                ; $0434
    ld a, $00                                     ; $0436
    ldh [rSCX], a                                 ; $0438
    ldh [hSCXW], a                                ; $043A
    ret                                           ; $043C


; I: developers' name: the same bytes as the data label SOUND_P in the old build of table 2A at old 0443 and 35 at old
; 073D (6 bytes, data match)
SOUND_P::
    db $3e, $3e, $ea, $60, $dc, $c9

; I: developers' name: the same bytes as the data label SOUND_PE in the old build of table 2A at old 0449 and 35 at
; old 0743 (6 bytes, data match)
SOUND_PE::
    db $3e, $3f, $ea, $60, $dc, $c9

; C: developers' name: the same bytes as the data label MEN_FADE_CLR in the old build of table 2A at old 044F and 35
; at old 0749 (17 bytes, data match)
MEN_FADE_CLR::
    db $af, $ea, $a1, $c0, $ea, $a2, $c0, $ea, $a3, $c0, $ea, $a4, $c0, $ea, $a5, $c0
    db $c9

; I: writes 1 to $C0A1, MEN_FADE_F in both old symbol tables (same address)
MenFade_Start::
    ld a, $01                                     ; $045A
    ld [wMEN_FADE_F], a                           ; $045C
    ret                                           ; $045F


; C: developers' name: same code as MEN_FADE in the old build of table 2A at old 0466 and 35 at old 0760 (54 bytes,
; masked match)
MEN_FADE::
    ld a, [wMEN_FADE_F]                           ; $0460
    and a                                         ; $0463
    ret z                                         ; $0464

    ld a, [wMEN_FADE_T]                           ; $0465
    and a                                         ; $0468
    jr z, jr_000_0472                             ; $0469

    dec a                                         ; $046B
    ld [wMEN_FADE_T], a                           ; $046C
    jr z, MEN_FADE_END                            ; $046F

    ret                                           ; $0471


jr_000_0472:
    ld hl, wMEN_FADE_C                            ; $0472
    inc [hl]                                      ; $0475
    ld a, [hl]                                    ; $0476
    cp $04                                        ; $0477
    ret nz                                        ; $0479

    ld [hl], $00                                  ; $047A
    ldh a, [hOBP0W]                               ; $047C
    call MEN_FADE_DEC                             ; $047E
    ldh [hOBP0W], a                               ; $0481
    ldh [rOBP0], a                                ; $0483
    ldh a, [hBGPW]                                ; $0485
    call MEN_FADE_DEC                             ; $0487
    ldh [hBGPW], a                                ; $048A
    ldh [rBGP], a                                 ; $048C
    and a                                         ; $048E
    ret nz                                        ; $048F

    ld a, $05                                     ; $0490
    ld [wMEN_FADE_T], a                           ; $0492
    ret                                           ; $0495


; I: developers' name: same code as MEN_FADE_END in the old build of table 2A at old 049C and 35 at old 0796 (10
; bytes, exact match)
MEN_FADE_END::
    xor a                                         ; $0496
    ld [wMEN_FADE_F], a                           ; $0497
    ld a, $01                                     ; $049A
    ld [wMEN_CHG_F], a                            ; $049C
    ret                                           ; $049F


; C: developers' name: same code as MEN_FADE_DEC in the old build of table 2A at old 04A6 and 35 at old 07A0 (26
; bytes, exact match)
MEN_FADE_DEC::
    ld c, a                                       ; $04A0
    ld e, $04                                     ; $04A1
    ld b, $00                                     ; $04A3

jr_000_04a5:
    ld a, c                                       ; $04A5
    and $03                                       ; $04A6
    jr z, jr_000_04ab                             ; $04A8

    dec a                                         ; $04AA

jr_000_04ab:
    or b                                          ; $04AB
    ld b, a                                       ; $04AC
    rrc b                                         ; $04AD
    rrc b                                         ; $04AF
    rrc c                                         ; $04B1
    rrc c                                         ; $04B3
    dec e                                         ; $04B5
    jr nz, jr_000_04a5                            ; $04B6

    ld a, b                                       ; $04B8
    ret                                           ; $04B9


; C: developers' name: same code as TITL_GAMEN in the old build of table 2A at old 04C0 and 35 at old 07BA (37 bytes,
; masked match)
TITL_GAMEN::
    ld hl, $4001                                  ; $04BA
    ld de, $8000                                  ; $04BD
    ld bc, $1800                                  ; $04C0
    call DATA_MOV                                 ; $04C3
    ld hl, $5801                                  ; $04C6
    ld de, $9800                                  ; $04C9
    ld bc, $0240                                  ; $04CC
    call DATA_MOV                                 ; $04CF
    ld hl, TITLE_OBJ                              ; $04D2
    ld de, wOBJRAM                                ; $04D5
    ld bc, $0010                                  ; $04D8
    call DATA_MOV                                 ; $04DB
    ret                                           ; $04DE


; C: developers' name: the same bytes as the data label TITLE_OBJ in the old build of table 2A at old 04E5 and 35 at
; old 07DF (16 bytes, data match)
TITLE_OBJ::
    db $60, $4c, $10, $00, $60, $54, $12, $00, $60, $5c, $14, $00, $60, $64, $16, $00

; C: developers' name: same code as GAME_TITL in the old build of table 2A at old 04F5 and 35 at old 07EF (84 bytes,
; masked match)
GAME_TITL::
    ld a, [wTITLE_FLAG]                           ; $04EF
    inc a                                         ; $04F2
    ld [wTITLE_FLAG], a                           ; $04F3
    cp $08                                        ; $04F6
    jr z, jr_000_0518                             ; $04F8

    cp $10                                        ; $04FA
    jr nz, jr_000_052c                            ; $04FC

    ld a, $10                                     ; $04FE
    ld [wDOG_ANIME_C002], a                       ; $0500
    ld a, $12                                     ; $0503
    ld [wDOG_ANIME_C006], a                       ; $0505
    ld a, $14                                     ; $0508
    ld [wGAME_TITL_C00A], a                       ; $050A
    ld a, $16                                     ; $050D
    ld [wGAME_TITL_C00E], a                       ; $050F
    xor a                                         ; $0512
    ld [wTITLE_FLAG], a                           ; $0513
    jr jr_000_052c                                ; $0516

jr_000_0518:
    ld a, $18                                     ; $0518
    ld [wDOG_ANIME_C002], a                       ; $051A
    ld a, $1a                                     ; $051D
    ld [wDOG_ANIME_C006], a                       ; $051F
    ld a, $1c                                     ; $0522
    ld [wGAME_TITL_C00A], a                       ; $0524
    ld a, $1e                                     ; $0527
    ld [wGAME_TITL_C00E], a                       ; $0529

jr_000_052c:
    ldh a, [hTRG1]                                ; $052C
    and $0f                                       ; $052E
    call nz, MenFade_Start                        ; $0530
    call MEN_FADE                                 ; $0533
    ld a, [wMEN_CHG_F]                            ; $0536
    and a                                         ; $0539
    jr z, jr_000_0543                             ; $053A

    xor a                                         ; $053C
    ld [wINF_CUR], a                              ; $053D
    call MAKE_MENU                                ; $0540

jr_000_0543:
    ret                                           ; $0543


; C: developers' name: same code as MAKE_MENU in the old build of table 2A at old 054A and 35 at old 0844 (43 bytes,
; masked match)
MAKE_MENU::
    call LCDCOFF                                  ; $0544
    call VRAM_CLR                                 ; $0547
    call DMACLR                                   ; $054A
    ldh a, [hBANK_BUF]                            ; $054D
    push af                                       ; $054F
    ld a, $01                                     ; $0550
    ldh [hBANK_BUF], a                            ; $0552
    ld [$2100], a                                 ; $0554
    ld hl, Gfx_01_4001_FNTOOE1                    ; $0557
    ld de, $8000                                  ; $055A
    ld bc, $1800                                  ; $055D
    call DATA_MOV                                 ; $0560
    ld hl, Map_01_5A41_MENU1                      ; $0563
    ld de, $9800                                  ; $0566
    ld bc, $0240                                  ; $0569
    call DATA_MOV                                 ; $056C

; C: developers' name: same code as WANKO in the old build of table 2A at old 0575 and 35 at old 086F (58 bytes,
; masked match)
WANKO::
    ld a, [wINF_CUR]                              ; $056F
    ld b, a                                       ; $0572
    ld a, $34                                     ; $0573

jr_000_0575:
    ldh [hR0], a                                  ; $0575
    ld a, b                                       ; $0577
    or a                                          ; $0578
    jr z, jr_000_0583                             ; $0579

    dec a                                         ; $057B
    ld b, a                                       ; $057C
    ldh a, [hR0]                                  ; $057D
    add $10                                       ; $057F
    jr jr_000_0575                                ; $0581

jr_000_0583:
    ld hl, wOBJRAM                                ; $0583
    ldh a, [hR0]                                  ; $0586
    ld [hl+], a                                   ; $0588
    ld a, $1e                                     ; $0589
    ld [hl+], a                                   ; $058B
    ld a, $04                                     ; $058C
    ld [hl+], a                                   ; $058E
    xor a                                         ; $058F
    ld [hl+], a                                   ; $0590
    ldh a, [hR0]                                  ; $0591
    ld [hl+], a                                   ; $0593
    ld a, $26                                     ; $0594
    ld [hl+], a                                   ; $0596
    ld a, $06                                     ; $0597
    ld [hl+], a                                   ; $0599
    xor a                                         ; $059A
    ld [hl+], a                                   ; $059B
    call SCYX_SET0                                ; $059C
    call OBJP_DEF_SET                             ; $059F
    call Bgp_SetDefault                           ; $05A2
    ld a, $c7                                     ; $05A5
    ldh [rLCDC], a                                ; $05A7

; I: developers' name: same code as MKMENU_END in the old build of table 2A at old 05AF and 35 at old 08A9 (12 bytes,
; exact match)
MKMENU_END::
    ld a, SEQ_MAIN_MENU                           ; $05A9
    ld [wGAME_SEQ], a                             ; $05AB
    pop af                                        ; $05AE
    ldh [hBANK_BUF], a                            ; $05AF
    ld [$2100], a                                 ; $05B1
    ret                                           ; $05B4


; C: developers' name: same code as MAIN_MENU in the old build of table 2A at old 05BB and 35 at old 08B5 (166 bytes,
; masked match)
MAIN_MENU::
    ldh a, [hTRG1]                                ; $05B5
    sla a                                         ; $05B7
    jp c, Jump_000_062a                           ; $05B9

    sla a                                         ; $05BC
    jp c, Jump_000_0639                           ; $05BE

    sla a                                         ; $05C1
    sla a                                         ; $05C3
    sla a                                         ; $05C5
    sla a                                         ; $05C7
    sla a                                         ; $05C9
    sla a                                         ; $05CB
    jr c, jr_000_05d5                             ; $05CD

    call DOG_ANIME                                ; $05CF
    jp Jump_000_065a                              ; $05D2


jr_000_05d5:
    ld a, $08                                     ; $05D5
    ld [wDOG_ANIME_C002], a                       ; $05D7
    ld a, $0a                                     ; $05DA
    ld [wDOG_ANIME_C006], a                       ; $05DC
    ld a, $08                                     ; $05DF
    ldh [hOBJ_CT], a                              ; $05E1
    xor a                                         ; $05E3
    ld [wINF_CUR], a                              ; $05E4
    ld a, $20                                     ; $05E7
    ldh [hR0], a                                  ; $05E9

jr_000_05eb:
    ldh a, [hR0]                                  ; $05EB
    or a                                          ; $05ED
    jr z, jr_000_0607                             ; $05EE

    dec a                                         ; $05F0
    ldh [hR0], a                                  ; $05F1
    call DOG_ANIME                                ; $05F3
    or $ff                                        ; $05F6
    ldh [hMAIN_AFURE], a                          ; $05F8

jr_000_05fa:
    halt                                          ; $05FA
    ldh a, [hVBFLG]                               ; $05FB
    and a                                         ; $05FD
    jr z, jr_000_05fa                             ; $05FE

    xor a                                         ; $0600
    ldh [hVBFLG], a                               ; $0601
    ldh [hMAIN_AFURE], a                          ; $0603
    jr jr_000_05eb                                ; $0605

jr_000_0607:
    ld a, [wOBJRAM]                               ; $0607
    cp $34                                        ; $060A
    call z, MK_SRAM_MENU                          ; $060C
    cp $44                                        ; $060F
    call z, BankTest_InitScreen                   ; $0611
    cp $54                                        ; $0614
    call z, MK_PROTECT                            ; $0616
    cp $64                                        ; $0619
    call z, MAKE_MOVIE                            ; $061B
    cp $74                                        ; $061E
    call z, MAKE_GALLERY                          ; $0620
    cp $84                                        ; $0623
    call z, MAKE_EMI                              ; $0625
    jr jr_000_065a                                ; $0628

Jump_000_062a:
    ld a, [wOBJRAM]                               ; $062A
    cp $84                                        ; $062D
    jr nz, jr_000_0635                            ; $062F

    sub $50                                       ; $0631
    jr jr_000_0646                                ; $0633

jr_000_0635:
    add $10                                       ; $0635
    jr jr_000_0646                                ; $0637

Jump_000_0639:
    ld a, [wOBJRAM]                               ; $0639
    cp $34                                        ; $063C
    jr nz, jr_000_0644                            ; $063E

    add $50                                       ; $0640
    jr jr_000_0646                                ; $0642

jr_000_0644:
    sub $10                                       ; $0644

jr_000_0646:
    ld [wOBJRAM], a                               ; $0646
    ld [wMAIN_MENU_C004], a                       ; $0649
    ld a, $00                                     ; $064C
    ld [wDOG_ANIME_C002], a                       ; $064E
    ld a, $02                                     ; $0651
    ld [wDOG_ANIME_C006], a                       ; $0653
    ld a, $18                                     ; $0656
    ldh [hOBJ_CT], a                              ; $0658

Jump_000_065a:
jr_000_065a:
    ret                                           ; $065A


; C: developers' name: same code as DOG_ANIME in the old build of table 2A at old 0661 and 35 at old 095B (70 bytes,
; exact match)
DOG_ANIME::
    ldh a, [hOBJ_CT]                              ; $065B
    and a                                         ; $065D
    jr nz, jr_000_068f                            ; $065E

    ldh a, [hOBJ_CT2]                             ; $0660
    and a                                         ; $0662
    jr nz, jr_000_066a                            ; $0663

    ld a, $21                                     ; $0665
    ldh [hOBJ_CT2], a                             ; $0667
    ret                                           ; $0669


jr_000_066a:
    ld hl, hOBJ_CT2                               ; $066A
    dec [hl]                                      ; $066D
    ldh a, [hOBJ_CT2]                             ; $066E
    cp $20                                        ; $0670
    jr z, jr_000_0679                             ; $0672

    cp $10                                        ; $0674
    jr z, jr_000_0684                             ; $0676

    ret                                           ; $0678


jr_000_0679:
    ld a, $04                                     ; $0679
    ld [wDOG_ANIME_C002], a                       ; $067B
    ld a, $06                                     ; $067E
    ld [wDOG_ANIME_C006], a                       ; $0680
    ret                                           ; $0683


jr_000_0684:
    ld a, $0c                                     ; $0684
    ld [wDOG_ANIME_C002], a                       ; $0686
    ld a, $0e                                     ; $0689
    ld [wDOG_ANIME_C006], a                       ; $068B
    ret                                           ; $068E


jr_000_068f:
    dec a                                         ; $068F
    ldh [hOBJ_CT], a                              ; $0690
    or a                                          ; $0692
    jr z, jr_000_0696                             ; $0693

    ret                                           ; $0695


jr_000_0696:
    ld a, $04                                     ; $0696
    ld [wDOG_ANIME_C002], a                       ; $0698
    ld a, $06                                     ; $069B
    ld [wDOG_ANIME_C006], a                       ; $069D
    ret                                           ; $06A0


; I: leftover: 3 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_06A1::
    db $c9, $c9, $c9

; I: LCDCOFF, VRAM_CLR, DMACLR, then falls into CB2 (bank 2 selected for the BANK screen); called once
BankTest_InitScreen::
    call LCDCOFF                                  ; $06A4
    call VRAM_CLR                                 ; $06A7
    call DMACLR                                   ; $06AA

; C: developers' name: same code as CB2 in the old build of table 2A at old 06B3 and 35 at old 09AD (53 bytes, masked
; match)
CB2::
    ldh a, [hBANK_BUF]                            ; $06AD
    push af                                       ; $06AF
    ld a, $02                                     ; $06B0
    ldh [hBANK_BUF], a                            ; $06B2
    ld [$2100], a                                 ; $06B4
    ld hl, Gfx_02_4001_FNTOOE2                    ; $06B7
    ld de, $8000                                  ; $06BA
    ld bc, $1800                                  ; $06BD
    call DATA_MOV                                 ; $06C0
    ld hl, Map_02_5801_BG_BANK                    ; $06C3
    ld de, $9800                                  ; $06C6
    ld bc, $0240                                  ; $06C9
    call DATA_MOV                                 ; $06CC
    ld a, $c7                                     ; $06CF
    ldh [rLCDC], a                                ; $06D1
    ld a, SEQ_BANK_TEST                           ; $06D3
    ld [wGAME_SEQ], a                             ; $06D5
    xor a                                         ; $06D8
    ldh [hR0], a                                  ; $06D9
    pop af                                        ; $06DB
    ldh [hBANK_BUF], a                            ; $06DC
    ld [$2100], a                                 ; $06DE
    ret                                           ; $06E1


; C: developers' name: same code as BANK_TEST in the old build of table 2A at old 06E8 and 35 at old 09E2 (85 bytes,
; masked match)
BANK_TEST::
    ldh a, [hTRG1]                                ; $06E2
    srl a                                         ; $06E4
    srl a                                         ; $06E6
    jr c, jr_000_06ec                             ; $06E8

    jr jr_000_06f5                                ; $06EA

jr_000_06ec:
    ld a, $01                                     ; $06EC
    ld [wINF_CUR], a                              ; $06EE
    call MAKE_MENU                                ; $06F1
    ret                                           ; $06F4


jr_000_06f5:
    ldh a, [hR0]                                  ; $06F5
    or a                                          ; $06F7
    ret nz                                        ; $06F8

    ld d, $01                                     ; $06F9

jr_000_06fb:
    ld a, d                                       ; $06FB
    ld [rROMB0], a                                ; $06FC
    ld a, [$4000]                                 ; $06FF
    cp d                                          ; $0702
    jr nz, jr_000_0713                            ; $0703

    ld a, [$7fff]                                 ; $0705
    cp d                                          ; $0708
    jr nz, jr_000_0713                            ; $0709

    ld a, d                                       ; $070B
    cp $3f                                        ; $070C
    jr z, jr_000_0726                             ; $070E

    inc d                                         ; $0710
    jr jr_000_06fb                                ; $0711

jr_000_0713:
    call LCDCOFF                                  ; $0713
    ld a, $ce                                     ; $0716
    ld [$98cc], a                                 ; $0718
    ld a, $c7                                     ; $071B
    ld [$98cd], a                                 ; $071D
    ld a, $c1                                     ; $0720
    ldh [rLCDC], a                                ; $0722
    jr TEST4M                                     ; $0724

jr_000_0726:
    call LCDCOFF                                  ; $0726
    ld a, $cf                                     ; $0729
    ld [$98cc], a                                 ; $072B
    ld a, $cb                                     ; $072E
    ld [$98cd], a                                 ; $0730
    ld a, $c1                                     ; $0733
    ldh [rLCDC], a                                ; $0735

; C: developers' name: same code as TEST4M in the old build of table 2A at old 073D and 35 at old 0A37 (72 bytes,
; masked match)
TEST4M::
    ld d, $01                                     ; $0737
    ld c, $01                                     ; $0739

jr_000_073b:
    ld a, d                                       ; $073B
    ld [rROMB0], a                                ; $073C
    ld a, [$4000]                                 ; $073F
    cp c                                          ; $0742
    jr nz, jr_000_0757                            ; $0743

    ld a, [$7fff]                                 ; $0745
    cp c                                          ; $0748
    jr nz, jr_000_0757                            ; $0749

    ld a, d                                       ; $074B
    cp $3f                                        ; $074C
    jr z, jr_000_076a                             ; $074E

    inc d                                         ; $0750
    ld a, d                                       ; $0751
    and $1f                                       ; $0752
    ld c, a                                       ; $0754
    jr jr_000_073b                                ; $0755

jr_000_0757:
    call LCDCOFF                                  ; $0757
    ld a, $ce                                     ; $075A
    ld [$990c], a                                 ; $075C
    ld a, $c7                                     ; $075F
    ld [$990d], a                                 ; $0761
    ld a, $c1                                     ; $0764
    ldh [rLCDC], a                                ; $0766
    jr jr_000_077b                                ; $0768

jr_000_076a:
    call LCDCOFF                                  ; $076A
    ld a, $cf                                     ; $076D
    ld [$990c], a                                 ; $076F
    ld a, $cb                                     ; $0772
    ld [$990d], a                                 ; $0774
    ld a, $c1                                     ; $0777
    ldh [rLCDC], a                                ; $0779

jr_000_077b:
    ld a, $ff                                     ; $077B
    ldh [hR0], a                                  ; $077D
    ret                                           ; $077F


; C: developers' name: same code as MK_SRAM_MENU in the old build of table 2A at old 0786 and 35 at old 0A80 (105
; bytes, masked match)
MK_SRAM_MENU::
    call LCDCOFF                                  ; $0780
    call VRAM_CLR                                 ; $0783
    call DMACLR                                   ; $0786
    ld a, $02                                     ; $0789
    ld [rROMB0], a                                ; $078B
    ld hl, Gfx_02_4001_FNTOOE2                    ; $078E
    ld de, $8000                                  ; $0791
    ld bc, $1800                                  ; $0794
    call DATA_MOV                                 ; $0797
    ld hl, Map_02_5A41_BGSRAM1                    ; $079A
    ld de, $9800                                  ; $079D
    ld bc, $0240                                  ; $07A0
    call DATA_MOV                                 ; $07A3
    ld a, [wINF_CUR]                              ; $07A6
    ld b, a                                       ; $07A9
    ld a, $3c                                     ; $07AA

jr_000_07ac:
    ldh [hR0], a                                  ; $07AC
    ld a, b                                       ; $07AE
    or a                                          ; $07AF
    jr z, jr_000_07ba                             ; $07B0

    dec a                                         ; $07B2
    ld b, a                                       ; $07B3
    ldh a, [hR0]                                  ; $07B4
    add $10                                       ; $07B6
    jr jr_000_07ac                                ; $07B8

jr_000_07ba:
    ld hl, wOBJRAM                                ; $07BA
    ldh a, [hR0]                                  ; $07BD
    ld [hl+], a                                   ; $07BF
    ld a, $2e                                     ; $07C0
    ld [hl+], a                                   ; $07C2
    xor a                                         ; $07C3
    ld [hl+], a                                   ; $07C4
    ld [hl+], a                                   ; $07C5
    ldh a, [hR0]                                  ; $07C6
    ld [hl+], a                                   ; $07C8
    ld a, $36                                     ; $07C9
    ld [hl+], a                                   ; $07CB
    ld a, $02                                     ; $07CC
    ld [hl+], a                                   ; $07CE
    xor a                                         ; $07CF
    ld [hl+], a                                   ; $07D0
    ldh [hOBJ_CT2], a                             ; $07D1
    ld [wOK_FLAG], a                              ; $07D3
    call SCYX_SET0                                ; $07D6
    call OBJP_DEF_SET                             ; $07D9
    call Bgp_SetDefault                           ; $07DC
    ld a, $c7                                     ; $07DF
    ldh [rLCDC], a                                ; $07E1
    ld a, SEQ_SRAM_MENU                           ; $07E3
    ld [wGAME_SEQ], a                             ; $07E5
    ret                                           ; $07E8


; C: developers' name: same code as SRAM_MENU in the old build of table 2A at old 07EF and 35 at old 0AE9 (122 bytes,
; masked match)
SRAM_MENU::
    ldh a, [hTRG1]                                ; $07E9
    sla a                                         ; $07EB
    jr c, jr_000_083c                             ; $07ED

    sla a                                         ; $07EF
    jr c, jr_000_084b                             ; $07F1

    sla a                                         ; $07F3
    sla a                                         ; $07F5
    sla a                                         ; $07F7
    sla a                                         ; $07F9
    sla a                                         ; $07FB
    jr c, jr_000_0808                             ; $07FD

    sla a                                         ; $07FF
    jr c, jr_000_0811                             ; $0801

    call KAO_ANIME                                ; $0803
    jr jr_000_0862                                ; $0806

jr_000_0808:
    xor a                                         ; $0808
    ld [wINF_CUR], a                              ; $0809
    call MAKE_MENU                                ; $080C
    jr jr_000_0862                                ; $080F

jr_000_0811:
    xor a                                         ; $0811
    ld [wOK_FLAG], a                              ; $0812
    ld a, [wOBJRAM]                               ; $0815
    cp $3c                                        ; $0818
    jr nz, jr_000_0821                            ; $081A

    call SRAM_VERIFY                              ; $081C
    jr jr_000_083a                                ; $081F

jr_000_0821:
    cp $4c                                        ; $0821
    jr nz, jr_000_082a                            ; $0823

    call SRAM_WRITE                               ; $0825
    jr jr_000_083a                                ; $0828

jr_000_082a:
    cp $5c                                        ; $082A
    jr nz, jr_000_0837                            ; $082C

    ld a, $35                                     ; $082E
    ldh [hR0], a                                  ; $0830
    call MK_SRAM_DATA                             ; $0832
    jr jr_000_083a                                ; $0835

jr_000_0837:
    call MK_SRAM_DUMP                             ; $0837

jr_000_083a:
    jr jr_000_0862                                ; $083A

jr_000_083c:
    ld a, [wOBJRAM]                               ; $083C
    cp $6c                                        ; $083F
    jr nz, jr_000_0847                            ; $0841

    sub $30                                       ; $0843
    jr jr_000_0858                                ; $0845

jr_000_0847:
    add $10                                       ; $0847
    jr jr_000_0858                                ; $0849

jr_000_084b:
    ld a, [wOBJRAM]                               ; $084B
    cp $3c                                        ; $084E
    jr nz, jr_000_0856                            ; $0850

    add $30                                       ; $0852
    jr jr_000_0858                                ; $0854

jr_000_0856:
    sub $10                                       ; $0856

jr_000_0858:
    ld [wOBJRAM], a                               ; $0858
    ld [wMAIN_MENU_C004], a                       ; $085B
    xor a                                         ; $085E
    ld [wOK_FLAG], a                              ; $085F

jr_000_0862:
    ret                                           ; $0862


; C: developers' name: same code as VB_SRAM_MENU in the old build of table 2A at old 0869 and 35 at old 0B63 (78
; bytes, exact match)
VB_SRAM_MENU::
    ld a, [wOK_FLAG]                              ; $0863
    or a                                          ; $0866
    jr nz, jr_000_087c                            ; $0867

    ld a, $a0                                     ; $0869
    ld [$98ce], a                                 ; $086B
    ld [$98cf], a                                 ; $086E
    ld [$990d], a                                 ; $0871
    ld [$990e], a                                 ; $0874
    ld [$990f], a                                 ; $0877
    jr jr_000_08b1                                ; $087A

jr_000_087c:
    cp $01                                        ; $087C
    jr nz, jr_000_088c                            ; $087E

    ld a, $cf                                     ; $0880
    ld [$98ce], a                                 ; $0882
    ld a, $cb                                     ; $0885
    ld [$98cf], a                                 ; $0887
    jr jr_000_08b1                                ; $088A

jr_000_088c:
    cp $02                                        ; $088C
    jr nz, jr_000_089c                            ; $088E

    ld a, $ce                                     ; $0890
    ld [$98ce], a                                 ; $0892
    ld a, $c7                                     ; $0895
    ld [$98cf], a                                 ; $0897
    jr jr_000_08b1                                ; $089A

jr_000_089c:
    cp $03                                        ; $089C
    jr nz, jr_000_08b1                            ; $089E

    ld a, $38                                     ; $08A0
    ld [$990d], a                                 ; $08A2
    ld a, $39                                     ; $08A5
    ld [$990e], a                                 ; $08A7
    ld a, $3a                                     ; $08AA
    ld [$990f], a                                 ; $08AC
    jr jr_000_08b1                                ; $08AF

jr_000_08b1:
    ret                                           ; $08B1


; C: developers' name: same code as SRAM_VERIFY in the old build of table 2A at old 08B8 and 35 at old 0BB2 (72 bytes,
; exact match)
SRAM_VERIFY::
    ld d, $00                                     ; $08B2
    ld bc, $55aa                                  ; $08B4
    ld a, $01                                     ; $08B7
    ld [$6000], a                                 ; $08B9

jr_000_08bc:
    or $ff                                        ; $08BC
    ldh [hMAIN_AFURE], a                          ; $08BE

jr_000_08c0:
    ldh a, [hVBFLG]                               ; $08C0
    and a                                         ; $08C2
    jr z, jr_000_08c0                             ; $08C3

    xor a                                         ; $08C5
    ldh [hVBFLG], a                               ; $08C6
    ldh [hMAIN_AFURE], a                          ; $08C8
    ld hl, $a000                                  ; $08CA
    ld a, d                                       ; $08CD
    ld [rRAMB], a                                 ; $08CE

jr_000_08d1:
    ld a, [hl+]                                   ; $08D1
    cp b                                          ; $08D2
    jr nz, jr_000_08f4                            ; $08D3

    ld a, [hl+]                                   ; $08D5
    cp c                                          ; $08D6
    jr nz, jr_000_08f4                            ; $08D7

    dec c                                         ; $08D9
    ld a, c                                       ; $08DA
    cp $ff                                        ; $08DB
    jr nz, jr_000_08e0                            ; $08DD

    dec b                                         ; $08DF

jr_000_08e0:
    ld a, h                                       ; $08E0
    cp $c0                                        ; $08E1
    jr nz, jr_000_08d1                            ; $08E3

    ld a, d                                       ; $08E5
    cp $0f                                        ; $08E6
    jr z, jr_000_08ed                             ; $08E8

    inc d                                         ; $08EA
    jr jr_000_08bc                                ; $08EB

jr_000_08ed:
    ld a, $01                                     ; $08ED
    ld [wOK_FLAG], a                              ; $08EF
    ei                                            ; $08F2
    ret                                           ; $08F3


jr_000_08f4:
    ld a, $02                                     ; $08F4
    ld [wOK_FLAG], a                              ; $08F6
    ret                                           ; $08F9


; C: developers' name: same code as SRAM_WRITE in the old build of table 2A at old 0900 and 35 at old 0BFA (56 bytes,
; exact match)
SRAM_WRITE::
    ld d, $00                                     ; $08FA
    ld bc, $55aa                                  ; $08FC

jr_000_08ff:
    or $ff                                        ; $08FF
    ldh [hMAIN_AFURE], a                          ; $0901

jr_000_0903:
    ldh a, [hVBFLG]                               ; $0903
    and a                                         ; $0905
    jr z, jr_000_0903                             ; $0906

    xor a                                         ; $0908
    ldh [hVBFLG], a                               ; $0909
    ldh [hMAIN_AFURE], a                          ; $090B
    ld hl, $a000                                  ; $090D
    ld a, d                                       ; $0910
    ld [rRAMB], a                                 ; $0911

jr_000_0914:
    ld a, b                                       ; $0914
    ld [hl+], a                                   ; $0915
    ld a, c                                       ; $0916
    ld [hl+], a                                   ; $0917
    dec c                                         ; $0918
    ld a, c                                       ; $0919
    cp $ff                                        ; $091A
    jr nz, jr_000_091f                            ; $091C

    dec b                                         ; $091E

jr_000_091f:
    ld a, h                                       ; $091F
    cp $c0                                        ; $0920
    jr nz, jr_000_0914                            ; $0922

    ld a, d                                       ; $0924
    cp $0f                                        ; $0925
    jr z, jr_000_092c                             ; $0927

    inc d                                         ; $0929
    jr jr_000_08ff                                ; $092A

jr_000_092c:
    ld a, $03                                     ; $092C
    ld [wOK_FLAG], a                              ; $092E
    ret                                           ; $0931


; C: developers' name: same code as MK_SRAM_DATA in the old build of table 2A at old 0938 and 35 at old 0C32 (93
; bytes, masked match)
MK_SRAM_DATA::
    call LCDCOFF                                  ; $0932
    call VRAM_CLR                                 ; $0935
    call DMACLR                                   ; $0938
    ldh a, [hBANK_BUF]                            ; $093B
    push af                                       ; $093D
    ld a, $02                                     ; $093E
    ldh [hBANK_BUF], a                            ; $0940
    ld [$2100], a                                 ; $0942
    ld hl, Gfx_02_4001_FNTOOE2                    ; $0945
    ld de, $8000                                  ; $0948
    ld bc, $1800                                  ; $094B
    call DATA_MOV                                 ; $094E
    ld hl, Map_02_5C81_BGSRAM2                    ; $0951
    ld de, $9800                                  ; $0954
    ld bc, $0240                                  ; $0957
    call DATA_MOV                                 ; $095A
    ld hl, wOBJRAM                                ; $095D
    ldh a, [hR0]                                  ; $0960
    ld [hl+], a                                   ; $0962
    ld a, $1e                                     ; $0963
    ld [hl+], a                                   ; $0965
    xor a                                         ; $0966
    ld [hl+], a                                   ; $0967
    ld [hl+], a                                   ; $0968
    ldh a, [hR0]                                  ; $0969
    ld [hl+], a                                   ; $096B
    ld a, $26                                     ; $096C
    ld [hl+], a                                   ; $096E
    ld a, $02                                     ; $096F
    ld [hl+], a                                   ; $0971
    xor a                                         ; $0972
    ld [hl+], a                                   ; $0973
    ldh [hOBJ_CT2], a                             ; $0974
    call SCYX_SET0                                ; $0976
    call OBJP_DEF_SET                             ; $0979
    call Bgp_SetDefault                           ; $097C
    ld a, $c7                                     ; $097F
    ldh [rLCDC], a                                ; $0981
    ld a, SEQ_SRAM_DATA_SEL                       ; $0983
    ld [wGAME_SEQ], a                             ; $0985
    pop af                                        ; $0988
    ldh [hBANK_BUF], a                            ; $0989
    ld [$2100], a                                 ; $098B
    ret                                           ; $098E


; C: developers' name: same code as SRAM_DATA_SEL in the old build of table 2A at old 0995 and 35 at old 0C8F (86
; bytes, masked match)
SRAM_DATA_SEL::
    ldh a, [hTRG1]                                ; $098F
    sla a                                         ; $0991
    jr c, jr_000_09c2                             ; $0993

    sla a                                         ; $0995
    jr c, jr_000_09d1                             ; $0997

    sla a                                         ; $0999
    sla a                                         ; $099B
    sla a                                         ; $099D
    sla a                                         ; $099F
    sla a                                         ; $09A1
    jr c, jr_000_09ae                             ; $09A3

    sla a                                         ; $09A5
    jr c, jr_000_09b8                             ; $09A7

    call KAO_ANIME                                ; $09A9
    jr jr_000_09e4                                ; $09AC

jr_000_09ae:
    ld a, $02                                     ; $09AE
    ld [wINF_CUR], a                              ; $09B0
    call MK_SRAM_MENU                             ; $09B3
    jr jr_000_09e4                                ; $09B6

jr_000_09b8:
    ld a, [wOBJRAM]                               ; $09B8
    ldh [hR0], a                                  ; $09BB
    call MK_SRAM_AGING                            ; $09BD
    jr jr_000_09e4                                ; $09C0

jr_000_09c2:
    ld a, [wOBJRAM]                               ; $09C2
    cp $75                                        ; $09C5
    jr nz, jr_000_09cd                            ; $09C7

    sub $40                                       ; $09C9
    jr jr_000_09de                                ; $09CB

jr_000_09cd:
    add $10                                       ; $09CD
    jr jr_000_09de                                ; $09CF

jr_000_09d1:
    ld a, [wOBJRAM]                               ; $09D1
    cp $35                                        ; $09D4
    jr nz, jr_000_09dc                            ; $09D6

    add $40                                       ; $09D8
    jr jr_000_09de                                ; $09DA

jr_000_09dc:
    sub $10                                       ; $09DC

jr_000_09de:
    ld [wOBJRAM], a                               ; $09DE
    ld [wMAIN_MENU_C004], a                       ; $09E1

jr_000_09e4:
    ret                                           ; $09E4


; C: developers' name: same code as KAO_ANIME in the old build of table 2A at old 09EB and 35 at old 0CE5 (132 bytes,
; exact match)
KAO_ANIME::
    ldh a, [hOBJ_CT2]                             ; $09E5
    inc a                                         ; $09E7
    cp $40                                        ; $09E8
    jr nz, jr_000_09ed                            ; $09EA

    xor a                                         ; $09EC

jr_000_09ed:
    ldh [hOBJ_CT2], a                             ; $09ED
    cp $00                                        ; $09EF
    jr nz, jr_000_0a00                            ; $09F1

    ld c, $00                                     ; $09F3
    ld d, $02                                     ; $09F5
    xor a                                         ; $09F7
    ld [wKAO_ANIME_C003], a                       ; $09F8
    ld [wKAO_ANIME_C007], a                       ; $09FB
    jr jr_000_0a60                                ; $09FE

jr_000_0a00:
    cp $04                                        ; $0A00
    jr nz, jr_000_0a0a                            ; $0A02

    ld c, $04                                     ; $0A04
    ld d, $06                                     ; $0A06
    jr jr_000_0a60                                ; $0A08

jr_000_0a0a:
    cp $08                                        ; $0A0A
    jr nz, jr_000_0a14                            ; $0A0C

    ld c, $08                                     ; $0A0E
    ld d, $0a                                     ; $0A10
    jr jr_000_0a60                                ; $0A12

jr_000_0a14:
    cp $0c                                        ; $0A14
    jr nz, jr_000_0a1e                            ; $0A16

    ld c, $0c                                     ; $0A18
    ld d, $0e                                     ; $0A1A
    jr jr_000_0a60                                ; $0A1C

jr_000_0a1e:
    cp $10                                        ; $0A1E
    jr nz, jr_000_0a28                            ; $0A20

    ld c, $10                                     ; $0A22
    ld d, $12                                     ; $0A24
    jr jr_000_0a60                                ; $0A26

jr_000_0a28:
    cp $14                                        ; $0A28
    jr nz, jr_000_0a32                            ; $0A2A

    ld c, $14                                     ; $0A2C
    ld d, $16                                     ; $0A2E
    jr jr_000_0a60                                ; $0A30

jr_000_0a32:
    cp $30                                        ; $0A32
    jr nz, jr_000_0a44                            ; $0A34

    ld c, $12                                     ; $0A36
    ld d, $10                                     ; $0A38
    ld a, $20                                     ; $0A3A
    ld [wKAO_ANIME_C003], a                       ; $0A3C
    ld [wKAO_ANIME_C007], a                       ; $0A3F
    jr jr_000_0a60                                ; $0A42

jr_000_0a44:
    cp $34                                        ; $0A44
    jr nz, jr_000_0a4e                            ; $0A46

    ld c, $0e                                     ; $0A48
    ld d, $0c                                     ; $0A4A
    jr jr_000_0a60                                ; $0A4C

jr_000_0a4e:
    cp $38                                        ; $0A4E
    jr nz, jr_000_0a58                            ; $0A50

    ld c, $0a                                     ; $0A52
    ld d, $08                                     ; $0A54
    jr jr_000_0a60                                ; $0A56

jr_000_0a58:
    cp $3c                                        ; $0A58
    jr nz, jr_000_0a68                            ; $0A5A

    ld c, $06                                     ; $0A5C
    ld d, $04                                     ; $0A5E

jr_000_0a60:
    ld a, c                                       ; $0A60
    ld [wDOG_ANIME_C002], a                       ; $0A61
    ld a, d                                       ; $0A64
    ld [wDOG_ANIME_C006], a                       ; $0A65

jr_000_0a68:
    ret                                           ; $0A68


; C: developers' name: same code as MK_SRAM_AGING in the old build of table 2A at old 0A6F and 35 at old 0D69 (95
; bytes, masked match)
MK_SRAM_AGING::
    call LCDCOFF                                  ; $0A69
    call VRAM_CLR                                 ; $0A6C
    call DMACLR                                   ; $0A6F
    ldh a, [hBANK_BUF]                            ; $0A72
    push af                                       ; $0A74
    ld a, $02                                     ; $0A75
    ldh [hBANK_BUF], a                            ; $0A77
    ld [$2100], a                                 ; $0A79
    ld hl, Gfx_02_4001_FNTOOE2                    ; $0A7C
    ld de, $8000                                  ; $0A7F
    ld bc, $1800                                  ; $0A82
    call DATA_MOV                                 ; $0A85
    ld hl, Map_02_5EC1_BGSRAM3                    ; $0A88
    ld de, $9800                                  ; $0A8B
    ld bc, $0240                                  ; $0A8E
    call DATA_MOV                                 ; $0A91
    ld bc, $98a7                                  ; $0A94
    ldh a, [hR0]                                  ; $0A97
    cp $35                                        ; $0A99
    jr nz, jr_000_0aa2                            ; $0A9B

    ld hl, PAT_DEC                                ; $0A9D
    jr PAT_SET                                    ; $0AA0

jr_000_0aa2:
    cp $45                                        ; $0AA2
    jr nz, jr_000_0aab                            ; $0AA4

    ld hl, PAT_0F                                 ; $0AA6
    jr PAT_SET                                    ; $0AA9

jr_000_0aab:
    cp $55                                        ; $0AAB
    jr nz, jr_000_0ab4                            ; $0AAD

    ld hl, PAT_5A                                 ; $0AAF
    jr PAT_SET                                    ; $0AB2

jr_000_0ab4:
    cp $65                                        ; $0AB4
    jr nz, jr_000_0abd                            ; $0AB6

    ld hl, PAT_00                                 ; $0AB8
    jr PAT_SET                                    ; $0ABB

jr_000_0abd:
    cp $75                                        ; $0ABD
    jr nz, jr_000_0ac6                            ; $0ABF

    ld hl, PAT_FF                                 ; $0AC1
    jr PAT_SET                                    ; $0AC4

jr_000_0ac6:
    jr PAT_END                                    ; $0AC6

; I: developers' name: same code as PAT_SET in the old build of table 2A at old 0ACE and 35 at old 0DC8 (10 bytes,
; exact match)
PAT_SET::
    ld d, $0b                                     ; $0AC8

jr_000_0aca:
    ld a, [hl+]                                   ; $0ACA
    ld [bc], a                                    ; $0ACB
    inc bc                                        ; $0ACC
    dec d                                         ; $0ACD
    ld a, d                                       ; $0ACE
    or a                                          ; $0ACF
    jr nz, jr_000_0aca                            ; $0AD0

; C: developers' name: same code as PAT_END in the old build of table 2A at old 0AD8 and 35 at old 0DD2 (56 bytes,
; masked match)
PAT_END::
    call SCYX_SET0                                ; $0AD2
    call OBJP_DEF_SET                             ; $0AD5
    call Bgp_SetDefault                           ; $0AD8
    ld c, $00                                     ; $0ADB
    ld b, $aa                                     ; $0ADD
    ld hl, $9c00                                  ; $0ADF

jr_000_0ae2:
    ld a, b                                       ; $0AE2
    ld [hl+], a                                   ; $0AE3
    inc c                                         ; $0AE4
    ld a, c                                       ; $0AE5
    or a                                          ; $0AE6
    jr nz, jr_000_0ae2                            ; $0AE7

    xor a                                         ; $0AE9
    ldh [rWX], a                                  ; $0AEA
    ld a, $50                                     ; $0AEC
    ldh [rWY], a                                  ; $0AEE
    ld a, $e7                                     ; $0AF0
    ldh [rLCDC], a                                ; $0AF2
    ld a, SEQ_SRAM_AGING                          ; $0AF4
    ld [wGAME_SEQ], a                             ; $0AF6
    xor a                                         ; $0AF9
    ld [wAGE_CNT_H], a                            ; $0AFA
    ld [wAGE_CNT_L], a                            ; $0AFD
    ld [wAGE_ERROR], a                            ; $0B00
    pop af                                        ; $0B03
    ldh [hBANK_BUF], a                            ; $0B04
    ld [$2100], a                                 ; $0B06
    ret                                           ; $0B09


; I: developers' name: the same bytes as the data label PAT_DEC in the old build of table 2A at old 0B10 and 35 at old
; 0E0A (11 bytes, data match)
PAT_DEC::
    db $c4, $c5, $c3, $d2, $c5, $cd, $c5, $ce, $d4, $a0, $a0

; I: developers' name: the same bytes as the data label PAT_0F in the old build of table 2A at old 0B1B and 35 at old
; 0E15 (11 bytes, data match)
PAT_0F::
    db $80, $80, $ab, $80, $80, $ab, $8f, $8f, $ab, $8f, $8f

; I: developers' name: the same bytes as the data label PAT_5A in the old build of table 2A at old 0B26 and 35 at old
; 0E20 (11 bytes, data match)
PAT_5A::
    db $85, $85, $ab, $85, $85, $ab, $8a, $8a, $ab, $8a, $8a

; I: developers' name: the same bytes as the data label PAT_00 in the old build of table 2A at old 0B31 and 35 at old
; 0E2B (11 bytes, data match)
PAT_00::
    db $c1, $cc, $cc, $a0, $80, $80, $a0, $a0, $a0, $a0, $a0

; I: developers' name: the same bytes as the data label PAT_FF in the old build of table 2A at old 0B3C and 35 at old
; 0E36 (11 bytes, data match)
PAT_FF::
    db $c1, $cc, $cc, $a0, $8f, $8f, $a0, $a0, $a0, $a0, $a0

; C: developers' name: same code as SRAM_AGING in the old build of table 2A at old 0B47 and 35 at old 0E41 (148 bytes,
; masked match)
SRAM_AGING::
    ldh a, [hTRG1]                                ; $0B41
    srl a                                         ; $0B43
    srl a                                         ; $0B45
    jr c, jr_000_0b4b                             ; $0B47

    jr jr_000_0b4f                                ; $0B49

jr_000_0b4b:
    call MK_SRAM_DATA                             ; $0B4B
    ret                                           ; $0B4E


jr_000_0b4f:
    ld a, [wAGE_ERROR]                            ; $0B4F
    or a                                          ; $0B52
    ret nz                                        ; $0B53

    ldh a, [hR0]                                  ; $0B54
    cp $35                                        ; $0B56
    jr nz, jr_000_0b5f                            ; $0B58

    call AGE_DEC                                  ; $0B5A
    jr jr_000_0b93                                ; $0B5D

jr_000_0b5f:
    cp $45                                        ; $0B5F
    jr nz, jr_000_0b6c                            ; $0B61

    ld b, $00                                     ; $0B63
    ld c, $ff                                     ; $0B65
    call Aging_FillSram                           ; $0B67
    jr jr_000_0b93                                ; $0B6A

jr_000_0b6c:
    cp $55                                        ; $0B6C
    jr nz, jr_000_0b79                            ; $0B6E

    ld b, $55                                     ; $0B70
    ld c, $aa                                     ; $0B72
    call Aging_FillSram                           ; $0B74
    jr jr_000_0b93                                ; $0B77

jr_000_0b79:
    cp $65                                        ; $0B79
    jr nz, jr_000_0b86                            ; $0B7B

    ld b, $00                                     ; $0B7D
    ld c, $00                                     ; $0B7F
    call Aging_FillSram                           ; $0B81
    jr jr_000_0b93                                ; $0B84

jr_000_0b86:
    cp $75                                        ; $0B86
    jr nz, jr_000_0b93                            ; $0B88

    ld b, $ff                                     ; $0B8A
    ld c, $ff                                     ; $0B8C
    call Aging_FillSram                           ; $0B8E
    jr jr_000_0b93                                ; $0B91

jr_000_0b93:
    ld a, [wAGE_ERROR]                            ; $0B93
    or a                                          ; $0B96
    jr nz, jr_000_0bd4                            ; $0B97

    ld a, [wAGE_CNT_H]                            ; $0B99
    ld h, a                                       ; $0B9C
    ld a, [wAGE_CNT_L]                            ; $0B9D
    ld l, a                                       ; $0BA0
    inc hl                                        ; $0BA1
    ld a, h                                       ; $0BA2
    ld [wAGE_CNT_H], a                            ; $0BA3
    ld a, l                                       ; $0BA6
    ld [wAGE_CNT_L], a                            ; $0BA7
    ld b, $5a                                     ; $0BAA
    ld d, $00                                     ; $0BAC
    ld a, $01                                     ; $0BAE
    ld [$6000], a                                 ; $0BB0

jr_000_0bb3:
    ld hl, $a000                                  ; $0BB3
    ld a, d                                       ; $0BB6
    ld [rRAMB], a                                 ; $0BB7

jr_000_0bba:
    ld a, b                                       ; $0BBA
    ld [hl+], a                                   ; $0BBB
    ld [hl+], a                                   ; $0BBC
    ld [hl+], a                                   ; $0BBD
    ld [hl+], a                                   ; $0BBE
    ld [hl+], a                                   ; $0BBF
    ld [hl+], a                                   ; $0BC0
    ld [hl+], a                                   ; $0BC1
    ld [hl+], a                                   ; $0BC2
    ld a, l                                       ; $0BC3
    or a                                          ; $0BC4
    jr nz, jr_000_0bba                            ; $0BC5

    ld a, h                                       ; $0BC7
    cp $c0                                        ; $0BC8
    jr nz, jr_000_0bba                            ; $0BCA

    ld a, d                                       ; $0BCC
    cp $0f                                        ; $0BCD
    jr z, jr_000_0bd4                             ; $0BCF

    inc d                                         ; $0BD1
    jr jr_000_0bb3                                ; $0BD2

jr_000_0bd4:
    ret                                           ; $0BD4


; C: developers' name: same code as AGE_DEC in the old build of table 2A at old 0BDB and 35 at old 0ED5 (123 bytes,
; masked match)
AGE_DEC::
    ld d, $00                                     ; $0BD5
    ld bc, $55aa                                  ; $0BD7
    ld a, $01                                     ; $0BDA
    ld [$6000], a                                 ; $0BDC

jr_000_0bdf:
    ld hl, $a000                                  ; $0BDF
    ld a, d                                       ; $0BE2
    ld [rRAMB], a                                 ; $0BE3

jr_000_0be6:
    ld a, b                                       ; $0BE6
    ld [hl+], a                                   ; $0BE7
    ld a, c                                       ; $0BE8
    ld [hl+], a                                   ; $0BE9
    dec c                                         ; $0BEA
    ld a, c                                       ; $0BEB
    cp $ff                                        ; $0BEC
    jr nz, jr_000_0bf1                            ; $0BEE

    dec b                                         ; $0BF0

jr_000_0bf1:
    ld a, l                                       ; $0BF1
    or a                                          ; $0BF2
    jr nz, jr_000_0be6                            ; $0BF3

    ld a, h                                       ; $0BF5
    cp $c0                                        ; $0BF6
    jr nz, jr_000_0be6                            ; $0BF8

    ld a, d                                       ; $0BFA
    cp $0f                                        ; $0BFB
    jr z, jr_000_0c02                             ; $0BFD

    inc d                                         ; $0BFF
    jr jr_000_0bdf                                ; $0C00

jr_000_0c02:
    ld d, $00                                     ; $0C02
    ld bc, $55aa                                  ; $0C04

jr_000_0c07:
    ld hl, $a000                                  ; $0C07
    ld a, d                                       ; $0C0A
    ld [rRAMB], a                                 ; $0C0B

jr_000_0c0e:
    ld a, [hl+]                                   ; $0C0E
    cp b                                          ; $0C0F
    jr nz, jr_000_0c30                            ; $0C10

    ld a, [hl+]                                   ; $0C12
    cp c                                          ; $0C13
    jr nz, jr_000_0c39                            ; $0C14

    dec c                                         ; $0C16
    ld a, c                                       ; $0C17
    cp $ff                                        ; $0C18
    jr nz, jr_000_0c1d                            ; $0C1A

    dec b                                         ; $0C1C

jr_000_0c1d:
    ld a, l                                       ; $0C1D
    or a                                          ; $0C1E
    jr nz, jr_000_0c0e                            ; $0C1F

    ld a, h                                       ; $0C21
    cp $c0                                        ; $0C22
    jr nz, jr_000_0c0e                            ; $0C24

    ld a, d                                       ; $0C26
    cp $0f                                        ; $0C27
    jr z, jr_000_0c2e                             ; $0C29

    inc d                                         ; $0C2B
    jr jr_000_0c07                                ; $0C2C

jr_000_0c2e:
    ei                                            ; $0C2E
    ret                                           ; $0C2F


jr_000_0c30:
    ld [wE_DATA], a                               ; $0C30
    ld a, b                                       ; $0C33
    ld [wR_DATA], a                               ; $0C34
    jr jr_000_0c40                                ; $0C37

jr_000_0c39:
    ld [wE_DATA], a                               ; $0C39
    ld a, c                                       ; $0C3C
    ld [wR_DATA], a                               ; $0C3D

jr_000_0c40:
    ld a, d                                       ; $0C40
    ld [wE_BANK], a                               ; $0C41
    dec hl                                        ; $0C44
    ld a, h                                       ; $0C45
    ld [wE_ADDR_H], a                             ; $0C46
    ld a, l                                       ; $0C49
    ld [wE_ADDR_L], a                             ; $0C4A
    jp AGING_ERROR                                ; $0C4D


; C: for SRAM bank D: writes the pattern B,B,C,C over $A000-$BFFF (ld [$4000],d; ld [hl+],a ...); called by SRAM_AGING
; four times
Aging_FillSram::
    ld d, $00                                     ; $0C50
    ld a, $01                                     ; $0C52
    ld [$6000], a                                 ; $0C54

jr_000_0c57:
    ld hl, $a000                                  ; $0C57
    ld a, d                                       ; $0C5A
    ld [rRAMB], a                                 ; $0C5B

jr_000_0c5e:
    ld a, b                                       ; $0C5E
    ld [hl+], a                                   ; $0C5F
    ld [hl+], a                                   ; $0C60
    ld a, c                                       ; $0C61
    ld [hl+], a                                   ; $0C62
    ld [hl+], a                                   ; $0C63
    ld a, l                                       ; $0C64
    or a                                          ; $0C65
    jr nz, jr_000_0c5e                            ; $0C66

    ld a, h                                       ; $0C68
    cp $c0                                        ; $0C69
    jr nz, jr_000_0c5e                            ; $0C6B

    ld a, d                                       ; $0C6D
    cp $0f                                        ; $0C6E
    jr z, jr_000_0c75                             ; $0C70

    inc d                                         ; $0C72
    jr jr_000_0c57                                ; $0C73

jr_000_0c75:
    ld d, $00                                     ; $0C75

jr_000_0c77:
    ld hl, $a000                                  ; $0C77
    ld a, d                                       ; $0C7A
    ld [rRAMB], a                                 ; $0C7B

jr_000_0c7e:
    ld a, [hl+]                                   ; $0C7E
    cp b                                          ; $0C7F
    jr nz, jr_000_0ca0                            ; $0C80

    ld a, [hl+]                                   ; $0C82
    cp b                                          ; $0C83
    jr nz, jr_000_0ca0                            ; $0C84

    ld a, [hl+]                                   ; $0C86
    cp c                                          ; $0C87
    jr nz, jr_000_0ca9                            ; $0C88

    ld a, [hl+]                                   ; $0C8A
    cp c                                          ; $0C8B
    jr nz, jr_000_0ca9                            ; $0C8C

    ld a, l                                       ; $0C8E
    or a                                          ; $0C8F
    jr nz, jr_000_0c7e                            ; $0C90

    ld a, h                                       ; $0C92
    cp $c0                                        ; $0C93
    jr nz, jr_000_0c7e                            ; $0C95

    ld a, d                                       ; $0C97
    cp $0f                                        ; $0C98
    jr z, jr_000_0c9f                             ; $0C9A

    inc d                                         ; $0C9C
    jr jr_000_0c77                                ; $0C9D

jr_000_0c9f:
    ret                                           ; $0C9F


jr_000_0ca0:
    ld [wE_DATA], a                               ; $0CA0
    ld a, b                                       ; $0CA3
    ld [wR_DATA], a                               ; $0CA4
    jr jr_000_0cb0                                ; $0CA7

jr_000_0ca9:
    ld [wE_DATA], a                               ; $0CA9
    ld a, c                                       ; $0CAC
    ld [wR_DATA], a                               ; $0CAD

jr_000_0cb0:
    ld a, d                                       ; $0CB0
    ld [wE_BANK], a                               ; $0CB1
    dec hl                                        ; $0CB4
    ld a, h                                       ; $0CB5
    ld [wE_ADDR_H], a                             ; $0CB6
    ld a, l                                       ; $0CB9
    ld [wE_ADDR_L], a                             ; $0CBA
    jp AGING_ERROR                                ; $0CBD


; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_0CC0::
    db $c9

; C: developers' name: same code as AGING_ERROR in the old build of table 2A at old 0CC7 and 35 at old 0FC1 (55 bytes,
; masked match)
AGING_ERROR::
    call LCDCOFF                                  ; $0CC1
    ld hl, $99c3                                  ; $0CC4
    ld a, [wE_BANK]                               ; $0CC7
    ld b, a                                       ; $0CCA
    call PUT_BYTE                                 ; $0CCB
    inc hl                                        ; $0CCE
    ld a, [wE_ADDR_H]                             ; $0CCF
    ld b, a                                       ; $0CD2
    call PUT_BYTE                                 ; $0CD3
    ld a, [wE_ADDR_L]                             ; $0CD6
    ld b, a                                       ; $0CD9
    call PUT_BYTE                                 ; $0CDA
    inc hl                                        ; $0CDD
    inc hl                                        ; $0CDE
    ld a, [wR_DATA]                               ; $0CDF
    ld b, a                                       ; $0CE2
    call PUT_BYTE                                 ; $0CE3
    inc hl                                        ; $0CE6
    ld a, [wE_DATA]                               ; $0CE7
    ld b, a                                       ; $0CEA
    call PUT_BYTE                                 ; $0CEB
    ld a, $c7                                     ; $0CEE
    ldh [rLCDC], a                                ; $0CF0
    ld a, $ff                                     ; $0CF2
    ld [wAGE_ERROR], a                            ; $0CF4
    ret                                           ; $0CF7


; C: developers' name: same code as PUT_BYTE in the old build of table 2A at old 0CFE and 35 at old 0FF8 (19 bytes,
; exact match)
PUT_BYTE::
    ld a, b                                       ; $0CF8
    srl a                                         ; $0CF9
    srl a                                         ; $0CFB
    srl a                                         ; $0CFD
    srl a                                         ; $0CFF
    add $80                                       ; $0D01
    ld [hl+], a                                   ; $0D03
    ld a, b                                       ; $0D04
    and $0f                                       ; $0D05
    add $80                                       ; $0D07
    ld [hl+], a                                   ; $0D09
    ret                                           ; $0D0A


; C: developers' name: same code as VB_SRAM_AGING in the old build of table 2A at old 0D11 and 35 at old 100B (48
; bytes, exact match)
VB_SRAM_AGING::
    ld hl, $98e8                                  ; $0D0B
    ld a, [wAGE_CNT_H]                            ; $0D0E
    srl a                                         ; $0D11
    srl a                                         ; $0D13
    srl a                                         ; $0D15
    srl a                                         ; $0D17
    add $80                                       ; $0D19
    ld [hl+], a                                   ; $0D1B
    ld a, [wAGE_CNT_H]                            ; $0D1C
    and $0f                                       ; $0D1F
    add $80                                       ; $0D21
    ld [hl+], a                                   ; $0D23
    ld a, [wAGE_CNT_L]                            ; $0D24
    srl a                                         ; $0D27
    srl a                                         ; $0D29
    srl a                                         ; $0D2B
    srl a                                         ; $0D2D
    add $80                                       ; $0D2F
    ld [hl+], a                                   ; $0D31
    ld a, [wAGE_CNT_L]                            ; $0D32
    and $0f                                       ; $0D35
    add $80                                       ; $0D37
    ld [hl+], a                                   ; $0D39
    ret                                           ; $0D3A


; C: developers' name: same code as MK_SRAM_DUMP in the old build of table 2A at old 0D41 and 35 at old 103B (71
; bytes, masked match)
MK_SRAM_DUMP::
    call LCDCOFF                                  ; $0D3B
    call VRAM_CLR                                 ; $0D3E
    call DMACLR                                   ; $0D41
    ldh a, [hBANK_BUF]                            ; $0D44
    push af                                       ; $0D46
    ld a, $02                                     ; $0D47
    ldh [hBANK_BUF], a                            ; $0D49
    ld [$2100], a                                 ; $0D4B
    ld hl, Gfx_02_4001_FNTOOE2                    ; $0D4E
    ld de, $8000                                  ; $0D51
    ld bc, $1800                                  ; $0D54
    call DATA_MOV                                 ; $0D57
    ld hl, Map_02_6101_BG_DUMP                    ; $0D5A
    ld de, $9800                                  ; $0D5D
    ld bc, $0240                                  ; $0D60
    call DATA_MOV                                 ; $0D63
    call SCYX_SET0                                ; $0D66
    call OBJP_DEF_SET                             ; $0D69
    call Bgp_SetDefault                           ; $0D6C
    ld a, $c7                                     ; $0D6F
    ldh [rLCDC], a                                ; $0D71
    ld a, SEQ_SRAM_DUMP                           ; $0D73
    ld [wGAME_SEQ], a                             ; $0D75
    pop af                                        ; $0D78
    ldh [hBANK_BUF], a                            ; $0D79
    ld [$2100], a                                 ; $0D7B
    call DUMP_1MEN                                ; $0D7E
    ret                                           ; $0D81


; C: developers' name: same code as SRAM_DUMP in the old build of table 2A at old 0D88 and 35 at old 1082 (167 bytes,
; masked match)
SRAM_DUMP::
    ldh a, [hTRG1]                                ; $0D82
    sla a                                         ; $0D84
    jr c, jr_000_0dac                             ; $0D86

    sla a                                         ; $0D88
    jr c, jr_000_0dd7                             ; $0D8A

    sla a                                         ; $0D8C
    jr c, jr_000_0e02                             ; $0D8E

    sla a                                         ; $0D90
    jp c, Jump_000_0e15                           ; $0D92

    sla a                                         ; $0D95
    sla a                                         ; $0D97
    sla a                                         ; $0D99
    jr c, jr_000_0da2                             ; $0D9B

    sla a                                         ; $0D9D
    jp Jump_000_0e28                              ; $0D9F


jr_000_0da2:
    ld a, $03                                     ; $0DA2
    ld [wINF_CUR], a                              ; $0DA4
    call MK_SRAM_MENU                             ; $0DA7
    jr jr_000_0e28                                ; $0DAA

jr_000_0dac:
    ld a, [wDUMP_ADR_H]                           ; $0DAC
    ld h, a                                       ; $0DAF
    ld a, [wDUMP_ADR_L]                           ; $0DB0
    ld l, a                                       ; $0DB3
    ld a, h                                       ; $0DB4
    cp $bf                                        ; $0DB5
    jr nz, jr_000_0dc6                            ; $0DB7

    ld a, l                                       ; $0DB9
    cp $80                                        ; $0DBA
    jr nz, jr_000_0dc6                            ; $0DBC

    ld a, $a0                                     ; $0DBE
    ld h, a                                       ; $0DC0
    ld a, $00                                     ; $0DC1
    ld l, a                                       ; $0DC3
    jr jr_000_0dca                                ; $0DC4

jr_000_0dc6:
    ld bc, $0080                                  ; $0DC6
    add hl, bc                                    ; $0DC9

jr_000_0dca:
    ld a, h                                       ; $0DCA
    ld [wDUMP_ADR_H], a                           ; $0DCB
    ld a, l                                       ; $0DCE
    ld [wDUMP_ADR_L], a                           ; $0DCF
    call DUMP_1MEN                                ; $0DD2
    jr jr_000_0e28                                ; $0DD5

jr_000_0dd7:
    ld a, [wDUMP_ADR_H]                           ; $0DD7
    ld h, a                                       ; $0DDA
    ld a, [wDUMP_ADR_L]                           ; $0DDB
    ld l, a                                       ; $0DDE
    ld a, h                                       ; $0DDF
    cp $a0                                        ; $0DE0
    jr nz, jr_000_0df1                            ; $0DE2

    ld a, l                                       ; $0DE4
    cp $00                                        ; $0DE5
    jr nz, jr_000_0df1                            ; $0DE7

    ld a, $bf                                     ; $0DE9
    ld h, a                                       ; $0DEB
    ld a, $80                                     ; $0DEC
    ld l, a                                       ; $0DEE
    jr jr_000_0df5                                ; $0DEF

jr_000_0df1:
    ld bc, hCNT1                                  ; $0DF1
    add hl, bc                                    ; $0DF4

jr_000_0df5:
    ld a, h                                       ; $0DF5
    ld [wDUMP_ADR_H], a                           ; $0DF6
    ld a, l                                       ; $0DF9
    ld [wDUMP_ADR_L], a                           ; $0DFA
    call DUMP_1MEN                                ; $0DFD
    jr jr_000_0e28                                ; $0E00

jr_000_0e02:
    ld a, [wDUMP_BANK]                            ; $0E02
    or a                                          ; $0E05
    jr nz, jr_000_0e0c                            ; $0E06

    ld a, $0f                                     ; $0E08
    jr jr_000_0e0d                                ; $0E0A

jr_000_0e0c:
    dec a                                         ; $0E0C

jr_000_0e0d:
    ld [wDUMP_BANK], a                            ; $0E0D
    call DUMP_1MEN                                ; $0E10
    jr jr_000_0e28                                ; $0E13

Jump_000_0e15:
    ld a, [wDUMP_BANK]                            ; $0E15
    cp $0f                                        ; $0E18
    jr nz, jr_000_0e1f                            ; $0E1A

    xor a                                         ; $0E1C
    jr jr_000_0e20                                ; $0E1D

jr_000_0e1f:
    inc a                                         ; $0E1F

jr_000_0e20:
    ld [wDUMP_BANK], a                            ; $0E20
    call DUMP_1MEN                                ; $0E23
    jr jr_000_0e28                                ; $0E26

Jump_000_0e28:
jr_000_0e28:
    ret                                           ; $0E28


; C: developers' name: same code as PUT_BYTE2 in the old build of table 2A at old 0E2F and 35 at old 1129 (19 bytes,
; exact match)
PUT_BYTE2::
    ld a, b                                       ; $0E29
    srl a                                         ; $0E2A
    srl a                                         ; $0E2C
    srl a                                         ; $0E2E
    srl a                                         ; $0E30
    add $50                                       ; $0E32
    ld [hl+], a                                   ; $0E34
    ld a, b                                       ; $0E35
    and $0f                                       ; $0E36
    add $50                                       ; $0E38
    ld [hl+], a                                   ; $0E3A
    ret                                           ; $0E3B


; C: developers' name: same code as PUT_BYTE3 in the old build of table 2A at old 0E42 and 35 at old 113C (19 bytes,
; exact match)
PUT_BYTE3::
    ld a, b                                       ; $0E3C
    srl a                                         ; $0E3D
    srl a                                         ; $0E3F
    srl a                                         ; $0E41
    srl a                                         ; $0E43
    add $60                                       ; $0E45
    ld [hl+], a                                   ; $0E47
    ld a, b                                       ; $0E48
    and $0f                                       ; $0E49
    add $70                                       ; $0E4B
    ld [hl+], a                                   ; $0E4D
    ret                                           ; $0E4E


; C: developers' name: same code as DUMP_1MEN in the old build of table 2A at old 0E55 and 35 at old 114F (80 bytes,
; masked match)
DUMP_1MEN::
    call LCDCOFF                                  ; $0E4F
    ld a, [wDUMP_BANK]                            ; $0E52
    ld b, a                                       ; $0E55
    ld hl, $9811                                  ; $0E56
    call PUT_BYTE                                 ; $0E59
    ld a, [wDUMP_ADR_H]                           ; $0E5C
    ld d, a                                       ; $0E5F
    ld a, [wDUMP_ADR_L]                           ; $0E60
    ld e, a                                       ; $0E63
    ld hl, $9840                                  ; $0E64
    ld a, [wDUMP_BANK]                            ; $0E67
    ld [rRAMB], a                                 ; $0E6A
    ld a, $10                                     ; $0E6D
    ldh [hR1], a                                  ; $0E6F

jr_000_0e71:
    ld b, d                                       ; $0E71
    call PUT_BYTE2                                ; $0E72
    ld b, e                                       ; $0E75
    call PUT_BYTE2                                ; $0E76
    ld c, $08                                     ; $0E79

jr_000_0e7b:
    ld a, [de]                                    ; $0E7B
    ld b, a                                       ; $0E7C
    call PUT_BYTE3                                ; $0E7D
    inc de                                        ; $0E80
    dec c                                         ; $0E81
    ld a, c                                       ; $0E82
    or a                                          ; $0E83
    jr nz, jr_000_0e7b                            ; $0E84

    inc hl                                        ; $0E86
    inc hl                                        ; $0E87
    inc hl                                        ; $0E88
    inc hl                                        ; $0E89
    inc hl                                        ; $0E8A
    inc hl                                        ; $0E8B
    inc hl                                        ; $0E8C
    inc hl                                        ; $0E8D
    inc hl                                        ; $0E8E
    inc hl                                        ; $0E8F
    inc hl                                        ; $0E90
    inc hl                                        ; $0E91
    ldh a, [hR1]                                  ; $0E92
    dec a                                         ; $0E94
    ldh [hR1], a                                  ; $0E95
    or a                                          ; $0E97
    jr nz, jr_000_0e71                            ; $0E98

    ld a, $c7                                     ; $0E9A
    ldh [rLCDC], a                                ; $0E9C
    ret                                           ; $0E9E


; C: developers' name: same code as MAKE_MOVIE in the old build of table 2A at old 0EA5 (107 bytes, masked match)
MAKE_MOVIE::
    call LCDCOFF                                  ; $0E9F
    call VRAM_CLR                                 ; $0EA2
    call DMACLR                                   ; $0EA5
    xor a                                         ; $0EA8
    ld [wPANASI], a                               ; $0EA9
    ldh a, [hBANK_BUF]                            ; $0EAC
    push af                                       ; $0EAE
    ld a, $03                                     ; $0EAF
    ldh [hBANK_BUF], a                            ; $0EB1
    ld [$2100], a                                 ; $0EB3
    ld hl, Gfx_03_4001_FNTOOE3                    ; $0EB6
    ld de, $8000                                  ; $0EB9
    ld bc, $1800                                  ; $0EBC
    call DATA_MOV                                 ; $0EBF
    ld hl, Map_03_5801_BG_MOVIE                   ; $0EC2
    ld de, $9800                                  ; $0EC5
    ld bc, $0240                                  ; $0EC8
    call DATA_MOV                                 ; $0ECB
    ld a, [wAKARUSA]                              ; $0ECE
    call AKARUSA_HYOUJI                           ; $0ED1
    ld a, [wCONTRAST]                             ; $0ED4
    call CONTRAST_HYOUJI                          ; $0ED7
    ld a, [wBUNKATU_MODE]                         ; $0EDA
    call BUNKATU_HYOUJI                           ; $0EDD
    ld a, [wTEST]                                 ; $0EE0
    call Obj_PutHexDigits                         ; $0EE3
    pop af                                        ; $0EE6
    ldh [hBANK_BUF], a                            ; $0EE7
    ld [$2100], a                                 ; $0EE9
    call SCYX_SET0                                ; $0EEC
    call OBJP_DEF_SET                             ; $0EEF
    call Bgp_SetDefault                           ; $0EF2
    ld hl, wVRAM_ADD_L                            ; $0EF5
    xor a                                         ; $0EF8
    ld [hl+], a                                   ; $0EF9
    ld a, $88                                     ; $0EFA
    ld [hl], a                                    ; $0EFC
    ld hl, wIMMAGE_ADD_L                          ; $0EFD
    xor a                                         ; $0F00
    ld [hl+], a                                   ; $0F01
    ld a, $d0                                     ; $0F02
    ld [hl+], a                                   ; $0F04
    ld a, $10                                     ; $0F05
    ld [rRAMB], a                                 ; $0F07

; C: developers' name: same code as PARA_SET in the old build of table 2A at old 0F10 (102 bytes, masked match)
PARA_SET::
    ld a, [wB_MODE]                               ; $0F0A
    call ParaSet_ByMode                           ; $0F0D
    call Sensor_FillDitherFlat                    ; $0F10
    ld a, $10                                     ; $0F13
    ld [rRAMB], a                                 ; $0F15
    ld a, [wDITHER]                               ; $0F18
    ld b, a                                       ; $0F1B
    ld a, [wCONTRAST]                             ; $0F1C
    ld c, a                                       ; $0F1F
    call SET_DITH_MATRIX                          ; $0F20
    ld a, $10                                     ; $0F23
    ld [rRAMB], a                                 ; $0F25
    ld a, [wB_CNTR0]                              ; $0F28
    or $01                                        ; $0F2B
    ld [$a000], a                                 ; $0F2D

jr_000_0f30:
    ld a, [$a000]                                 ; $0F30
    and $01                                       ; $0F33
    jr nz, jr_000_0f30                            ; $0F35

    ld a, [wB_CNTR0]                              ; $0F37
    or $01                                        ; $0F3A
    ld [$a000], a                                 ; $0F3C

jr_000_0f3f:
    ld a, [$a000]                                 ; $0F3F
    and $01                                       ; $0F42
    jr nz, jr_000_0f3f                            ; $0F44

    ld a, [wB_CNTR0]                              ; $0F46
    or $01                                        ; $0F49
    ld [$a000], a                                 ; $0F4B
    call GET_A_IMMAGE                             ; $0F4E
    ld a, $e4                                     ; $0F51
    ldh [rBGP], a                                 ; $0F53
    ld a, $01                                     ; $0F55
    ld [wDRAWING_F], a                            ; $0F57
    ld a, $01                                     ; $0F5A
    ldh [rIE], a                                  ; $0F5C
    ld a, SEQ_MOVIE                               ; $0F5E
    ld [wGAME_SEQ], a                             ; $0F60
    xor a                                         ; $0F63
    ld [wHBLANK_F], a                             ; $0F64
    ld a, $08                                     ; $0F67
    ldh [rSTAT], a                                ; $0F69
    ld a, $c3                                     ; $0F6B
    ldh [rLCDC], a                                ; $0F6D
    ret                                           ; $0F6F


; C: GAME_SEQ $06 handler of MAIN_SUB; MOVIE TEST in BGB (menu entry 4 -> GAME_SEQ $06, port/menu_paths_proto.csv)
Seq06_MovieMain::
    ld a, [wTEST]                                 ; $0F70
    call Obj_PutHexDigits                         ; $0F73
    ldh a, [hTRG1]                                ; $0F76
    bit 1, a                                      ; $0F78
    jr nz, jr_000_0f87                            ; $0F7A

    bit 2, a                                      ; $0F7C
    jr nz, jr_000_0f9f                            ; $0F7E

    bit 3, a                                      ; $0F80
    jr nz, jr_000_0faf                            ; $0F82

    jp Jump_000_0fb3                              ; $0F84


jr_000_0f87:
    ld a, [wBUNKATU_MODE]                         ; $0F87
    bit 0, a                                      ; $0F8A
    jr z, jr_000_0f96                             ; $0F8C

    xor $01                                       ; $0F8E
    ld [wBUNKATU_MODE], a                         ; $0F90
    jp Jump_000_0fb3                              ; $0F93


jr_000_0f96:
    ld a, $03                                     ; $0F96
    ld [wINF_CUR], a                              ; $0F98
    call MAKE_MENU                                ; $0F9B
    ret                                           ; $0F9E


jr_000_0f9f:
    ld a, [wBUNKATU_MODE]                         ; $0F9F
    inc a                                         ; $0FA2
    cp $20                                        ; $0FA3
    jr nz, jr_000_0fa8                            ; $0FA5

    xor a                                         ; $0FA7

jr_000_0fa8:
    ld [wBUNKATU_MODE], a                         ; $0FA8
    call BUNKATU_HYOUJI                           ; $0FAB
    ret                                           ; $0FAE


jr_000_0faf:
    call MAKE_CONFIG                              ; $0FAF
    ret                                           ; $0FB2


Jump_000_0fb3:
    ld a, [wVRAM_ADD_H]                           ; $0FB3
    sub $96                                       ; $0FB6
    jr nc, jr_000_0fc3                            ; $0FB8

Jump_000_0fba:
    ld a, $01                                     ; $0FBA
    ld [wDRAWING_F], a                            ; $0FBC
    call H_BLANK_TX                               ; $0FBF
    ret                                           ; $0FC2


jr_000_0fc3:
    ldh a, [hCNT1]                                ; $0FC3
    bit 0, a                                      ; $0FC5
    jr nz, jr_000_0fe2                            ; $0FC7

    bit 7, a                                      ; $0FC9
    jp nz, Jump_000_1066                          ; $0FCB

    bit 6, a                                      ; $0FCE
    jp nz, Jump_000_1055                          ; $0FD0

    bit 5, a                                      ; $0FD3
    jr nz, jr_000_103a                            ; $0FD5

    bit 4, a                                      ; $0FD7
    jr nz, Seq06_MovieMain_Part101F               ; $0FD9

    xor a                                         ; $0FDB
    ld [wIKKAI_FLAG], a                           ; $0FDC
    jp Jump_000_1077                              ; $0FDF


jr_000_0fe2:
    ld a, [wIKKAI_FLAG]                           ; $0FE2
    or a                                          ; $0FE5
    ret nz                                        ; $0FE6

    ld a, $01                                     ; $0FE7
    ld [wIKKAI_FLAG], a                           ; $0FE9
    ld a, [wBUNKATU_MODE]                         ; $0FEC
    jp MK_PIC_SAVE                                ; $0FEF


; I: leftover: 45 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_0FF2::
    db $fa, $67, $c1, $e6, $f0, $fe, $10, $20, $0e, $fa, $67, $c1, $fe, $11, $28, $15
    db $3e, $11, $ea, $67, $c1, $18, $6e, $fa, $67, $c1, $fe, $21, $28, $07, $3e, $21
    db $ea, $67, $c1, $18, $60, $ee, $01, $ea, $67, $c1, $c3, $b2, $1b

; C: continuation of Seq06_MovieMain after a data label or a never-traced byte
Seq06_MovieMain_Part101F::
    ld a, [wCONTRAST]                             ; $101F
    cp $83                                        ; $1022
    jr z, jr_000_1077                             ; $1024

    inc a                                         ; $1026
    ld [wCONTRAST], a                             ; $1027
    call CONTRAST_HYOUJI                          ; $102A
    ld a, [wDITHER]                               ; $102D
    ld b, a                                       ; $1030
    ld a, [wCONTRAST]                             ; $1031
    ld c, a                                       ; $1034
    call SET_DITH_MATRIX                          ; $1035
    jr jr_000_1077                                ; $1038

jr_000_103a:
    ld a, [wCONTRAST]                             ; $103A
    cp $01                                        ; $103D
    jr z, jr_000_1077                             ; $103F

    dec a                                         ; $1041
    ld [wCONTRAST], a                             ; $1042
    call CONTRAST_HYOUJI                          ; $1045
    ld a, [wDITHER]                               ; $1048
    ld b, a                                       ; $104B
    ld a, [wCONTRAST]                             ; $104C
    ld c, a                                       ; $104F
    call SET_DITH_MATRIX                          ; $1050
    jr jr_000_1077                                ; $1053

Jump_000_1055:
    ld a, [wAKARUSA]                              ; $1055
    cp $a8                                        ; $1058
    jr z, jr_000_1077                             ; $105A

    add $02                                       ; $105C
    ld [wAKARUSA], a                              ; $105E
    call AKARUSA_HYOUJI                           ; $1061
    jr jr_000_1077                                ; $1064

Jump_000_1066:
    ld a, [wAKARUSA]                              ; $1066
    cp $00                                        ; $1069
    jr z, jr_000_1077                             ; $106B

    sub $02                                       ; $106D
    ld [wAKARUSA], a                              ; $106F
    call AKARUSA_HYOUJI                           ; $1072
    jr jr_000_1077                                ; $1075

Jump_000_1077:
jr_000_1077:
    xor a                                         ; $1077
    ld [wDRAWING_F], a                            ; $1078
    ld hl, wVRAM_ADD_L                            ; $107B
    xor a                                         ; $107E
    ld [hl+], a                                   ; $107F
    ld a, $88                                     ; $1080
    ld [hl], a                                    ; $1082
    ld hl, wIMMAGE_ADD_L                          ; $1083
    xor a                                         ; $1086
    ld [hl+], a                                   ; $1087
    ld a, $d0                                     ; $1088
    ld [hl+], a                                   ; $108A
    call GET_A_IMMAGE                             ; $108B
    call WAIT_DONE_VBLNK                          ; $108E
    jp Jump_000_0fba                              ; $1091


; C: developers' name: same code as GET_A_IMMAGE in the old build of table 2A at old 109A (49 bytes, masked match)
GET_A_IMMAGE::
    di                                            ; $1094
    ld a, $10                                     ; $1095
    ld [rRAMB], a                                 ; $1097

jr_000_109a:
    ld a, [$a000]                                 ; $109A
    and $01                                       ; $109D
    jr nz, jr_000_109a                            ; $109F

    ld a, [wAKARUSA]                              ; $10A1
    call Akarusa_Apply                            ; $10A4
    ld a, [wBUNKATU_MODE]                         ; $10A7
    call ImageCopy_Dispatch                       ; $10AA
    ld a, $10                                     ; $10AD
    ld [rRAMB], a                                 ; $10AF
    ld a, [wB_CNTR0]                              ; $10B2
    or $01                                        ; $10B5
    ld [$a000], a                                 ; $10B7
    ld a, [wPALETTE]                              ; $10BA
    call CHANGE_PALETTE                           ; $10BD
    ei                                            ; $10C0
    call WAIT_DONE_VBLNK                          ; $10C1
    ret                                           ; $10C4


; C: developers' name: same code as CHANGE_PALETTE in the old build of table 2A at old 10CB (97 bytes, exact match)
CHANGE_PALETTE::
    ld hl, wB_ADR                                 ; $10C5
    cp $00                                        ; $10C8
    ret z                                         ; $10CA

    cp $01                                        ; $10CB
    jr z, jr_000_10e0                             ; $10CD

    cp $02                                        ; $10CF
    jr z, jr_000_10ec                             ; $10D1

    cp $03                                        ; $10D3
    jr z, jr_000_10fa                             ; $10D5

    cp $04                                        ; $10D7
    jr z, jr_000_1109                             ; $10D9

    cp $05                                        ; $10DB
    jr z, jr_000_1119                             ; $10DD

    ret                                           ; $10DF


jr_000_10e0:
    ld de, $0e00                                  ; $10E0

jr_000_10e3:
    ld a, [hl]                                    ; $10E3
    cpl                                           ; $10E4
    ld [hl+], a                                   ; $10E5
    dec de                                        ; $10E6
    ld a, d                                       ; $10E7
    or e                                          ; $10E8
    jr nz, jr_000_10e3                            ; $10E9

    ret                                           ; $10EB


jr_000_10ec:
    ld de, $0700                                  ; $10EC

jr_000_10ef:
    ld a, [hl+]                                   ; $10EF
    ld b, [hl]                                    ; $10F0
    xor b                                         ; $10F1
    cpl                                           ; $10F2
    ld [hl+], a                                   ; $10F3
    dec de                                        ; $10F4
    ld a, d                                       ; $10F5
    or e                                          ; $10F6
    jr nz, jr_000_10ef                            ; $10F7

    ret                                           ; $10F9


jr_000_10fa:
    ld de, $0700                                  ; $10FA

jr_000_10fd:
    ld a, [hl+]                                   ; $10FD
    ld b, [hl]                                    ; $10FE
    dec hl                                        ; $10FF
    ld [hl], b                                    ; $1100
    inc hl                                        ; $1101
    ld [hl+], a                                   ; $1102
    dec de                                        ; $1103
    ld a, d                                       ; $1104
    or e                                          ; $1105
    jr nz, jr_000_10fd                            ; $1106

    ret                                           ; $1108


jr_000_1109:
    ld de, $0700                                  ; $1109

jr_000_110c:
    ld a, [hl]                                    ; $110C
    ld c, a                                       ; $110D
    cpl                                           ; $110E
    ld [hl+], a                                   ; $110F
    ld a, [hl]                                    ; $1110
    xor c                                         ; $1111
    ld [hl+], a                                   ; $1112
    dec de                                        ; $1113
    ld a, d                                       ; $1114
    or e                                          ; $1115
    jr nz, jr_000_110c                            ; $1116

    ret                                           ; $1118


jr_000_1119:
    ld de, $0700                                  ; $1119

jr_000_111c:
    ld a, [hl+]                                   ; $111C
    ld b, [hl]                                    ; $111D
    xor b                                         ; $111E
    ld [hl+], a                                   ; $111F
    dec de                                        ; $1120
    ld a, d                                       ; $1121
    or e                                          ; $1122
    jr nz, jr_000_111c                            ; $1123

    ret                                           ; $1125


; C: developers' name: the same bytes as the data label PUT_BYTE_OBJ in the old build of table 2A at old 112C and 35
; at old 1671 (35 bytes, data match)
PUT_BYTE_OBJ::
    db $47, $21, $14, $c0, $3e, $10, $22, $3e, $30, $22, $78, $cb, $3f, $cb, $3f, $cb
    db $3f, $cb, $3f, $22, $af, $22, $3e, $10, $22, $3e, $38, $22, $78, $e6, $0f, $22
    db $af, $22, $c9

; C: developers' name: same code as AKARUSA_HYOUJI in the old build of table 2A at old 114F (31 bytes, exact match)
AKARUSA_HYOUJI::
    ld b, a                                       ; $1149
    ld hl, wAKARUSA_HYOUJI_C01C                   ; $114A
    ld a, $10                                     ; $114D
    ld [hl+], a                                   ; $114F
    ld a, $0c                                     ; $1150
    ld [hl+], a                                   ; $1152
    ld a, b                                       ; $1153
    swap a                                        ; $1154
    and $0f                                       ; $1156
    ld [hl+], a                                   ; $1158
    xor a                                         ; $1159
    ld [hl+], a                                   ; $115A
    ld a, $10                                     ; $115B
    ld [hl+], a                                   ; $115D
    ld a, $14                                     ; $115E
    ld [hl+], a                                   ; $1160
    ld a, b                                       ; $1161
    and $0f                                       ; $1162
    ld [hl+], a                                   ; $1164
    xor a                                         ; $1165
    ld [hl+], a                                   ; $1166
    ret                                           ; $1167


; C: developers' name: same code as CONTRAST_HYOUJI in the old build of table 2A at old 116E (34 bytes, exact match)
CONTRAST_HYOUJI::
    ld b, a                                       ; $1168
    ld hl, wCONTRAST_HYOUJI_C024                  ; $1169
    ld a, $95                                     ; $116C
    ld [hl+], a                                   ; $116E
    ld a, $58                                     ; $116F
    ld [hl+], a                                   ; $1171
    ld a, b                                       ; $1172
    swap a                                        ; $1173
    and $0f                                       ; $1175
    ld [hl+], a                                   ; $1177
    xor a                                         ; $1178
    ld [hl+], a                                   ; $1179
    ld hl, wCONTRAST_HYOUJI_C044                  ; $117A
    ld a, $95                                     ; $117D
    ld [hl+], a                                   ; $117F
    ld a, $60                                     ; $1180
    ld [hl+], a                                   ; $1182
    ld a, b                                       ; $1183
    and $0f                                       ; $1184
    ld [hl+], a                                   ; $1186
    xor a                                         ; $1187
    ld [hl+], a                                   ; $1188
    ret                                           ; $1189


; C: developers' name: same code as BUNKATU_HYOUJI in the old build of table 2A at old 1190 (34 bytes, exact match)
BUNKATU_HYOUJI::
    ld b, a                                       ; $118A
    ld hl, wBUNKATU_HYOUJI_C028                   ; $118B
    ld a, $10                                     ; $118E
    ld [hl+], a                                   ; $1190
    ld a, $90                                     ; $1191
    ld [hl+], a                                   ; $1193
    ld a, b                                       ; $1194
    swap a                                        ; $1195
    and $0f                                       ; $1197
    ld [hl+], a                                   ; $1199
    xor a                                         ; $119A
    ld [hl+], a                                   ; $119B
    ld hl, wBUNKATU_HYOUJI_C048                   ; $119C
    ld a, $10                                     ; $119F
    ld [hl+], a                                   ; $11A1
    ld a, $98                                     ; $11A2
    ld [hl+], a                                   ; $11A4
    ld a, b                                       ; $11A5
    and $0f                                       ; $11A6
    ld [hl+], a                                   ; $11A8
    xor a                                         ; $11A9
    ld [hl], a                                    ; $11AA
    ret                                           ; $11AB


; I: writes OAM entries from $C02C: Y $10, X $30, then the high nibble of A, and so on: the two nibbles of A as
; sprites
Obj_PutHexDigits::
    ld b, a                                       ; $11AC
    ld hl, wObj_PutHexDigits_C02C                 ; $11AD
    ld a, $10                                     ; $11B0
    ld [hl+], a                                   ; $11B2
    ld a, $30                                     ; $11B3
    ld [hl+], a                                   ; $11B5
    ld a, b                                       ; $11B6
    swap a                                        ; $11B7
    and $0f                                       ; $11B9
    ld [hl+], a                                   ; $11BB
    xor a                                         ; $11BC
    ld [hl+], a                                   ; $11BD
    ld a, $10                                     ; $11BE
    ld [hl+], a                                   ; $11C0
    ld a, $38                                     ; $11C1
    ld [hl+], a                                   ; $11C3
    ld a, b                                       ; $11C4
    and $0f                                       ; $11C5
    ld [hl+], a                                   ; $11C7
    xor a                                         ; $11C8
    ld [hl+], a                                   ; $11C9
    ld a, [wTEST1]                                ; $11CA
    ld b, a                                       ; $11CD
    ld a, $95                                     ; $11CE
    ld [hl+], a                                   ; $11D0
    ld a, $20                                     ; $11D1
    ld [hl+], a                                   ; $11D3
    ld a, b                                       ; $11D4
    swap a                                        ; $11D5
    and $0f                                       ; $11D7
    ld [hl+], a                                   ; $11D9
    xor a                                         ; $11DA
    ld [hl+], a                                   ; $11DB
    ld a, $95                                     ; $11DC
    ld [hl+], a                                   ; $11DE
    ld a, $28                                     ; $11DF
    ld [hl+], a                                   ; $11E1
    ld a, b                                       ; $11E2
    and $0f                                       ; $11E3
    ld [hl+], a                                   ; $11E5
    xor a                                         ; $11E6
    ld [hl+], a                                   ; $11E7
    ld a, [wTEST2]                                ; $11E8
    ld b, a                                       ; $11EB
    ld a, $95                                     ; $11EC
    ld [hl+], a                                   ; $11EE
    ld a, $30                                     ; $11EF
    ld [hl+], a                                   ; $11F1
    ld a, b                                       ; $11F2
    swap a                                        ; $11F3
    and $0f                                       ; $11F5
    ld [hl+], a                                   ; $11F7
    xor a                                         ; $11F8
    ld [hl+], a                                   ; $11F9
    ld a, $95                                     ; $11FA
    ld [hl+], a                                   ; $11FC
    ld a, $38                                     ; $11FD
    ld [hl+], a                                   ; $11FF
    ld a, b                                       ; $1200
    and $0f                                       ; $1201
    ld [hl+], a                                   ; $1203
    xor a                                         ; $1204
    ld [hl+], a                                   ; $1205
    ret                                           ; $1206


; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_1207::
    db $c9

; C: developers' name: same code as H_BLANK_TX in the old build of table 2A at old 120E and 35 at old 1857 (72 bytes,
; exact match)
H_BLANK_TX::
    ld a, $80                                     ; $1208
    ldh [hR0], a                                  ; $120A

jr_000_120c:
    ld a, [wIMMAGE_ADD_H]                         ; $120C
    ld h, a                                       ; $120F
    ld a, [wIMMAGE_ADD_L]                         ; $1210
    ld l, a                                       ; $1213
    ld a, [hl+]                                   ; $1214
    ld b, a                                       ; $1215
    ld a, [hl+]                                   ; $1216
    ld c, a                                       ; $1217
    ld a, [hl+]                                   ; $1218
    ld d, a                                       ; $1219
    ld a, [hl+]                                   ; $121A
    ld e, a                                       ; $121B
    ld a, h                                       ; $121C
    ld [wIMMAGE_ADD_H], a                         ; $121D
    ld a, l                                       ; $1220
    ld [wIMMAGE_ADD_L], a                         ; $1221
    ld a, [wVRAM_ADD_H]                           ; $1224
    ld h, a                                       ; $1227
    ld a, [wVRAM_ADD_L]                           ; $1228
    ld l, a                                       ; $122B

jr_000_122c:
    ldh a, [rSTAT]                                ; $122C
    and $03                                       ; $122E
    jr z, jr_000_122c                             ; $1230

jr_000_1232:
    ldh a, [rSTAT]                                ; $1232
    and $03                                       ; $1234
    jr nz, jr_000_1232                            ; $1236

    ld a, b                                       ; $1238
    ld [hl+], a                                   ; $1239
    ld a, c                                       ; $123A
    ld [hl+], a                                   ; $123B
    ld a, d                                       ; $123C
    ld [hl+], a                                   ; $123D
    ld a, e                                       ; $123E
    ld [hl+], a                                   ; $123F
    ld a, h                                       ; $1240
    ld [wVRAM_ADD_H], a                           ; $1241
    ld a, l                                       ; $1244
    ld [wVRAM_ADD_L], a                           ; $1245
    ldh a, [hR0]                                  ; $1248
    dec a                                         ; $124A
    ldh [hR0], a                                  ; $124B
    jr nz, jr_000_120c                            ; $124D

    ret                                           ; $124F


; I: developers' name: same code as HBLK in the old build of table 2A at old 1256 and 35 at old 189F (14 bytes, exact
; match)
HBLK::
    ld a, b                                       ; $1250
    ld [hl+], a                                   ; $1251
    ld a, c                                       ; $1252
    ld [hl+], a                                   ; $1253
    ld a, d                                       ; $1254
    ld [hl+], a                                   ; $1255
    ld a, e                                       ; $1256
    ld [hl+], a                                   ; $1257
    ld a, $01                                     ; $1258
    ld [wHBLANK_F], a                             ; $125A
    reti                                          ; $125D


; I: developers' name: same code as WAIT_DONE_VBLNK in the old build of table 2A at old 1264 and 35 at old 18AD (8
; bytes, masked match)
WAIT_DONE_VBLNK::
    ldh a, [rLY]                                  ; $125E
    cp $00                                        ; $1260
    jp nz, WAIT_DONE_VBLNK                        ; $1262

    ret                                           ; $1265


; I: developers' name: same code as TIMER_INT in the old build of table 2A at old 126C and 35 at old 18B5 (5 bytes,
; exact match)
TIMER_INT::
    ld hl, wTIME_CT                               ; $1266
    inc [hl]                                      ; $1269
    reti                                          ; $126A


; I: developers' name: same code as VB_MOVIE in the old build of table 2A at old 1271 and 35 at old 18BA (10 bytes,
; exact match)
VB_MOVIE::
    call $ffb6                                    ; $126B
    ld a, [wDRAWING_F]                            ; $126E
    and $ff                                       ; $1271
    ret z                                         ; $1273

    ret                                           ; $1274


; C: developers' name: same code as MAKE_CONFIG in the old build of table 2A at old 127B (135 bytes, masked match)
MAKE_CONFIG::
    call LCDCOFF                                  ; $1275
    call VRAM_CLR                                 ; $1278
    call DMACLR                                   ; $127B
    ldh a, [hBANK_BUF]                            ; $127E
    push af                                       ; $1280
    ld a, $03                                     ; $1281
    ldh [hBANK_BUF], a                            ; $1283
    ld [$2100], a                                 ; $1285
    ld hl, Gfx_03_5A41_CONF2                      ; $1288
    ld de, $8000                                  ; $128B
    ld bc, $1800                                  ; $128E
    call DATA_MOV                                 ; $1291
    ld hl, Map_03_7241_BG_CONF                    ; $1294
    ld de, $9800                                  ; $1297
    ld bc, $0240                                  ; $129A
    call DATA_MOV                                 ; $129D
    ld hl, wOBJRAM                                ; $12A0
    ld a, [wCNF_CUR]                              ; $12A3
    ld [hl+], a                                   ; $12A6
    ld a, $08                                     ; $12A7
    ld [hl+], a                                   ; $12A9
    ld a, $00                                     ; $12AA
    ld [hl+], a                                   ; $12AC
    xor a                                         ; $12AD
    ld [hl+], a                                   ; $12AE
    ld hl, CONF_OBJ_PAT                           ; $12AF
    ld de, wMAIN_MENU_C004                        ; $12B2
    ld bc, $0030                                  ; $12B5
    call DATA_MOV                                 ; $12B8
    call CONF_SET_OBJ                             ; $12BB
    call PUT_MODE                                 ; $12BE
    call PUT_EDGE                                 ; $12C1
    call PUT_VREF                                 ; $12C4
    call Config_PutC0FDFlag                       ; $12C7
    call PUT_PALETTE                              ; $12CA
    call PUT_CHG_T                                ; $12CD
    call PUT_OFS                                  ; $12D0
    call Config_PutHexC0F9                        ; $12D3
    call PUT_DITH_PAT                             ; $12D6
    pop af                                        ; $12D9
    ldh [hBANK_BUF], a                            ; $12DA
    ld [$2100], a                                 ; $12DC
    call SCYX_SET0                                ; $12DF
    call OBJP_DEF_SET                             ; $12E2
    call Bgp_SetDefault                           ; $12E5
    ld a, $01                                     ; $12E8
    ldh [rIE], a                                  ; $12EA
    ld a, SEQ_CONFIG                              ; $12EC
    ld [wGAME_SEQ], a                             ; $12EE
    ld a, $c3                                     ; $12F1
    ldh [rLCDC], a                                ; $12F3
    xor a                                         ; $12F5
    ld [wNUM_IN_F], a                             ; $12F6
    ldh [hR0], a                                  ; $12F9
    ret                                           ; $12FB


; C: GAME_SEQ $09 handler of MAIN_SUB; the settings screen in BGB (Start on MOVIE TEST -> GAME_SEQ $09,
; port/menu_paths_proto.csv)
Seq09_ConfigMain::
    ld a, [wOBJRAM]                               ; $12FC
    cp $85                                        ; $12FF
    jr z, jr_000_130b                             ; $1301

    cp $75                                        ; $1303
    jr z, jr_000_130b                             ; $1305

    cp $65                                        ; $1307
    jr nz, jr_000_1365                            ; $1309

jr_000_130b:
    ldh a, [hCNT1]                                ; $130B
    bit 4, a                                      ; $130D
    jr z, jr_000_1339                             ; $130F

    ld a, [wPANASI]                               ; $1311
    cp $20                                        ; $1314
    jr nz, jr_000_132f                            ; $1316

    ld a, [wOBJRAM]                               ; $1318
    cp $85                                        ; $131B
    jr nz, jr_000_1327                            ; $131D

    ld a, $20                                     ; $131F
    ld [wPANASI], a                               ; $1321
    jp Jump_000_13d3                              ; $1324


jr_000_1327:
    ld a, $1c                                     ; $1327
    ld [wPANASI], a                               ; $1329
    jp Jump_000_13d3                              ; $132C


jr_000_132f:
    inc a                                         ; $132F
    ld [wPANASI], a                               ; $1330
    cp $01                                        ; $1333
    jp z, Jump_000_13d3                           ; $1335

    ret                                           ; $1338


jr_000_1339:
    bit 5, a                                      ; $1339
    jr z, jr_000_1365                             ; $133B

    ld a, [wPANASI]                               ; $133D
    cp $20                                        ; $1340
    jr nz, jr_000_135b                            ; $1342

    ld a, [wOBJRAM]                               ; $1344
    cp $85                                        ; $1347
    jr nz, jr_000_1353                            ; $1349

    ld a, $20                                     ; $134B
    ld [wPANASI], a                               ; $134D
    jp Jump_000_1461                              ; $1350


jr_000_1353:
    ld a, $1c                                     ; $1353
    ld [wPANASI], a                               ; $1355
    jp Jump_000_1461                              ; $1358


jr_000_135b:
    inc a                                         ; $135B
    ld [wPANASI], a                               ; $135C
    cp $01                                        ; $135F
    jp z, Jump_000_1461                           ; $1361

    ret                                           ; $1364


jr_000_1365:
    ldh a, [hCNT1]                                ; $1365
    bit 7, a                                      ; $1367
    jr nz, jr_000_1371                            ; $1369

    bit 6, a                                      ; $136B
    jr nz, jr_000_138a                            ; $136D

    jr jr_000_13a3                                ; $136F

jr_000_1371:
    ld a, [wPANASI2]                              ; $1371
    cp $20                                        ; $1374
    jr nz, jr_000_1380                            ; $1376

    ld a, $1c                                     ; $1378
    ld [wPANASI2], a                              ; $137A
    jp Jump_000_150c                              ; $137D


jr_000_1380:
    inc a                                         ; $1380
    ld [wPANASI2], a                              ; $1381
    cp $01                                        ; $1384
    jp z, Jump_000_150c                           ; $1386

    ret                                           ; $1389


jr_000_138a:
    ld a, [wPANASI2]                              ; $138A
    cp $20                                        ; $138D
    jr nz, jr_000_1399                            ; $138F

    ld a, $1c                                     ; $1391
    ld [wPANASI2], a                              ; $1393
    jp Jump_000_14f0                              ; $1396


jr_000_1399:
    inc a                                         ; $1399
    ld [wPANASI2], a                              ; $139A
    cp $01                                        ; $139D
    jp z, Jump_000_14f0                           ; $139F

    ret                                           ; $13A2


jr_000_13a3:
    ldh a, [hTRG1]                                ; $13A3
    sra a                                         ; $13A5
    jr c, jr_000_13ce                             ; $13A7

    sra a                                         ; $13A9
    jr c, jr_000_13cf                             ; $13AB

    sra a                                         ; $13AD
    sra a                                         ; $13AF
    jr c, jr_000_13cf                             ; $13B1

    sra a                                         ; $13B3
    jr c, jr_000_13d3                             ; $13B5

    sra a                                         ; $13B7
    jp c, Jump_000_1461                           ; $13B9

    sra a                                         ; $13BC
    jp c, Jump_000_14f0                           ; $13BE

    sra a                                         ; $13C1
    jp c, Jump_000_150c                           ; $13C3

    xor a                                         ; $13C6
    ld [wPANASI], a                               ; $13C7
    ld [wPANASI2], a                              ; $13CA
    ret                                           ; $13CD


jr_000_13ce:
    ret                                           ; $13CE


jr_000_13cf:
    call MAKE_MOVIE                               ; $13CF
    ret                                           ; $13D2


Jump_000_13d3:
jr_000_13d3:
    ld a, [wOBJRAM]                               ; $13D3
    cp $15                                        ; $13D6
    jr nz, jr_000_13f0                            ; $13D8

    ld a, [wDITHER]                               ; $13DA
    cp $0b                                        ; $13DD
    jr nz, jr_000_13e3                            ; $13DF

    ld a, $ff                                     ; $13E1

jr_000_13e3:
    inc a                                         ; $13E3
    ld [wDITHER], a                               ; $13E4
    call Stub_Ret_163A                            ; $13E7
    ld a, $01                                     ; $13EA
    ldh [hR0], a                                  ; $13EC
    jr jr_000_145d                                ; $13EE

jr_000_13f0:
    cp $25                                        ; $13F0
    jr nz, jr_000_1424                            ; $13F2

    ld a, [wB_MODE]                               ; $13F4
    and $0f                                       ; $13F7
    inc a                                         ; $13F9
    cp $07                                        ; $13FA
    jr nz, jr_000_13ff                            ; $13FC

    xor a                                         ; $13FE

jr_000_13ff:
    ld b, a                                       ; $13FF
    ld a, [wB_MODE]                               ; $1400
    and $f0                                       ; $1403
    or b                                          ; $1405
    ld [wB_MODE], a                               ; $1406
    call ParaSet_ByMode                           ; $1409
    ld a, $02                                     ; $140C
    ldh [hR0], a                                  ; $140E
    or $ff                                        ; $1410
    ldh [hMAIN_AFURE], a                          ; $1412

jr_000_1414:
    ldh a, [hVBFLG]                               ; $1414
    and a                                         ; $1416
    jr z, jr_000_1414                             ; $1417

    xor a                                         ; $1419
    ldh [hVBFLG], a                               ; $141A
    ldh [hMAIN_AFURE], a                          ; $141C
    ld a, $05                                     ; $141E
    ldh [hR0], a                                  ; $1420
    jr jr_000_145d                                ; $1422

jr_000_1424:
    cp $35                                        ; $1424
    jr nz, jr_000_1447                            ; $1426

    ld a, [wB_MODE]                               ; $1428
    swap a                                        ; $142B
    and $0f                                       ; $142D
    inc a                                         ; $142F
    cp $08                                        ; $1430
    jr nz, jr_000_1435                            ; $1432

    xor a                                         ; $1434

jr_000_1435:
    swap a                                        ; $1435
    ld b, a                                       ; $1437
    ld a, [wB_MODE]                               ; $1438
    and $0f                                       ; $143B
    or b                                          ; $143D
    ld [wB_MODE], a                               ; $143E
    ld a, $03                                     ; $1441
    ldh [hR0], a                                  ; $1443
    jr jr_000_145d                                ; $1445

jr_000_1447:
    cp $95                                        ; $1447
    jr nz, jr_000_145d                            ; $1449

    ld a, [wPALETTE]                              ; $144B
    inc a                                         ; $144E
    cp $06                                        ; $144F
    jr nz, jr_000_1454                            ; $1451

    xor a                                         ; $1453

jr_000_1454:
    ld [wPALETTE], a                              ; $1454
    ld a, $09                                     ; $1457
    ldh [hR0], a                                  ; $1459
    jr jr_000_145d                                ; $145B

jr_000_145d:
    call CONF_SET_OBJ                             ; $145D
    ret                                           ; $1460


Jump_000_1461:
    ld a, [wOBJRAM]                               ; $1461
    cp $15                                        ; $1464
    jr nz, jr_000_147e                            ; $1466

    ld a, [wDITHER]                               ; $1468
    cp $00                                        ; $146B
    jr nz, jr_000_1471                            ; $146D

    ld a, $0c                                     ; $146F

jr_000_1471:
    dec a                                         ; $1471
    ld [wDITHER], a                               ; $1472
    call Stub_Ret_163A                            ; $1475
    ld a, $01                                     ; $1478
    ldh [hR0], a                                  ; $147A
    jr jr_000_14ec                                ; $147C

jr_000_147e:
    cp $25                                        ; $147E
    jr nz, jr_000_14b3                            ; $1480

    ld a, [wB_MODE]                               ; $1482
    and $0f                                       ; $1485
    dec a                                         ; $1487
    cp $ff                                        ; $1488
    jr nz, jr_000_148e                            ; $148A

    ld a, $06                                     ; $148C

jr_000_148e:
    ld b, a                                       ; $148E
    ld a, [wB_MODE]                               ; $148F
    and $f0                                       ; $1492
    or b                                          ; $1494
    ld [wB_MODE], a                               ; $1495
    call ParaSet_ByMode                           ; $1498
    ld a, $02                                     ; $149B
    ldh [hR0], a                                  ; $149D
    or $ff                                        ; $149F
    ldh [hMAIN_AFURE], a                          ; $14A1

jr_000_14a3:
    ldh a, [hVBFLG]                               ; $14A3
    and a                                         ; $14A5
    jr z, jr_000_14a3                             ; $14A6

    xor a                                         ; $14A8
    ldh [hVBFLG], a                               ; $14A9
    ldh [hMAIN_AFURE], a                          ; $14AB
    ld a, $05                                     ; $14AD
    ldh [hR0], a                                  ; $14AF
    jr jr_000_14ec                                ; $14B1

jr_000_14b3:
    cp $35                                        ; $14B3
    jr nz, jr_000_14d5                            ; $14B5

    ld a, [wB_MODE]                               ; $14B7
    swap a                                        ; $14BA
    and $0f                                       ; $14BC
    dec a                                         ; $14BE
    cp $ff                                        ; $14BF
    jr nz, jr_000_14c5                            ; $14C1

    ld a, $07                                     ; $14C3

jr_000_14c5:
    swap a                                        ; $14C5
    ld b, a                                       ; $14C7
    ld a, [wB_MODE]                               ; $14C8
    and $0f                                       ; $14CB
    or b                                          ; $14CD
    ld [wB_MODE], a                               ; $14CE
    ld a, $03                                     ; $14D1
    ldh [hR0], a                                  ; $14D3

jr_000_14d5:
    cp $95                                        ; $14D5
    jr nz, jr_000_14ec                            ; $14D7

    ld a, [wPALETTE]                              ; $14D9
    dec a                                         ; $14DC
    cp $ff                                        ; $14DD
    jr nz, jr_000_14e3                            ; $14DF

    ld a, $05                                     ; $14E1

jr_000_14e3:
    ld [wPALETTE], a                              ; $14E3
    ld a, $09                                     ; $14E6
    ldh [hR0], a                                  ; $14E8
    jr jr_000_14ec                                ; $14EA

jr_000_14ec:
    call CONF_SET_OBJ                             ; $14EC
    ret                                           ; $14EF


Jump_000_14f0:
    ld a, [wOBJRAM]                               ; $14F0
    cp $15                                        ; $14F3
    jr z, jr_000_1503                             ; $14F5

    cp $95                                        ; $14F7
    jr z, jr_000_14ff                             ; $14F9

    sub $10                                       ; $14FB
    jr jr_000_1505                                ; $14FD

jr_000_14ff:
    ld a, $35                                     ; $14FF
    jr jr_000_1505                                ; $1501

jr_000_1503:
    ld a, $95                                     ; $1503

jr_000_1505:
    ld [wOBJRAM], a                               ; $1505
    ld [wCNF_CUR], a                              ; $1508
    ret                                           ; $150B


Jump_000_150c:
    ld a, [wOBJRAM]                               ; $150C
    cp $35                                        ; $150F
    jr z, jr_000_151f                             ; $1511

    cp $95                                        ; $1513
    jr z, jr_000_151b                             ; $1515

    add $10                                       ; $1517
    jr jr_000_1521                                ; $1519

jr_000_151b:
    ld a, $15                                     ; $151B
    jr jr_000_1521                                ; $151D

jr_000_151f:
    ld a, $95                                     ; $151F

jr_000_1521:
    ld [wOBJRAM], a                               ; $1521
    ld [wCNF_CUR], a                              ; $1524
    ret                                           ; $1527


; I: dispatch on R0 ($FF88) to the PUT_ routines of the settings screen (PUT_DITH_PAT, PUT_MODE ...)
Config_PutItem::
    ldh a, [hR0]                                  ; $1528
    cp $01                                        ; $152A
    jr nz, Config_PutItem_Part1535                ; $152C

    call PUT_DITH_PAT                             ; $152E
    jr jr_000_1589                                ; $1531

; I: leftover: 2 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_1533::
    db $18, $54

; C: continuation of Config_PutItem after a data label or a never-traced byte
Config_PutItem_Part1535::
    cp $02                                        ; $1535
    jr nz, jr_000_1544                            ; $1537

    call Config_PutHexC0F9                        ; $1539
    call PUT_MODE                                 ; $153C
    call PUT_VREF                                 ; $153F
    jr jr_000_1589                                ; $1542

jr_000_1544:
    cp $03                                        ; $1544
    jr nz, jr_000_1553                            ; $1546

    call PUT_EDGE                                 ; $1548
    call PUT_VREF                                 ; $154B
    call Config_PutHexC0F9                        ; $154E
    jr jr_000_1589                                ; $1551

jr_000_1553:
    cp $04                                        ; $1553
    jr nz, jr_000_155c                            ; $1555

    call PUT_VREF                                 ; $1557
    jr jr_000_1589                                ; $155A

jr_000_155c:
    cp $05                                        ; $155C
    jr nz, jr_000_1565                            ; $155E

    call Config_PutC0FDFlag                       ; $1560
    jr jr_000_1589                                ; $1563

jr_000_1565:
    cp $06                                        ; $1565
    jr nz, jr_000_156e                            ; $1567

    call Config_PutHexC0F9                        ; $1569
    jr jr_000_1589                                ; $156C

jr_000_156e:
    cp $07                                        ; $156E
    jr nz, jr_000_1577                            ; $1570

    call PUT_OFS                                  ; $1572
    jr jr_000_1589                                ; $1575

jr_000_1577:
    cp $08                                        ; $1577
    jr nz, jr_000_1580                            ; $1579

    call PUT_CHG_T                                ; $157B
    jr jr_000_1589                                ; $157E

jr_000_1580:
    cp $09                                        ; $1580
    jr nz, jr_000_1589                            ; $1582

    call PUT_PALETTE                              ; $1584
    jr jr_000_1589                                ; $1587

jr_000_1589:
    xor a                                         ; $1589
    ldh [hR0], a                                  ; $158A
    ret                                           ; $158C


; C: developers' name: same code as CONF_SET_OBJ in the old build of table 2A at old 1569 (173 bytes, masked match)
CONF_SET_OBJ::
    ld a, [wRAM_BANK_BUF]                         ; $158D
    push af                                       ; $1590
    ld a, $10                                     ; $1591
    ld [wRAM_BANK_BUF], a                         ; $1593
    ld [rRAMB], a                                 ; $1596
    ld a, [wB_MODE]                               ; $1599
    call ParaSet_ByMode                           ; $159C
    pop af                                        ; $159F
    ld [wRAM_BANK_BUF], a                         ; $15A0
    ld [rRAMB], a                                 ; $15A3
    ld hl, wDOG_ANIME_C006                        ; $15A6
    ld a, [wB_CNTR0]                              ; $15A9
    swap a                                        ; $15AC
    and $0f                                       ; $15AE
    add $e0                                       ; $15B0
    ld [hl+], a                                   ; $15B2
    inc hl                                        ; $15B3
    inc hl                                        ; $15B4
    inc hl                                        ; $15B5
    ld a, [wB_CNTR0]                              ; $15B6
    and $0f                                       ; $15B9
    add $e0                                       ; $15BB
    ld [hl+], a                                   ; $15BD
    inc hl                                        ; $15BE
    inc hl                                        ; $15BF
    inc hl                                        ; $15C0
    ld a, [wB_CNTR1]                              ; $15C1
    swap a                                        ; $15C4
    and $0f                                       ; $15C6
    add $e0                                       ; $15C8
    ld [hl+], a                                   ; $15CA
    inc hl                                        ; $15CB
    inc hl                                        ; $15CC
    inc hl                                        ; $15CD
    ld a, [wB_CNTR1]                              ; $15CE
    and $0f                                       ; $15D1
    add $e0                                       ; $15D3
    ld [hl+], a                                   ; $15D5
    inc hl                                        ; $15D6
    inc hl                                        ; $15D7
    inc hl                                        ; $15D8
    ld a, [wB_CNTR2]                              ; $15D9
    swap a                                        ; $15DC
    and $0f                                       ; $15DE
    add $e0                                       ; $15E0
    ld [hl+], a                                   ; $15E2
    inc hl                                        ; $15E3
    inc hl                                        ; $15E4
    inc hl                                        ; $15E5
    ld a, [wB_CNTR2]                              ; $15E6
    and $0f                                       ; $15E9
    add $e0                                       ; $15EB
    ld [hl+], a                                   ; $15ED
    inc hl                                        ; $15EE
    inc hl                                        ; $15EF
    inc hl                                        ; $15F0
    ld a, [wB_CNTR3]                              ; $15F1
    swap a                                        ; $15F4
    and $0f                                       ; $15F6
    add $e0                                       ; $15F8
    ld [hl+], a                                   ; $15FA
    inc hl                                        ; $15FB
    inc hl                                        ; $15FC
    inc hl                                        ; $15FD
    ld a, [wB_CNTR3]                              ; $15FE
    and $0f                                       ; $1601
    add $e0                                       ; $1603
    ld [hl+], a                                   ; $1605
    inc hl                                        ; $1606
    inc hl                                        ; $1607
    inc hl                                        ; $1608
    ld a, [wB_CNTR4]                              ; $1609
    swap a                                        ; $160C
    and $0f                                       ; $160E
    add $e0                                       ; $1610
    ld [hl+], a                                   ; $1612
    inc hl                                        ; $1613
    inc hl                                        ; $1614
    inc hl                                        ; $1615
    ld a, [wB_CNTR4]                              ; $1616
    and $0f                                       ; $1619
    add $e0                                       ; $161B
    ld [hl+], a                                   ; $161D
    inc hl                                        ; $161E
    inc hl                                        ; $161F
    inc hl                                        ; $1620
    ld a, [wB_CNTR5]                              ; $1621
    swap a                                        ; $1624
    and $0f                                       ; $1626
    add $e0                                       ; $1628
    ld [hl+], a                                   ; $162A
    inc hl                                        ; $162B
    inc hl                                        ; $162C
    inc hl                                        ; $162D
    ld a, [wB_CNTR5]                              ; $162E
    and $0f                                       ; $1631
    add $e0                                       ; $1633
    ld [hl+], a                                   ; $1635
    inc hl                                        ; $1636
    inc hl                                        ; $1637
    inc hl                                        ; $1638
    ret                                           ; $1639


; C: a lone ret (the byte before PUT_MODE), called twice
Stub_Ret_163A::
    ret                                           ; $163A


; C: developers' name: same code as PUT_MODE in the old build of table 2A at old 1617 (37 bytes, masked match)
PUT_MODE::
    ld hl, MODE0                                  ; $163B
    ld de, $0018                                  ; $163E
    ld a, [wB_MODE]                               ; $1641
    and $0f                                       ; $1644

jr_000_1646:
    or a                                          ; $1646
    jr z, jr_000_164d                             ; $1647

    add hl, de                                    ; $1649
    dec a                                         ; $164A
    jr jr_000_1646                                ; $164B

jr_000_164d:
    ld de, $9846                                  ; $164D
    ld bc, $000c                                  ; $1650
    call DATA_MOV                                 ; $1653
    ld de, $9866                                  ; $1656
    ld bc, $000c                                  ; $1659
    call DATA_MOV                                 ; $165C
    ret                                           ; $165F


; C: developers' name: same code as PUT_EDGE in the old build of table 2A at old 163C (39 bytes, masked match)
PUT_EDGE::
    ld hl, EDGE0                                  ; $1660
    ld de, $0008                                  ; $1663
    ld a, [wB_MODE]                               ; $1666
    swap a                                        ; $1669
    and $0f                                       ; $166B

jr_000_166d:
    or a                                          ; $166D
    jr z, jr_000_1674                             ; $166E

    add hl, de                                    ; $1670
    dec a                                         ; $1671
    jr jr_000_166d                                ; $1672

jr_000_1674:
    ld de, $9886                                  ; $1674
    ld bc, $0004                                  ; $1677
    call DATA_MOV                                 ; $167A
    ld de, $98a6                                  ; $167D
    ld bc, $0004                                  ; $1680
    call DATA_MOV                                 ; $1683
    ret                                           ; $1686


; C: developers' name: same code as PUT_VREF in the old build of table 2A at old 1663 (37 bytes, masked match)
PUT_VREF::
    ld hl, VREF0                                  ; $1687
    ld de, $0008                                  ; $168A
    ld a, [wB_CNTR4]                              ; $168D
    and $07                                       ; $1690

jr_000_1692:
    or a                                          ; $1692
    jr z, jr_000_1699                             ; $1693

    add hl, de                                    ; $1695
    dec a                                         ; $1696
    jr jr_000_1692                                ; $1697

jr_000_1699:
    ld de, $98c6                                  ; $1699
    ld bc, $0004                                  ; $169C
    call DATA_MOV                                 ; $169F
    ld de, $98e6                                  ; $16A2
    ld bc, $0004                                  ; $16A5
    call DATA_MOV                                 ; $16A8
    ret                                           ; $16AB


; I: prints one of two texts ($1911 table, step $1C) chosen by bit 7 of $C0FD
Config_PutC0FDFlag::
    ld hl, ZERO0                                  ; $16AC
    ld de, $001c                                  ; $16AF
    ld a, [wB_CNTR5]                              ; $16B2
    bit 7, a                                      ; $16B5
    jr nz, jr_000_16bc                            ; $16B7

    xor a                                         ; $16B9
    jr jr_000_16be                                ; $16BA

jr_000_16bc:
    ld a, $02                                     ; $16BC

jr_000_16be:
    or a                                          ; $16BE
    jr z, jr_000_16c5                             ; $16BF

    add hl, de                                    ; $16C1
    dec a                                         ; $16C2
    jr jr_000_16be                                ; $16C3

jr_000_16c5:
    ld de, $9906                                  ; $16C5
    ld bc, $000e                                  ; $16C8
    call DATA_MOV                                 ; $16CB
    ld de, $9926                                  ; $16CE
    ld bc, $000e                                  ; $16D1
    call DATA_MOV                                 ; $16D4
    ret                                           ; $16D7


; I: developers' name: same code as PUT_PALETTE in the old build of table 2A at old 16AA (14 bytes, exact match)
PUT_PALETTE::
    ld a, [wPALETTE]                              ; $16D8
    add $80                                       ; $16DB
    ld [$9a06], a                                 ; $16DD
    add $10                                       ; $16E0
    ld [$9a26], a                                 ; $16E2
    ret                                           ; $16E5


; C: developers' name: same code as PUT_CHG_T in the old build of table 2A at old 16B8 and 35 at old 1F60 (65 bytes,
; exact match)
PUT_CHG_T::
    ld a, [wB_CNTR2]                              ; $16E6
    swap a                                        ; $16E9
    and $0f                                       ; $16EB
    add $80                                       ; $16ED
    ld [$99c6], a                                 ; $16EF
    add $10                                       ; $16F2
    ld [$99e6], a                                 ; $16F4
    ld a, [wB_CNTR2]                              ; $16F7
    and $0f                                       ; $16FA
    add $80                                       ; $16FC
    ld [$99c7], a                                 ; $16FE
    add $10                                       ; $1701
    ld [$99e7], a                                 ; $1703
    ld a, [wB_CNTR3]                              ; $1706
    swap a                                        ; $1709
    and $0f                                       ; $170B
    add $80                                       ; $170D
    ld [$99c8], a                                 ; $170F
    add $10                                       ; $1712
    ld [$99e8], a                                 ; $1714
    ld a, [wB_CNTR3]                              ; $1717
    and $0f                                       ; $171A
    add $80                                       ; $171C
    ld [$99c9], a                                 ; $171E
    add $10                                       ; $1721
    ld [$99e9], a                                 ; $1723
    ret                                           ; $1726


; C: developers' name: same code as PUT_OFS in the old build of table 2A at old 16F9 and 35 at old 1FA1 (54 bytes,
; exact match)
PUT_OFS::
    ld a, [wB_CNTR5]                              ; $1727
    bit 5, a                                      ; $172A
    jr z, jr_000_1732                             ; $172C

    ld a, $40                                     ; $172E
    jr jr_000_1734                                ; $1730

jr_000_1732:
    ld a, $41                                     ; $1732

jr_000_1734:
    ld [$9986], a                                 ; $1734
    add $10                                       ; $1737
    ld [$99a6], a                                 ; $1739
    ld a, [wB_CNTR5]                              ; $173C
    swap a                                        ; $173F
    and $01                                       ; $1741
    add $80                                       ; $1743
    ld [$9987], a                                 ; $1745
    add $10                                       ; $1748
    ld [$99a7], a                                 ; $174A
    ld a, [wB_CNTR5]                              ; $174D
    and $0f                                       ; $1750
    add $80                                       ; $1752
    ld [$9988], a                                 ; $1754
    add $10                                       ; $1757
    ld [$99a8], a                                 ; $1759
    ret                                           ; $175C


; C: writes the two nibbles of $C0F9 as tiles $80+n to BG $9946 / $9966
Config_PutHexC0F9::
    ld a, [wB_CNTR1]                              ; $175D
    swap a                                        ; $1760
    and $01                                       ; $1762
    add $80                                       ; $1764
    ld [$9946], a                                 ; $1766
    add $10                                       ; $1769
    ld [$9966], a                                 ; $176B
    ld a, [wB_CNTR1]                              ; $176E
    and $0f                                       ; $1771
    add $80                                       ; $1773
    ld [$9947], a                                 ; $1775
    add $10                                       ; $1778
    ld [$9967], a                                 ; $177A
    ret                                           ; $177D


; C: developers' name: same code as PUT_DITH_PAT in the old build of table 2A at old 1750 and 35 at old 1FF8 (35
; bytes, masked match); other names on this address: PUT_REV, PUT_ZERO
PUT_DITH_PAT::
    ld hl, DITH_P0                                ; $177E
    ld de, $0006                                  ; $1781
    ld a, [wDITHER]                               ; $1784

jr_000_1787:
    or a                                          ; $1787
    jr z, jr_000_178e                             ; $1788

    add hl, de                                    ; $178A
    dec a                                         ; $178B
    jr jr_000_1787                                ; $178C

jr_000_178e:
    ld de, $9806                                  ; $178E
    ld bc, $0003                                  ; $1791
    call DATA_MOV                                 ; $1794
    ld de, $9826                                  ; $1797
    ld bc, $0003                                  ; $179A
    call DATA_MOV                                 ; $179D
    ret                                           ; $17A0


; C: developers' name: the same bytes as the data label DITH_P0 in the old build of table 2A at old 1773 (72 bytes,
; data match)
DITH_P0::
    db $29, $2a, $2b, $39, $3a, $3b, $81, $60, $60, $91, $60, $60, $82, $60, $60, $92
    db $60, $60, $83, $60, $60, $93, $60, $60, $84, $60, $60, $94, $60, $60, $85, $60
    db $60, $95, $60, $60, $86, $60, $60, $96, $60, $60, $87, $60, $60, $97, $60, $60
    db $88, $60, $60, $98, $60, $60, $89, $60, $60, $99, $60, $60, $81, $80, $60, $91
    db $90, $60, $81, $81, $60, $91, $91, $60

; I: tile rows printed by PUT_MODE (00:163B): 5 entries of $18 bytes (two rows of 12 tiles), one per camera mode (C);
; the old table $2A names the same kind of table MODE0, next to EDGE0 / VREF0 / ZERO0 / REV0, which match by their
; bytes (its own bytes changed)
MODE0::
    db $2e, $2f, $46, $47, $48, $49, $60, $60, $60, $60, $60, $60, $3e, $3f, $56, $57
    db $58, $59, $60, $60, $60, $60, $60, $60, $0a, $0b, $20, $21, $22, $23, $24, $25
    db $26, $60, $60, $60, $1a, $1b, $30, $31, $32, $33, $34, $35, $36, $60, $60, $60
    db $0c, $0d, $20, $21, $22, $23, $24, $25, $26, $60, $60, $60, $1c, $1d, $30, $31
    db $32, $33, $34, $35, $36, $60, $60, $60, $00, $01, $02, $03, $04, $20, $21, $22
    db $23, $24, $25, $26, $10, $11, $12, $13, $14, $30, $31, $32, $33, $34, $35, $36
    db $00, $01, $02, $03, $04, $20, $21, $22, $23, $24, $25, $26, $10, $11, $12, $13
    db $14, $30, $31, $32, $33, $34, $35, $36, $00, $01, $02, $03, $04, $20, $21, $22
    db $23, $24, $25, $26, $10, $11, $12, $13, $14, $30, $31, $32, $33, $34, $35, $36
    db $00, $01, $02, $03, $04, $20, $21, $22, $60, $60, $60, $60, $10, $11, $12, $13
    db $14, $30, $31, $32, $60, $60, $60, $60

; C: developers' name: the same bytes as the data label EDGE0 in the old build of table 2A at old 1863 and 35 at old
; 20FF (64 bytes, data match)
EDGE0::
    db $85, $80, $44, $60, $95, $90, $54, $60, $87, $85, $44, $60, $97, $95, $54, $60
    db $81, $80, $80, $44, $91, $90, $90, $54, $81, $82, $85, $44, $91, $92, $95, $54
    db $82, $80, $80, $44, $92, $90, $90, $54, $83, $80, $80, $44, $93, $90, $90, $54
    db $84, $80, $80, $44, $94, $90, $90, $54, $85, $80, $80, $44, $95, $90, $90, $54

; C: developers' name: the same bytes as the data label VREF0 in the old build of table 2A at old 18A3 and 35 at old
; 213F (64 bytes, data match)
VREF0::
    db $80, $42, $80, $43, $90, $52, $90, $53, $80, $42, $85, $43, $90, $52, $95, $53
    db $81, $42, $80, $43, $91, $52, $90, $53, $81, $42, $85, $43, $91, $52, $95, $53
    db $82, $42, $80, $43, $92, $52, $90, $53, $82, $42, $85, $43, $92, $52, $95, $53
    db $83, $42, $80, $43, $93, $52, $90, $53, $83, $42, $85, $43, $93, $52, $95, $53

; C: developers' name: the same bytes as the data label ZERO0 in the old build of table 2A at old 18E3 and 35 at old
; 217F (84 bytes, data match)
ZERO0::
    db $4a, $4b, $4c, $4d, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $5a, $5b
    db $5c, $5d, $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $2c, $2d, $46, $47
    db $48, $49, $ac, $ad, $ae, $af, $0e, $0f, $2c, $2d, $3c, $3d, $56, $57, $58, $59
    db $bc, $bd, $be, $bf, $1e, $1f, $3c, $3d, $2e, $2f, $46, $47, $48, $49, $ac, $ad
    db $ae, $af, $0e, $0f, $2c, $2d, $3e, $3f, $56, $57, $58, $59, $bc, $bd, $be, $bf
    db $1e, $1f, $3c, $3d

; C: developers' name: the same bytes as the data label REV0 in the old build of table 2A at old 1937 and 35 at old
; 21D3 (24 bytes, data match)
REV0::
    db $4e, $4f, $cc, $cd, $ce, $cf, $5e, $5f, $dc, $dd, $de, $df, $cc, $cd, $ce, $cf
    db $60, $60, $dc, $dd, $de, $df, $60, $60

; C: developers' name: the same bytes as the data label CONF_OBJ_PAT in the old build of table 2A at old 194F and 35
; at old 21EB (48 bytes, data match)
CONF_OBJ_PAT::
    db $70, $80, $80, $00, $70, $88, $80, $00, $78, $80, $80, $00, $78, $88, $80, $00
    db $80, $80, $80, $00, $80, $88, $80, $00, $88, $80, $80, $00, $88, $88, $80, $00
    db $90, $80, $80, $00, $90, $88, $80, $00, $98, $80, $80, $00, $98, $88, $80, $00

; C: developers' name: same code as MK_PROTECT in the old build of table 2A at old 197F and 35 at old 257B (96 bytes,
; masked match)
MK_PROTECT::
    call LCDCOFF                                  ; $19AD
    call VRAM_CLR                                 ; $19B0
    call DMACLR                                   ; $19B3
    ldh a, [hBANK_BUF]                            ; $19B6
    push af                                       ; $19B8
    ld a, $02                                     ; $19B9
    ldh [hBANK_BUF], a                            ; $19BB
    ld [$2100], a                                 ; $19BD
    ld hl, Gfx_02_4001_FNTOOE2                    ; $19C0
    ld de, $8000                                  ; $19C3
    ld bc, $1800                                  ; $19C6
    call DATA_MOV                                 ; $19C9
    ld hl, Map_02_6341_BGPROTEC                   ; $19CC
    ld de, $9800                                  ; $19CF
    ld bc, $0240                                  ; $19D2
    call DATA_MOV                                 ; $19D5
    ld hl, wOBJRAM                                ; $19D8
    ld a, $3c                                     ; $19DB
    ld [hl+], a                                   ; $19DD
    ld a, $29                                     ; $19DE
    ld [hl+], a                                   ; $19E0
    xor a                                         ; $19E1
    ld [hl+], a                                   ; $19E2
    ld [hl+], a                                   ; $19E3
    ld a, $3c                                     ; $19E4
    ld [hl+], a                                   ; $19E6
    ld a, $31                                     ; $19E7
    ld [hl+], a                                   ; $19E9
    ld a, $02                                     ; $19EA
    ld [hl+], a                                   ; $19EC
    xor a                                         ; $19ED
    ld [hl+], a                                   ; $19EE
    ldh [hOBJ_CT2], a                             ; $19EF
    ld [wOK_FLAG], a                              ; $19F1
    call SCYX_SET0                                ; $19F4
    call OBJP_DEF_SET                             ; $19F7
    call Bgp_SetDefault                           ; $19FA
    ld a, $c7                                     ; $19FD
    ldh [rLCDC], a                                ; $19FF
    ld a, SEQ_PROTECT_TEST                        ; $1A01
    ld [wGAME_SEQ], a                             ; $1A03
    pop af                                        ; $1A06
    ldh [hBANK_BUF], a                            ; $1A07
    ld [$2100], a                                 ; $1A09
    ret                                           ; $1A0C


; C: developers' name: same code as PROTECT_TEST in the old build of table 2A at old 19DF and 35 at old 25DB (112
; bytes, masked match)
PROTECT_TEST::
    ldh a, [hTRG1]                                ; $1A0D
    sla a                                         ; $1A0F
    jr c, jr_000_1a54                             ; $1A11

    sla a                                         ; $1A13
    jr c, jr_000_1a63                             ; $1A15

    sla a                                         ; $1A17
    sla a                                         ; $1A19
    sla a                                         ; $1A1B
    sla a                                         ; $1A1D
    sla a                                         ; $1A1F
    jr c, jr_000_1a2c                             ; $1A21

    sla a                                         ; $1A23
    jr c, jr_000_1a36                             ; $1A25

    call KAO_ANIME                                ; $1A27
    jr jr_000_1a7c                                ; $1A2A

jr_000_1a2c:
    ld a, $02                                     ; $1A2C
    ld [wINF_CUR], a                              ; $1A2E
    call MAKE_MENU                                ; $1A31
    jr jr_000_1a7c                                ; $1A34

jr_000_1a36:
    ld a, [wOBJRAM]                               ; $1A36
    cp $3c                                        ; $1A39
    jr nz, jr_000_1a42                            ; $1A3B

    call PROT_TEST                                ; $1A3D
    jr jr_000_1a52                                ; $1A40

jr_000_1a42:
    cp $4c                                        ; $1A42
    jr nz, jr_000_1a4b                            ; $1A44

    call OFF_TEST                                 ; $1A46
    jr jr_000_1a52                                ; $1A49

jr_000_1a4b:
    cp $5c                                        ; $1A4B
    jr nz, jr_000_1a52                            ; $1A4D

    call ON_TEST                                  ; $1A4F

jr_000_1a52:
    jr jr_000_1a7c                                ; $1A52

jr_000_1a54:
    ld a, [wOBJRAM]                               ; $1A54
    cp $5c                                        ; $1A57
    jr nz, jr_000_1a5f                            ; $1A59

    sub $20                                       ; $1A5B
    jr jr_000_1a72                                ; $1A5D

jr_000_1a5f:
    add $10                                       ; $1A5F
    jr jr_000_1a72                                ; $1A61

jr_000_1a63:
    ld a, [wOBJRAM]                               ; $1A63
    cp $3c                                        ; $1A66
    jr nz, jr_000_1a6e                            ; $1A68

    add $20                                       ; $1A6A
    jr jr_000_1a72                                ; $1A6C

jr_000_1a6e:
    sub $10                                       ; $1A6E
    jr jr_000_1a72                                ; $1A70

jr_000_1a72:
    ld [wOBJRAM], a                               ; $1A72
    ld [wMAIN_MENU_C004], a                       ; $1A75
    xor a                                         ; $1A78
    ld [wOK_FLAG], a                              ; $1A79

jr_000_1a7c:
    ret                                           ; $1A7C


; C: developers' name: same code as PROT_TEST in the old build of table 2A at old 1A4F and 35 at old 264B (58 bytes,
; exact match)
PROT_TEST::
    di                                            ; $1A7D
    ld d, $00                                     ; $1A7E
    ld a, $01                                     ; $1A80
    ld [$6000], a                                 ; $1A82

jr_000_1a85:
    ld a, d                                       ; $1A85
    ld [rRAMB], a                                 ; $1A86
    ld hl, $a000                                  ; $1A89
    ld a, [hl]                                    ; $1A8C
    ld b, a                                       ; $1A8D
    xor $ff                                       ; $1A8E
    ld [hl], a                                    ; $1A90
    ld a, [hl]                                    ; $1A91
    cp b                                          ; $1A92
    jr nz, jr_000_1ab0                            ; $1A93

    ld hl, $bfff                                  ; $1A95
    ld a, [hl]                                    ; $1A98
    ld b, a                                       ; $1A99
    xor $ff                                       ; $1A9A
    ld [hl], a                                    ; $1A9C
    ld a, [hl]                                    ; $1A9D
    cp b                                          ; $1A9E
    jr nz, jr_000_1ab0                            ; $1A9F

    ld a, d                                       ; $1AA1
    cp $0f                                        ; $1AA2
    jr z, jr_000_1aa9                             ; $1AA4

    inc d                                         ; $1AA6
    jr jr_000_1a85                                ; $1AA7

jr_000_1aa9:
    ld a, $01                                     ; $1AA9
    ld [wOK_FLAG], a                              ; $1AAB
    ei                                            ; $1AAE
    ret                                           ; $1AAF


jr_000_1ab0:
    ld a, $02                                     ; $1AB0
    ld [wOK_FLAG], a                              ; $1AB2
    ei                                            ; $1AB5
    ret                                           ; $1AB6


; C: developers' name: same code as OFF_TEST in the old build of table 2A at old 1A89 and 35 at old 2685 (63 bytes,
; exact match)
OFF_TEST::
    di                                            ; $1AB7
    ld d, $00                                     ; $1AB8
    ld a, $01                                     ; $1ABA
    ld [$6000], a                                 ; $1ABC
    ld a, $0a                                     ; $1ABF
    ld [rRAMG], a                                 ; $1AC1

jr_000_1ac4:
    ld a, d                                       ; $1AC4
    ld [rRAMB], a                                 ; $1AC5
    ld hl, $a000                                  ; $1AC8
    ld a, [hl]                                    ; $1ACB
    xor $ff                                       ; $1ACC
    ld b, a                                       ; $1ACE
    ld [hl], a                                    ; $1ACF
    ld a, [hl]                                    ; $1AD0
    cp b                                          ; $1AD1
    jr nz, jr_000_1aef                            ; $1AD2

    ld hl, $bfff                                  ; $1AD4
    ld a, [hl]                                    ; $1AD7
    xor $ff                                       ; $1AD8
    ld b, a                                       ; $1ADA
    ld [hl], a                                    ; $1ADB
    ld a, [hl]                                    ; $1ADC
    cp b                                          ; $1ADD
    jr nz, jr_000_1aef                            ; $1ADE

    ld a, d                                       ; $1AE0
    cp $0f                                        ; $1AE1
    jr z, jr_000_1ae8                             ; $1AE3

    inc d                                         ; $1AE5
    jr jr_000_1ac4                                ; $1AE6

jr_000_1ae8:
    ld a, $03                                     ; $1AE8
    ld [wOK_FLAG], a                              ; $1AEA
    ei                                            ; $1AED
    ret                                           ; $1AEE


jr_000_1aef:
    ld a, $04                                     ; $1AEF
    ld [wOK_FLAG], a                              ; $1AF1
    ei                                            ; $1AF4
    ret                                           ; $1AF5


; C: developers' name: same code as ON_TEST in the old build of table 2A at old 1AC8 and 35 at old 26C4 (63 bytes,
; exact match)
ON_TEST::
    di                                            ; $1AF6
    ld d, $00                                     ; $1AF7
    ld a, $01                                     ; $1AF9
    ld [$6000], a                                 ; $1AFB
    ld a, $00                                     ; $1AFE
    ld [rRAMG], a                                 ; $1B00

jr_000_1b03:
    ld a, d                                       ; $1B03
    ld [rRAMB], a                                 ; $1B04
    ld hl, $a000                                  ; $1B07
    ld a, [hl]                                    ; $1B0A
    ld b, a                                       ; $1B0B
    xor $ff                                       ; $1B0C
    ld [hl], a                                    ; $1B0E
    ld a, [hl]                                    ; $1B0F
    cp b                                          ; $1B10
    jr nz, jr_000_1b2e                            ; $1B11

    ld hl, $bfff                                  ; $1B13
    ld a, [hl]                                    ; $1B16
    ld b, a                                       ; $1B17
    xor $ff                                       ; $1B18
    ld [hl], a                                    ; $1B1A
    ld a, [hl]                                    ; $1B1B
    cp b                                          ; $1B1C
    jr nz, jr_000_1b2e                            ; $1B1D

    ld a, d                                       ; $1B1F
    cp $0f                                        ; $1B20
    jr z, jr_000_1b27                             ; $1B22

    inc d                                         ; $1B24
    jr jr_000_1b03                                ; $1B25

jr_000_1b27:
    ld a, $05                                     ; $1B27
    ld [wOK_FLAG], a                              ; $1B29
    ei                                            ; $1B2C
    ret                                           ; $1B2D


jr_000_1b2e:
    ld a, $06                                     ; $1B2E
    ld [wOK_FLAG], a                              ; $1B30
    ei                                            ; $1B33
    ret                                           ; $1B34


; C: developers' name: same code as VB_PROTECT in the old build of table 2A at old 1B07 and 35 at old 2703 (125 bytes,
; exact match)
VB_PROTECT::
    ld a, [wOK_FLAG]                              ; $1B35
    or a                                          ; $1B38
    jr nz, jr_000_1b51                            ; $1B39

    ld a, $a0                                     ; $1B3B
    ld [$98ce], a                                 ; $1B3D
    ld [$98cf], a                                 ; $1B40
    ld [$990e], a                                 ; $1B43
    ld [$990f], a                                 ; $1B46
    ld [$994e], a                                 ; $1B49
    ld [$994f], a                                 ; $1B4C
    jr jr_000_1bb1                                ; $1B4F

jr_000_1b51:
    cp $01                                        ; $1B51
    jr nz, jr_000_1b61                            ; $1B53

    ld a, $cf                                     ; $1B55
    ld [$98ce], a                                 ; $1B57
    ld a, $cb                                     ; $1B5A
    ld [$98cf], a                                 ; $1B5C
    jr jr_000_1bb1                                ; $1B5F

jr_000_1b61:
    cp $02                                        ; $1B61
    jr nz, jr_000_1b71                            ; $1B63

    ld a, $ce                                     ; $1B65
    ld [$98ce], a                                 ; $1B67
    ld a, $c7                                     ; $1B6A
    ld [$98cf], a                                 ; $1B6C
    jr jr_000_1bb1                                ; $1B6F

jr_000_1b71:
    cp $03                                        ; $1B71
    jr nz, jr_000_1b81                            ; $1B73

    ld a, $cf                                     ; $1B75
    ld [$990e], a                                 ; $1B77
    ld a, $cb                                     ; $1B7A
    ld [$990f], a                                 ; $1B7C
    jr jr_000_1bb1                                ; $1B7F

jr_000_1b81:
    cp $04                                        ; $1B81
    jr nz, jr_000_1b91                            ; $1B83

    ld a, $ce                                     ; $1B85
    ld [$990e], a                                 ; $1B87
    ld a, $c7                                     ; $1B8A
    ld [$990f], a                                 ; $1B8C
    jr jr_000_1bb1                                ; $1B8F

jr_000_1b91:
    cp $05                                        ; $1B91
    jr nz, jr_000_1ba1                            ; $1B93

    ld a, $cf                                     ; $1B95
    ld [$994e], a                                 ; $1B97
    ld a, $cb                                     ; $1B9A
    ld [$994f], a                                 ; $1B9C
    jr jr_000_1bb1                                ; $1B9F

jr_000_1ba1:
    cp $06                                        ; $1BA1
    jr nz, jr_000_1bb1                            ; $1BA3

    ld a, $ce                                     ; $1BA5
    ld [$994e], a                                 ; $1BA7
    ld a, $c7                                     ; $1BAA
    ld [$994f], a                                 ; $1BAC
    jr jr_000_1bb1                                ; $1BAF

jr_000_1bb1:
    ret                                           ; $1BB1


; C: developers' name: same code as MK_PIC_SAVE in the old build of table 2A at old 1B84 and 35 at old 2780 (24 bytes,
; masked match)
MK_PIC_SAVE::
    ld a, SEQ_PIC_SAVE                            ; $1BB2
    ld [wGAME_SEQ], a                             ; $1BB4
    call DMACLR                                   ; $1BB7
    ld hl, SAVE_SURU                              ; $1BBA
    ld de, wOBJRAM                                ; $1BBD
    ld bc, $0028                                  ; $1BC0
    call DATA_MOV                                 ; $1BC3
    xor a                                         ; $1BC6
    ld [wSAVE_FLAG], a                            ; $1BC7

; C: developers' name: same code as PIC_SAVE in the old build of table 2A at old 1B9C and 35 at old 2798 (220 bytes,
; masked match)
PIC_SAVE::
    ld a, [wSAVE_FLAG]                            ; $1BCA
    or a                                          ; $1BCD
    jr z, jr_000_1bda                             ; $1BCE

    cp $01                                        ; $1BD0
    jr z, jr_000_1c31                             ; $1BD2

    cp $02                                        ; $1BD4
    jp z, Jump_000_1c9b                           ; $1BD6

    ret                                           ; $1BD9


jr_000_1bda:
    ldh a, [hTRG1]                                ; $1BDA
    srl a                                         ; $1BDC
    jr c, jr_000_1bf1                             ; $1BDE

    srl a                                         ; $1BE0
    jr c, jr_000_1c13                             ; $1BE2

    srl a                                         ; $1BE4
    srl a                                         ; $1BE6
    srl a                                         ; $1BE8
    jr c, jr_000_1c17                             ; $1BEA

    srl a                                         ; $1BEC
    jr c, jr_000_1c24                             ; $1BEE

    ret                                           ; $1BF0


jr_000_1bf1:
    ld a, [wPIC_SAVE_C01A]                        ; $1BF1
    cp $36                                        ; $1BF4
    jr nz, jr_000_1c13                            ; $1BF6

    call DMACLR                                   ; $1BF8
    ld hl, NANBANNI                               ; $1BFB
    ld de, wOBJRAM                                ; $1BFE
    ld bc, $0014                                  ; $1C01
    call DATA_MOV                                 ; $1C04
    ld a, [wPICT_NUM]                             ; $1C07
    call PUT_BYTE_OBJ2                            ; $1C0A
    ld a, $01                                     ; $1C0D
    ld [wSAVE_FLAG], a                            ; $1C0F
    ret                                           ; $1C12


jr_000_1c13:
    call MAKE_MOVIE                               ; $1C13
    ret                                           ; $1C16


jr_000_1c17:
    ld hl, SAVE_NO                                ; $1C17
    ld de, wPIC_SAVE_C018                         ; $1C1A
    ld bc, $0010                                  ; $1C1D
    call DATA_MOV                                 ; $1C20
    ret                                           ; $1C23


jr_000_1c24:
    ld hl, SAVE_YES                               ; $1C24
    ld de, wPIC_SAVE_C018                         ; $1C27
    ld bc, $0010                                  ; $1C2A
    call DATA_MOV                                 ; $1C2D
    ret                                           ; $1C30


jr_000_1c31:
    ldh a, [hTRG1]                                ; $1C31
    srl a                                         ; $1C33
    jr c, jr_000_1c4c                             ; $1C35

    srl a                                         ; $1C37
    jr c, jr_000_1c75                             ; $1C39

    srl a                                         ; $1C3B
    srl a                                         ; $1C3D
    srl a                                         ; $1C3F
    srl a                                         ; $1C41
    srl a                                         ; $1C43
    jr c, jr_000_1c79                             ; $1C45

    srl a                                         ; $1C47
    jr c, jr_000_1c8a                             ; $1C49

    ret                                           ; $1C4B


jr_000_1c4c:
    call PICT_SAVE_GO                             ; $1C4C
    call DMACLR                                   ; $1C4F
    ld hl, SAVESIMASITA                           ; $1C52
    ld de, wOBJRAM                                ; $1C55
    ld bc, $0018                                  ; $1C58
    call DATA_MOV                                 ; $1C5B
    ld a, $02                                     ; $1C5E
    ld [wSAVE_FLAG], a                            ; $1C60
    ld a, $30                                     ; $1C63
    ldh [hR0], a                                  ; $1C65
    ld a, [wPICT_NUM]                             ; $1C67
    inc a                                         ; $1C6A
    cp $1e                                        ; $1C6B
    jr nz, jr_000_1c71                            ; $1C6D

    ld a, $00                                     ; $1C6F

jr_000_1c71:
    ld [wPICT_NUM], a                             ; $1C71
    ret                                           ; $1C74


jr_000_1c75:
    call MAKE_MOVIE                               ; $1C75
    ret                                           ; $1C78


jr_000_1c79:
    ld a, [wPICT_NUM]                             ; $1C79
    cp $1d                                        ; $1C7C
    jr nz, jr_000_1c82                            ; $1C7E

    ld a, $ff                                     ; $1C80

jr_000_1c82:
    inc a                                         ; $1C82
    ld [wPICT_NUM], a                             ; $1C83
    call PUT_BYTE_OBJ2                            ; $1C86
    ret                                           ; $1C89


jr_000_1c8a:
    ld a, [wPICT_NUM]                             ; $1C8A
    cp $00                                        ; $1C8D
    jr nz, jr_000_1c93                            ; $1C8F

    ld a, $1e                                     ; $1C91

jr_000_1c93:
    dec a                                         ; $1C93
    ld [wPICT_NUM], a                             ; $1C94
    call PUT_BYTE_OBJ2                            ; $1C97
    ret                                           ; $1C9A


Jump_000_1c9b:
    ldh a, [hR0]                                  ; $1C9B
    dec a                                         ; $1C9D
    ldh [hR0], a                                  ; $1C9E
    or a                                          ; $1CA0
    ret nz                                        ; $1CA1

    call MAKE_MOVIE                               ; $1CA2
    ret                                           ; $1CA5


; C: developers' name: same code as PICT_SAVE_GO in the old build of table 2A at old 1C78 and 35 at old 2874 (38
; bytes, masked match)
PICT_SAVE_GO::
    ld hl, wB_ADR                                 ; $1CA6
    ld de, $a000                                  ; $1CA9
    ld bc, $1000                                  ; $1CAC
    ld a, [wPICT_NUM]                             ; $1CAF
    srl a                                         ; $1CB2
    jr nc, jr_000_1cb9                            ; $1CB4

    ld de, $b000                                  ; $1CB6

jr_000_1cb9:
    add $01                                       ; $1CB9
    ld [rRAMB], a                                 ; $1CBB
    ld a, $0a                                     ; $1CBE
    ld [rRAMG], a                                 ; $1CC0
    call Copy_Pages                               ; $1CC3
    ld a, $00                                     ; $1CC6
    ld [rRAMG], a                                 ; $1CC8
    ret                                           ; $1CCB


; C: developers' name: same code as PUT_BYTE_OBJ2 in the old build of table 2A at old 1C9E and 35 at old 289A (49
; bytes, exact match)
PUT_BYTE_OBJ2::
    ld c, a                                       ; $1CCC
    xor a                                         ; $1CCD
    ld b, a                                       ; $1CCE
    ld a, c                                       ; $1CCF
    or a                                          ; $1CD0
    jr z, jr_000_1cde                             ; $1CD1

    xor a                                         ; $1CD3

jr_000_1cd4:
    inc a                                         ; $1CD4
    cp $0a                                        ; $1CD5
    jr nz, jr_000_1cdb                            ; $1CD7

    inc b                                         ; $1CD9
    xor a                                         ; $1CDA

jr_000_1cdb:
    dec c                                         ; $1CDB
    jr nz, jr_000_1cd4                            ; $1CDC

jr_000_1cde:
    ldh [hR0], a                                  ; $1CDE
    ld a, b                                       ; $1CE0
    ldh [hR1], a                                  ; $1CE1
    ld hl, wPUT_BYTE_OBJ2_C014                    ; $1CE3
    ld a, $96                                     ; $1CE6
    ld [hl+], a                                   ; $1CE8
    ld a, $70                                     ; $1CE9
    ld [hl+], a                                   ; $1CEB
    ldh a, [hR1]                                  ; $1CEC
    ld [hl+], a                                   ; $1CEE
    xor a                                         ; $1CEF
    ld [hl+], a                                   ; $1CF0
    ld a, $96                                     ; $1CF1
    ld [hl+], a                                   ; $1CF3
    ld a, $78                                     ; $1CF4
    ld [hl+], a                                   ; $1CF6
    ldh a, [hR0]                                  ; $1CF7
    ld [hl+], a                                   ; $1CF9
    xor a                                         ; $1CFA
    ld [hl+], a                                   ; $1CFB
    ret                                           ; $1CFC


; C: developers' name: the same bytes as the data label SAVE_SURU in the old build of table 2A at old 1CCF and 35 at
; old 28CB (24 bytes, data match)
SAVE_SURU::
    db $96, $38, $30, $00, $96, $40, $31, $00, $96, $48, $32, $00, $96, $50, $33, $00
    db $96, $58, $34, $00, $96, $60, $35, $00

; C: developers' name: the same bytes as the data label SAVE_YES in the old build of table 2A at old 1CE7 and 35 at
; old 28E3 (16 bytes, data match)
SAVE_YES::
    db $96, $68, $36, $00, $96, $70, $37, $00, $96, $78, $38, $00, $96, $80, $39, $00

; C: developers' name: the same bytes as the data label SAVE_NO in the old build of table 2A at old 1CF7 and 35 at old
; 28F3 (16 bytes, data match)
SAVE_NO::
    db $96, $68, $3a, $00, $96, $70, $3b, $00, $96, $78, $3c, $00, $96, $80, $3d, $00

; C: developers' name: the same bytes as the data label NANBANNI in the old build of table 2A at old 1D07 and 35 at
; old 2903 (20 bytes, data match)
NANBANNI::
    db $96, $40, $40, $00, $96, $48, $41, $00, $96, $50, $42, $00, $96, $58, $43, $00
    db $96, $60, $44, $00

; C: developers' name: the same bytes as the data label SAVESIMASITA in the old build of table 2A at old 1D1B and 35
; at old 2917 (24 bytes, data match)
SAVESIMASITA::
    db $96, $40, $45, $00, $96, $48, $46, $00, $96, $50, $47, $00, $96, $58, $48, $00
    db $96, $60, $49, $00, $96, $68, $4a, $00

; C: developers' name: same code as MAKE_GALLERY in the old build of table 2A at old 1D33 and 35 at old 292F (124
; bytes, masked match)
MAKE_GALLERY::
    call LCDCOFF                                  ; $1D61
    call VRAM_CLR                                 ; $1D64
    call DMACLR                                   ; $1D67
    ldh a, [hBANK_BUF]                            ; $1D6A
    push af                                       ; $1D6C
    ld a, $03                                     ; $1D6D
    ldh [hBANK_BUF], a                            ; $1D6F
    ld [$2100], a                                 ; $1D71
    ld hl, Gfx_03_4001_FNTOOE3                    ; $1D74
    ld de, $8000                                  ; $1D77
    ld bc, $1800                                  ; $1D7A
    call DATA_MOV                                 ; $1D7D
    ld hl, Map_03_5801_BG_MOVIE                   ; $1D80
    ld de, $9800                                  ; $1D83
    ld bc, $0240                                  ; $1D86
    call DATA_MOV                                 ; $1D89
    ld hl, $a000                                  ; $1D8C
    ld a, [wPICT_NUM]                             ; $1D8F
    or a                                          ; $1D92
    jr nz, jr_000_1d97                            ; $1D93

    ld a, $1e                                     ; $1D95

jr_000_1d97:
    dec a                                         ; $1D97
    ld [wPICT_NUM], a                             ; $1D98
    srl a                                         ; $1D9B
    jr nc, jr_000_1da2                            ; $1D9D

    ld hl, $b000                                  ; $1D9F

jr_000_1da2:
    add $01                                       ; $1DA2
    ld [rRAMB], a                                 ; $1DA4
    ld de, $8800                                  ; $1DA7
    ld bc, $0e00                                  ; $1DAA
    call DATA_MOV                                 ; $1DAD
    call GALLERY_OBJ_SET                          ; $1DB0
    pop af                                        ; $1DB3
    ldh [hBANK_BUF], a                            ; $1DB4
    ld [$2100], a                                 ; $1DB6
    call SCYX_SET0                                ; $1DB9
    call OBJP_DEF_SET                             ; $1DBC
    call Bgp_SetDefault                           ; $1DBF
    ld a, $01                                     ; $1DC2
    ld [wDRAWING_F], a                            ; $1DC4
    ld a, $01                                     ; $1DC7
    ldh [rIE], a                                  ; $1DC9
    xor a                                         ; $1DCB
    ld [wHBLANK_F], a                             ; $1DCC
    ld a, $08                                     ; $1DCF
    ldh [rSTAT], a                                ; $1DD1
    ld a, SEQ_GALLERY                             ; $1DD3
    ld [wGAME_SEQ], a                             ; $1DD5
    ld a, $c3                                     ; $1DD8
    ldh [rLCDC], a                                ; $1DDA
    ret                                           ; $1DDC


; C: GAME_SEQ $0D handler of MAIN_SUB; GALLERY in BGB (menu entry 5 -> GAME_SEQ $0D, port/menu_paths_proto.csv)
Seq0D_GalleryMain::
    ld a, [wPP_FLAG]                              ; $1DDD
    or a                                          ; $1DE0
    jr nz, PUT_PICTURE                            ; $1DE1

    ldh a, [hTRG1]                                ; $1DE3
    sra a                                         ; $1DE5
    jr c, jr_000_1e02                             ; $1DE7

    ldh a, [hCNT1]                                ; $1DE9
    sra a                                         ; $1DEB
    sra a                                         ; $1DED
    jr c, jr_000_1e03                             ; $1DEF

    sra a                                         ; $1DF1
    sra a                                         ; $1DF3
    sra a                                         ; $1DF5
    sra a                                         ; $1DF7
    sra a                                         ; $1DF9
    jr c, jr_000_1e18                             ; $1DFB

    sra a                                         ; $1DFD
    jr c, jr_000_1e26                             ; $1DFF

    ret                                           ; $1E01


jr_000_1e02:
    ret                                           ; $1E02


jr_000_1e03:
    ld a, [wPICT_NUM]                             ; $1E03
    inc a                                         ; $1E06
    cp $1e                                        ; $1E07
    jr nz, jr_000_1e0c                            ; $1E09

    xor a                                         ; $1E0B

jr_000_1e0c:
    ld [wPICT_NUM], a                             ; $1E0C
    ld a, $04                                     ; $1E0F
    ld [wINF_CUR], a                              ; $1E11
    call MAKE_MENU                                ; $1E14
    ret                                           ; $1E17


jr_000_1e18:
    ld a, [wPICT_NUM]                             ; $1E18
    inc a                                         ; $1E1B
    cp $1e                                        ; $1E1C
    jr nz, jr_000_1e21                            ; $1E1E

    xor a                                         ; $1E20

jr_000_1e21:
    ld [wPICT_NUM], a                             ; $1E21
    jr jr_000_1e35                                ; $1E24

jr_000_1e26:
    ld a, [wPICT_NUM]                             ; $1E26
    dec a                                         ; $1E29
    cp $ff                                        ; $1E2A
    jr nz, jr_000_1e30                            ; $1E2C

    ld a, $1d                                     ; $1E2E

jr_000_1e30:
    ld [wPICT_NUM], a                             ; $1E30
    jr jr_000_1e35                                ; $1E33

jr_000_1e35:
    call GALLERY_OBJ_SET                          ; $1E35
    ld hl, wVRAM_ADD_L                            ; $1E38
    xor a                                         ; $1E3B
    ld [hl+], a                                   ; $1E3C
    ld a, $88                                     ; $1E3D
    ld [hl], a                                    ; $1E3F
    ld d, $a0                                     ; $1E40
    ld a, [wPICT_NUM]                             ; $1E42
    srl a                                         ; $1E45
    jr nc, jr_000_1e4b                            ; $1E47

    ld d, $b0                                     ; $1E49

jr_000_1e4b:
    add $01                                       ; $1E4B
    ld [rRAMB], a                                 ; $1E4D
    ld hl, wIMMAGE_ADD_L                          ; $1E50
    xor a                                         ; $1E53
    ld [hl+], a                                   ; $1E54
    ld a, d                                       ; $1E55
    ld [hl+], a                                   ; $1E56
    ld a, $01                                     ; $1E57
    ld [wPP_FLAG], a                              ; $1E59
    ret                                           ; $1E5C


; I: developers' name: same code as PUT_PICTURE in the old build of table 2A at old 1E32 and 35 at old 2A2E (15 bytes,
; masked match)
PUT_PICTURE::
    ld a, [wVRAM_ADD_H]                           ; $1E5D
    sub $96                                       ; $1E60
    jr nc, jr_000_1e68                            ; $1E62

    call H_BLANK_TX2                              ; $1E64
    ret                                           ; $1E67


jr_000_1e68:
    xor a                                         ; $1E68
    ld [wPP_FLAG], a                              ; $1E69
    ret                                           ; $1E6C


; C: developers' name: same code as H_BLANK_TX2 in the old build of table 2A at old 1E42 and 35 at old 2A3E (84 bytes,
; masked match)
H_BLANK_TX2::
    di                                            ; $1E6D
    ld a, $80                                     ; $1E6E
    ldh [hR0], a                                  ; $1E70
    ld a, $10                                     ; $1E72

Jump_000_1e74:
    dec a                                         ; $1E74
    jp nz, Jump_000_1e74                          ; $1E75

    ld a, $02                                     ; $1E78
    ldh [rIE], a                                  ; $1E7A

jr_000_1e7c:
    ld a, [wIMMAGE_ADD_H]                         ; $1E7C
    ld h, a                                       ; $1E7F
    ld a, [wIMMAGE_ADD_L]                         ; $1E80
    ld l, a                                       ; $1E83
    ld a, [hl+]                                   ; $1E84
    ld b, a                                       ; $1E85
    ld a, [hl+]                                   ; $1E86
    ld c, a                                       ; $1E87
    ld a, [hl+]                                   ; $1E88
    ld d, a                                       ; $1E89
    ld a, [hl+]                                   ; $1E8A
    ld e, a                                       ; $1E8B
    ld a, h                                       ; $1E8C
    ld [wIMMAGE_ADD_H], a                         ; $1E8D
    ld a, l                                       ; $1E90
    ld [wIMMAGE_ADD_L], a                         ; $1E91
    ld a, [wVRAM_ADD_H]                           ; $1E94
    ld h, a                                       ; $1E97
    ld a, [wVRAM_ADD_L]                           ; $1E98
    ld l, a                                       ; $1E9B
    ei                                            ; $1E9C

jr_000_1e9d:
    ld a, [wHBLANK_F]                             ; $1E9D
    and a                                         ; $1EA0
    jr z, jr_000_1e9d                             ; $1EA1

    di                                            ; $1EA3
    xor a                                         ; $1EA4
    ld [wHBLANK_F], a                             ; $1EA5
    ld a, h                                       ; $1EA8
    ld [wVRAM_ADD_H], a                           ; $1EA9
    ld a, l                                       ; $1EAC
    ld [wVRAM_ADD_L], a                           ; $1EAD
    ldh a, [hR0]                                  ; $1EB0
    dec a                                         ; $1EB2
    ldh [hR0], a                                  ; $1EB3
    jr nz, jr_000_1e7c                            ; $1EB5

    ld a, $01                                     ; $1EB7
    ldh [rIE], a                                  ; $1EB9
    ei                                            ; $1EBB
    ldh a, [rLY]                                  ; $1EBC
    ldh [hR3], a                                  ; $1EBE
    ret                                           ; $1EC0


; C: developers' name: same code as GALLERY_OBJ_SET in the old build of table 2A at old 1E96 and 35 at old 2A92 (53
; bytes, exact match)
GALLERY_OBJ_SET::
    ld a, [wPICT_NUM]                             ; $1EC1
    ld c, a                                       ; $1EC4
    xor a                                         ; $1EC5
    ld b, a                                       ; $1EC6
    ld a, c                                       ; $1EC7
    or a                                          ; $1EC8
    jr z, jr_000_1ed6                             ; $1EC9

    xor a                                         ; $1ECB

jr_000_1ecc:
    inc a                                         ; $1ECC
    cp $0a                                        ; $1ECD
    jr nz, jr_000_1ed3                            ; $1ECF

    inc b                                         ; $1ED1
    xor a                                         ; $1ED2

jr_000_1ed3:
    dec c                                         ; $1ED3
    jr nz, jr_000_1ecc                            ; $1ED4

jr_000_1ed6:
    ldh [hR0], a                                  ; $1ED6
    ld a, b                                       ; $1ED8
    ldh [hR1], a                                  ; $1ED9
    ld b, a                                       ; $1EDB
    ld hl, wOBJRAM                                ; $1EDC
    ld a, $10                                     ; $1EDF
    ld [hl+], a                                   ; $1EE1
    ld a, $30                                     ; $1EE2
    ld [hl+], a                                   ; $1EE4
    ldh a, [hR1]                                  ; $1EE5
    ld [hl+], a                                   ; $1EE7
    xor a                                         ; $1EE8
    ld [hl+], a                                   ; $1EE9
    ld a, $10                                     ; $1EEA
    ld [hl+], a                                   ; $1EEC
    ld a, $38                                     ; $1EED
    ld [hl+], a                                   ; $1EEF
    ldh a, [hR0]                                  ; $1EF0
    ld [hl+], a                                   ; $1EF2
    xor a                                         ; $1EF3
    ld [hl+], a                                   ; $1EF4
    ret                                           ; $1EF5


; C: call $FFB6 (the OAM DMA stub Data_00_0317 copied to HRAM); ret
OamDma_Run::
    call $ffb6                                    ; $1EF6
    ret                                           ; $1EF9


; I: leftover: 248 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_1EFA::
    db $fa, $c7, $c0, $67, $fa, $c6, $c0, $6f, $fa, $c5, $c0, $47, $fa, $c4, $c0, $4f
    db $3e, $00, $57, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a
    db $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c
    db $2a, $02, $0c, $79, $82, $20, $01, $04, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c
    db $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a
    db $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $79, $82, $20, $01, $04, $2a, $02, $0c
    db $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a
    db $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $79, $82, $20
    db $01, $04, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02
    db $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c
    db $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a, $02, $0c, $2a
    db $02, $0c, $79, $82, $20, $01, $04, $78, $ea, $c5, $c0, $79, $ea, $c4, $c0, $7c
    db $ea, $c7, $c0, $7d, $ea, $c6, $c0, $c9

; C: entry 0 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode00::
    ld hl, $a100                                  ; $1FF2
    ld de, wB_ADR                                 ; $1FF5
    ld b, $0e                                     ; $1FF8
    call Copy_Pages                               ; $1FFA
    ret                                           ; $1FFD


; C: entry 1 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode01::
    ld hl, $a180                                  ; $1FFE
    ld de, wImageCopy_Mode01_D080                 ; $2001
    ld b, $42                                     ; $2004
    ld a, $0e                                     ; $2006
    ldh [hR0], a                                  ; $2008

Jump_000_200a:
    ld a, $08                                     ; $200A
    ldh [hR1], a                                  ; $200C

Jump_000_200e:
    ld a, [hl+]                                   ; $200E
    ld [de], a                                    ; $200F
    ld c, a                                       ; $2010
    ld a, [bc]                                    ; $2011
    ld c, a                                       ; $2012
    ld a, e                                       ; $2013
    xor $f0                                       ; $2014
    ld e, a                                       ; $2016
    ld a, c                                       ; $2017
    ld [de], a                                    ; $2018
    inc e                                         ; $2019
    ld a, [hl+]                                   ; $201A
    ld c, a                                       ; $201B
    ld a, [bc]                                    ; $201C
    ld [de], a                                    ; $201D
    ld a, e                                       ; $201E
    xor $f0                                       ; $201F
    ld e, a                                       ; $2021
    ld a, c                                       ; $2022
    ld [de], a                                    ; $2023
    inc e                                         ; $2024
    ld a, [hl+]                                   ; $2025
    ld [de], a                                    ; $2026
    ld c, a                                       ; $2027
    ld a, [bc]                                    ; $2028
    ld c, a                                       ; $2029
    ld a, e                                       ; $202A
    xor $f0                                       ; $202B
    ld e, a                                       ; $202D
    ld a, c                                       ; $202E
    ld [de], a                                    ; $202F
    inc e                                         ; $2030
    ld a, [hl+]                                   ; $2031
    ld c, a                                       ; $2032
    ld a, [bc]                                    ; $2033
    ld [de], a                                    ; $2034
    ld a, e                                       ; $2035
    xor $f0                                       ; $2036
    ld e, a                                       ; $2038
    ld a, c                                       ; $2039
    ld [de], a                                    ; $203A
    inc e                                         ; $203B
    ld a, [hl+]                                   ; $203C
    ld [de], a                                    ; $203D
    ld c, a                                       ; $203E
    ld a, [bc]                                    ; $203F
    ld c, a                                       ; $2040
    ld a, e                                       ; $2041
    xor $f0                                       ; $2042
    ld e, a                                       ; $2044
    ld a, c                                       ; $2045
    ld [de], a                                    ; $2046
    inc e                                         ; $2047
    ld a, [hl+]                                   ; $2048
    ld c, a                                       ; $2049
    ld a, [bc]                                    ; $204A
    ld [de], a                                    ; $204B
    ld a, e                                       ; $204C
    xor $f0                                       ; $204D
    ld e, a                                       ; $204F
    ld a, c                                       ; $2050
    ld [de], a                                    ; $2051
    inc e                                         ; $2052
    ld a, [hl+]                                   ; $2053
    ld [de], a                                    ; $2054
    ld c, a                                       ; $2055
    ld a, [bc]                                    ; $2056
    ld c, a                                       ; $2057
    ld a, e                                       ; $2058
    xor $f0                                       ; $2059
    ld e, a                                       ; $205B
    ld a, c                                       ; $205C
    ld [de], a                                    ; $205D
    inc e                                         ; $205E
    ld a, [hl+]                                   ; $205F
    ld c, a                                       ; $2060
    ld a, [bc]                                    ; $2061
    ld [de], a                                    ; $2062
    ld a, e                                       ; $2063
    xor $f0                                       ; $2064
    ld e, a                                       ; $2066
    ld a, c                                       ; $2067
    ld [de], a                                    ; $2068
    inc e                                         ; $2069
    ld a, [hl+]                                   ; $206A
    ld [de], a                                    ; $206B
    ld c, a                                       ; $206C
    ld a, [bc]                                    ; $206D
    ld c, a                                       ; $206E
    ld a, e                                       ; $206F
    xor $f0                                       ; $2070
    ld e, a                                       ; $2072
    ld a, c                                       ; $2073
    ld [de], a                                    ; $2074
    inc e                                         ; $2075
    ld a, [hl+]                                   ; $2076
    ld c, a                                       ; $2077
    ld a, [bc]                                    ; $2078
    ld [de], a                                    ; $2079
    ld a, e                                       ; $207A
    xor $f0                                       ; $207B
    ld e, a                                       ; $207D
    ld a, c                                       ; $207E
    ld [de], a                                    ; $207F
    inc e                                         ; $2080
    ld a, [hl+]                                   ; $2081
    ld [de], a                                    ; $2082
    ld c, a                                       ; $2083
    ld a, [bc]                                    ; $2084
    ld c, a                                       ; $2085
    ld a, e                                       ; $2086
    xor $f0                                       ; $2087
    ld e, a                                       ; $2089
    ld a, c                                       ; $208A
    ld [de], a                                    ; $208B
    inc e                                         ; $208C
    ld a, [hl+]                                   ; $208D
    ld c, a                                       ; $208E
    ld a, [bc]                                    ; $208F
    ld [de], a                                    ; $2090
    ld a, e                                       ; $2091
    xor $f0                                       ; $2092
    ld e, a                                       ; $2094
    ld a, c                                       ; $2095
    ld [de], a                                    ; $2096
    inc e                                         ; $2097
    ld a, [hl+]                                   ; $2098
    ld [de], a                                    ; $2099
    ld c, a                                       ; $209A
    ld a, [bc]                                    ; $209B
    ld c, a                                       ; $209C
    ld a, e                                       ; $209D
    xor $f0                                       ; $209E
    ld e, a                                       ; $20A0
    ld a, c                                       ; $20A1
    ld [de], a                                    ; $20A2
    inc e                                         ; $20A3
    ld a, [hl+]                                   ; $20A4
    ld c, a                                       ; $20A5
    ld a, [bc]                                    ; $20A6
    ld [de], a                                    ; $20A7
    ld a, e                                       ; $20A8
    xor $f0                                       ; $20A9
    ld e, a                                       ; $20AB
    ld a, c                                       ; $20AC
    ld [de], a                                    ; $20AD
    inc e                                         ; $20AE
    ld a, [hl+]                                   ; $20AF
    ld [de], a                                    ; $20B0
    ld c, a                                       ; $20B1
    ld a, [bc]                                    ; $20B2
    ld c, a                                       ; $20B3
    ld a, e                                       ; $20B4
    xor $f0                                       ; $20B5
    ld e, a                                       ; $20B7
    ld a, c                                       ; $20B8
    ld [de], a                                    ; $20B9
    inc e                                         ; $20BA
    ld a, [hl+]                                   ; $20BB
    ld c, a                                       ; $20BC
    ld a, [bc]                                    ; $20BD
    ld [de], a                                    ; $20BE
    ld a, e                                       ; $20BF
    xor $f0                                       ; $20C0
    ld e, a                                       ; $20C2
    ld a, c                                       ; $20C3
    ld [de], a                                    ; $20C4
    inc e                                         ; $20C5
    ldh a, [hR1]                                  ; $20C6
    dec a                                         ; $20C8
    jr z, jr_000_20d0                             ; $20C9

    ldh [hR1], a                                  ; $20CB
    jp Jump_000_200e                              ; $20CD


jr_000_20d0:
    ldh a, [hR0]                                  ; $20D0
    dec a                                         ; $20D2
    ret z                                         ; $20D3

    ldh [hR0], a                                  ; $20D4
    ld e, $80                                     ; $20D6
    inc d                                         ; $20D8
    ld l, $80                                     ; $20D9
    jp Jump_000_200a                              ; $20DB


; C: entry 2 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode02::
    ld hl, $a100                                  ; $20DE
    ld de, wB_ADR                                 ; $20E1
    ld b, $42                                     ; $20E4
    ld a, $0e                                     ; $20E6
    ldh [hR0], a                                  ; $20E8

Jump_000_20ea:
    ld a, $08                                     ; $20EA
    ldh [hR1], a                                  ; $20EC

Jump_000_20ee:
    ld a, [hl+]                                   ; $20EE
    ld [de], a                                    ; $20EF
    ld c, a                                       ; $20F0
    ld a, [bc]                                    ; $20F1
    ld c, a                                       ; $20F2
    ld a, e                                       ; $20F3
    xor $f0                                       ; $20F4
    ld e, a                                       ; $20F6
    ld a, c                                       ; $20F7
    ld [de], a                                    ; $20F8
    inc e                                         ; $20F9
    ld a, [hl+]                                   ; $20FA
    ld c, a                                       ; $20FB
    ld a, [bc]                                    ; $20FC
    ld [de], a                                    ; $20FD
    ld a, e                                       ; $20FE
    xor $f0                                       ; $20FF
    ld e, a                                       ; $2101
    ld a, c                                       ; $2102
    ld [de], a                                    ; $2103
    inc e                                         ; $2104
    ld a, [hl+]                                   ; $2105
    ld [de], a                                    ; $2106
    ld c, a                                       ; $2107
    ld a, [bc]                                    ; $2108
    ld c, a                                       ; $2109
    ld a, e                                       ; $210A
    xor $f0                                       ; $210B
    ld e, a                                       ; $210D
    ld a, c                                       ; $210E
    ld [de], a                                    ; $210F
    inc e                                         ; $2110
    ld a, [hl+]                                   ; $2111
    ld c, a                                       ; $2112
    ld a, [bc]                                    ; $2113
    ld [de], a                                    ; $2114
    ld a, e                                       ; $2115
    xor $f0                                       ; $2116
    ld e, a                                       ; $2118
    ld a, c                                       ; $2119
    ld [de], a                                    ; $211A
    inc e                                         ; $211B
    ld a, [hl+]                                   ; $211C
    ld [de], a                                    ; $211D
    ld c, a                                       ; $211E
    ld a, [bc]                                    ; $211F
    ld c, a                                       ; $2120
    ld a, e                                       ; $2121
    xor $f0                                       ; $2122
    ld e, a                                       ; $2124
    ld a, c                                       ; $2125
    ld [de], a                                    ; $2126
    inc e                                         ; $2127
    ld a, [hl+]                                   ; $2128
    ld c, a                                       ; $2129
    ld a, [bc]                                    ; $212A
    ld [de], a                                    ; $212B
    ld a, e                                       ; $212C
    xor $f0                                       ; $212D
    ld e, a                                       ; $212F
    ld a, c                                       ; $2130
    ld [de], a                                    ; $2131
    inc e                                         ; $2132
    ld a, [hl+]                                   ; $2133
    ld [de], a                                    ; $2134
    ld c, a                                       ; $2135
    ld a, [bc]                                    ; $2136
    ld c, a                                       ; $2137
    ld a, e                                       ; $2138
    xor $f0                                       ; $2139
    ld e, a                                       ; $213B
    ld a, c                                       ; $213C
    ld [de], a                                    ; $213D
    inc e                                         ; $213E
    ld a, [hl+]                                   ; $213F
    ld c, a                                       ; $2140
    ld a, [bc]                                    ; $2141
    ld [de], a                                    ; $2142
    ld a, e                                       ; $2143
    xor $f0                                       ; $2144
    ld e, a                                       ; $2146
    ld a, c                                       ; $2147
    ld [de], a                                    ; $2148
    inc e                                         ; $2149
    ld a, [hl+]                                   ; $214A
    ld [de], a                                    ; $214B
    ld c, a                                       ; $214C
    ld a, [bc]                                    ; $214D
    ld c, a                                       ; $214E
    ld a, e                                       ; $214F
    xor $f0                                       ; $2150
    ld e, a                                       ; $2152
    ld a, c                                       ; $2153
    ld [de], a                                    ; $2154
    inc e                                         ; $2155
    ld a, [hl+]                                   ; $2156
    ld c, a                                       ; $2157
    ld a, [bc]                                    ; $2158
    ld [de], a                                    ; $2159
    ld a, e                                       ; $215A
    xor $f0                                       ; $215B
    ld e, a                                       ; $215D
    ld a, c                                       ; $215E
    ld [de], a                                    ; $215F
    inc e                                         ; $2160
    ld a, [hl+]                                   ; $2161
    ld [de], a                                    ; $2162
    ld c, a                                       ; $2163
    ld a, [bc]                                    ; $2164
    ld c, a                                       ; $2165
    ld a, e                                       ; $2166
    xor $f0                                       ; $2167
    ld e, a                                       ; $2169
    ld a, c                                       ; $216A
    ld [de], a                                    ; $216B
    inc e                                         ; $216C
    ld a, [hl+]                                   ; $216D
    ld c, a                                       ; $216E
    ld a, [bc]                                    ; $216F
    ld [de], a                                    ; $2170
    ld a, e                                       ; $2171
    xor $f0                                       ; $2172
    ld e, a                                       ; $2174
    ld a, c                                       ; $2175
    ld [de], a                                    ; $2176
    inc e                                         ; $2177
    ld a, [hl+]                                   ; $2178
    ld [de], a                                    ; $2179
    ld c, a                                       ; $217A
    ld a, [bc]                                    ; $217B
    ld c, a                                       ; $217C
    ld a, e                                       ; $217D
    xor $f0                                       ; $217E
    ld e, a                                       ; $2180
    ld a, c                                       ; $2181
    ld [de], a                                    ; $2182
    inc e                                         ; $2183
    ld a, [hl+]                                   ; $2184
    ld c, a                                       ; $2185
    ld a, [bc]                                    ; $2186
    ld [de], a                                    ; $2187
    ld a, e                                       ; $2188
    xor $f0                                       ; $2189
    ld e, a                                       ; $218B
    ld a, c                                       ; $218C
    ld [de], a                                    ; $218D
    inc e                                         ; $218E
    ld a, [hl+]                                   ; $218F
    ld [de], a                                    ; $2190
    ld c, a                                       ; $2191
    ld a, [bc]                                    ; $2192
    ld c, a                                       ; $2193
    ld a, e                                       ; $2194
    xor $f0                                       ; $2195
    ld e, a                                       ; $2197
    ld a, c                                       ; $2198
    ld [de], a                                    ; $2199
    inc e                                         ; $219A
    ld a, [hl+]                                   ; $219B
    ld c, a                                       ; $219C
    ld a, [bc]                                    ; $219D
    ld [de], a                                    ; $219E
    ld a, e                                       ; $219F
    xor $f0                                       ; $21A0
    ld e, a                                       ; $21A2
    ld a, c                                       ; $21A3
    ld [de], a                                    ; $21A4
    inc e                                         ; $21A5
    ldh a, [hR1]                                  ; $21A6
    dec a                                         ; $21A8
    jr z, jr_000_21b0                             ; $21A9

    ldh [hR1], a                                  ; $21AB
    jp Jump_000_20ee                              ; $21AD


jr_000_21b0:
    ldh a, [hR0]                                  ; $21B0
    dec a                                         ; $21B2
    ret z                                         ; $21B3

    ldh [hR0], a                                  ; $21B4
    ld e, $00                                     ; $21B6
    inc d                                         ; $21B8
    ld l, $00                                     ; $21B9
    inc h                                         ; $21BB
    jp Jump_000_20ea                              ; $21BC


; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_21BF::
    db $c9

; C: entry 3 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode03::
    ld hl, $a800                                  ; $21C0
    ld de, wImageCopy_Mode03_D700                 ; $21C3
    ld bc, wImageCopy_Mode03_D60E                 ; $21C6
    ld a, $07                                     ; $21C9
    ldh [hR0], a                                  ; $21CB

Jump_000_21cd:
    ld a, $10                                     ; $21CD
    ldh [hR1], a                                  ; $21CF

Jump_000_21d1:
    ld a, [hl+]                                   ; $21D1
    ld [de], a                                    ; $21D2
    ld [bc], a                                    ; $21D3
    inc e                                         ; $21D4
    inc c                                         ; $21D5
    ld a, [hl+]                                   ; $21D6
    ld [de], a                                    ; $21D7
    ld [bc], a                                    ; $21D8
    inc e                                         ; $21D9
    dec c                                         ; $21DA
    dec c                                         ; $21DB
    dec c                                         ; $21DC
    ld a, [hl+]                                   ; $21DD
    ld [de], a                                    ; $21DE
    ld [bc], a                                    ; $21DF
    inc e                                         ; $21E0
    inc c                                         ; $21E1
    ld a, [hl+]                                   ; $21E2
    ld [de], a                                    ; $21E3
    ld [bc], a                                    ; $21E4
    inc e                                         ; $21E5
    dec c                                         ; $21E6
    dec c                                         ; $21E7
    dec c                                         ; $21E8
    ld a, [hl+]                                   ; $21E9
    ld [de], a                                    ; $21EA
    ld [bc], a                                    ; $21EB
    inc e                                         ; $21EC
    inc c                                         ; $21ED
    ld a, [hl+]                                   ; $21EE
    ld [de], a                                    ; $21EF
    ld [bc], a                                    ; $21F0
    inc e                                         ; $21F1
    dec c                                         ; $21F2
    dec c                                         ; $21F3
    dec c                                         ; $21F4
    ld a, [hl+]                                   ; $21F5
    ld [de], a                                    ; $21F6
    ld [bc], a                                    ; $21F7
    inc e                                         ; $21F8
    inc c                                         ; $21F9
    ld a, [hl+]                                   ; $21FA
    ld [de], a                                    ; $21FB
    ld [bc], a                                    ; $21FC
    inc e                                         ; $21FD
    dec c                                         ; $21FE
    dec c                                         ; $21FF
    dec c                                         ; $2200
    ld a, [hl+]                                   ; $2201
    ld [de], a                                    ; $2202
    ld [bc], a                                    ; $2203
    inc e                                         ; $2204
    inc c                                         ; $2205
    ld a, [hl+]                                   ; $2206
    ld [de], a                                    ; $2207
    ld [bc], a                                    ; $2208
    inc e                                         ; $2209
    dec c                                         ; $220A
    dec c                                         ; $220B
    dec c                                         ; $220C
    ld a, [hl+]                                   ; $220D
    ld [de], a                                    ; $220E
    ld [bc], a                                    ; $220F
    inc e                                         ; $2210
    inc c                                         ; $2211
    ld a, [hl+]                                   ; $2212
    ld [de], a                                    ; $2213
    ld [bc], a                                    ; $2214
    inc e                                         ; $2215
    dec c                                         ; $2216
    dec c                                         ; $2217
    dec c                                         ; $2218
    ld a, [hl+]                                   ; $2219
    ld [de], a                                    ; $221A
    ld [bc], a                                    ; $221B
    inc e                                         ; $221C
    inc c                                         ; $221D
    ld a, [hl+]                                   ; $221E
    ld [de], a                                    ; $221F
    ld [bc], a                                    ; $2220
    inc e                                         ; $2221
    dec c                                         ; $2222
    dec c                                         ; $2223
    dec c                                         ; $2224
    ld a, [hl+]                                   ; $2225
    ld [de], a                                    ; $2226
    ld [bc], a                                    ; $2227
    inc e                                         ; $2228
    inc c                                         ; $2229
    ld a, [hl+]                                   ; $222A
    ld [de], a                                    ; $222B
    ld [bc], a                                    ; $222C
    inc e                                         ; $222D
    ldh a, [hR1]                                  ; $222E
    dec a                                         ; $2230
    jr z, jr_000_223c                             ; $2231

    ldh [hR1], a                                  ; $2233
    ld a, c                                       ; $2235
    add $1d                                       ; $2236
    ld c, a                                       ; $2238
    jp Jump_000_21d1                              ; $2239


jr_000_223c:
    ldh a, [hR0]                                  ; $223C
    dec a                                         ; $223E
    ret z                                         ; $223F

    ldh [hR0], a                                  ; $2240
    ld e, $00                                     ; $2242
    inc d                                         ; $2244
    ld c, $0e                                     ; $2245
    dec b                                         ; $2247
    jp Jump_000_21cd                              ; $2248


; C: entry 4 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode04::
    ld hl, $a100                                  ; $224B
    ld de, wB_ADR                                 ; $224E
    ld bc, wImageCopy_Mode04_DD0E                 ; $2251
    ld a, $07                                     ; $2254
    ldh [hR0], a                                  ; $2256

Jump_000_2258:
    ld a, $10                                     ; $2258
    ldh [hR1], a                                  ; $225A

Jump_000_225c:
    ld a, [hl+]                                   ; $225C
    ld [de], a                                    ; $225D
    ld [bc], a                                    ; $225E
    inc e                                         ; $225F
    inc c                                         ; $2260
    ld a, [hl+]                                   ; $2261
    ld [de], a                                    ; $2262
    ld [bc], a                                    ; $2263
    inc e                                         ; $2264
    dec c                                         ; $2265
    dec c                                         ; $2266
    dec c                                         ; $2267
    ld a, [hl+]                                   ; $2268
    ld [de], a                                    ; $2269
    ld [bc], a                                    ; $226A
    inc e                                         ; $226B
    inc c                                         ; $226C
    ld a, [hl+]                                   ; $226D
    ld [de], a                                    ; $226E
    ld [bc], a                                    ; $226F
    inc e                                         ; $2270
    dec c                                         ; $2271
    dec c                                         ; $2272
    dec c                                         ; $2273
    ld a, [hl+]                                   ; $2274
    ld [de], a                                    ; $2275
    ld [bc], a                                    ; $2276
    inc e                                         ; $2277
    inc c                                         ; $2278
    ld a, [hl+]                                   ; $2279
    ld [de], a                                    ; $227A
    ld [bc], a                                    ; $227B
    inc e                                         ; $227C
    dec c                                         ; $227D
    dec c                                         ; $227E
    dec c                                         ; $227F
    ld a, [hl+]                                   ; $2280
    ld [de], a                                    ; $2281
    ld [bc], a                                    ; $2282
    inc e                                         ; $2283
    inc c                                         ; $2284
    ld a, [hl+]                                   ; $2285
    ld [de], a                                    ; $2286
    ld [bc], a                                    ; $2287
    inc e                                         ; $2288
    dec c                                         ; $2289
    dec c                                         ; $228A
    dec c                                         ; $228B
    ld a, [hl+]                                   ; $228C
    ld [de], a                                    ; $228D
    ld [bc], a                                    ; $228E
    inc e                                         ; $228F
    inc c                                         ; $2290
    ld a, [hl+]                                   ; $2291
    ld [de], a                                    ; $2292
    ld [bc], a                                    ; $2293
    inc e                                         ; $2294
    dec c                                         ; $2295
    dec c                                         ; $2296
    dec c                                         ; $2297
    ld a, [hl+]                                   ; $2298
    ld [de], a                                    ; $2299
    ld [bc], a                                    ; $229A
    inc e                                         ; $229B
    inc c                                         ; $229C
    ld a, [hl+]                                   ; $229D
    ld [de], a                                    ; $229E
    ld [bc], a                                    ; $229F
    inc e                                         ; $22A0
    dec c                                         ; $22A1
    dec c                                         ; $22A2
    dec c                                         ; $22A3
    ld a, [hl+]                                   ; $22A4
    ld [de], a                                    ; $22A5
    ld [bc], a                                    ; $22A6
    inc e                                         ; $22A7
    inc c                                         ; $22A8
    ld a, [hl+]                                   ; $22A9
    ld [de], a                                    ; $22AA
    ld [bc], a                                    ; $22AB
    inc e                                         ; $22AC
    dec c                                         ; $22AD
    dec c                                         ; $22AE
    dec c                                         ; $22AF
    ld a, [hl+]                                   ; $22B0
    ld [de], a                                    ; $22B1
    ld [bc], a                                    ; $22B2
    inc e                                         ; $22B3
    inc c                                         ; $22B4
    ld a, [hl+]                                   ; $22B5
    ld [de], a                                    ; $22B6
    ld [bc], a                                    ; $22B7
    inc e                                         ; $22B8
    ldh a, [hR1]                                  ; $22B9
    dec a                                         ; $22BB
    jr z, jr_000_22c7                             ; $22BC

    ldh [hR1], a                                  ; $22BE
    ld a, c                                       ; $22C0
    add $1d                                       ; $22C1
    ld c, a                                       ; $22C3
    jp Jump_000_225c                              ; $22C4


jr_000_22c7:
    ldh a, [hR0]                                  ; $22C7
    dec a                                         ; $22C9
    ret z                                         ; $22CA

    ldh [hR0], a                                  ; $22CB
    ld e, $00                                     ; $22CD
    inc d                                         ; $22CF
    ld c, $0e                                     ; $22D0
    dec b                                         ; $22D2
    jp Jump_000_2258                              ; $22D3


; C: entry 5 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode05::
    ld hl, $a300                                  ; $22D6
    ld de, wB_ADR                                 ; $22D9
    ld a, $07                                     ; $22DC
    ldh [hR0], a                                  ; $22DE

Jump_000_22e0:
    ld a, $10                                     ; $22E0
    ldh [hR1], a                                  ; $22E2

Jump_000_22e4:
    ld a, [hl+]                                   ; $22E4
    ld [de], a                                    ; $22E5
    inc e                                         ; $22E6
    inc e                                         ; $22E7
    ld [de], a                                    ; $22E8
    dec e                                         ; $22E9
    ld a, [hl+]                                   ; $22EA
    ld [de], a                                    ; $22EB
    inc e                                         ; $22EC
    inc e                                         ; $22ED
    ld [de], a                                    ; $22EE
    inc e                                         ; $22EF
    ld a, [hl+]                                   ; $22F0
    ld [de], a                                    ; $22F1
    inc e                                         ; $22F2
    inc e                                         ; $22F3
    ld [de], a                                    ; $22F4
    dec e                                         ; $22F5
    ld a, [hl+]                                   ; $22F6
    ld [de], a                                    ; $22F7
    inc e                                         ; $22F8
    inc e                                         ; $22F9
    ld [de], a                                    ; $22FA
    inc e                                         ; $22FB
    ld a, [hl+]                                   ; $22FC
    ld [de], a                                    ; $22FD
    inc e                                         ; $22FE
    inc e                                         ; $22FF
    ld [de], a                                    ; $2300
    dec e                                         ; $2301
    ld a, [hl+]                                   ; $2302
    ld [de], a                                    ; $2303
    inc e                                         ; $2304
    inc e                                         ; $2305
    ld [de], a                                    ; $2306
    inc e                                         ; $2307
    ld a, [hl+]                                   ; $2308
    ld [de], a                                    ; $2309
    inc e                                         ; $230A
    inc e                                         ; $230B
    ld [de], a                                    ; $230C
    dec e                                         ; $230D
    ld a, [hl+]                                   ; $230E
    ld [de], a                                    ; $230F
    inc e                                         ; $2310
    inc e                                         ; $2311
    ld [de], a                                    ; $2312
    inc d                                         ; $2313
    ld a, e                                       ; $2314
    and $f0                                       ; $2315
    ld e, a                                       ; $2317
    ld a, [hl+]                                   ; $2318
    ld [de], a                                    ; $2319
    inc e                                         ; $231A
    inc e                                         ; $231B
    ld [de], a                                    ; $231C
    dec e                                         ; $231D
    ld a, [hl+]                                   ; $231E
    ld [de], a                                    ; $231F
    inc e                                         ; $2320
    inc e                                         ; $2321
    ld [de], a                                    ; $2322
    inc e                                         ; $2323
    ld a, [hl+]                                   ; $2324
    ld [de], a                                    ; $2325
    inc e                                         ; $2326
    inc e                                         ; $2327
    ld [de], a                                    ; $2328
    dec e                                         ; $2329
    ld a, [hl+]                                   ; $232A
    ld [de], a                                    ; $232B
    inc e                                         ; $232C
    inc e                                         ; $232D
    ld [de], a                                    ; $232E
    inc e                                         ; $232F
    ld a, [hl+]                                   ; $2330
    ld [de], a                                    ; $2331
    inc e                                         ; $2332
    inc e                                         ; $2333
    ld [de], a                                    ; $2334
    dec e                                         ; $2335
    ld a, [hl+]                                   ; $2336
    ld [de], a                                    ; $2337
    inc e                                         ; $2338
    inc e                                         ; $2339
    ld [de], a                                    ; $233A
    inc e                                         ; $233B
    ld a, [hl+]                                   ; $233C
    ld [de], a                                    ; $233D
    inc e                                         ; $233E
    inc e                                         ; $233F
    ld [de], a                                    ; $2340
    dec e                                         ; $2341
    ld a, [hl+]                                   ; $2342
    ld [de], a                                    ; $2343
    inc e                                         ; $2344
    inc e                                         ; $2345
    ld [de], a                                    ; $2346
    inc e                                         ; $2347
    dec d                                         ; $2348
    ldh a, [hR1]                                  ; $2349
    dec a                                         ; $234B
    jr z, jr_000_2353                             ; $234C

    ldh [hR1], a                                  ; $234E
    jp Jump_000_22e4                              ; $2350


jr_000_2353:
    ldh a, [hR0]                                  ; $2353
    dec a                                         ; $2355
    ret z                                         ; $2356

    ldh [hR0], a                                  ; $2357
    inc d                                         ; $2359
    inc d                                         ; $235A
    jp Jump_000_22e0                              ; $235B


; C: entry 6 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode06::
    ld hl, $a040                                  ; $235E
    ld de, wB_ADR                                 ; $2361
    ld a, $0e                                     ; $2364
    ldh [hR0], a                                  ; $2366

Jump_000_2368:
    ld a, $08                                     ; $2368
    ldh [hR1], a                                  ; $236A

Jump_000_236c:
    ld a, [hl+]                                   ; $236C
    ld c, a                                       ; $236D
    ld b, $43                                     ; $236E
    ld a, [bc]                                    ; $2370
    ld [de], a                                    ; $2371
    ld a, e                                       ; $2372
    add $10                                       ; $2373
    ld e, a                                       ; $2375
    ld b, $44                                     ; $2376
    ld a, [bc]                                    ; $2378
    ld [de], a                                    ; $2379
    ld a, e                                       ; $237A
    add $f1                                       ; $237B
    ld e, a                                       ; $237D
    ld a, [hl+]                                   ; $237E
    ld c, a                                       ; $237F
    ld b, $43                                     ; $2380
    ld a, [bc]                                    ; $2382
    ld [de], a                                    ; $2383
    ld a, e                                       ; $2384
    add $10                                       ; $2385
    ld e, a                                       ; $2387
    ld b, $44                                     ; $2388
    ld a, [bc]                                    ; $238A
    ld [de], a                                    ; $238B
    ld a, e                                       ; $238C
    add $f1                                       ; $238D
    ld e, a                                       ; $238F
    ld a, [hl+]                                   ; $2390
    ld c, a                                       ; $2391
    ld b, $43                                     ; $2392
    ld a, [bc]                                    ; $2394
    ld [de], a                                    ; $2395
    ld a, e                                       ; $2396
    add $10                                       ; $2397
    ld e, a                                       ; $2399
    ld b, $44                                     ; $239A
    ld a, [bc]                                    ; $239C
    ld [de], a                                    ; $239D
    ld a, e                                       ; $239E
    add $f1                                       ; $239F
    ld e, a                                       ; $23A1
    ld a, [hl+]                                   ; $23A2
    ld c, a                                       ; $23A3
    ld b, $43                                     ; $23A4
    ld a, [bc]                                    ; $23A6
    ld [de], a                                    ; $23A7
    ld a, e                                       ; $23A8
    add $10                                       ; $23A9
    ld e, a                                       ; $23AB
    ld b, $44                                     ; $23AC
    ld a, [bc]                                    ; $23AE
    ld [de], a                                    ; $23AF
    ld a, e                                       ; $23B0
    add $f1                                       ; $23B1
    ld e, a                                       ; $23B3
    ld a, [hl+]                                   ; $23B4
    ld c, a                                       ; $23B5
    ld b, $43                                     ; $23B6
    ld a, [bc]                                    ; $23B8
    ld [de], a                                    ; $23B9
    ld a, e                                       ; $23BA
    add $10                                       ; $23BB
    ld e, a                                       ; $23BD
    ld b, $44                                     ; $23BE
    ld a, [bc]                                    ; $23C0
    ld [de], a                                    ; $23C1
    ld a, e                                       ; $23C2
    add $f1                                       ; $23C3
    ld e, a                                       ; $23C5
    ld a, [hl+]                                   ; $23C6
    ld c, a                                       ; $23C7
    ld b, $43                                     ; $23C8
    ld a, [bc]                                    ; $23CA
    ld [de], a                                    ; $23CB
    ld a, e                                       ; $23CC
    add $10                                       ; $23CD
    ld e, a                                       ; $23CF
    ld b, $44                                     ; $23D0
    ld a, [bc]                                    ; $23D2
    ld [de], a                                    ; $23D3
    ld a, e                                       ; $23D4
    add $f1                                       ; $23D5
    ld e, a                                       ; $23D7
    ld a, [hl+]                                   ; $23D8
    ld c, a                                       ; $23D9
    ld b, $43                                     ; $23DA
    ld a, [bc]                                    ; $23DC
    ld [de], a                                    ; $23DD
    ld a, e                                       ; $23DE
    add $10                                       ; $23DF
    ld e, a                                       ; $23E1
    ld b, $44                                     ; $23E2
    ld a, [bc]                                    ; $23E4
    ld [de], a                                    ; $23E5
    ld a, e                                       ; $23E6
    add $f1                                       ; $23E7
    ld e, a                                       ; $23E9
    ld a, [hl+]                                   ; $23EA
    ld c, a                                       ; $23EB
    ld b, $43                                     ; $23EC
    ld a, [bc]                                    ; $23EE
    ld [de], a                                    ; $23EF
    ld a, e                                       ; $23F0
    add $10                                       ; $23F1
    ld e, a                                       ; $23F3
    ld b, $44                                     ; $23F4
    ld a, [bc]                                    ; $23F6
    ld [de], a                                    ; $23F7
    ld a, e                                       ; $23F8
    add $f1                                       ; $23F9
    ld e, a                                       ; $23FB
    ld a, [hl+]                                   ; $23FC
    ld c, a                                       ; $23FD
    ld b, $43                                     ; $23FE
    ld a, [bc]                                    ; $2400
    ld [de], a                                    ; $2401
    ld a, e                                       ; $2402
    add $10                                       ; $2403
    ld e, a                                       ; $2405
    ld b, $44                                     ; $2406
    ld a, [bc]                                    ; $2408
    ld [de], a                                    ; $2409
    ld a, e                                       ; $240A
    add $f1                                       ; $240B
    ld e, a                                       ; $240D
    ld a, [hl+]                                   ; $240E
    ld c, a                                       ; $240F
    ld b, $43                                     ; $2410
    ld a, [bc]                                    ; $2412
    ld [de], a                                    ; $2413
    ld a, e                                       ; $2414
    add $10                                       ; $2415
    ld e, a                                       ; $2417
    ld b, $44                                     ; $2418
    ld a, [bc]                                    ; $241A
    ld [de], a                                    ; $241B
    ld a, e                                       ; $241C
    add $f1                                       ; $241D
    ld e, a                                       ; $241F
    ld a, [hl+]                                   ; $2420
    ld c, a                                       ; $2421
    ld b, $43                                     ; $2422
    ld a, [bc]                                    ; $2424
    ld [de], a                                    ; $2425
    ld a, e                                       ; $2426
    add $10                                       ; $2427
    ld e, a                                       ; $2429
    ld b, $44                                     ; $242A
    ld a, [bc]                                    ; $242C
    ld [de], a                                    ; $242D
    ld a, e                                       ; $242E
    add $f1                                       ; $242F
    ld e, a                                       ; $2431
    ld a, [hl+]                                   ; $2432
    ld c, a                                       ; $2433
    ld b, $43                                     ; $2434
    ld a, [bc]                                    ; $2436
    ld [de], a                                    ; $2437
    ld a, e                                       ; $2438
    add $10                                       ; $2439
    ld e, a                                       ; $243B
    ld b, $44                                     ; $243C
    ld a, [bc]                                    ; $243E
    ld [de], a                                    ; $243F
    ld a, e                                       ; $2440
    add $f1                                       ; $2441
    ld e, a                                       ; $2443
    ld a, [hl+]                                   ; $2444
    ld c, a                                       ; $2445
    ld b, $43                                     ; $2446
    ld a, [bc]                                    ; $2448
    ld [de], a                                    ; $2449
    ld a, e                                       ; $244A
    add $10                                       ; $244B
    ld e, a                                       ; $244D
    ld b, $44                                     ; $244E
    ld a, [bc]                                    ; $2450
    ld [de], a                                    ; $2451
    ld a, e                                       ; $2452
    add $f1                                       ; $2453
    ld e, a                                       ; $2455
    ld a, [hl+]                                   ; $2456
    ld c, a                                       ; $2457
    ld b, $43                                     ; $2458
    ld a, [bc]                                    ; $245A
    ld [de], a                                    ; $245B
    ld a, e                                       ; $245C
    add $10                                       ; $245D
    ld e, a                                       ; $245F
    ld b, $44                                     ; $2460
    ld a, [bc]                                    ; $2462
    ld [de], a                                    ; $2463
    ld a, e                                       ; $2464
    add $f1                                       ; $2465
    ld e, a                                       ; $2467
    ld a, [hl+]                                   ; $2468
    ld c, a                                       ; $2469
    ld b, $43                                     ; $246A
    ld a, [bc]                                    ; $246C
    ld [de], a                                    ; $246D
    ld a, e                                       ; $246E
    add $10                                       ; $246F
    ld e, a                                       ; $2471
    ld b, $44                                     ; $2472
    ld a, [bc]                                    ; $2474
    ld [de], a                                    ; $2475
    ld a, e                                       ; $2476
    add $f1                                       ; $2477
    ld e, a                                       ; $2479
    ld a, [hl+]                                   ; $247A
    ld c, a                                       ; $247B
    ld b, $43                                     ; $247C
    ld a, [bc]                                    ; $247E
    ld [de], a                                    ; $247F
    ld a, e                                       ; $2480
    add $10                                       ; $2481
    ld e, a                                       ; $2483
    ld b, $44                                     ; $2484
    ld a, [bc]                                    ; $2486
    ld [de], a                                    ; $2487
    inc e                                         ; $2488
    ldh a, [hR1]                                  ; $2489
    dec a                                         ; $248B
    jr z, jr_000_2493                             ; $248C

    ldh [hR1], a                                  ; $248E
    jp Jump_000_236c                              ; $2490


jr_000_2493:
    ldh a, [hR0]                                  ; $2493
    dec a                                         ; $2495
    ret z                                         ; $2496

    ldh [hR0], a                                  ; $2497
    inc d                                         ; $2499
    inc h                                         ; $249A
    ld l, $40                                     ; $249B
    jp Jump_000_2368                              ; $249D


; C: entry 7 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode07::
    ld hl, $a440                                  ; $24A0
    ld de, wB_ADR                                 ; $24A3
    ld a, $07                                     ; $24A6
    ldh [hR0], a                                  ; $24A8

Jump_000_24aa:
    ld a, $08                                     ; $24AA
    ldh [hR1], a                                  ; $24AC

Jump_000_24ae:
    ld a, [hl+]                                   ; $24AE
    ld c, a                                       ; $24AF
    ld b, $43                                     ; $24B0
    ld a, [bc]                                    ; $24B2
    ld [de], a                                    ; $24B3
    inc e                                         ; $24B4
    inc e                                         ; $24B5
    ld [de], a                                    ; $24B6
    ld a, e                                       ; $24B7
    add $0e                                       ; $24B8
    ld e, a                                       ; $24BA
    ld b, $44                                     ; $24BB
    ld a, [bc]                                    ; $24BD
    ld [de], a                                    ; $24BE
    inc e                                         ; $24BF
    inc e                                         ; $24C0
    ld [de], a                                    ; $24C1
    ld a, e                                       ; $24C2
    add $ef                                       ; $24C3
    ld e, a                                       ; $24C5
    ld a, [hl+]                                   ; $24C6
    ld c, a                                       ; $24C7
    ld b, $43                                     ; $24C8
    ld a, [bc]                                    ; $24CA
    ld [de], a                                    ; $24CB
    inc e                                         ; $24CC
    inc e                                         ; $24CD
    ld [de], a                                    ; $24CE
    ld a, e                                       ; $24CF
    add $0e                                       ; $24D0
    ld e, a                                       ; $24D2
    ld b, $44                                     ; $24D3
    ld a, [bc]                                    ; $24D5
    ld [de], a                                    ; $24D6
    inc e                                         ; $24D7
    inc e                                         ; $24D8
    ld [de], a                                    ; $24D9
    ld a, e                                       ; $24DA
    add $f1                                       ; $24DB
    ld e, a                                       ; $24DD
    ld a, [hl+]                                   ; $24DE
    ld c, a                                       ; $24DF
    ld b, $43                                     ; $24E0
    ld a, [bc]                                    ; $24E2
    ld [de], a                                    ; $24E3
    inc e                                         ; $24E4
    inc e                                         ; $24E5
    ld [de], a                                    ; $24E6
    ld a, e                                       ; $24E7
    add $0e                                       ; $24E8
    ld e, a                                       ; $24EA
    ld b, $44                                     ; $24EB
    ld a, [bc]                                    ; $24ED
    ld [de], a                                    ; $24EE
    inc e                                         ; $24EF
    inc e                                         ; $24F0
    ld [de], a                                    ; $24F1
    ld a, e                                       ; $24F2
    add $ef                                       ; $24F3
    ld e, a                                       ; $24F5
    ld a, [hl+]                                   ; $24F6
    ld c, a                                       ; $24F7
    ld b, $43                                     ; $24F8
    ld a, [bc]                                    ; $24FA
    ld [de], a                                    ; $24FB
    inc e                                         ; $24FC
    inc e                                         ; $24FD
    ld [de], a                                    ; $24FE
    ld a, e                                       ; $24FF
    add $0e                                       ; $2500
    ld e, a                                       ; $2502
    ld b, $44                                     ; $2503
    ld a, [bc]                                    ; $2505
    ld [de], a                                    ; $2506
    inc e                                         ; $2507
    inc e                                         ; $2508
    ld [de], a                                    ; $2509
    ld a, e                                       ; $250A
    add $f1                                       ; $250B
    ld e, a                                       ; $250D
    ld a, [hl+]                                   ; $250E
    ld c, a                                       ; $250F
    ld b, $43                                     ; $2510
    ld a, [bc]                                    ; $2512
    ld [de], a                                    ; $2513
    inc e                                         ; $2514
    inc e                                         ; $2515
    ld [de], a                                    ; $2516
    ld a, e                                       ; $2517
    add $0e                                       ; $2518
    ld e, a                                       ; $251A
    ld b, $44                                     ; $251B
    ld a, [bc]                                    ; $251D
    ld [de], a                                    ; $251E
    inc e                                         ; $251F
    inc e                                         ; $2520
    ld [de], a                                    ; $2521
    ld a, e                                       ; $2522
    add $ef                                       ; $2523
    ld e, a                                       ; $2525
    ld a, [hl+]                                   ; $2526
    ld c, a                                       ; $2527
    ld b, $43                                     ; $2528
    ld a, [bc]                                    ; $252A
    ld [de], a                                    ; $252B
    inc e                                         ; $252C
    inc e                                         ; $252D
    ld [de], a                                    ; $252E
    ld a, e                                       ; $252F
    add $0e                                       ; $2530
    ld e, a                                       ; $2532
    ld b, $44                                     ; $2533
    ld a, [bc]                                    ; $2535
    ld [de], a                                    ; $2536
    inc e                                         ; $2537
    inc e                                         ; $2538
    ld [de], a                                    ; $2539
    ld a, e                                       ; $253A
    add $f1                                       ; $253B
    ld e, a                                       ; $253D
    ld a, [hl+]                                   ; $253E
    ld c, a                                       ; $253F
    ld b, $43                                     ; $2540
    ld a, [bc]                                    ; $2542
    ld [de], a                                    ; $2543
    inc e                                         ; $2544
    inc e                                         ; $2545
    ld [de], a                                    ; $2546
    ld a, e                                       ; $2547
    add $0e                                       ; $2548
    ld e, a                                       ; $254A
    ld b, $44                                     ; $254B
    ld a, [bc]                                    ; $254D
    ld [de], a                                    ; $254E
    inc e                                         ; $254F
    inc e                                         ; $2550
    ld [de], a                                    ; $2551
    ld a, e                                       ; $2552
    add $ef                                       ; $2553
    ld e, a                                       ; $2555
    ld a, [hl+]                                   ; $2556
    ld c, a                                       ; $2557
    ld b, $43                                     ; $2558
    ld a, [bc]                                    ; $255A
    ld [de], a                                    ; $255B
    inc e                                         ; $255C
    inc e                                         ; $255D
    ld [de], a                                    ; $255E
    ld a, e                                       ; $255F
    add $0e                                       ; $2560
    ld e, a                                       ; $2562
    ld b, $44                                     ; $2563
    ld a, [bc]                                    ; $2565
    ld [de], a                                    ; $2566
    inc e                                         ; $2567
    inc e                                         ; $2568
    ld [de], a                                    ; $2569
    inc d                                         ; $256A
    ld a, e                                       ; $256B
    add $e1                                       ; $256C
    ld e, a                                       ; $256E
    ld a, [hl+]                                   ; $256F
    ld c, a                                       ; $2570
    ld b, $43                                     ; $2571
    ld a, [bc]                                    ; $2573
    ld [de], a                                    ; $2574
    inc e                                         ; $2575
    inc e                                         ; $2576
    ld [de], a                                    ; $2577
    ld a, e                                       ; $2578
    add $0e                                       ; $2579
    ld e, a                                       ; $257B
    ld b, $44                                     ; $257C
    ld a, [bc]                                    ; $257E
    ld [de], a                                    ; $257F
    inc e                                         ; $2580
    inc e                                         ; $2581
    ld [de], a                                    ; $2582
    ld a, e                                       ; $2583
    add $ef                                       ; $2584
    ld e, a                                       ; $2586
    ld a, [hl+]                                   ; $2587
    ld c, a                                       ; $2588
    ld b, $43                                     ; $2589
    ld a, [bc]                                    ; $258B
    ld [de], a                                    ; $258C
    inc e                                         ; $258D
    inc e                                         ; $258E
    ld [de], a                                    ; $258F
    ld a, e                                       ; $2590
    add $0e                                       ; $2591
    ld e, a                                       ; $2593
    ld b, $44                                     ; $2594
    ld a, [bc]                                    ; $2596
    ld [de], a                                    ; $2597
    inc e                                         ; $2598
    inc e                                         ; $2599
    ld [de], a                                    ; $259A
    ld a, e                                       ; $259B
    add $f1                                       ; $259C
    ld e, a                                       ; $259E
    ld a, [hl+]                                   ; $259F
    ld c, a                                       ; $25A0
    ld b, $43                                     ; $25A1
    ld a, [bc]                                    ; $25A3
    ld [de], a                                    ; $25A4
    inc e                                         ; $25A5
    inc e                                         ; $25A6
    ld [de], a                                    ; $25A7
    ld a, e                                       ; $25A8
    add $0e                                       ; $25A9
    ld e, a                                       ; $25AB
    ld b, $44                                     ; $25AC
    ld a, [bc]                                    ; $25AE
    ld [de], a                                    ; $25AF
    inc e                                         ; $25B0
    inc e                                         ; $25B1
    ld [de], a                                    ; $25B2
    ld a, e                                       ; $25B3
    add $ef                                       ; $25B4
    ld e, a                                       ; $25B6
    ld a, [hl+]                                   ; $25B7
    ld c, a                                       ; $25B8
    ld b, $43                                     ; $25B9
    ld a, [bc]                                    ; $25BB
    ld [de], a                                    ; $25BC
    inc e                                         ; $25BD
    inc e                                         ; $25BE
    ld [de], a                                    ; $25BF
    ld a, e                                       ; $25C0
    add $0e                                       ; $25C1
    ld e, a                                       ; $25C3
    ld b, $44                                     ; $25C4
    ld a, [bc]                                    ; $25C6
    ld [de], a                                    ; $25C7
    inc e                                         ; $25C8
    inc e                                         ; $25C9
    ld [de], a                                    ; $25CA
    ld a, e                                       ; $25CB
    add $f1                                       ; $25CC
    ld e, a                                       ; $25CE
    ld a, [hl+]                                   ; $25CF
    ld c, a                                       ; $25D0
    ld b, $43                                     ; $25D1
    ld a, [bc]                                    ; $25D3
    ld [de], a                                    ; $25D4
    inc e                                         ; $25D5
    inc e                                         ; $25D6
    ld [de], a                                    ; $25D7
    ld a, e                                       ; $25D8
    add $0e                                       ; $25D9
    ld e, a                                       ; $25DB
    ld b, $44                                     ; $25DC
    ld a, [bc]                                    ; $25DE
    ld [de], a                                    ; $25DF
    inc e                                         ; $25E0
    inc e                                         ; $25E1
    ld [de], a                                    ; $25E2
    ld a, e                                       ; $25E3
    add $ef                                       ; $25E4
    ld e, a                                       ; $25E6
    ld a, [hl+]                                   ; $25E7
    ld c, a                                       ; $25E8
    ld b, $43                                     ; $25E9
    ld a, [bc]                                    ; $25EB
    ld [de], a                                    ; $25EC
    inc e                                         ; $25ED
    inc e                                         ; $25EE
    ld [de], a                                    ; $25EF
    ld a, e                                       ; $25F0
    add $0e                                       ; $25F1
    ld e, a                                       ; $25F3
    ld b, $44                                     ; $25F4
    ld a, [bc]                                    ; $25F6
    ld [de], a                                    ; $25F7
    inc e                                         ; $25F8
    inc e                                         ; $25F9
    ld [de], a                                    ; $25FA
    ld a, e                                       ; $25FB
    add $f1                                       ; $25FC
    ld e, a                                       ; $25FE
    ld a, [hl+]                                   ; $25FF
    ld c, a                                       ; $2600
    ld b, $43                                     ; $2601
    ld a, [bc]                                    ; $2603
    ld [de], a                                    ; $2604
    inc e                                         ; $2605
    inc e                                         ; $2606
    ld [de], a                                    ; $2607
    ld a, e                                       ; $2608
    add $0e                                       ; $2609
    ld e, a                                       ; $260B
    ld b, $44                                     ; $260C
    ld a, [bc]                                    ; $260E
    ld [de], a                                    ; $260F
    inc e                                         ; $2610
    inc e                                         ; $2611
    ld [de], a                                    ; $2612
    ld a, e                                       ; $2613
    add $ef                                       ; $2614
    ld e, a                                       ; $2616
    ld a, [hl+]                                   ; $2617
    ld c, a                                       ; $2618
    ld b, $43                                     ; $2619
    ld a, [bc]                                    ; $261B
    ld [de], a                                    ; $261C
    inc e                                         ; $261D
    inc e                                         ; $261E
    ld [de], a                                    ; $261F
    ld a, e                                       ; $2620
    add $0e                                       ; $2621
    ld e, a                                       ; $2623
    ld b, $44                                     ; $2624
    ld a, [bc]                                    ; $2626
    ld [de], a                                    ; $2627
    inc e                                         ; $2628
    inc e                                         ; $2629
    ld [de], a                                    ; $262A
    ldh a, [hR1]                                  ; $262B
    dec a                                         ; $262D
    jr z, jr_000_2637                             ; $262E

    ldh [hR1], a                                  ; $2630
    dec d                                         ; $2632
    inc e                                         ; $2633
    jp Jump_000_24ae                              ; $2634


jr_000_2637:
    ldh a, [hR0]                                  ; $2637
    dec a                                         ; $2639
    ret z                                         ; $263A

    ldh [hR0], a                                  ; $263B
    inc h                                         ; $263D
    ld l, $40                                     ; $263E
    inc d                                         ; $2640
    inc e                                         ; $2641
    jp Jump_000_24aa                              ; $2642


; C: entry 8 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode08::
    ld de, wB_ADR                                 ; $2645
    ld hl, $a100                                  ; $2648
    ld b, $45                                     ; $264B
    ld a, $07                                     ; $264D
    ldh [hR0], a                                  ; $264F

Jump_000_2651:
    ld a, $08                                     ; $2651
    ldh [hR1], a                                  ; $2653

Jump_000_2655:
    ld c, [hl]                                    ; $2655
    ld a, [bc]                                    ; $2656
    swap a                                        ; $2657
    ldh [hR2], a                                  ; $2659
    ld a, l                                       ; $265B
    add $10                                       ; $265C
    ld l, a                                       ; $265E
    ld c, [hl]                                    ; $265F
    ld a, [bc]                                    ; $2660
    ld c, a                                       ; $2661
    ldh a, [hR2]                                  ; $2662
    or c                                          ; $2664
    ld c, a                                       ; $2665
    ld [de], a                                    ; $2666
    ld a, e                                       ; $2667
    add $80                                       ; $2668
    ld e, a                                       ; $266A
    ld a, c                                       ; $266B
    ld [de], a                                    ; $266C
    ld a, d                                       ; $266D
    add $07                                       ; $266E
    ld d, a                                       ; $2670
    ld a, c                                       ; $2671
    ld [de], a                                    ; $2672
    ld a, e                                       ; $2673
    add $80                                       ; $2674
    ld e, a                                       ; $2676
    ld a, c                                       ; $2677
    ld [de], a                                    ; $2678
    ld a, d                                       ; $2679
    sub $07                                       ; $267A
    ld d, a                                       ; $267C
    inc e                                         ; $267D
    ld a, l                                       ; $267E
    add $f1                                       ; $267F
    ld l, a                                       ; $2681
    ld c, [hl]                                    ; $2682
    ld a, [bc]                                    ; $2683
    swap a                                        ; $2684
    ldh [hR2], a                                  ; $2686
    ld a, l                                       ; $2688
    add $10                                       ; $2689
    ld l, a                                       ; $268B
    ld c, [hl]                                    ; $268C
    ld a, [bc]                                    ; $268D
    ld c, a                                       ; $268E
    ldh a, [hR2]                                  ; $268F
    or c                                          ; $2691
    ld c, a                                       ; $2692
    ld [de], a                                    ; $2693
    ld a, e                                       ; $2694
    add $80                                       ; $2695
    ld e, a                                       ; $2697
    ld a, c                                       ; $2698
    ld [de], a                                    ; $2699
    ld a, d                                       ; $269A
    add $07                                       ; $269B
    ld d, a                                       ; $269D
    ld a, c                                       ; $269E
    ld [de], a                                    ; $269F
    ld a, e                                       ; $26A0
    add $80                                       ; $26A1
    ld e, a                                       ; $26A3
    ld a, c                                       ; $26A4
    ld [de], a                                    ; $26A5
    ld a, d                                       ; $26A6
    sub $07                                       ; $26A7
    ld d, a                                       ; $26A9
    inc e                                         ; $26AA
    ld a, l                                       ; $26AB
    add $f3                                       ; $26AC
    ld l, a                                       ; $26AE
    ld c, [hl]                                    ; $26AF
    ld a, [bc]                                    ; $26B0
    swap a                                        ; $26B1
    ldh [hR2], a                                  ; $26B3
    ld a, l                                       ; $26B5
    add $10                                       ; $26B6
    ld l, a                                       ; $26B8
    ld c, [hl]                                    ; $26B9
    ld a, [bc]                                    ; $26BA
    ld c, a                                       ; $26BB
    ldh a, [hR2]                                  ; $26BC
    or c                                          ; $26BE
    ld c, a                                       ; $26BF
    ld [de], a                                    ; $26C0
    ld a, e                                       ; $26C1
    add $80                                       ; $26C2
    ld e, a                                       ; $26C4
    ld a, c                                       ; $26C5
    ld [de], a                                    ; $26C6
    ld a, d                                       ; $26C7
    add $07                                       ; $26C8
    ld d, a                                       ; $26CA
    ld a, c                                       ; $26CB
    ld [de], a                                    ; $26CC
    ld a, e                                       ; $26CD
    add $80                                       ; $26CE
    ld e, a                                       ; $26D0
    ld a, c                                       ; $26D1
    ld [de], a                                    ; $26D2
    ld a, d                                       ; $26D3
    sub $07                                       ; $26D4
    ld d, a                                       ; $26D6
    inc e                                         ; $26D7
    ld a, l                                       ; $26D8
    add $f1                                       ; $26D9
    ld l, a                                       ; $26DB
    ld c, [hl]                                    ; $26DC
    ld a, [bc]                                    ; $26DD
    swap a                                        ; $26DE
    ldh [hR2], a                                  ; $26E0
    ld a, l                                       ; $26E2
    add $10                                       ; $26E3
    ld l, a                                       ; $26E5
    ld c, [hl]                                    ; $26E6
    ld a, [bc]                                    ; $26E7
    ld c, a                                       ; $26E8
    ldh a, [hR2]                                  ; $26E9
    or c                                          ; $26EB
    ld c, a                                       ; $26EC
    ld [de], a                                    ; $26ED
    ld a, e                                       ; $26EE
    add $80                                       ; $26EF
    ld e, a                                       ; $26F1
    ld a, c                                       ; $26F2
    ld [de], a                                    ; $26F3
    ld a, d                                       ; $26F4
    add $07                                       ; $26F5
    ld d, a                                       ; $26F7
    ld a, c                                       ; $26F8
    ld [de], a                                    ; $26F9
    ld a, e                                       ; $26FA
    add $80                                       ; $26FB
    ld e, a                                       ; $26FD
    ld a, c                                       ; $26FE
    ld [de], a                                    ; $26FF
    ld a, d                                       ; $2700
    sub $07                                       ; $2701
    ld d, a                                       ; $2703
    inc e                                         ; $2704
    ld a, l                                       ; $2705
    add $f3                                       ; $2706
    ld l, a                                       ; $2708
    ld c, [hl]                                    ; $2709
    ld a, [bc]                                    ; $270A
    swap a                                        ; $270B
    ldh [hR2], a                                  ; $270D
    ld a, l                                       ; $270F
    add $10                                       ; $2710
    ld l, a                                       ; $2712
    ld c, [hl]                                    ; $2713
    ld a, [bc]                                    ; $2714
    ld c, a                                       ; $2715
    ldh a, [hR2]                                  ; $2716
    or c                                          ; $2718
    ld c, a                                       ; $2719
    ld [de], a                                    ; $271A
    ld a, e                                       ; $271B
    add $80                                       ; $271C
    ld e, a                                       ; $271E
    ld a, c                                       ; $271F
    ld [de], a                                    ; $2720
    ld a, d                                       ; $2721
    add $07                                       ; $2722
    ld d, a                                       ; $2724
    ld a, c                                       ; $2725
    ld [de], a                                    ; $2726
    ld a, e                                       ; $2727
    add $80                                       ; $2728
    ld e, a                                       ; $272A
    ld a, c                                       ; $272B
    ld [de], a                                    ; $272C
    ld a, d                                       ; $272D
    sub $07                                       ; $272E
    ld d, a                                       ; $2730
    inc e                                         ; $2731
    ld a, l                                       ; $2732
    add $f1                                       ; $2733
    ld l, a                                       ; $2735
    ld c, [hl]                                    ; $2736
    ld a, [bc]                                    ; $2737
    swap a                                        ; $2738
    ldh [hR2], a                                  ; $273A
    ld a, l                                       ; $273C
    add $10                                       ; $273D
    ld l, a                                       ; $273F
    ld c, [hl]                                    ; $2740
    ld a, [bc]                                    ; $2741
    ld c, a                                       ; $2742
    ldh a, [hR2]                                  ; $2743
    or c                                          ; $2745
    ld c, a                                       ; $2746
    ld [de], a                                    ; $2747
    ld a, e                                       ; $2748
    add $80                                       ; $2749
    ld e, a                                       ; $274B
    ld a, c                                       ; $274C
    ld [de], a                                    ; $274D
    ld a, d                                       ; $274E
    add $07                                       ; $274F
    ld d, a                                       ; $2751
    ld a, c                                       ; $2752
    ld [de], a                                    ; $2753
    ld a, e                                       ; $2754
    add $80                                       ; $2755
    ld e, a                                       ; $2757
    ld a, c                                       ; $2758
    ld [de], a                                    ; $2759
    ld a, d                                       ; $275A
    sub $07                                       ; $275B
    ld d, a                                       ; $275D
    inc e                                         ; $275E
    ld a, l                                       ; $275F
    add $f3                                       ; $2760
    ld l, a                                       ; $2762
    ld c, [hl]                                    ; $2763
    ld a, [bc]                                    ; $2764
    swap a                                        ; $2765
    ldh [hR2], a                                  ; $2767
    ld a, l                                       ; $2769
    add $10                                       ; $276A
    ld l, a                                       ; $276C
    ld c, [hl]                                    ; $276D
    ld a, [bc]                                    ; $276E
    ld c, a                                       ; $276F
    ldh a, [hR2]                                  ; $2770
    or c                                          ; $2772
    ld c, a                                       ; $2773
    ld [de], a                                    ; $2774
    ld a, e                                       ; $2775
    add $80                                       ; $2776
    ld e, a                                       ; $2778
    ld a, c                                       ; $2779
    ld [de], a                                    ; $277A
    ld a, d                                       ; $277B
    add $07                                       ; $277C
    ld d, a                                       ; $277E
    ld a, c                                       ; $277F
    ld [de], a                                    ; $2780
    ld a, e                                       ; $2781
    add $80                                       ; $2782
    ld e, a                                       ; $2784
    ld a, c                                       ; $2785
    ld [de], a                                    ; $2786
    ld a, d                                       ; $2787
    sub $07                                       ; $2788
    ld d, a                                       ; $278A
    inc e                                         ; $278B
    ld a, l                                       ; $278C
    add $f1                                       ; $278D
    ld l, a                                       ; $278F
    ld c, [hl]                                    ; $2790
    ld a, [bc]                                    ; $2791
    swap a                                        ; $2792
    ldh [hR2], a                                  ; $2794
    ld a, l                                       ; $2796
    add $10                                       ; $2797
    ld l, a                                       ; $2799
    ld c, [hl]                                    ; $279A
    ld a, [bc]                                    ; $279B
    ld c, a                                       ; $279C
    ldh a, [hR2]                                  ; $279D
    or c                                          ; $279F
    ld c, a                                       ; $27A0
    ld [de], a                                    ; $27A1
    ld a, e                                       ; $27A2
    add $80                                       ; $27A3
    ld e, a                                       ; $27A5
    ld a, c                                       ; $27A6
    ld [de], a                                    ; $27A7
    ld a, d                                       ; $27A8
    add $07                                       ; $27A9
    ld d, a                                       ; $27AB
    ld a, c                                       ; $27AC
    ld [de], a                                    ; $27AD
    ld a, e                                       ; $27AE
    add $80                                       ; $27AF
    ld e, a                                       ; $27B1
    ld a, c                                       ; $27B2
    ld [de], a                                    ; $27B3
    ld a, d                                       ; $27B4
    sub $07                                       ; $27B5
    ld d, a                                       ; $27B7
    inc e                                         ; $27B8
    inc h                                         ; $27B9
    ld a, l                                       ; $27BA
    add $e3                                       ; $27BB
    ld l, a                                       ; $27BD
    ld c, [hl]                                    ; $27BE
    ld a, [bc]                                    ; $27BF
    swap a                                        ; $27C0
    ldh [hR2], a                                  ; $27C2
    ld a, l                                       ; $27C4
    add $10                                       ; $27C5
    ld l, a                                       ; $27C7
    ld c, [hl]                                    ; $27C8
    ld a, [bc]                                    ; $27C9
    ld c, a                                       ; $27CA
    ldh a, [hR2]                                  ; $27CB
    or c                                          ; $27CD
    ld c, a                                       ; $27CE
    ld [de], a                                    ; $27CF
    ld a, e                                       ; $27D0
    add $80                                       ; $27D1
    ld e, a                                       ; $27D3
    ld a, c                                       ; $27D4
    ld [de], a                                    ; $27D5
    ld a, d                                       ; $27D6
    add $07                                       ; $27D7
    ld d, a                                       ; $27D9
    ld a, c                                       ; $27DA
    ld [de], a                                    ; $27DB
    ld a, e                                       ; $27DC
    add $80                                       ; $27DD
    ld e, a                                       ; $27DF
    ld a, c                                       ; $27E0
    ld [de], a                                    ; $27E1
    ld a, d                                       ; $27E2
    sub $07                                       ; $27E3
    ld d, a                                       ; $27E5
    inc e                                         ; $27E6
    ld a, l                                       ; $27E7
    add $f1                                       ; $27E8
    ld l, a                                       ; $27EA
    ld c, [hl]                                    ; $27EB
    ld a, [bc]                                    ; $27EC
    swap a                                        ; $27ED
    ldh [hR2], a                                  ; $27EF
    ld a, l                                       ; $27F1
    add $10                                       ; $27F2
    ld l, a                                       ; $27F4
    ld c, [hl]                                    ; $27F5
    ld a, [bc]                                    ; $27F6
    ld c, a                                       ; $27F7
    ldh a, [hR2]                                  ; $27F8
    or c                                          ; $27FA
    ld c, a                                       ; $27FB
    ld [de], a                                    ; $27FC
    ld a, e                                       ; $27FD
    add $80                                       ; $27FE
    ld e, a                                       ; $2800
    ld a, c                                       ; $2801
    ld [de], a                                    ; $2802
    ld a, d                                       ; $2803
    add $07                                       ; $2804
    ld d, a                                       ; $2806
    ld a, c                                       ; $2807
    ld [de], a                                    ; $2808
    ld a, e                                       ; $2809
    add $80                                       ; $280A
    ld e, a                                       ; $280C
    ld a, c                                       ; $280D
    ld [de], a                                    ; $280E
    ld a, d                                       ; $280F
    sub $07                                       ; $2810
    ld d, a                                       ; $2812
    inc e                                         ; $2813
    ld a, l                                       ; $2814
    add $f3                                       ; $2815
    ld l, a                                       ; $2817
    ld c, [hl]                                    ; $2818
    ld a, [bc]                                    ; $2819
    swap a                                        ; $281A
    ldh [hR2], a                                  ; $281C
    ld a, l                                       ; $281E
    add $10                                       ; $281F
    ld l, a                                       ; $2821
    ld c, [hl]                                    ; $2822
    ld a, [bc]                                    ; $2823
    ld c, a                                       ; $2824
    ldh a, [hR2]                                  ; $2825
    or c                                          ; $2827
    ld c, a                                       ; $2828
    ld [de], a                                    ; $2829
    ld a, e                                       ; $282A
    add $80                                       ; $282B
    ld e, a                                       ; $282D
    ld a, c                                       ; $282E
    ld [de], a                                    ; $282F
    ld a, d                                       ; $2830
    add $07                                       ; $2831
    ld d, a                                       ; $2833
    ld a, c                                       ; $2834
    ld [de], a                                    ; $2835
    ld a, e                                       ; $2836
    add $80                                       ; $2837
    ld e, a                                       ; $2839
    ld a, c                                       ; $283A
    ld [de], a                                    ; $283B
    ld a, d                                       ; $283C
    sub $07                                       ; $283D
    ld d, a                                       ; $283F
    inc e                                         ; $2840
    ld a, l                                       ; $2841
    add $f1                                       ; $2842
    ld l, a                                       ; $2844
    ld c, [hl]                                    ; $2845
    ld a, [bc]                                    ; $2846
    swap a                                        ; $2847
    ldh [hR2], a                                  ; $2849
    ld a, l                                       ; $284B
    add $10                                       ; $284C
    ld l, a                                       ; $284E
    ld c, [hl]                                    ; $284F
    ld a, [bc]                                    ; $2850
    ld c, a                                       ; $2851
    ldh a, [hR2]                                  ; $2852
    or c                                          ; $2854
    ld c, a                                       ; $2855
    ld [de], a                                    ; $2856
    ld a, e                                       ; $2857
    add $80                                       ; $2858
    ld e, a                                       ; $285A
    ld a, c                                       ; $285B
    ld [de], a                                    ; $285C
    ld a, d                                       ; $285D
    add $07                                       ; $285E
    ld d, a                                       ; $2860
    ld a, c                                       ; $2861
    ld [de], a                                    ; $2862
    ld a, e                                       ; $2863
    add $80                                       ; $2864
    ld e, a                                       ; $2866
    ld a, c                                       ; $2867
    ld [de], a                                    ; $2868
    ld a, d                                       ; $2869
    sub $07                                       ; $286A
    ld d, a                                       ; $286C
    inc e                                         ; $286D
    ld a, l                                       ; $286E
    add $f3                                       ; $286F
    ld l, a                                       ; $2871
    ld c, [hl]                                    ; $2872
    ld a, [bc]                                    ; $2873
    swap a                                        ; $2874
    ldh [hR2], a                                  ; $2876
    ld a, l                                       ; $2878
    add $10                                       ; $2879
    ld l, a                                       ; $287B
    ld c, [hl]                                    ; $287C
    ld a, [bc]                                    ; $287D
    ld c, a                                       ; $287E
    ldh a, [hR2]                                  ; $287F
    or c                                          ; $2881
    ld c, a                                       ; $2882
    ld [de], a                                    ; $2883
    ld a, e                                       ; $2884
    add $80                                       ; $2885
    ld e, a                                       ; $2887
    ld a, c                                       ; $2888
    ld [de], a                                    ; $2889
    ld a, d                                       ; $288A
    add $07                                       ; $288B
    ld d, a                                       ; $288D
    ld a, c                                       ; $288E
    ld [de], a                                    ; $288F
    ld a, e                                       ; $2890
    add $80                                       ; $2891
    ld e, a                                       ; $2893
    ld a, c                                       ; $2894
    ld [de], a                                    ; $2895
    ld a, d                                       ; $2896
    sub $07                                       ; $2897
    ld d, a                                       ; $2899
    inc e                                         ; $289A
    ld a, l                                       ; $289B
    add $f1                                       ; $289C
    ld l, a                                       ; $289E
    ld c, [hl]                                    ; $289F
    ld a, [bc]                                    ; $28A0
    swap a                                        ; $28A1
    ldh [hR2], a                                  ; $28A3
    ld a, l                                       ; $28A5
    add $10                                       ; $28A6
    ld l, a                                       ; $28A8
    ld c, [hl]                                    ; $28A9
    ld a, [bc]                                    ; $28AA
    ld c, a                                       ; $28AB
    ldh a, [hR2]                                  ; $28AC
    or c                                          ; $28AE
    ld c, a                                       ; $28AF
    ld [de], a                                    ; $28B0
    ld a, e                                       ; $28B1
    add $80                                       ; $28B2
    ld e, a                                       ; $28B4
    ld a, c                                       ; $28B5
    ld [de], a                                    ; $28B6
    ld a, d                                       ; $28B7
    add $07                                       ; $28B8
    ld d, a                                       ; $28BA
    ld a, c                                       ; $28BB
    ld [de], a                                    ; $28BC
    ld a, e                                       ; $28BD
    add $80                                       ; $28BE
    ld e, a                                       ; $28C0
    ld a, c                                       ; $28C1
    ld [de], a                                    ; $28C2
    ld a, d                                       ; $28C3
    sub $07                                       ; $28C4
    ld d, a                                       ; $28C6
    inc e                                         ; $28C7
    ld a, l                                       ; $28C8
    add $f3                                       ; $28C9
    ld l, a                                       ; $28CB
    ld c, [hl]                                    ; $28CC
    ld a, [bc]                                    ; $28CD
    swap a                                        ; $28CE
    ldh [hR2], a                                  ; $28D0
    ld a, l                                       ; $28D2
    add $10                                       ; $28D3
    ld l, a                                       ; $28D5
    ld c, [hl]                                    ; $28D6
    ld a, [bc]                                    ; $28D7
    ld c, a                                       ; $28D8
    ldh a, [hR2]                                  ; $28D9
    or c                                          ; $28DB
    ld c, a                                       ; $28DC
    ld [de], a                                    ; $28DD
    ld a, e                                       ; $28DE
    add $80                                       ; $28DF
    ld e, a                                       ; $28E1
    ld a, c                                       ; $28E2
    ld [de], a                                    ; $28E3
    ld a, d                                       ; $28E4
    add $07                                       ; $28E5
    ld d, a                                       ; $28E7
    ld a, c                                       ; $28E8
    ld [de], a                                    ; $28E9
    ld a, e                                       ; $28EA
    add $80                                       ; $28EB
    ld e, a                                       ; $28ED
    ld a, c                                       ; $28EE
    ld [de], a                                    ; $28EF
    ld a, d                                       ; $28F0
    sub $07                                       ; $28F1
    ld d, a                                       ; $28F3
    inc e                                         ; $28F4
    ld a, l                                       ; $28F5
    add $f1                                       ; $28F6
    ld l, a                                       ; $28F8
    ld c, [hl]                                    ; $28F9
    ld a, [bc]                                    ; $28FA
    swap a                                        ; $28FB
    ldh [hR2], a                                  ; $28FD
    ld a, l                                       ; $28FF
    add $10                                       ; $2900
    ld l, a                                       ; $2902
    ld c, [hl]                                    ; $2903
    ld a, [bc]                                    ; $2904
    ld c, a                                       ; $2905
    ldh a, [hR2]                                  ; $2906
    or c                                          ; $2908
    ld c, a                                       ; $2909
    ld [de], a                                    ; $290A
    ld a, e                                       ; $290B
    add $80                                       ; $290C
    ld e, a                                       ; $290E
    ld a, c                                       ; $290F
    ld [de], a                                    ; $2910
    ld a, d                                       ; $2911
    add $07                                       ; $2912
    ld d, a                                       ; $2914
    ld a, c                                       ; $2915
    ld [de], a                                    ; $2916
    ld a, e                                       ; $2917
    add $80                                       ; $2918
    ld e, a                                       ; $291A
    ld a, c                                       ; $291B
    ld [de], a                                    ; $291C
    ld a, d                                       ; $291D
    sub $07                                       ; $291E
    ld d, a                                       ; $2920
    inc e                                         ; $2921
    ldh a, [hR1]                                  ; $2922
    dec a                                         ; $2924
    jr z, jr_000_2931                             ; $2925

    ldh [hR1], a                                  ; $2927
    dec h                                         ; $2929
    ld a, l                                       ; $292A
    add $03                                       ; $292B
    ld l, a                                       ; $292D
    jp Jump_000_2655                              ; $292E


jr_000_2931:
    ldh a, [hR0]                                  ; $2931
    dec a                                         ; $2933
    ret z                                         ; $2934

    ldh [hR0], a                                  ; $2935
    ld a, e                                       ; $2937
    add $80                                       ; $2938
    ld e, a                                       ; $293A
    inc d                                         ; $293B
    inc h                                         ; $293C
    ld l, $00                                     ; $293D
    jp Jump_000_2651                              ; $293F


; C: entry 9 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode09::
    ld de, wB_ADR                                 ; $2942
    jp ImageCopy_Common2AC0                       ; $2945


; C: entry 10 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode10::
    ld de, wImageCopy_Mode01_D080                 ; $2948
    jp ImageCopy_Common2AC0                       ; $294B


; C: entry 11 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode11::
    ld de, wImageCopy_Mode03_D700                 ; $294E
    jp ImageCopy_Common2AC0                       ; $2951


; C: entry 12 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode12::
    ld de, wImageCopy_Mode12_D780                 ; $2954
    jp ImageCopy_Common2AC0                       ; $2957


; C: entry 13 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode13::
    ld de, wB_ADR                                 ; $295A
    ld hl, $a100                                  ; $295D
    ld a, $0e                                     ; $2960
    ldh [hR0], a                                  ; $2962

Jump_000_2964:
    ld a, $08                                     ; $2964
    ldh [hR1], a                                  ; $2966

Jump_000_2968:
    REPT 16                                       ; $2968
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    ldh a, [hR1]                                  ; $2998
    dec a                                         ; $299A
    jr z, jr_000_29a2                             ; $299B

    ldh [hR1], a                                  ; $299D
    jp Jump_000_2968                              ; $299F


jr_000_29a2:
    ldh a, [hR0]                                  ; $29A2
    dec a                                         ; $29A4
    ret z                                         ; $29A5

    ldh [hR0], a                                  ; $29A6
    ld a, e                                       ; $29A8
    add $80                                       ; $29A9
    ld e, a                                       ; $29AB
    inc d                                         ; $29AC
    inc h                                         ; $29AD
    ld l, $00                                     ; $29AE
    jp Jump_000_2964                              ; $29B0


; C: entry 14 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode14::
    ld de, wImageCopy_Mode01_D080                 ; $29B3
    ld hl, $a180                                  ; $29B6
    ld a, $0e                                     ; $29B9
    ldh [hR0], a                                  ; $29BB

Jump_000_29bd:
    ld a, $08                                     ; $29BD
    ldh [hR1], a                                  ; $29BF

Jump_000_29c1:
    REPT 16                                       ; $29C1
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    ldh a, [hR1]                                  ; $29F1
    dec a                                         ; $29F3
    jr z, jr_000_29fb                             ; $29F4

    ldh [hR1], a                                  ; $29F6
    jp Jump_000_29c1                              ; $29F8


jr_000_29fb:
    ldh a, [hR0]                                  ; $29FB
    dec a                                         ; $29FD
    ret z                                         ; $29FE

    ldh [hR0], a                                  ; $29FF
    ld a, e                                       ; $2A01
    add $80                                       ; $2A02
    ld e, a                                       ; $2A04
    inc d                                         ; $2A05
    ld l, $80                                     ; $2A06
    jp Jump_000_29bd                              ; $2A08


; C: entry 15 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode15::
    ld hl, $a100                                  ; $2A0B
    ld de, wB_ADR                                 ; $2A0E
    ld b, $07                                     ; $2A11
    call Copy_Pages                               ; $2A13
    ret                                           ; $2A16


; C: entry 16 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode16::
    ld hl, $a800                                  ; $2A17
    ld de, wImageCopy_Mode03_D700                 ; $2A1A
    ld b, $07                                     ; $2A1D
    call Copy_Pages                               ; $2A1F
    ret                                           ; $2A22


; C: entry 17 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode17::
    ld de, wB_ADR                                 ; $2A23
    jp ImageCopy_Common2C4B                       ; $2A26


; C: entry 18 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode18::
    ld de, wImageCopy_Mode01_D080                 ; $2A29
    jp ImageCopy_Common2C4B                       ; $2A2C


; C: entry 19 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode19::
    ld hl, $a100                                  ; $2A2F
    ld de, wB_ADR                                 ; $2A32
    ld b, $0a                                     ; $2A35
    call Copy_Pages                               ; $2A37
    ret                                           ; $2A3A


; C: entry 20 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode20::
    ld hl, $ab00                                  ; $2A3B
    ld de, wImageCopy_Mode20_DA00                 ; $2A3E
    ld b, $04                                     ; $2A41
    call Copy_Pages                               ; $2A43
    ret                                           ; $2A46


; C: entry 21 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode21::
    ld hl, $a100                                  ; $2A47
    ld de, wB_ADR                                 ; $2A4A
    ld b, $04                                     ; $2A4D
    call Copy_Pages                               ; $2A4F
    ret                                           ; $2A52


; C: entry 22 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode22::
    ld hl, $a500                                  ; $2A53
    ld de, wImageCopy_Mode22_D400                 ; $2A56
    ld b, $0a                                     ; $2A59
    call Copy_Pages                               ; $2A5B
    ret                                           ; $2A5E


; C: entry 23 of ImageCopy_ModeTable: copies a slice of the picture from SRAM ($A000-$BFFF) to WRAM ($D000-$DFFF)
ImageCopy_Mode23::
    ld hl, $a440                                  ; $2A5F
    ld de, wImageCopy_Mode23_D340                 ; $2A62
    ld a, $09                                     ; $2A65
    ldh [hR0], a                                  ; $2A67

Jump_000_2a69:
    ld a, $08                                     ; $2A69
    ldh [hR1], a                                  ; $2A6B

Jump_000_2a6d:
    REPT 16                                       ; $2A6D
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    ldh a, [hR1]                                  ; $2A9D
    dec a                                         ; $2A9F
    jr z, jr_000_2aa7                             ; $2AA0

    ldh [hR1], a                                  ; $2AA2
    jp Jump_000_2a6d                              ; $2AA4


jr_000_2aa7:
    ldh a, [hR0]                                  ; $2AA7
    dec a                                         ; $2AA9
    ret z                                         ; $2AAA

    ldh [hR0], a                                  ; $2AAB
    ld a, e                                       ; $2AAD
    add $80                                       ; $2AAE
    ld e, a                                       ; $2AB0
    inc d                                         ; $2AB1
    inc h                                         ; $2AB2
    ld l, $40                                     ; $2AB3
    jp Jump_000_2a69                              ; $2AB5


; C: entry 24 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode24_None::
    ret                                           ; $2AB8


; C: entry 25 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode25_None::
    ret                                           ; $2AB9


; C: entry 26 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode26_None::
    ret                                           ; $2ABA


; C: entry 27 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode27_None::
    ret                                           ; $2ABB


; C: entry 28 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode28_None::
    ret                                           ; $2ABC


; C: entry 29 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode29_None::
    ret                                           ; $2ABD


; C: entry 30 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode30_None::
    ret                                           ; $2ABE


; C: entry 31 of ImageCopy_ModeTable: a lone ret (no copy)
ImageCopy_Mode31_None::
    ret                                           ; $2ABF


; C: shared tail of the image-copy modes 9-12 (each sets DE and jumps here: jp $2AC0)
ImageCopy_Common2AC0::
    ld hl, $a100                                  ; $2AC0
    ld b, $45                                     ; $2AC3
    ld a, $07                                     ; $2AC5
    ldh [hR0], a                                  ; $2AC7

Jump_000_2ac9:
    ld a, $08                                     ; $2AC9
    ldh [hR1], a                                  ; $2ACB

Jump_000_2acd:
    ld c, [hl]                                    ; $2ACD
    ld a, [bc]                                    ; $2ACE
    swap a                                        ; $2ACF
    ldh [hR2], a                                  ; $2AD1
    ld a, l                                       ; $2AD3
    add $10                                       ; $2AD4
    ld l, a                                       ; $2AD6
    ld c, [hl]                                    ; $2AD7
    ld a, [bc]                                    ; $2AD8
    ld c, a                                       ; $2AD9
    ldh a, [hR2]                                  ; $2ADA
    or c                                          ; $2ADC
    ld [de], a                                    ; $2ADD
    inc e                                         ; $2ADE
    ld a, l                                       ; $2ADF
    add $f1                                       ; $2AE0
    ld l, a                                       ; $2AE2
    ld c, [hl]                                    ; $2AE3
    ld a, [bc]                                    ; $2AE4
    swap a                                        ; $2AE5
    ldh [hR2], a                                  ; $2AE7
    ld a, l                                       ; $2AE9
    add $10                                       ; $2AEA
    ld l, a                                       ; $2AEC
    ld c, [hl]                                    ; $2AED
    ld a, [bc]                                    ; $2AEE
    ld c, a                                       ; $2AEF
    ldh a, [hR2]                                  ; $2AF0
    or c                                          ; $2AF2
    ld [de], a                                    ; $2AF3
    inc e                                         ; $2AF4
    ld a, l                                       ; $2AF5
    add $f3                                       ; $2AF6
    ld l, a                                       ; $2AF8
    ld c, [hl]                                    ; $2AF9
    ld a, [bc]                                    ; $2AFA
    swap a                                        ; $2AFB
    ldh [hR2], a                                  ; $2AFD
    ld a, l                                       ; $2AFF
    add $10                                       ; $2B00
    ld l, a                                       ; $2B02
    ld c, [hl]                                    ; $2B03
    ld a, [bc]                                    ; $2B04
    ld c, a                                       ; $2B05
    ldh a, [hR2]                                  ; $2B06
    or c                                          ; $2B08
    ld [de], a                                    ; $2B09
    inc e                                         ; $2B0A
    ld a, l                                       ; $2B0B
    add $f1                                       ; $2B0C
    ld l, a                                       ; $2B0E
    ld c, [hl]                                    ; $2B0F
    ld a, [bc]                                    ; $2B10
    swap a                                        ; $2B11
    ldh [hR2], a                                  ; $2B13
    ld a, l                                       ; $2B15
    add $10                                       ; $2B16
    ld l, a                                       ; $2B18
    ld c, [hl]                                    ; $2B19
    ld a, [bc]                                    ; $2B1A
    ld c, a                                       ; $2B1B
    ldh a, [hR2]                                  ; $2B1C
    or c                                          ; $2B1E
    ld [de], a                                    ; $2B1F
    inc e                                         ; $2B20
    ld a, l                                       ; $2B21
    add $f3                                       ; $2B22
    ld l, a                                       ; $2B24
    ld c, [hl]                                    ; $2B25
    ld a, [bc]                                    ; $2B26
    swap a                                        ; $2B27
    ldh [hR2], a                                  ; $2B29
    ld a, l                                       ; $2B2B
    add $10                                       ; $2B2C
    ld l, a                                       ; $2B2E
    ld c, [hl]                                    ; $2B2F
    ld a, [bc]                                    ; $2B30
    ld c, a                                       ; $2B31
    ldh a, [hR2]                                  ; $2B32
    or c                                          ; $2B34
    ld [de], a                                    ; $2B35
    inc e                                         ; $2B36
    ld a, l                                       ; $2B37
    add $f1                                       ; $2B38
    ld l, a                                       ; $2B3A
    ld c, [hl]                                    ; $2B3B
    ld a, [bc]                                    ; $2B3C
    swap a                                        ; $2B3D
    ldh [hR2], a                                  ; $2B3F
    ld a, l                                       ; $2B41
    add $10                                       ; $2B42
    ld l, a                                       ; $2B44
    ld c, [hl]                                    ; $2B45
    ld a, [bc]                                    ; $2B46
    ld c, a                                       ; $2B47
    ldh a, [hR2]                                  ; $2B48
    or c                                          ; $2B4A
    ld [de], a                                    ; $2B4B
    inc e                                         ; $2B4C
    ld a, l                                       ; $2B4D
    add $f3                                       ; $2B4E
    ld l, a                                       ; $2B50
    ld c, [hl]                                    ; $2B51
    ld a, [bc]                                    ; $2B52
    swap a                                        ; $2B53
    ldh [hR2], a                                  ; $2B55
    ld a, l                                       ; $2B57
    add $10                                       ; $2B58
    ld l, a                                       ; $2B5A
    ld c, [hl]                                    ; $2B5B
    ld a, [bc]                                    ; $2B5C
    ld c, a                                       ; $2B5D
    ldh a, [hR2]                                  ; $2B5E
    or c                                          ; $2B60
    ld [de], a                                    ; $2B61
    inc e                                         ; $2B62
    ld a, l                                       ; $2B63
    add $f1                                       ; $2B64
    ld l, a                                       ; $2B66
    ld c, [hl]                                    ; $2B67
    ld a, [bc]                                    ; $2B68
    swap a                                        ; $2B69
    ldh [hR2], a                                  ; $2B6B
    ld a, l                                       ; $2B6D
    add $10                                       ; $2B6E
    ld l, a                                       ; $2B70
    ld c, [hl]                                    ; $2B71
    ld a, [bc]                                    ; $2B72
    ld c, a                                       ; $2B73
    ldh a, [hR2]                                  ; $2B74
    or c                                          ; $2B76
    ld [de], a                                    ; $2B77
    inc e                                         ; $2B78
    inc h                                         ; $2B79
    ld a, l                                       ; $2B7A
    add $e3                                       ; $2B7B
    ld l, a                                       ; $2B7D
    ld c, [hl]                                    ; $2B7E
    ld a, [bc]                                    ; $2B7F
    swap a                                        ; $2B80
    ldh [hR2], a                                  ; $2B82
    ld a, l                                       ; $2B84
    add $10                                       ; $2B85
    ld l, a                                       ; $2B87
    ld c, [hl]                                    ; $2B88
    ld a, [bc]                                    ; $2B89
    ld c, a                                       ; $2B8A
    ldh a, [hR2]                                  ; $2B8B
    or c                                          ; $2B8D
    ld [de], a                                    ; $2B8E
    inc e                                         ; $2B8F
    ld a, l                                       ; $2B90
    add $f1                                       ; $2B91
    ld l, a                                       ; $2B93
    ld c, [hl]                                    ; $2B94
    ld a, [bc]                                    ; $2B95
    swap a                                        ; $2B96
    ldh [hR2], a                                  ; $2B98
    ld a, l                                       ; $2B9A
    add $10                                       ; $2B9B
    ld l, a                                       ; $2B9D
    ld c, [hl]                                    ; $2B9E
    ld a, [bc]                                    ; $2B9F
    ld c, a                                       ; $2BA0
    ldh a, [hR2]                                  ; $2BA1
    or c                                          ; $2BA3
    ld [de], a                                    ; $2BA4
    inc e                                         ; $2BA5
    ld a, l                                       ; $2BA6
    add $f3                                       ; $2BA7
    ld l, a                                       ; $2BA9
    ld c, [hl]                                    ; $2BAA
    ld a, [bc]                                    ; $2BAB
    swap a                                        ; $2BAC
    ldh [hR2], a                                  ; $2BAE
    ld a, l                                       ; $2BB0
    add $10                                       ; $2BB1
    ld l, a                                       ; $2BB3
    ld c, [hl]                                    ; $2BB4
    ld a, [bc]                                    ; $2BB5
    ld c, a                                       ; $2BB6
    ldh a, [hR2]                                  ; $2BB7
    or c                                          ; $2BB9
    ld [de], a                                    ; $2BBA
    inc e                                         ; $2BBB
    ld a, l                                       ; $2BBC
    add $f1                                       ; $2BBD
    ld l, a                                       ; $2BBF
    ld c, [hl]                                    ; $2BC0
    ld a, [bc]                                    ; $2BC1
    swap a                                        ; $2BC2
    ldh [hR2], a                                  ; $2BC4
    ld a, l                                       ; $2BC6
    add $10                                       ; $2BC7
    ld l, a                                       ; $2BC9
    ld c, [hl]                                    ; $2BCA
    ld a, [bc]                                    ; $2BCB
    ld c, a                                       ; $2BCC
    ldh a, [hR2]                                  ; $2BCD
    or c                                          ; $2BCF
    ld [de], a                                    ; $2BD0
    inc e                                         ; $2BD1
    ld a, l                                       ; $2BD2
    add $f3                                       ; $2BD3
    ld l, a                                       ; $2BD5
    ld c, [hl]                                    ; $2BD6
    ld a, [bc]                                    ; $2BD7
    swap a                                        ; $2BD8
    ldh [hR2], a                                  ; $2BDA
    ld a, l                                       ; $2BDC
    add $10                                       ; $2BDD
    ld l, a                                       ; $2BDF
    ld c, [hl]                                    ; $2BE0
    ld a, [bc]                                    ; $2BE1
    ld c, a                                       ; $2BE2
    ldh a, [hR2]                                  ; $2BE3
    or c                                          ; $2BE5
    ld [de], a                                    ; $2BE6
    inc e                                         ; $2BE7
    ld a, l                                       ; $2BE8
    add $f1                                       ; $2BE9
    ld l, a                                       ; $2BEB
    ld c, [hl]                                    ; $2BEC
    ld a, [bc]                                    ; $2BED
    swap a                                        ; $2BEE
    ldh [hR2], a                                  ; $2BF0
    ld a, l                                       ; $2BF2
    add $10                                       ; $2BF3
    ld l, a                                       ; $2BF5
    ld c, [hl]                                    ; $2BF6
    ld a, [bc]                                    ; $2BF7
    ld c, a                                       ; $2BF8
    ldh a, [hR2]                                  ; $2BF9
    or c                                          ; $2BFB
    ld [de], a                                    ; $2BFC
    inc e                                         ; $2BFD
    ld a, l                                       ; $2BFE
    add $f3                                       ; $2BFF
    ld l, a                                       ; $2C01
    ld c, [hl]                                    ; $2C02
    ld a, [bc]                                    ; $2C03
    swap a                                        ; $2C04
    ldh [hR2], a                                  ; $2C06
    ld a, l                                       ; $2C08
    add $10                                       ; $2C09
    ld l, a                                       ; $2C0B
    ld c, [hl]                                    ; $2C0C
    ld a, [bc]                                    ; $2C0D
    ld c, a                                       ; $2C0E
    ldh a, [hR2]                                  ; $2C0F
    or c                                          ; $2C11
    ld [de], a                                    ; $2C12
    inc e                                         ; $2C13
    ld a, l                                       ; $2C14
    add $f1                                       ; $2C15
    ld l, a                                       ; $2C17
    ld c, [hl]                                    ; $2C18
    ld a, [bc]                                    ; $2C19
    swap a                                        ; $2C1A
    ldh [hR2], a                                  ; $2C1C
    ld a, l                                       ; $2C1E
    add $10                                       ; $2C1F
    ld l, a                                       ; $2C21
    ld c, [hl]                                    ; $2C22
    ld a, [bc]                                    ; $2C23
    ld c, a                                       ; $2C24
    ldh a, [hR2]                                  ; $2C25
    or c                                          ; $2C27
    ld [de], a                                    ; $2C28
    inc e                                         ; $2C29
    ldh a, [hR1]                                  ; $2C2A
    dec a                                         ; $2C2C
    jr z, jr_000_2c39                             ; $2C2D

    ldh [hR1], a                                  ; $2C2F
    dec h                                         ; $2C31
    ld a, l                                       ; $2C32
    add $03                                       ; $2C33
    ld l, a                                       ; $2C35
    jp Jump_000_2acd                              ; $2C36


jr_000_2c39:
    ldh a, [hR0]                                  ; $2C39
    dec a                                         ; $2C3B
    ret z                                         ; $2C3C

    ldh [hR0], a                                  ; $2C3D
    ld a, e                                       ; $2C3F
    add $80                                       ; $2C40
    ld e, a                                       ; $2C42
    inc d                                         ; $2C43
    inc h                                         ; $2C44
    ld l, $00                                     ; $2C45
    jp Jump_000_2ac9                              ; $2C47


; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_2C4A::
    db $c9

; C: shared tail of the image-copy modes 17 and 18 (each sets DE and jumps here: jp $2C4B)
ImageCopy_Common2C4B::
    ld hl, $a100                                  ; $2C4B
    ld b, $45                                     ; $2C4E
    ld a, $07                                     ; $2C50
    ldh [hR0], a                                  ; $2C52

Jump_000_2c54:
    ld a, $08                                     ; $2C54
    ldh [hR1], a                                  ; $2C56

Jump_000_2c58:
    ld c, [hl]                                    ; $2C58
    ld a, [bc]                                    ; $2C59
    swap a                                        ; $2C5A
    ldh [hR2], a                                  ; $2C5C
    ld a, l                                       ; $2C5E
    add $10                                       ; $2C5F
    ld l, a                                       ; $2C61
    ld c, [hl]                                    ; $2C62
    ld a, [bc]                                    ; $2C63
    ld c, a                                       ; $2C64
    ldh a, [hR2]                                  ; $2C65
    or c                                          ; $2C67
    ld c, a                                       ; $2C68
    ld [de], a                                    ; $2C69
    ld a, e                                       ; $2C6A
    add $80                                       ; $2C6B
    ld e, a                                       ; $2C6D
    ld a, d                                       ; $2C6E
    add $07                                       ; $2C6F
    ld d, a                                       ; $2C71
    ld a, c                                       ; $2C72
    ld [de], a                                    ; $2C73
    ld a, d                                       ; $2C74
    sub $07                                       ; $2C75
    ld d, a                                       ; $2C77
    ld a, e                                       ; $2C78
    add $81                                       ; $2C79
    ld e, a                                       ; $2C7B
    ld a, l                                       ; $2C7C
    add $f1                                       ; $2C7D
    ld l, a                                       ; $2C7F
    ld c, [hl]                                    ; $2C80
    ld a, [bc]                                    ; $2C81
    swap a                                        ; $2C82
    ldh [hR2], a                                  ; $2C84
    ld a, l                                       ; $2C86
    add $10                                       ; $2C87
    ld l, a                                       ; $2C89
    ld c, [hl]                                    ; $2C8A
    ld a, [bc]                                    ; $2C8B
    ld c, a                                       ; $2C8C
    ldh a, [hR2]                                  ; $2C8D
    or c                                          ; $2C8F
    ld c, a                                       ; $2C90
    ld [de], a                                    ; $2C91
    ld a, e                                       ; $2C92
    add $80                                       ; $2C93
    ld e, a                                       ; $2C95
    ld a, d                                       ; $2C96
    add $07                                       ; $2C97
    ld d, a                                       ; $2C99
    ld a, c                                       ; $2C9A
    ld [de], a                                    ; $2C9B
    ld a, d                                       ; $2C9C
    sub $07                                       ; $2C9D
    ld d, a                                       ; $2C9F
    ld a, e                                       ; $2CA0
    add $81                                       ; $2CA1
    ld e, a                                       ; $2CA3
    ld a, l                                       ; $2CA4
    add $f3                                       ; $2CA5
    ld l, a                                       ; $2CA7
    ld c, [hl]                                    ; $2CA8
    ld a, [bc]                                    ; $2CA9
    swap a                                        ; $2CAA
    ldh [hR2], a                                  ; $2CAC
    ld a, l                                       ; $2CAE
    add $10                                       ; $2CAF
    ld l, a                                       ; $2CB1
    ld c, [hl]                                    ; $2CB2
    ld a, [bc]                                    ; $2CB3
    ld c, a                                       ; $2CB4
    ldh a, [hR2]                                  ; $2CB5
    or c                                          ; $2CB7
    ld c, a                                       ; $2CB8
    ld [de], a                                    ; $2CB9
    ld a, e                                       ; $2CBA
    add $80                                       ; $2CBB
    ld e, a                                       ; $2CBD
    ld a, d                                       ; $2CBE
    add $07                                       ; $2CBF
    ld d, a                                       ; $2CC1
    ld a, c                                       ; $2CC2
    ld [de], a                                    ; $2CC3
    ld a, d                                       ; $2CC4
    sub $07                                       ; $2CC5
    ld d, a                                       ; $2CC7
    ld a, e                                       ; $2CC8
    add $81                                       ; $2CC9
    ld e, a                                       ; $2CCB
    ld a, l                                       ; $2CCC
    add $f1                                       ; $2CCD
    ld l, a                                       ; $2CCF
    ld c, [hl]                                    ; $2CD0
    ld a, [bc]                                    ; $2CD1
    swap a                                        ; $2CD2
    ldh [hR2], a                                  ; $2CD4
    ld a, l                                       ; $2CD6
    add $10                                       ; $2CD7
    ld l, a                                       ; $2CD9
    ld c, [hl]                                    ; $2CDA
    ld a, [bc]                                    ; $2CDB
    ld c, a                                       ; $2CDC
    ldh a, [hR2]                                  ; $2CDD
    or c                                          ; $2CDF
    ld c, a                                       ; $2CE0
    ld [de], a                                    ; $2CE1
    ld a, e                                       ; $2CE2
    add $80                                       ; $2CE3
    ld e, a                                       ; $2CE5
    ld a, d                                       ; $2CE6
    add $07                                       ; $2CE7
    ld d, a                                       ; $2CE9
    ld a, c                                       ; $2CEA
    ld [de], a                                    ; $2CEB
    ld a, d                                       ; $2CEC
    sub $07                                       ; $2CED
    ld d, a                                       ; $2CEF
    ld a, e                                       ; $2CF0
    add $81                                       ; $2CF1
    ld e, a                                       ; $2CF3
    ld a, l                                       ; $2CF4
    add $f3                                       ; $2CF5
    ld l, a                                       ; $2CF7
    ld c, [hl]                                    ; $2CF8
    ld a, [bc]                                    ; $2CF9
    swap a                                        ; $2CFA
    ldh [hR2], a                                  ; $2CFC
    ld a, l                                       ; $2CFE
    add $10                                       ; $2CFF
    ld l, a                                       ; $2D01
    ld c, [hl]                                    ; $2D02
    ld a, [bc]                                    ; $2D03
    ld c, a                                       ; $2D04
    ldh a, [hR2]                                  ; $2D05
    or c                                          ; $2D07
    ld c, a                                       ; $2D08
    ld [de], a                                    ; $2D09
    ld a, e                                       ; $2D0A
    add $80                                       ; $2D0B
    ld e, a                                       ; $2D0D
    ld a, d                                       ; $2D0E
    add $07                                       ; $2D0F
    ld d, a                                       ; $2D11
    ld a, c                                       ; $2D12
    ld [de], a                                    ; $2D13
    ld a, d                                       ; $2D14
    sub $07                                       ; $2D15
    ld d, a                                       ; $2D17
    ld a, e                                       ; $2D18
    add $81                                       ; $2D19
    ld e, a                                       ; $2D1B
    ld a, l                                       ; $2D1C
    add $f1                                       ; $2D1D
    ld l, a                                       ; $2D1F
    ld c, [hl]                                    ; $2D20
    ld a, [bc]                                    ; $2D21
    swap a                                        ; $2D22
    ldh [hR2], a                                  ; $2D24
    ld a, l                                       ; $2D26
    add $10                                       ; $2D27
    ld l, a                                       ; $2D29
    ld c, [hl]                                    ; $2D2A
    ld a, [bc]                                    ; $2D2B
    ld c, a                                       ; $2D2C
    ldh a, [hR2]                                  ; $2D2D
    or c                                          ; $2D2F
    ld c, a                                       ; $2D30
    ld [de], a                                    ; $2D31
    ld a, e                                       ; $2D32
    add $80                                       ; $2D33
    ld e, a                                       ; $2D35
    ld a, d                                       ; $2D36
    add $07                                       ; $2D37
    ld d, a                                       ; $2D39
    ld a, c                                       ; $2D3A
    ld [de], a                                    ; $2D3B
    ld a, d                                       ; $2D3C
    sub $07                                       ; $2D3D
    ld d, a                                       ; $2D3F
    ld a, e                                       ; $2D40
    add $81                                       ; $2D41
    ld e, a                                       ; $2D43
    ld a, l                                       ; $2D44
    add $f3                                       ; $2D45
    ld l, a                                       ; $2D47
    ld c, [hl]                                    ; $2D48
    ld a, [bc]                                    ; $2D49
    swap a                                        ; $2D4A
    ldh [hR2], a                                  ; $2D4C
    ld a, l                                       ; $2D4E
    add $10                                       ; $2D4F
    ld l, a                                       ; $2D51
    ld c, [hl]                                    ; $2D52
    ld a, [bc]                                    ; $2D53
    ld c, a                                       ; $2D54
    ldh a, [hR2]                                  ; $2D55
    or c                                          ; $2D57
    ld c, a                                       ; $2D58
    ld [de], a                                    ; $2D59
    ld a, e                                       ; $2D5A
    add $80                                       ; $2D5B
    ld e, a                                       ; $2D5D
    ld a, d                                       ; $2D5E
    add $07                                       ; $2D5F
    ld d, a                                       ; $2D61
    ld a, c                                       ; $2D62
    ld [de], a                                    ; $2D63
    ld a, d                                       ; $2D64
    sub $07                                       ; $2D65
    ld d, a                                       ; $2D67
    ld a, e                                       ; $2D68
    add $81                                       ; $2D69
    ld e, a                                       ; $2D6B
    ld a, l                                       ; $2D6C
    add $f1                                       ; $2D6D
    ld l, a                                       ; $2D6F
    ld c, [hl]                                    ; $2D70
    ld a, [bc]                                    ; $2D71
    swap a                                        ; $2D72
    ldh [hR2], a                                  ; $2D74
    ld a, l                                       ; $2D76
    add $10                                       ; $2D77
    ld l, a                                       ; $2D79
    ld c, [hl]                                    ; $2D7A
    ld a, [bc]                                    ; $2D7B
    ld c, a                                       ; $2D7C
    ldh a, [hR2]                                  ; $2D7D
    or c                                          ; $2D7F
    ld c, a                                       ; $2D80
    ld [de], a                                    ; $2D81
    ld a, e                                       ; $2D82
    add $80                                       ; $2D83
    ld e, a                                       ; $2D85
    ld a, d                                       ; $2D86
    add $07                                       ; $2D87
    ld d, a                                       ; $2D89
    ld a, c                                       ; $2D8A
    ld [de], a                                    ; $2D8B
    ld a, d                                       ; $2D8C
    sub $07                                       ; $2D8D
    ld d, a                                       ; $2D8F
    ld a, e                                       ; $2D90
    add $81                                       ; $2D91
    ld e, a                                       ; $2D93
    inc h                                         ; $2D94
    ld a, l                                       ; $2D95
    add $e3                                       ; $2D96
    ld l, a                                       ; $2D98
    ld c, [hl]                                    ; $2D99
    ld a, [bc]                                    ; $2D9A
    swap a                                        ; $2D9B
    ldh [hR2], a                                  ; $2D9D
    ld a, l                                       ; $2D9F
    add $10                                       ; $2DA0
    ld l, a                                       ; $2DA2
    ld c, [hl]                                    ; $2DA3
    ld a, [bc]                                    ; $2DA4
    ld c, a                                       ; $2DA5
    ldh a, [hR2]                                  ; $2DA6
    or c                                          ; $2DA8
    ld c, a                                       ; $2DA9
    ld [de], a                                    ; $2DAA
    ld a, e                                       ; $2DAB
    add $80                                       ; $2DAC
    ld e, a                                       ; $2DAE
    ld a, d                                       ; $2DAF
    add $07                                       ; $2DB0
    ld d, a                                       ; $2DB2
    ld a, c                                       ; $2DB3
    ld [de], a                                    ; $2DB4
    ld a, d                                       ; $2DB5
    sub $07                                       ; $2DB6
    ld d, a                                       ; $2DB8
    ld a, e                                       ; $2DB9
    add $81                                       ; $2DBA
    ld e, a                                       ; $2DBC
    ld a, l                                       ; $2DBD
    add $f1                                       ; $2DBE
    ld l, a                                       ; $2DC0
    ld c, [hl]                                    ; $2DC1
    ld a, [bc]                                    ; $2DC2
    swap a                                        ; $2DC3
    ldh [hR2], a                                  ; $2DC5
    ld a, l                                       ; $2DC7
    add $10                                       ; $2DC8
    ld l, a                                       ; $2DCA
    ld c, [hl]                                    ; $2DCB
    ld a, [bc]                                    ; $2DCC
    ld c, a                                       ; $2DCD
    ldh a, [hR2]                                  ; $2DCE
    or c                                          ; $2DD0
    ld c, a                                       ; $2DD1
    ld [de], a                                    ; $2DD2
    ld a, e                                       ; $2DD3
    add $80                                       ; $2DD4
    ld e, a                                       ; $2DD6
    ld a, d                                       ; $2DD7
    add $07                                       ; $2DD8
    ld d, a                                       ; $2DDA
    ld a, c                                       ; $2DDB
    ld [de], a                                    ; $2DDC
    ld a, d                                       ; $2DDD
    sub $07                                       ; $2DDE
    ld d, a                                       ; $2DE0
    ld a, e                                       ; $2DE1
    add $81                                       ; $2DE2
    ld e, a                                       ; $2DE4
    ld a, l                                       ; $2DE5
    add $f3                                       ; $2DE6
    ld l, a                                       ; $2DE8
    ld c, [hl]                                    ; $2DE9
    ld a, [bc]                                    ; $2DEA
    swap a                                        ; $2DEB
    ldh [hR2], a                                  ; $2DED
    ld a, l                                       ; $2DEF
    add $10                                       ; $2DF0
    ld l, a                                       ; $2DF2
    ld c, [hl]                                    ; $2DF3
    ld a, [bc]                                    ; $2DF4
    ld c, a                                       ; $2DF5
    ldh a, [hR2]                                  ; $2DF6
    or c                                          ; $2DF8
    ld c, a                                       ; $2DF9
    ld [de], a                                    ; $2DFA
    ld a, e                                       ; $2DFB
    add $80                                       ; $2DFC
    ld e, a                                       ; $2DFE
    ld a, d                                       ; $2DFF
    add $07                                       ; $2E00
    ld d, a                                       ; $2E02
    ld a, c                                       ; $2E03
    ld [de], a                                    ; $2E04
    ld a, d                                       ; $2E05
    sub $07                                       ; $2E06
    ld d, a                                       ; $2E08
    ld a, e                                       ; $2E09
    add $81                                       ; $2E0A
    ld e, a                                       ; $2E0C
    ld a, l                                       ; $2E0D
    add $f1                                       ; $2E0E
    ld l, a                                       ; $2E10
    ld c, [hl]                                    ; $2E11
    ld a, [bc]                                    ; $2E12
    swap a                                        ; $2E13
    ldh [hR2], a                                  ; $2E15
    ld a, l                                       ; $2E17
    add $10                                       ; $2E18
    ld l, a                                       ; $2E1A
    ld c, [hl]                                    ; $2E1B
    ld a, [bc]                                    ; $2E1C
    ld c, a                                       ; $2E1D
    ldh a, [hR2]                                  ; $2E1E
    or c                                          ; $2E20
    ld c, a                                       ; $2E21
    ld [de], a                                    ; $2E22
    ld a, e                                       ; $2E23
    add $80                                       ; $2E24
    ld e, a                                       ; $2E26
    ld a, d                                       ; $2E27
    add $07                                       ; $2E28
    ld d, a                                       ; $2E2A
    ld a, c                                       ; $2E2B
    ld [de], a                                    ; $2E2C
    ld a, d                                       ; $2E2D
    sub $07                                       ; $2E2E
    ld d, a                                       ; $2E30
    ld a, e                                       ; $2E31
    add $81                                       ; $2E32
    ld e, a                                       ; $2E34
    ld a, l                                       ; $2E35
    add $f3                                       ; $2E36
    ld l, a                                       ; $2E38
    ld c, [hl]                                    ; $2E39
    ld a, [bc]                                    ; $2E3A
    swap a                                        ; $2E3B
    ldh [hR2], a                                  ; $2E3D
    ld a, l                                       ; $2E3F
    add $10                                       ; $2E40
    ld l, a                                       ; $2E42
    ld c, [hl]                                    ; $2E43
    ld a, [bc]                                    ; $2E44
    ld c, a                                       ; $2E45
    ldh a, [hR2]                                  ; $2E46
    or c                                          ; $2E48
    ld c, a                                       ; $2E49
    ld [de], a                                    ; $2E4A
    ld a, e                                       ; $2E4B
    add $80                                       ; $2E4C
    ld e, a                                       ; $2E4E
    ld a, d                                       ; $2E4F
    add $07                                       ; $2E50
    ld d, a                                       ; $2E52
    ld a, c                                       ; $2E53
    ld [de], a                                    ; $2E54
    ld a, d                                       ; $2E55
    sub $07                                       ; $2E56
    ld d, a                                       ; $2E58
    ld a, e                                       ; $2E59
    add $81                                       ; $2E5A
    ld e, a                                       ; $2E5C
    ld a, l                                       ; $2E5D
    add $f1                                       ; $2E5E
    ld l, a                                       ; $2E60
    ld c, [hl]                                    ; $2E61
    ld a, [bc]                                    ; $2E62
    swap a                                        ; $2E63
    ldh [hR2], a                                  ; $2E65
    ld a, l                                       ; $2E67
    add $10                                       ; $2E68
    ld l, a                                       ; $2E6A
    ld c, [hl]                                    ; $2E6B
    ld a, [bc]                                    ; $2E6C
    ld c, a                                       ; $2E6D
    ldh a, [hR2]                                  ; $2E6E
    or c                                          ; $2E70
    ld c, a                                       ; $2E71
    ld [de], a                                    ; $2E72
    ld a, e                                       ; $2E73
    add $80                                       ; $2E74
    ld e, a                                       ; $2E76
    ld a, d                                       ; $2E77
    add $07                                       ; $2E78
    ld d, a                                       ; $2E7A
    ld a, c                                       ; $2E7B
    ld [de], a                                    ; $2E7C
    ld a, d                                       ; $2E7D
    sub $07                                       ; $2E7E
    ld d, a                                       ; $2E80
    ld a, e                                       ; $2E81
    add $81                                       ; $2E82
    ld e, a                                       ; $2E84
    ld a, l                                       ; $2E85
    add $f3                                       ; $2E86
    ld l, a                                       ; $2E88
    ld c, [hl]                                    ; $2E89
    ld a, [bc]                                    ; $2E8A
    swap a                                        ; $2E8B
    ldh [hR2], a                                  ; $2E8D
    ld a, l                                       ; $2E8F
    add $10                                       ; $2E90
    ld l, a                                       ; $2E92
    ld c, [hl]                                    ; $2E93
    ld a, [bc]                                    ; $2E94
    ld c, a                                       ; $2E95
    ldh a, [hR2]                                  ; $2E96
    or c                                          ; $2E98
    ld c, a                                       ; $2E99
    ld [de], a                                    ; $2E9A
    ld a, e                                       ; $2E9B
    add $80                                       ; $2E9C
    ld e, a                                       ; $2E9E
    ld a, d                                       ; $2E9F
    add $07                                       ; $2EA0
    ld d, a                                       ; $2EA2
    ld a, c                                       ; $2EA3
    ld [de], a                                    ; $2EA4
    ld a, d                                       ; $2EA5
    sub $07                                       ; $2EA6
    ld d, a                                       ; $2EA8
    ld a, e                                       ; $2EA9
    add $81                                       ; $2EAA
    ld e, a                                       ; $2EAC
    ld a, l                                       ; $2EAD
    add $f1                                       ; $2EAE
    ld l, a                                       ; $2EB0
    ld c, [hl]                                    ; $2EB1
    ld a, [bc]                                    ; $2EB2
    swap a                                        ; $2EB3
    ldh [hR2], a                                  ; $2EB5
    ld a, l                                       ; $2EB7
    add $10                                       ; $2EB8
    ld l, a                                       ; $2EBA
    ld c, [hl]                                    ; $2EBB
    ld a, [bc]                                    ; $2EBC
    ld c, a                                       ; $2EBD
    ldh a, [hR2]                                  ; $2EBE
    or c                                          ; $2EC0
    ld c, a                                       ; $2EC1
    ld [de], a                                    ; $2EC2
    ld a, e                                       ; $2EC3
    add $80                                       ; $2EC4
    ld e, a                                       ; $2EC6
    ld a, d                                       ; $2EC7
    add $07                                       ; $2EC8
    ld d, a                                       ; $2ECA
    ld a, c                                       ; $2ECB
    ld [de], a                                    ; $2ECC
    ld a, d                                       ; $2ECD
    sub $07                                       ; $2ECE
    ld d, a                                       ; $2ED0
    ld a, e                                       ; $2ED1
    add $81                                       ; $2ED2
    ld e, a                                       ; $2ED4
    ldh a, [hR1]                                  ; $2ED5
    dec a                                         ; $2ED7
    jr z, jr_000_2ee4                             ; $2ED8

    ldh [hR1], a                                  ; $2EDA
    dec h                                         ; $2EDC
    ld a, l                                       ; $2EDD
    add $03                                       ; $2EDE
    ld l, a                                       ; $2EE0
    jp Jump_000_2c58                              ; $2EE1


jr_000_2ee4:
    ldh a, [hR0]                                  ; $2EE4
    dec a                                         ; $2EE6
    ret z                                         ; $2EE7

    ldh [hR0], a                                  ; $2EE8
    ld a, e                                       ; $2EEA
    add $80                                       ; $2EEB
    ld e, a                                       ; $2EED
    inc d                                         ; $2EEE
    inc h                                         ; $2EEF
    ld l, $00                                     ; $2EF0
    jp Jump_000_2c54                              ; $2EF2


; C: unrolled copy: B pages of 256 bytes from HL to DE (ld a,[hl+]; ld [de],a; inc e; ... inc d; dec b; jp nz)
Copy_Pages::
    REPT 256                                      ; $2EF5
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 256 copies of 3 bytes
    inc d                                         ; $31F5
    dec b                                         ; $31F6
    jp nz, Copy_Pages                             ; $31F7

    ret                                           ; $31FA


; C: developers' name: same code as MAKE_EMI in the old build of table 2A at old 29ED (115 bytes, masked match)
MAKE_EMI::
    call LCDCOFF                                  ; $31FB
    call VRAM_CLR                                 ; $31FE
    call DMACLR                                   ; $3201
    ldh a, [hBANK_BUF]                            ; $3204
    push af                                       ; $3206
    ld a, $03                                     ; $3207
    ldh [hBANK_BUF], a                            ; $3209
    ld [$2100], a                                 ; $320B
    ld hl, Gfx_03_4001_FNTOOE3                    ; $320E
    ld de, $8000                                  ; $3211
    ld bc, $1800                                  ; $3214
    call Copy_Pages                               ; $3217
    ld hl, Map_03_5801_BG_MOVIE                   ; $321A
    ld de, $9800                                  ; $321D
    ld bc, $0240                                  ; $3220
    call DATA_MOV                                 ; $3223
    pop af                                        ; $3226
    ldh [hBANK_BUF], a                            ; $3227
    ld [$2100], a                                 ; $3229
    ld a, $80                                     ; $322C
    ldh [rSC], a                                  ; $322E
    ld a, $fe                                     ; $3230
    ldh [rSB], a                                  ; $3232
    xor a                                         ; $3234
    ldh [rWY], a                                  ; $3235
    ldh [rSCY], a                                 ; $3237
    ldh [hSCYW], a                                ; $3239
    ldh [rSCX], a                                 ; $323B
    ldh [hSCXW], a                                ; $323D
    ld a, $e4                                     ; $323F
    ldh [rOBP0], a                                ; $3241
    ldh [rBGP], a                                 ; $3243
    ldh [hOBP0W], a                               ; $3245
    ldh [hBGPW], a                                ; $3247
    ld a, $d0                                     ; $3249
    ldh [rOBP1], a                                ; $324B
    ldh [hOBP1W], a                               ; $324D
    ld a, SEQ_EMI                                 ; $324F
    ld [wGAME_SEQ], a                             ; $3251
    xor a                                         ; $3254
    ld [wGAME_SSEQ], a                            ; $3255
    ld a, $c3                                     ; $3258
    ldh [rLCDC], a                                ; $325A
    ld a, $58                                     ; $325C
    ld [wMY_OBJ_X], a                             ; $325E
    ld a, $5d                                     ; $3261
    ld [wMY_OBJ_Y], a                             ; $3263
    xor a                                         ; $3266
    ld [wN_COM_FLG], a                            ; $3267
    ld [wGAME_SSEQ], a                            ; $326A
    ret                                           ; $326D


; C: developers' name: same code as EMI_MAIN in the old build of table 2A at old 2A60 (39 bytes, masked match)
EMI_MAIN::
    ldh a, [hTRG1]                                ; $326E
    bit 1, a                                      ; $3270
    jr z, jr_000_327d                             ; $3272

    ld a, $05                                     ; $3274
    ld [wINF_CUR], a                              ; $3276
    call MAKE_MENU                                ; $3279
    ret                                           ; $327C


jr_000_327d:
    ld a, [wGAME_SSEQ]                            ; $327D
    cp $02                                        ; $3280
    jr z, N_TU_SIN                                ; $3282

    call N_KEY_INPUT                              ; $3284
    call N_OBJ_HYOUJI                             ; $3287
    ld a, [wN_COM_FLG]                            ; $328A
    and a                                         ; $328D
    ret z                                         ; $328E

    ld a, $02                                     ; $328F
    ld [wGAME_SSEQ], a                            ; $3291
    ret                                           ; $3294


; C: developers' name: same code as N_TU_SIN in the old build of table 2A at old 2A87 (19 bytes, masked match)
N_TU_SIN::
    ld a, [wN_COM_FLG]                            ; $3295
    and a                                         ; $3298
    ret z                                         ; $3299

    call N_OBJ_HYOUJI2                            ; $329A
    ld a, [wN_COM_FLG]                            ; $329D
    cp $02                                        ; $32A0
    ret nz                                        ; $32A2

    ld a, $81                                     ; $32A3
    ldh [rSC], a                                  ; $32A5
    ret                                           ; $32A7


; C: developers' name: same code as N_KEY_INPUT in the old build of table 2A at old 2A9A (16 bytes, exact match)
N_KEY_INPUT::
    ldh a, [hTRG1]                                ; $32A8
    bit 0, a                                      ; $32AA
    jr nz, jr_000_32af                            ; $32AC

    ret                                           ; $32AE


jr_000_32af:
    ld a, $00                                     ; $32AF
    ldh [rSB], a                                  ; $32B1
    ld a, $81                                     ; $32B3
    ldh [rSC], a                                  ; $32B5
    ret                                           ; $32B7


; I: developers' name: same code as N_OBJ_HYOUJI in the old build of table 2A at old 2AAA (14 bytes, exact match)
N_OBJ_HYOUJI::
    ld hl, wOBJRAM                                ; $32B8
    ld a, $54                                     ; $32BB
    ld [hl+], a                                   ; $32BD
    ld a, $50                                     ; $32BE
    ld [hl+], a                                   ; $32C0
    ld a, $00                                     ; $32C1
    ld [hl+], a                                   ; $32C3
    ld [hl], a                                    ; $32C4
    ret                                           ; $32C5


; C: developers' name: same code as N_OBJ_HYOUJI2 in the old build of table 2A at old 2AB8 (29 bytes, exact match)
N_OBJ_HYOUJI2::
    ld hl, wDOG_ANIME_C002                        ; $32C6
    ld a, [wR_DATA]                               ; $32C9
    srl a                                         ; $32CC
    srl a                                         ; $32CE
    srl a                                         ; $32D0
    srl a                                         ; $32D2
    ld [hl+], a                                   ; $32D4
    inc hl                                        ; $32D5
    ld a, $54                                     ; $32D6
    ld [hl+], a                                   ; $32D8
    ld a, $58                                     ; $32D9
    ld [hl+], a                                   ; $32DB
    ld a, [wR_DATA]                               ; $32DC
    and $0f                                       ; $32DF
    ld [hl+], a                                   ; $32E1
    ret                                           ; $32E2


; I: stores A in $C164 (AKARUSA in table $2A), returns when the mode in $C0F2 is 6, else selects SRAM bank 0 and ROM
; bank 4 (ld [$4000],0; ld [$2000],4) and goes on; not read further
Akarusa_Apply::
    ld [wAKARUSA], a                              ; $32E3
    ld a, [wB_MODE]                               ; $32E6
    and $0f                                       ; $32E9
    cp $06                                        ; $32EB
    ret z                                         ; $32ED

    ld a, $00                                     ; $32EE
    ld [rRAMB], a                                 ; $32F0
    ld a, $04                                     ; $32F3
    ld [rROMB0], a                                ; $32F5
    ld a, [wB_CNTR2]                              ; $32F8
    ld [wTEST1], a                                ; $32FB
    ld a, [wB_CNTR3]                              ; $32FE
    ld [wTEST2], a                                ; $3301
    ld bc, $0000                                  ; $3304
    ld de, $a000                                  ; $3307
    call SCREEN_CHECK                             ; $330A
    ld a, [wAKARUSA]                              ; $330D
    ld d, a                                       ; $3310
    sla c                                         ; $3311
    rl b                                          ; $3313
    sla c                                         ; $3315
    rl b                                          ; $3317
    sla c                                         ; $3319
    rl b                                          ; $331B
    ld a, b                                       ; $331D
    sub d                                         ; $331E
    jr nc, jr_000_3350                            ; $331F

    cpl                                           ; $3321
    inc a                                         ; $3322
    ld b, a                                       ; $3323
    ld [wTEST], a                                 ; $3324
    ld a, [wB_CNTR2]                              ; $3327
    ld h, a                                       ; $332A
    ld d, a                                       ; $332B
    ld a, [wB_CNTR3]                              ; $332C
    ld l, a                                       ; $332F
    ld e, a                                       ; $3330
    ld a, b                                       ; $3331
    ld bc, CHG_TIME_TBL_D                         ; $3332
    add c                                         ; $3335
    ld c, a                                       ; $3336
    jr nc, jr_000_333a                            ; $3337

    inc b                                         ; $3339

jr_000_333a:
    ld a, [bc]                                    ; $333A

jr_000_333b:
    cp $00                                        ; $333B
    jr z, jr_000_3346                             ; $333D

    srl d                                         ; $333F
    rr e                                          ; $3341
    dec a                                         ; $3343
    jr jr_000_333b                                ; $3344

jr_000_3346:
    ld a, d                                       ; $3346
    cpl                                           ; $3347
    ld d, a                                       ; $3348
    ld a, e                                       ; $3349
    cpl                                           ; $334A
    ld e, a                                       ; $334B
    inc de                                        ; $334C
    add hl, de                                    ; $334D
    jr jr_000_337c                                ; $334E

jr_000_3350:
    ld b, a                                       ; $3350
    ld [wTEST], a                                 ; $3351
    ld a, [wB_CNTR2]                              ; $3354
    ld h, a                                       ; $3357
    ld d, a                                       ; $3358
    ld a, [wB_CNTR3]                              ; $3359
    ld l, a                                       ; $335C
    ld e, a                                       ; $335D
    ld a, b                                       ; $335E
    cp $00                                        ; $335F
    ret z                                         ; $3361

    ld bc, CHG_TIME_TBL_U                         ; $3362
    add c                                         ; $3365
    ld c, a                                       ; $3366
    jr nc, jr_000_336a                            ; $3367

    inc b                                         ; $3369

jr_000_336a:
    ld a, [bc]                                    ; $336A

jr_000_336b:
    cp $00                                        ; $336B
    jr z, jr_000_3376                             ; $336D

    srl d                                         ; $336F
    rr e                                          ; $3371
    dec a                                         ; $3373
    jr jr_000_336b                                ; $3374

jr_000_3376:
    add hl, de                                    ; $3376
    jr nc, jr_000_337c                            ; $3377

    ld hl, $ffff                                  ; $3379

jr_000_337c:
    ld a, h                                       ; $337C
    ld [wB_CNTR2], a                              ; $337D
    ld a, l                                       ; $3380
    ld [wB_CNTR3], a                              ; $3381
    ld de, hAkarusa_Apply_FFDF                    ; $3384
    add hl, de                                    ; $3387
    jr c, jr_000_3394                             ; $3388

    ld a, $00                                     ; $338A
    ld [wB_CNTR2], a                              ; $338C
    ld a, $21                                     ; $338F
    ld [wB_CNTR3], a                              ; $3391

jr_000_3394:
    ld a, $10                                     ; $3394
    ld [rRAMB], a                                 ; $3396
    ld a, [wB_CNTR2]                              ; $3399
    ld [$a002], a                                 ; $339C
    ld a, [wB_CNTR3]                              ; $339F
    ld [$a003], a                                 ; $33A2
    ret                                           ; $33A5


; I: leftover: 52 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_33A6::
    db $3e, $04, $e0, $88, $cd, $2e, $34, $13, $13, $cd, $2e, $34, $13, $13, $cd, $2e
    db $34, $13, $13, $cd, $2e, $34, $13, $13, $13, $13, $cd, $2e, $34, $13, $13, $cd
    db $2e, $34, $13, $13, $cd, $2e, $34, $13, $13, $cd, $2e, $34, $f0, $88, $3d, $c8
    db $e0, $88, $18, $d0

; C: developers' name: same code as SCREEN_CHECK in the old build of table 2A at old 314B (84 bytes, masked match)
SCREEN_CHECK::
    ld a, $1c                                     ; $33DA
    ldh [hR0], a                                  ; $33DC

jr_000_33de:
    call BIT_COUNT                                ; $33DE
    ld hl, $0014                                  ; $33E1
    add hl, de                                    ; $33E4
    ld d, h                                       ; $33E5
    ld e, l                                       ; $33E6
    call BIT_COUNT                                ; $33E7
    ld hl, $0014                                  ; $33EA
    add hl, de                                    ; $33ED
    ld d, h                                       ; $33EE
    ld e, l                                       ; $33EF
    call BIT_COUNT                                ; $33F0
    ld hl, $0004                                  ; $33F3
    add hl, de                                    ; $33F6
    ld d, h                                       ; $33F7
    ld e, l                                       ; $33F8
    call BIT_COUNT                                ; $33F9
    ld hl, $0014                                  ; $33FC
    add hl, de                                    ; $33FF
    ld d, h                                       ; $3400
    ld e, l                                       ; $3401
    call BIT_COUNT                                ; $3402
    ld hl, $0014                                  ; $3405
    add hl, de                                    ; $3408
    ld d, h                                       ; $3409
    ld e, l                                       ; $340A
    call BIT_COUNT                                ; $340B
    ld hl, $0004                                  ; $340E
    add hl, de                                    ; $3411
    ld d, h                                       ; $3412
    ld e, l                                       ; $3413
    call BIT_COUNT                                ; $3414
    ld hl, $0014                                  ; $3417
    add hl, de                                    ; $341A
    ld d, h                                       ; $341B
    ld e, l                                       ; $341C
    call BIT_COUNT                                ; $341D
    ld hl, $0004                                  ; $3420
    add hl, de                                    ; $3423
    ld d, h                                       ; $3424
    ld e, l                                       ; $3425
    ldh a, [hR0]                                  ; $3426
    dec a                                         ; $3428
    ret z                                         ; $3429

    ldh [hR0], a                                  ; $342A
    jr jr_000_33de                                ; $342C

; I: adds popcount(byte) + 2 x popcount(next byte) through the table at 04:4100 into BC, eight times per call from
; SCREEN_CHECK: the dark pixels of 2bpp rows (C); BIT_COUNT is the routine the source text left in the ROM describes
; for this (docs §18.14), so the name is I
BIT_COUNT::
    ld h, $41                                     ; $342E
    ld a, [de]                                    ; $3430
    inc de                                        ; $3431
    ld l, a                                       ; $3432
    ld l, [hl]                                    ; $3433
    ld h, $00                                     ; $3434
    add hl, bc                                    ; $3436
    ld b, h                                       ; $3437
    ld c, l                                       ; $3438
    ld h, $41                                     ; $3439
    ld a, [de]                                    ; $343B
    inc de                                        ; $343C
    ld l, a                                       ; $343D
    ld l, [hl]                                    ; $343E
    sla l                                         ; $343F
    ld h, $00                                     ; $3441
    add hl, bc                                    ; $3443
    ld b, h                                       ; $3444
    ld c, l                                       ; $3445
    ret                                           ; $3446


; C: developers' name: same code as SET_DITH_MATRIX in the old build of table 2A at old 31B8 (374 bytes, masked match)
SET_DITH_MATRIX::
    ld hl, CONTRAST_ROWS                          ; $3447
    ld de, $0006                                  ; $344A

jr_000_344d:
    dec c                                         ; $344D
    jr z, jr_000_3453                             ; $344E

    add hl, de                                    ; $3450
    jr jr_000_344d                                ; $3451

jr_000_3453:
    ld de, wS0                                    ; $3453
    ld a, [hl+]                                   ; $3456
    ld [de], a                                    ; $3457
    inc de                                        ; $3458
    ld a, [hl+]                                   ; $3459
    ld [de], a                                    ; $345A
    inc de                                        ; $345B
    ld a, [hl+]                                   ; $345C
    ld [de], a                                    ; $345D
    inc de                                        ; $345E
    ld a, [hl+]                                   ; $345F
    ld [de], a                                    ; $3460
    inc de                                        ; $3461
    ld a, [hl+]                                   ; $3462
    ld [de], a                                    ; $3463
    inc de                                        ; $3464
    ld a, [hl+]                                   ; $3465
    ld [de], a                                    ; $3466
    ld hl, NO_DITHER_PAT                          ; $3467
    ld de, $0010                                  ; $346A
    ld a, b                                       ; $346D
    or a                                          ; $346E
    jr z, jr_000_3475                             ; $346F

jr_000_3471:
    add hl, de                                    ; $3471
    dec b                                         ; $3472
    jr nz, jr_000_3471                            ; $3473

jr_000_3475:
    ld de, wB_TH000                               ; $3475
    ld a, $10                                     ; $3478
    ld [wLOOP_COUNT], a                           ; $347A

jr_000_347d:
    ld a, [wW0]                                   ; $347D
    ld c, a                                       ; $3480
    ld a, [hl+]                                   ; $3481
    ld b, a                                       ; $3482
    xor a                                         ; $3483

jr_000_3484:
    dec c                                         ; $3484
    jr z, jr_000_348a                             ; $3485

    add b                                         ; $3487
    jr jr_000_3484                                ; $3488

jr_000_348a:
    ld b, a                                       ; $348A
    ld a, [wS0]                                   ; $348B
    add b                                         ; $348E
    ld [de], a                                    ; $348F
    inc de                                        ; $3490
    ld a, [wLOOP_COUNT]                           ; $3491
    dec a                                         ; $3494
    ld [wLOOP_COUNT], a                           ; $3495
    jr nz, jr_000_347d                            ; $3498

    ld bc, hSET_DITH_MATRIX_FFF0                  ; $349A
    add hl, bc                                    ; $349D
    ld a, $10                                     ; $349E
    ld [wLOOP_COUNT], a                           ; $34A0

jr_000_34a3:
    ld a, [wW1]                                   ; $34A3
    ld c, a                                       ; $34A6
    ld a, [hl+]                                   ; $34A7
    ld b, a                                       ; $34A8
    xor a                                         ; $34A9

jr_000_34aa:
    dec c                                         ; $34AA
    jr z, jr_000_34b0                             ; $34AB

    add b                                         ; $34AD
    jr jr_000_34aa                                ; $34AE

jr_000_34b0:
    ld b, a                                       ; $34B0
    ld a, [wS1]                                   ; $34B1
    add b                                         ; $34B4
    ld [de], a                                    ; $34B5
    inc de                                        ; $34B6
    ld a, [wLOOP_COUNT]                           ; $34B7
    dec a                                         ; $34BA
    ld [wLOOP_COUNT], a                           ; $34BB
    jr nz, jr_000_34a3                            ; $34BE

    ld bc, hSET_DITH_MATRIX_FFF0                  ; $34C0
    add hl, bc                                    ; $34C3
    ld a, $10                                     ; $34C4
    ld [wLOOP_COUNT], a                           ; $34C6

jr_000_34c9:
    ld a, [wW2]                                   ; $34C9
    ld c, a                                       ; $34CC
    ld a, [hl+]                                   ; $34CD
    ld b, a                                       ; $34CE
    xor a                                         ; $34CF

jr_000_34d0:
    dec c                                         ; $34D0
    jr z, jr_000_34d6                             ; $34D1

    add b                                         ; $34D3
    jr jr_000_34d0                                ; $34D4

jr_000_34d6:
    ld b, a                                       ; $34D6
    ld a, [wS2]                                   ; $34D7
    add b                                         ; $34DA
    ld [de], a                                    ; $34DB
    inc de                                        ; $34DC
    ld a, [wLOOP_COUNT]                           ; $34DD
    dec a                                         ; $34E0
    ld [wLOOP_COUNT], a                           ; $34E1
    jr nz, jr_000_34c9                            ; $34E4

    ld a, [wRAM_BANK_BUF]                         ; $34E6
    push af                                       ; $34E9
    ld a, $10                                     ; $34EA
    ld [wRAM_BANK_BUF], a                         ; $34EC
    ld [rRAMB], a                                 ; $34EF
    ld hl, $a006                                  ; $34F2
    ld a, [wB_TH000]                              ; $34F5
    ld [hl+], a                                   ; $34F8
    ld a, [wB_TH001]                              ; $34F9
    ld [hl+], a                                   ; $34FC
    ld a, [wB_TH002]                              ; $34FD
    ld [hl+], a                                   ; $3500
    ld a, [wB_TH010]                              ; $3501
    ld [hl+], a                                   ; $3504
    ld a, [wB_TH011]                              ; $3505
    ld [hl+], a                                   ; $3508
    ld a, [wB_TH012]                              ; $3509
    ld [hl+], a                                   ; $350C
    ld a, [wB_TH020]                              ; $350D
    ld [hl+], a                                   ; $3510
    ld a, [wB_TH021]                              ; $3511
    ld [hl+], a                                   ; $3514
    ld a, [wB_TH022]                              ; $3515
    ld [hl+], a                                   ; $3518
    ld a, [wB_TH030]                              ; $3519
    ld [hl+], a                                   ; $351C
    ld a, [wB_TH031]                              ; $351D
    ld [hl+], a                                   ; $3520
    ld a, [wB_TH032]                              ; $3521
    ld [hl+], a                                   ; $3524
    ld a, [wB_TH100]                              ; $3525
    ld [hl+], a                                   ; $3528
    ld a, [wB_TH101]                              ; $3529
    ld [hl+], a                                   ; $352C
    ld a, [wB_TH102]                              ; $352D
    ld [hl+], a                                   ; $3530
    ld a, [wB_TH110]                              ; $3531
    ld [hl+], a                                   ; $3534
    ld a, [wB_TH111]                              ; $3535
    ld [hl+], a                                   ; $3538
    ld a, [wB_TH112]                              ; $3539
    ld [hl+], a                                   ; $353C
    ld a, [wB_TH120]                              ; $353D
    ld [hl+], a                                   ; $3540
    ld a, [wB_TH121]                              ; $3541
    ld [hl+], a                                   ; $3544
    ld a, [wB_TH122]                              ; $3545
    ld [hl+], a                                   ; $3548
    ld a, [wB_TH130]                              ; $3549
    ld [hl+], a                                   ; $354C
    ld a, [wB_TH131]                              ; $354D
    ld [hl+], a                                   ; $3550
    ld a, [wB_TH132]                              ; $3551
    ld [hl+], a                                   ; $3554
    ld a, [wB_TH200]                              ; $3555
    ld [hl+], a                                   ; $3558
    ld a, [wB_TH201]                              ; $3559
    ld [hl+], a                                   ; $355C
    ld a, [wB_TH202]                              ; $355D
    ld [hl+], a                                   ; $3560
    ld a, [wB_TH210]                              ; $3561
    ld [hl+], a                                   ; $3564
    ld a, [wB_TH211]                              ; $3565
    ld [hl+], a                                   ; $3568
    ld a, [wB_TH212]                              ; $3569
    ld [hl+], a                                   ; $356C
    ld a, [wB_TH220]                              ; $356D
    ld [hl+], a                                   ; $3570
    ld a, [wB_TH221]                              ; $3571
    ld [hl+], a                                   ; $3574
    ld a, [wB_TH222]                              ; $3575
    ld [hl+], a                                   ; $3578
    ld a, [wB_TH230]                              ; $3579
    ld [hl+], a                                   ; $357C
    ld a, [wB_TH231]                              ; $357D
    ld [hl+], a                                   ; $3580
    ld a, [wB_TH232]                              ; $3581
    ld [hl+], a                                   ; $3584
    ld a, [wB_TH300]                              ; $3585
    ld [hl+], a                                   ; $3588
    ld a, [wB_TH301]                              ; $3589
    ld [hl+], a                                   ; $358C
    ld a, [wB_TH302]                              ; $358D
    ld [hl+], a                                   ; $3590
    ld a, [wB_TH310]                              ; $3591
    ld [hl+], a                                   ; $3594
    ld a, [wB_TH311]                              ; $3595
    ld [hl+], a                                   ; $3598
    ld a, [wB_TH312]                              ; $3599
    ld [hl+], a                                   ; $359C
    ld a, [wB_TH320]                              ; $359D
    ld [hl+], a                                   ; $35A0
    ld a, [wB_TH321]                              ; $35A1
    ld [hl+], a                                   ; $35A4
    ld a, [wB_TH322]                              ; $35A5
    ld [hl+], a                                   ; $35A8
    ld a, [wB_TH330]                              ; $35A9
    ld [hl+], a                                   ; $35AC
    ld a, [wB_TH331]                              ; $35AD
    ld [hl+], a                                   ; $35B0
    ld a, [wB_TH332]                              ; $35B1
    ld [hl+], a                                   ; $35B4
    pop af                                        ; $35B5
    ld [wRAM_BANK_BUF], a                         ; $35B6
    ld [rRAMB], a                                 ; $35B9
    ret                                           ; $35BC


; I: dispatch on the low nibble of A (cp 0..n) to per-mode register settings; called by PARA_SET and the settings
; screen
ParaSet_ByMode::
    ld b, a                                       ; $35BD
    and $0f                                       ; $35BE
    cp $00                                        ; $35C0
    jr z, ParaSet_ByMode_Part35DF                 ; $35C2

    cp $01                                        ; $35C4
    jr z, jr_000_3600                             ; $35C6

    cp $02                                        ; $35C8
    jr z, jr_000_3634                             ; $35CA

    cp $03                                        ; $35CC
    jp z, Jump_000_3658                           ; $35CE

    cp $04                                        ; $35D1
    jp z, Jump_000_3694                           ; $35D3

    cp $05                                        ; $35D6
    jp z, Jump_000_36d0                           ; $35D8

    jp Jump_000_370c                              ; $35DB


; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_35DE::
    db $c9

; C: continuation of ParaSet_ByMode after a data label or a never-traced byte
ParaSet_ByMode_Part35DF::
    ld a, $02                                     ; $35DF
    ld [wB_CNTR0], a                              ; $35E1
    ld a, $04                                     ; $35E4
    ld [$a001], a                                 ; $35E6
    ld [wB_CNTR1], a                              ; $35E9
    ld a, $02                                     ; $35EC
    ld [$a004], a                                 ; $35EE
    ld [wB_CNTR4], a                              ; $35F1
    ld a, [wB_CNTR5]                              ; $35F4
    set 7, a                                      ; $35F7
    ld [wB_CNTR5], a                              ; $35F9
    ld [$a005], a                                 ; $35FC
    ret                                           ; $35FF


jr_000_3600:
    ld a, $02                                     ; $3600
    ld [wB_CNTR0], a                              ; $3602
    ld a, $24                                     ; $3605
    ld [wB_CNTR1], a                              ; $3607
    ld [$a001], a                                 ; $360A
    ld a, b                                       ; $360D
    and $f0                                       ; $360E
    cp $00                                        ; $3610
    jr z, jr_000_3620                             ; $3612

    cp $10                                        ; $3614
    jr z, jr_000_3620                             ; $3616

    cp $20                                        ; $3618
    jr z, jr_000_3620                             ; $361A

    add $06                                       ; $361C
    jr jr_000_3622                                ; $361E

jr_000_3620:
    add $03                                       ; $3620

jr_000_3622:
    ld [$a004], a                                 ; $3622
    ld [wB_CNTR4], a                              ; $3625
    ld a, [wB_CNTR5]                              ; $3628
    set 7, a                                      ; $362B
    ld [wB_CNTR5], a                              ; $362D
    ld [$a005], a                                 ; $3630
    ret                                           ; $3633


jr_000_3634:
    ld a, $00                                     ; $3634
    ld [wB_CNTR0], a                              ; $3636
    ld a, $c4                                     ; $3639
    ld [$a001], a                                 ; $363B
    ld [wB_CNTR1], a                              ; $363E
    ld a, b                                       ; $3641
    and $f0                                       ; $3642
    add $03                                       ; $3644
    ld [$a004], a                                 ; $3646
    ld [wB_CNTR4], a                              ; $3649
    ld a, [wB_CNTR5]                              ; $364C
    set 7, a                                      ; $364F
    ld [wB_CNTR5], a                              ; $3651
    ld [$a005], a                                 ; $3654
    ret                                           ; $3657


Jump_000_3658:
    ld a, $00                                     ; $3658
    ld [wB_CNTR0], a                              ; $365A
    ld a, $e0                                     ; $365D
    ld [wB_CNTR1], a                              ; $365F
    ld [$a001], a                                 ; $3662
    ld a, b                                       ; $3665
    and $f0                                       ; $3666
    cp $00                                        ; $3668
    jr z, jr_000_367c                             ; $366A

    cp $10                                        ; $366C
    jr z, jr_000_367c                             ; $366E

    cp $20                                        ; $3670
    jr z, jr_000_367c                             ; $3672

    cp $30                                        ; $3674
    jr z, jr_000_3680                             ; $3676

    add $06                                       ; $3678
    jr jr_000_3682                                ; $367A

jr_000_367c:
    add $03                                       ; $367C
    jr jr_000_3682                                ; $367E

jr_000_3680:
    add $04                                       ; $3680

jr_000_3682:
    ld [$a004], a                                 ; $3682
    ld [wB_CNTR4], a                              ; $3685
    ld a, [wB_CNTR5]                              ; $3688
    set 7, a                                      ; $368B
    ld [wB_CNTR5], a                              ; $368D
    ld [$a005], a                                 ; $3690
    ret                                           ; $3693


Jump_000_3694:
    ld a, $00                                     ; $3694
    ld [wB_CNTR0], a                              ; $3696
    ld a, $e4                                     ; $3699
    ld [wB_CNTR1], a                              ; $369B
    ld [$a001], a                                 ; $369E
    ld a, b                                       ; $36A1
    and $f0                                       ; $36A2
    cp $00                                        ; $36A4
    jr z, jr_000_36b8                             ; $36A6

    cp $10                                        ; $36A8
    jr z, jr_000_36b8                             ; $36AA

    cp $20                                        ; $36AC
    jr z, jr_000_36b8                             ; $36AE

    cp $30                                        ; $36B0
    jr z, jr_000_36bc                             ; $36B2

    add $06                                       ; $36B4
    jr jr_000_36be                                ; $36B6

jr_000_36b8:
    add $03                                       ; $36B8
    jr jr_000_36be                                ; $36BA

jr_000_36bc:
    add $04                                       ; $36BC

jr_000_36be:
    ld [$a004], a                                 ; $36BE
    ld [wB_CNTR4], a                              ; $36C1
    ld a, [wB_CNTR5]                              ; $36C4
    set 7, a                                      ; $36C7
    ld [wB_CNTR5], a                              ; $36C9
    ld [$a005], a                                 ; $36CC
    ret                                           ; $36CF


Jump_000_36d0:
    ld a, $00                                     ; $36D0
    ld [wB_CNTR0], a                              ; $36D2
    ld a, $e8                                     ; $36D5
    ld [wB_CNTR1], a                              ; $36D7
    ld [$a001], a                                 ; $36DA
    ld a, b                                       ; $36DD
    and $f0                                       ; $36DE
    cp $00                                        ; $36E0
    jr z, jr_000_36f4                             ; $36E2

    cp $10                                        ; $36E4
    jr z, jr_000_36f4                             ; $36E6

    cp $20                                        ; $36E8
    jr z, jr_000_36f4                             ; $36EA

    cp $30                                        ; $36EC
    jr z, jr_000_36f8                             ; $36EE

    add $06                                       ; $36F0
    jr jr_000_36fa                                ; $36F2

jr_000_36f4:
    add $03                                       ; $36F4
    jr jr_000_36fa                                ; $36F6

jr_000_36f8:
    add $04                                       ; $36F8

jr_000_36fa:
    ld [$a004], a                                 ; $36FA
    ld [wB_CNTR4], a                              ; $36FD
    ld a, [wB_CNTR5]                              ; $3700
    set 7, a                                      ; $3703
    ld [wB_CNTR5], a                              ; $3705
    ld [$a005], a                                 ; $3708
    ret                                           ; $370B


Jump_000_370c:
    ld a, $00                                     ; $370C
    ld [wB_CNTR0], a                              ; $370E
    ld a, $e4                                     ; $3711
    ld [$a001], a                                 ; $3713
    ld [wB_CNTR1], a                              ; $3716
    ld a, b                                       ; $3719
    and $f0                                       ; $371A
    add $03                                       ; $371C
    set 7, a                                      ; $371E
    ld [$a004], a                                 ; $3720
    ld [wB_CNTR4], a                              ; $3723
    ld a, [wB_CNTR5]                              ; $3726
    and $3f                                       ; $3729
    ld [wB_CNTR5], a                              ; $372B
    ld [$a005], a                                 ; $372E
    ret                                           ; $3731


; C: SRAM bank $10 (camera registers): writes $80, or $55 when the mode in $C0F2 is 6, to the 48 dither registers from
; $A006
Sensor_FillDitherFlat::
    ld a, $10                                     ; $3732
    ld [rRAMB], a                                 ; $3734
    ld b, $80                                     ; $3737
    ld a, [wB_MODE]                               ; $3739
    and $0f                                       ; $373C
    cp $06                                        ; $373E
    jr z, jr_000_3744                             ; $3740

    ld b, $55                                     ; $3742

jr_000_3744:
    ld hl, $a006                                  ; $3744
    ld de, $0030                                  ; $3747

jr_000_374a:
    ld [hl], b                                    ; $374A
    inc hl                                        ; $374B
    dec de                                        ; $374C
    ld a, d                                       ; $374D
    or e                                          ; $374E
    jr nz, jr_000_374a                            ; $374F

    xor a                                         ; $3751
    ld [$a002], a                                 ; $3752
    ld a, $21                                     ; $3755
    ld [$a003], a                                 ; $3757
    ld a, [wB_CNTR5]                              ; $375A
    and $c0                                       ; $375D
    ld b, $3f                                     ; $375F
    or b                                          ; $3761
    ld [wB_CNTR5], a                              ; $3762
    ld [$a005], a                                 ; $3765
    ld a, $10                                     ; $3768
    ld [rRAMB], a                                 ; $376A
    ld a, [wB_CNTR0]                              ; $376D
    set 0, a                                      ; $3770
    ld [$a000], a                                 ; $3772

jr_000_3775:
    ld a, [$a000]                                 ; $3775
    bit 0, a                                      ; $3778
    jr nz, jr_000_3775                            ; $377A

    ld a, [wB_CNTR0]                              ; $377C
    set 0, a                                      ; $377F
    ld [$a000], a                                 ; $3781

jr_000_3784:
    ld a, [$a000]                                 ; $3784
    bit 0, a                                      ; $3787
    jr nz, jr_000_3784                            ; $3789

jr_000_378b:
    ld a, $10                                     ; $378B
    ld [rRAMB], a                                 ; $378D
    ld a, [wB_CNTR0]                              ; $3790
    set 0, a                                      ; $3793
    ld [$a000], a                                 ; $3795

jr_000_3798:
    ld a, [$a000]                                 ; $3798
    bit 0, a                                      ; $379B
    jr nz, jr_000_3798                            ; $379D

    call CHECK_BLACK                              ; $379F
    or a                                          ; $37A2
    jr nz, jr_000_37ab                            ; $37A3

    call OFFSET_DOWN                              ; $37A5
    or a                                          ; $37A8
    jr z, jr_000_378b                             ; $37A9

jr_000_37ab:
    ld a, [wB_CNTR2]                              ; $37AB
    ld [$a002], a                                 ; $37AE
    ld a, [wB_CNTR3]                              ; $37B1
    ld [$a003], a                                 ; $37B4
    ret                                           ; $37B7


; C: developers' name: same code as CHECK_BLACK in the old build of table 2A at old 3478 (32 bytes, exact match)
CHECK_BLACK::
    xor a                                         ; $37B8
    ld [rRAMB], a                                 ; $37B9
    ld hl, $a770                                  ; $37BC
    ld e, $10                                     ; $37BF

jr_000_37c1:
    ld a, [hl+]                                   ; $37C1
    cp $ff                                        ; $37C2
    jr nz, jr_000_37d1                            ; $37C4

    dec e                                         ; $37C6
    jr nz, jr_000_37c1                            ; $37C7

    ld a, $10                                     ; $37C9
    ld [rRAMB], a                                 ; $37CB
    ld a, $01                                     ; $37CE
    ret                                           ; $37D0


jr_000_37d1:
    ld a, $10                                     ; $37D1
    ld [rRAMB], a                                 ; $37D3
    xor a                                         ; $37D6
    ret                                           ; $37D7


; C: developers' name: same code as OFFSET_DOWN in the old build of table 2A at old 3498 (52 bytes, exact match)
OFFSET_DOWN::
    ld a, [wB_CNTR5]                              ; $37D8
    bit 5, a                                      ; $37DB
    jr z, jr_000_37f0                             ; $37DD

    and $3f                                       ; $37DF
    cp $20                                        ; $37E1
    jr z, jr_000_37ea                             ; $37E3

    dec a                                         ; $37E5
    ld b, $00                                     ; $37E6
    jr jr_000_37fd                                ; $37E8

jr_000_37ea:
    ld a, $01                                     ; $37EA
    ld b, $00                                     ; $37EC
    jr jr_000_37fd                                ; $37EE

jr_000_37f0:
    and $1f                                       ; $37F0
    cp $1f                                        ; $37F2
    jr nz, jr_000_37fa                            ; $37F4

    ld b, $01                                     ; $37F6
    jr jr_000_37fd                                ; $37F8

jr_000_37fa:
    inc a                                         ; $37FA
    ld b, $00                                     ; $37FB

jr_000_37fd:
    ld c, a                                       ; $37FD
    ld a, [wB_CNTR5]                              ; $37FE
    and $c0                                       ; $3801
    or c                                          ; $3803
    ld [wB_CNTR5], a                              ; $3804
    ld [$a005], a                                 ; $3807
    ld a, b                                       ; $380A
    ret                                           ; $380B


; C: A (BUNKATU_MODE $C167, from GET_A_IMMAGE 00:10A7) and $1F, x2: jp through ImageCopy_ModeTable to one of 32 SRAM-
; to-WRAM copies
ImageCopy_Dispatch::
    and $1f                                       ; $380C
    sla a                                         ; $380E
    ld c, a                                       ; $3810
    ld b, $00                                     ; $3811
    ld hl, ImageCopy_ModeTable                    ; $3813
    add hl, bc                                    ; $3816
    ld a, [hl+]                                   ; $3817
    ld b, a                                       ; $3818
    ld a, [hl]                                    ; $3819
    ld c, a                                       ; $381A
    ld l, b                                       ; $381B
    ld h, c                                       ; $381C
    xor a                                         ; $381D
    ld [rRAMB], a                                 ; $381E
    jp hl                                         ; $3821


; C: the 32 words of ImageCopy_Dispatch (00:380C): BUNKATU_MODE ($C167) and $1F, x2, selects the SRAM-to-WRAM copy
; routine ImageCopy_Mode00-1F
ImageCopy_ModeTable::
    dw ImageCopy_Mode00
    dw ImageCopy_Mode01
    dw ImageCopy_Mode02
    dw ImageCopy_Mode03
    dw ImageCopy_Mode04
    dw ImageCopy_Mode05
    dw ImageCopy_Mode06
    dw ImageCopy_Mode07
    dw ImageCopy_Mode08
    dw ImageCopy_Mode09
    dw ImageCopy_Mode10
    dw ImageCopy_Mode11
    dw ImageCopy_Mode12
    dw ImageCopy_Mode13
    dw ImageCopy_Mode14
    dw ImageCopy_Mode15
    dw ImageCopy_Mode16
    dw ImageCopy_Mode17
    dw ImageCopy_Mode18
    dw ImageCopy_Mode19
    dw ImageCopy_Mode20
    dw ImageCopy_Mode21
    dw ImageCopy_Mode22
    dw ImageCopy_Mode23
    dw ImageCopy_Mode24_None
    dw ImageCopy_Mode25_None
    dw ImageCopy_Mode26_None
    dw ImageCopy_Mode27_None
    dw ImageCopy_Mode28_None
    dw ImageCopy_Mode29_None
    dw ImageCopy_Mode30_None
    dw ImageCopy_Mode31_None

; C: SET_DITH_MATRIX (00:3447) takes row C (1-131, the CONTRAST value $C165) of this table, 6 bytes per row (three
; bases, three widths; docs §18.14): $3862-$3B73
CONTRAST_ROWS::
    INCBIN "data/bank_00/CONTRAST_ROWS.bin" ; $3862, 1080 bytes
; I: dither order pattern 0 of SET_DITH_MATRIX (table base $3C9A, 16 bytes of $08: no dither); the old table $2A has
; NO_DITHER_PAT 16 bytes before BAYER_PAT, as here, but an all-$08 pattern is too plain to match by its bytes
NO_DITHER_PAT::
    db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08

; C: developers' name: the same bytes as the data label BAYER_PAT in the old build of table 2A at old 3806 (16 bytes,
; data match)
BAYER_PAT::
    db $00, $08, $02, $0a, $0c, $04, $0e, $06, $03, $0b, $01, $09, $0f, $07, $0d, $05

; C: developers' name: the same bytes as the data label HARF_PAT in the old build of table 2A at old 3816 (16 bytes,
; data match)
HARF_PAT::
    db $0a, $04, $06, $08, $0c, $00, $01, $0e, $07, $09, $0b, $05, $03, $0f, $0d, $01

; C: developers' name: the same bytes as the data label SCREW_PAT in the old build of table 2A at old 3826 (16 bytes,
; data match)
SCREW_PAT::
    db $0d, $07, $06, $0c, $08, $01, $00, $05, $09, $02, $03, $04, $0e, $0a, $0b, $0f

; C: developers' name: the same bytes as the data label SCREW2_PAT in the old build of table 2A at old 3836 (16 bytes,
; data match)
SCREW2_PAT::
    db $0f, $04, $08, $0c, $0b, $00, $01, $05, $07, $03, $02, $09, $0e, $0a, $06, $0d

; C: developers' name: the same bytes as the data label TYUUKAN_PAT in the old build of table 2A at old 3846 (16
; bytes, data match)
TYUUKAN_PAT::
    db $0c, $04, $08, $0e, $0b, $00, $02, $06, $07, $03, $01, $0a, $0f, $09, $05, $0d

; C: developers' name: the same bytes as the data label CONCENT_PAT in the old build of table 2A at old 3856 (96
; bytes, data match)
CONCENT_PAT::
    db $0d, $04, $08, $0e, $0a, $00, $01, $07, $06, $03, $02, $0b, $0f, $09, $05, $0c
    db $0f, $00, $0f, $00, $0f, $0f, $0f, $00, $0f, $00, $0f, $00, $00, $00, $00, $00
    db $08, $00, $08, $0f, $00, $08, $0f, $08, $08, $0f, $08, $00, $0f, $08, $00, $08
    db $0f, $00, $00, $00, $00, $0f, $00, $0f, $00, $00, $0f, $00, $00, $0f, $00, $0f
    db $07, $03, $07, $0b, $03, $00, $03, $07, $07, $03, $07, $0b, $0b, $07, $0b, $0f
    db $08, $08, $08, $00, $08, $0f, $08, $00, $08, $08, $08, $00, $00, $00, $00, $00

; C: developers' name: the same bytes as the data label CHG_TIME_TBL_U in the old build of table 2A at old 38B6 (169
; bytes, data match)
CHG_TIME_TBL_U::
    db $10, $07, $06, $06, $06, $05, $05, $05, $05, $05, $04, $04, $04, $04, $04, $04
    db $03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $01, $01, $01, $01, $01, $01, $01, $01

    ; padding
    ds $41, $00

; C: developers' name: the same bytes as the data label CHG_TIME_TBL_D in the old build of table 2A at old 395F (256
; bytes, data match)
CHG_TIME_TBL_D::
    INCBIN "data/bank_00/CHG_TIME_TBL_D.bin" ; $3E03, 508 bytes
; I: leftover: 1 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_00_3FFF::
    db $00

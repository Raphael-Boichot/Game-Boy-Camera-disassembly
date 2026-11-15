; Macros of the Pocket Camera source tree, written by tools/make_source.py. Each one assembles to the same bytes as the lines it replaces.

; farcopy ROUTINE, SOURCE, DEST, LENGTH: copy LENGTH bytes from SOURCE (any bank) to DEST with a banked copy routine
; (Mem_CopyFromBank, Vram_CopyFromBank, Vram_CopyFromBankAuto, Vram_CopyFromBank_4)
MACRO farcopy
    ld a, BANK(\2)
    ld hl, \2
    ld de, \3
    ld bc, \4
    call \1
ENDM

; farcall TARGET: call TARGET in its own bank through Far_Call
MACRO farcall
    ld a, BANK(\1)
    ld hl, \1
    call Far_Call
ENDM

; dwb LABEL: a 3-byte far pointer {lo, hi, bank}
MACRO dwb
    dw \1
    db BANK(\1)
ENDM

; set_state STATE: the state of the current mode (leaves A = STATE)
MACRO set_state
    ld a, \1
    ld [wState], a
ENDM

; next_state: the next state of the current mode (leaves HL = wState)
MACRO next_state
    ld hl, wState
    inc [hl]
ENDM

; play_sfx1 / play_sfx3 / play_sfx4 / play_music ID: request a sound on that channel; A is kept
MACRO play_sfx1
    push af
    ld a, \1
    call Snd_Sfx1
    pop af
ENDM

MACRO play_sfx3
    push af
    ld a, \1
    call Snd_Sfx3
    pop af
ENDM

MACRO play_sfx4
    push af
    ld a, \1
    call Snd_Sfx4
    pop af
ENDM

MACRO play_music
    push af
    ld a, \1
    call Snd_Music
    pop af
ENDM

; ui_sfx VALUE: post a request to wUiSfxRequest; A is kept
MACRO ui_sfx
    push af
    ld a, \1
    ld [wUiSfxRequest], a
    pop af
ENDM

; screen_off: fade the palettes out, then switch the LCD off
MACRO screen_off
    call Pal_FadeOut
    call Lcd_Off
ENDM

; stat_irq_off: clear the LY=LYC source (bit 6) in the STAT shadow and disable the STAT interrupt in IE (leaves HL = rIE)
MACRO stat_irq_off
    ld hl, hStatShadow
    res 6, [hl]
    ld hl, rIE
    res 1, [hl]
ENDM

; screen_on: clear the sprite shadow, all-white palettes, LCD on
MACRO screen_on
    call Oam_ClearShadow
    call Pal_AllWhite
    call Lcd_On
ENDM

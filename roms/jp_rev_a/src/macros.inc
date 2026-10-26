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

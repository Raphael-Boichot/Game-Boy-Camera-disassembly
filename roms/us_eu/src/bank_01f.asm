; Game Boy Camera (USA, Europe), bank $1F. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01f", ROMX[$4000], BANK[$1f]

; C: 37 bytes: NR43 value per noise note (bank 0 sound code; README 2.7 $D917)
Snd_NoiseNR43Tbl::
    db $84, $77, $76, $75, $74, $67, $66, $65, $64, $57, $56, $55, $54, $47, $46, $45
    db $44, $37, $36, $35, $34, $27, $26, $25, $24, $17, $16, $15, $14, $07, $06, $05
    db $04, $03, $02, $01, $00

; C: 20 bytes: NR21/NR31 length values (bank 0 sound code)
Snd_LengthTbl::
    db $3d, $3a, $38, $35, $32, $30, $2d, $2a, $20, $3d, $38, $32, $2a, $26, $20, $14
    db $08, $00, $00, $0f

; C: 72 words: GB frequency values; C-2 up (music note -> NR13/NR14)
Snd_FreqTbl::
    dw $002c
    dw $009c
    dw $0106
    dw $016b
    dw $01c9
    dw $0223
    dw $0277
    dw $02c6
    dw $0312
    dw $0356
    dw $039b
    dw $03da
    dw $0416
    dw $044e
    dw $0483
    dw $04b5
    dw $04e5
    dw $0511
    dw $053b
    dw $0563
    dw $0589
    dw $05ac
    dw $05ce
    dw $05ed
    dw $060a
    dw $0627
    dw $0642
    dw $065b
    dw $0672
    dw $0689
    dw $069e
    dw $06b2
    dw $06c4
    dw $06d6
    dw $06e7
    dw $06f7
    dw $0706
    dw $0714
    dw $0721
    dw $072d
    dw $0739
    dw $0744
    dw $074f
    dw $0759
    dw $0762
    dw $076b
    dw $0773
    dw $077b
    dw $0783
    dw $078a
    dw $0790
    dw $0797
    dw $079d
    dw $07a2
    dw $07a7
    dw $07ac
    dw $07b1
    dw $07b6
    dw $07ba
    dw $07be
    dw $07c1
    dw $07c4
    dw $07c8
    dw $07cb
    dw $07ce
    dw $07d1
    dw $07d4
    dw $07d6
    dw $07d9
    dw $07db
    dw $07dd
    dw $07df

; C: 8 records of 5 bytes (noise instruments for track 4; record 0 is empty)
Snd_Trk4_InstrTbl::
    db $00, $00, $00, $00, $00
    db $c0, $a1, $00, $3a, $02
    db $c0, $91, $00, $29, $04
    db $c0, $a1, $00, $00, $14
    db $c0, $f1, $00, $30, $6e
    db $c0, $b1, $00, $00, $3f
    db $c0, $2b, $00, $00, $1c
    db $80, $4b, $00, $00, $2c

; C: single byte $80 between the instrument table and the waves. L3 pass 2026-10-26: read in BGB in 26 replay(s) of
; the organic corpus, modes 00 08 (tcrf_check/assets/l3_names/)
Snd_Pad_40F1::
    db $80

; C: 7 wave patterns of 16 bytes (instrument wave numbers of op $9D)
Snd_WaveTbl::
    db $23, $33, $45, $67, $89, $ab, $cd, $ef, $fe, $dc, $ba, $98, $8a, $a8, $32, $10
    db $01, $23, $45, $67, $89, $ab, $cd, $ef, $fe, $dc, $ba, $98, $76, $54, $32, $10
    db $77, $23, $56, $78, $99, $98, $76, $67, $9a, $df, $fe, $c9, $85, $77, $77, $77
    db $11, $23, $56, $78, $99, $98, $76, $67, $9a, $df, $fe, $c9, $85, $42, $11, $31
    db $11, $12, $22, $33, $34, $44, $55, $55, $66, $66, $66, $66, $66, $11, $22, $32
    db $87, $66, $65, $55, $54, $44, $43, $32, $22, $11, $11, $66, $61, $11, $66, $66
    db $01, $23, $44, $55, $67, $88, $9a, $bb, $a9, $88, $76, $55, $44, $33, $22, $11

; C: pool of duration values; the seven 16-entry duration tables start at $416B; $4176; $4182; $418B; $419B; $41AA;
; $41B3 and overlap
Snd_DurTblPool::
    db $01, $02, $04, $08, $10, $20, $06, $0c, $18

; C: duration table (frames per note length) used by songs through header byte 1-2
Snd_DurTbl_416B::
    db $00, $03, $06, $0c, $18, $30, $09, $12, $24, $04, $08

; C: duration table (frames per note length) used by songs through header byte 1-2
Snd_DurTbl_4176::
    db $02, $04, $08, $10, $20, $40, $0c, $18, $30, $05, $03, $01

; C: duration table (frames per note length) used by songs through header byte 1-2
Snd_DurTbl_4182::
    db $03, $05, $0a, $14, $28, $50, $0f, $1e, $3c

; C: duration table (frames per note length) used by songs through header byte 1-2
Snd_DurTbl_418B::
    db $03, $06, $0c, $18, $30, $60, $12, $24, $48, $08, $10, $02, $01, $04, $16, $78

; C: duration table (frames per note length) used by songs through header byte 1-2
Snd_DurTbl_419B::
    db $03, $07, $0e, $1c, $38, $70, $15, $2a, $54, $09, $12, $02, $01, $09, $05

; C: duration table (frames per note length) used by songs through header byte 1-2
Snd_DurTbl_41AA::
    db $04, $08, $10, $20, $40, $80, $18, $30, $60

; C: duration table (frames per note length) used by songs through header byte 1-2
Snd_DurTbl_41B3::
    db $04, $09, $12, $24, $48, $90, $1b, $36, $6c, $0c, $18

; C: 60 bytes: SOUND I modulation base per note (bank 0 sound code; $D907)
Snd_ModBaseTbl::
    db $f6, $e9, $dd, $d1, $c7, $bc, $b3, $a9, $a1, $99, $91, $8a, $83, $7c, $76, $70
    db $6b, $66, $61, $5c, $58, $54, $50, $4d, $49, $46, $43, $40, $3d, $3b, $38, $36
    db $34, $32, $30, $2e, $2c, $2b, $29, $28, $26, $25, $24, $23, $22, $21, $20, $1f
    db $1e, $1d, $1c, $1c, $1b, $1a, $1a, $19, $19, $18, $18, $17

; I: 62 words: channel-1 effect init handlers (id 1..$3E)
Sfx1_InitTbl::
    dw Sfx1_Init_01_KeyLeftRight
    dw Sfx1_Init_02_KeyUpDown
    dw Sfx1_Init_03_KeyA
    dw Sfx1_Init_04_KeyB
    dw Sfx1_Init_05_KeyStart
    dw Sfx1_Init_06_0D_KeySelect_SpaceFeverBigEnemyKill
    dw Sfx1_Init_07_MainMenuMove
    dw Sfx1_Init_08_MainMenuPageDown
    dw Sfx1_Init_09_MainMenuPageUp
    dw Sfx1_Init_0A_MainMenuPageTurn
    dw Sfx1_Init_0B_BeepRefused
    dw Sfx1_Init_0C_SpaceFeverEnemyKill
    dw Sfx1_Init_06_0D_KeySelect_SpaceFeverBigEnemyKill
    dw Sfx1_Init_0E_ChooseD
    dw Sfx1_Init_0F_SpaceFeverTargetKill
    dw Sfx1_Init_10_TagDigitsJingle
    dw Sfx1_Init_11_Confirm
    dw $4871
    dw Sfx1_Init_13_PanelClose
    dw Sfx1_Init_14_HotspotSound01
    dw Sfx1_Init_15_HotspotSound02
    dw Sfx1_Init_16_OptionChange
    dw Sfx1_Init_17
    dw Sfx1_Init_18
    dw Sfx1_Init_19_3A_ComposeLayoutKey_PickPhoto
    dw Sfx1_Init_1A
    dw Sfx1_Init_1B_SpaceFeverMenuPickGame
    dw Sfx1_Init_1C
    dw Sfx1_Init_12_1D_PanelOpen
    dw Sfx1_Init_1E_26_Choose_SpaceFeverBossDeath
    dw Sfx1_Init_1F
    dw Sfx1_Init_20_StepFast
    dw Sfx1_Init_21_StepValue
    dw Sfx1_Init_22_DirectionKey
    dw Sfx1_Init_23_2B_BallPoint
    dw Sfx1_Init_24_LoopTone
    dw Sfx1_Init_25_SpaceFeverStart
    dw Sfx1_Init_1E_26_Choose_SpaceFeverBossDeath
    dw Sfx1_Init_27_SpaceFeverWave0End
    dw Sfx1_Init_28_Shutter
    dw Sfx1_Init_29_ChooseB
    dw Sfx1_Init_2A_ChooseC
    dw Sfx1_Init_23_2B_BallPoint
    dw Sfx1_Init_2C
    dw Sfx1_Init_2D
    dw Sfx1_Init_2E
    dw Sfx1_Init_2F
    dw Sfx1_Init_30_RunCelebration
    dw Sfx1_Init_31
    dw Sfx1_Init_32
    dw Sfx1_Init_33
    dw Sfx1_Init_34_SeqStep
    dw Sfx1_Init_35_RunJump
    dw Sfx1_Init_36_PageStep
    dw Sfx1_Init_37_CopyBrowse
    dw Sfx1_Init_38_CursorMove
    dw Sfx1_Init_39_MenuChoose
    dw Sfx1_Init_19_3A_ComposeLayoutKey_PickPhoto
    dw Sfx1_Init_3B_EraseAnim
    dw Sfx1_Init_3C_3D_3E_SpaceFeverPlayerDeathJingle
    dw Sfx1_Init_3C_3D_3E_SpaceFeverPlayerDeathJingle
    dw Sfx1_Init_3C_3D_3E_SpaceFeverPlayerDeathJingle

; I: 62 words: channel-1 effect step handlers
Sfx1_StepTbl::
    dw Sfx1_Step_Generic
    dw Sfx1_Step_02_KeyUpDown
    dw Sfx1_Step_03_KeyA
    dw Sfx1_Step_Generic
    dw Sfx1_Step_05_KeyStart
    dw Sfx1_Step_06_0D_KeySelect_SpaceFeverBigEnemyKill
    dw Sfx1_Step_Generic
    dw Sfx1_Step_08_MainMenuPageDown
    dw Sfx1_Step_09_MainMenuPageUp
    dw Sfx1_Step_0A_MainMenuPageTurn
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_06_0D_KeySelect_SpaceFeverBigEnemyKill
    dw Sfx1_Step_0E_ChooseD
    dw Sfx1_Step_0F_SpaceFeverTargetKill
    dw Sfx1_Step_10_TagDigitsJingle
    dw Sfx1_Step_11_Confirm
    dw Sfx1_Step_Generic
    dw Sfx1_Step_13_PanelClose
    dw Sfx1_Step_14_HotspotSound01
    dw Sfx1_Step_15_HotspotSound02
    dw Sfx1_Step_16_OptionChange
    dw Sfx1_Step_17
    dw Sfx1_Step_Generic
    dw Sfx1_Step_19_3A_ComposeLayoutKey_PickPhoto
    dw Sfx1_Step_1A_1E_HotspotSound07_Choose
    dw Sfx1_Step_1B_SpaceFeverMenuPickGame
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_1A_1E_HotspotSound07_Choose
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_24_LoopTone
    dw Sfx1_Step_25_SpaceFeverStart
    dw Sfx1_Step_26_SpaceFeverBossDeath
    dw Sfx1_Step_Generic
    dw Sfx1_Step_28_Shutter
    dw Sfx1_Step_29_ChooseB
    dw Sfx1_Step_2A_ChooseC
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_Generic
    dw Sfx1_Step_2F
    dw Sfx1_Step_30_RunCelebration
    dw Sfx1_Step_31
    dw Sfx1_Step_32
    dw Sfx1_Step_33
    dw Sfx1_Step_Generic
    dw Sfx1_Step_35_RunJump
    dw Sfx1_Step_36_PageStep
    dw Sfx1_Step_37_CopyBrowse
    dw Sfx1_Step_38_CursorMove
    dw Sfx1_Step_39_MenuChoose
    dw Sfx1_Step_19_3A_ComposeLayoutKey_PickPhoto
    dw Sfx1_Step_3B_EraseAnim
    dw Sfx1_Step_3C_3D_3E_SpaceFeverPlayerDeathJingle
    dw Sfx1_Step_3C_3D_3E_SpaceFeverPlayerDeathJingle
    dw Sfx1_Step_3C_3D_3E_SpaceFeverPlayerDeathJingle

; I: 10 words: channel-3 effect init handlers
Sfx3_InitTbl::
    dw Sfx3_Init_01_MainMenuShoot
    dw Sfx3_Init_02_MainMenuViewArcade
    dw Sfx3_Init_03_SpaceFeverBossHit
    dw Sfx3_Init_04
    dw Sfx3_Init_05_0A
    dw Sfx3_Init_06
    dw Sfx3_Init_07
    dw Sfx3_Init_08_DeleteDialogFirst
    dw Sfx3_Init_09_DeleteDialogSecond
    dw Sfx3_Init_05_0A

; I: 10 words: channel-3 effect step handlers
Sfx3_StepTbl::
    dw Sfx3_Step_01_MainMenuShoot
    dw Sfx3_Step_02_MainMenuViewArcade
    dw Sfx3_Step_03_SpaceFeverBossHit
    dw Sfx3_Step_04
    dw Sfx3_Step_05_0A
    dw Sfx3_Step_06
    dw Sfx3_Step_07
    dw Sfx3_Step_08_DeleteDialogFirst
    dw Sfx3_Step_09_DeleteDialogSecond
    dw Sfx3_Step_05_0A

; I: 18 words: channel-4 effect init handlers
Sfx4_InitTbl::
    dw Sfx4_Init_01_StampCommit
    dw Sfx4_Init_02
    dw Sfx4_Init_03
    dw Sfx4_Init_04_RunHurdleHit
    dw Sfx4_Init_05_EraseAnim
    dw Sfx4_Init_06
    dw Sfx4_Init_07_SpaceFeverFireShots
    dw Sfx4_Init_08_SpaceFeverPlayerDeath
    dw Sfx4_Init_09
    dw Sfx4_Init_0A_LinkChoose
    dw Sfx4_Init_0B
    dw Sfx4_Init_0C
    dw Sfx4_Init_0D
    dw Sfx4_Init_0E
    dw Sfx4_Init_0F
    dw Sfx4_Init_10
    dw Sfx4_Init_11_RunFlagHeight
    dw Sfx4_Init_12_MusicSelect

; I: 18 words: channel-4 effect step handlers
Sfx4_StepTbl::
    dw Sfx4_Step_01_StampCommit
    dw Sfx4_Step_Generic
    dw Sfx4_Step_Generic
    dw Sfx4_Step_04_RunHurdleHit
    dw Sfx4_Step_Generic
    dw Sfx4_Step_06
    dw Sfx4_Step_07_SpaceFeverFireShots
    dw Sfx4_Step_Generic
    dw Sfx4_Step_09
    dw Sfx4_Step_0A_LinkChoose
    dw Sfx4_Step_Generic
    dw Sfx4_Step_Generic
    dw Sfx4_Step_Generic
    dw Sfx4_Step_0E
    dw Sfx4_Step_Generic
    dw Sfx4_Step_10
    dw Sfx4_Step_11_RunFlagHeight
    dw Sfx4_Step_12_MusicSelect

; I: one byte $C9 before the first register block
Sfx1_Data_4362::
    db $c9

; C: inline register block of effect 04
Sfx1_Data_4363::
    db $00, $c0, $d0, $20, $85

; C: channel-1 effect init handler of ids 04 (table $41FA). Named after the caller of its id (SFX1_KEY_B,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_04_KeyB::
    ld a, $06                                     ; $4368
    ld hl, Sfx1_Data_4363                         ; $436A
    jp Snd_Sfx_Start                              ; $436D


; C: Z when the running channel-1 effect is $26; callers refuse to cut it
Sfx1_IsRunning26::
    ld a, [wSndSfx1 + $1]                         ; $4370
    cp $26                                        ; $4373
    ret z                                         ; $4375

    ret                                           ; $4376


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4377::
    db $1e, $00, $7b, $ff, $87

; C: channel-1 effect init handler of ids 3B (table $41FA). Named after the caller of its id (SFX1_ERASE_ANIM,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_3B_EraseAnim::
    ld a, $10                                     ; $437C
    ld hl, Sfx1_Data_4377                         ; $437E
    jp Snd_Sfx_Start                              ; $4381


; C: channel-1 effect step handler of ids 3B (table $4276). Named after the caller of its id (SFX1_ERASE_ANIM,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_3B_EraseAnim::
    call Snd_Sfx_TickCounter                      ; $4384
    and a                                         ; $4387
    ret nz                                        ; $4388

    ld a, SFX4_ERASE_ANIM_TAIL                    ; $4389
    ld [wSndSfx4], a                              ; $438B
    jp Sfx1_Stop                                  ; $438E


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4391::
    db $00, $fa, $f0, $a2, $c7
    db $00, $d0, $f0, $d1, $c7

; C: channel-1 effect init handler of id 28: the shutter sound (owner, by ear: sure)
Sfx1_Init_28_Shutter::
    ld a, $06                                     ; $439B
    ld hl, Sfx1_Data_4391                         ; $439D
    jp Snd_Sfx_Start                              ; $43A0


; C: channel-1 effect step handler of id 28: the shutter sound
Sfx1_Step_28_Shutter::
    call Snd_Sfx_TickCounter                      ; $43A3
    and a                                         ; $43A6
    ret nz                                        ; $43A7

    ld hl, wSndSfx1 + $4                          ; $43A8
    inc [hl]                                      ; $43AB
    ld a, [hl]                                    ; $43AC
    cp $02                                        ; $43AD
    jp z, Sfx1_Stop                               ; $43AF

    ld hl, Sfx1_Data_4391 + $5                    ; $43B2
    jp Snd_Sfx_LoadNR1x                           ; $43B5


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_43B8::
    db $00, $f8, $f0, $f2, $c6
    db $00, $c0, $a9, $f8, $c5

; C: channel-1 effect init handler of ids 2A (table $41FA). Named after the caller of its id (SFX1_CHOOSE_C,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_2A_ChooseC::
    ld a, $06                                     ; $43C2
    ld hl, Sfx1_Data_43B8                         ; $43C4
    jp Snd_Sfx_Start                              ; $43C7


; C: channel-1 effect step handler of ids 2A (table $4276). Named after the caller of its id (SFX1_CHOOSE_C,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_2A_ChooseC::
    call Snd_Sfx_TickCounter                      ; $43CA
    and a                                         ; $43CD
    ret nz                                        ; $43CE

    ld hl, wSndSfx1 + $4                          ; $43CF
    inc [hl]                                      ; $43D2
    ld a, [hl]                                    ; $43D3
    cp $02                                        ; $43D4
    jp z, Sfx1_Stop                               ; $43D6

    ld hl, Sfx1_Data_43B8 + $5                    ; $43D9
    jp Snd_Sfx_LoadNR1x                           ; $43DC


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_43DF::
    db $3e, $80, $d0, $70, $87

; C: channel-1 effect init handler of id 24: loads one note (duty 50 %, constant volume $D, hardware sweep $3E down,
; start pitch $770 = about 910 Hz) and sets the step limit to 21 frames. Role read from the code and checked in BGB (a
; 45 s recording, 130 notes, no end): the step handler 1F:43EC reloads ...
Sfx1_Init_24_LoopTone::
    ld a, $15                                     ; $43E4
    ld hl, Sfx1_Data_43DF                         ; $43E6
    jp Snd_Sfx_Start                              ; $43E9


; C: channel-1 effect step handler of id 24: every 21 frames it reloads the note of 1F:43DF into NR10-NR14 (a
; retrigger of the same falling tone) and does not call Sfx1_Stop, so the tone loops (BGB, 45 s). No request of id $24
; in either ROM (all 334 JP call sites of Snd_Sfx1 and the international ones ...
Sfx1_Step_24_LoopTone::
    call Snd_Sfx_TickCounter                      ; $43EC
    and a                                         ; $43EF
    ret nz                                        ; $43F0

    ld hl, Sfx1_Data_43DF                         ; $43F1
    jp Snd_Sfx_LoadNR1x                           ; $43F4


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_43F7::
    db $4c, $c0, $50, $aa, $87
    db $44, $00, $a0, $70, $86

; C: channel-1 effect init handler of ids 1E 26 (table $41FA). Owner (review page, 2026-10-13, by ear): sfx1 26: used
; - boss death in space fever; the name BossHit comes from the caller SpaceFever_BossHit (id 26); name kept, the
; sounds agree on Space Fever. Requested 12 times from frame 2799 in the ...
Sfx1_Init_1E_26_Choose_SpaceFeverBossDeath::
    ld a, $08                                     ; $4401
    ld hl, Sfx1_Data_43F7                         ; $4403
    jp Snd_Sfx_Start                              ; $4406


; C: channel-1 effect step handler of ids 26 (table $4276). Named after the caller of its id
; (SFX1_SPACE_FEVER_BOSS_DEATH, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx1_Step_26_SpaceFeverBossDeath::
    call Snd_Sfx_TickCounter                      ; $4409
    and a                                         ; $440C
    ret nz                                        ; $440D

    ld a, SFX4_SHUTTER_SOUND_4                    ; $440E
    ld [wSndSfx4], a                              ; $4410
    ld hl, wSndSfx1 + $4                          ; $4413
    inc [hl]                                      ; $4416
    bit 0, [hl]                                   ; $4417
    jr nz, jr_01f_4421                            ; $4419

    ld hl, Sfx1_Data_43F7                         ; $441B
    jp Snd_Sfx_LoadNR1x                           ; $441E


jr_01f_4421:
    ld hl, Sfx1_Data_43F7 + $5                    ; $4421
    jp Snd_Sfx_LoadNR1x                           ; $4424


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4427::
    db $25, $00, $5a, $70, $86
    db $3b, $00, $8a, $88, $87

; C: channel-1 effect init handler of ids 25 (table $41FA). Named after the caller of its id (SFX1_SPACE_FEVER_START,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_25_SpaceFeverStart::
    ld a, $07                                     ; $4431
    ld hl, Sfx1_Data_4427                         ; $4433
    jp Snd_Sfx_Start                              ; $4436


; C: channel-1 effect step handler of ids 25 (table $4276). Named after the caller of its id (SFX1_SPACE_FEVER_START,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_25_SpaceFeverStart::
    call Snd_Sfx_TickCounter                      ; $4439
    and a                                         ; $443C
    ret nz                                        ; $443D

    ld hl, wSndSfx1 + $4                          ; $443E
    inc [hl]                                      ; $4441
    bit 0, [hl]                                   ; $4442
    jr nz, jr_01f_444c                            ; $4444

    ld hl, Sfx1_Data_4427                         ; $4446
    jp Snd_Sfx_LoadNR1x                           ; $4449


jr_01f_444c:
    ld hl, Sfx1_Data_4427 + $5                    ; $444C
    jp Snd_Sfx_LoadNR1x                           ; $444F


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4452::
    db $00, $00, $11, $70, $87

; C: channel-1 effect init handler of ids 27 (table $41FA). Named after the caller of its id
; (SFX1_SPACE_FEVER_WAVE0_END, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx1_Init_27_SpaceFeverWave0End::
    ld a, $02                                     ; $4457
    ld hl, Sfx1_Data_4452                         ; $4459
    jp Snd_Sfx_Start                              ; $445C


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_445F::
    db $00, $80, $e0, $01, $87

; C: channel-1 effect init handler of ids 0E (table $41FA). Named after the caller of its id (SFX1_CHOOSE_D,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_0E_ChooseD::
    call Sfx1_IsRunning26                         ; $4464
    ret z                                         ; $4467

    ld a, $01                                     ; $4468
    ld [wSndSfx1 + $6], a                         ; $446A
    ld a, $03                                     ; $446D
    ld hl, Sfx1_Data_445F                         ; $446F
    jp Snd_Sfx_Start                              ; $4472


; C: channel-1 effect step handler of ids 0E (table $4276). Named after the caller of its id (SFX1_CHOOSE_D,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_0E_ChooseD::
    ld hl, wSndSfx1 + $4                          ; $4475
    ld a, [hl]                                    ; $4478
    inc [hl]                                      ; $4479
    cp $19                                        ; $447A
    jp z, Sfx1_Stop                               ; $447C

    ld hl, wSndSfx1 + $6                          ; $447F
    ld c, $70                                     ; $4482
    bit 2, a                                      ; $4484
    jr nz, jr_01f_448a                            ; $4486

    ld c, $b0                                     ; $4488

jr_01f_448a:
    ld a, c                                       ; $448A
    add [hl]                                      ; $448B
    ldh [rNR13], a                                ; $448C
    ret                                           ; $448E


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_448F::
    db $00, $00, $99, $4e, $86
    db $00, $00, $aa, $b5, $86

; C: channel-1 effect init handler of ids 1A (table $41FA)
Sfx1_Init_1A::
    ld a, $05                                     ; $4499
    ld hl, Sfx1_Data_448F                         ; $449B
    jp Snd_Sfx_Start                              ; $449E


; C: channel-1 effect step handler of ids 1A 1E (table $4276). Named after the caller of its ids
; (SFX1_HOTSPOT_SOUND_07, SFX1_CHOOSE, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function /
; caller, not by ear).
Sfx1_Step_1A_1E_HotspotSound07_Choose::
    call Snd_Sfx_TickCounter                      ; $44A1
    and a                                         ; $44A4
    ret nz                                        ; $44A5

    ld hl, wSndSfx1 + $4                          ; $44A6
    ld a, [hl]                                    ; $44A9
    inc [hl]                                      ; $44AA
    cp $04                                        ; $44AB
    jp z, Sfx1_Stop                               ; $44AD

    bit 0, a                                      ; $44B0
    jr nz, jr_01f_44ba                            ; $44B2

    ld hl, Sfx1_Data_448F + $5                    ; $44B4
    jp Snd_Sfx_LoadNR1x                           ; $44B7


jr_01f_44ba:
    ld hl, Sfx1_Data_448F                         ; $44BA
    jp Snd_Sfx_LoadNR1x                           ; $44BD


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_44C0::
    db $00, $bb, $90, $80, $c7
    db $00, $ba, $a0, $89, $c7

; C: channel-1 effect init handler of ids 03 (table $41FA). Named after the caller of its id (SFX1_KEY_A,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_03_KeyA::
    ld a, $04                                     ; $44CA
    ld hl, Sfx1_Data_44C0                         ; $44CC
    jp Snd_Sfx_Start                              ; $44CF


; C: channel-1 effect step handler of ids 03 (table $4276). Named after the caller of its id (SFX1_KEY_A,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_03_KeyA::
    call Snd_Sfx_TickCounter                      ; $44D2
    and a                                         ; $44D5
    ret nz                                        ; $44D6

    ld hl, wSndSfx1 + $4                          ; $44D7
    inc [hl]                                      ; $44DA
    ld a, [hl]                                    ; $44DB
    cp $02                                        ; $44DC
    jp z, Sfx1_Stop                               ; $44DE

    ld hl, Sfx1_Data_44C0                         ; $44E1
    bit 0, a                                      ; $44E4
    jr z, jr_01f_44eb                             ; $44E6

    ld hl, Sfx1_Data_44C0 + $5                    ; $44E8

jr_01f_44eb:
    jp Snd_Sfx_LoadNR1x                           ; $44EB


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_44EE::
    db $00, $bd, $f0, $dd, $c7

; C: channel-1 effect init handler of ids 0B (table $41FA). Named after the caller of its id (SFX1_BEEP_REFUSED,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_0B_BeepRefused::
    ld a, $03                                     ; $44F3
    ld hl, Sfx1_Data_44EE                         ; $44F5
    call Snd_Sfx_Start                            ; $44F8
    ret                                           ; $44FB


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_44FC::
    db $00, $00, $f0, $20, $81

; C: channel-1 effect init handler of ids 1C (table $41FA)
Sfx1_Init_1C::
    ld a, $16                                     ; $4501
    ld hl, Sfx1_Data_44FC                         ; $4503
    jp Snd_Sfx_Start                              ; $4506


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4509::
    db $9b, $12, $00, $00, $00, $f2, $12, $83

; C: channel-1 effect init handler of ids 1B (table $41FA). Named after the caller of its id
; (SFX1_SPACE_FEVER_MENU_PICK_GAME, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Init_1B_SpaceFeverMenuPickGame::
    ld a, $83                                     ; $4511
    ld [wSndSfx1 + $7], a                         ; $4513
    ld a, $0c                                     ; $4516
    ld hl, Sfx1_Data_4509 + $3                    ; $4518
    jp Snd_Sfx_Start                              ; $451B


; C: channel-1 effect step handler of ids 1B (table $4276). Named after the caller of its id
; (SFX1_SPACE_FEVER_MENU_PICK_GAME, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Step_1B_SpaceFeverMenuPickGame::
    call Snd_Sfx_TickCounter                      ; $451E
    and a                                         ; $4521
    ret nz                                        ; $4522

    ld bc, Sfx1_Data_4509                         ; $4523
    ld a, $0c                                     ; $4526
    jr jr_01f_459a                                ; $4528

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_452A::
    db $9d, $ac, $c1, $ff, $ac, $00

; C: channel-1 effect init handler of ids 16 (table $41FA). Named after the caller of its id (SFX1_OPTION_CHANGE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_16_OptionChange::
    ld a, $87                                     ; $4530
    ld [wSndSfx1 + $7], a                         ; $4532
    ld a, $0c                                     ; $4535
    ld hl, Sfx1_Data_4575                         ; $4537
    jp Snd_Sfx_Start                              ; $453A


; C: channel-1 effect step handler of ids 16 (table $4276). Named after the caller of its id (SFX1_OPTION_CHANGE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_16_OptionChange::
    call Snd_Sfx_TickCounter                      ; $453D
    and a                                         ; $4540
    ret nz                                        ; $4541

    ld bc, Sfx1_Data_452A                         ; $4542
    ld a, $04                                     ; $4545
    jr jr_01f_459a                                ; $4547

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4549::
    db $ff, $11, $ac, $ff, $11, $00, $00, $00, $f0, $ac, $85

; C: channel-1 effect init handler of ids 3C 3D 3E (table $41FA). Owner (review page, 2026-10-13, by ear): sfx1 3D:
; used - death in Ball or Space fever; ids 3D and 3E share this handler; owner for 3E: death in Ball or space fever
; (used). Named after the caller of its ids ...
Sfx1_Init_3C_3D_3E_SpaceFeverPlayerDeathJingle::
    call Snd_StopSong                             ; $4554
    ld a, SFX4_DEATH_NOISE                        ; $4557
    ld [wSndSfx4], a                              ; $4559
    ld a, $85                                     ; $455C
    ld [wSndSfx1 + $7], a                         ; $455E
    ld a, $14                                     ; $4561
    ld hl, Sfx1_Data_4549 + $6                    ; $4563
    jp Snd_Sfx_Start                              ; $4566


; C: channel-1 effect step handler of ids 3C 3D 3E (table $4276). Named after the caller of its ids
; (SFX1_SPACE_FEVER_PLAYER_DEATH_JINGLE, SFX1_SPACE_FEVER_PLAYER_DEATH_JINGLE_ALIAS_3D,
; SFX1_SPACE_FEVER_PLAYER_DEATH_JINGLE_ALIAS_3E, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by ...
Sfx1_Step_3C_3D_3E_SpaceFeverPlayerDeathJingle::
    call Snd_Sfx_TickCounter                      ; $4569
    and a                                         ; $456C
    ret nz                                        ; $456D

    ld bc, Sfx1_Data_4549                         ; $456E
    ld a, $14                                     ; $4571
    jr jr_01f_459a                                ; $4573

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4575::
    db $00, $80, $00, $ff, $87, $21, $90, $21, $90, $21, $90, $21, $90, $00

; C: channel-1 effect init handler of ids 17 (table $41FA)
Sfx1_Init_17::
    ld a, $87                                     ; $4583
    ld [wSndSfx1 + $7], a                         ; $4585
    ld a, $08                                     ; $4588
    ld hl, Sfx1_Data_4575                         ; $458A
    jp Snd_Sfx_Start                              ; $458D


; C: channel-1 effect step handler of ids 17 (table $4276)
Sfx1_Step_17::
    call Snd_Sfx_TickCounter                      ; $4590
    and a                                         ; $4593
    ret nz                                        ; $4594

    ld a, $05                                     ; $4595
    ld bc, Sfx1_Data_4575 + $5                    ; $4597

jr_01f_459a:
    ld [wSndSfx1 + $3], a                         ; $459A
    ld hl, wSndSfx1 + $4                          ; $459D
    ld a, [hl]                                    ; $45A0
    inc [hl]                                      ; $45A1
    ld l, a                                       ; $45A2
    ld h, $00                                     ; $45A3
    add hl, bc                                    ; $45A5
    ld a, [hl]                                    ; $45A6
    and a                                         ; $45A7
    jp z, Sfx1_Stop                               ; $45A8

    ldh [rNR13], a                                ; $45AB
    ld a, $d2                                     ; $45AD
    ldh [rNR12], a                                ; $45AF
    ld a, [wSndSfx1 + $7]                         ; $45B1
    ldh [rNR14], a                                ; $45B4
    ret                                           ; $45B6


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_45B7::
    db $00, $00, $a9, $8e, $86
    db $00, $00, $ba, $f5, $86

; C: channel-1 effect init handler of ids 29 (table $41FA). Named after the caller of its id (SFX1_CHOOSE_B,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_29_ChooseB::
    ld a, $04                                     ; $45C1
    ld hl, Sfx1_Data_45B7                         ; $45C3
    jp Snd_Sfx_Start                              ; $45C6


; C: channel-1 effect step handler of ids 29 (table $4276). Named after the caller of its id (SFX1_CHOOSE_B,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_29_ChooseB::
    call Snd_Sfx_TickCounter                      ; $45C9
    and a                                         ; $45CC
    ret nz                                        ; $45CD

    ld hl, wSndSfx1 + $4                          ; $45CE
    ld a, [hl]                                    ; $45D1
    inc [hl]                                      ; $45D2
    cp $06                                        ; $45D3
    jp z, Sfx1_Stop                               ; $45D5

    bit 0, a                                      ; $45D8
    jr nz, jr_01f_45e2                            ; $45DA

    ld hl, Sfx1_Data_45B7 + $5                    ; $45DC
    jp Snd_Sfx_LoadNR1x                           ; $45DF


jr_01f_45e2:
    ld hl, Sfx1_Data_45B7                         ; $45E2
    jp Snd_Sfx_LoadNR1x                           ; $45E5


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_45E8::
    db $00, $80, $e1, $ac, $c7
    db $00, $80, $e1, $c1, $c7
    db $00, $80, $e1, $d6, $c7

; C: channel-1 effect init handler of ids 05 (table $41FA). Named after the caller of its id (SFX1_KEY_START,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_05_KeyStart::
    ld a, $05                                     ; $45F7
    ld hl, Sfx1_Data_45E8                         ; $45F9
    jp Snd_Sfx_Start                              ; $45FC


; C: channel-1 effect step handler of ids 05 (table $4276). Named after the caller of its id (SFX1_KEY_START,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_05_KeyStart::
    call Snd_Sfx_TickCounter                      ; $45FF
    and a                                         ; $4602
    ret nz                                        ; $4603

    ld hl, wSndSfx1 + $4                          ; $4604
    inc [hl]                                      ; $4607
    ld a, [hl]                                    ; $4608
    ld hl, Sfx1_Data_45E8 + $5                    ; $4609
    cp $01                                        ; $460C
    jr z, jr_01f_4624                             ; $460E

    ld hl, Sfx1_Data_45E8 + $A                    ; $4610
    cp $02                                        ; $4613
    jr z, jr_01f_4624                             ; $4615

    ld hl, Sfx1_Data_45E8 + $5                    ; $4617
    cp $03                                        ; $461A
    jr z, jr_01f_4624                             ; $461C

    cp $04                                        ; $461E
    jp z, Sfx1_Stop                               ; $4620

    ret                                           ; $4623


jr_01f_4624:
    jp Snd_Sfx_LoadNR1x                           ; $4624


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4627::
    db $dc, $80, $80, $f0, $c7, $00, $bc, $c0, $b2, $c7, $b2, $a2, $92, $82, $72, $62
    db $52, $42, $32, $22, $11, $01, $00

; C: channel-1 effect init handler of ids 0A (table $41FA). Named after the caller of its id
; (SFX1_MAIN_MENU_PAGE_TURN, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_0A_MainMenuPageTurn::
    ld a, $04                                     ; $463E
    ld hl, Sfx1_Data_4627                         ; $4640
    jp Snd_Sfx_Start                              ; $4643


; C: channel-1 effect step handler of ids 0A (table $4276). Named after the caller of its id
; (SFX1_MAIN_MENU_PAGE_TURN, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Step_0A_MainMenuPageTurn::
    call Snd_Sfx_TickCounter                      ; $4646
    and a                                         ; $4649
    ret nz                                        ; $464A

    ld hl, wSndSfx1 + $4                          ; $464B
    ld a, [hl]                                    ; $464E
    inc [hl]                                      ; $464F
    cp $04                                        ; $4650
    jr z, jr_01f_466a                             ; $4652

    cp $04                                        ; $4654
    ret c                                         ; $4656

    ld c, a                                       ; $4657
    ld b, $00                                     ; $4658
    ld hl, Sfx1_Data_4627 + $A                    ; $465A
    add hl, bc                                    ; $465D
    ld a, [hl]                                    ; $465E
    and a                                         ; $465F
    jp z, Sfx1_Stop                               ; $4660

    ldh [rNR13], a                                ; $4663
    ld a, $c7                                     ; $4665
    ldh [rNR14], a                                ; $4667
    ret                                           ; $4669


jr_01f_466a:
    ld hl, Sfx1_Data_4627 + $5                    ; $466A
    jp Snd_Sfx_LoadNR1x                           ; $466D


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4670::
    db $00, $b5, $b0, $44, $c7
    db $00, $b5, $20, $44, $c7

; C: channel-1 effect init handler of ids 02 (table $41FA). Named after the caller of its id (SFX1_KEY_UP_DOWN,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_02_KeyUpDown::
    ld a, $05                                     ; $467A
    ld hl, Sfx1_Data_4670                         ; $467C
    jp Snd_Sfx_Start                              ; $467F


; C: channel-1 effect step handler of ids 02 (table $4276). Named after the caller of its id (SFX1_KEY_UP_DOWN,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_02_KeyUpDown::
    call Snd_Sfx_TickCounter                      ; $4682
    and a                                         ; $4685
    ret nz                                        ; $4686

    ld hl, wSndSfx1 + $4                          ; $4687
    inc [hl]                                      ; $468A
    ld a, [hl]                                    ; $468B
    cp $02                                        ; $468C
    jp z, Sfx1_Stop                               ; $468E

    ld hl, Sfx1_Data_4670 + $5                    ; $4691
    jp Snd_Sfx_LoadNR1x                           ; $4694


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4697::
    db $00, $ba, $e0, $90, $c7

; C: channel-1 effect init handler of ids 20 (table $41FA). Named after the caller of its id (SFX1_STEP_FAST,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_20_StepFast::
    ld a, $03                                     ; $469C
    ld hl, Sfx1_Data_4697                         ; $469E
    jp Snd_Sfx_Start                              ; $46A1


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_46A4::
    db $00, $bc, $b0, $a0, $c7

; C: channel-1 effect init handler of ids 21 (table $41FA). Named after the caller of its id (SFX1_STEP_VALUE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_21_StepValue::
    ld a, $03                                     ; $46A9
    ld hl, Sfx1_Data_46A4                         ; $46AB
    jp Snd_Sfx_Start                              ; $46AE


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_46B1::
    db $00, $bb, $90, $b1, $c7

; C: channel-1 effect init handler of ids 22 (table $41FA). Named after the caller of its id (SFX1_DIRECTION_KEY,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_22_DirectionKey::
    ld a, $03                                     ; $46B6
    ld hl, Sfx1_Data_46B1                         ; $46B8
    jp Snd_Sfx_Start                              ; $46BB


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_46BE::
    db $00, $f9, $f0, $7d, $c7

; C: channel-1 effect init handler of ids 23 2B (table $41FA). Named after the caller of its ids (SFX1_BALL_POINT,
; SFX1_BALL_POINT_ALIAS_2B, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_23_2B_BallPoint::
    ld a, $03                                     ; $46C3
    ld hl, Sfx1_Data_46BE                         ; $46C5
    jp Snd_Sfx_Start                              ; $46C8


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_46CB::
    db $00, $ba, $e1, $66, $c7

; C: channel-1 effect init handler of ids 01 (table $41FA). Named after the caller of its id (SFX1_KEY_LEFT_RIGHT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_01_KeyLeftRight::
    ld a, $03                                     ; $46D0
    ld hl, Sfx1_Data_46CB                         ; $46D2
    jp Snd_Sfx_Start                              ; $46D5


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_46D8::
    db $00, $00, $d1, $c1, $87

; I: channel-1 init handler in the id 20-23 series that no table lists (dead)
Unused_Sfx1_Init_46DD::
    ld a, $10                                     ; $46DD
    ld hl, Sfx1_Data_46D8                         ; $46DF
    jp Snd_Sfx_Start                              ; $46E2


; C: 16 jingle digit register blocks of 5 bytes
Sfx1_10_DigitRegs::
    db $7f, $ae, $e1, $16, $c4
    db $77, $ae, $e1, $b5, $c4
    db $7f, $ae, $e1, $e5, $c4
    db $77, $ae, $e1, $63, $c5
    db $7f, $ae, $e1, $ce, $c5
    db $77, $ae, $e1, $0a, $c6
    db $7f, $ae, $e1, $5b, $c6
    db $77, $ae, $e1, $72, $c6
    db $7f, $ae, $e1, $b2, $c6
    db $77, $ae, $e1, $e7, $c6
    db $7f, $ae, $e1, $06, $c7
    db $77, $ae, $e1, $2d, $c7
    db $7f, $ae, $e1, $39, $c7
    db $77, $ae, $e1, $59, $c7
    db $7f, $ae, $e1, $73, $c7
    db $77, $ae, $e1, $83, $c7

; C: digit -> block offset
Sfx1_10_DigitIdx::
    db $00, $05, $0a, $0f, $14, $19, $1e, $23, $28, $2d, $32, $37, $3c, $41, $46, $4b

; C: channel-1 effect init handler of ids 10 (table $41FA). Named after the caller of its id (SFX1_TAG_DIGITS_JINGLE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_10_TagDigitsJingle::
    call Sfx1_10_DigitPtr0                        ; $4745
    ld a, $08                                     ; $4748
    jp Snd_Sfx_Start                              ; $474A


; C: channel-1 effect step handler of ids 10 (table $4276). Named after the caller of its id (SFX1_TAG_DIGITS_JINGLE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_10_TagDigitsJingle::
    call Snd_Sfx_TickCounter                      ; $474D
    and a                                         ; $4750
    ret nz                                        ; $4751

    ld hl, wSndSfx1 + $4                          ; $4752
    inc [hl]                                      ; $4755
    ld a, [hl]                                    ; $4756
    cp $04                                        ; $4757
    jp z, Sfx1_Stop                               ; $4759

    ld c, [hl]                                    ; $475C
    ld b, $00                                     ; $475D
    ld hl, wSndDurTabHi                           ; $475F
    add hl, bc                                    ; $4762
    call Sfx1_10_DigitPtr                         ; $4763
    jp Snd_Sfx_LoadNR1x                           ; $4766


; C: HL -> register block for the first jingle digit ($DD03)
Sfx1_10_DigitPtr0::
    ld hl, wSndDurTabHi                           ; $4769

; C: HL = $46E5 + $4735[digit at HL] : register block of one jingle digit
Sfx1_10_DigitPtr::
    ld c, [hl]                                    ; $476C
    ld b, $00                                     ; $476D
    ld hl, Sfx1_10_DigitIdx                       ; $476F
    add hl, bc                                    ; $4772
    ld c, [hl]                                    ; $4773
    ld b, $00                                     ; $4774
    ld hl, Sfx1_10_DigitRegs                      ; $4776
    add hl, bc                                    ; $4779
    ret                                           ; $477A


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_477B::
    db $00, $80, $e2, $60, $87

; C: channel-1 effect init handler of ids 1F (table $41FA)
Sfx1_Init_1F::
    ld a, $06                                     ; $4780
    ld hl, Sfx1_Data_477B                         ; $4782
    call Snd_Sfx_Start                            ; $4785
    ldh a, [rDIV]                                 ; $4788
    and $3f                                       ; $478A
    or $00                                        ; $478C
    ldh [rNR13], a                                ; $478E
    ret                                           ; $4790


; C: shared channel-1 step handler (ids 01 04 07 0B 0C 12 18 1C 1D 1F 20 21 22 23 27 2B 2C 2D 2E 34):
; Snd_Sfx_TickCounter until the limit; then the effect stops
Sfx1_Step_Generic::
    call Snd_Sfx_TickCounter                      ; $4791
    and a                                         ; $4794
    ret nz                                        ; $4795

; C: channel-1 effect ends: running id 0; NR10=0; NR12=$08; NR14=$80; busy flag off
Sfx1_Stop::
    xor a                                         ; $4796
    ld [wSndSfx1 + $1], a                         ; $4797
    ldh [rNR10], a                                ; $479A
    ld a, $08                                     ; $479C
    ldh [rNR12], a                                ; $479E
    ld a, $80                                     ; $47A0
    ldh [rNR14], a                                ; $47A2
    ld hl, wSndTrack1 + $f                        ; $47A4
    res 7, [hl]                                   ; $47A7
    ret                                           ; $47A9


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_47AA::
    db $4b, $80, $e0, $ee, $87
    db $53, $80, $d0, $37, $87

; C: channel-1 effect init handler of ids 06 0D (table $41FA). Named after the caller of its ids (SFX1_KEY_SELECT,
; SFX1_SPACE_FEVER_BIG_ENEMY_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Init_06_0D_KeySelect_SpaceFeverBigEnemyKill::
    call Sfx1_IsRunning26                         ; $47B4
    ret z                                         ; $47B7

    ld a, $09                                     ; $47B8
    ld hl, Sfx1_Data_47AA                         ; $47BA
    jp Snd_Sfx_Start                              ; $47BD


; C: channel-1 effect step handler of ids 06 0D (table $4276). Named after the caller of its ids (SFX1_KEY_SELECT,
; SFX1_SPACE_FEVER_BIG_ENEMY_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Step_06_0D_KeySelect_SpaceFeverBigEnemyKill::
    call Snd_Sfx_TickCounter                      ; $47C0
    and a                                         ; $47C3
    ret nz                                        ; $47C4

    ld hl, wSndSfx1 + $4                          ; $47C5
    ld a, [hl]                                    ; $47C8
    inc [hl]                                      ; $47C9
    cp $00                                        ; $47CA
    jr z, jr_01f_47d3                             ; $47CC

    cp $01                                        ; $47CE
    jr z, Sfx1_Stop                               ; $47D0

    ret                                           ; $47D2


jr_01f_47d3:
    ld hl, Sfx1_Data_47AA + $5                    ; $47D3
    jp Snd_Sfx_LoadNR1x                           ; $47D6


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_47D9::
    db $27, $c0, $e0, $80, $87, $90, $80, $70, $60, $50, $40, $00, $90, $80, $70, $60
    db $50, $40, $00

; C: channel-1 effect init handler of ids 09 (table $41FA). Named after the caller of its id (SFX1_MAIN_MENU_PAGE_UP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_09_MainMenuPageUp::
    ld a, $04                                     ; $47EC
    ld hl, Sfx1_Data_47D9                         ; $47EE
    jp Snd_Sfx_Start                              ; $47F1


; C: channel-1 effect step handler of ids 09 (table $4276). Named after the caller of its id (SFX1_MAIN_MENU_PAGE_UP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_09_MainMenuPageUp::
    call Snd_Sfx_TickCounter                      ; $47F4
    and a                                         ; $47F7
    ret nz                                        ; $47F8

    ld hl, wSndSfx1 + $4                          ; $47F9
    ld c, [hl]                                    ; $47FC
    inc [hl]                                      ; $47FD
    ld b, $00                                     ; $47FE
    ld hl, Sfx1_Data_47D9 + $5                    ; $4800
    add hl, bc                                    ; $4803
    ld a, [hl]                                    ; $4804
    and a                                         ; $4805
    jp z, Sfx1_Step_09_Finish                     ; $4806

    ldh [rNR13], a                                ; $4809
    ldh [rNR12], a                                ; $480B
    ld a, $87                                     ; $480D
    ldh [rNR14], a                                ; $480F
    ret                                           ; $4811


; C: end of step 09 of the channel-1 effect: $DD78 = 4, then Sfx1_Stop (branch target; code read 2026-10-19)
Sfx1_Step_09_Finish::
    ld a, SFX4_RUN_HURDLE_HIT                     ; $4812
    ld [wSndSfx4], a                              ; $4814
    jp Sfx1_Stop                                  ; $4817


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_481A::
    db $00, $80, $40, $40, $87

; C: channel-1 effect init handler of id 14: hot-spot related (owner, by ear: sure). Named after the caller of its id
; (SFX1_HOTSPOT_SOUND_01, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_14_HotspotSound01::
    ld a, $40                                     ; $481F
    ld [wSndSfx1 + $6], a                         ; $4821
    ld a, $03                                     ; $4824
    ld hl, Sfx1_Data_481A                         ; $4826
    jp Snd_Sfx_Start                              ; $4829


; C: channel-1 effect step handler of id 14 (hot spot). Named after the caller of its id (SFX1_HOTSPOT_SOUND_01,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_14_HotspotSound01::
    call Snd_Sfx_TickCounter                      ; $482C
    and a                                         ; $482F
    ret nz                                        ; $4830

    ld hl, wSndSfx1 + $6                          ; $4831
    inc [hl]                                      ; $4834
    inc [hl]                                      ; $4835
    ld a, [hl]                                    ; $4836
    cp $c0                                        ; $4837
    jp z, Sfx1_Stop                               ; $4839

    ldh [rNR13], a                                ; $483C
    ret                                           ; $483E


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_483F::
    db $00, $80, $40, $60, $87

; C: channel-1 effect init handler of id 15: hot-spot related (owner, by ear: sure). Named after the caller of its id
; (SFX1_HOTSPOT_SOUND_02, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_15_HotspotSound02::
    ld a, $60                                     ; $4844
    ld [wSndSfx1 + $6], a                         ; $4846
    ld a, $03                                     ; $4849
    ld hl, Sfx1_Data_483F                         ; $484B
    jp Snd_Sfx_Start                              ; $484E


; C: channel-1 effect step handler of id 15 (hot spot). Named after the caller of its id (SFX1_HOTSPOT_SOUND_02,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_15_HotspotSound02::
    call Snd_Sfx_TickCounter                      ; $4851
    and a                                         ; $4854
    ret nz                                        ; $4855

    ld hl, wSndSfx1 + $6                          ; $4856
    dec [hl]                                      ; $4859
    dec [hl]                                      ; $485A
    ld a, [hl]                                    ; $485B
    cp $10                                        ; $485C
    jp z, Sfx1_Stop                               ; $485E

    ldh [rNR13], a                                ; $4861
    ret                                           ; $4863


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4864::
    db $9c, $80, $e0, $34, $84

; C: channel-1 effect init handler of ids 18 (table $41FA)
Sfx1_Init_18::
    ld a, $09                                     ; $4869
    ld hl, Sfx1_Data_4864                         ; $486B
    jp Snd_Sfx_Start                              ; $486E


    ld a, $06                                     ; $4871
    ld hl, Sfx1_Init_18 + $10                     ; $4873
    jp Snd_Sfx_Start                              ; $4876


    db $9e, $00, $50, $ee, $c7

; C: channel-1 effect init handler of ids 12 1D (table $41FA). Named after the caller of its ids (SFX1_PANEL_OPEN,
; SFX1_PANEL_OPEN_ALIAS_1D, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_12_1D_PanelOpen::
    ld a, $06                                     ; $487E
    ld hl, Sfx1_Data_4886 + $5                    ; $4880
    jp Snd_Sfx_Start                              ; $4883


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4886::
    db $7e, $c0, $90, $aa, $c7
    db $9e, $00, $d0, $ee, $c7

; C: channel-1 effect init handler of ids 0C (table $41FA). Named after the caller of its id
; (SFX1_SPACE_FEVER_ENEMY_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx1_Init_0C_SpaceFeverEnemyKill::
    call Sfx1_IsRunning26                         ; $4890
    ret z                                         ; $4893

    ld a, $07                                     ; $4894
    ld hl, Sfx1_Data_4886 + $5                    ; $4896
    jp Snd_Sfx_Start                              ; $4899


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_489C::
    db $7f, $c0, $9a, $34, $c4

; C: channel-1 effect init handler of ids 07 (table $41FA). Named after the caller of its id (SFX1_MAIN_MENU_MOVE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_07_MainMenuMove::
    ld a, $04                                     ; $48A1
    ld hl, Sfx1_Data_489C                         ; $48A3
    call Snd_Sfx_Start                            ; $48A6
    ldh a, [rDIV]                                 ; $48A9
    or $00                                        ; $48AB
    ldh [rNR13], a                                ; $48AD
    ldh a, [rDIV]                                 ; $48AF
    or $c5                                        ; $48B1
    ldh [rNR14], a                                ; $48B3
    ret                                           ; $48B5


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_48B6::
    db $2f, $e9, $f0, $34, $c7

; C: channel-1 effect init handler of ids 2C (table $41FA)
Sfx1_Init_2C::
    ldh a, [rDIV]                                 ; $48BB
    and $03                                       ; $48BD
    ld c, a                                       ; $48BF
    ld b, $00                                     ; $48C0
    ld hl, Sfx1_Data_48EC + $4                    ; $48C2
    add hl, bc                                    ; $48C5
    ld a, [hl]                                    ; $48C6
    ld hl, Sfx1_Data_48B6                         ; $48C7
    call Snd_Sfx_Start                            ; $48CA
    ldh a, [rDIV]                                 ; $48CD
    ld e, a                                       ; $48CF
    srl a                                         ; $48D0
    srl a                                         ; $48D2
    and $03                                       ; $48D4
    ld c, a                                       ; $48D6
    ld b, $00                                     ; $48D7
    ld hl, Sfx1_Data_48EC                         ; $48D9
    add hl, bc                                    ; $48DC
    ld a, e                                       ; $48DD
    and $0f                                       ; $48DE
    or [hl]                                       ; $48E0
    ldh [rNR13], a                                ; $48E1
    ld a, $c7                                     ; $48E3
    ldh [rNR14], a                                ; $48E5

; C: shared tail of four channel-1 init routines (callers 4973, 49C3, 4A7B, 4AA2) after Snd_Sfx_Start: clears $DD08
; and returns (branch target; code read 2026-10-19)
Sfx1_InitTail_ClearFlag::
    xor a                                         ; $48E7
    ld [wSndSeqIdx], a                            ; $48E8
    ret                                           ; $48EB


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_48EC::
    db $80, $90, $70, $60, $0a, $07, $0f, $0c, $27, $34, $f0, $34, $c7

; C: channel-1 effect init handler of ids 2D (table $41FA)
Sfx1_Init_2D::
    ldh a, [rDIV]                                 ; $48F9
    add $03                                       ; $48FB
    and $0f                                       ; $48FD
    ld hl, Sfx1_Data_48EC + $8                    ; $48FF
    call Snd_Sfx_Start                            ; $4902
    ldh a, [rDIV]                                 ; $4905
    and $bf                                       ; $4907
    ldh [rNR13], a                                ; $4909
    ld a, $c7                                     ; $490B
    ldh [rNR14], a                                ; $490D
    jr Sfx1_InitTail_ClearFlag                    ; $490F

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4911::
    db $59, $83, $ac, $c1, $d6
    db $c1, $ac, $83, $59, $00

; C: channel-1 effect init handler of ids 2F (table $41FA). Owner (review page, 2026-10-13, by ear): sfx1 2F: unsure;
; listed as the D.J. performance screen SE 4 (05:554D).
Sfx1_Init_2F::
    ld a, $f0                                     ; $491B
    ld [wSndSfx1 + $7], a                         ; $491D
    ld a, $04                                     ; $4920
    ld hl, Sfx1_Data_4961                         ; $4922
    jp Snd_Sfx_Start                              ; $4925


; C: channel-1 effect step handler of ids 2F (table $4276)
Sfx1_Step_2F::
    call Snd_Sfx_TickCounter                      ; $4928
    and a                                         ; $492B
    ret nz                                        ; $492C

    ld bc, Sfx1_Data_4911                         ; $492D
    ld hl, wSndSfx1 + $4                          ; $4930
    ld a, [hl]                                    ; $4933
    inc [hl]                                      ; $4934
    ld l, a                                       ; $4935
    ld h, $00                                     ; $4936
    add hl, bc                                    ; $4938
    ld a, [hl]                                    ; $4939
    and a                                         ; $493A
    jr z, jr_01f_494d                             ; $493B

jr_01f_493d:
    ldh [rNR13], a                                ; $493D
    ld a, [wSndSfx1 + $7]                         ; $493F
    ldh [rNR12], a                                ; $4942
    ld a, $b8                                     ; $4944
    ldh [rNR11], a                                ; $4946
    ld a, $c7                                     ; $4948
    ldh [rNR14], a                                ; $494A
    ret                                           ; $494C


jr_01f_494d:
    xor a                                         ; $494D
    ld [wSndSfx1 + $4], a                         ; $494E
    ld a, [wSndSfx1 + $7]                         ; $4951
    sub $30                                       ; $4954
    ld [wSndSfx1 + $7], a                         ; $4956
    and a                                         ; $4959
    jp z, Sfx1_Stop                               ; $495A

    ld a, $06                                     ; $495D
    jr jr_01f_493d                                ; $495F

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4961::
    db $00, $b8, $f0, $06, $c7
    db $9c, $80, $f0, $10, $87

; C: channel-1 effect init handler of ids 2E (table $41FA)
Sfx1_Init_2E::
    ld hl, Sfx1_Data_4961 + $5                    ; $496B
    ld a, $13                                     ; $496E
    jp Snd_Sfx_Start                              ; $4970


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4973::
    db $6e, $80, $c0, $ff, $87

; C: channel-1 effect init handler of ids 32 (table $41FA)
Sfx1_Init_32::
    ld a, $08                                     ; $4978
    ld hl, Sfx1_Data_4973                         ; $497A
    call Snd_Sfx_Start                            ; $497D
    jp Sfx1_InitTail_ClearFlag                    ; $4980


; C: channel-1 effect step handler of ids 32 (table $4276)
Sfx1_Step_32::
    call Snd_Sfx_TickCounter                      ; $4983
    and a                                         ; $4986
    ret nz                                        ; $4987

    ld hl, wSndSfx1 + $4                          ; $4988
    ld c, [hl]                                    ; $498B
    inc [hl]                                      ; $498C
    ld b, $00                                     ; $498D
    ld hl, Sfx1_Data_499B                         ; $498F
    add hl, bc                                    ; $4992
    ld a, [hl]                                    ; $4993
    ldh [rNR13], a                                ; $4994
    ld a, $87                                     ; $4996
    ldh [rNR14], a                                ; $4998
    ret                                           ; $499A


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_499B::
    db $e0, $d0, $c0, $b0, $a0, $90, $80, $c0, $b0, $a0, $90, $80, $70, $60, $a0, $90
    db $80, $70, $60, $50, $40, $90, $80, $70, $60, $50, $40, $30, $70, $60, $50, $40
    db $30, $20, $10, $65, $80, $e0, $20, $85

; C: channel-1 effect init handler of ids 33 (table $41FA)
Sfx1_Init_33::
    ld a, $85                                     ; $49C3
    ld [wSndSfx1 + $6], a                         ; $49C5
    ld a, $08                                     ; $49C8
    ld hl, Sfx1_Data_499B + $23                   ; $49CA
    call Snd_Sfx_Start                            ; $49CD
    jp Sfx1_InitTail_ClearFlag                    ; $49D0


; C: channel-1 effect step handler of ids 33 (table $4276)
Sfx1_Step_33::
    call Snd_Sfx_TickCounter                      ; $49D3
    and a                                         ; $49D6
    ret nz                                        ; $49D7

    ld hl, wSndSfx1 + $4                          ; $49D8
    ld c, [hl]                                    ; $49DB
    inc [hl]                                      ; $49DC
    ld b, $00                                     ; $49DD
    ld hl, Sfx1_Data_4A00                         ; $49DF
    add hl, bc                                    ; $49E2
    ld a, [hl]                                    ; $49E3
    cp $11                                        ; $49E4
    jr z, jr_01f_49f0                             ; $49E6

jr_01f_49e8:
    ldh [rNR13], a                                ; $49E8
    ld a, [wSndSfx1 + $6]                         ; $49EA
    ldh [rNR14], a                                ; $49ED
    ret                                           ; $49EF


jr_01f_49f0:
    ld hl, wSndSfx1 + $6                          ; $49F0
    inc [hl]                                      ; $49F3
    ld a, [hl]                                    ; $49F4
    and $07                                       ; $49F5
    or $80                                        ; $49F7
    ld [hl], a                                    ; $49F9
    xor a                                         ; $49FA
    ld [wSndSfx1 + $4], a                         ; $49FB
    jr jr_01f_49e8                                ; $49FE

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4A00::
    db $00, $30, $20, $10, $60
    db $50, $40, $a0, $90, $80
    db $d0, $c0, $b0, $e0, $11

; C: eight 5-byte register blocks of effect $34
Sfx1_34_SeqRegs::
    db $00, $f3, $f0, $06, $c7
    db $00, $f3, $f0, $21, $c7
    db $00, $f3, $f0, $39, $c7
    db $00, $f3, $f0, $44, $c7
    db $00, $f3, $f0, $59, $c7
    db $00, $f3, $f0, $6b, $c7
    db $00, $f3, $f0, $7b, $c7
    db $00, $f3, $f0, $72, $c7

; C: step memory $DD08 -> block
Sfx1_34_SeqIdx::
    db $14, $19, $14, $0f, $0a, $0f, $14, $05, $0a, $0f, $0a, $0f, $14, $14, $19, $14, $0f, $0a, $0f, $14, $05, $14, $0a, $00

jr_01f_4a4f:
    xor a                                         ; $4A4F
    ld [hl], a                                    ; $4A50

; C: channel-1 effect init handler of ids 34 (table $41FA)
Sfx1_Init_34_SeqStep::
    ld hl, wSndSeqIdx                             ; $4A51
    ld a, [hl]                                    ; $4A54
    cp $18                                        ; $4A55
    jr z, jr_01f_4a4f                             ; $4A57

    inc [hl]                                      ; $4A59
    ld c, a                                       ; $4A5A
    ld b, $00                                     ; $4A5B
    ld hl, Sfx1_34_SeqIdx                         ; $4A5D
    add hl, bc                                    ; $4A60
    ld a, [hl]                                    ; $4A61
    ld c, a                                       ; $4A62
    ld b, $00                                     ; $4A63
    ld hl, Sfx1_34_SeqRegs                        ; $4A65
    add hl, bc                                    ; $4A68
    ld a, $0d                                     ; $4A69
    jp Snd_Sfx_Start                              ; $4A6B


; I: step handler that no table lists (effect $34 uses the generic step; dead)
Unused_Sfx1_Step_4A6E::
    call Snd_Sfx_TickCounter                      ; $4A6E
    and a                                         ; $4A71
    jp z, Sfx1_Stop                               ; $4A72

    ret                                           ; $4A75


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4A76::
    db $00, $80, $b0, $b0, $87

; C: channel-1 effect init handler of ids 30 (table $41FA). Named after the caller of its id (SFX1_RUN_CELEBRATION,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_30_RunCelebration::
    ld a, $b0                                     ; $4A7B
    ld [wSndSfx1 + $6], a                         ; $4A7D
    ld a, $01                                     ; $4A80
    ld hl, Sfx1_Data_4A76                         ; $4A82
    call Snd_Sfx_Start                            ; $4A85
    jp Sfx1_InitTail_ClearFlag                    ; $4A88


; C: channel-1 effect step handler of ids 30 (table $4276). Named after the caller of its id (SFX1_RUN_CELEBRATION,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_30_RunCelebration::
    call Snd_Sfx_TickCounter                      ; $4A8B
    and a                                         ; $4A8E
    ret nz                                        ; $4A8F

    ld hl, wSndSfx1 + $6                          ; $4A90
    dec [hl]                                      ; $4A93
    ld a, [hl]                                    ; $4A94
    cp $10                                        ; $4A95
    jp z, Sfx1_Stop                               ; $4A97

    ldh [rNR13], a                                ; $4A9A
    ret                                           ; $4A9C


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4A9D::
    db $00, $80, $b0, $60, $87

; C: channel-1 effect init handler of ids 31 (table $41FA)
Sfx1_Init_31::
    ld a, $60                                     ; $4AA2
    ld [wSndSfx1 + $6], a                         ; $4AA4
    ld a, $01                                     ; $4AA7
    ld hl, Sfx1_Data_4A9D                         ; $4AA9
    call Snd_Sfx_Start                            ; $4AAC
    jp Sfx1_InitTail_ClearFlag                    ; $4AAF


; C: channel-1 effect step handler of ids 31 (table $4276)
Sfx1_Step_31::
    call Snd_Sfx_TickCounter                      ; $4AB2
    and a                                         ; $4AB5
    ret nz                                        ; $4AB6

    ld hl, wSndSfx1 + $6                          ; $4AB7
    inc [hl]                                      ; $4ABA
    inc [hl]                                      ; $4ABB
    ld a, [hl]                                    ; $4ABC
    cp $f0                                        ; $4ABD
    jp z, Sfx1_Stop                               ; $4ABF

    ldh [rNR13], a                                ; $4AC2
    ret                                           ; $4AC4


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4AC5::
    db $4d, $80, $f5, $70, $87
    db $e7, $a7, $77, $d7, $87
    db $57, $77, $47, $27, $00

; C: channel-1 effect init handler of ids 38 (table $41FA). Named after the caller of its id (SFX1_CURSOR_MOVE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_38_CursorMove::
    ld a, $87                                     ; $4AD4
    ld [wSndSfx1 + $7], a                         ; $4AD6
    ld a, $03                                     ; $4AD9
    ld hl, Sfx1_Data_4AC5                         ; $4ADB
    jp Snd_Sfx_Start                              ; $4ADE


; C: channel-1 effect step handler of ids 38 (table $4276). Named after the caller of its id (SFX1_CURSOR_MOVE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_38_CursorMove::
    call Snd_Sfx_TickCounter                      ; $4AE1
    and a                                         ; $4AE4
    ret nz                                        ; $4AE5

    ld hl, Sfx1_Data_4AC5 + $5                    ; $4AE6
    jp Sfx1_StepRegTable                          ; $4AE9


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4AEC::
    db $36, $80, $f5, $e0, $86
    db $e7, $a7, $77, $d7, $87
    db $57, $67, $37, $47, $00

; C: channel-1 effect init handler of ids 37 (table $41FA). Named after the caller of its id (SFX1_COPY_BROWSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_37_CopyBrowse::
    ld a, $86                                     ; $4AFB
    ld [wSndSfx1 + $7], a                         ; $4AFD
    ld a, $03                                     ; $4B00
    ld hl, Sfx1_Data_4AEC                         ; $4B02
    jp Snd_Sfx_Start                              ; $4B05


; C: channel-1 effect step handler of ids 37 (table $4276). Named after the caller of its id (SFX1_COPY_BROWSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_37_CopyBrowse::
    call Snd_Sfx_TickCounter                      ; $4B08
    and a                                         ; $4B0B
    ret nz                                        ; $4B0C

    ld hl, Sfx1_Data_4AEC + $5                    ; $4B0D
    jr Sfx1_StepRegTable                          ; $4B10

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B12::
    db $4b, $80, $b7, $10, $87, $87, $67, $47, $47, $37, $27, $37, $27, $17, $27, $27
    db $17, $00

; C: channel-1 effect init handler of ids 39 (table $41FA). Named after the caller of its id (SFX1_MENU_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_39_MenuChoose::
    ld a, $87                                     ; $4B24
    ld [wSndSfx1 + $7], a                         ; $4B26
    ld a, $04                                     ; $4B29
    ld hl, Sfx1_Data_4B12                         ; $4B2B
    jp Snd_Sfx_Start                              ; $4B2E


; C: channel-1 effect step handler of ids 39 (table $4276). Named after the caller of its id (SFX1_MENU_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_39_MenuChoose::
    call Snd_Sfx_TickCounter                      ; $4B31
    and a                                         ; $4B34
    ret nz                                        ; $4B35

    ld hl, Sfx1_Data_4B12 + $5                    ; $4B36
    jr Sfx1_StepRegTable                          ; $4B39

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B3B::
    db $4e, $00, $f5, $00, $87
    db $e7, $a7, $77, $d7, $87
    db $57, $67, $37, $47, $00

; C: channel-1 effect init handler of ids 36 (table $41FA). Named after the caller of its id (SFX1_PAGE_STEP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_36_PageStep::
    ld a, $87                                     ; $4B4A
    ld [wSndSfx1 + $7], a                         ; $4B4C
    ld a, $03                                     ; $4B4F
    ld hl, Sfx1_Data_4B3B                         ; $4B51
    jp Snd_Sfx_Start                              ; $4B54


; C: channel-1 effect step handler of ids 36 (table $4276). Named after the caller of its id (SFX1_PAGE_STEP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_36_PageStep::
    call Snd_Sfx_TickCounter                      ; $4B57
    and a                                         ; $4B5A
    ret nz                                        ; $4B5B

    ld hl, Sfx1_Data_4B3B + $5                    ; $4B5C
    jr Sfx1_StepRegTable                          ; $4B5F

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B61::
    db $3d, $c0, $f5, $33, $87, $e7, $b7, $a7, $b7, $77, $57, $47, $37, $37, $27, $00

; C: channel-1 effect init handler of ids 35 (table $41FA). Named after the caller of its id (SFX1_RUN_JUMP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_35_RunJump::
    ld a, $87                                     ; $4B71
    ld [wSndSfx1 + $7], a                         ; $4B73
    ld a, $04                                     ; $4B76
    ld hl, Sfx1_Data_4B61                         ; $4B78
    jp Snd_Sfx_Start                              ; $4B7B


; C: channel-1 effect step handler of ids 35 (table $4276). Named after the caller of its id (SFX1_RUN_JUMP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_35_RunJump::
    call Snd_Sfx_TickCounter                      ; $4B7E
    and a                                         ; $4B81
    ret nz                                        ; $4B82

    ld hl, Sfx1_Data_4B61 + $5                    ; $4B83

; C: shared step: reads one byte of the table in HL at index $DD64 into NR12 until $00 (then Sfx1_Stop)
Sfx1_StepRegTable::
    push hl                                       ; $4B86
    ld hl, wSndSfx1 + $4                          ; $4B87
    ld c, [hl]                                    ; $4B8A
    inc [hl]                                      ; $4B8B
    ld b, $00                                     ; $4B8C
    pop hl                                        ; $4B8E
    add hl, bc                                    ; $4B8F
    ld a, [hl]                                    ; $4B90
    and a                                         ; $4B91
    jp z, Sfx1_Stop                               ; $4B92

    ld c, $12                                     ; $4B95
    ldh [c], a                                    ; $4B97
    inc c                                         ; $4B98
    inc c                                         ; $4B99
    ld a, [wSndSfx1 + $7]                         ; $4B9A
    ldh [c], a                                    ; $4B9D
    ret                                           ; $4B9E


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B9F::
    db $4c, $c0, $f5, $ee, $87
    db $e5, $b5, $a5, $b5, $75
    db $55, $45, $35, $45, $35
    db $35, $35, $25, $25, $00

; C: channel-1 effect init handler of ids 0F (table $41FA). Named after the caller of its id
; (SFX1_SPACE_FEVER_TARGET_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Init_0F_SpaceFeverTargetKill::
    ld a, $03                                     ; $4BB3
    ld hl, Sfx1_Data_4B9F                         ; $4BB5
    jp Snd_Sfx_Start                              ; $4BB8


; C: channel-1 effect step handler of ids 0F (table $4276). Named after the caller of its id
; (SFX1_SPACE_FEVER_TARGET_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Step_0F_SpaceFeverTargetKill::
    call Snd_Sfx_TickCounter                      ; $4BBB
    and a                                         ; $4BBE
    ret nz                                        ; $4BBF

    ld hl, wSndSfx1 + $4                          ; $4BC0
    ld c, [hl]                                    ; $4BC3
    inc [hl]                                      ; $4BC4
    ld b, $00                                     ; $4BC5
    ld hl, Sfx1_Data_4B9F + $5                    ; $4BC7
    jr jr_01f_4bf2                                ; $4BCA

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4BCC::
    db $4a, $00, $f2, $90, $87
    db $d3, $b3, $a3, $43, $43
    db $33, $33, $23, $23, $00

; C: channel-1 effect init handler of ids 11 (table $41FA). Named after the caller of its id (SFX1_CONFIRM,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_11_Confirm::
    ld a, $03                                     ; $4BDB
    ld hl, Sfx1_Data_4BCC                         ; $4BDD
    jp Snd_Sfx_Start                              ; $4BE0


; C: channel-1 effect step handler of ids 11 (table $4276). Named after the caller of its id (SFX1_CONFIRM,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_11_Confirm::
    call Snd_Sfx_TickCounter                      ; $4BE3
    and a                                         ; $4BE6
    ret nz                                        ; $4BE7

    ld hl, wSndSfx1 + $4                          ; $4BE8
    ld c, [hl]                                    ; $4BEB
    inc [hl]                                      ; $4BEC
    ld b, $00                                     ; $4BED
    ld hl, Sfx1_Data_4BCC + $5                    ; $4BEF

jr_01f_4bf2:
    add hl, bc                                    ; $4BF2
    ld a, [hl]                                    ; $4BF3
    and a                                         ; $4BF4
    jr z, jr_01f_4c01                             ; $4BF5

    ld b, $86                                     ; $4BF7

jr_01f_4bf9:
    ld c, $12                                     ; $4BF9
    ldh [c], a                                    ; $4BFB
    inc c                                         ; $4BFC
    inc c                                         ; $4BFD
    ld a, b                                       ; $4BFE
    ldh [c], a                                    ; $4BFF
    ret                                           ; $4C00


jr_01f_4c01:
    jp Sfx1_Stop                                  ; $4C01


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4C04::
    db $3b, $80, $f4, $dd, $87, $d2, $b2, $a2, $92, $82, $72, $62, $52, $23, $23, $13
    db $13, $00

; C: channel-1 effect init handler of ids 13 (table $41FA). Named after the caller of its id (SFX1_PANEL_CLOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_13_PanelClose::
    ld a, $03                                     ; $4C16
    ld hl, Sfx1_Data_4C04                         ; $4C18
    jp Snd_Sfx_Start                              ; $4C1B


; C: channel-1 effect step handler of ids 13 (table $4276). Named after the caller of its id (SFX1_PANEL_CLOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_13_PanelClose::
    call Snd_Sfx_TickCounter                      ; $4C1E
    and a                                         ; $4C21
    ret nz                                        ; $4C22

    ld hl, wSndSfx1 + $4                          ; $4C23
    ld c, [hl]                                    ; $4C26
    inc [hl]                                      ; $4C27
    ld b, $00                                     ; $4C28
    ld hl, Sfx1_Data_4C04 + $5                    ; $4C2A
    add hl, bc                                    ; $4C2D
    ld a, [hl]                                    ; $4C2E
    and a                                         ; $4C2F
    jp z, Sfx1_Stop                               ; $4C30

    ld b, $87                                     ; $4C33
    jr jr_01f_4bf9                                ; $4C35

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4C37::
    db $3b, $80, $f4, $90, $87, $b2, $a2, $82, $72, $62, $43, $43, $33, $23, $23, $13
    db $00

; C: channel-1 effect init handler of ids 19 3A (table $41FA). Named after the caller of its ids
; (SFX1_COMPOSE_LAYOUT_KEY, SFX1_PICK_PHOTO, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function
; / caller, not by ear).
Sfx1_Init_19_3A_ComposeLayoutKey_PickPhoto::
    ld a, $02                                     ; $4C48
    ld hl, Sfx1_Data_4C37                         ; $4C4A
    jp Snd_Sfx_Start                              ; $4C4D


; C: channel-1 effect step handler of ids 19 3A (table $4276). Named after the caller of its ids
; (SFX1_COMPOSE_LAYOUT_KEY, SFX1_PICK_PHOTO, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function
; / caller, not by ear).
Sfx1_Step_19_3A_ComposeLayoutKey_PickPhoto::
    call Snd_Sfx_TickCounter                      ; $4C50
    and a                                         ; $4C53
    ret nz                                        ; $4C54

    ld hl, wSndSfx1 + $4                          ; $4C55
    ld c, [hl]                                    ; $4C58
    inc [hl]                                      ; $4C59
    ld b, $00                                     ; $4C5A
    ld hl, Sfx1_Data_4C37 + $5                    ; $4C5C
    add hl, bc                                    ; $4C5F
    ld a, [hl]                                    ; $4C60
    and a                                         ; $4C61
    jp z, Sfx1_Stop                               ; $4C62

    ld b, $87                                     ; $4C65
    jr jr_01f_4bf9                                ; $4C67

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4C69::
    db $00, $00, $5b, $0a, $86

; C: channel-1 effect init handler of ids 08 (table $41FA). Named after the caller of its id
; (SFX1_MAIN_MENU_PAGE_DOWN, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_08_MainMenuPageDown::
    ld a, [Sfx1_Data_4C69 + $3]                   ; $4C6E
    ld hl, Sfx1_Data_4C69                         ; $4C71
    ld [wSndSfx1 + $6], a                         ; $4C74
    ld a, $04                                     ; $4C77
    jp Snd_Sfx_Start                              ; $4C79


; C: channel-1 effect step handler of ids 08 (table $4276). Named after the caller of its id
; (SFX1_MAIN_MENU_PAGE_DOWN, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Step_08_MainMenuPageDown::
    call Snd_Sfx_TickCounter                      ; $4C7C
    and a                                         ; $4C7F
    ret nz                                        ; $4C80

    ld hl, wSndSfx1 + $4                          ; $4C81
    ld a, [hl]                                    ; $4C84
    inc [hl]                                      ; $4C85
    cp $07                                        ; $4C86
    jr z, jr_01f_4ca6                             ; $4C88

    cp $08                                        ; $4C8A
    jr z, jr_01f_4cac                             ; $4C8C

    cp $09                                        ; $4C8E
    jr z, jr_01f_4cb2                             ; $4C90

    cp $0a                                        ; $4C92
    jr z, jr_01f_4cb8                             ; $4C94

    cp $0b                                        ; $4C96
    jp z, Sfx1_Stop                               ; $4C98

    ld hl, wSndSfx1 + $6                          ; $4C9B
    inc [hl]                                      ; $4C9E
    inc [hl]                                      ; $4C9F
    ld a, [wSndSfx1 + $6]                         ; $4CA0
    ldh [rNR13], a                                ; $4CA3
    ret                                           ; $4CA5


jr_01f_4ca6:
    ld hl, Sfx1_Data_4CBE                         ; $4CA6
    jp Snd_Sfx_LoadNR1x                           ; $4CA9


jr_01f_4cac:
    ld hl, Sfx1_Data_4CBE + $5                    ; $4CAC
    jp Snd_Sfx_LoadNR1x                           ; $4CAF


jr_01f_4cb2:
    ld hl, Sfx1_Data_4CBE + $A                    ; $4CB2
    jp Snd_Sfx_LoadNR1x                           ; $4CB5


jr_01f_4cb8:
    ld hl, Sfx1_Data_4CBE + $F                    ; $4CB8
    jp Snd_Sfx_LoadNR1x                           ; $4CBB


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4CBE::
    db $00, $b9, $72, $9d, $c7, $00, $b9, $92, $a2, $c7, $00, $b9, $c2, $ac, $c7, $00
    db $b9, $e2, $c1, $c7, $3e, $08, $e0, $17, $3e, $80, $e0, $19, $21, $2f, $dd, $cb
    db $be, $c9, $00, $d0, $3a, $80, $2c, $2c, $2f, $2d, $3c, $1c, $2d, $3d

; C: channel-4 effect init handler of ids 09 (table $431A)
Sfx4_Init_09::
    ld a, $02                                     ; $4CEC
    ld hl, Sfx1_Data_4CBE + $22                   ; $4CEE
    jp Snd_Sfx_Start                              ; $4CF1


; C: channel-4 effect step handler of ids 09 (table $433E)
Sfx4_Step_09::
    call Snd_Sfx_TickCounter                      ; $4CF4
    and a                                         ; $4CF7
    ret nz                                        ; $4CF8

    ld hl, wSndSfx4 + $4                          ; $4CF9
    ld a, [hl]                                    ; $4CFC
    cp $15                                        ; $4CFD
    jp z, Sfx4_Stop                               ; $4CFF

    and $07                                       ; $4D02
    ld c, a                                       ; $4D04
    ld b, $00                                     ; $4D05
    inc [hl]                                      ; $4D07
    ld hl, Sfx1_Data_4CBE + $26                   ; $4D08
    add hl, bc                                    ; $4D0B
    ld a, [hl]                                    ; $4D0C
    ldh [rNR43], a                                ; $4D0D
    ld a, $80                                     ; $4D0F
    ldh [rNR44], a                                ; $4D11
    ret                                           ; $4D13


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4D14::
    db $0c, $0d, $0e, $0f, $1c, $1d, $1e, $1f, $00, $00, $1f, $0b, $80, $00, $f3, $44
    db $80, $00, $e5, $45, $80, $00, $a4, $46, $80, $00, $d3, $44, $80, $00, $04, $08
    db $0c

; C: channel-4 effect init handler of ids 05 (table $431A). The name EraseAnim comes from the caller EraseAnim_Run
; (04:5165, the only request site); the owner confirmed it on 2026-10-26: the photo erase sound, not a Space Fever II
; one (his by-ear guess of 2026-10-13 withdrawn). Named after the caller of ...
Sfx4_Init_05_EraseAnim::
    ldh a, [rDIV]                                 ; $4D35
    and $03                                       ; $4D37
    ld c, a                                       ; $4D39
    ld b, $00                                     ; $4D3A
    ld hl, Sfx4_Data_4D14 + $1D                   ; $4D3C
    add hl, bc                                    ; $4D3F
    ld c, [hl]                                    ; $4D40
    ld b, $00                                     ; $4D41
    ld hl, Sfx4_Data_4D14 + $D                    ; $4D43
    add hl, bc                                    ; $4D46
    ld a, $a0                                     ; $4D47
    jp Snd_Sfx_Start                              ; $4D49


; C: channel-4 effect init handler of ids 06 (table $431A)
Sfx4_Init_06::
    ld a, $13                                     ; $4D4C
    ld hl, Sfx4_Data_4D14 + $9                    ; $4D4E
    jp Snd_Sfx_Start                              ; $4D51


; C: channel-4 effect step handler of ids 06 (table $433E)
Sfx4_Step_06::
    ld hl, wSndSfx4 + $4                          ; $4D54
    ld a, [hl]                                    ; $4D57
    cp $b0                                        ; $4D58
    jp z, Sfx4_Stop                               ; $4D5A

    ld c, [hl]                                    ; $4D5D
    ld b, $00                                     ; $4D5E
    inc [hl]                                      ; $4D60
    ld hl, wSndSfx4 + $5                          ; $4D61
    ld a, [hl]                                    ; $4D64
    and a                                         ; $4D65
    ret nz                                        ; $4D66

    ld hl, Sfx4_Data_4D14                         ; $4D67
    add hl, bc                                    ; $4D6A
    ld a, [hl]                                    ; $4D6B
    and a                                         ; $4D6C
    jp z, Sfx4_Step_06_LoadNR4x                   ; $4D6D

    ldh [rNR43], a                                ; $4D70
    ret                                           ; $4D72


; C: step 06 of the channel-4 effect when the table value is 0: $DD7D = 1, then Snd_Sfx_LoadNR4x with the data at
; $4D14 (branch target; code read 2026-10-19)
Sfx4_Step_06_LoadNR4x::
    ld a, $01                                     ; $4D73
    ld hl, wSndSfx4 + $5                          ; $4D75
    ld [hl], a                                    ; $4D78
    ld hl, Sfx4_Data_4D14 + $D                    ; $4D79
    jp Snd_Sfx_LoadNR4x                           ; $4D7C


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4D7F::
    db $00, $e1, $25, $80, $00, $61, $25, $80

; C: channel-4 effect init handler of ids 0B (table $431A)
Sfx4_Init_0B::
    ld a, $18                                     ; $4D87
    ld hl, Sfx4_Data_4D7F                         ; $4D89
    jp Snd_Sfx_Start                              ; $4D8C


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4D8F::
    db $00, $f1, $25, $80

; C: channel-4 effect init handler of ids 01 (table $431A). Named after the caller of its id (SFX4_STAMP_COMMIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_01_StampCommit::
    ld a, $07                                     ; $4D93
    ld hl, Sfx4_Data_4D8F                         ; $4D95
    jp Snd_Sfx_Start                              ; $4D98


; C: channel-4 effect step handler of ids 01 (table $433E). Named after the caller of its id (SFX4_STAMP_COMMIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_01_StampCommit::
    call Snd_Sfx_TickCounter                      ; $4D9B
    and a                                         ; $4D9E
    ret nz                                        ; $4D9F

    ld hl, wSndSfx4 + $4                          ; $4DA0
    inc [hl]                                      ; $4DA3
    ld a, [hl]                                    ; $4DA4
    cp $01                                        ; $4DA5
    jr z, jr_01f_4daf                             ; $4DA7

    cp $03                                        ; $4DA9
    jp z, Sfx4_Stop                               ; $4DAB

    ret                                           ; $4DAE


jr_01f_4daf:
    ld hl, Sfx4_Data_4D7F + $4                    ; $4DAF
    jp Snd_Sfx_LoadNR4x                           ; $4DB2


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4DB5::
    db $00, $e3, $16, $80

; C: channel-4 effect init handler of ids 0D (table $431A)
Sfx4_Init_0D::
    ld a, $50                                     ; $4DB9
    ld hl, Sfx4_Data_4DB5                         ; $4DBB
    jp Snd_Sfx_Start                              ; $4DBE


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4DC1::
    db $00, $f0, $2e, $80

; C: channel-4 effect init handler of ids 0F (table $431A)
Sfx4_Init_0F::
    ld a, $18                                     ; $4DC5
    ld hl, Sfx4_Data_4DC1                         ; $4DC7
    jp Snd_Sfx_Start                              ; $4DCA


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4DCD::
    db $00, $f0, $08, $80, $09, $0a, $0b, $0c, $0d, $0e, $0f, $1c, $1d, $1e, $1f, $24
    db $25, $26, $27, $34, $35, $36, $37, $44, $45, $46, $47, $54, $55, $56, $57, $64
    db $65, $66, $67, $74, $75, $76, $77, $84, $85, $86, $87, $94, $95, $96, $97, $a4
    db $00

; C: channel-4 effect init handler of ids 0E (table $431A)
Sfx4_Init_0E::
    ld a, $02                                     ; $4DFE
    ld hl, Sfx4_Data_4DCD                         ; $4E00
    jp Snd_Sfx_Start                              ; $4E03


; C: channel-4 effect step handler of ids 0E (table $433E)
Sfx4_Step_0E::
    call Snd_Sfx_TickCounter                      ; $4E06
    and a                                         ; $4E09
    ret nz                                        ; $4E0A

    ld hl, wSndSfx4 + $4                          ; $4E0B
    ld c, [hl]                                    ; $4E0E
    inc [hl]                                      ; $4E0F
    ld hl, Sfx4_Data_4DCD + $4                    ; $4E10
    jr jr_01f_4e43                                ; $4E13

; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E15::
    db $00, $40, $4e, $80, $4c, $3f, $6b, $3d, $3c, $2f, $2e, $2d, $2c, $1f, $1e, $1d
    db $14, $07, $06, $05, $04, $03, $02, $01, $00

; C: channel-4 effect init handler of ids 07 (table $431A). Named after the caller of its id
; (SFX4_SPACE_FEVER_FIRE_SHOTS, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx4_Init_07_SpaceFeverFireShots::
    ld a, $01                                     ; $4E2E
    ld hl, Sfx4_Data_4E15                         ; $4E30
    jp Snd_Sfx_Start                              ; $4E33


; C: channel-4 effect step handler of ids 07 (table $433E). Named after the caller of its id
; (SFX4_SPACE_FEVER_FIRE_SHOTS, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx4_Step_07_SpaceFeverFireShots::
    call Snd_Sfx_TickCounter                      ; $4E36
    and a                                         ; $4E39
    ret nz                                        ; $4E3A

    ld hl, wSndSfx4 + $4                          ; $4E3B
    ld c, [hl]                                    ; $4E3E
    inc [hl]                                      ; $4E3F
    ld hl, Sfx4_Data_4E15 + $4                    ; $4E40

jr_01f_4e43:
    ld b, $00                                     ; $4E43
    add hl, bc                                    ; $4E45
    ld a, [hl]                                    ; $4E46
    and a                                         ; $4E47
    jp z, Sfx4_Stop                               ; $4E48

    ldh [rNR43], a                                ; $4E4B
    ret                                           ; $4E4D


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E4E::
    db $00, $e3, $17, $80, $00, $f4, $64, $c0

; C: channel-4 effect init handler of ids 0A (table $431A). Named after the caller of its id (SFX4_LINK_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_0A_LinkChoose::
    ld a, $18                                     ; $4E56
    ld hl, Sfx4_Data_4E4E + $4                    ; $4E58
    jp Snd_Sfx_Start                              ; $4E5B


jr_01f_4e5e:
    ld hl, Sfx4_Data_4E4E                         ; $4E5E
    jp Snd_Sfx_LoadNR4x                           ; $4E61


; C: channel-4 effect step handler of ids 0A (table $433E). Named after the caller of its id (SFX4_LINK_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_0A_LinkChoose::
    ld hl, wSndSfx4 + $4                          ; $4E64
    ld a, [hl]                                    ; $4E67
    inc [hl]                                      ; $4E68
    cp $08                                        ; $4E69
    jr z, jr_01f_4e5e                             ; $4E6B

    cp $30                                        ; $4E6D
    jp z, Sfx4_Stop                               ; $4E6F

    ret                                           ; $4E72


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E73::
    db $3a, $b4, $14, $c0, $3d, $90, $24, $c0

; C: channel-4 effect init handler of ids 12 (table $431A). Named after the caller of its id (SFX4_MUSIC_SELECT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_12_MusicSelect::
    ld a, $03                                     ; $4E7B
    ld hl, Sfx4_Data_4E73 + $4                    ; $4E7D
    jp Snd_Sfx_Start                              ; $4E80


; C: channel-4 effect step handler of ids 12 (table $433E). Named after the caller of its id (SFX4_MUSIC_SELECT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_12_MusicSelect::
    call Snd_Sfx_TickCounter                      ; $4E83
    and a                                         ; $4E86
    ret nz                                        ; $4E87

    ld hl, wSndSfx4 + $4                          ; $4E88
    ld a, [hl]                                    ; $4E8B
    inc [hl]                                      ; $4E8C
    and a                                         ; $4E8D
    jr z, jr_01f_4e96                             ; $4E8E

    cp $02                                        ; $4E90
    jp z, Sfx4_Stop                               ; $4E92

    ret                                           ; $4E95


jr_01f_4e96:
    ld hl, Sfx4_Data_4E73                         ; $4E96
    jp Snd_Sfx_LoadNR4x                           ; $4E99


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E9C::
    db $00, $a2, $37, $80, $33, $f0, $5f, $c0

; C: channel-4 effect init handler of ids 04 (table $431A). Named after the caller of its id (SFX4_RUN_HURDLE_HIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_04_RunHurdleHit::
    ld a, $08                                     ; $4EA4
    ld hl, Sfx4_Data_4E9C + $4                    ; $4EA6
    jp Snd_Sfx_Start                              ; $4EA9


; C: channel-4 effect step handler of ids 04 (table $433E). Named after the caller of its id (SFX4_RUN_HURDLE_HIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_04_RunHurdleHit::
    call Snd_Sfx_TickCounter                      ; $4EAC
    and a                                         ; $4EAF
    ret nz                                        ; $4EB0

    ld hl, wSndSfx4 + $4                          ; $4EB1
    ld a, [hl]                                    ; $4EB4
    inc [hl]                                      ; $4EB5
    and a                                         ; $4EB6
    jr z, jr_01f_4ebf                             ; $4EB7

    cp $02                                        ; $4EB9
    jp z, Sfx4_Stop                               ; $4EBB

    ret                                           ; $4EBE


jr_01f_4ebf:
    ld hl, Sfx4_Data_4E9C                         ; $4EBF
    jp Snd_Sfx_LoadNR4x                           ; $4EC2


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4EC5::
    db $00, $f1, $34, $80

; C: channel-4 effect init handler of ids 11 (table $431A). Named after the caller of its id (SFX4_RUN_FLAG_HEIGHT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_11_RunFlagHeight::
    ld a, $0c                                     ; $4EC9
    ld hl, Sfx4_Data_4EC5                         ; $4ECB
    jp Snd_Sfx_Start                              ; $4ECE


; C: channel-4 effect step handler of ids 11 (table $433E). Named after the caller of its id (SFX4_RUN_FLAG_HEIGHT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_11_RunFlagHeight::
    call Snd_Sfx_TickCounter                      ; $4ED1
    and a                                         ; $4ED4
    ret nz                                        ; $4ED5

    ld hl, wSndSfx4 + $4                          ; $4ED6
    ld a, [hl]                                    ; $4ED9
    inc [hl]                                      ; $4EDA
    cp $07                                        ; $4EDB
    jp z, Sfx4_Stop                               ; $4EDD

    ld hl, Sfx4_Data_4EC5                         ; $4EE0
    jp Snd_Sfx_LoadNR4x                           ; $4EE3


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4EE6::
    db $00, $f4, $5f, $80

; C: channel-4 effect init handler of ids 08 (table $431A). Named after the caller of its id
; (SFX4_SPACE_FEVER_PLAYER_DEATH, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx4_Init_08_SpaceFeverPlayerDeath::
    call Snd_StopSong                             ; $4EEA
    ld a, $60                                     ; $4EED
    ld hl, Sfx4_Data_4EE6                         ; $4EEF
    jp Snd_Sfx_Start                              ; $4EF2


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4EF5::
    db $00, $74, $5f, $80

; C: channel-4 effect init handler of ids 02 (table $431A)
Sfx4_Init_02::
    ld a, $60                                     ; $4EF9
    ld hl, Sfx4_Data_4EF5                         ; $4EFB
    jp Snd_Sfx_Start                              ; $4EFE


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F01::
    db $00, $f4, $57, $80

; C: channel-4 effect init handler of ids 0C (table $431A)
Sfx4_Init_0C::
    ld a, $40                                     ; $4F05
    ld hl, Sfx4_Data_4F01                         ; $4F07
    jp Snd_Sfx_Start                              ; $4F0A


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F0D::
    db $00, $f2, $3c, $80, $2c, $1f, $2e, $4d, $5c, $5d, $4e, $2f, $4f

; C: channel-4 effect init handler of ids 03 (table $431A)
Sfx4_Init_03::
    ld a, $38                                     ; $4F1A
    ld hl, Sfx4_Data_4F0D                         ; $4F1C
    call Snd_Sfx_Start                            ; $4F1F
    ldh a, [rDIV]                                 ; $4F22
    and $07                                       ; $4F24
    ld c, a                                       ; $4F26
    ld b, $00                                     ; $4F27
    ld hl, Sfx4_Data_4F0D + $4                    ; $4F29

jr_01f_4f2c:
    add hl, bc                                    ; $4F2C
    ld a, [hl]                                    ; $4F2D
    ldh [rNR43], a                                ; $4F2E
    ld a, $80                                     ; $4F30
    ldh [rNR44], a                                ; $4F32
    ret                                           ; $4F34


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F35::
    db $00, $f2, $1c, $80

; C: channel-4 effect init handler of ids 10 (table $431A)
Sfx4_Init_10::
    ld a, $08                                     ; $4F39
    ld hl, Sfx4_Data_4F0D                         ; $4F3B
    jp Snd_Sfx_Start                              ; $4F3E


; C: channel-4 effect step handler of ids 10 (table $433E)
Sfx4_Step_10::
    call Snd_Sfx_TickCounter                      ; $4F41
    and a                                         ; $4F44
    ret nz                                        ; $4F45

    ld hl, wSndSfx4 + $4                          ; $4F46
    ld a, [hl]                                    ; $4F49
    cp $12                                        ; $4F4A
    jp z, Sfx4_Stop                               ; $4F4C

    and $07                                       ; $4F4F
    ld c, a                                       ; $4F51
    ld b, $00                                     ; $4F52
    inc [hl]                                      ; $4F54
    ld hl, Sfx4_Data_4F5A                         ; $4F55
    jr jr_01f_4f2c                                ; $4F58

; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F5A::
    db $0d, $1d, $0e, $0f, $0b, $1f, $1c, $0a, $1e

; C: shared channel-4 step handler (ids 02 03 05 08 0B 0C 0D 0F): Snd_Sfx_TickCounter until the limit; then the effect
; stops
Sfx4_Step_Generic::
    call Snd_Sfx_TickCounter                      ; $4F63
    and a                                         ; $4F66
    ret nz                                        ; $4F67

; C: channel-4 effect ends: running id 0; NR42=$08; NR44=$80; busy flag off
Sfx4_Stop::
    xor a                                         ; $4F68
    ld [wSndSfx4 + $1], a                         ; $4F69
    ld a, $08                                     ; $4F6C
    ldh [rNR42], a                                ; $4F6E
    ld a, $80                                     ; $4F70
    ldh [rNR44], a                                ; $4F72
    ld hl, wSndTrack4 + $f                        ; $4F74
    res 7, [hl]                                   ; $4F77
    ret                                           ; $4F79


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F7A::
    db $80, $00, $20, $40, $85

; C: channel-3 effect init handler of ids 07 (table $42F2)
Sfx3_Init_07::
    call Sfx3_Begin_Wave51B5                      ; $4F7F
    ld a, [Sfx4_Data_4F7A + $3]                   ; $4F82
    ld [wSndSfx3 + $5], a                         ; $4F85
    ld a, [Sfx4_Data_4F7A + $4]                   ; $4F88
    and $0f                                       ; $4F8B
    ld [wSndSfx3 + $6], a                         ; $4F8D
    ld hl, Sfx4_Data_4F7A                         ; $4F90
    jp Snd_Sfx_LoadNR3x                           ; $4F93


; C: channel-3 effect step: counter +1 in $DD74; HL = pointer in $DD75/$DD76
Sfx3_StepAdvance::
    ld hl, wSndSfx3 + $4                          ; $4F96
    inc [hl]                                      ; $4F99
    ld e, [hl]                                    ; $4F9A
    ld a, [wSndSfx3 + $5]                         ; $4F9B
    ld l, a                                       ; $4F9E
    ld a, [wSndSfx3 + $6]                         ; $4F9F
    ld h, a                                       ; $4FA2
    ld a, e                                       ; $4FA3
    ret                                           ; $4FA4


; C: channel-3 effect step handler of ids 07 (table $4306)
Sfx3_Step_07::
    call Sfx3_StepAdvance                         ; $4FA5
    cp $16                                        ; $4FA8
    jp z, Sfx3_Stop                               ; $4FAA

    cp $06                                        ; $4FAD
    jr c, jr_01f_4fc4                             ; $4FAF

    ld bc, $fff3                                  ; $4FB1

jr_01f_4fb4:
    add hl, bc                                    ; $4FB4
    ld a, l                                       ; $4FB5
    ldh [rNR33], a                                ; $4FB6
    ld [wSndSfx3 + $5], a                         ; $4FB8
    ld a, h                                       ; $4FBB
    ld [wSndSfx3 + $6], a                         ; $4FBC
    or $c0                                        ; $4FBF
    ldh [rNR34], a                                ; $4FC1
    ret                                           ; $4FC3


jr_01f_4fc4:
    ld bc, $000e                                  ; $4FC4
    jr jr_01f_4fb4                                ; $4FC7

; I: sets $DD0D (snd_freeze) = 1; no caller
Unused_Snd_SetFreeze::
    ld a, $01                                     ; $4FC9
    ld [wSndFreeze], a                            ; $4FCB
    ret                                           ; $4FCE


; I: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_4FCF::
    db $80, $f2, $20, $39, $c7, $21, $06, $06, $00

; I: channel-3 effect step handler of ids 09 (table $4306). Named after the caller of its id
; (SFX3_DELETE_DIALOG_SECOND, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Step_09_DeleteDialogSecond::
    ld hl, wSndSfx3 + $4                          ; $4FD8
    inc [hl]                                      ; $4FDB
    ld a, [hl]                                    ; $4FDC
    cp $06                                        ; $4FDD
    ret nz                                        ; $4FDF

    xor a                                         ; $4FE0
    ld [hl], a                                    ; $4FE1
    ldh [rNR30], a                                ; $4FE2
    inc l                                         ; $4FE4
    ld c, [hl]                                    ; $4FE5
    inc [hl]                                      ; $4FE6
    ld b, $00                                     ; $4FE7
    ld hl, Sfx3_Data_4FCF + $5                    ; $4FE9
    jr jr_01f_5014                                ; $4FEC

; C: channel-3 effect init handler of ids 09 (table $42F2). Named after the caller of its id
; (SFX3_DELETE_DIALOG_SECOND, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Init_09_DeleteDialogSecond::
    call Sfx3_Begin_Wave51F5                      ; $4FEE
    ld hl, Sfx3_Data_4FCF                         ; $4FF1
    jp Snd_Sfx_LoadNR3x                           ; $4FF4


; I: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_4FF7::
    db $80
    db $f2
    db $20
    db $ac
    db $c7

    db $b6
    db $be
    db $c1
    db $00

; I: channel-3 effect step handler of ids 08 (table $4306). Named after the caller of its id
; (SFX3_DELETE_DIALOG_FIRST, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx3_Step_08_DeleteDialogFirst::
    ld hl, wSndSfx3 + $4                          ; $5000
    inc [hl]                                      ; $5003
    ld a, [hl]                                    ; $5004
    cp $04                                        ; $5005
    ret nz                                        ; $5007

    xor a                                         ; $5008
    ld [hl], a                                    ; $5009
    ldh [rNR30], a                                ; $500A
    inc l                                         ; $500C
    ld c, [hl]                                    ; $500D
    inc [hl]                                      ; $500E
    ld b, $00                                     ; $500F
    ld hl, Sfx3_Data_4FF7 + $5                    ; $5011

jr_01f_5014:
    add hl, bc                                    ; $5014
    ld a, $80                                     ; $5015
    ldh [rNR30], a                                ; $5017
    ld a, [hl]                                    ; $5019
    and a                                         ; $501A
    jp z, Sfx3_Stop                               ; $501B

    ldh [rNR33], a                                ; $501E
    ld a, $f6                                     ; $5020
    ldh [rNR31], a                                ; $5022
    ld a, $c7                                     ; $5024
    ldh [rNR34], a                                ; $5026
    ret                                           ; $5028


; C: channel-3 effect init handler of ids 08 (table $42F2). Named after the caller of its id
; (SFX3_DELETE_DIALOG_FIRST, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx3_Init_08_DeleteDialogFirst::
    call Sfx3_Begin_Wave51E5                      ; $5029
    ld hl, Sfx3_Data_4FF7                         ; $502C
    jp Snd_Sfx_LoadNR3x                           ; $502F


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_5032::
    db $80, $50, $20, $f0, $c6

; C: channel-3 effect step handler of ids 03 (table $4306). Named after the caller of its id
; (SFX3_SPACE_FEVER_BOSS_HIT, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Step_03_SpaceFeverBossHit::
    ld hl, wSndSfx3 + $4                          ; $5037
    inc [hl]                                      ; $503A
    ld a, [hl]                                    ; $503B
    cp $20                                        ; $503C
    jp z, Sfx3_Stop                               ; $503E

    cp $10                                        ; $5041
    jr c, jr_01f_504e                             ; $5043

    inc l                                         ; $5045
    dec [hl]                                      ; $5046
    dec [hl]                                      ; $5047
    dec [hl]                                      ; $5048

jr_01f_5049:
    ldh a, [rDIV]                                 ; $5049
    ldh [rNR33], a                                ; $504B
    ret                                           ; $504D


jr_01f_504e:
    inc l                                         ; $504E
    jr jr_01f_5049                                ; $504F

; C: channel-3 effect init handler of ids 03 (table $42F2). Named after the caller of its id
; (SFX3_SPACE_FEVER_BOSS_HIT, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Init_03_SpaceFeverBossHit::
    call Sfx3_Begin_Wave51D5                      ; $5051
    ld a, $f0                                     ; $5054
    ld [wSndSfx3 + $5], a                         ; $5056
    ld hl, Sfx3_Data_5032                         ; $5059
    jp Snd_Sfx_LoadNR3x                           ; $505C


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_505F::
    db $80, $50, $20, $e0, $c7

; C: channel-3 effect step handler of ids 02 (table $4306). Named after the caller of its id
; (SFX3_MAIN_MENU_VIEW_ARCADE, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Step_02_MainMenuViewArcade::
    ld hl, wSndSfx3 + $4                          ; $5064
    inc [hl]                                      ; $5067
    ld a, [hl]                                    ; $5068
    cp $20                                        ; $5069
    jp z, Sfx3_Stop                               ; $506B

    cp $0a                                        ; $506E
    jr c, jr_01f_5085                             ; $5070

    inc l                                         ; $5072
    dec [hl]                                      ; $5073
    dec [hl]                                      ; $5074
    dec [hl]                                      ; $5075
    dec [hl]                                      ; $5076
    dec [hl]                                      ; $5077
    dec [hl]                                      ; $5078

jr_01f_5079:
    ld a, [hl]                                    ; $5079
    and $f8                                       ; $507A
    ld c, a                                       ; $507C
    ldh a, [rDIV]                                 ; $507D
    and $07                                       ; $507F
    or c                                          ; $5081
    ldh [rNR33], a                                ; $5082
    ret                                           ; $5084


jr_01f_5085:
    inc l                                         ; $5085
    jr jr_01f_5079                                ; $5086

; C: channel-3 effect init handler of ids 02 (table $42F2). Named after the caller of its id
; (SFX3_MAIN_MENU_VIEW_ARCADE, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Init_02_MainMenuViewArcade::
    call Sfx3_Begin_Wave5205                      ; $5088
    ld a, $e0                                     ; $508B
    ld [wSndSfx3 + $5], a                         ; $508D
    ld hl, Sfx3_Data_5032                         ; $5090
    jp Snd_Sfx_LoadNR3x                           ; $5093


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_5096::
    db $80, $50, $20, $60, $c6

; C: channel-3 effect step handler of ids 04 (table $4306)
Sfx3_Step_04::
    ld hl, wSndSfx3 + $4                          ; $509B
    inc [hl]                                      ; $509E
    ld a, [hl]                                    ; $509F
    cp $13                                        ; $50A0
    jp z, Sfx3_Stop                               ; $50A2

    cp $04                                        ; $50A5
    jr c, jr_01f_50b2                             ; $50A7

    inc l                                         ; $50A9
    inc [hl]                                      ; $50AA
    inc [hl]                                      ; $50AB
    inc [hl]                                      ; $50AC
    inc [hl]                                      ; $50AD
    ld a, [hl]                                    ; $50AE

; C: shared tail of step 04 of the channel-3 effect: writes A to NR33 and returns (branch target; code read
; 2026-10-19)
Sfx3_Step_04_WriteNR33::
    ldh [rNR33], a                                ; $50AF
    ret                                           ; $50B1


jr_01f_50b2:
    ldh a, [rDIV]                                 ; $50B2
    jr Sfx3_Step_04_WriteNR33                     ; $50B4

; C: channel-3 effect init handler of ids 04 (table $42F2). Owner (review page, 2026-10-13, by ear): sfx3 04: unsure.
Sfx3_Init_04::
    call Sfx3_Begin_Wave51E5                      ; $50B6
    ld a, $60                                     ; $50B9
    ld [wSndSfx3 + $5], a                         ; $50BB
    ld hl, Sfx3_Data_5096                         ; $50BE
    jp Snd_Sfx_LoadNR3x                           ; $50C1


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_50C4::
    db $80, $50, $20, $10, $c4

; C: channel-3 effect step handler of ids 01 (table $4306). Named after the caller of its id (SFX3_MAIN_MENU_SHOOT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx3_Step_01_MainMenuShoot::
    ld hl, wSndSfx3 + $4                          ; $50C9
    inc [hl]                                      ; $50CC
    ld a, [hl]                                    ; $50CD
    cp $16                                        ; $50CE
    jp z, Sfx3_Stop                               ; $50D0

    cp $05                                        ; $50D3
    jr c, jr_01f_50b2                             ; $50D5

    inc l                                         ; $50D7
    inc [hl]                                      ; $50D8
    inc [hl]                                      ; $50D9
    inc [hl]                                      ; $50DA
    inc [hl]                                      ; $50DB
    inc [hl]                                      ; $50DC
    inc [hl]                                      ; $50DD
    ld a, [hl]                                    ; $50DE
    jp Sfx3_Step_04_WriteNR33                     ; $50DF


; C: channel-3 effect init handler of ids 01 (table $42F2). Named after the caller of its id (SFX3_MAIN_MENU_SHOOT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx3_Init_01_MainMenuShoot::
    call Sfx3_Begin_Wave5205                      ; $50E2
    ld a, $10                                     ; $50E5
    ld [wSndSfx3 + $5], a                         ; $50E7
    ld hl, Sfx3_Data_50C4                         ; $50EA
    jp Snd_Sfx_LoadNR3x                           ; $50ED


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_50F0::
    db $80, $50, $20, $40, $c5

; C: channel-3 effect step handler of ids 05 0A (table $4306)
Sfx3_Step_05_0A::
    ld hl, wSndSfx3 + $4                          ; $50F5
    inc [hl]                                      ; $50F8
    ld a, [hl]                                    ; $50F9
    cp $18                                        ; $50FA
    jr z, Sfx3_Stop                               ; $50FC

    cp $04                                        ; $50FE
    jr c, jr_01f_510c                             ; $5100

    inc l                                         ; $5102
    dec [hl]                                      ; $5103
    dec [hl]                                      ; $5104
    dec [hl]                                      ; $5105
    dec [hl]                                      ; $5106
    dec [hl]                                      ; $5107
    dec [hl]                                      ; $5108
    ld a, [hl]                                    ; $5109
    ldh [rNR33], a                                ; $510A

jr_01f_510c:
    ret                                           ; $510C


; C: channel-3 effect init handler of ids 05 0A (table $42F2)
Sfx3_Init_05_0A::
    call Sfx3_Begin_Wave51F5                      ; $510D
    ld a, $80                                     ; $5110
    ld [wSndSfx3 + $5], a                         ; $5112
    ld hl, Sfx3_Data_50F0                         ; $5115
    jp Snd_Sfx_LoadNR3x                           ; $5118


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_511B::
    db $80, $80, $20, $23, $c7

; C: channel-3 effect init handler of ids 06 (table $42F2)
Sfx3_Init_06::
    call Sfx3_Begin_Wave51C5                      ; $5120
    ld a, $23                                     ; $5123
    ld [wSndSfx3 + $6], a                         ; $5125

jr_01f_5128:
    ld hl, Sfx3_Data_511B                         ; $5128
    call Snd_Sfx_LoadNR3x                         ; $512B
    ret                                           ; $512E


jr_01f_512f:
    inc [hl]                                      ; $512F
    jr jr_01f_5128                                ; $5130

; C: channel-3 effect step handler of ids 06 (table $4306)
Sfx3_Step_06::
    ld hl, wSndSfx3 + $4                          ; $5132
    inc [hl]                                      ; $5135
    ld a, [hl+]                                   ; $5136
    cp $0a                                        ; $5137
    jr z, jr_01f_512f                             ; $5139

    cp $22                                        ; $513B
    jr z, jr_01f_5154                             ; $513D

    ld a, [hl+]                                   ; $513F
    and a                                         ; $5140
    jr z, jr_01f_514b                             ; $5141

    dec [hl]                                      ; $5143
    dec [hl]                                      ; $5144
    dec [hl]                                      ; $5145
    dec [hl]                                      ; $5146

jr_01f_5147:
    ld a, [hl]                                    ; $5147
    ldh [rNR33], a                                ; $5148
    ret                                           ; $514A


jr_01f_514b:
    inc [hl]                                      ; $514B
    inc [hl]                                      ; $514C
    inc [hl]                                      ; $514D
    inc [hl]                                      ; $514E
    inc [hl]                                      ; $514F
    inc [hl]                                      ; $5150
    inc [hl]                                      ; $5151
    jr jr_01f_5147                                ; $5152

jr_01f_5154:
    jr Sfx3_Stop                                  ; $5154

; C: channel-3 effect ends: running id 0; NR30=0; busy flag off; reloads the track-3 wave
Sfx3_Stop::
    xor a                                         ; $5156
    ld [wSndSfx3 + $1], a                         ; $5157
    ldh [rNR30], a                                ; $515A
    ld hl, wSndTrack3 + $f                        ; $515C
    res 7, [hl]                                   ; $515F
    ld a, [wSndTrack3 + $6]                       ; $5161
    ld l, a                                       ; $5164
    ld a, [wSndTrack3 + $7]                       ; $5165
    ld h, a                                       ; $5168
    jr jr_01f_5199                                ; $5169

; C: Sfx3_Begin then loads the wave pattern at $51FA into wave RAM
Sfx3_Begin_Wave5205::
    call Sfx3_Begin                               ; $516B
    ld hl, Sfx3_Wave_5205                         ; $516E
    jr jr_01f_5199                                ; $5171

; C: Sfx3_Begin then loads the wave pattern at $51BA into wave RAM
Sfx3_Begin_Wave51C5::
    call Sfx3_Begin                               ; $5173
    ld hl, Sfx3_Wave_51C5                         ; $5176
    jr jr_01f_5199                                ; $5179

; C: Sfx3_Begin then loads the wave pattern at $51CA into wave RAM
Sfx3_Begin_Wave51D5::
    call Sfx3_Begin                               ; $517B
    ld hl, Sfx3_Wave_51D5                         ; $517E
    jr jr_01f_5199                                ; $5181

; C: Sfx3_Begin then loads the wave pattern at $51DA into wave RAM
Sfx3_Begin_Wave51E5::
    call Sfx3_Begin                               ; $5183
    ld hl, Sfx3_Wave_51E5                         ; $5186
    jr jr_01f_5199                                ; $5189

; C: Sfx3_Begin then loads the wave pattern at $51EA into wave RAM
Sfx3_Begin_Wave51F5::
    call Sfx3_Begin                               ; $518B
    ld hl, Sfx3_Wave_51F5                         ; $518E
    jr jr_01f_5199                                ; $5191

; C: Sfx3_Begin then loads the wave pattern at $51AA into wave RAM
Sfx3_Begin_Wave51B5::
    call Sfx3_Begin                               ; $5193
    ld hl, Sfx3_Wave_51B5                         ; $5196

jr_01f_5199:
    jp Snd_LoadWaveRam                            ; $5199


; C: channel-3 SFX start: running id; busy flag on track 3; counters cleared; NR30=0 (DAC off); callers then load a
; wave and register block
Sfx3_Begin::
    ld de, wSndSfx3 + $1                          ; $519C
    ld a, [wSndTmp]                               ; $519F
    ld [de], a                                    ; $51A2
    ld hl, wSndTrack3 + $f                        ; $51A3
    set 7, [hl]                                   ; $51A6
    xor a                                         ; $51A8
    ld [wSndSfx3 + $4], a                         ; $51A9
    ld [wSndSfx3 + $5], a                         ; $51AC
    ld [wSndSfx3 + $6], a                         ; $51AF
    ldh [rNR30], a                                ; $51B2
    ret                                           ; $51B4


; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51B5::
    db $a7, $13, $32, $3f, $ab, $cd, $ef, $a7, $f1, $f1, $f1, $f1, $f1, $f1, $49, $b9

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51C5::
    db $f1, $00, $f1, $f1, $f1, $f1, $f1, $f1, $77, $77, $77, $77, $71, $00, $a0, $00

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51D5::
    db $12, $13, $32, $3f, $89, $cd, $78, $97, $71, $61, $61, $61, $61, $61, $49, $b9

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51E5::
    db $00, $00, $98, $76, $54, $32, $10, $91, $f8, $76, $04, $32, $12, $38, $e9, $19

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51F5::
    db $34, $34, $00, $23, $23, $34, $34, $30, $00, $00, $00, $00, $00, $00, $e9, $00

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_5205::
    db $12, $34, $56, $f0, $77, $00, $77, $00, $77, $00, $77, $00, $76, $54, $32, $11

; C: starts an SFX: stores the running id ($DD51); counters = 0; sets the busy flag of the channel; loads the register
; block at HL
Snd_Sfx_Start::
    push af                                       ; $5215
    dec e                                         ; $5216
    ld a, [wSndTmp]                               ; $5217
    ld [de], a                                    ; $521A
    inc e                                         ; $521B
    pop af                                        ; $521C
    inc e                                         ; $521D
    ld [de], a                                    ; $521E
    dec e                                         ; $521F
    xor a                                         ; $5220
    ld [de], a                                    ; $5221
    inc e                                         ; $5222
    inc e                                         ; $5223
    ld [de], a                                    ; $5224
    inc e                                         ; $5225
    ld [de], a                                    ; $5226
    push hl                                       ; $5227
    ld a, e                                       ; $5228
    cp $65                                        ; $5229
    jr z, jr_01f_5237                             ; $522B

    cp $75                                        ; $522D
    jr z, jr_01f_523f                             ; $522F

    cp $7d                                        ; $5231
    jr z, jr_01f_5247                             ; $5233

    pop hl                                        ; $5235
    ret                                           ; $5236


jr_01f_5237:
    ld hl, wSndTrack1 + $f                        ; $5237
    set 7, [hl]                                   ; $523A
    pop hl                                        ; $523C
    jr Snd_Sfx_LoadNR1x                           ; $523D

jr_01f_523f:
    ld hl, wSndTrack3 + $f                        ; $523F
    set 7, [hl]                                   ; $5242
    pop hl                                        ; $5244
    jr Snd_Sfx_LoadNR3x                           ; $5245

jr_01f_5247:
    ld hl, wSndTrack4 + $f                        ; $5247
    set 7, [hl]                                   ; $524A
    pop hl                                        ; $524C
    jr Snd_Sfx_LoadNR4x                           ; $524D

; C: copies 5 bytes from HL to NR10-NR14
Snd_Sfx_LoadNR1x::
    push bc                                       ; $524F
    ld c, $10                                     ; $5250
    ld b, $05                                     ; $5252
    jr Snd_Sfx_LoadRegs                           ; $5254

; C: copies 4 bytes from HL to NR21-NR24 (no caller: channel 2 has no SFX)
Unused_Snd_Sfx_LoadNR2x::
    push bc                                       ; $5256
    ld c, $16                                     ; $5257
    ld b, $04                                     ; $5259
    jr Snd_Sfx_LoadRegs                           ; $525B

; C: copies 5 bytes from HL to NR30-NR34
Snd_Sfx_LoadNR3x::
    push bc                                       ; $525D
    ld c, $1a                                     ; $525E
    ld b, $05                                     ; $5260
    jr Snd_Sfx_LoadRegs                           ; $5262

; C: copies 4 bytes from HL to NR41-NR44
Snd_Sfx_LoadNR4x::
    push bc                                       ; $5264
    ld c, $20                                     ; $5265
    ld b, $04                                     ; $5267

; C: loop: B bytes from [HL+] to $FF00+C; C++
Snd_Sfx_LoadRegs::
    ld a, [hl+]                                   ; $5269
    ldh [c], a                                    ; $526A
    inc c                                         ; $526B
    dec b                                         ; $526C
    jr nz, Snd_Sfx_LoadRegs                       ; $526D

    pop bc                                        ; $526F
    ret                                           ; $5270


; C: parks the request id in $DD51 and falls through into Snd_Sfx_Lookup
Snd_Sfx_InitLookup::
    inc e                                         ; $5271
    ld [wSndTmp], a                               ; $5272

; C: HL = table + 2 * (A - 1) -> handler address in HL
Snd_Sfx_Lookup::
    inc e                                         ; $5275
    dec a                                         ; $5276
    sla a                                         ; $5277
    ld c, a                                       ; $5279
    ld b, $00                                     ; $527A
    add hl, bc                                    ; $527C
    ld c, [hl]                                    ; $527D
    inc hl                                        ; $527E
    ld b, [hl]                                    ; $527F
    ld l, c                                       ; $5280
    ld h, b                                       ; $5281
    ld a, h                                       ; $5282
    ret                                           ; $5283


; C: increments the frame counter at [DE]; Z (A=0) when it reaches the limit at [DE+1] and is reset; called by 47 step
; handlers
Snd_Sfx_TickCounter::
    push de                                       ; $5284
    ld l, e                                       ; $5285
    ld h, d                                       ; $5286
    inc [hl]                                      ; $5287
    ld a, [hl+]                                   ; $5288
    cp [hl]                                       ; $5289
    jr nz, jr_01f_528f                            ; $528A

    dec l                                         ; $528C
    xor a                                         ; $528D
    ld [hl], a                                    ; $528E

jr_01f_528f:
    pop de                                        ; $528F
    ret                                           ; $5290


; C: copies 16 bytes from HL to the wave RAM $FF30-$FF3F
Snd_LoadWaveRam::
    push bc                                       ; $5291
    ld c, $30                                     ; $5292

jr_01f_5294:
    ld a, [hl+]                                   ; $5294
    ldh [c], a                                    ; $5295
    inc c                                         ; $5296
    ld a, c                                       ; $5297
    cp $40                                        ; $5298
    jr nz, jr_01f_5294                            ; $529A

    pop bc                                        ; $529C
    ret                                           ; $529D


; C: NR51=$FF; song id and sequence variables cleared; no song plays afterwards
Snd_StopSong::
    ld a, $ff                                     ; $529E
    ldh [rNR51], a                                ; $52A0
    ld a, $01                                     ; $52A2
    ld [wSndU55], a                               ; $52A4
    xor a                                         ; $52A7
    ld [wSndSong], a                              ; $52A8
    ld [wSndU0e], a                               ; $52AB
    ld [wSndU09], a                               ; $52AE
    ld [wSndU09 + $1], a                          ; $52B1
    ld [wSndSeqIdx], a                            ; $52B4

; C: clears the SFX running ids and the track busy flags; NR12/22/42=$08; NR14/24/44=$80; NR10/NR30=0
Snd_SilenceChannels::
    xor a                                         ; $52B7
    ld [wSndSfx1 + $1], a                         ; $52B8
    ld [wSndSfx3 + $1], a                         ; $52BB
    ld [wSndSfx4 + $1], a                         ; $52BE
    ld [wSndTrack1 + $f], a                       ; $52C1
    ld [wSndTrack2 + $f], a                       ; $52C4
    ld [wSndTrack3 + $f], a                       ; $52C7
    ld [wSndTrack4 + $f], a                       ; $52CA
    ld a, $08                                     ; $52CD
    ldh [rNR12], a                                ; $52CF
    ldh [rNR22], a                                ; $52D1
    ldh [rNR42], a                                ; $52D3
    ld a, $80                                     ; $52D5
    ldh [rNR14], a                                ; $52D7
    ldh [rNR24], a                                ; $52D9
    ldh [rNR44], a                                ; $52DB
    xor a                                         ; $52DD
    ldh [rNR10], a                                ; $52DE
    ldh [rNR30], a                                ; $52E0
    ret                                           ; $52E2


; C: channel-3 SFX: request $DD70 -> init (table $42F2; ids 1..10); running id $DD71 -> step (table $4306)
Snd_RunSfx3::
    ld de, wSndSfx3                               ; $52E3
    ld a, [de]                                    ; $52E6
    and a                                         ; $52E7
    jr z, jr_01f_52f5                             ; $52E8

    cp $0b                                        ; $52EA
    jr nc, jr_01f_52f5                            ; $52EC

    ld hl, Sfx3_InitTbl                           ; $52EE
    call Snd_Sfx_InitLookup                       ; $52F1
    jp hl                                         ; $52F4


jr_01f_52f5:
    inc e                                         ; $52F5
    ld a, [de]                                    ; $52F6
    and a                                         ; $52F7
    ret z                                         ; $52F8

    cp $0b                                        ; $52F9
    ret nc                                        ; $52FB

    ld hl, Sfx3_StepTbl                           ; $52FC
    call Snd_Sfx_Lookup                           ; $52FF
    jp hl                                         ; $5302


; C: channel-1 SFX: request $DD60 -> init handler (table $41FA; ids 1..$3E); running id $DD61 -> step handler (table
; $4276)
Snd_RunSfx1::
    ld de, wSndSfx1                               ; $5303
    ld a, [de]                                    ; $5306
    and a                                         ; $5307
    jr z, jr_01f_5315                             ; $5308

    cp $3f                                        ; $530A
    jr nc, jr_01f_5315                            ; $530C

    ld hl, Sfx1_InitTbl                           ; $530E
    call Snd_Sfx_InitLookup                       ; $5311
    jp hl                                         ; $5314


jr_01f_5315:
    inc e                                         ; $5315
    ld a, [de]                                    ; $5316
    and a                                         ; $5317
    ret z                                         ; $5318

    cp $3f                                        ; $5319
    ret nc                                        ; $531B

    ld hl, Sfx1_StepTbl                           ; $531C
    call Snd_Sfx_Lookup                           ; $531F
    jp hl                                         ; $5322


; C: channel-4 (noise) SFX: request $DD78 -> init (table $431A; ids 1..18); running id $DD79 -> step (table $433E)
Snd_RunSfx4::
    ld de, wSndSfx4                               ; $5323
    ld a, [de]                                    ; $5326
    and a                                         ; $5327
    jr z, jr_01f_5335                             ; $5328

    cp $13                                        ; $532A
    jr nc, jr_01f_5335                            ; $532C

    ld hl, Sfx4_InitTbl                           ; $532E
    call Snd_Sfx_InitLookup                       ; $5331
    jp hl                                         ; $5334


jr_01f_5335:
    inc e                                         ; $5335
    ld a, [de]                                    ; $5336
    and a                                         ; $5337
    ret z                                         ; $5338

    cp $13                                        ; $5339
    ret nc                                        ; $533B

    ld hl, Sfx4_StepTbl                           ; $533C
    call Snd_Sfx_Lookup                           ; $533F
    jp hl                                         ; $5342


; C: APU on (NR52=$80; NR50=$77; NR51=$FF) then clears $DD00-$DEFF
Snd_Init::
    ld a, $80                                     ; $5343
    ldh [rNR52], a                                ; $5345
    ld a, $77                                     ; $5347
    ldh [rNR50], a                                ; $5349
    ld a, $ff                                     ; $534B
    ldh [rNR51], a                                ; $534D
    ld hl, wSndUnused00                           ; $534F

jr_01f_5352:
    ld [hl], $00                                  ; $5352
    inc l                                         ; $5354
    jr nz, jr_01f_5352                            ; $5355

    inc h                                         ; $5357
    ld a, h                                       ; $5358
    cp $df                                        ; $5359
    jr nz, jr_01f_5352                            ; $535B

    ret                                           ; $535D


; C: jp Snd_StopSong (target of the $FF "reset" request)
Snd_StopSong_Tail::
    jp Snd_StopSong                               ; $535E


; C: $FF = stop; 1..$48 = start the song (header via the table at $57C6); other values ignored
Snd_RequestSong::
    cp $ff                                        ; $5361
    jr z, Snd_StopSong_Tail                       ; $5363

    cp $49                                        ; $5365
    ret nc                                        ; $5367

    ld [hl], a                                    ; $5368
    ld b, a                                       ; $5369
    ld hl, Snd_SongTbl                            ; $536A
    and $7f                                       ; $536D
    call Snd_Sfx_Lookup                           ; $536F
    call Snd_SongInit                             ; $5372
    jp Snd_PanReset                               ; $5375


; C: request $FE: only the channel-1 SFX runs; the music tick is skipped
Snd_Tick_MusicHold::
    call Snd_RunSfx1                              ; $5378
    xor a                                         ; $537B
    ld [wSndSfx1], a                              ; $537C
    xor a                                         ; $537F
    ld [wSndU5e], a                               ; $5380
    pop hl                                        ; $5383
    pop de                                        ; $5384
    pop bc                                        ; $5385
    pop af                                        ; $5386
    ret                                           ; $5387


; C: per-frame sound handler: music request ($DD68); the three SFX channels; then the music tick
Snd_Tick::
    push af                                       ; $5388
    push bc                                       ; $5389
    push de                                       ; $538A
    push hl                                       ; $538B
    ld hl, wSndMusicReq                           ; $538C
    ld a, [hl+]                                   ; $538F
    and a                                         ; $5390
    jr nz, Snd_Tick_MusicRequest                  ; $5391

    call Snd_RunSfx1                              ; $5393
    call Snd_RunSfx3                              ; $5396
    call Snd_RunSfx4                              ; $5399

; C: runs the music tick; then clears the four request mailboxes
Snd_Tick_RunMusic::
    call Snd_MusicTick                            ; $539C
    xor a                                         ; $539F
    ld [wSndSfx1], a                              ; $53A0
    ld [wSndMusicReq], a                          ; $53A3
    ld [wSndSfx3], a                              ; $53A6
    ld [wSndSfx4], a                              ; $53A9
    pop hl                                        ; $53AC
    pop de                                        ; $53AD
    pop bc                                        ; $53AE
    pop af                                        ; $53AF
    ret                                           ; $53B0


; C: music request in $DD68: $FE hold; else Snd_RequestSong
Snd_Tick_MusicRequest::
    cp $fe                                        ; $53B1
    jr z, Snd_Tick_MusicHold                      ; $53B3

    call Snd_RequestSong                          ; $53B5
    jr Snd_Tick_RunMusic                          ; $53B8

; C: NR51=$FF; $DD55=1 (end of Snd_RequestSong)
Snd_PanReset::
    ld a, $ff                                     ; $53BA
    ldh [rNR51], a                                ; $53BC
    ld a, $01                                     ; $53BE
    ld [wSndU55], a                               ; $53C0
    ret                                           ; $53C3


; I: loads a 6-byte record at $5856 + 6 * (song - 1) into $DD55..; no caller (UNREFERENCED; README 16.21)
Unused_Snd_SongPan_Load::
    ld a, [wSndSong]                              ; $53C4
    ld hl, Song10_Hdr                             ; $53C7

jr_01f_53ca:
    dec a                                         ; $53CA
    jr z, jr_01f_53d5                             ; $53CB

    inc hl                                        ; $53CD
    inc hl                                        ; $53CE
    inc hl                                        ; $53CF
    inc hl                                        ; $53D0
    inc hl                                        ; $53D1
    inc hl                                        ; $53D2
    jr jr_01f_53ca                                ; $53D3

jr_01f_53d5:
    ld bc, wSndU55                                ; $53D5
    ld a, [hl+]                                   ; $53D8
    ld [bc], a                                    ; $53D9
    inc c                                         ; $53DA
    xor a                                         ; $53DB
    ld [bc], a                                    ; $53DC
    inc c                                         ; $53DD
    ld a, [hl+]                                   ; $53DE
    ld [bc], a                                    ; $53DF
    inc c                                         ; $53E0
    xor a                                         ; $53E1
    ld [bc], a                                    ; $53E2
    inc c                                         ; $53E3
    ld a, [hl+]                                   ; $53E4
    ld [bc], a                                    ; $53E5
    ldh [rNR51], a                                ; $53E6
    inc c                                         ; $53E8
    ld a, [hl+]                                   ; $53E9
    ld [bc], a                                    ; $53EA
    inc c                                         ; $53EB
    ld a, [hl+]                                   ; $53EC
    ld [bc], a                                    ; $53ED
    inc c                                         ; $53EE
    ld a, [hl+]                                   ; $53EF
    ld [bc], a                                    ; $53F0
    ret                                           ; $53F1


; I: steps a panning sequence (NR51) from the $DD55 record; no caller (UNREFERENCED)
Unused_Snd_Pan_Step::
    ld hl, wSndU55                                ; $53F2
    ld a, [hl+]                                   ; $53F5
    cp $01                                        ; $53F6
    ret z                                         ; $53F8

    inc [hl]                                      ; $53F9
    ld a, [hl+]                                   ; $53FA
    cp [hl]                                       ; $53FB
    ret nz                                        ; $53FC

    dec l                                         ; $53FD
    ld [hl], $00                                  ; $53FE
    inc l                                         ; $5400
    inc l                                         ; $5401
    inc [hl]                                      ; $5402
    ld a, [hl+]                                   ; $5403
    and $03                                       ; $5404
    ld c, l                                       ; $5406
    ld b, h                                       ; $5407
    and a                                         ; $5408
    jr z, jr_01f_5416                             ; $5409

    inc c                                         ; $540B
    cp $01                                        ; $540C
    jr z, jr_01f_5416                             ; $540E

    inc c                                         ; $5410
    cp $02                                        ; $5411
    jr z, jr_01f_5416                             ; $5413

    inc c                                         ; $5415

jr_01f_5416:
    ld a, [bc]                                    ; $5416
    ldh [rNR51], a                                ; $5417
    ret                                           ; $5419


; C: DE = [[HL]] .. [[HL]+1]: copies the 2-byte pattern pointer found at the list cursor
Snd_Trk_LoadFirstPattern::
    ld a, [hl+]                                   ; $541A
    ld c, a                                       ; $541B
    ld a, [hl]                                    ; $541C
    ld b, a                                       ; $541D
    ld a, [bc]                                    ; $541E
    ld [de], a                                    ; $541F
    inc e                                         ; $5420
    inc bc                                        ; $5421
    ld a, [bc]                                    ; $5422
    ld [de], a                                    ; $5423
    ret                                           ; $5424


; C: copies two bytes [HL+] -> [DE]; [DE+1]
Snd_Copy2::
    ld a, [hl+]                                   ; $5425
    ld [de], a                                    ; $5426
    inc e                                         ; $5427
    ld a, [hl+]                                   ; $5428
    ld [de], a                                    ; $5429
    ret                                           ; $542A


; C: copies the 11-byte song header: transposition; duration-table pointer; four track list pointers; first pattern
; pointers; counters = 1
Snd_SongInit::
    call Snd_SilenceChannels                      ; $542B
    ld de, wSndTranspose                          ; $542E
    ld b, $00                                     ; $5431
    ld a, [hl+]                                   ; $5433
    ld [de], a                                    ; $5434
    inc e                                         ; $5435
    call Snd_Copy2                                ; $5436
    ld de, wSndTrack1                             ; $5439
    call Snd_Copy2                                ; $543C
    ld de, wSndTrack2                             ; $543F
    call Snd_Copy2                                ; $5442
    ld de, wSndTrack3                             ; $5445
    call Snd_Copy2                                ; $5448
    ld de, wSndTrack4                             ; $544B
    call Snd_Copy2                                ; $544E
    ld hl, wSndTrack1                             ; $5451
    ld de, wSndTrack1 + $4                        ; $5454
    call Snd_Trk_LoadFirstPattern                 ; $5457
    ld hl, wSndTrack2                             ; $545A
    ld de, wSndTrack2 + $4                        ; $545D
    call Snd_Trk_LoadFirstPattern                 ; $5460
    ld hl, wSndTrack3                             ; $5463
    ld de, wSndTrack3 + $4                        ; $5466
    call Snd_Trk_LoadFirstPattern                 ; $5469
    ld hl, wSndTrack4                             ; $546C
    ld de, wSndTrack4 + $4                        ; $546F
    call Snd_Trk_LoadFirstPattern                 ; $5472
    ld bc, $0410                                  ; $5475
    ld hl, wSndTrack1 + $2                        ; $5478

jr_01f_547b:
    ld [hl], $01                                  ; $547B
    ld a, c                                       ; $547D
    add l                                         ; $547E
    ld l, a                                       ; $547F
    dec b                                         ; $5480
    jr nz, jr_01f_547b                            ; $5481

    xor a                                         ; $5483
    ld [wSndTrack1 + $e], a                       ; $5484
    ld [wSndTrack2 + $e], a                       ; $5487
    ld [wSndTrack3 + $e], a                       ; $548A
    ret                                           ; $548D


; C: track 3: DAC off and wave RAM reload from the instrument table
Snd_Op9D_LoadWaveTrk3::
    push hl                                       ; $548E
    xor a                                         ; $548F
    ldh [rNR30], a                                ; $5490
    ld l, e                                       ; $5492
    ld h, d                                       ; $5493
    call Snd_LoadWaveRam                          ; $5494
    pop hl                                        ; $5497
    jr jr_01f_54ca                                ; $5498

; C: $9D e d c: three operands stored in the track block (duty/envelope/wave); wave RAM reload on track 3
Snd_Op9D_SetInstrument::
    call Snd_Trk_PtrInc                           ; $549A
    call Snd_Trk_FetchByte                        ; $549D
    ld e, a                                       ; $54A0
    call Snd_Trk_PtrInc                           ; $54A1
    call Snd_Trk_FetchByte                        ; $54A4
    ld d, a                                       ; $54A7
    call Snd_Trk_PtrInc                           ; $54A8
    call Snd_Trk_FetchByte                        ; $54AB
    ld c, a                                       ; $54AE
    ld a, [wSndFreeze]                            ; $54AF
    and a                                         ; $54B2
    jr nz, jr_01f_54c0                            ; $54B3

    inc l                                         ; $54B5
    inc l                                         ; $54B6
    ld [hl], e                                    ; $54B7
    inc l                                         ; $54B8
    ld [hl], d                                    ; $54B9
    inc l                                         ; $54BA
    ld [hl], c                                    ; $54BB
    dec l                                         ; $54BC
    dec l                                         ; $54BD
    dec l                                         ; $54BE
    dec l                                         ; $54BF

jr_01f_54c0:
    push hl                                       ; $54C0
    ld hl, wSndCurTrack                           ; $54C1
    ld a, [hl]                                    ; $54C4
    pop hl                                        ; $54C5
    cp $03                                        ; $54C6
    jr z, Snd_Op9D_LoadWaveTrk3                   ; $54C8

jr_01f_54ca:
    call Snd_Trk_PtrInc                           ; $54CA
    jp Snd_Trk_FetchOp                            ; $54CD


; C: pattern cursor (HL) += 1
Snd_Trk_PtrInc::
    push de                                       ; $54D0
    ld a, [hl+]                                   ; $54D1
    ld e, a                                       ; $54D2
    ld a, [hl-]                                   ; $54D3
    ld d, a                                       ; $54D4
    inc de                                        ; $54D5

jr_01f_54d6:
    ld a, e                                       ; $54D6
    ld [hl+], a                                   ; $54D7
    ld a, d                                       ; $54D8
    ld [hl-], a                                   ; $54D9
    pop de                                        ; $54DA
    ret                                           ; $54DB


; C: list cursor (HL) += 2
Snd_Trk_PtrInc2::
    push de                                       ; $54DC
    ld a, [hl+]                                   ; $54DD
    ld e, a                                       ; $54DE
    ld a, [hl-]                                   ; $54DF
    ld d, a                                       ; $54E0
    inc de                                        ; $54E1
    inc de                                        ; $54E2
    jr jr_01f_54d6                                ; $54E3

; C: A = B = [[HL]] (byte at the cursor)
Snd_Trk_FetchByte::
    ld a, [hl+]                                   ; $54E5
    ld c, a                                       ; $54E6
    ld a, [hl-]                                   ; $54E7
    ld b, a                                       ; $54E8
    ld a, [bc]                                    ; $54E9
    ld b, a                                       ; $54EA
    ret                                           ; $54EB


jr_01f_54ec:
    pop hl                                        ; $54EC
    jr Snd_Trk_Skip                               ; $54ED

; C: note still running: track 3 volume fix; vibrato call; SFX-busy check
Snd_Trk_Sustain::
    ld a, [wSndCurTrack]                          ; $54EF
    cp $03                                        ; $54F2
    jr nz, jr_01f_5506                            ; $54F4

    ld a, [wSndTrack3 + $8]                       ; $54F6
    bit 7, a                                      ; $54F9
    jr z, jr_01f_5506                             ; $54FB

    ld a, [hl]                                    ; $54FD
    cp $06                                        ; $54FE
    jr nz, jr_01f_5506                            ; $5500

    ld a, $40                                     ; $5502
    ldh [rNR32], a                                ; $5504

jr_01f_5506:
    push hl                                       ; $5506
    ld a, l                                       ; $5507
    add $09                                       ; $5508
    ld l, a                                       ; $550A
    ld a, [hl]                                    ; $550B
    and a                                         ; $550C
    jr nz, jr_01f_54ec                            ; $550D

    ld a, l                                       ; $550F
    add $04                                       ; $5510
    ld l, a                                       ; $5512
    bit 7, [hl]                                   ; $5513
    jr nz, jr_01f_54ec                            ; $5515

    pop hl                                        ; $5517
    call Snd_Trk_Vibrato                          ; $5518

; C: track idle: step back to the track base and go to Snd_Trk_Next
Snd_Trk_Skip::
    dec l                                         ; $551B
    dec l                                         ; $551C
    jp Snd_Trk_Next                               ; $551D


; C: list cursor += 2; loads the next pattern; word hi $00 ends the whole song; hi $FF loops to the next word
Snd_Op00_EndPattern::
    dec l                                         ; $5520
    dec l                                         ; $5521
    dec l                                         ; $5522
    dec l                                         ; $5523
    call Snd_Trk_PtrInc2                          ; $5524

jr_01f_5527:
    ld a, l                                       ; $5527
    add $04                                       ; $5528
    ld e, a                                       ; $552A
    ld d, h                                       ; $552B
    call Snd_Trk_LoadFirstPattern                 ; $552C
    cp $00                                        ; $552F
    jr z, Snd_Song_End                            ; $5531

    cp $ff                                        ; $5533
    jr z, Snd_Op00_LoopList                       ; $5535

    inc l                                         ; $5537
    jp Snd_Trk_NextOp                             ; $5538


; C: loop marker: jump back to the address stored after $FFxx
Snd_Op00_LoopList::
    dec l                                         ; $553B
    push hl                                       ; $553C
    call Snd_Trk_PtrInc2                          ; $553D
    call Snd_Trk_FetchByte                        ; $5540
    ld e, a                                       ; $5543
    call Snd_Trk_PtrInc                           ; $5544
    call Snd_Trk_FetchByte                        ; $5547
    ld d, a                                       ; $554A
    pop hl                                        ; $554B
    ld a, e                                       ; $554C
    ld [hl+], a                                   ; $554D
    ld a, d                                       ; $554E
    ld [hl-], a                                   ; $554F
    jr jr_01f_5527                                ; $5550

; C: song finished: $DD69=0 then Snd_StopSong
Snd_Song_End::
    ld hl, wSndSong                               ; $5552
    ld [hl], $00                                  ; $5555
    call Snd_StopSong                             ; $5557
    ret                                           ; $555A


; C: $9E lo hi: duration table pointer -> $DD02/$DD03
Snd_Op9E_SetDurTable::
    call Snd_Trk_PtrInc                           ; $555B
    call Snd_Trk_FetchByte                        ; $555E
    ld [wSndDurTabLo], a                          ; $5561
    call Snd_Trk_PtrInc                           ; $5564
    call Snd_Trk_FetchByte                        ; $5567
    ld [wSndDurTabHi], a                          ; $556A
    jr jr_01f_5578                                ; $556D

; C: $9F n: transposition -> $DD01
Snd_Op9F_SetTranspose::
    call Snd_Trk_PtrInc                           ; $556F
    call Snd_Trk_FetchByte                        ; $5572
    ld [wSndTranspose], a                         ; $5575

jr_01f_5578:
    call Snd_Trk_PtrInc                           ; $5578
    jr Snd_Trk_FetchOp                            ; $557B

; C: $9B n: repeat count n; saves the pattern cursor for the matching $9C
Snd_Op9B_RepeatBegin::
    call Snd_Trk_PtrInc                           ; $557D
    call Snd_Trk_FetchByte                        ; $5580
    push hl                                       ; $5583
    ld a, l                                       ; $5584
    add $0b                                       ; $5585
    ld l, a                                       ; $5587
    ld c, [hl]                                    ; $5588
    ld a, b                                       ; $5589
    or c                                          ; $558A
    ld [hl], a                                    ; $558B
    ld b, h                                       ; $558C
    ld c, l                                       ; $558D
    dec c                                         ; $558E
    dec c                                         ; $558F
    pop hl                                        ; $5590
    ld a, [hl+]                                   ; $5591
    ld e, a                                       ; $5592
    ld a, [hl-]                                   ; $5593
    ld d, a                                       ; $5594
    inc de                                        ; $5595
    ld a, e                                       ; $5596
    ld [hl+], a                                   ; $5597
    ld a, d                                       ; $5598
    ld [hl-], a                                   ; $5599
    ld a, d                                       ; $559A
    ld [bc], a                                    ; $559B
    dec c                                         ; $559C
    ld a, e                                       ; $559D
    ld [bc], a                                    ; $559E
    jr Snd_Trk_FetchOp                            ; $559F

; C: $9C: count -1; jumps back to the saved cursor until the count is 0
Snd_Op9C_RepeatEnd::
    push hl                                       ; $55A1
    ld a, l                                       ; $55A2
    add $0b                                       ; $55A3
    ld l, a                                       ; $55A5
    ld a, [hl]                                    ; $55A6
    dec [hl]                                      ; $55A7
    ld a, [hl]                                    ; $55A8
    and $7f                                       ; $55A9
    jr z, jr_01f_55ba                             ; $55AB

    ld b, h                                       ; $55AD
    ld c, l                                       ; $55AE
    dec c                                         ; $55AF
    dec c                                         ; $55B0
    dec c                                         ; $55B1
    pop hl                                        ; $55B2
    ld a, [bc]                                    ; $55B3
    ld [hl+], a                                   ; $55B4
    inc c                                         ; $55B5
    ld a, [bc]                                    ; $55B6
    ld [hl-], a                                   ; $55B7
    jr Snd_Trk_FetchOp                            ; $55B8

jr_01f_55ba:
    pop hl                                        ; $55BA
    jr jr_01f_5578                                ; $55BB

; C: per-frame music tick: for track 1..4 count down the note; fetch ops until a note
Snd_MusicTick::
    ld hl, wSndSong                               ; $55BD
    ld a, [hl]                                    ; $55C0
    and a                                         ; $55C1
    ret z                                         ; $55C2

    ld a, $01                                     ; $55C3
    ld [wSndCurTrack], a                          ; $55C5
    ld hl, wSndTrack1                             ; $55C8

; C: head of the per-track loop
Snd_Trk_Loop::
    inc l                                         ; $55CB
    ld a, [hl+]                                   ; $55CC
    and a                                         ; $55CD
    jp z, Snd_Trk_Skip                            ; $55CE

    dec [hl]                                      ; $55D1
    jp nz, Snd_Trk_Sustain                        ; $55D2

; C: skips the counter bytes and fetches the next op
Snd_Trk_NextOp::
    inc l                                         ; $55D5
    inc l                                         ; $55D6

; C: op dispatch: $00 end of pattern; $9B/$9C repeat; $9D instrument; $9E duration table; $9F transpose; $A0-$AF
; duration + note; else note
Snd_Trk_FetchOp::
    call Snd_Trk_FetchByte                        ; $55D7
    cp $00                                        ; $55DA
    jp z, Snd_Op00_EndPattern                     ; $55DC

    cp $9d                                        ; $55DF
    jp z, Snd_Op9D_SetInstrument                  ; $55E1

    cp $9e                                        ; $55E4
    jp z, Snd_Op9E_SetDurTable                    ; $55E6

    cp $9f                                        ; $55E9
    jp z, Snd_Op9F_SetTranspose                   ; $55EB

    cp $9b                                        ; $55EE
    jp z, Snd_Op9B_RepeatBegin                    ; $55F0

    cp $9c                                        ; $55F3
    jp z, Snd_Op9C_RepeatEnd                      ; $55F5

    and $f0                                       ; $55F8
    cp $a0                                        ; $55FA
    jr nz, Snd_Trk_NoteOn                         ; $55FC

    ld a, b                                       ; $55FE
    and $0f                                       ; $55FF
    ld c, a                                       ; $5601
    ld b, $00                                     ; $5602
    push hl                                       ; $5604
    ld de, wSndDurTabLo                           ; $5605
    ld a, [de]                                    ; $5608
    ld l, a                                       ; $5609
    inc e                                         ; $560A
    ld a, [de]                                    ; $560B
    ld h, a                                       ; $560C
    add hl, bc                                    ; $560D
    ld a, [hl]                                    ; $560E
    pop hl                                        ; $560F
    dec l                                         ; $5610
    ld [hl+], a                                   ; $5611
    call Snd_Trk_PtrInc                           ; $5612
    call Snd_Trk_FetchByte                        ; $5615

; C: note byte in B: frequency lookup (table $4039; transposed); track 4 uses the noise instrument table
Snd_Trk_NoteOn::
    ld c, b                                       ; $5618
    ld b, $00                                     ; $5619
    call Snd_Trk_PtrInc                           ; $561B
    ld a, [wSndCurTrack]                          ; $561E
    cp $04                                        ; $5621
    jp z, Snd_Trk4_NoteOn                         ; $5623

    push hl                                       ; $5626
    ld a, l                                       ; $5627
    add $05                                       ; $5628
    ld l, a                                       ; $562A
    ld e, l                                       ; $562B
    ld d, h                                       ; $562C
    inc l                                         ; $562D
    inc l                                         ; $562E
    ld a, c                                       ; $562F
    cp $01                                        ; $5630
    jr z, jr_01f_5655                             ; $5632

    ld [hl], $00                                  ; $5634
    ld a, [wSndTranspose]                         ; $5636
    and a                                         ; $5639
    jr z, jr_01f_5648                             ; $563A

    ld l, a                                       ; $563C
    ld h, $00                                     ; $563D
    bit 7, l                                      ; $563F
    jr z, jr_01f_5645                             ; $5641

    ld h, $ff                                     ; $5643

jr_01f_5645:
    add hl, bc                                    ; $5645
    ld b, h                                       ; $5646
    ld c, l                                       ; $5647

jr_01f_5648:
    ld hl, Snd_LengthTbl + $12                    ; $5648
    add hl, bc                                    ; $564B
    ld a, [hl+]                                   ; $564C
    ld [de], a                                    ; $564D
    inc e                                         ; $564E
    ld a, [hl]                                    ; $564F
    ld [de], a                                    ; $5650
    pop hl                                        ; $5651
    jp Snd_Trk_WriteHw                            ; $5652


jr_01f_5655:
    ld [hl], $01                                  ; $5655
    pop hl                                        ; $5657
    jr Snd_Trk_WriteHw                            ; $5658

; C: noise track: copies the 5-byte instrument record at $40C9 + note to $DD46
Snd_Trk4_NoteOn::
    push hl                                       ; $565A
    ld de, wSndTrack4 + $6                        ; $565B
    ld hl, Snd_Trk4_InstrTbl                      ; $565E
    add hl, bc                                    ; $5661

jr_01f_5662:
    ld a, [hl+]                                   ; $5662
    ld [de], a                                    ; $5663
    inc e                                         ; $5664
    ld a, e                                       ; $5665
    cp $4b                                        ; $5666
    jr nz, jr_01f_5662                            ; $5668

    ld c, $20                                     ; $566A
    ld hl, wSndTrack4 + $4                        ; $566C
    ld b, $00                                     ; $566F
    jr jr_01f_56b7                                ; $5671

; C: writes the frequency / envelope registers of the current track unless an SFX owns the channel
Snd_Trk_WriteHw::
    push hl                                       ; $5673
    ld b, $00                                     ; $5674
    ld a, [wSndCurTrack]                          ; $5676
    cp $01                                        ; $5679
    jr z, jr_01f_569e                             ; $567B

    cp $02                                        ; $567D
    jr z, jr_01f_569a                             ; $567F

    ld c, $1a                                     ; $5681
    ld a, [wSndTrack3 + $f]                       ; $5683
    bit 7, a                                      ; $5686
    jr nz, jr_01f_568f                            ; $5688

    xor a                                         ; $568A
    ldh [c], a                                    ; $568B
    ld a, $80                                     ; $568C
    ldh [c], a                                    ; $568E

jr_01f_568f:
    inc c                                         ; $568F
    inc l                                         ; $5690
    inc l                                         ; $5691
    inc l                                         ; $5692
    inc l                                         ; $5693
    ld a, [hl+]                                   ; $5694
    ld e, a                                       ; $5695
    ld d, $00                                     ; $5696
    jr jr_01f_56c3                                ; $5698

jr_01f_569a:
    ld c, $16                                     ; $569A
    jr jr_01f_56b7                                ; $569C

jr_01f_569e:
    ld c, $10                                     ; $569E
    ld a, [wSndSong]                              ; $56A0
    cp $01                                        ; $56A3
    jr z, jr_01f_56ad                             ; $56A5

    cp $1e                                        ; $56A7
    jr z, jr_01f_56ad                             ; $56A9

    jr jr_01f_56b4                                ; $56AB

jr_01f_56ad:
    ld b, $33                                     ; $56AD
    ld a, $1d                                     ; $56AF
    ldh [c], a                                    ; $56B1
    jr jr_01f_56b6                                ; $56B2

jr_01f_56b4:
    ld a, $00                                     ; $56B4

jr_01f_56b6:
    inc c                                         ; $56B6

jr_01f_56b7:
    inc l                                         ; $56B7
    inc l                                         ; $56B8
    inc l                                         ; $56B9
    ld a, [hl-]                                   ; $56BA
    and a                                         ; $56BB
    jr nz, jr_01f_5708                            ; $56BC

    ld a, [hl+]                                   ; $56BE
    ld e, a                                       ; $56BF

jr_01f_56c0:
    inc l                                         ; $56C0
    ld a, [hl+]                                   ; $56C1
    ld d, a                                       ; $56C2

jr_01f_56c3:
    push hl                                       ; $56C3
    inc l                                         ; $56C4
    inc l                                         ; $56C5
    ld a, [hl+]                                   ; $56C6
    and a                                         ; $56C7
    jr z, jr_01f_56cc                             ; $56C8

    ld e, $08                                     ; $56CA

jr_01f_56cc:
    inc l                                         ; $56CC
    inc l                                         ; $56CD
    ld [hl], $00                                  ; $56CE
    inc l                                         ; $56D0
    ld a, [hl]                                    ; $56D1
    pop hl                                        ; $56D2
    bit 7, a                                      ; $56D3
    jr nz, jr_01f_56e5                            ; $56D5

    ld a, d                                       ; $56D7
    or b                                          ; $56D8
    ldh [c], a                                    ; $56D9
    inc c                                         ; $56DA
    ld a, e                                       ; $56DB
    ldh [c], a                                    ; $56DC
    inc c                                         ; $56DD
    ld a, [hl+]                                   ; $56DE
    ldh [c], a                                    ; $56DF
    inc c                                         ; $56E0
    ld a, [hl]                                    ; $56E1
    or $c0                                        ; $56E2
    ldh [c], a                                    ; $56E4

jr_01f_56e5:
    pop hl                                        ; $56E5
    dec l                                         ; $56E6
    ld a, [hl-]                                   ; $56E7
    ld [hl-], a                                   ; $56E8
    dec l                                         ; $56E9

; C: next track (stride $10); after track 4: counters of tracks 1-3 incremented and return
Snd_Trk_Next::
    ld de, wSndCurTrack                           ; $56EA
    ld a, [de]                                    ; $56ED
    cp $04                                        ; $56EE
    jr z, jr_01f_56fb                             ; $56F0

    inc a                                         ; $56F2
    ld [de], a                                    ; $56F3
    ld a, $10                                     ; $56F4
    add l                                         ; $56F6
    ld l, a                                       ; $56F7
    jp Snd_Trk_Loop                               ; $56F8


jr_01f_56fb:
    ld hl, wSndTrack1 + $e                        ; $56FB
    inc [hl]                                      ; $56FE
    ld hl, wSndTrack2 + $e                        ; $56FF
    inc [hl]                                      ; $5702
    ld hl, wSndTrack3 + $e                        ; $5703
    inc [hl]                                      ; $5706
    ret                                           ; $5707


jr_01f_5708:
    ld b, $00                                     ; $5708
    push hl                                       ; $570A
    pop hl                                        ; $570B
    inc l                                         ; $570C
    jr jr_01f_56c0                                ; $570D

; C: E = nibble table byte at DE + (B >> 1)
Snd_Vib_Lookup::
    ld a, b                                       ; $570F
    srl a                                         ; $5710
    ld l, a                                       ; $5712
    ld h, $00                                     ; $5713
    add hl, de                                    ; $5715
    ld e, [hl]                                    ; $5716
    ret                                           ; $5717


; C: per-frame frequency modulation of the running note (depth in the low nibble of track byte +6; table $5771)
Snd_Trk_Vibrato::
    push hl                                       ; $5718
    ld a, l                                       ; $5719
    add $06                                       ; $571A
    ld l, a                                       ; $571C
    ld a, [hl]                                    ; $571D
    and $0f                                       ; $571E
    jr z, jr_01f_573a                             ; $5720

    ld [wSndTmp], a                               ; $5722
    ld a, [wSndCurTrack]                          ; $5725
    ld c, $13                                     ; $5728
    cp $01                                        ; $572A
    jr z, jr_01f_573c                             ; $572C

    ld c, $18                                     ; $572E
    cp $02                                        ; $5730
    jr z, jr_01f_573c                             ; $5732

    ld c, $1d                                     ; $5734
    cp $03                                        ; $5736
    jr z, jr_01f_573c                             ; $5738

jr_01f_573a:
    pop hl                                        ; $573A
    ret                                           ; $573B


jr_01f_573c:
    inc l                                         ; $573C
    ld a, [hl+]                                   ; $573D
    ld e, a                                       ; $573E
    ld a, [hl]                                    ; $573F
    ld d, a                                       ; $5740
    push de                                       ; $5741
    ld a, l                                       ; $5742
    add $04                                       ; $5743
    ld l, a                                       ; $5745
    ld b, [hl]                                    ; $5746
    ld a, [wSndTmp]                               ; $5747
    cp $01                                        ; $574A
    jr jr_01f_5757                                ; $574C

; I: dead tail after an unconditional jr in Snd_Trk_Vibrato; the bytes of a removed branch
Unused_Snd_Vib_Tail::
    cp $03                                        ; $574E
    jr jr_01f_5752                                ; $5750

jr_01f_5752:
    ld hl, hBootSp                                ; $5752
    jr jr_01f_5773                                ; $5755

jr_01f_5757:
    ld de, Snd_VibratoTbl                         ; $5757
    call Snd_Vib_Lookup                           ; $575A
    bit 0, b                                      ; $575D
    jr nz, jr_01f_5763                            ; $575F

    swap e                                        ; $5761

jr_01f_5763:
    ld a, e                                       ; $5763
    and $0f                                       ; $5764
    bit 3, a                                      ; $5766
    jr z, jr_01f_5770                             ; $5768

    ld h, $ff                                     ; $576A
    or $f0                                        ; $576C
    jr jr_01f_5772                                ; $576E

jr_01f_5770:
    ld h, $00                                     ; $5770

jr_01f_5772:
    ld l, a                                       ; $5772

jr_01f_5773:
    pop de                                        ; $5773
    add hl, de                                    ; $5774
    ld a, l                                       ; $5775
    ldh [c], a                                    ; $5776
    inc c                                         ; $5777
    ld a, h                                       ; $5778
    ldh [c], a                                    ; $5779
    jr jr_01f_573a                                ; $577A

; C: signed nibble offsets indexed by B>>1 (Snd_Vib_Lookup)
Snd_VibratoTbl::
    db $00, $00, $00, $00, $00, $00, $10, $00, $0f, $00, $00, $11, $00, $0f, $f0, $01
    db $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12
    db $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10
    db $ff, $ef, $01, $12, $10, $ff, $ef, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00

; I: 72 words: song id 1..$48 -> song header
Snd_SongTbl::
    dw Song01_Title_Hdr
    dw Song02_CreditsB_Hdr
    dw Song03_CreditsReal_Hdr
    dw Song04_Shutterbug_Hdr
    dw Song05_MainMenu_Hdr
    dw Song06_ShootIntroA_Hdr
    dw Song07_ShootIntroB_Hdr
    dw Song08_TimerPrintOpt_Hdr
    dw Song09_SlideMenu_Hdr
    dw Song0A_Doodle_Hdr
    dw Song0B_Edit_Hdr
    dw Song0C_Link_Hdr
    dw Song08_TimerPrintOpt_Hdr
    dw Song0E_ShootIntroC_Hdr
    dw Song0F_PhotoPicker_Hdr
    dw Song10_Hdr
    dw Song11_Jingle_Hdr
    dw Song12_Hdr
    dw Song13_Hdr
    dw Song14_Hdr
    dw Song21_SlideShowPlay_Hdr
    dw Song16_FactoryDiag_Hdr
    dw Song17_Hdr
    dw Song18_Hdr
    dw Song19_Hdr
    dw Song08_TimerPrintOpt_Hdr
    dw Song1B_Hdr
    dw Song1C_Hdr
    dw Song1D_Hdr
    dw Song01_Title_Hdr
    dw Song1F_Hdr
    dw Song20_SlideShowInit_Hdr
    dw Song21_SlideShowPlay_Hdr
    dw Song22_Hdr
    dw Song23_AnimTools_Hdr
    dw Song24_Stamp_Hdr
    dw Song25_Paint_Hdr
    dw Song26_TransferSend_Hdr
    dw Song27_TransferPrint_Hdr
    dw Song28_Hdr
    dw Song29_TotakaTune_Hdr
    dw Song19_Hdr
    dw Song2B_BallGameOver_Hdr
    dw Song2C_BallMenu_Hdr
    dw Song2D_Hdr
    dw Song2E_Hdr
    dw Song2F_DjTitle_Hdr
    dw Song30_Hdr
    dw Song31_SpaceFeverStart_Hdr
    dw Song32_SpaceFeverBossEnd_Hdr
    dw Song33_Hdr
    dw Song34_UserScreens_Hdr
    dw Song35_RecordHiScore_Hdr
    dw Song36_Special_Hdr
    dw Song37_Compose_Hdr
    dw Song38_CommentEditor_Hdr
    dw Song39_ViewMenu_Hdr
    dw Song3A_AlbumViewer_Hdr
    dw Song3B_OwnerCard_Hdr
    dw Song3C_RunPickChar_Hdr
    dw Song3D_RunCountdown_Hdr
    dw Song3E_RunReadySteadyGo_Hdr
    dw Song3F_RunRace_Hdr
    dw Song40_RunResultSetup_Hdr
    dw Song41_RunResult_Hdr
    dw Song42_SpaceFeverBossInit_Hdr
    dw Song43_RunRaceScene_Hdr
    dw Song11_Jingle_Hdr
    dw Song45_EraseJingle_Hdr
    dw Song46_UserMapScrollOut_Hdr
    dw Song1C_Hdr
    dw Song48_ErrorIncomplete_Hdr

; I: header of song id 10
Song10_Hdr::
    db $04
    db $b3
    db $41
    db $6c
    db $58
    db $74
    db $58
    db $7a
    db $58
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song10_Trk1List::
    db $ae
    db $58
    db $b9
    db $58
    db $ff
    db $ff
    db $6e
    db $58

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song10_Trk2List::
    db $b5
    db $58
    db $ff
    db $ff
    db $74
    db $58

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song10_Trk3List::
    db $88
    db $58
    db $c6
    db $58
    db $df
    db $58
    db $c6
    db $58
    db $e5
    db $58
    db $ff
    db $ff
    db $7a
    db $58

; C: note pattern ($00 ends it)
Song10_Pat5888::
    db $9d
    db $02
    db $41
    db $21
    db $9b
    db $02
    db $a4
    db $5c
    db $a2
    db $01
    db $5c
    db $60
    db $62
    db $a7
    db $66
    db $a1
    db $62
    db $60
    db $a7
    db $62
    db $a1
    db $60
    db $5c
    db $a4
    db $56
    db $a2
    db $01
    db $56
    db $58
    db $5c
    db $a4
    db $60
    db $a7
    db $5c
    db $a2
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song10_Pat58AE::
    db $9d
    db $46
    db $00
    db $81
    db $a1
    db $01
    db $00

; C: note pattern ($00 ends it)
Song10_Pat58B5::
    db $9d
    db $83
    db $00
    db $c1

; C: note pattern ($00 ends it)
Song10_Pat58B9::
    db $9b
    db $08
    db $a2
    db $44
    db $52
    db $4e
    db $52
    db $4a
    db $52
    db $48
    db $52
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song10_Pat58C6::
    db $a7
    db $70
    db $a1
    db $01
    db $6a
    db $a7
    db $6e
    db $a1
    db $01
    db $66
    db $a7
    db $6a
    db $a1
    db $01
    db $62
    db $a3
    db $66
    db $a2
    db $62
    db $60
    db $5c
    db $60
    db $62
    db $66
    db $00

; C: note pattern ($00 ends it)
Song10_Pat58DF::
    db $a3
    db $60
    db $58
    db $a5
    db $52
    db $00

; C: note pattern ($00 ends it)
Song10_Pat58E5::
    db $a2
    db $6a
    db $01
    db $a3
    db $60
    db $a4
    db $5c
    db $01
    db $00

; I: header of song id 46
Song46_UserMapScrollOut_Hdr::
    db $fa
    db $76
    db $41
    db $f9
    db $58
    db $ff
    db $58
    db $00
    db $00
    db $07
    db $59

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song46_UserMapScrollOut_Trk1List::
    db $0d
    db $59
    db $ff
    db $ff
    db $f9
    db $58

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song46_UserMapScrollOut_Trk2List::
    db $28
    db $59
    db $11
    db $59
    db $ff
    db $ff
    db $01
    db $59

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song46_UserMapScrollOut_Trk4List::
    db $2d
    db $59
    db $ff
    db $ff
    db $07
    db $59

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat590D::
    db $9d
    db $47
    db $00
    db $80

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat5911::
    db $a0
    db $62
    db $64
    db $66
    db $68
    db $6c
    db $6e
    db $70
    db $72
    db $74
    db $76
    db $78
    db $7a
    db $7c
    db $7e
    db $80
    db $82
    db $84
    db $86
    db $88
    db $8a
    db $8c
    db $00

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat5928::
    db $9d
    db $37
    db $00
    db $83
    db $00

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat592D::
    db $9b
    db $10
    db $a1
    db $1f
    db $24
    db $9c
    db $00

; I: header of song id 2D. Owner (review page, 2026-10-13, by ear): music 2D: Ball BGM (sure)
Song2D_Hdr::
    db $12
    db $8b
    db $41
    db $45
    db $59
    db $3f
    db $59
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2D_Trk2List::
    db $4b
    db $59
    db $ff
    db $ff
    db $3f
    db $59

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2D_Trk1List::
    db $ce
    db $59
    db $ff
    db $ff
    db $45
    db $59

; C: note pattern ($00 ends it)
Song2D_Pat594B::
    db $9d
    db $91
    db $00
    db $80
    db $a2
    db $32
    db $01
    db $32
    db $ad
    db $3a
    db $36
    db $32
    db $a3
    db $40
    db $3a
    db $a2
    db $32
    db $01
    db $32
    db $ad
    db $3a
    db $36
    db $32
    db $a3
    db $30
    db $32
    db $9d
    db $51
    db $00
    db $c0
    db $a2
    db $32
    db $01
    db $32
    db $ad
    db $3a
    db $36
    db $32
    db $a3
    db $40
    db $3a
    db $a2
    db $32
    db $01
    db $32
    db $ad
    db $40
    db $3c
    db $3a
    db $a3
    db $36
    db $32
    db $9d
    db $95
    db $00
    db $80
    db $a3
    db $01
    db $aa
    db $3c
    db $3c
    db $a3
    db $3c
    db $aa
    db $01
    db $9d
    db $75
    db $00
    db $c0
    db $a3
    db $01
    db $aa
    db $3a
    db $3a
    db $a3
    db $3a
    db $aa
    db $01
    db $9d
    db $36
    db $00
    db $80
    db $a3
    db $01
    db $aa
    db $3c
    db $3c
    db $a3
    db $3c
    db $aa
    db $01
    db $9d
    db $81
    db $00
    db $80
    db $a3
    db $01
    db $a2
    db $3a
    db $3a
    db $a1
    db $01
    db $a2
    db $3c
    db $a6
    db $40
    db $a2
    db $3c
    db $a2
    db $3a
    db $40
    db $a3
    db $3c
    db $3a
    db $36
    db $a3
    db $3a
    db $a7
    db $32
    db $9d
    db $f2
    db $00
    db $c0
    db $ad
    db $1a
    db $1a
    db $a3
    db $1a
    db $ad
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2D_Pat59CE::
    db $9d
    db $72
    db $00
    db $81
    db $a4
    db $1a
    db $22
    db $1a
    db $18
    db $9d
    db $42
    db $00
    db $c1
    db $1a
    db $22
    db $a7
    db $1a
    db $ad
    db $22
    db $1e
    db $1a
    db $a3
    db $18
    db $1a
    db $9d
    db $75
    db $00
    db $81
    db $a3
    db $01
    db $aa
    db $1e
    db $1e
    db $a3
    db $1e
    db $aa
    db $01
    db $9d
    db $65
    db $00
    db $81
    db $a3
    db $01
    db $aa
    db $1a
    db $1a
    db $a3
    db $1a
    db $aa
    db $01
    db $9d
    db $45
    db $00
    db $c0
    db $a3
    db $01
    db $aa
    db $1e
    db $1e
    db $a3
    db $1e
    db $aa
    db $01
    db $9d
    db $72
    db $00
    db $81
    db $a3
    db $01
    db $a2
    db $22
    db $22
    db $a1
    db $01
    db $a2
    db $24
    db $a6
    db $28
    db $a2
    db $24
    db $a2
    db $22
    db $28
    db $a3
    db $1e
    db $1a
    db $18
    db $a3
    db $1a
    db $a7
    db $1a
    db $9d
    db $e2
    db $00
    db $c0
    db $ad
    db $02
    db $02
    db $a3
    db $02
    db $ad
    db $01
    db $00

; I: header of song ids 19 2A. Owner (review page, 2026-10-13, by ear): music 2A: Jambo Nintendo ! (sure)
Song19_Hdr::
    db $fc
    db $8b
    db $41
    db $46
    db $5a
    db $40
    db $5a
    db $4c
    db $5a
    db $52
    db $5a

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk2List::
    db $6f
    db $5a
    db $ff
    db $ff
    db $40
    db $5a

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk1List::
    db $58
    db $5a
    db $ff
    db $ff
    db $46
    db $5a

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk3List::
    db $85
    db $5a
    db $ff
    db $ff
    db $4c
    db $5a

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk4List::
    db $9b
    db $5a
    db $ff
    db $ff
    db $52
    db $5a

; C: note pattern ($00 ends it)
Song19_Pat5A58::
    db $9d
    db $81
    db $00
    db $c1
    db $a1
    db $6a
    db $62
    db $58
    db $01
    db $4a
    db $52
    db $01
    db $44
    db $4a
    db $54
    db $5c
    db $60
    db $01
    db $5c
    db $60
    db $62
    db $00
    db $00

; C: note pattern ($00 ends it)
Song19_Pat5A6F::
    db $9d
    db $73
    db $00
    db $81
    db $a1
    db $52
    db $52
    db $4a
    db $01
    db $52
    db $58
    db $01
    db $54
    db $01
    db $4e
    db $01
    db $54
    db $5c
    db $01
    db $58
    db $01
    db $00

; C: note pattern ($00 ends it)
Song19_Pat5A85::
    db $9d
    db $12
    db $41
    db $20
    db $a0
    db $4a
    db $32
    db $4a
    db $01
    db $a1
    db $52
    db $01
    db $a2
    db $4e
    db $54
    db $a2
    db $01
    db $a3
    db $28
    db $a2
    db $1e
    db $00

; C: note pattern ($00 ends it)
Song19_Pat5A9B::
    db $a1
    db $15
    db $06
    db $a2
    db $10
    db $00

; I: header of song id 45
Song45_EraseJingle_Hdr::
    db $00
    db $76
    db $41
    db $ac
    db $5a
    db $b4
    db $5a
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song45_EraseJingle_Trk1List::
    db $ba
    db $5a
    db $bc
    db $5a
    db $ff
    db $ff
    db $ae
    db $5a

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song45_EraseJingle_Trk2List::
    db $f5
    db $5a
    db $ff
    db $ff
    db $b4
    db $5a

; C: note pattern ($00 ends it)
Song45_EraseJingle_Pat5ABA::
    db $aa
    db $01

; C: note pattern ($00 ends it)
Song45_EraseJingle_Pat5ABC::
    db $9d
    db $37
    db $00
    db $81
    db $a2
    db $1c
    db $26
    db $30
    db $3a
    db $44
    db $4e
    db $9d
    db $57
    db $00
    db $81
    db $a2
    db $1e
    db $28
    db $32
    db $3c
    db $46
    db $50
    db $9d
    db $77
    db $00
    db $81
    db $a2
    db $20
    db $2a
    db $34
    db $3e
    db $42
    db $52
    db $9d
    db $97
    db $00
    db $81
    db $a2
    db $22
    db $2c
    db $36
    db $40
    db $42
    db $54
    db $9d
    db $b7
    db $00
    db $81
    db $a2
    db $24
    db $2e
    db $38
    db $42
    db $44
    db $56
    db $58
    db $00

; C: note pattern ($00 ends it)
Song45_EraseJingle_Pat5AF5::
    db $9d
    db $55
    db $00
    db $80
    db $a2
    db $1a
    db $24
    db $2e
    db $38
    db $42
    db $4c
    db $9d
    db $75
    db $00
    db $80
    db $1c
    db $26
    db $30
    db $3a
    db $44
    db $4e
    db $9d
    db $95
    db $00
    db $80
    db $1e
    db $28
    db $32
    db $3c
    db $46
    db $50
    db $9d
    db $b5
    db $00
    db $80
    db $20
    db $2a
    db $34
    db $3e
    db $42
    db $52
    db $9d
    db $d5
    db $00
    db $80
    db $22
    db $2c
    db $36
    db $40
    db $42
    db $54
    db $56
    db $00

; I: header of song id 30. Owner (review page, 2026-10-13, by ear): music 30: Who are you running from 2 / error
; message (sure)
Song30_Hdr::
    db $fc
    db $82
    db $41
    db $00
    db $00
    db $35
    db $5b
    db $3d
    db $5b
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song30_Trk2List::
    db $45
    db $5b
    db $50
    db $5b
    db $ff
    db $ff
    db $37
    db $5b

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song30_Trk3List::
    db $5b
    db $5b
    db $66
    db $5b
    db $ff
    db $ff
    db $3f
    db $5b

; C: note pattern ($00 ends it)
Song30_Pat5B45::
    db $9d
    db $d3
    db $00
    db $80
    db $a0
    db $12
    db $01
    db $10
    db $01
    db $0e
    db $01

; C: note pattern ($00 ends it)
Song30_Pat5B50::
    db $a2
    db $1a
    db $01
    db $1a
    db $16
    db $10
    db $a3
    db $16
    db $a2
    db $10
    db $00

; C: note pattern ($00 ends it)
Song30_Pat5B5B::
    db $9d
    db $f2
    db $40
    db $21
    db $a0
    db $44
    db $01
    db $42
    db $01
    db $40
    db $01

; C: note pattern ($00 ends it)
Song30_Pat5B66::
    db $a2
    db $01
    db $01
    db $52
    db $01
    db $4e
    db $a3
    db $46
    db $a2
    db $40
    db $52
    db $01
    db $52
    db $a4
    db $4e
    db $a2
    db $01
    db $00

; I: header of song id 29
Song29_TotakaTune_Hdr::
    db $02
    db $76
    db $41
    db $83
    db $5b
    db $8b
    db $5b
    db $93
    db $5b
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song29_TotakaTune_Trk1List::
    db $47
    db $7f
    db $9b
    db $5b
    db $ff
    db $ff
    db $85
    db $5b

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song29_TotakaTune_Trk2List::
    db $3b
    db $7f
    db $b6
    db $5b
    db $ff
    db $ff
    db $8d
    db $5b

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song29_TotakaTune_Trk3List::
    db $53
    db $7f
    db $d1
    db $5b
    db $ff
    db $ff
    db $95
    db $5b

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat5B9B::
    db $9d
    db $93
    db $00
    db $80
    db $a3
    db $02
    db $01
    db $02
    db $06
    db $a4
    db $0a
    db $06
    db $a5
    db $02
    db $01
    db $01
    db $a3
    db $04
    db $01
    db $04
    db $08
    db $a4
    db $0c
    db $08
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat5BB6::
    db $9d
    db $b3
    db $00
    db $80
    db $a3
    db $1a
    db $01
    db $1a
    db $1e
    db $a4
    db $22
    db $1e
    db $a5
    db $1a
    db $01
    db $01
    db $a3
    db $1c
    db $01
    db $1c
    db $20
    db $a4
    db $24
    db $20
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat5BD1::
    db $9d
    db $22
    db $41
    db $21
    db $a3
    db $32
    db $01
    db $32
    db $36
    db $a4
    db $3a
    db $36
    db $a5
    db $32
    db $01
    db $01
    db $a3
    db $34
    db $01
    db $34
    db $38
    db $a4
    db $3c
    db $38
    db $01
    db $01
    db $00

; I: header of song id 41
Song41_RunResult_Hdr::
    db $fa
    db $9b
    db $41
    db $f7
    db $5b
    db $ff
    db $5b
    db $07
    db $5c
    db $0f
    db $5c

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk1List::
    db $56
    db $5c
    db $67
    db $5c
    db $ff
    db $ff
    db $f9
    db $5b

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk2List::
    db $82
    db $5c
    db $9b
    db $5c
    db $ff
    db $ff
    db $01
    db $5c

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk3List::
    db $a9
    db $5c
    db $c5
    db $5c
    db $ff
    db $ff
    db $09
    db $5c

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk4List::
    db $d8
    db $5c
    db $ff
    db $ff
    db $0f
    db $5c

; I: header of song id 02
Song02_CreditsB_Hdr::
    db $00
    db $8b
    db $41
    db $20
    db $5c
    db $32
    db $5c
    db $3c
    db $5c
    db $4e
    db $5c

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk1List::
    db $e8
    db $5c
    db $25
    db $5d
    db $25
    db $5d
    db $25
    db $5d
    db $41
    db $5d
    db $25
    db $5d
    db $66
    db $5d
    db $ff
    db $ff
    db $22
    db $5c

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk2List::
    db $f0
    db $5c
    db $89
    db $5d
    db $90
    db $5d
    db $ff
    db $ff
    db $36
    db $5c

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk3List::
    db $f8
    db $5c
    db $ac
    db $5e
    db $ac
    db $5e
    db $ac
    db $5e
    db $d1
    db $5e
    db $ac
    db $5e
    db $03
    db $5f
    db $ff
    db $ff
    db $3e
    db $5c

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk4List::
    db $13
    db $5d
    db $12
    db $5f
    db $ff
    db $ff
    db $50
    db $5c

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C56::
    db $9d
    db $7d
    db $00
    db $c1
    db $9b
    db $02
    db $a4
    db $48
    db $4e
    db $a2
    db $01
    db $a7
    db $3a
    db $a4
    db $38
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C67::
    db $9d
    db $93
    db $00
    db $81
    db $9b
    db $02
    db $a2
    db $60
    db $4e
    db $58
    db $a3
    db $5c
    db $a2
    db $66
    db $a3
    db $5c
    db $a2
    db $01
    db $52
    db $58
    db $5c
    db $50
    db $60
    db $a3
    db $5c
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C82::
    db $9d
    db $c3
    db $00
    db $c1
    db $9b
    db $02
    db $a2
    db $58
    db $4e
    db $40
    db $58
    db $4e
    db $40
    db $58
    db $4e
    db $40
    db $58
    db $4c
    db $40
    db $58
    db $4a
    db $40
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C9B::
    db $9d
    db $2f
    db $00
    db $41
    db $a4
    db $48
    db $40
    db $44
    db $4a
    db $48
    db $40
    db $44
    db $38
    db $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5CA9::
    db $9d
    db $12
    db $41
    db $21
    db $a4
    db $58
    db $a7
    db $60
    db $a2
    db $66
    db $01
    db $a7
    db $64
    db $a4
    db $62
    db $a4
    db $58
    db $a7
    db $60
    db $a2
    db $66
    db $01
    db $a7
    db $4c
    db $4a
    db $a2
    db $01
    db $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5CC5::
    db $9b
    db $02
    db $a7
    db $28
    db $a4
    db $30
    db $a2
    db $40
    db $a2
    db $01
    db $a3
    db $34
    db $a2
    db $40
    db $a3
    db $32
    db $40
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5CD8::
    db $a3
    db $01
    db $06
    db $01
    db $a2
    db $06
    db $06
    db $01
    db $01
    db $06
    db $06
    db $01
    db $06
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5CE8::
    db $9d
    db $81
    db $00
    db $c0
    db $a5
    db $14
    db $01
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5CF0::
    db $9d
    db $e4
    db $00
    db $81
    db $a5
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5CF8::
    db $9d
    db $12
    db $41
    db $20
    db $a2
    db $44
    db $01
    db $01
    db $44
    db $a3
    db $3e
    db $a2
    db $01
    db $3e
    db $48
    db $01
    db $01
    db $48
    db $a6
    db $3a
    db $a1
    db $01
    db $a6
    db $36
    db $a1
    db $01
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D13::
    db $a2
    db $15
    db $01
    db $06
    db $06
    db $01
    db $01
    db $0b
    db $01
    db $01
    db $01
    db $06
    db $06
    db $01
    db $1a
    db $1a
    db $01
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D25::
    db $9d
    db $93
    db $00
    db $c1
    db $9b
    db $04
    db $a2
    db $2c
    db $22
    db $2c
    db $a3
    db $3a
    db $a2
    db $2c
    db $22
    db $a3
    db $38
    db $a2
    db $2c
    db $26
    db $a3
    db $36
    db $a2
    db $2c
    db $a3
    db $26
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D41::
    db $9b
    db $02
    db $a2
    db $34
    db $2c
    db $26
    db $a7
    db $3a
    db $a2
    db $34
    db $2c
    db $30
    db $2c
    db $22
    db $a7
    db $3a
    db $a2
    db $30
    db $2a
    db $2c
    db $26
    db $1e
    db $a7
    db $34
    db $a2
    db $2c
    db $26
    db $2c
    db $26
    db $1e
    db $30
    db $26
    db $1e
    db $2c
    db $26
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D66::
    db $a2
    db $0e
    db $26
    db $2c
    db $30
    db $a3
    db $34
    db $3a
    db $a2
    db $0c
    db $24
    db $2c
    db $30
    db $a3
    db $34
    db $3c
    db $a2
    db $0a
    db $22
    db $2c
    db $30
    db $a3
    db $34
    db $3a
    db $a2
    db $30
    db $2c
    db $26
    db $2c
    db $4c
    db $48
    db $44
    db $48
    db $00
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D89::
    db $9b
    db $04
    db $a5
    db $01
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D90::
    INCBIN "data/bank_1f/Song02_CreditsB_Pat5D90.bin" ; $5D90, 284 bytes
; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5EAC::
    db $9d
    db $12
    db $41
    db $20
    db $9b
    db $04
    db $a3
    db $2c
    db $a2
    db $01
    db $a1
    db $2c
    db $01
    db $9d
    db $12
    db $41
    db $21
    db $a4
    db $26
    db $9d
    db $12
    db $41
    db $20
    db $a2
    db $01
    db $a7
    db $30
    db $a6
    db $22
    db $a1
    db $01
    db $a6
    db $2a
    db $a1
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5ED1::
    db $9b
    db $02
    db $a4
    db $1e
    db $a1
    db $1e
    db $01
    db $1e
    db $01
    db $1e
    db $01
    db $1e
    db $01
    db $a6
    db $1c
    db $a1
    db $01
    db $a6
    db $1c
    db $a1
    db $01
    db $a4
    db $34
    db $a3
    db $30
    db $a2
    db $01
    db $a3
    db $36
    db $a2
    db $01
    db $a3
    db $3e
    db $a1
    db $22
    db $01
    db $22
    db $01
    db $22
    db $01
    db $22
    db $01
    db $9d
    db $12
    db $41
    db $21
    db $a4
    db $22
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5F03::
    db $a4
    db $3e
    db $56
    db $3c
    db $54
    db $3a
    db $a7
    db $52
    db $a4
    db $38
    db $a2
    db $01
    db $a4
    db $22
    db $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5F12::
    db $9b
    db $0c
    db $a2
    db $15
    db $01
    db $06
    db $06
    db $1a
    db $01
    db $06
    db $06
    db $01
    db $15
    db $06
    db $06
    db $1a
    db $01
    db $06
    db $06
    db $9c
    db $00

; I: header of song id 2F
Song2F_DjTitle_Hdr::
    db $00
    db $76
    db $41
    db $32
    db $5f
    db $40
    db $5f
    db $4e
    db $5f
    db $5c
    db $5f

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk1List::
    db $62
    db $5f
    db $83
    db $5f
    db $62
    db $5f
    db $a4
    db $5f
    db $c5
    db $5f
    db $ff
    db $ff
    db $32
    db $5f

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk2List::
    db $6d
    db $5f
    db $8e
    db $5f
    db $6d
    db $5f
    db $af
    db $5f
    db $d0
    db $5f
    db $ff
    db $ff
    db $40
    db $5f

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk3List::
    db $78
    db $5f
    db $99
    db $5f
    db $78
    db $5f
    db $ba
    db $5f
    db $db
    db $5f
    db $ff
    db $ff
    db $4e
    db $5f

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk4List::
    db $e6
    db $5f
    db $ff
    db $ff
    db $5c
    db $5f

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F62::
    db $9d
    db $51
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $24
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F6D::
    db $9d
    db $61
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $1a
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F78::
    db $9d
    db $f2
    db $40
    db $20
    db $9b
    db $03
    db $a2
    db $3c
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F83::
    db $9d
    db $a1
    db $00
    db $c0
    db $9b
    db $09
    db $aa
    db $3c
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F8E::
    db $9d
    db $b1
    db $00
    db $c0
    db $9b
    db $09
    db $aa
    db $32
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F99::
    db $9d
    db $f2
    db $40
    db $20
    db $9b
    db $09
    db $aa
    db $54
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FA4::
    db $9d
    db $41
    db $00
    db $40
    db $9b
    db $0c
    db $a0
    db $4a
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FAF::
    db $9d
    db $41
    db $00
    db $40
    db $9b
    db $0c
    db $a0
    db $54
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FBA::
    db $9d
    db $f2
    db $40
    db $40
    db $9b
    db $0c
    db $a0
    db $70
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FC5::
    db $9d
    db $71
    db $00
    db $40
    db $9b
    db $1b
    db $a0
    db $4c
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FD0::
    db $9d
    db $61
    db $00
    db $40
    db $9b
    db $1b
    db $a0
    db $56
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FDB::
    db $9d
    db $f2
    db $40
    db $20
    db $9b
    db $1b
    db $a0
    db $72
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FE6::
    db $a2
    db $15
    db $06
    db $06
    db $15
    db $06
    db $06
    db $1a
    db $06
    db $00

; I: header of song id 1B
Song1B_Hdr::
    db $10
    db $9b
    db $41
    db $fb
    db $5f
    db $03
    db $60
    db $09
    db $60
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1B_Trk1List::
    db $0f
    db $60
    db $1a
    db $60
    db $ff
    db $ff
    db $fd
    db $5f

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1B_Trk2List::
    db $16
    db $60
    db $ff
    db $ff
    db $03
    db $60

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1B_Trk3List::
    db $3b
    db $60
    db $ff
    db $ff
    db $09
    db $60

; C: note pattern ($00 ends it)
Song1B_Pat600F::
    db $9d
    db $30
    db $00
    db $c1
    db $aa
    db $01
    db $00

; C: note pattern ($00 ends it)
Song1B_Pat6016::
    db $9d
    db $87
    db $00
    db $c0

; C: note pattern ($00 ends it)
Song1B_Pat601A::
    db $9b
    db $02
    db $a2
    db $32
    db $36
    db $40
    db $44
    db $4e
    db $52
    db $58
    db $52
    db $4e
    db $48
    db $44
    db $40
    db $9c
    db $9b
    db $02
    db $a2
    db $24
    db $32
    db $3c
    db $40
    db $44
    db $4e
    db $5c
    db $58
    db $52
    db $4e
    db $48
    db $44
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song1B_Pat603B::
    db $9d
    db $22
    db $41
    db $21
    db $a8
    db $4a
    db $4e
    db $52
    db $58
    db $54
    db $58
    db $5c
    db $60
    db $62
    db $58
    db $52
    db $58
    db $54
    db $52
    db $4e
    db $a4
    db $44
    db $a3
    db $48
    db $00

; I: header of song ids 11 44. Owner (review page, 2026-10-13, by ear): music 44: used - credits, short; the header is
; shared with id 11; the callers of 44 are Mode0E_State06_ExchangeSetup / State0A_ExchangeSetupB, so the same tune is
; used both for the short credits and in the link exchange; name kept.
Song11_Jingle_Hdr::
    db $00
    db $76
    db $41
    db $5f
    db $60
    db $65
    db $60
    db $6b
    db $60
    db $71
    db $60

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk1List::
    db $77
    db $60
    db $ff
    db $ff
    db $5f
    db $60

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk2List::
    db $90
    db $60
    db $ff
    db $ff
    db $65
    db $60

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk3List::
    db $bc
    db $60
    db $ff
    db $ff
    db $6b
    db $60

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk4List::
    db $d6
    db $60
    db $ff
    db $ff
    db $71
    db $60

; C: note pattern ($00 ends it)
Song11_Jingle_Pat6077::
    db $9d
    db $d1
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $10
    db $01
    db $28
    db $14
    db $01
    db $14
    db $28
    db $01
    db $9c
    db $10
    db $01
    db $28
    db $1e
    db $01
    db $10
    db $28
    db $01
    db $00

; C: note pattern ($00 ends it)
Song11_Jingle_Pat6090::
    db $9d
    db $81
    db $00
    db $80
    db $9b
    db $02
    db $a2
    db $01
    db $60
    db $60
    db $60
    db $60
    db $60
    db $60
    db $60
    db $5c
    db $60
    db $01
    db $58
    db $a4
    db $01
    db $a2
    db $01
    db $60
    db $60
    db $60
    db $60
    db $60
    db $60
    db $60
    db $5c
    db $62
    db $a8
    db $01
    db $9c
    db $9b
    db $08
    db $a3
    db $01
    db $30
    db $01
    db $30
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song11_Jingle_Pat60BC::
    db $9d
    db $f2
    db $40
    db $21
    db $9b
    db $03
    db $a3
    db $28
    db $a2
    db $01
    db $2c
    db $01
    db $2c
    db $a3
    db $24
    db $9c
    db $a3
    db $28
    db $a2
    db $01
    db $36
    db $01
    db $28
    db $a3
    db $24
    db $00

; C: note pattern ($00 ends it)
Song11_Jingle_Pat60D6::
    db $a2
    db $15
    db $06
    db $06
    db $15
    db $06
    db $06
    db $1a
    db $06
    db $00

; I: header of song id 3C
Song3C_RunPickChar_Hdr::
    db $00
    db $8b
    db $41
    db $eb
    db $60
    db $f1
    db $60
    db $f7
    db $60
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3C_RunPickChar_Trk1List::
    db $fd
    db $60
    db $ff
    db $ff
    db $eb
    db $60

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3C_RunPickChar_Trk2List::
    db $14
    db $61
    db $ff
    db $ff
    db $f1
    db $60

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3C_RunPickChar_Trk3List::
    db $2a
    db $61
    db $ff
    db $ff
    db $f7
    db $60

; C: note pattern ($00 ends it)
Song3C_RunPickChar_Pat60FD::
    db $9d
    db $93
    db $00
    db $41
    db $a2
    db $7e
    db $7e
    db $7e
    db $80
    db $7e
    db $a1
    db $80
    db $7e
    db $a2
    db $76
    db $74
    db $70
    db $74
    db $76
    db $70
    db $a4
    db $74
    db $00

; C: note pattern ($00 ends it)
Song3C_RunPickChar_Pat6114::
    db $9d
    db $7b
    db $00
    db $81
    db $a3
    db $36
    db $a2
    db $38
    db $40
    db $a3
    db $44
    db $a2
    db $46
    db $4e
    db $a2
    db $46
    db $44
    db $40
    db $38
    db $a4
    db $36
    db $00

; C: note pattern ($00 ends it)
Song3C_RunPickChar_Pat612A::
    db $9d
    db $f2
    db $40
    db $21
    db $a3
    db $66
    db $a2
    db $68
    db $70
    db $a3
    db $74
    db $a2
    db $76
    db $7e
    db $a2
    db $76
    db $74
    db $70
    db $68
    db $a4
    db $66
    db $00

; I: header of song id 43
Song43_RunRaceScene_Hdr::
    db $00
    db $8b
    db $41
    db $4b
    db $61
    db $51
    db $61
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song43_RunRaceScene_Trk1List::
    db $57
    db $61
    db $ff
    db $ff
    db $4b
    db $61

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song43_RunRaceScene_Trk2List::
    db $74
    db $61
    db $ff
    db $ff
    db $51
    db $61

; C: note pattern ($00 ends it)
Song43_RunRaceScene_Pat6157::
    db $9d
    db $b1
    db $00
    db $41
    db $9b
    db $02
    db $a2
    db $1a
    db $22
    db $9c
    db $9b
    db $02
    db $a2
    db $1e
    db $a1
    db $2c
    db $2c
    db $9c
    db $9b
    db $02
    db $a2
    db $1a
    db $22
    db $9c
    db $1e
    db $26
    db $06
    db $01
    db $00

; C: note pattern ($00 ends it)
Song43_RunRaceScene_Pat6174::
    db $9d
    db $9b
    db $00
    db $81
    db $a2
    db $52
    db $58
    db $5c
    db $58
    db $56
    db $01
    db $5c
    db $01
    db $52
    db $58
    db $5c
    db $58
    db $56
    db $a2
    db $01
    db $9d
    db $d1
    db $00
    db $c0
    db $a3
    db $06
    db $00

; I: header of song id 42
Song42_SpaceFeverBossInit_Hdr::
    db $00
    db $8b
    db $41
    db $9a
    db $61
    db $a2
    db $61
    db $aa
    db $61
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song42_SpaceFeverBossInit_Trk1List::
    db $b2
    db $61
    db $ee
    db $61
    db $ff
    db $ff
    db $9c
    db $61

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song42_SpaceFeverBossInit_Trk2List::
    db $c2
    db $61
    db $e2
    db $61
    db $ff
    db $ff
    db $a4
    db $61

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song42_SpaceFeverBossInit_Trk3List::
    db $d2
    db $61
    db $04
    db $62
    db $ff
    db $ff
    db $ac
    db $61

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61B2::
    db $9d
    db $d0
    db $00
    db $41
    db $9b
    db $02
    db $a7
    db $22
    db $a2
    db $01
    db $a7
    db $24
    db $a2
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61C2::
    db $9d
    db $e0
    db $00
    db $41
    db $9b
    db $02
    db $a7
    db $0a
    db $a2
    db $01
    db $a7
    db $0c
    db $a2
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61D2::
    db $9d
    db $f2
    db $40
    db $21
    db $9b
    db $02
    db $a7
    db $48
    db $a2
    db $01
    db $a7
    db $4a
    db $a2
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61E2::
    db $9d
    db $8a
    db $00
    db $81
    db $a9
    db $78
    db $76
    db $74
    db $72
    db $74
    db $76
    db $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61EE::
    db $9d
    db $e0
    db $00
    db $c1
    db $a0
    db $0a
    db $01
    db $0c
    db $01
    db $0e
    db $01
    db $10
    db $01
    db $12
    db $01
    db $10
    db $01
    db $0e
    db $01
    db $0c
    db $01
    db $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat6204::
    db $9d
    db $f2
    db $40
    db $20
    db $a0
    db $3a
    db $01
    db $3c
    db $01
    db $3e
    db $01
    db $40
    db $01
    db $42
    db $01
    db $40
    db $01
    db $3e
    db $01
    db $3c
    db $01
    db $00

; I: header of song id 34
Song34_UserScreens_Hdr::
    db $00
    db $82
    db $41
    db $25
    db $62
    db $2d
    db $62
    db $33
    db $62
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song34_UserScreens_Trk1List::
    db $39
    db $62
    db $41
    db $62
    db $ff
    db $ff
    db $27
    db $62

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song34_UserScreens_Trk2List::
    db $5b
    db $62
    db $ff
    db $ff
    db $2d
    db $62

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song34_UserScreens_Trk3List::
    db $95
    db $62
    db $ff
    db $ff
    db $33
    db $62

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat6239::
    db $9d
    db $20
    db $00
    db $81
    db $aa
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat6241::
    db $a2
    db $32
    db $3c
    db $46
    db $4a
    db $54
    db $5e
    db $62
    db $6c
    db $76
    db $7a
    db $84
    db $8e
    db $90
    db $86
    db $7c
    db $78
    db $6e
    db $64
    db $60
    db $56
    db $4c
    db $48
    db $3e
    db $34
    db $00

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat625B::
    db $9d
    db $57
    db $00
    db $81
    db $a2
    db $32
    db $3c
    db $46
    db $9d
    db $87
    db $00
    db $81
    db $4a
    db $54
    db $5e
    db $9d
    db $a7
    db $00
    db $81
    db $62
    db $6c
    db $76
    db $9d
    db $c7
    db $00
    db $81
    db $7a
    db $84
    db $8e
    db $9d
    db $e7
    db $00
    db $81
    db $90
    db $86
    db $7c
    db $9d
    db $b7
    db $00
    db $81
    db $78
    db $6e
    db $64
    db $9d
    db $87
    db $00
    db $81
    db $60
    db $56
    db $4c
    db $9d
    db $67
    db $00
    db $81
    db $48
    db $3e
    db $34
    db $00

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat6295::
    db $9d
    db $22
    db $41
    db $20
    db $a0
    db $8a
    db $01
    db $8a
    db $01
    db $a5
    db $01
    db $01
    db $9b
    db $03
    db $a0
    db $8e
    db $01
    db $9c
    db $a5
    db $01
    db $01
    db $01
    db $00

; I: header of song id 2C
Song2C_BallMenu_Hdr::
    db $00
    db $82
    db $41
    db $b7
    db $62
    db $bd
    db $62
    db $c3
    db $62
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2C_BallMenu_Trk1List::
    db $c9
    db $62
    db $ff
    db $ff
    db $b7
    db $62

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2C_BallMenu_Trk2List::
    db $e0
    db $62
    db $ff
    db $ff
    db $bd
    db $62

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song2C_BallMenu_Trk3List::
    db $f7
    db $62
    db $ff
    db $ff
    db $c3
    db $62

; C: note pattern ($00 ends it)
Song2C_BallMenu_Pat62C9::
    db $9d
    db $c1
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $01
    db $01
    db $4a
    db $9c
    db $a7
    db $01
    db $a5
    db $01
    db $a6
    db $56
    db $01
    db $01
    db $64
    db $a8
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2C_BallMenu_Pat62E0::
    db $9d
    db $e1
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $32
    db $36
    db $3a
    db $9c
    db $a7
    db $01
    db $a5
    db $01
    db $a6
    db $5a
    db $68
    db $56
    db $01
    db $a8
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2C_BallMenu_Pat62F7::
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $03
    db $a2
    db $01
    db $01
    db $54
    db $9c
    db $a7
    db $01
    db $a5
    db $01
    db $a6
    db $01
    db $64
    db $72
    db $80
    db $a8
    db $01
    db $00

; I: header of song id 39
Song39_ViewMenu_Hdr::
    db $00
    db $82
    db $41
    db $19
    db $63
    db $1f
    db $63
    db $25
    db $63
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song39_ViewMenu_Trk1List::
    db $2b
    db $63
    db $ff
    db $ff
    db $19
    db $63

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song39_ViewMenu_Trk2List::
    db $5d
    db $63
    db $ff
    db $ff
    db $1f
    db $63

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song39_ViewMenu_Trk3List::
    db $8c
    db $63
    db $ff
    db $ff
    db $25
    db $63

; C: note pattern ($00 ends it)
Song39_ViewMenu_Pat632B::
    db $9d
    db $41
    db $00
    db $80
    db $a2
    db $48
    db $48
    db $48
    db $4a
    db $4a
    db $4a
    db $9d
    db $71
    db $00
    db $80
    db $a2
    db $48
    db $48
    db $48
    db $4a
    db $4a
    db $4a
    db $9d
    db $91
    db $00
    db $80
    db $a2
    db $48
    db $48
    db $48
    db $4a
    db $4a
    db $4a
    db $9d
    db $c1
    db $00
    db $80
    db $a2
    db $48
    db $48
    db $48
    db $9d
    db $e1
    db $00
    db $80
    db $a2
    db $4a
    db $4a
    db $4a
    db $00

; C: note pattern ($00 ends it)
Song39_ViewMenu_Pat635D::
    db $9d
    db $41
    db $00
    db $80
    db $a2
    db $36
    db $36
    db $36
    db $3a
    db $3a
    db $3a
    db $9d
    db $71
    db $00
    db $80
    db $36
    db $36
    db $36
    db $3a
    db $3a
    db $3a
    db $9d
    db $91
    db $00
    db $80
    db $a2
    db $36
    db $36
    db $36
    db $3a
    db $3a
    db $3a
    db $9d
    db $b1
    db $00
    db $80
    db $36
    db $36
    db $36
    db $9d
    db $d1
    db $00
    db $80
    db $3a
    db $3a
    db $3a
    db $00

; C: note pattern ($00 ends it)
Song39_ViewMenu_Pat638C::
    db $9d
    db $f2
    db $40
    db $21
    db $a3
    db $32
    db $a1
    db $58
    db $70
    db $a3
    db $3a
    db $a1
    db $66
    db $4e
    db $a3
    db $3c
    db $a1
    db $58
    db $70
    db $a3
    db $40
    db $a1
    db $66
    db $4e
    db $a3
    db $3c
    db $a1
    db $28
    db $40
    db $a3
    db $44
    db $a1
    db $36
    db $4e
    db $a3
    db $4a
    db $a1
    db $58
    db $70
    db $a3
    db $4e
    db $a1
    db $66
    db $7e
    db $00

; I: header of song id 38
Song38_CommentEditor_Hdr::
    db $00
    db $8b
    db $41
    db $c4
    db $63
    db $ca
    db $63
    db $d0
    db $63
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song38_CommentEditor_Trk1List::
    db $d6
    db $63
    db $ff
    db $ff
    db $c4
    db $63

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song38_CommentEditor_Trk2List::
    db $0a
    db $64
    db $ff
    db $ff
    db $ca
    db $63

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song38_CommentEditor_Trk3List::
    db $35
    db $64
    db $ff
    db $ff
    db $d0
    db $63

; C: note pattern ($00 ends it)
Song38_CommentEditor_Pat63D6::
    db $9d
    db $51
    db $00
    db $81
    db $a2
    db $01
    db $36
    db $3a
    db $3e
    db $40
    db $44
    db $48
    db $9d
    db $a1
    db $00
    db $80
    db $a2
    db $4e
    db $01
    db $52
    db $56
    db $58
    db $5c
    db $9d
    db $91
    db $00
    db $80
    db $a2
    db $60
    db $64
    db $66
    db $6a
    db $56
    db $52
    db $4e
    db $9d
    db $c1
    db $00
    db $80
    db $a2
    db $4c
    db $48
    db $44
    db $9d
    db $e1
    db $00
    db $80
    db $a2
    db $01
    db $01
    db $40
    db $00

; C: note pattern ($00 ends it)
Song38_CommentEditor_Pat640A::
    db $9d
    db $51
    db $00
    db $81
    db $a2
    db $48
    db $4c
    db $4e
    db $52
    db $56
    db $9d
    db $71
    db $00
    db $80
    db $58
    db $5c
    db $01
    db $60
    db $64
    db $01
    db $9d
    db $61
    db $00
    db $80
    db $a2
    db $66
    db $6a
    db $6e
    db $9d
    db $e1
    db $00
    db $80
    db $6a
    db $66
    db $01
    db $9d
    db $d1
    db $00
    db $80
    db $01
    db $64
    db $60
    db $00

; C: note pattern ($00 ends it)
Song38_CommentEditor_Pat6435::
    db $9d
    db $f2
    db $40
    db $21
    db $9b
    db $02
    db $a1
    db $58
    db $01
    db $36
    db $01
    db $66
    db $01
    db $52
    db $01
    db $6a
    db $01
    db $4e
    db $01
    db $66
    db $01
    db $40
    db $01
    db $9c
    db $6a
    db $01
    db $5c
    db $01
    db $66
    db $01
    db $48
    db $01
    db $60
    db $01
    db $4e
    db $01
    db $5c
    db $01
    db $52
    db $01
    db $00

; I: header of song id 36
Song36_Special_Hdr::
    db $02
    db $6b
    db $41
    db $69
    db $64
    db $6f
    db $64
    db $75
    db $64
    db $7b
    db $64

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk1List::
    db $81
    db $64
    db $ff
    db $ff
    db $69
    db $64

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk2List::
    db $8a
    db $64
    db $ff
    db $ff
    db $6f
    db $64

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk3List::
    db $93
    db $64
    db $ff
    db $ff
    db $75
    db $64

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk4List::
    db $a0
    db $64
    db $ff
    db $ff
    db $7b
    db $64

; C: note pattern ($00 ends it)
Song36_Special_Pat6481::
    db $9d
    db $c1
    db $00
    db $80
    db $a2
    db $1e
    db $a1
    db $1e
    db $00

; C: note pattern ($00 ends it)
Song36_Special_Pat648A::
    db $9d
    db $e1
    db $00
    db $80
    db $a6
    db $06
    db $a1
    db $06
    db $00

; C: note pattern ($00 ends it)
Song36_Special_Pat6493::
    db $9d
    db $22
    db $41
    db $20
    db $a7
    db $58
    db $5c
    db $60
    db $52
    db $01
    db $4e
    db $01
    db $00

; C: note pattern ($00 ends it)
Song36_Special_Pat64A0::
    db $a3
    db $15
    db $15
    db $1a
    db $1a
    db $00

; I: header of song id 37
Song37_Compose_Hdr::
    db $02
    db $82
    db $41
    db $b1
    db $64
    db $b9
    db $64
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song37_Compose_Trk1List::
    db $c1
    db $64
    db $f5
    db $64
    db $ff
    db $ff
    db $b1
    db $64

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song37_Compose_Trk2List::
    db $db
    db $64
    db $0c
    db $65
    db $ff
    db $ff
    db $b9
    db $64

; C: note pattern ($00 ends it)
Song37_Compose_Pat64C1::
    db $9d
    db $91
    db $00
    db $40
    db $a2
    db $40
    db $44
    db $48
    db $01
    db $40
    db $44
    db $48
    db $01
    db $9d
    db $41
    db $00
    db $40
    db $48
    db $4a
    db $48
    db $44
    db $40
    db $01
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song37_Compose_Pat64DB::
    db $9d
    db $91
    db $00
    db $40
    db $a2
    db $56
    db $58
    db $5c
    db $01
    db $56
    db $58
    db $5c
    db $01
    db $9d
    db $41
    db $00
    db $40
    db $5c
    db $60
    db $5c
    db $58
    db $56
    db $01
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song37_Compose_Pat64F5::
    db $9d
    db $71
    db $00
    db $80
    db $a2
    db $42
    db $46
    db $4a
    db $01
    db $42
    db $46
    db $4a
    db $01
    db $a5
    db $01
    db $a2
    db $5c
    db $60
    db $5c
    db $58
    db $a4
    db $01
    db $00

; C: note pattern ($00 ends it)
Song37_Compose_Pat650C::
    db $9d
    db $71
    db $00
    db $80
    db $a2
    db $56
    db $58
    db $5c
    db $01
    db $56
    db $58
    db $5c
    db $01
    db $a5
    db $01
    db $a2
    db $48
    db $4a
    db $48
    db $44
    db $a4
    db $01
    db $00

; I: header of song id 3A
Song3A_AlbumViewer_Hdr::
    db $02
    db $82
    db $41
    db $2e
    db $65
    db $34
    db $65
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3A_AlbumViewer_Trk1List::
    db $3a
    db $65
    db $ff
    db $ff
    db $2e
    db $65

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3A_AlbumViewer_Trk2List::
    db $60
    db $65
    db $ff
    db $ff
    db $34
    db $65

; C: note pattern ($00 ends it)
Song3A_AlbumViewer_Pat653A::
    db $9d
    db $91
    db $00
    db $80
    db $a3
    db $02
    db $52
    db $52
    db $01
    db $06
    db $54
    db $54
    db $01
    db $9d
    db $51
    db $00
    db $80
    db $0a
    db $52
    db $52
    db $0c
    db $a6
    db $54
    db $a1
    db $58
    db $a6
    db $01
    db $a1
    db $5c
    db $a6
    db $01
    db $a1
    db $58
    db $a6
    db $54
    db $a1
    db $52
    db $00

; C: note pattern ($00 ends it)
Song3A_AlbumViewer_Pat6560::
    db $9d
    db $91
    db $00
    db $80
    db $a3
    db $1a
    db $58
    db $58
    db $01
    db $1e
    db $5c
    db $5c
    db $01
    db $9d
    db $51
    db $00
    db $80
    db $22
    db $58
    db $58
    db $24
    db $a6
    db $4e
    db $a1
    db $52
    db $a6
    db $01
    db $a1
    db $54
    db $a6
    db $01
    db $a1
    db $52
    db $a6
    db $4e
    db $a1
    db $4a
    db $00

; I: header of song id 40
Song40_RunResultSetup_Hdr::
    db $00
    db $76
    db $41
    db $91
    db $65
    db $97
    db $65
    db $9d
    db $65
    db $a3
    db $65

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk1List::
    db $a9
    db $65
    db $ff
    db $ff
    db $91
    db $65

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk2List::
    db $bf
    db $65
    db $ff
    db $ff
    db $97
    db $65

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk3List::
    db $04
    db $66
    db $ff
    db $ff
    db $9d
    db $65

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk4List::
    db $1a
    db $66
    db $ff
    db $ff
    db $a3
    db $65

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat65A9::
    db $9d
    db $c1
    db $00
    db $c0
    db $a3
    db $01
    db $40
    db $1a
    db $01
    db $01
    db $30
    db $0a
    db $01
    db $01
    db $32
    db $0c
    db $01
    db $01
    db $32
    db $0e
    db $01
    db $00

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat65BF::
    db $9d
    db $e2
    db $00
    db $80
    db $a6
    db $02
    db $a1
    db $01
    db $a6
    db $52
    db $a1
    db $01
    db $a6
    db $4a
    db $a1
    db $40
    db $a6
    db $28
    db $a1
    db $01
    db $a6
    db $4e
    db $a1
    db $01
    db $a6
    db $48
    db $a1
    db $42
    db $a6
    db $0a
    db $a1
    db $3a
    db $a6
    db $30
    db $a1
    db $01
    db $a6
    db $0c
    db $a1
    db $01
    db $a6
    db $44
    db $a1
    db $01
    db $a6
    db $4a
    db $a1
    db $4e
    db $a6
    db $32
    db $a1
    db $4a
    db $a6
    db $50
    db $a1
    db $01
    db $a6
    db $4e
    db $a1
    db $4a
    db $a6
    db $0e
    db $a1
    db $44
    db $a6
    db $36
    db $a1
    db $40
    db $00

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat6604::
    db $9d
    db $f2
    db $40
    db $20
    db $a3
    db $1a
    db $52
    db $1a
    db $52
    db $22
    db $5a
    db $22
    db $5a
    db $24
    db $5c
    db $24
    db $5c
    db $26
    db $5c
    db $26
    db $5c
    db $00

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat661A::
    db $a6
    db $15
    db $a1
    db $06
    db $a6
    db $0b
    db $a1
    db $06
    db $a6
    db $1a
    db $a1
    db $06
    db $a6
    db $0b
    db $a1
    db $06
    db $00

; I: header of song id 3D
Song3D_RunCountdown_Hdr::
    db $00
    db $76
    db $41
    db $36
    db $66
    db $3a
    db $66
    db $3c
    db $66
    db $3e
    db $66

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk1List::
    db $40
    db $66
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk2List::
    db $57
    db $66

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk3List::
    db $6e
    db $66

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk4List::
    db $92
    db $66

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat6640::
    db $9d
    db $50
    db $00
    db $c1
    db $a4
    db $26
    db $2a
    db $9d
    db $70
    db $00
    db $c1
    db $a4
    db $2e
    db $32
    db $9d
    db $90
    db $00
    db $c1
    db $a4
    db $36
    db $a5
    db $3a
    db $00

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat6657::
    db $9d
    db $50
    db $00
    db $c1
    db $a4
    db $32
    db $36
    db $9d
    db $70
    db $00
    db $c1
    db $a4
    db $3a
    db $3e
    db $9d
    db $90
    db $00
    db $c1
    db $a4
    db $42
    db $a5
    db $46
    db $00

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat666E::
    db $9d
    db $f2
    db $40
    db $20
    db $9b
    db $04
    db $a1
    db $1e
    db $01
    db $9c
    db $9b
    db $04
    db $22
    db $01
    db $9c
    db $9b
    db $04
    db $26
    db $01
    db $9c
    db $9b
    db $04
    db $2a
    db $01
    db $9c
    db $9b
    db $04
    db $2e
    db $01
    db $9c
    db $9b
    db $12
    db $32
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat6692::
    db $9b
    db $10
    db $a2
    db $0b
    db $0b
    db $0b
    db $0b
    db $1a
    db $1a
    db $1a
    db $1a
    db $9c
    db $00

; I: header of song id 3E
Song3E_RunReadySteadyGo_Hdr::
    db $fa
    db $8b
    db $41
    db $aa
    db $66
    db $b2
    db $66
    db $ba
    db $66
    db $c2
    db $66

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk1List::
    db $cd
    db $66
    db $e2
    db $66
    db $ff
    db $ff
    db $ac
    db $66

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk2List::
    db $d4
    db $66
    db $f0
    db $66
    db $ff
    db $ff
    db $b4
    db $66

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk3List::
    db $db
    db $66
    db $16
    db $67
    db $ff
    db $ff
    db $bc
    db $66

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk4List::
    db $ca
    db $66
    db $49
    db $67
    db $ff
    db $ff
    db $c4
    db $66

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66CA::
    db $a4
    db $01
    db $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66CD::
    db $9d
    db $e0
    db $00
    db $81
    db $a4
    db $74
    db $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66D4::
    db $9d
    db $e0
    db $00
    db $81
    db $a4
    db $70
    db $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66DB::
    db $9d
    db $f2
    db $40
    db $21
    db $a4
    db $72
    db $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66E2::
    db $9d
    db $c1
    db $00
    db $c0
    db $a3
    db $1a
    db $32
    db $30
    db $48
    db $2c
    db $44
    db $28
    db $40
    db $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66F0::
    db $9d
    db $a1
    db $00
    db $40
    db $a1
    db $1a
    db $62
    db $40
    db $7a
    db $1a
    db $01
    db $40
    db $70
    db $18
    db $62
    db $40
    db $7a
    db $18
    db $01
    db $40
    db $70
    db $14
    db $62
    db $40
    db $7a
    db $14
    db $01
    db $40
    db $70
    db $10
    db $62
    db $40
    db $7a
    db $10
    db $10
    db $40
    db $10
    db $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat6716::
    db $9d
    db $f2
    db $40
    db $20
    db $a2
    db $32
    db $a1
    db $52
    db $01
    db $a2
    db $32
    db $a1
    db $52
    db $a0
    db $58
    db $6a
    db $a2
    db $30
    db $a1
    db $52
    db $70
    db $a2
    db $30
    db $a1
    db $52
    db $a0
    db $58
    db $6a
    db $a2
    db $2c
    db $a1
    db $52
    db $7a
    db $a2
    db $2c
    db $a1
    db $52
    db $a0
    db $58
    db $6a
    db $a2
    db $28
    db $a1
    db $52
    db $66
    db $a2
    db $28
    db $a1
    db $52
    db $74
    db $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat6749::
    db $a1
    db $15
    db $06
    db $a2
    db $0b
    db $a1
    db $06
    db $06
    db $a2
    db $0b
    db $a1
    db $15
    db $06
    db $a2
    db $0b
    db $a1
    db $1a
    db $06
    db $a2
    db $0b
    db $00

; I: header of song id 3F
Song3F_RunRace_Hdr::
    db $00
    db $76
    db $41
    db $69
    db $67
    db $6d
    db $67
    db $6f
    db $67
    db $71
    db $67

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk1List::
    db $73
    db $67
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk2List::
    db $89
    db $67

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk3List::
    db $9a
    db $67

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk4List::
    db $a5
    db $67

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat6773::
    db $9d
    db $c0
    db $00
    db $c1
    db $a2
    db $4a
    db $3a
    db $4a
    db $4a
    db $32
    db $4a
    db $48
    db $40
    db $48
    db $a5
    db $52
    db $9f
    db $fa
    db $9e
    db $aa
    db $41
    db $00

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat6789::
    db $9d
    db $e0
    db $00
    db $c1
    db $a2
    db $52
    db $58
    db $52
    db $54
    db $44
    db $3c
    db $58
    db $4e
    db $58
    db $a5
    db $62
    db $00

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat679A::
    db $9d
    db $f2
    db $40
    db $21
    db $a7
    db $4a
    db $54
    db $58
    db $a5
    db $32
    db $00

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat67A5::
    db $a2
    db $0b
    db $06
    db $06
    db $0b
    db $06
    db $06
    db $0b
    db $06
    db $06
    db $9b
    db $10
    db $a0
    db $0b
    db $0b
    db $9c
    db $00

; I: header of song id 3B
Song3B_OwnerCard_Hdr::
    db $06
    db $76
    db $41
    db $c1
    db $67
    db $c7
    db $67
    db $cd
    db $67
    db $d3
    db $67

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk1List::
    db $d9
    db $67
    db $ff
    db $ff
    db $c1
    db $67

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk2List::
    db $fa
    db $67
    db $ff
    db $ff
    db $c7
    db $67

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk3List::
    db $55
    db $68
    db $ff
    db $ff
    db $cd
    db $67

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk4List::
    db $6e
    db $68
    db $ff
    db $ff
    db $d3
    db $67

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat67D9::
    db $9d
    db $c1
    db $00
    db $c0
    db $9b
    db $08
    db $a3
    db $02
    db $32
    db $02
    db $32
    db $06
    db $36
    db $06
    db $36
    db $9c
    db $9d
    db $91
    db $00
    db $c0
    db $9b
    db $04
    db $a3
    db $02
    db $32
    db $02
    db $32
    db $06
    db $36
    db $06
    db $36
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat67FA::
    db $9d
    db $e1
    db $00
    db $41
    db $9b
    db $02
    db $a6
    db $40
    db $a1
    db $01
    db $a6
    db $28
    db $a1
    db $40
    db $a6
    db $44
    db $a1
    db $4a
    db $a6
    db $28
    db $a1
    db $50
    db $a6
    db $01
    db $a1
    db $4e
    db $a6
    db $2c
    db $a1
    db $4a
    db $a6
    db $01
    db $a1
    db $44
    db $a6
    db $2c
    db $a1
    db $40
    db $9c
    db $9b
    db $02
    db $a6
    db $01
    db $a1
    db $01
    db $a6
    db $28
    db $a1
    db $38
    db $a6
    db $3a
    db $a1
    db $28
    db $a6
    db $44
    db $a1
    db $01
    db $a6
    db $38
    db $a1
    db $01
    db $a6
    db $36
    db $a1
    db $01
    db $a6
    db $32
    db $a1
    db $01
    db $a6
    db $2c
    db $a1
    db $32
    db $9c
    db $9d
    db $91
    db $00
    db $40
    db $9b
    db $02
    db $a3
    db $01
    db $28
    db $01
    db $28
    db $01
    db $2c
    db $01
    db $2c
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat6855::
    db $9d
    db $f2
    db $40
    db $20
    db $a3
    db $1a
    db $a2
    db $52
    db $01
    db $a3
    db $1a
    db $a2
    db $52
    db $01
    db $a3
    db $1e
    db $a2
    db $54
    db $01
    db $a3
    db $1e
    db $a2
    db $54
    db $01
    db $00

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat686E::
    db $a6
    db $15
    db $a1
    db $06
    db $a6
    db $0b
    db $a1
    db $06
    db $a6
    db $1a
    db $a1
    db $06
    db $a6
    db $06
    db $a1
    db $0b
    db $00

; I: header of song ids 01 1E
Song01_Title_Hdr::
    db $00
    db $8b
    db $41
    db $8a
    db $68
    db $92
    db $68
    db $9a
    db $68
    db $a6
    db $68

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk1List::
    db $b2
    db $68
    db $e0
    db $68
    db $ff
    db $ff
    db $8c
    db $68

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk2List::
    db $c3
    db $68
    db $7f
    db $69
    db $ff
    db $ff
    db $94
    db $68

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk3List::
    db $cd
    db $68
    db $a5
    db $69
    db $a5
    db $69
    db $12
    db $6a
    db $ff
    db $ff
    db $9c
    db $68

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk4List::
    db $d9
    db $68
    db $19
    db $6a
    db $19
    db $6a
    db $47
    db $6a
    db $ff
    db $ff
    db $a8
    db $68

; C: note pattern ($00 ends it)
Song01_Title_Pat68B2::
    db $9d
    db $f1
    db $00
    db $80
    db $ad
    db $32
    db $32
    db $9d
    db $51
    db $00
    db $80
    db $a0
    db $62
    db $90
    db $1a
    db $48
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68C3::
    db $9d
    db $f3
    db $00
    db $40
    db $ad
    db $08
    db $08
    db $a2
    db $01
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68CD::
    db $9d
    db $12
    db $41
    db $20
    db $ab
    db $0e
    db $01
    db $0e
    db $01
    db $a2
    db $01
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68D9::
    db $ad
    db $06
    db $06
    db $a2
    db $01
    db $00
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68E0::
    db $9d
    db $f1
    db $00
    db $80
    db $a3
    db $10
    db $01
    db $58
    db $01
    db $a6
    db $10
    db $10
    db $a2
    db $10
    db $a3
    db $58
    db $a1
    db $01
    db $a6
    db $10
    db $a3
    db $10
    db $01
    db $58
    db $01
    db $a6
    db $10
    db $10
    db $a2
    db $10
    db $9d
    db $61
    db $00
    db $80
    db $a0
    db $70
    db $70
    db $6a
    db $6a
    db $62
    db $62
    db $58
    db $58
    db $9d
    db $e1
    db $00
    db $80
    db $a1
    db $10
    db $9d
    db $31
    db $00
    db $80
    db $a0
    db $10
    db $28
    db $9d
    db $61
    db $00
    db $80
    db $40
    db $58
    db $9d
    db $81
    db $00
    db $80
    db $70
    db $88
    db $9d
    db $f1
    db $00
    db $80
    db $a6
    db $10
    db $10
    db $a2
    db $10
    db $a1
    db $4a
    db $4a
    db $01
    db $01
    db $a9
    db $01
    db $10
    db $10
    db $a4
    db $10
    db $4a
    db $a1
    db $02
    db $01
    db $4a
    db $4a
    db $01
    db $4a
    db $4a
    db $01
    db $9d
    db $61
    db $00
    db $80
    db $a0
    db $32
    db $28
    db $9d
    db $f1
    db $00
    db $80
    db $a1
    db $01
    db $4a
    db $4a
    db $a1
    db $01
    db $01
    db $4a
    db $4a
    db $9d
    db $41
    db $00
    db $80
    db $9b
    db $04
    db $a0
    db $70
    db $70
    db $9c
    db $9d
    db $71
    db $00
    db $80
    db $9b
    db $04
    db $a0
    db $58
    db $58
    db $9c
    db $9d
    db $a1
    db $00
    db $80
    db $9b
    db $04
    db $a0
    db $40
    db $40
    db $9c
    db $9d
    db $e1
    db $00
    db $80
    db $9b
    db $04
    db $a0
    db $28
    db $28
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat697F::
    db $9d
    db $7d
    db $00
    db $80
    db $a1
    db $74
    db $14
    db $01
    db $74
    db $01
    db $14
    db $74
    db $01
    db $0a
    db $74
    db $01
    db $01
    db $74
    db $01
    db $01
    db $74
    db $01
    db $10
    db $74
    db $01
    db $06
    db $74
    db $01
    db $01
    db $74
    db $18
    db $01
    db $74
    db $01
    db $06
    db $74
    db $01
    db $00

; I: note pattern ($00 ends it)
Song01_Title_Pat69A5::
    db $9d
    db $05
    db $52
    db $20
    db $a0
    db $38
    db $01
    db $38
    db $01
    db $a1
    db $01
    db $38
    db $01
    db $a0
    db $32
    db $01
    db $3a
    db $01
    db $a1
    db $01
    db $40
    db $01
    db $01
    db $9b
    db $05
    db $a0
    db $01
    db $ab
    db $5e
    db $ac
    db $01
    db $9c
    db $a3
    db $01
    db $a0
    db $4c
    db $01
    db $56
    db $01
    db $4c
    db $01
    db $2e
    db $01
    db $a1
    db $01
    db $01
    db $46
    db $2e
    db $01
    db $a0
    db $46
    db $48
    db $a2
    db $01
    db $a0
    db $38
    db $01
    db $38
    db $01
    db $a1
    db $01
    db $38
    db $01
    db $a0
    db $32
    db $01
    db $3a
    db $01
    db $a1
    db $01
    db $40
    db $01
    db $01
    db $9b
    db $05
    db $ab
    db $4a
    db $ac
    db $01
    db $a0
    db $54
    db $9c
    db $9b
    db $06
    db $ab
    db $01
    db $80
    db $9c
    db $a1
    db $01
    db $ad
    db $66
    db $01
    db $6e
    db $01
    db $74
    db $01
    db $6e
    db $01
    db $66
    db $01
    db $01
    db $01
    db $a0
    db $76
    db $78
    db $a2
    db $01
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat6A12::
    db $9b
    db $04
    db $a5
    db $01
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat6A19::
    db $9b
    db $02
    db $a1
    db $01
    db $06
    db $a0
    db $06
    db $06
    db $a1
    db $06
    db $01
    db $06
    db $01
    db $a0
    db $06
    db $06
    db $06
    db $06
    db $a1
    db $10
    db $06
    db $01
    db $01
    db $06
    db $0b
    db $06
    db $9c
    db $9b
    db $08
    db $a1
    db $06
    db $01
    db $01
    db $10
    db $9c
    db $9b
    db $04
    db $a0
    db $06
    db $06
    db $a1
    db $01
    db $06
    db $0b
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat6A47::
    db $a5
    db $01
    db $01
    db $00

; I: header of song id 35
Song35_RecordHiScore_Hdr::
    db $00
    db $8b
    db $41
    db $56
    db $6a
    db $5c
    db $6a
    db $62
    db $6a
    db $68
    db $6a

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk1List::
    db $6e
    db $6a
    db $ff
    db $ff
    db $56
    db $6a

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk2List::
    db $8c
    db $6a
    db $ff
    db $ff
    db $5c
    db $6a

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk3List::
    db $a6
    db $6a
    db $ff
    db $ff
    db $62
    db $6a

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk4List::
    db $c4
    db $6a
    db $ff
    db $ff
    db $68
    db $6a

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6A6E::
    db $9d
    db $6c
    db $00
    db $81
    db $a9
    db $3a
    db $40
    db $4a
    db $3a
    db $40
    db $4a
    db $3c
    db $42
    db $4e
    db $3c
    db $42
    db $4e
    db $40
    db $4a
    db $52
    db $40
    db $4a
    db $52
    db $42
    db $4a
    db $54
    db $42
    db $4a
    db $54
    db $00

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6A8C::
    db $9d
    db $8c
    db $00
    db $81
    db $9b
    db $03
    db $a9
    db $40
    db $58
    db $9c
    db $9b
    db $03
    db $3c
    db $54
    db $9c
    db $9b
    db $03
    db $3a
    db $52
    db $9c
    db $9b
    db $03
    db $36
    db $4e
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6AA6::
    db $9d
    db $22
    db $41
    db $20
    db $a9
    db $4a
    db $4e
    db $52
    db $4a
    db $52
    db $58
    db $a3
    db $46
    db $a9
    db $4e
    db $54
    db $5a
    db $a3
    db $44
    db $a9
    db $52
    db $58
    db $62
    db $a3
    db $42
    db $a9
    db $54
    db $5a
    db $62
    db $00

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6AC4::
    db $a3
    db $15
    db $0b
    db $1a
    db $1a
    db $00

; I: header of song id 03
Song03_CreditsReal_Hdr::
    db $fc
    db $9b
    db $41
    db $d5
    db $6a
    db $e5
    db $6a
    db $f3
    db $6a
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song03_CreditsReal_Trk1List::
    db $45
    db $6b
    db $fd
    db $6a
    db $0c
    db $6b
    db $02
    db $6b
    db $0c
    db $6b
    db $07
    db $6b
    db $0c
    db $6b
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song03_CreditsReal_Trk2List::
    db $62
    db $6b
    db $14
    db $6b
    db $23
    db $6b
    db $19
    db $6b
    db $23
    db $6b
    db $1e
    db $6b
    db $23
    db $6b

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song03_CreditsReal_Trk3List::
    db $78
    db $6b
    db $2e
    db $6b
    db $38
    db $6b
    db $33
    db $6b
    db $38
    db $6b

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6AFD::
    db $9d
    db $94
    db $00
    db $81
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B02::
    db $9d
    db $55
    db $00
    db $81
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B07::
    db $9d
    db $20
    db $00
    db $81
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B0C::
    db $a3
    db $32
    db $3c
    db $40
    db $44
    db $48
    db $4a
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B14::
    db $9d
    db $9c
    db $00
    db $81
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B19::
    db $9d
    db $4d
    db $00
    db $81
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B1E::
    db $9d
    db $20
    db $00
    db $81
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B23::
    db $a4
    db $52
    db $a6
    db $4e
    db $a1
    db $4a
    db $a4
    db $5c
    db $a3
    db $40
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B2E::
    db $9d
    db $f2
    db $40
    db $21
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B33::
    db $9d
    db $f2
    db $40
    db $41
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B38::
    db $a8
    db $4a
    db $a3
    db $54
    db $58
    db $5c
    db $a8
    db $4a
    db $a3
    db $54
    db $a4
    db $5c
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B45::
    db $9d
    db $80
    db $00
    db $81
    db $a3
    db $40
    db $4a
    db $a4
    db $40
    db $a3
    db $3a
    db $3c
    db $40
    db $36
    db $a2
    db $32
    db $36
    db $3a
    db $3c
    db $30
    db $32
    db $36
    db $3a
    db $a3
    db $3c
    db $42
    db $48
    db $3c
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B62::
    db $9d
    db $9c
    db $00
    db $81
    db $a4
    db $52
    db $a3
    db $4e
    db $52
    db $a4
    db $4a
    db $a3
    db $48
    db $40
    db $44
    db $4a
    db $58
    db $4a
    db $a4
    db $52
    db $4e
    db $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B78::
    db $9d
    db $f2
    db $40
    db $21
    db $a4
    db $4a
    db $48
    db $44
    db $40
    db $3c
    db $3a
    db $36
    db $40
    db $00

; I: header of song id 07
Song07_ShootIntroB_Hdr::
    db $00
    db $9b
    db $41
    db $91
    db $6b
    db $9d
    db $6b
    db $a5
    db $6b
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song07_ShootIntroB_Trk1List::
    db $51
    db $6c
    db $ad
    db $6b
    db $51
    db $7e
    db $39
    db $7e
    db $ff
    db $ff
    db $97
    db $6b

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song07_ShootIntroB_Trk2List::
    db $78
    db $6c
    db $35
    db $7e
    db $ff
    db $ff
    db $9f
    db $6b

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song07_ShootIntroB_Trk3List::
    db $8a
    db $6c
    db $58
    db $7e
    db $ff
    db $ff
    db $a7
    db $6b

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6BAD::
    db $9e
    db $8b
    db $41
    db $00

; I: header of song id 05
Song05_MainMenu_Hdr::
    db $00
    db $9b
    db $41
    db $bc
    db $6b
    db $c2
    db $6b
    db $c8
    db $6b
    db $d0
    db $6b

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk1List::
    db $d6
    db $6b
    db $ff
    db $ff
    db $bc
    db $6b

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk2List::
    db $ea
    db $6b
    db $ff
    db $ff
    db $c2
    db $6b

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk3List::
    db $03
    db $6c
    db $16
    db $6c
    db $ff
    db $ff
    db $ca
    db $6b

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk4List::
    db $1c
    db $6c
    db $ff
    db $ff
    db $d0
    db $6b

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6BD6::
    db $9d
    db $80
    db $00
    db $40
    db $9b
    db $02
    db $a7
    db $10
    db $a2
    db $0a
    db $10
    db $0a
    db $a3
    db $10
    db $1e
    db $1e
    db $a4
    db $14
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6BEA::
    db $9d
    db $51
    db $00
    db $80
    db $a2
    db $70
    db $70
    db $58
    db $58
    db $70
    db $70
    db $58
    db $58
    db $01
    db $a1
    db $70
    db $70
    db $a2
    db $58
    db $58
    db $70
    db $70
    db $58
    db $70
    db $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6C03::
    db $9d
    db $42
    db $41
    db $a0
    db $a2
    db $6e
    db $66
    db $a8
    db $01
    db $a2
    db $6a
    db $62
    db $a7
    db $01
    db $a2
    db $62
    db $6a
    db $70
    db $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6C16::
    db $9b
    db $04
    db $a5
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6C1C::
    db $a2
    db $15
    db $01
    db $06
    db $06
    db $01
    db $06
    db $01
    db $06
    db $00

; I: header of song id 06
Song06_ShootIntroA_Hdr::
    db $fa
    db $9b
    db $41
    db $31
    db $6c
    db $39
    db $6c
    db $43
    db $6c
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song06_ShootIntroA_Trk1List::
    db $51
    db $6c
    db $5c
    db $6c
    db $ff
    db $ff
    db $33
    db $6c

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song06_ShootIntroA_Trk2List::
    db $78
    db $6c
    db $83
    db $6c
    db $60
    db $6c
    db $ff
    db $ff
    db $3d
    db $6c

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song06_ShootIntroA_Trk3List::
    db $8a
    db $6c
    db $95
    db $6c
    db $ff
    db $ff
    db $45
    db $6c
    db $9b
    db $04
    db $a5
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6C51::
    db $9d
    db $80
    db $00
    db $41
    db $a1
    db $56
    db $40
    db $42
    db $a7
    db $44
    db $00

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C5C::
    db $9d
    db $a7
    db $00
    db $81

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C60::
    db $9b
    db $02
    db $a2
    db $28
    db $36
    db $44
    db $46
    db $4e
    db $28
    db $44
    db $46
    db $9c
    db $9b
    db $02
    db $24
    db $36
    db $44
    db $46
    db $4e
    db $24
    db $44
    db $46
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6C78::
    db $9d
    db $80
    db $00
    db $40
    db $a1
    db $36
    db $38
    db $3a
    db $a7
    db $3c
    db $00

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C83::
    db $9d
    db $40
    db $00
    db $80
    db $aa
    db $01
    db $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6C8A::
    db $9d
    db $22
    db $41
    db $21
    db $a1
    db $5a
    db $5c
    db $5e
    db $a7
    db $60
    db $00

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C95::
    db $9d
    db $22
    db $41
    db $21
    db $a5
    db $28
    db $28
    db $24
    db $24
    db $00

; I: header of song id 20
Song20_SlideShowInit_Hdr::
    db $00
    db $82
    db $41
    db $aa
    db $6c
    db $b0
    db $6c
    db $b6
    db $6c
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song20_SlideShowInit_Trk1List::
    db $bc
    db $6c
    db $ff
    db $ff
    db $aa
    db $6c

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song20_SlideShowInit_Trk2List::
    db $cd
    db $6c
    db $ff
    db $ff
    db $b0
    db $6c

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song20_SlideShowInit_Trk3List::
    db $de
    db $6c
    db $ff
    db $ff
    db $b6
    db $6c

; C: note pattern ($00 ends it)
Song20_SlideShowInit_Pat6CBC::
    db $9d
    db $71
    db $00
    db $00
    db $9b
    db $03
    db $a2
    db $02
    db $01
    db $02
    db $02
    db $9c
    db $06
    db $06
    db $0a
    db $0a
    db $00

; C: note pattern ($00 ends it)
Song20_SlideShowInit_Pat6CCD::
    db $9d
    db $71
    db $00
    db $40
    db $a2
    db $6a
    db $70
    db $6a
    db $70
    db $6a
    db $a1
    db $70
    db $70
    db $a2
    db $6a
    db $70
    db $00

; C: note pattern ($00 ends it)
Song20_SlideShowInit_Pat6CDE::
    db $9d
    db $f2
    db $40
    db $20
    db $9b
    db $03
    db $a2
    db $1a
    db $01
    db $1a
    db $1a
    db $9c
    db $a3
    db $1e
    db $22
    db $00

; I: header of song id 09
Song09_SlideMenu_Hdr::
    db $00
    db $82
    db $41
    db $f9
    db $6c
    db $ff
    db $6c
    db $05
    db $6d
    db $0b
    db $6d

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk1List::
    db $39
    db $6d
    db $ff
    db $ff
    db $f9
    db $6c

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk2List::
    db $5e
    db $6d
    db $ff
    db $ff
    db $ff
    db $6c

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk3List::
    db $83
    db $6d
    db $ff
    db $ff
    db $05
    db $6d

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk4List::
    db $9e
    db $6d
    db $ff
    db $ff
    db $0b
    db $6d
    db $9d
    db $61
    db $00
    db $80
    db $9b
    db $07
    db $a0
    db $46
    db $01
    db $9c
    db $00
    db $9d
    db $81
    db $00
    db $80
    db $9b
    db $07
    db $a0
    db $50
    db $01
    db $9c
    db $00
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $07
    db $a0
    db $58
    db $01
    db $9c
    db $00
    db $9b
    db $07
    db $a0
    db $0b
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D39::
    db $9d
    db $c1
    db $00
    db $00
    db $a2
    db $02
    db $40
    db $28
    db $4e
    db $a1
    db $72
    db $74
    db $76
    db $78
    db $7a
    db $78
    db $76
    db $74
    db $9d
    db $51
    db $00
    db $80
    db $a2
    db $32
    db $40
    db $28
    db $4a
    db $a1
    db $72
    db $74
    db $76
    db $78
    db $7a
    db $78
    db $76
    db $74
    db $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D5E::
    db $9d
    db $d1
    db $00
    db $00
    db $a2
    db $1a
    db $52
    db $10
    db $60
    db $a1
    db $70
    db $72
    db $74
    db $76
    db $78
    db $76
    db $74
    db $72
    db $9d
    db $61
    db $00
    db $80
    db $a2
    db $1a
    db $52
    db $10
    db $52
    db $a1
    db $70
    db $72
    db $74
    db $76
    db $78
    db $76
    db $74
    db $72
    db $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D83::
    db $9d
    db $22
    db $41
    db $20
    db $a2
    db $01
    db $52
    db $54
    db $52
    db $54
    db $52
    db $54
    db $01
    db $9d
    db $22
    db $41
    db $40
    db $a2
    db $01
    db $52
    db $54
    db $52
    db $54
    db $52
    db $54
    db $01
    db $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D9E::
    db $9b
    db $08
    db $a1
    db $15
    db $06
    db $a2
    db $0b
    db $a1
    db $1a
    db $06
    db $a2
    db $0b
    db $9c
    db $00

; I: header of song id 0A
Song0A_Doodle_Hdr::
    db $00
    db $8b
    db $41
    db $b7
    db $6d
    db $bd
    db $6d
    db $c3
    db $6d
    db $c9
    db $6d

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk1List::
    db $cf
    db $6d
    db $ff
    db $ff
    db $b7
    db $6d

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk2List::
    db $03
    db $6e
    db $ff
    db $ff
    db $bd
    db $6d

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk3List::
    db $20
    db $6e
    db $ff
    db $ff
    db $c3
    db $6d

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk4List::
    db $39
    db $6e
    db $ff
    db $ff
    db $c9
    db $6d

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6DCF::
    db $9d
    db $e2
    db $00
    db $00
    db $a2
    db $02
    db $02
    db $01
    db $02
    db $02
    db $02
    db $01
    db $01
    db $9d
    db $72
    db $00
    db $00
    db $a2
    db $02
    db $02
    db $01
    db $02
    db $02
    db $02
    db $01
    db $01
    db $9d
    db $c2
    db $00
    db $00
    db $a2
    db $02
    db $02
    db $01
    db $02
    db $02
    db $02
    db $01
    db $01
    db $9d
    db $41
    db $00
    db $00
    db $0c
    db $0c
    db $10
    db $14
    db $18
    db $01
    db $a9
    db $26
    db $00

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6E03::
    db $9d
    db $d2
    db $00
    db $00
    db $9b
    db $03
    db $a2
    db $1a
    db $1a
    db $01
    db $1a
    db $1a
    db $1a
    db $01
    db $01
    db $9c
    db $9d
    db $32
    db $00
    db $00
    db $01
    db $24
    db $01
    db $2c
    db $01
    db $01
    db $a9
    db $10
    db $00

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6E20::
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $03
    db $a2
    db $1a
    db $1a
    db $01
    db $3a
    db $01
    db $3a
    db $01
    db $01
    db $9c
    db $24
    db $24
    db $28
    db $2c
    db $30
    db $01
    db $a9
    db $3a
    db $00

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6E39::
    db $9b
    db $10
    db $a2
    db $0b
    db $0b
    db $15
    db $15
    db $9c
    db $00

; I: header of song id 0B
Song0B_Edit_Hdr::
    db $00
    db $b3
    db $41
    db $4d
    db $6e
    db $53
    db $6e
    db $59
    db $6e
    db $5f
    db $6e

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk1List::
    db $65
    db $6e
    db $ff
    db $ff
    db $4d
    db $6e

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk2List::
    db $77
    db $6e
    db $ff
    db $ff
    db $53
    db $6e

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk3List::
    db $8f
    db $6e
    db $ff
    db $ff
    db $59
    db $6e

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk4List::
    db $9e
    db $6e
    db $ff
    db $ff
    db $5f
    db $6e

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E65::
    db $9d
    db $91
    db $00
    db $40
    db $a5
    db $01
    db $9b
    db $02
    db $a2
    db $01
    db $52
    db $01
    db $52
    db $01
    db $a4
    db $52
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E77::
    db $9d
    db $e0
    db $00
    db $01
    db $a3
    db $0a
    db $06
    db $02
    db $01
    db $a3
    db $0c
    db $0a
    db $06
    db $01
    db $a3
    db $02
    db $06
    db $0a
    db $01
    db $0e
    db $0e
    db $12
    db $01
    db $00

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E8F::
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $03
    db $a1
    db $01
    db $01
    db $58
    db $01
    db $9c
    db $a3
    db $01
    db $00

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E9E::
    db $9b
    db $08
    db $a1
    db $01
    db $06
    db $0b
    db $01
    db $06
    db $9c
    db $00

; I: header of song id 0C
Song0C_Link_Hdr::
    db $f6
    db $82
    db $41
    db $b3
    db $6e
    db $b9
    db $6e
    db $bf
    db $6e
    db $c7
    db $6e

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk1List::
    db $fb
    db $6e
    db $ff
    db $ff
    db $b3
    db $6e

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk2List::
    db $eb
    db $6e
    db $ff
    db $ff
    db $b9
    db $6e

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk3List::
    db $cf
    db $6e
    db $cf
    db $6e
    db $ff
    db $ff
    db $bf
    db $6e

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk4List::
    db $09
    db $6f
    db $09
    db $6f
    db $ff
    db $ff
    db $c7
    db $6e

; C: note pattern ($00 ends it)
Song0C_Link_Pat6ECF::
    db $9d
    db $32
    db $41
    db $21
    db $a2
    db $7a
    db $82
    db $88
    db $01
    db $a4
    db $88
    db $a2
    db $84
    db $7e
    db $76
    db $01
    db $a4
    db $76
    db $a2
    db $7a
    db $82
    db $7a
    db $01
    db $a4
    db $7a
    db $a5
    db $01
    db $00

; C: note pattern ($00 ends it)
Song0C_Link_Pat6EEB::
    db $9d
    db $e1
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $18
    db $1a
    db $1a
    db $1a
    db $9c
    db $a3
    db $24
    db $22
    db $00

; C: note pattern ($00 ends it)
Song0C_Link_Pat6EFB::
    db $9d
    db $91
    db $00
    db $80
    db $a3
    db $01
    db $4a
    db $01
    db $4a
    db $01
    db $4a
    db $01
    db $46
    db $00

; C: note pattern ($00 ends it)
Song0C_Link_Pat6F09::
    db $a7
    db $15
    db $a2
    db $06
    db $a7
    db $06
    db $a2
    db $06
    db $a7
    db $1a
    db $a2
    db $06
    db $a7
    db $06
    db $a2
    db $06
    db $a7
    db $15
    db $a2
    db $06
    db $a7
    db $06
    db $a2
    db $06
    db $a7
    db $1a
    db $a2
    db $01
    db $a7
    db $01
    db $a2
    db $06
    db $00

; I: header of song id 0F
Song0F_PhotoPicker_Hdr::
    db $08
    db $8b
    db $41
    db $35
    db $6f
    db $3d
    db $6f
    db $43
    db $6f
    db $49
    db $6f

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk1List::
    db $67
    db $6f
    db $6a
    db $6f
    db $ff
    db $ff
    db $37
    db $6f

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk2List::
    db $52
    db $6f
    db $ff
    db $ff
    db $3d
    db $6f

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk3List::
    db $7f
    db $6f
    db $ff
    db $ff
    db $43
    db $6f

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk4List::
    db $97
    db $6f
    db $ff
    db $ff
    db $49
    db $6f
    db $aa
    db $01
    db $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F52::
    db $9d
    db $d1
    db $00
    db $80
    db $9b
    db $02
    db $a3
    db $10
    db $01
    db $10
    db $28
    db $9c
    db $9b
    db $02
    db $a3
    db $1a
    db $01
    db $1a
    db $32
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F67::
    db $aa
    db $01
    db $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F6A::
    db $9d
    db $a2
    db $00
    db $40
    db $9b
    db $02
    db $a3
    db $06
    db $1e
    db $01
    db $36
    db $9c
    db $9b
    db $02
    db $a3
    db $1e
    db $36
    db $01
    db $4e
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F7F::
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $02
    db $a6
    db $52
    db $a1
    db $01
    db $a6
    db $3a
    db $a1
    db $01
    db $a6
    db $60
    db $a1
    db $01
    db $a6
    db $3a
    db $a1
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F97::
    db $9b
    db $02
    db $a3
    db $15
    db $15
    db $01
    db $01
    db $9c
    db $9b
    db $02
    db $a3
    db $15
    db $01
    db $15
    db $01
    db $9c
    db $00

; I: header of song id 12
Song12_Hdr::
    db $02
    db $8b
    db $41
    db $b3
    db $6f
    db $bb
    db $6f
    db $c3
    db $6f
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song12_Trk1List::
    db $cb
    db $6f
    db $d4
    db $6f
    db $ff
    db $ff
    db $b5
    db $6f

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song12_Trk2List::
    db $f7
    db $6f
    db $ff
    db $6f
    db $ff
    db $ff
    db $bd
    db $6f

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song12_Trk3List::
    db $22
    db $70
    db $29
    db $70
    db $ff
    db $ff
    db $c5
    db $6f

; C: note pattern ($00 ends it)
Song12_Pat6FCB::
    db $9d
    db $a1
    db $00
    db $80
    db $a0
    db $01
    db $ab
    db $01
    db $00

; C: note pattern ($00 ends it)
Song12_Pat6FD4::
    db $9d
    db $63
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $10
    db $01
    db $16
    db $12
    db $01
    db $0c
    db $9c
    db $10
    db $01
    db $1c
    db $a7
    db $36
    db $9b
    db $03
    db $a2
    db $10
    db $01
    db $16
    db $12
    db $01
    db $0c
    db $9c
    db $10
    db $01
    db $01
    db $a7
    db $02
    db $00

; C: note pattern ($00 ends it)
Song12_Pat6FF7::
    db $9d
    db $c1
    db $00
    db $80
    db $a0
    db $01
    db $00
    db $00

; C: note pattern ($00 ends it)
Song12_Pat6FFF::
    db $9d
    db $c1
    db $00
    db $80
    db $9b
    db $03
    db $a2
    db $28
    db $01
    db $2e
    db $2a
    db $01
    db $24
    db $9c
    db $28
    db $01
    db $34
    db $a7
    db $34
    db $9b
    db $03
    db $a2
    db $28
    db $01
    db $2e
    db $2a
    db $01
    db $24
    db $9c
    db $28
    db $01
    db $01
    db $a7
    db $1a
    db $00

; C: note pattern ($00 ends it)
Song12_Pat7022::
    db $9d
    db $22
    db $41
    db $20
    db $a0
    db $01
    db $00

; C: note pattern ($00 ends it)
Song12_Pat7029::
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $03
    db $a2
    db $28
    db $01
    db $2e
    db $2a
    db $01
    db $24
    db $9c
    db $28
    db $01
    db $34
    db $a7
    db $34
    db $9b
    db $03
    db $a2
    db $28
    db $01
    db $2e
    db $2a
    db $01
    db $24
    db $9c
    db $28
    db $01
    db $01
    db $a7
    db $1a
    db $00

; I: header of song id 13 = 4th entry of the animation list 03:61FD (BGM 04 in the jofamo article); the Japanese ROM
; requests it only from the animation / hot-spot pickers, the international RUN! RUN! RUN! title does ($DD68 = $13;
; the Japanese one asks for $3C; BGB, README 16.27)
Song13_Hdr::
    db $00
    db $76
    db $41
    db $ab
    db $75
    db $bd
    db $75
    db $c5
    db $75
    db $d7
    db $75

; I: header of song id 23
Song23_AnimTools_Hdr::
    db $00
    db $8b
    db $41
    db $62
    db $70
    db $68
    db $70
    db $6e
    db $70
    db $74
    db $70

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk1List::
    db $7a
    db $70
    db $ff
    db $ff
    db $62
    db $70

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk2List::
    db $aa
    db $70
    db $ff
    db $ff
    db $68
    db $70

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk3List::
    db $c7
    db $70
    db $ff
    db $ff
    db $6e
    db $70

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk4List::
    db $f3
    db $70
    db $ff
    db $ff
    db $74
    db $70

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat707A::
    db $9d
    db $71
    db $00
    db $80
    db $a2
    db $01
    db $70
    db $70
    db $7a
    db $88
    db $62
    db $62
    db $01
    db $62
    db $70
    db $7a
    db $7a
    db $70
    db $7a
    db $62
    db $62
    db $a2
    db $01
    db $70
    db $70
    db $a1
    db $7a
    db $7a
    db $a2
    db $88
    db $62
    db $62
    db $01
    db $62
    db $a1
    db $70
    db $70
    db $a2
    db $7a
    db $7a
    db $70
    db $7a
    db $a1
    db $62
    db $70
    db $a2
    db $62
    db $00

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat70AA::
    db $9d
    db $e1
    db $00
    db $80
    db $a4
    db $02
    db $02
    db $a2
    db $10
    db $10
    db $10
    db $10
    db $a4
    db $10
    db $a4
    db $02
    db $a7
    db $02
    db $a2
    db $02
    db $0c
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $00

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat70C7::
    db $9d
    db $22
    db $41
    db $41
    db $9b
    db $02
    db $a3
    db $01
    db $4a
    db $52
    db $4a
    db $a4
    db $46
    db $a3
    db $40
    db $46
    db $a4
    db $4a
    db $40
    db $01
    db $01
    db $a3
    db $01
    db $4a
    db $52
    db $4a
    db $a4
    db $46
    db $a3
    db $40
    db $46
    db $a5
    db $4a
    db $a4
    db $01
    db $01
    db $9c
    db $9b
    db $04
    db $a5
    db $01
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat70F3::
    db $a3
    db $15
    db $06
    db $1a
    db $06
    db $15
    db $0b
    db $1a
    db $a2
    db $06
    db $a1
    db $06
    db $06
    db $00

; I: header of song id 33
Song33_Hdr::
    db $02
    db $8b
    db $41
    db $0c
    db $71
    db $12
    db $71
    db $18
    db $71
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song33_Trk1List::
    db $1e
    db $71
    db $ff
    db $ff
    db $0c
    db $71

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song33_Trk2List::
    db $27
    db $71
    db $ff
    db $ff
    db $12
    db $71

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song33_Trk3List::
    db $30
    db $71
    db $ff
    db $ff
    db $18
    db $71

; C: note pattern ($00 ends it)
Song33_Pat711E::
    db $9d
    db $a2
    db $00
    db $80
    db $a7
    db $8e
    db $8e
    db $8e
    db $00

; C: note pattern ($00 ends it)
Song33_Pat7127::
    db $9d
    db $91
    db $00
    db $80
    db $a7
    db $78
    db $78
    db $78
    db $00

; C: note pattern ($00 ends it)
Song33_Pat7130::
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $02
    db $ad
    db $4a
    db $01
    db $ab
    db $90
    db $88
    db $ab
    db $58
    db $70
    db $58
    db $70
    db $ab
    db $7c
    db $84
    db $a2
    db $52
    db $58
    db $9c
    db $9b
    db $02
    db $ab
    db $4a
    db $62
    db $4a
    db $62
    db $ad
    db $01
    db $a2
    db $58
    db $ab
    db $01
    db $54
    db $01
    db $54
    db $ab
    db $7c
    db $60
    db $a9
    db $58
    db $ad
    db $01
    db $9c
    db $00

; I: header of song id 32. Owner (review page, 2026-10-13, by ear): music 32: used - Space fever main theme during
; gameplay; NOT the same as the name, which comes from the callers SpaceFever_Boss_EndA (2 static callers): the owner
; hears the main theme, the callers sit at the boss end; name kept, to be ...
Song32_SpaceFeverBossEnd_Hdr::
    db $00
    db $8b
    db $41
    db $72
    db $71
    db $6c
    db $71
    db $78
    db $71
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song32_SpaceFeverBossEnd_Trk2List::
    db $7e
    db $71
    db $ff
    db $ff
    db $39
    db $73

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song32_SpaceFeverBossEnd_Trk1List::
    db $8b
    db $71
    db $ff
    db $ff
    db $41
    db $73

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song32_SpaceFeverBossEnd_Trk3List::
    db $98
    db $71
    db $ff
    db $ff
    db $49
    db $73

; C: note pattern ($00 ends it)
Song32_SpaceFeverBossEnd_Pat717E::
    db $9d
    db $d0
    db $00
    db $81
    db $a1
    db $58
    db $5a
    db $5c
    db $5e
    db $60
    db $a4
    db $62
    db $00

; C: note pattern ($00 ends it)
Song32_SpaceFeverBossEnd_Pat718B::
    db $9d
    db $e0
    db $00
    db $41
    db $a1
    db $1e
    db $20
    db $22
    db $24
    db $26
    db $a4
    db $28
    db $00

; C: note pattern ($00 ends it)
Song32_SpaceFeverBossEnd_Pat7198::
    db $9d
    db $f2
    db $40
    db $20
    db $a1
    db $60
    db $62
    db $64
    db $66
    db $68
    db $a4
    db $6a
    db $00

; I: header of song id 1D
Song1D_Hdr::
    db $fa
    db $8b
    db $41
    db $b0
    db $71
    db $b6
    db $71
    db $bc
    db $71
    db $c2
    db $71

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk1List::
    db $c8
    db $71
    db $ff
    db $ff
    db $b0
    db $71

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk2List::
    db $d3
    db $71
    db $ff
    db $ff
    db $b6
    db $71

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk3List::
    db $de
    db $71
    db $ff
    db $ff
    db $bc
    db $71

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk4List::
    db $e9
    db $71
    db $ff
    db $ff
    db $c2
    db $71

; C: note pattern ($00 ends it)
Song1D_Pat71C8::
    db $9d
    db $e3
    db $00
    db $40
    db $9b
    db $04
    db $a3
    db $10
    db $12
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song1D_Pat71D3::
    db $9d
    db $e1
    db $00
    db $40
    db $9b
    db $04
    db $a3
    db $1e
    db $20
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song1D_Pat71DE::
    db $9d
    db $22
    db $41
    db $20
    db $9b
    db $04
    db $a3
    db $28
    db $2a
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song1D_Pat71E9::
    db $9b
    db $04
    db $a3
    db $15
    db $15
    db $9c
    db $00

; I: header of song id 16
Song16_FactoryDiag_Hdr::
    db $f6
    db $6b
    db $41
    db $fb
    db $71
    db $ff
    db $71
    db $01
    db $72
    db $03
    db $72

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk1List::
    db $05
    db $72
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk2List::
    db $3c
    db $72

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk3List::
    db $6f
    db $72

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk4List::
    db $a3
    db $72

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat7205::
    db $9d
    db $60
    db $00
    db $81
    db $a3
    db $3c
    db $a1
    db $3c
    db $01
    db $3c
    db $01
    db $3c
    db $01
    db $a2
    db $01
    db $a3
    db $3c
    db $32
    db $3c
    db $a3
    db $40
    db $a1
    db $40
    db $01
    db $40
    db $01
    db $40
    db $01
    db $a2
    db $01
    db $a3
    db $40
    db $36
    db $40
    db $9d
    db $90
    db $00
    db $81
    db $a8
    db $50
    db $a3
    db $50
    db $50
    db $50
    db $a8
    db $54
    db $a4
    db $54
    db $a3
    db $54
    db $a5
    db $58
    db $a4
    db $01
    db $00

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat723C::
    db $9d
    db $a0
    db $00
    db $81
    db $a3
    db $5c
    db $a1
    db $5c
    db $01
    db $5c
    db $01
    db $5c
    db $01
    db $a2
    db $01
    db $a3
    db $5c
    db $54
    db $5c
    db $a3
    db $60
    db $a1
    db $60
    db $01
    db $60
    db $01
    db $60
    db $01
    db $a2
    db $01
    db $a3
    db $60
    db $58
    db $60
    db $a8
    db $62
    db $a3
    db $62
    db $62
    db $62
    db $a8
    db $66
    db $a4
    db $66
    db $a3
    db $66
    db $a5
    db $6a
    db $a4
    db $01
    db $00

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat726F::
    db $9d
    db $22
    db $41
    db $21
    db $a3
    db $54
    db $a1
    db $54
    db $01
    db $54
    db $01
    db $54
    db $01
    db $a2
    db $01
    db $a3
    db $54
    db $4a
    db $54
    db $a3
    db $58
    db $a1
    db $58
    db $01
    db $58
    db $01
    db $58
    db $01
    db $a2
    db $01
    db $a3
    db $58
    db $4e
    db $58
    db $a3
    db $42
    db $38
    db $42
    db $4a
    db $42
    db $32
    db $5e
    db $3c
    db $46
    db $4e
    db $46
    db $4e
    db $a5
    db $62
    db $a4
    db $01
    db $00

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat72A3::
    db $9b
    db $02
    db $a3
    db $0b
    db $a2
    db $0b
    db $0b
    db $0b
    db $01
    db $a3
    db $0b
    db $0b
    db $0b
    db $9c
    db $9b
    db $06
    db $a1
    db $0b
    db $0b
    db $9c
    db $a3
    db $15
    db $15
    db $15
    db $9b
    db $06
    db $a1
    db $0b
    db $0b
    db $9c
    db $a3
    db $15
    db $01
    db $15
    db $9b
    db $08
    db $a1
    db $0b
    db $0b
    db $9c
    db $a4
    db $01
    db $00

; I: header of song id 17
Song17_Hdr::
    db $00
    db $aa
    db $41
    db $d9
    db $72
    db $df
    db $72
    db $e5
    db $72
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song17_Trk1List::
    db $eb
    db $72
    db $ff
    db $ff
    db $d9
    db $72

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song17_Trk2List::
    db $f3
    db $72
    db $ff
    db $ff
    db $df
    db $72

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song17_Trk3List::
    db $fb
    db $72
    db $ff
    db $ff
    db $e5
    db $72

; C: note pattern ($00 ends it)
Song17_Pat72EB::
    db $9d
    db $e0
    db $00
    db $81
    db $a5
    db $12
    db $12
    db $00

; C: note pattern ($00 ends it)
Song17_Pat72F3::
    db $9d
    db $e0
    db $00
    db $81
    db $a5
    db $08
    db $0c
    db $00

; C: note pattern ($00 ends it)
Song17_Pat72FB::
    db $9d
    db $22
    db $41
    db $21
    db $a5
    db $1a
    db $1a
    db $1a
    db $24
    db $28
    db $1a
    db $1a
    db $1a
    db $00

; I: header of song id 2B
Song2B_BallGameOver_Hdr::
    db $00
    db $8b
    db $41
    db $14
    db $73
    db $18
    db $73
    db $00
    db $00
    db $1a
    db $73

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2B_BallGameOver_Trk1List::
    db $1c
    db $73
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2B_BallGameOver_Trk2List::
    db $23
    db $73

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song2B_BallGameOver_Trk4List::
    db $2a
    db $73

; C: note pattern ($00 ends it)
Song2B_BallGameOver_Pat731C::
    db $9d
    db $f1
    db $00
    db $c0
    db $a3
    db $16
    db $00

; C: note pattern ($00 ends it)
Song2B_BallGameOver_Pat7323::
    db $9d
    db $f1
    db $00
    db $00
    db $a3
    db $14
    db $00

; C: note pattern ($00 ends it)
Song2B_BallGameOver_Pat732A::
    db $a3
    db $0b

; I: header of song id 31
Song31_SpaceFeverStart_Hdr::
    db $00
    db $8b
    db $41
    db $37
    db $73
    db $3f
    db $73
    db $47
    db $73
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song31_SpaceFeverStart_Trk1List::
    db $4f
    db $73
    db $9f
    db $73
    db $ff
    db $ff
    db $39
    db $73

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song31_SpaceFeverStart_Trk2List::
    db $61
    db $73
    db $83
    db $73
    db $ff
    db $ff
    db $41
    db $73

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song31_SpaceFeverStart_Trk3List::
    db $72
    db $73
    db $a9
    db $73
    db $ff
    db $ff
    db $49
    db $73

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat734F::
    db $9d
    db $e0
    db $00
    db $00
    db $a6
    db $36
    db $a1
    db $36
    db $36
    db $36
    db $a6
    db $32
    db $3c
    db $40
    db $01
    db $01
    db $00
    db $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7361::
    db $9d
    db $e0
    db $00
    db $00
    db $a6
    db $30
    db $a1
    db $30
    db $30
    db $30
    db $a6
    db $2c
    db $32
    db $36
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7372::
    db $9d
    db $22
    db $41
    db $a0
    db $a6
    db $40
    db $a1
    db $40
    db $40
    db $40
    db $a6
    db $40
    db $40
    db $40
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7383::
    db $9d
    db $b0
    db $00
    db $80
    db $9b
    db $04
    db $a1
    db $1a
    db $18
    db $16
    db $14
    db $12
    db $10
    db $0e
    db $0c
    db $0a
    db $06
    db $9c
    db $9b
    db $06
    db $1a
    db $1c
    db $1e
    db $20
    db $22
    db $9c
    db $00
    db $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat739F::
    db $9d
    db $a0
    db $00
    db $80
    db $9b
    db $04
    db $a5
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat73A9::
    db $9d
    db $22
    db $41
    db $c0
    db $a1
    db $88
    db $01
    db $88
    db $01
    db $88
    db $88
    db $01
    db $a5
    db $01
    db $a1
    db $88
    db $88
    db $01
    db $88
    db $01
    db $01
    db $a5
    db $01
    db $01
    db $00
    db $9d
    db $e1
    db $00
    db $80
    db $a2
    db $4a
    db $4a
    db $4a
    db $a4
    db $44
    db $a2
    db $01
    db $4a
    db $4a
    db $46
    db $a4
    db $4a
    db $a2
    db $01
    db $4a
    db $4a
    db $a3
    db $52
    db $4e
    db $4a
    db $3a
    db $a8
    db $3c
    db $00

; I: header of song id 25
Song25_Paint_Hdr::
    db $00
    db $8b
    db $41
    db $ea
    db $73
    db $f6
    db $73
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song25_Paint_Trk1List::
    db $1b
    db $74
    db $fe
    db $73
    db $34
    db $74
    db $fe
    db $73
    db $ff
    db $ff
    db $ea
    db $73

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song25_Paint_Trk2List::
    db $02
    db $74
    db $fe
    db $73
    db $ff
    db $ff
    db $f6
    db $73

; C: note pattern ($00 ends it)
Song25_Paint_Pat73FE::
    db $a5
    db $01
    db $01
    db $00

; C: note pattern ($00 ends it)
Song25_Paint_Pat7402::
    db $9d
    db $81
    db $00
    db $00
    db $a8
    db $4a
    db $a9
    db $4a
    db $4e
    db $52
    db $a8
    db $4e
    db $a3
    db $01
    db $a8
    db $52
    db $a9
    db $4a
    db $4e
    db $52
    db $a8
    db $54
    db $a3
    db $01
    db $00

; C: note pattern ($00 ends it)
Song25_Paint_Pat741B::
    db $9d
    db $21
    db $00
    db $00
    db $a8
    db $62
    db $a9
    db $62
    db $66
    db $6a
    db $a8
    db $66
    db $a3
    db $01
    db $a8
    db $6a
    db $a9
    db $62
    db $66
    db $6a
    db $a8
    db $6c
    db $a3
    db $01
    db $00

; C: note pattern ($00 ends it)
Song25_Paint_Pat7434::
    db $9d
    db $32
    db $00
    db $01
    db $a9
    db $01
    db $01
    db $a8
    db $4a
    db $a9
    db $4a
    db $4e
    db $52
    db $a8
    db $4e
    db $a3
    db $01
    db $a8
    db $52
    db $a9
    db $4a
    db $4e
    db $52
    db $a8
    db $54
    db $a9
    db $01
    db $00

; I: header of song id 24
Song24_Stamp_Hdr::
    db $00
    db $8b
    db $41
    db $5b
    db $74
    db $69
    db $74
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song24_Stamp_Trk1List::
    db $7c
    db $74
    db $fe
    db $73
    db $77
    db $74
    db $80
    db $74
    db $fe
    db $73
    db $ff
    db $ff
    db $5b
    db $74

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song24_Stamp_Trk2List::
    db $97
    db $74
    db $fe
    db $73
    db $77
    db $74
    db $9b
    db $74
    db $fe
    db $73
    db $ff
    db $ff
    db $69
    db $74

; C: note pattern ($00 ends it)
Song24_Stamp_Pat7477::
    db $9d
    db $42
    db $00
    db $c1
    db $00

; C: note pattern ($00 ends it)
Song24_Stamp_Pat747C::
    db $9d
    db $81
    db $00
    db $81

; C: note pattern ($00 ends it)
Song24_Stamp_Pat7480::
    db $a4
    db $3a
    db $a3
    db $3c
    db $3a
    db $3c
    db $a4
    db $40
    db $a3
    db $40
    db $a8
    db $4a
    db $a3
    db $44
    db $40
    db $3c
    db $a4
    db $36
    db $a3
    db $36
    db $a8
    db $3a
    db $00

; C: note pattern ($00 ends it)
Song24_Stamp_Pat7497::
    db $9d
    db $91
    db $00
    db $81

; C: note pattern ($00 ends it)
Song24_Stamp_Pat749B::
    db $a4
    db $32
    db $a3
    db $36
    db $32
    db $36
    db $a4
    db $3a
    db $a3
    db $3a
    db $a8
    db $44
    db $a3
    db $3c
    db $3a
    db $36
    db $a4
    db $30
    db $a3
    db $30
    db $a8
    db $32
    db $00

; I: header of song id 28. Owner (review page, 2026-10-13, by ear): music 28: Who are you running from 1 / error
; message (sure)
Song28_Hdr::
    db $00
    db $82
    db $41
    db $bd
    db $74
    db $c5
    db $74
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song28_Trk1List::
    db $47
    db $7f
    db $eb
    db $72
    db $ff
    db $ff
    db $bf
    db $74

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song28_Trk2List::
    db $3b
    db $7f
    db $f3
    db $72
    db $ff
    db $ff
    db $c7
    db $74

; I: header of song ids 08 0D 1A. Owner (review page, 2026-10-13, by ear): music 08: used - Printer waiting jingle
; during multiple print selection; kept: the name comes from the screens that call ids 08 / 0D / 1A.
Song08_TimerPrintOpt_Hdr::
    db $00
    db $8b
    db $41
    db $0b
    db $75
    db $d8
    db $74
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song08_TimerPrintOpt_Trk2List::
    db $de
    db $74
    db $ff
    db $ff
    db $d8
    db $74

; C: note pattern ($00 ends it)
Song08_TimerPrintOpt_Pat74DE::
    db $9d
    db $81
    db $00
    db $80
    db $a2
    db $3a
    db $3a
    db $36
    db $a3
    db $3a
    db $a2
    db $3c
    db $a5
    db $40
    db $a3
    db $01
    db $a2
    db $3c
    db $3c
    db $3a
    db $a3
    db $3c
    db $a2
    db $40
    db $a5
    db $44
    db $a3
    db $01
    db $a2
    db $40
    db $40
    db $40
    db $40
    db $44
    db $44
    db $44
    db $44
    db $a3
    db $48
    db $48
    db $a5
    db $4a
    db $a4
    db $01
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song08_TimerPrintOpt_Trk1List::
    db $13
    db $75
    db $e2
    db $74
    db $ff
    db $ff
    db $0b
    db $75

; C: note pattern ($00 ends it)
Song08_TimerPrintOpt_Pat7513::
    db $9d
    db $10
    db $00
    db $80
    db $a1
    db $01
    db $00

; I: header of song id 04
Song04_Shutterbug_Hdr::
    db $00
    db $8b
    db $41
    db $25
    db $75
    db $2b
    db $75
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song04_Shutterbug_Trk1List::
    db $31
    db $75
    db $ff
    db $ff
    db $25
    db $75

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song04_Shutterbug_Trk2List::
    db $50
    db $75
    db $ff
    db $ff
    db $2b
    db $75

; C: note pattern ($00 ends it)
Song04_Shutterbug_Pat7531::
    db $9d
    db $e1
    db $00
    db $80
    db $9b
    db $04
    db $a5
    db $01
    db $9c
    db $9b
    db $02
    db $a3
    db $36
    db $3a
    db $a4
    db $3c
    db $9c
    db $a3
    db $36
    db $3a
    db $a2
    db $3c
    db $a4
    db $3a
    db $a2
    db $01
    db $9b
    db $04
    db $36
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song04_Shutterbug_Pat7550::
    db $9d
    db $e1
    db $00
    db $80
    db $9b
    db $02
    db $a3
    db $3c
    db $40
    db $a4
    db $44
    db $9c
    db $a3
    db $3c
    db $40
    db $a2
    db $44
    db $a4
    db $40
    db $9b
    db $04
    db $a2
    db $3c
    db $9c
    db $a7
    db $01
    db $9b
    db $02
    db $a3
    db $3c
    db $40
    db $a4
    db $44
    db $9c
    db $a3
    db $3c
    db $40
    db $a2
    db $44
    db $a4
    db $40
    db $a2
    db $01
    db $9b
    db $04
    db $3c
    db $9c
    db $00

; I: header of song id 27. Owner (review page, 2026-10-13, by ear): music 27: used - jingle during waiting time when
; the game boy printer is busy printing; consistent with the caller Mode1D_State05_SendPrint.
Song27_TransferPrint_Hdr::
    db $00
    db $8b
    db $41
    db $00
    db $00
    db $8b
    db $75
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song27_TransferPrint_Trk2List::
    db $91
    db $75
    db $ff
    db $ff
    db $8b
    db $75

; C: note pattern ($00 ends it)
Song27_TransferPrint_Pat7591::
    db $9d
    db $e1
    db $00
    db $80
    db $a3
    db $32
    db $40
    db $32
    db $40
    db $a2
    db $01
    db $a9
    db $44
    db $44
    db $44
    db $a7
    db $40
    db $a7
    db $44
    db $a2
    db $40
    db $a4
    db $4a
    db $a3
    db $01
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk1List::
    db $df
    db $75
    db $df
    db $75
    db $df
    db $75
    db $f1
    db $75
    db $df
    db $75
    db $ff
    db $75
    db $df
    db $75
    db $ff
    db $ff
    db $ab
    db $75

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk2List::
    db $19
    db $76
    db $23
    db $76
    db $ff
    db $ff
    db $bd
    db $75

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk3List::
    db $aa
    db $76
    db $aa
    db $76
    db $aa
    db $76
    db $bf
    db $76
    db $aa
    db $76
    db $cb
    db $76
    db $aa
    db $76
    db $ff
    db $ff
    db $c5
    db $75

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk4List::
    db $d5
    db $76
    db $e9
    db $76
    db $ff
    db $ff
    db $d7
    db $75

; C: note pattern ($00 ends it)
Song13_Pat75DF::
    db $9d
    db $82
    db $00
    db $40
    db $9b
    db $04
    db $a2
    db $22
    db $14
    db $26
    db $14
    db $a3
    db $28
    db $a2
    db $26
    db $22
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song13_Pat75F1::
    db $9b
    db $04
    db $a2
    db $2c
    db $1e
    db $30
    db $1e
    db $a3
    db $32
    db $a2
    db $30
    db $2c
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song13_Pat75FF::
    db $9b
    db $02
    db $1e
    db $10
    db $22
    db $10
    db $a3
    db $1e
    db $a2
    db $22
    db $10
    db $9c
    db $2c
    db $1e
    db $30
    db $1e
    db $a3
    db $2c
    db $a2
    db $30
    db $10
    db $2c
    db $01
    db $a8
    db $01
    db $00

; C: note pattern ($00 ends it)
Song13_Pat7619::
    db $9d
    db $6a
    db $00
    db $c1
    db $9b
    db $04
    db $a5
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song13_Pat7623::
    db $a2
    db $52
    db $52
    db $01
    db $52
    db $a3
    db $01
    db $4e
    db $a2
    db $4a
    db $44
    db $01
    db $a4
    db $44
    db $a2
    db $01
    db $a3
    db $40
    db $44
    db $44
    db $44
    db $4a
    db $a8
    db $01
    db $a2
    db $01
    db $52
    db $01
    db $a7
    db $52
    db $a3
    db $4e
    db $a2
    db $4a
    db $44
    db $01
    db $a4
    db $44
    db $a2
    db $01
    db $44
    db $44
    db $a3
    db $01
    db $44
    db $44
    db $a2
    db $44
    db $01
    db $a8
    db $01
    db $a2
    db $4e
    db $a7
    db $01
    db $a3
    db $4e
    db $4a
    db $a3
    db $4e
    db $a2
    db $44
    db $44
    db $a4
    db $01
    db $a2
    db $52
    db $01
    db $4e
    db $01
    db $a3
    db $4a
    db $a2
    db $4e
    db $4a
    db $a5
    db $01
    db $a2
    db $52
    db $01
    db $01
    db $a7
    db $52
    db $a3
    db $4e
    db $a2
    db $4a
    db $44
    db $01
    db $a4
    db $44
    db $a2
    db $01
    db $a3
    db $40
    db $44
    db $44
    db $44
    db $44
    db $a8
    db $01
    db $a2
    db $44
    db $44
    db $a3
    db $01
    db $44
    db $a2
    db $44
    db $4a
    db $a5
    db $01
    db $a2
    db $52
    db $01
    db $4e
    db $01
    db $a3
    db $4a
    db $a2
    db $44
    db $44
    db $a4
    db $01
    db $a2
    db $4a
    db $4a
    db $01
    db $44
    db $9b
    db $04
    db $a5
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song13_Pat76AA::
    db $9d
    db $f2
    db $40
    db $a0
    db $a4
    db $2c
    db $22
    db $a7
    db $2c
    db $a2
    db $2c
    db $a4
    db $22
    db $2c
    db $22
    db $a3
    db $2c
    db $22
    db $26
    db $2a
    db $00

; C: note pattern ($00 ends it)
Song13_Pat76BF::
    db $9b
    db $04
    db $a3
    db $1e
    db $a2
    db $01
    db $1e
    db $a3
    db $1e
    db $01
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song13_Pat76CB::
    db $a4
    db $28
    db $1a
    db $28
    db $1a
    db $1e
    db $1e
    db $1e
    db $01
    db $00

; C: note pattern ($00 ends it)
Song13_Pat76D5::
    db $9b
    db $03
    db $a2
    db $15
    db $06
    db $1a
    db $06
    db $15
    db $06
    db $1a
    db $06
    db $9c
    db $9b
    db $02
    db $1a
    db $1a
    db $1a
    db $1a
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song13_Pat76E9::
    db $9b
    db $13
    db $a2
    db $15
    db $06
    db $1a
    db $06
    db $15
    db $06
    db $1a
    db $06
    db $9c
    db $a5
    db $1a
    db $9b
    db $03
    db $a2
    db $15
    db $06
    db $1a
    db $06
    db $15
    db $06
    db $1a
    db $06
    db $9c
    db $06
    db $1a
    db $06
    db $1a
    db $15
    db $1a
    db $1a
    db $1a
    db $00

; I: header of song ids 15 21
Song21_SlideShowPlay_Hdr::
    db $00
    db $8b
    db $41
    db $17
    db $77
    db $1f
    db $77
    db $27
    db $77
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song21_SlideShowPlay_Trk1List::
    db $35
    db $77
    db $d4
    db $77
    db $ff
    db $ff
    db $17
    db $77

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song21_SlideShowPlay_Trk2List::
    db $8f
    db $77
    db $18
    db $78
    db $ff
    db $ff
    db $1f
    db $77

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song21_SlideShowPlay_Trk3List::
    db $ac
    db $77
    db $49
    db $78
    db $ff
    db $ff
    db $27
    db $77
    db $cc
    db $77
    db $ff
    db $ff
    db $2f
    db $77

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat7735::
    db $9d
    db $80
    db $00
    db $81
    db $a3
    db $36
    db $3e
    db $44
    db $a4
    db $44
    db $9d
    db $74
    db $00
    db $81
    db $a3
    db $5c
    db $5c
    db $01
    db $56
    db $56
    db $01
    db $9d
    db $80
    db $00
    db $81
    db $36
    db $36
    db $3e
    db $44
    db $a4
    db $44
    db $9d
    db $74
    db $00
    db $81
    db $a3
    db $5c
    db $5c
    db $01
    db $58
    db $58
    db $01
    db $9d
    db $80
    db $00
    db $81
    db $34
    db $34
    db $3a
    db $48
    db $a4
    db $48
    db $9d
    db $74
    db $00
    db $81
    db $a3
    db $60
    db $60
    db $01
    db $58
    db $58
    db $01
    db $9d
    db $80
    db $00
    db $81
    db $34
    db $34
    db $3a
    db $48
    db $a4
    db $48
    db $9d
    db $74
    db $00
    db $81
    db $a3
    db $60
    db $60
    db $01
    db $56
    db $56
    db $01
    db $9d
    db $60
    db $00
    db $81
    db $36
    db $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat778F::
    db $9d
    db $b3
    db $00
    db $81
    db $a8
    db $01
    db $9b
    db $03
    db $a3
    db $01
    db $3e
    db $3e
    db $9c
    db $01
    db $36
    db $3e
    db $9b
    db $08
    db $01
    db $40
    db $40
    db $9c
    db $9b
    db $03
    db $01
    db $3e
    db $3e
    db $9c
    db $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat77AC::
    db $9d
    db $22
    db $41
    db $a0
    db $a8
    db $01
    db $9b
    db $04
    db $a3
    db $36
    db $44
    db $44
    db $9c
    db $9b
    db $04
    db $3a
    db $44
    db $44
    db $9c
    db $9b
    db $04
    db $2c
    db $44
    db $44
    db $9c
    db $9b
    db $03
    db $36
    db $44
    db $44
    db $9c
    db $00
    db $a3
    db $06
    db $0b
    db $0b
    db $06
    db $0b
    db $0b
    db $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat77D4::
    db $a3
    db $36
    db $3e
    db $44
    db $4e
    db $9d
    db $74
    db $00
    db $81
    db $01
    db $66
    db $66
    db $01
    db $5c
    db $5c
    db $01
    db $9d
    db $80
    db $00
    db $81
    db $36
    db $36
    db $3e
    db $44
    db $a4
    db $4e
    db $9d
    db $74
    db $00
    db $81
    db $a3
    db $66
    db $66
    db $01
    db $60
    db $60
    db $01
    db $9d
    db $80
    db $00
    db $81
    db $52
    db $52
    db $58
    db $60
    db $a5
    db $60
    db $a3
    db $5a
    db $5c
    db $a5
    db $6e
    db $a3
    db $66
    db $56
    db $a4
    db $56
    db $a3
    db $52
    db $a4
    db $60
    db $a3
    db $5c
    db $a4
    db $4e
    db $a3
    db $01
    db $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat7818::
    db $a3
    db $01
    db $36
    db $3e
    db $9b
    db $03
    db $01
    db $3e
    db $3e
    db $9c
    db $01
    db $36
    db $3e
    db $9b
    db $02
    db $01
    db $3a
    db $3a
    db $9c
    db $3a
    db $01
    db $3a
    db $3a
    db $40
    db $48
    db $9b
    db $02
    db $01
    db $40
    db $40
    db $9c
    db $9b
    db $02
    db $01
    db $3e
    db $3e
    db $9c
    db $a4
    db $3a
    db $a3
    db $01
    db $a4
    db $40
    db $a3
    db $01
    db $a7
    db $3e
    db $01
    db $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat7849::
    db $a3
    db $36
    db $44
    db $44
    db $9b
    db $04
    db $3e
    db $44
    db $44
    db $9c
    db $9b
    db $02
    db $40
    db $48
    db $48
    db $9c
    db $40
    db $01
    db $01
    db $3a
    db $40
    db $48
    db $3a
    db $44
    db $44
    db $2c
    db $44
    db $44
    db $36
    db $44
    db $44
    db $3e
    db $44
    db $44
    db $a8
    db $40
    db $44
    db $a4
    db $36
    db $a3
    db $01
    db $00

; I: header of song id 14
Song14_Hdr::
    db $00
    db $8b
    db $41
    db $00
    db $00
    db $7e
    db $78
    db $84
    db $78
    db $8a
    db $78

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song14_Trk2List::
    db $90
    db $78
    db $ff
    db $ff
    db $7e
    db $78

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song14_Trk3List::
    db $ca
    db $78
    db $ff
    db $ff
    db $84
    db $78

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song14_Trk4List::
    db $fc
    db $78
    db $ff
    db $ff
    db $8a
    db $78

; C: note pattern ($00 ends it)
Song14_Pat7890::
    db $9d
    db $b0
    db $00
    db $81
    db $a2
    db $01
    db $44
    db $a7
    db $60
    db $a1
    db $62
    db $60
    db $a2
    db $5c
    db $54
    db $52
    db $4a
    db $a3
    db $52
    db $a2
    db $01
    db $a1
    db $54
    db $52
    db $a2
    db $4a
    db $44
    db $a7
    db $48
    db $a2
    db $4a
    db $a1
    db $52
    db $a1
    db $01
    db $01
    db $a0
    db $54
    db $52
    db $a2
    db $4a
    db $48
    db $a3
    db $44
    db $a2
    db $01
    db $a1
    db $3a
    db $3c
    db $44
    db $44
    db $a1
    db $01
    db $44
    db $44
    db $a6
    db $01
    db $00

; C: note pattern ($00 ends it)
Song14_Pat78CA::
    db $9d
    db $22
    db $41
    db $20
    db $a3
    db $1e
    db $a2
    db $01
    db $1e
    db $a3
    db $1e
    db $a2
    db $01
    db $1e
    db $a3
    db $14
    db $a2
    db $01
    db $14
    db $a3
    db $14
    db $a2
    db $01
    db $14
    db $a3
    db $22
    db $a2
    db $01
    db $2c
    db $a3
    db $22
    db $a2
    db $01
    db $0a
    db $a3
    db $14
    db $a2
    db $01
    db $a1
    db $0a
    db $0c
    db $14
    db $14
    db $a1
    db $01
    db $14
    db $14
    db $a6
    db $01
    db $00

; C: note pattern ($00 ends it)
Song14_Pat78FC::
    db $9b
    db $02
    db $a2
    db $15
    db $06
    db $1a
    db $06
    db $06
    db $15
    db $1a
    db $06
    db $9c
    db $a1
    db $15
    db $06
    db $01
    db $06
    db $1a
    db $06
    db $a0
    db $06
    db $06
    db $06
    db $06
    db $a7
    db $1a
    db $a2
    db $06
    db $a2
    db $15
    db $06
    db $1a
    db $06
    db $06
    db $15
    db $1a
    db $a1
    db $06
    db $1a
    db $00

; I: header of song id 2E
Song2E_Hdr::
    db $00
    db $8b
    db $41
    db $2f
    db $79
    db $37
    db $79
    db $3f
    db $79
    db $47
    db $79

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk1List::
    db $fd
    db $79
    db $0e
    db $7a
    db $ff
    db $ff
    db $2f
    db $79

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk2List::
    db $4f
    db $79
    db $6f
    db $79
    db $ff
    db $ff
    db $37
    db $79

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk3List::
    db $64
    db $7a
    db $75
    db $7a
    db $ff
    db $ff
    db $3f
    db $79

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk4List::
    db $a4
    db $7a
    db $ad
    db $7a
    db $ff
    db $ff
    db $49
    db $79

; C: note pattern ($00 ends it)
Song2E_Pat794F::
    db $9d
    db $82
    db $00
    db $81
    db $a2
    db $5e
    db $5e
    db $a1
    db $5a
    db $58
    db $a2
    db $54
    db $5e
    db $5e
    db $a1
    db $5a
    db $58
    db $a2
    db $54
    db $a2
    db $58
    db $58
    db $a1
    db $50
    db $4e
    db $a2
    db $4a
    db $50
    db $4e
    db $4a
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat796F::
    db $a2
    db $4a
    db $4e
    db $a1
    db $50
    db $4e
    db $a2
    db $4a
    db $50
    db $54
    db $58
    db $54
    db $a2
    db $50
    db $58
    db $5e
    db $a1
    db $5a
    db $5e
    db $a2
    db $58
    db $54
    db $a3
    db $58
    db $a2
    db $4a
    db $4e
    db $a1
    db $50
    db $4e
    db $a2
    db $4a
    db $50
    db $54
    db $58
    db $54
    db $a2
    db $62
    db $62
    db $5e
    db $a1
    db $58
    db $5e
    db $a2
    db $58
    db $58
    db $62
    db $01
    db $9b
    db $04
    db $a2
    db $62
    db $62
    db $9c
    db $a2
    db $01
    db $62
    db $5e
    db $5e
    db $58
    db $5e
    db $62
    db $01
    db $62
    db $62
    db $62
    db $62
    db $62
    db $62
    db $62
    db $62
    db $01
    db $62
    db $5e
    db $5e
    db $58
    db $54
    db $58
    db $01
    db $a3
    db $5e
    db $5e
    db $5e
    db $5e
    db $a2
    db $5e
    db $5e
    db $a1
    db $5a
    db $58
    db $54
    db $01
    db $a2
    db $5e
    db $5e
    db $a1
    db $5a
    db $58
    db $54
    db $01
    db $a2
    db $50
    db $54
    db $58
    db $a1
    db $5a
    db $58
    db $a2
    db $54
    db $50
    db $5e
    db $01
    db $a2
    db $5e
    db $5e
    db $a1
    db $5a
    db $58
    db $54
    db $01
    db $a2
    db $5e
    db $5e
    db $a1
    db $5a
    db $58
    db $54
    db $01
    db $a2
    db $58
    db $58
    db $a1
    db $50
    db $4e
    db $4a
    db $01
    db $a2
    db $50
    db $4e
    db $4a
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat79FD::
    db $9d
    db $82
    db $00
    db $81
    db $9b
    db $02
    db $a2
    db $54
    db $54
    db $01
    db $01
    db $9c
    db $50
    db $50
    db $a8
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat7A0E::
    db $9b
    db $07
    db $a2
    db $01
    db $4a
    db $9c
    db $a3
    db $4a
    db $9b
    db $06
    db $a2
    db $01
    db $4a
    db $9c
    db $01
    db $4e
    db $50
    db $01
    db $a5
    db $5a
    db $58
    db $5a
    db $58
    db $a3
    db $58
    db $58
    db $58
    db $58
    db $a2
    db $46
    db $46
    db $a1
    db $42
    db $40
    db $3c
    db $01
    db $a2
    db $46
    db $46
    db $a1
    db $42
    db $40
    db $3c
    db $01
    db $a2
    db $38
    db $3c
    db $40
    db $a1
    db $42
    db $40
    db $a2
    db $3c
    db $38
    db $46
    db $01
    db $a2
    db $46
    db $46
    db $a1
    db $42
    db $40
    db $3c
    db $01
    db $a2
    db $46
    db $46
    db $a1
    db $42
    db $40
    db $3c
    db $01
    db $a2
    db $40
    db $40
    db $a1
    db $38
    db $36
    db $32
    db $01
    db $a2
    db $38
    db $36
    db $32
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat7A64::
    db $9d
    db $22
    db $41
    db $a0
    db $a3
    db $3c
    db $46
    db $3c
    db $46
    db $32
    db $40
    db $a2
    db $01
    db $40
    db $32
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat7A75::
    db $9b
    db $07
    db $a3
    db $32
    db $40
    db $9c
    db $a2
    db $01
    db $40
    db $32
    db $01
    db $9b
    db $02
    db $a3
    db $3c
    db $3c
    db $3c
    db $3c
    db $32
    db $32
    db $32
    db $32
    db $9c
    db $40
    db $40
    db $40
    db $40
    db $3c
    db $46
    db $3c
    db $46
    db $38
    db $46
    db $38
    db $46
    db $3c
    db $46
    db $3c
    db $46
    db $32
    db $28
    db $a2
    db $01
    db $40
    db $32
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat7AA4::
    db $9b
    db $07
    db $a2
    db $01
    db $0b
    db $9c
    db $0b
    db $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat7AAD::
    db $9b
    db $0f
    db $01
    db $0b
    db $9c
    db $0b
    db $01
    db $9b
    db $23
    db $01
    db $0b
    db $9c
    db $0b
    db $01
    db $00

; I: header of song ids 1C 47. Owner (review page, 2026-10-13, by ear): music 47: unused - classical music theme
; (mozart ?); id 47 shares this header with id 1C; 47 is only in the slide-show music list (#13).
Song1C_Hdr::
    db $00
    db $9b
    db $41
    db $c7
    db $7a
    db $cd
    db $7a
    db $d3
    db $7a
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1C_Trk1List::
    db $2c
    db $7b
    db $ff
    db $ff
    db $c7
    db $7a

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1C_Trk2List::
    db $d9
    db $7a
    db $ff
    db $ff
    db $cd
    db $7a

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1C_Trk3List::
    db $54
    db $7b
    db $ff
    db $ff
    db $d3
    db $7a

; C: note pattern ($00 ends it)
Song1C_Pat7AD9::
    db $9d
    db $d4
    db $00
    db $81
    db $a2
    db $01
    db $40
    db $40
    db $40
    db $a4
    db $38
    db $a2
    db $01
    db $3c
    db $3c
    db $3c
    db $a4
    db $36
    db $a3
    db $01
    db $a1
    db $01
    db $40
    db $40
    db $40
    db $38
    db $42
    db $42
    db $42
    db $40
    db $50
    db $50
    db $50
    db $a3
    db $4a
    db $a1
    db $01
    db $40
    db $40
    db $40
    db $a1
    db $36
    db $42
    db $42
    db $42
    db $40
    db $54
    db $54
    db $54
    db $a3
    db $4e
    db $a1
    db $01
    db $58
    db $58
    db $54
    db $a1
    db $50
    db $50
    db $50
    db $54
    db $58
    db $58
    db $58
    db $54
    db $50
    db $50
    db $50
    db $54
    db $58
    db $58
    db $58
    db $54
    db $a2
    db $50
    db $01
    db $a1
    db $4a
    db $a6
    db $01
    db $a4
    db $58
    db $00

; C: note pattern ($00 ends it)
Song1C_Pat7B2C::
    db $9d
    db $d4
    db $00
    db $81
    db $a2
    db $01
    db $10
    db $10
    db $10
    db $a4
    db $08
    db $a2
    db $01
    db $0c
    db $0c
    db $0c
    db $a4
    db $06
    db $01
    db $a5
    db $32
    db $30
    db $a2
    db $32
    db $01
    db $30
    db $01
    db $32
    db $01
    db $30
    db $01
    db $32
    db $01
    db $a1
    db $2a
    db $a6
    db $01
    db $a4
    db $28
    db $00

; C: note pattern ($00 ends it)
Song1C_Pat7B54::
    db $9d
    db $f2
    db $40
    db $21
    db $a4
    db $01
    db $a5
    db $01
    db $01
    db $01
    db $01
    db $a2
    db $32
    db $01
    db $30
    db $01
    db $32
    db $01
    db $30
    db $01
    db $a2
    db $32
    db $01
    db $a1
    db $2a
    db $a6
    db $01
    db $a4
    db $28
    db $00

; I: header of song id 26
Song26_TransferSend_Hdr::
    db $08
    db $8b
    db $41
    db $7d
    db $7b
    db $83
    db $7b
    db $89
    db $7b
    db $8f
    db $7b

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk1List::
    db $cc
    db $7b
    db $ff
    db $ff
    db $7d
    db $7b

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk2List::
    db $95
    db $7b
    db $ff
    db $ff
    db $83
    db $7b

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk3List::
    db $0b
    db $7c
    db $ff
    db $ff
    db $89
    db $7b

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk4List::
    db $37
    db $7c
    db $ff
    db $ff
    db $8f
    db $7b

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7B95::
    db $9d
    db $e1
    db $00
    db $c0
    db $9b
    db $02
    db $a1
    db $34
    db $01
    db $34
    db $01
    db $01
    db $34
    db $01
    db $9c
    db $34
    db $01
    db $34
    db $01
    db $34
    db $01
    db $01
    db $34
    db $01
    db $34
    db $a4
    db $01
    db $9b
    db $02
    db $a1
    db $34
    db $01
    db $34
    db $01
    db $01
    db $34
    db $01
    db $9c
    db $34
    db $01
    db $34
    db $01
    db $34
    db $01
    db $01
    db $34
    db $01
    db $36
    db $a2
    db $01
    db $a3
    db $36
    db $a2
    db $01
    db $00

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7BCC::
    db $9d
    db $d2
    db $00
    db $c0
    db $a1
    db $2a
    db $01
    db $2a
    db $01
    db $01
    db $2a
    db $01
    db $26
    db $01
    db $26
    db $01
    db $01
    db $26
    db $01
    db $26
    db $01
    db $2a
    db $01
    db $2a
    db $01
    db $01
    db $2a
    db $01
    db $26
    db $a4
    db $01
    db $a1
    db $2a
    db $01
    db $2a
    db $01
    db $01
    db $2a
    db $01
    db $26
    db $01
    db $26
    db $01
    db $01
    db $26
    db $01
    db $26
    db $01
    db $2a
    db $01
    db $2a
    db $01
    db $01
    db $2a
    db $01
    db $2c
    db $a2
    db $01
    db $a3
    db $2c
    db $a2
    db $01
    db $00

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7C0B::
    db $9d
    db $22
    db $41
    db $21
    db $a3
    db $2c
    db $22
    db $a6
    db $2c
    db $a3
    db $22
    db $a1
    db $01
    db $a3
    db $2c
    db $22
    db $a6
    db $2c
    db $a1
    db $2c
    db $a3
    db $01
    db $a3
    db $2c
    db $22
    db $a6
    db $2c
    db $a3
    db $22
    db $a1
    db $01
    db $a3
    db $2c
    db $a6
    db $2c
    db $a1
    db $2e
    db $a2
    db $01
    db $a3
    db $2e
    db $a2
    db $01
    db $00

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7C37::
    db $9b
    db $03
    db $a1
    db $10
    db $06
    db $06
    db $10
    db $06
    db $06
    db $10
    db $06
    db $06
    db $06
    db $10
    db $06
    db $06
    db $0b
    db $06
    db $06
    db $9c
    db $10
    db $06
    db $06
    db $10
    db $06
    db $0b
    db $10
    db $06
    db $a2
    db $01
    db $a3
    db $0b
    db $a2
    db $01
    db $00

; I: header of song id 18
Song18_Hdr::
    db $00
    db $8b
    db $41
    db $65
    db $7c
    db $6d
    db $7c
    db $75
    db $7c
    db $7d
    db $7c

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk1List::
    db $10
    db $7d
    db $17
    db $7d
    db $ff
    db $ff
    db $67
    db $7c

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk2List::
    db $85
    db $7c
    db $91
    db $7c
    db $ff
    db $ff
    db $6f
    db $7c

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk3List::
    db $77
    db $7d
    db $7e
    db $7d
    db $ff
    db $ff
    db $77
    db $7c

; I: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk4List::
    db $dc
    db $7d
    db $df
    db $7d
    db $ff
    db $ff
    db $7f
    db $7c

; C: note pattern ($00 ends it)
Song18_Pat7C85::
    db $9d
    db $d4
    db $00
    db $40
    db $a9
    db $01
    db $01
    db $52
    db $54
    db $01
    db $52
    db $00

; C: note pattern ($00 ends it)
Song18_Pat7C91::
    db $a4
    db $58
    db $a7
    db $54
    db $a4
    db $52
    db $a2
    db $01
    db $a9
    db $01
    db $01
    db $52
    db $54
    db $01
    db $58
    db $a2
    db $4a
    db $9d
    db $a4
    db $00
    db $40
    db $a7
    db $01
    db $a9
    db $2e
    db $01
    db $2e
    db $a3
    db $01
    db $a1
    db $2e
    db $a6
    db $01
    db $a3
    db $2e
    db $9d
    db $d4
    db $00
    db $40
    db $a9
    db $01
    db $01
    db $52
    db $54
    db $01
    db $52
    db $a4
    db $58
    db $a9
    db $54
    db $01
    db $52
    db $54
    db $01
    db $a8
    db $52
    db $a9
    db $52
    db $54
    db $01
    db $58
    db $a2
    db $4a
    db $a7
    db $01
    db $a9
    db $4a
    db $01
    db $4a
    db $01
    db $01
    db $44
    db $a3
    db $01
    db $54
    db $a9
    db $01
    db $01
    db $52
    db $54
    db $01
    db $52
    db $a4
    db $58
    db $a9
    db $58
    db $01
    db $5c
    db $01
    db $01
    db $5e
    db $a9
    db $01
    db $01
    db $5c
    db $01
    db $01
    db $58
    db $01
    db $01
    db $54
    db $01
    db $01
    db $a3
    db $52
    db $a9
    db $4a
    db $a3
    db $01
    db $34
    db $a9
    db $01
    db $01
    db $a3
    db $32
    db $a9
    db $01
    db $a3
    db $30
    db $a9
    db $01
    db $01
    db $52
    db $54
    db $01
    db $52
    db $00

; C: note pattern ($00 ends it)
Song18_Pat7D10::
    db $9d
    db $b3
    db $00
    db $41
    db $a4
    db $01
    db $00

; C: note pattern ($00 ends it)
Song18_Pat7D17::
    db $a9
    db $01
    db $01
    db $2e
    db $a8
    db $01
    db $a9
    db $01
    db $01
    db $2c
    db $a8
    db $01
    db $a9
    db $01
    db $01
    db $2e
    db $a3
    db $01
    db $a9
    db $22
    db $01
    db $22
    db $a3
    db $01
    db $a1
    db $22
    db $a6
    db $01
    db $a3
    db $22
    db $a4
    db $01
    db $a9
    db $01
    db $01
    db $a4
    db $2c
    db $a9
    db $01
    db $a3
    db $01
    db $a9
    db $01
    db $01
    db $2c
    db $a3
    db $01
    db $a4
    db $01
    db $a9
    db $01
    db $01
    db $2e
    db $a4
    db $01
    db $a9
    db $01
    db $01
    db $2e
    db $a3
    db $01
    db $a4
    db $34
    db $a9
    db $01
    db $01
    db $32
    db $a8
    db $01
    db $a9
    db $01
    db $01
    db $3a
    db $a9
    db $01
    db $01
    db $3a
    db $a8
    db $01
    db $a9
    db $01
    db $01
    db $2e
    db $a3
    db $01
    db $28
    db $a9
    db $01
    db $01
    db $a3
    db $24
    db $a9
    db $01
    db $a8
    db $3a
    db $00

; C: note pattern ($00 ends it)
Song18_Pat7D77::
    db $9d
    db $f2
    db $40
    db $20
    db $a4
    db $01
    db $00

; C: note pattern ($00 ends it)
Song18_Pat7D7E::
    db $a9
    db $1a
    db $01
    db $36
    db $a3
    db $1e
    db $22
    db $1a
    db $a9
    db $24
    db $01
    db $38
    db $a3
    db $2c
    db $2e
    db $30
    db $a9
    db $32
    db $01
    db $3a
    db $a3
    db $28
    db $1e
    db $1c
    db $a3
    db $1a
    db $1e
    db $20
    db $22
    db $a9
    db $24
    db $01
    db $38
    db $a3
    db $22
    db $24
    db $1a
    db $a9
    db $24
    db $01
    db $38
    db $a3
    db $2c
    db $2e
    db $30
    db $a9
    db $32
    db $01
    db $3a
    db $a3
    db $32
    db $30
    db $a9
    db $2e
    db $01
    db $3a
    db $a3
    db $2c
    db $22
    db $2c
    db $a9
    db $22
    db $01
    db $3c
    db $a3
    db $1e
    db $2c
    db $30
    db $a9
    db $32
    db $01
    db $48
    db $a9
    db $30
    db $01
    db $48
    db $a3
    db $28
    db $2c
    db $30
    db $a9
    db $32
    db $01
    db $22
    db $a3
    db $2c
    db $22
    db $20
    db $a3
    db $1e
    db $28
    db $2c
    db $30
    db $00

; C: note pattern ($00 ends it)
Song18_Pat7DDC::
    db $a4
    db $01
    db $00

; I: note pattern ($00 ends it)
Song18_Pat7DDF::
    db $9b
    db $06
    db $a3
    db $0b
    db $a9
    db $06
    db $01
    db $0b
    db $a3
    db $0b
    db $a9
    db $06
    db $01
    db $0b
    db $9c
    db $a3
    db $0b
    db $a9
    db $06
    db $01
    db $0b
    db $a3
    db $0b
    db $a9
    db $06
    db $01
    db $a3
    db $0b
    db $a9
    db $01
    db $0b
    db $01
    db $0b
    db $a3
    db $0b
    db $a9
    db $06
    db $01
    db $0b
    db $9b
    db $04
    db $a3
    db $0b
    db $a9
    db $06
    db $01
    db $0b
    db $a3
    db $0b
    db $a9
    db $06
    db $01
    db $0b
    db $9c
    db $00
    db $00
    db $8b
    db $41
    db $21
    db $7e
    db $29
    db $7e
    db $2f
    db $7e
    db $00
    db $00
    db $51
    db $7e
    db $39
    db $7e
    db $ff
    db $ff
    db $23
    db $7e
    db $35
    db $7e
    db $ff
    db $ff
    db $29
    db $7e
    db $58
    db $7e
    db $ff
    db $ff
    db $2f
    db $7e

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E35::
    db $9d
    db $a4
    db $00
    db $81

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E39::
    db $a8
    db $70
    db $a8
    db $6e
    db $a4
    db $6c
    db $a3
    db $6a
    db $a4
    db $66
    db $a3
    db $5c
    db $a4
    db $58
    db $a3
    db $5c
    db $a4
    db $62
    db $a3
    db $5c
    db $a8
    db $58
    db $01
    db $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E51::
    db $9d
    db $20
    db $00
    db $81
    db $aa
    db $01
    db $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E58::
    db $9d
    db $22
    db $41
    db $21
    db $a2
    db $32
    db $40
    db $4a
    db $4e
    db $52
    db $58
    db $32
    db $3e
    db $44
    db $4a
    db $4e
    db $56
    db $32
    db $3c
    db $44
    db $4a
    db $4e
    db $54
    db $32
    db $3c
    db $44
    db $4a
    db $4e
    db $54
    db $32
    db $40
    db $48
    db $4a
    db $52
    db $58
    db $44
    db $3a
    db $40
    db $44
    db $4a
    db $52
    db $36
    db $40
    db $44
    db $4a
    db $4e
    db $58
    db $60
    db $01
    db $a4
    db $01
    db $00

; I: header of song id 22
Song22_Hdr::
    db $00
    db $9b
    db $41
    db $9f
    db $7e
    db $97
    db $7e
    db $a5
    db $7e
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song22_Trk2List::
    db $ab
    db $7e
    db $b6
    db $7e
    db $ff
    db $ff
    db $99
    db $7e

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song22_Trk1List::
    db $b2
    db $7e
    db $ff
    db $ff
    db $9f
    db $7e

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song22_Trk3List::
    db $e8
    db $7e
    db $ff
    db $ff
    db $a5
    db $7e

; C: note pattern ($00 ends it)
Song22_Pat7EAB::
    db $9d
    db $56
    db $00
    db $81
    db $a9
    db $01
    db $00

; C: note pattern ($00 ends it)
Song22_Pat7EB2::
    db $9d
    db $93
    db $00
    db $81

; C: note pattern ($00 ends it)
Song22_Pat7EB6::
    db $a1
    db $78
    db $74
    db $6e
    db $66
    db $60
    db $5c
    db $56
    db $4e
    db $48
    db $44
    db $3e
    db $36
    db $34
    db $36
    db $3e
    db $44
    db $4c
    db $4e
    db $56
    db $5c
    db $64
    db $66
    db $6e
    db $74
    db $78
    db $70
    db $6a
    db $66
    db $60
    db $58
    db $52
    db $4e
    db $48
    db $40
    db $3a
    db $36
    db $3a
    db $40
    db $46
    db $4c
    db $52
    db $58
    db $5e
    db $64
    db $6a
    db $70
    db $76
    db $7c
    db $00

; C: note pattern ($00 ends it)
Song22_Pat7EE8::
    db $9d
    db $22
    db $41
    db $21
    db $a4
    db $5c
    db $a3
    db $60
    db $a4
    db $6e
    db $a3
    db $64
    db $a8
    db $60
    db $a8
    db $5e
    db $00

; I: header of song id 1F. Owner (review page, 2026-10-13, by ear): music 1F: From space Fever (likely)
Song1F_Hdr::
    db $00
    db $76
    db $41
    db $08
    db $7f
    db $04
    db $7f
    db $0a
    db $7f
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1F_Trk2List::
    db $16
    db $7f
    db $00
    db $00

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1F_Trk1List::
    db $0c
    db $7f

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1F_Trk3List::
    db $20
    db $7f

; C: note pattern ($00 ends it)
Song1F_Pat7F0C::
    db $9d
    db $d3
    db $00
    db $81
    db $a2
    db $3c
    db $2e
    db $3c
    db $46
    db $00

; C: note pattern ($00 ends it)
Song1F_Pat7F16::
    db $9d
    db $d3
    db $00
    db $81
    db $a2
    db $32
    db $24
    db $32
    db $3c
    db $00

; C: note pattern ($00 ends it)
Song1F_Pat7F20::
    db $9d
    db $22
    db $41
    db $21
    db $a2
    db $44
    db $36
    db $44
    db $4e
    db $00

; I: header of song id 48. Owner (review page, 2026-10-13, by ear): music 48: known - error message, incomplete;
; confirmed the earlier answer (error message, incomplete).
Song48_ErrorIncomplete_Hdr::
    db $00
    db $8b
    db $41
    db $37
    db $7f
    db $35
    db $7f
    db $00
    db $00
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop). Owner (review page, 2026-10-13, by ear):
; music 48: known - error message, incomplete.
Song48_ErrorIncomplete_Trk2List::
    db $3b
    db $7f

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop). Owner (review page, 2026-10-13, by ear):
; music 48: known - error message, incomplete.
Song48_ErrorIncomplete_Trk1List::
    db $47
    db $7f
    db $00
    db $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat7F3B::
    db $9d
    db $f1
    db $00
    db $40
    db $a0
    db $28
    db $01
    db $22
    db $01
    db $1c
    db $01
    db $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat7F47::
    db $9d
    db $f1
    db $00
    db $40
    db $a0
    db $0e
    db $01
    db $08
    db $01
    db $02
    db $01
    db $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat7F53::
    db $a0
    db $01
    db $01
    db $01
    db $01
    db $01
    db $01
    db $00

; I: header of song id 0E
Song0E_ShootIntroC_Hdr::
    db $fa
    db $8b
    db $41
    db $6c
    db $7f
    db $66
    db $7f
    db $74
    db $7f
    db $00
    db $00

; I: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0E_ShootIntroC_Trk2List::
    db $7a
    db $7f
    db $ff
    db $ff
    db $66
    db $7f

; I: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0E_ShootIntroC_Trk1List::
    db $98
    db $7f
    db $7e
    db $7f
    db $ff
    db $ff
    db $6e
    db $7f

; I: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0E_ShootIntroC_Trk3List::
    db $a0
    db $7f
    db $ff
    db $ff
    db $74
    db $7f

; C: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7F7A::
    db $9d
    db $75
    db $00
    db $c1

; C: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7F7E::
    db $a2
    db $70
    db $66
    db $6a
    db $60
    db $66
    db $5c
    db $60
    db $58
    db $5c
    db $52
    db $58
    db $4e
    db $36
    db $3c
    db $42
    db $48
    db $4e
    db $54
    db $5a
    db $60
    db $66
    db $6c
    db $72
    db $78
    db $00

; C: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7F98::
    db $9d
    db $37
    db $00
    db $c1
    db $a9
    db $01
    db $01
    db $00

; I: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7FA0::
    db $9d
    db $f2
    db $40
    db $21
    db $a4
    db $32
    db $a3
    db $40
    db $a4
    db $52
    db $a3
    db $58
    db $a4
    db $5a
    db $a3
    db $54
    db $4e
    db $52
    db $54
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00

; C: stub jp Snd_Tick; the only per-frame entry (bank 0 Snd_Tick_Tramp calls $7FF0)
Snd_TickEntry::
    jp Snd_Tick                                   ; $7FF0


; C: stub jp Snd_StopSong; no caller in the ROM
Unused_Snd_StopEntry::
    jp Snd_StopSong                               ; $7FF3


; C: stub jp Snd_Init; called by bank 0 Snd_Init_Tramp
Snd_InitEntry::
    jp Snd_Init                                   ; $7FF6


    ; padding
    ds $7, $00

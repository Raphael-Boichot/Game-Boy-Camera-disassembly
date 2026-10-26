; Pocket Camera (Japan) (Rev A), bank $1F. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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
    dw Vram_FillFFSafe
    dw $072d
    dw $0739
    dw Vram_WriteByteSafe
    dw $074f
    dw $0759
    dw Unused_Vram_AndByteSafe
    dw $076b
    dw Unused_Vram_ReadByteSafe
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

; C: 62 words: channel-1 effect init handlers (id 1..$3E)
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
    dw Sfx1_Init_12_1D_PanelOpen
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

; C: 62 words: channel-1 effect step handlers
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

; C: 10 words: channel-3 effect init handlers
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

; C: 10 words: channel-3 effect step handlers
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

; C: 18 words: channel-4 effect init handlers
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

; C: 18 words: channel-4 effect step handlers
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

    ld hl, $4396                                  ; $43B2
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

    ld hl, $43bd                                  ; $43D9
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
    ld hl, $43fc                                  ; $4421
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
    ld hl, $442c                                  ; $444C
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

    ld hl, $4494                                  ; $44B4
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

    ld hl, $44c5                                  ; $44E8

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
    ld hl, $450c                                  ; $4518
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
    ld hl, $454f                                  ; $4563
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
    ld bc, $457a                                  ; $4597

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

    ld hl, $45bc                                  ; $45DC
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
    ld hl, $45ed                                  ; $4609
    cp $01                                        ; $460C
    jr z, jr_01f_4624                             ; $460E

    ld hl, $45f2                                  ; $4610
    cp $02                                        ; $4613
    jr z, jr_01f_4624                             ; $4615

    ld hl, $45ed                                  ; $4617
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
    ld hl, $4631                                  ; $465A
    add hl, bc                                    ; $465D
    ld a, [hl]                                    ; $465E
    and a                                         ; $465F
    jp z, Sfx1_Stop                               ; $4660

    ldh [rNR13], a                                ; $4663
    ld a, $c7                                     ; $4665
    ldh [rNR14], a                                ; $4667
    ret                                           ; $4669


jr_01f_466a:
    ld hl, $462c                                  ; $466A
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

    ld hl, $4675                                  ; $4691
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
    ld hl, $47af                                  ; $47D3
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
    ld hl, $47de                                  ; $4800
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


; C: channel-1 effect init handler of ids 12 1D (table $41FA). Named after the caller of its ids (SFX1_PANEL_OPEN,
; SFX1_PANEL_OPEN_ALIAS_1D, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_12_1D_PanelOpen::
    ld a, $06                                     ; $4871
    ld hl, $487e                                  ; $4873
    jp Snd_Sfx_Start                              ; $4876


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4879::
    db $7e, $c0, $90, $aa, $c7
    db $9e, $00, $d0, $ee, $c7

; C: channel-1 effect init handler of ids 0C (table $41FA). Named after the caller of its id
; (SFX1_SPACE_FEVER_ENEMY_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx1_Init_0C_SpaceFeverEnemyKill::
    call Sfx1_IsRunning26                         ; $4883
    ret z                                         ; $4886

    ld a, $07                                     ; $4887
    ld hl, $487e                                  ; $4889
    jp Snd_Sfx_Start                              ; $488C


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_488F::
    db $7f, $c0, $9a, $34, $c4

; C: channel-1 effect init handler of ids 07 (table $41FA). Named after the caller of its id (SFX1_MAIN_MENU_MOVE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_07_MainMenuMove::
    ld a, $04                                     ; $4894
    ld hl, Sfx1_Data_488F                         ; $4896
    call Snd_Sfx_Start                            ; $4899
    ldh a, [rDIV]                                 ; $489C
    or $00                                        ; $489E
    ldh [rNR13], a                                ; $48A0
    ldh a, [rDIV]                                 ; $48A2
    or $c5                                        ; $48A4
    ldh [rNR14], a                                ; $48A6
    ret                                           ; $48A8


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_48A9::
    db $2f, $e9, $f0, $34, $c7

; C: channel-1 effect init handler of ids 2C (table $41FA)
Sfx1_Init_2C::
    ldh a, [rDIV]                                 ; $48AE
    and $03                                       ; $48B0
    ld c, a                                       ; $48B2
    ld b, $00                                     ; $48B3
    ld hl, $48e3                                  ; $48B5
    add hl, bc                                    ; $48B8
    ld a, [hl]                                    ; $48B9
    ld hl, Sfx1_Data_48A9                         ; $48BA
    call Snd_Sfx_Start                            ; $48BD
    ldh a, [rDIV]                                 ; $48C0
    ld e, a                                       ; $48C2
    srl a                                         ; $48C3
    srl a                                         ; $48C5
    and $03                                       ; $48C7
    ld c, a                                       ; $48C9
    ld b, $00                                     ; $48CA
    ld hl, Sfx1_Data_48DF                         ; $48CC
    add hl, bc                                    ; $48CF
    ld a, e                                       ; $48D0
    and $0f                                       ; $48D1
    or [hl]                                       ; $48D3
    ldh [rNR13], a                                ; $48D4
    ld a, $c7                                     ; $48D6
    ldh [rNR14], a                                ; $48D8

; C: shared tail of four channel-1 init routines (callers 4973, 49C3, 4A7B, 4AA2) after Snd_Sfx_Start: clears $DD08
; and returns (branch target; code read 2026-10-19)
Sfx1_InitTail_ClearFlag::
    xor a                                         ; $48DA
    ld [wSndSeqIdx], a                            ; $48DB
    ret                                           ; $48DE


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_48DF::
    db $80, $90, $70, $60, $0a, $07, $0f, $0c, $27, $34, $f0, $34, $c7

; C: channel-1 effect init handler of ids 2D (table $41FA)
Sfx1_Init_2D::
    ldh a, [rDIV]                                 ; $48EC
    add $03                                       ; $48EE
    and $0f                                       ; $48F0
    ld hl, $48e7                                  ; $48F2
    call Snd_Sfx_Start                            ; $48F5
    ldh a, [rDIV]                                 ; $48F8
    and $bf                                       ; $48FA
    ldh [rNR13], a                                ; $48FC
    ld a, $c7                                     ; $48FE
    ldh [rNR14], a                                ; $4900
    jr Sfx1_InitTail_ClearFlag                    ; $4902

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4904::
    db $59, $83, $ac, $c1, $d6
    db $c1, $ac, $83, $59, $00

; C: channel-1 effect init handler of ids 2F (table $41FA). Owner (review page, 2026-10-13, by ear): sfx1 2F: unsure;
; listed as the D.J. performance screen SE 4 (05:554D).
Sfx1_Init_2F::
    ld a, $f0                                     ; $490E
    ld [wSndSfx1 + $7], a                         ; $4910
    ld a, $04                                     ; $4913
    ld hl, Sfx1_Data_4954                         ; $4915
    jp Snd_Sfx_Start                              ; $4918


; C: channel-1 effect step handler of ids 2F (table $4276)
Sfx1_Step_2F::
    call Snd_Sfx_TickCounter                      ; $491B
    and a                                         ; $491E
    ret nz                                        ; $491F

    ld bc, Sfx1_Data_4904                         ; $4920
    ld hl, wSndSfx1 + $4                          ; $4923
    ld a, [hl]                                    ; $4926
    inc [hl]                                      ; $4927
    ld l, a                                       ; $4928
    ld h, $00                                     ; $4929
    add hl, bc                                    ; $492B
    ld a, [hl]                                    ; $492C
    and a                                         ; $492D
    jr z, jr_01f_4940                             ; $492E

jr_01f_4930:
    ldh [rNR13], a                                ; $4930
    ld a, [wSndSfx1 + $7]                         ; $4932
    ldh [rNR12], a                                ; $4935
    ld a, $b8                                     ; $4937
    ldh [rNR11], a                                ; $4939
    ld a, $c7                                     ; $493B
    ldh [rNR14], a                                ; $493D
    ret                                           ; $493F


jr_01f_4940:
    xor a                                         ; $4940
    ld [wSndSfx1 + $4], a                         ; $4941
    ld a, [wSndSfx1 + $7]                         ; $4944
    sub $30                                       ; $4947
    ld [wSndSfx1 + $7], a                         ; $4949
    and a                                         ; $494C
    jp z, Sfx1_Stop                               ; $494D

    ld a, $06                                     ; $4950
    jr jr_01f_4930                                ; $4952

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4954::
    db $00, $b8, $f0, $06, $c7
    db $9c, $80, $f0, $10, $87

; C: channel-1 effect init handler of ids 2E (table $41FA)
Sfx1_Init_2E::
    ld hl, $4959                                  ; $495E
    ld a, $13                                     ; $4961
    jp Snd_Sfx_Start                              ; $4963


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4966::
    db $6e, $80, $c0, $ff, $87

; C: channel-1 effect init handler of ids 32 (table $41FA)
Sfx1_Init_32::
    ld a, $08                                     ; $496B
    ld hl, Sfx1_Data_4966                         ; $496D
    call Snd_Sfx_Start                            ; $4970
    jp Sfx1_InitTail_ClearFlag                    ; $4973


; C: channel-1 effect step handler of ids 32 (table $4276)
Sfx1_Step_32::
    call Snd_Sfx_TickCounter                      ; $4976
    and a                                         ; $4979
    ret nz                                        ; $497A

    ld hl, wSndSfx1 + $4                          ; $497B
    ld c, [hl]                                    ; $497E
    inc [hl]                                      ; $497F
    ld b, $00                                     ; $4980
    ld hl, Sfx1_Data_498E                         ; $4982
    add hl, bc                                    ; $4985
    ld a, [hl]                                    ; $4986
    ldh [rNR13], a                                ; $4987
    ld a, $87                                     ; $4989
    ldh [rNR14], a                                ; $498B
    ret                                           ; $498D


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_498E::
    db $e0, $d0, $c0, $b0, $a0, $90, $80, $c0, $b0, $a0, $90, $80, $70, $60, $a0, $90
    db $80, $70, $60, $50, $40, $90, $80, $70, $60, $50, $40, $30, $70, $60, $50, $40
    db $30, $20, $10, $65, $80, $e0, $20, $85

; C: channel-1 effect init handler of ids 33 (table $41FA)
Sfx1_Init_33::
    ld a, $85                                     ; $49B6
    ld [wSndSfx1 + $6], a                         ; $49B8
    ld a, $08                                     ; $49BB
    ld hl, $49b1                                  ; $49BD
    call Snd_Sfx_Start                            ; $49C0
    jp Sfx1_InitTail_ClearFlag                    ; $49C3


; C: channel-1 effect step handler of ids 33 (table $4276)
Sfx1_Step_33::
    call Snd_Sfx_TickCounter                      ; $49C6
    and a                                         ; $49C9
    ret nz                                        ; $49CA

    ld hl, wSndSfx1 + $4                          ; $49CB
    ld c, [hl]                                    ; $49CE
    inc [hl]                                      ; $49CF
    ld b, $00                                     ; $49D0
    ld hl, Sfx1_Data_49F3                         ; $49D2
    add hl, bc                                    ; $49D5
    ld a, [hl]                                    ; $49D6
    cp $11                                        ; $49D7
    jr z, jr_01f_49e3                             ; $49D9

jr_01f_49db:
    ldh [rNR13], a                                ; $49DB
    ld a, [wSndSfx1 + $6]                         ; $49DD
    ldh [rNR14], a                                ; $49E0
    ret                                           ; $49E2


jr_01f_49e3:
    ld hl, wSndSfx1 + $6                          ; $49E3
    inc [hl]                                      ; $49E6
    ld a, [hl]                                    ; $49E7
    and $07                                       ; $49E8
    or $80                                        ; $49EA
    ld [hl], a                                    ; $49EC
    xor a                                         ; $49ED
    ld [wSndSfx1 + $4], a                         ; $49EE
    jr jr_01f_49db                                ; $49F1

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_49F3::
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

jr_01f_4a42:
    xor a                                         ; $4A42
    ld [hl], a                                    ; $4A43

; C: channel-1 effect init handler of ids 34 (table $41FA)
Sfx1_Init_34_SeqStep::
    ld hl, wSndSeqIdx                             ; $4A44
    ld a, [hl]                                    ; $4A47
    cp $18                                        ; $4A48
    jr z, jr_01f_4a42                             ; $4A4A

    inc [hl]                                      ; $4A4C
    ld c, a                                       ; $4A4D
    ld b, $00                                     ; $4A4E
    ld hl, Sfx1_34_SeqIdx                         ; $4A50
    add hl, bc                                    ; $4A53
    ld a, [hl]                                    ; $4A54
    ld c, a                                       ; $4A55
    ld b, $00                                     ; $4A56
    ld hl, Sfx1_34_SeqRegs                        ; $4A58
    add hl, bc                                    ; $4A5B
    ld a, $0d                                     ; $4A5C
    jp Snd_Sfx_Start                              ; $4A5E


; I: step handler that no table lists (effect $34 uses the generic step; dead)
Unused_Sfx1_Step_4A61::
    call Snd_Sfx_TickCounter                      ; $4A61
    and a                                         ; $4A64
    jp z, Sfx1_Stop                               ; $4A65

    ret                                           ; $4A68


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4A69::
    db $00, $80, $b0, $b0, $87

; C: channel-1 effect init handler of ids 30 (table $41FA). Named after the caller of its id (SFX1_RUN_CELEBRATION,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_30_RunCelebration::
    ld a, $b0                                     ; $4A6E
    ld [wSndSfx1 + $6], a                         ; $4A70
    ld a, $01                                     ; $4A73
    ld hl, Sfx1_Data_4A69                         ; $4A75
    call Snd_Sfx_Start                            ; $4A78
    jp Sfx1_InitTail_ClearFlag                    ; $4A7B


; C: channel-1 effect step handler of ids 30 (table $4276). Named after the caller of its id (SFX1_RUN_CELEBRATION,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_30_RunCelebration::
    call Snd_Sfx_TickCounter                      ; $4A7E
    and a                                         ; $4A81
    ret nz                                        ; $4A82

    ld hl, wSndSfx1 + $6                          ; $4A83
    dec [hl]                                      ; $4A86
    ld a, [hl]                                    ; $4A87
    cp $10                                        ; $4A88
    jp z, Sfx1_Stop                               ; $4A8A

    ldh [rNR13], a                                ; $4A8D
    ret                                           ; $4A8F


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4A90::
    db $00, $80, $b0, $60, $87

; C: channel-1 effect init handler of ids 31 (table $41FA)
Sfx1_Init_31::
    ld a, $60                                     ; $4A95
    ld [wSndSfx1 + $6], a                         ; $4A97
    ld a, $01                                     ; $4A9A
    ld hl, Sfx1_Data_4A90                         ; $4A9C
    call Snd_Sfx_Start                            ; $4A9F
    jp Sfx1_InitTail_ClearFlag                    ; $4AA2


; C: channel-1 effect step handler of ids 31 (table $4276)
Sfx1_Step_31::
    call Snd_Sfx_TickCounter                      ; $4AA5
    and a                                         ; $4AA8
    ret nz                                        ; $4AA9

    ld hl, wSndSfx1 + $6                          ; $4AAA
    inc [hl]                                      ; $4AAD
    inc [hl]                                      ; $4AAE
    ld a, [hl]                                    ; $4AAF
    cp $f0                                        ; $4AB0
    jp z, Sfx1_Stop                               ; $4AB2

    ldh [rNR13], a                                ; $4AB5
    ret                                           ; $4AB7


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4AB8::
    db $4d, $80, $f5, $70, $87
    db $e7, $a7, $77, $d7, $87
    db $57, $77, $47, $27, $00

; C: channel-1 effect init handler of ids 38 (table $41FA). Named after the caller of its id (SFX1_CURSOR_MOVE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_38_CursorMove::
    ld a, $87                                     ; $4AC7
    ld [wSndSfx1 + $7], a                         ; $4AC9
    ld a, $03                                     ; $4ACC
    ld hl, Sfx1_Data_4AB8                         ; $4ACE
    jp Snd_Sfx_Start                              ; $4AD1


; C: channel-1 effect step handler of ids 38 (table $4276). Named after the caller of its id (SFX1_CURSOR_MOVE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_38_CursorMove::
    call Snd_Sfx_TickCounter                      ; $4AD4
    and a                                         ; $4AD7
    ret nz                                        ; $4AD8

    ld hl, $4abd                                  ; $4AD9
    jp Sfx1_StepRegTable                          ; $4ADC


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4ADF::
    db $36, $80, $f5, $e0, $86
    db $e7, $a7, $77, $d7, $87
    db $57, $67, $37, $47, $00

; C: channel-1 effect init handler of ids 37 (table $41FA). Named after the caller of its id (SFX1_COPY_BROWSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_37_CopyBrowse::
    ld a, $86                                     ; $4AEE
    ld [wSndSfx1 + $7], a                         ; $4AF0
    ld a, $03                                     ; $4AF3
    ld hl, Sfx1_Data_4ADF                         ; $4AF5
    jp Snd_Sfx_Start                              ; $4AF8


; C: channel-1 effect step handler of ids 37 (table $4276). Named after the caller of its id (SFX1_COPY_BROWSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_37_CopyBrowse::
    call Snd_Sfx_TickCounter                      ; $4AFB
    and a                                         ; $4AFE
    ret nz                                        ; $4AFF

    ld hl, $4ae4                                  ; $4B00
    jr Sfx1_StepRegTable                          ; $4B03

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B05::
    db $4b, $80, $b7, $10, $87, $87, $67, $47, $47, $37, $27, $37, $27, $17, $27, $27
    db $17, $00

; C: channel-1 effect init handler of ids 39 (table $41FA). Named after the caller of its id (SFX1_MENU_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_39_MenuChoose::
    ld a, $87                                     ; $4B17
    ld [wSndSfx1 + $7], a                         ; $4B19
    ld a, $04                                     ; $4B1C
    ld hl, Sfx1_Data_4B05                         ; $4B1E
    jp Snd_Sfx_Start                              ; $4B21


; C: channel-1 effect step handler of ids 39 (table $4276). Named after the caller of its id (SFX1_MENU_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_39_MenuChoose::
    call Snd_Sfx_TickCounter                      ; $4B24
    and a                                         ; $4B27
    ret nz                                        ; $4B28

    ld hl, $4b0a                                  ; $4B29
    jr Sfx1_StepRegTable                          ; $4B2C

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B2E::
    db $4e, $00, $f5, $00, $87
    db $e7, $a7, $77, $d7, $87
    db $57, $67, $37, $47, $00

; C: channel-1 effect init handler of ids 36 (table $41FA). Named after the caller of its id (SFX1_PAGE_STEP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_36_PageStep::
    ld a, $87                                     ; $4B3D
    ld [wSndSfx1 + $7], a                         ; $4B3F
    ld a, $03                                     ; $4B42
    ld hl, Sfx1_Data_4B2E                         ; $4B44
    jp Snd_Sfx_Start                              ; $4B47


; C: channel-1 effect step handler of ids 36 (table $4276). Named after the caller of its id (SFX1_PAGE_STEP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_36_PageStep::
    call Snd_Sfx_TickCounter                      ; $4B4A
    and a                                         ; $4B4D
    ret nz                                        ; $4B4E

    ld hl, $4b33                                  ; $4B4F
    jr Sfx1_StepRegTable                          ; $4B52

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B54::
    db $3d, $c0, $f5, $33, $87, $e7, $b7, $a7, $b7, $77, $57, $47, $37, $37, $27, $00

; C: channel-1 effect init handler of ids 35 (table $41FA). Named after the caller of its id (SFX1_RUN_JUMP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_35_RunJump::
    ld a, $87                                     ; $4B64
    ld [wSndSfx1 + $7], a                         ; $4B66
    ld a, $04                                     ; $4B69
    ld hl, Sfx1_Data_4B54                         ; $4B6B
    jp Snd_Sfx_Start                              ; $4B6E


; C: channel-1 effect step handler of ids 35 (table $4276). Named after the caller of its id (SFX1_RUN_JUMP,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_35_RunJump::
    call Snd_Sfx_TickCounter                      ; $4B71
    and a                                         ; $4B74
    ret nz                                        ; $4B75

    ld hl, $4b59                                  ; $4B76

; C: shared step: reads one byte of the table in HL at index $DD64 into NR12 until $00 (then Sfx1_Stop)
Sfx1_StepRegTable::
    push hl                                       ; $4B79
    ld hl, wSndSfx1 + $4                          ; $4B7A
    ld c, [hl]                                    ; $4B7D
    inc [hl]                                      ; $4B7E
    ld b, $00                                     ; $4B7F
    pop hl                                        ; $4B81
    add hl, bc                                    ; $4B82
    ld a, [hl]                                    ; $4B83
    and a                                         ; $4B84
    jp z, Sfx1_Stop                               ; $4B85

    ld c, $12                                     ; $4B88
    ldh [c], a                                    ; $4B8A
    inc c                                         ; $4B8B
    inc c                                         ; $4B8C
    ld a, [wSndSfx1 + $7]                         ; $4B8D
    ldh [c], a                                    ; $4B90
    ret                                           ; $4B91


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4B92::
    db $4c, $c0, $f5, $ee, $87
    db $e5, $b5, $a5, $b5, $75
    db $55, $45, $35, $45, $35
    db $35, $35, $25, $25, $00

; C: channel-1 effect init handler of ids 0F (table $41FA). Named after the caller of its id
; (SFX1_SPACE_FEVER_TARGET_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Init_0F_SpaceFeverTargetKill::
    ld a, $03                                     ; $4BA6
    ld hl, Sfx1_Data_4B92                         ; $4BA8
    jp Snd_Sfx_Start                              ; $4BAB


; C: channel-1 effect step handler of ids 0F (table $4276). Named after the caller of its id
; (SFX1_SPACE_FEVER_TARGET_KILL, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx1_Step_0F_SpaceFeverTargetKill::
    call Snd_Sfx_TickCounter                      ; $4BAE
    and a                                         ; $4BB1
    ret nz                                        ; $4BB2

    ld hl, wSndSfx1 + $4                          ; $4BB3
    ld c, [hl]                                    ; $4BB6
    inc [hl]                                      ; $4BB7
    ld b, $00                                     ; $4BB8
    ld hl, $4b97                                  ; $4BBA
    jr jr_01f_4be5                                ; $4BBD

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4BBF::
    db $4a, $00, $f2, $90, $87
    db $d3, $b3, $a3, $43, $43
    db $33, $33, $23, $23, $00

; C: channel-1 effect init handler of ids 11 (table $41FA). Named after the caller of its id (SFX1_CONFIRM,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_11_Confirm::
    ld a, $03                                     ; $4BCE
    ld hl, Sfx1_Data_4BBF                         ; $4BD0
    jp Snd_Sfx_Start                              ; $4BD3


; C: channel-1 effect step handler of ids 11 (table $4276). Named after the caller of its id (SFX1_CONFIRM,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_11_Confirm::
    call Snd_Sfx_TickCounter                      ; $4BD6
    and a                                         ; $4BD9
    ret nz                                        ; $4BDA

    ld hl, wSndSfx1 + $4                          ; $4BDB
    ld c, [hl]                                    ; $4BDE
    inc [hl]                                      ; $4BDF
    ld b, $00                                     ; $4BE0
    ld hl, $4bc4                                  ; $4BE2

jr_01f_4be5:
    add hl, bc                                    ; $4BE5
    ld a, [hl]                                    ; $4BE6
    and a                                         ; $4BE7
    jr z, jr_01f_4bf4                             ; $4BE8

    ld b, $86                                     ; $4BEA

jr_01f_4bec:
    ld c, $12                                     ; $4BEC
    ldh [c], a                                    ; $4BEE
    inc c                                         ; $4BEF
    inc c                                         ; $4BF0
    ld a, b                                       ; $4BF1
    ldh [c], a                                    ; $4BF2
    ret                                           ; $4BF3


jr_01f_4bf4:
    jp Sfx1_Stop                                  ; $4BF4


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4BF7::
    db $3b, $80, $f4, $dd, $87, $d2, $b2, $a2, $92, $82, $72, $62, $52, $23, $23, $13
    db $13, $00

; C: channel-1 effect init handler of ids 13 (table $41FA). Named after the caller of its id (SFX1_PANEL_CLOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Init_13_PanelClose::
    ld a, $03                                     ; $4C09
    ld hl, Sfx1_Data_4BF7                         ; $4C0B
    jp Snd_Sfx_Start                              ; $4C0E


; C: channel-1 effect step handler of ids 13 (table $4276). Named after the caller of its id (SFX1_PANEL_CLOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx1_Step_13_PanelClose::
    call Snd_Sfx_TickCounter                      ; $4C11
    and a                                         ; $4C14
    ret nz                                        ; $4C15

    ld hl, wSndSfx1 + $4                          ; $4C16
    ld c, [hl]                                    ; $4C19
    inc [hl]                                      ; $4C1A
    ld b, $00                                     ; $4C1B
    ld hl, $4bfc                                  ; $4C1D
    add hl, bc                                    ; $4C20
    ld a, [hl]                                    ; $4C21
    and a                                         ; $4C22
    jp z, Sfx1_Stop                               ; $4C23

    ld b, $87                                     ; $4C26
    jr jr_01f_4bec                                ; $4C28

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4C2A::
    db $3b, $80, $f4, $90, $87, $b2, $a2, $82, $72, $62, $43, $43, $33, $23, $23, $13
    db $00

; C: channel-1 effect init handler of ids 19 3A (table $41FA). Named after the caller of its ids
; (SFX1_COMPOSE_LAYOUT_KEY, SFX1_PICK_PHOTO, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function
; / caller, not by ear).
Sfx1_Init_19_3A_ComposeLayoutKey_PickPhoto::
    ld a, $02                                     ; $4C3B
    ld hl, Sfx1_Data_4C2A                         ; $4C3D
    jp Snd_Sfx_Start                              ; $4C40


; C: channel-1 effect step handler of ids 19 3A (table $4276). Named after the caller of its ids
; (SFX1_COMPOSE_LAYOUT_KEY, SFX1_PICK_PHOTO, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function
; / caller, not by ear).
Sfx1_Step_19_3A_ComposeLayoutKey_PickPhoto::
    call Snd_Sfx_TickCounter                      ; $4C43
    and a                                         ; $4C46
    ret nz                                        ; $4C47

    ld hl, wSndSfx1 + $4                          ; $4C48
    ld c, [hl]                                    ; $4C4B
    inc [hl]                                      ; $4C4C
    ld b, $00                                     ; $4C4D
    ld hl, $4c2f                                  ; $4C4F
    add hl, bc                                    ; $4C52
    ld a, [hl]                                    ; $4C53
    and a                                         ; $4C54
    jp z, Sfx1_Stop                               ; $4C55

    ld b, $87                                     ; $4C58
    jr jr_01f_4bec                                ; $4C5A

; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4C5C::
    db $00, $00, $5b, $0a, $86

; C: channel-1 effect init handler of ids 08 (table $41FA). Named after the caller of its id
; (SFX1_MAIN_MENU_PAGE_DOWN, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Init_08_MainMenuPageDown::
    ld a, [$4c5f]                                 ; $4C61
    ld hl, Sfx1_Data_4C5C                         ; $4C64
    ld [wSndSfx1 + $6], a                         ; $4C67
    ld a, $04                                     ; $4C6A
    jp Snd_Sfx_Start                              ; $4C6C


; C: channel-1 effect step handler of ids 08 (table $4276). Named after the caller of its id
; (SFX1_MAIN_MENU_PAGE_DOWN, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx1_Step_08_MainMenuPageDown::
    call Snd_Sfx_TickCounter                      ; $4C6F
    and a                                         ; $4C72
    ret nz                                        ; $4C73

    ld hl, wSndSfx1 + $4                          ; $4C74
    ld a, [hl]                                    ; $4C77
    inc [hl]                                      ; $4C78
    cp $07                                        ; $4C79
    jr z, jr_01f_4c99                             ; $4C7B

    cp $08                                        ; $4C7D
    jr z, jr_01f_4c9f                             ; $4C7F

    cp $09                                        ; $4C81
    jr z, jr_01f_4ca5                             ; $4C83

    cp $0a                                        ; $4C85
    jr z, jr_01f_4cab                             ; $4C87

    cp $0b                                        ; $4C89
    jp z, Sfx1_Stop                               ; $4C8B

    ld hl, wSndSfx1 + $6                          ; $4C8E
    inc [hl]                                      ; $4C91
    inc [hl]                                      ; $4C92
    ld a, [wSndSfx1 + $6]                         ; $4C93
    ldh [rNR13], a                                ; $4C96
    ret                                           ; $4C98


jr_01f_4c99:
    ld hl, Sfx1_Data_4CB1                         ; $4C99
    jp Snd_Sfx_LoadNR1x                           ; $4C9C


jr_01f_4c9f:
    ld hl, $4cb6                                  ; $4C9F
    jp Snd_Sfx_LoadNR1x                           ; $4CA2


jr_01f_4ca5:
    ld hl, $4cbb                                  ; $4CA5
    jp Snd_Sfx_LoadNR1x                           ; $4CA8


jr_01f_4cab:
    ld hl, $4cc0                                  ; $4CAB
    jp Snd_Sfx_LoadNR1x                           ; $4CAE


; C: inline data of the channel-1 handlers (register block / sequence)
Sfx1_Data_4CB1::
    db $00, $b9, $72, $9d, $c7, $00, $b9, $92, $a2, $c7, $00, $b9, $c2, $ac, $c7, $00
    db $b9, $e2, $c1, $c7, $3e, $08, $e0, $17, $3e, $80, $e0, $19, $21, $2f, $dd, $cb
    db $be, $c9, $00, $d0, $3a, $80, $2c, $2c, $2f, $2d, $3c, $1c, $2d, $3d

; C: channel-4 effect init handler of ids 09 (table $431A)
Sfx4_Init_09::
    ld a, $02                                     ; $4CDF
    ld hl, $4cd3                                  ; $4CE1
    jp Snd_Sfx_Start                              ; $4CE4


; C: channel-4 effect step handler of ids 09 (table $433E)
Sfx4_Step_09::
    call Snd_Sfx_TickCounter                      ; $4CE7
    and a                                         ; $4CEA
    ret nz                                        ; $4CEB

    ld hl, wSndSfx4 + $4                          ; $4CEC
    ld a, [hl]                                    ; $4CEF
    cp $15                                        ; $4CF0
    jp z, Sfx4_Stop                               ; $4CF2

    and $07                                       ; $4CF5
    ld c, a                                       ; $4CF7
    ld b, $00                                     ; $4CF8
    inc [hl]                                      ; $4CFA
    ld hl, $4cd7                                  ; $4CFB
    add hl, bc                                    ; $4CFE
    ld a, [hl]                                    ; $4CFF
    ldh [rNR43], a                                ; $4D00
    ld a, $80                                     ; $4D02
    ldh [rNR44], a                                ; $4D04
    ret                                           ; $4D06


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4D07::
    db $0c, $0d, $0e, $0f, $1c, $1d, $1e, $1f, $00, $00, $1f, $0b, $80, $00, $f3, $44
    db $80, $00, $e5, $45, $80, $00, $a4, $46, $80, $00, $d3, $44, $80, $00, $04, $08
    db $0c

; C: channel-4 effect init handler of ids 05 (table $431A). The name EraseAnim comes from the caller EraseAnim_Run
; (04:5165, the only request site); the owner confirmed it on 2026-10-26: the photo erase sound, not a Space Fever II
; one (his by-ear guess of 2026-10-13 withdrawn). Named after the caller of ...
Sfx4_Init_05_EraseAnim::
    ldh a, [rDIV]                                 ; $4D28
    and $03                                       ; $4D2A
    ld c, a                                       ; $4D2C
    ld b, $00                                     ; $4D2D
    ld hl, $4d24                                  ; $4D2F
    add hl, bc                                    ; $4D32
    ld c, [hl]                                    ; $4D33
    ld b, $00                                     ; $4D34
    ld hl, $4d14                                  ; $4D36
    add hl, bc                                    ; $4D39
    ld a, $a0                                     ; $4D3A
    jp Snd_Sfx_Start                              ; $4D3C


; C: channel-4 effect init handler of ids 06 (table $431A)
Sfx4_Init_06::
    ld a, $13                                     ; $4D3F
    ld hl, $4d10                                  ; $4D41
    jp Snd_Sfx_Start                              ; $4D44


; C: channel-4 effect step handler of ids 06 (table $433E)
Sfx4_Step_06::
    ld hl, wSndSfx4 + $4                          ; $4D47
    ld a, [hl]                                    ; $4D4A
    cp $b0                                        ; $4D4B
    jp z, Sfx4_Stop                               ; $4D4D

    ld c, [hl]                                    ; $4D50
    ld b, $00                                     ; $4D51
    inc [hl]                                      ; $4D53
    ld hl, wSndSfx4 + $5                          ; $4D54
    ld a, [hl]                                    ; $4D57
    and a                                         ; $4D58
    ret nz                                        ; $4D59

    ld hl, Sfx4_Data_4D07                         ; $4D5A
    add hl, bc                                    ; $4D5D
    ld a, [hl]                                    ; $4D5E
    and a                                         ; $4D5F
    jp z, Sfx4_Step_06_LoadNR4x                   ; $4D60

    ldh [rNR43], a                                ; $4D63
    ret                                           ; $4D65


; C: step 06 of the channel-4 effect when the table value is 0: $DD7D = 1, then Snd_Sfx_LoadNR4x with the data at
; $4D14 (branch target; code read 2026-10-19)
Sfx4_Step_06_LoadNR4x::
    ld a, $01                                     ; $4D66
    ld hl, wSndSfx4 + $5                          ; $4D68
    ld [hl], a                                    ; $4D6B
    ld hl, $4d14                                  ; $4D6C
    jp Snd_Sfx_LoadNR4x                           ; $4D6F


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4D72::
    db $00, $e1, $25, $80, $00, $61, $25, $80

; C: channel-4 effect init handler of ids 0B (table $431A)
Sfx4_Init_0B::
    ld a, $18                                     ; $4D7A
    ld hl, Sfx4_Data_4D72                         ; $4D7C
    jp Snd_Sfx_Start                              ; $4D7F


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4D82::
    db $00, $f1, $25, $80

; C: channel-4 effect init handler of ids 01 (table $431A). Named after the caller of its id (SFX4_STAMP_COMMIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_01_StampCommit::
    ld a, $07                                     ; $4D86
    ld hl, Sfx4_Data_4D82                         ; $4D88
    jp Snd_Sfx_Start                              ; $4D8B


; C: channel-4 effect step handler of ids 01 (table $433E). Named after the caller of its id (SFX4_STAMP_COMMIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_01_StampCommit::
    call Snd_Sfx_TickCounter                      ; $4D8E
    and a                                         ; $4D91
    ret nz                                        ; $4D92

    ld hl, wSndSfx4 + $4                          ; $4D93
    inc [hl]                                      ; $4D96
    ld a, [hl]                                    ; $4D97
    cp $01                                        ; $4D98
    jr z, jr_01f_4da2                             ; $4D9A

    cp $03                                        ; $4D9C
    jp z, Sfx4_Stop                               ; $4D9E

    ret                                           ; $4DA1


jr_01f_4da2:
    ld hl, $4d76                                  ; $4DA2
    jp Snd_Sfx_LoadNR4x                           ; $4DA5


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4DA8::
    db $00, $e3, $16, $80

; C: channel-4 effect init handler of ids 0D (table $431A)
Sfx4_Init_0D::
    ld a, $50                                     ; $4DAC
    ld hl, Sfx4_Data_4DA8                         ; $4DAE
    jp Snd_Sfx_Start                              ; $4DB1


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4DB4::
    db $00, $f0, $2e, $80

; C: channel-4 effect init handler of ids 0F (table $431A)
Sfx4_Init_0F::
    ld a, $18                                     ; $4DB8
    ld hl, Sfx4_Data_4DB4                         ; $4DBA
    jp Snd_Sfx_Start                              ; $4DBD


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4DC0::
    db $00, $f0, $08, $80, $09, $0a, $0b, $0c, $0d, $0e, $0f, $1c, $1d, $1e, $1f, $24
    db $25, $26, $27, $34, $35, $36, $37, $44, $45, $46, $47, $54, $55, $56, $57, $64
    db $65, $66, $67, $74, $75, $76, $77, $84, $85, $86, $87, $94, $95, $96, $97, $a4
    db $00

; C: channel-4 effect init handler of ids 0E (table $431A)
Sfx4_Init_0E::
    ld a, $02                                     ; $4DF1
    ld hl, Sfx4_Data_4DC0                         ; $4DF3
    jp Snd_Sfx_Start                              ; $4DF6


; C: channel-4 effect step handler of ids 0E (table $433E)
Sfx4_Step_0E::
    call Snd_Sfx_TickCounter                      ; $4DF9
    and a                                         ; $4DFC
    ret nz                                        ; $4DFD

    ld hl, wSndSfx4 + $4                          ; $4DFE
    ld c, [hl]                                    ; $4E01
    inc [hl]                                      ; $4E02
    ld hl, $4dc4                                  ; $4E03
    jr jr_01f_4e36                                ; $4E06

; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E08::
    db $00, $40, $4e, $80, $4c, $3f, $6b, $3d, $3c, $2f, $2e, $2d, $2c, $1f, $1e, $1d
    db $14, $07, $06, $05, $04, $03, $02, $01, $00

; C: channel-4 effect init handler of ids 07 (table $431A). Named after the caller of its id
; (SFX4_SPACE_FEVER_FIRE_SHOTS, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx4_Init_07_SpaceFeverFireShots::
    ld a, $01                                     ; $4E21
    ld hl, Sfx4_Data_4E08                         ; $4E23
    jp Snd_Sfx_Start                              ; $4E26


; C: channel-4 effect step handler of ids 07 (table $433E). Named after the caller of its id
; (SFX4_SPACE_FEVER_FIRE_SHOTS, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx4_Step_07_SpaceFeverFireShots::
    call Snd_Sfx_TickCounter                      ; $4E29
    and a                                         ; $4E2C
    ret nz                                        ; $4E2D

    ld hl, wSndSfx4 + $4                          ; $4E2E
    ld c, [hl]                                    ; $4E31
    inc [hl]                                      ; $4E32
    ld hl, $4e0c                                  ; $4E33

jr_01f_4e36:
    ld b, $00                                     ; $4E36
    add hl, bc                                    ; $4E38
    ld a, [hl]                                    ; $4E39
    and a                                         ; $4E3A
    jp z, Sfx4_Stop                               ; $4E3B

    ldh [rNR43], a                                ; $4E3E
    ret                                           ; $4E40


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E41::
    db $00, $e3, $17, $80, $00, $f4, $64, $c0

; C: channel-4 effect init handler of ids 0A (table $431A). Named after the caller of its id (SFX4_LINK_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_0A_LinkChoose::
    ld a, $18                                     ; $4E49
    ld hl, $4e45                                  ; $4E4B
    jp Snd_Sfx_Start                              ; $4E4E


jr_01f_4e51:
    ld hl, Sfx4_Data_4E41                         ; $4E51
    jp Snd_Sfx_LoadNR4x                           ; $4E54


; C: channel-4 effect step handler of ids 0A (table $433E). Named after the caller of its id (SFX4_LINK_CHOOSE,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_0A_LinkChoose::
    ld hl, wSndSfx4 + $4                          ; $4E57
    ld a, [hl]                                    ; $4E5A
    inc [hl]                                      ; $4E5B
    cp $08                                        ; $4E5C
    jr z, jr_01f_4e51                             ; $4E5E

    cp $30                                        ; $4E60
    jp z, Sfx4_Stop                               ; $4E62

    ret                                           ; $4E65


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E66::
    db $3a, $b4, $14, $c0, $3d, $90, $24, $c0

; C: channel-4 effect init handler of ids 12 (table $431A). Named after the caller of its id (SFX4_MUSIC_SELECT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_12_MusicSelect::
    ld a, $03                                     ; $4E6E
    ld hl, $4e6a                                  ; $4E70
    jp Snd_Sfx_Start                              ; $4E73


; C: channel-4 effect step handler of ids 12 (table $433E). Named after the caller of its id (SFX4_MUSIC_SELECT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_12_MusicSelect::
    call Snd_Sfx_TickCounter                      ; $4E76
    and a                                         ; $4E79
    ret nz                                        ; $4E7A

    ld hl, wSndSfx4 + $4                          ; $4E7B
    ld a, [hl]                                    ; $4E7E
    inc [hl]                                      ; $4E7F
    and a                                         ; $4E80
    jr z, jr_01f_4e89                             ; $4E81

    cp $02                                        ; $4E83
    jp z, Sfx4_Stop                               ; $4E85

    ret                                           ; $4E88


jr_01f_4e89:
    ld hl, Sfx4_Data_4E66                         ; $4E89
    jp Snd_Sfx_LoadNR4x                           ; $4E8C


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4E8F::
    db $00, $a2, $37, $80, $33, $f0, $5f, $c0

; C: channel-4 effect init handler of ids 04 (table $431A). Named after the caller of its id (SFX4_RUN_HURDLE_HIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_04_RunHurdleHit::
    ld a, $08                                     ; $4E97
    ld hl, $4e93                                  ; $4E99
    jp Snd_Sfx_Start                              ; $4E9C


; C: channel-4 effect step handler of ids 04 (table $433E). Named after the caller of its id (SFX4_RUN_HURDLE_HIT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_04_RunHurdleHit::
    call Snd_Sfx_TickCounter                      ; $4E9F
    and a                                         ; $4EA2
    ret nz                                        ; $4EA3

    ld hl, wSndSfx4 + $4                          ; $4EA4
    ld a, [hl]                                    ; $4EA7
    inc [hl]                                      ; $4EA8
    and a                                         ; $4EA9
    jr z, jr_01f_4eb2                             ; $4EAA

    cp $02                                        ; $4EAC
    jp z, Sfx4_Stop                               ; $4EAE

    ret                                           ; $4EB1


jr_01f_4eb2:
    ld hl, Sfx4_Data_4E8F                         ; $4EB2
    jp Snd_Sfx_LoadNR4x                           ; $4EB5


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4EB8::
    db $00, $f1, $34, $80

; C: channel-4 effect init handler of ids 11 (table $431A). Named after the caller of its id (SFX4_RUN_FLAG_HEIGHT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Init_11_RunFlagHeight::
    ld a, $0c                                     ; $4EBC
    ld hl, Sfx4_Data_4EB8                         ; $4EBE
    jp Snd_Sfx_Start                              ; $4EC1


; C: channel-4 effect step handler of ids 11 (table $433E). Named after the caller of its id (SFX4_RUN_FLAG_HEIGHT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx4_Step_11_RunFlagHeight::
    call Snd_Sfx_TickCounter                      ; $4EC4
    and a                                         ; $4EC7
    ret nz                                        ; $4EC8

    ld hl, wSndSfx4 + $4                          ; $4EC9
    ld a, [hl]                                    ; $4ECC
    inc [hl]                                      ; $4ECD
    cp $07                                        ; $4ECE
    jp z, Sfx4_Stop                               ; $4ED0

    ld hl, Sfx4_Data_4EB8                         ; $4ED3
    jp Snd_Sfx_LoadNR4x                           ; $4ED6


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4ED9::
    db $00, $f4, $5f, $80

; C: channel-4 effect init handler of ids 08 (table $431A). Named after the caller of its id
; (SFX4_SPACE_FEVER_PLAYER_DEATH, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller,
; not by ear).
Sfx4_Init_08_SpaceFeverPlayerDeath::
    call Snd_StopSong                             ; $4EDD
    ld a, $60                                     ; $4EE0
    ld hl, Sfx4_Data_4ED9                         ; $4EE2
    jp Snd_Sfx_Start                              ; $4EE5


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4EE8::
    db $00, $74, $5f, $80

; C: channel-4 effect init handler of ids 02 (table $431A)
Sfx4_Init_02::
    ld a, $60                                     ; $4EEC
    ld hl, Sfx4_Data_4EE8                         ; $4EEE
    jp Snd_Sfx_Start                              ; $4EF1


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4EF4::
    db $00, $f4, $57, $80

; C: channel-4 effect init handler of ids 0C (table $431A)
Sfx4_Init_0C::
    ld a, $40                                     ; $4EF8
    ld hl, Sfx4_Data_4EF4                         ; $4EFA
    jp Snd_Sfx_Start                              ; $4EFD


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F00::
    db $00, $f2, $3c, $80, $2c, $1f, $2e, $4d, $5c, $5d, $4e, $2f, $4f

; C: channel-4 effect init handler of ids 03 (table $431A)
Sfx4_Init_03::
    ld a, $38                                     ; $4F0D
    ld hl, Sfx4_Data_4F00                         ; $4F0F
    call Snd_Sfx_Start                            ; $4F12
    ldh a, [rDIV]                                 ; $4F15
    and $07                                       ; $4F17
    ld c, a                                       ; $4F19
    ld b, $00                                     ; $4F1A
    ld hl, $4f04                                  ; $4F1C

jr_01f_4f1f:
    add hl, bc                                    ; $4F1F
    ld a, [hl]                                    ; $4F20
    ldh [rNR43], a                                ; $4F21
    ld a, $80                                     ; $4F23
    ldh [rNR44], a                                ; $4F25
    ret                                           ; $4F27


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F28::
    db $00, $f2, $1c, $80

; C: channel-4 effect init handler of ids 10 (table $431A)
Sfx4_Init_10::
    ld a, $08                                     ; $4F2C
    ld hl, Sfx4_Data_4F00                         ; $4F2E
    jp Snd_Sfx_Start                              ; $4F31


; C: channel-4 effect step handler of ids 10 (table $433E)
Sfx4_Step_10::
    call Snd_Sfx_TickCounter                      ; $4F34
    and a                                         ; $4F37
    ret nz                                        ; $4F38

    ld hl, wSndSfx4 + $4                          ; $4F39
    ld a, [hl]                                    ; $4F3C
    cp $12                                        ; $4F3D
    jp z, Sfx4_Stop                               ; $4F3F

    and $07                                       ; $4F42
    ld c, a                                       ; $4F44
    ld b, $00                                     ; $4F45
    inc [hl]                                      ; $4F47
    ld hl, Sfx4_Data_4F4D                         ; $4F48
    jr jr_01f_4f1f                                ; $4F4B

; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F4D::
    db $0d, $1d, $0e, $0f, $0b, $1f, $1c, $0a, $1e

; C: shared channel-4 step handler (ids 02 03 05 08 0B 0C 0D 0F): Snd_Sfx_TickCounter until the limit; then the effect
; stops
Sfx4_Step_Generic::
    call Snd_Sfx_TickCounter                      ; $4F56
    and a                                         ; $4F59
    ret nz                                        ; $4F5A

; C: channel-4 effect ends: running id 0; NR42=$08; NR44=$80; busy flag off
Sfx4_Stop::
    xor a                                         ; $4F5B
    ld [wSndSfx4 + $1], a                         ; $4F5C
    ld a, $08                                     ; $4F5F
    ldh [rNR42], a                                ; $4F61
    ld a, $80                                     ; $4F63
    ldh [rNR44], a                                ; $4F65
    ld hl, wSndTrack4 + $f                        ; $4F67
    res 7, [hl]                                   ; $4F6A
    ret                                           ; $4F6C


; C: inline data of the channel-4 handlers (register block / sequence)
Sfx4_Data_4F6D::
    db $80, $00, $20, $40, $85

; C: channel-3 effect init handler of ids 07 (table $42F2)
Sfx3_Init_07::
    call Sfx3_Begin_Wave51AA                      ; $4F72
    ld a, [$4f70]                                 ; $4F75
    ld [wSndSfx3 + $5], a                         ; $4F78
    ld a, [$4f71]                                 ; $4F7B
    and $0f                                       ; $4F7E
    ld [wSndSfx3 + $6], a                         ; $4F80
    ld hl, Sfx4_Data_4F6D                         ; $4F83
    jp Snd_Sfx_LoadNR3x                           ; $4F86


; C: channel-3 effect step: counter +1 in $DD74; HL = pointer in $DD75/$DD76
Sfx3_StepAdvance::
    ld hl, wSndSfx3 + $4                          ; $4F89
    inc [hl]                                      ; $4F8C
    ld e, [hl]                                    ; $4F8D
    ld a, [wSndSfx3 + $5]                         ; $4F8E
    ld l, a                                       ; $4F91
    ld a, [wSndSfx3 + $6]                         ; $4F92
    ld h, a                                       ; $4F95
    ld a, e                                       ; $4F96
    ret                                           ; $4F97


; C: channel-3 effect step handler of ids 07 (table $4306)
Sfx3_Step_07::
    call Sfx3_StepAdvance                         ; $4F98
    cp $16                                        ; $4F9B
    jp z, Sfx3_Stop                               ; $4F9D

    cp $06                                        ; $4FA0
    jr c, jr_01f_4fb7                             ; $4FA2

    ld bc, $fff3                                  ; $4FA4

jr_01f_4fa7:
    add hl, bc                                    ; $4FA7
    ld a, l                                       ; $4FA8
    ldh [rNR33], a                                ; $4FA9
    ld [wSndSfx3 + $5], a                         ; $4FAB
    ld a, h                                       ; $4FAE
    ld [wSndSfx3 + $6], a                         ; $4FAF
    or $c0                                        ; $4FB2
    ldh [rNR34], a                                ; $4FB4
    ret                                           ; $4FB6


jr_01f_4fb7:
    ld bc, $000e                                  ; $4FB7
    jr jr_01f_4fa7                                ; $4FBA

; I: sets $DD0D (snd_freeze) = 1; no caller
Unused_Snd_SetFreeze::
    ld a, $01                                     ; $4FBC
    ld [wSndFreeze], a                            ; $4FBE
    ret                                           ; $4FC1


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_4FC2::
    db $80, $f6, $20, $62, $c7, $4f, $39, $21, $00

; C: channel-3 effect step handler of ids 09 (table $4306). Named after the caller of its id
; (SFX3_DELETE_DIALOG_SECOND, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Step_09_DeleteDialogSecond::
    ld hl, wSndSfx3 + $4                          ; $4FCB
    inc [hl]                                      ; $4FCE
    ld a, [hl]                                    ; $4FCF
    cp $07                                        ; $4FD0
    ret nz                                        ; $4FD2

    xor a                                         ; $4FD3
    ld [hl], a                                    ; $4FD4
    ldh [rNR30], a                                ; $4FD5
    inc l                                         ; $4FD7
    ld c, [hl]                                    ; $4FD8
    inc [hl]                                      ; $4FD9
    ld b, $00                                     ; $4FDA
    ld hl, $4fc7                                  ; $4FDC
    jr jr_01f_5009                                ; $4FDF

; C: channel-3 effect init handler of ids 09 (table $42F2). Named after the caller of its id
; (SFX3_DELETE_DIALOG_SECOND, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Init_09_DeleteDialogSecond::
    call Sfx3_Begin_Wave51EA                      ; $4FE1
    ld hl, Sfx3_Data_4FC2                         ; $4FE4
    jp Snd_Sfx_LoadNR3x                           ; $4FE7


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_4FEA::
    db $80, $f6, $20, $39, $c7, $59, $83, $9d, $ac, $c1, $00

; C: channel-3 effect step handler of ids 08 (table $4306). Named after the caller of its id
; (SFX3_DELETE_DIALOG_FIRST, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx3_Step_08_DeleteDialogFirst::
    ld hl, wSndSfx3 + $4                          ; $4FF5
    inc [hl]                                      ; $4FF8
    ld a, [hl]                                    ; $4FF9
    cp $07                                        ; $4FFA
    ret nz                                        ; $4FFC

    xor a                                         ; $4FFD
    ld [hl], a                                    ; $4FFE
    ldh [rNR30], a                                ; $4FFF
    inc l                                         ; $5001
    ld c, [hl]                                    ; $5002
    inc [hl]                                      ; $5003
    ld b, $00                                     ; $5004
    ld hl, $4fef                                  ; $5006

jr_01f_5009:
    add hl, bc                                    ; $5009
    ld a, $80                                     ; $500A
    ldh [rNR30], a                                ; $500C
    ld a, [hl]                                    ; $500E
    and a                                         ; $500F
    jp z, Sfx3_Stop                               ; $5010

    ldh [rNR33], a                                ; $5013
    ld a, $f6                                     ; $5015
    ldh [rNR31], a                                ; $5017
    ld a, $c7                                     ; $5019
    ldh [rNR34], a                                ; $501B
    ret                                           ; $501D


; C: channel-3 effect init handler of ids 08 (table $42F2). Named after the caller of its id
; (SFX3_DELETE_DIALOG_FIRST, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by
; ear).
Sfx3_Init_08_DeleteDialogFirst::
    call Sfx3_Begin_Wave51DA                      ; $501E
    ld hl, Sfx3_Data_4FEA                         ; $5021
    jp Snd_Sfx_LoadNR3x                           ; $5024


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_5027::
    db $80, $50, $20, $f0, $c6

; C: channel-3 effect step handler of ids 03 (table $4306). Named after the caller of its id
; (SFX3_SPACE_FEVER_BOSS_HIT, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Step_03_SpaceFeverBossHit::
    ld hl, wSndSfx3 + $4                          ; $502C
    inc [hl]                                      ; $502F
    ld a, [hl]                                    ; $5030
    cp $20                                        ; $5031
    jp z, Sfx3_Stop                               ; $5033

    cp $10                                        ; $5036
    jr c, jr_01f_5043                             ; $5038

    inc l                                         ; $503A
    dec [hl]                                      ; $503B
    dec [hl]                                      ; $503C
    dec [hl]                                      ; $503D

jr_01f_503e:
    ldh a, [rDIV]                                 ; $503E
    ldh [rNR33], a                                ; $5040
    ret                                           ; $5042


jr_01f_5043:
    inc l                                         ; $5043
    jr jr_01f_503e                                ; $5044

; C: channel-3 effect init handler of ids 03 (table $42F2). Named after the caller of its id
; (SFX3_SPACE_FEVER_BOSS_HIT, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Init_03_SpaceFeverBossHit::
    call Sfx3_Begin_Wave51CA                      ; $5046
    ld a, $f0                                     ; $5049
    ld [wSndSfx3 + $5], a                         ; $504B
    ld hl, Sfx3_Data_5027                         ; $504E
    jp Snd_Sfx_LoadNR3x                           ; $5051


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_5054::
    db $80, $50, $20, $e0, $c7

; C: channel-3 effect step handler of ids 02 (table $4306). Named after the caller of its id
; (SFX3_MAIN_MENU_VIEW_ARCADE, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Step_02_MainMenuViewArcade::
    ld hl, wSndSfx3 + $4                          ; $5059
    inc [hl]                                      ; $505C
    ld a, [hl]                                    ; $505D
    cp $20                                        ; $505E
    jp z, Sfx3_Stop                               ; $5060

    cp $0a                                        ; $5063
    jr c, jr_01f_507a                             ; $5065

    inc l                                         ; $5067
    dec [hl]                                      ; $5068
    dec [hl]                                      ; $5069
    dec [hl]                                      ; $506A
    dec [hl]                                      ; $506B
    dec [hl]                                      ; $506C
    dec [hl]                                      ; $506D

jr_01f_506e:
    ld a, [hl]                                    ; $506E
    and $f8                                       ; $506F
    ld c, a                                       ; $5071
    ldh a, [rDIV]                                 ; $5072
    and $07                                       ; $5074
    or c                                          ; $5076
    ldh [rNR33], a                                ; $5077
    ret                                           ; $5079


jr_01f_507a:
    inc l                                         ; $507A
    jr jr_01f_506e                                ; $507B

; C: channel-3 effect init handler of ids 02 (table $42F2). Named after the caller of its id
; (SFX3_MAIN_MENU_VIEW_ARCADE, sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not
; by ear).
Sfx3_Init_02_MainMenuViewArcade::
    call Sfx3_Begin_Wave51FA                      ; $507D
    ld a, $e0                                     ; $5080
    ld [wSndSfx3 + $5], a                         ; $5082
    ld hl, Sfx3_Data_5027                         ; $5085
    jp Snd_Sfx_LoadNR3x                           ; $5088


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_508B::
    db $80, $50, $20, $60, $c6

; C: channel-3 effect step handler of ids 04 (table $4306)
Sfx3_Step_04::
    ld hl, wSndSfx3 + $4                          ; $5090
    inc [hl]                                      ; $5093
    ld a, [hl]                                    ; $5094
    cp $13                                        ; $5095
    jp z, Sfx3_Stop                               ; $5097

    cp $04                                        ; $509A
    jr c, jr_01f_50a7                             ; $509C

    inc l                                         ; $509E
    inc [hl]                                      ; $509F
    inc [hl]                                      ; $50A0
    inc [hl]                                      ; $50A1
    inc [hl]                                      ; $50A2
    ld a, [hl]                                    ; $50A3

; C: shared tail of step 04 of the channel-3 effect: writes A to NR33 and returns (branch target; code read
; 2026-10-19)
Sfx3_Step_04_WriteNR33::
    ldh [rNR33], a                                ; $50A4
    ret                                           ; $50A6


jr_01f_50a7:
    ldh a, [rDIV]                                 ; $50A7
    jr Sfx3_Step_04_WriteNR33                     ; $50A9

; C: channel-3 effect init handler of ids 04 (table $42F2). Owner (review page, 2026-10-13, by ear): sfx3 04: unsure.
Sfx3_Init_04::
    call Sfx3_Begin_Wave51DA                      ; $50AB
    ld a, $60                                     ; $50AE
    ld [wSndSfx3 + $5], a                         ; $50B0
    ld hl, Sfx3_Data_508B                         ; $50B3
    jp Snd_Sfx_LoadNR3x                           ; $50B6


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_50B9::
    db $80, $50, $20, $10, $c4

; C: channel-3 effect step handler of ids 01 (table $4306). Named after the caller of its id (SFX3_MAIN_MENU_SHOOT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx3_Step_01_MainMenuShoot::
    ld hl, wSndSfx3 + $4                          ; $50BE
    inc [hl]                                      ; $50C1
    ld a, [hl]                                    ; $50C2
    cp $16                                        ; $50C3
    jp z, Sfx3_Stop                               ; $50C5

    cp $05                                        ; $50C8
    jr c, jr_01f_50a7                             ; $50CA

    inc l                                         ; $50CC
    inc [hl]                                      ; $50CD
    inc [hl]                                      ; $50CE
    inc [hl]                                      ; $50CF
    inc [hl]                                      ; $50D0
    inc [hl]                                      ; $50D1
    inc [hl]                                      ; $50D2
    ld a, [hl]                                    ; $50D3
    jp Sfx3_Step_04_WriteNR33                     ; $50D4


; C: channel-3 effect init handler of ids 01 (table $42F2). Named after the caller of its id (SFX3_MAIN_MENU_SHOOT,
; sound_names_jp.csv; owner rule 2026-10-26: sounds are tagged by function / caller, not by ear).
Sfx3_Init_01_MainMenuShoot::
    call Sfx3_Begin_Wave51FA                      ; $50D7
    ld a, $10                                     ; $50DA
    ld [wSndSfx3 + $5], a                         ; $50DC
    ld hl, Sfx3_Data_50B9                         ; $50DF
    jp Snd_Sfx_LoadNR3x                           ; $50E2


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_50E5::
    db $80, $50, $20, $40, $c5

; C: channel-3 effect step handler of ids 05 0A (table $4306)
Sfx3_Step_05_0A::
    ld hl, wSndSfx3 + $4                          ; $50EA
    inc [hl]                                      ; $50ED
    ld a, [hl]                                    ; $50EE
    cp $18                                        ; $50EF
    jr z, Sfx3_Stop                               ; $50F1

    cp $04                                        ; $50F3
    jr c, jr_01f_5101                             ; $50F5

    inc l                                         ; $50F7
    dec [hl]                                      ; $50F8
    dec [hl]                                      ; $50F9
    dec [hl]                                      ; $50FA
    dec [hl]                                      ; $50FB
    dec [hl]                                      ; $50FC
    dec [hl]                                      ; $50FD
    ld a, [hl]                                    ; $50FE
    ldh [rNR33], a                                ; $50FF

jr_01f_5101:
    ret                                           ; $5101


; C: channel-3 effect init handler of ids 05 0A (table $42F2)
Sfx3_Init_05_0A::
    call Sfx3_Begin_Wave51EA                      ; $5102
    ld a, $80                                     ; $5105
    ld [wSndSfx3 + $5], a                         ; $5107
    ld hl, Sfx3_Data_50E5                         ; $510A
    jp Snd_Sfx_LoadNR3x                           ; $510D


; C: inline data of the channel-3 handlers (register block / sequence)
Sfx3_Data_5110::
    db $80, $80, $20, $23, $c7

; C: channel-3 effect init handler of ids 06 (table $42F2)
Sfx3_Init_06::
    call Sfx3_Begin_Wave51BA                      ; $5115
    ld a, $23                                     ; $5118
    ld [wSndSfx3 + $6], a                         ; $511A

jr_01f_511d:
    ld hl, Sfx3_Data_5110                         ; $511D
    call Snd_Sfx_LoadNR3x                         ; $5120
    ret                                           ; $5123


jr_01f_5124:
    inc [hl]                                      ; $5124
    jr jr_01f_511d                                ; $5125

; C: channel-3 effect step handler of ids 06 (table $4306)
Sfx3_Step_06::
    ld hl, wSndSfx3 + $4                          ; $5127
    inc [hl]                                      ; $512A
    ld a, [hl+]                                   ; $512B
    cp $0a                                        ; $512C
    jr z, jr_01f_5124                             ; $512E

    cp $22                                        ; $5130
    jr z, jr_01f_5149                             ; $5132

    ld a, [hl+]                                   ; $5134
    and a                                         ; $5135
    jr z, jr_01f_5140                             ; $5136

    dec [hl]                                      ; $5138
    dec [hl]                                      ; $5139
    dec [hl]                                      ; $513A
    dec [hl]                                      ; $513B

jr_01f_513c:
    ld a, [hl]                                    ; $513C
    ldh [rNR33], a                                ; $513D
    ret                                           ; $513F


jr_01f_5140:
    inc [hl]                                      ; $5140
    inc [hl]                                      ; $5141
    inc [hl]                                      ; $5142
    inc [hl]                                      ; $5143
    inc [hl]                                      ; $5144
    inc [hl]                                      ; $5145
    inc [hl]                                      ; $5146
    jr jr_01f_513c                                ; $5147

jr_01f_5149:
    jr Sfx3_Stop                                  ; $5149

; C: channel-3 effect ends: running id 0; NR30=0; busy flag off; reloads the track-3 wave
Sfx3_Stop::
    xor a                                         ; $514B
    ld [wSndSfx3 + $1], a                         ; $514C
    ldh [rNR30], a                                ; $514F
    ld hl, wSndTrack3 + $f                        ; $5151
    res 7, [hl]                                   ; $5154
    ld a, [wSndTrack3 + $6]                       ; $5156
    ld l, a                                       ; $5159
    ld a, [wSndTrack3 + $7]                       ; $515A
    ld h, a                                       ; $515D
    jr jr_01f_518e                                ; $515E

; C: Sfx3_Begin then loads the wave pattern at $51FA into wave RAM
Sfx3_Begin_Wave51FA::
    call Sfx3_Begin                               ; $5160
    ld hl, Sfx3_Wave_51FA                         ; $5163
    jr jr_01f_518e                                ; $5166

; C: Sfx3_Begin then loads the wave pattern at $51BA into wave RAM
Sfx3_Begin_Wave51BA::
    call Sfx3_Begin                               ; $5168
    ld hl, Sfx3_Wave_51BA                         ; $516B
    jr jr_01f_518e                                ; $516E

; C: Sfx3_Begin then loads the wave pattern at $51CA into wave RAM
Sfx3_Begin_Wave51CA::
    call Sfx3_Begin                               ; $5170
    ld hl, Sfx3_Wave_51CA                         ; $5173
    jr jr_01f_518e                                ; $5176

; C: Sfx3_Begin then loads the wave pattern at $51DA into wave RAM
Sfx3_Begin_Wave51DA::
    call Sfx3_Begin                               ; $5178
    ld hl, Sfx3_Wave_51DA                         ; $517B
    jr jr_01f_518e                                ; $517E

; C: Sfx3_Begin then loads the wave pattern at $51EA into wave RAM
Sfx3_Begin_Wave51EA::
    call Sfx3_Begin                               ; $5180
    ld hl, Sfx3_Wave_51EA                         ; $5183
    jr jr_01f_518e                                ; $5186

; C: Sfx3_Begin then loads the wave pattern at $51AA into wave RAM
Sfx3_Begin_Wave51AA::
    call Sfx3_Begin                               ; $5188
    ld hl, Sfx3_Wave_51AA                         ; $518B

jr_01f_518e:
    jp Snd_LoadWaveRam                            ; $518E


; C: channel-3 SFX start: running id; busy flag on track 3; counters cleared; NR30=0 (DAC off); callers then load a
; wave and register block
Sfx3_Begin::
    ld de, wSndSfx3 + $1                          ; $5191
    ld a, [wSndTmp]                               ; $5194
    ld [de], a                                    ; $5197
    ld hl, wSndTrack3 + $f                        ; $5198
    set 7, [hl]                                   ; $519B
    xor a                                         ; $519D
    ld [wSndSfx3 + $4], a                         ; $519E
    ld [wSndSfx3 + $5], a                         ; $51A1
    ld [wSndSfx3 + $6], a                         ; $51A4
    ldh [rNR30], a                                ; $51A7
    ret                                           ; $51A9


; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51AA::
    db $a7, $13, $32, $3f, $ab, $cd, $ef, $a7, $f1, $f1, $f1, $f1, $f1, $f1, $49, $b9

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51BA::
    db $f1, $00, $f1, $f1, $f1, $f1, $f1, $f1, $77, $77, $77, $77, $71, $00, $a0, $00

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51CA::
    db $12, $13, $32, $3f, $89, $cd, $78, $97, $71, $61, $61, $61, $61, $61, $49, $b9

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51DA::
    db $00, $00, $98, $76, $54, $32, $10, $91, $f8, $76, $04, $32, $12, $38, $e9, $19

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51EA::
    db $34, $34, $00, $23, $23, $34, $34, $30, $00, $00, $00, $00, $00, $00, $e9, $00

; C: 16-byte wave pattern for channel-3 SFX
Sfx3_Wave_51FA::
    db $12, $34, $56, $f0, $77, $00, $77, $00, $77, $00, $77, $00, $76, $54, $32, $11

; C: starts an SFX: stores the running id ($DD51); counters = 0; sets the busy flag of the channel; loads the register
; block at HL
Snd_Sfx_Start::
    push af                                       ; $520A
    dec e                                         ; $520B
    ld a, [wSndTmp]                               ; $520C
    ld [de], a                                    ; $520F
    inc e                                         ; $5210
    pop af                                        ; $5211
    inc e                                         ; $5212
    ld [de], a                                    ; $5213
    dec e                                         ; $5214
    xor a                                         ; $5215
    ld [de], a                                    ; $5216
    inc e                                         ; $5217
    inc e                                         ; $5218
    ld [de], a                                    ; $5219
    inc e                                         ; $521A
    ld [de], a                                    ; $521B
    push hl                                       ; $521C
    ld a, e                                       ; $521D
    cp $65                                        ; $521E
    jr z, jr_01f_522c                             ; $5220

    cp $75                                        ; $5222
    jr z, jr_01f_5234                             ; $5224

    cp $7d                                        ; $5226
    jr z, jr_01f_523c                             ; $5228

    pop hl                                        ; $522A
    ret                                           ; $522B


jr_01f_522c:
    ld hl, wSndTrack1 + $f                        ; $522C
    set 7, [hl]                                   ; $522F
    pop hl                                        ; $5231
    jr Snd_Sfx_LoadNR1x                           ; $5232

jr_01f_5234:
    ld hl, wSndTrack3 + $f                        ; $5234
    set 7, [hl]                                   ; $5237
    pop hl                                        ; $5239
    jr Snd_Sfx_LoadNR3x                           ; $523A

jr_01f_523c:
    ld hl, wSndTrack4 + $f                        ; $523C
    set 7, [hl]                                   ; $523F
    pop hl                                        ; $5241
    jr Snd_Sfx_LoadNR4x                           ; $5242

; C: copies 5 bytes from HL to NR10-NR14
Snd_Sfx_LoadNR1x::
    push bc                                       ; $5244
    ld c, $10                                     ; $5245
    ld b, $05                                     ; $5247
    jr Snd_Sfx_LoadRegs                           ; $5249

; C: copies 4 bytes from HL to NR21-NR24 (no caller: channel 2 has no SFX)
Unused_Snd_Sfx_LoadNR2x::
    push bc                                       ; $524B
    ld c, $16                                     ; $524C
    ld b, $04                                     ; $524E
    jr Snd_Sfx_LoadRegs                           ; $5250

; C: copies 5 bytes from HL to NR30-NR34
Snd_Sfx_LoadNR3x::
    push bc                                       ; $5252
    ld c, $1a                                     ; $5253
    ld b, $05                                     ; $5255
    jr Snd_Sfx_LoadRegs                           ; $5257

; C: copies 4 bytes from HL to NR41-NR44
Snd_Sfx_LoadNR4x::
    push bc                                       ; $5259
    ld c, $20                                     ; $525A
    ld b, $04                                     ; $525C

; C: loop: B bytes from [HL+] to $FF00+C; C++
Snd_Sfx_LoadRegs::
    ld a, [hl+]                                   ; $525E
    ldh [c], a                                    ; $525F
    inc c                                         ; $5260
    dec b                                         ; $5261
    jr nz, Snd_Sfx_LoadRegs                       ; $5262

    pop bc                                        ; $5264
    ret                                           ; $5265


; C: parks the request id in $DD51 and falls through into Snd_Sfx_Lookup
Snd_Sfx_InitLookup::
    inc e                                         ; $5266
    ld [wSndTmp], a                               ; $5267

; C: HL = table + 2 * (A - 1) -> handler address in HL
Snd_Sfx_Lookup::
    inc e                                         ; $526A
    dec a                                         ; $526B
    sla a                                         ; $526C
    ld c, a                                       ; $526E
    ld b, $00                                     ; $526F
    add hl, bc                                    ; $5271
    ld c, [hl]                                    ; $5272
    inc hl                                        ; $5273
    ld b, [hl]                                    ; $5274
    ld l, c                                       ; $5275
    ld h, b                                       ; $5276
    ld a, h                                       ; $5277
    ret                                           ; $5278


; C: increments the frame counter at [DE]; Z (A=0) when it reaches the limit at [DE+1] and is reset; called by 47 step
; handlers
Snd_Sfx_TickCounter::
    push de                                       ; $5279
    ld l, e                                       ; $527A
    ld h, d                                       ; $527B
    inc [hl]                                      ; $527C
    ld a, [hl+]                                   ; $527D
    cp [hl]                                       ; $527E
    jr nz, jr_01f_5284                            ; $527F

    dec l                                         ; $5281
    xor a                                         ; $5282
    ld [hl], a                                    ; $5283

jr_01f_5284:
    pop de                                        ; $5284
    ret                                           ; $5285


; C: copies 16 bytes from HL to the wave RAM $FF30-$FF3F
Snd_LoadWaveRam::
    push bc                                       ; $5286
    ld c, $30                                     ; $5287

jr_01f_5289:
    ld a, [hl+]                                   ; $5289
    ldh [c], a                                    ; $528A
    inc c                                         ; $528B
    ld a, c                                       ; $528C
    cp $40                                        ; $528D
    jr nz, jr_01f_5289                            ; $528F

    pop bc                                        ; $5291
    ret                                           ; $5292


; C: NR51=$FF; song id and sequence variables cleared; no song plays afterwards
Snd_StopSong::
    ld a, $ff                                     ; $5293
    ldh [rNR51], a                                ; $5295
    ld a, $01                                     ; $5297
    ld [wSndU55], a                               ; $5299
    xor a                                         ; $529C
    ld [wSndSong], a                              ; $529D
    ld [wSndU0e], a                               ; $52A0
    ld [wSndU09], a                               ; $52A3
    ld [wSndU09 + $1], a                          ; $52A6
    ld [wSndSeqIdx], a                            ; $52A9

; C: clears the SFX running ids and the track busy flags; NR12/22/42=$08; NR14/24/44=$80; NR10/NR30=0
Snd_SilenceChannels::
    xor a                                         ; $52AC
    ld [wSndSfx1 + $1], a                         ; $52AD
    ld [wSndSfx3 + $1], a                         ; $52B0
    ld [wSndSfx4 + $1], a                         ; $52B3
    ld [wSndTrack1 + $f], a                       ; $52B6
    ld [wSndTrack2 + $f], a                       ; $52B9
    ld [wSndTrack3 + $f], a                       ; $52BC
    ld [wSndTrack4 + $f], a                       ; $52BF
    ld a, $08                                     ; $52C2
    ldh [rNR12], a                                ; $52C4
    ldh [rNR22], a                                ; $52C6
    ldh [rNR42], a                                ; $52C8
    ld a, $80                                     ; $52CA
    ldh [rNR14], a                                ; $52CC
    ldh [rNR24], a                                ; $52CE
    ldh [rNR44], a                                ; $52D0
    xor a                                         ; $52D2
    ldh [rNR10], a                                ; $52D3
    ldh [rNR30], a                                ; $52D5
    ret                                           ; $52D7


; C: channel-3 SFX: request $DD70 -> init (table $42F2; ids 1..10); running id $DD71 -> step (table $4306)
Snd_RunSfx3::
    ld de, wSndSfx3                               ; $52D8
    ld a, [de]                                    ; $52DB
    and a                                         ; $52DC
    jr z, jr_01f_52ea                             ; $52DD

    cp $0b                                        ; $52DF
    jr nc, jr_01f_52ea                            ; $52E1

    ld hl, Sfx3_InitTbl                           ; $52E3
    call Snd_Sfx_InitLookup                       ; $52E6
    jp hl                                         ; $52E9


jr_01f_52ea:
    inc e                                         ; $52EA
    ld a, [de]                                    ; $52EB
    and a                                         ; $52EC
    ret z                                         ; $52ED

    cp $0b                                        ; $52EE
    ret nc                                        ; $52F0

    ld hl, Sfx3_StepTbl                           ; $52F1
    call Snd_Sfx_Lookup                           ; $52F4
    jp hl                                         ; $52F7


; C: channel-1 SFX: request $DD60 -> init handler (table $41FA; ids 1..$3E); running id $DD61 -> step handler (table
; $4276)
Snd_RunSfx1::
    ld de, wSndSfx1                               ; $52F8
    ld a, [de]                                    ; $52FB
    and a                                         ; $52FC
    jr z, jr_01f_530a                             ; $52FD

    cp $3f                                        ; $52FF
    jr nc, jr_01f_530a                            ; $5301

    ld hl, Sfx1_InitTbl                           ; $5303
    call Snd_Sfx_InitLookup                       ; $5306
    jp hl                                         ; $5309


jr_01f_530a:
    inc e                                         ; $530A
    ld a, [de]                                    ; $530B
    and a                                         ; $530C
    ret z                                         ; $530D

    cp $3f                                        ; $530E
    ret nc                                        ; $5310

    ld hl, Sfx1_StepTbl                           ; $5311
    call Snd_Sfx_Lookup                           ; $5314
    jp hl                                         ; $5317


; C: channel-4 (noise) SFX: request $DD78 -> init (table $431A; ids 1..18); running id $DD79 -> step (table $433E)
Snd_RunSfx4::
    ld de, wSndSfx4                               ; $5318
    ld a, [de]                                    ; $531B
    and a                                         ; $531C
    jr z, jr_01f_532a                             ; $531D

    cp $13                                        ; $531F
    jr nc, jr_01f_532a                            ; $5321

    ld hl, Sfx4_InitTbl                           ; $5323
    call Snd_Sfx_InitLookup                       ; $5326
    jp hl                                         ; $5329


jr_01f_532a:
    inc e                                         ; $532A
    ld a, [de]                                    ; $532B
    and a                                         ; $532C
    ret z                                         ; $532D

    cp $13                                        ; $532E
    ret nc                                        ; $5330

    ld hl, Sfx4_StepTbl                           ; $5331
    call Snd_Sfx_Lookup                           ; $5334
    jp hl                                         ; $5337


; C: APU on (NR52=$80; NR50=$77; NR51=$FF) then clears $DD00-$DEFF
Snd_Init::
    ld a, $80                                     ; $5338
    ldh [rNR52], a                                ; $533A
    ld a, $77                                     ; $533C
    ldh [rNR50], a                                ; $533E
    ld a, $ff                                     ; $5340
    ldh [rNR51], a                                ; $5342
    ld hl, wSndUnused00                           ; $5344

jr_01f_5347:
    ld [hl], $00                                  ; $5347
    inc l                                         ; $5349
    jr nz, jr_01f_5347                            ; $534A

    inc h                                         ; $534C
    ld a, h                                       ; $534D
    cp $df                                        ; $534E
    jr nz, jr_01f_5347                            ; $5350

    ret                                           ; $5352


; C: jp Snd_StopSong (target of the $FF "reset" request)
Snd_StopSong_Tail::
    jp Snd_StopSong                               ; $5353


; C: $FF = stop; 1..$48 = start the song (header via the table at $57C6); other values ignored
Snd_RequestSong::
    cp $ff                                        ; $5356
    jr z, Snd_StopSong_Tail                       ; $5358

    cp $49                                        ; $535A
    ret nc                                        ; $535C

    ld [hl], a                                    ; $535D
    ld b, a                                       ; $535E
    ld hl, Snd_SongTbl                            ; $535F
    and $7f                                       ; $5362
    call Snd_Sfx_Lookup                           ; $5364
    call Snd_SongInit                             ; $5367
    jp Snd_PanReset                               ; $536A


; C: request $FE: only the channel-1 SFX runs; the music tick is skipped
Snd_Tick_MusicHold::
    call Snd_RunSfx1                              ; $536D
    xor a                                         ; $5370
    ld [wSndSfx1], a                              ; $5371
    xor a                                         ; $5374
    ld [wSndU5e], a                               ; $5375
    pop hl                                        ; $5378
    pop de                                        ; $5379
    pop bc                                        ; $537A
    pop af                                        ; $537B
    ret                                           ; $537C


; C: per-frame sound handler: music request ($DD68); the three SFX channels; then the music tick
Snd_Tick::
    push af                                       ; $537D
    push bc                                       ; $537E
    push de                                       ; $537F
    push hl                                       ; $5380
    ld hl, wSndMusicReq                           ; $5381
    ld a, [hl+]                                   ; $5384
    and a                                         ; $5385
    jr nz, Snd_Tick_MusicRequest                  ; $5386

    call Snd_RunSfx1                              ; $5388
    call Snd_RunSfx3                              ; $538B
    call Snd_RunSfx4                              ; $538E

; C: runs the music tick; then clears the four request mailboxes
Snd_Tick_RunMusic::
    call Snd_MusicTick                            ; $5391
    xor a                                         ; $5394
    ld [wSndSfx1], a                              ; $5395
    ld [wSndMusicReq], a                          ; $5398
    ld [wSndSfx3], a                              ; $539B
    ld [wSndSfx4], a                              ; $539E
    pop hl                                        ; $53A1
    pop de                                        ; $53A2
    pop bc                                        ; $53A3
    pop af                                        ; $53A4
    ret                                           ; $53A5


; C: music request in $DD68: $FE hold; else Snd_RequestSong
Snd_Tick_MusicRequest::
    cp $fe                                        ; $53A6
    jr z, Snd_Tick_MusicHold                      ; $53A8

    call Snd_RequestSong                          ; $53AA
    jr Snd_Tick_RunMusic                          ; $53AD

; C: NR51=$FF; $DD55=1 (end of Snd_RequestSong)
Snd_PanReset::
    ld a, $ff                                     ; $53AF
    ldh [rNR51], a                                ; $53B1
    ld a, $01                                     ; $53B3
    ld [wSndU55], a                               ; $53B5
    ret                                           ; $53B8


; I: loads a 6-byte record at $5856 + 6 * (song - 1) into $DD55..; no caller (UNREFERENCED; README 16.21)
Unused_Snd_SongPan_Load::
    ld a, [wSndSong]                              ; $53B9
    ld hl, Song10_Hdr                             ; $53BC

jr_01f_53bf:
    dec a                                         ; $53BF
    jr z, jr_01f_53ca                             ; $53C0

    inc hl                                        ; $53C2
    inc hl                                        ; $53C3
    inc hl                                        ; $53C4
    inc hl                                        ; $53C5
    inc hl                                        ; $53C6
    inc hl                                        ; $53C7
    jr jr_01f_53bf                                ; $53C8

jr_01f_53ca:
    ld bc, wSndU55                                ; $53CA
    ld a, [hl+]                                   ; $53CD
    ld [bc], a                                    ; $53CE
    inc c                                         ; $53CF
    xor a                                         ; $53D0
    ld [bc], a                                    ; $53D1
    inc c                                         ; $53D2
    ld a, [hl+]                                   ; $53D3
    ld [bc], a                                    ; $53D4
    inc c                                         ; $53D5
    xor a                                         ; $53D6
    ld [bc], a                                    ; $53D7
    inc c                                         ; $53D8
    ld a, [hl+]                                   ; $53D9
    ld [bc], a                                    ; $53DA
    ldh [rNR51], a                                ; $53DB
    inc c                                         ; $53DD
    ld a, [hl+]                                   ; $53DE
    ld [bc], a                                    ; $53DF
    inc c                                         ; $53E0
    ld a, [hl+]                                   ; $53E1
    ld [bc], a                                    ; $53E2
    inc c                                         ; $53E3
    ld a, [hl+]                                   ; $53E4
    ld [bc], a                                    ; $53E5
    ret                                           ; $53E6


; I: steps a panning sequence (NR51) from the $DD55 record; no caller (UNREFERENCED)
Unused_Snd_Pan_Step::
    ld hl, wSndU55                                ; $53E7
    ld a, [hl+]                                   ; $53EA
    cp $01                                        ; $53EB
    ret z                                         ; $53ED

    inc [hl]                                      ; $53EE
    ld a, [hl+]                                   ; $53EF
    cp [hl]                                       ; $53F0
    ret nz                                        ; $53F1

    dec l                                         ; $53F2
    ld [hl], $00                                  ; $53F3
    inc l                                         ; $53F5
    inc l                                         ; $53F6
    inc [hl]                                      ; $53F7
    ld a, [hl+]                                   ; $53F8
    and $03                                       ; $53F9
    ld c, l                                       ; $53FB
    ld b, h                                       ; $53FC
    and a                                         ; $53FD
    jr z, jr_01f_540b                             ; $53FE

    inc c                                         ; $5400
    cp $01                                        ; $5401
    jr z, jr_01f_540b                             ; $5403

    inc c                                         ; $5405
    cp $02                                        ; $5406
    jr z, jr_01f_540b                             ; $5408

    inc c                                         ; $540A

jr_01f_540b:
    ld a, [bc]                                    ; $540B
    ldh [rNR51], a                                ; $540C
    ret                                           ; $540E


; C: DE = [[HL]] .. [[HL]+1]: copies the 2-byte pattern pointer found at the list cursor
Snd_Trk_LoadFirstPattern::
    ld a, [hl+]                                   ; $540F
    ld c, a                                       ; $5410
    ld a, [hl]                                    ; $5411
    ld b, a                                       ; $5412
    ld a, [bc]                                    ; $5413
    ld [de], a                                    ; $5414
    inc e                                         ; $5415
    inc bc                                        ; $5416
    ld a, [bc]                                    ; $5417
    ld [de], a                                    ; $5418
    ret                                           ; $5419


; C: copies two bytes [HL+] -> [DE]; [DE+1]
Snd_Copy2::
    ld a, [hl+]                                   ; $541A
    ld [de], a                                    ; $541B
    inc e                                         ; $541C
    ld a, [hl+]                                   ; $541D
    ld [de], a                                    ; $541E
    ret                                           ; $541F


; C: copies the 11-byte song header: transposition; duration-table pointer; four track list pointers; first pattern
; pointers; counters = 1
Snd_SongInit::
    call Snd_SilenceChannels                      ; $5420
    ld de, wSndTranspose                          ; $5423
    ld b, $00                                     ; $5426
    ld a, [hl+]                                   ; $5428
    ld [de], a                                    ; $5429
    inc e                                         ; $542A
    call Snd_Copy2                                ; $542B
    ld de, wSndTrack1                             ; $542E
    call Snd_Copy2                                ; $5431
    ld de, wSndTrack2                             ; $5434
    call Snd_Copy2                                ; $5437
    ld de, wSndTrack3                             ; $543A
    call Snd_Copy2                                ; $543D
    ld de, wSndTrack4                             ; $5440
    call Snd_Copy2                                ; $5443
    ld hl, wSndTrack1                             ; $5446
    ld de, wSndTrack1 + $4                        ; $5449
    call Snd_Trk_LoadFirstPattern                 ; $544C
    ld hl, wSndTrack2                             ; $544F
    ld de, wSndTrack2 + $4                        ; $5452
    call Snd_Trk_LoadFirstPattern                 ; $5455
    ld hl, wSndTrack3                             ; $5458
    ld de, wSndTrack3 + $4                        ; $545B
    call Snd_Trk_LoadFirstPattern                 ; $545E
    ld hl, wSndTrack4                             ; $5461
    ld de, wSndTrack4 + $4                        ; $5464
    call Snd_Trk_LoadFirstPattern                 ; $5467
    ld bc, $0410                                  ; $546A
    ld hl, wSndTrack1 + $2                        ; $546D

jr_01f_5470:
    ld [hl], $01                                  ; $5470
    ld a, c                                       ; $5472
    add l                                         ; $5473
    ld l, a                                       ; $5474
    dec b                                         ; $5475
    jr nz, jr_01f_5470                            ; $5476

    xor a                                         ; $5478
    ld [wSndTrack1 + $e], a                       ; $5479
    ld [wSndTrack2 + $e], a                       ; $547C
    ld [wSndTrack3 + $e], a                       ; $547F
    ret                                           ; $5482


; C: track 3: DAC off and wave RAM reload from the instrument table
Snd_Op9D_LoadWaveTrk3::
    push hl                                       ; $5483
    xor a                                         ; $5484
    ldh [rNR30], a                                ; $5485
    ld l, e                                       ; $5487
    ld h, d                                       ; $5488
    call Snd_LoadWaveRam                          ; $5489
    pop hl                                        ; $548C
    jr jr_01f_54bf                                ; $548D

; C: $9D e d c: three operands stored in the track block (duty/envelope/wave); wave RAM reload on track 3
Snd_Op9D_SetInstrument::
    call Snd_Trk_PtrInc                           ; $548F
    call Snd_Trk_FetchByte                        ; $5492
    ld e, a                                       ; $5495
    call Snd_Trk_PtrInc                           ; $5496
    call Snd_Trk_FetchByte                        ; $5499
    ld d, a                                       ; $549C
    call Snd_Trk_PtrInc                           ; $549D
    call Snd_Trk_FetchByte                        ; $54A0
    ld c, a                                       ; $54A3
    ld a, [wSndFreeze]                            ; $54A4
    and a                                         ; $54A7
    jr nz, jr_01f_54b5                            ; $54A8

    inc l                                         ; $54AA
    inc l                                         ; $54AB
    ld [hl], e                                    ; $54AC
    inc l                                         ; $54AD
    ld [hl], d                                    ; $54AE
    inc l                                         ; $54AF
    ld [hl], c                                    ; $54B0
    dec l                                         ; $54B1
    dec l                                         ; $54B2
    dec l                                         ; $54B3
    dec l                                         ; $54B4

jr_01f_54b5:
    push hl                                       ; $54B5
    ld hl, wSndCurTrack                           ; $54B6
    ld a, [hl]                                    ; $54B9
    pop hl                                        ; $54BA
    cp $03                                        ; $54BB
    jr z, Snd_Op9D_LoadWaveTrk3                   ; $54BD

jr_01f_54bf:
    call Snd_Trk_PtrInc                           ; $54BF
    jp Snd_Trk_FetchOp                            ; $54C2


; C: pattern cursor (HL) += 1
Snd_Trk_PtrInc::
    push de                                       ; $54C5
    ld a, [hl+]                                   ; $54C6
    ld e, a                                       ; $54C7
    ld a, [hl-]                                   ; $54C8
    ld d, a                                       ; $54C9
    inc de                                        ; $54CA

jr_01f_54cb:
    ld a, e                                       ; $54CB
    ld [hl+], a                                   ; $54CC
    ld a, d                                       ; $54CD
    ld [hl-], a                                   ; $54CE
    pop de                                        ; $54CF
    ret                                           ; $54D0


; C: list cursor (HL) += 2
Snd_Trk_PtrInc2::
    push de                                       ; $54D1
    ld a, [hl+]                                   ; $54D2
    ld e, a                                       ; $54D3
    ld a, [hl-]                                   ; $54D4
    ld d, a                                       ; $54D5
    inc de                                        ; $54D6
    inc de                                        ; $54D7
    jr jr_01f_54cb                                ; $54D8

; C: A = B = [[HL]] (byte at the cursor)
Snd_Trk_FetchByte::
    ld a, [hl+]                                   ; $54DA
    ld c, a                                       ; $54DB
    ld a, [hl-]                                   ; $54DC
    ld b, a                                       ; $54DD
    ld a, [bc]                                    ; $54DE
    ld b, a                                       ; $54DF
    ret                                           ; $54E0


jr_01f_54e1:
    pop hl                                        ; $54E1
    jr Snd_Trk_Skip                               ; $54E2

; C: note still running: track 3 volume fix; vibrato call; SFX-busy check
Snd_Trk_Sustain::
    ld a, [wSndCurTrack]                          ; $54E4
    cp $03                                        ; $54E7
    jr nz, jr_01f_54fb                            ; $54E9

    ld a, [wSndTrack3 + $8]                       ; $54EB
    bit 7, a                                      ; $54EE
    jr z, jr_01f_54fb                             ; $54F0

    ld a, [hl]                                    ; $54F2
    cp $06                                        ; $54F3
    jr nz, jr_01f_54fb                            ; $54F5

    ld a, $40                                     ; $54F7
    ldh [rNR32], a                                ; $54F9

jr_01f_54fb:
    push hl                                       ; $54FB
    ld a, l                                       ; $54FC
    add $09                                       ; $54FD
    ld l, a                                       ; $54FF
    ld a, [hl]                                    ; $5500
    and a                                         ; $5501
    jr nz, jr_01f_54e1                            ; $5502

    ld a, l                                       ; $5504
    add $04                                       ; $5505
    ld l, a                                       ; $5507
    bit 7, [hl]                                   ; $5508
    jr nz, jr_01f_54e1                            ; $550A

    pop hl                                        ; $550C
    call Snd_Trk_Vibrato                          ; $550D

; C: track idle: step back to the track base and go to Snd_Trk_Next
Snd_Trk_Skip::
    dec l                                         ; $5510
    dec l                                         ; $5511
    jp Snd_Trk_Next                               ; $5512


; C: list cursor += 2; loads the next pattern; word hi $00 ends the whole song; hi $FF loops to the next word
Snd_Op00_EndPattern::
    dec l                                         ; $5515
    dec l                                         ; $5516
    dec l                                         ; $5517
    dec l                                         ; $5518
    call Snd_Trk_PtrInc2                          ; $5519

jr_01f_551c:
    ld a, l                                       ; $551C
    add $04                                       ; $551D
    ld e, a                                       ; $551F
    ld d, h                                       ; $5520
    call Snd_Trk_LoadFirstPattern                 ; $5521
    cp $00                                        ; $5524
    jr z, Snd_Song_End                            ; $5526

    cp $ff                                        ; $5528
    jr z, Snd_Op00_LoopList                       ; $552A

    inc l                                         ; $552C
    jp Snd_Trk_NextOp                             ; $552D


; C: loop marker: jump back to the address stored after $FFxx
Snd_Op00_LoopList::
    dec l                                         ; $5530
    push hl                                       ; $5531
    call Snd_Trk_PtrInc2                          ; $5532
    call Snd_Trk_FetchByte                        ; $5535
    ld e, a                                       ; $5538
    call Snd_Trk_PtrInc                           ; $5539
    call Snd_Trk_FetchByte                        ; $553C
    ld d, a                                       ; $553F
    pop hl                                        ; $5540
    ld a, e                                       ; $5541
    ld [hl+], a                                   ; $5542
    ld a, d                                       ; $5543
    ld [hl-], a                                   ; $5544
    jr jr_01f_551c                                ; $5545

; C: song finished: $DD69=0 then Snd_StopSong
Snd_Song_End::
    ld hl, wSndSong                               ; $5547
    ld [hl], $00                                  ; $554A
    call Snd_StopSong                             ; $554C
    ret                                           ; $554F


; C: $9E lo hi: duration table pointer -> $DD02/$DD03
Snd_Op9E_SetDurTable::
    call Snd_Trk_PtrInc                           ; $5550
    call Snd_Trk_FetchByte                        ; $5553
    ld [wSndDurTabLo], a                          ; $5556
    call Snd_Trk_PtrInc                           ; $5559
    call Snd_Trk_FetchByte                        ; $555C
    ld [wSndDurTabHi], a                          ; $555F
    jr jr_01f_556d                                ; $5562

; C: $9F n: transposition -> $DD01
Snd_Op9F_SetTranspose::
    call Snd_Trk_PtrInc                           ; $5564
    call Snd_Trk_FetchByte                        ; $5567
    ld [wSndTranspose], a                         ; $556A

jr_01f_556d:
    call Snd_Trk_PtrInc                           ; $556D
    jr Snd_Trk_FetchOp                            ; $5570

; C: $9B n: repeat count n; saves the pattern cursor for the matching $9C
Snd_Op9B_RepeatBegin::
    call Snd_Trk_PtrInc                           ; $5572
    call Snd_Trk_FetchByte                        ; $5575
    push hl                                       ; $5578
    ld a, l                                       ; $5579
    add $0b                                       ; $557A
    ld l, a                                       ; $557C
    ld c, [hl]                                    ; $557D
    ld a, b                                       ; $557E
    or c                                          ; $557F
    ld [hl], a                                    ; $5580
    ld b, h                                       ; $5581
    ld c, l                                       ; $5582
    dec c                                         ; $5583
    dec c                                         ; $5584
    pop hl                                        ; $5585
    ld a, [hl+]                                   ; $5586
    ld e, a                                       ; $5587
    ld a, [hl-]                                   ; $5588
    ld d, a                                       ; $5589
    inc de                                        ; $558A
    ld a, e                                       ; $558B
    ld [hl+], a                                   ; $558C
    ld a, d                                       ; $558D
    ld [hl-], a                                   ; $558E
    ld a, d                                       ; $558F
    ld [bc], a                                    ; $5590
    dec c                                         ; $5591
    ld a, e                                       ; $5592
    ld [bc], a                                    ; $5593
    jr Snd_Trk_FetchOp                            ; $5594

; C: $9C: count -1; jumps back to the saved cursor until the count is 0
Snd_Op9C_RepeatEnd::
    push hl                                       ; $5596
    ld a, l                                       ; $5597
    add $0b                                       ; $5598
    ld l, a                                       ; $559A
    ld a, [hl]                                    ; $559B
    dec [hl]                                      ; $559C
    ld a, [hl]                                    ; $559D
    and $7f                                       ; $559E
    jr z, jr_01f_55af                             ; $55A0

    ld b, h                                       ; $55A2
    ld c, l                                       ; $55A3
    dec c                                         ; $55A4
    dec c                                         ; $55A5
    dec c                                         ; $55A6
    pop hl                                        ; $55A7
    ld a, [bc]                                    ; $55A8
    ld [hl+], a                                   ; $55A9
    inc c                                         ; $55AA
    ld a, [bc]                                    ; $55AB
    ld [hl-], a                                   ; $55AC
    jr Snd_Trk_FetchOp                            ; $55AD

jr_01f_55af:
    pop hl                                        ; $55AF
    jr jr_01f_556d                                ; $55B0

; C: per-frame music tick: for track 1..4 count down the note; fetch ops until a note
Snd_MusicTick::
    ld hl, wSndSong                               ; $55B2
    ld a, [hl]                                    ; $55B5
    and a                                         ; $55B6
    ret z                                         ; $55B7

    ld a, $01                                     ; $55B8
    ld [wSndCurTrack], a                          ; $55BA
    ld hl, wSndTrack1                             ; $55BD

; C: head of the per-track loop
Snd_Trk_Loop::
    inc l                                         ; $55C0
    ld a, [hl+]                                   ; $55C1
    and a                                         ; $55C2
    jp z, Snd_Trk_Skip                            ; $55C3

    dec [hl]                                      ; $55C6
    jp nz, Snd_Trk_Sustain                        ; $55C7

; C: skips the counter bytes and fetches the next op
Snd_Trk_NextOp::
    inc l                                         ; $55CA
    inc l                                         ; $55CB

; C: op dispatch: $00 end of pattern; $9B/$9C repeat; $9D instrument; $9E duration table; $9F transpose; $A0-$AF
; duration + note; else note
Snd_Trk_FetchOp::
    call Snd_Trk_FetchByte                        ; $55CC
    cp $00                                        ; $55CF
    jp z, Snd_Op00_EndPattern                     ; $55D1

    cp $9d                                        ; $55D4
    jp z, Snd_Op9D_SetInstrument                  ; $55D6

    cp $9e                                        ; $55D9
    jp z, Snd_Op9E_SetDurTable                    ; $55DB

    cp $9f                                        ; $55DE
    jp z, Snd_Op9F_SetTranspose                   ; $55E0

    cp $9b                                        ; $55E3
    jp z, Snd_Op9B_RepeatBegin                    ; $55E5

    cp $9c                                        ; $55E8
    jp z, Snd_Op9C_RepeatEnd                      ; $55EA

    and $f0                                       ; $55ED
    cp $a0                                        ; $55EF
    jr nz, Snd_Trk_NoteOn                         ; $55F1

    ld a, b                                       ; $55F3
    and $0f                                       ; $55F4
    ld c, a                                       ; $55F6
    ld b, $00                                     ; $55F7
    push hl                                       ; $55F9
    ld de, wSndDurTabLo                           ; $55FA
    ld a, [de]                                    ; $55FD
    ld l, a                                       ; $55FE
    inc e                                         ; $55FF
    ld a, [de]                                    ; $5600
    ld h, a                                       ; $5601
    add hl, bc                                    ; $5602
    ld a, [hl]                                    ; $5603
    pop hl                                        ; $5604
    dec l                                         ; $5605
    ld [hl+], a                                   ; $5606
    call Snd_Trk_PtrInc                           ; $5607
    call Snd_Trk_FetchByte                        ; $560A

; C: note byte in B: frequency lookup (table $4039; transposed); track 4 uses the noise instrument table
Snd_Trk_NoteOn::
    ld c, b                                       ; $560D
    ld b, $00                                     ; $560E
    call Snd_Trk_PtrInc                           ; $5610
    ld a, [wSndCurTrack]                          ; $5613
    cp $04                                        ; $5616
    jp z, Snd_Trk4_NoteOn                         ; $5618

    push hl                                       ; $561B
    ld a, l                                       ; $561C
    add $05                                       ; $561D
    ld l, a                                       ; $561F
    ld e, l                                       ; $5620
    ld d, h                                       ; $5621
    inc l                                         ; $5622
    inc l                                         ; $5623
    ld a, c                                       ; $5624
    cp $01                                        ; $5625
    jr z, jr_01f_564a                             ; $5627

    ld [hl], $00                                  ; $5629
    ld a, [wSndTranspose]                         ; $562B
    and a                                         ; $562E
    jr z, jr_01f_563d                             ; $562F

    ld l, a                                       ; $5631
    ld h, $00                                     ; $5632
    bit 7, l                                      ; $5634
    jr z, jr_01f_563a                             ; $5636

    ld h, $ff                                     ; $5638

jr_01f_563a:
    add hl, bc                                    ; $563A
    ld b, h                                       ; $563B
    ld c, l                                       ; $563C

jr_01f_563d:
    ld hl, $4037                                  ; $563D
    add hl, bc                                    ; $5640
    ld a, [hl+]                                   ; $5641
    ld [de], a                                    ; $5642
    inc e                                         ; $5643
    ld a, [hl]                                    ; $5644
    ld [de], a                                    ; $5645
    pop hl                                        ; $5646
    jp Snd_Trk_WriteHw                            ; $5647


jr_01f_564a:
    ld [hl], $01                                  ; $564A
    pop hl                                        ; $564C
    jr Snd_Trk_WriteHw                            ; $564D

; C: noise track: copies the 5-byte instrument record at $40C9 + note to $DD46
Snd_Trk4_NoteOn::
    push hl                                       ; $564F
    ld de, wSndTrack4 + $6                        ; $5650
    ld hl, Snd_Trk4_InstrTbl                      ; $5653
    add hl, bc                                    ; $5656

jr_01f_5657:
    ld a, [hl+]                                   ; $5657
    ld [de], a                                    ; $5658
    inc e                                         ; $5659
    ld a, e                                       ; $565A
    cp $4b                                        ; $565B
    jr nz, jr_01f_5657                            ; $565D

    ld c, $20                                     ; $565F
    ld hl, wSndTrack4 + $4                        ; $5661
    ld b, $00                                     ; $5664
    jr jr_01f_56ac                                ; $5666

; C: writes the frequency / envelope registers of the current track unless an SFX owns the channel
Snd_Trk_WriteHw::
    push hl                                       ; $5668
    ld b, $00                                     ; $5669
    ld a, [wSndCurTrack]                          ; $566B
    cp $01                                        ; $566E
    jr z, jr_01f_5693                             ; $5670

    cp $02                                        ; $5672
    jr z, jr_01f_568f                             ; $5674

    ld c, $1a                                     ; $5676
    ld a, [wSndTrack3 + $f]                       ; $5678
    bit 7, a                                      ; $567B
    jr nz, jr_01f_5684                            ; $567D

    xor a                                         ; $567F
    ldh [c], a                                    ; $5680
    ld a, $80                                     ; $5681
    ldh [c], a                                    ; $5683

jr_01f_5684:
    inc c                                         ; $5684
    inc l                                         ; $5685
    inc l                                         ; $5686
    inc l                                         ; $5687
    inc l                                         ; $5688
    ld a, [hl+]                                   ; $5689
    ld e, a                                       ; $568A
    ld d, $00                                     ; $568B
    jr jr_01f_56b8                                ; $568D

jr_01f_568f:
    ld c, $16                                     ; $568F
    jr jr_01f_56ac                                ; $5691

jr_01f_5693:
    ld c, $10                                     ; $5693
    ld a, [wSndSong]                              ; $5695
    cp $01                                        ; $5698
    jr z, jr_01f_56a2                             ; $569A

    cp $1e                                        ; $569C
    jr z, jr_01f_56a2                             ; $569E

    jr jr_01f_56a9                                ; $56A0

jr_01f_56a2:
    ld b, $33                                     ; $56A2
    ld a, $1d                                     ; $56A4
    ldh [c], a                                    ; $56A6
    jr jr_01f_56ab                                ; $56A7

jr_01f_56a9:
    ld a, $00                                     ; $56A9

jr_01f_56ab:
    inc c                                         ; $56AB

jr_01f_56ac:
    inc l                                         ; $56AC
    inc l                                         ; $56AD
    inc l                                         ; $56AE
    ld a, [hl-]                                   ; $56AF
    and a                                         ; $56B0
    jr nz, jr_01f_56fd                            ; $56B1

    ld a, [hl+]                                   ; $56B3
    ld e, a                                       ; $56B4

jr_01f_56b5:
    inc l                                         ; $56B5
    ld a, [hl+]                                   ; $56B6
    ld d, a                                       ; $56B7

jr_01f_56b8:
    push hl                                       ; $56B8
    inc l                                         ; $56B9
    inc l                                         ; $56BA
    ld a, [hl+]                                   ; $56BB
    and a                                         ; $56BC
    jr z, jr_01f_56c1                             ; $56BD

    ld e, $08                                     ; $56BF

jr_01f_56c1:
    inc l                                         ; $56C1
    inc l                                         ; $56C2
    ld [hl], $00                                  ; $56C3
    inc l                                         ; $56C5
    ld a, [hl]                                    ; $56C6
    pop hl                                        ; $56C7
    bit 7, a                                      ; $56C8
    jr nz, jr_01f_56da                            ; $56CA

    ld a, d                                       ; $56CC
    or b                                          ; $56CD
    ldh [c], a                                    ; $56CE
    inc c                                         ; $56CF
    ld a, e                                       ; $56D0
    ldh [c], a                                    ; $56D1
    inc c                                         ; $56D2
    ld a, [hl+]                                   ; $56D3
    ldh [c], a                                    ; $56D4
    inc c                                         ; $56D5
    ld a, [hl]                                    ; $56D6
    or $c0                                        ; $56D7
    ldh [c], a                                    ; $56D9

jr_01f_56da:
    pop hl                                        ; $56DA
    dec l                                         ; $56DB
    ld a, [hl-]                                   ; $56DC
    ld [hl-], a                                   ; $56DD
    dec l                                         ; $56DE

; C: next track (stride $10); after track 4: counters of tracks 1-3 incremented and return
Snd_Trk_Next::
    ld de, wSndCurTrack                           ; $56DF
    ld a, [de]                                    ; $56E2
    cp $04                                        ; $56E3
    jr z, jr_01f_56f0                             ; $56E5

    inc a                                         ; $56E7
    ld [de], a                                    ; $56E8
    ld a, $10                                     ; $56E9
    add l                                         ; $56EB
    ld l, a                                       ; $56EC
    jp Snd_Trk_Loop                               ; $56ED


jr_01f_56f0:
    ld hl, wSndTrack1 + $e                        ; $56F0
    inc [hl]                                      ; $56F3
    ld hl, wSndTrack2 + $e                        ; $56F4
    inc [hl]                                      ; $56F7
    ld hl, wSndTrack3 + $e                        ; $56F8
    inc [hl]                                      ; $56FB
    ret                                           ; $56FC


jr_01f_56fd:
    ld b, $00                                     ; $56FD
    push hl                                       ; $56FF
    pop hl                                        ; $5700
    inc l                                         ; $5701
    jr jr_01f_56b5                                ; $5702

; C: E = nibble table byte at DE + (B >> 1)
Snd_Vib_Lookup::
    ld a, b                                       ; $5704
    srl a                                         ; $5705
    ld l, a                                       ; $5707
    ld h, $00                                     ; $5708
    add hl, de                                    ; $570A
    ld e, [hl]                                    ; $570B
    ret                                           ; $570C


; C: per-frame frequency modulation of the running note (depth in the low nibble of track byte +6; table $5771)
Snd_Trk_Vibrato::
    push hl                                       ; $570D
    ld a, l                                       ; $570E
    add $06                                       ; $570F
    ld l, a                                       ; $5711
    ld a, [hl]                                    ; $5712
    and $0f                                       ; $5713
    jr z, jr_01f_572f                             ; $5715

    ld [wSndTmp], a                               ; $5717
    ld a, [wSndCurTrack]                          ; $571A
    ld c, $13                                     ; $571D
    cp $01                                        ; $571F
    jr z, jr_01f_5731                             ; $5721

    ld c, $18                                     ; $5723
    cp $02                                        ; $5725
    jr z, jr_01f_5731                             ; $5727

    ld c, $1d                                     ; $5729
    cp $03                                        ; $572B
    jr z, jr_01f_5731                             ; $572D

jr_01f_572f:
    pop hl                                        ; $572F
    ret                                           ; $5730


jr_01f_5731:
    inc l                                         ; $5731
    ld a, [hl+]                                   ; $5732
    ld e, a                                       ; $5733
    ld a, [hl]                                    ; $5734
    ld d, a                                       ; $5735
    push de                                       ; $5736
    ld a, l                                       ; $5737
    add $04                                       ; $5738
    ld l, a                                       ; $573A
    ld b, [hl]                                    ; $573B
    ld a, [wSndTmp]                               ; $573C
    cp $01                                        ; $573F
    jr jr_01f_574c                                ; $5741

; I: dead tail after an unconditional jr in Snd_Trk_Vibrato; the bytes of a removed branch
Unused_Snd_Vib_Tail::
    cp $03                                        ; $5743
    jr jr_01f_5747                                ; $5745

jr_01f_5747:
    ld hl, hBootSp                                ; $5747
    jr jr_01f_5768                                ; $574A

jr_01f_574c:
    ld de, Snd_VibratoTbl                         ; $574C
    call Snd_Vib_Lookup                           ; $574F
    bit 0, b                                      ; $5752
    jr nz, jr_01f_5758                            ; $5754

    swap e                                        ; $5756

jr_01f_5758:
    ld a, e                                       ; $5758
    and $0f                                       ; $5759
    bit 3, a                                      ; $575B
    jr z, jr_01f_5765                             ; $575D

    ld h, $ff                                     ; $575F
    or $f0                                        ; $5761
    jr jr_01f_5767                                ; $5763

jr_01f_5765:
    ld h, $00                                     ; $5765

jr_01f_5767:
    ld l, a                                       ; $5767

jr_01f_5768:
    pop de                                        ; $5768
    add hl, de                                    ; $5769
    ld a, l                                       ; $576A
    ldh [c], a                                    ; $576B
    inc c                                         ; $576C
    ld a, h                                       ; $576D
    ldh [c], a                                    ; $576E
    jr jr_01f_572f                                ; $576F

; C: signed nibble offsets indexed by B>>1 (Snd_Vib_Lookup)
Snd_VibratoTbl::
    db $00, $00, $00, $00, $00, $00, $10, $00, $0f, $00, $00, $11, $00, $0f, $f0, $01
    db $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12
    db $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10
    db $ff, $ef, $01, $12, $10, $ff, $ef, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00

; C: 72 words: song id 1..$48 -> song header
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

; C: header of song id 10
Song10_Hdr::
    db $04, $b3, $41, $61, $58, $69, $58, $6f, $58, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song10_Trk1List::
    db $a3, $58, $ae, $58, $ff, $ff, $63, $58

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song10_Trk2List::
    db $aa, $58, $ff, $ff, $69, $58

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song10_Trk3List::
    db $7d, $58, $bb, $58, $d4, $58, $bb, $58, $da, $58, $ff, $ff, $6f, $58

; C: note pattern ($00 ends it)
Song10_Pat587D::
    db $9d, $02, $41, $21, $9b, $02, $a4, $5c, $a2, $01, $5c, $60, $62, $a7, $66, $a1
    db $62, $60, $a7, $62, $a1, $60, $5c, $a4, $56, $a2, $01, $56, $58, $5c, $a4, $60
    db $a7, $5c, $a2, $01, $9c, $00

; C: note pattern ($00 ends it)
Song10_Pat58A3::
    db $9d, $46, $00, $81, $a1, $01, $00

; C: note pattern ($00 ends it)
Song10_Pat58AA::
    db $9d, $83, $00, $c1

; C: note pattern ($00 ends it)
Song10_Pat58AE::
    db $9b, $08, $a2, $44, $52, $4e, $52, $4a, $52, $48, $52, $9c, $00

; C: note pattern ($00 ends it)
Song10_Pat58BB::
    db $a7, $70, $a1, $01, $6a, $a7, $6e, $a1, $01, $66, $a7, $6a, $a1, $01, $62, $a3
    db $66, $a2, $62, $60, $5c, $60, $62, $66, $00

; C: note pattern ($00 ends it)
Song10_Pat58D4::
    db $a3, $60, $58, $a5, $52, $00

; C: note pattern ($00 ends it)
Song10_Pat58DA::
    db $a2, $6a, $01, $a3, $60, $a4, $5c, $01, $00

; C: header of song id 46
Song46_UserMapScrollOut_Hdr::
    db $fa, $76, $41, $ee, $58, $f4, $58, $00, $00, $fc, $58

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song46_UserMapScrollOut_Trk1List::
    db $02, $59, $ff, $ff, $ee, $58

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song46_UserMapScrollOut_Trk2List::
    db $1d, $59, $06, $59, $ff, $ff, $f6, $58

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song46_UserMapScrollOut_Trk4List::
    db $22, $59, $ff, $ff, $fc, $58

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat5902::
    db $9d, $47, $00, $80

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat5906::
    db $a0, $62, $64, $66, $68, $6c, $6e, $70, $72, $74, $76, $78, $7a, $7c, $7e, $80
    db $82, $84, $86, $88, $8a, $8c, $00

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat591D::
    db $9d, $37, $00, $83, $00

; C: note pattern ($00 ends it)
Song46_UserMapScrollOut_Pat5922::
    db $9b, $10, $a1, $1f, $24, $9c, $00

; C: header of song id 2D. Owner (review page, 2026-10-13, by ear): music 2D: Ball BGM (sure)
Song2D_Hdr::
    db $12, $8b, $41, $3a, $59, $34, $59, $00, $00, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2D_Trk2List::
    db $40, $59, $ff, $ff, $34, $59

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2D_Trk1List::
    db $c3, $59, $ff, $ff, $3a, $59

; C: note pattern ($00 ends it)
Song2D_Pat5940::
    db $9d, $91, $00, $80, $a2, $32, $01, $32, $ad, $3a, $36, $32, $a3, $40, $3a, $a2
    db $32, $01, $32, $ad, $3a, $36, $32, $a3, $30, $32, $9d, $51, $00, $c0, $a2, $32
    db $01, $32, $ad, $3a, $36, $32, $a3, $40, $3a, $a2, $32, $01, $32, $ad, $40, $3c
    db $3a, $a3, $36, $32, $9d, $95, $00, $80, $a3, $01, $aa, $3c, $3c, $a3, $3c, $aa
    db $01, $9d, $75, $00, $c0, $a3, $01, $aa, $3a, $3a, $a3, $3a, $aa, $01, $9d, $36
    db $00, $80, $a3, $01, $aa, $3c, $3c, $a3, $3c, $aa, $01, $9d, $81, $00, $80, $a3
    db $01, $a2, $3a, $3a, $a1, $01, $a2, $3c, $a6, $40, $a2, $3c, $a2, $3a, $40, $a3
    db $3c, $3a, $36, $a3, $3a, $a7, $32, $9d, $f2, $00, $c0, $ad, $1a, $1a, $a3, $1a
    db $ad, $01, $00

; C: note pattern ($00 ends it)
Song2D_Pat59C3::
    db $9d, $72, $00, $81, $a4, $1a, $22, $1a, $18, $9d, $42, $00, $c1, $1a, $22, $a7
    db $1a, $ad, $22, $1e, $1a, $a3, $18, $1a, $9d, $75, $00, $81, $a3, $01, $aa, $1e
    db $1e, $a3, $1e, $aa, $01, $9d, $65, $00, $81, $a3, $01, $aa, $1a, $1a, $a3, $1a
    db $aa, $01, $9d, $45, $00, $c0, $a3, $01, $aa, $1e, $1e, $a3, $1e, $aa, $01, $9d
    db $72, $00, $81, $a3, $01, $a2, $22, $22, $a1, $01, $a2, $24, $a6, $28, $a2, $24
    db $a2, $22, $28, $a3, $1e, $1a, $18, $a3, $1a, $a7, $1a, $9d, $e2, $00, $c0, $ad
    db $02, $02, $a3, $02, $ad, $01, $00

; C: header of song ids 19 2A. Owner (review page, 2026-10-13, by ear): music 2A: Jambo Nintendo ! (sure)
Song19_Hdr::
    db $fc, $8b, $41, $3b, $5a, $35, $5a, $41, $5a, $47, $5a

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk2List::
    db $64, $5a, $ff, $ff, $35, $5a

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk1List::
    db $4d, $5a, $ff, $ff, $3b, $5a

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk3List::
    db $7a, $5a, $ff, $ff, $41, $5a

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song19_Trk4List::
    db $90, $5a, $ff, $ff, $47, $5a

; C: note pattern ($00 ends it)
Song19_Pat5A4D::
    db $9d, $81, $00, $c1, $a1, $6a, $62, $58, $01, $4a, $52, $01, $44, $4a, $54, $5c
    db $60, $01, $5c, $60, $62, $00, $00

; C: note pattern ($00 ends it)
Song19_Pat5A64::
    db $9d, $73, $00, $81, $a1, $52, $52, $4a, $01, $52, $58, $01, $54, $01, $4e, $01
    db $54, $5c, $01, $58, $01, $00

; C: note pattern ($00 ends it)
Song19_Pat5A7A::
    db $9d, $12, $41, $20, $a0, $4a, $32, $4a, $01, $a1, $52, $01, $a2, $4e, $54, $a2
    db $01, $a3, $28, $a2, $1e, $00

; C: note pattern ($00 ends it)
Song19_Pat5A90::
    db $a1, $15, $06, $a2, $10, $00

; C: header of song id 45
Song45_EraseJingle_Hdr::
    db $00, $76, $41, $a1, $5a, $a9, $5a, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song45_EraseJingle_Trk1List::
    db $af, $5a, $b1, $5a, $ff, $ff, $a3, $5a

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song45_EraseJingle_Trk2List::
    db $ea, $5a, $ff, $ff, $a9, $5a

; C: note pattern ($00 ends it)
Song45_EraseJingle_Pat5AAF::
    db $aa, $01

; C: note pattern ($00 ends it)
Song45_EraseJingle_Pat5AB1::
    db $9d, $37, $00, $81, $a2, $1c, $26, $30, $3a, $44, $4e, $9d, $57, $00, $81, $a2
    db $1e, $28, $32, $3c, $46, $50, $9d, $77, $00, $81, $a2, $20, $2a, $34, $3e, $42
    db $52, $9d, $97, $00, $81, $a2, $22, $2c, $36, $40, $42, $54, $9d, $b7, $00, $81
    db $a2, $24, $2e, $38, $42, $44, $56, $58, $00

; C: note pattern ($00 ends it)
Song45_EraseJingle_Pat5AEA::
    db $9d, $55, $00, $80, $a2, $1a, $24, $2e, $38, $42, $4c, $9d, $75, $00, $80, $1c
    db $26, $30, $3a, $44, $4e, $9d, $95, $00, $80, $1e, $28, $32, $3c, $46, $50, $9d
    db $b5, $00, $80, $20, $2a, $34, $3e, $42, $52, $9d, $d5, $00, $80, $22, $2c, $36
    db $40, $42, $54, $56, $00

; C: header of song id 30. Owner (review page, 2026-10-13, by ear): music 30: Who are you running from 2 / error
; message (sure)
Song30_Hdr::
    db $fc, $82, $41, $00, $00, $2a, $5b, $32, $5b, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song30_Trk2List::
    db $3a, $5b, $45, $5b, $ff, $ff, $2c, $5b

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song30_Trk3List::
    db $50, $5b, $5b, $5b, $ff, $ff, $34, $5b

; C: note pattern ($00 ends it)
Song30_Pat5B3A::
    db $9d, $d3, $00, $80, $a0, $12, $01, $10, $01, $0e, $01

; C: note pattern ($00 ends it)
Song30_Pat5B45::
    db $a2, $1a, $01, $1a, $16, $10, $a3, $16, $a2, $10, $00

; C: note pattern ($00 ends it)
Song30_Pat5B50::
    db $9d, $f2, $40, $21, $a0, $44, $01, $42, $01, $40, $01

; C: note pattern ($00 ends it)
Song30_Pat5B5B::
    db $a2, $01, $01, $52, $01, $4e, $a3, $46, $a2, $40, $52, $01, $52, $a4, $4e, $a2
    db $01, $00

; C: header of song id 29
Song29_TotakaTune_Hdr::
    db $02, $76, $41, $78, $5b, $80, $5b, $88, $5b, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song29_TotakaTune_Trk1List::
    db $3c, $7f, $90, $5b, $ff, $ff, $7a, $5b

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song29_TotakaTune_Trk2List::
    db $30, $7f, $ab, $5b, $ff, $ff, $82, $5b

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song29_TotakaTune_Trk3List::
    db $48, $7f, $c6, $5b, $ff, $ff, $8a, $5b

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat5B90::
    db $9d, $93, $00, $80, $a3, $02, $01, $02, $06, $a4, $0a, $06, $a5, $02, $01, $01
    db $a3, $04, $01, $04, $08, $a4, $0c, $08, $01, $01, $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat5BAB::
    db $9d, $b3, $00, $80, $a3, $1a, $01, $1a, $1e, $a4, $22, $1e, $a5, $1a, $01, $01
    db $a3, $1c, $01, $1c, $20, $a4, $24, $20, $01, $01, $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat5BC6::
    db $9d, $22, $41, $21, $a3, $32, $01, $32, $36, $a4, $3a, $36, $a5, $32, $01, $01
    db $a3, $34, $01, $34, $38, $a4, $3c, $38, $01, $01, $00

; C: header of song id 41
Song41_RunResult_Hdr::
    db $fa, $9b, $41, $ec, $5b, $f4, $5b, $fc, $5b, $04, $5c

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk1List::
    db $4b, $5c, $5c, $5c, $ff, $ff, $ee, $5b

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk2List::
    db $77, $5c, $90, $5c, $ff, $ff, $f6, $5b

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk3List::
    db $9e, $5c, $ba, $5c, $ff, $ff, $fe, $5b

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song41_RunResult_Trk4List::
    db $cd, $5c, $ff, $ff, $04, $5c

; C: header of song id 02
Song02_CreditsB_Hdr::
    db $00, $8b, $41, $15, $5c, $27, $5c, $31, $5c, $43, $5c

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk1List::
    db $dd, $5c, $1a, $5d, $1a, $5d, $1a, $5d, $36, $5d, $1a, $5d, $5b, $5d, $ff, $ff
    db $17, $5c

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk2List::
    db $e5, $5c, $7e, $5d, $85, $5d, $ff, $ff, $2b, $5c

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk3List::
    db $ed, $5c, $a1, $5e, $a1, $5e, $a1, $5e, $c6, $5e, $a1, $5e, $f8, $5e, $ff, $ff
    db $33, $5c

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song02_CreditsB_Trk4List::
    db $08, $5d, $07, $5f, $ff, $ff, $45, $5c

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C4B::
    db $9d, $7d, $00, $c1, $9b, $02, $a4, $48, $4e, $a2, $01, $a7, $3a, $a4, $38, $9c
    db $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C5C::
    db $9d, $93, $00, $81, $9b, $02, $a2, $60, $4e, $58, $a3, $5c, $a2, $66, $a3, $5c
    db $a2, $01, $52, $58, $5c, $50, $60, $a3, $5c, $9c, $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C77::
    db $9d, $c3, $00, $c1, $9b, $02, $a2, $58, $4e, $40, $58, $4e, $40, $58, $4e, $40
    db $58, $4c, $40, $58, $4a, $40, $01, $9c, $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C90::
    db $9d, $2f, $00, $41, $a4, $48, $40, $44, $4a, $48, $40, $44, $38, $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5C9E::
    db $9d, $12, $41, $21, $a4, $58, $a7, $60, $a2, $66, $01, $a7, $64, $a4, $62, $a4
    db $58, $a7, $60, $a2, $66, $01, $a7, $4c, $4a, $a2, $01, $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5CBA::
    db $9b, $02, $a7, $28, $a4, $30, $a2, $40, $a2, $01, $a3, $34, $a2, $40, $a3, $32
    db $40, $9c, $00

; C: note pattern ($00 ends it)
Song41_RunResult_Pat5CCD::
    db $a3, $01, $06, $01, $a2, $06, $06, $01, $01, $06, $06, $01, $06, $01, $01, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5CDD::
    db $9d, $81, $00, $c0, $a5, $14, $01, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5CE5::
    db $9d, $e4, $00, $81, $a5, $01, $01, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5CED::
    db $9d, $12, $41, $20, $a2, $44, $01, $01, $44, $a3, $3e, $a2, $01, $3e, $48, $01
    db $01, $48, $a6, $3a, $a1, $01, $a6, $36, $a1, $01, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D08::
    db $a2, $15, $01, $06, $06, $01, $01, $0b, $01, $01, $01, $06, $06, $01, $1a, $1a
    db $01, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D1A::
    db $9d, $93, $00, $c1, $9b, $04, $a2, $2c, $22, $2c, $a3, $3a, $a2, $2c, $22, $a3
    db $38, $a2, $2c, $26, $a3, $36, $a2, $2c, $a3, $26, $9c, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D36::
    db $9b, $02, $a2, $34, $2c, $26, $a7, $3a, $a2, $34, $2c, $30, $2c, $22, $a7, $3a
    db $a2, $30, $2a, $2c, $26, $1e, $a7, $34, $a2, $2c, $26, $2c, $26, $1e, $30, $26
    db $1e, $2c, $26, $9c, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D5B::
    db $a2, $0e, $26, $2c, $30, $a3, $34, $3a, $a2, $0c, $24, $2c, $30, $a3, $34, $3c
    db $a2, $0a, $22, $2c, $30, $a3, $34, $3a, $a2, $30, $2c, $26, $2c, $4c, $48, $44
    db $48, $00, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D7E::
    db $9b, $04, $a5, $01, $01, $9c, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5D85::
    INCBIN "data/bank_1f/Song02_CreditsB_Pat5D85.bin" ; $5D85, 284 bytes
; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5EA1::
    db $9d, $12, $41, $20, $9b, $04, $a3, $2c, $a2, $01, $a1, $2c, $01, $9d, $12, $41
    db $21, $a4, $26, $9d, $12, $41, $20, $a2, $01, $a7, $30, $a6, $22, $a1, $01, $a6
    db $2a, $a1, $01, $9c, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5EC6::
    db $9b, $02, $a4, $1e, $a1, $1e, $01, $1e, $01, $1e, $01, $1e, $01, $a6, $1c, $a1
    db $01, $a6, $1c, $a1, $01, $a4, $34, $a3, $30, $a2, $01, $a3, $36, $a2, $01, $a3
    db $3e, $a1, $22, $01, $22, $01, $22, $01, $22, $01, $9d, $12, $41, $21, $a4, $22
    db $9c, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5EF8::
    db $a4, $3e, $56, $3c, $54, $3a, $a7, $52, $a4, $38, $a2, $01, $a4, $22, $00

; C: note pattern ($00 ends it)
Song02_CreditsB_Pat5F07::
    db $9b, $0c, $a2, $15, $01, $06, $06, $1a, $01, $06, $06, $01, $15, $06, $06, $1a
    db $01, $06, $06, $9c, $00

; C: header of song id 2F
Song2F_DjTitle_Hdr::
    db $00, $76, $41, $27, $5f, $35, $5f, $43, $5f, $51, $5f

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk1List::
    db $57, $5f, $78, $5f, $57, $5f, $99, $5f, $ba, $5f, $ff, $ff, $27, $5f

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk2List::
    db $62, $5f, $83, $5f, $62, $5f, $a4, $5f, $c5, $5f, $ff, $ff, $35, $5f

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk3List::
    db $6d, $5f, $8e, $5f, $6d, $5f, $af, $5f, $d0, $5f, $ff, $ff, $43, $5f

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song2F_DjTitle_Trk4List::
    db $db, $5f, $ff, $ff, $51, $5f

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F57::
    db $9d, $51, $00, $80, $9b, $03, $a2, $24, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F62::
    db $9d, $61, $00, $80, $9b, $03, $a2, $1a, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F6D::
    db $9d, $f2, $40, $20, $9b, $03, $a2, $3c, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F78::
    db $9d, $a1, $00, $c0, $9b, $09, $aa, $3c, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F83::
    db $9d, $b1, $00, $c0, $9b, $09, $aa, $32, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F8E::
    db $9d, $f2, $40, $20, $9b, $09, $aa, $54, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5F99::
    db $9d, $41, $00, $40, $9b, $0c, $a0, $4a, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FA4::
    db $9d, $41, $00, $40, $9b, $0c, $a0, $54, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FAF::
    db $9d, $f2, $40, $40, $9b, $0c, $a0, $70, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FBA::
    db $9d, $71, $00, $40, $9b, $1b, $a0, $4c, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FC5::
    db $9d, $61, $00, $40, $9b, $1b, $a0, $56, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FD0::
    db $9d, $f2, $40, $20, $9b, $1b, $a0, $72, $01, $9c, $00

; C: note pattern ($00 ends it)
Song2F_DjTitle_Pat5FDB::
    db $a2, $15, $06, $06, $15, $06, $06, $1a, $06, $00

; C: header of song id 1B
Song1B_Hdr::
    db $10, $9b, $41, $f0, $5f, $f8, $5f, $fe, $5f, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1B_Trk1List::
    db $04, $60, $0f, $60, $ff, $ff, $f2, $5f

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1B_Trk2List::
    db $0b, $60, $ff, $ff, $f8, $5f

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1B_Trk3List::
    db $30, $60, $ff, $ff, $fe, $5f

; C: note pattern ($00 ends it)
Song1B_Pat6004::
    db $9d, $30, $00, $c1, $aa, $01, $00

; C: note pattern ($00 ends it)
Song1B_Pat600B::
    db $9d, $87, $00, $c0

; C: note pattern ($00 ends it)
Song1B_Pat600F::
    db $9b, $02, $a2, $32, $36, $40, $44, $4e, $52, $58, $52, $4e, $48, $44, $40, $9c
    db $9b, $02, $a2, $24, $32, $3c, $40, $44, $4e, $5c, $58, $52, $4e, $48, $44, $9c
    db $00

; C: note pattern ($00 ends it)
Song1B_Pat6030::
    db $9d, $22, $41, $21, $a8, $4a, $4e, $52, $58, $54, $58, $5c, $60, $62, $58, $52
    db $58, $54, $52, $4e, $a4, $44, $a3, $48, $00

; C: header of song ids 11 44. Owner (review page, 2026-10-13, by ear): music 44: used - credits, short; the header is
; shared with id 11; the callers of 44 are Mode0E_State06_ExchangeSetup / State0A_ExchangeSetupB, so the same tune is
; used both for the short credits and in the link exchange; name kept.
Song11_Jingle_Hdr::
    db $00, $76, $41, $54, $60, $5a, $60, $60, $60, $66, $60

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk1List::
    db $6c, $60, $ff, $ff, $54, $60

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk2List::
    db $85, $60, $ff, $ff, $5a, $60

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk3List::
    db $b1, $60, $ff, $ff, $60, $60

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song11_Jingle_Trk4List::
    db $cb, $60, $ff, $ff, $66, $60

; C: note pattern ($00 ends it)
Song11_Jingle_Pat606C::
    db $9d, $d1, $00, $80, $9b, $03, $a2, $10, $01, $28, $14, $01, $14, $28, $01, $9c
    db $10, $01, $28, $1e, $01, $10, $28, $01, $00

; C: note pattern ($00 ends it)
Song11_Jingle_Pat6085::
    db $9d, $81, $00, $80, $9b, $02, $a2, $01, $60, $60, $60, $60, $60, $60, $60, $5c
    db $60, $01, $58, $a4, $01, $a2, $01, $60, $60, $60, $60, $60, $60, $60, $5c, $62
    db $a8, $01, $9c, $9b, $08, $a3, $01, $30, $01, $30, $9c, $00

; C: note pattern ($00 ends it)
Song11_Jingle_Pat60B1::
    db $9d, $f2, $40, $21, $9b, $03, $a3, $28, $a2, $01, $2c, $01, $2c, $a3, $24, $9c
    db $a3, $28, $a2, $01, $36, $01, $28, $a3, $24, $00

; C: note pattern ($00 ends it)
Song11_Jingle_Pat60CB::
    db $a2, $15, $06, $06, $15, $06, $06, $1a, $06, $00

; C: header of song id 3C
Song3C_RunPickChar_Hdr::
    db $00, $8b, $41, $e0, $60, $e6, $60, $ec, $60, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3C_RunPickChar_Trk1List::
    db $f2, $60, $ff, $ff, $e0, $60

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3C_RunPickChar_Trk2List::
    db $09, $61, $ff, $ff, $e6, $60

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3C_RunPickChar_Trk3List::
    db $1f, $61, $ff, $ff, $ec, $60

; C: note pattern ($00 ends it)
Song3C_RunPickChar_Pat60F2::
    db $9d, $93, $00, $41, $a2, $7e, $7e, $7e, $80, $7e, $a1, $80, $7e, $a2, $76, $74
    db $70, $74, $76, $70, $a4, $74, $00

; C: note pattern ($00 ends it)
Song3C_RunPickChar_Pat6109::
    db $9d, $7b, $00, $81, $a3, $36, $a2, $38, $40, $a3, $44, $a2, $46, $4e, $a2, $46
    db $44, $40, $38, $a4, $36, $00

; C: note pattern ($00 ends it)
Song3C_RunPickChar_Pat611F::
    db $9d, $f2, $40, $21, $a3, $66, $a2, $68, $70, $a3, $74, $a2, $76, $7e, $a2, $76
    db $74, $70, $68, $a4, $66, $00

; C: header of song id 43
Song43_RunRaceScene_Hdr::
    db $00, $8b, $41, $40, $61, $46, $61, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song43_RunRaceScene_Trk1List::
    db $4c, $61, $ff, $ff, $40, $61

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song43_RunRaceScene_Trk2List::
    db $69, $61, $ff, $ff, $46, $61

; C: note pattern ($00 ends it)
Song43_RunRaceScene_Pat614C::
    db $9d, $b1, $00, $41, $9b, $02, $a2, $1a, $22, $9c, $9b, $02, $a2, $1e, $a1, $2c
    db $2c, $9c, $9b, $02, $a2, $1a, $22, $9c, $1e, $26, $06, $01, $00

; C: note pattern ($00 ends it)
Song43_RunRaceScene_Pat6169::
    db $9d, $9b, $00, $81, $a2, $52, $58, $5c, $58, $56, $01, $5c, $01, $52, $58, $5c
    db $58, $56, $a2, $01, $9d, $d1, $00, $c0, $a3, $06, $00

; C: header of song id 42
Song42_SpaceFeverBossInit_Hdr::
    db $00, $8b, $41, $8f, $61, $97, $61, $9f, $61, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song42_SpaceFeverBossInit_Trk1List::
    db $a7, $61, $e3, $61, $ff, $ff, $91, $61

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song42_SpaceFeverBossInit_Trk2List::
    db $b7, $61, $d7, $61, $ff, $ff, $99, $61

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song42_SpaceFeverBossInit_Trk3List::
    db $c7, $61, $f9, $61, $ff, $ff, $a1, $61

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61A7::
    db $9d, $d0, $00, $41, $9b, $02, $a7, $22, $a2, $01, $a7, $24, $a2, $01, $9c, $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61B7::
    db $9d, $e0, $00, $41, $9b, $02, $a7, $0a, $a2, $01, $a7, $0c, $a2, $01, $9c, $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61C7::
    db $9d, $f2, $40, $21, $9b, $02, $a7, $48, $a2, $01, $a7, $4a, $a2, $01, $9c, $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61D7::
    db $9d, $8a, $00, $81, $a9, $78, $76, $74, $72, $74, $76, $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61E3::
    db $9d, $e0, $00, $c1, $a0, $0a, $01, $0c, $01, $0e, $01, $10, $01, $12, $01, $10
    db $01, $0e, $01, $0c, $01, $00

; C: note pattern ($00 ends it)
Song42_SpaceFeverBossInit_Pat61F9::
    db $9d, $f2, $40, $20, $a0, $3a, $01, $3c, $01, $3e, $01, $40, $01, $42, $01, $40
    db $01, $3e, $01, $3c, $01, $00

; C: header of song id 34
Song34_UserScreens_Hdr::
    db $00, $82, $41, $1a, $62, $22, $62, $28, $62, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song34_UserScreens_Trk1List::
    db $2e, $62, $36, $62, $ff, $ff, $1c, $62

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song34_UserScreens_Trk2List::
    db $50, $62, $ff, $ff, $22, $62

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song34_UserScreens_Trk3List::
    db $8a, $62, $ff, $ff, $28, $62

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat622E::
    db $9d, $20, $00, $81, $aa, $01, $01, $00

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat6236::
    db $a2, $32, $3c, $46, $4a, $54, $5e, $62, $6c, $76, $7a, $84, $8e, $90, $86, $7c
    db $78, $6e, $64, $60, $56, $4c, $48, $3e, $34, $00

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat6250::
    db $9d, $57, $00, $81, $a2, $32, $3c, $46, $9d, $87, $00, $81, $4a, $54, $5e, $9d
    db $a7, $00, $81, $62, $6c, $76, $9d, $c7, $00, $81, $7a, $84, $8e, $9d, $e7, $00
    db $81, $90, $86, $7c, $9d, $b7, $00, $81, $78, $6e, $64, $9d, $87, $00, $81, $60
    db $56, $4c, $9d, $67, $00, $81, $48, $3e, $34, $00

; C: note pattern ($00 ends it)
Song34_UserScreens_Pat628A::
    db $9d, $22, $41, $20, $a0, $8a, $01, $8a, $01, $a5, $01, $01, $9b, $03, $a0, $8e
    db $01, $9c, $a5, $01, $01, $01, $00

; C: header of song id 2C
Song2C_BallMenu_Hdr::
    db $00, $82, $41, $ac, $62, $b2, $62, $b8, $62, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2C_BallMenu_Trk1List::
    db $be, $62, $ff, $ff, $ac, $62

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2C_BallMenu_Trk2List::
    db $d5, $62, $ff, $ff, $b2, $62

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song2C_BallMenu_Trk3List::
    db $ec, $62, $ff, $ff, $b8, $62

; C: note pattern ($00 ends it)
Song2C_BallMenu_Pat62BE::
    db $9d, $c1, $00, $80, $9b, $03, $a2, $01, $01, $4a, $9c, $a7, $01, $a5, $01, $a6
    db $56, $01, $01, $64, $a8, $01, $00

; C: note pattern ($00 ends it)
Song2C_BallMenu_Pat62D5::
    db $9d, $e1, $00, $80, $9b, $03, $a2, $32, $36, $3a, $9c, $a7, $01, $a5, $01, $a6
    db $5a, $68, $56, $01, $a8, $01, $00

; C: note pattern ($00 ends it)
Song2C_BallMenu_Pat62EC::
    db $9d, $22, $41, $20, $9b, $03, $a2, $01, $01, $54, $9c, $a7, $01, $a5, $01, $a6
    db $01, $64, $72, $80, $a8, $01, $00

; C: header of song id 39
Song39_ViewMenu_Hdr::
    db $00, $82, $41, $0e, $63, $14, $63, $1a, $63, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song39_ViewMenu_Trk1List::
    db $20, $63, $ff, $ff, $0e, $63

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song39_ViewMenu_Trk2List::
    db $52, $63, $ff, $ff, $14, $63

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song39_ViewMenu_Trk3List::
    db $81, $63, $ff, $ff, $1a, $63

; C: note pattern ($00 ends it)
Song39_ViewMenu_Pat6320::
    db $9d, $41, $00, $80, $a2, $48, $48, $48, $4a, $4a, $4a, $9d, $71, $00, $80, $a2
    db $48, $48, $48, $4a, $4a, $4a, $9d, $91, $00, $80, $a2, $48, $48, $48, $4a, $4a
    db $4a, $9d, $c1, $00, $80, $a2, $48, $48, $48, $9d, $e1, $00, $80, $a2, $4a, $4a
    db $4a, $00

; C: note pattern ($00 ends it)
Song39_ViewMenu_Pat6352::
    db $9d, $41, $00, $80, $a2, $36, $36, $36, $3a, $3a, $3a, $9d, $71, $00, $80, $36
    db $36, $36, $3a, $3a, $3a, $9d, $91, $00, $80, $a2, $36, $36, $36, $3a, $3a, $3a
    db $9d, $b1, $00, $80, $36, $36, $36, $9d, $d1, $00, $80, $3a, $3a, $3a, $00

; C: note pattern ($00 ends it)
Song39_ViewMenu_Pat6381::
    db $9d, $f2, $40, $21, $a3, $32, $a1, $58, $70, $a3, $3a, $a1, $66, $4e, $a3, $3c
    db $a1, $58, $70, $a3, $40, $a1, $66, $4e, $a3, $3c, $a1, $28, $40, $a3, $44, $a1
    db $36, $4e, $a3, $4a, $a1, $58, $70, $a3, $4e, $a1, $66, $7e, $00

; C: header of song id 38
Song38_CommentEditor_Hdr::
    db $00, $8b, $41, $b9, $63, $bf, $63, $c5, $63, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song38_CommentEditor_Trk1List::
    db $cb, $63, $ff, $ff, $b9, $63

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song38_CommentEditor_Trk2List::
    db $ff, $63, $ff, $ff, $bf, $63

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song38_CommentEditor_Trk3List::
    db $2a, $64, $ff, $ff, $c5, $63

; C: note pattern ($00 ends it)
Song38_CommentEditor_Pat63CB::
    db $9d, $51, $00, $81, $a2, $01, $36, $3a, $3e, $40, $44, $48, $9d, $a1, $00, $80
    db $a2, $4e, $01, $52, $56, $58, $5c, $9d, $91, $00, $80, $a2, $60, $64, $66, $6a
    db $56, $52, $4e, $9d, $c1, $00, $80, $a2, $4c, $48, $44, $9d, $e1, $00, $80, $a2
    db $01, $01, $40, $00

; C: note pattern ($00 ends it)
Song38_CommentEditor_Pat63FF::
    db $9d, $51, $00, $81, $a2, $48, $4c, $4e, $52, $56, $9d, $71, $00, $80, $58, $5c
    db $01, $60, $64, $01, $9d, $61, $00, $80, $a2, $66, $6a, $6e, $9d, $e1, $00, $80
    db $6a, $66, $01, $9d, $d1, $00, $80, $01, $64, $60, $00

; C: note pattern ($00 ends it)
Song38_CommentEditor_Pat642A::
    db $9d, $f2, $40, $21, $9b, $02, $a1, $58, $01, $36, $01, $66, $01, $52, $01, $6a
    db $01, $4e, $01, $66, $01, $40, $01, $9c, $6a, $01, $5c, $01, $66, $01, $48, $01
    db $60, $01, $4e, $01, $5c, $01, $52, $01, $00

; C: header of song id 36
Song36_Special_Hdr::
    db $02, $6b, $41, $5e, $64, $64, $64, $6a, $64, $70, $64

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk1List::
    db $76, $64, $ff, $ff, $5e, $64

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk2List::
    db $7f, $64, $ff, $ff, $64, $64

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk3List::
    db $88, $64, $ff, $ff, $6a, $64

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song36_Special_Trk4List::
    db $95, $64, $ff, $ff, $70, $64

; C: note pattern ($00 ends it)
Song36_Special_Pat6476::
    db $9d, $c1, $00, $80, $a2, $1e, $a1, $1e, $00

; C: note pattern ($00 ends it)
Song36_Special_Pat647F::
    db $9d, $e1, $00, $80, $a6, $06, $a1, $06, $00

; C: note pattern ($00 ends it)
Song36_Special_Pat6488::
    db $9d, $22, $41, $20, $a7, $58, $5c, $60, $52, $01, $4e, $01, $00

; C: note pattern ($00 ends it)
Song36_Special_Pat6495::
    db $a3, $15, $15, $1a, $1a, $00

; C: header of song id 37
Song37_Compose_Hdr::
    db $02, $82, $41, $a6, $64, $ae, $64, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song37_Compose_Trk1List::
    db $b6, $64, $ea, $64, $ff, $ff, $a6, $64

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song37_Compose_Trk2List::
    db $d0, $64, $01, $65, $ff, $ff, $ae, $64

; C: note pattern ($00 ends it)
Song37_Compose_Pat64B6::
    db $9d, $91, $00, $40, $a2, $40, $44, $48, $01, $40, $44, $48, $01, $9d, $41, $00
    db $40, $48, $4a, $48, $44, $40, $01, $01, $01, $00

; C: note pattern ($00 ends it)
Song37_Compose_Pat64D0::
    db $9d, $91, $00, $40, $a2, $56, $58, $5c, $01, $56, $58, $5c, $01, $9d, $41, $00
    db $40, $5c, $60, $5c, $58, $56, $01, $01, $01, $00

; C: note pattern ($00 ends it)
Song37_Compose_Pat64EA::
    db $9d, $71, $00, $80, $a2, $42, $46, $4a, $01, $42, $46, $4a, $01, $a5, $01, $a2
    db $5c, $60, $5c, $58, $a4, $01, $00

; C: note pattern ($00 ends it)
Song37_Compose_Pat6501::
    db $9d, $71, $00, $80, $a2, $56, $58, $5c, $01, $56, $58, $5c, $01, $a5, $01, $a2
    db $48, $4a, $48, $44, $a4, $01, $00

; C: header of song id 3A
Song3A_AlbumViewer_Hdr::
    db $02, $82, $41, $23, $65, $29, $65, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3A_AlbumViewer_Trk1List::
    db $2f, $65, $ff, $ff, $23, $65

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3A_AlbumViewer_Trk2List::
    db $55, $65, $ff, $ff, $29, $65

; C: note pattern ($00 ends it)
Song3A_AlbumViewer_Pat652F::
    db $9d, $91, $00, $80, $a3, $02, $52, $52, $01, $06, $54, $54, $01, $9d, $51, $00
    db $80, $0a, $52, $52, $0c, $a6, $54, $a1, $58, $a6, $01, $a1, $5c, $a6, $01, $a1
    db $58, $a6, $54, $a1, $52, $00

; C: note pattern ($00 ends it)
Song3A_AlbumViewer_Pat6555::
    db $9d, $91, $00, $80, $a3, $1a, $58, $58, $01, $1e, $5c, $5c, $01, $9d, $51, $00
    db $80, $22, $58, $58, $24, $a6, $4e, $a1, $52, $a6, $01, $a1, $54, $a6, $01, $a1
    db $52, $a6, $4e, $a1, $4a, $00

; C: header of song id 40
Song40_RunResultSetup_Hdr::
    db $00, $76, $41, $86, $65, $8c, $65, $92, $65, $98, $65

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk1List::
    db $9e, $65, $ff, $ff, $86, $65

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk2List::
    db $b4, $65, $ff, $ff, $8c, $65

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk3List::
    db $f9, $65, $ff, $ff, $92, $65

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song40_RunResultSetup_Trk4List::
    db $0f, $66, $ff, $ff, $98, $65

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat659E::
    db $9d, $c1, $00, $c0, $a3, $01, $40, $1a, $01, $01, $30, $0a, $01, $01, $32, $0c
    db $01, $01, $32, $0e, $01, $00

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat65B4::
    db $9d, $e2, $00, $80, $a6, $02, $a1, $01, $a6, $52, $a1, $01, $a6, $4a, $a1, $40
    db $a6, $28, $a1, $01, $a6, $4e, $a1, $01, $a6, $48, $a1, $42, $a6, $0a, $a1, $3a
    db $a6, $30, $a1, $01, $a6, $0c, $a1, $01, $a6, $44, $a1, $01, $a6, $4a, $a1, $4e
    db $a6, $32, $a1, $4a, $a6, $50, $a1, $01, $a6, $4e, $a1, $4a, $a6, $0e, $a1, $44
    db $a6, $36, $a1, $40, $00

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat65F9::
    db $9d, $f2, $40, $20, $a3, $1a, $52, $1a, $52, $22, $5a, $22, $5a, $24, $5c, $24
    db $5c, $26, $5c, $26, $5c, $00

; C: note pattern ($00 ends it)
Song40_RunResultSetup_Pat660F::
    db $a6, $15, $a1, $06, $a6, $0b, $a1, $06, $a6, $1a, $a1, $06, $a6, $0b, $a1, $06
    db $00

; C: header of song id 3D
Song3D_RunCountdown_Hdr::
    db $00, $76, $41, $2b, $66, $2f, $66, $31, $66, $33, $66

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk1List::
    db $35, $66, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk2List::
    db $4c, $66

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk3List::
    db $63, $66

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3D_RunCountdown_Trk4List::
    db $87, $66

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat6635::
    db $9d, $50, $00, $c1, $a4, $26, $2a, $9d, $70, $00, $c1, $a4, $2e, $32, $9d, $90
    db $00, $c1, $a4, $36, $a5, $3a, $00

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat664C::
    db $9d, $50, $00, $c1, $a4, $32, $36, $9d, $70, $00, $c1, $a4, $3a, $3e, $9d, $90
    db $00, $c1, $a4, $42, $a5, $46, $00

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat6663::
    db $9d, $f2, $40, $20, $9b, $04, $a1, $1e, $01, $9c, $9b, $04, $22, $01, $9c, $9b
    db $04, $26, $01, $9c, $9b, $04, $2a, $01, $9c, $9b, $04, $2e, $01, $9c, $9b, $12
    db $32, $01, $9c, $00

; C: note pattern ($00 ends it)
Song3D_RunCountdown_Pat6687::
    db $9b, $10, $a2, $0b, $0b, $0b, $0b, $1a, $1a, $1a, $1a, $9c, $00

; C: header of song id 3E
Song3E_RunReadySteadyGo_Hdr::
    db $fa, $8b, $41, $9f, $66, $a7, $66, $af, $66, $b7, $66

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk1List::
    db $c2, $66, $d7, $66, $ff, $ff, $a1, $66

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk2List::
    db $c9, $66, $e5, $66, $ff, $ff, $a9, $66

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk3List::
    db $d0, $66, $0b, $67, $ff, $ff, $b1, $66

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3E_RunReadySteadyGo_Trk4List::
    db $bf, $66, $3e, $67, $ff, $ff, $b9, $66

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66BF::
    db $a4, $01, $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66C2::
    db $9d, $e0, $00, $81, $a4, $74, $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66C9::
    db $9d, $e0, $00, $81, $a4, $70, $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66D0::
    db $9d, $f2, $40, $21, $a4, $72, $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66D7::
    db $9d, $c1, $00, $c0, $a3, $1a, $32, $30, $48, $2c, $44, $28, $40, $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat66E5::
    db $9d, $a1, $00, $40, $a1, $1a, $62, $40, $7a, $1a, $01, $40, $70, $18, $62, $40
    db $7a, $18, $01, $40, $70, $14, $62, $40, $7a, $14, $01, $40, $70, $10, $62, $40
    db $7a, $10, $10, $40, $10, $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat670B::
    db $9d, $f2, $40, $20, $a2, $32, $a1, $52, $01, $a2, $32, $a1, $52, $a0, $58, $6a
    db $a2, $30, $a1, $52, $70, $a2, $30, $a1, $52, $a0, $58, $6a, $a2, $2c, $a1, $52
    db $7a, $a2, $2c, $a1, $52, $a0, $58, $6a, $a2, $28, $a1, $52, $66, $a2, $28, $a1
    db $52, $74, $00

; C: note pattern ($00 ends it)
Song3E_RunReadySteadyGo_Pat673E::
    db $a1, $15, $06, $a2, $0b, $a1, $06, $06, $a2, $0b, $a1, $15, $06, $a2, $0b, $a1
    db $1a, $06, $a2, $0b, $00

; C: header of song id 3F
Song3F_RunRace_Hdr::
    db $00, $76, $41, $5e, $67, $62, $67, $64, $67, $66, $67

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk1List::
    db $68, $67, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk2List::
    db $7e, $67

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk3List::
    db $8f, $67

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3F_RunRace_Trk4List::
    db $9a, $67

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat6768::
    db $9d, $c0, $00, $c1, $a2, $4a, $3a, $4a, $4a, $32, $4a, $48, $40, $48, $a5, $52
    db $9f, $fa, $9e, $aa, $41, $00

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat677E::
    db $9d, $e0, $00, $c1, $a2, $52, $58, $52, $54, $44, $3c, $58, $4e, $58, $a5, $62
    db $00

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat678F::
    db $9d, $f2, $40, $21, $a7, $4a, $54, $58, $a5, $32, $00

; C: note pattern ($00 ends it)
Song3F_RunRace_Pat679A::
    db $a2, $0b, $06, $06, $0b, $06, $06, $0b, $06, $06, $9b, $10, $a0, $0b, $0b, $9c
    db $00

; C: header of song id 3B
Song3B_OwnerCard_Hdr::
    db $06, $76, $41, $b6, $67, $bc, $67, $c2, $67, $c8, $67

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk1List::
    db $ce, $67, $ff, $ff, $b6, $67

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk2List::
    db $ef, $67, $ff, $ff, $bc, $67

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk3List::
    db $4a, $68, $ff, $ff, $c2, $67

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song3B_OwnerCard_Trk4List::
    db $63, $68, $ff, $ff, $c8, $67

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat67CE::
    db $9d, $c1, $00, $c0, $9b, $08, $a3, $02, $32, $02, $32, $06, $36, $06, $36, $9c
    db $9d, $91, $00, $c0, $9b, $04, $a3, $02, $32, $02, $32, $06, $36, $06, $36, $9c
    db $00

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat67EF::
    db $9d, $e1, $00, $41, $9b, $02, $a6, $40, $a1, $01, $a6, $28, $a1, $40, $a6, $44
    db $a1, $4a, $a6, $28, $a1, $50, $a6, $01, $a1, $4e, $a6, $2c, $a1, $4a, $a6, $01
    db $a1, $44, $a6, $2c, $a1, $40, $9c, $9b, $02, $a6, $01, $a1, $01, $a6, $28, $a1
    db $38, $a6, $3a, $a1, $28, $a6, $44, $a1, $01, $a6, $38, $a1, $01, $a6, $36, $a1
    db $01, $a6, $32, $a1, $01, $a6, $2c, $a1, $32, $9c, $9d, $91, $00, $40, $9b, $02
    db $a3, $01, $28, $01, $28, $01, $2c, $01, $2c, $9c, $00

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat684A::
    db $9d, $f2, $40, $20, $a3, $1a, $a2, $52, $01, $a3, $1a, $a2, $52, $01, $a3, $1e
    db $a2, $54, $01, $a3, $1e, $a2, $54, $01, $00

; C: note pattern ($00 ends it)
Song3B_OwnerCard_Pat6863::
    db $a6, $15, $a1, $06, $a6, $0b, $a1, $06, $a6, $1a, $a1, $06, $a6, $06, $a1, $0b
    db $00

; C: header of song ids 01 1E
Song01_Title_Hdr::
    db $00, $8b, $41, $7f, $68, $87, $68, $8f, $68, $9b, $68

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk1List::
    db $a7, $68, $d5, $68, $ff, $ff, $81, $68

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk2List::
    db $b8, $68, $74, $69, $ff, $ff, $89, $68

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk3List::
    db $c2, $68, $9a, $69, $9a, $69, $07, $6a, $ff, $ff, $91, $68

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song01_Title_Trk4List::
    db $ce, $68, $0e, $6a, $0e, $6a, $3c, $6a, $ff, $ff, $9d, $68

; C: note pattern ($00 ends it)
Song01_Title_Pat68A7::
    db $9d, $f1, $00, $80, $ad, $32, $32, $9d, $51, $00, $80, $a0, $62, $90, $1a, $48
    db $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68B8::
    db $9d, $f3, $00, $40, $ad, $08, $08, $a2, $01, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68C2::
    db $9d, $12, $41, $20, $ab, $0e, $01, $0e, $01, $a2, $01, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68CE::
    db $ad, $06, $06, $a2, $01, $00, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat68D5::
    db $9d, $f1, $00, $80, $a3, $10, $01, $58, $01, $a6, $10, $10, $a2, $10, $a3, $58
    db $a1, $01, $a6, $10, $a3, $10, $01, $58, $01, $a6, $10, $10, $a2, $10, $9d, $61
    db $00, $80, $a0, $70, $70, $6a, $6a, $62, $62, $58, $58, $9d, $e1, $00, $80, $a1
    db $10, $9d, $31, $00, $80, $a0, $10, $28, $9d, $61, $00, $80, $40, $58, $9d, $81
    db $00, $80, $70, $88, $9d, $f1, $00, $80, $a6, $10, $10, $a2, $10, $a1, $4a, $4a
    db $01, $01, $a9, $01, $10, $10, $a4, $10, $4a, $a1, $02, $01, $4a, $4a, $01, $4a
    db $4a, $01, $9d, $61, $00, $80, $a0, $32, $28, $9d, $f1, $00, $80, $a1, $01, $4a
    db $4a, $a1, $01, $01, $4a, $4a, $9d, $41, $00, $80, $9b, $04, $a0, $70, $70, $9c
    db $9d, $71, $00, $80, $9b, $04, $a0, $58, $58, $9c, $9d, $a1, $00, $80, $9b, $04
    db $a0, $40, $40, $9c, $9d, $e1, $00, $80, $9b, $04, $a0, $28, $28, $9c, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat6974::
    db $9d, $7d, $00, $80, $a1, $74, $14, $01, $74, $01, $14, $74, $01, $0a, $74, $01
    db $01, $74, $01, $01, $74, $01, $10, $74, $01, $06, $74, $01, $01, $74, $18, $01
    db $74, $01, $06, $74, $01, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat699A::
    db $9d, $fa, $51, $20, $a0, $38, $01, $38, $01, $a1, $01, $38, $01, $a0, $32, $01
    db $3a, $01, $a1, $01, $40, $01, $01, $9b, $05, $a0, $01, $ab, $5e, $ac, $01, $9c
    db $a3, $01, $a0, $4c, $01, $56, $01, $4c, $01, $2e, $01, $a1, $01, $01, $46, $2e
    db $01, $a0, $46, $48, $a2, $01, $a0, $38, $01, $38, $01, $a1, $01, $38, $01, $a0
    db $32, $01, $3a, $01, $a1, $01, $40, $01, $01, $9b, $05, $ab, $4a, $ac, $01, $a0
    db $54, $9c, $9b, $06, $ab, $01, $80, $9c, $a1, $01, $ad, $66, $01, $6e, $01, $74
    db $01, $6e, $01, $66, $01, $01, $01, $a0, $76, $78, $a2, $01, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat6A07::
    db $9b, $04, $a5, $01, $01, $9c, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat6A0E::
    db $9b, $02, $a1, $01, $06, $a0, $06, $06, $a1, $06, $01, $06, $01, $a0, $06, $06
    db $06, $06, $a1, $10, $06, $01, $01, $06, $0b, $06, $9c, $9b, $08, $a1, $06, $01
    db $01, $10, $9c, $9b, $04, $a0, $06, $06, $a1, $01, $06, $0b, $9c, $00

; C: note pattern ($00 ends it)
Song01_Title_Pat6A3C::
    db $a5, $01, $01, $00

; C: header of song id 35
Song35_RecordHiScore_Hdr::
    db $00, $8b, $41, $4b, $6a, $51, $6a, $57, $6a, $5d, $6a

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk1List::
    db $63, $6a, $ff, $ff, $4b, $6a

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk2List::
    db $81, $6a, $ff, $ff, $51, $6a

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk3List::
    db $9b, $6a, $ff, $ff, $57, $6a

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song35_RecordHiScore_Trk4List::
    db $b9, $6a, $ff, $ff, $5d, $6a

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6A63::
    db $9d, $6c, $00, $81, $a9, $3a, $40, $4a, $3a, $40, $4a, $3c, $42, $4e, $3c, $42
    db $4e, $40, $4a, $52, $40, $4a, $52, $42, $4a, $54, $42, $4a, $54, $00

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6A81::
    db $9d, $8c, $00, $81, $9b, $03, $a9, $40, $58, $9c, $9b, $03, $3c, $54, $9c, $9b
    db $03, $3a, $52, $9c, $9b, $03, $36, $4e, $9c, $00

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6A9B::
    db $9d, $22, $41, $20, $a9, $4a, $4e, $52, $4a, $52, $58, $a3, $46, $a9, $4e, $54
    db $5a, $a3, $44, $a9, $52, $58, $62, $a3, $42, $a9, $54, $5a, $62, $00

; C: note pattern ($00 ends it)
Song35_RecordHiScore_Pat6AB9::
    db $a3, $15, $0b, $1a, $1a, $00

; C: header of song id 03
Song03_CreditsReal_Hdr::
    db $fc, $9b, $41, $ca, $6a, $da, $6a, $e8, $6a, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song03_CreditsReal_Trk1List::
    db $3a, $6b, $f2, $6a, $01, $6b, $f7, $6a, $01, $6b, $fc, $6a, $01, $6b, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song03_CreditsReal_Trk2List::
    db $57, $6b, $09, $6b, $18, $6b, $0e, $6b, $18, $6b, $13, $6b, $18, $6b

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song03_CreditsReal_Trk3List::
    db $6d, $6b, $23, $6b, $2d, $6b, $28, $6b, $2d, $6b

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6AF2::
    db $9d, $94, $00, $81, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6AF7::
    db $9d, $55, $00, $81, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6AFC::
    db $9d, $20, $00, $81, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B01::
    db $a3, $32, $3c, $40, $44, $48, $4a, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B09::
    db $9d, $9c, $00, $81, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B0E::
    db $9d, $4d, $00, $81, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B13::
    db $9d, $20, $00, $81, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B18::
    db $a4, $52, $a6, $4e, $a1, $4a, $a4, $5c, $a3, $40, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B23::
    db $9d, $f2, $40, $21, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B28::
    db $9d, $f2, $40, $41, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B2D::
    db $a8, $4a, $a3, $54, $58, $5c, $a8, $4a, $a3, $54, $a4, $5c, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B3A::
    db $9d, $80, $00, $81, $a3, $40, $4a, $a4, $40, $a3, $3a, $3c, $40, $36, $a2, $32
    db $36, $3a, $3c, $30, $32, $36, $3a, $a3, $3c, $42, $48, $3c, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B57::
    db $9d, $9c, $00, $81, $a4, $52, $a3, $4e, $52, $a4, $4a, $a3, $48, $40, $44, $4a
    db $58, $4a, $a4, $52, $4e, $00

; C: note pattern ($00 ends it)
Song03_CreditsReal_Pat6B6D::
    db $9d, $f2, $40, $21, $a4, $4a, $48, $44, $40, $3c, $3a, $36, $40, $00

; C: header of song id 07
Song07_ShootIntroB_Hdr::
    db $00, $9b, $41, $86, $6b, $92, $6b, $9a, $6b, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song07_ShootIntroB_Trk1List::
    db $46, $6c, $a2, $6b, $46, $7e, $2e, $7e, $ff, $ff, $8c, $6b

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song07_ShootIntroB_Trk2List::
    db $6d, $6c, $2a, $7e, $ff, $ff, $94, $6b

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song07_ShootIntroB_Trk3List::
    db $7f, $6c, $4d, $7e, $ff, $ff, $9c, $6b

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6BA2::
    db $9e, $8b, $41, $00

; C: header of song id 05
Song05_MainMenu_Hdr::
    db $00, $9b, $41, $b1, $6b, $b7, $6b, $bd, $6b, $c5, $6b

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk1List::
    db $cb, $6b, $ff, $ff, $b1, $6b

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk2List::
    db $df, $6b, $ff, $ff, $b7, $6b

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk3List::
    db $f8, $6b, $0b, $6c, $ff, $ff, $bf, $6b

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song05_MainMenu_Trk4List::
    db $11, $6c, $ff, $ff, $c5, $6b

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6BCB::
    db $9d, $80, $00, $40, $9b, $02, $a7, $10, $a2, $0a, $10, $0a, $a3, $10, $1e, $1e
    db $a4, $14, $9c, $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6BDF::
    db $9d, $51, $00, $80, $a2, $70, $70, $58, $58, $70, $70, $58, $58, $01, $a1, $70
    db $70, $a2, $58, $58, $70, $70, $58, $70, $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6BF8::
    db $9d, $42, $41, $a0, $a2, $6e, $66, $a8, $01, $a2, $6a, $62, $a7, $01, $a2, $62
    db $6a, $70, $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6C0B::
    db $9b, $04, $a5, $01, $9c, $00

; C: note pattern ($00 ends it)
Song05_MainMenu_Pat6C11::
    db $a2, $15, $01, $06, $06, $01, $06, $01, $06, $00

; C: header of song id 06
Song06_ShootIntroA_Hdr::
    db $fa, $9b, $41, $26, $6c, $2e, $6c, $38, $6c, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song06_ShootIntroA_Trk1List::
    db $46, $6c, $51, $6c, $ff, $ff, $28, $6c

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song06_ShootIntroA_Trk2List::
    db $6d, $6c, $78, $6c, $55, $6c, $ff, $ff, $32, $6c

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song06_ShootIntroA_Trk3List::
    db $7f, $6c, $8a, $6c, $ff, $ff, $3a, $6c, $9b, $04, $a5, $01, $9c, $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6C46::
    db $9d, $80, $00, $41, $a1, $56, $40, $42, $a7, $44, $00

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C51::
    db $9d, $a7, $00, $81

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C55::
    db $9b, $02, $a2, $28, $36, $44, $46, $4e, $28, $44, $46, $9c, $9b, $02, $24, $36
    db $44, $46, $4e, $24, $44, $46, $9c, $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6C6D::
    db $9d, $80, $00, $40, $a1, $36, $38, $3a, $a7, $3c, $00

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C78::
    db $9d, $40, $00, $80, $aa, $01, $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat6C7F::
    db $9d, $22, $41, $21, $a1, $5a, $5c, $5e, $a7, $60, $00

; C: note pattern ($00 ends it)
Song06_ShootIntroA_Pat6C8A::
    db $9d, $22, $41, $21, $a5, $28, $28, $24, $24, $00

; C: header of song id 20
Song20_SlideShowInit_Hdr::
    db $00, $82, $41, $9f, $6c, $a5, $6c, $ab, $6c, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song20_SlideShowInit_Trk1List::
    db $b1, $6c, $ff, $ff, $9f, $6c

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song20_SlideShowInit_Trk2List::
    db $c2, $6c, $ff, $ff, $a5, $6c

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song20_SlideShowInit_Trk3List::
    db $d3, $6c, $ff, $ff, $ab, $6c

; C: note pattern ($00 ends it)
Song20_SlideShowInit_Pat6CB1::
    db $9d, $71, $00, $00, $9b, $03, $a2, $02, $01, $02, $02, $9c, $06, $06, $0a, $0a
    db $00

; C: note pattern ($00 ends it)
Song20_SlideShowInit_Pat6CC2::
    db $9d, $71, $00, $40, $a2, $6a, $70, $6a, $70, $6a, $a1, $70, $70, $a2, $6a, $70
    db $00

; C: note pattern ($00 ends it)
Song20_SlideShowInit_Pat6CD3::
    db $9d, $f2, $40, $20, $9b, $03, $a2, $1a, $01, $1a, $1a, $9c, $a3, $1e, $22, $00

; C: header of song id 09
Song09_SlideMenu_Hdr::
    db $00, $82, $41, $ee, $6c, $f4, $6c, $fa, $6c, $00, $6d

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk1List::
    db $2e, $6d, $ff, $ff, $ee, $6c

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk2List::
    db $53, $6d, $ff, $ff, $f4, $6c

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk3List::
    db $78, $6d, $ff, $ff, $fa, $6c

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song09_SlideMenu_Trk4List::
    db $93, $6d, $ff, $ff, $00, $6d, $9d, $61, $00, $80, $9b, $07, $a0, $46, $01, $9c
    db $00, $9d, $81, $00, $80, $9b, $07, $a0, $50, $01, $9c, $00, $9d, $22, $41, $20
    db $9b, $07, $a0, $58, $01, $9c, $00, $9b, $07, $a0, $0b, $01, $9c, $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D2E::
    db $9d, $c1, $00, $00, $a2, $02, $40, $28, $4e, $a1, $72, $74, $76, $78, $7a, $78
    db $76, $74, $9d, $51, $00, $80, $a2, $32, $40, $28, $4a, $a1, $72, $74, $76, $78
    db $7a, $78, $76, $74, $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D53::
    db $9d, $d1, $00, $00, $a2, $1a, $52, $10, $60, $a1, $70, $72, $74, $76, $78, $76
    db $74, $72, $9d, $61, $00, $80, $a2, $1a, $52, $10, $52, $a1, $70, $72, $74, $76
    db $78, $76, $74, $72, $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D78::
    db $9d, $22, $41, $20, $a2, $01, $52, $54, $52, $54, $52, $54, $01, $9d, $22, $41
    db $40, $a2, $01, $52, $54, $52, $54, $52, $54, $01, $00

; C: note pattern ($00 ends it)
Song09_SlideMenu_Pat6D93::
    db $9b, $08, $a1, $15, $06, $a2, $0b, $a1, $1a, $06, $a2, $0b, $9c, $00

; C: header of song id 0A
Song0A_Doodle_Hdr::
    db $00, $8b, $41, $ac, $6d, $b2, $6d, $b8, $6d, $be, $6d

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk1List::
    db $c4, $6d, $ff, $ff, $ac, $6d

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk2List::
    db $f8, $6d, $ff, $ff, $b2, $6d

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk3List::
    db $15, $6e, $ff, $ff, $b8, $6d

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0A_Doodle_Trk4List::
    db $2e, $6e, $ff, $ff, $be, $6d

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6DC4::
    db $9d, $e2, $00, $00, $a2, $02, $02, $01, $02, $02, $02, $01, $01, $9d, $72, $00
    db $00, $a2, $02, $02, $01, $02, $02, $02, $01, $01, $9d, $c2, $00, $00, $a2, $02
    db $02, $01, $02, $02, $02, $01, $01, $9d, $41, $00, $00, $0c, $0c, $10, $14, $18
    db $01, $a9, $26, $00

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6DF8::
    db $9d, $d2, $00, $00, $9b, $03, $a2, $1a, $1a, $01, $1a, $1a, $1a, $01, $01, $9c
    db $9d, $32, $00, $00, $01, $24, $01, $2c, $01, $01, $a9, $10, $00

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6E15::
    db $9d, $22, $41, $20, $9b, $03, $a2, $1a, $1a, $01, $3a, $01, $3a, $01, $01, $9c
    db $24, $24, $28, $2c, $30, $01, $a9, $3a, $00

; C: note pattern ($00 ends it)
Song0A_Doodle_Pat6E2E::
    db $9b, $10, $a2, $0b, $0b, $15, $15, $9c, $00

; C: header of song id 0B
Song0B_Edit_Hdr::
    db $00, $b3, $41, $42, $6e, $48, $6e, $4e, $6e, $54, $6e

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk1List::
    db $5a, $6e, $ff, $ff, $42, $6e

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk2List::
    db $6c, $6e, $ff, $ff, $48, $6e

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk3List::
    db $84, $6e, $ff, $ff, $4e, $6e

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0B_Edit_Trk4List::
    db $93, $6e, $ff, $ff, $54, $6e

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E5A::
    db $9d, $91, $00, $40, $a5, $01, $9b, $02, $a2, $01, $52, $01, $52, $01, $a4, $52
    db $9c, $00

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E6C::
    db $9d, $e0, $00, $01, $a3, $0a, $06, $02, $01, $a3, $0c, $0a, $06, $01, $a3, $02
    db $06, $0a, $01, $0e, $0e, $12, $01, $00

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E84::
    db $9d, $22, $41, $20, $9b, $03, $a1, $01, $01, $58, $01, $9c, $a3, $01, $00

; C: note pattern ($00 ends it)
Song0B_Edit_Pat6E93::
    db $9b, $08, $a1, $01, $06, $0b, $01, $06, $9c, $00

; C: header of song id 0C
Song0C_Link_Hdr::
    db $f6, $82, $41, $a8, $6e, $ae, $6e, $b4, $6e, $bc, $6e

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk1List::
    db $f0, $6e, $ff, $ff, $a8, $6e

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk2List::
    db $e0, $6e, $ff, $ff, $ae, $6e

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk3List::
    db $c4, $6e, $c4, $6e, $ff, $ff, $b4, $6e

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0C_Link_Trk4List::
    db $fe, $6e, $fe, $6e, $ff, $ff, $bc, $6e

; C: note pattern ($00 ends it)
Song0C_Link_Pat6EC4::
    db $9d, $32, $41, $21, $a2, $7a, $82, $88, $01, $a4, $88, $a2, $84, $7e, $76, $01
    db $a4, $76, $a2, $7a, $82, $7a, $01, $a4, $7a, $a5, $01, $00

; C: note pattern ($00 ends it)
Song0C_Link_Pat6EE0::
    db $9d, $e1, $00, $80, $9b, $03, $a2, $18, $1a, $1a, $1a, $9c, $a3, $24, $22, $00

; C: note pattern ($00 ends it)
Song0C_Link_Pat6EF0::
    db $9d, $91, $00, $80, $a3, $01, $4a, $01, $4a, $01, $4a, $01, $46, $00

; C: note pattern ($00 ends it)
Song0C_Link_Pat6EFE::
    db $a7, $15, $a2, $06, $a7, $06, $a2, $06, $a7, $1a, $a2, $06, $a7, $06, $a2, $06
    db $a7, $15, $a2, $06, $a7, $06, $a2, $06, $a7, $1a, $a2, $01, $a7, $01, $a2, $06
    db $00

; C: header of song id 0F
Song0F_PhotoPicker_Hdr::
    db $08, $8b, $41, $2a, $6f, $32, $6f, $38, $6f, $3e, $6f

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk1List::
    db $5c, $6f, $5f, $6f, $ff, $ff, $2c, $6f

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk2List::
    db $47, $6f, $ff, $ff, $32, $6f

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk3List::
    db $74, $6f, $ff, $ff, $38, $6f

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song0F_PhotoPicker_Trk4List::
    db $8c, $6f, $ff, $ff, $3e, $6f, $aa, $01, $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F47::
    db $9d, $d1, $00, $80, $9b, $02, $a3, $10, $01, $10, $28, $9c, $9b, $02, $a3, $1a
    db $01, $1a, $32, $9c, $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F5C::
    db $aa, $01, $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F5F::
    db $9d, $a2, $00, $40, $9b, $02, $a3, $06, $1e, $01, $36, $9c, $9b, $02, $a3, $1e
    db $36, $01, $4e, $9c, $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F74::
    db $9d, $22, $41, $20, $9b, $02, $a6, $52, $a1, $01, $a6, $3a, $a1, $01, $a6, $60
    db $a1, $01, $a6, $3a, $a1, $01, $9c, $00

; C: note pattern ($00 ends it)
Song0F_PhotoPicker_Pat6F8C::
    db $9b, $02, $a3, $15, $15, $01, $01, $9c, $9b, $02, $a3, $15, $01, $15, $01, $9c
    db $00

; C: header of song id 12
Song12_Hdr::
    db $02, $8b, $41, $a8, $6f, $b0, $6f, $b8, $6f, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song12_Trk1List::
    db $c0, $6f, $c9, $6f, $ff, $ff, $aa, $6f

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song12_Trk2List::
    db $ec, $6f, $f4, $6f, $ff, $ff, $b2, $6f

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song12_Trk3List::
    db $17, $70, $1e, $70, $ff, $ff, $ba, $6f

; C: note pattern ($00 ends it)
Song12_Pat6FC0::
    db $9d, $a1, $00, $80, $a0, $01, $ab, $01, $00

; C: note pattern ($00 ends it)
Song12_Pat6FC9::
    db $9d, $63, $00, $80, $9b, $03, $a2, $10, $01, $16, $12, $01, $0c, $9c, $10, $01
    db $1c, $a7, $36, $9b, $03, $a2, $10, $01, $16, $12, $01, $0c, $9c, $10, $01, $01
    db $a7, $02, $00

; C: note pattern ($00 ends it)
Song12_Pat6FEC::
    db $9d, $c1, $00, $80, $a0, $01, $00, $00

; C: note pattern ($00 ends it)
Song12_Pat6FF4::
    db $9d, $c1, $00, $80, $9b, $03, $a2, $28, $01, $2e, $2a, $01, $24, $9c, $28, $01
    db $34, $a7, $34, $9b, $03, $a2, $28, $01, $2e, $2a, $01, $24, $9c, $28, $01, $01
    db $a7, $1a, $00

; C: note pattern ($00 ends it)
Song12_Pat7017::
    db $9d, $22, $41, $20, $a0, $01, $00

; C: note pattern ($00 ends it)
Song12_Pat701E::
    db $9d, $22, $41, $20, $9b, $03, $a2, $28, $01, $2e, $2a, $01, $24, $9c, $28, $01
    db $34, $a7, $34, $9b, $03, $a2, $28, $01, $2e, $2a, $01, $24, $9c, $28, $01, $01
    db $a7, $1a, $00

; C: header of song id 13 = 4th entry of the animation list 03:61FD (BGM 04 in the jofamo article); the Japanese ROM
; requests it only from the animation / hot-spot pickers, the international RUN! RUN! RUN! title does ($DD68 = $13;
; the Japanese one asks for $3C; BGB, README 16.27)
Song13_Hdr::
    db $00, $76, $41, $a0, $75, $b2, $75, $ba, $75, $cc, $75

; C: header of song id 23
Song23_AnimTools_Hdr::
    db $00, $8b, $41, $57, $70, $5d, $70, $63, $70, $69, $70

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk1List::
    db $6f, $70, $ff, $ff, $57, $70

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk2List::
    db $9f, $70, $ff, $ff, $5d, $70

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk3List::
    db $bc, $70, $ff, $ff, $63, $70

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song23_AnimTools_Trk4List::
    db $e8, $70, $ff, $ff, $69, $70

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat706F::
    db $9d, $71, $00, $80, $a2, $01, $70, $70, $7a, $88, $62, $62, $01, $62, $70, $7a
    db $7a, $70, $7a, $62, $62, $a2, $01, $70, $70, $a1, $7a, $7a, $a2, $88, $62, $62
    db $01, $62, $a1, $70, $70, $a2, $7a, $7a, $70, $7a, $a1, $62, $70, $a2, $62, $00

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat709F::
    db $9d, $e1, $00, $80, $a4, $02, $02, $a2, $10, $10, $10, $10, $a4, $10, $a4, $02
    db $a7, $02, $a2, $02, $0c, $10, $10, $10, $10, $10, $10, $10, $00

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat70BC::
    db $9d, $22, $41, $41, $9b, $02, $a3, $01, $4a, $52, $4a, $a4, $46, $a3, $40, $46
    db $a4, $4a, $40, $01, $01, $a3, $01, $4a, $52, $4a, $a4, $46, $a3, $40, $46, $a5
    db $4a, $a4, $01, $01, $9c, $9b, $04, $a5, $01, $01, $9c, $00

; C: note pattern ($00 ends it)
Song23_AnimTools_Pat70E8::
    db $a3, $15, $06, $1a, $06, $15, $0b, $1a, $a2, $06, $a1, $06, $06, $00

; C: header of song id 33
Song33_Hdr::
    db $02, $8b, $41, $01, $71, $07, $71, $0d, $71, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song33_Trk1List::
    db $13, $71, $ff, $ff, $01, $71

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song33_Trk2List::
    db $1c, $71, $ff, $ff, $07, $71

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song33_Trk3List::
    db $25, $71, $ff, $ff, $0d, $71

; C: note pattern ($00 ends it)
Song33_Pat7113::
    db $9d, $a2, $00, $80, $a7, $8e, $8e, $8e, $00

; C: note pattern ($00 ends it)
Song33_Pat711C::
    db $9d, $91, $00, $80, $a7, $78, $78, $78, $00

; C: note pattern ($00 ends it)
Song33_Pat7125::
    db $9d, $22, $41, $20, $9b, $02, $ad, $4a, $01, $ab, $90, $88, $ab, $58, $70, $58
    db $70, $ab, $7c, $84, $a2, $52, $58, $9c, $9b, $02, $ab, $4a, $62, $4a, $62, $ad
    db $01, $a2, $58, $ab, $01, $54, $01, $54, $ab, $7c, $60, $a9, $58, $ad, $01, $9c
    db $00

; C: header of song id 32. Owner (review page, 2026-10-13, by ear): music 32: used - Space fever main theme during
; gameplay; NOT the same as the name, which comes from the callers SpaceFever_Boss_EndA (2 static callers): the owner
; hears the main theme, the callers sit at the boss end; name kept, to be ...
Song32_SpaceFeverBossEnd_Hdr::
    db $00, $8b, $41, $67, $71, $61, $71, $6d, $71, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song32_SpaceFeverBossEnd_Trk2List::
    db $73, $71, $ff, $ff, $2e, $73

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song32_SpaceFeverBossEnd_Trk1List::
    db $80, $71, $ff, $ff, $36, $73

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song32_SpaceFeverBossEnd_Trk3List::
    db $8d, $71, $ff, $ff, $3e, $73

; C: note pattern ($00 ends it)
Song32_SpaceFeverBossEnd_Pat7173::
    db $9d, $d0, $00, $81, $a1, $58, $5a, $5c, $5e, $60, $a4, $62, $00

; C: note pattern ($00 ends it)
Song32_SpaceFeverBossEnd_Pat7180::
    db $9d, $e0, $00, $41, $a1, $1e, $20, $22, $24, $26, $a4, $28, $00

; C: note pattern ($00 ends it)
Song32_SpaceFeverBossEnd_Pat718D::
    db $9d, $f2, $40, $20, $a1, $60, $62, $64, $66, $68, $a4, $6a, $00

; C: header of song id 1D
Song1D_Hdr::
    db $fa, $8b, $41, $a5, $71, $ab, $71, $b1, $71, $b7, $71

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk1List::
    db $bd, $71, $ff, $ff, $a5, $71

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk2List::
    db $c8, $71, $ff, $ff, $ab, $71

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk3List::
    db $d3, $71, $ff, $ff, $b1, $71

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song1D_Trk4List::
    db $de, $71, $ff, $ff, $b7, $71

; C: note pattern ($00 ends it)
Song1D_Pat71BD::
    db $9d, $e3, $00, $40, $9b, $04, $a3, $10, $12, $9c, $00

; C: note pattern ($00 ends it)
Song1D_Pat71C8::
    db $9d, $e1, $00, $40, $9b, $04, $a3, $1e, $20, $9c, $00

; C: note pattern ($00 ends it)
Song1D_Pat71D3::
    db $9d, $22, $41, $20, $9b, $04, $a3, $28, $2a, $9c, $00

; C: note pattern ($00 ends it)
Song1D_Pat71DE::
    db $9b, $04, $a3, $15, $15, $9c, $00

; C: header of song id 16
Song16_FactoryDiag_Hdr::
    db $f6, $6b, $41, $f0, $71, $f4, $71, $f6, $71, $f8, $71

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk1List::
    db $fa, $71, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk2List::
    db $31, $72

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk3List::
    db $64, $72

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song16_FactoryDiag_Trk4List::
    db $98, $72

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat71FA::
    db $9d, $60, $00, $81, $a3, $3c, $a1, $3c, $01, $3c, $01, $3c, $01, $a2, $01, $a3
    db $3c, $32, $3c, $a3, $40, $a1, $40, $01, $40, $01, $40, $01, $a2, $01, $a3, $40
    db $36, $40, $9d, $90, $00, $81, $a8, $50, $a3, $50, $50, $50, $a8, $54, $a4, $54
    db $a3, $54, $a5, $58, $a4, $01, $00

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat7231::
    db $9d, $a0, $00, $81, $a3, $5c, $a1, $5c, $01, $5c, $01, $5c, $01, $a2, $01, $a3
    db $5c, $54, $5c, $a3, $60, $a1, $60, $01, $60, $01, $60, $01, $a2, $01, $a3, $60
    db $58, $60, $a8, $62, $a3, $62, $62, $62, $a8, $66, $a4, $66, $a3, $66, $a5, $6a
    db $a4, $01, $00

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat7264::
    db $9d, $22, $41, $21, $a3, $54, $a1, $54, $01, $54, $01, $54, $01, $a2, $01, $a3
    db $54, $4a, $54, $a3, $58, $a1, $58, $01, $58, $01, $58, $01, $a2, $01, $a3, $58
    db $4e, $58, $a3, $42, $38, $42, $4a, $42, $32, $5e, $3c, $46, $4e, $46, $4e, $a5
    db $62, $a4, $01, $00

; C: note pattern ($00 ends it)
Song16_FactoryDiag_Pat7298::
    db $9b, $02, $a3, $0b, $a2, $0b, $0b, $0b, $01, $a3, $0b, $0b, $0b, $9c, $9b, $06
    db $a1, $0b, $0b, $9c, $a3, $15, $15, $15, $9b, $06, $a1, $0b, $0b, $9c, $a3, $15
    db $01, $15, $9b, $08, $a1, $0b, $0b, $9c, $a4, $01, $00

; C: header of song id 17
Song17_Hdr::
    db $00, $aa, $41, $ce, $72, $d4, $72, $da, $72, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song17_Trk1List::
    db $e0, $72, $ff, $ff, $ce, $72

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song17_Trk2List::
    db $e8, $72, $ff, $ff, $d4, $72

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song17_Trk3List::
    db $f0, $72, $ff, $ff, $da, $72

; C: note pattern ($00 ends it)
Song17_Pat72E0::
    db $9d, $e0, $00, $81, $a5, $12, $12, $00

; C: note pattern ($00 ends it)
Song17_Pat72E8::
    db $9d, $e0, $00, $81, $a5, $08, $0c, $00

; C: note pattern ($00 ends it)
Song17_Pat72F0::
    db $9d, $22, $41, $21, $a5, $1a, $1a, $1a, $24, $28, $1a, $1a, $1a, $00

; C: header of song id 2B
Song2B_BallGameOver_Hdr::
    db $00, $8b, $41, $09, $73, $0d, $73, $00, $00, $0f, $73

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2B_BallGameOver_Trk1List::
    db $11, $73, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2B_BallGameOver_Trk2List::
    db $18, $73

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song2B_BallGameOver_Trk4List::
    db $1f, $73

; C: note pattern ($00 ends it)
Song2B_BallGameOver_Pat7311::
    db $9d, $f1, $00, $c0, $a3, $16, $00

; C: note pattern ($00 ends it)
Song2B_BallGameOver_Pat7318::
    db $9d, $f1, $00, $00, $a3, $14, $00

; C: note pattern ($00 ends it)
Song2B_BallGameOver_Pat731F::
    db $a3, $0b

; C: header of song id 31
Song31_SpaceFeverStart_Hdr::
    db $00, $8b, $41, $2c, $73, $34, $73, $3c, $73, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song31_SpaceFeverStart_Trk1List::
    db $44, $73, $94, $73, $ff, $ff, $2e, $73

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song31_SpaceFeverStart_Trk2List::
    db $56, $73, $78, $73, $ff, $ff, $36, $73

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song31_SpaceFeverStart_Trk3List::
    db $67, $73, $9e, $73, $ff, $ff, $3e, $73

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7344::
    db $9d, $e0, $00, $00, $a6, $36, $a1, $36, $36, $36, $a6, $32, $3c, $40, $01, $01
    db $00, $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7356::
    db $9d, $e0, $00, $00, $a6, $30, $a1, $30, $30, $30, $a6, $2c, $32, $36, $01, $01
    db $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7367::
    db $9d, $22, $41, $a0, $a6, $40, $a1, $40, $40, $40, $a6, $40, $40, $40, $01, $01
    db $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7378::
    db $9d, $b0, $00, $80, $9b, $04, $a1, $1a, $18, $16, $14, $12, $10, $0e, $0c, $0a
    db $06, $9c, $9b, $06, $1a, $1c, $1e, $20, $22, $9c, $00, $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat7394::
    db $9d, $a0, $00, $80, $9b, $04, $a5, $01, $9c, $00

; C: note pattern ($00 ends it)
Song31_SpaceFeverStart_Pat739E::
    db $9d, $22, $41, $c0, $a1, $88, $01, $88, $01, $88, $88, $01, $a5, $01, $a1, $88
    db $88, $01, $88, $01, $01, $a5, $01, $01, $00, $9d, $e1, $00, $80, $a2, $4a, $4a
    db $4a, $a4, $44, $a2, $01, $4a, $4a, $46, $a4, $4a, $a2, $01, $4a, $4a, $a3, $52
    db $4e, $4a, $3a, $a8, $3c, $00

; C: header of song id 25
Song25_Paint_Hdr::
    db $00, $8b, $41, $df, $73, $eb, $73, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song25_Paint_Trk1List::
    db $10, $74, $f3, $73, $29, $74, $f3, $73, $ff, $ff, $df, $73

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song25_Paint_Trk2List::
    db $f7, $73, $f3, $73, $ff, $ff, $eb, $73

; C: note pattern ($00 ends it)
Song25_Paint_Pat73F3::
    db $a5, $01, $01, $00

; C: note pattern ($00 ends it)
Song25_Paint_Pat73F7::
    db $9d, $81, $00, $00, $a8, $4a, $a9, $4a, $4e, $52, $a8, $4e, $a3, $01, $a8, $52
    db $a9, $4a, $4e, $52, $a8, $54, $a3, $01, $00

; C: note pattern ($00 ends it)
Song25_Paint_Pat7410::
    db $9d, $21, $00, $00, $a8, $62, $a9, $62, $66, $6a, $a8, $66, $a3, $01, $a8, $6a
    db $a9, $62, $66, $6a, $a8, $6c, $a3, $01, $00

; C: note pattern ($00 ends it)
Song25_Paint_Pat7429::
    db $9d, $32, $00, $01, $a9, $01, $01, $a8, $4a, $a9, $4a, $4e, $52, $a8, $4e, $a3
    db $01, $a8, $52, $a9, $4a, $4e, $52, $a8, $54, $a9, $01, $00

; C: header of song id 24
Song24_Stamp_Hdr::
    db $00, $8b, $41, $50, $74, $5e, $74, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song24_Stamp_Trk1List::
    db $71, $74, $f3, $73, $6c, $74, $75, $74, $f3, $73, $ff, $ff, $50, $74

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song24_Stamp_Trk2List::
    db $8c, $74, $f3, $73, $6c, $74, $90, $74, $f3, $73, $ff, $ff, $5e, $74

; C: note pattern ($00 ends it)
Song24_Stamp_Pat746C::
    db $9d, $42, $00, $c1, $00

; C: note pattern ($00 ends it)
Song24_Stamp_Pat7471::
    db $9d, $81, $00, $81

; C: note pattern ($00 ends it)
Song24_Stamp_Pat7475::
    db $a4, $3a, $a3, $3c, $3a, $3c, $a4, $40, $a3, $40, $a8, $4a, $a3, $44, $40, $3c
    db $a4, $36, $a3, $36, $a8, $3a, $00

; C: note pattern ($00 ends it)
Song24_Stamp_Pat748C::
    db $9d, $91, $00, $81

; C: note pattern ($00 ends it)
Song24_Stamp_Pat7490::
    db $a4, $32, $a3, $36, $32, $36, $a4, $3a, $a3, $3a, $a8, $44, $a3, $3c, $3a, $36
    db $a4, $30, $a3, $30, $a8, $32, $00

; C: header of song id 28. Owner (review page, 2026-10-13, by ear): music 28: Who are you running from 1 / error
; message (sure)
Song28_Hdr::
    db $00, $82, $41, $b2, $74, $ba, $74, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song28_Trk1List::
    db $3c, $7f, $e0, $72, $ff, $ff, $b4, $74

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song28_Trk2List::
    db $30, $7f, $e8, $72, $ff, $ff, $bc, $74

; C: header of song ids 08 0D 1A. Owner (review page, 2026-10-13, by ear): music 08: used - Printer waiting jingle
; during multiple print selection; kept: the name comes from the screens that call ids 08 / 0D / 1A.
Song08_TimerPrintOpt_Hdr::
    db $00, $8b, $41, $00, $75, $cd, $74, $00, $00, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song08_TimerPrintOpt_Trk2List::
    db $d3, $74, $ff, $ff, $cd, $74

; C: note pattern ($00 ends it)
Song08_TimerPrintOpt_Pat74D3::
    db $9d, $81, $00, $80, $a2, $3a, $3a, $36, $a3, $3a, $a2, $3c, $a5, $40, $a3, $01
    db $a2, $3c, $3c, $3a, $a3, $3c, $a2, $40, $a5, $44, $a3, $01, $a2, $40, $40, $40
    db $40, $44, $44, $44, $44, $a3, $48, $48, $a5, $4a, $a4, $01, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song08_TimerPrintOpt_Trk1List::
    db $08, $75, $d7, $74, $ff, $ff, $00, $75

; C: note pattern ($00 ends it)
Song08_TimerPrintOpt_Pat7508::
    db $9d, $10, $00, $80, $a1, $01, $00

; C: header of song id 04
Song04_Shutterbug_Hdr::
    db $00, $8b, $41, $1a, $75, $20, $75, $00, $00, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song04_Shutterbug_Trk1List::
    db $26, $75, $ff, $ff, $1a, $75

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song04_Shutterbug_Trk2List::
    db $45, $75, $ff, $ff, $20, $75

; C: note pattern ($00 ends it)
Song04_Shutterbug_Pat7526::
    db $9d, $e1, $00, $80, $9b, $04, $a5, $01, $9c, $9b, $02, $a3, $36, $3a, $a4, $3c
    db $9c, $a3, $36, $3a, $a2, $3c, $a4, $3a, $a2, $01, $9b, $04, $36, $9c, $00

; C: note pattern ($00 ends it)
Song04_Shutterbug_Pat7545::
    db $9d, $e1, $00, $80, $9b, $02, $a3, $3c, $40, $a4, $44, $9c, $a3, $3c, $40, $a2
    db $44, $a4, $40, $9b, $04, $a2, $3c, $9c, $a7, $01, $9b, $02, $a3, $3c, $40, $a4
    db $44, $9c, $a3, $3c, $40, $a2, $44, $a4, $40, $a2, $01, $9b, $04, $3c, $9c, $00

; C: header of song id 27. Owner (review page, 2026-10-13, by ear): music 27: used - jingle during waiting time when
; the game boy printer is busy printing; consistent with the caller Mode1D_State05_SendPrint.
Song27_TransferPrint_Hdr::
    db $00, $8b, $41, $00, $00, $80, $75, $00, $00, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song27_TransferPrint_Trk2List::
    db $86, $75, $ff, $ff, $80, $75

; C: note pattern ($00 ends it)
Song27_TransferPrint_Pat7586::
    db $9d, $e1, $00, $80, $a3, $32, $40, $32, $40, $a2, $01, $a9, $44, $44, $44, $a7
    db $40, $a7, $44, $a2, $40, $a4, $4a, $a3, $01, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk1List::
    db $d4, $75, $d4, $75, $d4, $75, $e6, $75, $d4, $75, $f4, $75, $d4, $75, $ff, $ff
    db $a0, $75

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk2List::
    db $0e, $76, $18, $76, $ff, $ff, $b2, $75

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk3List::
    db $9f, $76, $9f, $76, $9f, $76, $b4, $76, $9f, $76, $c0, $76, $9f, $76, $ff, $ff
    db $ba, $75

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song13_Trk4List::
    db $ca, $76, $de, $76, $ff, $ff, $cc, $75

; C: note pattern ($00 ends it)
Song13_Pat75D4::
    db $9d, $82, $00, $40, $9b, $04, $a2, $22, $14, $26, $14, $a3, $28, $a2, $26, $22
    db $9c, $00

; C: note pattern ($00 ends it)
Song13_Pat75E6::
    db $9b, $04, $a2, $2c, $1e, $30, $1e, $a3, $32, $a2, $30, $2c, $9c, $00

; C: note pattern ($00 ends it)
Song13_Pat75F4::
    db $9b, $02, $1e, $10, $22, $10, $a3, $1e, $a2, $22, $10, $9c, $2c, $1e, $30, $1e
    db $a3, $2c, $a2, $30, $10, $2c, $01, $a8, $01, $00

; C: note pattern ($00 ends it)
Song13_Pat760E::
    db $9d, $6a, $00, $c1, $9b, $04, $a5, $01, $9c, $00

; C: note pattern ($00 ends it)
Song13_Pat7618::
    db $a2, $52, $52, $01, $52, $a3, $01, $4e, $a2, $4a, $44, $01, $a4, $44, $a2, $01
    db $a3, $40, $44, $44, $44, $4a, $a8, $01, $a2, $01, $52, $01, $a7, $52, $a3, $4e
    db $a2, $4a, $44, $01, $a4, $44, $a2, $01, $44, $44, $a3, $01, $44, $44, $a2, $44
    db $01, $a8, $01, $a2, $4e, $a7, $01, $a3, $4e, $4a, $a3, $4e, $a2, $44, $44, $a4
    db $01, $a2, $52, $01, $4e, $01, $a3, $4a, $a2, $4e, $4a, $a5, $01, $a2, $52, $01
    db $01, $a7, $52, $a3, $4e, $a2, $4a, $44, $01, $a4, $44, $a2, $01, $a3, $40, $44
    db $44, $44, $44, $a8, $01, $a2, $44, $44, $a3, $01, $44, $a2, $44, $4a, $a5, $01
    db $a2, $52, $01, $4e, $01, $a3, $4a, $a2, $44, $44, $a4, $01, $a2, $4a, $4a, $01
    db $44, $9b, $04, $a5, $01, $9c, $00

; C: note pattern ($00 ends it)
Song13_Pat769F::
    db $9d, $f2, $40, $a0, $a4, $2c, $22, $a7, $2c, $a2, $2c, $a4, $22, $2c, $22, $a3
    db $2c, $22, $26, $2a, $00

; C: note pattern ($00 ends it)
Song13_Pat76B4::
    db $9b, $04, $a3, $1e, $a2, $01, $1e, $a3, $1e, $01, $9c, $00

; C: note pattern ($00 ends it)
Song13_Pat76C0::
    db $a4, $28, $1a, $28, $1a, $1e, $1e, $1e, $01, $00

; C: note pattern ($00 ends it)
Song13_Pat76CA::
    db $9b, $03, $a2, $15, $06, $1a, $06, $15, $06, $1a, $06, $9c, $9b, $02, $1a, $1a
    db $1a, $1a, $9c, $00

; C: note pattern ($00 ends it)
Song13_Pat76DE::
    db $9b, $13, $a2, $15, $06, $1a, $06, $15, $06, $1a, $06, $9c, $a5, $1a, $9b, $03
    db $a2, $15, $06, $1a, $06, $15, $06, $1a, $06, $9c, $06, $1a, $06, $1a, $15, $1a
    db $1a, $1a, $00

; C: header of song ids 15 21
Song21_SlideShowPlay_Hdr::
    db $00, $8b, $41, $0c, $77, $14, $77, $1c, $77, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song21_SlideShowPlay_Trk1List::
    db $2a, $77, $c9, $77, $ff, $ff, $0c, $77

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song21_SlideShowPlay_Trk2List::
    db $84, $77, $0d, $78, $ff, $ff, $14, $77

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song21_SlideShowPlay_Trk3List::
    db $a1, $77, $3e, $78, $ff, $ff, $1c, $77, $c1, $77, $ff, $ff, $24, $77

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat772A::
    db $9d, $80, $00, $81, $a3, $36, $3e, $44, $a4, $44, $9d, $74, $00, $81, $a3, $5c
    db $5c, $01, $56, $56, $01, $9d, $80, $00, $81, $36, $36, $3e, $44, $a4, $44, $9d
    db $74, $00, $81, $a3, $5c, $5c, $01, $58, $58, $01, $9d, $80, $00, $81, $34, $34
    db $3a, $48, $a4, $48, $9d, $74, $00, $81, $a3, $60, $60, $01, $58, $58, $01, $9d
    db $80, $00, $81, $34, $34, $3a, $48, $a4, $48, $9d, $74, $00, $81, $a3, $60, $60
    db $01, $56, $56, $01, $9d, $60, $00, $81, $36, $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat7784::
    db $9d, $b3, $00, $81, $a8, $01, $9b, $03, $a3, $01, $3e, $3e, $9c, $01, $36, $3e
    db $9b, $08, $01, $40, $40, $9c, $9b, $03, $01, $3e, $3e, $9c, $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat77A1::
    db $9d, $22, $41, $a0, $a8, $01, $9b, $04, $a3, $36, $44, $44, $9c, $9b, $04, $3a
    db $44, $44, $9c, $9b, $04, $2c, $44, $44, $9c, $9b, $03, $36, $44, $44, $9c, $00
    db $a3, $06, $0b, $0b, $06, $0b, $0b, $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat77C9::
    db $a3, $36, $3e, $44, $4e, $9d, $74, $00, $81, $01, $66, $66, $01, $5c, $5c, $01
    db $9d, $80, $00, $81, $36, $36, $3e, $44, $a4, $4e, $9d, $74, $00, $81, $a3, $66
    db $66, $01, $60, $60, $01, $9d, $80, $00, $81, $52, $52, $58, $60, $a5, $60, $a3
    db $5a, $5c, $a5, $6e, $a3, $66, $56, $a4, $56, $a3, $52, $a4, $60, $a3, $5c, $a4
    db $4e, $a3, $01, $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat780D::
    db $a3, $01, $36, $3e, $9b, $03, $01, $3e, $3e, $9c, $01, $36, $3e, $9b, $02, $01
    db $3a, $3a, $9c, $3a, $01, $3a, $3a, $40, $48, $9b, $02, $01, $40, $40, $9c, $9b
    db $02, $01, $3e, $3e, $9c, $a4, $3a, $a3, $01, $a4, $40, $a3, $01, $a7, $3e, $01
    db $00

; C: note pattern ($00 ends it)
Song21_SlideShowPlay_Pat783E::
    db $a3, $36, $44, $44, $9b, $04, $3e, $44, $44, $9c, $9b, $02, $40, $48, $48, $9c
    db $40, $01, $01, $3a, $40, $48, $3a, $44, $44, $2c, $44, $44, $36, $44, $44, $3e
    db $44, $44, $a8, $40, $44, $a4, $36, $a3, $01, $00

; C: header of song id 14
Song14_Hdr::
    db $00, $8b, $41, $00, $00, $73, $78, $79, $78, $7f, $78

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song14_Trk2List::
    db $85, $78, $ff, $ff, $73, $78

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song14_Trk3List::
    db $bf, $78, $ff, $ff, $79, $78

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song14_Trk4List::
    db $f1, $78, $ff, $ff, $7f, $78

; C: note pattern ($00 ends it)
Song14_Pat7885::
    db $9d, $b0, $00, $81, $a2, $01, $44, $a7, $60, $a1, $62, $60, $a2, $5c, $54, $52
    db $4a, $a3, $52, $a2, $01, $a1, $54, $52, $a2, $4a, $44, $a7, $48, $a2, $4a, $a1
    db $52, $a1, $01, $01, $a0, $54, $52, $a2, $4a, $48, $a3, $44, $a2, $01, $a1, $3a
    db $3c, $44, $44, $a1, $01, $44, $44, $a6, $01, $00

; C: note pattern ($00 ends it)
Song14_Pat78BF::
    db $9d, $22, $41, $20, $a3, $1e, $a2, $01, $1e, $a3, $1e, $a2, $01, $1e, $a3, $14
    db $a2, $01, $14, $a3, $14, $a2, $01, $14, $a3, $22, $a2, $01, $2c, $a3, $22, $a2
    db $01, $0a, $a3, $14, $a2, $01, $a1, $0a, $0c, $14, $14, $a1, $01, $14, $14, $a6
    db $01, $00

; C: note pattern ($00 ends it)
Song14_Pat78F1::
    db $9b, $02, $a2, $15, $06, $1a, $06, $06, $15, $1a, $06, $9c, $a1, $15, $06, $01
    db $06, $1a, $06, $a0, $06, $06, $06, $06, $a7, $1a, $a2, $06, $a2, $15, $06, $1a
    db $06, $06, $15, $1a, $a1, $06, $1a, $00

; C: header of song id 2E
Song2E_Hdr::
    db $00, $8b, $41, $24, $79, $2c, $79, $34, $79, $3c, $79

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk1List::
    db $f2, $79, $03, $7a, $ff, $ff, $24, $79

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk2List::
    db $44, $79, $64, $79, $ff, $ff, $2c, $79

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk3List::
    db $59, $7a, $6a, $7a, $ff, $ff, $34, $79

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song2E_Trk4List::
    db $99, $7a, $a2, $7a, $ff, $ff, $3e, $79

; C: note pattern ($00 ends it)
Song2E_Pat7944::
    db $9d, $82, $00, $81, $a2, $5e, $5e, $a1, $5a, $58, $a2, $54, $5e, $5e, $a1, $5a
    db $58, $a2, $54, $a2, $58, $58, $a1, $50, $4e, $a2, $4a, $50, $4e, $4a, $01, $00

; C: note pattern ($00 ends it)
Song2E_Pat7964::
    db $a2, $4a, $4e, $a1, $50, $4e, $a2, $4a, $50, $54, $58, $54, $a2, $50, $58, $5e
    db $a1, $5a, $5e, $a2, $58, $54, $a3, $58, $a2, $4a, $4e, $a1, $50, $4e, $a2, $4a
    db $50, $54, $58, $54, $a2, $62, $62, $5e, $a1, $58, $5e, $a2, $58, $58, $62, $01
    db $9b, $04, $a2, $62, $62, $9c, $a2, $01, $62, $5e, $5e, $58, $5e, $62, $01, $62
    db $62, $62, $62, $62, $62, $62, $62, $01, $62, $5e, $5e, $58, $54, $58, $01, $a3
    db $5e, $5e, $5e, $5e, $a2, $5e, $5e, $a1, $5a, $58, $54, $01, $a2, $5e, $5e, $a1
    db $5a, $58, $54, $01, $a2, $50, $54, $58, $a1, $5a, $58, $a2, $54, $50, $5e, $01
    db $a2, $5e, $5e, $a1, $5a, $58, $54, $01, $a2, $5e, $5e, $a1, $5a, $58, $54, $01
    db $a2, $58, $58, $a1, $50, $4e, $4a, $01, $a2, $50, $4e, $4a, $01, $00

; C: note pattern ($00 ends it)
Song2E_Pat79F2::
    db $9d, $82, $00, $81, $9b, $02, $a2, $54, $54, $01, $01, $9c, $50, $50, $a8, $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat7A03::
    db $9b, $07, $a2, $01, $4a, $9c, $a3, $4a, $9b, $06, $a2, $01, $4a, $9c, $01, $4e
    db $50, $01, $a5, $5a, $58, $5a, $58, $a3, $58, $58, $58, $58, $a2, $46, $46, $a1
    db $42, $40, $3c, $01, $a2, $46, $46, $a1, $42, $40, $3c, $01, $a2, $38, $3c, $40
    db $a1, $42, $40, $a2, $3c, $38, $46, $01, $a2, $46, $46, $a1, $42, $40, $3c, $01
    db $a2, $46, $46, $a1, $42, $40, $3c, $01, $a2, $40, $40, $a1, $38, $36, $32, $01
    db $a2, $38, $36, $32, $01, $00

; C: note pattern ($00 ends it)
Song2E_Pat7A59::
    db $9d, $22, $41, $a0, $a3, $3c, $46, $3c, $46, $32, $40, $a2, $01, $40, $32, $01
    db $00

; C: note pattern ($00 ends it)
Song2E_Pat7A6A::
    db $9b, $07, $a3, $32, $40, $9c, $a2, $01, $40, $32, $01, $9b, $02, $a3, $3c, $3c
    db $3c, $3c, $32, $32, $32, $32, $9c, $40, $40, $40, $40, $3c, $46, $3c, $46, $38
    db $46, $38, $46, $3c, $46, $3c, $46, $32, $28, $a2, $01, $40, $32, $01, $00

; C: note pattern ($00 ends it)
Song2E_Pat7A99::
    db $9b, $07, $a2, $01, $0b, $9c, $0b, $01, $00

; C: note pattern ($00 ends it)
Song2E_Pat7AA2::
    db $9b, $0f, $01, $0b, $9c, $0b, $01, $9b, $23, $01, $0b, $9c, $0b, $01, $00

; C: header of song ids 1C 47. Owner (review page, 2026-10-13, by ear): music 47: unused - classical music theme
; (mozart ?); id 47 shares this header with id 1C; 47 is only in the slide-show music list (#13).
Song1C_Hdr::
    db $00, $9b, $41, $bc, $7a, $c2, $7a, $c8, $7a, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1C_Trk1List::
    db $21, $7b, $ff, $ff, $bc, $7a

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1C_Trk2List::
    db $ce, $7a, $ff, $ff, $c2, $7a

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1C_Trk3List::
    db $49, $7b, $ff, $ff, $c8, $7a

; C: note pattern ($00 ends it)
Song1C_Pat7ACE::
    db $9d, $d4, $00, $81, $a2, $01, $40, $40, $40, $a4, $38, $a2, $01, $3c, $3c, $3c
    db $a4, $36, $a3, $01, $a1, $01, $40, $40, $40, $38, $42, $42, $42, $40, $50, $50
    db $50, $a3, $4a, $a1, $01, $40, $40, $40, $a1, $36, $42, $42, $42, $40, $54, $54
    db $54, $a3, $4e, $a1, $01, $58, $58, $54, $a1, $50, $50, $50, $54, $58, $58, $58
    db $54, $50, $50, $50, $54, $58, $58, $58, $54, $a2, $50, $01, $a1, $4a, $a6, $01
    db $a4, $58, $00

; C: note pattern ($00 ends it)
Song1C_Pat7B21::
    db $9d, $d4, $00, $81, $a2, $01, $10, $10, $10, $a4, $08, $a2, $01, $0c, $0c, $0c
    db $a4, $06, $01, $a5, $32, $30, $a2, $32, $01, $30, $01, $32, $01, $30, $01, $32
    db $01, $a1, $2a, $a6, $01, $a4, $28, $00

; C: note pattern ($00 ends it)
Song1C_Pat7B49::
    db $9d, $f2, $40, $21, $a4, $01, $a5, $01, $01, $01, $01, $a2, $32, $01, $30, $01
    db $32, $01, $30, $01, $a2, $32, $01, $a1, $2a, $a6, $01, $a4, $28, $00

; C: header of song id 26
Song26_TransferSend_Hdr::
    db $08, $8b, $41, $72, $7b, $78, $7b, $7e, $7b, $84, $7b

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk1List::
    db $c1, $7b, $ff, $ff, $72, $7b

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk2List::
    db $8a, $7b, $ff, $ff, $78, $7b

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk3List::
    db $00, $7c, $ff, $ff, $7e, $7b

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song26_TransferSend_Trk4List::
    db $2c, $7c, $ff, $ff, $84, $7b

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7B8A::
    db $9d, $e1, $00, $c0, $9b, $02, $a1, $34, $01, $34, $01, $01, $34, $01, $9c, $34
    db $01, $34, $01, $34, $01, $01, $34, $01, $34, $a4, $01, $9b, $02, $a1, $34, $01
    db $34, $01, $01, $34, $01, $9c, $34, $01, $34, $01, $34, $01, $01, $34, $01, $36
    db $a2, $01, $a3, $36, $a2, $01, $00

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7BC1::
    db $9d, $d2, $00, $c0, $a1, $2a, $01, $2a, $01, $01, $2a, $01, $26, $01, $26, $01
    db $01, $26, $01, $26, $01, $2a, $01, $2a, $01, $01, $2a, $01, $26, $a4, $01, $a1
    db $2a, $01, $2a, $01, $01, $2a, $01, $26, $01, $26, $01, $01, $26, $01, $26, $01
    db $2a, $01, $2a, $01, $01, $2a, $01, $2c, $a2, $01, $a3, $2c, $a2, $01, $00

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7C00::
    db $9d, $22, $41, $21, $a3, $2c, $22, $a6, $2c, $a3, $22, $a1, $01, $a3, $2c, $22
    db $a6, $2c, $a1, $2c, $a3, $01, $a3, $2c, $22, $a6, $2c, $a3, $22, $a1, $01, $a3
    db $2c, $a6, $2c, $a1, $2e, $a2, $01, $a3, $2e, $a2, $01, $00

; C: note pattern ($00 ends it)
Song26_TransferSend_Pat7C2C::
    db $9b, $03, $a1, $10, $06, $06, $10, $06, $06, $10, $06, $06, $06, $10, $06, $06
    db $0b, $06, $06, $9c, $10, $06, $06, $10, $06, $0b, $10, $06, $a2, $01, $a3, $0b
    db $a2, $01, $00

; C: header of song id 18
Song18_Hdr::
    db $00, $8b, $41, $5a, $7c, $62, $7c, $6a, $7c, $72, $7c

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk1List::
    db $05, $7d, $0c, $7d, $ff, $ff, $5c, $7c

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk2List::
    db $7a, $7c, $86, $7c, $ff, $ff, $64, $7c

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk3List::
    db $6c, $7d, $73, $7d, $ff, $ff, $6c, $7c

; C: pattern list of track 4 (word hi $00 = song end; $FFxx + word = loop)
Song18_Trk4List::
    db $d1, $7d, $d4, $7d, $ff, $ff, $74, $7c

; C: note pattern ($00 ends it)
Song18_Pat7C7A::
    db $9d, $d4, $00, $40, $a9, $01, $01, $52, $54, $01, $52, $00

; C: note pattern ($00 ends it)
Song18_Pat7C86::
    db $a4, $58, $a7, $54, $a4, $52, $a2, $01, $a9, $01, $01, $52, $54, $01, $58, $a2
    db $4a, $9d, $a4, $00, $40, $a7, $01, $a9, $2e, $01, $2e, $a3, $01, $a1, $2e, $a6
    db $01, $a3, $2e, $9d, $d4, $00, $40, $a9, $01, $01, $52, $54, $01, $52, $a4, $58
    db $a9, $54, $01, $52, $54, $01, $a8, $52, $a9, $52, $54, $01, $58, $a2, $4a, $a7
    db $01, $a9, $4a, $01, $4a, $01, $01, $44, $a3, $01, $54, $a9, $01, $01, $52, $54
    db $01, $52, $a4, $58, $a9, $58, $01, $5c, $01, $01, $5e, $a9, $01, $01, $5c, $01
    db $01, $58, $01, $01, $54, $01, $01, $a3, $52, $a9, $4a, $a3, $01, $34, $a9, $01
    db $01, $a3, $32, $a9, $01, $a3, $30, $a9, $01, $01, $52, $54, $01, $52, $00

; C: note pattern ($00 ends it)
Song18_Pat7D05::
    db $9d, $b3, $00, $41, $a4, $01, $00

; C: note pattern ($00 ends it)
Song18_Pat7D0C::
    db $a9, $01, $01, $2e, $a8, $01, $a9, $01, $01, $2c, $a8, $01, $a9, $01, $01, $2e
    db $a3, $01, $a9, $22, $01, $22, $a3, $01, $a1, $22, $a6, $01, $a3, $22, $a4, $01
    db $a9, $01, $01, $a4, $2c, $a9, $01, $a3, $01, $a9, $01, $01, $2c, $a3, $01, $a4
    db $01, $a9, $01, $01, $2e, $a4, $01, $a9, $01, $01, $2e, $a3, $01, $a4, $34, $a9
    db $01, $01, $32, $a8, $01, $a9, $01, $01, $3a, $a9, $01, $01, $3a, $a8, $01, $a9
    db $01, $01, $2e, $a3, $01, $28, $a9, $01, $01, $a3, $24, $a9, $01, $a8, $3a, $00

; C: note pattern ($00 ends it)
Song18_Pat7D6C::
    db $9d, $f2, $40, $20, $a4, $01, $00

; C: note pattern ($00 ends it)
Song18_Pat7D73::
    db $a9, $1a, $01, $36, $a3, $1e, $22, $1a, $a9, $24, $01, $38, $a3, $2c, $2e, $30
    db $a9, $32, $01, $3a, $a3, $28, $1e, $1c, $a3, $1a, $1e, $20, $22, $a9, $24, $01
    db $38, $a3, $22, $24, $1a, $a9, $24, $01, $38, $a3, $2c, $2e, $30, $a9, $32, $01
    db $3a, $a3, $32, $30, $a9, $2e, $01, $3a, $a3, $2c, $22, $2c, $a9, $22, $01, $3c
    db $a3, $1e, $2c, $30, $a9, $32, $01, $48, $a9, $30, $01, $48, $a3, $28, $2c, $30
    db $a9, $32, $01, $22, $a3, $2c, $22, $20, $a3, $1e, $28, $2c, $30, $00

; C: note pattern ($00 ends it)
Song18_Pat7DD1::
    db $a4, $01, $00

; C: note pattern ($00 ends it)
Song18_Pat7DD4::
    db $9b, $06, $a3, $0b, $a9, $06, $01, $0b, $a3, $0b, $a9, $06, $01, $0b, $9c, $a3
    db $0b, $a9, $06, $01, $0b, $a3, $0b, $a9, $06, $01, $a3, $0b, $a9, $01, $0b, $01
    db $0b, $a3, $0b, $a9, $06, $01, $0b, $9b, $04, $a3, $0b, $a9, $06, $01, $0b, $a3
    db $0b, $a9, $06, $01, $0b, $9c, $00, $00, $8b, $41, $16, $7e, $1e, $7e, $24, $7e
    db $00, $00, $46, $7e, $2e, $7e, $ff, $ff, $18, $7e, $2a, $7e, $ff, $ff, $1e, $7e
    db $4d, $7e, $ff, $ff, $24, $7e

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E2A::
    db $9d, $a4, $00, $81

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E2E::
    db $a8, $70, $a8, $6e, $a4, $6c, $a3, $6a, $a4, $66, $a3, $5c, $a4, $58, $a3, $5c
    db $a4, $62, $a3, $5c, $a8, $58, $01, $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E46::
    db $9d, $20, $00, $81, $aa, $01, $00

; C: note pattern ($00 ends it)
Song07_ShootIntroB_Pat7E4D::
    db $9d, $22, $41, $21, $a2, $32, $40, $4a, $4e, $52, $58, $32, $3e, $44, $4a, $4e
    db $56, $32, $3c, $44, $4a, $4e, $54, $32, $3c, $44, $4a, $4e, $54, $32, $40, $48
    db $4a, $52, $58, $44, $3a, $40, $44, $4a, $52, $36, $40, $44, $4a, $4e, $58, $60
    db $01, $a4, $01, $00

; C: header of song id 22
Song22_Hdr::
    db $00, $9b, $41, $94, $7e, $8c, $7e, $9a, $7e, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song22_Trk2List::
    db $a0, $7e, $ab, $7e, $ff, $ff, $8e, $7e

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song22_Trk1List::
    db $a7, $7e, $ff, $ff, $94, $7e

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song22_Trk3List::
    db $dd, $7e, $ff, $ff, $9a, $7e

; C: note pattern ($00 ends it)
Song22_Pat7EA0::
    db $9d, $56, $00, $81, $a9, $01, $00

; C: note pattern ($00 ends it)
Song22_Pat7EA7::
    db $9d, $93, $00, $81

; C: note pattern ($00 ends it)
Song22_Pat7EAB::
    db $a1, $78, $74, $6e, $66, $60, $5c, $56, $4e, $48, $44, $3e, $36, $34, $36, $3e
    db $44, $4c, $4e, $56, $5c, $64, $66, $6e, $74, $78, $70, $6a, $66, $60, $58, $52
    db $4e, $48, $40, $3a, $36, $3a, $40, $46, $4c, $52, $58, $5e, $64, $6a, $70, $76
    db $7c, $00

; C: note pattern ($00 ends it)
Song22_Pat7EDD::
    db $9d, $22, $41, $21, $a4, $5c, $a3, $60, $a4, $6e, $a3, $64, $a8, $60, $a8, $5e
    db $00

; C: header of song id 1F. Owner (review page, 2026-10-13, by ear): music 1F: From space Fever (likely)
Song1F_Hdr::
    db $00, $76, $41, $fd, $7e, $f9, $7e, $ff, $7e, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song1F_Trk2List::
    db $0b, $7f, $00, $00

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song1F_Trk1List::
    db $01, $7f

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song1F_Trk3List::
    db $15, $7f

; C: note pattern ($00 ends it)
Song1F_Pat7F01::
    db $9d, $d3, $00, $81, $a2, $3c, $2e, $3c, $46, $00

; C: note pattern ($00 ends it)
Song1F_Pat7F0B::
    db $9d, $d3, $00, $81, $a2, $32, $24, $32, $3c, $00

; C: note pattern ($00 ends it)
Song1F_Pat7F15::
    db $9d, $22, $41, $21, $a2, $44, $36, $44, $4e, $00

; C: header of song id 48. Owner (review page, 2026-10-13, by ear): music 48: known - error message, incomplete;
; confirmed the earlier answer (error message, incomplete).
Song48_ErrorIncomplete_Hdr::
    db $00, $8b, $41, $2c, $7f, $2a, $7f, $00, $00, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop). Owner (review page, 2026-10-13, by ear):
; music 48: known - error message, incomplete.
Song48_ErrorIncomplete_Trk2List::
    db $30, $7f

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop). Owner (review page, 2026-10-13, by ear):
; music 48: known - error message, incomplete.
Song48_ErrorIncomplete_Trk1List::
    db $3c, $7f, $00, $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat7F30::
    db $9d, $f1, $00, $40, $a0, $28, $01, $22, $01, $1c, $01, $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat7F3C::
    db $9d, $f1, $00, $40, $a0, $0e, $01, $08, $01, $02, $01, $00

; C: note pattern ($00 ends it)
Song29_TotakaTune_Pat7F48::
    db $a0, $01, $01, $01, $01, $01, $01, $00

; C: header of song id 0E
Song0E_ShootIntroC_Hdr::
    db $fa, $8b, $41, $61, $7f, $5b, $7f, $69, $7f, $00, $00

; C: pattern list of track 2 (word hi $00 = song end; $FFxx + word = loop)
Song0E_ShootIntroC_Trk2List::
    db $6f, $7f, $ff, $ff, $5b, $7f

; C: pattern list of track 1 (word hi $00 = song end; $FFxx + word = loop)
Song0E_ShootIntroC_Trk1List::
    db $8d, $7f, $73, $7f, $ff, $ff, $63, $7f

; C: pattern list of track 3 (word hi $00 = song end; $FFxx + word = loop)
Song0E_ShootIntroC_Trk3List::
    db $95, $7f, $ff, $ff, $69, $7f

; C: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7F6F::
    db $9d, $75, $00, $c1

; C: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7F73::
    db $a2, $70, $66, $6a, $60, $66, $5c, $60, $58, $5c, $52, $58, $4e, $36, $3c, $42
    db $48, $4e, $54, $5a, $60, $66, $6c, $72, $78, $00

; C: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7F8D::
    db $9d, $37, $00, $c1, $a9, $01, $01, $00

; C: note pattern ($00 ends it)
Song0E_ShootIntroC_Pat7F95::
    db $9d, $f2, $40, $21, $a4, $32, $a3, $40, $a4, $52, $a3, $58, $a4, $5a, $a3, $54
    db $4e, $52, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

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

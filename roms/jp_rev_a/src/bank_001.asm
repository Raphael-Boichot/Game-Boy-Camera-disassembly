; Pocket Camera (Japan) (Rev A), bank $01. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

; C: 249 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B01_4000 (00:24AF)
OamPtrTbl_B01_4000::
    dw OamList_B01_4000_00
    dw OamList_B01_4000_01
    dw OamList_B01_4000_02
    dw OamList_B01_4000_03
    dw OamList_B01_4000_04
    dw OamList_B01_4000_05
    dw OamList_B01_4000_06
    dw OamList_B01_4000_07
    dw OamList_B01_4000_08
    dw OamList_B01_4000_09
    dw OamList_B01_4000_0A
    dw OamList_B01_4000_0B
    dw OamList_B01_4000_0C
    dw OamList_B01_4000_0D
    dw OamList_B01_4000_0E
    dw OamList_B01_4000_0F
    dw OamList_B01_4000_10
    dw OamList_B01_4000_11
    dw OamList_B01_4000_12
    dw OamList_B01_4000_13
    dw OamList_B01_4000_14
    dw OamList_B01_4000_15
    dw OamList_B01_4000_16
    dw OamList_B01_4000_17
    dw OamList_B01_4000_18
    dw OamList_B01_4000_19
    dw OamList_B01_4000_1A
    dw OamList_B01_4000_1B
    dw OamList_B01_4000_1C
    dw OamList_B01_4000_1D
    dw OamList_B01_4000_1E
    dw OamList_B01_4000_1F
    dw OamList_B01_4000_20
    dw OamList_B01_4000_21
    dw OamList_B01_4000_22
    dw OamList_B01_4000_23
    dw OamList_B01_4000_24
    dw OamList_B01_4000_25
    dw OamList_B01_4000_26
    dw OamList_B01_4000_27
    dw OamList_B01_4000_28
    dw OamList_B01_4000_29
    dw OamList_B01_4000_2A
    dw OamList_B01_4000_2B
    dw OamList_B01_4000_2C
    dw OamList_B01_4000_2D
    dw OamList_B01_4000_2E
    dw OamList_B01_4000_2F
    dw OamList_B01_4000_30
    dw OamList_B01_4000_31
    dw OamList_B01_4000_32
    dw OamList_B01_4000_33
    dw OamList_B01_4000_34
    dw OamList_B01_4000_35
    dw OamList_B01_4000_36
    dw OamList_B01_4000_37
    dw OamList_B01_4000_38
    dw OamList_B01_4000_39
    dw OamList_B01_4000_3A
    dw OamList_B01_4000_3B
    dw OamList_B01_4000_3C
    dw OamList_B01_4000_3D
    dw OamList_B01_4000_3E
    dw OamList_B01_4000_3F
    dw OamList_B01_4000_40
    dw OamList_B01_4000_41
    dw OamList_B01_4000_42
    dw OamList_B01_4000_43
    dw OamList_B01_4000_44
    dw OamList_B01_4000_45
    dw OamList_B01_4000_46
    dw OamList_B01_4000_47
    dw OamList_B01_4000_48
    dw OamList_B01_4000_49
    dw OamList_B01_4000_4A
    dw OamList_B01_4000_4B
    dw OamList_B01_4000_4C
    dw OamList_B01_4000_4D
    dw OamList_B01_4000_4E
    dw OamList_B01_4000_4F
    dw OamList_B01_4000_50
    dw OamList_B01_4000_51
    dw OamList_B01_4000_52
    dw OamList_B01_4000_53
    dw OamList_B01_4000_54
    dw OamList_B01_4000_55
    dw OamList_B01_4000_56
    dw OamList_B01_4000_57
    dw OamList_B01_4000_58
    dw OamList_B01_4000_59
    dw OamList_B01_4000_5A
    dw OamList_B01_4000_5B
    dw OamList_B01_4000_5C
    dw OamList_B01_4000_5D
    dw OamList_B01_4000_5E
    dw OamList_B01_4000_5F
    dw OamList_B01_4000_60
    dw OamList_B01_4000_61
    dw OamList_B01_4000_62
    dw OamList_B01_4000_63
    dw OamList_B01_4000_64
    dw OamList_B01_4000_65
    dw OamList_B01_4000_66
    dw OamList_B01_4000_67
    dw OamList_B01_4000_68
    dw OamList_B01_4000_69
    dw OamList_B01_4000_6A
    dw OamList_B01_4000_6B
    dw OamList_B01_4000_6C
    dw OamList_B01_4000_6D
    dw OamList_B01_4000_6E
    dw OamList_B01_4000_6F
    dw OamList_B01_4000_70
    dw OamList_B01_4000_71
    dw OamList_B01_4000_72
    dw OamList_B01_4000_73
    dw OamList_B01_4000_74
    dw OamList_B01_4000_75
    dw OamList_B01_4000_76
    dw OamList_B01_4000_77
    dw OamList_B01_4000_78
    dw OamList_B01_4000_79
    dw OamList_B01_4000_7A
    dw OamList_B01_4000_7B
    dw OamList_B01_4000_7C
    dw OamList_B01_4000_7D
    dw OamList_B01_4000_7E
    dw OamList_B01_4000_7F
    dw OamList_B01_4000_80
    dw OamList_B01_4000_81
    dw OamList_B01_4000_82
    dw OamList_B01_4000_83
    dw OamList_B01_4000_84
    dw OamList_B01_4000_85
    dw OamList_B01_4000_86
    dw OamList_B01_4000_87
    dw OamList_B01_4000_88
    dw OamList_B01_4000_89
    dw OamList_B01_4000_8A
    dw OamList_B01_4000_8B
    dw OamList_B01_4000_8C
    dw OamList_B01_4000_8D
    dw OamList_B01_4000_8E
    dw OamList_B01_4000_8F
    dw OamList_B01_4000_90
    dw OamList_B01_4000_91
    dw OamList_B01_4000_92
    dw OamList_B01_4000_93
    dw OamList_B01_4000_94
    dw OamList_B01_4000_95
    dw OamList_B01_4000_96
    dw OamList_B01_4000_97
    dw OamList_B01_4000_98
    dw OamList_B01_4000_99
    dw OamList_B01_4000_9A
    dw OamList_B01_4000_9B
    dw OamList_B01_4000_9C
    dw OamList_B01_4000_9D
    dw OamList_B01_4000_9E
    dw OamList_B01_4000_9F
    dw OamList_B01_4000_A0
    dw OamList_B01_4000_A1
    dw OamList_B01_4000_A2
    dw OamList_B01_4000_A3
    dw OamList_B01_4000_A4
    dw OamList_B01_4000_A5
    dw OamList_B01_4000_A6
    dw OamList_B01_4000_A7
    dw OamList_B01_4000_A8
    dw OamList_B01_4000_A9
    dw OamList_B01_4000_AA
    dw OamList_B01_4000_AB
    dw OamList_B01_4000_AC
    dw OamList_B01_4000_AD
    dw OamList_B01_4000_AE
    dw OamList_B01_4000_AF
    dw OamList_B01_4000_B0
    dw OamList_B01_4000_B1
    dw OamList_B01_4000_B2
    dw OamList_B01_4000_B3
    dw OamList_B01_4000_B4
    dw OamList_B01_4000_B5
    dw OamList_B01_4000_B6
    dw OamList_B01_4000_B7
    dw OamList_B01_4000_B8
    dw OamList_B01_4000_B9
    dw OamList_B01_4000_BA
    dw OamList_B01_4000_BB
    dw OamList_B01_4000_BC
    dw OamList_B01_4000_BD
    dw OamList_B01_4000_BE
    dw OamList_B01_4000_BF
    dw OamList_B01_4000_C0
    dw OamList_B01_4000_C1
    dw OamList_B01_4000_C2
    dw OamList_B01_4000_C3
    dw OamList_B01_4000_C4
    dw OamList_B01_4000_C5
    dw OamList_B01_4000_C6
    dw OamList_B01_4000_C7
    dw OamList_B01_4000_C8
    dw OamList_B01_4000_C9
    dw OamList_B01_4000_CA
    dw OamList_B01_4000_CB
    dw OamList_B01_4000_CC
    dw OamList_B01_4000_CD
    dw OamList_B01_4000_CE
    dw OamList_B01_4000_CF
    dw OamList_B01_4000_D0
    dw OamList_B01_4000_D1
    dw OamList_B01_4000_D2
    dw OamList_B01_4000_D3
    dw OamList_B01_4000_D4
    dw OamList_B01_4000_D5
    dw OamList_B01_4000_D6
    dw OamList_B01_4000_D7
    dw OamList_B01_4000_D8
    dw OamList_B01_4000_D9
    dw OamList_B01_4000_DA
    dw OamList_B01_4000_DB
    dw OamList_B01_4000_DC
    dw OamList_B01_4000_DD
    dw OamList_B01_4000_DE
    dw OamList_B01_4000_DF
    dw OamList_B01_4000_E0
    dw OamList_B01_4000_E1
    dw OamList_B01_4000_E2
    dw OamList_B01_4000_E3
    dw OamList_B01_4000_E4
    dw OamList_B01_4000_E5
    dw OamList_B01_4000_E6
    dw OamList_B01_4000_E7
    dw OamList_B01_4000_E8
    dw OamList_B01_4000_E9
    dw OamList_B01_4000_EA
    dw OamList_B01_4000_EB
    dw OamList_B01_4000_EC
    dw OamList_B01_4000_ED
    dw OamList_B01_4000_EE
    dw OamList_B01_4000_EF
    dw OamList_B01_4000_F0
    dw OamList_B01_4000_F1
    dw OamList_B01_4000_F2
    dw OamList_B01_4000_F3
    dw OamList_B01_4000_F4
    dw OamList_B01_4000_F5
    dw OamList_B01_4000_F6
    dw OamList_B01_4000_F7
    dw OamList_B01_4000_F8

; C: OAM list 00 of the table 4000
OamList_B01_4000_00::
    db $08, $07, $51, $30
    db $08, $01, $51, $10
    db $80

; C: OAM list 01 of the table 4000
OamList_B01_4000_01::
    db $10, $07, $51, $70
    db $10, $01, $51, $50
    db $80

; C: OAM list 02 of the table 4000
OamList_B01_4000_02::
    db $10, $08, $50, $10
    db $08, $08, $50, $50
    db $80

; C: OAM list 03 of the table 4000
OamList_B01_4000_03::
    db $10, $00, $50, $30
    db $08, $00, $50, $70
    db $80

; C: OAM list 04 of the table 4000
OamList_B01_4000_04::
    db $10, $18, $58, $10
    db $10, $10, $57, $10
    db $10, $08, $56, $10
    db $18, $18, $5d, $10
    db $18, $10, $5c, $10
    db $18, $08, $5b, $10
    db $08, $08, $65, $10
    db $08, $10, $75, $10
    db $18, $18, $78, $00
    db $18, $10, $77, $00
    db $18, $08, $76, $00
    db $10, $18, $68, $00
    db $10, $10, $67, $00
    db $10, $08, $66, $00
    db $80

; C: OAM list 05 of the table 4000
OamList_B01_4000_05::
    db $10, $14, $5a, $10
    db $10, $0c, $59, $10
    db $10, $1c, $60, $10
    db $10, $1c, $6b, $00
    db $10, $14, $6a, $00
    db $10, $0c, $69, $00
    db $08, $0a, $65, $10
    db $08, $12, $75, $10
    db $18, $1c, $7b, $00
    db $18, $14, $7a, $00
    db $18, $0c, $79, $00
    db $18, $1c, $70, $10
    db $18, $14, $5f, $10
    db $18, $0c, $5e, $10
    db $80

; C: OAM list 06 of the table 4000
OamList_B01_4000_06::
    db $18, $20, $74, $10
    db $18, $18, $73, $10
    db $18, $10, $72, $10
    db $10, $20, $64, $10
    db $10, $18, $63, $10
    db $10, $10, $62, $10
    db $18, $08, $71, $10
    db $10, $08, $61, $10
    db $08, $0c, $65, $10
    db $08, $14, $75, $10
    db $18, $20, $7f, $00
    db $18, $18, $7e, $00
    db $18, $10, $7d, $00
    db $18, $08, $7c, $00
    db $10, $20, $6f, $00
    db $10, $18, $6e, $00
    db $10, $10, $6d, $00
    db $10, $08, $6c, $00
    db $80

; C: OAM list 07 of the table 4000
OamList_B01_4000_07::
    db $10, $18, $6a, $00
    db $10, $10, $69, $00
    db $10, $18, $5a, $10
    db $10, $10, $59, $10
    db $08, $0e, $65, $10
    db $08, $16, $75, $10
    db $18, $20, $7b, $00
    db $18, $18, $7a, $00
    db $18, $10, $79, $00
    db $10, $20, $6b, $00
    db $18, $20, $70, $10
    db $10, $20, $60, $10
    db $18, $18, $5f, $10
    db $18, $10, $5e, $10
    db $80

; C: OAM list 08 of the table 4000
OamList_B01_4000_08::
    db $10, $18, $63, $10
    db $18, $18, $73, $10
    db $18, $10, $72, $10
    db $10, $10, $62, $10
    db $18, $08, $71, $10
    db $10, $08, $61, $10
    db $08, $0c, $65, $10
    db $08, $14, $75, $10
    db $18, $18, $7e, $00
    db $18, $10, $7d, $00
    db $18, $08, $7c, $00
    db $10, $18, $6e, $00
    db $10, $10, $6d, $00
    db $10, $08, $6c, $00
    db $80

; C: OAM list 09 of the table 4000
OamList_B01_4000_09::
    db $10, $08, $52, $10
    db $80

; C: OAM list 0A of the table 4000
OamList_B01_4000_0A::
    db $10, $08, $53, $00
    db $80

; C: OAM list 0B of the table 4000
OamList_B01_4000_0B::
    db $10, $08, $54, $00
    db $80

; C: OAM list 0C of the table 4000
OamList_B01_4000_0C::
    db $10, $08, $55, $00
    db $80

; C: OAM list 0D of the table 4000
OamList_B01_4000_0D::
    db $18, $20, $fd, $10
    db $10, $20, $fc, $10
    db $18, $18, $fb, $10
    db $10, $18, $fa, $10
    db $18, $10, $f7, $10
    db $18, $08, $f9, $10
    db $10, $08, $f8, $10
    db $80

; C: OAM list 0E of the table 4000
OamList_B01_4000_0E::
    db $18, $18, $fd, $10
    db $10, $18, $fc, $10
    db $18, $10, $fb, $10
    db $10, $10, $fa, $10
    db $18, $08, $f9, $10
    db $10, $08, $f8, $10
    db $80

; C: OAM list 0F of the table 4000
OamList_B01_4000_0F::
    db $18, $30, $11, $10
    db $20, $20, $10, $10
    db $20, $30, $2b, $10
    db $28, $28, $2d, $10
    db $28, $20, $2c, $10
    db $20, $28, $2a, $10
    db $18, $28, $2f, $10
    db $18, $20, $2e, $10
    db $28, $20, $7f, $00
    db $28, $18, $7e, $00
    db $28, $10, $7d, $00
    db $28, $08, $7c, $00
    db $20, $20, $7b, $00
    db $20, $18, $7a, $00
    db $20, $10, $79, $00
    db $20, $08, $78, $00
    db $18, $20, $77, $00
    db $18, $18, $76, $00
    db $18, $10, $75, $00
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $80

; C: OAM list 10 of the table 4000
OamList_B01_4000_10::
    db $2c, $24, $61, $10
    db $2c, $1c, $60, $10
    db $24, $24, $51, $10
    db $24, $1c, $50, $10
    db $1c, $24, $41, $10
    db $1c, $1c, $40, $10
    db $24, $1c, $7f, $00
    db $24, $14, $7e, $00
    db $24, $0c, $7d, $00
    db $24, $04, $7c, $00
    db $1c, $1c, $7b, $00
    db $1c, $14, $7a, $00
    db $1c, $0c, $79, $00
    db $1c, $04, $78, $00
    db $14, $1c, $77, $00
    db $14, $14, $76, $00
    db $14, $0c, $75, $00
    db $14, $04, $74, $00
    db $0c, $1c, $73, $00
    db $0c, $14, $72, $00
    db $0c, $0c, $71, $00
    db $0c, $04, $70, $00
    db $80

; C: OAM list 11 of the table 4000
OamList_B01_4000_11::
    db $1c, $24, $45, $10
    db $1c, $1c, $44, $10
    db $24, $24, $55, $10
    db $2c, $24, $65, $10
    db $24, $1c, $54, $10
    db $2c, $1c, $64, $10
    db $14, $1c, $53, $10
    db $14, $14, $52, $10
    db $0c, $1c, $43, $10
    db $0c, $14, $42, $10
    db $14, $0c, $75, $00
    db $14, $04, $74, $00
    db $0c, $0c, $71, $00
    db $0c, $04, $70, $00
    db $24, $1c, $7f, $00
    db $24, $14, $7e, $00
    db $24, $0c, $7d, $00
    db $24, $04, $7c, $00
    db $1c, $1c, $7b, $00
    db $1c, $14, $7a, $00
    db $1c, $0c, $79, $00
    db $1c, $04, $78, $00
    db $80

; C: OAM list 12 of the table 4000
OamList_B01_4000_12::
    db $14, $0c, $36, $10
    db $1c, $0c, $38, $10
    db $14, $14, $37, $10
    db $24, $14, $67, $10
    db $24, $1c, $3b, $10
    db $1c, $1c, $3a, $10
    db $1c, $14, $39, $10
    db $14, $04, $35, $10
    db $14, $fc, $34, $10
    db $24, $14, $7e, $00
    db $24, $0c, $7d, $00
    db $24, $04, $7c, $00
    db $1c, $0c, $79, $00
    db $1c, $04, $78, $00
    db $80

; C: OAM list 13 of the table 4000
OamList_B01_4000_13::
    db $28, $17, $68, $10
    db $18, $0f, $48, $10
    db $20, $1f, $59, $10
    db $18, $07, $47, $10
    db $18, $ff, $46, $10
    db $28, $0f, $67, $10
    db $20, $17, $58, $10
    db $20, $0f, $57, $10
    db $20, $07, $56, $10
    db $80

; C: OAM list 14 of the table 4000
OamList_B01_4000_14::
    db $38, $20, $6b, $10
    db $38, $18, $6a, $10
    db $30, $20, $5b, $10
    db $30, $18, $5a, $10
    db $28, $20, $4b, $10
    db $28, $18, $4a, $10
    db $28, $20, $7f, $00
    db $28, $18, $7e, $00
    db $28, $10, $7d, $00
    db $28, $08, $7c, $00
    db $20, $20, $7b, $00
    db $20, $18, $7a, $00
    db $20, $10, $79, $00
    db $20, $08, $78, $00
    db $18, $20, $77, $00
    db $18, $18, $76, $00
    db $18, $10, $75, $00
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $80

; C: OAM list 15 of the table 4000
OamList_B01_4000_15::
    db $20, $20, $0c, $10
    db $20, $18, $0b, $10
    db $18, $20, $0a, $10
    db $18, $18, $09, $10
    db $38, $20, $6d, $10
    db $38, $18, $6c, $10
    db $30, $20, $5d, $10
    db $30, $18, $5c, $10
    db $28, $20, $4d, $10
    db $28, $18, $4c, $10
    db $28, $20, $7f, $00
    db $28, $18, $7e, $00
    db $28, $10, $7d, $00
    db $28, $08, $7c, $00
    db $20, $20, $7b, $00
    db $20, $18, $7a, $00
    db $20, $10, $79, $00
    db $20, $08, $78, $00
    db $18, $20, $77, $00
    db $18, $18, $76, $00
    db $18, $10, $75, $00
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $80

; C: OAM list 16 of the table 4000
OamList_B01_4000_16::
    db $20, $18, $66, $10
    db $38, $20, $6f, $10
    db $38, $18, $6e, $10
    db $30, $20, $5f, $10
    db $30, $18, $5e, $10
    db $28, $20, $4f, $10
    db $28, $18, $4e, $10
    db $28, $20, $7f, $00
    db $28, $18, $7e, $00
    db $28, $10, $7d, $00
    db $28, $08, $7c, $00
    db $20, $20, $7b, $00
    db $20, $18, $7a, $00
    db $20, $10, $79, $00
    db $20, $08, $78, $00
    db $18, $20, $77, $00
    db $18, $18, $76, $00
    db $18, $10, $75, $00
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $80

; C: OAM list 17 of the table 4000
OamList_B01_4000_17::
    db $20, $08, $30, $00
    db $20, $10, $31, $00
    db $20, $20, $0c, $10
    db $20, $18, $0b, $10
    db $18, $20, $0a, $10
    db $18, $18, $09, $10
    db $28, $20, $4d, $10
    db $28, $18, $4c, $10
    db $18, $20, $23, $00
    db $18, $18, $22, $00
    db $18, $10, $21, $00
    db $20, $20, $33, $00
    db $20, $18, $32, $00
    db $38, $20, $6d, $10
    db $38, $18, $6c, $10
    db $30, $20, $5d, $10
    db $30, $18, $5c, $10
    db $18, $20, $77, $00
    db $18, $18, $76, $00
    db $18, $10, $75, $00
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $20, $08, $78, $00
    db $80

; C: OAM list 18 of the table 4000
OamList_B01_4000_18::
    db $18, $20, $23, $00
    db $18, $10, $21, $00
    db $18, $18, $22, $00
    db $20, $18, $66, $10
    db $38, $20, $6f, $10
    db $38, $18, $6e, $10
    db $30, $20, $5f, $10
    db $30, $18, $5e, $10
    db $28, $20, $4f, $10
    db $28, $18, $4e, $10
    db $20, $08, $30, $00
    db $20, $20, $33, $00
    db $20, $18, $32, $00
    db $20, $10, $31, $00
    db $20, $08, $78, $00
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $18, $20, $77, $00
    db $18, $18, $76, $00
    db $18, $10, $75, $00
    db $80

; C: OAM list 19 of the table 4000
OamList_B01_4000_19::
    db $10, $20, $23, $00
    db $10, $18, $22, $00
    db $10, $10, $21, $00
    db $18, $08, $30, $00
    db $18, $10, $31, $00
    db $18, $20, $0a, $10
    db $18, $18, $09, $10
    db $20, $20, $0c, $10
    db $20, $18, $0b, $10
    db $18, $20, $33, $00
    db $18, $18, $32, $00
    db $28, $20, $4d, $10
    db $28, $18, $4c, $10
    db $38, $20, $6d, $10
    db $38, $18, $6c, $10
    db $30, $20, $5d, $10
    db $30, $18, $5c, $10
    db $10, $08, $70, $00
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $80

; C: OAM list 1A of the table 4000
OamList_B01_4000_1A::
    db $18, $08, $30, $00
    db $10, $20, $23, $00
    db $10, $18, $22, $00
    db $10, $10, $21, $00
    db $18, $20, $33, $00
    db $18, $18, $32, $00
    db $18, $10, $31, $00
    db $20, $18, $66, $10
    db $38, $20, $6f, $10
    db $38, $18, $6e, $10
    db $30, $20, $5f, $10
    db $30, $18, $5e, $10
    db $28, $20, $4f, $10
    db $28, $18, $4e, $10
    db $18, $08, $74, $00
    db $10, $20, $73, $00
    db $10, $18, $72, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $80

; C: OAM list 1B of the table 4000
OamList_B01_4000_1B::
    db $10, $10, $23, $00
    db $10, $08, $22, $00
    db $20, $20, $0c, $10
    db $20, $18, $0b, $10
    db $18, $20, $0a, $10
    db $18, $18, $09, $10
    db $38, $20, $6d, $10
    db $38, $18, $6c, $10
    db $30, $20, $5d, $10
    db $30, $18, $5c, $10
    db $28, $20, $4d, $10
    db $28, $18, $4c, $10
    db $10, $18, $20, $00
    db $18, $10, $33, $00
    db $18, $08, $32, $00
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $80

; C: OAM list 1C of the table 4000
OamList_B01_4000_1C::
    db $10, $10, $23, $00
    db $10, $08, $22, $00
    db $20, $18, $66, $10
    db $10, $18, $20, $00
    db $18, $10, $33, $00
    db $18, $08, $32, $00
    db $38, $20, $6f, $10
    db $38, $18, $6e, $10
    db $30, $20, $5f, $10
    db $30, $18, $5e, $10
    db $28, $20, $4f, $10
    db $28, $18, $4e, $10
    db $10, $10, $71, $00
    db $10, $08, $70, $00
    db $80

; C: OAM list 1D of the table 4000
OamList_B01_4000_1D::
    db $37, $20, $6f, $10
    db $37, $18, $6e, $10
    db $2f, $20, $5f, $10
    db $2f, $18, $5e, $10
    db $27, $20, $4f, $10
    db $27, $18, $4e, $10
    db $80

; C: OAM list 1E of the table 4000
OamList_B01_4000_1E::
    db $0d, $06, $3d, $10
    db $15, $fe, $3c, $10
    db $15, $0e, $3a, $10
    db $1d, $06, $67, $10
    db $1d, $0e, $3b, $10
    db $15, $06, $39, $10
    db $80

; C: OAM list 1F of the table 4000
OamList_B01_4000_1F::
    db $0b, $06, $37, $10
    db $13, $0c, $25, $10
    db $13, $04, $24, $10
    db $1b, $0c, $3f, $10
    db $1b, $04, $3e, $10
    db $80

; C: OAM list 20 of the table 4000
OamList_B01_4000_20::
    db $22, $2c, $2b, $10
    db $2a, $24, $2d, $10
    db $2a, $1c, $2c, $10
    db $1a, $2c, $28, $10
    db $1a, $24, $27, $10
    db $1a, $1c, $26, $10
    db $22, $24, $2a, $10
    db $22, $1c, $29, $10
    db $80

; C: OAM list 21 of the table 4000
OamList_B01_4000_21::
    db $1a, $2c, $11, $10
    db $22, $1c, $10, $10
    db $1a, $24, $2f, $10
    db $1a, $1c, $2e, $10
    db $22, $2c, $2b, $10
    db $2a, $24, $2d, $10
    db $2a, $1c, $2c, $10
    db $22, $24, $2a, $10
    db $80

; C: OAM list 22 of the table 4000
OamList_B01_4000_22::
    db $10, $18, $14, $10
    db $10, $10, $13, $10
    db $10, $08, $12, $10
    db $80

; C: OAM list 23 of the table 4000
OamList_B01_4000_23::
    db $3f, $20, $50, $60
    db $10, $20, $50, $20
    db $3f, $08, $50, $40
    db $10, $08, $50, $00
    db $80

; C: OAM list 24 of the table 4000
OamList_B01_4000_24::
    db $3e, $1f, $50, $60
    db $11, $1f, $50, $20
    db $3e, $09, $50, $40
    db $11, $09, $50, $00
    db $80

; C: OAM list 25 of the table 4000
OamList_B01_4000_25::
    db $2d, $14, $50, $60
    db $10, $14, $50, $20
    db $2d, $08, $50, $40
    db $10, $08, $50, $00
    db $80

; C: OAM list 26 of the table 4000
OamList_B01_4000_26::
    db $2c, $13, $50, $60
    db $11, $13, $50, $20
    db $2c, $09, $50, $40
    db $11, $09, $50, $00
    db $80

; C: OAM list 27 of the table 4000
OamList_B01_4000_27::
    db $3e, $10, $59, $00
    db $3e, $08, $59, $00
    db $10, $10, $59, $00
    db $10, $08, $59, $00
    db $80

; C: OAM list 28 of the table 4000
OamList_B01_4000_28::
    db $3e, $10, $59, $00
    db $3e, $08, $59, $00
    db $80

; C: OAM list 29 of the table 4000
OamList_B01_4000_29::
    db $30, $1d, $50, $60
    db $10, $1d, $50, $20
    db $30, $08, $50, $40
    db $10, $08, $50, $00
    db $80

; C: OAM list 2A of the table 4000
OamList_B01_4000_2A::
    db $2f, $1c, $50, $60
    db $11, $1c, $50, $20
    db $2f, $09, $50, $40
    db $11, $09, $50, $00
    db $80

; C: OAM list 2B of the table 4000
OamList_B01_4000_2B::
    db $0d, $05, $57, $10
    db $80

; C: OAM list 2C of the table 4000
OamList_B01_4000_2C::
    db $0d, $05, $58, $10
    db $80

; C: OAM list 2D of the table 4000
OamList_B01_4000_2D::
    db $10, $08, $56, $10
    db $80

; C: OAM list 2E of the table 4000
OamList_B01_4000_2E::
    db $10, $08, $53, $10
    db $80

; C: OAM list 2F of the table 4000
OamList_B01_4000_2F::
    db $0e, $06, $55, $10
    db $80

; C: OAM list 30 of the table 4000
OamList_B01_4000_30::
    db $0e, $06, $52, $10
    db $80

; C: OAM list 31 of the table 4000
OamList_B01_4000_31::
    db $0c, $04, $54, $10
    db $80

; C: OAM list 32 of the table 4000
OamList_B01_4000_32::
    db $0c, $04, $51, $10
    db $80

; C: OAM list 33 of the table 4000
OamList_B01_4000_33::
    db $0f, $20, $50, $20
    db $27, $20, $50, $60
    db $27, $08, $50, $40
    db $0f, $08, $50, $00
    db $80

; C: OAM list 34 of the table 4000
OamList_B01_4000_34::
    db $10, $1f, $50, $20
    db $26, $1f, $50, $60
    db $26, $09, $50, $40
    db $10, $09, $50, $00
    db $80

; C: OAM list 35 of the table 4000
OamList_B01_4000_35::
    db $2c, $08, $50, $40
    db $2c, $1a, $50, $60
    db $0f, $1a, $50, $20
    db $0f, $08, $50, $00
    db $80

; C: OAM list 36 of the table 4000
OamList_B01_4000_36::
    db $2b, $19, $50, $60
    db $2b, $09, $50, $40
    db $10, $19, $50, $20
    db $10, $09, $50, $00
    db $80

; C: OAM list 37 of the table 4000
OamList_B01_4000_37::
    db $0f, $13, $50, $20
    db $22, $13, $50, $60
    db $22, $08, $50, $40
    db $0f, $08, $50, $00
    db $80

; C: OAM list 38 of the table 4000
OamList_B01_4000_38::
    db $10, $12, $50, $20
    db $21, $12, $50, $60
    db $21, $09, $50, $40
    db $10, $09, $50, $00
    db $80

; C: OAM list 39 of the table 4000
OamList_B01_4000_39::
    db $27, $10, $ee, $10
    db $27, $09, $ee, $10
    db $80

; C: OAM list 3A of the table 4000
OamList_B01_4000_3A::
    db $f8, $10, $ee, $10
    db $f8, $09, $ee, $10
    db $80

; C: OAM list 3B of the table 4000
OamList_B01_4000_3B::
    db $0f, $21, $50, $20
    db $2d, $21, $50, $60
    db $2d, $07, $50, $40
    db $0f, $07, $50, $00
    db $80

; C: OAM list 3C of the table 4000
OamList_B01_4000_3C::
    db $10, $20, $50, $20
    db $2c, $20, $50, $60
    db $2c, $08, $50, $40
    db $10, $08, $50, $00
    db $80

; C: OAM list 3D of the table 4000
OamList_B01_4000_3D::
    db $0e, $29, $50, $20
    db $30, $29, $50, $60
    db $30, $07, $50, $40
    db $0e, $07, $50, $00
    db $80

; C: OAM list 3E of the table 4000
OamList_B01_4000_3E::
    db $0f, $28, $50, $20
    db $2f, $28, $50, $60
    db $2f, $08, $50, $40
    db $0f, $08, $50, $00
    db $80

; C: OAM list 3F of the table 4000
OamList_B01_4000_3F::
    db $0e, $29, $50, $20
    db $38, $29, $50, $60
    db $38, $07, $50, $40
    db $0e, $07, $50, $00
    db $80

; C: OAM list 40 of the table 4000
OamList_B01_4000_40::
    db $0f, $28, $50, $20
    db $37, $28, $50, $60
    db $37, $08, $50, $40
    db $0f, $08, $50, $00
    db $80

; C: OAM list 41 of the table 4000
OamList_B01_4000_41::
    db $30, $28, $bc, $10
    db $30, $20, $ba, $10
    db $30, $18, $b8, $10
    db $30, $10, $b6, $10
    db $30, $08, $b4, $10
    db $20, $28, $b2, $10
    db $20, $20, $b0, $10
    db $20, $18, $ae, $10
    db $20, $10, $ac, $10
    db $20, $08, $aa, $10
    db $10, $28, $a8, $10
    db $10, $20, $a6, $10
    db $10, $18, $a4, $10
    db $10, $10, $a2, $10
    db $10, $08, $a0, $10
    db $30, $28, $6e, $00
    db $30, $20, $6c, $00
    db $30, $18, $6a, $00
    db $30, $10, $68, $00
    db $30, $08, $66, $00
    db $20, $28, $64, $00
    db $20, $20, $62, $00
    db $20, $18, $60, $00
    db $20, $10, $5e, $00
    db $20, $08, $5c, $00
    db $10, $28, $5a, $00
    db $10, $20, $58, $00
    db $10, $18, $56, $00
    db $10, $10, $54, $00
    db $10, $08, $52, $00
    db $80

; C: OAM list 42 of the table 4000
OamList_B01_4000_42::
    db $10, $08, $60, $00
    db $80

; C: OAM list 43 of the table 4000
OamList_B01_4000_43::
    db $10, $08, $61, $00
    db $80

; C: OAM list 44 of the table 4000
OamList_B01_4000_44::
    db $10, $08, $62, $00
    db $80

; C: OAM list 45 of the table 4000
OamList_B01_4000_45::
    db $10, $08, $63, $00
    db $80

; C: OAM list 46 of the table 4000
OamList_B01_4000_46::
    db $10, $08, $64, $00
    db $80

; C: OAM list 47 of the table 4000
OamList_B01_4000_47::
    db $10, $08, $65, $00
    db $80

; C: OAM list 48 of the table 4000
OamList_B01_4000_48::
    db $10, $08, $66, $00
    db $80

; C: OAM list 49 of the table 4000
OamList_B01_4000_49::
    db $10, $08, $70, $00
    db $80

; C: OAM list 4A of the table 4000
OamList_B01_4000_4A::
    db $10, $08, $71, $00
    db $80

; C: OAM list 4B of the table 4000
OamList_B01_4000_4B::
    db $10, $08, $72, $00
    db $80

; C: OAM list 4C of the table 4000
OamList_B01_4000_4C::
    db $10, $08, $73, $00
    db $80

; C: OAM list 4D of the table 4000
OamList_B01_4000_4D::
    db $10, $08, $74, $00
    db $80

; C: OAM list 4E of the table 4000
OamList_B01_4000_4E::
    db $10, $08, $75, $00
    db $80

; C: OAM list 4F of the table 4000
OamList_B01_4000_4F::
    db $10, $08, $76, $00
    db $80

; C: OAM list 50 of the table 4000
OamList_B01_4000_50::
    db $10, $08, $79, $10
    db $10, $0a, $78, $30
    db $10, $02, $78, $10
    db $14, $07, $77, $50
    db $80

; C: OAM list 51 of the table 4000
OamList_B01_4000_51::
    db $10, $08, $79, $10
    db $10, $0b, $78, $30
    db $10, $01, $78, $10
    db $15, $07, $77, $50
    db $80

; C: OAM list 52 of the table 4000
OamList_B01_4000_52::
    db $10, $08, $79, $10
    db $10, $0c, $78, $30
    db $10, $00, $78, $10
    db $16, $07, $77, $50
    db $80

; C: OAM list 53 of the table 4000
OamList_B01_4000_53::
    db $10, $08, $79, $10
    db $10, $0a, $78, $30
    db $10, $02, $78, $10
    db $0b, $07, $77, $10
    db $80

; C: OAM list 54 of the table 4000
OamList_B01_4000_54::
    db $10, $08, $79, $10
    db $10, $0b, $78, $30
    db $10, $01, $78, $10
    db $0a, $07, $77, $10
    db $80

; C: OAM list 55 of the table 4000
OamList_B01_4000_55::
    db $10, $08, $79, $10
    db $10, $0c, $78, $30
    db $10, $00, $78, $10
    db $09, $07, $77, $10
    db $80

; C: OAM list 56 of the table 4000
OamList_B01_4000_56::
    db $10, $ff, $78, $10
    db $18, $09, $77, $50
    db $10, $10, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 57 of the table 4000
OamList_B01_4000_57::
    db $10, $fe, $78, $10
    db $19, $09, $77, $50
    db $10, $11, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 58 of the table 4000
OamList_B01_4000_58::
    db $10, $fd, $78, $10
    db $1a, $09, $77, $50
    db $10, $12, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 59 of the table 4000
OamList_B01_4000_59::
    db $08, $09, $77, $10
    db $10, $ff, $78, $10
    db $18, $09, $77, $50
    db $10, $10, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 5A of the table 4000
OamList_B01_4000_5A::
    db $07, $09, $77, $10
    db $10, $fe, $78, $10
    db $19, $09, $77, $50
    db $10, $11, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 5B of the table 4000
OamList_B01_4000_5B::
    db $06, $09, $77, $10
    db $10, $fd, $78, $10
    db $1a, $09, $77, $50
    db $10, $12, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 5C of the table 4000
OamList_B01_4000_5C::
    db $08, $09, $77, $10
    db $10, $ff, $78, $10
    db $10, $10, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 5D of the table 4000
OamList_B01_4000_5D::
    db $07, $09, $77, $10
    db $10, $fe, $78, $10
    db $10, $11, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 5E of the table 4000
OamList_B01_4000_5E::
    db $06, $09, $77, $10
    db $10, $fd, $78, $10
    db $10, $12, $78, $30
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 5F of the table 4000
OamList_B01_4000_5F::
    db $15, $0d, $7e, $00
    db $15, $05, $7d, $00
    db $0d, $0d, $7c, $00
    db $0d, $05, $7b, $00
    db $80

; C: OAM list 60 of the table 4000
OamList_B01_4000_60::
    db $14, $04, $6d, $30
    db $14, $0b, $6d, $10
    db $0d, $0b, $6d, $50
    db $0d, $04, $6d, $70
    db $0d, $fe, $67, $30
    db $15, $fe, $68, $30
    db $15, $11, $68, $10
    db $0d, $11, $67, $10
    db $07, $0b, $6a, $10
    db $07, $03, $69, $10
    db $1a, $0b, $6a, $50
    db $1a, $03, $69, $50
    db $80

; C: OAM list 61 of the table 4000
OamList_B01_4000_61::
    db $07, $0b, $6a, $10
    db $07, $03, $69, $10
    db $0f, $0c, $6f, $10
    db $0f, $04, $6e, $10
    db $12, $03, $6f, $70
    db $12, $0b, $6e, $70
    db $0d, $fc, $67, $30
    db $15, $fc, $68, $30
    db $15, $13, $68, $10
    db $0d, $13, $67, $10
    db $1a, $0b, $6a, $50
    db $1a, $03, $69, $50
    db $80

; C: OAM list 62 of the table 4000
OamList_B01_4000_62::
    db $15, $09, $6c, $70
    db $0d, $09, $6b, $70
    db $0c, $06, $6c, $10
    db $14, $06, $6b, $10
    db $05, $0b, $6a, $10
    db $05, $03, $69, $10
    db $0d, $fd, $67, $30
    db $15, $fd, $68, $30
    db $15, $12, $68, $10
    db $0d, $12, $67, $10
    db $1c, $0b, $6a, $50
    db $1c, $03, $69, $50
    db $80

; C: OAM list 63 of the table 4000
OamList_B01_4000_63::
    db $23, $0f, $44, $10
    db $23, $07, $43, $10
    db $0b, $09, $51, $30
    db $0b, $11, $50, $30
    db $13, $03, $45, $30
    db $1b, $03, $42, $30
    db $1b, $0b, $41, $30
    db $1b, $13, $40, $30
    db $13, $0b, $5f, $30
    db $13, $13, $5e, $30
    db $80

; C: OAM list 64 of the table 4000
OamList_B01_4000_64::
    db $1b, $09, $5b, $30
    db $1b, $11, $5a, $30
    db $13, $09, $56, $30
    db $13, $11, $55, $30
    db $0b, $09, $51, $30
    db $0b, $11, $50, $30
    db $80

; C: OAM list 65 of the table 4000
OamList_B01_4000_65::
    db $1b, $11, $5c, $30
    db $13, $09, $58, $30
    db $13, $11, $57, $30
    db $0b, $09, $53, $30
    db $0b, $11, $52, $30
    db $1b, $09, $5b, $30
    db $80

; C: OAM list 66 of the table 4000
OamList_B01_4000_66::
    db $1b, $11, $5d, $30
    db $13, $09, $58, $30
    db $13, $11, $59, $30
    db $0b, $09, $53, $30
    db $0b, $11, $54, $30
    db $1b, $09, $5b, $30
    db $80

; C: OAM list 67 of the table 4000
OamList_B01_4000_67::
    db $1f, $08, $4b, $30
    db $1f, $10, $4a, $30
    db $1f, $18, $49, $30
    db $17, $08, $48, $30
    db $17, $10, $47, $30
    db $17, $18, $46, $30
    db $80

; C: OAM list 68 of the table 4000
OamList_B01_4000_68::
    db $1f, $08, $31, $30
    db $1f, $10, $30, $30
    db $1f, $18, $4f, $30
    db $17, $08, $4e, $30
    db $17, $10, $4d, $30
    db $17, $18, $4c, $30
    db $80

; C: OAM list 69 of the table 4000
OamList_B01_4000_69::
    db $1b, $07, $5b, $10
    db $1b, $ff, $5a, $10
    db $13, $07, $56, $10
    db $13, $ff, $55, $10
    db $0b, $07, $51, $10
    db $0b, $ff, $50, $10
    db $80

; C: OAM list 6A of the table 4000
OamList_B01_4000_6A::
    db $1b, $ff, $5c, $10
    db $13, $07, $58, $10
    db $13, $ff, $57, $10
    db $0b, $07, $53, $10
    db $0b, $ff, $52, $10
    db $1b, $07, $5b, $10
    db $80

; C: OAM list 6B of the table 4000
OamList_B01_4000_6B::
    db $1b, $ff, $5d, $10
    db $13, $07, $58, $10
    db $13, $ff, $59, $10
    db $0b, $07, $53, $10
    db $0b, $ff, $54, $10
    db $1b, $07, $5b, $10
    db $80

; C: OAM list 6C of the table 4000
OamList_B01_4000_6C::
    db $1f, $08, $4b, $10
    db $1f, $00, $4a, $10
    db $1f, $f8, $49, $10
    db $17, $08, $48, $10
    db $17, $00, $47, $10
    db $17, $f8, $46, $10
    db $80

; C: OAM list 6D of the table 4000
OamList_B01_4000_6D::
    db $1f, $08, $31, $10
    db $1f, $00, $30, $10
    db $1f, $f8, $4f, $10
    db $17, $08, $4e, $10
    db $17, $00, $4d, $10
    db $17, $f8, $4c, $10
    db $80

; C: OAM list 6E of the table 4000
OamList_B01_4000_6E::
    db $00, $08, $6a, $50
    db $00, $00, $69, $50
    db $18, $08, $6a, $10
    db $18, $00, $69, $10
    db $80

; C: OAM list 6F of the table 4000
OamList_B01_4000_6F::
    db $01, $08, $6a, $50
    db $01, $00, $69, $50
    db $17, $08, $6a, $10
    db $17, $00, $69, $10
    db $80

; C: OAM list 70 of the table 4000
OamList_B01_4000_70::
    db $02, $08, $6a, $50
    db $02, $00, $69, $50
    db $16, $08, $6a, $10
    db $16, $00, $69, $10
    db $80

; C: OAM list 71 of the table 4000
OamList_B01_4000_71::
    db $04, $08, $6a, $50
    db $04, $00, $69, $50
    db $14, $08, $6a, $10
    db $14, $00, $69, $10
    db $80

; C: OAM list 72 of the table 4000
OamList_B01_4000_72::
    db $05, $08, $6a, $50
    db $05, $00, $69, $50
    db $13, $08, $6a, $10
    db $13, $00, $69, $10
    db $80

; C: OAM list 73 of the table 4000
OamList_B01_4000_73::
    db $06, $08, $6a, $50
    db $06, $00, $69, $50
    db $12, $08, $6a, $10
    db $12, $00, $69, $10
    db $80

; C: OAM list 74 of the table 4000
OamList_B01_4000_74::
    db $19, $0c, $29, $10
    db $19, $04, $28, $10
    db $11, $0c, $27, $10
    db $11, $04, $26, $10
    db $09, $0c, $25, $10
    db $09, $04, $24, $10
    db $80

; C: OAM list 75 of the table 4000
OamList_B01_4000_75::
    db $18, $10, $3f, $10
    db $18, $08, $3e, $10
    db $10, $10, $3d, $10
    db $10, $08, $3c, $10
    db $80

; C: OAM list 76 of the table 4000
OamList_B01_4000_76::
    db $18, $10, $23, $10
    db $18, $08, $22, $10
    db $10, $10, $21, $10
    db $10, $08, $20, $10
    db $80

; C: OAM list 77 of the table 4000
OamList_B01_4000_77::
    db $1f, $18, $39, $00
    db $1f, $10, $38, $00
    db $1f, $08, $37, $00
    db $17, $18, $36, $00
    db $17, $10, $35, $00
    db $17, $08, $34, $00
    db $0f, $10, $33, $10
    db $0f, $08, $32, $10
    db $80

; C: OAM list 78 of the table 4000
OamList_B01_4000_78::
    db $17, $10, $3b, $00
    db $17, $08, $3a, $00
    db $1f, $18, $39, $00
    db $1f, $10, $38, $00
    db $1f, $08, $37, $00
    db $17, $18, $36, $00
    db $0f, $10, $33, $10
    db $0f, $08, $32, $10
    db $80

; C: OAM list 79 of the table 4000
OamList_B01_4000_79::
    db $10, $08, $2b, $30
    db $10, $00, $2b, $10
    db $80

; C: OAM list 7A of the table 4000
OamList_B01_4000_7A::
    db $10, $08, $79, $10
    db $80

; C: OAM list 7B of the table 4000
OamList_B01_4000_7B::
    db $10, $08, $2c, $10
    db $80

; C: OAM list 7C of the table 4000
OamList_B01_4000_7C::
    db $10, $08, $2d, $00
    db $80

; C: OAM list 7D of the table 4000
OamList_B01_4000_7D::
    db $23, $09, $44, $10
    db $23, $01, $43, $10
    db $0b, $07, $51, $10
    db $0b, $ff, $50, $10
    db $13, $0d, $45, $10
    db $1b, $0d, $42, $10
    db $1b, $05, $41, $10
    db $1b, $fd, $40, $10
    db $13, $05, $5f, $10
    db $13, $fd, $5e, $10
    db $80

; C: OAM list 7E of the table 4000
OamList_B01_4000_7E::
    db $0e, $08, $1d, $10
    db $16, $08, $11, $10
    db $80

; C: OAM list 7F of the table 4000
OamList_B01_4000_7F::
    db $16, $08, $13, $10
    db $0e, $08, $12, $10
    db $80

; C: OAM list 80 of the table 4000
OamList_B01_4000_80::
    db $16, $08, $15, $10
    db $0e, $08, $14, $10
    db $80

; C: OAM list 81 of the table 4000
OamList_B01_4000_81::
    db $16, $08, $17, $10
    db $0e, $08, $16, $10
    db $80

; C: OAM list 82 of the table 4000
OamList_B01_4000_82::
    db $16, $08, $19, $10
    db $0e, $08, $18, $10
    db $80

; C: OAM list 83 of the table 4000
OamList_B01_4000_83::
    db $16, $08, $10, $10
    db $0e, $08, $1a, $10
    db $80

; C: OAM list 84 of the table 4000
OamList_B01_4000_84::
    db $16, $08, $1b, $10
    db $0e, $08, $1a, $10
    db $80

; C: OAM list 85 of the table 4000
OamList_B01_4000_85::
    db $16, $08, $2a, $10
    db $0e, $08, $1c, $10
    db $80

; C: OAM list 86 of the table 4000
OamList_B01_4000_86::
    db $16, $08, $1e, $10
    db $0e, $08, $1d, $10
    db $80

; C: OAM list 87 of the table 4000
OamList_B01_4000_87::
    db $0e, $08, $1d, $10
    db $16, $08, $1f, $10
    db $80

; C: OAM list 88 of the table 4000
OamList_B01_4000_88::
    db $14, $04, $6d, $30
    db $14, $0b, $6d, $10
    db $0d, $0b, $6d, $50
    db $0d, $04, $6d, $70
    db $0d, $fe, $67, $30
    db $15, $fe, $68, $30
    db $15, $11, $68, $10
    db $0d, $11, $67, $10
    db $1a, $0b, $6a, $50
    db $1a, $03, $69, $50
    db $80

; C: OAM list 89 of the table 4000
OamList_B01_4000_89::
    db $0f, $0c, $6f, $10
    db $0f, $04, $6e, $10
    db $12, $03, $6f, $70
    db $12, $0b, $6e, $70
    db $0d, $fc, $67, $30
    db $15, $fc, $68, $30
    db $15, $13, $68, $10
    db $0d, $13, $67, $10
    db $1a, $0b, $6a, $50
    db $1a, $03, $69, $50
    db $80

; C: OAM list 8A of the table 4000
OamList_B01_4000_8A::
    db $15, $09, $6c, $70
    db $0d, $09, $6b, $70
    db $0c, $06, $6c, $10
    db $14, $06, $6b, $10
    db $0d, $fd, $67, $30
    db $15, $fd, $68, $30
    db $15, $12, $68, $10
    db $0d, $12, $67, $10
    db $1c, $0b, $6a, $50
    db $1c, $03, $69, $50
    db $80

; C: OAM list 8B of the table 4000
OamList_B01_4000_8B::
    db $14, $04, $6d, $30
    db $14, $0b, $6d, $10
    db $0d, $0b, $6d, $50
    db $0d, $04, $6d, $70
    db $0d, $fe, $67, $30
    db $15, $fe, $68, $30
    db $15, $11, $68, $10
    db $0d, $11, $67, $10
    db $07, $0b, $6a, $10
    db $07, $03, $69, $10
    db $80

; C: OAM list 8C of the table 4000
OamList_B01_4000_8C::
    db $07, $0b, $6a, $10
    db $07, $03, $69, $10
    db $0f, $0c, $6f, $10
    db $0f, $04, $6e, $10
    db $12, $03, $6f, $70
    db $12, $0b, $6e, $70
    db $0d, $fc, $67, $30
    db $15, $fc, $68, $30
    db $15, $13, $68, $10
    db $0d, $13, $67, $10
    db $80

; C: OAM list 8D of the table 4000
OamList_B01_4000_8D::
    db $15, $09, $6c, $70
    db $0d, $09, $6b, $70
    db $0c, $06, $6c, $10
    db $14, $06, $6b, $10
    db $05, $0b, $6a, $10
    db $05, $03, $69, $10
    db $0d, $fd, $67, $30
    db $15, $fd, $68, $30
    db $15, $12, $68, $10
    db $0d, $12, $67, $10
    db $80

; C: OAM list 8E of the table 4000
OamList_B01_4000_8E::
    db $17, $08, $77, $50
    db $10, $ff, $78, $10
    db $07, $08, $77, $10
    db $10, $0f, $78, $30
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $0d, $01, $10
    db $0d, $05, $00, $10
    db $80

; C: OAM list 8F of the table 4000
OamList_B01_4000_8F::
    db $10, $fe, $78, $10
    db $06, $08, $77, $10
    db $10, $10, $78, $30
    db $18, $08, $77, $50
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $05, $00, $10
    db $0d, $0d, $01, $10
    db $80

; C: OAM list 90 of the table 4000
OamList_B01_4000_90::
    db $10, $fd, $78, $10
    db $1a, $08, $77, $50
    db $10, $11, $78, $30
    db $05, $08, $77, $10
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $05, $00, $10
    db $0d, $0d, $01, $10
    db $80

; C: OAM list 91 of the table 4000
OamList_B01_4000_91::
    db $17, $08, $77, $50
    db $10, $ff, $78, $10
    db $10, $0f, $78, $30
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $0d, $01, $10
    db $0d, $05, $00, $10
    db $80

; C: OAM list 92 of the table 4000
OamList_B01_4000_92::
    db $10, $fe, $78, $10
    db $10, $10, $78, $30
    db $18, $08, $77, $50
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $05, $00, $10
    db $0d, $0d, $01, $10
    db $80

; C: OAM list 93 of the table 4000
OamList_B01_4000_93::
    db $10, $fd, $78, $10
    db $1a, $08, $77, $50
    db $10, $11, $78, $30
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $05, $00, $10
    db $0d, $0d, $01, $10
    db $80

; C: OAM list 94 of the table 4000
OamList_B01_4000_94::
    db $10, $ff, $78, $10
    db $07, $08, $77, $10
    db $10, $0f, $78, $30
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $0d, $01, $10
    db $0d, $05, $00, $10
    db $80

; C: OAM list 95 of the table 4000
OamList_B01_4000_95::
    db $10, $fe, $78, $10
    db $06, $08, $77, $10
    db $10, $10, $78, $30
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $05, $00, $10
    db $0d, $0d, $01, $10
    db $80

; C: OAM list 96 of the table 4000
OamList_B01_4000_96::
    db $10, $fd, $78, $10
    db $10, $11, $78, $30
    db $05, $08, $77, $10
    db $15, $0d, $03, $10
    db $15, $05, $02, $10
    db $0d, $05, $00, $10
    db $0d, $0d, $01, $10
    db $80

; C: OAM list 97 of the table 4000
OamList_B01_4000_97::
    db $10, $f0, $5d, $10
    db $10, $e8, $5c, $10
    db $10, $d5, $5b, $00
    db $10, $cd, $5a, $00
    db $10, $c5, $59, $00
    db $fe, $c6, $6d, $00
    db $06, $c6, $6c, $00
    db $f6, $c8, $6f, $00
    db $f6, $d8, $71, $00
    db $f6, $d0, $70, $00
    db $06, $d6, $75, $00
    db $06, $ce, $74, $00
    db $fe, $d6, $73, $00
    db $fe, $ce, $72, $00
    db $80

; C: OAM list 98 of the table 4000
OamList_B01_4000_98::
    db $0d, $f0, $58, $00
    db $0d, $e8, $57, $00
    db $10, $18, $62, $00
    db $10, $10, $61, $00
    db $10, $08, $60, $00
    db $10, $00, $5f, $00
    db $10, $f8, $5e, $00
    db $fe, $f9, $7a, $20
    db $fe, $01, $79, $20
    db $fe, $09, $78, $20
    db $fe, $11, $77, $20
    db $fe, $19, $76, $20
    db $06, $f9, $7f, $20
    db $06, $01, $7e, $20
    db $06, $09, $7d, $20
    db $06, $11, $7c, $20
    db $06, $19, $7b, $20
    db $80

; C: OAM list 99 of the table 4000
OamList_B01_4000_99::
    db $0d, $f0, $58, $00
    db $0d, $e8, $57, $00
    db $10, $18, $62, $00
    db $10, $10, $61, $00
    db $10, $08, $60, $00
    db $10, $00, $5f, $00
    db $10, $f8, $5e, $00
    db $fe, $12, $6d, $20
    db $06, $12, $6c, $20
    db $f6, $00, $71, $20
    db $f6, $08, $70, $20
    db $f6, $10, $6f, $20
    db $fe, $02, $69, $20
    db $fe, $0a, $68, $20
    db $06, $02, $6b, $20
    db $06, $0a, $6a, $20
    db $80

; C: OAM list 9A of the table 4000
OamList_B01_4000_9A::
    db $0d, $f0, $58, $00
    db $0d, $e8, $57, $00
    db $10, $40, $67, $00
    db $10, $38, $66, $00
    db $10, $30, $65, $00
    db $10, $28, $64, $00
    db $10, $20, $63, $00
    db $fe, $47, $7a, $00
    db $fe, $3f, $79, $00
    db $fe, $37, $78, $00
    db $06, $47, $7f, $00
    db $06, $3f, $7e, $00
    db $06, $37, $7d, $00
    db $fe, $2f, $77, $00
    db $fe, $27, $76, $00
    db $06, $2f, $7c, $00
    db $06, $27, $7b, $00
    db $80

; C: OAM list 9B of the table 4000
OamList_B01_4000_9B::
    db $0d, $f0, $58, $00
    db $0d, $e8, $57, $00
    db $10, $40, $67, $00
    db $10, $38, $66, $00
    db $10, $30, $65, $00
    db $10, $28, $64, $00
    db $10, $20, $63, $00
    db $fe, $2b, $6d, $00
    db $06, $2b, $6c, $00
    db $f6, $3d, $71, $00
    db $f6, $35, $70, $00
    db $f6, $2d, $6f, $00
    db $fe, $3b, $69, $00
    db $fe, $33, $68, $00
    db $06, $3b, $6b, $00
    db $06, $33, $6a, $00
    db $80

; C: OAM list 9C of the table 4000
OamList_B01_4000_9C::
    db $10, $f0, $5d, $10
    db $10, $e8, $5c, $10
    db $10, $d5, $5b, $00
    db $10, $cd, $5a, $00
    db $10, $c5, $59, $00
    db $fe, $de, $7a, $00
    db $fe, $d6, $79, $00
    db $fe, $ce, $78, $00
    db $fe, $c6, $77, $00
    db $fe, $be, $76, $00
    db $06, $de, $7f, $00
    db $06, $d6, $7e, $00
    db $06, $ce, $7d, $00
    db $06, $c6, $7c, $00
    db $06, $be, $7b, $00
    db $80

; C: OAM list 9D of the table 4000
OamList_B01_4000_9D::
    db $18, $18, $09, $00
    db $18, $10, $08, $00
    db $18, $08, $07, $00
    db $10, $18, $06, $00
    db $10, $10, $05, $00
    db $10, $08, $04, $00
    db $80

; C: OAM list 9E of the table 4000
OamList_B01_4000_9E::
    db $18, $18, $0f, $00
    db $18, $10, $0e, $00
    db $18, $08, $0d, $00
    db $10, $18, $0c, $00
    db $10, $10, $0b, $00
    db $10, $08, $0a, $00
    db $80

; C: OAM list 9F of the table 4000
OamList_B01_4000_9F::
    db $10, $08, $77, $10
    db $10, $00, $76, $10
    db $08, $08, $67, $10
    db $08, $00, $66, $10
    db $80

; C: OAM list A0 of the table 4000
OamList_B01_4000_A0::
    db $10, $08, $79, $10
    db $10, $00, $78, $10
    db $08, $08, $69, $10
    db $08, $00, $68, $10
    db $80

; C: OAM list A1 of the table 4000
OamList_B01_4000_A1::
    db $10, $08, $7b, $10
    db $10, $00, $7a, $10
    db $08, $08, $6b, $10
    db $08, $00, $6a, $10
    db $80

; C: OAM list A2 of the table 4000
OamList_B01_4000_A2::
    db $08, $00, $7f, $10
    db $08, $08, $7f, $30
    db $80

; C: OAM list A3 of the table 4000
OamList_B01_4000_A3::
    db $10, $08, $7f, $70
    db $10, $00, $7f, $50
    db $80

; C: OAM list A4 of the table 4000
OamList_B01_4000_A4::
    db $08, $08, $7e, $50
    db $10, $08, $7e, $10
    db $80

; C: OAM list A5 of the table 4000
OamList_B01_4000_A5::
    db $08, $00, $7e, $70
    db $10, $00, $7e, $30
    db $80

; C: OAM list A6 of the table 4000
OamList_B01_4000_A6::
    db $20, $08, $7d, $10
    db $20, $00, $7c, $10
    db $18, $08, $6d, $10
    db $18, $00, $6c, $10
    db $80

; C: OAM list A7 of the table 4000
OamList_B01_4000_A7::
    db $22, $09, $7d, $10
    db $22, $01, $7c, $10
    db $1a, $09, $6d, $10
    db $1a, $01, $6c, $10
    db $80

; C: OAM list A8 of the table 4000
OamList_B01_4000_A8::
    db $19, $0c, $7d, $10
    db $19, $04, $7c, $10
    db $11, $0c, $6d, $10
    db $11, $04, $6c, $10
    db $80

; C: OAM list A9 of the table 4000
OamList_B01_4000_A9::
    db $17, $0a, $7d, $10
    db $17, $02, $7c, $10
    db $0f, $0a, $6d, $10
    db $0f, $02, $6c, $10
    db $80

; C: OAM list AA of the table 4000
OamList_B01_4000_AA::
    db $18, $0a, $7d, $10
    db $18, $02, $7c, $10
    db $10, $0a, $6d, $10
    db $10, $02, $6c, $10
    db $80

; C: OAM list AB of the table 4000
OamList_B01_4000_AB::
    db $f8, $08, $7d, $50
    db $f8, $00, $7c, $50
    db $00, $08, $6d, $50
    db $00, $00, $6c, $50
    db $80

; C: OAM list AC of the table 4000
OamList_B01_4000_AC::
    db $f6, $09, $7d, $50
    db $f6, $01, $7c, $50
    db $fe, $09, $6d, $50
    db $fe, $01, $6c, $50
    db $80

; C: OAM list AD of the table 4000
OamList_B01_4000_AD::
    db $ff, $0c, $7d, $50
    db $ff, $04, $7c, $50
    db $07, $0c, $6d, $50
    db $07, $04, $6c, $50
    db $80

; C: OAM list AE of the table 4000
OamList_B01_4000_AE::
    db $01, $0a, $7d, $50
    db $01, $02, $7c, $50
    db $09, $0a, $6d, $50
    db $09, $02, $6c, $50
    db $80

; C: OAM list AF of the table 4000
OamList_B01_4000_AF::
    db $00, $0a, $7d, $50
    db $00, $02, $7c, $50
    db $08, $0a, $6d, $50
    db $08, $02, $6c, $50
    db $80

; C: OAM list B0 of the table 4000
OamList_B01_4000_B0::
    db $15, $f9, $7d, $10
    db $15, $f1, $7c, $10
    db $0d, $f9, $6d, $10
    db $0d, $f1, $6c, $10
    db $80

; C: OAM list B1 of the table 4000
OamList_B01_4000_B1::
    db $16, $f8, $7d, $10
    db $16, $f0, $7c, $10
    db $0e, $f8, $6d, $10
    db $0e, $f0, $6c, $10
    db $80

; C: OAM list B2 of the table 4000
OamList_B01_4000_B2::
    db $18, $01, $7d, $10
    db $18, $f9, $7c, $10
    db $10, $01, $6d, $10
    db $10, $f9, $6c, $10
    db $80

; C: OAM list B3 of the table 4000
OamList_B01_4000_B3::
    db $15, $04, $7d, $10
    db $15, $fc, $7c, $10
    db $0d, $04, $6d, $10
    db $0d, $fc, $6c, $10
    db $80

; C: OAM list B4 of the table 4000
OamList_B01_4000_B4::
    db $15, $03, $7d, $10
    db $15, $fb, $7c, $10
    db $0d, $03, $6d, $10
    db $0d, $fb, $6c, $10
    db $80

; C: OAM list B5 of the table 4000
OamList_B01_4000_B5::
    db $04, $0f, $7d, $70
    db $04, $17, $7c, $70
    db $0c, $0f, $6d, $70
    db $0c, $17, $6c, $70
    db $80

; C: OAM list B6 of the table 4000
OamList_B01_4000_B6::
    db $03, $10, $7d, $70
    db $03, $18, $7c, $70
    db $0b, $10, $6d, $70
    db $0b, $18, $6c, $70
    db $80

; C: OAM list B7 of the table 4000
OamList_B01_4000_B7::
    db $00, $07, $7d, $70
    db $00, $0f, $7c, $70
    db $08, $07, $6d, $70
    db $08, $0f, $6c, $70
    db $80

; C: OAM list B8 of the table 4000
OamList_B01_4000_B8::
    db $03, $04, $7d, $70
    db $03, $0c, $7c, $70
    db $0b, $04, $6d, $70
    db $0b, $0c, $6c, $70
    db $80

; C: OAM list B9 of the table 4000
OamList_B01_4000_B9::
    db $03, $05, $7d, $70
    db $03, $0d, $7c, $70
    db $0b, $05, $6d, $70
    db $0b, $0d, $6c, $70
    db $80

; C: OAM list BA of the table 4000
OamList_B01_4000_BA::
    db $20, $18, $68, $10
    db $20, $10, $67, $10
    db $20, $08, $66, $10
    db $20, $00, $65, $10
    db $20, $f8, $64, $10
    db $18, $18, $63, $10
    db $18, $10, $62, $10
    db $18, $08, $61, $10
    db $18, $00, $60, $10
    db $18, $f8, $5f, $10
    db $10, $18, $5e, $10
    db $10, $10, $5d, $10
    db $10, $08, $5c, $10
    db $10, $00, $5b, $10
    db $10, $f8, $5a, $10
    db $08, $18, $59, $10
    db $08, $10, $58, $10
    db $08, $08, $57, $10
    db $08, $00, $56, $10
    db $08, $f8, $55, $10
    db $00, $18, $54, $10
    db $00, $10, $53, $10
    db $00, $08, $52, $10
    db $00, $00, $51, $10
    db $00, $f8, $50, $10
    db $80

; C: OAM list BB of the table 4000
OamList_B01_4000_BB::
    db $08, $00, $77, $70
    db $08, $08, $76, $70
    db $10, $00, $67, $70
    db $10, $08, $66, $70
    db $80

; C: OAM list BC of the table 4000
OamList_B01_4000_BC::
    db $08, $00, $79, $70
    db $08, $08, $78, $70
    db $10, $00, $69, $70
    db $10, $08, $68, $70
    db $80

; C: OAM list BD of the table 4000
OamList_B01_4000_BD::
    db $08, $00, $7b, $70
    db $08, $08, $7a, $70
    db $10, $00, $6b, $70
    db $10, $08, $6a, $70
    db $80

; C: OAM list BE of the table 4000
OamList_B01_4000_BE::
    db $10, $08, $73, $30
    db $08, $08, $63, $30
    db $10, $00, $73, $10
    db $08, $00, $63, $10
    db $80

; C: OAM list BF of the table 4000
OamList_B01_4000_BF::
    db $16, $08, $70, $30
    db $16, $00, $70, $10
    db $0d, $08, $75, $10
    db $0d, $00, $74, $10
    db $05, $08, $65, $10
    db $05, $00, $64, $10
    db $80

; C: OAM list C0 of the table 4000
OamList_B01_4000_C0::
    db $16, $08, $60, $30
    db $16, $00, $60, $10
    db $0d, $08, $76, $30
    db $05, $08, $66, $30
    db $0d, $00, $76, $10
    db $05, $00, $66, $10
    db $80

; C: OAM list C1 of the table 4000
OamList_B01_4000_C1::
    db $16, $08, $60, $30
    db $16, $00, $60, $10
    db $0c, $08, $76, $30
    db $05, $08, $66, $30
    db $0c, $00, $76, $10
    db $05, $00, $66, $10
    db $80

; C: OAM list C2 of the table 4000
OamList_B01_4000_C2::
    db $16, $08, $70, $30
    db $16, $00, $70, $10
    db $0e, $00, $75, $30
    db $0e, $08, $74, $30
    db $06, $00, $65, $30
    db $06, $08, $64, $30
    db $80

; C: OAM list C3 of the table 4000
OamList_B01_4000_C3::
    db $10, $08, $77, $30
    db $08, $08, $67, $30
    db $10, $00, $77, $10
    db $08, $00, $67, $10
    db $80

; C: OAM list C4 of the table 4000
OamList_B01_4000_C4::
    db $08, $08, $61, $30
    db $08, $00, $61, $10
    db $10, $08, $73, $30
    db $10, $00, $73, $10
    db $80

; C: OAM list C5 of the table 4000
OamList_B01_4000_C5::
    db $08, $08, $62, $30
    db $08, $00, $62, $10
    db $10, $08, $73, $30
    db $10, $00, $73, $10
    db $80

; C: OAM list C6 of the table 4000
OamList_B01_4000_C6::
    db $10, $08, $72, $30
    db $10, $00, $72, $10
    db $08, $08, $63, $30
    db $08, $00, $63, $10
    db $80

; C: OAM list C7 of the table 4000
OamList_B01_4000_C7::
    db $10, $08, $71, $30
    db $10, $00, $71, $10
    db $08, $08, $63, $30
    db $08, $00, $63, $10
    db $80

; C: OAM list C8 of the table 4000
OamList_B01_4000_C8::
    db $10, $08, $71, $30
    db $10, $00, $71, $10
    db $08, $08, $61, $30
    db $08, $00, $61, $10
    db $80

; C: OAM list C9 of the table 4000
OamList_B01_4000_C9::
    db $08, $08, $62, $30
    db $08, $00, $62, $10
    db $10, $08, $72, $30
    db $10, $00, $72, $10
    db $80

; C: OAM list CA of the table 4000
OamList_B01_4000_CA::
    db $13, $09, $d4, $10
    db $13, $01, $d3, $10
    db $0a, $09, $f1, $10
    db $0a, $01, $f0, $10
    db $02, $09, $e0, $10
    db $80

; C: OAM list CB of the table 4000
OamList_B01_4000_CB::
    db $13, $09, $d4, $10
    db $13, $01, $d3, $10
    db $02, $09, $f3, $50
    db $02, $01, $f2, $50
    db $0a, $09, $f3, $10
    db $0a, $01, $f2, $10
    db $80

; C: OAM list CC of the table 4000
OamList_B01_4000_CC::
    db $02, $01, $cf, $10
    db $13, $09, $d6, $10
    db $13, $01, $d5, $10
    db $0a, $09, $d2, $10
    db $0a, $01, $d1, $10
    db $02, $09, $d0, $10
    db $80

; C: OAM list CD of the table 4000
OamList_B01_4000_CD::
    db $13, $09, $df, $10
    db $13, $01, $de, $10
    db $0a, $01, $e2, $70
    db $0a, $09, $e1, $70
    db $02, $09, $e2, $10
    db $02, $01, $e1, $10
    db $80

; C: OAM list CE of the table 4000
OamList_B01_4000_CE::
    db $13, $fc, $d7, $10
    db $13, $0c, $d9, $10
    db $13, $04, $d8, $10
    db $80

; C: OAM list CF of the table 4000
OamList_B01_4000_CF::
    db $1d, $08, $5b, $10
    db $1d, $00, $5a, $10
    db $f7, $08, $59, $10
    db $f7, $00, $58, $10
    db $80

; C: OAM list D0 of the table 4000
OamList_B01_4000_D0::
    db $1e, $08, $5b, $10
    db $1e, $00, $5a, $10
    db $f7, $08, $59, $10
    db $f7, $00, $58, $10
    db $80

; C: OAM list D1 of the table 4000
OamList_B01_4000_D1::
    db $1d, $08, $5b, $10
    db $1d, $00, $5a, $10
    db $f6, $08, $59, $10
    db $f6, $00, $58, $10
    db $80

; C: OAM list D2 of the table 4000
OamList_B01_4000_D2::
    db $18, $10, $7d, $00
    db $18, $08, $7c, $00
    db $10, $10, $6d, $00
    db $10, $08, $6c, $00
    db $80

; C: OAM list D3 of the table 4000
OamList_B01_4000_D3::
    db $18, $10, $6f, $00
    db $18, $08, $6e, $00
    db $10, $10, $5f, $00
    db $10, $08, $5e, $00
    db $80

; C: OAM list D4 of the table 4000
OamList_B01_4000_D4::
    db $08, $08, $57, $00
    db $08, $00, $56, $00
    db $08, $f8, $55, $00
    db $08, $f0, $54, $00
    db $80

; C: OAM list D5 of the table 4000
OamList_B01_4000_D5::
    db $08, $08, $7e, $50
    db $10, $08, $7e, $10
    db $80

; C: OAM list D6 of the table 4000
OamList_B01_4000_D6::
    db $08, $00, $7e, $70
    db $10, $00, $7e, $30
    db $80

; C: OAM list D7 of the table 4000
OamList_B01_4000_D7::
    db $28, $10, $1d, $00
    db $28, $08, $1e, $00
    db $20, $08, $21, $00
    db $18, $30, $29, $00
    db $18, $28, $2a, $00
    db $18, $20, $2b, $00
    db $18, $18, $2c, $00
    db $18, $10, $2d, $00
    db $18, $08, $2e, $00
    db $10, $30, $37, $00
    db $10, $28, $38, $00
    db $10, $20, $39, $00
    db $10, $18, $3a, $00
    db $10, $10, $3b, $00
    db $08, $28, $43, $00
    db $08, $20, $44, $00
    db $08, $18, $45, $00
    db $08, $10, $46, $00
    db $08, $08, $47, $00
    db $00, $28, $4d, $00
    db $00, $20, $4e, $00
    db $00, $18, $4f, $00
    db $00, $10, $50, $00
    db $f8, $28, $56, $00
    db $f8, $20, $57, $00
    db $80

; C: OAM list D8 of the table 4000
OamList_B01_4000_D8::
    db $28, $10, $1b, $00
    db $28, $08, $1c, $00
    db $20, $08, $20, $00
    db $18, $10, $27, $00
    db $18, $08, $28, $00
    db $10, $10, $35, $00
    db $10, $08, $36, $00
    db $08, $10, $41, $00
    db $08, $08, $42, $00
    db $00, $10, $4c, $00
    db $18, $30, $23, $00
    db $18, $28, $24, $00
    db $18, $20, $25, $00
    db $18, $18, $26, $00
    db $10, $30, $31, $00
    db $10, $28, $32, $00
    db $10, $20, $33, $00
    db $10, $18, $34, $00
    db $08, $28, $3e, $00
    db $08, $20, $3f, $00
    db $08, $18, $40, $00
    db $00, $28, $49, $00
    db $00, $20, $4a, $00
    db $00, $18, $4b, $00
    db $f8, $28, $54, $00
    db $f8, $20, $55, $00
    db $80

; C: OAM list D9 of the table 4000
OamList_B01_4000_D9::
    db $28, $10, $00, $00
    db $28, $08, $01, $00
    db $20, $28, $02, $00
    db $20, $20, $03, $00
    db $20, $10, $04, $00
    db $20, $08, $05, $00
    db $18, $28, $06, $00
    db $18, $20, $07, $00
    db $18, $18, $08, $00
    db $18, $10, $09, $00
    db $18, $08, $0a, $00
    db $10, $28, $0b, $00
    db $10, $20, $0c, $00
    db $10, $18, $0d, $00
    db $10, $10, $0e, $00
    db $10, $08, $0f, $00
    db $08, $20, $10, $00
    db $08, $18, $11, $00
    db $08, $10, $12, $00
    db $08, $08, $13, $00
    db $00, $28, $14, $00
    db $00, $20, $15, $00
    db $00, $18, $16, $00
    db $00, $10, $17, $00
    db $00, $08, $18, $00
    db $f8, $28, $42, $20
    db $f8, $20, $19, $00
    db $f8, $18, $1a, $00
    db $80

; C: OAM list DA of the table 4000
OamList_B01_4000_DA::
    db $f4, $20, $53, $00
    db $1a, $2f, $51, $00
    db $22, $27, $48, $00
    db $1a, $27, $52, $00
    db $08, $31, $53, $00
    db $28, $10, $1d, $00
    db $28, $08, $1e, $00
    db $20, $08, $21, $00
    db $18, $30, $29, $00
    db $18, $28, $2a, $00
    db $18, $20, $2b, $00
    db $18, $18, $2c, $00
    db $18, $10, $2d, $00
    db $18, $08, $2e, $00
    db $10, $30, $37, $00
    db $10, $28, $38, $00
    db $10, $20, $39, $00
    db $10, $18, $3a, $00
    db $10, $10, $3b, $00
    db $08, $28, $43, $00
    db $08, $20, $44, $00
    db $08, $18, $45, $00
    db $08, $10, $46, $00
    db $08, $08, $47, $00
    db $00, $28, $4d, $00
    db $00, $20, $4e, $00
    db $00, $18, $4f, $00
    db $00, $10, $50, $00
    db $f8, $28, $56, $00
    db $f8, $20, $57, $00
    db $80

; C: OAM list DB of the table 4000
OamList_B01_4000_DB::
    db $2c, $30, $48, $00
    db $24, $38, $51, $00
    db $24, $30, $52, $00
    db $1a, $3d, $53, $00
    db $ee, $39, $2f, $00
    db $ee, $31, $30, $00
    db $e6, $39, $3c, $00
    db $e6, $31, $3d, $00
    db $03, $3b, $53, $00
    db $f8, $30, $53, $00
    db $28, $10, $1b, $00
    db $28, $08, $1c, $00
    db $20, $08, $20, $00
    db $18, $10, $27, $00
    db $18, $08, $28, $00
    db $10, $10, $35, $00
    db $10, $08, $36, $00
    db $08, $10, $41, $00
    db $08, $08, $42, $00
    db $00, $10, $4c, $00
    db $18, $30, $23, $00
    db $18, $28, $24, $00
    db $18, $20, $25, $00
    db $18, $18, $26, $00
    db $10, $30, $31, $00
    db $10, $28, $32, $00
    db $10, $20, $33, $00
    db $10, $18, $34, $00
    db $08, $28, $3e, $00
    db $08, $20, $3f, $00
    db $08, $18, $40, $00
    db $00, $28, $49, $00
    db $00, $20, $4a, $00
    db $00, $18, $4b, $00
    db $f8, $28, $54, $00
    db $f8, $20, $55, $00
    db $80

; C: OAM list DC of the table 4000
OamList_B01_4000_DC::
    db $18, $08, $ca, $00
    db $10, $08, $c9, $00
    db $80

; C: OAM list DD of the table 4000
OamList_B01_4000_DD::
    db $10, $10, $c8, $10
    db $10, $08, $c7, $10
    db $10, $00, $c6, $10
    db $08, $10, $c5, $10
    db $08, $08, $c4, $10
    db $08, $00, $c3, $10
    db $80

; C: OAM list DE of the table 4000
OamList_B01_4000_DE::
    db $10, $f8, $c8, $30
    db $10, $00, $c7, $30
    db $10, $08, $c6, $30
    db $08, $f8, $c5, $30
    db $08, $00, $c4, $30
    db $08, $08, $c3, $30
    db $80

; C: OAM list DF of the table 4000
OamList_B01_4000_DF::
    db $17, $08, $df, $40
    db $10, $08, $df, $00
    db $80

; C: OAM list E0 of the table 4000
OamList_B01_4000_E0::
    db $16, $0b, $b8, $10
    db $1b, $10, $b9, $10
    db $10, $10, $b7, $10
    db $80

; C: OAM list E1 of the table 4000
OamList_B01_4000_E1::
    db $14, $02, $b8, $10
    db $1b, $0b, $b9, $10
    db $0d, $0d, $b7, $10
    db $80

; C: OAM list E2 of the table 4000
OamList_B01_4000_E2::
    db $15, $fd, $b8, $10
    db $0b, $04, $b7, $10
    db $1c, $05, $b9, $10
    db $80

; C: OAM list E3 of the table 4000
OamList_B01_4000_E3::
    db $18, $30, $1b, $00
    db $18, $28, $1a, $00
    db $18, $20, $19, $00
    db $18, $18, $18, $00
    db $18, $10, $17, $00
    db $18, $08, $16, $00
    db $10, $30, $0b, $00
    db $10, $28, $0a, $00
    db $10, $20, $09, $00
    db $10, $18, $08, $00
    db $10, $10, $07, $00
    db $10, $08, $06, $00
    db $80

; C: OAM list E4 of the table 4000
OamList_B01_4000_E4::
    db $18, $30, $15, $10
    db $18, $28, $14, $10
    db $18, $20, $13, $10
    db $18, $18, $12, $10
    db $18, $10, $11, $10
    db $18, $08, $10, $10
    db $10, $30, $05, $10
    db $10, $28, $04, $10
    db $10, $20, $03, $10
    db $10, $18, $02, $10
    db $10, $10, $01, $10
    db $10, $08, $00, $10
    db $80

; C: OAM list E5 of the table 4000
OamList_B01_4000_E5::
    db $18, $40, $33, $00
    db $18, $38, $32, $00
    db $18, $30, $31, $00
    db $18, $28, $30, $00
    db $10, $40, $23, $00
    db $10, $38, $22, $00
    db $10, $30, $21, $00
    db $10, $28, $20, $00
    db $18, $20, $1f, $00
    db $18, $18, $1e, $00
    db $18, $10, $1d, $00
    db $18, $08, $1c, $00
    db $10, $20, $0f, $00
    db $10, $18, $0e, $00
    db $10, $10, $0d, $00
    db $10, $08, $0c, $00
    db $80

; C: OAM list E6 of the table 4000
OamList_B01_4000_E6::
    db $18, $40, $3b, $10
    db $18, $38, $3a, $10
    db $18, $30, $39, $10
    db $18, $28, $38, $10
    db $18, $20, $37, $10
    db $18, $18, $36, $10
    db $18, $10, $35, $10
    db $18, $08, $34, $10
    db $10, $40, $2b, $10
    db $10, $38, $2a, $10
    db $10, $30, $29, $10
    db $10, $28, $28, $10
    db $10, $20, $27, $10
    db $10, $18, $26, $10
    db $10, $10, $25, $10
    db $10, $08, $24, $10
    db $80

; C: OAM list E7 of the table 4000
OamList_B01_4000_E7::
    db $10, $20, $43, $10
    db $10, $18, $42, $10
    db $10, $10, $41, $10
    db $10, $08, $40, $10
    db $80

; C: OAM list E8 of the table 4000
OamList_B01_4000_E8::
    db $10, $08, $44, $10
    db $80

; C: OAM list E9 of the table 4000
OamList_B01_4000_E9::
    db $10, $08, $45, $10
    db $80

; C: OAM list EA of the table 4000
OamList_B01_4000_EA::
    db $10, $08, $46, $10
    db $80

; C: OAM list EB of the table 4000
OamList_B01_4000_EB::
    db $0a, $40, $67, $10
    db $0a, $38, $66, $10
    db $0a, $30, $65, $10
    db $0a, $28, $64, $10
    db $0a, $20, $63, $10
    db $12, $38, $6a, $10
    db $12, $30, $69, $10
    db $12, $28, $68, $10
    db $02, $38, $62, $10
    db $02, $30, $61, $10
    db $02, $28, $60, $10
    db $10, $08, $7f, $10
    db $08, $00, $6f, $10
    db $18, $00, $7c, $30
    db $10, $00, $6c, $30
    db $18, $f8, $7e, $10
    db $10, $f8, $6e, $10
    db $80

; C: OAM list EC of the table 4000
OamList_B01_4000_EC::
    db $14, $08, $7b, $30
    db $0c, $08, $6b, $30
    db $14, $00, $7b, $10
    db $0c, $00, $6b, $10
    db $80

; C: OAM list ED of the table 4000
OamList_B01_4000_ED::
    db $12, $e0, $78, $10
    db $12, $d8, $77, $10
    db $12, $d0, $76, $10
    db $0a, $e0, $75, $10
    db $0a, $d8, $74, $10
    db $0a, $d0, $73, $10
    db $02, $e0, $72, $10
    db $02, $d8, $71, $10
    db $02, $d0, $70, $10
    db $10, $00, $7f, $30
    db $08, $08, $6f, $30
    db $18, $10, $7d, $10
    db $18, $08, $7c, $10
    db $10, $10, $6d, $10
    db $10, $08, $6c, $10
    db $80

; C: OAM list EE of the table 4000
OamList_B01_4000_EE::
    db $18, $10, $df, $10
    db $18, $08, $de, $10
    db $10, $10, $cf, $10
    db $10, $08, $ce, $10
    db $80

; C: OAM list EF of the table 4000
OamList_B01_4000_EF::
    db $46, $2b, $df, $10
    db $46, $23, $de, $10
    db $3e, $2b, $cf, $10
    db $3e, $23, $ce, $10
    db $80

; C: OAM list F0 of the table 4000
OamList_B01_4000_F0::
    db $1f, $10, $e1, $80
    db $1f, $08, $e0, $80
    db $17, $10, $e1, $80
    db $17, $08, $e0, $80
    db $0f, $10, $e1, $80
    db $0f, $08, $e0, $80
    db $80

; C: OAM list F1 of the table 4000
OamList_B01_4000_F1::
    db $1f, $10, $e3, $80
    db $1f, $08, $e2, $80
    db $17, $10, $e3, $80
    db $17, $08, $e2, $80
    db $0f, $10, $e3, $80
    db $0f, $08, $e2, $80
    db $80

; C: OAM list F2 of the table 4000
OamList_B01_4000_F2::
    db $f8, $4a, $27, $10
    db $f8, $42, $26, $10
    db $f8, $3a, $25, $10
    db $f8, $32, $24, $10
    db $f8, $2a, $23, $10
    db $f8, $22, $22, $10
    db $f8, $1a, $21, $10
    db $f8, $12, $20, $10
    db $28, $30, $3b, $10
    db $28, $28, $3a, $10
    db $28, $20, $39, $10
    db $28, $18, $38, $10
    db $20, $30, $37, $10
    db $20, $28, $36, $10
    db $20, $20, $35, $10
    db $20, $18, $34, $10
    db $18, $30, $33, $10
    db $18, $28, $32, $10
    db $18, $20, $31, $10
    db $18, $18, $30, $10
    db $f0, $4a, $17, $10
    db $f0, $42, $16, $10
    db $f0, $3a, $15, $10
    db $f0, $32, $14, $10
    db $f0, $2a, $13, $10
    db $f0, $22, $12, $10
    db $f0, $1a, $11, $10
    db $f0, $12, $10, $10
    db $e8, $4a, $07, $10
    db $e8, $42, $06, $10
    db $e8, $3a, $05, $10
    db $e8, $32, $04, $10
    db $e8, $2a, $03, $10
    db $e8, $22, $02, $10
    db $e8, $1a, $01, $10
    db $e8, $12, $00, $10
    db $80

; C: OAM list F3 of the table 4000
OamList_B01_4000_F3::
    db $2d, $d0, $45, $10
    db $2e, $c8, $44, $10
    db $2f, $c0, $43, $10
    db $21, $d0, $42, $10
    db $21, $c8, $41, $10
    db $21, $c0, $40, $10
    db $13, $d0, $3e, $10
    db $11, $c8, $3d, $10
    db $10, $c0, $3c, $10
    db $60, $ce, $2a, $10
    db $60, $c6, $29, $10
    db $60, $be, $28, $10
    db $60, $f6, $2f, $10
    db $60, $e6, $2d, $10
    db $60, $ee, $2e, $10
    db $60, $de, $2c, $10
    db $60, $d6, $2b, $10
    db $50, $f6, $0f, $10
    db $58, $f6, $1f, $10
    db $58, $ee, $1e, $10
    db $58, $e6, $1d, $10
    db $58, $de, $1c, $10
    db $58, $d6, $1b, $10
    db $58, $ce, $1a, $10
    db $58, $c6, $19, $10
    db $58, $be, $18, $10
    db $50, $ee, $0e, $10
    db $50, $e6, $0d, $10
    db $50, $de, $0c, $10
    db $50, $d6, $0b, $10
    db $50, $ce, $0a, $10
    db $50, $c6, $09, $10
    db $50, $be, $08, $10
    db $80

; C: OAM list F4 of the table 4000
OamList_B01_4000_F4::
    db $10, $0c, $3f, $50
    db $08, $0c, $3f, $10
    db $80

; C: OAM list F5 of the table 4000
OamList_B01_4000_F5::
    db $10, $04, $3f, $70
    db $08, $04, $3f, $30
    db $80

; C: OAM list F6 of the table 4000
OamList_B01_4000_F6::
    db $10, $08, $f8, $00
    db $80

; C: OAM list F7 of the table 4000
OamList_B01_4000_F7::
    db $18, $08, $ad, $00
    db $10, $08, $ac, $00
    db $80

; C: OAM list F8 of the table 4000
OamList_B01_4000_F8::
    db $13, $08, $ae, $00
    db $80

; C: 246 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B01_5D47 (00:2496)
OamPtrTbl_B01_5D47::
    dw OamList_B01_5D47_00
    dw OamList_B01_5D47_01
    dw OamList_B01_5D47_02
    dw OamList_B01_5D47_03
    dw OamList_B01_5D47_04
    dw OamList_B01_5D47_05
    dw OamList_B01_5D47_06
    dw OamList_B01_5D47_07
    dw OamList_B01_5D47_08
    dw OamList_B01_5D47_09
    dw OamList_B01_5D47_0A
    dw OamList_B01_5D47_0B
    dw OamList_B01_5D47_0C
    dw OamList_B01_5D47_0D
    dw OamList_B01_5D47_0E
    dw OamList_B01_5D47_0F
    dw OamList_B01_5D47_10
    dw OamList_B01_5D47_11
    dw OamList_B01_5D47_12
    dw OamList_B01_5D47_13
    dw OamList_B01_5D47_14
    dw OamList_B01_5D47_15
    dw OamList_B01_5D47_16
    dw OamList_B01_5D47_17
    dw OamList_B01_5D47_18
    dw OamList_B01_5D47_19
    dw OamList_B01_5D47_1A
    dw OamList_B01_5D47_1B
    dw OamList_B01_5D47_1C
    dw OamList_B01_5D47_1D
    dw OamList_B01_5D47_1E
    dw OamList_B01_5D47_1F
    dw OamList_B01_5D47_20
    dw OamList_B01_5D47_21
    dw OamList_B01_5D47_22
    dw OamList_B01_5D47_23
    dw OamList_B01_5D47_24
    dw OamList_B01_5D47_25
    dw OamList_B01_5D47_26
    dw OamList_B01_5D47_27
    dw OamList_B01_5D47_28
    dw OamList_B01_5D47_29
    dw OamList_B01_5D47_2A
    dw OamList_B01_5D47_2B
    dw OamList_B01_5D47_2C
    dw OamList_B01_5D47_2D
    dw OamList_B01_5D47_2E
    dw OamList_B01_5D47_2F
    dw OamList_B01_5D47_30
    dw OamList_B01_5D47_31
    dw OamList_B01_5D47_32
    dw OamList_B01_5D47_33
    dw OamList_B01_5D47_34
    dw OamList_B01_5D47_35
    dw OamList_B01_5D47_36
    dw OamList_B01_5D47_37
    dw OamList_B01_5D47_38
    dw OamList_B01_5D47_39
    dw OamList_B01_5D47_3A
    dw OamList_B01_5D47_3B
    dw OamList_B01_5D47_3C
    dw OamList_B01_5D47_3D
    dw OamList_B01_5D47_3E
    dw OamList_B01_5D47_3F
    dw OamList_B01_5D47_40
    dw OamList_B01_5D47_41
    dw OamList_B01_5D47_42
    dw OamList_B01_5D47_43
    dw OamList_B01_5D47_44
    dw OamList_B01_5D47_45
    dw OamList_B01_5D47_46
    dw OamList_B01_5D47_47
    dw OamList_B01_5D47_48
    dw OamList_B01_5D47_49
    dw OamList_B01_5D47_4A
    dw OamList_B01_5D47_4B
    dw OamList_B01_5D47_4C
    dw OamList_B01_5D47_4D
    dw OamList_B01_5D47_4E
    dw OamList_B01_5D47_4F
    dw OamList_B01_5D47_50
    dw OamList_B01_5D47_51
    dw OamList_B01_5D47_52
    dw OamList_B01_5D47_53
    dw OamList_B01_5D47_54
    dw OamList_B01_5D47_55
    dw OamList_B01_5D47_56
    dw OamList_B01_5D47_57
    dw OamList_B01_5D47_58
    dw OamList_B01_5D47_59
    dw OamList_B01_5D47_5A
    dw OamList_B01_5D47_5B
    dw OamList_B01_5D47_5C
    dw OamList_B01_5D47_5D
    dw OamList_B01_5D47_5E
    dw OamList_B01_5D47_5F
    dw OamList_B01_5D47_60
    dw OamList_B01_5D47_61
    dw OamList_B01_5D47_62
    dw OamList_B01_5D47_63
    dw OamList_B01_5D47_64
    dw OamList_B01_5D47_65
    dw OamList_B01_5D47_66
    dw OamList_B01_5D47_67
    dw OamList_B01_5D47_68
    dw OamList_B01_5D47_69
    dw OamList_B01_5D47_6A
    dw OamList_B01_5D47_6B
    dw OamList_B01_5D47_6C
    dw OamList_B01_5D47_6D
    dw OamList_B01_5D47_6E
    dw OamList_B01_5D47_6F
    dw OamList_B01_5D47_70
    dw OamList_B01_5D47_71
    dw OamList_B01_5D47_72
    dw OamList_B01_5D47_73
    dw OamList_B01_5D47_74
    dw OamList_B01_5D47_75
    dw OamList_B01_5D47_76
    dw OamList_B01_5D47_77
    dw OamList_B01_5D47_78
    dw OamList_B01_5D47_79
    dw OamList_B01_5D47_7A
    dw OamList_B01_5D47_7B
    dw OamList_B01_5D47_7C
    dw OamList_B01_5D47_7D
    dw OamList_B01_5D47_7E
    dw OamList_B01_5D47_7F
    dw OamList_B01_5D47_80
    dw OamList_B01_5D47_81
    dw OamList_B01_5D47_82
    dw OamList_B01_5D47_83
    dw OamList_B01_5D47_84
    dw OamList_B01_5D47_85
    dw OamList_B01_5D47_86
    dw OamList_B01_5D47_87
    dw OamList_B01_5D47_88
    dw OamList_B01_5D47_89
    dw OamList_B01_5D47_8A
    dw OamList_B01_5D47_8B
    dw OamList_B01_5D47_8C
    dw OamList_B01_5D47_8D
    dw OamList_B01_5D47_8E
    dw OamList_B01_5D47_8F
    dw OamList_B01_5D47_90
    dw OamList_B01_5D47_91
    dw OamList_B01_5D47_92
    dw OamList_B01_5D47_93
    dw OamList_B01_5D47_94
    dw OamList_B01_5D47_95
    dw OamList_B01_5D47_96
    dw OamList_B01_5D47_97
    dw OamList_B01_5D47_98
    dw OamList_B01_5D47_99
    dw OamList_B01_5D47_9A
    dw OamList_B01_5D47_9B
    dw OamList_B01_5D47_9C
    dw OamList_B01_5D47_9D
    dw OamList_B01_5D47_9E
    dw OamList_B01_5D47_9F
    dw OamList_B01_5D47_A0
    dw OamList_B01_5D47_A1
    dw OamList_B01_5D47_A2
    dw OamList_B01_5D47_A3
    dw OamList_B01_5D47_A4
    dw OamList_B01_5D47_A5
    dw OamList_B01_5D47_A6
    dw OamList_B01_5D47_A7
    dw OamList_B01_5D47_A8
    dw OamList_B01_5D47_A9
    dw OamList_B01_5D47_AA
    dw OamList_B01_5D47_AB
    dw OamList_B01_5D47_AC
    dw OamList_B01_5D47_AD
    dw OamList_B01_5D47_AE
    dw OamList_B01_5D47_AF
    dw OamList_B01_5D47_B0
    dw OamList_B01_5D47_B1
    dw OamList_B01_5D47_B2
    dw OamList_B01_5D47_B3
    dw OamList_B01_5D47_B4
    dw OamList_B01_5D47_B5
    dw OamList_B01_5D47_B6
    dw OamList_B01_5D47_B7
    dw OamList_B01_5D47_B8
    dw OamList_B01_5D47_B9
    dw OamList_B01_5D47_BA
    dw OamList_B01_5D47_BB
    dw OamList_B01_5D47_BC
    dw OamList_B01_5D47_BD
    dw OamList_B01_5D47_BE
    dw OamList_B01_5D47_BF
    dw OamList_B01_5D47_C0
    dw OamList_B01_5D47_C1
    dw OamList_B01_5D47_C2
    dw OamList_B01_5D47_C3
    dw OamList_B01_5D47_C4
    dw OamList_B01_5D47_C5
    dw OamList_B01_5D47_C6
    dw OamList_B01_5D47_C7
    dw OamList_B01_5D47_C8
    dw OamList_B01_5D47_C9
    dw OamList_B01_5D47_CA
    dw OamList_B01_5D47_CB
    dw OamList_B01_5D47_CC
    dw OamList_B01_5D47_CD
    dw OamList_B01_5D47_CE
    dw OamList_B01_5D47_CF
    dw OamList_B01_5D47_D0
    dw OamList_B01_5D47_D1
    dw OamList_B01_5D47_D2
    dw OamList_B01_5D47_D3
    dw OamList_B01_5D47_D4
    dw OamList_B01_5D47_D5
    dw OamList_B01_5D47_D6
    dw OamList_B01_5D47_D7
    dw OamList_B01_5D47_D8
    dw OamList_B01_5D47_D9
    dw OamList_B01_5D47_DA
    dw OamList_B01_5D47_DB
    dw OamList_B01_5D47_DC
    dw OamList_B01_5D47_DD
    dw OamList_B01_5D47_DE
    dw OamList_B01_5D47_DF
    dw OamList_B01_5D47_E0
    dw OamList_B01_5D47_E1
    dw OamList_B01_5D47_E2
    dw OamList_B01_5D47_E3
    dw OamList_B01_5D47_E4
    dw OamList_B01_5D47_E5
    dw OamList_B01_5D47_E6
    dw OamList_B01_5D47_E7
    dw OamList_B01_5D47_E8
    dw OamList_B01_5D47_E9
    dw OamList_B01_5D47_EA
    dw OamList_B01_5D47_EB
    dw OamList_B01_5D47_EC
    dw OamList_B01_5D47_ED
    dw OamList_B01_5D47_EE
    dw OamList_B01_5D47_EF
    dw OamList_B01_5D47_F0
    dw OamList_B01_5D47_F1
    dw OamList_B01_5D47_F2
    dw OamList_B01_5D47_F3
    dw OamList_B01_5D47_F4
    dw OamList_B01_5D47_F5

; C: OAM list 00 of the table 5D47
OamList_B01_5D47_00::
    db $20, $10, $71, $10
    db $20, $08, $70, $10
    db $18, $10, $61, $10
    db $18, $08, $60, $10
    db $10, $10, $51, $10
    db $10, $08, $50, $10
    db $80

; C: OAM list 01 of the table 5D47
OamList_B01_5D47_01::
    db $20, $10, $73, $10
    db $20, $08, $72, $10
    db $18, $10, $63, $10
    db $18, $08, $62, $10
    db $10, $10, $53, $10
    db $10, $08, $52, $10
    db $80

; C: OAM list 02 of the table 5D47
OamList_B01_5D47_02::
    db $20, $10, $75, $10
    db $20, $08, $74, $10
    db $18, $10, $65, $10
    db $18, $08, $64, $10
    db $10, $10, $55, $10
    db $10, $08, $54, $10
    db $80

; C: OAM list 03 of the table 5D47
OamList_B01_5D47_03::
    db $20, $10, $77, $10
    db $20, $08, $76, $10
    db $18, $10, $67, $10
    db $18, $08, $66, $10
    db $10, $10, $57, $10
    db $10, $08, $56, $10
    db $80

; C: OAM list 04 of the table 5D47
OamList_B01_5D47_04::
    db $20, $10, $79, $10
    db $20, $08, $78, $10
    db $18, $10, $69, $10
    db $18, $08, $68, $10
    db $10, $10, $59, $10
    db $10, $08, $58, $10
    db $80

; C: OAM list 05 of the table 5D47
OamList_B01_5D47_05::
    db $20, $10, $7b, $10
    db $20, $08, $7a, $10
    db $18, $10, $6b, $10
    db $18, $08, $6a, $10
    db $10, $10, $5b, $10
    db $10, $08, $5a, $10
    db $80

; C: OAM list 06 of the table 5D47
OamList_B01_5D47_06::
    db $20, $08, $79, $30
    db $20, $10, $78, $30
    db $18, $08, $69, $30
    db $18, $10, $68, $30
    db $10, $08, $59, $30
    db $10, $10, $58, $30
    db $80

; C: OAM list 07 of the table 5D47
OamList_B01_5D47_07::
    db $20, $08, $77, $30
    db $20, $10, $76, $30
    db $18, $08, $67, $30
    db $18, $10, $66, $30
    db $10, $08, $57, $30
    db $10, $10, $56, $30
    db $80

; C: OAM list 08 of the table 5D47
OamList_B01_5D47_08::
    db $20, $08, $75, $30
    db $20, $10, $74, $30
    db $18, $08, $65, $30
    db $18, $10, $64, $30
    db $10, $08, $55, $30
    db $10, $10, $54, $30
    db $80

; C: OAM list 09 of the table 5D47
OamList_B01_5D47_09::
    db $20, $08, $73, $30
    db $20, $10, $72, $30
    db $18, $08, $63, $30
    db $18, $10, $62, $30
    db $10, $08, $53, $30
    db $10, $10, $52, $30
    db $80

; C: OAM list 0A of the table 5D47
OamList_B01_5D47_0A::
    db $20, $08, $71, $30
    db $20, $10, $70, $30
    db $18, $08, $61, $30
    db $18, $10, $60, $30
    db $10, $08, $51, $30
    db $10, $10, $50, $30
    db $80

; C: OAM list 0B of the table 5D47
OamList_B01_5D47_0B::
    db $10, $08, $01, $30
    db $10, $10, $00, $30
    db $20, $08, $19, $30
    db $20, $10, $18, $30
    db $18, $08, $09, $30
    db $18, $10, $08, $30
    db $80

; C: OAM list 0C of the table 5D47
OamList_B01_5D47_0C::
    db $20, $08, $1b, $30
    db $20, $10, $1a, $30
    db $18, $08, $0b, $30
    db $18, $10, $0a, $30
    db $10, $08, $fb, $30
    db $10, $10, $fa, $30
    db $80

; C: OAM list 0D of the table 5D47
OamList_B01_5D47_0D::
    db $20, $08, $1d, $30
    db $20, $10, $1c, $30
    db $18, $08, $0d, $30
    db $18, $10, $0c, $30
    db $10, $08, $fd, $30
    db $10, $10, $fc, $30
    db $80

; C: OAM list 0E of the table 5D47
OamList_B01_5D47_0E::
    db $20, $08, $1f, $30
    db $20, $10, $1e, $30
    db $18, $08, $0f, $30
    db $18, $10, $0e, $30
    db $10, $08, $ff, $30
    db $10, $10, $fe, $30
    db $80

; C: OAM list 0F of the table 5D47
OamList_B01_5D47_0F::
    db $20, $10, $1f, $10
    db $20, $08, $1e, $10
    db $18, $10, $0f, $10
    db $18, $08, $0e, $10
    db $10, $10, $ff, $10
    db $10, $08, $fe, $10
    db $80

; C: OAM list 10 of the table 5D47
OamList_B01_5D47_10::
    db $20, $10, $1d, $10
    db $20, $08, $1c, $10
    db $18, $10, $0d, $10
    db $18, $08, $0c, $10
    db $10, $10, $fd, $10
    db $10, $08, $fc, $10
    db $80

; C: OAM list 11 of the table 5D47
OamList_B01_5D47_11::
    db $20, $10, $1b, $10
    db $20, $08, $1a, $10
    db $18, $10, $0b, $10
    db $18, $08, $0a, $10
    db $10, $10, $fb, $10
    db $10, $08, $fa, $10
    db $80

; C: OAM list 12 of the table 5D47
OamList_B01_5D47_12::
    db $10, $10, $01, $10
    db $10, $08, $00, $10
    db $20, $10, $19, $10
    db $20, $08, $18, $10
    db $18, $10, $09, $10
    db $18, $08, $08, $10
    db $80

; C: OAM list 13 of the table 5D47
OamList_B01_5D47_13::
    db $20, $08, $7d, $30
    db $20, $10, $7c, $30
    db $18, $08, $6d, $30
    db $18, $10, $6c, $30
    db $10, $08, $5d, $30
    db $10, $10, $5c, $30
    db $80

; C: OAM list 14 of the table 5D47
OamList_B01_5D47_14::
    db $20, $08, $7f, $30
    db $20, $10, $7e, $30
    db $18, $08, $6f, $30
    db $18, $10, $6e, $30
    db $10, $08, $5f, $30
    db $10, $10, $5e, $30
    db $80

; C: OAM list 15 of the table 5D47
OamList_B01_5D47_15::
    db $20, $08, $4b, $30
    db $20, $10, $4a, $30
    db $18, $08, $3b, $30
    db $18, $10, $3a, $30
    db $10, $08, $2b, $30
    db $10, $10, $2a, $30
    db $80

; C: OAM list 16 of the table 5D47
OamList_B01_5D47_16::
    db $20, $08, $4d, $30
    db $20, $10, $4c, $30
    db $18, $08, $3d, $30
    db $18, $10, $3c, $30
    db $10, $08, $2d, $30
    db $10, $10, $2c, $30
    db $80

; C: OAM list 17 of the table 5D47
OamList_B01_5D47_17::
    db $20, $08, $4f, $30
    db $20, $10, $4e, $30
    db $18, $08, $3f, $30
    db $18, $10, $3e, $30
    db $10, $08, $2f, $30
    db $10, $10, $2e, $30
    db $80

; C: OAM list 18 of the table 5D47
OamList_B01_5D47_18::
    db $10, $10, $11, $10
    db $10, $08, $10, $10
    db $20, $10, $17, $10
    db $20, $08, $16, $10
    db $18, $10, $07, $10
    db $18, $08, $06, $10
    db $80

; C: OAM list 19 of the table 5D47
OamList_B01_5D47_19::
    db $20, $10, $4f, $10
    db $20, $08, $4e, $10
    db $18, $10, $3f, $10
    db $18, $08, $3e, $10
    db $10, $10, $2f, $10
    db $10, $08, $2e, $10
    db $80

; C: OAM list 1A of the table 5D47
OamList_B01_5D47_1A::
    db $20, $10, $4d, $10
    db $20, $08, $4c, $10
    db $18, $10, $3d, $10
    db $18, $08, $3c, $10
    db $10, $10, $2d, $10
    db $10, $08, $2c, $10
    db $80

; C: OAM list 1B of the table 5D47
OamList_B01_5D47_1B::
    db $20, $10, $4b, $10
    db $20, $08, $4a, $10
    db $18, $10, $3b, $10
    db $18, $08, $3a, $10
    db $10, $10, $2b, $10
    db $10, $08, $2a, $10
    db $80

; C: OAM list 1C of the table 5D47
OamList_B01_5D47_1C::
    db $20, $10, $7f, $10
    db $20, $08, $7e, $10
    db $18, $10, $6f, $10
    db $18, $08, $6e, $10
    db $10, $10, $5f, $10
    db $10, $08, $5e, $10
    db $80

; C: OAM list 1D of the table 5D47
OamList_B01_5D47_1D::
    db $20, $10, $7d, $10
    db $20, $08, $7c, $10
    db $18, $10, $6d, $10
    db $18, $08, $6c, $10
    db $10, $10, $5d, $10
    db $10, $08, $5c, $10
    db $80

; C: OAM list 1E of the table 5D47
OamList_B01_5D47_1E::
    db $20, $10, $43, $10
    db $20, $08, $42, $10
    db $18, $10, $33, $10
    db $18, $08, $32, $10
    db $10, $10, $23, $10
    db $10, $08, $22, $10
    db $80

; C: OAM list 1F of the table 5D47
OamList_B01_5D47_1F::
    db $20, $10, $45, $10
    db $20, $08, $44, $10
    db $18, $10, $35, $10
    db $18, $08, $34, $10
    db $10, $10, $25, $10
    db $10, $08, $24, $10
    db $80

; C: OAM list 20 of the table 5D47
OamList_B01_5D47_20::
    db $20, $10, $47, $10
    db $20, $08, $46, $10
    db $18, $10, $37, $10
    db $18, $08, $36, $10
    db $10, $10, $27, $10
    db $10, $08, $26, $10
    db $80

; C: OAM list 21 of the table 5D47
OamList_B01_5D47_21::
    db $20, $10, $49, $10
    db $20, $08, $48, $10
    db $18, $10, $39, $10
    db $18, $08, $38, $10
    db $10, $10, $29, $10
    db $10, $08, $28, $10
    db $80

; C: OAM list 22 of the table 5D47
OamList_B01_5D47_22::
    db $20, $08, $49, $30
    db $20, $10, $48, $30
    db $18, $08, $39, $30
    db $18, $10, $38, $30
    db $10, $08, $29, $30
    db $10, $10, $28, $30
    db $80

; C: OAM list 23 of the table 5D47
OamList_B01_5D47_23::
    db $20, $08, $47, $30
    db $20, $10, $46, $30
    db $18, $08, $37, $30
    db $18, $10, $36, $30
    db $10, $08, $27, $30
    db $10, $10, $26, $30
    db $80

; C: OAM list 24 of the table 5D47
OamList_B01_5D47_24::
    db $20, $08, $45, $30
    db $20, $10, $44, $30
    db $18, $08, $35, $30
    db $18, $10, $34, $30
    db $10, $08, $25, $30
    db $10, $10, $24, $30
    db $80

; C: OAM list 25 of the table 5D47
OamList_B01_5D47_25::
    db $20, $08, $7d, $30
    db $20, $10, $7c, $30
    db $18, $08, $6d, $30
    db $18, $10, $6c, $30
    db $10, $08, $5d, $30
    db $10, $10, $5c, $30
    db $80

; C: OAM list 26 of the table 5D47
OamList_B01_5D47_26::
    db $11, $f7, $6d, $10
    db $11, $ef, $6c, $10
    db $19, $ff, $70, $00
    db $19, $f7, $6f, $00
    db $19, $ef, $6e, $00
    db $08, $14, $5f, $00
    db $08, $0c, $5e, $00
    db $08, $04, $5d, $00
    db $08, $fc, $5c, $00
    db $08, $f4, $5b, $00
    db $00, $14, $5a, $00
    db $00, $0c, $59, $00
    db $00, $04, $58, $00
    db $00, $fc, $57, $00
    db $00, $f4, $56, $00
    db $f6, $0f, $4f, $00
    db $f6, $04, $4e, $00
    db $f6, $f8, $4d, $00
    db $80

; C: OAM list 27 of the table 5D47
OamList_B01_5D47_27::
    db $f6, $18, $55, $00
    db $f6, $0f, $54, $00
    db $f6, $07, $53, $00
    db $f6, $fe, $52, $00
    db $f6, $f5, $51, $00
    db $f6, $ed, $50, $00
    db $11, $f7, $6d, $10
    db $11, $ef, $6c, $10
    db $19, $ff, $70, $00
    db $19, $f7, $6f, $00
    db $19, $ef, $6e, $00
    db $08, $14, $5f, $00
    db $08, $0c, $5e, $00
    db $08, $04, $5d, $00
    db $08, $fc, $5c, $00
    db $08, $f4, $5b, $00
    db $00, $14, $5a, $00
    db $00, $0c, $59, $00
    db $00, $04, $58, $00
    db $00, $fc, $57, $00
    db $00, $f4, $56, $00
    db $80

; C: OAM list 28 of the table 5D47
OamList_B01_5D47_28::
    db $08, $00, $71, $00
    db $00, $00, $61, $00
    db $80

; C: OAM list 29 of the table 5D47
OamList_B01_5D47_29::
    db $08, $00, $72, $00
    db $00, $00, $62, $00
    db $80

; C: OAM list 2A of the table 5D47
OamList_B01_5D47_2A::
    db $08, $00, $73, $00
    db $00, $00, $63, $00
    db $80

; C: OAM list 2B of the table 5D47
OamList_B01_5D47_2B::
    db $08, $00, $74, $00
    db $00, $00, $64, $00
    db $80

; C: OAM list 2C of the table 5D47
OamList_B01_5D47_2C::
    db $08, $00, $75, $00
    db $00, $00, $65, $00
    db $80

; C: OAM list 2D of the table 5D47
OamList_B01_5D47_2D::
    db $08, $00, $76, $00
    db $00, $00, $66, $00
    db $80

; C: OAM list 2E of the table 5D47
OamList_B01_5D47_2E::
    db $08, $00, $77, $00
    db $00, $00, $67, $00
    db $80

; C: OAM list 2F of the table 5D47
OamList_B01_5D47_2F::
    db $08, $00, $78, $00
    db $00, $00, $68, $00
    db $80

; C: OAM list 30 of the table 5D47
OamList_B01_5D47_30::
    db $08, $00, $79, $00
    db $00, $00, $69, $00
    db $80

; C: OAM list 31 of the table 5D47
OamList_B01_5D47_31::
    db $08, $00, $7a, $00
    db $00, $00, $6a, $00
    db $80

; C: OAM list 32 of the table 5D47
OamList_B01_5D47_32::
    db $11, $01, $60, $30
    db $11, $1c, $60, $10
    db $80

; C: OAM list 33 of the table 5D47
OamList_B01_5D47_33::
    db $11, $1b, $60, $10
    db $11, $02, $60, $30
    db $80

; C: OAM list 34 of the table 5D47
OamList_B01_5D47_34::
    db $18, $06, $40, $00
    db $18, $02, $7e, $00
    db $18, $f0, $7c, $10
    db $18, $f8, $7d, $00
    db $08, $1a, $4b, $10
    db $08, $12, $4a, $10
    db $08, $0a, $49, $10
    db $10, $fd, $48, $10
    db $08, $fd, $44, $10
    db $10, $f5, $47, $10
    db $10, $ed, $46, $10
    db $10, $e5, $45, $10
    db $08, $f5, $43, $10
    db $08, $ed, $42, $10
    db $08, $e5, $41, $10
    db $80

; C: OAM list 35 of the table 5D47
OamList_B01_5D47_35::
    db $08, $00, $6e, $10
    db $80

; C: OAM list 36 of the table 5D47
OamList_B01_5D47_36::
    db $08, $08, $6f, $10
    db $80

; C: OAM list 37 of the table 5D47
OamList_B01_5D47_37::
    db $f8, $f0, $73, $10
    db $f0, $f0, $72, $10
    db $f8, $e8, $71, $10
    db $f0, $e8, $70, $10
    db $80

; C: OAM list 38 of the table 5D47
OamList_B01_5D47_38::
    db $f8, $18, $e9, $10
    db $f8, $10, $e8, $10
    db $f8, $08, $e7, $10
    db $f8, $00, $e6, $10
    db $f8, $f8, $e5, $10
    db $f0, $18, $d9, $10
    db $f0, $10, $d8, $10
    db $f0, $08, $d7, $10
    db $f0, $00, $d6, $10
    db $f0, $f8, $d5, $10
    db $f8, $f0, $63, $10
    db $f8, $e8, $62, $10
    db $f0, $f0, $61, $10
    db $f0, $e8, $60, $10
    db $80

; C: OAM list 39 of the table 5D47
OamList_B01_5D47_39::
    db $f8, $18, $f1, $10
    db $f8, $10, $f0, $10
    db $f8, $08, $ef, $10
    db $f8, $00, $ee, $10
    db $f8, $f8, $ed, $10
    db $f0, $18, $ec, $10
    db $f0, $10, $eb, $10
    db $f0, $08, $ea, $10
    db $f0, $00, $db, $10
    db $f0, $f8, $da, $10
    db $f8, $f0, $67, $10
    db $f8, $e8, $66, $10
    db $f0, $f0, $65, $10
    db $f0, $e8, $64, $10
    db $80

; C: OAM list 3A of the table 5D47
OamList_B01_5D47_3A::
    db $10, $20, $5f, $10
    db $10, $18, $5e, $10
    db $08, $20, $5d, $10
    db $08, $18, $5c, $10
    db $10, $10, $5b, $10
    db $10, $08, $5a, $10
    db $08, $10, $59, $10
    db $08, $08, $58, $10
    db $10, $00, $57, $10
    db $10, $f8, $56, $10
    db $08, $00, $55, $10
    db $08, $f8, $54, $10
    db $10, $f0, $53, $10
    db $10, $e8, $52, $10
    db $08, $f0, $51, $10
    db $08, $e8, $50, $10
    db $80

; C: OAM list 3B of the table 5D47
OamList_B01_5D47_3B::
    db $28, $08, $5f, $10
    db $28, $00, $5e, $10
    db $20, $08, $5d, $10
    db $20, $00, $5c, $10
    db $10, $08, $59, $10
    db $10, $00, $58, $10
    db $08, $08, $57, $10
    db $08, $00, $56, $10
    db $18, $08, $5b, $10
    db $18, $00, $5a, $10
    db $00, $08, $55, $10
    db $00, $00, $54, $10
    db $f8, $08, $53, $10
    db $f8, $00, $52, $10
    db $f0, $08, $51, $10
    db $f0, $00, $50, $10
    db $80

; C: OAM list 3C of the table 5D47
OamList_B01_5D47_3C::
    db $3d, $08, $75, $10
    db $15, $08, $75, $10
    db $ed, $08, $75, $10
    db $80

; C: OAM list 3D of the table 5D47
OamList_B01_5D47_3D::
    db $51, $08, $75, $10
    db $29, $08, $75, $10
    db $01, $08, $75, $10
    db $80

; C: OAM list 3E of the table 5D47
OamList_B01_5D47_3E::
    db $10, $26, $74, $10
    db $10, $06, $74, $10
    db $10, $e6, $74, $10
    db $10, $c6, $74, $10
    db $80

; C: OAM list 3F of the table 5D47
OamList_B01_5D47_3F::
    db $10, $36, $74, $10
    db $10, $16, $74, $10
    db $10, $f6, $74, $10
    db $10, $d6, $74, $10
    db $80

; C: OAM list 40 of the table 5D47
OamList_B01_5D47_40::
    db $2f, $14, $74, $10
    db $2f, $f4, $74, $10
    db $24, $2e, $75, $10
    db $04, $2e, $75, $10
    db $24, $df, $75, $10
    db $f0, $24, $74, $10
    db $f0, $04, $74, $10
    db $04, $df, $75, $10
    db $f0, $e4, $74, $10
    db $80

; C: OAM list 41 of the table 5D47
OamList_B01_5D47_41::
    db $2f, $24, $74, $10
    db $2f, $04, $74, $10
    db $2f, $e4, $74, $10
    db $14, $2e, $75, $10
    db $f4, $2e, $75, $10
    db $14, $df, $75, $10
    db $f0, $14, $74, $10
    db $f4, $df, $75, $10
    db $f0, $f4, $74, $10
    db $80

; C: OAM list 42 of the table 5D47
OamList_B01_5D47_42::
    db $0c, $f7, $64, $30
    db $0c, $11, $64, $10
    db $80

; C: OAM list 43 of the table 5D47
OamList_B01_5D47_43::
    db $0c, $f7, $64, $30
    db $0c, $0f, $64, $10
    db $80

; C: OAM list 44 of the table 5D47
OamList_B01_5D47_44::
    db $0c, $f9, $64, $30
    db $0c, $11, $64, $10
    db $80

; C: OAM list 45 of the table 5D47
OamList_B01_5D47_45::
    db $10, $00, $59, $30
    db $08, $00, $51, $30
    db $10, $08, $59, $10
    db $08, $08, $51, $10
    db $80

; C: OAM list 46 of the table 5D47
OamList_B01_5D47_46::
    db $10, $08, $5f, $10
    db $10, $00, $5e, $10
    db $08, $08, $57, $10
    db $08, $00, $56, $10
    db $80

; C: OAM list 47 of the table 5D47
OamList_B01_5D47_47::
    db $10, $08, $5d, $10
    db $10, $00, $5c, $10
    db $08, $08, $55, $10
    db $08, $00, $54, $10
    db $80

; C: OAM list 48 of the table 5D47
OamList_B01_5D47_48::
    db $10, $08, $5b, $10
    db $10, $00, $5a, $10
    db $08, $08, $53, $10
    db $08, $00, $52, $10
    db $80

; C: OAM list 49 of the table 5D47
OamList_B01_5D47_49::
    db $10, $08, $58, $30
    db $10, $00, $58, $10
    db $08, $08, $50, $30
    db $08, $00, $50, $10
    db $80

; C: OAM list 4A of the table 5D47
OamList_B01_5D47_4A::
    db $10, $00, $5b, $30
    db $10, $08, $5a, $30
    db $08, $00, $53, $30
    db $08, $08, $52, $30
    db $80

; C: OAM list 4B of the table 5D47
OamList_B01_5D47_4B::
    db $10, $00, $5d, $30
    db $10, $08, $5c, $30
    db $08, $00, $55, $30
    db $08, $08, $54, $30
    db $80

; C: OAM list 4C of the table 5D47
OamList_B01_5D47_4C::
    db $10, $00, $5f, $30
    db $10, $08, $5e, $30
    db $08, $00, $57, $30
    db $08, $08, $56, $30
    db $80

; C: OAM list 4D of the table 5D47
OamList_B01_5D47_4D::
    db $10, $08, $63, $10
    db $10, $00, $62, $10
    db $08, $08, $61, $10
    db $08, $00, $60, $10
    db $80

; C: OAM list 4E of the table 5D47
OamList_B01_5D47_4E::
    db $0a, $f4, $6c, $70
    db $0a, $14, $6c, $50
    db $10, $14, $6c, $10
    db $10, $0c, $6b, $10
    db $10, $04, $6a, $10
    db $10, $fc, $69, $10
    db $10, $f4, $68, $10
    db $08, $0c, $67, $10
    db $08, $04, $66, $10
    db $08, $fc, $65, $10
    db $80

; C: OAM list 4F of the table 5D47
OamList_B01_5D47_4F::
    db $08, $08, $a0, $a0
    db $08, $00, $a0, $80
    db $80

; C: OAM list 50 of the table 5D47
OamList_B01_5D47_50::
    db $08, $08, $a4, $80
    db $08, $00, $a2, $80
    db $80

; C: OAM list 51 of the table 5D47
OamList_B01_5D47_51::
    db $08, $00, $a4, $a0
    db $08, $08, $a2, $a0
    db $80

; C: OAM list 52 of the table 5D47
OamList_B01_5D47_52::
    db $08, $08, $a8, $80
    db $08, $00, $a6, $80
    db $80

; C: OAM list 53 of the table 5D47
OamList_B01_5D47_53::
    db $08, $00, $a8, $a0
    db $08, $08, $a6, $a0
    db $80

; C: OAM list 54 of the table 5D47
OamList_B01_5D47_54::
    db $08, $08, $b2, $80
    db $08, $00, $b0, $80
    db $80

; C: OAM list 55 of the table 5D47
OamList_B01_5D47_55::
    db $08, $08, $b6, $80
    db $08, $00, $b4, $80
    db $80

; C: OAM list 56 of the table 5D47
OamList_B01_5D47_56::
    db $08, $08, $ba, $80
    db $08, $00, $b8, $80
    db $80

; C: OAM list 57 of the table 5D47
OamList_B01_5D47_57::
    db $0c, $08, $be, $80
    db $0c, $00, $bc, $80
    db $80

; C: OAM list 58 of the table 5D47
OamList_B01_5D47_58::
    db $0c, $08, $92, $80
    db $0c, $00, $90, $80
    db $80

; C: OAM list 59 of the table 5D47
OamList_B01_5D47_59::
    db $0c, $08, $96, $80
    db $0c, $00, $94, $80
    db $80

; C: OAM list 5A of the table 5D47
OamList_B01_5D47_5A::
    db $0c, $04, $aa, $80
    db $80

; C: OAM list 5B of the table 5D47
OamList_B01_5D47_5B::
    db $0c, $04, $ac, $80
    db $80

; C: OAM list 5C of the table 5D47
OamList_B01_5D47_5C::
    db $08, $08, $ae, $a0
    db $08, $00, $ae, $80
    db $80

; C: OAM list 5D of the table 5D47
OamList_B01_5D47_5D::
    db $0a, $07, $8c, $80
    db $80

; C: OAM list 5E of the table 5D47
OamList_B01_5D47_5E::
    db $0c, $04, $9a, $80
    db $80

; C: OAM list 5F of the table 5D47
OamList_B01_5D47_5F::
    db $0c, $04, $9c, $80
    db $80

; C: OAM list 60 of the table 5D47
OamList_B01_5D47_60::
    db $0f, $00, $9e, $80
    db $80

; C: OAM list 61 of the table 5D47
OamList_B01_5D47_61::
    db $0c, $04, $8e, $80
    db $80

; C: OAM list 62 of the table 5D47
OamList_B01_5D47_62::
    db $20, $20, $fe, $80
    db $20, $18, $fc, $80
    db $20, $10, $fa, $80
    db $20, $08, $f8, $80
    db $20, $00, $f6, $80
    db $20, $f8, $f4, $80
    db $20, $f0, $f2, $80
    db $20, $e8, $f0, $80
    db $10, $20, $ee, $80
    db $10, $18, $ec, $80
    db $10, $10, $ea, $80
    db $10, $08, $e8, $80
    db $10, $00, $e6, $80
    db $10, $f8, $e4, $80
    db $10, $f0, $e2, $80
    db $10, $e8, $e0, $80
    db $00, $20, $de, $80
    db $00, $18, $dc, $80
    db $00, $10, $da, $80
    db $00, $08, $d8, $80
    db $00, $00, $d6, $80
    db $00, $f8, $d4, $80
    db $00, $f0, $d2, $80
    db $00, $e8, $d0, $80
    db $f0, $20, $ce, $80
    db $f0, $18, $cc, $80
    db $f0, $10, $ca, $80
    db $f0, $08, $c8, $80
    db $f0, $00, $c6, $80
    db $f0, $f8, $c4, $80
    db $f0, $f0, $c2, $80
    db $f0, $e8, $c0, $80
    db $80

; C: OAM list 63 of the table 5D47
OamList_B01_5D47_63::
    db $20, $20, $3e, $80
    db $20, $18, $3c, $80
    db $20, $10, $3a, $80
    db $20, $08, $38, $80
    db $20, $00, $36, $80
    db $20, $f8, $34, $80
    db $20, $f0, $32, $80
    db $20, $e8, $30, $80
    db $10, $20, $2e, $80
    db $10, $18, $2c, $80
    db $10, $10, $2a, $80
    db $10, $08, $28, $80
    db $10, $00, $26, $80
    db $10, $f8, $24, $80
    db $10, $f0, $22, $80
    db $10, $e8, $20, $80
    db $00, $20, $1e, $80
    db $00, $18, $1c, $80
    db $00, $10, $1a, $80
    db $00, $08, $18, $80
    db $00, $00, $16, $80
    db $00, $f8, $14, $80
    db $00, $f0, $12, $80
    db $00, $e8, $10, $80
    db $f0, $20, $0e, $80
    db $f0, $18, $0c, $80
    db $f0, $10, $0a, $80
    db $f0, $08, $08, $80
    db $f0, $00, $06, $80
    db $f0, $f8, $04, $80
    db $f0, $f0, $02, $80
    db $f0, $e8, $00, $80
    db $80

; C: OAM list 64 of the table 5D47
OamList_B01_5D47_64::
    db $20, $20, $7e, $80
    db $20, $18, $7c, $80
    db $20, $10, $7a, $80
    db $20, $08, $78, $80
    db $20, $00, $76, $80
    db $20, $f8, $74, $80
    db $20, $f0, $72, $80
    db $20, $e8, $70, $80
    db $10, $20, $6e, $80
    db $10, $18, $6c, $80
    db $10, $10, $6a, $80
    db $10, $08, $68, $80
    db $10, $00, $66, $80
    db $10, $f8, $64, $80
    db $10, $f0, $62, $80
    db $10, $e8, $60, $80
    db $00, $20, $5e, $80
    db $00, $18, $5c, $80
    db $00, $10, $5a, $80
    db $00, $08, $58, $80
    db $00, $00, $56, $80
    db $00, $f8, $54, $80
    db $00, $f0, $52, $80
    db $00, $e8, $50, $80
    db $f0, $20, $4e, $80
    db $f0, $18, $4c, $80
    db $f0, $10, $4a, $80
    db $f0, $08, $48, $80
    db $f0, $00, $46, $80
    db $f0, $f8, $44, $80
    db $f0, $f0, $42, $80
    db $f0, $e8, $40, $80
    db $80

; C: OAM list 65 of the table 5D47
OamList_B01_5D47_65::
    db $20, $20, $fe, $80
    db $20, $18, $fc, $80
    db $20, $10, $fa, $80
    db $20, $08, $f8, $80
    db $20, $00, $f6, $80
    db $20, $f8, $f4, $80
    db $20, $f0, $f2, $80
    db $10, $20, $ee, $80
    db $10, $18, $ec, $80
    db $10, $10, $ea, $80
    db $10, $08, $e8, $80
    db $10, $00, $e6, $80
    db $10, $f8, $e4, $80
    db $10, $f0, $e2, $80
    db $00, $20, $de, $80
    db $00, $18, $dc, $80
    db $00, $10, $da, $80
    db $00, $08, $d8, $80
    db $00, $00, $d6, $80
    db $00, $f8, $d4, $80
    db $00, $f0, $d2, $80
    db $f0, $20, $ce, $80
    db $f0, $18, $cc, $80
    db $f0, $10, $ca, $80
    db $f0, $08, $c8, $80
    db $f0, $00, $c6, $80
    db $f0, $f8, $c4, $80
    db $f0, $f0, $c2, $80
    db $80

; C: OAM list 66 of the table 5D47
OamList_B01_5D47_66::
    db $20, $20, $3e, $80
    db $20, $18, $3c, $80
    db $20, $10, $3a, $80
    db $20, $08, $38, $80
    db $20, $00, $36, $80
    db $20, $f8, $34, $80
    db $20, $f0, $32, $80
    db $10, $20, $2e, $80
    db $10, $18, $2c, $80
    db $10, $10, $2a, $80
    db $10, $08, $28, $80
    db $10, $00, $26, $80
    db $10, $f8, $24, $80
    db $10, $f0, $22, $80
    db $00, $20, $1e, $80
    db $00, $18, $1c, $80
    db $00, $10, $1a, $80
    db $00, $08, $18, $80
    db $00, $00, $16, $80
    db $00, $f8, $14, $80
    db $00, $f0, $12, $80
    db $f0, $20, $0e, $80
    db $f0, $18, $0c, $80
    db $f0, $10, $0a, $80
    db $f0, $08, $08, $80
    db $f0, $00, $06, $80
    db $f0, $f8, $04, $80
    db $f0, $f0, $02, $80
    db $80

; C: OAM list 67 of the table 5D47
OamList_B01_5D47_67::
    db $20, $20, $7e, $80
    db $20, $18, $7c, $80
    db $20, $10, $7a, $80
    db $20, $08, $78, $80
    db $20, $00, $76, $80
    db $20, $f8, $74, $80
    db $20, $f0, $72, $80
    db $10, $20, $6e, $80
    db $10, $18, $6c, $80
    db $10, $10, $6a, $80
    db $10, $08, $68, $80
    db $10, $00, $66, $80
    db $10, $f8, $64, $80
    db $10, $f0, $62, $80
    db $00, $20, $5e, $80
    db $00, $18, $5c, $80
    db $00, $10, $5a, $80
    db $00, $08, $58, $80
    db $00, $00, $56, $80
    db $00, $f8, $54, $80
    db $00, $f0, $52, $80
    db $f0, $20, $4e, $80
    db $f0, $18, $4c, $80
    db $f0, $10, $4a, $80
    db $f0, $08, $48, $80
    db $f0, $00, $46, $80
    db $f0, $f8, $44, $80
    db $f0, $f0, $42, $80
    db $80

; C: OAM list 68 of the table 5D47
OamList_B01_5D47_68::
    db $1e, $1e, $fe, $80
    db $1e, $16, $fc, $80
    db $1e, $0f, $fa, $80
    db $1e, $07, $f8, $80
    db $1e, $01, $f6, $80
    db $1e, $f9, $f4, $80
    db $1e, $f2, $f2, $80
    db $1e, $ea, $f0, $80
    db $0f, $1e, $ee, $80
    db $0f, $16, $ec, $80
    db $0f, $0f, $ea, $80
    db $0f, $07, $e8, $80
    db $0f, $01, $e6, $80
    db $0f, $f9, $e4, $80
    db $0f, $f2, $e2, $80
    db $0f, $ea, $e0, $80
    db $01, $1e, $de, $80
    db $01, $16, $dc, $80
    db $01, $0f, $da, $80
    db $01, $07, $d8, $80
    db $01, $01, $d6, $80
    db $01, $f9, $d4, $80
    db $01, $f2, $d2, $80
    db $01, $ea, $d0, $80
    db $f2, $1e, $ce, $80
    db $f2, $16, $cc, $80
    db $f2, $0f, $ca, $80
    db $f2, $07, $c8, $80
    db $f2, $01, $c6, $80
    db $f2, $f9, $c4, $80
    db $f2, $f2, $c2, $80
    db $f2, $ea, $c0, $80
    db $80

; C: OAM list 69 of the table 5D47
OamList_B01_5D47_69::
    db $1c, $1c, $fe, $80
    db $1c, $14, $fc, $80
    db $1c, $0e, $fa, $80
    db $1c, $06, $f8, $80
    db $1c, $02, $f6, $80
    db $1c, $fa, $f4, $80
    db $1c, $f4, $f2, $80
    db $1c, $ec, $f0, $80
    db $0e, $1c, $ee, $80
    db $0e, $14, $ec, $80
    db $0e, $0e, $ea, $80
    db $0e, $06, $e8, $80
    db $0e, $02, $e6, $80
    db $0e, $fa, $e4, $80
    db $0e, $f4, $e2, $80
    db $0e, $ec, $e0, $80
    db $02, $1c, $de, $80
    db $02, $14, $dc, $80
    db $02, $0e, $da, $80
    db $02, $06, $d8, $80
    db $02, $02, $d6, $80
    db $02, $fa, $d4, $80
    db $02, $f4, $d2, $80
    db $02, $ec, $d0, $80
    db $f4, $1c, $ce, $80
    db $f4, $14, $cc, $80
    db $f4, $0e, $ca, $80
    db $f4, $06, $c8, $80
    db $f4, $02, $c6, $80
    db $f4, $fa, $c4, $80
    db $f4, $f4, $c2, $80
    db $f4, $ec, $c0, $80
    db $80

; C: OAM list 6A of the table 5D47
OamList_B01_5D47_6A::
    db $1a, $1a, $fe, $80
    db $1a, $12, $fc, $80
    db $1a, $0d, $fa, $80
    db $1a, $06, $f8, $80
    db $1a, $03, $f6, $80
    db $1a, $fb, $f4, $80
    db $1a, $f6, $f2, $80
    db $1a, $ee, $f0, $80
    db $0d, $1a, $ee, $80
    db $0d, $12, $ec, $80
    db $0d, $0d, $ea, $80
    db $0d, $06, $e8, $80
    db $0d, $03, $e6, $80
    db $0d, $fb, $e4, $80
    db $0d, $f6, $e2, $80
    db $0d, $ee, $e0, $80
    db $03, $1a, $de, $80
    db $03, $12, $dc, $80
    db $03, $0d, $da, $80
    db $03, $06, $d8, $80
    db $03, $03, $d6, $80
    db $03, $fb, $d4, $80
    db $03, $f6, $d2, $80
    db $03, $ee, $d0, $80
    db $f6, $1a, $ce, $80
    db $f6, $12, $cc, $80
    db $f6, $0d, $ca, $80
    db $f6, $06, $c8, $80
    db $f6, $03, $c6, $80
    db $f6, $fb, $c4, $80
    db $f6, $f6, $c2, $80
    db $f6, $ee, $c0, $80
    db $80

; C: OAM list 6B of the table 5D47
OamList_B01_5D47_6B::
    db $1e, $1e, $fe, $80
    db $1e, $16, $fc, $80
    db $1e, $0f, $fa, $80
    db $1e, $07, $f8, $80
    db $1e, $01, $f6, $80
    db $1e, $f9, $f4, $80
    db $1e, $f2, $f2, $80
    db $0f, $1e, $ee, $80
    db $0f, $16, $ec, $80
    db $0f, $0f, $ea, $80
    db $0f, $07, $e8, $80
    db $0f, $01, $e6, $80
    db $0f, $f9, $e4, $80
    db $0f, $f2, $e2, $80
    db $01, $1e, $de, $80
    db $01, $16, $dc, $80
    db $01, $0f, $da, $80
    db $01, $07, $d8, $80
    db $01, $01, $d6, $80
    db $01, $f9, $d4, $80
    db $01, $f2, $d2, $80
    db $f2, $1e, $ce, $80
    db $f2, $16, $cc, $80
    db $f2, $0f, $ca, $80
    db $f2, $07, $c8, $80
    db $f2, $01, $c6, $80
    db $f2, $f9, $c4, $80
    db $f2, $f2, $c2, $80
    db $80

; C: OAM list 6C of the table 5D47
OamList_B01_5D47_6C::
    db $1c, $1c, $fe, $80
    db $1c, $14, $fc, $80
    db $1c, $0e, $fa, $80
    db $1c, $06, $f8, $80
    db $1c, $02, $f6, $80
    db $1c, $fa, $f4, $80
    db $1c, $f4, $f2, $80
    db $0e, $1c, $ee, $80
    db $0e, $14, $ec, $80
    db $0e, $0e, $ea, $80
    db $0e, $06, $e8, $80
    db $0e, $02, $e6, $80
    db $0e, $fa, $e4, $80
    db $0e, $f4, $e2, $80
    db $02, $1c, $de, $80
    db $02, $14, $dc, $80
    db $02, $0e, $da, $80
    db $02, $06, $d8, $80
    db $02, $02, $d6, $80
    db $02, $fa, $d4, $80
    db $02, $f4, $d2, $80
    db $f4, $1c, $ce, $80
    db $f4, $14, $cc, $80
    db $f4, $0e, $ca, $80
    db $f4, $06, $c8, $80
    db $f4, $02, $c6, $80
    db $f4, $fa, $c4, $80
    db $f4, $f4, $c2, $80
    db $80

; C: OAM list 6D of the table 5D47
OamList_B01_5D47_6D::
    db $1a, $1a, $fe, $80
    db $1a, $12, $fc, $80
    db $1a, $0d, $fa, $80
    db $1a, $06, $f8, $80
    db $1a, $03, $f6, $80
    db $1a, $fb, $f4, $80
    db $1a, $f6, $f2, $80
    db $0d, $1a, $ee, $80
    db $0d, $12, $ec, $80
    db $0d, $0d, $ea, $80
    db $0d, $06, $e8, $80
    db $0d, $03, $e6, $80
    db $0d, $fb, $e4, $80
    db $0d, $f6, $e2, $80
    db $03, $1a, $de, $80
    db $03, $12, $dc, $80
    db $03, $0d, $da, $80
    db $03, $06, $d8, $80
    db $03, $03, $d6, $80
    db $03, $fb, $d4, $80
    db $03, $f6, $d2, $80
    db $f6, $1a, $ce, $80
    db $f6, $12, $cc, $80
    db $f6, $0d, $ca, $80
    db $f6, $06, $c8, $80
    db $f6, $03, $c6, $80
    db $f6, $fb, $c4, $80
    db $f6, $f6, $c2, $80
    db $80

; C: OAM list 6E of the table 5D47
OamList_B01_5D47_6E::
    db $0b, $03, $60, $00
    db $80

; C: OAM list 6F of the table 5D47
OamList_B01_5D47_6F::
    db $0b, $05, $60, $20
    db $80

; C: OAM list 70 of the table 5D47
OamList_B01_5D47_70::
    db $0b, $03, $61, $00
    db $80

; C: OAM list 71 of the table 5D47
OamList_B01_5D47_71::
    db $0b, $05, $61, $20
    db $80

; C: OAM list 72 of the table 5D47
OamList_B01_5D47_72::
    db $0e, $06, $64, $10
    db $80

; C: OAM list 73 of the table 5D47
OamList_B01_5D47_73::
    db $0e, $06, $64, $00
    db $80

; C: OAM list 74 of the table 5D47
OamList_B01_5D47_74::
    db $0e, $05, $65, $10
    db $80

; C: OAM list 75 of the table 5D47
OamList_B01_5D47_75::
    db $0e, $05, $65, $00
    db $80

; C: OAM list 76 of the table 5D47
OamList_B01_5D47_76::
    db $0c, $06, $63, $10
    db $80

; C: OAM list 77 of the table 5D47
OamList_B01_5D47_77::
    db $0c, $06, $62, $00
    db $80

; C: OAM list 78 of the table 5D47
OamList_B01_5D47_78::
    db $0e, $06, $66, $00
    db $80

; C: OAM list 79 of the table 5D47
OamList_B01_5D47_79::
    db $0e, $06, $67, $00
    db $80

; C: OAM list 7A of the table 5D47
OamList_B01_5D47_7A::
    db $0b, $03, $68, $00
    db $80

; C: OAM list 7B of the table 5D47
OamList_B01_5D47_7B::
    db $0b, $03, $69, $00
    db $80

; C: OAM list 7C of the table 5D47
OamList_B01_5D47_7C::
    db $0c, $06, $6a, $00
    db $80

; C: OAM list 7D of the table 5D47
OamList_B01_5D47_7D::
    db $16, $05, $6b, $50
    db $02, $05, $6b, $10
    db $80

; C: OAM list 7E of the table 5D47
OamList_B01_5D47_7E::
    db $08, $00, $6e, $00
    db $80

; C: OAM list 7F of the table 5D47
OamList_B01_5D47_7F::
    db $08, $08, $70, $00
    db $80

; C: OAM list 80 of the table 5D47
OamList_B01_5D47_80::
    db $08, $08, $71, $00
    db $80

; C: OAM list 81 of the table 5D47
OamList_B01_5D47_81::
    db $08, $08, $72, $00
    db $80

; C: OAM list 82 of the table 5D47
OamList_B01_5D47_82::
    db $08, $08, $73, $00
    db $80

; C: OAM list 83 of the table 5D47
OamList_B01_5D47_83::
    db $08, $08, $74, $00
    db $80

; C: OAM list 84 of the table 5D47
OamList_B01_5D47_84::
    db $08, $08, $75, $00
    db $80

; C: OAM list 85 of the table 5D47
OamList_B01_5D47_85::
    db $08, $08, $76, $00
    db $80

; C: OAM list 86 of the table 5D47
OamList_B01_5D47_86::
    db $08, $08, $77, $00
    db $80

; C: OAM list 87 of the table 5D47
OamList_B01_5D47_87::
    db $08, $08, $78, $00
    db $80

; C: OAM list 88 of the table 5D47
OamList_B01_5D47_88::
    db $08, $08, $79, $00
    db $80

; C: OAM list 89 of the table 5D47
OamList_B01_5D47_89::
    db $08, $08, $7a, $00
    db $80

; C: OAM list 8A of the table 5D47
OamList_B01_5D47_8A::
    db $0b, $04, $61, $00
    db $80

; C: OAM list 8B of the table 5D47
OamList_B01_5D47_8B::
    db $f1, $08, $6d, $00
    db $f9, $08, $6d, $00
    db $01, $08, $6d, $00
    db $09, $08, $6d, $00
    db $80

; C: OAM list 8C of the table 5D47
OamList_B01_5D47_8C::
    db $0c, $0d, $7b, $30
    db $0c, $fd, $7b, $10
    db $80

; C: OAM list 8D of the table 5D47
OamList_B01_5D47_8D::
    db $0c, $0e, $7b, $30
    db $0c, $fc, $7b, $10
    db $80

; C: OAM list 8E of the table 5D47
OamList_B01_5D47_8E::
    db $0c, $fd, $7b, $10
    db $80

; C: OAM list 8F of the table 5D47
OamList_B01_5D47_8F::
    db $0c, $fc, $7b, $10
    db $80

; C: OAM list 90 of the table 5D47
OamList_B01_5D47_90::
    db $0c, $0d, $7b, $30
    db $80

; C: OAM list 91 of the table 5D47
OamList_B01_5D47_91::
    db $0c, $0e, $7b, $30
    db $80

; C: OAM list 92 of the table 5D47
OamList_B01_5D47_92::
    db $08, $08, $50, $10
    db $08, $0e, $51, $10
    db $08, $14, $52, $10
    db $80

; C: OAM list 93 of the table 5D47
OamList_B01_5D47_93::
    db $08, $16, $52, $10
    db $08, $0f, $51, $10
    db $08, $08, $50, $10
    db $80

; C: OAM list 94 of the table 5D47
OamList_B01_5D47_94::
    db $08, $18, $52, $10
    db $08, $10, $51, $10
    db $08, $08, $50, $10
    db $80

; C: OAM list 95 of the table 5D47
OamList_B01_5D47_95::
    db $08, $08, $53, $10
    db $08, $0e, $54, $10
    db $08, $14, $55, $10
    db $80

; C: OAM list 96 of the table 5D47
OamList_B01_5D47_96::
    db $08, $16, $55, $10
    db $08, $0f, $54, $10
    db $08, $08, $53, $10
    db $80

; C: OAM list 97 of the table 5D47
OamList_B01_5D47_97::
    db $08, $18, $55, $10
    db $08, $10, $54, $10
    db $08, $08, $53, $10
    db $80

; C: OAM list 98 of the table 5D47
OamList_B01_5D47_98::
    db $08, $08, $56, $10
    db $08, $14, $58, $10
    db $08, $0e, $57, $10
    db $80

; C: OAM list 99 of the table 5D47
OamList_B01_5D47_99::
    db $08, $08, $56, $10
    db $08, $16, $58, $10
    db $08, $0f, $57, $10
    db $80

; C: OAM list 9A of the table 5D47
OamList_B01_5D47_9A::
    db $08, $18, $58, $10
    db $08, $10, $57, $10
    db $08, $08, $56, $10
    db $80

; C: OAM list 9B of the table 5D47
OamList_B01_5D47_9B::
    db $08, $14, $5b, $10
    db $08, $08, $59, $10
    db $08, $0e, $57, $10
    db $80

; C: OAM list 9C of the table 5D47
OamList_B01_5D47_9C::
    db $08, $16, $5b, $10
    db $08, $0f, $5a, $10
    db $08, $08, $59, $10
    db $80

; C: OAM list 9D of the table 5D47
OamList_B01_5D47_9D::
    db $08, $18, $5b, $10
    db $08, $10, $5a, $10
    db $08, $08, $59, $10
    db $80

; C: OAM list 9E of the table 5D47
OamList_B01_5D47_9E::
    db $08, $08, $5c, $10
    db $08, $0e, $5d, $10
    db $08, $14, $5e, $10
    db $80

; C: OAM list 9F of the table 5D47
OamList_B01_5D47_9F::
    db $08, $08, $5c, $10
    db $08, $0f, $5d, $10
    db $08, $16, $5e, $10
    db $80

; C: OAM list A0 of the table 5D47
OamList_B01_5D47_A0::
    db $08, $18, $5e, $10
    db $08, $10, $5d, $10
    db $08, $08, $5c, $10
    db $80

; C: OAM list A1 of the table 5D47
OamList_B01_5D47_A1::
    db $08, $08, $7c, $10
    db $08, $0e, $7d, $10
    db $08, $14, $7e, $10
    db $80

; C: OAM list A2 of the table 5D47
OamList_B01_5D47_A2::
    db $08, $08, $7c, $10
    db $08, $0f, $7d, $10
    db $08, $16, $7e, $10
    db $80

; C: OAM list A3 of the table 5D47
OamList_B01_5D47_A3::
    db $08, $18, $7e, $10
    db $08, $10, $7d, $10
    db $08, $08, $7c, $10
    db $80

; C: OAM list A4 of the table 5D47
OamList_B01_5D47_A4::
    db $08, $10, $6d, $00
    db $08, $08, $7c, $10
    db $80

; C: OAM list A5 of the table 5D47
OamList_B01_5D47_A5::
    db $10, $08, $6c, $10
    db $18, $08, $f9, $00
    db $08, $08, $6c, $10
    db $f8, $08, $6c, $10
    db $00, $08, $6c, $10
    db $f0, $08, $6c, $10
    db $80

; C: OAM list A6 of the table 5D47
OamList_B01_5D47_A6::
    db $10, $10, $46, $00
    db $10, $08, $45, $00
    db $08, $10, $44, $00
    db $08, $08, $43, $00
    db $00, $10, $42, $00
    db $00, $08, $41, $00
    db $00, $00, $40, $00
    db $80

; C: OAM list A7 of the table 5D47
OamList_B01_5D47_A7::
    db $08, $20, $4c, $00
    db $08, $18, $4b, $00
    db $08, $10, $4a, $00
    db $08, $08, $49, $00
    db $08, $00, $48, $00
    db $08, $f8, $47, $00
    db $80

; C: OAM list A8 of the table 5D47
OamList_B01_5D47_A8::
    db $01, $02, $7b, $10
    db $07, $09, $5f, $10
    db $80

; C: OAM list A9 of the table 5D47
OamList_B01_5D47_A9::
    db $01, $08, $7b, $30
    db $07, $01, $5f, $10
    db $80

; C: OAM list AA of the table 5D47
OamList_B01_5D47_AA::
    db $14, $0c, $7b, $30
    db $14, $fe, $7b, $10
    db $0e, $05, $5f, $50
    db $80

; C: OAM list AB of the table 5D47
OamList_B01_5D47_AB::
    db $14, $02, $7b, $10
    db $0e, $09, $5f, $50
    db $80

; C: OAM list AC of the table 5D47
OamList_B01_5D47_AC::
    db $14, $08, $7b, $30
    db $0e, $01, $5f, $50
    db $80

; C: OAM list AD of the table 5D47
OamList_B01_5D47_AD::
    db $14, $0c, $7b, $30
    db $14, $fe, $7b, $10
    db $80

; C: OAM list AE of the table 5D47
OamList_B01_5D47_AE::
    db $14, $02, $7b, $10
    db $80

; C: OAM list AF of the table 5D47
OamList_B01_5D47_AF::
    db $14, $08, $7b, $30
    db $80

; C: OAM list B0 of the table 5D47
OamList_B01_5D47_B0::
    db $08, $08, $00, $30
    db $10, $08, $00, $70
    db $10, $00, $00, $50
    db $08, $00, $00, $10
    db $80

; C: OAM list B1 of the table 5D47
OamList_B01_5D47_B1::
    db $10, $18, $07, $00
    db $10, $10, $06, $00
    db $10, $08, $05, $00
    db $10, $00, $04, $00
    db $10, $f8, $03, $00
    db $08, $f8, $02, $00
    db $08, $f0, $01, $00
    db $80

; C: OAM list B2 of the table 5D47
OamList_B01_5D47_B2::
    db $10, $f0, $07, $20
    db $10, $f8, $06, $20
    db $10, $00, $05, $20
    db $10, $08, $04, $20
    db $10, $10, $03, $20
    db $08, $10, $02, $20
    db $08, $18, $01, $20
    db $80

; C: OAM list B3 of the table 5D47
OamList_B01_5D47_B3::
    db $18, $18, $0e, $00
    db $18, $10, $0d, $00
    db $18, $08, $0c, $00
    db $10, $18, $0b, $00
    db $10, $10, $0a, $00
    db $10, $08, $09, $00
    db $10, $00, $08, $00
    db $08, $00, $02, $00
    db $08, $f8, $01, $00
    db $80

; C: OAM list B4 of the table 5D47
OamList_B01_5D47_B4::
    db $18, $f0, $0e, $20
    db $18, $f8, $0d, $20
    db $18, $00, $0c, $20
    db $10, $f0, $0b, $20
    db $10, $f8, $0a, $20
    db $10, $00, $09, $20
    db $10, $08, $08, $20
    db $08, $08, $02, $20
    db $08, $10, $01, $20
    db $80

; C: OAM list B5 of the table 5D47
OamList_B01_5D47_B5::
    db $08, $f0, $02, $00
    db $08, $e8, $01, $00
    db $10, $f0, $0f, $00
    db $10, $10, $13, $00
    db $10, $08, $12, $00
    db $10, $00, $11, $00
    db $10, $f8, $10, $00
    db $10, $18, $14, $00
    db $80

; C: OAM list B6 of the table 5D47
OamList_B01_5D47_B6::
    db $08, $18, $02, $20
    db $08, $20, $01, $20
    db $10, $18, $0f, $20
    db $10, $f8, $13, $20
    db $10, $00, $12, $20
    db $10, $08, $11, $20
    db $10, $10, $10, $20
    db $10, $f0, $14, $20
    db $80

; C: OAM list B7 of the table 5D47
OamList_B01_5D47_B7::
    db $08, $18, $74, $10
    db $08, $10, $73, $10
    db $08, $08, $72, $10
    db $08, $00, $71, $10
    db $08, $f8, $70, $10
    db $80

; C: OAM list B8 of the table 5D47
OamList_B01_5D47_B8::
    db $08, $18, $74, $10
    db $08, $10, $77, $10
    db $08, $08, $76, $10
    db $08, $00, $75, $10
    db $08, $f8, $73, $10
    db $80

; C: OAM list B9 of the table 5D47
OamList_B01_5D47_B9::
    db $08, $20, $74, $10
    db $08, $18, $77, $10
    db $08, $10, $76, $10
    db $08, $08, $75, $10
    db $08, $00, $73, $10
    db $08, $f8, $79, $10
    db $08, $f0, $78, $10
    db $80

; C: OAM list BA of the table 5D47
OamList_B01_5D47_BA::
    db $08, $10, $7c, $10
    db $08, $08, $7b, $10
    db $08, $00, $7a, $10
    db $08, $f8, $74, $10
    db $80

; C: OAM list BB of the table 5D47
OamList_B01_5D47_BB::
    db $08, $10, $7e, $10
    db $08, $08, $71, $10
    db $08, $00, $7d, $10
    db $08, $f8, $70, $10
    db $80

; C: OAM list BC of the table 5D47
OamList_B01_5D47_BC::
    db $08, $18, $1e, $10
    db $09, $10, $1d, $10
    db $09, $08, $1c, $10
    db $0a, $00, $1b, $10
    db $0c, $f8, $1a, $10
    db $00, $18, $19, $10
    db $01, $10, $18, $10
    db $01, $08, $17, $10
    db $02, $00, $16, $10
    db $04, $f8, $15, $10
    db $80

; C: OAM list BD of the table 5D47
OamList_B01_5D47_BD::
    db $15, $fb, $15, $00
    db $0d, $f9, $06, $00
    db $0b, $f1, $05, $00
    db $fb, $e9, $03, $00
    db $03, $f1, $14, $00
    db $03, $e9, $13, $00
    db $fb, $f1, $04, $00
    db $f3, $eb, $12, $00
    db $f3, $e3, $11, $00
    db $f3, $db, $10, $00
    db $eb, $eb, $02, $00
    db $eb, $e3, $01, $00
    db $eb, $db, $00, $00
    db $80

; C: OAM list BE of the table 5D47
OamList_B01_5D47_BE::
    db $0e, $21, $07, $00
    db $12, $11, $16, $00
    db $0f, $19, $17, $00
    db $0a, $25, $18, $00
    db $fa, $39, $1b, $00
    db $fd, $31, $1a, $00
    db $f5, $31, $0a, $00
    db $02, $27, $08, $00
    db $fa, $29, $19, $00
    db $f2, $29, $09, $00
    db $80

; C: OAM list BF of the table 5D47
OamList_B01_5D47_BF::
    db $2a, $03, $24, $00
    db $2a, $fb, $23, $00
    db $22, $03, $20, $00
    db $80

; C: OAM list C0 of the table 5D47
OamList_B01_5D47_C0::
    db $19, $f7, $0c, $00
    db $21, $ff, $1d, $00
    db $21, $f7, $1c, $00
    db $80

; C: OAM list C1 of the table 5D47
OamList_B01_5D47_C1::
    db $22, $0e, $25, $00
    db $2a, $16, $22, $00
    db $2a, $0e, $21, $00
    db $80

; C: OAM list C2 of the table 5D47
OamList_B01_5D47_C2::
    db $1a, $17, $0e, $00
    db $22, $0f, $0d, $00
    db $22, $17, $1e, $00
    db $80

; C: OAM list C3 of the table 5D47
OamList_B01_5D47_C3::
    db $15, $0d, $15, $20
    db $0d, $0f, $06, $20
    db $0b, $17, $05, $20
    db $fb, $1f, $03, $20
    db $03, $17, $14, $20
    db $03, $1f, $13, $20
    db $fb, $17, $04, $20
    db $f3, $1d, $12, $20
    db $f3, $25, $11, $20
    db $f3, $2d, $10, $20
    db $eb, $1d, $02, $20
    db $eb, $25, $01, $20
    db $eb, $2d, $00, $20
    db $80

; C: OAM list C4 of the table 5D47
OamList_B01_5D47_C4::
    db $0e, $e7, $07, $20
    db $12, $f7, $16, $20
    db $0f, $ef, $17, $20
    db $0a, $e3, $18, $20
    db $fa, $cf, $1b, $20
    db $fd, $d7, $1a, $20
    db $f5, $d7, $0a, $20
    db $02, $e1, $08, $20
    db $fa, $df, $19, $20
    db $f2, $df, $09, $20
    db $80

; C: OAM list C5 of the table 5D47
OamList_B01_5D47_C5::
    db $2a, $05, $24, $20
    db $2a, $0d, $23, $20
    db $22, $05, $20, $20
    db $80

; C: OAM list C6 of the table 5D47
OamList_B01_5D47_C6::
    db $19, $11, $0c, $20
    db $21, $09, $1d, $20
    db $21, $11, $1c, $20
    db $80

; C: OAM list C7 of the table 5D47
OamList_B01_5D47_C7::
    db $22, $fa, $25, $20
    db $2a, $f2, $22, $20
    db $2a, $fa, $21, $20
    db $80

; C: OAM list C8 of the table 5D47
OamList_B01_5D47_C8::
    db $1a, $f1, $0e, $20
    db $22, $f9, $0d, $20
    db $22, $f1, $1e, $20
    db $80

; C: OAM list C9 of the table 5D47
OamList_B01_5D47_C9::
    db $09, $11, $01, $00
    db $09, $09, $00, $00
    db $80

; C: OAM list CA of the table 5D47
OamList_B01_5D47_CA::
    db $09, $11, $01, $00
    db $09, $09, $02, $00
    db $80

; C: OAM list CB of the table 5D47
OamList_B01_5D47_CB::
    db $09, $08, $01, $20
    db $09, $10, $02, $20
    db $80

; C: OAM list CC of the table 5D47
OamList_B01_5D47_CC::
    db $09, $08, $01, $20
    db $09, $10, $00, $20
    db $80

; C: OAM list CD of the table 5D47
OamList_B01_5D47_CD::
    db $08, $08, $01, $60
    db $08, $10, $00, $60
    db $80

; C: OAM list CE of the table 5D47
OamList_B01_5D47_CE::
    db $08, $08, $01, $60
    db $08, $10, $02, $60
    db $80

; C: OAM list CF of the table 5D47
OamList_B01_5D47_CF::
    db $08, $11, $01, $40
    db $08, $09, $02, $40
    db $80

; C: OAM list D0 of the table 5D47
OamList_B01_5D47_D0::
    db $08, $11, $01, $40
    db $08, $09, $00, $40
    db $80

; C: OAM list D1 of the table 5D47
OamList_B01_5D47_D1::
    db $08, $08, $06, $10
    db $80

; C: OAM list D2 of the table 5D47
OamList_B01_5D47_D2::
    db $08, $08, $05, $10
    db $80

; C: OAM list D3 of the table 5D47
OamList_B01_5D47_D3::
    db $04, $17, $04, $10
    db $00, $f2, $04, $70
    db $80

; C: OAM list D4 of the table 5D47
OamList_B01_5D47_D4::
    db $04, $17, $03, $10
    db $00, $f2, $03, $70
    db $80

; C: OAM list D5 of the table 5D47
OamList_B01_5D47_D5::
    db $08, $20, $43, $00
    db $08, $18, $42, $00
    db $08, $10, $41, $00
    db $08, $08, $40, $00
    db $80

; C: OAM list D6 of the table 5D47
OamList_B01_5D47_D6::
    db $08, $20, $53, $00
    db $08, $18, $52, $00
    db $08, $10, $51, $00
    db $08, $08, $50, $00
    db $80

; C: OAM list D7 of the table 5D47
OamList_B01_5D47_D7::
    db $08, $20, $20, $00
    db $08, $18, $52, $00
    db $08, $10, $51, $00
    db $08, $08, $50, $00
    db $80

; C: OAM list D8 of the table 5D47
OamList_B01_5D47_D8::
    db $08, $20, $2d, $00
    db $08, $18, $24, $00
    db $08, $10, $1d, $00
    db $08, $08, $1c, $00
    db $80

; C: OAM list D9 of the table 5D47
OamList_B01_5D47_D9::
    db $08, $10, $15, $00
    db $08, $08, $14, $00
    db $80

; C: OAM list DA of the table 5D47
OamList_B01_5D47_DA::
    db $08, $08, $07, $50
    db $07, $08, $07, $10
    db $80

; C: OAM list DB of the table 5D47
OamList_B01_5D47_DB::
    db $07, $08, $07, $50
    db $07, $08, $07, $10
    db $80

; C: OAM list DC of the table 5D47
OamList_B01_5D47_DC::
    db $08, $08, $07, $50
    db $08, $08, $07, $10
    db $80

; C: OAM list DD of the table 5D47
OamList_B01_5D47_DD::
    db $f0, $09, $3d, $70
    db $f0, $11, $3c, $70
    db $f8, $11, $2c, $70
    db $f0, $19, $58, $70
    db $f8, $19, $48, $70
    db $f8, $21, $47, $70
    db $00, $11, $39, $70
    db $00, $19, $38, $70
    db $00, $21, $37, $70
    db $16, $e6, $54, $10
    db $0f, $ea, $31, $10
    db $0f, $e2, $30, $10
    db $07, $f8, $23, $10
    db $07, $f0, $22, $10
    db $07, $e8, $21, $10
    db $ff, $f8, $13, $10
    db $ff, $f0, $12, $10
    db $ff, $e8, $11, $10
    db $80

; C: OAM list DE of the table 5D47
OamList_B01_5D47_DE::
    db $d9, $0d, $5d, $50
    db $e1, $09, $5f, $70
    db $e1, $11, $5e, $70
    db $e9, $0f, $4f, $70
    db $e9, $17, $4e, $70
    db $f1, $10, $3f, $70
    db $f1, $18, $3e, $70
    db $f9, $0f, $2f, $70
    db $f9, $17, $2e, $70
    db $01, $0f, $1f, $70
    db $01, $17, $1e, $70
    db $20, $e4, $54, $10
    db $18, $e8, $45, $10
    db $18, $e0, $44, $10
    db $10, $eb, $35, $10
    db $10, $e3, $34, $10
    db $08, $f8, $27, $10
    db $08, $f0, $26, $10
    db $08, $e8, $25, $10
    db $00, $f8, $17, $10
    db $00, $f0, $16, $10
    db $80

; C: OAM list DF of the table 5D47
OamList_B01_5D47_DF::
    db $0f, $15, $10, $10
    db $11, $01, $3d, $10
    db $11, $f9, $3c, $10
    db $09, $f9, $2c, $10
    db $11, $f1, $58, $10
    db $09, $f1, $48, $10
    db $09, $e9, $47, $10
    db $01, $e9, $37, $10
    db $01, $f1, $38, $10
    db $01, $f9, $39, $10
    db $17, $25, $29, $10
    db $17, $1d, $28, $10
    db $0f, $25, $19, $10
    db $0f, $1d, $18, $10
    db $07, $0d, $23, $30
    db $07, $15, $22, $30
    db $07, $1d, $21, $30
    db $ff, $0d, $13, $30
    db $ff, $15, $12, $30
    db $ff, $1d, $11, $30
    db $80

; C: OAM list E0 of the table 5D47
OamList_B01_5D47_E0::
    db $0f, $15, $10, $00
    db $11, $09, $3d, $10
    db $11, $01, $3c, $10
    db $09, $01, $2c, $10
    db $11, $f9, $3b, $10
    db $11, $f1, $3a, $10
    db $09, $f9, $2b, $10
    db $09, $f1, $2a, $10
    db $01, $f9, $1b, $10
    db $01, $f1, $1a, $10
    db $17, $25, $29, $10
    db $17, $1d, $28, $10
    db $0f, $25, $19, $10
    db $0f, $1d, $18, $10
    db $07, $0d, $23, $30
    db $07, $15, $22, $30
    db $07, $1d, $21, $30
    db $ff, $0d, $13, $30
    db $ff, $15, $12, $30
    db $ff, $1d, $11, $30
    db $80

; C: OAM list E1 of the table 5D47
OamList_B01_5D47_E1::
    db $0f, $19, $10, $10
    db $11, $09, $3d, $10
    db $11, $01, $3c, $10
    db $09, $01, $2c, $10
    db $11, $f9, $3b, $10
    db $11, $f1, $3a, $10
    db $09, $f9, $2b, $10
    db $09, $f1, $2a, $10
    db $01, $f9, $1b, $10
    db $01, $f1, $1a, $10
    db $17, $2a, $29, $10
    db $17, $22, $28, $10
    db $0f, $29, $19, $10
    db $0f, $21, $18, $10
    db $07, $10, $23, $30
    db $07, $18, $22, $30
    db $07, $20, $21, $30
    db $ff, $10, $13, $30
    db $ff, $18, $12, $30
    db $ff, $20, $11, $30
    db $80

; C: OAM list E2 of the table 5D47
OamList_B01_5D47_E2::
    db $f2, $18, $10, $50
    db $11, $09, $3d, $10
    db $11, $01, $3c, $10
    db $09, $01, $2c, $10
    db $11, $f9, $3b, $10
    db $11, $f1, $3a, $10
    db $09, $f9, $2b, $10
    db $09, $f1, $2a, $10
    db $01, $f9, $1b, $10
    db $01, $f1, $1a, $10
    db $ea, $28, $29, $50
    db $ea, $20, $28, $50
    db $f2, $28, $19, $50
    db $f2, $20, $18, $50
    db $fa, $10, $23, $70
    db $fa, $18, $22, $70
    db $fa, $20, $21, $70
    db $02, $10, $13, $70
    db $02, $18, $12, $70
    db $02, $20, $11, $70
    db $80

; C: OAM list E3 of the table 5D47
OamList_B01_5D47_E3::
    db $11, $09, $3d, $30
    db $11, $11, $3c, $30
    db $11, $02, $3d, $10
    db $11, $fa, $3c, $10
    db $09, $11, $2c, $30
    db $09, $fa, $2c, $10
    db $11, $19, $58, $30
    db $09, $19, $48, $30
    db $09, $21, $47, $30
    db $01, $11, $39, $30
    db $01, $19, $38, $30
    db $01, $21, $37, $30
    db $11, $f2, $58, $10
    db $09, $f2, $48, $10
    db $09, $ea, $47, $10
    db $01, $fa, $39, $10
    db $01, $f2, $38, $10
    db $01, $ea, $37, $10
    db $80

; C: OAM list E4 of the table 5D47
OamList_B01_5D47_E4::
    db $28, $02, $5d, $10
    db $20, $04, $5f, $10
    db $20, $fc, $5e, $10
    db $18, $fe, $4f, $10
    db $18, $f6, $4e, $10
    db $10, $fc, $3f, $10
    db $10, $f4, $3e, $10
    db $08, $fc, $2f, $10
    db $08, $f4, $2e, $10
    db $00, $fc, $1f, $10
    db $00, $f4, $1e, $10
    db $11, $08, $3d, $30
    db $11, $10, $3c, $30
    db $09, $10, $2c, $30
    db $11, $18, $58, $30
    db $09, $18, $48, $30
    db $09, $20, $47, $30
    db $01, $10, $39, $30
    db $01, $18, $38, $30
    db $01, $20, $37, $30
    db $80

; C: OAM list E5 of the table 5D47
OamList_B01_5D47_E5::
    db $18, $16, $35, $10
    db $18, $0e, $34, $10
    db $28, $0c, $5d, $30
    db $20, $0a, $5f, $30
    db $20, $12, $5e, $30
    db $10, $0f, $3f, $30
    db $10, $17, $3e, $30
    db $08, $0e, $2f, $30
    db $08, $16, $2e, $30
    db $00, $0c, $1f, $30
    db $00, $14, $1e, $30
    db $f0, $00, $3d, $50
    db $f0, $f8, $3c, $50
    db $f8, $f8, $2c, $50
    db $f0, $f0, $58, $50
    db $f8, $f0, $48, $50
    db $f8, $e8, $47, $50
    db $00, $f8, $39, $50
    db $00, $f0, $38, $50
    db $00, $e8, $37, $50
    db $80

; C: OAM list E6 of the table 5D47
OamList_B01_5D47_E6::
    db $f2, $19, $10, $50
    db $ea, $29, $29, $50
    db $ea, $21, $28, $50
    db $f2, $29, $19, $50
    db $f2, $21, $18, $50
    db $fa, $11, $23, $70
    db $fa, $19, $22, $70
    db $fa, $21, $21, $70
    db $02, $11, $13, $70
    db $02, $19, $12, $70
    db $02, $21, $11, $70
    db $ff, $fb, $17, $10
    db $ff, $f3, $16, $10
    db $07, $f4, $48, $50
    db $07, $ec, $47, $50
    db $17, $ee, $35, $30
    db $17, $f6, $34, $30
    db $27, $f7, $5d, $10
    db $1f, $f9, $5f, $10
    db $1f, $f1, $5e, $10
    db $0f, $f5, $3f, $10
    db $0f, $ed, $3e, $10
    db $80

; C: OAM list E7 of the table 5D47
OamList_B01_5D47_E7::
    db $ea, $e7, $54, $70
    db $f2, $eb, $45, $50
    db $f2, $e3, $44, $50
    db $ea, $28, $29, $50
    db $ea, $20, $28, $50
    db $f2, $28, $19, $50
    db $f2, $20, $18, $50
    db $fa, $10, $23, $70
    db $fa, $18, $22, $70
    db $fa, $20, $21, $70
    db $02, $10, $13, $70
    db $02, $18, $12, $70
    db $02, $20, $11, $70
    db $fa, $f8, $23, $50
    db $fa, $f0, $22, $50
    db $fa, $e8, $21, $50
    db $02, $f8, $13, $50
    db $02, $f0, $12, $50
    db $02, $e8, $11, $50
    db $80

; C: OAM list E8 of the table 5D47
OamList_B01_5D47_E8::
    db $ea, $e7, $54, $70
    db $f2, $eb, $45, $50
    db $f2, $e3, $44, $50
    db $fa, $f8, $23, $50
    db $fa, $f0, $22, $50
    db $fa, $e8, $21, $50
    db $02, $f8, $13, $50
    db $02, $f0, $12, $50
    db $02, $e8, $11, $50
    db $eb, $1c, $54, $50
    db $f3, $20, $45, $50
    db $f3, $18, $44, $50
    db $fb, $0f, $23, $70
    db $fb, $17, $22, $70
    db $fb, $1f, $21, $70
    db $03, $10, $13, $70
    db $03, $18, $12, $70
    db $03, $20, $11, $70
    db $80

; C: OAM list E9 of the table 5D47
OamList_B01_5D47_E9::
    db $b8, $01, $5d, $50
    db $c0, $03, $5f, $50
    db $c0, $fb, $5e, $50
    db $c8, $fd, $4f, $50
    db $c8, $f5, $4e, $50
    db $d0, $fb, $3f, $50
    db $d0, $f3, $3e, $50
    db $d8, $fb, $2f, $50
    db $d8, $f3, $2e, $50
    db $e0, $fb, $1f, $50
    db $e0, $f3, $1e, $50
    db $80

; C: OAM list EA of the table 5D47
OamList_B01_5D47_EA::
    db $b8, $07, $5d, $70
    db $c0, $05, $5f, $70
    db $c0, $0d, $5e, $70
    db $c8, $0b, $4f, $70
    db $c8, $13, $4e, $70
    db $d0, $0d, $3f, $70
    db $d0, $15, $3e, $70
    db $d8, $0d, $2f, $70
    db $d8, $15, $2e, $70
    db $e0, $0d, $1f, $70
    db $e0, $15, $1e, $70
    db $80

; C: OAM list EB of the table 5D47
OamList_B01_5D47_EB::
    db $d0, $00, $3d, $50
    db $d0, $f8, $3c, $50
    db $d8, $f8, $2c, $50
    db $d0, $f0, $58, $50
    db $d8, $f0, $48, $50
    db $d8, $e8, $47, $50
    db $e0, $f8, $39, $50
    db $e0, $f0, $38, $50
    db $e0, $e8, $37, $50
    db $80

; C: OAM list EC of the table 5D47
OamList_B01_5D47_EC::
    db $d0, $08, $3d, $70
    db $d0, $10, $3c, $70
    db $d8, $10, $2c, $70
    db $d0, $18, $58, $70
    db $d8, $18, $48, $70
    db $d8, $20, $47, $70
    db $e0, $10, $39, $70
    db $e0, $18, $38, $70
    db $e0, $20, $37, $70
    db $80

; C: OAM list ED of the table 5D47
OamList_B01_5D47_ED::
    db $ef, $d9, $59, $10
    db $ef, $e0, $5a, $10
    db $ef, $e8, $5b, $10
    db $e7, $e0, $4a, $10
    db $e7, $e8, $4b, $10
    db $e7, $f0, $4c, $10
    db $e7, $f8, $23, $10
    db $df, $f8, $13, $10
    db $df, $f0, $12, $10
    db $df, $e8, $11, $10
    db $80

; C: OAM list EE of the table 5D47
OamList_B01_5D47_EE::
    db $ef, $2f, $59, $30
    db $ef, $28, $5a, $30
    db $ef, $20, $5b, $30
    db $e7, $28, $4a, $30
    db $e7, $20, $4b, $30
    db $e7, $18, $4c, $30
    db $e7, $10, $23, $30
    db $df, $10, $13, $30
    db $df, $18, $12, $30
    db $df, $20, $11, $30
    db $80

; C: OAM list EF of the table 5D47
OamList_B01_5D47_EF::
    db $e0, $f8, $39, $50
    db $c4, $e4, $54, $50
    db $cc, $e8, $45, $50
    db $cc, $e0, $44, $50
    db $d4, $eb, $35, $50
    db $d4, $e3, $34, $50
    db $dc, $f0, $26, $50
    db $dc, $e8, $25, $50
    db $e4, $f0, $16, $50
    db $80

; C: OAM list F0 of the table 5D47
OamList_B01_5D47_F0::
    db $e0, $10, $39, $70
    db $c4, $24, $54, $70
    db $cc, $20, $45, $70
    db $cc, $28, $44, $70
    db $d4, $1d, $35, $70
    db $d4, $25, $34, $70
    db $dc, $18, $26, $70
    db $dc, $20, $25, $70
    db $e4, $18, $16, $70
    db $80

; C: OAM list F1 of the table 5D47
OamList_B01_5D47_F1::
    db $f0, $09, $3d, $10
    db $f0, $01, $3c, $10
    db $e8, $01, $2c, $10
    db $f0, $f9, $3b, $10
    db $f0, $f1, $3a, $10
    db $e8, $f9, $2b, $10
    db $e8, $f1, $2a, $10
    db $e0, $f9, $1b, $10
    db $e0, $f1, $1a, $10
    db $80

; C: OAM list F2 of the table 5D47
OamList_B01_5D47_F2::
    db $f0, $ff, $3d, $30
    db $f0, $07, $3c, $30
    db $e8, $07, $2c, $30
    db $f0, $0f, $3b, $30
    db $f0, $17, $3a, $30
    db $e8, $0f, $2b, $30
    db $e8, $17, $2a, $30
    db $e0, $0f, $1b, $30
    db $e0, $17, $1a, $30
    db $80

; C: OAM list F3 of the table 5D47
OamList_B01_5D47_F3::
    db $d0, $09, $3d, $50
    db $d0, $01, $3c, $50
    db $d8, $01, $2c, $50
    db $d0, $f9, $3b, $50
    db $d0, $f1, $3a, $50
    db $d8, $f9, $2b, $50
    db $d8, $f1, $2a, $50
    db $e0, $f9, $1b, $50
    db $e0, $f1, $1a, $50
    db $80

; C: OAM list F4 of the table 5D47
OamList_B01_5D47_F4::
    db $d0, $ff, $3d, $70
    db $d0, $07, $3c, $70
    db $d8, $07, $2c, $70
    db $d0, $0f, $3b, $70
    db $d0, $17, $3a, $70
    db $d8, $0f, $2b, $70
    db $d8, $17, $2a, $70
    db $e0, $0f, $1b, $70
    db $e0, $17, $1a, $70
    db $80

; C: OAM list F5 of the table 5D47
OamList_B01_5D47_F5::
    db $38, $c0, $fc, $00
    db $38, $b8, $fc, $00
    db $28, $b8, $fc, $00
    db $28, $c0, $fc, $00
    db $18, $c0, $fc, $00
    db $18, $b8, $fc, $00
    db $08, $c0, $fc, $00
    db $08, $b8, $fc, $00
    db $f8, $c0, $fc, $00
    db $f8, $b8, $fc, $00
    db $e8, $b8, $fc, $00
    db $e8, $c0, $fc, $00
    db $d8, $c0, $fc, $00
    db $d8, $b8, $fc, $00
    db $38, $50, $fc, $00
    db $38, $48, $fc, $00
    db $28, $48, $fc, $00
    db $28, $50, $fc, $00
    db $18, $50, $fc, $00
    db $18, $48, $fc, $00
    db $08, $50, $fc, $00
    db $08, $48, $fc, $00
    db $f8, $50, $fc, $00
    db $f8, $48, $fc, $00
    db $e8, $48, $fc, $00
    db $e8, $50, $fc, $00
    db $d8, $50, $fc, $00
    db $d8, $48, $fc, $00
    db $80

; C: zero fill to the end of the bank
Bank01_Padding_7889::
    INCBIN "data/bank_01/Bank01_Padding_7889.bin" ; $7889, 1911 bytes

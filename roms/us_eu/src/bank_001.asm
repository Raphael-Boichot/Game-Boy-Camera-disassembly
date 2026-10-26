; Game Boy Camera (USA, Europe), bank $01. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

; I: 249 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
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

; I: OAM list 97 of the table 4000
OamList_B01_4000_97::
    db $11, $e0, $5a, $00
    db $11, $d8, $59, $00
    db $11, $d0, $58, $00
    db $11, $c8, $57, $00
    db $11, $c0, $fd, $00
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

; I: OAM list 98 of the table 4000
OamList_B01_4000_98::
    db $10
    db $18
    db $62
    db $00
    db $10
    db $10
    db $61
    db $00
    db $10
    db $08
    db $60
    db $00
    db $10
    db $00
    db $5f
    db $00
    db $10
    db $f8
    db $5e
    db $00
    db $fe
    db $f9
    db $7a
    db $20
    db $fe
    db $01
    db $79
    db $20
    db $fe
    db $09
    db $78
    db $20
    db $fe
    db $11
    db $77
    db $20
    db $fe
    db $19
    db $76
    db $20
    db $06
    db $f9
    db $7f
    db $20
    db $06
    db $01
    db $7e
    db $20
    db $06
    db $09
    db $7d
    db $20
    db $06
    db $11
    db $7c
    db $20
    db $06
    db $19
    db $7b
    db $20
    db $80

; I: OAM list 99 of the table 4000
OamList_B01_4000_99::
    db $10
    db $18
    db $62
    db $00
    db $10
    db $10
    db $61
    db $00
    db $10
    db $08
    db $60
    db $00
    db $10
    db $00
    db $5f
    db $00
    db $10
    db $f8
    db $5e
    db $00
    db $fe
    db $12
    db $6d
    db $20
    db $06
    db $12
    db $6c
    db $20
    db $f6
    db $00
    db $71
    db $20
    db $f6
    db $08
    db $70
    db $20
    db $f6
    db $10
    db $6f
    db $20
    db $fe
    db $02
    db $69
    db $20
    db $fe
    db $0a
    db $68
    db $20
    db $06
    db $02
    db $6b
    db $20
    db $06
    db $0a
    db $6a
    db $20
    db $80

; I: OAM list 9A of the table 4000
OamList_B01_4000_9A::
    db $10
    db $40
    db $67
    db $00
    db $10
    db $38
    db $66
    db $00
    db $10
    db $30
    db $65
    db $00
    db $10
    db $28
    db $64
    db $00
    db $10
    db $20
    db $63
    db $00
    db $fe
    db $47
    db $7a
    db $00
    db $fe
    db $3f
    db $79
    db $00
    db $fe
    db $37
    db $78
    db $00
    db $06
    db $47
    db $7f
    db $00
    db $06
    db $3f
    db $7e
    db $00
    db $06
    db $37
    db $7d
    db $00
    db $fe
    db $2f
    db $77
    db $00
    db $fe
    db $27
    db $76
    db $00
    db $06
    db $2f
    db $7c
    db $00
    db $06
    db $27
    db $7b
    db $00
    db $80

; I: OAM list 9B of the table 4000
OamList_B01_4000_9B::
    db $10
    db $40
    db $67
    db $00
    db $10
    db $38
    db $66
    db $00
    db $10
    db $30
    db $65
    db $00
    db $10
    db $28
    db $64
    db $00
    db $10
    db $20
    db $63
    db $00
    db $fe
    db $2b
    db $6d
    db $00
    db $06
    db $2b
    db $6c
    db $00
    db $f6
    db $3d
    db $71
    db $00
    db $f6
    db $35
    db $70
    db $00
    db $f6
    db $2d
    db $6f
    db $00
    db $fe
    db $3b
    db $69
    db $00
    db $fe
    db $33
    db $68
    db $00
    db $06
    db $3b
    db $6b
    db $00
    db $06
    db $33
    db $6a
    db $00
    db $80

; I: OAM list 9C of the table 4000
OamList_B01_4000_9C::
    db $11
    db $e0
    db $5a
    db $00
    db $11
    db $d8
    db $59
    db $00
    db $11
    db $d0
    db $58
    db $00
    db $11
    db $c8
    db $57
    db $00
    db $11
    db $c0
    db $fd
    db $00
    db $fe
    db $de
    db $7a
    db $00
    db $fe
    db $d6
    db $79
    db $00
    db $fe
    db $ce
    db $78
    db $00
    db $fe
    db $c6
    db $77
    db $00
    db $fe
    db $be
    db $76
    db $00
    db $06
    db $de
    db $7f
    db $00
    db $06
    db $d6
    db $7e
    db $00
    db $06
    db $ce
    db $7d
    db $00
    db $06
    db $c6
    db $7c
    db $00
    db $06
    db $be
    db $7b
    db $00
    db $80

; C: OAM list 9D of the table 4000
OamList_B01_4000_9D::
    db $18
    db $18
    db $09
    db $00
    db $18
    db $10
    db $08
    db $00
    db $18
    db $08
    db $07
    db $00
    db $10
    db $18
    db $06
    db $00
    db $10
    db $10
    db $05
    db $00
    db $10
    db $08
    db $04
    db $00
    db $80

; C: OAM list 9E of the table 4000
OamList_B01_4000_9E::
    db $18
    db $18
    db $0f
    db $00
    db $18
    db $10
    db $0e
    db $00
    db $18
    db $08
    db $0d
    db $00
    db $10
    db $18
    db $0c
    db $00
    db $10
    db $10
    db $0b
    db $00
    db $10
    db $08
    db $0a
    db $00
    db $80

; C: OAM list 9F of the table 4000
OamList_B01_4000_9F::
    db $10
    db $08
    db $77
    db $10
    db $10
    db $00
    db $76
    db $10
    db $08
    db $08
    db $67
    db $10
    db $08
    db $00
    db $66
    db $10
    db $80

; C: OAM list A0 of the table 4000
OamList_B01_4000_A0::
    db $10
    db $08
    db $79
    db $10
    db $10
    db $00
    db $78
    db $10
    db $08
    db $08
    db $69
    db $10
    db $08
    db $00
    db $68
    db $10
    db $80

; C: OAM list A1 of the table 4000
OamList_B01_4000_A1::
    db $10
    db $08
    db $7b
    db $10
    db $10
    db $00
    db $7a
    db $10
    db $08
    db $08
    db $6b
    db $10
    db $08
    db $00
    db $6a
    db $10
    db $80

; C: OAM list A2 of the table 4000
OamList_B01_4000_A2::
    db $08
    db $00
    db $7f
    db $10
    db $08
    db $08
    db $7f
    db $30
    db $80

; C: OAM list A3 of the table 4000
OamList_B01_4000_A3::
    db $10
    db $08
    db $7f
    db $70
    db $10
    db $00
    db $7f
    db $50
    db $80

; C: OAM list A4 of the table 4000
OamList_B01_4000_A4::
    db $08
    db $08
    db $7e
    db $50
    db $10
    db $08
    db $7e
    db $10
    db $80

; C: OAM list A5 of the table 4000
OamList_B01_4000_A5::
    db $08
    db $00
    db $7e
    db $70
    db $10
    db $00
    db $7e
    db $30
    db $80

; C: OAM list A6 of the table 4000
OamList_B01_4000_A6::
    db $20
    db $08
    db $7d
    db $10
    db $20
    db $00
    db $7c
    db $10
    db $18
    db $08
    db $6d
    db $10
    db $18
    db $00
    db $6c
    db $10
    db $80

; C: OAM list A7 of the table 4000
OamList_B01_4000_A7::
    db $22
    db $09
    db $7d
    db $10
    db $22
    db $01
    db $7c
    db $10
    db $1a
    db $09
    db $6d
    db $10
    db $1a
    db $01
    db $6c
    db $10
    db $80

; C: OAM list A8 of the table 4000
OamList_B01_4000_A8::
    db $19
    db $0c
    db $7d
    db $10
    db $19
    db $04
    db $7c
    db $10
    db $11
    db $0c
    db $6d
    db $10
    db $11
    db $04
    db $6c
    db $10
    db $80

; C: OAM list A9 of the table 4000
OamList_B01_4000_A9::
    db $17
    db $0a
    db $7d
    db $10
    db $17
    db $02
    db $7c
    db $10
    db $0f
    db $0a
    db $6d
    db $10
    db $0f
    db $02
    db $6c
    db $10
    db $80

; C: OAM list AA of the table 4000
OamList_B01_4000_AA::
    db $18
    db $0a
    db $7d
    db $10
    db $18
    db $02
    db $7c
    db $10
    db $10
    db $0a
    db $6d
    db $10
    db $10
    db $02
    db $6c
    db $10
    db $80

; C: OAM list AB of the table 4000
OamList_B01_4000_AB::
    db $f8
    db $08
    db $7d
    db $50
    db $f8
    db $00
    db $7c
    db $50
    db $00
    db $08
    db $6d
    db $50
    db $00
    db $00
    db $6c
    db $50
    db $80

; C: OAM list AC of the table 4000
OamList_B01_4000_AC::
    db $f6
    db $09
    db $7d
    db $50
    db $f6
    db $01
    db $7c
    db $50
    db $fe
    db $09
    db $6d
    db $50
    db $fe
    db $01
    db $6c
    db $50
    db $80

; C: OAM list AD of the table 4000
OamList_B01_4000_AD::
    db $ff
    db $0c
    db $7d
    db $50
    db $ff
    db $04
    db $7c
    db $50
    db $07
    db $0c
    db $6d
    db $50
    db $07
    db $04
    db $6c
    db $50
    db $80

; C: OAM list AE of the table 4000
OamList_B01_4000_AE::
    db $01
    db $0a
    db $7d
    db $50
    db $01
    db $02
    db $7c
    db $50
    db $09
    db $0a
    db $6d
    db $50
    db $09
    db $02
    db $6c
    db $50
    db $80

; C: OAM list AF of the table 4000
OamList_B01_4000_AF::
    db $00
    db $0a
    db $7d
    db $50
    db $00
    db $02
    db $7c
    db $50
    db $08
    db $0a
    db $6d
    db $50
    db $08
    db $02
    db $6c
    db $50
    db $80

; C: OAM list B0 of the table 4000
OamList_B01_4000_B0::
    db $15
    db $f9
    db $7d
    db $10
    db $15
    db $f1
    db $7c
    db $10
    db $0d
    db $f9
    db $6d
    db $10
    db $0d
    db $f1
    db $6c
    db $10
    db $80

; C: OAM list B1 of the table 4000
OamList_B01_4000_B1::
    db $16
    db $f8
    db $7d
    db $10
    db $16
    db $f0
    db $7c
    db $10
    db $0e
    db $f8
    db $6d
    db $10
    db $0e
    db $f0
    db $6c
    db $10
    db $80

; C: OAM list B2 of the table 4000
OamList_B01_4000_B2::
    db $18
    db $01
    db $7d
    db $10
    db $18
    db $f9
    db $7c
    db $10
    db $10
    db $01
    db $6d
    db $10
    db $10
    db $f9
    db $6c
    db $10
    db $80

; C: OAM list B3 of the table 4000
OamList_B01_4000_B3::
    db $15
    db $04
    db $7d
    db $10
    db $15
    db $fc
    db $7c
    db $10
    db $0d
    db $04
    db $6d
    db $10
    db $0d
    db $fc
    db $6c
    db $10
    db $80

; C: OAM list B4 of the table 4000
OamList_B01_4000_B4::
    db $15
    db $03
    db $7d
    db $10
    db $15
    db $fb
    db $7c
    db $10
    db $0d
    db $03
    db $6d
    db $10
    db $0d
    db $fb
    db $6c
    db $10
    db $80

; C: OAM list B5 of the table 4000
OamList_B01_4000_B5::
    db $04
    db $0f
    db $7d
    db $70
    db $04
    db $17
    db $7c
    db $70
    db $0c
    db $0f
    db $6d
    db $70
    db $0c
    db $17
    db $6c
    db $70
    db $80

; C: OAM list B6 of the table 4000
OamList_B01_4000_B6::
    db $03
    db $10
    db $7d
    db $70
    db $03
    db $18
    db $7c
    db $70
    db $0b
    db $10
    db $6d
    db $70
    db $0b
    db $18
    db $6c
    db $70
    db $80

; C: OAM list B7 of the table 4000
OamList_B01_4000_B7::
    db $00
    db $07
    db $7d
    db $70
    db $00
    db $0f
    db $7c
    db $70
    db $08
    db $07
    db $6d
    db $70
    db $08
    db $0f
    db $6c
    db $70
    db $80

; C: OAM list B8 of the table 4000
OamList_B01_4000_B8::
    db $03
    db $04
    db $7d
    db $70
    db $03
    db $0c
    db $7c
    db $70
    db $0b
    db $04
    db $6d
    db $70
    db $0b
    db $0c
    db $6c
    db $70
    db $80

; C: OAM list B9 of the table 4000
OamList_B01_4000_B9::
    db $03
    db $05
    db $7d
    db $70
    db $03
    db $0d
    db $7c
    db $70
    db $0b
    db $05
    db $6d
    db $70
    db $0b
    db $0d
    db $6c
    db $70
    db $80

; C: OAM list BA of the table 4000
OamList_B01_4000_BA::
    db $20
    db $18
    db $68
    db $10
    db $20
    db $10
    db $67
    db $10
    db $20
    db $08
    db $66
    db $10
    db $20
    db $00
    db $65
    db $10
    db $20
    db $f8
    db $64
    db $10
    db $18
    db $18
    db $63
    db $10
    db $18
    db $10
    db $62
    db $10
    db $18
    db $08
    db $61
    db $10
    db $18
    db $00
    db $60
    db $10
    db $18
    db $f8
    db $5f
    db $10
    db $10
    db $18
    db $5e
    db $10
    db $10
    db $10
    db $5d
    db $10
    db $10
    db $08
    db $5c
    db $10
    db $10
    db $00
    db $5b
    db $10
    db $10
    db $f8
    db $5a
    db $10
    db $08
    db $18
    db $59
    db $10
    db $08
    db $10
    db $58
    db $10
    db $08
    db $08
    db $57
    db $10
    db $08
    db $00
    db $56
    db $10
    db $08
    db $f8
    db $55
    db $10
    db $00
    db $18
    db $54
    db $10
    db $00
    db $10
    db $53
    db $10
    db $00
    db $08
    db $52
    db $10
    db $00
    db $00
    db $51
    db $10
    db $00
    db $f8
    db $50
    db $10
    db $80

; C: OAM list BB of the table 4000
OamList_B01_4000_BB::
    db $08
    db $00
    db $77
    db $70
    db $08
    db $08
    db $76
    db $70
    db $10
    db $00
    db $67
    db $70
    db $10
    db $08
    db $66
    db $70
    db $80

; C: OAM list BC of the table 4000
OamList_B01_4000_BC::
    db $08
    db $00
    db $79
    db $70
    db $08
    db $08
    db $78
    db $70
    db $10
    db $00
    db $69
    db $70
    db $10
    db $08
    db $68
    db $70
    db $80

; C: OAM list BD of the table 4000
OamList_B01_4000_BD::
    db $08
    db $00
    db $7b
    db $70
    db $08
    db $08
    db $7a
    db $70
    db $10
    db $00
    db $6b
    db $70
    db $10
    db $08
    db $6a
    db $70
    db $80

; C: OAM list BE of the table 4000
OamList_B01_4000_BE::
    db $10
    db $08
    db $73
    db $30
    db $08
    db $08
    db $63
    db $30
    db $10
    db $00
    db $73
    db $10
    db $08
    db $00
    db $63
    db $10
    db $80

; C: OAM list BF of the table 4000
OamList_B01_4000_BF::
    db $16
    db $08
    db $70
    db $30
    db $16
    db $00
    db $70
    db $10
    db $0d
    db $08
    db $75
    db $10
    db $0d
    db $00
    db $74
    db $10
    db $05
    db $08
    db $65
    db $10
    db $05
    db $00
    db $64
    db $10
    db $80

; C: OAM list C0 of the table 4000
OamList_B01_4000_C0::
    db $16
    db $08
    db $60
    db $30
    db $16
    db $00
    db $60
    db $10
    db $0d
    db $08
    db $76
    db $30
    db $05
    db $08
    db $66
    db $30
    db $0d
    db $00
    db $76
    db $10
    db $05
    db $00
    db $66
    db $10
    db $80

; C: OAM list C1 of the table 4000
OamList_B01_4000_C1::
    db $16
    db $08
    db $60
    db $30
    db $16
    db $00
    db $60
    db $10
    db $0c
    db $08
    db $76
    db $30
    db $05
    db $08
    db $66
    db $30
    db $0c
    db $00
    db $76
    db $10
    db $05
    db $00
    db $66
    db $10
    db $80

; C: OAM list C2 of the table 4000
OamList_B01_4000_C2::
    db $16
    db $08
    db $70
    db $30
    db $16
    db $00
    db $70
    db $10
    db $0e
    db $00
    db $75
    db $30
    db $0e
    db $08
    db $74
    db $30
    db $06
    db $00
    db $65
    db $30
    db $06
    db $08
    db $64
    db $30
    db $80

; C: OAM list C3 of the table 4000
OamList_B01_4000_C3::
    db $10
    db $08
    db $77
    db $30
    db $08
    db $08
    db $67
    db $30
    db $10
    db $00
    db $77
    db $10
    db $08
    db $00
    db $67
    db $10
    db $80

; C: OAM list C4 of the table 4000
OamList_B01_4000_C4::
    db $08
    db $08
    db $61
    db $30
    db $08
    db $00
    db $61
    db $10
    db $10
    db $08
    db $73
    db $30
    db $10
    db $00
    db $73
    db $10
    db $80

; C: OAM list C5 of the table 4000
OamList_B01_4000_C5::
    db $08
    db $08
    db $62
    db $30
    db $08
    db $00
    db $62
    db $10
    db $10
    db $08
    db $73
    db $30
    db $10
    db $00
    db $73
    db $10
    db $80

; C: OAM list C6 of the table 4000
OamList_B01_4000_C6::
    db $10
    db $08
    db $72
    db $30
    db $10
    db $00
    db $72
    db $10
    db $08
    db $08
    db $63
    db $30
    db $08
    db $00
    db $63
    db $10
    db $80

; C: OAM list C7 of the table 4000
OamList_B01_4000_C7::
    db $10
    db $08
    db $71
    db $30
    db $10
    db $00
    db $71
    db $10
    db $08
    db $08
    db $63
    db $30
    db $08
    db $00
    db $63
    db $10
    db $80

; C: OAM list C8 of the table 4000
OamList_B01_4000_C8::
    db $10
    db $08
    db $71
    db $30
    db $10
    db $00
    db $71
    db $10
    db $08
    db $08
    db $61
    db $30
    db $08
    db $00
    db $61
    db $10
    db $80

; C: OAM list C9 of the table 4000
OamList_B01_4000_C9::
    db $08
    db $08
    db $62
    db $30
    db $08
    db $00
    db $62
    db $10
    db $10
    db $08
    db $72
    db $30
    db $10
    db $00
    db $72
    db $10
    db $80

; C: OAM list CA of the table 4000
OamList_B01_4000_CA::
    db $13
    db $09
    db $d4
    db $10
    db $13
    db $01
    db $d3
    db $10
    db $0a
    db $09
    db $f1
    db $10
    db $0a
    db $01
    db $f0
    db $10
    db $02
    db $09
    db $e0
    db $10
    db $80

; C: OAM list CB of the table 4000
OamList_B01_4000_CB::
    db $13
    db $09
    db $d4
    db $10
    db $13
    db $01
    db $d3
    db $10
    db $02
    db $09
    db $f3
    db $50
    db $02
    db $01
    db $f2
    db $50
    db $0a
    db $09
    db $f3
    db $10
    db $0a
    db $01
    db $f2
    db $10
    db $80

; C: OAM list CC of the table 4000
OamList_B01_4000_CC::
    db $02
    db $01
    db $cf
    db $10
    db $13
    db $09
    db $d6
    db $10
    db $13
    db $01
    db $d5
    db $10
    db $0a
    db $09
    db $d2
    db $10
    db $0a
    db $01
    db $d1
    db $10
    db $02
    db $09
    db $d0
    db $10
    db $80

; C: OAM list CD of the table 4000
OamList_B01_4000_CD::
    db $13
    db $09
    db $df
    db $10
    db $13
    db $01
    db $de
    db $10
    db $0a
    db $01
    db $e2
    db $70
    db $0a
    db $09
    db $e1
    db $70
    db $02
    db $09
    db $e2
    db $10
    db $02
    db $01
    db $e1
    db $10
    db $80

; C: OAM list CE of the table 4000
OamList_B01_4000_CE::
    db $13
    db $fc
    db $d7
    db $10
    db $13
    db $0c
    db $d9
    db $10
    db $13
    db $04
    db $d8
    db $10
    db $80

; C: OAM list CF of the table 4000
OamList_B01_4000_CF::
    db $1d
    db $08
    db $5b
    db $10
    db $1d
    db $00
    db $5a
    db $10
    db $f7
    db $08
    db $59
    db $10
    db $f7
    db $00
    db $58
    db $10
    db $80

; C: OAM list D0 of the table 4000
OamList_B01_4000_D0::
    db $1e
    db $08
    db $5b
    db $10
    db $1e
    db $00
    db $5a
    db $10
    db $f7
    db $08
    db $59
    db $10
    db $f7
    db $00
    db $58
    db $10
    db $80

; C: OAM list D1 of the table 4000
OamList_B01_4000_D1::
    db $1d
    db $08
    db $5b
    db $10
    db $1d
    db $00
    db $5a
    db $10
    db $f6
    db $08
    db $59
    db $10
    db $f6
    db $00
    db $58
    db $10
    db $80

; C: OAM list D2 of the table 4000
OamList_B01_4000_D2::
    db $18
    db $10
    db $7d
    db $00
    db $18
    db $08
    db $7c
    db $00
    db $10
    db $10
    db $6d
    db $00
    db $10
    db $08
    db $6c
    db $00
    db $80

; C: OAM list D3 of the table 4000
OamList_B01_4000_D3::
    db $18
    db $10
    db $6f
    db $00
    db $18
    db $08
    db $6e
    db $00
    db $10
    db $10
    db $5f
    db $00
    db $10
    db $08
    db $5e
    db $00
    db $80

; C: OAM list D4 of the table 4000
OamList_B01_4000_D4::
    db $08
    db $08
    db $57
    db $00
    db $08
    db $00
    db $56
    db $00
    db $08
    db $f8
    db $55
    db $00
    db $08
    db $f0
    db $54
    db $00
    db $80

; C: OAM list D5 of the table 4000
OamList_B01_4000_D5::
    db $08
    db $08
    db $7e
    db $50
    db $10
    db $08
    db $7e
    db $10
    db $80

; C: OAM list D6 of the table 4000
OamList_B01_4000_D6::
    db $08
    db $00
    db $7e
    db $70
    db $10
    db $00
    db $7e
    db $30
    db $80

; C: OAM list D7 of the table 4000
OamList_B01_4000_D7::
    db $28
    db $10
    db $1d
    db $00
    db $28
    db $08
    db $1e
    db $00
    db $20
    db $08
    db $21
    db $00
    db $18
    db $30
    db $29
    db $00
    db $18
    db $28
    db $2a
    db $00
    db $18
    db $20
    db $2b
    db $00
    db $18
    db $18
    db $2c
    db $00
    db $18
    db $10
    db $2d
    db $00
    db $18
    db $08
    db $2e
    db $00
    db $10
    db $30
    db $37
    db $00
    db $10
    db $28
    db $38
    db $00
    db $10
    db $20
    db $39
    db $00
    db $10
    db $18
    db $3a
    db $00
    db $10
    db $10
    db $3b
    db $00
    db $08
    db $28
    db $43
    db $00
    db $08
    db $20
    db $44
    db $00
    db $08
    db $18
    db $45
    db $00
    db $08
    db $10
    db $46
    db $00
    db $08
    db $08
    db $47
    db $00
    db $00
    db $28
    db $4d
    db $00
    db $00
    db $20
    db $4e
    db $00
    db $00
    db $18
    db $4f
    db $00
    db $00
    db $10
    db $50
    db $00
    db $f8
    db $28
    db $56
    db $00
    db $f8
    db $20
    db $57
    db $00
    db $80

; C: OAM list D8 of the table 4000
OamList_B01_4000_D8::
    db $28
    db $10
    db $1b
    db $00
    db $28
    db $08
    db $1c
    db $00
    db $20
    db $08
    db $20
    db $00
    db $18
    db $10
    db $27
    db $00
    db $18
    db $08
    db $28
    db $00
    db $10
    db $10
    db $35
    db $00
    db $10
    db $08
    db $36
    db $00
    db $08
    db $10
    db $41
    db $00
    db $08
    db $08
    db $42
    db $00
    db $00
    db $10
    db $4c
    db $00
    db $18
    db $30
    db $23
    db $00
    db $18
    db $28
    db $24
    db $00
    db $18
    db $20
    db $25
    db $00
    db $18
    db $18
    db $26
    db $00
    db $10
    db $30
    db $31
    db $00
    db $10
    db $28
    db $32
    db $00
    db $10
    db $20
    db $33
    db $00
    db $10
    db $18
    db $34
    db $00
    db $08
    db $28
    db $3e
    db $00
    db $08
    db $20
    db $3f
    db $00
    db $08
    db $18
    db $40
    db $00
    db $00
    db $28
    db $49
    db $00
    db $00
    db $20
    db $4a
    db $00
    db $00
    db $18
    db $4b
    db $00
    db $f8
    db $28
    db $54
    db $00
    db $f8
    db $20
    db $55
    db $00
    db $80

; C: OAM list D9 of the table 4000
OamList_B01_4000_D9::
    db $28
    db $10
    db $00
    db $00
    db $28
    db $08
    db $01
    db $00
    db $20
    db $28
    db $02
    db $00
    db $20
    db $20
    db $03
    db $00
    db $20
    db $10
    db $04
    db $00
    db $20
    db $08
    db $05
    db $00
    db $18
    db $28
    db $06
    db $00
    db $18
    db $20
    db $07
    db $00
    db $18
    db $18
    db $08
    db $00
    db $18
    db $10
    db $09
    db $00
    db $18
    db $08
    db $0a
    db $00
    db $10
    db $28
    db $0b
    db $00
    db $10
    db $20
    db $0c
    db $00
    db $10
    db $18
    db $0d
    db $00
    db $10
    db $10
    db $0e
    db $00
    db $10
    db $08
    db $0f
    db $00
    db $08
    db $20
    db $10
    db $00
    db $08
    db $18
    db $11
    db $00
    db $08
    db $10
    db $12
    db $00
    db $08
    db $08
    db $13
    db $00
    db $00
    db $28
    db $14
    db $00
    db $00
    db $20
    db $15
    db $00
    db $00
    db $18
    db $16
    db $00
    db $00
    db $10
    db $17
    db $00
    db $00
    db $08
    db $18
    db $00
    db $f8
    db $28
    db $42
    db $20
    db $f8
    db $20
    db $19
    db $00
    db $f8
    db $18
    db $1a
    db $00
    db $80

; C: OAM list DA of the table 4000
OamList_B01_4000_DA::
    db $f4
    db $20
    db $53
    db $00
    db $1a
    db $2f
    db $51
    db $00
    db $22
    db $27
    db $48
    db $00
    db $1a
    db $27
    db $52
    db $00
    db $08
    db $31
    db $53
    db $00
    db $28
    db $10
    db $1d
    db $00
    db $28
    db $08
    db $1e
    db $00
    db $20
    db $08
    db $21
    db $00
    db $18
    db $30
    db $29
    db $00
    db $18
    db $28
    db $2a
    db $00
    db $18
    db $20
    db $2b
    db $00
    db $18
    db $18
    db $2c
    db $00
    db $18
    db $10
    db $2d
    db $00
    db $18
    db $08
    db $2e
    db $00
    db $10
    db $30
    db $37
    db $00
    db $10
    db $28
    db $38
    db $00
    db $10
    db $20
    db $39
    db $00
    db $10
    db $18
    db $3a
    db $00
    db $10
    db $10
    db $3b
    db $00
    db $08
    db $28
    db $43
    db $00
    db $08
    db $20
    db $44
    db $00
    db $08
    db $18
    db $45
    db $00
    db $08
    db $10
    db $46
    db $00
    db $08
    db $08
    db $47
    db $00
    db $00
    db $28
    db $4d
    db $00
    db $00
    db $20
    db $4e
    db $00
    db $00
    db $18
    db $4f
    db $00
    db $00
    db $10
    db $50
    db $00
    db $f8
    db $28
    db $56
    db $00
    db $f8
    db $20
    db $57
    db $00
    db $80

; C: OAM list DB of the table 4000
OamList_B01_4000_DB::
    db $2c
    db $30
    db $48
    db $00
    db $24
    db $38
    db $51
    db $00
    db $24
    db $30
    db $52
    db $00
    db $1a
    db $3d
    db $53
    db $00
    db $ee
    db $39
    db $2f
    db $00
    db $ee
    db $31
    db $30
    db $00
    db $e6
    db $39
    db $3c
    db $00
    db $e6
    db $31
    db $3d
    db $00
    db $03
    db $3b
    db $53
    db $00
    db $f8
    db $30
    db $53
    db $00
    db $28
    db $10
    db $1b
    db $00
    db $28
    db $08
    db $1c
    db $00
    db $20
    db $08
    db $20
    db $00
    db $18
    db $10
    db $27
    db $00
    db $18
    db $08
    db $28
    db $00
    db $10
    db $10
    db $35
    db $00
    db $10
    db $08
    db $36
    db $00
    db $08
    db $10
    db $41
    db $00
    db $08
    db $08
    db $42
    db $00
    db $00
    db $10
    db $4c
    db $00
    db $18
    db $30
    db $23
    db $00
    db $18
    db $28
    db $24
    db $00
    db $18
    db $20
    db $25
    db $00
    db $18
    db $18
    db $26
    db $00
    db $10
    db $30
    db $31
    db $00
    db $10
    db $28
    db $32
    db $00
    db $10
    db $20
    db $33
    db $00
    db $10
    db $18
    db $34
    db $00
    db $08
    db $28
    db $3e
    db $00
    db $08
    db $20
    db $3f
    db $00
    db $08
    db $18
    db $40
    db $00
    db $00
    db $28
    db $49
    db $00
    db $00
    db $20
    db $4a
    db $00
    db $00
    db $18
    db $4b
    db $00
    db $f8
    db $28
    db $54
    db $00
    db $f8
    db $20
    db $55
    db $00
    db $80

; C: OAM list DC of the table 4000
OamList_B01_4000_DC::
    db $18
    db $08
    db $ca
    db $00
    db $10
    db $08
    db $c9
    db $00
    db $80

; C: OAM list DD of the table 4000
OamList_B01_4000_DD::
    db $10
    db $10
    db $c8
    db $10
    db $10
    db $08
    db $c7
    db $10
    db $10
    db $00
    db $c6
    db $10
    db $08
    db $10
    db $c5
    db $10
    db $08
    db $08
    db $c4
    db $10
    db $08
    db $00
    db $c3
    db $10
    db $80

; C: OAM list DE of the table 4000
OamList_B01_4000_DE::
    db $10
    db $f8
    db $c8
    db $30
    db $10
    db $00
    db $c7
    db $30
    db $10
    db $08
    db $c6
    db $30
    db $08
    db $f8
    db $c5
    db $30
    db $08
    db $00
    db $c4
    db $30
    db $08
    db $08
    db $c3
    db $30
    db $80

; C: OAM list DF of the table 4000
OamList_B01_4000_DF::
    db $17
    db $08
    db $df
    db $40
    db $10
    db $08
    db $df
    db $00
    db $80

; C: OAM list E0 of the table 4000
OamList_B01_4000_E0::
    db $16
    db $0b
    db $b8
    db $10
    db $1b
    db $10
    db $b9
    db $10
    db $10
    db $10
    db $b7
    db $10
    db $80

; C: OAM list E1 of the table 4000
OamList_B01_4000_E1::
    db $14
    db $02
    db $b8
    db $10
    db $1b
    db $0b
    db $b9
    db $10
    db $0d
    db $0d
    db $b7
    db $10
    db $80

; C: OAM list E2 of the table 4000
OamList_B01_4000_E2::
    db $15
    db $fd
    db $b8
    db $10
    db $0b
    db $04
    db $b7
    db $10
    db $1c
    db $05
    db $b9
    db $10
    db $80

; C: OAM list E3 of the table 4000
OamList_B01_4000_E3::
    db $18
    db $30
    db $1b
    db $00
    db $18
    db $28
    db $1a
    db $00
    db $18
    db $20
    db $19
    db $00
    db $18
    db $18
    db $18
    db $00
    db $18
    db $10
    db $17
    db $00
    db $18
    db $08
    db $16
    db $00
    db $10
    db $30
    db $0b
    db $00
    db $10
    db $28
    db $0a
    db $00
    db $10
    db $20
    db $09
    db $00
    db $10
    db $18
    db $08
    db $00
    db $10
    db $10
    db $07
    db $00
    db $10
    db $08
    db $06
    db $00
    db $80

; C: OAM list E4 of the table 4000
OamList_B01_4000_E4::
    db $18
    db $30
    db $15
    db $10
    db $18
    db $28
    db $14
    db $10
    db $18
    db $20
    db $13
    db $10
    db $18
    db $18
    db $12
    db $10
    db $18
    db $10
    db $11
    db $10
    db $18
    db $08
    db $10
    db $10
    db $10
    db $30
    db $05
    db $10
    db $10
    db $28
    db $04
    db $10
    db $10
    db $20
    db $03
    db $10
    db $10
    db $18
    db $02
    db $10
    db $10
    db $10
    db $01
    db $10
    db $10
    db $08
    db $00
    db $10
    db $80

; C: OAM list E5 of the table 4000
OamList_B01_4000_E5::
    db $18
    db $40
    db $33
    db $00
    db $18
    db $38
    db $32
    db $00
    db $18
    db $30
    db $31
    db $00
    db $18
    db $28
    db $30
    db $00
    db $10
    db $40
    db $23
    db $00
    db $10
    db $38
    db $22
    db $00
    db $10
    db $30
    db $21
    db $00
    db $10
    db $28
    db $20
    db $00
    db $18
    db $20
    db $1f
    db $00
    db $18
    db $18
    db $1e
    db $00
    db $18
    db $10
    db $1d
    db $00
    db $18
    db $08
    db $1c
    db $00
    db $10
    db $20
    db $0f
    db $00
    db $10
    db $18
    db $0e
    db $00
    db $10
    db $10
    db $0d
    db $00
    db $10
    db $08
    db $0c
    db $00
    db $80

; C: OAM list E6 of the table 4000
OamList_B01_4000_E6::
    db $18
    db $40
    db $3b
    db $10
    db $18
    db $38
    db $3a
    db $10
    db $18
    db $30
    db $39
    db $10
    db $18
    db $28
    db $38
    db $10
    db $18
    db $20
    db $37
    db $10
    db $18
    db $18
    db $36
    db $10
    db $18
    db $10
    db $35
    db $10
    db $18
    db $08
    db $34
    db $10
    db $10
    db $40
    db $2b
    db $10
    db $10
    db $38
    db $2a
    db $10
    db $10
    db $30
    db $29
    db $10
    db $10
    db $28
    db $28
    db $10
    db $10
    db $20
    db $27
    db $10
    db $10
    db $18
    db $26
    db $10
    db $10
    db $10
    db $25
    db $10
    db $10
    db $08
    db $24
    db $10
    db $80

; I: OAM list E7 of the table 4000
OamList_B01_4000_E7::
    db $10
    db $25
    db $2d
    db $10
    db $10

    db $1d, $2c, $10, $10

    db $18
    db $42
    db $10
    db $10
    db $10
    db $41
    db $10
    db $10
    db $08
    db $40
    db $10
    db $80

; C: OAM list E8 of the table 4000
OamList_B01_4000_E8::
    db $10
    db $08
    db $44
    db $10
    db $80

; C: OAM list E9 of the table 4000
OamList_B01_4000_E9::
    db $10
    db $08
    db $45
    db $10
    db $80

; C: OAM list EA of the table 4000
OamList_B01_4000_EA::
    db $10
    db $08
    db $46
    db $10
    db $80

; C: OAM list EB of the table 4000
OamList_B01_4000_EB::
    db $0a
    db $40
    db $67
    db $10
    db $0a
    db $38
    db $66
    db $10
    db $0a
    db $30
    db $65
    db $10
    db $0a
    db $28
    db $64
    db $10
    db $0a
    db $20
    db $63
    db $10
    db $12
    db $38
    db $6a
    db $10
    db $12
    db $30
    db $69
    db $10
    db $12
    db $28
    db $68
    db $10
    db $02
    db $38
    db $62
    db $10
    db $02
    db $30
    db $61
    db $10
    db $02
    db $28
    db $60
    db $10
    db $10
    db $08
    db $7f
    db $10
    db $08
    db $00
    db $6f
    db $10
    db $18
    db $00
    db $7c
    db $30
    db $10
    db $00
    db $6c
    db $30
    db $18
    db $f8
    db $7e
    db $10
    db $10
    db $f8
    db $6e
    db $10
    db $80

; C: OAM list EC of the table 4000
OamList_B01_4000_EC::
    db $14
    db $08
    db $7b
    db $30
    db $0c
    db $08
    db $6b
    db $30
    db $14
    db $00
    db $7b
    db $10
    db $0c
    db $00
    db $6b
    db $10
    db $80

; C: OAM list ED of the table 4000
OamList_B01_4000_ED::
    db $12
    db $e0
    db $78
    db $10
    db $12
    db $d8
    db $77
    db $10
    db $12
    db $d0
    db $76
    db $10
    db $0a
    db $e0
    db $75
    db $10
    db $0a
    db $d8
    db $74
    db $10
    db $0a
    db $d0
    db $73
    db $10
    db $02
    db $e0
    db $72
    db $10
    db $02
    db $d8
    db $71
    db $10
    db $02
    db $d0
    db $70
    db $10
    db $10
    db $00
    db $7f
    db $30
    db $08
    db $08
    db $6f
    db $30
    db $18
    db $10
    db $7d
    db $10
    db $18
    db $08
    db $7c
    db $10
    db $10
    db $10
    db $6d
    db $10
    db $10
    db $08
    db $6c
    db $10
    db $80

; C: OAM list EE of the table 4000
OamList_B01_4000_EE::
    db $18
    db $10
    db $df
    db $10
    db $18
    db $08
    db $de
    db $10
    db $10
    db $10
    db $cf
    db $10
    db $10
    db $08
    db $ce
    db $10
    db $80

; C: OAM list EF of the table 4000
OamList_B01_4000_EF::
    db $46
    db $2b
    db $df
    db $10
    db $46
    db $23
    db $de
    db $10
    db $3e
    db $2b
    db $cf
    db $10
    db $3e
    db $23
    db $ce
    db $10
    db $80

; C: OAM list F0 of the table 4000
OamList_B01_4000_F0::
    db $1f
    db $10
    db $e1
    db $80
    db $1f
    db $08
    db $e0
    db $80
    db $17
    db $10
    db $e1
    db $80
    db $17
    db $08
    db $e0
    db $80
    db $0f
    db $10
    db $e1
    db $80
    db $0f
    db $08
    db $e0
    db $80
    db $80

; C: OAM list F1 of the table 4000
OamList_B01_4000_F1::
    db $1f
    db $10
    db $e3
    db $80
    db $1f
    db $08
    db $e2
    db $80
    db $17
    db $10
    db $e3
    db $80
    db $17
    db $08
    db $e2
    db $80
    db $0f
    db $10
    db $e3
    db $80
    db $0f
    db $08
    db $e2
    db $80
    db $80

; C: OAM list F2 of the table 4000
OamList_B01_4000_F2::
    db $f8
    db $4a
    db $27
    db $10
    db $f8
    db $42
    db $26
    db $10
    db $f8
    db $3a
    db $25
    db $10
    db $f8
    db $32
    db $24
    db $10
    db $f8
    db $2a
    db $23
    db $10
    db $f8
    db $22
    db $22
    db $10
    db $f8
    db $1a
    db $21
    db $10
    db $f8
    db $12
    db $20
    db $10
    db $28
    db $30
    db $3b
    db $10
    db $28
    db $28
    db $3a
    db $10
    db $28
    db $20
    db $39
    db $10
    db $28
    db $18
    db $38
    db $10
    db $20
    db $30
    db $37
    db $10
    db $20
    db $28
    db $36
    db $10
    db $20
    db $20
    db $35
    db $10
    db $20
    db $18
    db $34
    db $10
    db $18
    db $30
    db $33
    db $10
    db $18
    db $28
    db $32
    db $10
    db $18
    db $20
    db $31
    db $10
    db $18
    db $18
    db $30
    db $10
    db $f0
    db $4a
    db $17
    db $10
    db $f0
    db $42
    db $16
    db $10
    db $f0
    db $3a
    db $15
    db $10
    db $f0
    db $32
    db $14
    db $10
    db $f0
    db $2a
    db $13
    db $10
    db $f0
    db $22
    db $12
    db $10
    db $f0
    db $1a
    db $11
    db $10
    db $f0
    db $12
    db $10
    db $10
    db $e8
    db $4a
    db $07
    db $10
    db $e8
    db $42
    db $06
    db $10
    db $e8
    db $3a
    db $05
    db $10
    db $e8
    db $32
    db $04
    db $10
    db $e8
    db $2a
    db $03
    db $10
    db $e8
    db $22
    db $02
    db $10
    db $e8
    db $1a
    db $01
    db $10
    db $e8
    db $12
    db $00
    db $10
    db $80

; C: OAM list F3 of the table 4000
OamList_B01_4000_F3::
    db $2d
    db $d0
    db $45
    db $10
    db $2e
    db $c8
    db $44
    db $10
    db $2f
    db $c0
    db $43
    db $10
    db $21
    db $d0
    db $42
    db $10
    db $21
    db $c8
    db $41
    db $10
    db $21
    db $c0
    db $40
    db $10
    db $13
    db $d0
    db $3e
    db $10
    db $11
    db $c8
    db $3d
    db $10
    db $10
    db $c0
    db $3c
    db $10
    db $60
    db $ce
    db $2a
    db $10
    db $60
    db $c6
    db $29
    db $10
    db $60
    db $be
    db $28
    db $10
    db $60
    db $f6
    db $2f
    db $10
    db $60
    db $e6
    db $2d
    db $10
    db $60
    db $ee
    db $2e
    db $10
    db $60
    db $de
    db $2c
    db $10
    db $60
    db $d6
    db $2b
    db $10
    db $50
    db $f6
    db $0f
    db $10
    db $58
    db $f6
    db $1f
    db $10
    db $58
    db $ee
    db $1e
    db $10
    db $58
    db $e6
    db $1d
    db $10
    db $58
    db $de
    db $1c
    db $10
    db $58
    db $d6
    db $1b
    db $10
    db $58
    db $ce
    db $1a
    db $10
    db $58
    db $c6
    db $19
    db $10
    db $58
    db $be
    db $18
    db $10
    db $50
    db $ee
    db $0e
    db $10
    db $50
    db $e6
    db $0d
    db $10
    db $50
    db $de
    db $0c
    db $10
    db $50
    db $d6
    db $0b
    db $10
    db $50
    db $ce
    db $0a
    db $10
    db $50
    db $c6
    db $09
    db $10
    db $50
    db $be
    db $08
    db $10
    db $80

; C: OAM list F4 of the table 4000
OamList_B01_4000_F4::
    db $10
    db $0c
    db $3f
    db $50
    db $08
    db $0c
    db $3f
    db $10
    db $80

; C: OAM list F5 of the table 4000
OamList_B01_4000_F5::
    db $10
    db $04
    db $3f
    db $70
    db $08
    db $04
    db $3f
    db $30
    db $80

; C: OAM list F6 of the table 4000
OamList_B01_4000_F6::
    db $10
    db $08
    db $f8
    db $00
    db $80

; C: OAM list F7 of the table 4000
OamList_B01_4000_F7::
    db $18
    db $08
    db $ad
    db $00
    db $10
    db $08
    db $ac
    db $00
    db $80

; C: OAM list F8 of the table 4000
OamList_B01_4000_F8::
    db $13
    db $08
    db $ae
    db $00
    db $80

; I: 246 words: list number -> OAM record list (4-byte records Y X tile attr; ends with Y=$80); used by
; Oam_AddMeta_B01_5D47 (00:2496)
OamPtrTbl_B01_5D2B::
    dw OamList_B01_5D2B_00
    dw OamList_B01_5D2B_01
    dw OamList_B01_5D2B_02
    dw OamList_B01_5D2B_03
    dw OamList_B01_5D2B_04
    dw OamList_B01_5D2B_05
    dw OamList_B01_5D2B_06
    dw OamList_B01_5D2B_07
    dw OamList_B01_5D2B_08
    dw OamList_B01_5D2B_09
    dw OamList_B01_5D2B_0A
    dw OamList_B01_5D2B_0B
    dw OamList_B01_5D2B_0C
    dw OamList_B01_5D2B_0D
    dw OamList_B01_5D2B_0E
    dw OamList_B01_5D2B_0F
    dw OamList_B01_5D2B_10
    dw OamList_B01_5D2B_11
    dw OamList_B01_5D2B_12
    dw OamList_B01_5D2B_13
    dw OamList_B01_5D2B_14
    dw OamList_B01_5D2B_15
    dw OamList_B01_5D2B_16
    dw OamList_B01_5D2B_17
    dw OamList_B01_5D2B_18
    dw OamList_B01_5D2B_19
    dw OamList_B01_5D2B_1A
    dw OamList_B01_5D2B_1B
    dw OamList_B01_5D2B_1C
    dw OamList_B01_5D2B_1D
    dw OamList_B01_5D2B_1E
    dw OamList_B01_5D2B_1F
    dw OamList_B01_5D2B_20
    dw OamList_B01_5D2B_21
    dw OamList_B01_5D2B_22
    dw OamList_B01_5D2B_23
    dw OamList_B01_5D2B_24
    dw OamList_B01_5D2B_25
    dw OamList_B01_5D2B_26
    dw OamList_B01_5D2B_27
    dw OamList_B01_5D2B_28
    dw OamList_B01_5D2B_29
    dw OamList_B01_5D2B_2A
    dw OamList_B01_5D2B_2B
    dw OamList_B01_5D2B_2C
    dw OamList_B01_5D2B_2D
    dw OamList_B01_5D2B_2E
    dw OamList_B01_5D2B_2F
    dw OamList_B01_5D2B_30
    dw OamList_B01_5D2B_31
    dw OamList_B01_5D2B_32
    dw OamList_B01_5D2B_33
    dw OamList_B01_5D2B_34
    dw OamList_B01_5D2B_35
    dw OamList_B01_5D2B_36
    dw OamList_B01_5D2B_37
    dw OamList_B01_5D2B_38
    dw OamList_B01_5D2B_39
    dw OamList_B01_5D2B_3A
    dw OamList_B01_5D2B_3B
    dw OamList_B01_5D2B_3C
    dw OamList_B01_5D2B_3D
    dw OamList_B01_5D2B_3E
    dw OamList_B01_5D2B_3F
    dw OamList_B01_5D2B_40
    dw OamList_B01_5D2B_41
    dw OamList_B01_5D2B_42
    dw OamList_B01_5D2B_43
    dw OamList_B01_5D2B_44
    dw OamList_B01_5D2B_45
    dw OamList_B01_5D2B_46
    dw OamList_B01_5D2B_47
    dw OamList_B01_5D2B_48
    dw OamList_B01_5D2B_49
    dw OamList_B01_5D2B_4A
    dw OamList_B01_5D2B_4B
    dw OamList_B01_5D2B_4C
    dw OamList_B01_5D2B_4D
    dw OamList_B01_5D2B_4E
    dw OamList_B01_5D2B_4F
    dw OamList_B01_5D2B_50
    dw OamList_B01_5D2B_51
    dw OamList_B01_5D2B_52
    dw OamList_B01_5D2B_53
    dw OamList_B01_5D2B_54
    dw OamList_B01_5D2B_55
    dw OamList_B01_5D2B_56
    dw OamList_B01_5D2B_57
    dw OamList_B01_5D2B_58
    dw OamList_B01_5D2B_59
    dw OamList_B01_5D2B_5A
    dw OamList_B01_5D2B_5B
    dw OamList_B01_5D2B_5C
    dw OamList_B01_5D2B_5D
    dw OamList_B01_5D2B_5E
    dw OamList_B01_5D2B_5F
    dw OamList_B01_5D2B_60
    dw OamList_B01_5D2B_61
    dw OamList_B01_5D2B_62
    dw OamList_B01_5D2B_63
    dw OamList_B01_5D2B_64
    dw OamList_B01_5D2B_65
    dw OamList_B01_5D2B_66
    dw OamList_B01_5D2B_67
    dw OamList_B01_5D2B_68
    dw OamList_B01_5D2B_69
    dw OamList_B01_5D2B_6A
    dw OamList_B01_5D2B_6B
    dw OamList_B01_5D2B_6C
    dw OamList_B01_5D2B_6D
    dw OamList_B01_5D2B_6E
    dw OamList_B01_5D2B_6F
    dw OamList_B01_5D2B_70
    dw OamList_B01_5D2B_71
    dw OamList_B01_5D2B_72
    dw OamList_B01_5D2B_73
    dw OamList_B01_5D2B_74
    dw OamList_B01_5D2B_75
    dw OamList_B01_5D2B_76
    dw OamList_B01_5D2B_77
    dw OamList_B01_5D2B_78
    dw OamList_B01_5D2B_79
    dw OamList_B01_5D2B_7A
    dw OamList_B01_5D2B_7B
    dw OamList_B01_5D2B_7C
    dw OamList_B01_5D2B_7D
    dw OamList_B01_5D2B_7E
    dw OamList_B01_5D2B_7F
    dw OamList_B01_5D2B_80
    dw OamList_B01_5D2B_81
    dw OamList_B01_5D2B_82
    dw OamList_B01_5D2B_83
    dw OamList_B01_5D2B_84
    dw OamList_B01_5D2B_85
    dw OamList_B01_5D2B_86
    dw OamList_B01_5D2B_87
    dw OamList_B01_5D2B_88
    dw OamList_B01_5D2B_89
    dw OamList_B01_5D2B_8A
    dw OamList_B01_5D2B_8B
    dw OamList_B01_5D2B_8C
    dw OamList_B01_5D2B_8D
    dw OamList_B01_5D2B_8E
    dw OamList_B01_5D2B_8F
    dw OamList_B01_5D2B_90
    dw OamList_B01_5D2B_91
    dw OamList_B01_5D2B_92
    dw OamList_B01_5D2B_93
    dw OamList_B01_5D2B_94
    dw OamList_B01_5D2B_95
    dw OamList_B01_5D2B_96
    dw OamList_B01_5D2B_97
    dw OamList_B01_5D2B_98
    dw OamList_B01_5D2B_99
    dw OamList_B01_5D2B_9A
    dw OamList_B01_5D2B_9B
    dw OamList_B01_5D2B_9C
    dw OamList_B01_5D2B_9D
    dw OamList_B01_5D2B_9E
    dw OamList_B01_5D2B_9F
    dw OamList_B01_5D2B_A0
    dw OamList_B01_5D2B_A1
    dw OamList_B01_5D2B_A2
    dw OamList_B01_5D2B_A3
    dw OamList_B01_5D2B_A4
    dw OamList_B01_5D2B_A5
    dw OamList_B01_5D2B_A6
    dw OamList_B01_5D2B_A7
    dw OamList_B01_5D2B_A8
    dw OamList_B01_5D2B_A9
    dw OamList_B01_5D2B_AA
    dw OamList_B01_5D2B_AB
    dw OamList_B01_5D2B_AC
    dw OamList_B01_5D2B_AD
    dw OamList_B01_5D2B_AE
    dw OamList_B01_5D2B_AF
    dw OamList_B01_5D2B_B0
    dw OamList_B01_5D2B_B1
    dw OamList_B01_5D2B_B2
    dw OamList_B01_5D2B_B3
    dw OamList_B01_5D2B_B4
    dw OamList_B01_5D2B_B5
    dw OamList_B01_5D2B_B6
    dw OamList_B01_5D2B_B7
    dw OamList_B01_5D2B_B8
    dw OamList_B01_5D2B_B9
    dw OamList_B01_5D2B_BA
    dw OamList_B01_5D2B_BB
    dw OamList_B01_5D2B_BC
    dw OamList_B01_5D2B_BD
    dw OamList_B01_5D2B_BE
    dw OamList_B01_5D2B_BF
    dw OamList_B01_5D2B_C0
    dw OamList_B01_5D2B_C1
    dw OamList_B01_5D2B_C2
    dw OamList_B01_5D2B_C3
    dw OamList_B01_5D2B_C4
    dw OamList_B01_5D2B_C5
    dw OamList_B01_5D2B_C6
    dw OamList_B01_5D2B_C7
    dw OamList_B01_5D2B_C8
    dw OamList_B01_5D2B_C9
    dw OamList_B01_5D2B_CA
    dw OamList_B01_5D2B_CB
    dw OamList_B01_5D2B_CC
    dw OamList_B01_5D2B_CD
    dw OamList_B01_5D2B_CE
    dw OamList_B01_5D2B_CF
    dw OamList_B01_5D2B_D0
    dw OamList_B01_5D2B_D1
    dw OamList_B01_5D2B_D2
    dw OamList_B01_5D2B_D3
    dw OamList_B01_5D2B_D4
    dw OamList_B01_5D2B_D5
    dw OamList_B01_5D2B_D6
    dw OamList_B01_5D2B_D7
    dw OamList_B01_5D2B_D8
    dw OamList_B01_5D2B_D9
    dw OamList_B01_5D2B_DA
    dw OamList_B01_5D2B_DB
    dw OamList_B01_5D2B_DC
    dw OamList_B01_5D2B_DD
    dw OamList_B01_5D2B_DE
    dw OamList_B01_5D2B_DF
    dw OamList_B01_5D2B_E0
    dw OamList_B01_5D2B_E1
    dw OamList_B01_5D2B_E2
    dw OamList_B01_5D2B_E3
    dw OamList_B01_5D2B_E4
    dw OamList_B01_5D2B_E5
    dw OamList_B01_5D2B_E6
    dw OamList_B01_5D2B_E7
    dw OamList_B01_5D2B_E8
    dw OamList_B01_5D2B_E9
    dw OamList_B01_5D2B_EA
    dw OamList_B01_5D2B_EB
    dw OamList_B01_5D2B_EC
    dw OamList_B01_5D2B_ED
    dw OamList_B01_5D2B_EE
    dw OamList_B01_5D2B_EF
    dw OamList_B01_5D2B_F0
    dw OamList_B01_5D2B_F1
    dw OamList_B01_5D2B_F2
    dw OamList_B01_5D2B_F3
    dw OamList_B01_5D2B_F4
    dw OamList_B01_5D2B_F5

; C: OAM list 00 of the table 5D47
OamList_B01_5D2B_00::
    db $20
    db $10
    db $71
    db $10
    db $20
    db $08
    db $70
    db $10
    db $18
    db $10
    db $61
    db $10
    db $18
    db $08
    db $60
    db $10
    db $10
    db $10
    db $51
    db $10
    db $10
    db $08
    db $50
    db $10
    db $80

; C: OAM list 01 of the table 5D47
OamList_B01_5D2B_01::
    db $20
    db $10
    db $73
    db $10
    db $20
    db $08
    db $72
    db $10
    db $18
    db $10
    db $63
    db $10
    db $18
    db $08
    db $62
    db $10
    db $10
    db $10
    db $53
    db $10
    db $10
    db $08
    db $52
    db $10
    db $80

; C: OAM list 02 of the table 5D47
OamList_B01_5D2B_02::
    db $20
    db $10
    db $75
    db $10
    db $20
    db $08
    db $74
    db $10
    db $18
    db $10
    db $65
    db $10
    db $18
    db $08
    db $64
    db $10
    db $10
    db $10
    db $55
    db $10
    db $10
    db $08
    db $54
    db $10
    db $80

; C: OAM list 03 of the table 5D47
OamList_B01_5D2B_03::
    db $20
    db $10
    db $77
    db $10
    db $20
    db $08
    db $76
    db $10
    db $18
    db $10
    db $67
    db $10
    db $18
    db $08
    db $66
    db $10
    db $10
    db $10
    db $57
    db $10
    db $10
    db $08
    db $56
    db $10
    db $80

; C: OAM list 04 of the table 5D47
OamList_B01_5D2B_04::
    db $20
    db $10
    db $79
    db $10
    db $20
    db $08
    db $78
    db $10
    db $18
    db $10
    db $69
    db $10
    db $18
    db $08
    db $68
    db $10
    db $10
    db $10
    db $59
    db $10
    db $10
    db $08
    db $58
    db $10
    db $80

; C: OAM list 05 of the table 5D47
OamList_B01_5D2B_05::
    db $20
    db $10
    db $7b
    db $10
    db $20
    db $08
    db $7a
    db $10
    db $18
    db $10
    db $6b
    db $10
    db $18
    db $08
    db $6a
    db $10
    db $10
    db $10
    db $5b
    db $10
    db $10
    db $08
    db $5a
    db $10
    db $80

; C: OAM list 06 of the table 5D47
OamList_B01_5D2B_06::
    db $20
    db $08
    db $79
    db $30
    db $20
    db $10
    db $78
    db $30
    db $18
    db $08
    db $69
    db $30
    db $18
    db $10
    db $68
    db $30
    db $10
    db $08
    db $59
    db $30
    db $10
    db $10
    db $58
    db $30
    db $80

; C: OAM list 07 of the table 5D47
OamList_B01_5D2B_07::
    db $20
    db $08
    db $77
    db $30
    db $20
    db $10
    db $76
    db $30
    db $18
    db $08
    db $67
    db $30
    db $18
    db $10
    db $66
    db $30
    db $10
    db $08
    db $57
    db $30
    db $10
    db $10
    db $56
    db $30
    db $80

; C: OAM list 08 of the table 5D47
OamList_B01_5D2B_08::
    db $20
    db $08
    db $75
    db $30
    db $20
    db $10
    db $74
    db $30
    db $18
    db $08
    db $65
    db $30
    db $18
    db $10
    db $64
    db $30
    db $10
    db $08
    db $55
    db $30
    db $10
    db $10
    db $54
    db $30
    db $80

; C: OAM list 09 of the table 5D47
OamList_B01_5D2B_09::
    db $20
    db $08
    db $73
    db $30
    db $20
    db $10
    db $72
    db $30
    db $18
    db $08
    db $63
    db $30
    db $18
    db $10
    db $62
    db $30
    db $10
    db $08
    db $53
    db $30
    db $10
    db $10
    db $52
    db $30
    db $80

; C: OAM list 0A of the table 5D47
OamList_B01_5D2B_0A::
    db $20
    db $08
    db $71
    db $30
    db $20
    db $10
    db $70
    db $30
    db $18
    db $08
    db $61
    db $30
    db $18
    db $10
    db $60
    db $30
    db $10
    db $08
    db $51
    db $30
    db $10
    db $10
    db $50
    db $30
    db $80

; C: OAM list 0B of the table 5D47
OamList_B01_5D2B_0B::
    db $10
    db $08
    db $01
    db $30
    db $10
    db $10
    db $00
    db $30
    db $20
    db $08
    db $19
    db $30
    db $20
    db $10
    db $18
    db $30
    db $18
    db $08
    db $09
    db $30
    db $18
    db $10
    db $08
    db $30
    db $80

; C: OAM list 0C of the table 5D47
OamList_B01_5D2B_0C::
    db $20
    db $08
    db $1b
    db $30
    db $20
    db $10
    db $1a
    db $30
    db $18
    db $08
    db $0b
    db $30
    db $18
    db $10
    db $0a
    db $30
    db $10
    db $08
    db $fb
    db $30
    db $10
    db $10
    db $fa
    db $30
    db $80

; C: OAM list 0D of the table 5D47
OamList_B01_5D2B_0D::
    db $20
    db $08
    db $1d
    db $30
    db $20
    db $10
    db $1c
    db $30
    db $18
    db $08
    db $0d
    db $30
    db $18
    db $10
    db $0c
    db $30
    db $10
    db $08
    db $fd
    db $30
    db $10
    db $10
    db $fc
    db $30
    db $80

; C: OAM list 0E of the table 5D47
OamList_B01_5D2B_0E::
    db $20
    db $08
    db $1f
    db $30
    db $20
    db $10
    db $1e
    db $30
    db $18
    db $08
    db $0f
    db $30
    db $18
    db $10
    db $0e
    db $30
    db $10
    db $08
    db $ff
    db $30
    db $10
    db $10
    db $fe
    db $30
    db $80

; C: OAM list 0F of the table 5D47
OamList_B01_5D2B_0F::
    db $20
    db $10
    db $1f
    db $10
    db $20
    db $08
    db $1e
    db $10
    db $18
    db $10
    db $0f
    db $10
    db $18
    db $08
    db $0e
    db $10
    db $10
    db $10
    db $ff
    db $10
    db $10
    db $08
    db $fe
    db $10
    db $80

; C: OAM list 10 of the table 5D47
OamList_B01_5D2B_10::
    db $20
    db $10
    db $1d
    db $10
    db $20
    db $08
    db $1c
    db $10
    db $18
    db $10
    db $0d
    db $10
    db $18
    db $08
    db $0c
    db $10
    db $10
    db $10
    db $fd
    db $10
    db $10
    db $08
    db $fc
    db $10
    db $80

; C: OAM list 11 of the table 5D47
OamList_B01_5D2B_11::
    db $20
    db $10
    db $1b
    db $10
    db $20
    db $08
    db $1a
    db $10
    db $18
    db $10
    db $0b
    db $10
    db $18
    db $08
    db $0a
    db $10
    db $10
    db $10
    db $fb
    db $10
    db $10
    db $08
    db $fa
    db $10
    db $80

; C: OAM list 12 of the table 5D47
OamList_B01_5D2B_12::
    db $10
    db $10
    db $01
    db $10
    db $10
    db $08
    db $00
    db $10
    db $20
    db $10
    db $19
    db $10
    db $20
    db $08
    db $18
    db $10
    db $18
    db $10
    db $09
    db $10
    db $18
    db $08
    db $08
    db $10
    db $80

; C: OAM list 13 of the table 5D47
OamList_B01_5D2B_13::
    db $20
    db $08
    db $7d
    db $30
    db $20
    db $10
    db $7c
    db $30
    db $18
    db $08
    db $6d
    db $30
    db $18
    db $10
    db $6c
    db $30
    db $10
    db $08
    db $5d
    db $30
    db $10
    db $10
    db $5c
    db $30
    db $80

; C: OAM list 14 of the table 5D47
OamList_B01_5D2B_14::
    db $20
    db $08
    db $7f
    db $30
    db $20
    db $10
    db $7e
    db $30
    db $18
    db $08
    db $6f
    db $30
    db $18
    db $10
    db $6e
    db $30
    db $10
    db $08
    db $5f
    db $30
    db $10
    db $10
    db $5e
    db $30
    db $80

; C: OAM list 15 of the table 5D47
OamList_B01_5D2B_15::
    db $20
    db $08
    db $4b
    db $30
    db $20
    db $10
    db $4a
    db $30
    db $18
    db $08
    db $3b
    db $30
    db $18
    db $10
    db $3a
    db $30
    db $10
    db $08
    db $2b
    db $30
    db $10
    db $10
    db $2a
    db $30
    db $80

; C: OAM list 16 of the table 5D47
OamList_B01_5D2B_16::
    db $20
    db $08
    db $4d
    db $30
    db $20
    db $10
    db $4c
    db $30
    db $18
    db $08
    db $3d
    db $30
    db $18
    db $10
    db $3c
    db $30
    db $10
    db $08
    db $2d
    db $30
    db $10
    db $10
    db $2c
    db $30
    db $80

; C: OAM list 17 of the table 5D47
OamList_B01_5D2B_17::
    db $20
    db $08
    db $4f
    db $30
    db $20
    db $10
    db $4e
    db $30
    db $18
    db $08
    db $3f
    db $30
    db $18
    db $10
    db $3e
    db $30
    db $10
    db $08
    db $2f
    db $30
    db $10
    db $10
    db $2e
    db $30
    db $80

; C: OAM list 18 of the table 5D47
OamList_B01_5D2B_18::
    db $10
    db $10
    db $11
    db $10
    db $10
    db $08
    db $10
    db $10
    db $20
    db $10
    db $17
    db $10
    db $20
    db $08
    db $16
    db $10
    db $18
    db $10
    db $07
    db $10
    db $18
    db $08
    db $06
    db $10
    db $80

; C: OAM list 19 of the table 5D47
OamList_B01_5D2B_19::
    db $20
    db $10
    db $4f
    db $10
    db $20
    db $08
    db $4e
    db $10
    db $18
    db $10
    db $3f
    db $10
    db $18
    db $08
    db $3e
    db $10
    db $10
    db $10
    db $2f
    db $10
    db $10
    db $08
    db $2e
    db $10
    db $80

; C: OAM list 1A of the table 5D47
OamList_B01_5D2B_1A::
    db $20
    db $10
    db $4d
    db $10
    db $20
    db $08
    db $4c
    db $10
    db $18
    db $10
    db $3d
    db $10
    db $18
    db $08
    db $3c
    db $10
    db $10
    db $10
    db $2d
    db $10
    db $10
    db $08
    db $2c
    db $10
    db $80

; C: OAM list 1B of the table 5D47
OamList_B01_5D2B_1B::
    db $20
    db $10
    db $4b
    db $10
    db $20
    db $08
    db $4a
    db $10
    db $18
    db $10
    db $3b
    db $10
    db $18
    db $08
    db $3a
    db $10
    db $10
    db $10
    db $2b
    db $10
    db $10
    db $08
    db $2a
    db $10
    db $80

; C: OAM list 1C of the table 5D47
OamList_B01_5D2B_1C::
    db $20
    db $10
    db $7f
    db $10
    db $20
    db $08
    db $7e
    db $10
    db $18
    db $10
    db $6f
    db $10
    db $18
    db $08
    db $6e
    db $10
    db $10
    db $10
    db $5f
    db $10
    db $10
    db $08
    db $5e
    db $10
    db $80

; C: OAM list 1D of the table 5D47
OamList_B01_5D2B_1D::
    db $20
    db $10
    db $7d
    db $10
    db $20
    db $08
    db $7c
    db $10
    db $18
    db $10
    db $6d
    db $10
    db $18
    db $08
    db $6c
    db $10
    db $10
    db $10
    db $5d
    db $10
    db $10
    db $08
    db $5c
    db $10
    db $80

; C: OAM list 1E of the table 5D47
OamList_B01_5D2B_1E::
    db $20
    db $10
    db $43
    db $10
    db $20
    db $08
    db $42
    db $10
    db $18
    db $10
    db $33
    db $10
    db $18
    db $08
    db $32
    db $10
    db $10
    db $10
    db $23
    db $10
    db $10
    db $08
    db $22
    db $10
    db $80

; C: OAM list 1F of the table 5D47
OamList_B01_5D2B_1F::
    db $20
    db $10
    db $45
    db $10
    db $20
    db $08
    db $44
    db $10
    db $18
    db $10
    db $35
    db $10
    db $18
    db $08
    db $34
    db $10
    db $10
    db $10
    db $25
    db $10
    db $10
    db $08
    db $24
    db $10
    db $80

; C: OAM list 20 of the table 5D47
OamList_B01_5D2B_20::
    db $20
    db $10
    db $47
    db $10
    db $20
    db $08
    db $46
    db $10
    db $18
    db $10
    db $37
    db $10
    db $18
    db $08
    db $36
    db $10
    db $10
    db $10
    db $27
    db $10
    db $10
    db $08
    db $26
    db $10
    db $80

; C: OAM list 21 of the table 5D47
OamList_B01_5D2B_21::
    db $20
    db $10
    db $49
    db $10
    db $20
    db $08
    db $48
    db $10
    db $18
    db $10
    db $39
    db $10
    db $18
    db $08
    db $38
    db $10
    db $10
    db $10
    db $29
    db $10
    db $10
    db $08
    db $28
    db $10
    db $80

; C: OAM list 22 of the table 5D47
OamList_B01_5D2B_22::
    db $20
    db $08
    db $49
    db $30
    db $20
    db $10
    db $48
    db $30
    db $18
    db $08
    db $39
    db $30
    db $18
    db $10
    db $38
    db $30
    db $10
    db $08
    db $29
    db $30
    db $10
    db $10
    db $28
    db $30
    db $80

; C: OAM list 23 of the table 5D47
OamList_B01_5D2B_23::
    db $20
    db $08
    db $47
    db $30
    db $20
    db $10
    db $46
    db $30
    db $18
    db $08
    db $37
    db $30
    db $18
    db $10
    db $36
    db $30
    db $10
    db $08
    db $27
    db $30
    db $10
    db $10
    db $26
    db $30
    db $80

; C: OAM list 24 of the table 5D47
OamList_B01_5D2B_24::
    db $20
    db $08
    db $45
    db $30
    db $20
    db $10
    db $44
    db $30
    db $18
    db $08
    db $35
    db $30
    db $18
    db $10
    db $34
    db $30
    db $10
    db $08
    db $25
    db $30
    db $10
    db $10
    db $24
    db $30
    db $80

; C: OAM list 25 of the table 5D47
OamList_B01_5D2B_25::
    db $20
    db $08
    db $7d
    db $30
    db $20
    db $10
    db $7c
    db $30
    db $18
    db $08
    db $6d
    db $30
    db $18
    db $10
    db $6c
    db $30
    db $10
    db $08
    db $5d
    db $30
    db $10
    db $10
    db $5c
    db $30
    db $80

; I: OAM list 26 of the table 5D47
OamList_B01_5D2B_26::
    db $11
    db $f7
    db $6d
    db $10
    db $11
    db $ef
    db $6c
    db $10
    db $19
    db $ff
    db $70
    db $00
    db $19
    db $f7
    db $6f
    db $00
    db $19
    db $ef
    db $6e
    db $00
    db $08
    db $14
    db $5f
    db $00
    db $08
    db $0c
    db $5e
    db $00
    db $08
    db $04
    db $5d
    db $00
    db $08
    db $fc
    db $5c
    db $00
    db $08
    db $f4
    db $5b
    db $00
    db $00
    db $14
    db $5a
    db $00
    db $00
    db $0c
    db $59
    db $00
    db $00
    db $04
    db $58
    db $00
    db $00
    db $fc
    db $57
    db $00
    db $00
    db $f4
    db $56
    db $00

    db $80

; I: OAM list 27 of the table 5D47
OamList_B01_5D2B_27::
    db $f6
    db $18
    db $55
    db $00
    db $f6
    db $10
    db $54
    db $00
    db $f6
    db $08
    db $53
    db $00
    db $f6
    db $00
    db $52
    db $00
    db $f6
    db $f8
    db $51
    db $00
    db $f6
    db $f0
    db $50
    db $00
    db $11
    db $f9
    db $6d
    db $10
    db $11
    db $f1
    db $6c
    db $10
    db $19
    db $01
    db $70
    db $00
    db $19
    db $f9
    db $6f
    db $00
    db $19
    db $f1
    db $6e
    db $00
    db $08
    db $10
    db $5f
    db $00
    db $08
    db $08
    db $5e
    db $00
    db $08
    db $00
    db $5d
    db $00
    db $08
    db $f8
    db $5c
    db $00
    db $08
    db $f0
    db $5b
    db $00
    db $00
    db $10
    db $5a
    db $00
    db $00
    db $08
    db $59
    db $00
    db $00
    db $00
    db $58
    db $00
    db $00
    db $f8
    db $57
    db $00
    db $00
    db $f0
    db $56
    db $00
    db $80

; C: OAM list 28 of the table 5D47
OamList_B01_5D2B_28::
    db $08
    db $00
    db $71
    db $00
    db $00
    db $00
    db $61
    db $00
    db $80

; C: OAM list 29 of the table 5D47
OamList_B01_5D2B_29::
    db $08
    db $00
    db $72
    db $00
    db $00
    db $00
    db $62
    db $00
    db $80

; C: OAM list 2A of the table 5D47
OamList_B01_5D2B_2A::
    db $08
    db $00
    db $73
    db $00
    db $00
    db $00
    db $63
    db $00
    db $80

; C: OAM list 2B of the table 5D47
OamList_B01_5D2B_2B::
    db $08
    db $00
    db $74
    db $00
    db $00
    db $00
    db $64
    db $00
    db $80

; C: OAM list 2C of the table 5D47
OamList_B01_5D2B_2C::
    db $08
    db $00
    db $75
    db $00
    db $00
    db $00
    db $65
    db $00
    db $80

; C: OAM list 2D of the table 5D47
OamList_B01_5D2B_2D::
    db $08
    db $00
    db $76
    db $00
    db $00
    db $00
    db $66
    db $00
    db $80

; C: OAM list 2E of the table 5D47
OamList_B01_5D2B_2E::
    db $08
    db $00
    db $77
    db $00
    db $00
    db $00
    db $67
    db $00
    db $80

; C: OAM list 2F of the table 5D47
OamList_B01_5D2B_2F::
    db $08
    db $00
    db $78
    db $00
    db $00
    db $00
    db $68
    db $00
    db $80

; C: OAM list 30 of the table 5D47
OamList_B01_5D2B_30::
    db $08
    db $00
    db $79
    db $00
    db $00
    db $00
    db $69
    db $00
    db $80

; C: OAM list 31 of the table 5D47
OamList_B01_5D2B_31::
    db $08
    db $00
    db $7a
    db $00
    db $00
    db $00
    db $6a
    db $00
    db $80

; C: OAM list 32 of the table 5D47
OamList_B01_5D2B_32::
    db $11
    db $01
    db $60
    db $30
    db $11
    db $1c
    db $60
    db $10
    db $80

; C: OAM list 33 of the table 5D47
OamList_B01_5D2B_33::
    db $11
    db $1b
    db $60
    db $10
    db $11
    db $02
    db $60
    db $30
    db $80

; I: OAM list 34 of the table 5D47
OamList_B01_5D2B_34::
    db $18
    db $06
    db $40
    db $00
    db $18
    db $02
    db $7e
    db $00
    db $18
    db $f0
    db $7c
    db $10
    db $18
    db $f8
    db $7d
    db $00

    db $10
    db $fd
    db $48
    db $10
    db $08
    db $fd
    db $44
    db $00
    db $10
    db $f5
    db $47
    db $10
    db $10
    db $ed
    db $46
    db $10
    db $10
    db $e5
    db $45
    db $10
    db $08
    db $f5
    db $43
    db $00
    db $08
    db $ed
    db $42
    db $00
    db $08
    db $e5
    db $41
    db $10
    db $80

; C: OAM list 35 of the table 5D47
OamList_B01_5D2B_35::
    db $08
    db $00
    db $6e
    db $10
    db $80

; C: OAM list 36 of the table 5D47
OamList_B01_5D2B_36::
    db $08
    db $08
    db $6f
    db $10
    db $80

; C: OAM list 37 of the table 5D47
OamList_B01_5D2B_37::
    db $f8
    db $f0
    db $73
    db $10
    db $f0
    db $f0
    db $72
    db $10
    db $f8
    db $e8
    db $71
    db $10
    db $f0
    db $e8
    db $70
    db $10
    db $80

; C: OAM list 38 of the table 5D47
OamList_B01_5D2B_38::
    db $f8
    db $18
    db $e9
    db $10
    db $f8
    db $10
    db $e8
    db $10
    db $f8
    db $08
    db $e7
    db $10
    db $f8
    db $00
    db $e6
    db $10
    db $f8
    db $f8
    db $e5
    db $10
    db $f0
    db $18
    db $d9
    db $10
    db $f0
    db $10
    db $d8
    db $10
    db $f0
    db $08
    db $d7
    db $10
    db $f0
    db $00
    db $d6
    db $10
    db $f0
    db $f8
    db $d5
    db $10
    db $f8
    db $f0
    db $63
    db $10
    db $f8
    db $e8
    db $62
    db $10
    db $f0
    db $f0
    db $61
    db $10
    db $f0
    db $e8
    db $60
    db $10
    db $80

; C: OAM list 39 of the table 5D47
OamList_B01_5D2B_39::
    db $f8
    db $18
    db $f1
    db $10
    db $f8
    db $10
    db $f0
    db $10
    db $f8
    db $08
    db $ef
    db $10
    db $f8
    db $00
    db $ee
    db $10
    db $f8
    db $f8
    db $ed
    db $10
    db $f0
    db $18
    db $ec
    db $10
    db $f0
    db $10
    db $eb
    db $10
    db $f0
    db $08
    db $ea
    db $10
    db $f0
    db $00
    db $db
    db $10
    db $f0
    db $f8
    db $da
    db $10
    db $f8
    db $f0
    db $67
    db $10
    db $f8
    db $e8
    db $66
    db $10
    db $f0
    db $f0
    db $65
    db $10
    db $f0
    db $e8
    db $64
    db $10
    db $80

; C: OAM list 3A of the table 5D47
OamList_B01_5D2B_3A::
    db $10
    db $20
    db $5f
    db $10
    db $10
    db $18
    db $5e
    db $10
    db $08
    db $20
    db $5d
    db $10
    db $08
    db $18
    db $5c
    db $10
    db $10
    db $10
    db $5b
    db $10
    db $10
    db $08
    db $5a
    db $10
    db $08
    db $10
    db $59
    db $10
    db $08
    db $08
    db $58
    db $10
    db $10
    db $00
    db $57
    db $10
    db $10
    db $f8
    db $56
    db $10
    db $08
    db $00
    db $55
    db $10
    db $08
    db $f8
    db $54
    db $10
    db $10
    db $f0
    db $53
    db $10
    db $10
    db $e8
    db $52
    db $10
    db $08
    db $f0
    db $51
    db $10
    db $08
    db $e8
    db $50
    db $10
    db $80

; C: OAM list 3B of the table 5D47
OamList_B01_5D2B_3B::
    db $28
    db $08
    db $5f
    db $10
    db $28
    db $00
    db $5e
    db $10
    db $20
    db $08
    db $5d
    db $10
    db $20
    db $00
    db $5c
    db $10
    db $10
    db $08
    db $59
    db $10
    db $10
    db $00
    db $58
    db $10
    db $08
    db $08
    db $57
    db $10
    db $08
    db $00
    db $56
    db $10
    db $18
    db $08
    db $5b
    db $10
    db $18
    db $00
    db $5a
    db $10
    db $00
    db $08
    db $55
    db $10
    db $00
    db $00
    db $54
    db $10
    db $f8
    db $08
    db $53
    db $10
    db $f8
    db $00
    db $52
    db $10
    db $f0
    db $08
    db $51
    db $10
    db $f0
    db $00
    db $50
    db $10
    db $80

; C: OAM list 3C of the table 5D47
OamList_B01_5D2B_3C::
    db $3d
    db $08
    db $75
    db $10
    db $15
    db $08
    db $75
    db $10
    db $ed
    db $08
    db $75
    db $10
    db $80

; C: OAM list 3D of the table 5D47
OamList_B01_5D2B_3D::
    db $51
    db $08
    db $75
    db $10
    db $29
    db $08
    db $75
    db $10
    db $01
    db $08
    db $75
    db $10
    db $80

; C: OAM list 3E of the table 5D47
OamList_B01_5D2B_3E::
    db $10
    db $26
    db $74
    db $10
    db $10
    db $06
    db $74
    db $10
    db $10
    db $e6
    db $74
    db $10
    db $10
    db $c6
    db $74
    db $10
    db $80

; C: OAM list 3F of the table 5D47
OamList_B01_5D2B_3F::
    db $10
    db $36
    db $74
    db $10
    db $10
    db $16
    db $74
    db $10
    db $10
    db $f6
    db $74
    db $10
    db $10
    db $d6
    db $74
    db $10
    db $80

; C: OAM list 40 of the table 5D47
OamList_B01_5D2B_40::
    db $2f
    db $14
    db $74
    db $10
    db $2f
    db $f4
    db $74
    db $10
    db $24
    db $2e
    db $75
    db $10
    db $04
    db $2e
    db $75
    db $10
    db $24
    db $df
    db $75
    db $10
    db $f0
    db $24
    db $74
    db $10
    db $f0
    db $04
    db $74
    db $10
    db $04
    db $df
    db $75
    db $10
    db $f0
    db $e4
    db $74
    db $10
    db $80

; C: OAM list 41 of the table 5D47
OamList_B01_5D2B_41::
    db $2f
    db $24
    db $74
    db $10
    db $2f
    db $04
    db $74
    db $10
    db $2f
    db $e4
    db $74
    db $10
    db $14
    db $2e
    db $75
    db $10
    db $f4
    db $2e
    db $75
    db $10
    db $14
    db $df
    db $75
    db $10
    db $f0
    db $14
    db $74
    db $10
    db $f4
    db $df
    db $75
    db $10
    db $f0
    db $f4
    db $74
    db $10
    db $80

; C: OAM list 42 of the table 5D47
OamList_B01_5D2B_42::
    db $0c
    db $f7
    db $64
    db $30
    db $0c
    db $11
    db $64
    db $10
    db $80

; C: OAM list 43 of the table 5D47
OamList_B01_5D2B_43::
    db $0c
    db $f7
    db $64
    db $30
    db $0c
    db $0f
    db $64
    db $10
    db $80

; C: OAM list 44 of the table 5D47
OamList_B01_5D2B_44::
    db $0c
    db $f9
    db $64
    db $30
    db $0c
    db $11
    db $64
    db $10
    db $80

; C: OAM list 45 of the table 5D47
OamList_B01_5D2B_45::
    db $10
    db $00
    db $59
    db $30
    db $08
    db $00
    db $51
    db $30
    db $10
    db $08
    db $59
    db $10
    db $08
    db $08
    db $51
    db $10
    db $80

; C: OAM list 46 of the table 5D47
OamList_B01_5D2B_46::
    db $10
    db $08
    db $5f
    db $10
    db $10
    db $00
    db $5e
    db $10
    db $08
    db $08
    db $57
    db $10
    db $08
    db $00
    db $56
    db $10
    db $80

; C: OAM list 47 of the table 5D47
OamList_B01_5D2B_47::
    db $10
    db $08
    db $5d
    db $10
    db $10
    db $00
    db $5c
    db $10
    db $08
    db $08
    db $55
    db $10
    db $08
    db $00
    db $54
    db $10
    db $80

; C: OAM list 48 of the table 5D47
OamList_B01_5D2B_48::
    db $10
    db $08
    db $5b
    db $10
    db $10
    db $00
    db $5a
    db $10
    db $08
    db $08
    db $53
    db $10
    db $08
    db $00
    db $52
    db $10
    db $80

; C: OAM list 49 of the table 5D47
OamList_B01_5D2B_49::
    db $10
    db $08
    db $58
    db $30
    db $10
    db $00
    db $58
    db $10
    db $08
    db $08
    db $50
    db $30
    db $08
    db $00
    db $50
    db $10
    db $80

; C: OAM list 4A of the table 5D47
OamList_B01_5D2B_4A::
    db $10
    db $00
    db $5b
    db $30
    db $10
    db $08
    db $5a
    db $30
    db $08
    db $00
    db $53
    db $30
    db $08
    db $08
    db $52
    db $30
    db $80

; C: OAM list 4B of the table 5D47
OamList_B01_5D2B_4B::
    db $10
    db $00
    db $5d
    db $30
    db $10
    db $08
    db $5c
    db $30
    db $08
    db $00
    db $55
    db $30
    db $08
    db $08
    db $54
    db $30
    db $80

; C: OAM list 4C of the table 5D47
OamList_B01_5D2B_4C::
    db $10
    db $00
    db $5f
    db $30
    db $10
    db $08
    db $5e
    db $30
    db $08
    db $00
    db $57
    db $30
    db $08
    db $08
    db $56
    db $30
    db $80

; C: OAM list 4D of the table 5D47
OamList_B01_5D2B_4D::
    db $10
    db $08
    db $63
    db $10
    db $10
    db $00
    db $62
    db $10
    db $08
    db $08
    db $61
    db $10
    db $08
    db $00
    db $60
    db $10
    db $80

; I: OAM list 4E of the table 5D47
OamList_B01_5D2B_4E::
    db $08
    db $14
    db $9b
    db $10
    db $08
    db $f4
    db $9a
    db $10
    db $10
    db $14
    db $6c
    db $10
    db $10
    db $0c
    db $6b
    db $10
    db $10
    db $04
    db $6a
    db $10
    db $10
    db $fc
    db $69
    db $10
    db $10
    db $f4
    db $68
    db $10
    db $08
    db $0c
    db $67
    db $10
    db $08
    db $04
    db $66
    db $10
    db $08
    db $fc
    db $65
    db $10
    db $80

; C: OAM list 4F of the table 5D47
OamList_B01_5D2B_4F::
    db $08
    db $08
    db $a0
    db $a0
    db $08
    db $00
    db $a0
    db $80
    db $80

; C: OAM list 50 of the table 5D47
OamList_B01_5D2B_50::
    db $08
    db $08
    db $a4
    db $80
    db $08
    db $00
    db $a2
    db $80
    db $80

; C: OAM list 51 of the table 5D47
OamList_B01_5D2B_51::
    db $08
    db $00
    db $a4
    db $a0
    db $08
    db $08
    db $a2
    db $a0
    db $80

; C: OAM list 52 of the table 5D47
OamList_B01_5D2B_52::
    db $08
    db $08
    db $a8
    db $80
    db $08
    db $00
    db $a6
    db $80
    db $80

; C: OAM list 53 of the table 5D47
OamList_B01_5D2B_53::
    db $08
    db $00
    db $a8
    db $a0
    db $08
    db $08
    db $a6
    db $a0
    db $80

; C: OAM list 54 of the table 5D47
OamList_B01_5D2B_54::
    db $08
    db $08
    db $b2
    db $80
    db $08
    db $00
    db $b0
    db $80
    db $80

; C: OAM list 55 of the table 5D47
OamList_B01_5D2B_55::
    db $08
    db $08
    db $b6
    db $80
    db $08
    db $00
    db $b4
    db $80
    db $80

; C: OAM list 56 of the table 5D47
OamList_B01_5D2B_56::
    db $08
    db $08
    db $ba
    db $80
    db $08
    db $00
    db $b8
    db $80
    db $80

; C: OAM list 57 of the table 5D47
OamList_B01_5D2B_57::
    db $0c
    db $08
    db $be
    db $80
    db $0c
    db $00
    db $bc
    db $80
    db $80

; C: OAM list 58 of the table 5D47
OamList_B01_5D2B_58::
    db $0c
    db $08
    db $92
    db $80
    db $0c
    db $00
    db $90
    db $80
    db $80

; C: OAM list 59 of the table 5D47
OamList_B01_5D2B_59::
    db $0c
    db $08
    db $96
    db $80
    db $0c
    db $00
    db $94
    db $80
    db $80

; C: OAM list 5A of the table 5D47
OamList_B01_5D2B_5A::
    db $0c
    db $04
    db $aa
    db $80
    db $80

; C: OAM list 5B of the table 5D47
OamList_B01_5D2B_5B::
    db $0c
    db $04
    db $ac
    db $80
    db $80

; C: OAM list 5C of the table 5D47
OamList_B01_5D2B_5C::
    db $08
    db $08
    db $ae
    db $a0
    db $08
    db $00
    db $ae
    db $80
    db $80

; C: OAM list 5D of the table 5D47
OamList_B01_5D2B_5D::
    db $0a
    db $07
    db $8c
    db $80
    db $80

; C: OAM list 5E of the table 5D47
OamList_B01_5D2B_5E::
    db $0c
    db $04
    db $9a
    db $80
    db $80

; C: OAM list 5F of the table 5D47
OamList_B01_5D2B_5F::
    db $0c
    db $04
    db $9c
    db $80
    db $80

; C: OAM list 60 of the table 5D47
OamList_B01_5D2B_60::
    db $0f
    db $00
    db $9e
    db $80
    db $80

; C: OAM list 61 of the table 5D47
OamList_B01_5D2B_61::
    db $0c
    db $04
    db $8e
    db $80
    db $80

; C: OAM list 62 of the table 5D47
OamList_B01_5D2B_62::
    db $20
    db $20
    db $fe
    db $80
    db $20
    db $18
    db $fc
    db $80
    db $20
    db $10
    db $fa
    db $80
    db $20
    db $08
    db $f8
    db $80
    db $20
    db $00
    db $f6
    db $80
    db $20
    db $f8
    db $f4
    db $80
    db $20
    db $f0
    db $f2
    db $80
    db $20
    db $e8
    db $f0
    db $80
    db $10
    db $20
    db $ee
    db $80
    db $10
    db $18
    db $ec
    db $80
    db $10
    db $10
    db $ea
    db $80
    db $10
    db $08
    db $e8
    db $80
    db $10
    db $00
    db $e6
    db $80
    db $10
    db $f8
    db $e4
    db $80
    db $10
    db $f0
    db $e2
    db $80
    db $10
    db $e8
    db $e0
    db $80
    db $00
    db $20
    db $de
    db $80
    db $00
    db $18
    db $dc
    db $80
    db $00
    db $10
    db $da
    db $80
    db $00
    db $08
    db $d8
    db $80
    db $00
    db $00
    db $d6
    db $80
    db $00
    db $f8
    db $d4
    db $80
    db $00
    db $f0
    db $d2
    db $80
    db $00
    db $e8
    db $d0
    db $80
    db $f0
    db $20
    db $ce
    db $80
    db $f0
    db $18
    db $cc
    db $80
    db $f0
    db $10
    db $ca
    db $80
    db $f0
    db $08
    db $c8
    db $80
    db $f0
    db $00
    db $c6
    db $80
    db $f0
    db $f8
    db $c4
    db $80
    db $f0
    db $f0
    db $c2
    db $80
    db $f0
    db $e8
    db $c0
    db $80
    db $80

; C: OAM list 63 of the table 5D47
OamList_B01_5D2B_63::
    db $20
    db $20
    db $3e
    db $80
    db $20
    db $18
    db $3c
    db $80
    db $20
    db $10
    db $3a
    db $80
    db $20
    db $08
    db $38
    db $80
    db $20
    db $00
    db $36
    db $80
    db $20
    db $f8
    db $34
    db $80
    db $20
    db $f0
    db $32
    db $80
    db $20
    db $e8
    db $30
    db $80
    db $10
    db $20
    db $2e
    db $80
    db $10
    db $18
    db $2c
    db $80
    db $10
    db $10
    db $2a
    db $80
    db $10
    db $08
    db $28
    db $80
    db $10
    db $00
    db $26
    db $80
    db $10
    db $f8
    db $24
    db $80
    db $10
    db $f0
    db $22
    db $80
    db $10
    db $e8
    db $20
    db $80
    db $00
    db $20
    db $1e
    db $80
    db $00
    db $18
    db $1c
    db $80
    db $00
    db $10
    db $1a
    db $80
    db $00
    db $08
    db $18
    db $80
    db $00
    db $00
    db $16
    db $80
    db $00
    db $f8
    db $14
    db $80
    db $00
    db $f0
    db $12
    db $80
    db $00
    db $e8
    db $10
    db $80
    db $f0
    db $20
    db $0e
    db $80
    db $f0
    db $18
    db $0c
    db $80
    db $f0
    db $10
    db $0a
    db $80
    db $f0
    db $08
    db $08
    db $80
    db $f0
    db $00
    db $06
    db $80
    db $f0
    db $f8
    db $04
    db $80
    db $f0
    db $f0
    db $02
    db $80
    db $f0
    db $e8
    db $00
    db $80
    db $80

; C: OAM list 64 of the table 5D47
OamList_B01_5D2B_64::
    db $20
    db $20
    db $7e
    db $80
    db $20
    db $18
    db $7c
    db $80
    db $20
    db $10
    db $7a
    db $80
    db $20
    db $08
    db $78
    db $80
    db $20
    db $00
    db $76
    db $80
    db $20
    db $f8
    db $74
    db $80
    db $20
    db $f0
    db $72
    db $80
    db $20
    db $e8
    db $70
    db $80
    db $10
    db $20
    db $6e
    db $80
    db $10
    db $18
    db $6c
    db $80
    db $10
    db $10
    db $6a
    db $80
    db $10
    db $08
    db $68
    db $80
    db $10
    db $00
    db $66
    db $80
    db $10
    db $f8
    db $64
    db $80
    db $10
    db $f0
    db $62
    db $80
    db $10
    db $e8
    db $60
    db $80
    db $00
    db $20
    db $5e
    db $80
    db $00
    db $18
    db $5c
    db $80
    db $00
    db $10
    db $5a
    db $80
    db $00
    db $08
    db $58
    db $80
    db $00
    db $00
    db $56
    db $80
    db $00
    db $f8
    db $54
    db $80
    db $00
    db $f0
    db $52
    db $80
    db $00
    db $e8
    db $50
    db $80
    db $f0
    db $20
    db $4e
    db $80
    db $f0
    db $18
    db $4c
    db $80
    db $f0
    db $10
    db $4a
    db $80
    db $f0
    db $08
    db $48
    db $80
    db $f0
    db $00
    db $46
    db $80
    db $f0
    db $f8
    db $44
    db $80
    db $f0
    db $f0
    db $42
    db $80
    db $f0
    db $e8
    db $40
    db $80
    db $80

; C: OAM list 65 of the table 5D47
OamList_B01_5D2B_65::
    db $20
    db $20
    db $fe
    db $80
    db $20
    db $18
    db $fc
    db $80
    db $20
    db $10
    db $fa
    db $80
    db $20
    db $08
    db $f8
    db $80
    db $20
    db $00
    db $f6
    db $80
    db $20
    db $f8
    db $f4
    db $80
    db $20
    db $f0
    db $f2
    db $80
    db $10
    db $20
    db $ee
    db $80
    db $10
    db $18
    db $ec
    db $80
    db $10
    db $10
    db $ea
    db $80
    db $10
    db $08
    db $e8
    db $80
    db $10
    db $00
    db $e6
    db $80
    db $10
    db $f8
    db $e4
    db $80
    db $10
    db $f0
    db $e2
    db $80
    db $00
    db $20
    db $de
    db $80
    db $00
    db $18
    db $dc
    db $80
    db $00
    db $10
    db $da
    db $80
    db $00
    db $08
    db $d8
    db $80
    db $00
    db $00
    db $d6
    db $80
    db $00
    db $f8
    db $d4
    db $80
    db $00
    db $f0
    db $d2
    db $80
    db $f0
    db $20
    db $ce
    db $80
    db $f0
    db $18
    db $cc
    db $80
    db $f0
    db $10
    db $ca
    db $80
    db $f0
    db $08
    db $c8
    db $80
    db $f0
    db $00
    db $c6
    db $80
    db $f0
    db $f8
    db $c4
    db $80
    db $f0
    db $f0
    db $c2
    db $80
    db $80

; C: OAM list 66 of the table 5D47
OamList_B01_5D2B_66::
    db $20
    db $20
    db $3e
    db $80
    db $20
    db $18
    db $3c
    db $80
    db $20
    db $10
    db $3a
    db $80
    db $20
    db $08
    db $38
    db $80
    db $20
    db $00
    db $36
    db $80
    db $20
    db $f8
    db $34
    db $80
    db $20
    db $f0
    db $32
    db $80
    db $10
    db $20
    db $2e
    db $80
    db $10
    db $18
    db $2c
    db $80
    db $10
    db $10
    db $2a
    db $80
    db $10
    db $08
    db $28
    db $80
    db $10
    db $00
    db $26
    db $80
    db $10
    db $f8
    db $24
    db $80
    db $10
    db $f0
    db $22
    db $80
    db $00
    db $20
    db $1e
    db $80
    db $00
    db $18
    db $1c
    db $80
    db $00
    db $10
    db $1a
    db $80
    db $00
    db $08
    db $18
    db $80
    db $00
    db $00
    db $16
    db $80
    db $00
    db $f8
    db $14
    db $80
    db $00
    db $f0
    db $12
    db $80
    db $f0
    db $20
    db $0e
    db $80
    db $f0
    db $18
    db $0c
    db $80
    db $f0
    db $10
    db $0a
    db $80
    db $f0
    db $08
    db $08
    db $80
    db $f0
    db $00
    db $06
    db $80
    db $f0
    db $f8
    db $04
    db $80
    db $f0
    db $f0
    db $02
    db $80
    db $80

; C: OAM list 67 of the table 5D47
OamList_B01_5D2B_67::
    db $20
    db $20
    db $7e
    db $80
    db $20
    db $18
    db $7c
    db $80
    db $20
    db $10
    db $7a
    db $80
    db $20
    db $08
    db $78
    db $80
    db $20
    db $00
    db $76
    db $80
    db $20
    db $f8
    db $74
    db $80
    db $20
    db $f0
    db $72
    db $80
    db $10
    db $20
    db $6e
    db $80
    db $10
    db $18
    db $6c
    db $80
    db $10
    db $10
    db $6a
    db $80
    db $10
    db $08
    db $68
    db $80
    db $10
    db $00
    db $66
    db $80
    db $10
    db $f8
    db $64
    db $80
    db $10
    db $f0
    db $62
    db $80
    db $00
    db $20
    db $5e
    db $80
    db $00
    db $18
    db $5c
    db $80
    db $00
    db $10
    db $5a
    db $80
    db $00
    db $08
    db $58
    db $80
    db $00
    db $00
    db $56
    db $80
    db $00
    db $f8
    db $54
    db $80
    db $00
    db $f0
    db $52
    db $80
    db $f0
    db $20
    db $4e
    db $80
    db $f0
    db $18
    db $4c
    db $80
    db $f0
    db $10
    db $4a
    db $80
    db $f0
    db $08
    db $48
    db $80
    db $f0
    db $00
    db $46
    db $80
    db $f0
    db $f8
    db $44
    db $80
    db $f0
    db $f0
    db $42
    db $80
    db $80

; C: OAM list 68 of the table 5D47
OamList_B01_5D2B_68::
    db $1e
    db $1e
    db $fe
    db $80
    db $1e
    db $16
    db $fc
    db $80
    db $1e
    db $0f
    db $fa
    db $80
    db $1e
    db $07
    db $f8
    db $80
    db $1e
    db $01
    db $f6
    db $80
    db $1e
    db $f9
    db $f4
    db $80
    db $1e
    db $f2
    db $f2
    db $80
    db $1e
    db $ea
    db $f0
    db $80
    db $0f
    db $1e
    db $ee
    db $80
    db $0f
    db $16
    db $ec
    db $80
    db $0f
    db $0f
    db $ea
    db $80
    db $0f
    db $07
    db $e8
    db $80
    db $0f
    db $01
    db $e6
    db $80
    db $0f
    db $f9
    db $e4
    db $80
    db $0f
    db $f2
    db $e2
    db $80
    db $0f
    db $ea
    db $e0
    db $80
    db $01
    db $1e
    db $de
    db $80
    db $01
    db $16
    db $dc
    db $80
    db $01
    db $0f
    db $da
    db $80
    db $01
    db $07
    db $d8
    db $80
    db $01
    db $01
    db $d6
    db $80
    db $01
    db $f9
    db $d4
    db $80
    db $01
    db $f2
    db $d2
    db $80
    db $01
    db $ea
    db $d0
    db $80
    db $f2
    db $1e
    db $ce
    db $80
    db $f2
    db $16
    db $cc
    db $80
    db $f2
    db $0f
    db $ca
    db $80
    db $f2
    db $07
    db $c8
    db $80
    db $f2
    db $01
    db $c6
    db $80
    db $f2
    db $f9
    db $c4
    db $80
    db $f2
    db $f2
    db $c2
    db $80
    db $f2
    db $ea
    db $c0
    db $80
    db $80

; C: OAM list 69 of the table 5D47
OamList_B01_5D2B_69::
    db $1c
    db $1c
    db $fe
    db $80
    db $1c
    db $14
    db $fc
    db $80
    db $1c
    db $0e
    db $fa
    db $80
    db $1c
    db $06
    db $f8
    db $80
    db $1c
    db $02
    db $f6
    db $80
    db $1c
    db $fa
    db $f4
    db $80
    db $1c
    db $f4
    db $f2
    db $80
    db $1c
    db $ec
    db $f0
    db $80
    db $0e
    db $1c
    db $ee
    db $80
    db $0e
    db $14
    db $ec
    db $80
    db $0e
    db $0e
    db $ea
    db $80
    db $0e
    db $06
    db $e8
    db $80
    db $0e
    db $02
    db $e6
    db $80
    db $0e
    db $fa
    db $e4
    db $80
    db $0e
    db $f4
    db $e2
    db $80
    db $0e
    db $ec
    db $e0
    db $80
    db $02
    db $1c
    db $de
    db $80
    db $02
    db $14
    db $dc
    db $80
    db $02
    db $0e
    db $da
    db $80
    db $02
    db $06
    db $d8
    db $80
    db $02
    db $02
    db $d6
    db $80
    db $02
    db $fa
    db $d4
    db $80
    db $02
    db $f4
    db $d2
    db $80
    db $02
    db $ec
    db $d0
    db $80
    db $f4
    db $1c
    db $ce
    db $80
    db $f4
    db $14
    db $cc
    db $80
    db $f4
    db $0e
    db $ca
    db $80
    db $f4
    db $06
    db $c8
    db $80
    db $f4
    db $02
    db $c6
    db $80
    db $f4
    db $fa
    db $c4
    db $80
    db $f4
    db $f4
    db $c2
    db $80
    db $f4
    db $ec
    db $c0
    db $80
    db $80

; C: OAM list 6A of the table 5D47
OamList_B01_5D2B_6A::
    db $1a
    db $1a
    db $fe
    db $80
    db $1a
    db $12
    db $fc
    db $80
    db $1a
    db $0d
    db $fa
    db $80
    db $1a
    db $06
    db $f8
    db $80
    db $1a
    db $03
    db $f6
    db $80
    db $1a
    db $fb
    db $f4
    db $80
    db $1a
    db $f6
    db $f2
    db $80
    db $1a
    db $ee
    db $f0
    db $80
    db $0d
    db $1a
    db $ee
    db $80
    db $0d
    db $12
    db $ec
    db $80
    db $0d
    db $0d
    db $ea
    db $80
    db $0d
    db $06
    db $e8
    db $80
    db $0d
    db $03
    db $e6
    db $80
    db $0d
    db $fb
    db $e4
    db $80
    db $0d
    db $f6
    db $e2
    db $80
    db $0d
    db $ee
    db $e0
    db $80
    db $03
    db $1a
    db $de
    db $80
    db $03
    db $12
    db $dc
    db $80
    db $03
    db $0d
    db $da
    db $80
    db $03
    db $06
    db $d8
    db $80
    db $03
    db $03
    db $d6
    db $80
    db $03
    db $fb
    db $d4
    db $80
    db $03
    db $f6
    db $d2
    db $80
    db $03
    db $ee
    db $d0
    db $80
    db $f6
    db $1a
    db $ce
    db $80
    db $f6
    db $12
    db $cc
    db $80
    db $f6
    db $0d
    db $ca
    db $80
    db $f6
    db $06
    db $c8
    db $80
    db $f6
    db $03
    db $c6
    db $80
    db $f6
    db $fb
    db $c4
    db $80
    db $f6
    db $f6
    db $c2
    db $80
    db $f6
    db $ee
    db $c0
    db $80
    db $80

; C: OAM list 6B of the table 5D47
OamList_B01_5D2B_6B::
    db $1e
    db $1e
    db $fe
    db $80
    db $1e
    db $16
    db $fc
    db $80
    db $1e
    db $0f
    db $fa
    db $80
    db $1e
    db $07
    db $f8
    db $80
    db $1e
    db $01
    db $f6
    db $80
    db $1e
    db $f9
    db $f4
    db $80
    db $1e
    db $f2
    db $f2
    db $80
    db $0f
    db $1e
    db $ee
    db $80
    db $0f
    db $16
    db $ec
    db $80
    db $0f
    db $0f
    db $ea
    db $80
    db $0f
    db $07
    db $e8
    db $80
    db $0f
    db $01
    db $e6
    db $80
    db $0f
    db $f9
    db $e4
    db $80
    db $0f
    db $f2
    db $e2
    db $80
    db $01
    db $1e
    db $de
    db $80
    db $01
    db $16
    db $dc
    db $80
    db $01
    db $0f
    db $da
    db $80
    db $01
    db $07
    db $d8
    db $80
    db $01
    db $01
    db $d6
    db $80
    db $01
    db $f9
    db $d4
    db $80
    db $01
    db $f2
    db $d2
    db $80
    db $f2
    db $1e
    db $ce
    db $80
    db $f2
    db $16
    db $cc
    db $80
    db $f2
    db $0f
    db $ca
    db $80
    db $f2
    db $07
    db $c8
    db $80
    db $f2
    db $01
    db $c6
    db $80
    db $f2
    db $f9
    db $c4
    db $80
    db $f2
    db $f2
    db $c2
    db $80
    db $80

; C: OAM list 6C of the table 5D47
OamList_B01_5D2B_6C::
    db $1c
    db $1c
    db $fe
    db $80
    db $1c
    db $14
    db $fc
    db $80
    db $1c
    db $0e
    db $fa
    db $80
    db $1c
    db $06
    db $f8
    db $80
    db $1c
    db $02
    db $f6
    db $80
    db $1c
    db $fa
    db $f4
    db $80
    db $1c
    db $f4
    db $f2
    db $80
    db $0e
    db $1c
    db $ee
    db $80
    db $0e
    db $14
    db $ec
    db $80
    db $0e
    db $0e
    db $ea
    db $80
    db $0e
    db $06
    db $e8
    db $80
    db $0e
    db $02
    db $e6
    db $80
    db $0e
    db $fa
    db $e4
    db $80
    db $0e
    db $f4
    db $e2
    db $80
    db $02
    db $1c
    db $de
    db $80
    db $02
    db $14
    db $dc
    db $80
    db $02
    db $0e
    db $da
    db $80
    db $02
    db $06
    db $d8
    db $80
    db $02
    db $02
    db $d6
    db $80
    db $02
    db $fa
    db $d4
    db $80
    db $02
    db $f4
    db $d2
    db $80
    db $f4
    db $1c
    db $ce
    db $80
    db $f4
    db $14
    db $cc
    db $80
    db $f4
    db $0e
    db $ca
    db $80
    db $f4
    db $06
    db $c8
    db $80
    db $f4
    db $02
    db $c6
    db $80
    db $f4
    db $fa
    db $c4
    db $80
    db $f4
    db $f4
    db $c2
    db $80
    db $80

; C: OAM list 6D of the table 5D47
OamList_B01_5D2B_6D::
    db $1a
    db $1a
    db $fe
    db $80
    db $1a
    db $12
    db $fc
    db $80
    db $1a
    db $0d
    db $fa
    db $80
    db $1a
    db $06
    db $f8
    db $80
    db $1a
    db $03
    db $f6
    db $80
    db $1a
    db $fb
    db $f4
    db $80
    db $1a
    db $f6
    db $f2
    db $80
    db $0d
    db $1a
    db $ee
    db $80
    db $0d
    db $12
    db $ec
    db $80
    db $0d
    db $0d
    db $ea
    db $80
    db $0d
    db $06
    db $e8
    db $80
    db $0d
    db $03
    db $e6
    db $80
    db $0d
    db $fb
    db $e4
    db $80
    db $0d
    db $f6
    db $e2
    db $80
    db $03
    db $1a
    db $de
    db $80
    db $03
    db $12
    db $dc
    db $80
    db $03
    db $0d
    db $da
    db $80
    db $03
    db $06
    db $d8
    db $80
    db $03
    db $03
    db $d6
    db $80
    db $03
    db $fb
    db $d4
    db $80
    db $03
    db $f6
    db $d2
    db $80
    db $f6
    db $1a
    db $ce
    db $80
    db $f6
    db $12
    db $cc
    db $80
    db $f6
    db $0d
    db $ca
    db $80
    db $f6
    db $06
    db $c8
    db $80
    db $f6
    db $03
    db $c6
    db $80
    db $f6
    db $fb
    db $c4
    db $80
    db $f6
    db $f6
    db $c2
    db $80
    db $80

; C: OAM list 6E of the table 5D47
OamList_B01_5D2B_6E::
    db $0b
    db $03
    db $60
    db $00
    db $80

; C: OAM list 6F of the table 5D47
OamList_B01_5D2B_6F::
    db $0b
    db $05
    db $60
    db $20
    db $80

; C: OAM list 70 of the table 5D47
OamList_B01_5D2B_70::
    db $0b
    db $03
    db $61
    db $00
    db $80

; C: OAM list 71 of the table 5D47
OamList_B01_5D2B_71::
    db $0b
    db $05
    db $61
    db $20
    db $80

; C: OAM list 72 of the table 5D47
OamList_B01_5D2B_72::
    db $0e
    db $06
    db $64
    db $10
    db $80

; C: OAM list 73 of the table 5D47
OamList_B01_5D2B_73::
    db $0e
    db $06
    db $64
    db $00
    db $80

; C: OAM list 74 of the table 5D47
OamList_B01_5D2B_74::
    db $0e
    db $05
    db $65
    db $10
    db $80

; C: OAM list 75 of the table 5D47
OamList_B01_5D2B_75::
    db $0e
    db $05
    db $65
    db $00
    db $80

; C: OAM list 76 of the table 5D47
OamList_B01_5D2B_76::
    db $0c
    db $06
    db $63
    db $10
    db $80

; C: OAM list 77 of the table 5D47
OamList_B01_5D2B_77::
    db $0c
    db $06
    db $62
    db $00
    db $80

; C: OAM list 78 of the table 5D47
OamList_B01_5D2B_78::
    db $0e
    db $06
    db $66
    db $00
    db $80

; C: OAM list 79 of the table 5D47
OamList_B01_5D2B_79::
    db $0e
    db $06
    db $67
    db $00
    db $80

; C: OAM list 7A of the table 5D47
OamList_B01_5D2B_7A::
    db $0b
    db $03
    db $68
    db $00
    db $80

; C: OAM list 7B of the table 5D47
OamList_B01_5D2B_7B::
    db $0b
    db $03
    db $69
    db $00
    db $80

; C: OAM list 7C of the table 5D47
OamList_B01_5D2B_7C::
    db $0c
    db $06
    db $6a
    db $00
    db $80

; C: OAM list 7D of the table 5D47
OamList_B01_5D2B_7D::
    db $16
    db $05
    db $6b
    db $50
    db $02
    db $05
    db $6b
    db $10
    db $80

; C: OAM list 7E of the table 5D47
OamList_B01_5D2B_7E::
    db $08
    db $00
    db $6e
    db $00
    db $80

; C: OAM list 7F of the table 5D47
OamList_B01_5D2B_7F::
    db $08
    db $08
    db $70
    db $00
    db $80

; C: OAM list 80 of the table 5D47
OamList_B01_5D2B_80::
    db $08
    db $08
    db $71
    db $00
    db $80

; C: OAM list 81 of the table 5D47
OamList_B01_5D2B_81::
    db $08
    db $08
    db $72
    db $00
    db $80

; C: OAM list 82 of the table 5D47
OamList_B01_5D2B_82::
    db $08
    db $08
    db $73
    db $00
    db $80

; C: OAM list 83 of the table 5D47
OamList_B01_5D2B_83::
    db $08
    db $08
    db $74
    db $00
    db $80

; C: OAM list 84 of the table 5D47
OamList_B01_5D2B_84::
    db $08
    db $08
    db $75
    db $00
    db $80

; C: OAM list 85 of the table 5D47
OamList_B01_5D2B_85::
    db $08
    db $08
    db $76
    db $00
    db $80

; C: OAM list 86 of the table 5D47
OamList_B01_5D2B_86::
    db $08
    db $08
    db $77
    db $00
    db $80

; C: OAM list 87 of the table 5D47
OamList_B01_5D2B_87::
    db $08
    db $08
    db $78
    db $00
    db $80

; C: OAM list 88 of the table 5D47
OamList_B01_5D2B_88::
    db $08
    db $08
    db $79
    db $00
    db $80

; C: OAM list 89 of the table 5D47
OamList_B01_5D2B_89::
    db $08
    db $08
    db $7a
    db $00
    db $80

; C: OAM list 8A of the table 5D47
OamList_B01_5D2B_8A::
    db $0b
    db $04
    db $61
    db $00
    db $80

; C: OAM list 8B of the table 5D47
OamList_B01_5D2B_8B::
    db $f1
    db $08
    db $6d
    db $00
    db $f9
    db $08
    db $6d
    db $00
    db $01
    db $08
    db $6d
    db $00
    db $09
    db $08
    db $6d
    db $00
    db $80

; C: OAM list 8C of the table 5D47
OamList_B01_5D2B_8C::
    db $0c
    db $0d
    db $7b
    db $30
    db $0c
    db $fd
    db $7b
    db $10
    db $80

; C: OAM list 8D of the table 5D47
OamList_B01_5D2B_8D::
    db $0c
    db $0e
    db $7b
    db $30
    db $0c
    db $fc
    db $7b
    db $10
    db $80

; C: OAM list 8E of the table 5D47
OamList_B01_5D2B_8E::
    db $0c
    db $fd
    db $7b
    db $10
    db $80

; C: OAM list 8F of the table 5D47
OamList_B01_5D2B_8F::
    db $0c
    db $fc
    db $7b
    db $10
    db $80

; C: OAM list 90 of the table 5D47
OamList_B01_5D2B_90::
    db $0c
    db $0d
    db $7b
    db $30
    db $80

; C: OAM list 91 of the table 5D47
OamList_B01_5D2B_91::
    db $0c
    db $0e
    db $7b
    db $30
    db $80

; C: OAM list 92 of the table 5D47
OamList_B01_5D2B_92::
    db $08
    db $08
    db $50
    db $10
    db $08
    db $0e
    db $51
    db $10
    db $08
    db $14
    db $52
    db $10
    db $80

; C: OAM list 93 of the table 5D47
OamList_B01_5D2B_93::
    db $08
    db $16
    db $52
    db $10
    db $08
    db $0f
    db $51
    db $10
    db $08
    db $08
    db $50
    db $10
    db $80

; C: OAM list 94 of the table 5D47
OamList_B01_5D2B_94::
    db $08
    db $18
    db $52
    db $10
    db $08
    db $10
    db $51
    db $10
    db $08
    db $08
    db $50
    db $10
    db $80

; C: OAM list 95 of the table 5D47
OamList_B01_5D2B_95::
    db $08
    db $08
    db $53
    db $10
    db $08
    db $0e
    db $54
    db $10
    db $08
    db $14
    db $55
    db $10
    db $80

; C: OAM list 96 of the table 5D47
OamList_B01_5D2B_96::
    db $08
    db $16
    db $55
    db $10
    db $08
    db $0f
    db $54
    db $10
    db $08
    db $08
    db $53
    db $10
    db $80

; C: OAM list 97 of the table 5D47
OamList_B01_5D2B_97::
    db $08
    db $18
    db $55
    db $10
    db $08
    db $10
    db $54
    db $10
    db $08
    db $08
    db $53
    db $10
    db $80

; C: OAM list 98 of the table 5D47
OamList_B01_5D2B_98::
    db $08
    db $08
    db $56
    db $10
    db $08
    db $14
    db $58
    db $10
    db $08
    db $0e
    db $57
    db $10
    db $80

; C: OAM list 99 of the table 5D47
OamList_B01_5D2B_99::
    db $08
    db $08
    db $56
    db $10
    db $08
    db $16
    db $58
    db $10
    db $08
    db $0f
    db $57
    db $10
    db $80

; C: OAM list 9A of the table 5D47
OamList_B01_5D2B_9A::
    db $08
    db $18
    db $58
    db $10
    db $08
    db $10
    db $57
    db $10
    db $08
    db $08
    db $56
    db $10
    db $80

; C: OAM list 9B of the table 5D47
OamList_B01_5D2B_9B::
    db $08
    db $14
    db $5b
    db $10
    db $08
    db $08
    db $59
    db $10
    db $08
    db $0e
    db $57
    db $10
    db $80

; C: OAM list 9C of the table 5D47
OamList_B01_5D2B_9C::
    db $08
    db $16
    db $5b
    db $10
    db $08
    db $0f
    db $5a
    db $10
    db $08
    db $08
    db $59
    db $10
    db $80

; C: OAM list 9D of the table 5D47
OamList_B01_5D2B_9D::
    db $08
    db $18
    db $5b
    db $10
    db $08
    db $10
    db $5a
    db $10
    db $08
    db $08
    db $59
    db $10
    db $80

; C: OAM list 9E of the table 5D47
OamList_B01_5D2B_9E::
    db $08
    db $08
    db $5c
    db $10
    db $08
    db $0e
    db $5d
    db $10
    db $08
    db $14
    db $5e
    db $10
    db $80

; C: OAM list 9F of the table 5D47
OamList_B01_5D2B_9F::
    db $08
    db $08
    db $5c
    db $10
    db $08
    db $0f
    db $5d
    db $10
    db $08
    db $16
    db $5e
    db $10
    db $80

; C: OAM list A0 of the table 5D47
OamList_B01_5D2B_A0::
    db $08
    db $18
    db $5e
    db $10
    db $08
    db $10
    db $5d
    db $10
    db $08
    db $08
    db $5c
    db $10
    db $80

; C: OAM list A1 of the table 5D47
OamList_B01_5D2B_A1::
    db $08
    db $08
    db $7c
    db $10
    db $08
    db $0e
    db $7d
    db $10
    db $08
    db $14
    db $7e
    db $10
    db $80

; C: OAM list A2 of the table 5D47
OamList_B01_5D2B_A2::
    db $08
    db $08
    db $7c
    db $10
    db $08
    db $0f
    db $7d
    db $10
    db $08
    db $16
    db $7e
    db $10
    db $80

; C: OAM list A3 of the table 5D47
OamList_B01_5D2B_A3::
    db $08
    db $18
    db $7e
    db $10
    db $08
    db $10
    db $7d
    db $10
    db $08
    db $08
    db $7c
    db $10
    db $80

; C: OAM list A4 of the table 5D47
OamList_B01_5D2B_A4::
    db $08
    db $10
    db $6d
    db $00
    db $08
    db $08
    db $7c
    db $10
    db $80

; C: OAM list A5 of the table 5D47
OamList_B01_5D2B_A5::
    db $10
    db $08
    db $6c
    db $10
    db $18
    db $08
    db $f9
    db $00
    db $08
    db $08
    db $6c
    db $10
    db $f8
    db $08
    db $6c
    db $10
    db $00
    db $08
    db $6c
    db $10
    db $f0
    db $08
    db $6c
    db $10
    db $80

; C: OAM list A6 of the table 5D47
OamList_B01_5D2B_A6::
    db $10
    db $10
    db $46
    db $00
    db $10
    db $08
    db $45
    db $00
    db $08
    db $10
    db $44
    db $00
    db $08
    db $08
    db $43
    db $00
    db $00
    db $10
    db $42
    db $00
    db $00
    db $08
    db $41
    db $00
    db $00
    db $00
    db $40
    db $00
    db $80

; I: OAM list A7 of the table 5D47
OamList_B01_5D2B_A7::
    db $08
    db $21

    db $4d, $00, $08, $19

    db $4c
    db $00
    db $08
    db $11
    db $4b
    db $00
    db $08
    db $09
    db $4a
    db $00
    db $08
    db $01
    db $49
    db $00
    db $08
    db $f9
    db $48
    db $00
    db $08
    db $f1
    db $47
    db $00
    db $80

; C: OAM list A8 of the table 5D47
OamList_B01_5D2B_A8::
    db $01
    db $02
    db $7b
    db $10
    db $07
    db $09
    db $5f
    db $10
    db $80

; C: OAM list A9 of the table 5D47
OamList_B01_5D2B_A9::
    db $01
    db $08
    db $7b
    db $30
    db $07
    db $01
    db $5f
    db $10
    db $80

; C: OAM list AA of the table 5D47
OamList_B01_5D2B_AA::
    db $14
    db $0c
    db $7b
    db $30
    db $14
    db $fe
    db $7b
    db $10
    db $0e
    db $05
    db $5f
    db $50
    db $80

; C: OAM list AB of the table 5D47
OamList_B01_5D2B_AB::
    db $14
    db $02
    db $7b
    db $10
    db $0e
    db $09
    db $5f
    db $50
    db $80

; C: OAM list AC of the table 5D47
OamList_B01_5D2B_AC::
    db $14
    db $08
    db $7b
    db $30
    db $0e
    db $01
    db $5f
    db $50
    db $80

; C: OAM list AD of the table 5D47
OamList_B01_5D2B_AD::
    db $14
    db $0c
    db $7b
    db $30
    db $14
    db $fe
    db $7b
    db $10
    db $80

; C: OAM list AE of the table 5D47
OamList_B01_5D2B_AE::
    db $14
    db $02
    db $7b
    db $10
    db $80

; C: OAM list AF of the table 5D47
OamList_B01_5D2B_AF::
    db $14
    db $08
    db $7b
    db $30
    db $80

; C: OAM list B0 of the table 5D47
OamList_B01_5D2B_B0::
    db $08
    db $08
    db $00
    db $30
    db $10
    db $08
    db $00
    db $70
    db $10
    db $00
    db $00
    db $50
    db $08
    db $00
    db $00
    db $10
    db $80

; C: OAM list B1 of the table 5D47
OamList_B01_5D2B_B1::
    db $10
    db $18
    db $07
    db $00
    db $10
    db $10
    db $06
    db $00
    db $10
    db $08
    db $05
    db $00
    db $10
    db $00
    db $04
    db $00
    db $10
    db $f8
    db $03
    db $00
    db $08
    db $f8
    db $02
    db $00
    db $08
    db $f0
    db $01
    db $00
    db $80

; C: OAM list B2 of the table 5D47
OamList_B01_5D2B_B2::
    db $10
    db $f0
    db $07
    db $20
    db $10
    db $f8
    db $06
    db $20
    db $10
    db $00
    db $05
    db $20
    db $10
    db $08
    db $04
    db $20
    db $10
    db $10
    db $03
    db $20
    db $08
    db $10
    db $02
    db $20
    db $08
    db $18
    db $01
    db $20
    db $80

; C: OAM list B3 of the table 5D47
OamList_B01_5D2B_B3::
    db $18
    db $18
    db $0e
    db $00
    db $18
    db $10
    db $0d
    db $00
    db $18
    db $08
    db $0c
    db $00
    db $10
    db $18
    db $0b
    db $00
    db $10
    db $10
    db $0a
    db $00
    db $10
    db $08
    db $09
    db $00
    db $10
    db $00
    db $08
    db $00
    db $08
    db $00
    db $02
    db $00
    db $08
    db $f8
    db $01
    db $00
    db $80

; C: OAM list B4 of the table 5D47
OamList_B01_5D2B_B4::
    db $18
    db $f0
    db $0e
    db $20
    db $18
    db $f8
    db $0d
    db $20
    db $18
    db $00
    db $0c
    db $20
    db $10
    db $f0
    db $0b
    db $20
    db $10
    db $f8
    db $0a
    db $20
    db $10
    db $00
    db $09
    db $20
    db $10
    db $08
    db $08
    db $20
    db $08
    db $08
    db $02
    db $20
    db $08
    db $10
    db $01
    db $20
    db $80

; C: OAM list B5 of the table 5D47
OamList_B01_5D2B_B5::
    db $08
    db $f0
    db $02
    db $00
    db $08
    db $e8
    db $01
    db $00
    db $10
    db $f0
    db $0f
    db $00
    db $10
    db $10
    db $13
    db $00
    db $10
    db $08
    db $12
    db $00
    db $10
    db $00
    db $11
    db $00
    db $10
    db $f8
    db $10
    db $00
    db $10
    db $18
    db $14
    db $00
    db $80

; C: OAM list B6 of the table 5D47
OamList_B01_5D2B_B6::
    db $08
    db $18
    db $02
    db $20
    db $08
    db $20
    db $01
    db $20
    db $10
    db $18
    db $0f
    db $20
    db $10
    db $f8
    db $13
    db $20
    db $10
    db $00
    db $12
    db $20
    db $10
    db $08
    db $11
    db $20
    db $10
    db $10
    db $10
    db $20
    db $10
    db $f0
    db $14
    db $20
    db $80

; C: OAM list B7 of the table 5D47
OamList_B01_5D2B_B7::
    db $08
    db $18
    db $74
    db $10
    db $08
    db $10
    db $73
    db $10
    db $08
    db $08
    db $72
    db $10
    db $08
    db $00
    db $71
    db $10
    db $08
    db $f8
    db $70
    db $10
    db $80

; C: OAM list B8 of the table 5D47
OamList_B01_5D2B_B8::
    db $08
    db $18
    db $74
    db $10
    db $08
    db $10
    db $77
    db $10
    db $08
    db $08
    db $76
    db $10
    db $08
    db $00
    db $75
    db $10
    db $08
    db $f8
    db $73
    db $10
    db $80

; C: OAM list B9 of the table 5D47
OamList_B01_5D2B_B9::
    db $08
    db $20
    db $74
    db $10
    db $08
    db $18
    db $77
    db $10
    db $08
    db $10
    db $76
    db $10
    db $08
    db $08
    db $75
    db $10
    db $08
    db $00
    db $73
    db $10
    db $08
    db $f8
    db $79
    db $10
    db $08
    db $f0
    db $78
    db $10
    db $80

; C: OAM list BA of the table 5D47
OamList_B01_5D2B_BA::
    db $08
    db $10
    db $7c
    db $10
    db $08
    db $08
    db $7b
    db $10
    db $08
    db $00
    db $7a
    db $10
    db $08
    db $f8
    db $74
    db $10
    db $80

; C: OAM list BB of the table 5D47
OamList_B01_5D2B_BB::
    db $08
    db $10
    db $7e
    db $10
    db $08
    db $08
    db $71
    db $10
    db $08
    db $00
    db $7d
    db $10
    db $08
    db $f8
    db $70
    db $10
    db $80

; C: OAM list BC of the table 5D47
OamList_B01_5D2B_BC::
    db $08
    db $18
    db $1e
    db $10
    db $09
    db $10
    db $1d
    db $10
    db $09
    db $08
    db $1c
    db $10
    db $0a
    db $00
    db $1b
    db $10
    db $0c
    db $f8
    db $1a
    db $10
    db $00
    db $18
    db $19
    db $10
    db $01
    db $10
    db $18
    db $10
    db $01
    db $08
    db $17
    db $10
    db $02
    db $00
    db $16
    db $10
    db $04
    db $f8
    db $15
    db $10
    db $80

; C: OAM list BD of the table 5D47
OamList_B01_5D2B_BD::
    db $15
    db $fb
    db $15
    db $00
    db $0d
    db $f9
    db $06
    db $00
    db $0b
    db $f1
    db $05
    db $00
    db $fb
    db $e9
    db $03
    db $00
    db $03
    db $f1
    db $14
    db $00
    db $03
    db $e9
    db $13
    db $00
    db $fb
    db $f1
    db $04
    db $00
    db $f3
    db $eb
    db $12
    db $00
    db $f3
    db $e3
    db $11
    db $00
    db $f3
    db $db
    db $10
    db $00
    db $eb
    db $eb
    db $02
    db $00
    db $eb
    db $e3
    db $01
    db $00
    db $eb
    db $db
    db $00
    db $00
    db $80

; C: OAM list BE of the table 5D47
OamList_B01_5D2B_BE::
    db $0e
    db $21
    db $07
    db $00
    db $12
    db $11
    db $16
    db $00
    db $0f
    db $19
    db $17
    db $00
    db $0a
    db $25
    db $18
    db $00
    db $fa
    db $39
    db $1b
    db $00
    db $fd
    db $31
    db $1a
    db $00
    db $f5
    db $31
    db $0a
    db $00
    db $02
    db $27
    db $08
    db $00
    db $fa
    db $29
    db $19
    db $00
    db $f2
    db $29
    db $09
    db $00
    db $80

; C: OAM list BF of the table 5D47
OamList_B01_5D2B_BF::
    db $2a
    db $03
    db $24
    db $00
    db $2a
    db $fb
    db $23
    db $00
    db $22
    db $03
    db $20
    db $00
    db $80

; C: OAM list C0 of the table 5D47
OamList_B01_5D2B_C0::
    db $19
    db $f7
    db $0c
    db $00
    db $21
    db $ff
    db $1d
    db $00
    db $21
    db $f7
    db $1c
    db $00
    db $80

; C: OAM list C1 of the table 5D47
OamList_B01_5D2B_C1::
    db $22
    db $0e
    db $25
    db $00
    db $2a
    db $16
    db $22
    db $00
    db $2a
    db $0e
    db $21
    db $00
    db $80

; C: OAM list C2 of the table 5D47
OamList_B01_5D2B_C2::
    db $1a
    db $17
    db $0e
    db $00
    db $22
    db $0f
    db $0d
    db $00
    db $22
    db $17
    db $1e
    db $00
    db $80

; C: OAM list C3 of the table 5D47
OamList_B01_5D2B_C3::
    db $15
    db $0d
    db $15
    db $20
    db $0d
    db $0f
    db $06
    db $20
    db $0b
    db $17
    db $05
    db $20
    db $fb
    db $1f
    db $03
    db $20
    db $03
    db $17
    db $14
    db $20
    db $03
    db $1f
    db $13
    db $20
    db $fb
    db $17
    db $04
    db $20
    db $f3
    db $1d
    db $12
    db $20
    db $f3
    db $25
    db $11
    db $20
    db $f3
    db $2d
    db $10
    db $20
    db $eb
    db $1d
    db $02
    db $20
    db $eb
    db $25
    db $01
    db $20
    db $eb
    db $2d
    db $00
    db $20
    db $80

; C: OAM list C4 of the table 5D47
OamList_B01_5D2B_C4::
    db $0e
    db $e7
    db $07
    db $20
    db $12
    db $f7
    db $16
    db $20
    db $0f
    db $ef
    db $17
    db $20
    db $0a
    db $e3
    db $18
    db $20
    db $fa
    db $cf
    db $1b
    db $20
    db $fd
    db $d7
    db $1a
    db $20
    db $f5
    db $d7
    db $0a
    db $20
    db $02
    db $e1
    db $08
    db $20
    db $fa
    db $df
    db $19
    db $20
    db $f2
    db $df
    db $09
    db $20
    db $80

; C: OAM list C5 of the table 5D47
OamList_B01_5D2B_C5::
    db $2a
    db $05
    db $24
    db $20
    db $2a
    db $0d
    db $23
    db $20
    db $22
    db $05
    db $20
    db $20
    db $80

; C: OAM list C6 of the table 5D47
OamList_B01_5D2B_C6::
    db $19
    db $11
    db $0c
    db $20
    db $21
    db $09
    db $1d
    db $20
    db $21
    db $11
    db $1c
    db $20
    db $80

; C: OAM list C7 of the table 5D47
OamList_B01_5D2B_C7::
    db $22
    db $fa
    db $25
    db $20
    db $2a
    db $f2
    db $22
    db $20
    db $2a
    db $fa
    db $21
    db $20
    db $80

; C: OAM list C8 of the table 5D47
OamList_B01_5D2B_C8::
    db $1a
    db $f1
    db $0e
    db $20
    db $22
    db $f9
    db $0d
    db $20
    db $22
    db $f1
    db $1e
    db $20
    db $80

; C: OAM list C9 of the table 5D47
OamList_B01_5D2B_C9::
    db $09
    db $11
    db $01
    db $00
    db $09
    db $09
    db $00
    db $00
    db $80

; C: OAM list CA of the table 5D47
OamList_B01_5D2B_CA::
    db $09
    db $11
    db $01
    db $00
    db $09
    db $09
    db $02
    db $00
    db $80

; C: OAM list CB of the table 5D47
OamList_B01_5D2B_CB::
    db $09
    db $08
    db $01
    db $20
    db $09
    db $10
    db $02
    db $20
    db $80

; C: OAM list CC of the table 5D47
OamList_B01_5D2B_CC::
    db $09
    db $08
    db $01
    db $20
    db $09
    db $10
    db $00
    db $20
    db $80

; C: OAM list CD of the table 5D47
OamList_B01_5D2B_CD::
    db $08
    db $08
    db $01
    db $60
    db $08
    db $10
    db $00
    db $60
    db $80

; C: OAM list CE of the table 5D47
OamList_B01_5D2B_CE::
    db $08
    db $08
    db $01
    db $60
    db $08
    db $10
    db $02
    db $60
    db $80

; C: OAM list CF of the table 5D47
OamList_B01_5D2B_CF::
    db $08
    db $11
    db $01
    db $40
    db $08
    db $09
    db $02
    db $40
    db $80

; C: OAM list D0 of the table 5D47
OamList_B01_5D2B_D0::
    db $08
    db $11
    db $01
    db $40
    db $08
    db $09
    db $00
    db $40
    db $80

; C: OAM list D1 of the table 5D47
OamList_B01_5D2B_D1::
    db $08
    db $08
    db $06
    db $10
    db $80

; C: OAM list D2 of the table 5D47
OamList_B01_5D2B_D2::
    db $08
    db $08
    db $05
    db $10
    db $80

; C: OAM list D3 of the table 5D47
OamList_B01_5D2B_D3::
    db $04
    db $17
    db $04
    db $10
    db $00
    db $f2
    db $04
    db $70
    db $80

; C: OAM list D4 of the table 5D47
OamList_B01_5D2B_D4::
    db $04
    db $17
    db $03
    db $10
    db $00
    db $f2
    db $03
    db $70
    db $80

; C: OAM list D5 of the table 5D47
OamList_B01_5D2B_D5::
    db $08
    db $20
    db $43
    db $00
    db $08
    db $18
    db $42
    db $00
    db $08
    db $10
    db $41
    db $00
    db $08
    db $08
    db $40
    db $00
    db $80

; C: OAM list D6 of the table 5D47
OamList_B01_5D2B_D6::
    db $08
    db $20
    db $53
    db $00
    db $08
    db $18
    db $52
    db $00
    db $08
    db $10
    db $51
    db $00
    db $08
    db $08
    db $50
    db $00
    db $80

; C: OAM list D7 of the table 5D47
OamList_B01_5D2B_D7::
    db $08
    db $20
    db $20
    db $00
    db $08
    db $18
    db $52
    db $00
    db $08
    db $10
    db $51
    db $00
    db $08
    db $08
    db $50
    db $00
    db $80

; C: OAM list D8 of the table 5D47
OamList_B01_5D2B_D8::
    db $08
    db $20
    db $2d
    db $00
    db $08
    db $18
    db $24
    db $00
    db $08
    db $10
    db $1d
    db $00
    db $08
    db $08
    db $1c
    db $00
    db $80

; C: OAM list D9 of the table 5D47
OamList_B01_5D2B_D9::
    db $08
    db $10
    db $15
    db $00
    db $08
    db $08
    db $14
    db $00
    db $80

; C: OAM list DA of the table 5D47
OamList_B01_5D2B_DA::
    db $08
    db $08
    db $07
    db $50
    db $07
    db $08
    db $07
    db $10
    db $80

; C: OAM list DB of the table 5D47
OamList_B01_5D2B_DB::
    db $07
    db $08
    db $07
    db $50
    db $07
    db $08
    db $07
    db $10
    db $80

; C: OAM list DC of the table 5D47
OamList_B01_5D2B_DC::
    db $08
    db $08
    db $07
    db $50
    db $08
    db $08
    db $07
    db $10
    db $80

; C: OAM list DD of the table 5D47
OamList_B01_5D2B_DD::
    db $f0
    db $09
    db $3d
    db $70
    db $f0
    db $11
    db $3c
    db $70
    db $f8
    db $11
    db $2c
    db $70
    db $f0
    db $19
    db $58
    db $70
    db $f8
    db $19
    db $48
    db $70
    db $f8
    db $21
    db $47
    db $70
    db $00
    db $11
    db $39
    db $70
    db $00
    db $19
    db $38
    db $70
    db $00
    db $21
    db $37
    db $70
    db $16
    db $e6
    db $54
    db $10
    db $0f
    db $ea
    db $31
    db $10
    db $0f
    db $e2
    db $30
    db $10
    db $07
    db $f8
    db $23
    db $10
    db $07
    db $f0
    db $22
    db $10
    db $07
    db $e8
    db $21
    db $10
    db $ff
    db $f8
    db $13
    db $10
    db $ff
    db $f0
    db $12
    db $10
    db $ff
    db $e8
    db $11
    db $10
    db $80

; C: OAM list DE of the table 5D47
OamList_B01_5D2B_DE::
    db $d9
    db $0d
    db $5d
    db $50
    db $e1
    db $09
    db $5f
    db $70
    db $e1
    db $11
    db $5e
    db $70
    db $e9
    db $0f
    db $4f
    db $70
    db $e9
    db $17
    db $4e
    db $70
    db $f1
    db $10
    db $3f
    db $70
    db $f1
    db $18
    db $3e
    db $70
    db $f9
    db $0f
    db $2f
    db $70
    db $f9
    db $17
    db $2e
    db $70
    db $01
    db $0f
    db $1f
    db $70
    db $01
    db $17
    db $1e
    db $70
    db $20
    db $e4
    db $54
    db $10
    db $18
    db $e8
    db $45
    db $10
    db $18
    db $e0
    db $44
    db $10
    db $10
    db $eb
    db $35
    db $10
    db $10
    db $e3
    db $34
    db $10
    db $08
    db $f8
    db $27
    db $10
    db $08
    db $f0
    db $26
    db $10
    db $08
    db $e8
    db $25
    db $10
    db $00
    db $f8
    db $17
    db $10
    db $00
    db $f0
    db $16
    db $10
    db $80

; C: OAM list DF of the table 5D47
OamList_B01_5D2B_DF::
    db $0f
    db $15
    db $10
    db $10
    db $11
    db $01
    db $3d
    db $10
    db $11
    db $f9
    db $3c
    db $10
    db $09
    db $f9
    db $2c
    db $10
    db $11
    db $f1
    db $58
    db $10
    db $09
    db $f1
    db $48
    db $10
    db $09
    db $e9
    db $47
    db $10
    db $01
    db $e9
    db $37
    db $10
    db $01
    db $f1
    db $38
    db $10
    db $01
    db $f9
    db $39
    db $10
    db $17
    db $25
    db $29
    db $10
    db $17
    db $1d
    db $28
    db $10
    db $0f
    db $25
    db $19
    db $10
    db $0f
    db $1d
    db $18
    db $10
    db $07
    db $0d
    db $23
    db $30
    db $07
    db $15
    db $22
    db $30
    db $07
    db $1d
    db $21
    db $30
    db $ff
    db $0d
    db $13
    db $30
    db $ff
    db $15
    db $12
    db $30
    db $ff
    db $1d
    db $11
    db $30
    db $80

; C: OAM list E0 of the table 5D47
OamList_B01_5D2B_E0::
    db $0f
    db $15
    db $10
    db $00
    db $11
    db $09
    db $3d
    db $10
    db $11
    db $01
    db $3c
    db $10
    db $09
    db $01
    db $2c
    db $10
    db $11
    db $f9
    db $3b
    db $10
    db $11
    db $f1
    db $3a
    db $10
    db $09
    db $f9
    db $2b
    db $10
    db $09
    db $f1
    db $2a
    db $10
    db $01
    db $f9
    db $1b
    db $10
    db $01
    db $f1
    db $1a
    db $10
    db $17
    db $25
    db $29
    db $10
    db $17
    db $1d
    db $28
    db $10
    db $0f
    db $25
    db $19
    db $10
    db $0f
    db $1d
    db $18
    db $10
    db $07
    db $0d
    db $23
    db $30
    db $07
    db $15
    db $22
    db $30
    db $07
    db $1d
    db $21
    db $30
    db $ff
    db $0d
    db $13
    db $30
    db $ff
    db $15
    db $12
    db $30
    db $ff
    db $1d
    db $11
    db $30
    db $80

; C: OAM list E1 of the table 5D47
OamList_B01_5D2B_E1::
    db $0f
    db $19
    db $10
    db $10
    db $11
    db $09
    db $3d
    db $10
    db $11
    db $01
    db $3c
    db $10
    db $09
    db $01
    db $2c
    db $10
    db $11
    db $f9
    db $3b
    db $10
    db $11
    db $f1
    db $3a
    db $10
    db $09
    db $f9
    db $2b
    db $10
    db $09
    db $f1
    db $2a
    db $10
    db $01
    db $f9
    db $1b
    db $10
    db $01
    db $f1
    db $1a
    db $10
    db $17
    db $2a
    db $29
    db $10
    db $17
    db $22
    db $28
    db $10
    db $0f
    db $29
    db $19
    db $10
    db $0f
    db $21
    db $18
    db $10
    db $07
    db $10
    db $23
    db $30
    db $07
    db $18
    db $22
    db $30
    db $07
    db $20
    db $21
    db $30
    db $ff
    db $10
    db $13
    db $30
    db $ff
    db $18
    db $12
    db $30
    db $ff
    db $20
    db $11
    db $30
    db $80

; C: OAM list E2 of the table 5D47
OamList_B01_5D2B_E2::
    db $f2
    db $18
    db $10
    db $50
    db $11
    db $09
    db $3d
    db $10
    db $11
    db $01
    db $3c
    db $10
    db $09
    db $01
    db $2c
    db $10
    db $11
    db $f9
    db $3b
    db $10
    db $11
    db $f1
    db $3a
    db $10
    db $09
    db $f9
    db $2b
    db $10
    db $09
    db $f1
    db $2a
    db $10
    db $01
    db $f9
    db $1b
    db $10
    db $01
    db $f1
    db $1a
    db $10
    db $ea
    db $28
    db $29
    db $50
    db $ea
    db $20
    db $28
    db $50
    db $f2
    db $28
    db $19
    db $50
    db $f2
    db $20
    db $18
    db $50
    db $fa
    db $10
    db $23
    db $70
    db $fa
    db $18
    db $22
    db $70
    db $fa
    db $20
    db $21
    db $70
    db $02
    db $10
    db $13
    db $70
    db $02
    db $18
    db $12
    db $70
    db $02
    db $20
    db $11
    db $70
    db $80

; C: OAM list E3 of the table 5D47
OamList_B01_5D2B_E3::
    db $11
    db $09
    db $3d
    db $30
    db $11
    db $11
    db $3c
    db $30
    db $11
    db $02
    db $3d
    db $10
    db $11
    db $fa
    db $3c
    db $10
    db $09
    db $11
    db $2c
    db $30
    db $09
    db $fa
    db $2c
    db $10
    db $11
    db $19
    db $58
    db $30
    db $09
    db $19
    db $48
    db $30
    db $09
    db $21
    db $47
    db $30
    db $01
    db $11
    db $39
    db $30
    db $01
    db $19
    db $38
    db $30
    db $01
    db $21
    db $37
    db $30
    db $11
    db $f2
    db $58
    db $10
    db $09
    db $f2
    db $48
    db $10
    db $09
    db $ea
    db $47
    db $10
    db $01
    db $fa
    db $39
    db $10
    db $01
    db $f2
    db $38
    db $10
    db $01
    db $ea
    db $37
    db $10
    db $80

; C: OAM list E4 of the table 5D47
OamList_B01_5D2B_E4::
    db $28
    db $02
    db $5d
    db $10
    db $20
    db $04
    db $5f
    db $10
    db $20
    db $fc
    db $5e
    db $10
    db $18
    db $fe
    db $4f
    db $10
    db $18
    db $f6
    db $4e
    db $10
    db $10
    db $fc
    db $3f
    db $10
    db $10
    db $f4
    db $3e
    db $10
    db $08
    db $fc
    db $2f
    db $10
    db $08
    db $f4
    db $2e
    db $10
    db $00
    db $fc
    db $1f
    db $10
    db $00
    db $f4
    db $1e
    db $10
    db $11
    db $08
    db $3d
    db $30
    db $11
    db $10
    db $3c
    db $30
    db $09
    db $10
    db $2c
    db $30
    db $11
    db $18
    db $58
    db $30
    db $09
    db $18
    db $48
    db $30
    db $09
    db $20
    db $47
    db $30
    db $01
    db $10
    db $39
    db $30
    db $01
    db $18
    db $38
    db $30
    db $01
    db $20
    db $37
    db $30
    db $80

; C: OAM list E5 of the table 5D47
OamList_B01_5D2B_E5::
    db $18
    db $16
    db $35
    db $10
    db $18
    db $0e
    db $34
    db $10
    db $28
    db $0c
    db $5d
    db $30
    db $20
    db $0a
    db $5f
    db $30
    db $20
    db $12
    db $5e
    db $30
    db $10
    db $0f
    db $3f
    db $30
    db $10
    db $17
    db $3e
    db $30
    db $08
    db $0e
    db $2f
    db $30
    db $08
    db $16
    db $2e
    db $30
    db $00
    db $0c
    db $1f
    db $30
    db $00
    db $14
    db $1e
    db $30
    db $f0
    db $00
    db $3d
    db $50
    db $f0
    db $f8
    db $3c
    db $50
    db $f8
    db $f8
    db $2c
    db $50
    db $f0
    db $f0
    db $58
    db $50
    db $f8
    db $f0
    db $48
    db $50
    db $f8
    db $e8
    db $47
    db $50
    db $00
    db $f8
    db $39
    db $50
    db $00
    db $f0
    db $38
    db $50
    db $00
    db $e8
    db $37
    db $50
    db $80

; C: OAM list E6 of the table 5D47
OamList_B01_5D2B_E6::
    db $f2
    db $19
    db $10
    db $50
    db $ea
    db $29
    db $29
    db $50
    db $ea
    db $21
    db $28
    db $50
    db $f2
    db $29
    db $19
    db $50
    db $f2
    db $21
    db $18
    db $50
    db $fa
    db $11
    db $23
    db $70
    db $fa
    db $19
    db $22
    db $70
    db $fa
    db $21
    db $21
    db $70
    db $02
    db $11
    db $13
    db $70
    db $02
    db $19
    db $12
    db $70
    db $02
    db $21
    db $11
    db $70
    db $ff
    db $fb
    db $17
    db $10
    db $ff
    db $f3
    db $16
    db $10
    db $07
    db $f4
    db $48
    db $50
    db $07
    db $ec
    db $47
    db $50
    db $17
    db $ee
    db $35
    db $30
    db $17
    db $f6
    db $34
    db $30
    db $27
    db $f7
    db $5d
    db $10
    db $1f
    db $f9
    db $5f
    db $10
    db $1f
    db $f1
    db $5e
    db $10
    db $0f
    db $f5
    db $3f
    db $10
    db $0f
    db $ed
    db $3e
    db $10
    db $80

; C: OAM list E7 of the table 5D47
OamList_B01_5D2B_E7::
    db $ea
    db $e7
    db $54
    db $70
    db $f2
    db $eb
    db $45
    db $50
    db $f2
    db $e3
    db $44
    db $50
    db $ea
    db $28
    db $29
    db $50
    db $ea
    db $20
    db $28
    db $50
    db $f2
    db $28
    db $19
    db $50
    db $f2
    db $20
    db $18
    db $50
    db $fa
    db $10
    db $23
    db $70
    db $fa
    db $18
    db $22
    db $70
    db $fa
    db $20
    db $21
    db $70
    db $02
    db $10
    db $13
    db $70
    db $02
    db $18
    db $12
    db $70
    db $02
    db $20
    db $11
    db $70
    db $fa
    db $f8
    db $23
    db $50
    db $fa
    db $f0
    db $22
    db $50
    db $fa
    db $e8
    db $21
    db $50
    db $02
    db $f8
    db $13
    db $50
    db $02
    db $f0
    db $12
    db $50
    db $02
    db $e8
    db $11
    db $50
    db $80

; C: OAM list E8 of the table 5D47
OamList_B01_5D2B_E8::
    db $ea
    db $e7
    db $54
    db $70
    db $f2
    db $eb
    db $45
    db $50
    db $f2
    db $e3
    db $44
    db $50
    db $fa
    db $f8
    db $23
    db $50
    db $fa
    db $f0
    db $22
    db $50
    db $fa
    db $e8
    db $21
    db $50
    db $02
    db $f8
    db $13
    db $50
    db $02
    db $f0
    db $12
    db $50
    db $02
    db $e8
    db $11
    db $50
    db $eb
    db $1c
    db $54
    db $50
    db $f3
    db $20
    db $45
    db $50
    db $f3
    db $18
    db $44
    db $50
    db $fb
    db $0f
    db $23
    db $70
    db $fb
    db $17
    db $22
    db $70
    db $fb
    db $1f
    db $21
    db $70
    db $03
    db $10
    db $13
    db $70
    db $03
    db $18
    db $12
    db $70
    db $03
    db $20
    db $11
    db $70
    db $80

; C: OAM list E9 of the table 5D47
OamList_B01_5D2B_E9::
    db $b8
    db $01
    db $5d
    db $50
    db $c0
    db $03
    db $5f
    db $50
    db $c0
    db $fb
    db $5e
    db $50
    db $c8
    db $fd
    db $4f
    db $50
    db $c8
    db $f5
    db $4e
    db $50
    db $d0
    db $fb
    db $3f
    db $50
    db $d0
    db $f3
    db $3e
    db $50
    db $d8
    db $fb
    db $2f
    db $50
    db $d8
    db $f3
    db $2e
    db $50
    db $e0
    db $fb
    db $1f
    db $50
    db $e0
    db $f3
    db $1e
    db $50
    db $80

; C: OAM list EA of the table 5D47
OamList_B01_5D2B_EA::
    db $b8
    db $07
    db $5d
    db $70
    db $c0
    db $05
    db $5f
    db $70
    db $c0
    db $0d
    db $5e
    db $70
    db $c8
    db $0b
    db $4f
    db $70
    db $c8
    db $13
    db $4e
    db $70
    db $d0
    db $0d
    db $3f
    db $70
    db $d0
    db $15
    db $3e
    db $70
    db $d8
    db $0d
    db $2f
    db $70
    db $d8
    db $15
    db $2e
    db $70
    db $e0
    db $0d
    db $1f
    db $70
    db $e0
    db $15
    db $1e
    db $70
    db $80

; C: OAM list EB of the table 5D47
OamList_B01_5D2B_EB::
    db $d0
    db $00
    db $3d
    db $50
    db $d0
    db $f8
    db $3c
    db $50
    db $d8
    db $f8
    db $2c
    db $50
    db $d0
    db $f0
    db $58
    db $50
    db $d8
    db $f0
    db $48
    db $50
    db $d8
    db $e8
    db $47
    db $50
    db $e0
    db $f8
    db $39
    db $50
    db $e0
    db $f0
    db $38
    db $50
    db $e0
    db $e8
    db $37
    db $50
    db $80

; C: OAM list EC of the table 5D47
OamList_B01_5D2B_EC::
    db $d0
    db $08
    db $3d
    db $70
    db $d0
    db $10
    db $3c
    db $70
    db $d8
    db $10
    db $2c
    db $70
    db $d0
    db $18
    db $58
    db $70
    db $d8
    db $18
    db $48
    db $70
    db $d8
    db $20
    db $47
    db $70
    db $e0
    db $10
    db $39
    db $70
    db $e0
    db $18
    db $38
    db $70
    db $e0
    db $20
    db $37
    db $70
    db $80

; C: OAM list ED of the table 5D47
OamList_B01_5D2B_ED::
    db $ef
    db $d9
    db $59
    db $10
    db $ef
    db $e0
    db $5a
    db $10
    db $ef
    db $e8
    db $5b
    db $10
    db $e7
    db $e0
    db $4a
    db $10
    db $e7
    db $e8
    db $4b
    db $10
    db $e7
    db $f0
    db $4c
    db $10
    db $e7
    db $f8
    db $23
    db $10
    db $df
    db $f8
    db $13
    db $10
    db $df
    db $f0
    db $12
    db $10
    db $df
    db $e8
    db $11
    db $10
    db $80

; C: OAM list EE of the table 5D47
OamList_B01_5D2B_EE::
    db $ef
    db $2f
    db $59
    db $30
    db $ef
    db $28
    db $5a
    db $30
    db $ef
    db $20
    db $5b
    db $30
    db $e7
    db $28
    db $4a
    db $30
    db $e7
    db $20
    db $4b
    db $30
    db $e7
    db $18
    db $4c
    db $30
    db $e7
    db $10
    db $23
    db $30
    db $df
    db $10
    db $13
    db $30
    db $df
    db $18
    db $12
    db $30
    db $df
    db $20
    db $11
    db $30
    db $80

; C: OAM list EF of the table 5D47
OamList_B01_5D2B_EF::
    db $e0
    db $f8
    db $39
    db $50
    db $c4
    db $e4
    db $54
    db $50
    db $cc
    db $e8
    db $45
    db $50
    db $cc
    db $e0
    db $44
    db $50
    db $d4
    db $eb
    db $35
    db $50
    db $d4
    db $e3
    db $34
    db $50
    db $dc
    db $f0
    db $26
    db $50
    db $dc
    db $e8
    db $25
    db $50
    db $e4
    db $f0
    db $16
    db $50
    db $80

; C: OAM list F0 of the table 5D47
OamList_B01_5D2B_F0::
    db $e0
    db $10
    db $39
    db $70
    db $c4
    db $24
    db $54
    db $70
    db $cc
    db $20
    db $45
    db $70
    db $cc
    db $28
    db $44
    db $70
    db $d4
    db $1d
    db $35
    db $70
    db $d4
    db $25
    db $34
    db $70
    db $dc
    db $18
    db $26
    db $70
    db $dc
    db $20
    db $25
    db $70
    db $e4
    db $18
    db $16
    db $70
    db $80

; C: OAM list F1 of the table 5D47
OamList_B01_5D2B_F1::
    db $f0
    db $09
    db $3d
    db $10
    db $f0
    db $01
    db $3c
    db $10
    db $e8
    db $01
    db $2c
    db $10
    db $f0
    db $f9
    db $3b
    db $10
    db $f0
    db $f1
    db $3a
    db $10
    db $e8
    db $f9
    db $2b
    db $10
    db $e8
    db $f1
    db $2a
    db $10
    db $e0
    db $f9
    db $1b
    db $10
    db $e0
    db $f1
    db $1a
    db $10
    db $80

; C: OAM list F2 of the table 5D47
OamList_B01_5D2B_F2::
    db $f0
    db $ff
    db $3d
    db $30
    db $f0
    db $07
    db $3c
    db $30
    db $e8
    db $07
    db $2c
    db $30
    db $f0
    db $0f
    db $3b
    db $30
    db $f0
    db $17
    db $3a
    db $30
    db $e8
    db $0f
    db $2b
    db $30
    db $e8
    db $17
    db $2a
    db $30
    db $e0
    db $0f
    db $1b
    db $30
    db $e0
    db $17
    db $1a
    db $30
    db $80

; C: OAM list F3 of the table 5D47
OamList_B01_5D2B_F3::
    db $d0
    db $09
    db $3d
    db $50
    db $d0
    db $01
    db $3c
    db $50
    db $d8
    db $01
    db $2c
    db $50
    db $d0
    db $f9
    db $3b
    db $50
    db $d0
    db $f1
    db $3a
    db $50
    db $d8
    db $f9
    db $2b
    db $50
    db $d8
    db $f1
    db $2a
    db $50
    db $e0
    db $f9
    db $1b
    db $50
    db $e0
    db $f1
    db $1a
    db $50
    db $80

; C: OAM list F4 of the table 5D47
OamList_B01_5D2B_F4::
    db $d0
    db $ff
    db $3d
    db $70
    db $d0
    db $07
    db $3c
    db $70
    db $d8
    db $07
    db $2c
    db $70
    db $d0
    db $0f
    db $3b
    db $70
    db $d0
    db $17
    db $3a
    db $70
    db $d8
    db $0f
    db $2b
    db $70
    db $d8
    db $17
    db $2a
    db $70
    db $e0
    db $0f
    db $1b
    db $70
    db $e0
    db $17
    db $1a
    db $70
    db $80

; C: OAM list F5 of the table 5D47
OamList_B01_5D2B_F5::
    db $38
    db $c0
    db $fc
    db $00
    db $38
    db $b8
    db $fc
    db $00
    db $28
    db $b8
    db $fc
    db $00
    db $28
    db $c0
    db $fc
    db $00
    db $18
    db $c0
    db $fc
    db $00
    db $18
    db $b8
    db $fc
    db $00
    db $08
    db $c0
    db $fc
    db $00
    db $08
    db $b8
    db $fc
    db $00
    db $f8
    db $c0
    db $fc
    db $00
    db $f8
    db $b8
    db $fc
    db $00
    db $e8
    db $b8
    db $fc
    db $00
    db $e8
    db $c0
    db $fc
    db $00
    db $d8
    db $c0
    db $fc
    db $00
    db $d8
    db $b8
    db $fc
    db $00
    db $38
    db $50
    db $fc
    db $00
    db $38
    db $48
    db $fc
    db $00
    db $28
    db $48
    db $fc
    db $00
    db $28
    db $50
    db $fc
    db $00
    db $18
    db $50
    db $fc
    db $00
    db $18
    db $48
    db $fc
    db $00
    db $08
    db $50
    db $fc
    db $00
    db $08
    db $48
    db $fc
    db $00
    db $f8
    db $50
    db $fc
    db $00
    db $f8
    db $48
    db $fc
    db $00
    db $e8
    db $48
    db $fc
    db $00
    db $e8
    db $50
    db $fc
    db $00
    db $d8
    db $50
    db $fc
    db $00
    db $d8
    db $48
    db $fc
    db $00
    db $80

; C: zero fill to the end of the bank
Bank01_Padding_7859::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $30, $00

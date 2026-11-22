; Pocket Camera Hello Kitty (Japan), bank $01. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

; C: leftover: 512 bytes (01:4000-41FF) 256 signed words round(256 sin(2 pi i / 256)), the low bytes at $4000-$40FF
; and the high bytes at $4100-$41FF (checked: 0 errors); no proven instruction points at it and no run reads it
Leftover_01_4000_SinTable::
    INCBIN "data/bank_01/Leftover_01_4000_SinTable.bin" ; $4000, 512 bytes
; C: leftover: 512 bytes (01:4200-43FF) 256 signed words round(256 cos(2 pi i / 256)), low bytes $4200-$42FF, high
; bytes $4300-$43FF (checked: 0 errors); never read
Leftover_01_4200_CosTable::
    INCBIN "data/bank_01/Leftover_01_4200_CosTable.bin" ; $4200, 512 bytes
; C: leftover: 768 bytes (01:4400-46FF) 768 bytes of $00 between the cosine table and Sram_WriteMagic_Tbl4700 (three
; more 256-byte pages, empty); never read
Leftover_01_4400_Zero::
    INCBIN "data/bank_01/Leftover_01_4400_Zero.bin" ; $4400, 768 bytes
; C: named by the code of Sram_WriteMagic, Sram_CompareMagic (01:4705 01:47CC); read in the runs by Sram_WriteMagic,
; Sram_CompareMagic; first read on the screen Mode00_BootAndTitle_State00 (trace/read_screens_kitty*.npz)
Sram_WriteMagic_Tbl4700::
    db $4d, $61, $67, $69, $63

; C: the 5 bytes of Data_01_4700 (the Magic string) at HL
Sram_WriteMagic::
    ld de, Sram_WriteMagic_Tbl4700                ; $4705
    ld c, $05                                     ; $4708

jr_001_470a:
    ld a, [de]                                    ; $470A
    ld [hl+], a                                   ; $470B
    inc de                                        ; $470C
    dec c                                         ; $470D
    jr nz, jr_001_470a                            ; $470E

    ret                                           ; $4710


; C: HL = checksum of BC bytes at DE: L = sum, H = xor of the bytes
Sram_Checksum::
    ld hl, $0000                                  ; $4711

jr_001_4714:
    ld a, [de]                                    ; $4714
    add l                                         ; $4715
    ld l, a                                       ; $4716
    ld a, [de]                                    ; $4717
    xor h                                         ; $4718
    ld h, a                                       ; $4719
    inc de                                        ; $471A
    dec bc                                        ; $471B
    ld a, b                                       ; $471C
    or c                                          ; $471D
    jr nz, jr_001_4714                            ; $471E

    ret                                           ; $4720


; C: Sram_Checksum, stored at HL as (L + $4E, H xor $54)
Sram_WriteChecksum::
    push hl                                       ; $4721
    call Sram_Checksum                            ; $4722
    ld e, l                                       ; $4725
    ld d, h                                       ; $4726
    pop hl                                        ; $4727
    ld a, e                                       ; $4728
    add $4e                                       ; $4729
    ld [hl+], a                                   ; $472B
    ld a, d                                       ; $472C
    xor $54                                       ; $472D
    ld [hl], a                                    ; $472F
    ret                                           ; $4730


; C: photo slot A: HL = $A000 or $B000 (A & 1), A = SRAM bank A / 2 + 1
Sram_PhotoSlotAddr::
    push af                                       ; $4731
    ld l, $00                                     ; $4732
    and $01                                       ; $4734
    swap a                                        ; $4736
    or $a0                                        ; $4738
    ld h, a                                       ; $473A
    pop af                                        ; $473B
    sra a                                         ; $473C
    inc a                                         ; $473E
    ret                                           ; $473F


; C: renumbers the order numbers of the 30-slot table $DAA9 so that they run 0, 1, 2 ... in the same order
Photo_RenumberVector::
    ld b, $1e                                     ; $4740
    ld de, $0000                                  ; $4742

jr_001_4745:
    ld hl, wPhotoVectorRam                        ; $4745
    ld a, e                                       ; $4748
    ld c, $1e                                     ; $4749

jr_001_474b:
    cp [hl]                                       ; $474B
    jr nz, jr_001_4752                            ; $474C

    ld [hl], d                                    ; $474E
    inc d                                         ; $474F
    jr jr_001_4756                                ; $4750

jr_001_4752:
    inc hl                                        ; $4752
    dec c                                         ; $4753
    jr nz, jr_001_474b                            ; $4754

jr_001_4756:
    inc e                                         ; $4756
    dec b                                         ; $4757
    jr nz, jr_001_4745                            ; $4758

    ret                                           ; $475A


; C: $D932 = number of slots of $DAA9 that are not $FF
Photo_CountUsed::
    ld bc, $1e00                                  ; $475B
    ld hl, wPhotoVectorRam                        ; $475E

jr_001_4761:
    ld a, [hl+]                                   ; $4761
    cp $ff                                        ; $4762
    jr z, jr_001_4767                             ; $4764

    inc c                                         ; $4766

jr_001_4767:
    dec b                                         ; $4767
    jr nz, jr_001_4761                            ; $4768

    ld a, c                                       ; $476A
    ld [wAlbum_SlotOp6D18_D932], a                ; $476B
    jp Far_Return                                 ; $476E


; C: the Japanese Sram_ComputeImageChecksums (02:4005), 77 instructions against 77, with 1 small edits (variables
; moved between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code
; compared
Sram_ComputeImageChecksums::
    ld hl, wPhotoImage                            ; $4771
    xor a                                         ; $4774
    ld b, $e0                                     ; $4775

jr_001_4777:
    add [hl]                                      ; $4777
    inc l                                         ; $4778
    add [hl]                                      ; $4779
    inc l                                         ; $477A
    add [hl]                                      ; $477B
    inc l                                         ; $477C
    add [hl]                                      ; $477D
    inc l                                         ; $477E
    add [hl]                                      ; $477F
    inc l                                         ; $4780
    add [hl]                                      ; $4781
    inc l                                         ; $4782
    add [hl]                                      ; $4783
    inc l                                         ; $4784
    add [hl]                                      ; $4785
    inc l                                         ; $4786
    add [hl]                                      ; $4787
    inc l                                         ; $4788
    add [hl]                                      ; $4789
    inc l                                         ; $478A
    add [hl]                                      ; $478B
    inc l                                         ; $478C
    add [hl]                                      ; $478D
    inc l                                         ; $478E
    add [hl]                                      ; $478F
    inc l                                         ; $4790
    add [hl]                                      ; $4791
    inc l                                         ; $4792
    add [hl]                                      ; $4793
    inc l                                         ; $4794
    add [hl]                                      ; $4795
    inc hl                                        ; $4796
    dec b                                         ; $4797
    jr nz, jr_001_4777                            ; $4798

    ld [wTagImageCheck], a                        ; $479A
    ld hl, $c000                                  ; $479D
    xor a                                         ; $47A0
    ld b, $e0                                     ; $47A1

jr_001_47a3:
    xor [hl]                                      ; $47A3
    inc l                                         ; $47A4
    xor [hl]                                      ; $47A5
    inc l                                         ; $47A6
    xor [hl]                                      ; $47A7
    inc l                                         ; $47A8
    xor [hl]                                      ; $47A9
    inc l                                         ; $47AA
    xor [hl]                                      ; $47AB
    inc l                                         ; $47AC
    xor [hl]                                      ; $47AD
    inc l                                         ; $47AE
    xor [hl]                                      ; $47AF
    inc l                                         ; $47B0
    xor [hl]                                      ; $47B1
    inc l                                         ; $47B2
    xor [hl]                                      ; $47B3
    inc l                                         ; $47B4
    xor [hl]                                      ; $47B5
    inc l                                         ; $47B6
    xor [hl]                                      ; $47B7
    inc l                                         ; $47B8
    xor [hl]                                      ; $47B9
    inc l                                         ; $47BA
    xor [hl]                                      ; $47BB
    inc l                                         ; $47BC
    xor [hl]                                      ; $47BD
    inc l                                         ; $47BE
    xor [hl]                                      ; $47BF
    inc l                                         ; $47C0
    xor [hl]                                      ; $47C1
    inc hl                                        ; $47C2
    dec b                                         ; $47C3
    jr nz, jr_001_47a3                            ; $47C4

    ld [wTagImageCheck + $1], a                   ; $47C6
    jp Far_Return                                 ; $47C9


; C: Z when the 5 bytes at HL equal the Magic string Data_01_4700 (code read; called by Sram_VerifyPhotoInfo,
; Sram_VerifyVector, Sram_VerifyIdCard and Sram_CheckCountersMagic)
Sram_CompareMagic::
    ld de, Sram_WriteMagic_Tbl4700                ; $47CC
    ld c, $05                                     ; $47CF

jr_001_47d1:
    ld a, [de]                                    ; $47D1
    cp [hl]                                       ; $47D2
    jr nz, jr_001_47da                            ; $47D3

    inc hl                                        ; $47D5
    inc de                                        ; $47D6
    dec c                                         ; $47D7
    jr nz, jr_001_47d1                            ; $47D8

jr_001_47da:
    ret                                           ; $47DA


; C: Z when the checksum stored at HL (+$4E, xor $54) matches Sram_Checksum of BC bytes at DE
Sram_VerifyChecksum::
    push hl                                       ; $47DB
    call Sram_Checksum                            ; $47DC
    ld e, l                                       ; $47DF
    ld d, h                                       ; $47E0
    pop hl                                        ; $47E1
    ld a, e                                       ; $47E2
    add $4e                                       ; $47E3
    cp [hl]                                       ; $47E5
    ret nz                                        ; $47E6

    inc hl                                        ; $47E7
    ld a, d                                       ; $47E8
    xor $54                                       ; $47E9
    cp [hl]                                       ; $47EB
    ret                                           ; $47EC


; C: photo slot A: Magic at +$F55 and checksum at +$F5A of the $5A bytes at +$F00; carry when bad
Sram_VerifyPhotoInfo::
    ld b, a                                       ; $47ED
    ldh a, [hSram_Format_FF8C]                    ; $47EE
    push af                                       ; $47F0
    ld a, b                                       ; $47F1
    call Sram_PhotoSlotAddr                       ; $47F2
    ldh [hSram_Format_FF8C], a                    ; $47F5
    ld [rRAMB], a                                 ; $47F7
    push af                                       ; $47FA
    ld a, $0a                                     ; $47FB
    ld [rRAMG], a                                 ; $47FD
    pop af                                        ; $4800
    push hl                                       ; $4801
    ld bc, $0f55                                  ; $4802
    add hl, bc                                    ; $4805
    call Sram_CompareMagic                        ; $4806
    pop bc                                        ; $4809
    jr nz, jr_001_4830                            ; $480A

    push bc                                       ; $480C
    ld hl, Prn_SendData_0F00                      ; $480D
    add hl, bc                                    ; $4810
    ld e, l                                       ; $4811
    ld d, h                                       ; $4812
    ld hl, Prn_SendData + $DF                     ; $4813
    add hl, bc                                    ; $4816
    ld bc, $005a                                  ; $4817
    call Sram_VerifyChecksum                      ; $481A
    pop bc                                        ; $481D
    jr nz, jr_001_4830                            ; $481E

    push af                                       ; $4820
    xor a                                         ; $4821
    ld [rRAMG], a                                 ; $4822
    pop af                                        ; $4825
    pop af                                        ; $4826
    ldh [hSram_Format_FF8C], a                    ; $4827
    ld [rRAMB], a                                 ; $4829
    and a                                         ; $482C
    jp Far_ReturnSramBank                         ; $482D


jr_001_4830:
    push af                                       ; $4830
    xor a                                         ; $4831
    ld [rRAMG], a                                 ; $4832
    pop af                                        ; $4835
    pop af                                        ; $4836
    ldh [hSram_Format_FF8C], a                    ; $4837
    ld [rRAMB], a                                 ; $4839
    scf                                           ; $483C
    jp Far_ReturnSramBank                         ; $483D


; C: bank 0: Magic at $B1D0 and checksum at $B1D5 of the $23 bytes from $B1B2 (the slot table); carry when bad
Sram_VerifyVector::
    ldh a, [hSram_Format_FF8C]                    ; $4840
    push af                                       ; $4842
    ld a, $00                                     ; $4843
    ldh [hSram_Format_FF8C], a                    ; $4845
    ld [rRAMB], a                                 ; $4847
    push af                                       ; $484A
    ld a, $0a                                     ; $484B
    ld [rRAMG], a                                 ; $484D
    pop af                                        ; $4850
    ld hl, $b1d0                                  ; $4851
    call Sram_CompareMagic                        ; $4854
    jr nz, jr_001_4877                            ; $4857

    ld de, $b1b2                                  ; $4859
    ld hl, $b1d5                                  ; $485C
    ld bc, $0023                                  ; $485F
    call Sram_VerifyChecksum                      ; $4862
    jr nz, jr_001_4877                            ; $4865

    push af                                       ; $4867
    xor a                                         ; $4868
    ld [rRAMG], a                                 ; $4869
    pop af                                        ; $486C
    pop af                                        ; $486D
    ldh [hSram_Format_FF8C], a                    ; $486E
    ld [rRAMB], a                                 ; $4870
    and a                                         ; $4873
    jp Far_ReturnSramBank                         ; $4874


jr_001_4877:
    push af                                       ; $4877
    xor a                                         ; $4878
    ld [rRAMG], a                                 ; $4879
    pop af                                        ; $487C
    pop af                                        ; $487D
    ldh [hSram_Format_FF8C], a                    ; $487E
    ld [rRAMB], a                                 ; $4880
    scf                                           ; $4883
    jp Far_ReturnSramBank                         ; $4884


; C: bank 1: Magic at $AFCA and checksum at $AFCF of the $17 bytes from $AFB8 (the ID card record); carry when bad
Sram_VerifyIdCard::
    ldh a, [hSram_Format_FF8C]                    ; $4887
    push af                                       ; $4889
    ld a, $01                                     ; $488A
    ldh [hSram_Format_FF8C], a                    ; $488C
    ld [rRAMB], a                                 ; $488E
    push af                                       ; $4891
    ld a, $0a                                     ; $4892
    ld [rRAMG], a                                 ; $4894
    pop af                                        ; $4897
    ld hl, $afca                                  ; $4898
    call Sram_CompareMagic                        ; $489B
    jr nz, jr_001_48be                            ; $489E

    ld de, $afb8                                  ; $48A0
    ld hl, $afcf                                  ; $48A3
    ld bc, $0017                                  ; $48A6
    call Sram_VerifyChecksum                      ; $48A9
    jr nz, jr_001_48be                            ; $48AC

    push af                                       ; $48AE
    xor a                                         ; $48AF
    ld [rRAMG], a                                 ; $48B0
    pop af                                        ; $48B3
    pop af                                        ; $48B4
    ldh [hSram_Format_FF8C], a                    ; $48B5
    ld [rRAMB], a                                 ; $48B7
    and a                                         ; $48BA
    jp Far_ReturnSramBank                         ; $48BB


jr_001_48be:
    push af                                       ; $48BE
    xor a                                         ; $48BF
    ld [rRAMG], a                                 ; $48C0
    pop af                                        ; $48C3
    pop af                                        ; $48C4
    ldh [hSram_Format_FF8C], a                    ; $48C5
    ld [rRAMB], a                                 ; $48C7
    scf                                           ; $48CA
    jp Far_ReturnSramBank                         ; $48CB


; C: bank 0: the Magic at $B012 after the counters $B000-$B011; no checksum on the counters
Sram_CheckCountersMagic::
    ldh a, [hSram_Format_FF8C]                    ; $48CE
    push af                                       ; $48D0
    ld a, $00                                     ; $48D1
    ldh [hSram_Format_FF8C], a                    ; $48D3
    ld [rRAMB], a                                 ; $48D5
    push af                                       ; $48D8
    ld a, $0a                                     ; $48D9
    ld [rRAMG], a                                 ; $48DB
    pop af                                        ; $48DE
    ld hl, $b012                                  ; $48DF
    call Sram_CompareMagic                        ; $48E2
    jr nz, jr_001_48f7                            ; $48E5

    push af                                       ; $48E7
    xor a                                         ; $48E8
    ld [rRAMG], a                                 ; $48E9
    pop af                                        ; $48EC
    pop af                                        ; $48ED
    ldh [hSram_Format_FF8C], a                    ; $48EE
    ld [rRAMB], a                                 ; $48F0
    and a                                         ; $48F3
    jp Far_ReturnSramBank                         ; $48F4


jr_001_48f7:
    push af                                       ; $48F7
    xor a                                         ; $48F8
    ld [rRAMG], a                                 ; $48F9
    pop af                                        ; $48FC
    pop af                                        ; $48FD
    ldh [hSram_Format_FF8C], a                    ; $48FE
    ld [rRAMB], a                                 ; $4900
    scf                                           ; $4903
    jp Far_ReturnSramBank                         ; $4904


; C: clears every SRAM bank with 00:023A (bank 0 $B000-$BFFF, bank 1, bank 2 except $AFF0-$AFFF, banks 3 and up); not
; run on a valid save
Sram_Format::
    ldh a, [hSram_Format_FF8C]                    ; $4907
    push af                                       ; $4909
    push af                                       ; $490A
    ld a, $0a                                     ; $490B
    ld [rRAMG], a                                 ; $490D
    pop af                                        ; $4910
    ld a, $00                                     ; $4911
    ldh [hSram_Format_FF8C], a                    ; $4913
    ld [rRAMB], a                                 ; $4915
    ld de, $0000                                  ; $4918
    ld hl, $b000                                  ; $491B
    ld bc, $1000                                  ; $491E
    call Mem_FillWord                             ; $4921
    ld a, $01                                     ; $4924
    ldh [hSram_Format_FF8C], a                    ; $4926
    ld [rRAMB], a                                 ; $4928
    ld de, $0000                                  ; $492B
    ld hl, $a000                                  ; $492E
    ld bc, $2000                                  ; $4931
    call Mem_FillWord                             ; $4934
    ld a, $02                                     ; $4937
    ldh [hSram_Format_FF8C], a                    ; $4939
    ld [rRAMB], a                                 ; $493B
    ld de, $0000                                  ; $493E
    ld hl, $a000                                  ; $4941
    ld bc, $0ff0                                  ; $4944
    call Mem_FillWord                             ; $4947
    ld de, $0000                                  ; $494A
    ld hl, $b000                                  ; $494D
    ld bc, $1000                                  ; $4950
    call Mem_FillWord                             ; $4953
    ld a, $03                                     ; $4956

jr_001_4958:
    push af                                       ; $4958
    ldh [hSram_Format_FF8C], a                    ; $4959
    ld [rRAMB], a                                 ; $495B
    ld de, $0000                                  ; $495E
    ld hl, $a000                                  ; $4961
    ld bc, $2000                                  ; $4964
    call Mem_FillWord                             ; $4967
    pop af                                        ; $496A
    inc a                                         ; $496B
    cp $08                                        ; $496C
    jr nz, jr_001_4958                            ; $496E

    ld a, $08                                     ; $4970
    ldh [hSram_Format_FF8C], a                    ; $4972
    ld [rRAMB], a                                 ; $4974
    ld de, $0000                                  ; $4977
    ld hl, $a000                                  ; $497A
    ld bc, $1ff0                                  ; $497D
    call Mem_FillWord                             ; $4980
    ld a, $09                                     ; $4983

jr_001_4985:
    push af                                       ; $4985
    ldh [hSram_Format_FF8C], a                    ; $4986
    ld [rRAMB], a                                 ; $4988
    ld de, $0000                                  ; $498B
    ld hl, $a000                                  ; $498E
    ld bc, $2000                                  ; $4991
    call Mem_FillWord                             ; $4994
    pop af                                        ; $4997
    inc a                                         ; $4998
    cp $10                                        ; $4999
    jr nz, jr_001_4985                            ; $499B

    ld a, $02                                     ; $499D
    ldh [hSram_Format_FF8C], a                    ; $499F
    ld [rRAMB], a                                 ; $49A1
    ld a, $1b                                     ; $49A4
    ld [$aff0], a                                 ; $49A6
    ld a, $13                                     ; $49A9
    ld [$aff1], a                                 ; $49AB
    push af                                       ; $49AE
    xor a                                         ; $49AF
    ld [rRAMG], a                                 ; $49B0
    pop af                                        ; $49B3
    pop af                                        ; $49B4
    ldh [hSram_Format_FF8C], a                    ; $49B5
    ld [rRAMB], a                                 ; $49B7
    jp Far_Return                                 ; $49BA


; C: photo slot A: Magic at +$F55, checksum at +$F5A of the $5A bytes at +$F00, the $5C bytes copied to the echo +$F5C
Sram_WritePhotoInfo::
    ld b, a                                       ; $49BD
    ldh a, [hSram_Format_FF8C]                    ; $49BE
    push af                                       ; $49C0
    ld a, b                                       ; $49C1
    call Sram_PhotoSlotAddr                       ; $49C2
    ldh [hSram_Format_FF8C], a                    ; $49C5
    ld [rRAMB], a                                 ; $49C7
    push af                                       ; $49CA
    ld a, $0a                                     ; $49CB
    ld [rRAMG], a                                 ; $49CD
    pop af                                        ; $49D0
    push hl                                       ; $49D1
    ld bc, $0fb8                                  ; $49D2
    call Call_000_01fe                            ; $49D5
    pop hl                                        ; $49D8
    push hl                                       ; $49D9
    ld bc, $0f55                                  ; $49DA
    add hl, bc                                    ; $49DD
    call Sram_WriteMagic                          ; $49DE
    pop bc                                        ; $49E1
    push bc                                       ; $49E2
    ld hl, Prn_SendData_0F00                      ; $49E3
    add hl, bc                                    ; $49E6
    ld e, l                                       ; $49E7
    ld d, h                                       ; $49E8
    ld hl, $0f5a                                  ; $49E9
    add hl, bc                                    ; $49EC
    ld bc, $005a                                  ; $49ED
    call Sram_WriteChecksum                       ; $49F0
    pop bc                                        ; $49F3
    ld hl, Prn_SendData_0F00                      ; $49F4
    add hl, bc                                    ; $49F7
    ld e, l                                       ; $49F8
    ld d, h                                       ; $49F9
    ld hl, $0f5c                                  ; $49FA
    add hl, bc                                    ; $49FD
    ld bc, $005c                                  ; $49FE
    call Copy_DEtoHL                              ; $4A01
    push af                                       ; $4A04
    xor a                                         ; $4A05
    ld [rRAMG], a                                 ; $4A06
    pop af                                        ; $4A09
    pop af                                        ; $4A0A
    ldh [hSram_Format_FF8C], a                    ; $4A0B
    ld [rRAMB], a                                 ; $4A0D
    jp Far_Return                                 ; $4A10


; C: bank 0: the slot table $B1B2 cleared (30 bytes), Magic, checksum, echo at $B1D7
Sram_FormatVector::
    ldh a, [hSram_Format_FF8C]                    ; $4A13
    push af                                       ; $4A15
    ld a, $00                                     ; $4A16
    ldh [hSram_Format_FF8C], a                    ; $4A18
    ld [rRAMB], a                                 ; $4A1A
    push af                                       ; $4A1D
    ld a, $0a                                     ; $4A1E
    ld [rRAMG], a                                 ; $4A20
    pop af                                        ; $4A23
    ld e, $ff                                     ; $4A24
    ld hl, $b1b2                                  ; $4A26
    ld bc, $001e                                  ; $4A29
    call Mem_FillByte                             ; $4A2C
    ld hl, $b1d0                                  ; $4A2F
    call Sram_WriteMagic                          ; $4A32
    ld de, $b1b2                                  ; $4A35
    ld hl, $b1d5                                  ; $4A38
    ld bc, $0023                                  ; $4A3B
    call Sram_WriteChecksum                       ; $4A3E
    ld de, $b1b2                                  ; $4A41
    ld hl, $b1d7                                  ; $4A44
    ld bc, $0025                                  ; $4A47
    call Copy_DEtoHL                              ; $4A4A
    xor a                                         ; $4A4D
    ld [wAlbum_SlotOp6D18_D932], a                ; $4A4E
    push af                                       ; $4A51
    xor a                                         ; $4A52
    ld [rRAMG], a                                 ; $4A53
    pop af                                        ; $4A56
    pop af                                        ; $4A57
    ldh [hSram_Format_FF8C], a                    ; $4A58
    ld [rRAMB], a                                 ; $4A5A
    jp Far_Return                                 ; $4A5D


; C: bank 1: the ID card record $AFB8 cleared ($12 bytes), Magic, checksum, echo at $AFD1
Sram_FormatIdCard::
    ldh a, [hSram_Format_FF8C]                    ; $4A60
    push af                                       ; $4A62
    ld a, $01                                     ; $4A63
    ldh [hSram_Format_FF8C], a                    ; $4A65
    ld [rRAMB], a                                 ; $4A67
    push af                                       ; $4A6A
    ld a, $0a                                     ; $4A6B
    ld [rRAMG], a                                 ; $4A6D
    pop af                                        ; $4A70
    ld e, $00                                     ; $4A71
    ld hl, $afb8                                  ; $4A73
    ld bc, $0012                                  ; $4A76
    call Mem_FillByte                             ; $4A79
    ld hl, $afca                                  ; $4A7C
    call Sram_WriteMagic                          ; $4A7F
    ld de, $afb8                                  ; $4A82
    ld hl, $afcf                                  ; $4A85
    ld bc, $0017                                  ; $4A88
    call Sram_WriteChecksum                       ; $4A8B
    ld de, $afb8                                  ; $4A8E
    ld hl, $afd1                                  ; $4A91
    ld bc, $0025                                  ; $4A94
    call Copy_DEtoHL                              ; $4A97
    push af                                       ; $4A9A
    xor a                                         ; $4A9B
    ld [rRAMG], a                                 ; $4A9C
    pop af                                        ; $4A9F
    pop af                                        ; $4AA0
    ldh [hSram_Format_FF8C], a                    ; $4AA1
    ld [rRAMB], a                                 ; $4AA3
    jp Far_Return                                 ; $4AA6


; C: bank 0: the counters $B000-$B011 cleared and the Magic written at $B012
Sram_FormatCounters::
    ldh a, [hSram_Format_FF8C]                    ; $4AA9
    push af                                       ; $4AAB
    ld a, $00                                     ; $4AAC
    ldh [hSram_Format_FF8C], a                    ; $4AAE
    ld [rRAMB], a                                 ; $4AB0
    push af                                       ; $4AB3
    ld a, $0a                                     ; $4AB4
    ld [rRAMG], a                                 ; $4AB6
    pop af                                        ; $4AB9
    ld e, $00                                     ; $4ABA
    ld hl, $b000                                  ; $4ABC
    ld bc, $0012                                  ; $4ABF
    call Mem_FillByte                             ; $4AC2
    ld a, $60                                     ; $4AC5
    ld [$b00d], a                                 ; $4AC7
    ld hl, $b012                                  ; $4ACA
    call Sram_WriteMagic                          ; $4ACD
    push af                                       ; $4AD0
    xor a                                         ; $4AD1
    ld [rRAMG], a                                 ; $4AD2
    pop af                                        ; $4AD5
    pop af                                        ; $4AD6
    ldh [hSram_Format_FF8C], a                    ; $4AD7
    ld [rRAMB], a                                 ; $4AD9
    jp Far_Return                                 ; $4ADC


; C: bank 0: $690 bytes from $B1FC cleared: the three photos of the name card (05:41B2 at boot, 0F:4AFE); code read
Sram_ClearCardPhotos::
    ldh a, [hSram_Format_FF8C]                    ; $4ADF
    push af                                       ; $4AE1
    ld a, $00                                     ; $4AE2
    ldh [hSram_Format_FF8C], a                    ; $4AE4
    ld [rRAMB], a                                 ; $4AE6
    push af                                       ; $4AE9
    ld a, $0a                                     ; $4AEA
    ld [rRAMG], a                                 ; $4AEC
    pop af                                        ; $4AEF
    ld e, $00                                     ; $4AF0
    ld hl, $b1fc                                  ; $4AF2
    ld bc, $0690                                  ; $4AF5
    call Mem_FillByte                             ; $4AF8
    push af                                       ; $4AFB
    xor a                                         ; $4AFC
    ld [rRAMG], a                                 ; $4AFD
    pop af                                        ; $4B00
    pop af                                        ; $4B01
    ldh [hSram_Format_FF8C], a                    ; $4B02
    ld [rRAMB], a                                 ; $4B04
    jp Far_Return                                 ; $4B07


; C: photo slot A: $F00 bytes into $C000, then $800 into tiles $9000 and $600 into $8000 (HBlank copy), its $55 bytes
; of information into $DA52
Photo_LoadToBufferAndVram::
    ld b, a                                       ; $4B0A
    ldh a, [hSram_Format_FF8C]                    ; $4B0B
    push af                                       ; $4B0D
    ld a, b                                       ; $4B0E
    call Sram_PhotoSlotAddr                       ; $4B0F
    ldh [hSram_Format_FF8C], a                    ; $4B12
    ld [rRAMB], a                                 ; $4B14
    ld [wPrintSrcTable + $2], a                   ; $4B17
    ld a, l                                       ; $4B1A
    ld [wPrintSrcTable], a                        ; $4B1B
    ld a, h                                       ; $4B1E
    ld [wPrintSrcTable + $1], a                   ; $4B1F
    push hl                                       ; $4B22
    ld e, l                                       ; $4B23
    ld d, h                                       ; $4B24
    ld hl, $c000                                  ; $4B25
    ld bc, $0f00                                  ; $4B28
    call Copy_DEtoHL                              ; $4B2B
    ld de, $c000                                  ; $4B2E
    ld hl, $9000                                  ; $4B31
    ld bc, $0800                                  ; $4B34
    call Vram_CopyHBlank                          ; $4B37
    ld de, $c800                                  ; $4B3A
    ld hl, $8000                                  ; $4B3D
    ld bc, $0600                                  ; $4B40
    call Vram_CopyHBlank                          ; $4B43
    pop hl                                        ; $4B46
    push hl                                       ; $4B47
    ld de, $0f00                                  ; $4B48
    add hl, de                                    ; $4B4B
    ld e, l                                       ; $4B4C
    ld d, h                                       ; $4B4D
    ld hl, wSlotTagOwnerCopy                      ; $4B4E
    ld bc, $0055                                  ; $4B51
    call Copy_DEtoHL                              ; $4B54
    pop hl                                        ; $4B57
    pop af                                        ; $4B58
    ldh [hSram_Format_FF8C], a                    ; $4B59
    ld [rRAMB], a                                 ; $4B5B
    jp Far_Return                                 ; $4B5E


; C: photo slot A straight into tiles $9000 / $8000 and its information into $DA52
Photo_LoadToVram::
    ld b, a                                       ; $4B61
    ldh a, [hSram_Format_FF8C]                    ; $4B62
    push af                                       ; $4B64
    ld a, b                                       ; $4B65
    call Sram_PhotoSlotAddr                       ; $4B66
    ldh [hSram_Format_FF8C], a                    ; $4B69
    ld [rRAMB], a                                 ; $4B6B
    ld [wPrintSrcTable + $2], a                   ; $4B6E
    ld a, l                                       ; $4B71
    ld [wPrintSrcTable], a                        ; $4B72
    ld a, h                                       ; $4B75
    ld [wPrintSrcTable + $1], a                   ; $4B76
    push hl                                       ; $4B79
    ld e, l                                       ; $4B7A
    ld d, h                                       ; $4B7B
    ld hl, $9000                                  ; $4B7C
    ld bc, $0800                                  ; $4B7F
    call Vram_CopyHBlank                          ; $4B82
    pop hl                                        ; $4B85
    push hl                                       ; $4B86
    ld de, $0800                                  ; $4B87
    add hl, de                                    ; $4B8A
    ld e, l                                       ; $4B8B
    ld d, h                                       ; $4B8C
    ld hl, $8000                                  ; $4B8D
    ld bc, $0600                                  ; $4B90
    call Vram_CopyHBlank                          ; $4B93
    pop hl                                        ; $4B96
    push hl                                       ; $4B97
    ld de, $0f00                                  ; $4B98
    add hl, de                                    ; $4B9B
    ld e, l                                       ; $4B9C
    ld d, h                                       ; $4B9D
    ld hl, wSlotTagOwnerCopy                      ; $4B9E
    ld bc, $0055                                  ; $4BA1
    call Copy_DEtoHL                              ; $4BA4
    pop hl                                        ; $4BA7
    pop af                                        ; $4BA8
    ldh [hSram_Format_FF8C], a                    ; $4BA9
    ld [rRAMB], a                                 ; $4BAB
    jp Far_Return                                 ; $4BAE


; C: photo slot A: $F00 bytes into $C000 and its information into $DA52
Photo_LoadToBuffer::
    ld b, a                                       ; $4BB1
    ldh a, [hSram_Format_FF8C]                    ; $4BB2
    push af                                       ; $4BB4
    ld a, b                                       ; $4BB5
    call Sram_PhotoSlotAddr                       ; $4BB6
    ldh [hSram_Format_FF8C], a                    ; $4BB9
    ld [rRAMB], a                                 ; $4BBB
    ld [wPrintSrcTable + $2], a                   ; $4BBE
    ld a, l                                       ; $4BC1
    ld [wPrintSrcTable], a                        ; $4BC2
    ld a, h                                       ; $4BC5
    ld [wPrintSrcTable + $1], a                   ; $4BC6
    push hl                                       ; $4BC9
    ld e, l                                       ; $4BCA
    ld d, h                                       ; $4BCB
    ld hl, $c000                                  ; $4BCC
    ld bc, $0f00                                  ; $4BCF
    call Copy_DEtoHL                              ; $4BD2
    pop hl                                        ; $4BD5
    push hl                                       ; $4BD6
    ld de, $0f00                                  ; $4BD7
    add hl, de                                    ; $4BDA
    ld e, l                                       ; $4BDB
    ld d, h                                       ; $4BDC
    ld hl, wSlotTagOwnerCopy                      ; $4BDD
    ld bc, $0055                                  ; $4BE0
    call Copy_DEtoHL                              ; $4BE3
    pop hl                                        ; $4BE6
    pop af                                        ; $4BE7
    ldh [hSram_Format_FF8C], a                    ; $4BE8
    ld [rRAMB], a                                 ; $4BEA
    jp Far_Return                                 ; $4BED


; C: photo slot A: $E00 bytes into tiles $8800 and into $C000
Photo_LoadTiles8800::
    ld b, a                                       ; $4BF0
    ldh a, [hSram_Format_FF8C]                    ; $4BF1
    push af                                       ; $4BF3
    ld a, b                                       ; $4BF4
    call Sram_PhotoSlotAddr                       ; $4BF5
    ldh [hSram_Format_FF8C], a                    ; $4BF8
    ld [rRAMB], a                                 ; $4BFA
    ld [wPrintSrcTable + $2], a                   ; $4BFD
    ld a, l                                       ; $4C00
    ld [wPrintSrcTable], a                        ; $4C01
    ld a, h                                       ; $4C04
    ld [wPrintSrcTable + $1], a                   ; $4C05
    push hl                                       ; $4C08
    ld e, l                                       ; $4C09
    ld d, h                                       ; $4C0A
    ld hl, $8800                                  ; $4C0B
    ld bc, $0e00                                  ; $4C0E
    call Vram_CopyHBlank                          ; $4C11
    pop hl                                        ; $4C14
    push hl                                       ; $4C15
    ld e, l                                       ; $4C16
    ld d, h                                       ; $4C17
    ld hl, $c000                                  ; $4C18
    ld bc, $0e00                                  ; $4C1B
    call Copy_DEtoHL                              ; $4C1E
    pop hl                                        ; $4C21
    pop af                                        ; $4C22
    ldh [hSram_Format_FF8C], a                    ; $4C23
    ld [rRAMB], a                                 ; $4C25
    jp Far_Return                                 ; $4C28


; C: photo slot A: $C000 ($F00 bytes) and the information $DA52 ($55 bytes) into SRAM, Magic, checksum and echo
Photo_Store::
    ld b, a                                       ; $4C2B
    ldh a, [hSram_Format_FF8C]                    ; $4C2C
    push af                                       ; $4C2E
    ld a, b                                       ; $4C2F
    call Sram_PhotoSlotAddr                       ; $4C30
    ldh [hSram_Format_FF8C], a                    ; $4C33
    ld [rRAMB], a                                 ; $4C35
    push af                                       ; $4C38
    ld a, $0a                                     ; $4C39
    ld [rRAMG], a                                 ; $4C3B
    pop af                                        ; $4C3E
    push hl                                       ; $4C3F
    ld de, $c000                                  ; $4C40
    ld bc, $0f00                                  ; $4C43
    call Copy_DEtoHL                              ; $4C46
    pop hl                                        ; $4C49
    push hl                                       ; $4C4A
    ld de, wSlotTagOwnerCopy                      ; $4C4B
    ld bc, $0f00                                  ; $4C4E
    add hl, bc                                    ; $4C51
    ld bc, $0055                                  ; $4C52
    call Copy_DEtoHL                              ; $4C55
    pop hl                                        ; $4C58
    push hl                                       ; $4C59
    ld bc, $0f55                                  ; $4C5A
    add hl, bc                                    ; $4C5D
    call Sram_WriteMagic                          ; $4C5E
    pop bc                                        ; $4C61
    push bc                                       ; $4C62
    ld hl, Prn_SendData_0F00                      ; $4C63
    add hl, bc                                    ; $4C66
    ld e, l                                       ; $4C67
    ld d, h                                       ; $4C68
    ld hl, $0f5a                                  ; $4C69
    add hl, bc                                    ; $4C6C
    ld bc, $005a                                  ; $4C6D
    call Sram_WriteChecksum                       ; $4C70
    pop bc                                        ; $4C73
    ld hl, Prn_SendData_0F00                      ; $4C74
    add hl, bc                                    ; $4C77
    ld e, l                                       ; $4C78
    ld d, h                                       ; $4C79
    ld hl, $0f5c                                  ; $4C7A
    add hl, bc                                    ; $4C7D
    ld bc, $005c                                  ; $4C7E
    call Copy_DEtoHL                              ; $4C81
    push af                                       ; $4C84
    xor a                                         ; $4C85
    ld [rRAMG], a                                 ; $4C86
    pop af                                        ; $4C89
    pop af                                        ; $4C8A
    ldh [hSram_Format_FF8C], a                    ; $4C8B
    ld [rRAMB], a                                 ; $4C8D
    jp Far_Return                                 ; $4C90


; C: bank 0: $690 bytes from $B1FC into $C230: the three photos of the name card, 3 x $230 bytes (35 tiles each;
; Mode0B_State05 makes them from the album photos picked at $0B:$04, the card screens and 07:608D / 07:6122 load
; them); code read
Sram_LoadCardPhotos::
    ldh a, [hSram_Format_FF8C]                    ; $4C93
    push af                                       ; $4C95
    ld a, $00                                     ; $4C96
    ldh [hSram_Format_FF8C], a                    ; $4C98
    ld [rRAMB], a                                 ; $4C9A
    ld de, $b1fc                                  ; $4C9D
    ld hl, wCardPhotos                            ; $4CA0
    ld bc, $0690                                  ; $4CA3
    call Copy_DEtoHL                              ; $4CA6
    pop af                                        ; $4CA9
    ldh [hSram_Format_FF8C], a                    ; $4CAA
    ld [rRAMB], a                                 ; $4CAC
    jp Far_Return                                 ; $4CAF


; C: bank 0: $690 bytes from $C230 into $B1FC: the three photos of the name card (called from Mode0B_State06, 06:53E0,
; when the card is finished); code read
Sram_StoreCardPhotos::
    ldh a, [hSram_Format_FF8C]                    ; $4CB2
    push af                                       ; $4CB4
    ld a, $00                                     ; $4CB5
    ldh [hSram_Format_FF8C], a                    ; $4CB7
    ld [rRAMB], a                                 ; $4CB9
    push af                                       ; $4CBC
    ld a, $0a                                     ; $4CBD
    ld [rRAMG], a                                 ; $4CBF
    pop af                                        ; $4CC2
    ld de, wCardPhotos                            ; $4CC3
    ld hl, $b1fc                                  ; $4CC6
    ld bc, $0690                                  ; $4CC9
    call Copy_DEtoHL                              ; $4CCC
    push af                                       ; $4CCF
    xor a                                         ; $4CD0
    ld [rRAMG], a                                 ; $4CD1
    pop af                                        ; $4CD4
    pop af                                        ; $4CD5
    ldh [hSram_Format_FF8C], a                    ; $4CD6
    ld [rRAMB], a                                 ; $4CD8
    jp Far_Return                                 ; $4CDB


    db $f0, $8c, $f5, $3e, $00, $e0, $8c, $ea, $00, $40, $f5, $3e, $0a, $ea, $00, $00
    db $f1, $11, $30, $c2, $21, $fc, $b1, $01, $30, $02, $cd, $1c, $02, $f5, $af, $ea
    db $00, $00, $f1, $f1, $e0, $8c, $ea, $00, $40, $c3, $73, $01, $f0, $8c, $f5, $3e
    db $00, $e0, $8c, $ea, $00, $40, $f5, $3e, $0a, $ea, $00, $00, $f1, $11, $60, $c4
    db $21, $2c, $b4, $01, $30, $02, $cd, $1c, $02, $f5, $af, $ea, $00, $00, $f1, $f1
    db $e0, $8c, $ea, $00, $40, $c3, $73, $01, $f0, $8c, $f5, $3e, $00, $e0, $8c, $ea
    db $00, $40, $f5, $3e, $0a, $ea, $00, $00, $f1, $11, $90, $c6, $21, $5c, $b6, $01
    db $30, $02, $cd, $1c, $02, $f5, $af, $ea, $00, $00, $f1, $f1, $e0, $8c, $ea, $00
    db $40, $c3, $73, $01

; C: bank 0: the slot table $B1B2 (30 bytes) into $DAA9
Sram_LoadVector::
    ldh a, [hSram_Format_FF8C]                    ; $4D62
    push af                                       ; $4D64
    ld a, $00                                     ; $4D65
    ldh [hSram_Format_FF8C], a                    ; $4D67
    ld [rRAMB], a                                 ; $4D69
    ld de, $b1b2                                  ; $4D6C
    ld hl, wPhotoVectorRam                        ; $4D6F
    ld bc, $001e                                  ; $4D72
    call Copy_DEtoHL                              ; $4D75
    pop af                                        ; $4D78
    ldh [hSram_Format_FF8C], a                    ; $4D79
    ld [rRAMB], a                                 ; $4D7B
    jp Far_Return                                 ; $4D7E


; C: A = $FF goes to Photo_FindSlot_Far, else A - 1 first
Photo_FindSlotA::
    cp $ff                                        ; $4D81
    jr z, Photo_FindSlot_Far                      ; $4D83

    dec a                                         ; $4D85

; C: same code as the Japanese Photo_FindSlot_Far (02:444D, 25 bytes, masked match)
Photo_FindSlot_Far::
    ld hl, wPhotoVectorRam                        ; $4D86
    ld b, $1e                                     ; $4D89

jr_001_4d8b:
    cp [hl]                                       ; $4D8B
    jr z, jr_001_4d97                             ; $4D8C

    inc hl                                        ; $4D8E
    dec b                                         ; $4D8F
    jr nz, jr_001_4d8b                            ; $4D90

    xor a                                         ; $4D92
    scf                                           ; $4D93
    jp Far_ReturnSramBank                         ; $4D94


jr_001_4d97:
    ld a, b                                       ; $4D97
    cpl                                           ; $4D98
    add $1f                                       ; $4D99
    and a                                         ; $4D9B
    jp Far_ReturnSramBank                         ; $4D9C


; C: slot A of $DAA9 gets the next order number, then Photo_RenumberVector and Photo_CountUsed
Photo_AddToVector::
    ld e, a                                       ; $4D9F
    ld d, $00                                     ; $4DA0
    ld hl, wPhotoVectorRam                        ; $4DA2
    add hl, de                                    ; $4DA5
    push hl                                       ; $4DA6
    ld hl, wPhotoVectorRam                        ; $4DA7
    ld c, $00                                     ; $4DAA
    ld b, $1e                                     ; $4DAC

jr_001_4dae:
    ld a, [hl]                                    ; $4DAE
    cp $ff                                        ; $4DAF
    jr z, jr_001_4db8                             ; $4DB1

    cp c                                          ; $4DB3
    jr c, jr_001_4db8                             ; $4DB4

    inc a                                         ; $4DB6
    ld c, a                                       ; $4DB7

jr_001_4db8:
    inc hl                                        ; $4DB8
    dec b                                         ; $4DB9
    jr nz, jr_001_4dae                            ; $4DBA

    pop hl                                        ; $4DBC
    ld [hl], c                                    ; $4DBD
    call Photo_RenumberVector                     ; $4DBE
    ld b, BANK(Photo_CountUsed)                   ; $4DC1
    ld hl, Photo_CountUsed                        ; $4DC3
    call Far_Call                                 ; $4DC6
    jp Far_Return                                 ; $4DC9


; C: slot A of $DAA9 = $FF, then Photo_RenumberVector and Photo_CountUsed
Photo_RemoveFromVector::
    ld e, a                                       ; $4DCC
    ld d, $00                                     ; $4DCD
    ld hl, wPhotoVectorRam                        ; $4DCF
    add hl, de                                    ; $4DD2
    ld a, $ff                                     ; $4DD3
    ld [hl], a                                    ; $4DD5
    call Photo_RenumberVector                     ; $4DD6
    ld b, BANK(Photo_CountUsed)                   ; $4DD9
    ld hl, Photo_CountUsed                        ; $4DDB
    call Far_Call                                 ; $4DDE
    jp Far_Return                                 ; $4DE1


; C: bank 0: $DAA9 (30 bytes) into $B1B2, Magic, checksum, echo
Sram_StoreVector::
    ldh a, [hSram_Format_FF8C]                    ; $4DE4
    push af                                       ; $4DE6
    ld a, $00                                     ; $4DE7
    ldh [hSram_Format_FF8C], a                    ; $4DE9
    ld [rRAMB], a                                 ; $4DEB
    push af                                       ; $4DEE
    ld a, $0a                                     ; $4DEF
    ld [rRAMG], a                                 ; $4DF1
    pop af                                        ; $4DF4
    ld de, wPhotoVectorRam                        ; $4DF5
    ld hl, $b1b2                                  ; $4DF8
    ld bc, $001e                                  ; $4DFB
    call Copy_DEtoHL                              ; $4DFE
    ld hl, $b1d0                                  ; $4E01
    call Sram_WriteMagic                          ; $4E04
    ld de, $b1b2                                  ; $4E07
    ld hl, $b1d5                                  ; $4E0A
    ld bc, $0023                                  ; $4E0D
    call Sram_WriteChecksum                       ; $4E10
    ld de, $b1b2                                  ; $4E13
    ld hl, $b1d7                                  ; $4E16
    ld bc, $0025                                  ; $4E19
    call Copy_DEtoHL                              ; $4E1C
    push af                                       ; $4E1F
    xor a                                         ; $4E20
    ld [rRAMG], a                                 ; $4E21
    pop af                                        ; $4E24
    pop af                                        ; $4E25
    ldh [hSram_Format_FF8C], a                    ; $4E26
    ld [rRAMB], a                                 ; $4E28
    jp Far_Return                                 ; $4E2B


; C: bank 1: the ID card record $AFB8 ($12 bytes) into $DADB
Sram_LoadIdCard::
    ldh a, [hSram_Format_FF8C]                    ; $4E2E
    push af                                       ; $4E30
    ld a, $01                                     ; $4E31
    ldh [hSram_Format_FF8C], a                    ; $4E33
    ld [rRAMB], a                                 ; $4E35
    ld de, $afb8                                  ; $4E38
    ld hl, wIdCard                                ; $4E3B
    ld bc, $0012                                  ; $4E3E
    call Copy_DEtoHL                              ; $4E41
    pop af                                        ; $4E44
    ldh [hSram_Format_FF8C], a                    ; $4E45
    ld [rRAMB], a                                 ; $4E47
    jp Far_Return                                 ; $4E4A


; C: bank 1: $DADB ($12 bytes) into $AFB8, Magic, checksum, echo
Sram_StoreIdCard::
    ldh a, [hSram_Format_FF8C]                    ; $4E4D
    push af                                       ; $4E4F
    ld a, $01                                     ; $4E50
    ldh [hSram_Format_FF8C], a                    ; $4E52
    ld [rRAMB], a                                 ; $4E54
    push af                                       ; $4E57
    ld a, $0a                                     ; $4E58
    ld [rRAMG], a                                 ; $4E5A
    pop af                                        ; $4E5D
    ld de, wIdCard                                ; $4E5E
    ld hl, $afb8                                  ; $4E61
    ld bc, $0012                                  ; $4E64
    call Copy_DEtoHL                              ; $4E67
    ld hl, $afca                                  ; $4E6A
    call Sram_WriteMagic                          ; $4E6D
    ld de, $afb8                                  ; $4E70
    ld hl, $afcf                                  ; $4E73
    ld bc, $0017                                  ; $4E76
    call Sram_WriteChecksum                       ; $4E79
    ld de, $afb8                                  ; $4E7C
    ld hl, $afd1                                  ; $4E7F
    ld bc, $0025                                  ; $4E82
    call Copy_DEtoHL                              ; $4E85
    push af                                       ; $4E88
    xor a                                         ; $4E89
    ld [rRAMG], a                                 ; $4E8A
    pop af                                        ; $4E8D
    pop af                                        ; $4E8E
    ldh [hSram_Format_FF8C], a                    ; $4E8F
    ld [rRAMB], a                                 ; $4E91
    jp Far_Return                                 ; $4E94


; C: bank 0: the counters $B000 ($12 bytes) into $DAC9
Counters_Load::
    ldh a, [hSram_Format_FF8C]                    ; $4E97
    push af                                       ; $4E99
    ld a, $00                                     ; $4E9A
    ldh [hSram_Format_FF8C], a                    ; $4E9C
    ld [rRAMB], a                                 ; $4E9E
    ld de, $b000                                  ; $4EA1
    ld hl, wCountTaken                            ; $4EA4
    ld bc, $0012                                  ; $4EA7
    call Copy_DEtoHL                              ; $4EAA
    pop af                                        ; $4EAD
    ldh [hSram_Format_FF8C], a                    ; $4EAE
    ld [rRAMB], a                                 ; $4EB0
    jp Far_Return                                 ; $4EB3


; C: bank 0: $DAC9 ($12 bytes) into $B000 and the Magic at $B012
Counters_Store::
    ldh a, [hSram_Format_FF8C]                    ; $4EB6
    push af                                       ; $4EB8
    ld a, $00                                     ; $4EB9
    ldh [hSram_Format_FF8C], a                    ; $4EBB
    ld [rRAMB], a                                 ; $4EBD
    push af                                       ; $4EC0
    ld a, $0a                                     ; $4EC1
    ld [rRAMG], a                                 ; $4EC3
    pop af                                        ; $4EC6
    ld de, wCountTaken                            ; $4EC7
    ld hl, $b000                                  ; $4ECA
    ld bc, $0012                                  ; $4ECD
    call Copy_DEtoHL                              ; $4ED0
    ld hl, $b012                                  ; $4ED3
    call Sram_WriteMagic                          ; $4ED6
    push af                                       ; $4ED9
    xor a                                         ; $4EDA
    ld [rRAMG], a                                 ; $4EDB
    pop af                                        ; $4EDE
    pop af                                        ; $4EDF
    ldh [hSram_Format_FF8C], a                    ; $4EE0
    ld [rRAMB], a                                 ; $4EE2
    jp Far_Return                                 ; $4EE5


; C: photo slot A decoded by 00:24E0 into $C000, $380 bytes into tiles $9000, its information into $DA52; code read;
; runs in the album (mode $03)
Photo_LoadThumbToVram::
    ld b, a                                       ; $4EE8
    ldh a, [hSram_Format_FF8C]                    ; $4EE9
    push af                                       ; $4EEB
    ld a, b                                       ; $4EEC
    call Sram_PhotoSlotAddr                       ; $4EED
    ldh [hSram_Format_FF8C], a                    ; $4EF0
    ld [rRAMB], a                                 ; $4EF2
    push hl                                       ; $4EF5
    ld e, l                                       ; $4EF6
    ld d, h                                       ; $4EF7
    ld hl, $c000                                  ; $4EF8
    call Img_ExpandThumb                          ; $4EFB
    ld de, $c000                                  ; $4EFE
    ld hl, $9000                                  ; $4F01
    ld bc, $0380                                  ; $4F04
    call Vram_CopyHBlank                          ; $4F07
    pop hl                                        ; $4F0A
    push hl                                       ; $4F0B
    ld de, $0f00                                  ; $4F0C
    add hl, de                                    ; $4F0F
    ld e, l                                       ; $4F10
    ld d, h                                       ; $4F11
    ld hl, wSlotTagOwnerCopy                      ; $4F12
    ld bc, $0055                                  ; $4F15
    call Copy_DEtoHL                              ; $4F18
    pop hl                                        ; $4F1B
    pop af                                        ; $4F1C
    ldh [hSram_Format_FF8C], a                    ; $4F1D
    ld [rRAMB], a                                 ; $4F1F
    jp Far_Return                                 ; $4F22


; C: 8 photo slots (by A x 8 + 1) found by Photo_FindSlotA and copied into the buffer at $C000 (Copy_Unrolled), the
; empty-slot picture 17:7800 for a slot without a photo; code read
Photos_LoadPage8::
    sla a                                         ; $4F25
    sla a                                         ; $4F27
    sla a                                         ; $4F29
    and $18                                       ; $4F2B
    inc a                                         ; $4F2D
    ld c, a                                       ; $4F2E
    ld b, $08                                     ; $4F2F
    ld hl, $c000                                  ; $4F31

jr_001_4f34:
    push bc                                       ; $4F34
    ldh a, [hSram_Format_FF8C]                    ; $4F35
    push af                                       ; $4F37
    push hl                                       ; $4F38
    ld a, c                                       ; $4F39
    ld b, BANK(Photo_FindSlotA)                   ; $4F3A
    ld hl, Photo_FindSlotA                        ; $4F3C
    call Far_CallKeepA                            ; $4F3F
    jr nc, jr_001_4f4f                            ; $4F42

    ld de, Gfx_17_7800_Mode08_ExchangePhotoTrain_State00 ; $4F44
    ld a, $17                                     ; $4F47
    pop hl                                        ; $4F49
    call Copy_FarUnrolled                         ; $4F4A
    jr jr_001_4f61                                ; $4F4D

jr_001_4f4f:
    call Sram_PhotoSlotAddr                       ; $4F4F
    ldh [hSram_Format_FF8C], a                    ; $4F52
    ld [rRAMB], a                                 ; $4F54
    ld de, $0e00                                  ; $4F57
    add hl, de                                    ; $4F5A
    ld e, l                                       ; $4F5B
    ld d, h                                       ; $4F5C
    pop hl                                        ; $4F5D
    call Copy_Unrolled                            ; $4F5E

jr_001_4f61:
    pop af                                        ; $4F61
    ldh [hSram_Format_FF8C], a                    ; $4F62
    ld [rRAMB], a                                 ; $4F64
    pop bc                                        ; $4F67
    inc c                                         ; $4F68
    dec b                                         ; $4F69
    jr nz, jr_001_4f34                            ; $4F6A

    jp Far_Return                                 ; $4F6C


; C: as Photo_LoadToBufferAndVram with Copy_DEtoHL (screen off)
Photo_LoadToVramScreenOff::
    ld b, a                                       ; $4F6F
    ldh a, [hSram_Format_FF8C]                    ; $4F70
    push af                                       ; $4F72
    ld a, b                                       ; $4F73
    call Sram_PhotoSlotAddr                       ; $4F74
    ldh [hSram_Format_FF8C], a                    ; $4F77
    ld [rRAMB], a                                 ; $4F79
    ld [wPrintSrcTable + $2], a                   ; $4F7C
    ld a, l                                       ; $4F7F
    ld [wPrintSrcTable], a                        ; $4F80
    ld a, h                                       ; $4F83
    ld [wPrintSrcTable + $1], a                   ; $4F84
    push hl                                       ; $4F87
    ld e, l                                       ; $4F88
    ld d, h                                       ; $4F89
    ld hl, $c000                                  ; $4F8A
    ld bc, $0f00                                  ; $4F8D
    call Copy_DEtoHL                              ; $4F90
    ld de, $c000                                  ; $4F93
    ld hl, $9000                                  ; $4F96
    ld bc, $0800                                  ; $4F99
    call Copy_DEtoHL                              ; $4F9C
    ld de, $c800                                  ; $4F9F
    ld hl, $8000                                  ; $4FA2
    ld bc, $0600                                  ; $4FA5
    call Copy_DEtoHL                              ; $4FA8
    pop hl                                        ; $4FAB
    push hl                                       ; $4FAC
    ld de, $0f00                                  ; $4FAD
    add hl, de                                    ; $4FB0
    ld e, l                                       ; $4FB1
    ld d, h                                       ; $4FB2
    ld hl, wSlotTagOwnerCopy                      ; $4FB3
    ld bc, $0055                                  ; $4FB6
    call Copy_DEtoHL                              ; $4FB9
    pop hl                                        ; $4FBC
    pop af                                        ; $4FBD
    ldh [hSram_Format_FF8C], a                    ; $4FBE
    ld [rRAMB], a                                 ; $4FC0
    jp Far_Return                                 ; $4FC3


    ; padding
    ds $3a, $00

; C: read in the runs by ScriptSlots_Run, ScriptCmd_JumpByByte, ScriptCmd_SetE1; first read on the screen
; Mode10_ScratchCard_State02 (trace/read_screens_kitty*.npz)
Script_01_5000_Mode10_ScratchCard_State02::
    db $19, $59, $98, $1e, $59, $05, $07, $0c, $59, $13, $30, $50, $57, $59, $5f, $d9
    db $18, $50, $1e, $50, $24, $50, $2a, $50, $01, $80, $00, $7f, $dc, $58, $01, $80
    db $40, $7f, $dc, $58, $01, $80, $80, $7f, $dc, $58, $01, $80, $c0, $7f, $dc, $58

; C: script callback: hFFE3-hFFE4 = word [$D8F4] of 01:5046
Puzzle15_ScriptSetPtrByItem::
    push hl                                       ; $5030
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5031
    sla a                                         ; $5034
    ld c, a                                       ; $5036
    ld b, $00                                     ; $5037
    ld hl, Script_01_5046_Puzzle15_ScriptSetPtrByItem; $5039
    add hl, bc                                    ; $503C
    ld a, [hl+]                                   ; $503D
    ldh [hScriptCmd_AddE3_FFE3], a                ; $503E
    ld a, [hl]                                    ; $5040
    ldh [hScriptCmd_AddE3_B_FFE4], a              ; $5041
    pop hl                                        ; $5043
    scf                                           ; $5044
    ret                                           ; $5045


; C: named by the code of Puzzle15_ScriptSetPtrByItem (01:5039); read in the runs by ScriptSlots_Run,
; Puzzle15_ScriptSetPtrByItem, ScriptSlots_Add; first read on the screen Mode0F_FifteenPuzzle_State05
; (trace/read_screens_kitty*.npz)
Script_01_5046_Puzzle15_ScriptSetPtrByItem::
    db $22, $98, $28, $98, $2e, $98, $42, $99, $48, $99, $4e, $99, $00, $50, $69, $59
    db $19, $59, $98, $1e, $59, $04, $04, $0c, $59, $26, $68, $50, $01, $80, $20, $7e
    db $dc, $58

; C: script callback: Puzzle15_SetMapPtr
Puzzle15_ScriptSetMapPtr::
    push hl                                       ; $5068
    ld b, BANK(Puzzle15_SetMapPtr)                ; $5069
    ld hl, Puzzle15_SetMapPtr                     ; $506B
    call Far_Call                                 ; $506E
    pop hl                                        ; $5071
    scf                                           ; $5072
    ret                                           ; $5073


; C: read in the runs by ScriptSlots_Run, ScriptSlots_Add, ScriptCmd_SetE1; first read on the screen
; Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty*.npz)
Script_01_5074_Mode0F_FifteenPuzzle_State05::
    db $56, $50, $69, $59, $19, $59, $98, $1e, $59, $04, $04, $0c, $59, $26, $8a, $50
    db $e9, $58, $01, $00, $dc, $58

; C: script callback: Puzzle15_SetMapPtrPrev and the cell of Puzzle15_CellAddrPrev; runs on its screen in the core
; replays (port/entry_modes_kitty.csv)
Puzzle15_ScriptSetMapPtrPrev::
    push hl                                       ; $508A
    ld b, BANK(Puzzle15_SetMapPtrPrev)            ; $508B
    ld hl, Puzzle15_SetMapPtrPrev                 ; $508D
    call Far_Call                                 ; $5090
    ld b, BANK(Puzzle15_CellAddrPrev)             ; $5093
    ld hl, Puzzle15_CellAddrPrev                  ; $5095
    call Far_Call                                 ; $5098
    ld a, [hl]                                    ; $509B
    swap a                                        ; $509C
    ld c, a                                       ; $509E
    ld b, $00                                     ; $509F
    sla c                                         ; $50A1
    rl b                                          ; $50A3
    ld hl, $7c20                                  ; $50A5
    add hl, bc                                    ; $50A8
    ld a, l                                       ; $50A9
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFE6], a   ; $50AA
    ld a, h                                       ; $50AC
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFE7], a   ; $50AD
    ldh a, [hPuzzle15_ScriptSetMapPtrPrev_FFDB]   ; $50AF
    or $80                                        ; $50B1
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFDB], a   ; $50B3
    pop hl                                        ; $50B5
    scf                                           ; $50B6
    ret                                           ; $50B7


; C: read in the runs by Map_CopyRect, ScriptSlots_Run, ScriptSlots_Add; first read on the screen
; Mode0F_FifteenPuzzle_State0A (trace/read_screens_kitty*.npz); kind MAP from the evidence of
; tools/kitty_layout_kinds.py
Map_01_50B8_Mode0F_FifteenPuzzle_State0A::
    INCBIN "data/bank_01/Map_01_50B8_Mode0F_FifteenPuzzle_State0A.tilemap" ; $50B8, 82 bytes
; C: read in the runs by ScriptSlots_Run, ScriptCmd_JumpByByte, ScriptCmd_Jump; first read on the screen
; Mode0F_FifteenPuzzle_State0A (trace/read_screens_kitty*.npz)
Script_01_510A_Mode0F_FifteenPuzzle_State0A::
    db $5b, $51, $4a, $51, $39, $51, $28, $51, $17, $51, $fc, $58, $0f, $3c, $80, $bd
    db $50, $31, $52, $01, $59, $17, $51, $38, $52, $0f, $00, $fc, $58, $0f, $3c, $80
    db $be, $50, $31, $52, $01, $59, $28, $51, $38, $52, $0e, $00, $fc, $58, $0f, $3c
    db $80, $bf, $50, $31, $52, $01, $59, $39, $51, $38, $52, $0d, $00, $fc, $58, $0f
    db $3c, $80, $c0, $50, $31, $52, $01, $59, $4a, $51, $38, $52, $0c, $00, $fc, $58
    db $0f, $3c, $80, $c1, $50, $31, $52, $01, $59, $5b, $51

; I: leftover: 197 bytes (01:5165-5229) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_01_5165::
    db $38, $52, $0b, $00, $fc, $58, $0f, $3c, $80, $c2, $50, $31, $52, $01, $59, $6c
    db $51, $38, $52, $0a, $00, $fc, $58, $0f, $3c, $80, $c3, $50, $31, $52, $01, $59
    db $7d, $51, $38, $52, $09, $00, $fc, $58, $0f, $3c, $80, $c4, $50, $31, $52, $01
    db $59, $8e, $51, $38, $52, $08, $00, $fc, $58, $0f, $3c, $80, $c5, $50, $31, $52
    db $01, $59, $9f, $51, $38, $52, $07, $00, $fc, $58, $0f, $3c, $80, $c6, $50, $31
    db $52, $01, $59, $b0, $51, $38, $52, $06, $00, $fc, $58, $0f, $3c, $80, $c7, $50
    db $31, $52, $01, $59, $c1, $51, $38, $52, $05, $00, $fc, $58, $0f, $3c, $80, $c8
    db $50, $31, $52, $01, $59, $d2, $51, $38, $52, $04, $00, $fc, $58, $0f, $3c, $80
    db $c9, $50, $31, $52, $01, $59, $e3, $51, $38, $52, $03, $00, $fc, $58, $0f, $3c
    db $80, $ca, $50, $31, $52, $01, $59, $f4, $51, $38, $52, $02, $00, $fc, $58, $0f
    db $3c, $80, $cb, $50, $31, $52, $01, $59, $05, $52, $38, $52, $01, $00, $fc, $58
    db $0f, $3c, $80, $cc, $50, $31, $52, $01, $59, $16, $52, $38, $52, $00, $00, $01
    db $80, $cd, $50, $dc, $58

; C: script callback: hFFE9 = $D97B
Script_LoadCounterD97B::
    ld a, [wScript_LoadCounterD97B]               ; $522A
    ldh [hScriptCmd_Loop_FFE9], a                 ; $522D
    scf                                           ; $522F
    ret                                           ; $5230


; C: script callback: $D97B = hFFE9
Script_SaveCounterD97B::
    ldh a, [hScriptCmd_Loop_FFE9]                 ; $5231
    ld [wScript_LoadCounterD97B], a               ; $5233
    scf                                           ; $5236
    ret                                           ; $5237


; C: script callback: $D97C = next byte, skip one
Script_SetD97C::
    ld a, [hl+]                                   ; $5238
    ld [wScript_SetD97C], a                       ; $5239
    inc hl                                        ; $523C
    scf                                           ; $523D
    ret                                           ; $523E


; C: ret
Script_Nop523F::
    ret                                           ; $523F


; C: named by the code of Mode0F_State08 (07:5C65); read in the runs by ScriptSlots_Add; first read on the screen
; Mode0F_FifteenPuzzle_State0A (trace/read_screens_kitty*.npz)
Script_01_5240_Mode0F_FifteenPuzzle_State08::
    db $de, $50, $3f, $52

; C: script callback: $D8E0 = 0
Script_ClearD8E0::
    xor a                                         ; $5244
    ld [wMode07_StateTable_D8E0], a               ; $5245
    scf                                           ; $5248
    ret                                           ; $5249


; C: read in the runs by ScriptSlots_Run, ScriptCmd_SetE3, ScriptSlots_Add; first read on the screen
; Mode11_StrawberryChannel_State02 (trace/read_screens_kitty*.npz)
Script_01_524A_Mode11_StrawberryChannel_State02::
    INCBIN "data/bank_01/Script_01_524A_Mode11_StrawberryChannel_State02.bin" ; $524A, 490 bytes
; C: when $D8F4 differs from hFFEA: hFFEA = $D8F4 and the script 01:5443 is started (00:2263); runs on its screen in
; the core replays (port/entry_modes_kitty.csv)
Menu_ScriptOnItemChange::
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $5434
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5437
    cp [hl]                                       ; $543A
    ret z                                         ; $543B

    ld [hl], a                                    ; $543C
    ld de, Script_01_5443_Menu_ScriptOnItemChange ; $543D
    jp ScriptSlot_StartScript                     ; $5440


; C: named by the code of Menu_ScriptOnItemChange (01:543D); read in the runs by ScriptSlots_Run, ScriptCmd_SetE3,
; ScriptCmd_JumpByByte; first read on the screen Mode12_SlideShow_State01 (trace/read_screens_kitty*.npz)
Script_01_5443_Menu_ScriptOnItemChange::
    db $19, $59, $98, $1e, $59, $10, $03, $0c, $59, $25, $11, $59, $04, $00, $01, $80
    db $a0, $7b, $11, $59, $64, $00, $01, $80, $00, $7c, $11, $59, $64, $01, $01, $80
    db $60, $7c, $57, $59, $f4, $d8, $6f, $54, $7f, $54, $8f, $54, $11, $59, $04, $00
    db $08, $80, $d0, $7b, $18, $80, $a0, $7b, $f7, $58, $6f, $54, $11, $59, $64, $00
    db $08, $80, $30, $7c, $18, $80, $00, $7c, $f7, $58, $7f, $54, $11, $59, $64, $01
    db $08, $80, $90, $7c, $18, $80, $60, $7c, $f7, $58, $8f, $54, $43, $54, $34, $54

; C: script callback: $34 bytes of $A8 at $D810
NameCard_ScriptFillD810::
    push hl                                       ; $54A3
    ld de, $a8a8                                  ; $54A4
    ld hl, wMode14_State01_D810                   ; $54A7
    ld bc, $0034                                  ; $54AA
    call Mem_FillWord                             ; $54AD
    pop hl                                        ; $54B0
    scf                                           ; $54B1
    ret                                           ; $54B2


; C: script callback: $D800 + $20
NameCard_ScriptStepRight::
    ld a, [wDoodleFromShutterbug]                 ; $54B3
    add $20                                       ; $54B6
    ld [wDoodleFromShutterbug], a                 ; $54B8
    scf                                           ; $54BB
    ret                                           ; $54BC


; C: script callback: $D800 = $40, hFFEA-hFFEB from NameCard_LoadBackgroundTiles with $D934: start of a page turn;
; runs on its screen in the core replays (port/entry_modes_kitty.csv)
NameCard_ScriptStartRight::
    push hl                                       ; $54BD
    ld a, $40                                     ; $54BE
    ld [wDoodleFromShutterbug], a                 ; $54C0
    ld a, [wCardBackgroundSel]                    ; $54C3
    ld b, BANK(NameCard_LoadBackgroundTiles)      ; $54C6
    ld hl, NameCard_LoadBackgroundTiles           ; $54C8
    call Far_CallKeepA                            ; $54CB
    ld a, l                                       ; $54CE
    ldh [hRecordBook_GetReceivedX11_FFEA], a      ; $54CF
    ld a, h                                       ; $54D1
    ldh [hRecordBook_CountHundreds_FFEB], a       ; $54D2
    pop hl                                        ; $54D4
    scf                                           ; $54D5
    ret                                           ; $54D6


; C: script callback: $D800 + $20, then 00:0BBB with [$D800] + $A0 and the address in hFFEA; runs on its screen in the
; core replays (port/entry_modes_kitty.csv)
NameCard_ScriptDrawStep::
    push hl                                       ; $54D7
    ldh a, [hRecordBook_GetReceivedX11_FFEA]      ; $54D8
    ld l, a                                       ; $54DA
    ldh a, [hRecordBook_CountHundreds_FFEB]       ; $54DB
    ld h, a                                       ; $54DD
    ld a, [wDoodleFromShutterbug]                 ; $54DE
    add $20                                       ; $54E1
    ld [wDoodleFromShutterbug], a                 ; $54E3
    add $a0                                       ; $54E6
    call Map_CopyColumnToD810                     ; $54E8
    pop hl                                        ; $54EB
    scf                                           ; $54EC
    ret                                           ; $54ED


; C: script callback: $D800 = 0, ModeState_Set $0A / $01
NameCard_ScriptEndTurn::
    push hl                                       ; $54EE
    ld a, $00                                     ; $54EF
    ld [wDoodleFromShutterbug], a                 ; $54F1
    ld b, MODE_NAME_CARD                          ; $54F4
    ld c, STATE_0A_NAME_CARD_FINISHED_ID_CARD     ; $54F6
    call ModeState_Set                            ; $54F8
    pop hl                                        ; $54FB
    scf                                           ; $54FC
    ret                                           ; $54FD


; C: read in the runs by ScriptSlots_Run, ScriptCmd_SetE3, ScriptCmd_SetE1; first read on the screen
; Mode0A_NameCard_State03 (trace/read_screens_kitty*.npz)
Script_01_54FE_Mode0A_NameCard_State03::
    db $0c, $59, $00, $19, $59, $98, $1e, $59, $04, $0d, $a3, $54, $b3, $54, $11, $59
    db $20, $00, $01, $80, $10, $d8, $b3, $54, $11, $59, $24, $00, $01, $80, $10, $d8
    db $b3, $54, $11, $59, $28, $00, $01, $80, $10, $d8, $b3, $54, $11, $59, $2c, $00
    db $01, $80, $10, $d8, $b3, $54, $11, $59, $30, $00, $01, $80, $10, $d8, $bd, $54
    db $d7, $54, $11, $59, $20, $00, $01, $80, $10, $d8, $d7, $54, $11, $59, $24, $00
    db $01, $80, $10, $d8, $d7, $54, $11, $59, $28, $00, $01, $80, $10, $d8, $d7, $54
    db $11, $59, $2c, $00, $01, $80, $10, $d8, $d7, $54, $11, $59, $30, $00, $01, $80
    db $10, $d8, $b3, $54, $ee, $54, $dc, $58

; C: ret (code after it not traced)
NameCard_ScriptNop5576::
    ret                                           ; $5576


    db $fa, $d9, $d8, $cb, $47, $28, $0a, $06, $0a, $0e, $00, $cd, $c8, $01, $c3, $12
    db $22, $c9

; C: read in the runs by ScriptSlots_Add; first read on the screen Mode0A_NameCard_State03
; (trace/read_screens_kitty*.npz)
Script_01_5589_Mode0A_NameCard_State03::
    db $fe, $54, $76, $55

; C: the same as 01:54A3
NameCard_ScriptFillD810_B::
    push hl                                       ; $558D
    ld de, $a8a8                                  ; $558E
    ld hl, wMode14_State01_D810                   ; $5591
    ld bc, $0034                                  ; $5594
    call Mem_FillWord                             ; $5597
    pop hl                                        ; $559A
    scf                                           ; $559B
    ret                                           ; $559C


; C: script callback: $D800 - $20
NameCard_ScriptStepLeft::
    ld a, [wDoodleFromShutterbug]                 ; $559D
    sub $20                                       ; $55A0
    ld [wDoodleFromShutterbug], a                 ; $55A2
    scf                                           ; $55A5
    ret                                           ; $55A6


; C: as 01:54BD with $D800 = $C0; runs on its screen in the core replays (port/entry_modes_kitty.csv)
NameCard_ScriptStartLeft::
    push hl                                       ; $55A7
    ld a, $c0                                     ; $55A8
    ld [wDoodleFromShutterbug], a                 ; $55AA
    ld a, [wCardBackgroundSel]                    ; $55AD
    ld b, BANK(NameCard_LoadBackgroundTiles)      ; $55B0
    ld hl, NameCard_LoadBackgroundTiles           ; $55B2
    call Far_CallKeepA                            ; $55B5
    ld a, l                                       ; $55B8
    ldh [hRecordBook_GetReceivedX11_FFEA], a      ; $55B9
    ld a, h                                       ; $55BB
    ldh [hRecordBook_CountHundreds_FFEB], a       ; $55BC
    pop hl                                        ; $55BE
    scf                                           ; $55BF
    ret                                           ; $55C0


; C: as 01:54D7 subtracting; runs on its screen in the core replays (port/entry_modes_kitty.csv)
NameCard_ScriptDrawStepLeft::
    push hl                                       ; $55C1
    ldh a, [hRecordBook_GetReceivedX11_FFEA]      ; $55C2
    ld l, a                                       ; $55C4
    ldh a, [hRecordBook_CountHundreds_FFEB]       ; $55C5
    ld h, a                                       ; $55C7
    ld a, [wDoodleFromShutterbug]                 ; $55C8
    sub $20                                       ; $55CB
    ld [wDoodleFromShutterbug], a                 ; $55CD
    sub $20                                       ; $55D0
    call Map_CopyColumnToD810                     ; $55D2
    pop hl                                        ; $55D5
    scf                                           ; $55D6
    ret                                           ; $55D7


; C: the same as 01:54EE
NameCard_ScriptEndTurn_B::
    push hl                                       ; $55D8
    ld a, $00                                     ; $55D9
    ld [wDoodleFromShutterbug], a                 ; $55DB
    ld b, MODE_NAME_CARD                          ; $55DE
    ld c, STATE_0A_NAME_CARD_FINISHED_ID_CARD     ; $55E0
    call ModeState_Set                            ; $55E2
    pop hl                                        ; $55E5
    scf                                           ; $55E6
    ret                                           ; $55E7


; C: read in the runs by ScriptSlots_Run, ScriptCmd_SetE3, ScriptCmd_SetE1; first read on the screen
; Mode0A_NameCard_State03 (trace/read_screens_kitty*.npz)
Script_01_55E8_Mode0A_NameCard_State03::
    db $0c, $59, $00, $19, $59, $98, $1e, $59, $04, $0d, $8d, $55, $9d, $55, $11, $59
    db $30, $00, $01, $80, $10, $d8, $9d, $55, $11, $59, $2c, $00, $01, $80, $10, $d8
    db $9d, $55, $11, $59, $28, $00, $01, $80, $10, $d8, $9d, $55, $11, $59, $24, $00
    db $01, $80, $10, $d8, $9d, $55, $11, $59, $20, $00, $01, $80, $10, $d8, $a7, $55
    db $c1, $55, $11, $59, $30, $00, $01, $80, $10, $d8, $c1, $55, $11, $59, $2c, $00
    db $01, $80, $10, $d8, $c1, $55, $11, $59, $28, $00, $01, $80, $10, $d8, $c1, $55
    db $11, $59, $24, $00, $01, $80, $10, $d8, $c1, $55, $11, $59, $20, $00, $01, $80
    db $10, $d8, $9d, $55, $d8, $55, $dc, $58

; C: ret (code after it not traced)
NameCard_ScriptNop5660::
    ret                                           ; $5660


    db $fa, $d9, $d8, $cb, $47, $28, $0a, $06, $0a, $0e, $00, $cd, $c8, $01, $c3, $12
    db $22, $c9

; C: read in the runs by ScriptSlots_Add, Map_CopyRect; first read on the screen Mode0A_NameCard_State03
; (trace/read_screens_kitty*.npz)
Script_01_5673_Mode0A_NameCard_State03::
    db $e8, $55, $60, $56, $03, $02, $01

; C: per-frame routine of a vine slot: ends the slot (hFFDA-hFFDB = 0) when hFFEC reaches $14
RecordBook_VineFrame::
    ldh a, [hScriptCmd_AddEC_FFEC]                ; $567A
    cp $14                                        ; $567C
    jr nz, jr_001_5685                            ; $567E

    xor a                                         ; $5680
    ldh [hRecordBook_VineFrame_FFDA], a           ; $5681
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFDB], a   ; $5683

jr_001_5685:
    ret                                           ; $5685


; C: tail of the count routines: hFFE9 = A (the loop count), skips the jump word
RecordBook_CountSetLoop::
    ldh [hScriptCmd_Loop_FFE9], a                 ; $5686
    inc hl                                        ; $5688
    inc hl                                        ; $5689
    scf                                           ; $568A
    ret                                           ; $568B


; C: tail of the count routines: jumps to the word (none of this kind)
RecordBook_CountNone::
    ld a, [hl+]                                   ; $568C
    ld h, [hl]                                    ; $568D
    ld l, a                                       ; $568E
    scf                                           ; $568F
    ret                                           ; $5690


; C: flowers of the first kind: the hundreds of the 4-digit BCD count in hFFEA-EB, 0-19, 20 from 2,000 on; 0 skips the
; kind
RecordBook_CountHundreds::
    ldh a, [hRecordBook_CountHundreds_FFEB]       ; $5691
    and a                                         ; $5693
    jp z, RecordBook_CountNone                    ; $5694

    cp $20                                        ; $5697
    jr c, jr_001_569f                             ; $5699

    ld a, $14                                     ; $569B
    jr RecordBook_CountSetLoop                    ; $569D

jr_001_569f:
    and $f0                                       ; $569F
    jr nz, jr_001_56a9                            ; $56A1

    ldh a, [hRecordBook_CountHundreds_FFEB]       ; $56A3
    and $0f                                       ; $56A5
    jr RecordBook_CountSetLoop                    ; $56A7

jr_001_56a9:
    ldh a, [hRecordBook_CountHundreds_FFEB]       ; $56A9
    and $0f                                       ; $56AB
    add $0a                                       ; $56AD
    jr RecordBook_CountSetLoop                    ; $56AF

; C: flowers of the second kind: the tens digit of hFFEA
RecordBook_CountTens::
    ldh a, [hRecordBook_GetReceivedX11_FFEA]      ; $56B1
    swap a                                        ; $56B3
    and $0f                                       ; $56B5
    jp z, RecordBook_CountNone                    ; $56B7

    jp nz, RecordBook_CountSetLoop                ; $56BA

; C: flowers of the third kind: the units digit of hFFEA
RecordBook_CountUnits::
    ldh a, [hRecordBook_GetReceivedX11_FFEA]      ; $56BD
    and $0f                                       ; $56BF
    jp z, RecordBook_CountNone                    ; $56C1

    jp nz, RecordBook_CountSetLoop                ; $56C4

; C: slot script shared by the 5 vines: waits, then grows the hundreds, tens and units flowers one by one
RecordBook_FlowerScript::
    db $0c, $59, $01, $19, $59, $98, $1e, $59, $01, $01, $e9, $58, $3c, $00, $91, $56
    db $ec, $56, $3a, $59, $01, $b2, $58, $29, $00, $20, $80, $77, $56, $42, $59, $ff
    db $ff, $01, $59, $d9, $56, $b1, $56, $03, $57

    db $3a, $59, $01, $b2, $58, $29, $00, $20, $80, $78, $56, $42, $59, $ff, $ff, $01
    db $59, $f0, $56

; C: read in the runs by ScriptSlots_Run, RecordBook_CountNone, ScriptCmd_Sound; first read on the screen
; Mode0C_RecordBook_State01 (trace/read_screens_kitty*.npz)
Script_01_5703_Mode0C_RecordBook_State01::
    db $bd, $56, $1a, $57, $3a, $59, $01, $b2, $58, $29, $00, $20, $80, $79, $56, $42
    db $59, $ff, $ff, $01, $59, $07, $57, $dc, $58

; C: hFFEA-EB = photos taken ($DAC9-DACA = SRAM $1000-$1001)
RecordBook_GetTaken::
    ld a, [wCountTaken]                           ; $571C
    ldh [hRecordBook_GetReceivedX11_FFEA], a      ; $571F
    ld a, [wCountTaken + $1]                      ; $5721
    ldh [hRecordBook_CountHundreds_FFEB], a       ; $5724
    scf                                           ; $5726
    ret                                           ; $5727


; C: vine script of the taken counter (descriptor at 01:5732)
RecordBook_VineTaken::
    db $1c, $57, $11, $59, $73, $00, $f7, $58, $c7, $56, $28, $57, $7a, $56

; C: hFFEA-EB = photos thrown away ($DACB-DACC = SRAM $1002-$1003)
RecordBook_GetErased::
    ld a, [wCountErased]                          ; $5736
    ldh [hRecordBook_GetReceivedX11_FFEA], a      ; $5739
    ld a, [wCountErased + $1]                     ; $573B
    ldh [hRecordBook_CountHundreds_FFEB], a       ; $573E
    scf                                           ; $5740
    ret                                           ; $5741


; C: vine script of the thrown-away counter (descriptor at 01:574C)
RecordBook_VineErased::
    db $36, $57, $11, $59, $d3, $00, $f7, $58, $c7, $56, $42, $57, $7a, $56

; C: hFFEA-EB += 11 x photos exchanged ($DACD-DACE, BCD adds through $0CB4); BGB: 1 exchange shows 2 flowers (1 ten, 1
; unit)
RecordBook_GetExchangedX11::
    push hl                                       ; $5750
    ld a, [wCountExchanged]                       ; $5751
    ld e, a                                       ; $5754
    ld a, [wCountExchanged + $1]                  ; $5755
    ld d, a                                       ; $5758
    ld b, $0b                                     ; $5759
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $575B
    ld c, $02                                     ; $575E

jr_001_5760:
    push bc                                       ; $5760
    push de                                       ; $5761
    push hl                                       ; $5762
    call Bcd_Add                                  ; $5763
    pop hl                                        ; $5766
    pop de                                        ; $5767
    pop bc                                        ; $5768
    dec b                                         ; $5769
    jr nz, jr_001_5760                            ; $576A

    pop hl                                        ; $576C
    scf                                           ; $576D
    ret                                           ; $576E


; C: vine script of the exchanged counter (descriptor at 01:5779)
RecordBook_VineExchanged::
    db $50, $57, $11, $59, $33, $01, $f7, $58, $c7, $56, $6f, $57, $7a, $56

; C: hFFEA-EB = 11 x (boys $DAD1 + girls $DAD2 received); BGB: 1 received shows 2 flowers
RecordBook_GetReceivedX11::
    push hl                                       ; $577D
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $577E
    ld a, [wCountReceivedGirl]                    ; $5781
    ld [hl+], a                                   ; $5784
    xor a                                         ; $5785
    ld [hl+], a                                   ; $5786
    ld a, [wCountReceivedBoy]                     ; $5787
    ld e, a                                       ; $578A
    ld d, $00                                     ; $578B
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $578D
    ld c, $02                                     ; $5790
    call Bcd_Add                                  ; $5792
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $5795
    ld e, [hl]                                    ; $5798
    inc hl                                        ; $5799
    ld d, [hl]                                    ; $579A
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $579B
    xor a                                         ; $579E
    ld [hl+], a                                   ; $579F
    ld [hl+], a                                   ; $57A0
    ld b, $0b                                     ; $57A1
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $57A3
    ld c, $02                                     ; $57A6

jr_001_57a8:
    push bc                                       ; $57A8
    push de                                       ; $57A9
    push hl                                       ; $57AA
    call Bcd_Add                                  ; $57AB
    pop hl                                        ; $57AE
    pop de                                        ; $57AF
    pop bc                                        ; $57B0
    dec b                                         ; $57B1
    jr nz, jr_001_57a8                            ; $57B2

    pop hl                                        ; $57B4
    scf                                           ; $57B5
    ret                                           ; $57B6


; C: vine script of the received counter (descriptor at 01:57C1)
RecordBook_VineReceived::
    db $7d, $57, $11, $59, $93, $01, $f7, $58, $c7, $56, $b7, $57, $7a, $56

; C: hFFEA-EB += 6 x photos printed ($DACF-DAD0); BGB: 1 print shows 6 flowers
RecordBook_GetPrintedX6::
    push hl                                       ; $57C5
    ld a, [wCountPrinted]                         ; $57C6
    ld e, a                                       ; $57C9
    ld a, [wCountPrinted + $1]                    ; $57CA
    ld d, a                                       ; $57CD
    ld b, $06                                     ; $57CE
    ld hl, hRecordBook_GetReceivedX11_FFEA        ; $57D0
    ld c, $02                                     ; $57D3

jr_001_57d5:
    push bc                                       ; $57D5
    push de                                       ; $57D6
    push hl                                       ; $57D7
    call Bcd_Add                                  ; $57D8
    pop hl                                        ; $57DB
    pop de                                        ; $57DC
    pop bc                                        ; $57DD
    dec b                                         ; $57DE
    jr nz, jr_001_57d5                            ; $57DF

    pop hl                                        ; $57E1
    scf                                           ; $57E2
    ret                                           ; $57E3


; C: vine script of the printed counter (descriptor at 01:57EE)
RecordBook_VinePrinted::
    db $c5, $57, $11, $59, $f3, $01, $f7, $58, $c7, $56, $e4, $57, $7a, $56, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe

; C: $D8E0 = $FF
ScriptCmd_SetD8E0FF::
    ld a, $ff                                     ; $5802
    ld [wMode07_StateTable_D8E0], a               ; $5804
    scf                                           ; $5807
    ret                                           ; $5808


; C: hFFE3-hFFE4 + the next word
ScriptCmd_AddE3::
    ld a, [hl+]                                   ; $5809
    ld e, a                                       ; $580A
    ld a, [hl+]                                   ; $580B
    ld d, a                                       ; $580C
    push hl                                       ; $580D
    ld hl, hScriptCmd_AddE3_FFE3                  ; $580E
    ld a, [hl+]                                   ; $5811
    ld h, [hl]                                    ; $5812
    ld l, a                                       ; $5813
    add hl, de                                    ; $5814
    ld a, l                                       ; $5815
    ldh [hScriptCmd_AddE3_FFE3], a                ; $5816
    ld a, h                                       ; $5818
    ldh [hScriptCmd_AddE3_B_FFE4], a              ; $5819
    pop hl                                        ; $581B
    scf                                           ; $581C
    ret                                           ; $581D


; C: read in the runs by ScriptSlots_Run, ScriptSlots_Add, ScriptCmd_SetE1; first read on the screen
; Mode03_ViewAlbum_State0F (trace/read_screens_kitty*.npz)
Script_01_581E_Mode03_ViewAlbum_State0F::
    db $0c, $59, $01, $19, $59, $98, $1e, $59, $10, $01, $11, $59, $84, $00, $fc, $58
    db $0e, $02, $80, $f2, $57, $09, $58, $20, $00, $01, $59, $2f, $58, $02, $58, $dc
    db $58, $1e, $58, $69, $59, $0c, $59, $01, $19, $59, $98, $1e, $59, $10, $01, $11
    db $59, $24, $02, $fc, $58, $0e, $02, $80, $f2, $57, $09, $58, $e0, $ff, $01, $59
    db $54, $58, $02, $58, $dc, $58, $43, $58, $69, $59, $0c, $59, $01, $19, $59, $98
    db $1e, $59, $01, $0e, $11, $59, $84, $00, $fc, $58, $10, $02, $80, $f2, $57, $09
    db $58, $01, $00, $01, $59, $79, $58, $02, $58, $dc, $58, $68, $58, $69, $59, $0c
    db $59, $01, $19, $59, $98, $1e, $59, $01, $0e, $11, $59, $93, $00, $fc, $58, $10
    db $02, $80, $f2, $57, $09, $58, $ff, $ff, $01, $59, $9e, $58, $02, $58, $dc, $58
    db $8d, $58, $69, $59

; C: {id, channel 0-3}: the sound id into $D060 / $D068 / $D070 / $D078
ScriptCmd_Sound::
    push hl                                       ; $58B2
    ld a, [hl+]                                   ; $58B3
    push af                                       ; $58B4
    ld a, [hl]                                    ; $58B5
    call JumpTable_Inline                         ; $58B6

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0C_RecordBook_State01
; (trace/read_screens_kitty*.npz)
ScriptCmd_Sound_JumpTbl58B9::
    dw ScriptCmd_SoundCh0
    dw ScriptCmd_SoundCh1
    dw ScriptCmd_SoundCh2
    dw ScriptCmd_SoundCh3

; C: channel 0 of ScriptCmd_Sound: $D060
ScriptCmd_SoundCh0::
    pop af                                        ; $58C1
    ld [wSndSfx1], a                              ; $58C2
    jr jr_001_58d7                                ; $58C5

; C: channel 1 of ScriptCmd_Sound: $D068
ScriptCmd_SoundCh1::
    pop af                                        ; $58C7
    ld [wSndMusicReq], a                          ; $58C8
    jr jr_001_58d7                                ; $58CB

; C: channel 2 of ScriptCmd_Sound: $D070
ScriptCmd_SoundCh2::
    pop af                                        ; $58CD
    ld [wSndSfx3], a                              ; $58CE
    jr jr_001_58d7                                ; $58D1

; C: channel 3 of ScriptCmd_Sound: $D078
ScriptCmd_SoundCh3::
    pop af                                        ; $58D3
    ld [wSndSfx4], a                              ; $58D4

jr_001_58d7:
    pop hl                                        ; $58D7
    inc hl                                        ; $58D8
    inc hl                                        ; $58D9
    scf                                           ; $58DA
    ret                                           ; $58DB


; C: hFFDA-hFFDB = 0 (the slot is free), stops
ScriptCmd_End::
    xor a                                         ; $58DC
    ldh [hRecordBook_VineFrame_FFDA], a           ; $58DD
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFDB], a   ; $58DF
    and a                                         ; $58E1
    ret                                           ; $58E2


    db $2b, $2b, $0e, $7f, $a7, $c9

; C: BC = the next word (frames to wait), stops for this frame
ScriptCmd_Wait::
    ld a, [hl+]                                   ; $58E9
    ld c, a                                       ; $58EA
    ld a, [hl+]                                   ; $58EB
    ld b, a                                       ; $58EC
    and a                                         ; $58ED
    ret                                           ; $58EE


    db $2a, $e0, $de, $2a, $e0, $df, $37, $c9

; C: HL = the next word
ScriptCmd_Jump::
    ld a, [hl+]                                   ; $58F7
    ld h, [hl]                                    ; $58F8
    ld l, a                                       ; $58F9
    scf                                           ; $58FA
    ret                                           ; $58FB


; C: hFFE9 = the next byte
ScriptCmd_SetLoop::
    ld a, [hl+]                                   ; $58FC
    ldh [hScriptCmd_Loop_FFE9], a                 ; $58FD
    scf                                           ; $58FF
    ret                                           ; $5900


; C: hFFE9 - 1; jumps to the next word while not 0
ScriptCmd_Loop::
    ldh a, [hScriptCmd_Loop_FFE9]                 ; $5901
    dec a                                         ; $5903
    ldh [hScriptCmd_Loop_FFE9], a                 ; $5904
    jr nz, ScriptCmd_Jump                         ; $5906

    inc hl                                        ; $5908
    inc hl                                        ; $5909
    scf                                           ; $590A
    ret                                           ; $590B


; C: hFFE8 = the next byte
ScriptCmd_SetE8::
    ld a, [hl+]                                   ; $590C
    ldh [hScriptCmd_SetE8_FFE8], a                ; $590D
    scf                                           ; $590F
    ret                                           ; $5910


; C: hFFE3-hFFE4 = the next word
ScriptCmd_SetE3::
    ld a, [hl+]                                   ; $5911
    ldh [hScriptCmd_AddE3_FFE3], a                ; $5912
    ld a, [hl+]                                   ; $5914
    ldh [hScriptCmd_AddE3_B_FFE4], a              ; $5915
    scf                                           ; $5917
    ret                                           ; $5918


; C: hFFE5 = the next byte
ScriptCmd_SetE5::
    ld a, [hl+]                                   ; $5919
    ldh [hScriptCmd_SetE5_FFE5], a                ; $591A
    scf                                           ; $591C
    ret                                           ; $591D


; C: hFFE1-hFFE2 = the next word
ScriptCmd_SetE1::
    ld a, [hl+]                                   ; $591E
    ldh [hScriptSlot_StartScript_FFE1], a         ; $591F
    ld a, [hl+]                                   ; $5921
    ldh [hScriptCmd_SetE1_FFE2], a                ; $5922
    scf                                           ; $5924
    ret                                           ; $5925


    db $2a, $e0, $ea, $37, $c9, $2a, $e0, $eb, $37, $c9, $2a, $e0, $ec, $37, $c9, $2a
    db $e0, $ed, $37, $c9

; C: hFFEC + the next byte
ScriptCmd_AddEC::
    ldh a, [hScriptCmd_AddEC_FFEC]                ; $593A
    add [hl]                                      ; $593C
    ldh [hScriptCmd_AddEC_FFEC], a                ; $593D
    inc hl                                        ; $593F
    scf                                           ; $5940
    ret                                           ; $5941


; C: hFFE3-hFFE4 + the next word (as 01:5809)
ScriptCmd_AddE3_B::
    ld a, [hl+]                                   ; $5942
    ld c, a                                       ; $5943
    ld a, [hl+]                                   ; $5944
    ld b, a                                       ; $5945
    push hl                                       ; $5946
    ldh a, [hScriptCmd_AddE3_FFE3]                ; $5947
    ld l, a                                       ; $5949
    ldh a, [hScriptCmd_AddE3_B_FFE4]              ; $594A
    ld h, a                                       ; $594C
    add hl, bc                                    ; $594D
    ld a, l                                       ; $594E
    ldh [hScriptCmd_AddE3_FFE3], a                ; $594F
    ld a, h                                       ; $5951
    ldh [hScriptCmd_AddE3_B_FFE4], a              ; $5952
    pop hl                                        ; $5954
    scf                                           ; $5955
    ret                                           ; $5956


; C: reads the byte at the address of the next word and jumps through the word table that follows
ScriptCmd_JumpByByte::
    ld a, [hl+]                                   ; $5957
    ld e, a                                       ; $5958
    ld a, [hl+]                                   ; $5959
    ld d, a                                       ; $595A
    ld a, [de]                                    ; $595B
    push hl                                       ; $595C
    sla a                                         ; $595D
    ld c, a                                       ; $595F
    ld b, $00                                     ; $5960
    pop hl                                        ; $5962
    add hl, bc                                    ; $5963
    ld a, [hl+]                                   ; $5964
    ld h, [hl]                                    ; $5965
    ld l, a                                       ; $5966
    scf                                           ; $5967
    ret                                           ; $5968


; C: ret
ScriptCmd_Ret5969::
    ret                                           ; $5969


    db $dc, $58

; C: empties the 6 script slots of 20 bytes at $DC67 (the record book calls it on entry: BGB writes 01:5975/5976 at
; every visit)
ScriptSlots_Clear::
    ld hl, wScriptSlots_Tick_DC67                 ; $596C
    ld b, $06                                     ; $596F
    xor a                                         ; $5971
    ld de, $0012                                  ; $5972

jr_001_5975:
    ld [hl+], a                                   ; $5975
    ld [hl+], a                                   ; $5976
    add hl, de                                    ; $5977
    dec b                                         ; $5978
    jr nz, jr_001_5975                            ; $5979

    jp Far_Return                                 ; $597B


; C: DE = {script; per-frame routine}: fills the first free slot of $DC67, script pointer at offsets 2-3
ScriptSlots_Add::
    push de                                       ; $597E
    ld de, $0014                                  ; $597F
    ld hl, wScriptSlots_Tick_DC67                 ; $5982
    ld b, $06                                     ; $5985

jr_001_5987:
    inc hl                                        ; $5987
    ld a, [hl-]                                   ; $5988
    cp $80                                        ; $5989
    jr z, jr_001_5990                             ; $598B

    or [hl]                                       ; $598D
    jr z, jr_001_5998                             ; $598E

jr_001_5990:
    add hl, de                                    ; $5990
    dec b                                         ; $5991
    jr nz, jr_001_5987                            ; $5992

    pop de                                        ; $5994
    jp Far_Return                                 ; $5995


jr_001_5998:
    pop de                                        ; $5998
    push de                                       ; $5999
    push hl                                       ; $599A
    xor a                                         ; $599B
    ld [hl+], a                                   ; $599C
    ld a, $80                                     ; $599D
    ld [hl+], a                                   ; $599F
    ld a, [de]                                    ; $59A0
    ld [hl+], a                                   ; $59A1
    inc de                                        ; $59A2
    ld a, [de]                                    ; $59A3
    ld [hl+], a                                   ; $59A4
    inc de                                        ; $59A5
    ld a, [de]                                    ; $59A6
    ld [hl+], a                                   ; $59A7
    inc de                                        ; $59A8
    ld a, [de]                                    ; $59A9
    ld [hl+], a                                   ; $59AA
    inc de                                        ; $59AB
    ld a, $01                                     ; $59AC
    ld [hl+], a                                   ; $59AE
    xor a                                         ; $59AF
    ld [hl+], a                                   ; $59B0
    ld [hl+], a                                   ; $59B1
    ld [hl+], a                                   ; $59B2
    ld [hl+], a                                   ; $59B3
    ld [hl+], a                                   ; $59B4
    ld [hl+], a                                   ; $59B5
    ld [hl+], a                                   ; $59B6
    ld [hl+], a                                   ; $59B7
    ld [hl+], a                                   ; $59B8
    ld [hl+], a                                   ; $59B9
    ld [hl+], a                                   ; $59BA
    ld [hl+], a                                   ; $59BB
    ld [hl+], a                                   ; $59BC
    pop hl                                        ; $59BD
    pop de                                        ; $59BE
    ld a, e                                       ; $59BF
    ld [hl+], a                                   ; $59C0
    ld a, d                                       ; $59C1
    ld [hl+], a                                   ; $59C2
    jp Far_Return                                 ; $59C3


; C: runs one step of each busy slot of $DC67 (far called from banks 0 and 7)
ScriptSlots_Run::
    ld hl, wScriptSlots_Tick_DC67                 ; $59C6
    ld b, $06                                     ; $59C9

jr_001_59cb:
    push bc                                       ; $59CB
    push hl                                       ; $59CC
    ld a, l                                       ; $59CD
    ld [wScriptSlots_Run_DCDF], a                 ; $59CE
    ld a, h                                       ; $59D1
    ld [wScriptSlots_Run_DCE0], a                 ; $59D2
    inc hl                                        ; $59D5
    ld a, [hl-]                                   ; $59D6
    cp $80                                        ; $59D7
    jr z, jr_001_5a1f                             ; $59D9

    or [hl]                                       ; $59DB
    jr z, jr_001_5a1f                             ; $59DC

    call ScriptSlot_LoadToHram                    ; $59DE
    ldh a, [hScriptSlots_Run_FFDE]                ; $59E1
    ld l, a                                       ; $59E3
    ldh a, [hScriptSlots_Run_FFDF]                ; $59E4
    ld h, a                                       ; $59E6
    call Call_HL                                  ; $59E7
    ldh a, [hScriptSlots_Run_FFE0]                ; $59EA
    ld c, a                                       ; $59EC
    dec c                                         ; $59ED
    jr nz, jr_001_5a17                            ; $59EE

    ldh a, [hScriptSlots_Run_FFDC]                ; $59F0
    ld l, a                                       ; $59F2
    ldh a, [hScriptSlots_Run_FFDD]                ; $59F3
    ld h, a                                       ; $59F5

jr_001_59f6:
    ld a, [hl+]                                   ; $59F6
    ld c, a                                       ; $59F7
    ld a, [hl+]                                   ; $59F8
    bit 7, a                                      ; $59F9
    jr nz, jr_001_5a05                            ; $59FB

    ld b, a                                       ; $59FD
    call Call_BC                                  ; $59FE
    jr c, jr_001_59f6                             ; $5A01

    jr nc, jr_001_5a11                            ; $5A03

jr_001_5a05:
    ldh a, [hPuzzle15_ScriptSetMapPtrPrev_FFDB]   ; $5A05
    or $80                                        ; $5A07
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFDB], a   ; $5A09
    ld a, [hl+]                                   ; $5A0B
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFE6], a   ; $5A0C
    ld a, [hl+]                                   ; $5A0E
    ldh [hPuzzle15_ScriptSetMapPtrPrev_FFE7], a   ; $5A0F

jr_001_5a11:
    ld a, l                                       ; $5A11
    ldh [hScriptSlots_Run_FFDC], a                ; $5A12
    ld a, h                                       ; $5A14
    ldh [hScriptSlots_Run_FFDD], a                ; $5A15

jr_001_5a17:
    ld a, c                                       ; $5A17
    ldh [hScriptSlots_Run_FFE0], a                ; $5A18
    pop hl                                        ; $5A1A
    push hl                                       ; $5A1B
    call ScriptSlot_SaveFromHram                  ; $5A1C

jr_001_5a1f:
    pop hl                                        ; $5A1F
    ld de, $0014                                  ; $5A20
    add hl, de                                    ; $5A23
    pop bc                                        ; $5A24
    dec b                                         ; $5A25
    jr nz, jr_001_59cb                            ; $5A26

    jp Far_Return                                 ; $5A28


; C: 20 bytes at HL into hFFDA-hFFED
ScriptSlot_LoadToHram::
    ld b, $14                                     ; $5A2B
    ld c, $da                                     ; $5A2D

jr_001_5a2f:
    ld a, [hl+]                                   ; $5A2F
    ldh [c], a                                    ; $5A30
    inc c                                         ; $5A31
    dec b                                         ; $5A32
    jr nz, jr_001_5a2f                            ; $5A33

    ret                                           ; $5A35


; C: hFFDA-hFFED into the 20 bytes at HL
ScriptSlot_SaveFromHram::
    ld b, $14                                     ; $5A36
    ld c, $da                                     ; $5A38

jr_001_5a3a:
    ldh a, [c]                                    ; $5A3A
    ld [hl+], a                                   ; $5A3B
    inc c                                         ; $5A3C
    dec b                                         ; $5A3D
    jr nz, jr_001_5a3a                            ; $5A3E

    ret                                           ; $5A40


    ; padding
    ds $5bf, $00

    db $9a, $22, $01, $a9, $00, $9a, $23, $01, $aa, $00, $9a, $24, $01, $aa, $00, $9a
    db $25, $01, $aa, $00, $9a, $26, $01, $aa, $00, $9a, $27, $01, $aa, $00, $9a, $28
    db $01, $aa, $00, $9a, $29, $01, $aa, $00, $9a, $2a, $01, $aa, $00, $9a, $2b, $01
    db $aa, $00, $9a, $2c, $01, $aa, $00, $9a, $2d, $01, $aa, $00, $9a, $2e, $01, $aa
    db $00, $9a, $2f, $01, $aa, $00, $9a, $30, $01, $aa, $00, $9a, $31, $01, $ab, $00

; C: read in the runs by Mode1D_CopyDescriptors, Mode06_State1B; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty*.npz)
Mode1D_CopyDescriptors_Tbl6050::
    INCBIN "data/bank_01/Mode1D_CopyDescriptors_Tbl6050.bin" ; $6050, 1924 bytes
; C: A as two BCD digits (00:0C9A) with the 8x8 digits of 0C:7C40 at DE (HBlank copy)
Number_DrawTwoDigits::
    push de                                       ; $67D4
    call Bin_ToBcd                                ; $67D5
    pop hl                                        ; $67D8
    push bc                                       ; $67D9
    ld a, b                                       ; $67DA
    and $0f                                       ; $67DB
    call Number_DrawDigit                         ; $67DD
    pop bc                                        ; $67E0
    push bc                                       ; $67E1
    ld a, c                                       ; $67E2
    swap a                                        ; $67E3
    and $0f                                       ; $67E5
    call Number_DrawDigit                         ; $67E7
    pop bc                                        ; $67EA
    push bc                                       ; $67EB
    ld a, c                                       ; $67EC
    and $0f                                       ; $67ED
    call Number_DrawDigit                         ; $67EF
    pop bc                                        ; $67F2
    jp Far_Return                                 ; $67F3


; C: digit A of 0C:7C40 into HL
Number_DrawDigit::
    push hl                                       ; $67F6
    ld c, a                                       ; $67F7
    swap c                                        ; $67F8
    ld b, $00                                     ; $67FA
    ld hl, Gfx_0C_7C40_Mode0A_NameCard_State01    ; $67FC
    add hl, bc                                    ; $67FF
    ld e, l                                       ; $6800
    ld d, h                                       ; $6801
    pop hl                                        ; $6802
    ld bc, $0010                                  ; $6803
    ld a, $0c                                     ; $6806
    call Vram_CopyHBlankFar                       ; $6808
    ret                                           ; $680B


; C: [$D94F], the apples caught in the printing game, as three tall digits (hundreds / tens / units) of 0C:7E40 into
; $8400; runs in mode $06 state $23, when the game starts while the printer works (BGB 2026-11-08, print with the
; printer helper on the link); state $23 also draws [$D94F] and [$DAD8] with ...
PrintGame_DrawAppleCount::
    ld a, [wMode06_State23_D94F]                  ; $680C
    call Bin_ToBcd                                ; $680F
    ld hl, $8400                                  ; $6812
    push bc                                       ; $6815
    ld a, b                                       ; $6816
    and $0f                                       ; $6817
    call Number_DrawTallDigit                     ; $6819
    pop bc                                        ; $681C
    push bc                                       ; $681D
    ld a, c                                       ; $681E
    swap a                                        ; $681F
    and $0f                                       ; $6821
    call Number_DrawTallDigit                     ; $6823
    pop bc                                        ; $6826
    push bc                                       ; $6827
    ld a, c                                       ; $6828
    and $0f                                       ; $6829
    call Number_DrawTallDigit                     ; $682B
    pop bc                                        ; $682E
    jp Far_Return                                 ; $682F


; C: tall digit A of 0C:7E40 into HL
Number_DrawTallDigit::
    push hl                                       ; $6832
    ld c, a                                       ; $6833
    ld b, $00                                     ; $6834
    swap c                                        ; $6836
    sla c                                         ; $6838
    rl b                                          ; $683A
    ld hl, Gfx_0C_7E20_Mode06_Printing_State24 + $20 ; $683C
    add hl, bc                                    ; $683F
    ld e, l                                       ; $6840
    ld d, h                                       ; $6841
    pop hl                                        ; $6842
    ld bc, $0020                                  ; $6843
    ld a, $0c                                     ; $6846
    call Vram_CopyHBlankFar                       ; $6848
    ret                                           ; $684B


; C: the 3-byte record [$D935] of 01:687D into $D386 / $D38A (the records read by TakePhotos_DrawRows*); runs on its
; screen in the core replays (port/entry_modes_kitty.csv)
PrintFrame_Select::
    ld a, [wPrintFrame_Next_D935]                 ; $684C
    ld c, a                                       ; $684F
    sla a                                         ; $6850
    add c                                         ; $6852
    ld c, a                                       ; $6853
    ld b, $00                                     ; $6854
    ld hl, PrintFrame_Select_Tbl687D              ; $6856
    add hl, bc                                    ; $6859
    ld a, [hl+]                                   ; $685A
    ld [wPrintSrcTable + $4], a                   ; $685B
    ld [wPrintSrcTable + $4], a                   ; $685E
    ld [wPrintSrcTable + $8], a                   ; $6861
    ld a, [hl+]                                   ; $6864
    ld [wPrintSrcTable + $5], a                   ; $6865
    add $08                                       ; $6868
    ld [wPrintSrcTable + $9], a                   ; $686A
    add $08                                       ; $686D
    ld [wPrintSrcTable + $d], a                   ; $686F
    ld a, [hl]                                    ; $6872
    ld [wPrintSrcTable + $6], a                   ; $6873
    ld [wPrintSrcTable + $a], a                   ; $6876
    ld [wPrintSrcTable + $e], a                   ; $6879
    ret                                           ; $687C


; C: named by the code of PrintFrame_Select, PrintFrame_LoadTiles, PrintFrame_LoadPart (01:6856 01:6896 01:68D5); read
; in the runs by PrintFrame_LoadTiles; first read on the screen Mode06_Printing_State07
; (trace/read_screens_kitty*.npz)
PrintFrame_Select_Tbl687D::
    dwb Frame_1B_4000_Mode06_Printing_State02
    dwb Frame_1A_4000_Mode06_Printing_State07
    dwb Frame_1A_5800_Mode06_Printing_State07
    dwb Frame_19_5800_Mode06_Printing_State07
    dwb Frame_19_4000_Mode06_Printing_State07
    dwb Frame_18_4000_Mode06_Printing_State07

; C: tiles of the record A of 01:687D into $9000; runs on its screen in the core replays (port/entry_modes_kitty.csv)
PrintFrame_LoadTiles::
    ld c, a                                       ; $688F
    sla a                                         ; $6890
    add c                                         ; $6892
    ld c, a                                       ; $6893
    ld b, $00                                     ; $6894
    ld hl, PrintFrame_Select_Tbl687D              ; $6896
    add hl, bc                                    ; $6899
    ld a, [hl+]                                   ; $689A
    ld e, a                                       ; $689B
    ld a, [hl+]                                   ; $689C
    ld d, a                                       ; $689D
    ld a, [hl+]                                   ; $689E
    push af                                       ; $689F
    ld hl, $9000                                  ; $68A0
    ld bc, $03c0                                  ; $68A3
    call Vram_CopyHBlankFar                       ; $68A6
    pop af                                        ; $68A9
    push af                                       ; $68AA
    ld hl, $8a00                                  ; $68AB
    ld bc, $0280                                  ; $68AE
    call Vram_CopyHBlankFar                       ; $68B1
    pop af                                        ; $68B4
    push af                                       ; $68B5
    ld hl, $8c80                                  ; $68B6
    ld bc, $0280                                  ; $68B9
    call Vram_CopyHBlankFar                       ; $68BC
    pop af                                        ; $68BF
    push af                                       ; $68C0
    ld hl, $8000                                  ; $68C1
    ld bc, $08c0                                  ; $68C4
    call Vram_CopyHBlankFar                       ; $68C7
    pop af                                        ; $68CA
    jp Far_Return                                 ; $68CB


; C: the record A of 01:687D + $3C0; runs on its screen in the core replays (port/entry_modes_kitty.csv)
PrintFrame_LoadPart::
    ld c, a                                       ; $68CE
    sla a                                         ; $68CF
    add c                                         ; $68D1
    ld c, a                                       ; $68D2
    ld b, $00                                     ; $68D3
    ld hl, PrintFrame_Select_Tbl687D              ; $68D5
    add hl, bc                                    ; $68D8
    ld a, [hl+]                                   ; $68D9
    ld e, a                                       ; $68DA
    ld a, [hl+]                                   ; $68DB
    ld d, a                                       ; $68DC
    ld a, [hl+]                                   ; $68DD
    ld hl, $03c0                                  ; $68DE
    add hl, de                                    ; $68E1
    ld e, l                                       ; $68E2
    ld d, h                                       ; $68E3
    push af                                       ; $68E4
    ld hl, $8a00                                  ; $68E5
    ld bc, $0280                                  ; $68E8
    call Vram_CopyHBlankFar                       ; $68EB
    pop af                                        ; $68EE
    push af                                       ; $68EF
    ld hl, $8c80                                  ; $68F0
    ld bc, $0280                                  ; $68F3
    call Vram_CopyHBlankFar                       ; $68F6
    pop af                                        ; $68F9
    jp Far_Return                                 ; $68FA


Jump_001_68fd:
    call Prn_EngineStop                           ; $68FD
    ld a, [wReturnMode]                           ; $6900
    ld b, a                                       ; $6903
    ld a, [wReturnState]                          ; $6904
    ld c, a                                       ; $6907
    call Fade_GoToB                               ; $6908
    ret                                           ; $690B


Jump_001_690c:
    ld a, [wPrnStatus]                            ; $690C
    cp $ff                                        ; $690F
    jr z, jr_001_692b                             ; $6911

    bit 7, a                                      ; $6913
    jr z, jr_001_691b                             ; $6915

    ld a, $04                                     ; $6917
    jr jr_001_6938                                ; $6919

jr_001_691b:
    bit 6, a                                      ; $691B
    jr z, jr_001_6923                             ; $691D

    ld a, $07                                     ; $691F
    jr jr_001_6938                                ; $6921

jr_001_6923:
    bit 5, a                                      ; $6923
    jr z, jr_001_692b                             ; $6925

    ld a, $06                                     ; $6927
    jr jr_001_6938                                ; $6929

jr_001_692b:
    ld a, [wPrnDevId]                             ; $692B
    cp $81                                        ; $692E
    jr z, jr_001_6936                             ; $6930

    ld a, $05                                     ; $6932
    jr jr_001_6938                                ; $6934

jr_001_6936:
    ld a, $05                                     ; $6936

jr_001_6938:
    push af                                       ; $6938
    call Prn_EngineStop                           ; $6939
    pop af                                        ; $693C
    call Message_Show                             ; $693D
    ret                                           ; $6940


; C: by [$D933] odd or even: the print stream pointer $D3F4-$D3F6; runs in mode $06 state $15 (BGB 2026-11-08: album
; print with START, the second page with the comment lines, the ID card fields and Kitty)
Print_SetFrameSide::
    ld a, [wMode03_State02_D933]                  ; $6941
    and $01                                       ; $6944
    jr nz, jr_001_6959                            ; $6946

    ld a, $50                                     ; $6948
    ld [wPrint_StreamFromD3F4], a                 ; $694A
    ld a, $5b                                     ; $694D
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $694F
    ld a, $23                                     ; $6952
    ld [wPrint_SetFrameSide_D3F6], a              ; $6954
    jr jr_001_6968                                ; $6957

jr_001_6959:
    ld a, $50                                     ; $6959
    ld [wPrint_StreamFromD3F4], a                 ; $695B
    ld a, $5f                                     ; $695E
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $6960
    ld a, $23                                     ; $6963
    ld [wPrint_SetFrameSide_D3F6], a              ; $6965

jr_001_6968:
    ret                                           ; $6968


; C: Copy_FarInline from 26:5C00 and from 0D:6000 or 0D:6400 by [$D933] parity; runs in mode $06 states $15 and $1C
; (BGB 2026-11-08: album print with START)
Print_LoadFrameGfx::
    call Copy_FarInline                           ; $6969

    db $00, $5c, $26, $00, $c4, $00, $09

    ld a, [wMode03_State02_D933]                  ; $6973
    and $01                                       ; $6976
    jr nz, jr_001_6986                            ; $6978

    call Copy_FarInline                           ; $697A

    db $00, $60, $0d, $00, $c0, $00, $04

    jr jr_001_6990                                ; $6984

jr_001_6986:
    call Copy_FarInline                           ; $6986

    db $00, $64, $0d, $00, $c0, $60, $04

jr_001_6990:
    ret                                           ; $6990


; C: the pointer [$D98B] of 01:69DD: $230 bytes into $CBB0; runs on its screen in the core replays
; (port/entry_modes_kitty.csv)
Print_LoadItemPicture::
    ld a, [wPrint_LoadItemPicture_D98B]           ; $6991
    sla a                                         ; $6994
    ld c, a                                       ; $6996
    ld b, $00                                     ; $6997
    ld hl, Print_LoadItemPicture_Tbl69DD          ; $6999
    add hl, bc                                    ; $699C
    ld a, [hl+]                                   ; $699D
    ld e, a                                       ; $699E
    ld a, [hl+]                                   ; $699F
    ld d, a                                       ; $69A0
    ld hl, $cbb0                                  ; $69A1
    ld bc, $0230                                  ; $69A4
    call Copy_DEtoHL                              ; $69A7
    call Copy_FarInline                           ; $69AA

    db $00, $7f, $0b, $00, $ca, $00, $01

    ld a, [wCardBackgroundSel]                    ; $69B4
    ld c, $06                                     ; $69B7
    call Mul_8x8                                  ; $69B9
    ld bc, Print_LoadItemPicture_Tbl69DD + $6     ; $69BC
    add hl, bc                                    ; $69BF
    ld a, [hl+]                                   ; $69C0
    ld e, a                                       ; $69C1
    ld a, [hl+]                                   ; $69C2
    ld d, a                                       ; $69C3
    ld a, [hl+]                                   ; $69C4
    push hl                                       ; $69C5
    ld hl, $c000                                  ; $69C6
    ld bc, $0650                                  ; $69C9
    call Copy_FarDEtoHL                           ; $69CC
    pop hl                                        ; $69CF
    ld a, [hl+]                                   ; $69D0
    ld [wPrint_StreamFromD3F4], a                 ; $69D1
    ld a, [hl+]                                   ; $69D4
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $69D5
    ld a, [hl+]                                   ; $69D8
    ld [wPrint_SetFrameSide_D3F6], a              ; $69D9
    ret                                           ; $69DC


; C: named by the code of Print_LoadItemPicture (01:6999); read in the runs by Print_LoadItemPicture,
; PrintScript_NextState, Mode06_State1A; first read on the screen Mode06_Printing_State16
; (trace/read_screens_kitty*.npz)
Print_LoadItemPicture_Tbl69DD::
    db $30, $c2, $60, $c4, $90, $c6
    dwb Gfx_2F_6B70_Mode0A_NameCard_State01
    db $40, $7e, $28, $c0, $66, $2c, $40, $7e, $2b
    dwb Gfx_27_75E0_Mode0A_NameCard_State03
    db $40, $7e, $22
    dwb Gfx_26_6B80_Mode0A_NameCard_State01
    db $40, $7e, $26, $60, $7a, $2f
    dwb Gfx_1C_7E40_Mode0A_NameCard_State03
    db $20, $5d, $2c, $40, $7e, $29, $20, $58, $2c, $40, $7e, $2a, $00, $80, $ff, $1b
    db $22, $24, $00, $80, $ff, $1b, $22, $25, $01, $50, $ff, $1b, $22, $26, $01, $80
    db $ff, $1b, $22, $27, $01, $80, $ff, $1c, $22, $28, $00, $60, $ff, $1d, $22, $29
    db $01, $00, $fe, $1e, $22, $2a

; C: B = 6 (printing), C = the next byte of the script [$D93B]: the next state
PrintScript_NextState::
    ld b, $06                                     ; $6A37
    ld a, [wPrintScript_NextState_D93B]           ; $6A39
    ld l, a                                       ; $6A3C
    ld a, [wPrintScript_NextState_D93C]           ; $6A3D
    ld h, a                                       ; $6A40
    ld a, [hl+]                                   ; $6A41
    ld c, a                                       ; $6A42
    ld a, l                                       ; $6A43
    ld [wPrintScript_NextState_D93B], a           ; $6A44
    ld a, h                                       ; $6A47
    ld [wPrintScript_NextState_D93C], a           ; $6A48
    ret                                           ; $6A4B


; C: B = 6, C = the last byte read again
PrintScript_SameState::
    ld b, $06                                     ; $6A4C
    ld a, [wPrintScript_NextState_D93B]           ; $6A4E
    ld l, a                                       ; $6A51
    ld a, [wPrintScript_NextState_D93C]           ; $6A52
    ld h, a                                       ; $6A55
    dec hl                                        ; $6A56
    ld a, [hl+]                                   ; $6A57
    ld c, a                                       ; $6A58
    ld a, l                                       ; $6A59
    ld [wPrintScript_NextState_D93B], a           ; $6A5A
    ld a, h                                       ; $6A5D
    ld [wPrintScript_NextState_D93C], a           ; $6A5E
    ret                                           ; $6A61


; C: handler of state $00 of mode $06 (word 0 of Mode06_StateTable)
Mode06_State00::
    di                                            ; $6A62
    call Lcd_Off                                  ; $6A63
    call Oam_ClearShadow                          ; $6A66
    ld b, BANK(Objects_ClearAll)                  ; $6A69
    ld hl, Objects_ClearAll                       ; $6A6B
    call Far_Call                                 ; $6A6E
    ld b, BANK(ScriptSlots_Clear)                 ; $6A71
    ld hl, ScriptSlots_Clear                      ; $6A73
    call Far_Call                                 ; $6A76
    call Copy_FarInline                           ; $6A79

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $6A83

    db $f0, $75, $31, $00, $98, $00, $04

    ld b, MODE_PRINTING                           ; $6A8D
    ld c, $00                                     ; $6A8F
    call Mode_SaveReturnD8F2                      ; $6A91
    ld b, MODE_PRINTING                           ; $6A94
    ld c, $00                                     ; $6A96
    call Mode_SaveReturnD93D                      ; $6A98
    call Keys_SetRepeatInline                     ; $6A9B

    dw $0a14

    xor a                                         ; $6AA0
    ld [wMode06_State00_D3A2], a                  ; $6AA1
    ld [wMode06_State24_D3FC], a                  ; $6AA4
    ld [wPrint_StreamFromD3F4], a                 ; $6AA7
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $6AAA
    ld [wPrint_SetFrameSide_D3F6], a              ; $6AAD
    ld [wPrintFrame_Next_D935], a                 ; $6AB0
    call Stat_SetTileToggleAt4F                   ; $6AB3
    call Serial_SetFarCallback                    ; $6AB6

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $6ABC

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    push af                                       ; $6ACA
    ld a, MUSIC_PRINTING                          ; $6ACB
    ld [wSndMusicReq], a                          ; $6ACD
    pop af                                        ; $6AD0
    ei                                            ; $6AD1
    ld a, [wMode03_State02_D933]                  ; $6AD2
    ld b, BANK(Photo_FindSlotA)                   ; $6AD5
    ld hl, Photo_FindSlotA                        ; $6AD7
    call Far_CallKeepA                            ; $6ADA
    ld b, BANK(Photo_LoadToBufferAndVram)         ; $6ADD
    ld hl, Photo_LoadToBufferAndVram              ; $6ADF
    call Far_CallKeepA                            ; $6AE2
    ld a, [wSlotTagBorder]                        ; $6AE5
    ld [wMode06_State00_D931], a                  ; $6AE8
    ld a, [wMode06_State00_D931]                  ; $6AEB
    call FrameRec_LoadDefault                     ; $6AEE
    ld hl, wLcdcShadow                            ; $6AF1
    set 2, [hl]                                   ; $6AF4
    ld bc, $2020                                  ; $6AF6
    ld de, ObjScript_02_61F2_Mode05_StampWindow_State06 + $6 ; $6AF9
    call Object_CreateWithParam                   ; $6AFC
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $20 ; $6AFF
    call Object_Create                            ; $6B02
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $26 ; $6B05
    call Object_Create                            ; $6B08
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $2C ; $6B0B
    call Object_Create                            ; $6B0E
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $32 ; $6B11
    call Object_Create                            ; $6B14
    ld b, MODE_PRINTING                           ; $6B17
    ld c, STATE_06_PRINTING_CHOOSE_PRINT_FRAME    ; $6B19
    call Fade_GoTo                                ; $6B1B
    ret                                           ; $6B1E


; C: handler of state $01 of mode $06 (word 1 of Mode06_StateTable)
Mode06_State01::
    di                                            ; $6B1F
    call Lcd_Off                                  ; $6B20
    call Oam_ClearShadow                          ; $6B23
    ld b, BANK(Objects_ClearAll)                  ; $6B26
    ld hl, Objects_ClearAll                       ; $6B28
    call Far_Call                                 ; $6B2B
    ld b, BANK(ScriptSlots_Clear)                 ; $6B2E
    ld hl, ScriptSlots_Clear                      ; $6B30
    call Far_Call                                 ; $6B33
    call Stat_SetTileToggleAt4F                   ; $6B36
    ld de, Gfx_23_7350_Mode02_TakePhotos_State00  ; $6B39
    ld hl, $8600                                  ; $6B3C
    ld bc, $0400                                  ; $6B3F
    ld a, $23                                     ; $6B42
    call Copy_FarDEtoHL                           ; $6B44
    ld de, Gfx_31_75F0_Mode02_TakePhotos_State00  ; $6B47
    ld hl, $9800                                  ; $6B4A
    ld bc, $0400                                  ; $6B4D
    ld a, $31                                     ; $6B50
    call Copy_FarDEtoHL                           ; $6B52
    ld de, $c000                                  ; $6B55
    ld hl, $9000                                  ; $6B58
    ld bc, $0800                                  ; $6B5B
    call Copy_FarDEtoHL                           ; $6B5E
    ld de, $c800                                  ; $6B61
    ld hl, $8000                                  ; $6B64
    ld bc, $0600                                  ; $6B67
    call Copy_FarDEtoHL                           ; $6B6A
    ei                                            ; $6B6D
    ld a, [wMode06_State00_D931]                  ; $6B6E
    call FrameRec_LoadDefault                     ; $6B71
    ld b, MODE_PRINTING                           ; $6B74
    ld c, STATE_06_PRINTING_CHOOSE_PRINT_FRAME    ; $6B76
    call Fade_GoTo                                ; $6B78
    ret                                           ; $6B7B


; C: handler of state $02 of mode $06 (word 2 of Mode06_StateTable)
Mode06_State02::
    di                                            ; $6B7C
    call Lcd_Off                                  ; $6B7D
    call Oam_ClearShadow                          ; $6B80
    ld b, BANK(Objects_ClearAll)                  ; $6B83
    ld hl, Objects_ClearAll                       ; $6B85
    call Far_Call                                 ; $6B88
    ld b, BANK(ScriptSlots_Clear)                 ; $6B8B
    ld hl, ScriptSlots_Clear                      ; $6B8D
    call Far_Call                                 ; $6B90
    call Stat_SetTileToggleAt27                   ; $6B93
    ld de, Map_20_7800_Mode06_Printing_State02    ; $6B96
    ld a, $20                                     ; $6B99
    ld hl, $9842                                  ; $6B9B
    ld bc, $0120                                  ; $6B9E
    call Copy_FarDEtoHL                           ; $6BA1
    ld de, Map_20_7A60_Mode06_Printing_State02    ; $6BA4
    ld a, $20                                     ; $6BA7
    ld hl, $9962                                  ; $6BA9
    ld bc, $0120                                  ; $6BAC
    call Copy_FarDEtoHL                           ; $6BAF
    ei                                            ; $6BB2
    ld a, [wPrintFrame_Next_D935]                 ; $6BB3
    ld b, BANK(PrintFrame_LoadTiles)              ; $6BB6
    ld hl, PrintFrame_LoadTiles                   ; $6BB8
    call Far_CallKeepA                            ; $6BBB
    ld de, ObjScript_02_6518_Mode06_Printing_State05 + $5C ; $6BBE
    call Object_Create                            ; $6BC1
    ld b, MODE_PRINTING                           ; $6BC4
    ld c, STATE_06_PRINTING_CHOOSE_WILD_FRAME     ; $6BC6
    call Fade_GoTo                                ; $6BC8
    ret                                           ; $6BCB


Jump_001_6bcc:
    push af                                       ; $6BCC
    ld a, SFX3_09                                 ; $6BCD
    ld [wSndSfx3], a                              ; $6BCF
    pop af                                        ; $6BD2
    push hl                                       ; $6BD3
    ld hl, wMode06_State0A_D896                   ; $6BD4
    set 0, [hl]                                   ; $6BD7
    pop hl                                        ; $6BD9
    ld a, [wMode06_State00_D931]                  ; $6BDA
    ld [wSlotTagBorder], a                        ; $6BDD
    ld b, BANK(Photo_StoreCurrent)                ; $6BE0
    ld hl, Photo_StoreCurrent                     ; $6BE2
    call Far_Call                                 ; $6BE5
    push hl                                       ; $6BE8
    ld hl, wMode06_State0A_D896                   ; $6BE9
    res 0, [hl]                                   ; $6BEC
    pop hl                                        ; $6BEE
    ld b, MODE_VIEW_ALBUM                         ; $6BEF
    ld c, $01                                     ; $6BF1
    call Fade_GoToB                               ; $6BF3
    ret                                           ; $6BF6


Jump_001_6bf7:
    push af                                       ; $6BF7
    ld a, SFX1_0B                                 ; $6BF8
    ld [wSndSfx1], a                              ; $6BFA
    pop af                                        ; $6BFD
    ldh a, [hState]                               ; $6BFE
    ldh [hMode06_State03_FF90], a                 ; $6C00
    ld hl, wLcdcShadow                            ; $6C02
    res 2, [hl]                                   ; $6C05
    ld a, $0c                                     ; $6C07
    ldh [hState], a                               ; $6C09
    ret                                           ; $6C0B


Jump_001_6c0c:
    push af                                       ; $6C0C
    ld a, SFX1_16                                 ; $6C0D
    ld [wSndSfx1], a                              ; $6C0F
    pop af                                        ; $6C12
    ld b, MODE_PRINTING                           ; $6C13
    ld c, $01                                     ; $6C15
    call Fade_GoToB                               ; $6C17
    ret                                           ; $6C1A


Jump_001_6c1b:
    push af                                       ; $6C1B
    ld a, SFX1_16                                 ; $6C1C
    ld [wSndSfx1], a                              ; $6C1E
    pop af                                        ; $6C21
    ld b, MODE_PRINTING                           ; $6C22
    ld c, $02                                     ; $6C24
    call Fade_GoToB                               ; $6C26
    ret                                           ; $6C29


; C: handler of state $03 of mode $06 (word 3 of Mode06_StateTable)
Mode06_State03::
    ld a, [wKeysNew]                              ; $6C2A
    bit PADB_B, a                                 ; $6C2D
    jp nz, Jump_001_6bcc                          ; $6C2F

    ld a, [wKeysHeld]                             ; $6C32
    bit PADB_START, a                             ; $6C35
    jp nz, Jump_001_6bf7                          ; $6C37

    ld a, [wKeysNew]                              ; $6C3A
    bit PADB_A, a                                 ; $6C3D
    jr z, jr_001_6c57                             ; $6C3F

    push af                                       ; $6C41
    ld a, SFX1_05                                 ; $6C42
    ld [wSndSfx1], a                              ; $6C44
    pop af                                        ; $6C47
    ld a, $02                                     ; $6C48
    ld b, BANK(KeyPrompt_LoadSounds)              ; $6C4A
    ld hl, KeyPrompt_LoadSounds                   ; $6C4C
    call Far_CallKeepA                            ; $6C4F
    ld a, $0a                                     ; $6C52
    ldh [hState], a                               ; $6C54
    ret                                           ; $6C56


jr_001_6c57:
    ld a, [wKeysNewRepeat]                        ; $6C57
    bit PADB_LEFT, a                              ; $6C5A
    jr z, jr_001_6c6d                             ; $6C5C

    ld de, ObjScript_02_5FF8_Mode02_TakePhotos_State08 + $CA ; $6C5E
    call Object_Create                            ; $6C61
    ldh a, [hState]                               ; $6C64
    ldh [hMode06_State03_FF90], a                 ; $6C66
    ld a, $0e                                     ; $6C68
    ldh [hState], a                               ; $6C6A
    ret                                           ; $6C6C


jr_001_6c6d:
    ld a, [wKeysNewRepeat]                        ; $6C6D
    bit PADB_RIGHT, a                             ; $6C70
    jr z, jr_001_6c83                             ; $6C72

    ld de, ObjScript_02_5FF8_Mode02_TakePhotos_State08 + $62 ; $6C74
    call Object_Create                            ; $6C77
    ldh a, [hState]                               ; $6C7A
    ldh [hMode06_State03_FF90], a                 ; $6C7C
    ld a, $0e                                     ; $6C7E
    ldh [hState], a                               ; $6C80
    ret                                           ; $6C82


jr_001_6c83:
    ld a, [wKeysNew]                              ; $6C83
    and PADF_UP | PADF_DOWN                       ; $6C86
    jp nz, Jump_001_6c1b                          ; $6C88

    ret                                           ; $6C8B


; C: handler of state $0E of mode $06 (word 14 of Mode06_StateTable)
Mode06_State0E::
    ld hl, wMode06_State0E_D8D3                   ; $6C8C
    bit 7, [hl]                                   ; $6C8F
    jr z, jr_001_6c98                             ; $6C91

    ldh a, [hMode06_State03_FF90]                 ; $6C93
    ldh [hState], a                               ; $6C95
    ret                                           ; $6C97


jr_001_6c98:
    ret                                           ; $6C98


    db $fa, $e0, $d8, $cb, $4f, $28, $0a, $3e, $04, $ea, $e0, $d8, $3e, $04, $e0, $8e
    db $c9, $c9

; C: handler of state $05 of mode $06 (word 5 of Mode06_StateTable)
Mode06_State05::
    ld hl, wMode06_State0E_D8D3                   ; $6CAB
    bit 6, [hl]                                   ; $6CAE
    jr z, jr_001_6cb7                             ; $6CB0

    ld a, $06                                     ; $6CB2
    ldh [hState], a                               ; $6CB4
    ret                                           ; $6CB6


jr_001_6cb7:
    ld a, [wKeysNew]                              ; $6CB7
    bit PADB_B, a                                 ; $6CBA
    jp nz, Jump_001_6bcc                          ; $6CBC

    ld a, [wKeysNewRepeat]                        ; $6CBF
    and PADF_RIGHT | PADF_LEFT                    ; $6CC2
    jp nz, Jump_001_6c0c                          ; $6CC4

    ret                                           ; $6CC7


; C: handler of state $04 of mode $06 (word 4 of Mode06_StateTable)
Mode06_State04::
    ld hl, wMode06_State0E_D8D3                   ; $6CC8
    bit 6, [hl]                                   ; $6CCB
    jr z, jr_001_6cd4                             ; $6CCD

    ld a, $06                                     ; $6CCF
    ldh [hState], a                               ; $6CD1
    ret                                           ; $6CD3


jr_001_6cd4:
    ld a, [wKeysNew]                              ; $6CD4
    bit PADB_B, a                                 ; $6CD7
    jp nz, Jump_001_6bcc                          ; $6CD9

    ld a, [wKeysNewRepeat]                        ; $6CDC
    bit PADB_UP, a                                ; $6CDF
    jr z, jr_001_6cee                             ; $6CE1

    ld de, ObjScript_02_6A59_Mode06_Printing_State08 ; $6CE3
    call Object_Create                            ; $6CE6
    ld a, $07                                     ; $6CE9
    ldh [hState], a                               ; $6CEB
    ret                                           ; $6CED


jr_001_6cee:
    ld a, [wKeysNewRepeat]                        ; $6CEE
    bit PADB_DOWN, a                              ; $6CF1
    jr z, jr_001_6d00                             ; $6CF3

    ld de, ObjScript_02_6A59_Mode06_Printing_State08 + $6 ; $6CF5
    call Object_Create                            ; $6CF8
    ld a, $07                                     ; $6CFB
    ldh [hState], a                               ; $6CFD
    ret                                           ; $6CFF


jr_001_6d00:
    ld a, [wKeysNewRepeat]                        ; $6D00
    and PADF_RIGHT | PADF_LEFT                    ; $6D03
    jp nz, Jump_001_6c0c                          ; $6D05

    ret                                           ; $6D08


; C: handler of state $06 of mode $06 (word 6 of Mode06_StateTable)
Mode06_State06::
    ld a, [wKeysNew]                              ; $6D09
    bit PADB_B, a                                 ; $6D0C
    jp nz, Jump_001_6bcc                          ; $6D0E

    ld a, [wKeysHeld]                             ; $6D11
    bit PADB_START, a                             ; $6D14
    jp nz, Jump_001_6bf7                          ; $6D16

    ld a, [wKeysNew]                              ; $6D19
    bit PADB_A, a                                 ; $6D1C
    jr z, jr_001_6d3c                             ; $6D1E

    push af                                       ; $6D20
    ld a, SFX1_05                                 ; $6D21
    ld [wSndSfx1], a                              ; $6D23
    pop af                                        ; $6D26
    ld hl, wMode06_State0E_D8D3                   ; $6D27
    bit 6, [hl]                                   ; $6D2A
    ret z                                         ; $6D2C

    ld a, $02                                     ; $6D2D
    ld b, BANK(KeyPrompt_LoadSounds)              ; $6D2F
    ld hl, KeyPrompt_LoadSounds                   ; $6D31
    call Far_CallKeepA                            ; $6D34
    ld a, $0b                                     ; $6D37
    ldh [hState], a                               ; $6D39
    ret                                           ; $6D3B


jr_001_6d3c:
    ld a, [wKeysNewRepeat]                        ; $6D3C
    bit PADB_UP, a                                ; $6D3F
    jr z, jr_001_6d4e                             ; $6D41

    ld de, ObjScript_02_659A_Mode06_Printing_State08 + $61 ; $6D43
    call Object_Create                            ; $6D46
    ld a, $08                                     ; $6D49
    ldh [hState], a                               ; $6D4B
    ret                                           ; $6D4D


jr_001_6d4e:
    ld a, [wKeysNewRepeat]                        ; $6D4E
    bit PADB_DOWN, a                              ; $6D51
    jr z, jr_001_6d60                             ; $6D53

    ld de, ObjScript_02_659A_Mode06_Printing_State08 + $61 ; $6D55
    call Object_Create                            ; $6D58
    ld a, $09                                     ; $6D5B
    ldh [hState], a                               ; $6D5D
    ret                                           ; $6D5F


jr_001_6d60:
    ld a, [wKeysNew]                              ; $6D60
    and PADF_RIGHT | PADF_LEFT                    ; $6D63
    jp nz, Jump_001_6c0c                          ; $6D65

    ret                                           ; $6D68


; C: handler of state $07 of mode $06 (word 7 of Mode06_StateTable)
Mode06_State07::
    ld hl, wMode06_State0E_D8D3                   ; $6D69
    bit 7, [hl]                                   ; $6D6C
    jr z, jr_001_6d7b                             ; $6D6E

    ld de, ObjScript_02_6518_Mode06_Printing_State05 + $5C ; $6D70
    call Object_Create                            ; $6D73
    ld a, $04                                     ; $6D76
    ldh [hState], a                               ; $6D78
    ret                                           ; $6D7A


jr_001_6d7b:
    ret                                           ; $6D7B


; C: handler of state $09 of mode $06 (word 9 of Mode06_StateTable)
Mode06_State09::
    ld hl, wMode06_State0E_D8D3                   ; $6D7C
    bit 6, [hl]                                   ; $6D7F
    jr nz, jr_001_6d8d                            ; $6D81

    ld de, ObjScript_02_6A59_Mode06_Printing_State08 + $6 ; $6D83
    call Object_Create                            ; $6D86
    ld a, $07                                     ; $6D89
    ldh [hState], a                               ; $6D8B

jr_001_6d8d:
    ret                                           ; $6D8D


; C: handler of state $08 of mode $06 (word 8 of Mode06_StateTable)
Mode06_State08::
    ld hl, wMode06_State0E_D8D3                   ; $6D8E
    bit 6, [hl]                                   ; $6D91
    jr nz, jr_001_6d9f                            ; $6D93

    ld de, ObjScript_02_6A59_Mode06_Printing_State08 ; $6D95
    call Object_Create                            ; $6D98
    ld a, $07                                     ; $6D9B
    ldh [hState], a                               ; $6D9D

jr_001_6d9f:
    ret                                           ; $6D9F


; C: handler of state $0A of mode $06 (word 10 of Mode06_StateTable)
Mode06_State0A::
    ld a, [wMode06_State0A_D8DF]                  ; $6DA0
    bit 1, a                                      ; $6DA3
    jr z, jr_001_6dac                             ; $6DA5

    ld a, $03                                     ; $6DA7
    ldh [hState], a                               ; $6DA9
    ret                                           ; $6DAB


jr_001_6dac:
    ld a, [wMode06_State0A_D8DF]                  ; $6DAC
    bit 0, a                                      ; $6DAF
    jr z, jr_001_6dd7                             ; $6DB1

    push hl                                       ; $6DB3
    ld hl, wMode06_State0A_D896                   ; $6DB4
    set 0, [hl]                                   ; $6DB7
    pop hl                                        ; $6DB9
    ld a, [wMode06_State00_D931]                  ; $6DBA
    ld [wSlotTagBorder], a                        ; $6DBD
    ld b, BANK(Photo_StoreCurrent)                ; $6DC0
    ld hl, Photo_StoreCurrent                     ; $6DC2
    call Far_Call                                 ; $6DC5
    push hl                                       ; $6DC8
    ld hl, wMode06_State0A_D896                   ; $6DC9
    res 0, [hl]                                   ; $6DCC
    pop hl                                        ; $6DCE
    ld b, MODE_PRINTING                           ; $6DCF
    ld c, $10                                     ; $6DD1
    call Fade_GoToB                               ; $6DD3
    ret                                           ; $6DD6


jr_001_6dd7:
    ld a, [wMode06_State0A_D8DF]                  ; $6DD7
    bit 3, a                                      ; $6DDA
    jr z, jr_001_6e07                             ; $6DDC

    push hl                                       ; $6DDE
    ld hl, wMode06_State0A_D896                   ; $6DDF
    set 0, [hl]                                   ; $6DE2
    pop hl                                        ; $6DE4
    ld a, [wMode06_State00_D931]                  ; $6DE5
    ld [wSlotTagBorder], a                        ; $6DE8
    ld b, BANK(Photo_StoreCurrent)                ; $6DEB
    ld hl, Photo_StoreCurrent                     ; $6DED
    call Far_Call                                 ; $6DF0
    push hl                                       ; $6DF3
    ld hl, wMode06_State0A_D896                   ; $6DF4
    res 0, [hl]                                   ; $6DF7
    pop hl                                        ; $6DF9
    ld hl, wMode06_State24_D3FC                   ; $6DFA
    set 0, [hl]                                   ; $6DFD
    ld b, MODE_PRINTING                           ; $6DFF
    ld c, $10                                     ; $6E01
    call Fade_GoToB                               ; $6E03
    ret                                           ; $6E06


jr_001_6e07:
    ret                                           ; $6E07


; C: handler of state $0B of mode $06 (word 11 of Mode06_StateTable)
Mode06_State0B::
    ld a, [wMode06_State0A_D8DF]                  ; $6E08
    bit 1, a                                      ; $6E0B
    jr z, jr_001_6e14                             ; $6E0D

    ld a, $06                                     ; $6E0F
    ldh [hState], a                               ; $6E11
    ret                                           ; $6E13


jr_001_6e14:
    ld a, [wMode06_State0A_D8DF]                  ; $6E14
    bit 0, a                                      ; $6E17
    jr z, jr_001_6e3f                             ; $6E19

    push hl                                       ; $6E1B
    ld hl, wMode06_State0A_D896                   ; $6E1C
    set 0, [hl]                                   ; $6E1F
    pop hl                                        ; $6E21
    ld a, [wMode06_State00_D931]                  ; $6E22
    ld [wSlotTagBorder], a                        ; $6E25
    ld b, BANK(Photo_StoreCurrent)                ; $6E28
    ld hl, Photo_StoreCurrent                     ; $6E2A
    call Far_Call                                 ; $6E2D
    push hl                                       ; $6E30
    ld hl, wMode06_State0A_D896                   ; $6E31
    res 0, [hl]                                   ; $6E34
    pop hl                                        ; $6E36
    ld b, MODE_PRINTING                           ; $6E37
    ld c, $11                                     ; $6E39
    call Fade_GoToB                               ; $6E3B
    ret                                           ; $6E3E


jr_001_6e3f:
    ld a, [wMode06_State0A_D8DF]                  ; $6E3F
    bit 3, a                                      ; $6E42
    jr z, jr_001_6e6f                             ; $6E44

    push hl                                       ; $6E46
    ld hl, wMode06_State0A_D896                   ; $6E47
    set 0, [hl]                                   ; $6E4A
    pop hl                                        ; $6E4C
    ld a, [wMode06_State00_D931]                  ; $6E4D
    ld [wSlotTagBorder], a                        ; $6E50
    ld b, BANK(Photo_StoreCurrent)                ; $6E53
    ld hl, Photo_StoreCurrent                     ; $6E55
    call Far_Call                                 ; $6E58
    push hl                                       ; $6E5B
    ld hl, wMode06_State0A_D896                   ; $6E5C
    res 0, [hl]                                   ; $6E5F
    pop hl                                        ; $6E61
    ld hl, wMode06_State24_D3FC                   ; $6E62
    set 0, [hl]                                   ; $6E65
    ld b, MODE_PRINTING                           ; $6E67
    ld c, $11                                     ; $6E69
    call Fade_GoToB                               ; $6E6B
    ret                                           ; $6E6E


jr_001_6e6f:
    ret                                           ; $6E6F


; C: handler of state $0C of mode $06 (word 12 of Mode06_StateTable)
Mode06_State0C::
    ld a, $2c                                     ; $6E70
    call FrameRec_LoadDefault                     ; $6E72
    ld a, $26                                     ; $6E75
    call FrameRec_LoadDefault                     ; $6E77
    ld de, Gfx_1B_7EF0_Mode06_Printing_State0D    ; $6E7A
    ld a, $1b                                     ; $6E7D
    ld hl, $8ef0                                  ; $6E7F
    ld bc, $00f0                                  ; $6E82
    call Vram_CopyHBlankFar                       ; $6E85
    ld de, ObjScript_02_6E79_Mode06_Printing_State0D + $16 ; $6E88
    call Object_Create                            ; $6E8B
    ld a, $0d                                     ; $6E8E
    ldh [hState], a                               ; $6E90
    ret                                           ; $6E92


; C: handler of state $0D of mode $06 (word 13 of Mode06_StateTable)
Mode06_State0D::
    ld a, [wKeysHeld]                             ; $6E93
    bit PADB_START, a                             ; $6E96
    jr nz, jr_001_6ebc                            ; $6E98

    push af                                       ; $6E9A
    ld a, SFX1_1D                                 ; $6E9B
    ld [wSndSfx1], a                              ; $6E9D
    pop af                                        ; $6EA0
    push hl                                       ; $6EA1
    ld hl, wMode06_State0A_D896                   ; $6EA2
    set 0, [hl]                                   ; $6EA5
    pop hl                                        ; $6EA7
    ld b, BANK(Counters_Store)                    ; $6EA8
    ld hl, Counters_Store                         ; $6EAA
    call Far_Call                                 ; $6EAD
    push hl                                       ; $6EB0
    ld hl, wMode06_State0A_D896                   ; $6EB1
    res 0, [hl]                                   ; $6EB4
    pop hl                                        ; $6EB6
    ld a, $0f                                     ; $6EB7
    ldh [hState], a                               ; $6EB9
    ret                                           ; $6EBB


jr_001_6ebc:
    ld a, [wKeysNewRepeat]                        ; $6EBC
    bit PADB_UP, a                                ; $6EBF
    jr z, jr_001_6ed7                             ; $6EC1

    ld a, [wPrintIntensity]                       ; $6EC3
    cp $00                                        ; $6EC6
    jr z, jr_001_6ed6                             ; $6EC8

    sub $08                                       ; $6ECA
    ld [wPrintIntensity], a                       ; $6ECC
    push af                                       ; $6ECF
    ld a, SFX1_03                                 ; $6ED0
    ld [wSndSfx1], a                              ; $6ED2
    pop af                                        ; $6ED5

jr_001_6ed6:
    ret                                           ; $6ED6


jr_001_6ed7:
    ld a, [wKeysNewRepeat]                        ; $6ED7
    bit PADB_DOWN, a                              ; $6EDA
    jr z, jr_001_6ef2                             ; $6EDC

    ld a, [wPrintIntensity]                       ; $6EDE
    cp $78                                        ; $6EE1
    jr z, jr_001_6ef1                             ; $6EE3

    add $08                                       ; $6EE5
    ld [wPrintIntensity], a                       ; $6EE7
    push af                                       ; $6EEA
    ld a, SFX1_03                                 ; $6EEB
    ld [wSndSfx1], a                              ; $6EED
    pop af                                        ; $6EF0

jr_001_6ef1:
    ret                                           ; $6EF1


jr_001_6ef2:
    ret                                           ; $6EF2


; C: handler of state $0F of mode $06 (word 15 of Mode06_StateTable)
Mode06_State0F::
    ldh a, [hMode06_State03_FF90]                 ; $6EF3
    ldh [hState], a                               ; $6EF5
    cp $03                                        ; $6EF7
    jr z, jr_001_6f36                             ; $6EF9

    ld de, Map_20_7C00_Mode06_Printing_State07    ; $6EFB
    ld a, BANK(Map_20_7C00_Mode06_Printing_State07) ; $6EFE
    ld hl, $9882                                  ; $6F00
    ld bc, $01c0                                  ; $6F03
    call Vram_CopyHBlankFar                       ; $6F06
    ld de, Map_20_7860_Mode06_Printing_State0F    ; $6F09
    ld a, $20                                     ; $6F0C
    ld hl, $9842                                  ; $6F0E
    ld bc, $0040                                  ; $6F11
    call Vram_CopyHBlankFar                       ; $6F14
    ld de, Map_20_7A60_Mode06_Printing_State02    ; $6F17
    ld a, $20                                     ; $6F1A
    ld hl, $9a42                                  ; $6F1C
    ld bc, $0040                                  ; $6F1F
    call Vram_CopyHBlankFar                       ; $6F22
    ld a, [wPrintFrame_Next_D935]                 ; $6F25
    ld b, BANK(PrintFrame_LoadPart)               ; $6F28
    ld hl, PrintFrame_LoadPart                    ; $6F2A
    call Far_CallKeepA                            ; $6F2D
    ld hl, wLcdcShadow                            ; $6F30
    set 2, [hl]                                   ; $6F33
    ret                                           ; $6F35


jr_001_6f36:
    ld a, [wMode06_State00_D931]                  ; $6F36
    call FrameRec_LoadDefault                     ; $6F39
    rst Rst08_WaitVBlank                          ; $6F3C
    ld a, [wMode06_State00_D931]                  ; $6F3D
    call FrameRec_LoadTilesAndMap                 ; $6F40
    ld hl, wLcdcShadow                            ; $6F43
    set 2, [hl]                                   ; $6F46
    ret                                           ; $6F48


; C: handler of state $10 of mode $06 (word 16 of Mode06_StateTable)
Mode06_State10::
    di                                            ; $6F49
    ld b, BANK(Objects_ClearAll)                  ; $6F4A
    ld hl, Objects_ClearAll                       ; $6F4C
    call Far_Call                                 ; $6F4F
    call Lcd_Off                                  ; $6F52
    call Oam_ClearShadow                          ; $6F55
    ld b, BANK(ScriptSlots_Clear)                 ; $6F58
    ld hl, ScriptSlots_Clear                      ; $6F5A
    call Far_Call                                 ; $6F5D
    call Serial_SetFarCallback                    ; $6F60

    dwb Frame_UpdateAll

    xor a                                         ; $6F66
    ld [wMode06_State23_D94F], a                  ; $6F67
    xor a                                         ; $6F6A
    ld [wMode06_State10_D951], a                  ; $6F6B
    ld a, $09                                     ; $6F6E
    ld [wMode06_State10_D950], a                  ; $6F70
    xor a                                         ; $6F73
    ld [wPrint_StreamFromD3F4], a                 ; $6F74
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $6F77
    ld [wPrint_SetFrameSide_D3F6], a              ; $6F7A
    ld a, $10                                     ; $6F7D
    ld [wMode06_State10_D380], a                  ; $6F7F
    ld a, [wMode06_State24_D3FC]                  ; $6F82
    bit 0, a                                      ; $6F85
    jr z, jr_001_6f90                             ; $6F87

    ld a, $00                                     ; $6F89
    ld [wMode06_State10_D381], a                  ; $6F8B
    jr jr_001_6f95                                ; $6F8E

jr_001_6f90:
    ld a, $00                                     ; $6F90
    ld [wMode06_State10_D381], a                  ; $6F92

jr_001_6f95:
    ld a, $01                                     ; $6F95
    ld [wMode06_State24_D3F9], a                  ; $6F97
    ld a, $00                                     ; $6F9A
    ld [wPrintSrcTable], a                        ; $6F9C
    ld a, $c0                                     ; $6F9F
    ld [wPrintSrcTable + $1], a                   ; $6FA1
    ld a, $00                                     ; $6FA4
    ld [wPrintSrcTable + $2], a                   ; $6FA6
    ld a, $0d                                     ; $6FA9
    ld [wPrintScript_NextState_D93B], a           ; $6FAB
    ld a, $6a                                     ; $6FAE
    ld [wPrintScript_NextState_D93C], a           ; $6FB0
    jp Mode06_State18                             ; $6FB3


; C: handler of state $11 of mode $06 (word 17 of Mode06_StateTable)
Mode06_State11::
    di                                            ; $6FB6
    ld b, BANK(Objects_ClearAll)                  ; $6FB7
    ld hl, Objects_ClearAll                       ; $6FB9
    call Far_Call                                 ; $6FBC
    call Lcd_Off                                  ; $6FBF
    call Oam_ClearShadow                          ; $6FC2
    ld b, BANK(ScriptSlots_Clear)                 ; $6FC5
    ld hl, ScriptSlots_Clear                      ; $6FC7
    call Far_Call                                 ; $6FCA
    call Serial_SetFarCallback                    ; $6FCD

    dwb Frame_UpdateAll

    xor a                                         ; $6FD3
    ld [wMode06_State23_D94F], a                  ; $6FD4
    xor a                                         ; $6FD7
    ld [wMode06_State10_D951], a                  ; $6FD8
    ld a, $03                                     ; $6FDB
    ld [wMode06_State10_D950], a                  ; $6FDD
    ld a, $10                                     ; $6FE0
    ld [wMode06_State10_D380], a                  ; $6FE2
    ld a, $00                                     ; $6FE5
    ld [wMode06_State10_D381], a                  ; $6FE7
    ld a, $01                                     ; $6FEA
    ld [wMode06_State00_D3A2], a                  ; $6FEC
    ld a, $01                                     ; $6FEF
    ld [wMode06_State24_D3F9], a                  ; $6FF1
    xor a                                         ; $6FF4
    ld [wPrint_StreamFromD3F4], a                 ; $6FF5
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $6FF8
    ld [wPrint_SetFrameSide_D3F6], a              ; $6FFB
    ld a, $00                                     ; $6FFE
    ld [wPrintSrcTable], a                        ; $7000
    ld a, $c0                                     ; $7003
    ld [wPrintSrcTable + $1], a                   ; $7005
    ld a, $00                                     ; $7008
    ld [wPrintSrcTable + $2], a                   ; $700A
    call PrintFrame_Select                        ; $700D
    ld a, $13                                     ; $7010
    ld [wPrintScript_NextState_D93B], a           ; $7012
    ld a, $6a                                     ; $7015
    ld [wPrintScript_NextState_D93C], a           ; $7017
    jp Mode06_State18                             ; $701A


; C: handler of state $12 of mode $06 (word 18 of Mode06_StateTable)
Mode06_State12::
    ld b, BANK(Objects_ClearAll)                  ; $701D
    ld hl, Objects_ClearAll                       ; $701F
    call Far_Call                                 ; $7022
    ld hl, wLcdcShadow                            ; $7025
    res 7, [hl]                                   ; $7028
    ld hl, $ff40                                  ; $702A

jr_001_702d:
    bit 7, [hl]                                   ; $702D
    jr nz, jr_001_702d                            ; $702F

    call Oam_ClearShadow                          ; $7031
    ld b, BANK(ScriptSlots_Clear)                 ; $7034
    ld hl, ScriptSlots_Clear                      ; $7036
    call Far_Call                                 ; $7039
    xor a                                         ; $703C
    ld [wMode06_State10_D951], a                  ; $703D
    ld a, $07                                     ; $7040
    ld [wMode06_State10_D950], a                  ; $7042
    ld a, $10                                     ; $7045
    ld [wMode06_State10_D380], a                  ; $7047
    ld a, $00                                     ; $704A
    ld [wMode06_State10_D381], a                  ; $704C
    ld a, $19                                     ; $704F
    ld [wPrintScript_NextState_D93B], a           ; $7051
    ld a, $6a                                     ; $7054
    ld [wPrintScript_NextState_D93C], a           ; $7056
    ld a, $19                                     ; $7059
    ldh [hState], a                               ; $705B
    ret                                           ; $705D


; C: handler of state $13 of mode $06 (word 19 of Mode06_StateTable)
Mode06_State13::
    ld b, BANK(Objects_ClearAll)                  ; $705E
    ld hl, Objects_ClearAll                       ; $7060
    call Far_Call                                 ; $7063
    ld hl, wLcdcShadow                            ; $7066
    res 7, [hl]                                   ; $7069
    ld hl, $ff40                                  ; $706B

jr_001_706e:
    bit 7, [hl]                                   ; $706E
    jr nz, jr_001_706e                            ; $7070

    call Oam_ClearShadow                          ; $7072
    ld b, BANK(ScriptSlots_Clear)                 ; $7075
    ld hl, ScriptSlots_Clear                      ; $7077
    call Far_Call                                 ; $707A
    xor a                                         ; $707D
    ld [wMode06_State10_D951], a                  ; $707E
    ld a, $05                                     ; $7081
    ld [wMode06_State10_D950], a                  ; $7083
    ld a, $10                                     ; $7086
    ld [wMode06_State10_D380], a                  ; $7088
    ld a, [wMode06_State24_D3FC]                  ; $708B
    bit 0, a                                      ; $708E
    jr z, jr_001_7099                             ; $7090

    ld a, $00                                     ; $7092
    ld [wMode06_State10_D381], a                  ; $7094
    jr jr_001_709e                                ; $7097

jr_001_7099:
    ld a, $00                                     ; $7099
    ld [wMode06_State10_D381], a                  ; $709B

jr_001_709e:
    ld a, $1f                                     ; $709E
    ld [wPrintScript_NextState_D93B], a           ; $70A0
    ld a, $6a                                     ; $70A3
    ld [wPrintScript_NextState_D93C], a           ; $70A5
    ld a, $19                                     ; $70A8
    ldh [hState], a                               ; $70AA
    ret                                           ; $70AC


; C: handler of state $14 of mode $06 (word 20 of Mode06_StateTable)
Mode06_State14::
    di                                            ; $70AD
    ld b, BANK(Objects_ClearAll)                  ; $70AE
    ld hl, Objects_ClearAll                       ; $70B0
    call Far_Call                                 ; $70B3
    call Lcd_Off                                  ; $70B6
    call Oam_ClearShadow                          ; $70B9
    ld b, BANK(ScriptSlots_Clear)                 ; $70BC
    ld hl, ScriptSlots_Clear                      ; $70BE
    call Far_Call                                 ; $70C1
    call Serial_SetFarCallback                    ; $70C4

    dwb Frame_UpdateAll

    xor a                                         ; $70CA
    ld [wMode06_State23_D94F], a                  ; $70CB
    xor a                                         ; $70CE
    ld [wMode06_State10_D951], a                  ; $70CF
    ld a, $09                                     ; $70D2
    ld [wMode06_State10_D950], a                  ; $70D4
    xor a                                         ; $70D7
    ld [wPrint_StreamFromD3F4], a                 ; $70D8
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $70DB
    ld [wPrint_SetFrameSide_D3F6], a              ; $70DE
    ld a, $10                                     ; $70E1
    ld [wMode06_State10_D380], a                  ; $70E3
    ld a, $00                                     ; $70E6
    ld [wMode06_State10_D381], a                  ; $70E8
    xor a                                         ; $70EB
    ld [wMode06_State00_D3A2], a                  ; $70EC
    ld [wMode06_State24_D3FC], a                  ; $70EF
    ld a, $01                                     ; $70F2
    ld [wMode06_State24_D3F9], a                  ; $70F4
    ld a, $00                                     ; $70F7
    ld [wPrintSrcTable], a                        ; $70F9
    ld a, $c0                                     ; $70FC
    ld [wPrintSrcTable + $1], a                   ; $70FE
    ld a, $00                                     ; $7101
    ld [wPrintSrcTable + $2], a                   ; $7103
    ld a, $0d                                     ; $7106
    ld [wPrintScript_NextState_D93B], a           ; $7108
    ld a, $6a                                     ; $710B
    ld [wPrintScript_NextState_D93C], a           ; $710D
    jp Mode06_State18                             ; $7110


; C: handler of state $15 of mode $06 (word 21 of Mode06_StateTable)
Mode06_State15::
    ld b, BANK(Objects_ClearAll)                  ; $7113
    ld hl, Objects_ClearAll                       ; $7115
    call Far_Call                                 ; $7118
    ld hl, wLcdcShadow                            ; $711B
    res 7, [hl]                                   ; $711E
    ld hl, $ff40                                  ; $7120

jr_001_7123:
    bit 7, [hl]                                   ; $7123
    jr nz, jr_001_7123                            ; $7125

    call Oam_ClearShadow                          ; $7127
    ld b, BANK(ScriptSlots_Clear)                 ; $712A
    ld hl, ScriptSlots_Clear                      ; $712C
    call Far_Call                                 ; $712F
    xor a                                         ; $7132
    ld [wMode06_State10_D951], a                  ; $7133
    ld a, $09                                     ; $7136
    ld [wMode06_State10_D950], a                  ; $7138
    ld a, $00                                     ; $713B
    ld [wMode06_State10_D380], a                  ; $713D
    ld a, $00                                     ; $7140
    ld [wMode06_State10_D381], a                  ; $7142
    call Print_SetFrameSide                       ; $7145
    call Print_LoadFrameGfx                       ; $7148
    ld b, BANK(Text_CopyBigLine)                  ; $714B
    ld hl, Text_CopyBigLine                       ; $714D
    call Far_Call                                 ; $7150
    ld a, $25                                     ; $7153
    ld [wPrintScript_NextState_D93B], a           ; $7155
    ld a, $6a                                     ; $7158
    ld [wPrintScript_NextState_D93C], a           ; $715A
    ld a, $19                                     ; $715D
    ldh [hState], a                               ; $715F
    ret                                           ; $7161


; C: handler of state $16 of mode $06 (word 22 of Mode06_StateTable)
Mode06_State16::
    di                                            ; $7162
    ld b, BANK(Objects_ClearAll)                  ; $7163
    ld hl, Objects_ClearAll                       ; $7165
    call Far_Call                                 ; $7168
    call Lcd_Off                                  ; $716B
    call Oam_ClearShadow                          ; $716E
    ld b, BANK(ScriptSlots_Clear)                 ; $7171
    ld hl, ScriptSlots_Clear                      ; $7173
    call Far_Call                                 ; $7176
    call Serial_SetFarCallback                    ; $7179

    dwb Frame_UpdateAll

    ld a, $01                                     ; $717F
    ld [wMode06_State24_D3F9], a                  ; $7181
    xor a                                         ; $7184
    ld [wMode06_State23_D94F], a                  ; $7185
    xor a                                         ; $7188
    ld [wMode06_State10_D951], a                  ; $7189
    ld a, $07                                     ; $718C
    ld [wMode06_State10_D950], a                  ; $718E
    ld a, $10                                     ; $7191
    ld [wMode06_State10_D380], a                  ; $7193
    ld a, $00                                     ; $7196
    ld [wMode06_State10_D381], a                  ; $7198
    call Print_LoadItemPicture                    ; $719B
    ld a, $2b                                     ; $719E
    ld [wPrintScript_NextState_D93B], a           ; $71A0
    ld a, $6a                                     ; $71A3
    ld [wPrintScript_NextState_D93C], a           ; $71A5
    ld b, BANK(IdCard_DrawNameToPrintBuf)         ; $71A8
    ld hl, IdCard_DrawNameToPrintBuf              ; $71AA
    call Far_Call                                 ; $71AD
    ld b, BANK(IdCard_DrawBirthdayToPrintBuf)     ; $71B0
    ld hl, IdCard_DrawBirthdayToPrintBuf          ; $71B2
    call Far_Call                                 ; $71B5
    ld b, BANK(IdCard_DrawBloodTypeToPrintBuf)    ; $71B8
    ld hl, IdCard_DrawBloodTypeToPrintBuf         ; $71BA
    call Far_Call                                 ; $71BD
    ld b, BANK(IdCard_DrawSexToPrintBuf)          ; $71C0
    ld hl, IdCard_DrawSexToPrintBuf               ; $71C2
    call Far_Call                                 ; $71C5
    jp Mode06_State18                             ; $71C8


; C: handler of state $17 of mode $06 (word 23 of Mode06_StateTable)
Mode06_State17::
    ld b, BANK(Objects_ClearAll)                  ; $71CB
    ld hl, Objects_ClearAll                       ; $71CD
    call Far_Call                                 ; $71D0
    ld hl, wLcdcShadow                            ; $71D3
    res 7, [hl]                                   ; $71D6
    ld hl, $ff40                                  ; $71D8

jr_001_71db:
    bit 7, [hl]                                   ; $71DB
    jr nz, jr_001_71db                            ; $71DD

    call Oam_ClearShadow                          ; $71DF
    ld b, BANK(ScriptSlots_Clear)                 ; $71E2
    ld hl, ScriptSlots_Clear                      ; $71E4
    call Far_Call                                 ; $71E7
    ld a, $01                                     ; $71EA
    ld [wMode06_State10_D951], a                  ; $71EC
    ld a, $03                                     ; $71EF
    ld [wMode06_State10_D950], a                  ; $71F1
    ld a, $00                                     ; $71F4
    ld [wMode06_State10_D380], a                  ; $71F6
    ld a, $03                                     ; $71F9
    ld [wMode06_State10_D381], a                  ; $71FB
    call Copy_FarInline                           ; $71FE

    db $00, $78, $1e, $00, $c0, $00, $04

    ld a, $b0                                     ; $7208
    ld [wPrint_StreamFromD3F4], a                 ; $720A
    ld a, $69                                     ; $720D
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $720F
    ld a, $31                                     ; $7212
    ld [wPrint_SetFrameSide_D3F6], a              ; $7214
    ld a, $31                                     ; $7217
    ld [wPrintScript_NextState_D93B], a           ; $7219
    ld a, $6a                                     ; $721C
    ld [wPrintScript_NextState_D93C], a           ; $721E
    ld a, $19                                     ; $7221
    ldh [hState], a                               ; $7223
    ret                                           ; $7225


; C: handler of state $18 of mode $06 (word 24 of Mode06_StateTable)
Mode06_State18::
    call Copy_FarInline                           ; $7226

    db $00, $68, $0e, $00, $80, $00, $18

    call Copy_FarInline                           ; $7230

    db $b0, $67, $2f, $00, $98, $c0, $01

    ld a, [wPrintScript_NextState_D93B]           ; $723A
    ld l, a                                       ; $723D
    ld a, [wPrintScript_NextState_D93C]           ; $723E
    ld h, a                                       ; $7241
    ld a, [hl+]                                   ; $7242
    and a                                         ; $7243
    jr z, jr_001_7252                             ; $7244

    call Copy_FarInline                           ; $7246

    db $70, $6a, $2f, $00, $9c, $80, $00

    jr jr_001_725c                                ; $7250

jr_001_7252:
    call Copy_FarInline                           ; $7252

    db $70, $69, $2f, $00, $9c, $80, $00

jr_001_725c:
    xor a                                         ; $725C
    ld [wFrame_UpdateAll_D8E5], a                 ; $725D
    ld a, $01                                     ; $7260
    ld [wFrame_UpdateAll_DD40], a                 ; $7262
    call Lcd_SetupInline                          ; $7265

    db $e7, $e4, $e4, $d0, $88, $00, $00, $70, $ff, $00, $09

    push af                                       ; $7273
    ld a, MUSIC_PRINTING_06_18                    ; $7274
    ld [wSndMusicReq], a                          ; $7276
    pop af                                        ; $7279
    ei                                            ; $727A
    ld b, MODE_PRINTING                           ; $727B
    ld c, $1a                                     ; $727D
    call Fade_GoTo                                ; $727F
    ret                                           ; $7282


; C: handler of state $19 of mode $06 (word 25 of Mode06_StateTable)
Mode06_State19::
    call Copy_FarInline                           ; $7283

    db $00, $68, $0e, $00, $80, $00, $18

    call Copy_FarInline                           ; $728D

    db $b0, $67, $2f, $00, $98, $c0, $01

    ld a, [wPrintScript_NextState_D93B]           ; $7297
    ld l, a                                       ; $729A
    ld a, [wPrintScript_NextState_D93C]           ; $729B
    ld h, a                                       ; $729E
    ld a, [hl+]                                   ; $729F
    and a                                         ; $72A0
    jr z, jr_001_72af                             ; $72A1

    call Copy_FarInline                           ; $72A3

    db $70, $6a, $2f, $00, $9c, $80, $00

    jr jr_001_72b9                                ; $72AD

jr_001_72af:
    call Copy_FarInline                           ; $72AF

    db $70, $69, $2f, $00, $9c, $80, $00

jr_001_72b9:
    call Lcd_SetupInlineNoIE                      ; $72B9

    db $e7, $e4, $e4, $d0, $88, $00, $00, $70, $ff, $00

    push af                                       ; $72C6
    ld a, MUSIC_PRINTING_06_18                    ; $72C7
    ld [wSndMusicReq], a                          ; $72C9
    pop af                                        ; $72CC
    ld b, MODE_PRINTING                           ; $72CD
    ld c, $1a                                     ; $72CF
    call Fade_GoTo                                ; $72D1
    ret                                           ; $72D4


; C: handler of state $1A of mode $06 (word 26 of Mode06_StateTable)
Mode06_State1A::
    ld a, [wFadeRunning]                          ; $72D5
    and a                                         ; $72D8
    ret nz                                        ; $72D9

    call Prn_SendInit                             ; $72DA
    cp $f0                                        ; $72DD
    ret z                                         ; $72DF

    cp $ff                                        ; $72E0
    jp z, Jump_001_690c                           ; $72E2

    ld a, [wPrnDevId]                             ; $72E5
    cp $81                                        ; $72E8
    jp nz, Jump_001_690c                          ; $72EA

    xor a                                         ; $72ED
    ld [wMode06_State1C_D3F7], a                  ; $72EE
    ld [wPrintLastBand], a                        ; $72F1
    ld [wPrintLastPage], a                        ; $72F4
    ld a, [wPrintScript_NextState_D93B]           ; $72F7
    ld l, a                                       ; $72FA
    ld a, [wPrintScript_NextState_D93C]           ; $72FB
    ld h, a                                       ; $72FE
    ld a, [hl+]                                   ; $72FF
    push af                                       ; $7300
    ld a, [hl+]                                   ; $7301
    ld [wMode06_State1A_D939], a                  ; $7302
    ld a, [hl+]                                   ; $7305
    ld [wMode06_State1A_D93A], a                  ; $7306
    ld a, l                                       ; $7309
    ld [wPrintScript_NextState_D93B], a           ; $730A
    ld a, h                                       ; $730D
    ld [wPrintScript_NextState_D93C], a           ; $730E
    pop af                                        ; $7311
    and a                                         ; $7312
    jr z, jr_001_7323                             ; $7313

    ld de, ObjScript_02_6F60_Mode06_Printing_State1F + $6 ; $7315
    call Object_Create                            ; $7318
    ld de, ObjScript_02_7044_Mode06_Printing_State1F + $E ; $731B
    call Object_Create                            ; $731E
    jr jr_001_7335                                ; $7321

jr_001_7323:
    ld de, ObjScript_02_6F1A_Mode06_Printing_State1F ; $7323
    call Object_Create                            ; $7326
    ld de, ObjScript_02_6F60_Mode06_Printing_State1F ; $7329
    call Object_Create                            ; $732C
    ld de, ObjScript_02_7023_Mode06_Printing_State1F ; $732F
    call Object_Create                            ; $7332

jr_001_7335:
    call PrintScript_NextState                    ; $7335
    call ModeState_Set                            ; $7338
    ret                                           ; $733B


; C: handler of state $1B of mode $06 (word 27 of Mode06_StateTable)
Mode06_State1B::
    ld a, [wMode06_State00_D3A2]                  ; $733C
    sla a                                         ; $733F
    ld c, a                                       ; $7341
    ld b, $00                                     ; $7342
    ld hl, Mode1D_CopyDescriptors_Tbl6050 + $780  ; $7344
    add hl, bc                                    ; $7347
    ld a, [hl+]                                   ; $7348
    ld h, [hl]                                    ; $7349
    ld l, a                                       ; $734A
    ld a, [wPrint_StreamFromD3F4]                 ; $734B
    ld c, a                                       ; $734E
    ld a, [wPrint_StreamFromD3F4_D3F5]            ; $734F
    ld b, a                                       ; $7352
    push bc                                       ; $7353
    add hl, bc                                    ; $7354
    ld a, $01                                     ; $7355
    ld de, wPrintBandDesc                         ; $7357
    ld c, $14                                     ; $735A
    call Mode1D_CopyDescriptors                   ; $735C
    pop hl                                        ; $735F
    ld bc, $0050                                  ; $7360
    add hl, bc                                    ; $7363
    ld a, l                                       ; $7364
    ld [wPrint_StreamFromD3F4], a                 ; $7365
    ld a, h                                       ; $7368
    ld [wPrint_StreamFromD3F4_D3F5], a            ; $7369
    call Mode1D_RenderBand                        ; $736C
    ld a, $1f                                     ; $736F
    ldh [hState], a                               ; $7371
    ret                                           ; $7373


; C: handler of state $1C of mode $06 (word 28 of Mode06_StateTable)
Mode06_State1C::
    call Print_StreamFromD3F4                     ; $7374
    ld a, [wMode06_State1C_D3F7]                  ; $7377
    inc a                                         ; $737A
    ld [wMode06_State1C_D3F7], a                  ; $737B
    cp $04                                        ; $737E
    jr nz, jr_001_738f                            ; $7380

    push af                                       ; $7382
    call Print_LoadFrameGfx                       ; $7383
    ld b, BANK(Digits_CopyDA60)                   ; $7386
    ld hl, Digits_CopyDA60                        ; $7388
    call Far_Call                                 ; $738B
    pop af                                        ; $738E

jr_001_738f:
    cp $09                                        ; $738F
    jr nz, jr_001_7398                            ; $7391

    ld a, $01                                     ; $7393
    ld [wPrintLastBand], a                        ; $7395

jr_001_7398:
    ld a, $1f                                     ; $7398
    ldh [hState], a                               ; $739A
    ret                                           ; $739C


; C: handler of state $1D of mode $06 (word 29 of Mode06_StateTable)
Mode06_State1D::
    call Print_StreamFromD3F4                     ; $739D
    ld a, [wMode06_State1C_D3F7]                  ; $73A0
    inc a                                         ; $73A3
    ld [wMode06_State1C_D3F7], a                  ; $73A4
    cp $07                                        ; $73A7
    jr nz, jr_001_73b0                            ; $73A9

    ld a, $01                                     ; $73AB
    ld [wPrintLastBand], a                        ; $73AD

jr_001_73b0:
    ld a, $1f                                     ; $73B0
    ldh [hState], a                               ; $73B2
    ret                                           ; $73B4


; C: handler of state $1E of mode $06 (word 30 of Mode06_StateTable)
Mode06_State1E::
    call Print_StreamFromD3F4                     ; $73B5
    ld a, [wMode06_State1C_D3F7]                  ; $73B8
    inc a                                         ; $73BB
    ld [wMode06_State1C_D3F7], a                  ; $73BC
    cp $01                                        ; $73BF
    jr nz, jr_001_73cb                            ; $73C1

    ld a, $01                                     ; $73C3
    ld [wPrintLastBand], a                        ; $73C5
    ld [wPrintLastPage], a                        ; $73C8

jr_001_73cb:
    ld a, $1f                                     ; $73CB
    ldh [hState], a                               ; $73CD
    ret                                           ; $73CF


; C: handler of state $1F of mode $06 (word 31 of Mode06_StateTable)
Mode06_State1F::
    ld a, [wFadeRunning]                          ; $73D0
    and a                                         ; $73D3
    ret nz                                        ; $73D4

    ld a, [wPrintLastBand]                        ; $73D5
    ld [wPrn_SendData_Abort_DD3C], a              ; $73D8
    ld hl, $d100                                  ; $73DB
    ld a, $01                                     ; $73DE
    call Prn_SendData                             ; $73E0
    cp $ff                                        ; $73E3
    jp z, Jump_001_690c                           ; $73E5

    cp $f0                                        ; $73E8
    jr nz, jr_001_73f9                            ; $73EA

    ld a, [wMode07_StateTable_D8E0]               ; $73EC
    bit 2, a                                      ; $73EF
    jp nz, Jump_001_68fd                          ; $73F1

    bit 1, a                                      ; $73F4
    jr nz, jr_001_740b                            ; $73F6

    ret                                           ; $73F8


jr_001_73f9:
    ld a, [wPrintLastBand]                        ; $73F9
    and a                                         ; $73FC
    jr z, jr_001_7404                             ; $73FD

    ld a, $21                                     ; $73FF
    ldh [hState], a                               ; $7401
    ret                                           ; $7403


jr_001_7404:
    call PrintScript_SameState                    ; $7404
    call ModeState_Set                            ; $7407
    ret                                           ; $740A


jr_001_740b:
    ld a, $20                                     ; $740B
    ldh [hState], a                               ; $740D
    ret                                           ; $740F


; C: handler of state $20 of mode $06 (word 32 of Mode06_StateTable)
Mode06_State20::
    ld a, [wMode07_StateTable_D8E0]               ; $7410
    bit 2, a                                      ; $7413
    jp nz, Jump_001_68fd                          ; $7415

    ret                                           ; $7418


; C: handler of state $21 of mode $06 (word 33 of Mode06_StateTable)
Mode06_State21::
    ld a, [wMode07_StateTable_D8E0]               ; $7419
    bit 2, a                                      ; $741C
    jp nz, Jump_001_68fd                          ; $741E

    ld a, [wMode07_StateTable_D8E0]               ; $7421
    bit 3, a                                      ; $7424
    jr z, jr_001_742f                             ; $7426

    call PrintScript_NextState                    ; $7428
    call ModeState_Set                            ; $742B
    ret                                           ; $742E


jr_001_742f:
    ret                                           ; $742F


; C: handler of state $22 of mode $06 (word 34 of Mode06_StateTable)
Mode06_State22::
    ld a, [wFadeRunning]                          ; $7430
    and a                                         ; $7433
    ret nz                                        ; $7434

    ld a, $01                                     ; $7435
    ld [wPrnSheets], a                            ; $7437
    ld bc, $0000                                  ; $743A
    ld a, [wMode06_State24_D3F9]                  ; $743D
    and a                                         ; $7440
    jr z, jr_001_7447                             ; $7441

    ld a, [wMode06_State10_D380]                  ; $7443
    ld b, a                                       ; $7446

jr_001_7447:
    ld a, [wPrintLastPage]                        ; $7447
    and a                                         ; $744A
    jr z, jr_001_7451                             ; $744B

    ld a, [wMode06_State10_D381]                  ; $744D
    ld c, a                                       ; $7450

jr_001_7451:
    ld a, b                                       ; $7451
    or c                                          ; $7452
    ld [wPrnMargin], a                            ; $7453
    ld a, $e4                                     ; $7456
    ld [wPrnPalette], a                           ; $7458
    call Prn_SendPrint                            ; $745B
    cp $ff                                        ; $745E
    jp z, Jump_001_690c                           ; $7460

    cp $f0                                        ; $7463
    ret z                                         ; $7465

    ld b, MODE_PRINTING                           ; $7466
    ld c, $23                                     ; $7468
    call Fade_GoToB                               ; $746A
    ret                                           ; $746D


; C: handler of state $23 of mode $06 (word 35 of Mode06_StateTable)
Mode06_State23::
    rst Rst08_WaitVBlank                          ; $746E
    ld a, [wPrnPollCnt]                           ; $746F
    cp $01                                        ; $7472
    jr nz, Mode06_State23                         ; $7474

    ld b, BANK(Objects_ClearAll)                  ; $7476
    ld hl, Objects_ClearAll                       ; $7478
    call Far_Call                                 ; $747B
    ld hl, wLcdcShadow                            ; $747E
    res 7, [hl]                                   ; $7481
    ld hl, $ff40                                  ; $7483

jr_001_7486:
    bit 7, [hl]                                   ; $7486
    jr nz, jr_001_7486                            ; $7488

    call Oam_ClearShadow                          ; $748A
    ld b, BANK(ScriptSlots_Clear)                 ; $748D
    ld hl, ScriptSlots_Clear                      ; $748F
    call Far_Call                                 ; $7492
    ld a, $03                                     ; $7495
    ld [wPrnPollCnt], a                           ; $7497
    call Lcd_SetupInlineNoIE                      ; $749A

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00

    ld de, Gfx_18_5800_Unused_Mode18_State00      ; $74A7
    ld a, $18                                     ; $74AA
    ld hl, $8000                                  ; $74AC
    ld bc, $1800                                  ; $74AF
    call Vram_CopyHBlankFar                       ; $74B2
    ld b, BANK(PrintGame_DrawAppleCount)          ; $74B5
    ld hl, PrintGame_DrawAppleCount               ; $74B7
    call Far_Call                                 ; $74BA
    ld de, Map_32_7800_Mode1B_PrintingAppleGame_State00 ; $74BD
    ld a, $32                                     ; $74C0
    ld hl, $9800                                  ; $74C2
    ld bc, $0240                                  ; $74C5
    call Vram_CopyHBlankFar                       ; $74C8
    push af                                       ; $74CB
    ld a, MUSIC_PRINTING_06_23                    ; $74CC
    ld [wSndMusicReq], a                          ; $74CE
    pop af                                        ; $74D1
    ld a, [wMode06_State23_D94F]                  ; $74D2
    ld de, $97a0                                  ; $74D5
    ld b, BANK(Number_DrawTwoDigits)              ; $74D8
    ld hl, Number_DrawTwoDigits                   ; $74DA
    call Far_CallKeepA                            ; $74DD
    ld a, [wPrintGameRecord]                      ; $74E0
    ld de, $97d0                                  ; $74E3
    ld b, BANK(Number_DrawTwoDigits)              ; $74E6
    ld hl, Number_DrawTwoDigits                   ; $74E8
    call Far_CallKeepA                            ; $74EB
    ld a, [wMode06_State10_D951]                  ; $74EE
    and a                                         ; $74F1
    jr z, jr_001_752c                             ; $74F2

    push hl                                       ; $74F4
    ld hl, wMode06_State0A_D896                   ; $74F5
    set 0, [hl]                                   ; $74F8
    pop hl                                        ; $74FA
    ld a, [wMode06_State23_D94F]                  ; $74FB
    call Bin_ToBcd                                ; $74FE
    ld e, c                                       ; $7501
    ld d, b                                       ; $7502
    ld b, BANK(Kitts_Add)                         ; $7503
    ld hl, Kitts_Add                              ; $7505
    call Far_Call                                 ; $7508
    push hl                                       ; $750B
    ld hl, wMode06_State0A_D896                   ; $750C
    res 0, [hl]                                   ; $750F
    pop hl                                        ; $7511
    ld de, ObjScript_02_77DE_Mode03_ViewAlbum_State0B + $6 ; $7512
    call Object_Create                            ; $7515
    ld de, ObjScript_02_734F_Object_RunAll + $A   ; $7518
    call Object_Create                            ; $751B
    ld de, ObjScript_02_7044_Mode06_Printing_State1F + $1C ; $751E
    call Object_Create                            ; $7521
    ld de, ObjScript_02_7345_Mode06_Printing_State24 ; $7524
    call Object_Create                            ; $7527
    jr jr_001_7544                                ; $752A

jr_001_752c:
    ld de, ObjScript_02_75F0_Mode06_Printing_State24 ; $752C
    call Object_Create                            ; $752F
    ld de, ObjScript_02_7044_Mode06_Printing_State1F + $1C ; $7532
    call Object_Create                            ; $7535
    ld de, ObjScript_02_7345_Mode06_Printing_State24 ; $7538
    call Object_Create                            ; $753B
    ld de, ObjScript_02_71F2_Mode06_Printing_State24 ; $753E
    call Object_Create                            ; $7541

jr_001_7544:
    call PrintScript_NextState                    ; $7544
    call Fade_GoTo                                ; $7547
    ret                                           ; $754A


; C: handler of state $24 of mode $06 (word 36 of Mode06_StateTable)
Mode06_State24::
    ld a, [wPrnStatus]                            ; $754B
    ld b, a                                       ; $754E
    cp $ff                                        ; $754F
    jp z, Jump_001_690c                           ; $7551

    and $f0                                       ; $7554
    jp nz, Jump_001_690c                          ; $7556

    bit 1, b                                      ; $7559
    ret nz                                        ; $755B

    push hl                                       ; $755C
    ld hl, wMode06_State0A_D896                   ; $755D
    set 0, [hl]                                   ; $7560
    pop hl                                        ; $7562
    ld b, BANK(Counters_AddPrinted)               ; $7563
    ld hl, Counters_AddPrinted                    ; $7565
    call Far_Call                                 ; $7568
    push hl                                       ; $756B
    ld hl, wMode06_State0A_D896                   ; $756C
    res 0, [hl]                                   ; $756F
    pop hl                                        ; $7571
    ld a, [wMode06_State24_D3FC]                  ; $7572
    bit 0, a                                      ; $7575
    jr z, jr_001_7591                             ; $7577

    xor a                                         ; $7579
    ld [wMode06_State24_D3F9], a                  ; $757A
    ld [wMode06_State24_D3FC], a                  ; $757D
    ld [wMode06_State1C_D3F7], a                  ; $7580
    ld [wPrintLastBand], a                        ; $7583
    ld [wPrintLastPage], a                        ; $7586
    ld b, MODE_PRINTING                           ; $7589
    ld c, $15                                     ; $758B
    call Fade_GoToB                               ; $758D
    ret                                           ; $7590


jr_001_7591:
    xor a                                         ; $7591
    ld [wMode06_State24_D3F9], a                  ; $7592
    ld [wMode06_State24_D3FC], a                  ; $7595
    ld [wMode06_State1C_D3F7], a                  ; $7598
    ld [wPrintLastBand], a                        ; $759B
    ld [wPrintLastPage], a                        ; $759E
    ld b, MODE_PRINTING                           ; $75A1
    ld c, $17                                     ; $75A3
    call Fade_GoToB                               ; $75A5
    ret                                           ; $75A8


; C: handler of state $25 of mode $06 (word 37 of Mode06_StateTable)
Mode06_State25::
    ld a, [wPrnStatus]                            ; $75A9
    ld b, a                                       ; $75AC
    cp $ff                                        ; $75AD
    jp z, Jump_001_690c                           ; $75AF

    and $f0                                       ; $75B2
    jp nz, Jump_001_690c                          ; $75B4

    bit 1, b                                      ; $75B7
    ret nz                                        ; $75B9

    xor a                                         ; $75BA
    ld [wMode06_State24_D3F9], a                  ; $75BB
    ld [wMode06_State1C_D3F7], a                  ; $75BE
    ld [wPrintLastBand], a                        ; $75C1
    ld [wPrintLastPage], a                        ; $75C4
    ld b, MODE_PRINTING                           ; $75C7
    ld c, $12                                     ; $75C9
    call Fade_GoToB                               ; $75CB
    ret                                           ; $75CE


; C: handler of state $26 of mode $06 (word 38 of Mode06_StateTable)
Mode06_State26::
    ld a, [wPrnStatus]                            ; $75CF
    ld b, a                                       ; $75D2
    cp $ff                                        ; $75D3
    jp z, Jump_001_690c                           ; $75D5

    and $f0                                       ; $75D8
    jp nz, Jump_001_690c                          ; $75DA

    bit 1, b                                      ; $75DD
    ret nz                                        ; $75DF

    xor a                                         ; $75E0
    ld [wMode06_State24_D3F9], a                  ; $75E1
    ld [wMode06_State1C_D3F7], a                  ; $75E4
    ld [wPrintLastBand], a                        ; $75E7
    ld [wPrintLastPage], a                        ; $75EA
    ld b, MODE_PRINTING                           ; $75ED
    ld c, $13                                     ; $75EF
    call Fade_GoToB                               ; $75F1
    ret                                           ; $75F4


; C: handler of state $27 of mode $06 (word 39 of Mode06_StateTable)
Mode06_State27::
    ld a, [wPrnStatus]                            ; $75F5
    ld b, a                                       ; $75F8
    cp $ff                                        ; $75F9
    jp z, Jump_001_690c                           ; $75FB

    and $f0                                       ; $75FE
    jp nz, Jump_001_690c                          ; $7600

    bit 1, b                                      ; $7603
    ret nz                                        ; $7605

    push hl                                       ; $7606
    ld hl, wMode06_State0A_D896                   ; $7607
    set 0, [hl]                                   ; $760A
    pop hl                                        ; $760C
    ld b, BANK(Counters_AddPrinted)               ; $760D
    ld hl, Counters_AddPrinted                    ; $760F
    call Far_Call                                 ; $7612
    push hl                                       ; $7615
    ld hl, wMode06_State0A_D896                   ; $7616
    res 0, [hl]                                   ; $7619
    pop hl                                        ; $761B
    ld a, [wMode06_State24_D3FC]                  ; $761C
    bit 0, a                                      ; $761F
    jr z, jr_001_763b                             ; $7621

    xor a                                         ; $7623
    ld [wMode06_State24_D3F9], a                  ; $7624
    ld [wMode06_State24_D3FC], a                  ; $7627
    ld [wMode06_State1C_D3F7], a                  ; $762A
    ld [wPrintLastBand], a                        ; $762D
    ld [wPrintLastPage], a                        ; $7630
    ld b, MODE_PRINTING                           ; $7633
    ld c, $15                                     ; $7635
    call Fade_GoToB                               ; $7637
    ret                                           ; $763A


jr_001_763b:
    xor a                                         ; $763B
    ld [wMode06_State24_D3F9], a                  ; $763C
    ld [wMode06_State24_D3FC], a                  ; $763F
    ld [wMode06_State1C_D3F7], a                  ; $7642
    ld [wPrintLastBand], a                        ; $7645
    ld [wPrintLastPage], a                        ; $7648
    ld b, MODE_PRINTING                           ; $764B
    ld c, $17                                     ; $764D
    call Fade_GoToB                               ; $764F
    ret                                           ; $7652


; C: handler of state $28 of mode $06 (word 40 of Mode06_StateTable)
Mode06_State28::
    ld a, [wPrnStatus]                            ; $7653
    ld b, a                                       ; $7656
    cp $ff                                        ; $7657
    jp z, Jump_001_690c                           ; $7659

    and $f0                                       ; $765C
    jp nz, Jump_001_690c                          ; $765E

    bit 1, b                                      ; $7661
    ret nz                                        ; $7663

    ldh a, [hState]                               ; $7664
    cp $2a                                        ; $7666
    jr z, jr_001_7682                             ; $7668

    xor a                                         ; $766A
    ld [wMode06_State24_D3F9], a                  ; $766B
    ld [wMode06_State24_D3FC], a                  ; $766E
    ld [wMode06_State1C_D3F7], a                  ; $7671
    ld [wPrintLastBand], a                        ; $7674
    ld [wPrintLastPage], a                        ; $7677
    ld b, MODE_PRINTING                           ; $767A
    ld c, $17                                     ; $767C
    call Fade_GoToB                               ; $767E
    ret                                           ; $7681


jr_001_7682:
    call Prn_EngineStop                           ; $7682
    ld a, [wReturnMode]                           ; $7685
    ld b, a                                       ; $7688
    ld a, [wReturnState]                          ; $7689
    ld c, a                                       ; $768C
    call Fade_GoToB                               ; $768D
    ret                                           ; $7690


; C: ModeTable entry $06: BGB screens with the printer helper on the link (06:1F please wait, 06:21, 06:24 the fruit
; game); forced alone it shows an empty frame
Mode06_Printing::
    ldh a, [hState]                               ; $7691
    ld hl, Mode06_StateTable                      ; $7693
    call JumpTable_ByA                            ; $7696
    jp Far_Return                                 ; $7699


; C: state table of mode $06, read by $0189 with hFF8E
Mode06_StateTable::
    dw Mode06_State00
    dw Mode06_State01
    dw Mode06_State02
    dw Mode06_State03
    dw Mode06_State04
    dw Mode06_State05
    dw Mode06_State06
    dw Mode06_State07
    dw Mode06_State08
    dw Mode06_State09
    dw Mode06_State0A
    dw Mode06_State0B
    dw Mode06_State0C
    dw Mode06_State0D
    dw Mode06_State0E
    dw Mode06_State0F
    dw Mode06_State10
    dw Mode06_State11
    dw Mode06_State12
    dw Mode06_State13
    dw Mode06_State14
    dw Mode06_State15
    dw Mode06_State16
    dw Mode06_State17
    dw Mode06_State18
    dw Mode06_State19
    dw Mode06_State1A
    dw Mode06_State1B
    dw Mode06_State1C
    dw Mode06_State1D
    dw Mode06_State1E
    dw Mode06_State1F
    dw Mode06_State20
    dw Mode06_State21
    dw Mode06_State22
    dw Mode06_State23
    dw Mode06_State24
    dw Mode06_State25
    dw Mode06_State26
    dw Mode06_State27
    dw Mode06_State28
    dw Mode06_State28
    dw Mode06_State28

    ; padding
    ds $90e, $00

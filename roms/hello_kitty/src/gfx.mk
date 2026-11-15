# Written by tools/make_source.py: one rule per tile PNG (width 16 tiles; -x = blank tiles at the end of the last row).
GFX := $(BUILD)/data/bank_09/Gfx_09_7FC0_Mode03_ViewAlbum_State0B.2bpp $(BUILD)/data/bank_0b/Gfx_0B_4000_Mode05_StampWindow_State06.2bpp $(BUILD)/data/bank_0b/Gfx_0B_7F00_Mode0A_NameCard_State00.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4000_Mode05_StampWindow_State06.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7A40_Mode03_ViewAlbum_State0B.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7C40_Mode0A_NameCard_State01.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7CE0_Mode0C_RecordBook_State01.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7F80_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6000_Mode03_ViewAlbum_State0A.2bpp $(BUILD)/data/bank_0d/Gfx_0D_7D80_Mode05_StampWindow_State06.2bpp $(BUILD)/data/bank_0d/Gfx_0D_7EC0_Mode05_StampWindow_State06.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4000_Mode05_StampWindow_State06.2bpp $(BUILD)/data/bank_0e/Gfx_0E_6800_Mode06_Printing_State18.2bpp $(BUILD)/data/bank_10/Gfx_10_5EE0_Mode05_StampWindow_State06.2bpp $(BUILD)/data/bank_12/Leftover_12_4000_Tiles.2bpp $(BUILD)/data/bank_12/Gfx_12_40E0_Vram_CopyHBlank.2bpp $(BUILD)/data/bank_13/Gfx_13_4000_Sram_Format.2bpp $(BUILD)/data/bank_13/Gfx_13_5F80_KittHost_InitScreen.2bpp $(BUILD)/data/bank_13/Gfx_13_7780_Mode0E_KittGamesHost_State01.2bpp $(BUILD)/data/bank_14/Gfx_14_4000_Copy_DEtoHL.2bpp $(BUILD)/data/bank_14/Gfx_14_5800_PompompurinPicture.2bpp $(BUILD)/data/bank_15/Gfx_15_4000_Mode03_ViewAlbum_State00.2bpp $(BUILD)/data/bank_15/Gfx_15_44C0_Album_LoadTilesBank15.2bpp $(BUILD)/data/bank_15/Gfx_15_4580_Album_LoadTilesBank15.2bpp $(BUILD)/data/bank_15/Gfx_15_4640_Album_LoadTilesBank15.2bpp $(BUILD)/data/bank_15/Gfx_15_5000_Mode03_ViewAlbum_State02.2bpp $(BUILD)/data/bank_15/Gfx_15_5380_Mode03_ViewAlbum_State02.2bpp $(BUILD)/data/bank_15/Gfx_15_5440_Album_LoadTilesBank15.2bpp $(BUILD)/data/bank_15/Gfx_15_5500_Album_LoadTilesBank15.2bpp $(BUILD)/data/bank_15/Gfx_15_5800_Mode00_BootAndTitle_State00.2bpp $(BUILD)/data/bank_17/Gfx_17_4000_Photos_LoadPage8.2bpp $(BUILD)/data/bank_17/Gfx_17_5800_Mode01_MainMenu_State00.2bpp $(BUILD)/data/bank_17/Gfx_17_7000_Mode08_ExchangePhotoTrain_State00.2bpp $(BUILD)/data/bank_17/Gfx_17_7800_NeverRead.2bpp $(BUILD)/data/bank_1c/Gfx_1C_6BC0_Mode14_MessageScreen_State01.2bpp $(BUILD)/data/bank_1c/Gfx_1C_7E40_Mode0A_NameCard_State03.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4000_Mode12_SlideShow_State00.2bpp $(BUILD)/data/bank_1d/Gfx_1D_5600_Mode09_ExchangeCommunicating_State03.2bpp $(BUILD)/data/bank_1d/Gfx_1D_6B00_Mode07_Exchange_State00.2bpp $(BUILD)/data/bank_1d/Gfx_1D_7F40_Mode0B_NameCardEdit_State0A.2bpp $(BUILD)/data/bank_1e/Gfx_1E_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_1e/Gfx_1E_7800_Mode00_BootAndTitle_State04.2bpp $(BUILD)/data/bank_1f/Gfx_1F_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_20/Gfx_20_4000_IdCard_NameGlyphAddr.2bpp $(BUILD)/data/bank_21/Gfx_21_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_22/Gfx_22_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_22/Gfx_22_6240_Mode03_ViewAlbum_State00.2bpp $(BUILD)/data/bank_22/Gfx_22_6850_Mode05_StampWindow_State06.2bpp $(BUILD)/data/bank_23/Gfx_23_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_23/Gfx_23_4E00_Mode10_ScratchCard_State02.2bpp $(BUILD)/data/bank_23/Gfx_23_7350_Mode02_TakePhotos_State00.2bpp $(BUILD)/data/bank_23/Gfx_23_7450_Mode0A_NameCard_State00.2bpp $(BUILD)/data/bank_23/Gfx_23_7D50_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_24/Gfx_24_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_24/Gfx_24_6A00_Puzzle15_LoadGfx.2bpp $(BUILD)/data/bank_24/Gfx_24_6BC0_Mode0F_FifteenPuzzle_State00.2bpp $(BUILD)/data/bank_24/Gfx_24_7000_Puzzle15_LoadGfx.2bpp $(BUILD)/data/bank_24/Gfx_24_7200_Puzzle15_LoadGfx.2bpp $(BUILD)/data/bank_24/Gfx_24_7400_Mode00_BootAndTitle_State01.2bpp $(BUILD)/data/bank_25/Gfx_25_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_25/Gfx_25_5C00_Mode11_StrawberryChannel_State00.2bpp $(BUILD)/data/bank_25/Gfx_25_63F0_Mode11_StrawberryChannel_State00.2bpp $(BUILD)/data/bank_25/Gfx_25_6600_Mode05_StampWindow_State00.2bpp $(BUILD)/data/bank_25/Gfx_25_6800_Mode05_StampWindow_State00.2bpp $(BUILD)/data/bank_25/Gfx_25_7000_Mode0C_RecordBook_State00.2bpp $(BUILD)/data/bank_26/Gfx_26_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_26/Gfx_26_5C00_Mode03_ViewAlbum_State0A.2bpp $(BUILD)/data/bank_26/Gfx_26_6B80_Mode0A_NameCard_State01.2bpp $(BUILD)/data/bank_27/Gfx_27_75E0_Mode0A_NameCard_State03.2bpp $(BUILD)/data/bank_28/Gfx_28_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_29/Gfx_29_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_2a/Gfx_2A_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_2b/Gfx_2B_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_2c/Gfx_2C_4000_Mode02_TakePhotos_State01.2bpp $(BUILD)/data/bank_2c/Gfx_2C_78D0_Mode09_ExchangeCommunicating_State0C.2bpp $(BUILD)/data/bank_2c/Gfx_2C_7CD0_Mode02_TakePhotos_State01.2bpp $(BUILD)/data/bank_2d/Gfx_2D_4000_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_2d/Gfx_2D_7820_Mode17_PrintError_State00.2bpp $(BUILD)/data/bank_2d/Gfx_2D_7C20_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_2f/Gfx_2F_63E0_Mode02_TakePhotos_State01.2bpp $(BUILD)/data/bank_2f/Gfx_2F_67B0_Mode06_Printing_State18.2bpp $(BUILD)/data/bank_2f/Gfx_2F_6970_Mode06_Printing_State18.2bpp $(BUILD)/data/bank_2f/Gfx_2F_69F0_Mode06_Printing_State1F.2bpp $(BUILD)/data/bank_2f/Gfx_2F_6B70_Mode0A_NameCard_State01.2bpp $(BUILD)/data/bank_30/Gfx_30_7FA0_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_31/Gfx_31_4E00_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_31/Gfx_31_64F0_Unused_Link_LoadTiles.2bpp $(BUILD)/data/bank_31/Gfx_31_6770_Mode00_BootAndTitle_State04.2bpp $(BUILD)/data/bank_31/Gfx_31_73C0_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_31/Gfx_31_75F0_Mode02_TakePhotos_State00.2bpp $(BUILD)/data/bank_31/Gfx_31_7830_Mode00_BootAndTitle_State01.2bpp $(BUILD)/data/bank_32/Gfx_32_7EC0_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_33/Gfx_33_6E50_Mode0B_NameCardEdit_State0C.2bpp $(BUILD)/data/bank_35/Gfx_35_6A00_Mode11_StrawberryChannel_State07.2bpp $(BUILD)/data/bank_35/Gfx_35_7F70_Mode02_TakePhotos_State08.2bpp $(BUILD)/data/bank_38/Gfx_38_4000_Mode11_StrawberryChannel_State04.2bpp

$(BUILD)/data/bank_09/Gfx_09_7FC0_Mode03_ViewAlbum_State0B.2bpp: $(SRC)/data/bank_09/Gfx_09_7FC0_Mode03_ViewAlbum_State0B.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0b/Gfx_0B_4000_Mode05_StampWindow_State06.2bpp: $(SRC)/data/bank_0b/Gfx_0B_4000_Mode05_StampWindow_State06.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0b/Gfx_0B_7F00_Mode0A_NameCard_State00.2bpp: $(SRC)/data/bank_0b/Gfx_0B_7F00_Mode0A_NameCard_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4000_Mode05_StampWindow_State06.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4000_Mode05_StampWindow_State06.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7A40_Mode03_ViewAlbum_State0B.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7A40_Mode03_ViewAlbum_State0B.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7C40_Mode0A_NameCard_State01.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7C40_Mode0A_NameCard_State01.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7CE0_Mode0C_RecordBook_State01.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7CE0_Mode0C_RecordBook_State01.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7F80_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7F80_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6000_Mode03_ViewAlbum_State0A.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6000_Mode03_ViewAlbum_State0A.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_7D80_Mode05_StampWindow_State06.2bpp: $(SRC)/data/bank_0d/Gfx_0D_7D80_Mode05_StampWindow_State06.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_7EC0_Mode05_StampWindow_State06.2bpp: $(SRC)/data/bank_0d/Gfx_0D_7EC0_Mode05_StampWindow_State06.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4000_Mode05_StampWindow_State06.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4000_Mode05_StampWindow_State06.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_6800_Mode06_Printing_State18.2bpp: $(SRC)/data/bank_0e/Gfx_0E_6800_Mode06_Printing_State18.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_5EE0_Mode05_StampWindow_State06.2bpp: $(SRC)/data/bank_10/Gfx_10_5EE0_Mode05_StampWindow_State06.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_12/Leftover_12_4000_Tiles.2bpp: $(SRC)/data/bank_12/Leftover_12_4000_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_40E0_Vram_CopyHBlank.2bpp: $(SRC)/data/bank_12/Gfx_12_40E0_Vram_CopyHBlank.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_4000_Sram_Format.2bpp: $(SRC)/data/bank_13/Gfx_13_4000_Sram_Format.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_5F80_KittHost_InitScreen.2bpp: $(SRC)/data/bank_13/Gfx_13_5F80_KittHost_InitScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_7780_Mode0E_KittGamesHost_State01.2bpp: $(SRC)/data/bank_13/Gfx_13_7780_Mode0E_KittGamesHost_State01.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_4000_Copy_DEtoHL.2bpp: $(SRC)/data/bank_14/Gfx_14_4000_Copy_DEtoHL.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_5800_PompompurinPicture.2bpp: $(SRC)/data/bank_14/Gfx_14_5800_PompompurinPicture.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4000_Mode03_ViewAlbum_State00.2bpp: $(SRC)/data/bank_15/Gfx_15_4000_Mode03_ViewAlbum_State00.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_44C0_Album_LoadTilesBank15.2bpp: $(SRC)/data/bank_15/Gfx_15_44C0_Album_LoadTilesBank15.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4580_Album_LoadTilesBank15.2bpp: $(SRC)/data/bank_15/Gfx_15_4580_Album_LoadTilesBank15.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4640_Album_LoadTilesBank15.2bpp: $(SRC)/data/bank_15/Gfx_15_4640_Album_LoadTilesBank15.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5000_Mode03_ViewAlbum_State02.2bpp: $(SRC)/data/bank_15/Gfx_15_5000_Mode03_ViewAlbum_State02.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5380_Mode03_ViewAlbum_State02.2bpp: $(SRC)/data/bank_15/Gfx_15_5380_Mode03_ViewAlbum_State02.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5440_Album_LoadTilesBank15.2bpp: $(SRC)/data/bank_15/Gfx_15_5440_Album_LoadTilesBank15.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5500_Album_LoadTilesBank15.2bpp: $(SRC)/data/bank_15/Gfx_15_5500_Album_LoadTilesBank15.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5800_Mode00_BootAndTitle_State00.2bpp: $(SRC)/data/bank_15/Gfx_15_5800_Mode00_BootAndTitle_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4000_Photos_LoadPage8.2bpp: $(SRC)/data/bank_17/Gfx_17_4000_Photos_LoadPage8.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_5800_Mode01_MainMenu_State00.2bpp: $(SRC)/data/bank_17/Gfx_17_5800_Mode01_MainMenu_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_7000_Mode08_ExchangePhotoTrain_State00.2bpp: $(SRC)/data/bank_17/Gfx_17_7000_Mode08_ExchangePhotoTrain_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_7800_NeverRead.2bpp: $(SRC)/data/bank_17/Gfx_17_7800_NeverRead.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_6BC0_Mode14_MessageScreen_State01.2bpp: $(SRC)/data/bank_1c/Gfx_1C_6BC0_Mode14_MessageScreen_State01.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_7E40_Mode0A_NameCard_State03.2bpp: $(SRC)/data/bank_1c/Gfx_1C_7E40_Mode0A_NameCard_State03.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4000_Mode12_SlideShow_State00.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4000_Mode12_SlideShow_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_5600_Mode09_ExchangeCommunicating_State03.2bpp: $(SRC)/data/bank_1d/Gfx_1D_5600_Mode09_ExchangeCommunicating_State03.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_6B00_Mode07_Exchange_State00.2bpp: $(SRC)/data/bank_1d/Gfx_1D_6B00_Mode07_Exchange_State00.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_7F40_Mode0B_NameCardEdit_State0A.2bpp: $(SRC)/data/bank_1d/Gfx_1D_7F40_Mode0B_NameCardEdit_State0A.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_1e/Gfx_1E_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_7800_Mode00_BootAndTitle_State04.2bpp: $(SRC)/data/bank_1e/Gfx_1E_7800_Mode00_BootAndTitle_State04.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1f/Gfx_1F_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_1f/Gfx_1F_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_4000_IdCard_NameGlyphAddr.2bpp: $(SRC)/data/bank_20/Gfx_20_4000_IdCard_NameGlyphAddr.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_21/Gfx_21_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_22/Gfx_22_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_6240_Mode03_ViewAlbum_State00.2bpp: $(SRC)/data/bank_22/Gfx_22_6240_Mode03_ViewAlbum_State00.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_6850_Mode05_StampWindow_State06.2bpp: $(SRC)/data/bank_22/Gfx_22_6850_Mode05_StampWindow_State06.png
	$(RGBGFX) -x 1 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_23/Gfx_23_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_4E00_Mode10_ScratchCard_State02.2bpp: $(SRC)/data/bank_23/Gfx_23_4E00_Mode10_ScratchCard_State02.png
	$(RGBGFX) -x 11 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_7350_Mode02_TakePhotos_State00.2bpp: $(SRC)/data/bank_23/Gfx_23_7350_Mode02_TakePhotos_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_7450_Mode0A_NameCard_State00.2bpp: $(SRC)/data/bank_23/Gfx_23_7450_Mode0A_NameCard_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_7D50_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_23/Gfx_23_7D50_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 5 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_24/Gfx_24_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_6A00_Puzzle15_LoadGfx.2bpp: $(SRC)/data/bank_24/Gfx_24_6A00_Puzzle15_LoadGfx.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_6BC0_Mode0F_FifteenPuzzle_State00.2bpp: $(SRC)/data/bank_24/Gfx_24_6BC0_Mode0F_FifteenPuzzle_State00.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_7000_Puzzle15_LoadGfx.2bpp: $(SRC)/data/bank_24/Gfx_24_7000_Puzzle15_LoadGfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_7200_Puzzle15_LoadGfx.2bpp: $(SRC)/data/bank_24/Gfx_24_7200_Puzzle15_LoadGfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_7400_Mode00_BootAndTitle_State01.2bpp: $(SRC)/data/bank_24/Gfx_24_7400_Mode00_BootAndTitle_State01.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_25/Gfx_25_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_5C00_Mode11_StrawberryChannel_State00.2bpp: $(SRC)/data/bank_25/Gfx_25_5C00_Mode11_StrawberryChannel_State00.png
	$(RGBGFX) -x 1 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_63F0_Mode11_StrawberryChannel_State00.2bpp: $(SRC)/data/bank_25/Gfx_25_63F0_Mode11_StrawberryChannel_State00.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_6600_Mode05_StampWindow_State00.2bpp: $(SRC)/data/bank_25/Gfx_25_6600_Mode05_StampWindow_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_6800_Mode05_StampWindow_State00.2bpp: $(SRC)/data/bank_25/Gfx_25_6800_Mode05_StampWindow_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_7000_Mode0C_RecordBook_State00.2bpp: $(SRC)/data/bank_25/Gfx_25_7000_Mode0C_RecordBook_State00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_26/Gfx_26_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_26/Gfx_26_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_26/Gfx_26_5C00_Mode03_ViewAlbum_State0A.2bpp: $(SRC)/data/bank_26/Gfx_26_5C00_Mode03_ViewAlbum_State0A.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_26/Gfx_26_6B80_Mode0A_NameCard_State01.2bpp: $(SRC)/data/bank_26/Gfx_26_6B80_Mode0A_NameCard_State01.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_27/Gfx_27_75E0_Mode0A_NameCard_State03.2bpp: $(SRC)/data/bank_27/Gfx_27_75E0_Mode0A_NameCard_State03.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_28/Gfx_28_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_29/Gfx_29_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_29/Gfx_29_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_2a/Gfx_2A_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_2a/Gfx_2A_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_2b/Gfx_2B_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_2b/Gfx_2B_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_2c/Gfx_2C_4000_Mode02_TakePhotos_State01.2bpp: $(SRC)/data/bank_2c/Gfx_2C_4000_Mode02_TakePhotos_State01.png
	$(RGBGFX) -x 3 -o $@ $<

$(BUILD)/data/bank_2c/Gfx_2C_78D0_Mode09_ExchangeCommunicating_State0C.2bpp: $(SRC)/data/bank_2c/Gfx_2C_78D0_Mode09_ExchangeCommunicating_State0C.png
	$(RGBGFX) -x 2 -o $@ $<

$(BUILD)/data/bank_2c/Gfx_2C_7CD0_Mode02_TakePhotos_State01.2bpp: $(SRC)/data/bank_2c/Gfx_2C_7CD0_Mode02_TakePhotos_State01.png
	$(RGBGFX) -x 13 -o $@ $<

$(BUILD)/data/bank_2d/Gfx_2D_4000_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_2d/Gfx_2D_4000_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_2d/Gfx_2D_7820_Mode17_PrintError_State00.2bpp: $(SRC)/data/bank_2d/Gfx_2D_7820_Mode17_PrintError_State00.png
	$(RGBGFX) -x 2 -o $@ $<

$(BUILD)/data/bank_2d/Gfx_2D_7C20_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_2d/Gfx_2D_7C20_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 2 -o $@ $<

$(BUILD)/data/bank_2f/Gfx_2F_63E0_Mode02_TakePhotos_State01.2bpp: $(SRC)/data/bank_2f/Gfx_2F_63E0_Mode02_TakePhotos_State01.png
	$(RGBGFX) -x 3 -o $@ $<

$(BUILD)/data/bank_2f/Gfx_2F_67B0_Mode06_Printing_State18.2bpp: $(SRC)/data/bank_2f/Gfx_2F_67B0_Mode06_Printing_State18.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_2f/Gfx_2F_6970_Mode06_Printing_State18.2bpp: $(SRC)/data/bank_2f/Gfx_2F_6970_Mode06_Printing_State18.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2f/Gfx_2F_69F0_Mode06_Printing_State1F.2bpp: $(SRC)/data/bank_2f/Gfx_2F_69F0_Mode06_Printing_State1F.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2f/Gfx_2F_6B70_Mode0A_NameCard_State01.2bpp: $(SRC)/data/bank_2f/Gfx_2F_6B70_Mode0A_NameCard_State01.png
	$(RGBGFX) -x 7 -o $@ $<

$(BUILD)/data/bank_30/Gfx_30_7FA0_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_30/Gfx_30_7FA0_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_31/Gfx_31_4E00_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_31/Gfx_31_4E00_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 1 -o $@ $<

$(BUILD)/data/bank_31/Gfx_31_64F0_Unused_Link_LoadTiles.2bpp: $(SRC)/data/bank_31/Gfx_31_64F0_Unused_Link_LoadTiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_31/Gfx_31_6770_Mode00_BootAndTitle_State04.2bpp: $(SRC)/data/bank_31/Gfx_31_6770_Mode00_BootAndTitle_State04.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_31/Gfx_31_73C0_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_31/Gfx_31_73C0_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 13 -o $@ $<

$(BUILD)/data/bank_31/Gfx_31_75F0_Mode02_TakePhotos_State00.2bpp: $(SRC)/data/bank_31/Gfx_31_75F0_Mode02_TakePhotos_State00.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_31/Gfx_31_7830_Mode00_BootAndTitle_State01.2bpp: $(SRC)/data/bank_31/Gfx_31_7830_Mode00_BootAndTitle_State01.png
	$(RGBGFX) -x 11 -o $@ $<

$(BUILD)/data/bank_32/Gfx_32_7EC0_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_32/Gfx_32_7EC0_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_33/Gfx_33_6E50_Mode0B_NameCardEdit_State0C.2bpp: $(SRC)/data/bank_33/Gfx_33_6E50_Mode0B_NameCardEdit_State0C.png
	$(RGBGFX) -x 2 -o $@ $<

$(BUILD)/data/bank_35/Gfx_35_6A00_Mode11_StrawberryChannel_State07.2bpp: $(SRC)/data/bank_35/Gfx_35_6A00_Mode11_StrawberryChannel_State07.png
	$(RGBGFX) -x 13 -o $@ $<

$(BUILD)/data/bank_35/Gfx_35_7F70_Mode02_TakePhotos_State08.2bpp: $(SRC)/data/bank_35/Gfx_35_7F70_Mode02_TakePhotos_State08.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_38/Gfx_38_4000_Mode11_StrawberryChannel_State04.2bpp: $(SRC)/data/bank_38/Gfx_38_4000_Mode11_StrawberryChannel_State04.png
	$(RGBGFX) -x 0 -o $@ $<

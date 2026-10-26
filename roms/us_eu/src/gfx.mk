# Written by tools/make_source.py: one rule per tile PNG (width 16 tiles; -x = blank tiles at the end of the last row).
GFX := $(BUILD)/data/bank_00/Gfx_WipeTile.2bpp $(BUILD)/data/bank_08/Gfx_08_48B1_Mode1C_DrawPrintScreen.2bpp $(BUILD)/data/bank_08/Gfx_08_48C1_Mode1C_DrawOptionScreen.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4000_Mode12_State00_Init.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4500_Mode12_State1F_SortDialogClose.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4600_Mode12_State16_SaveDialogClose.2bpp $(BUILD)/data/bank_0c/Gfx_0C_48C0_Mode12_State0F_ClearAll.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4920_Mode12_State20_BorderRow.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4950_Mode12_State03_EditSpeed.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4C60_Mode12_State16_SaveDialogClose.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4D50_Mode12_State07_ToolsSlideIn.2bpp $(BUILD)/data/bank_0c/Gfx_0C_4FF0_AnimEd_ShowEntryValue.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5100_Mode12_State0F_ClearAll.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5500_Mode12_State0F_ClearAll.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5770_AnimEd_ShowLoopFlag.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5800_AnimEdMenuLabelsAlt.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5A40_AnimEd_LoadMenuTiles_Entries0to1.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5B40_AnimEd_ShowEntryValue.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5B60_AnimEd_ShowEntryValue.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5C80_AnimEd_ShowLoopFlag.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5CA0_AnimEd_Ctx0_Decor.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5CC0_AnimEd_Ctx0_Decor.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5D40_Mode12_State22_BorderPickerReturn.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5D70_Mode12_State01_Browse.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5DA0_Mode12_State01_Browse.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5FA0_AnimEd_ShowEntryValue.2bpp $(BUILD)/data/bank_0c/Gfx_0C_5FE0_Mode12_State04_ToggleLoop.2bpp $(BUILD)/data/bank_0c/Gfx_0C_6000_Mode12_State04_ToggleLoop.2bpp $(BUILD)/data/bank_0c/Gfx_0C_6020_AnimEd_Ctx0_Decor.2bpp $(BUILD)/data/bank_0c/Gfx_0C_6180_Mode12_State14_SaveDialogOpen.2bpp $(BUILD)/data/bank_0c/Gfx_0C_6560_Mode12_State1A_ClearDialogOpen.2bpp $(BUILD)/data/bank_0c/Gfx_0C_6730_Mode12_State17_ExitDialogOpen.2bpp $(BUILD)/data/bank_0c/Gfx_0C_6C00_Mode12_State1D_SortDialogOpen_Aux.2bpp $(BUILD)/data/bank_0c/Gfx_0C_6C30_Mode12_State1D_SortDialogOpen.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7800_Mode09_State00_Init.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7900_Album_LoadSliderScreen.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7930_Mode09_State00_Init.2bpp $(BUILD)/data/bank_0c/Gfx_0C_79A0_Mode0A_State02_Setup.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7B00_Mode09_State00_Init.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7C00_Album_LoadSliderScreen.2bpp $(BUILD)/data/bank_0c/Gfx_0C_7FD0_Mode09_State00_Init.2bpp $(BUILD)/data/bank_0d/Gfx_0D_4000_Mode16_State00_Init.2bpp $(BUILD)/data/bank_0d/Gfx_0D_4800_Mode16_State00_Init.2bpp $(BUILD)/data/bank_0d/Gfx_0D_5000_Mode16_State00_Init.2bpp $(BUILD)/data/bank_0d/Gfx_0D_5300_Strip06_4B06.2bpp $(BUILD)/data/bank_0d/Gfx_0D_5580_Strip06_4B06.2bpp $(BUILD)/data/bank_0d/Gfx_0D_5800_Strip06_4B06.2bpp $(BUILD)/data/bank_0d/Gfx_0D_5A80_Strip06_4B06.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6000_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6100_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6200_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6300_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6400_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6500_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6600_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6700_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6800_Icon06_46E6.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6900_Icon06_4786.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6A00_Icon06_4786.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6B00_Icon06_4786.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6C00_Icon06_4786.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6D00_Icon06_4786.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6E00_Icon06_4786.2bpp $(BUILD)/data/bank_0d/Gfx_0D_6F00_Icon06_4786.2bpp $(BUILD)/data/bank_0d/Gfx_0D_7000_FillPatternTiles.2bpp $(BUILD)/data/bank_0d/Unused_TCRF_KanjiMiddleBeforeAfterHave_Gfx.2bpp $(BUILD)/data/bank_0d/Gfx_0D_77E0_FillPatternTiles_Cont.2bpp $(BUILD)/data/bank_0d/Gfx_0D_7900_Mode0F_State05_ConfirmInit.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4000_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4280_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4500_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4780_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4A00_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4C80_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_4F00_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_5180_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_5400_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_5680_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_5900_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_5B80_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_5E00_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_6080_MsgStrip.2bpp $(BUILD)/data/bank_0e/Gfx_0E_6300_Head.2bpp $(BUILD)/data/bank_0e/Gfx_0E_6680_Head.2bpp $(BUILD)/data/bank_0e/Gfx_0E_6A00_Head.2bpp $(BUILD)/data/bank_0e/Gfx_0E_6D80_Head.2bpp $(BUILD)/data/bank_0e/Gfx_0E_7100_Head.2bpp $(BUILD)/data/bank_0e/Gfx_0E_7480_Head.2bpp $(BUILD)/data/bank_0e/Gfx_0E_7800_Head.2bpp $(BUILD)/data/bank_0e/Gfx_0E_7B80_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_4000_Mode08_State00_Init.2bpp $(BUILD)/data/bank_0f/Gfx_0F_4800_Mode08_State00_Init.2bpp $(BUILD)/data/bank_0f/Gfx_0F_5000_Mode08_State00_Init.2bpp $(BUILD)/data/bank_0f/Gfx_0F_5500_UserMap_LoadPlanetTiles.2bpp $(BUILD)/data/bank_0f/Gfx_0F_5780_UserMap_LoadPlanetTiles.2bpp $(BUILD)/data/bank_0f/Gfx_0F_5F00_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_6280_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_6600_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_6980_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_6D00_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_7080_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_7400_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_7780_Head.2bpp $(BUILD)/data/bank_0f/Gfx_0F_7B00_Boot_EraseAllPrompt_Far.2bpp $(BUILD)/data/bank_10/Gfx_10_4000_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_4380_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_4700_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_4A80_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_4E00_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_5180_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_5500_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_5880_Head.2bpp $(BUILD)/data/bank_10/Gfx_10_5C00_Mode1F_State00_TitleInit.2bpp $(BUILD)/data/bank_10/DjPrintFont_10_78A8_Slots2Ato2B.2bpp $(BUILD)/data/bank_10/DjPrintFont_10_78E8_Slots2Eto30.2bpp $(BUILD)/data/bank_10/Unused_TCRF_SoundPrintModulationIcon_TopRow_Gfx.2bpp $(BUILD)/data/bank_10/Unused_TCRF_SoundPrintModulationIcon_BottomRow_Gfx.2bpp $(BUILD)/data/bank_11/Gfx_11_4000_MainMenu_IconStripB_F4.2bpp $(BUILD)/data/bank_11/Gfx_11_4500_MainMenu_IconStripB_F5.2bpp $(BUILD)/data/bank_11/Gfx_11_4A00_MainMenu_IconStripB_F6.2bpp $(BUILD)/data/bank_11/Gfx_11_4F00_MainMenu_LoadBaseTiles.2bpp $(BUILD)/data/bank_11/Gfx_11_5000_MainMenu_DrawUpperItem1.2bpp $(BUILD)/data/bank_11/Gfx_11_5200_MainMenu_DrawUpperItem0.2bpp $(BUILD)/data/bank_11/Gfx_11_5300_MainMenu_DrawUpperItem1.2bpp $(BUILD)/data/bank_11/Gfx_11_5400_MainMenuUpperItemFramesA.2bpp $(BUILD)/data/bank_11/Gfx_11_5500_MainMenu_DrawUpperItem0.2bpp $(BUILD)/data/bank_11/Gfx_11_5600_MainMenu_DrawUpperItem1.2bpp $(BUILD)/data/bank_11/Gfx_11_7000_Mode18_State00_Init.2bpp $(BUILD)/data/bank_11/Gfx_11_7200_Icon06_5D43.2bpp $(BUILD)/data/bank_11/Gfx_11_7300_Icon06_5D43.2bpp $(BUILD)/data/bank_11/Gfx_11_7400_Icon06_5D43.2bpp $(BUILD)/data/bank_11/Gfx_11_7500_Icon06_5D43.2bpp $(BUILD)/data/bank_11/Gfx_11_7600_Icon06_5D43.2bpp $(BUILD)/data/bank_11/Gfx_11_7000_Compose_DrawJitter_Part7700.2bpp $(BUILD)/data/bank_11/Gfx_11_7800_Mode18_State00_Init.2bpp $(BUILD)/data/bank_11/Gfx_11_7C40_Mode18_DrawThumbFrame.2bpp $(BUILD)/data/bank_11/Gfx_11_7D00_Icon06_5D43.2bpp $(BUILD)/data/bank_11/Gfx_11_7E00_Icon06_5D43.2bpp $(BUILD)/data/bank_11/Gfx_11_7800_Compose_DrawJitter_Part7F00.2bpp $(BUILD)/data/bank_12/Gfx_12_4000_Mode06_State00_Init.2bpp $(BUILD)/data/bank_12/Gfx_12_4010_Mode06_State00_Init.2bpp $(BUILD)/data/bank_12/Gfx_12_4800_Mode06_State00_Init.2bpp $(BUILD)/data/bank_12/Gfx_12_48B0_LinkMenu_LoadTilesSelected.2bpp $(BUILD)/data/bank_12/Gfx_12_4990_LinkMenu_LoadTilesDeselected.2bpp $(BUILD)/data/bank_12/Gfx_12_49A0_LinkMenu_LoadTilesDeselected.2bpp $(BUILD)/data/bank_12/Gfx_12_4A30_LinkMenu_LoadTilesSelected.2bpp $(BUILD)/data/bank_12/Gfx_12_4A40_LinkMenu_LoadTilesDeselected.2bpp $(BUILD)/data/bank_12/Gfx_12_4B10_LinkMenu_LoadTilesSelected.2bpp $(BUILD)/data/bank_12/Gfx_12_4B30_LinkMenu_LoadTilesSelected.2bpp $(BUILD)/data/bank_12/Gfx_12_4BB0_LinkMenu_LoadTilesDeselected.2bpp $(BUILD)/data/bank_12/Gfx_12_4E40_LinkMenu_LoadTilesDeselected.2bpp $(BUILD)/data/bank_12/Gfx_12_5000_Mode06_State00_Init.2bpp $(BUILD)/data/bank_12/Gfx_12_5800_Mode21_State00_Init.2bpp $(BUILD)/data/bank_12/Gfx_12_6000_Mode21_State00_Init.2bpp $(BUILD)/data/bank_12/Gfx_12_6800_Mode21_State00_Init.2bpp $(BUILD)/data/bank_12/Gfx_12_7000_Mode03_State00_Init.2bpp $(BUILD)/data/bank_13/Gfx_13_4000_Mode02_State00_Init.2bpp $(BUILD)/data/bank_13/Gfx_13_4800_Mode02_State00_Init.2bpp $(BUILD)/data/bank_13/Gfx_13_5000_Mode02_State00_Init.2bpp $(BUILD)/data/bank_13/Gfx_13_5800_Mode0F_State00_Init.2bpp $(BUILD)/data/bank_13/Gfx_13_5830_PhotoPicker_LoadPageTabsFor.2bpp $(BUILD)/data/bank_13/Gfx_13_5880_Mode0F_State0A_EraseAll.2bpp $(BUILD)/data/bank_13/Gfx_13_5950_Mode0F_DrawCopyCount.2bpp $(BUILD)/data/bank_13/Unused_TCRF_AlbumHandGestures_Gfx.2bpp $(BUILD)/data/bank_13/Gfx_13_5D00_Mode0F_State00_Init_Cont.2bpp $(BUILD)/data/bank_13/Gfx_13_6800_Icon04_44DC.2bpp $(BUILD)/data/bank_13/Gfx_13_6900_Icon04_44DC.2bpp $(BUILD)/data/bank_13/Gfx_13_6A00_Icon04_44DC.2bpp $(BUILD)/data/bank_13/Gfx_13_6B00_Icon04_44DC.2bpp $(BUILD)/data/bank_13/Gfx_13_6C00_Icon04_44DC.2bpp $(BUILD)/data/bank_13/Gfx_13_6D00_Icon04_44DC.2bpp $(BUILD)/data/bank_13/Gfx_13_7000_Mode08_CreditsReal.2bpp $(BUILD)/data/bank_13/Gfx_13_7800_Mode08_CreditsReal.2bpp $(BUILD)/data/bank_14/Gfx_14_5800_Mode0D_State00_Init.2bpp $(BUILD)/data/bank_14/Gfx_14_6000_Mode0D_State00_Init.2bpp $(BUILD)/data/bank_14/Gfx_14_6800_Mode0D_State00_Init.2bpp $(BUILD)/data/bank_14/Gfx_14_7000_PenMenu_Build.2bpp $(BUILD)/data/bank_14/Gfx_14_7430_Mode10_State02_Setup.2bpp $(BUILD)/data/bank_14/Gfx_14_75E0_PenMenu_Build.2bpp $(BUILD)/data/bank_14/Gfx_14_7600_PenMenu_Build.2bpp $(BUILD)/data/bank_14/Sheet_MiscellaneousDoodleRips_14_76B0.2bpp $(BUILD)/data/bank_14/Gfx_14_7A00_PenMenu_Build.2bpp $(BUILD)/data/bank_14/Sheet_MiscellaneousDoodleRips_14_7A80.2bpp $(BUILD)/data/bank_14/Gfx_14_7E30_Mode10_State02_Setup.2bpp $(BUILD)/data/bank_15/Gfx_15_4000_MainMenu_LoadBackground.2bpp $(BUILD)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Gfx.2bpp $(BUILD)/data/bank_15/Gfx_15_4490_MainMenu_LoadBackground_Cont.2bpp $(BUILD)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx.2bpp $(BUILD)/data/bank_15/Gfx_15_4510_MainMenu_LoadBackground_Cont.2bpp $(BUILD)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx.2bpp $(BUILD)/data/bank_15/Gfx_15_4590_MainMenu_LoadBackground_Cont.2bpp $(BUILD)/data/bank_15/Gfx_15_4600_Mode00_State00_Init.2bpp $(BUILD)/data/bank_15/Gfx_15_4900_Mode00_State00_Init.2bpp $(BUILD)/data/bank_15/Gfx_15_4A00_MainMenu_LoadBackground.2bpp $(BUILD)/data/bank_15/Gfx_15_4B00_MainMenu_LoadBackground.2bpp $(BUILD)/data/bank_15/Gfx_15_4C00_MainMenu_LoadBackground.2bpp $(BUILD)/data/bank_15/Gfx_15_4D00_MainMenu_LoadBackground.2bpp $(BUILD)/data/bank_15/Gfx_15_4E00_MainMenu_LoadBaseTiles.2bpp $(BUILD)/data/bank_15/Gfx_15_5000_MainMenu_DrawUpperItem2.2bpp $(BUILD)/data/bank_15/Gfx_15_5200_MainMenu_DrawUpperItem2_Aux.2bpp $(BUILD)/data/bank_15/Gfx_15_5400_Mode00_State00_Init.2bpp $(BUILD)/data/bank_15/Gfx_15_5500_SlidePlay_ReadKeys_Aux.2bpp $(BUILD)/data/bank_15/Gfx_15_5600_Mode00_State00_Init.2bpp $(BUILD)/data/bank_15/Gfx_15_5700_Mode04_State00_Init.2bpp $(BUILD)/data/bank_15/Gfx_15_5F00_Mode04_State00_Init.2bpp $(BUILD)/data/bank_15/Gfx_15_6700_Mode04_State00_Init.2bpp $(BUILD)/data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup.2bpp $(BUILD)/data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00.2bpp $(BUILD)/data/bank_15/Gfx_15_7C00_Mode0E_State06_ExchangeSetup.2bpp $(BUILD)/data/bank_16/Gfx_16_4000_Mode0B_State00_Init.2bpp $(BUILD)/data/bank_16/Gfx_16_4800_Mode0B_State00_Init.2bpp $(BUILD)/data/bank_16/Gfx_16_5000_Mode0B_State00_Init.2bpp $(BUILD)/data/bank_16/Gfx_16_5580_MainMenu_IconStripB_F0.2bpp $(BUILD)/data/bank_16/Gfx_16_5A80_MainMenu_IconStripB_F1.2bpp $(BUILD)/data/bank_16/Gfx_16_5F80_MainMenu_IconStripB_F2.2bpp $(BUILD)/data/bank_16/Gfx_16_6480_MainMenu_IconStripB_F3.2bpp $(BUILD)/data/bank_16/Gfx_16_6980_MainMenu_BallHeadAnim_F0.2bpp $(BUILD)/data/bank_16/Gfx_16_6B80_MainMenu_BallHeadAnim_F1.2bpp $(BUILD)/data/bank_16/Gfx_16_6D80_MainMenu_BallHeadAnim_F2.2bpp $(BUILD)/data/bank_16/Gfx_16_6F80_MainMenu_BallHeadAnim_F3.2bpp $(BUILD)/data/bank_16/Gfx_16_7180_MainMenu_BallHeadAnim_F4.2bpp $(BUILD)/data/bank_16/Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref.2bpp $(BUILD)/data/bank_16/Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref.2bpp $(BUILD)/data/bank_16/Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref.2bpp $(BUILD)/data/bank_16/Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref.2bpp $(BUILD)/data/bank_16/Gfx_16_7B80_MainMenu_BallHeadAnim_F9.2bpp $(BUILD)/data/bank_17/Gfx_17_4000_Shoot_DrawDigitAt_Digits.2bpp $(BUILD)/data/bank_17/Gfx_17_4140_Mode14_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_4180_Mode14_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_4200_Shoot_LoadTimerScreen_Frames.2bpp $(BUILD)/data/bank_17/Gfx_17_4680_Mode0F_State05_ConfirmInit.2bpp $(BUILD)/data/bank_17/Gfx_17_4680_Compose_Split_DrawMakeBlink_Part4690.2bpp $(BUILD)/data/bank_17/Gfx_17_46A0_Mode0F_State05_ConfirmInit.2bpp $(BUILD)/data/bank_17/Gfx_17_4700_Shoot_LoadBurstIcons.2bpp $(BUILD)/data/bank_17/Gfx_17_4740_Shoot_LoadBurstIcons.2bpp $(BUILD)/data/bank_17/Gfx_17_4780_Shoot_LoadBurstIcons.2bpp $(BUILD)/data/bank_17/Gfx_17_47C0_Shoot_LoadBurstIcons.2bpp $(BUILD)/data/bank_17/Gfx_17_4800_Compose_DrawFreeCount.2bpp $(BUILD)/data/bank_17/Gfx_17_4820_Shoot_DrawShotsLeft_Digits1to9.2bpp $(BUILD)/data/bank_17/Gfx_17_4940_Mode14_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_4950_Shoot_DrawTimerMinutes.2bpp $(BUILD)/data/bank_17/Gfx_17_4960_Mode14_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_4980_Mode17_State08_Split_Build.2bpp $(BUILD)/data/bank_17/Gfx_17_4A60_Mode0E_State04_PickDone.2bpp $(BUILD)/data/bank_17/Gfx_17_4B60_Mode0E_State04_PickDone.2bpp $(BUILD)/data/bank_17/Gfx_17_4B90_Mode0E_State04_PickDone.2bpp $(BUILD)/data/bank_17/Gfx_17_4C00_Shoot_DrawOptionPanel.2bpp $(BUILD)/data/bank_17/Gfx_17_5000_Mode14_State04_OptionsPage.2bpp $(BUILD)/data/bank_17/Gfx_17_5400_Shoot_LoadBurstIcons.2bpp $(BUILD)/data/bank_17/Gfx_17_5440_Mode14_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_54E0_Mode14_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_5500_Unused_MainMenuTiles.2bpp $(BUILD)/data/bank_17/Gfx_17_6800_Mode13_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_7000_Mode13_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_7800_Mode13_State00_Init.2bpp $(BUILD)/data/bank_17/Gfx_17_7B00_CreditsGirlFrame04.2bpp $(BUILD)/data/bank_18/Gfx_18_4000_Mode05_State00_Init.2bpp $(BUILD)/data/bank_18/Gfx_18_4800_Mode05_State00_Init.2bpp $(BUILD)/data/bank_18/Gfx_18_5000_Mode05_State00_Init.2bpp $(BUILD)/data/bank_18/Gfx_18_5470_Mode1E_State00_Init.2bpp $(BUILD)/data/bank_18/Unused_TCRF_MarginPrint_BFilmRoll_Gfx.2bpp $(BUILD)/data/bank_18/Gfx_18_5AB0_Mode1C_DrawOptionScreen_Cont.2bpp $(BUILD)/data/bank_18/Gfx_18_5C70_Mode1E_State00_Init.2bpp $(BUILD)/data/bank_18/Unused_TCRF_MarginPrint_OutlinedText_Gfx.2bpp $(BUILD)/data/bank_18/Gfx_18_6050_Mode1C_DrawOptionScreen_Cont.2bpp $(BUILD)/data/bank_18/Gfx_18_6470_Mode1B_State00_Init.2bpp $(BUILD)/data/bank_18/Gfx_18_6C70_Mode1B_State00_Init.2bpp $(BUILD)/data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen.2bpp $(BUILD)/data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen_Part7470.2bpp $(BUILD)/data/bank_18/Gfx_18_7900_Mode1C_LoadToggleTiles.2bpp $(BUILD)/data/bank_18/Gfx_18_79C0_Mode1C_LoadToggleTiles.2bpp $(BUILD)/data/bank_18/Gfx_18_7A80_Mode1C_State02_ShowPrintScreen.2bpp $(BUILD)/data/bank_18/Gfx_18_7B00_Mode1C_State02_ShowPrintScreen.2bpp $(BUILD)/data/bank_18/Gfx_18_7BA0_Mode0E_State04_PickDone.2bpp $(BUILD)/data/bank_18/Gfx_18_7C40_Mode0F_State05_ConfirmInit.2bpp $(BUILD)/data/bank_18/Gfx_18_7D60_Mode0F_State05_ConfirmInit.2bpp $(BUILD)/data/bank_18/Gfx_18_7D80_Mode0F_State04_LeaveSelected_Aux.2bpp $(BUILD)/data/bank_18/Gfx_18_7E80_Mode0F_State05_ConfirmInit.2bpp $(BUILD)/data/bank_19/Gfx_19_4760_Mode0E_State00_Init.2bpp $(BUILD)/data/bank_19/Gfx_19_4800_Mode0E_State00_Init.2bpp $(BUILD)/data/bank_19/Gfx_19_4F60_Mode0E_State00_Init.2bpp $(BUILD)/data/bank_19/Gfx_19_5000_Mode0E_State00_Init.2bpp $(BUILD)/data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA.2bpp $(BUILD)/data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA_Part5800.2bpp $(BUILD)/data/bank_19/Gfx_19_5A60_Mode08_State13_CreditsPageA.2bpp $(BUILD)/data/bank_19/Gfx_19_6260_Mode08_State13_CreditsPageA.2bpp $(BUILD)/data/bank_19/Gfx_19_6460_Mode21_State0B_ResultSetup.2bpp $(BUILD)/data/bank_19/Gfx_19_6560_Mode21_State0B_ResultSetup.2bpp $(BUILD)/data/bank_19/Gfx_19_6D60_Mode21_State0B_ResultSetup.2bpp $(BUILD)/data/bank_1a/Gfx_1A_4000_Mode1F_State04_PerformanceSetup.2bpp $(BUILD)/data/bank_1a/Gfx_1A_4D60_DjPerf_DrawTempo.2bpp $(BUILD)/data/bank_1a/Gfx_1A_4E00_Mode1F_State05_Performance.2bpp $(BUILD)/data/bank_1a/Gfx_1A_50A0_Mode1F_State06_SavePanel.2bpp $(BUILD)/data/bank_1a/Gfx_1A_5200_Mode08_State03_CardInit.2bpp $(BUILD)/data/bank_1a/Gfx_1A_5A00_Mode08_State03_CardInit.2bpp $(BUILD)/data/bank_1a/Gfx_1A_6400_Mode20_State00_MenuInit.2bpp $(BUILD)/data/bank_1a/Gfx_1A_6C00_Mode20_State00_MenuInit.2bpp $(BUILD)/data/bank_1a/Gfx_1A_7400_Mode20_State00_MenuInit.2bpp $(BUILD)/data/bank_1a/Gfx_1A_7600_Album_ShowPageScreenB.2bpp $(BUILD)/data/bank_1a/Gfx_1A_7C90_Album_ShowPageScreenB_ArrowGlyph.2bpp $(BUILD)/data/bank_1b/Gfx_1B_4000_Mode1C_State08_PrintJob.2bpp $(BUILD)/data/bank_1b/Gfx_1B_4800_Mode1C_State08_PrintJob.2bpp $(BUILD)/data/bank_1b/Gfx_1B_5100_Mode20_State09_ResultInit.2bpp $(BUILD)/data/bank_1b/Gfx_1B_6100_Mode21_State02_RaceSceneInit.2bpp $(BUILD)/data/bank_1b/Gfx_1B_6680_Mode21_State02_RaceSceneInit.2bpp $(BUILD)/data/bank_1b/Gfx_1B_6E80_Run_DrawTimerDigitB.2bpp $(BUILD)/data/bank_1b/Gfx_1B_7100_Mode1D_State06_LoadWaitScreen.2bpp $(BUILD)/data/bank_1c/Gfx_1C_44B0_Parlor_Page1.2bpp $(BUILD)/data/bank_1c/TileGap_1C_5160.2bpp $(BUILD)/data/bank_1c/Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete.2bpp $(BUILD)/data/bank_1c/Gfx_1C_53A0_Mode1A_State02_Setup.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5600_Album_ShowPageScreenB.2bpp $(BUILD)/data/bank_1c/TileGap_1C_5620.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5710_HotSpotEd_ShowJump.2bpp $(BUILD)/data/bank_1c/TileGap_1C_5720.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5760_HotSpotEd_ShowEffectIcon.2bpp $(BUILD)/data/bank_1c/Gfx_1C_58A0_Mode0C_State02_Setup.2bpp $(BUILD)/data/bank_1c/Unused_TCRF_HotSpotEffectIcons_Extra_Gfx.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5B20_Mode0C_State02_Setup_Cont.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5B60_Mode0C_State02_Setup.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5B80_Mode09_State02_PhotoArrows.2bpp $(BUILD)/data/bank_1c/TileGap_1C_5BC0.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5BE0_Mode09_State02_PhotoArrows.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5C20_Mode09_State02_PhotoArrows_Aux.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5C60_Mode0C_State02_Setup.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5C80_Mode09_State02_PhotoArrows.2bpp $(BUILD)/data/bank_1c/TileGap_1C_5CC0.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5CE0_Mode09_State02_PhotoArrows.2bpp $(BUILD)/data/bank_1c/TileGap_1C_5D20.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete.2bpp $(BUILD)/data/bank_1c/Gfx_1C_5E60_Link_ShowScreenA.2bpp $(BUILD)/data/bank_1c/Gfx_1C_6570_Link_ShowScreenA.2bpp $(BUILD)/data/bank_1c/Gfx_1C_6660_Link_ShowScreenA.2bpp $(BUILD)/data/bank_1c/Gfx_1C_6D50_Link_ShowScreenB.2bpp $(BUILD)/data/bank_1c/Gfx_1C_6D60_Mode1F_State07_QuitPanel_Part6DE0.2bpp $(BUILD)/data/bank_1c/Gfx_1C_7260_Mode1F_State08_EditPagesSetup.2bpp $(BUILD)/data/bank_1c/Gfx_1C_7860_Mode1F_State08_EditPagesSetup.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4000_Mode1F_State08_EditPagesSetup.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4300_Mode1F_State08_EditPagesSetup.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4500_Mode1F_State09_PageSound1.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4800_Mode1F_State09_PageSound1.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4A00_Mode1F_State0A_PageSound2.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4D00_Mode1F_State0A_PageSound2.2bpp $(BUILD)/data/bank_1d/Gfx_1D_4F00_ResultPic3_Equator_Tune2A.2bpp $(BUILD)/data/bank_1d/Gfx_1D_7860_Mode1F_State08_EditPagesSetup.2bpp $(BUILD)/data/bank_1d/Sheet_MiscellaneousStampsJpn_1D_78E0.2bpp $(BUILD)/data/bank_1e/Gfx_1E_4000_ResultPic2_RibbonWoman_Tune30.2bpp $(BUILD)/data/bank_1e/Gfx_1E_4E00_ResultPic0_HornedMan_Tune28.2bpp $(BUILD)/data/bank_1e/Gfx_1E_5C00_Mode17_State00_Init.2bpp $(BUILD)/data/bank_1e/Gfx_1E_5F00_Mode17_State00_Init.2bpp $(BUILD)/data/bank_1e/Gfx_1E_6480_Mode17_State00_Init.2bpp $(BUILD)/data/bank_1e/Gfx_1E_64B0_Compose_DrawPhotoNumber_AlbumLetter.2bpp $(BUILD)/data/bank_1e/Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits.2bpp $(BUILD)/data/bank_1e/Gfx_1E_6570_Mode17_State00_Init.2bpp $(BUILD)/data/bank_1e/Gfx_1E_6580_Mode17_State00_Init.2bpp $(BUILD)/data/bank_1e/Gfx_1E_6A00_ResultPic1_BaldMan_Tune29Totaka.2bpp $(BUILD)/data/bank_20/Gfx_20_4000_Mode08_State14_CreditsPageB.2bpp $(BUILD)/data/bank_20/Gfx_20_4800_Mode08_State14_CreditsPageB.2bpp $(BUILD)/data/bank_20/Gfx_20_4E00_Mode08_State0C_RecordInit.2bpp $(BUILD)/data/bank_20/Gfx_20_5600_Mode08_State0C_RecordInit.2bpp $(BUILD)/data/bank_20/Gfx_20_5B00_Mode08_State06_EditorInit.2bpp $(BUILD)/data/bank_20/Gfx_20_6080_Mode08_State06_EditorInit.2bpp $(BUILD)/data/bank_20/Gfx_20_64C0_OwnerCard_LoadGenderTiles.2bpp $(BUILD)/data/bank_20/Gfx_20_6680_OwnerCard_LoadBloodTiles.2bpp $(BUILD)/data/bank_20/Gfx_20_66C0_Kb_Page0_Press.2bpp $(BUILD)/data/bank_20/Gfx_20_6800_Mode15_State01_TimerInit.2bpp $(BUILD)/data/bank_20/Gfx_20_6E40_Mode15_State01_TimerInit.2bpp $(BUILD)/data/bank_20/Gfx_20_6EC0_Mode15_State01_TimerInit.2bpp $(BUILD)/data/bank_20/Gfx_20_6F20_Mode15_State01_TimerInit.2bpp $(BUILD)/data/bank_20/Gfx_20_70E0_Mode15_DrawTwoDigitsInterval.2bpp $(BUILD)/data/bank_20/Gfx_20_7180_Mode15_DrawTwoDigits.2bpp $(BUILD)/data/bank_20/Gfx_20_74F0_Mode15_State01_TimerInit.2bpp $(BUILD)/data/bank_20/Gfx_20_7D00_Mode1D_State01_LoadScreen.2bpp $(BUILD)/data/bank_21/Gfx_21_4000_Mode07_State00_Init.2bpp $(BUILD)/data/bank_21/Gfx_21_4750_SpaceFever_LoadHudTiles.2bpp $(BUILD)/data/bank_21/Gfx_21_4800_Mode07_State00_Init.2bpp $(BUILD)/data/bank_21/Gfx_21_4850_SpaceFever_LoadHudTiles.2bpp $(BUILD)/data/bank_21/Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00.2bpp $(BUILD)/data/bank_21/Gfx_21_4D00_CommentCard_DrawPhotoNumber_Tens.2bpp $(BUILD)/data/bank_21/Gfx_21_4E00_CommentCard_DrawPhotoNumber_Ones.2bpp $(BUILD)/data/bank_21/Gfx_21_5080_CommentCard_DrawDigit.2bpp $(BUILD)/data/bank_21/Gfx_21_54E0_CommentCard_DrawBlood_Far.2bpp $(BUILD)/data/bank_21/Gfx_21_56C0_CommentCard_DrawNumber.2bpp $(BUILD)/data/bank_21/Gfx_21_56D0_CommentCard_DrawGender_Far.2bpp $(BUILD)/data/bank_21/Gfx_21_5790_CommentCard_DrawCopyBadge_Far.2bpp $(BUILD)/data/bank_21/Gfx_21_71C0_Mode19_State00_CopyrightScreens.2bpp $(BUILD)/data/bank_21/Gfx_21_77C0_BorderPicker_Substate0_Init.2bpp $(BUILD)/data/bank_22/Gfx_22_4000_CreditsGirlFrame03.2bpp $(BUILD)/data/bank_22/Gfx_22_4500_CreditsNishimuraDanceFrame00.2bpp $(BUILD)/data/bank_22/Gfx_22_4970_CreditsNishimuraDanceFrame01.2bpp $(BUILD)/data/bank_22/Gfx_22_4DE0_CreditsGirlFrame10.2bpp $(BUILD)/data/bank_22/Gfx_22_5240_CreditsGirlFrame02_Part52E0.2bpp $(BUILD)/data/bank_22/Gfx_22_56A0_CreditsGirlFrame07_Part5740.2bpp $(BUILD)/data/bank_22/Gfx_22_5B00_CreditsGirlFrame11_Part5BA0.2bpp $(BUILD)/data/bank_22/Gfx_22_6740_Mode11_State02_Setup.2bpp $(BUILD)/data/bank_22/Gfx_22_6810_Mode11_State02_Setup.2bpp $(BUILD)/data/bank_22/Gfx_22_6A90_Mode11_State04_Place.2bpp $(BUILD)/data/bank_22/Gfx_22_6AA0_Mode1A_State02_Setup.2bpp $(BUILD)/data/bank_22/Gfx_22_6F40_CreditsGirlFrame08.2bpp $(BUILD)/data/bank_23/Gfx_23_4000_CreditsGirlFrame09.2bpp $(BUILD)/data/bank_23/Gfx_23_50C0_Mode16_State08_StartShoot.2bpp $(BUILD)/data/bank_23/Gfx_23_6C80_CreditsGirlFrame12.2bpp $(BUILD)/data/bank_24/Gfx_24_4000_CreditsGirlFrame01.2bpp $(BUILD)/data/bank_24/Gfx_24_57E0_Unused_Link_LoadTiles.2bpp $(BUILD)/data/bank_24/Gfx_24_57E0_Cam_FactoryDiag_AllButtonsExceptB_Part58E0.2bpp $(BUILD)/data/bank_25/Gfx_25_4000_CreditsGirlFrame05.2bpp $(BUILD)/data/bank_25/Gfx_25_4480_Mode08_State14_CreditsPageB.2bpp $(BUILD)/data/bank_25/Gfx_25_4480_CreditsGirlFrame00_Part4500.2bpp $(BUILD)/data/bank_26/Gfx_26_4000_CreditsGirlFrame06.2bpp $(BUILD)/data/bank_26/Gfx_26_4880_Mode1A_State03_Browse.2bpp $(BUILD)/data/bank_27/Gfx_27_4000_Mode1D_State01_LoadScreen.2bpp $(BUILD)/data/bank_27/Gfx_27_4800_Mode1D_State01_LoadScreen.2bpp $(BUILD)/data/bank_27/Gfx_27_4C00_CreditsNishimuraDanceFrame02.2bpp $(BUILD)/data/bank_28/Gfx_28_4000_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_4280_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_4500_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_4780_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_4A00_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_4C80_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_4F00_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_5180_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_5400_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_5680_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_5900_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_5B80_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_5E00_MsgStripB.2bpp $(BUILD)/data/bank_28/Gfx_28_7000_CreditsEndingPlate_TilesA.2bpp $(BUILD)/data/bank_28/Gfx_28_7790_CreditsEndingPlate_TilesB.2bpp $(BUILD)/data/bank_28/Gfx_28_7800_Mode08_State16_CreditsScroll.2bpp $(BUILD)/data/bank_2a/Gfx_2A_44F4_FontSlots27to28.2bpp $(BUILD)/data/bank_2a/Font_2A_5160_Glyph8C.2bpp $(BUILD)/data/bank_2a/Font_2A_5180_Glyphs8Dto94.2bpp $(BUILD)/data/bank_2a/Font_2A_5280_Glyphs95to96.2bpp $(BUILD)/data/bank_2a/Font_2A_52C0_Glyphs97to9C.2bpp $(BUILD)/data/bank_2a/Font_2A_5380_Glyphs9Dto9E.2bpp $(BUILD)/data/bank_2a/Font_2A_53C0_Glyph9F.2bpp $(BUILD)/data/bank_2a/Gfx_2A_54B0_FontSlotA5.2bpp $(BUILD)/data/bank_2a/Gfx_2A_54D0_FontSlotA6.2bpp $(BUILD)/data/bank_31/WildFrame0_Tiles.2bpp $(BUILD)/data/bank_31/WildFrame1_Tiles.2bpp $(BUILD)/data/bank_31/WildFrame2_Tiles.2bpp $(BUILD)/data/bank_32/WildFrame3_Tiles.2bpp $(BUILD)/data/bank_32/WildFrame4_Tiles.2bpp $(BUILD)/data/bank_32/WildFrame5_Tiles.2bpp $(BUILD)/data/bank_33/WildFrame6_Tiles.2bpp $(BUILD)/data/bank_33/WildFrame7_Tiles.2bpp $(BUILD)/data/bank_34/Border00_Tiles.2bpp $(BUILD)/data/bank_34/Border01_Tiles.2bpp $(BUILD)/data/bank_34/Border02_Tiles.2bpp $(BUILD)/data/bank_34/Border03_Tiles.2bpp $(BUILD)/data/bank_34/Border04_Tiles.2bpp $(BUILD)/data/bank_34/Border05_Tiles.2bpp $(BUILD)/data/bank_34/Border06_Tiles.2bpp $(BUILD)/data/bank_34/Border07_Tiles.2bpp $(BUILD)/data/bank_34/Border08_Tiles.2bpp $(BUILD)/data/bank_35/Border09_Tiles.2bpp $(BUILD)/data/bank_35/Border10_Tiles.2bpp $(BUILD)/data/bank_35/Border11_Tiles.2bpp $(BUILD)/data/bank_35/Border12_Tiles.2bpp $(BUILD)/data/bank_35/Border13_Tiles.2bpp $(BUILD)/data/bank_35/Border14_Tiles.2bpp $(BUILD)/data/bank_35/Border15_Tiles.2bpp $(BUILD)/data/bank_35/Border16_Tiles.2bpp $(BUILD)/data/bank_35/Border17_Tiles.2bpp $(BUILD)/data/bank_36/AlbumB_UnusedSlotA_Tiles.2bpp $(BUILD)/data/bank_36/AlbumB_UnusedSlotB_Tiles.2bpp $(BUILD)/data/bank_36/AlbumB_Photo01_Tiles.2bpp $(BUILD)/data/bank_36/AlbumB_Photo02_Tiles.2bpp $(BUILD)/data/bank_37/AlbumB_Photo03_Tiles.2bpp $(BUILD)/data/bank_37/AlbumB_Photo04_Tiles.2bpp $(BUILD)/data/bank_37/AlbumB_Photo05_Tiles.2bpp $(BUILD)/data/bank_37/AlbumB_Photo06_Tiles.2bpp $(BUILD)/data/bank_38/AlbumB_Photo07_Tiles.2bpp $(BUILD)/data/bank_39/AlbumB_Photo11_Tiles.2bpp $(BUILD)/data/bank_39/AlbumB_Photo14_Tiles.2bpp $(BUILD)/data/bank_3a/AlbumB_Photo15_Tiles.2bpp $(BUILD)/data/bank_3a/AlbumB_Photo16_Tiles.2bpp $(BUILD)/data/bank_3a/AlbumB_Photo17_Tiles.2bpp $(BUILD)/data/bank_3a/AlbumB_Photo18_Tiles.2bpp $(BUILD)/data/bank_3b/AlbumB_Photo19_Tiles.2bpp $(BUILD)/data/bank_3b/AlbumB_Photo20_Tiles.2bpp $(BUILD)/data/bank_3b/AlbumB_Photo21_Tiles.2bpp $(BUILD)/data/bank_3b/AlbumB_Photo22_Tiles.2bpp $(BUILD)/data/bank_3c/AlbumB_Photo23_Tiles.2bpp $(BUILD)/data/bank_3c/AlbumB_Photo24_Tiles.2bpp $(BUILD)/data/bank_3c/AlbumB_Photo25_Tiles.2bpp $(BUILD)/data/bank_3c/AlbumB_Photo26_Tiles.2bpp $(BUILD)/data/bank_3d/AlbumB_Photo27_Tiles.2bpp $(BUILD)/data/bank_3d/AlbumB_Photo28_Tiles.2bpp $(BUILD)/data/bank_3d/AlbumB_Photo29_Tiles.2bpp $(BUILD)/data/bank_3d/AlbumB_Photo30_Tiles.2bpp $(BUILD)/data/bank_3e/Gfx_3E_4000_TitleScene.2bpp $(BUILD)/data/bank_3e/Gfx_3E_4E00_TitleScene.2bpp $(BUILD)/data/bank_3e/Gfx_3E_5C00_TitleScene.2bpp $(BUILD)/data/bank_3e/Gfx_3E_6A00_TitleScene.2bpp $(BUILD)/data/bank_3e/Border18_Tiles.2bpp $(BUILD)/data/bank_3f/Gfx_3F_4000_TitleScene.2bpp $(BUILD)/data/bank_3f/Gfx_3F_4E00_TitleScene.2bpp $(BUILD)/data/bank_3f/Gfx_3F_5C00_TitleScene.2bpp $(BUILD)/data/bank_3f/Gfx_3F_6A00_Mode19_State01_TitleFirst.2bpp $(BUILD)/data/bank_3f/Gfx_3F_7100_Mode19_State01_TitleFirst.2bpp

$(BUILD)/data/bank_00/Gfx_WipeTile.2bpp: $(SRC)/data/bank_00/Gfx_WipeTile.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_08/Gfx_08_48B1_Mode1C_DrawPrintScreen.2bpp: $(SRC)/data/bank_08/Gfx_08_48B1_Mode1C_DrawPrintScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_08/Gfx_08_48C1_Mode1C_DrawOptionScreen.2bpp: $(SRC)/data/bank_08/Gfx_08_48C1_Mode1C_DrawOptionScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4000_Mode12_State00_Init.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4000_Mode12_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4500_Mode12_State1F_SortDialogClose.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4500_Mode12_State1F_SortDialogClose.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4600_Mode12_State16_SaveDialogClose.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4600_Mode12_State16_SaveDialogClose.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_48C0_Mode12_State0F_ClearAll.2bpp: $(SRC)/data/bank_0c/Gfx_0C_48C0_Mode12_State0F_ClearAll.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4920_Mode12_State20_BorderRow.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4920_Mode12_State20_BorderRow.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4950_Mode12_State03_EditSpeed.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4950_Mode12_State03_EditSpeed.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4C60_Mode12_State16_SaveDialogClose.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4C60_Mode12_State16_SaveDialogClose.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4D50_Mode12_State07_ToolsSlideIn.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4D50_Mode12_State07_ToolsSlideIn.png
	$(RGBGFX) -x 6 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_4FF0_AnimEd_ShowEntryValue.2bpp: $(SRC)/data/bank_0c/Gfx_0C_4FF0_AnimEd_ShowEntryValue.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5100_Mode12_State0F_ClearAll.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5100_Mode12_State0F_ClearAll.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5500_Mode12_State0F_ClearAll.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5500_Mode12_State0F_ClearAll.png
	$(RGBGFX) -x 9 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5770_AnimEd_ShowLoopFlag.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5770_AnimEd_ShowLoopFlag.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5800_AnimEdMenuLabelsAlt.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5800_AnimEdMenuLabelsAlt.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5A40_AnimEd_LoadMenuTiles_Entries0to1.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5A40_AnimEd_LoadMenuTiles_Entries0to1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5B40_AnimEd_ShowEntryValue.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5B40_AnimEd_ShowEntryValue.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5B60_AnimEd_ShowEntryValue.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5B60_AnimEd_ShowEntryValue.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5C80_AnimEd_ShowLoopFlag.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5C80_AnimEd_ShowLoopFlag.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5CA0_AnimEd_Ctx0_Decor.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5CA0_AnimEd_Ctx0_Decor.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5CC0_AnimEd_Ctx0_Decor.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5CC0_AnimEd_Ctx0_Decor.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5D40_Mode12_State22_BorderPickerReturn.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5D40_Mode12_State22_BorderPickerReturn.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5D70_Mode12_State01_Browse.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5D70_Mode12_State01_Browse.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5DA0_Mode12_State01_Browse.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5DA0_Mode12_State01_Browse.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5FA0_AnimEd_ShowEntryValue.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5FA0_AnimEd_ShowEntryValue.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_5FE0_Mode12_State04_ToggleLoop.2bpp: $(SRC)/data/bank_0c/Gfx_0C_5FE0_Mode12_State04_ToggleLoop.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_6000_Mode12_State04_ToggleLoop.2bpp: $(SRC)/data/bank_0c/Gfx_0C_6000_Mode12_State04_ToggleLoop.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_6020_AnimEd_Ctx0_Decor.2bpp: $(SRC)/data/bank_0c/Gfx_0C_6020_AnimEd_Ctx0_Decor.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_6180_Mode12_State14_SaveDialogOpen.2bpp: $(SRC)/data/bank_0c/Gfx_0C_6180_Mode12_State14_SaveDialogOpen.png
	$(RGBGFX) -x 2 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_6560_Mode12_State1A_ClearDialogOpen.2bpp: $(SRC)/data/bank_0c/Gfx_0C_6560_Mode12_State1A_ClearDialogOpen.png
	$(RGBGFX) -x 3 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_6730_Mode12_State17_ExitDialogOpen.2bpp: $(SRC)/data/bank_0c/Gfx_0C_6730_Mode12_State17_ExitDialogOpen.png
	$(RGBGFX) -x 6 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_6C00_Mode12_State1D_SortDialogOpen_Aux.2bpp: $(SRC)/data/bank_0c/Gfx_0C_6C00_Mode12_State1D_SortDialogOpen_Aux.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_6C30_Mode12_State1D_SortDialogOpen.2bpp: $(SRC)/data/bank_0c/Gfx_0C_6C30_Mode12_State1D_SortDialogOpen.png
	$(RGBGFX) -x 9 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7800_Mode09_State00_Init.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7800_Mode09_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7900_Album_LoadSliderScreen.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7900_Album_LoadSliderScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7930_Mode09_State00_Init.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7930_Mode09_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_79A0_Mode0A_State02_Setup.2bpp: $(SRC)/data/bank_0c/Gfx_0C_79A0_Mode0A_State02_Setup.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7B00_Mode09_State00_Init.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7B00_Mode09_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7C00_Album_LoadSliderScreen.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7C00_Album_LoadSliderScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0c/Gfx_0C_7FD0_Mode09_State00_Init.2bpp: $(SRC)/data/bank_0c/Gfx_0C_7FD0_Mode09_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_4000_Mode16_State00_Init.2bpp: $(SRC)/data/bank_0d/Gfx_0D_4000_Mode16_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_4800_Mode16_State00_Init.2bpp: $(SRC)/data/bank_0d/Gfx_0D_4800_Mode16_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_5000_Mode16_State00_Init.2bpp: $(SRC)/data/bank_0d/Gfx_0D_5000_Mode16_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_5300_Strip06_4B06.2bpp: $(SRC)/data/bank_0d/Gfx_0D_5300_Strip06_4B06.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_5580_Strip06_4B06.2bpp: $(SRC)/data/bank_0d/Gfx_0D_5580_Strip06_4B06.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_5800_Strip06_4B06.2bpp: $(SRC)/data/bank_0d/Gfx_0D_5800_Strip06_4B06.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_5A80_Strip06_4B06.2bpp: $(SRC)/data/bank_0d/Gfx_0D_5A80_Strip06_4B06.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6000_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6000_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6100_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6100_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6200_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6200_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6300_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6300_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6400_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6400_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6500_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6500_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6600_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6600_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6700_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6700_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6800_Icon06_46E6.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6800_Icon06_46E6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6900_Icon06_4786.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6900_Icon06_4786.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6A00_Icon06_4786.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6A00_Icon06_4786.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6B00_Icon06_4786.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6B00_Icon06_4786.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6C00_Icon06_4786.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6C00_Icon06_4786.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6D00_Icon06_4786.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6D00_Icon06_4786.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6E00_Icon06_4786.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6E00_Icon06_4786.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_6F00_Icon06_4786.2bpp: $(SRC)/data/bank_0d/Gfx_0D_6F00_Icon06_4786.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_7000_FillPatternTiles.2bpp: $(SRC)/data/bank_0d/Gfx_0D_7000_FillPatternTiles.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_0d/Unused_TCRF_KanjiMiddleBeforeAfterHave_Gfx.2bpp: $(SRC)/data/bank_0d/Unused_TCRF_KanjiMiddleBeforeAfterHave_Gfx.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_77E0_FillPatternTiles_Cont.2bpp: $(SRC)/data/bank_0d/Gfx_0D_77E0_FillPatternTiles_Cont.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_0d/Gfx_0D_7900_Mode0F_State05_ConfirmInit.2bpp: $(SRC)/data/bank_0d/Gfx_0D_7900_Mode0F_State05_ConfirmInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4000_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4000_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4280_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4280_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4500_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4500_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4780_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4780_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4A00_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4A00_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4C80_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4C80_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_4F00_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_4F00_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_5180_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_5180_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_5400_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_5400_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_5680_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_5680_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_5900_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_5900_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_5B80_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_5B80_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_5E00_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_5E00_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_6080_MsgStrip.2bpp: $(SRC)/data/bank_0e/Gfx_0E_6080_MsgStrip.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_6300_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_6300_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_6680_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_6680_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_6A00_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_6A00_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_6D80_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_6D80_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_7100_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_7100_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_7480_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_7480_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_7800_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_7800_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0e/Gfx_0E_7B80_Head.2bpp: $(SRC)/data/bank_0e/Gfx_0E_7B80_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_4000_Mode08_State00_Init.2bpp: $(SRC)/data/bank_0f/Gfx_0F_4000_Mode08_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_4800_Mode08_State00_Init.2bpp: $(SRC)/data/bank_0f/Gfx_0F_4800_Mode08_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_5000_Mode08_State00_Init.2bpp: $(SRC)/data/bank_0f/Gfx_0F_5000_Mode08_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_5500_UserMap_LoadPlanetTiles.2bpp: $(SRC)/data/bank_0f/Gfx_0F_5500_UserMap_LoadPlanetTiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_5780_UserMap_LoadPlanetTiles.2bpp: $(SRC)/data/bank_0f/Gfx_0F_5780_UserMap_LoadPlanetTiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_5F00_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_5F00_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_6280_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_6280_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_6600_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_6600_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_6980_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_6980_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_6D00_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_6D00_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_7080_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_7080_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_7400_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_7400_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_7780_Head.2bpp: $(SRC)/data/bank_0f/Gfx_0F_7780_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_0f/Gfx_0F_7B00_Boot_EraseAllPrompt_Far.2bpp: $(SRC)/data/bank_0f/Gfx_0F_7B00_Boot_EraseAllPrompt_Far.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_4000_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_4000_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_4380_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_4380_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_4700_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_4700_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_4A80_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_4A80_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_4E00_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_4E00_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_5180_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_5180_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_5500_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_5500_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_5880_Head.2bpp: $(SRC)/data/bank_10/Gfx_10_5880_Head.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_10/Gfx_10_5C00_Mode1F_State00_TitleInit.2bpp: $(SRC)/data/bank_10/Gfx_10_5C00_Mode1F_State00_TitleInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_10/DjPrintFont_10_78A8_Slots2Ato2B.2bpp: $(SRC)/data/bank_10/DjPrintFont_10_78A8_Slots2Ato2B.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_10/DjPrintFont_10_78E8_Slots2Eto30.2bpp: $(SRC)/data/bank_10/DjPrintFont_10_78E8_Slots2Eto30.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_10/Unused_TCRF_SoundPrintModulationIcon_TopRow_Gfx.2bpp: $(SRC)/data/bank_10/Unused_TCRF_SoundPrintModulationIcon_TopRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_10/Unused_TCRF_SoundPrintModulationIcon_BottomRow_Gfx.2bpp: $(SRC)/data/bank_10/Unused_TCRF_SoundPrintModulationIcon_BottomRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_4000_MainMenu_IconStripB_F4.2bpp: $(SRC)/data/bank_11/Gfx_11_4000_MainMenu_IconStripB_F4.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_4500_MainMenu_IconStripB_F5.2bpp: $(SRC)/data/bank_11/Gfx_11_4500_MainMenu_IconStripB_F5.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_4A00_MainMenu_IconStripB_F6.2bpp: $(SRC)/data/bank_11/Gfx_11_4A00_MainMenu_IconStripB_F6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_4F00_MainMenu_LoadBaseTiles.2bpp: $(SRC)/data/bank_11/Gfx_11_4F00_MainMenu_LoadBaseTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_5000_MainMenu_DrawUpperItem1.2bpp: $(SRC)/data/bank_11/Gfx_11_5000_MainMenu_DrawUpperItem1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_5200_MainMenu_DrawUpperItem0.2bpp: $(SRC)/data/bank_11/Gfx_11_5200_MainMenu_DrawUpperItem0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_5300_MainMenu_DrawUpperItem1.2bpp: $(SRC)/data/bank_11/Gfx_11_5300_MainMenu_DrawUpperItem1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_5400_MainMenuUpperItemFramesA.2bpp: $(SRC)/data/bank_11/Gfx_11_5400_MainMenuUpperItemFramesA.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_5500_MainMenu_DrawUpperItem0.2bpp: $(SRC)/data/bank_11/Gfx_11_5500_MainMenu_DrawUpperItem0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_5600_MainMenu_DrawUpperItem1.2bpp: $(SRC)/data/bank_11/Gfx_11_5600_MainMenu_DrawUpperItem1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7000_Mode18_State00_Init.2bpp: $(SRC)/data/bank_11/Gfx_11_7000_Mode18_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7200_Icon06_5D43.2bpp: $(SRC)/data/bank_11/Gfx_11_7200_Icon06_5D43.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7300_Icon06_5D43.2bpp: $(SRC)/data/bank_11/Gfx_11_7300_Icon06_5D43.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7400_Icon06_5D43.2bpp: $(SRC)/data/bank_11/Gfx_11_7400_Icon06_5D43.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7500_Icon06_5D43.2bpp: $(SRC)/data/bank_11/Gfx_11_7500_Icon06_5D43.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7600_Icon06_5D43.2bpp: $(SRC)/data/bank_11/Gfx_11_7600_Icon06_5D43.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7000_Compose_DrawJitter_Part7700.2bpp: $(SRC)/data/bank_11/Gfx_11_7000_Compose_DrawJitter_Part7700.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7800_Mode18_State00_Init.2bpp: $(SRC)/data/bank_11/Gfx_11_7800_Mode18_State00_Init.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7C40_Mode18_DrawThumbFrame.2bpp: $(SRC)/data/bank_11/Gfx_11_7C40_Mode18_DrawThumbFrame.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7D00_Icon06_5D43.2bpp: $(SRC)/data/bank_11/Gfx_11_7D00_Icon06_5D43.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7E00_Icon06_5D43.2bpp: $(SRC)/data/bank_11/Gfx_11_7E00_Icon06_5D43.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_11/Gfx_11_7800_Compose_DrawJitter_Part7F00.2bpp: $(SRC)/data/bank_11/Gfx_11_7800_Compose_DrawJitter_Part7F00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4000_Mode06_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_4000_Mode06_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4010_Mode06_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_4010_Mode06_State00_Init.png
	$(RGBGFX) -x 1 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4800_Mode06_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_4800_Mode06_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_48B0_LinkMenu_LoadTilesSelected.2bpp: $(SRC)/data/bank_12/Gfx_12_48B0_LinkMenu_LoadTilesSelected.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4990_LinkMenu_LoadTilesDeselected.2bpp: $(SRC)/data/bank_12/Gfx_12_4990_LinkMenu_LoadTilesDeselected.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_49A0_LinkMenu_LoadTilesDeselected.2bpp: $(SRC)/data/bank_12/Gfx_12_49A0_LinkMenu_LoadTilesDeselected.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4A30_LinkMenu_LoadTilesSelected.2bpp: $(SRC)/data/bank_12/Gfx_12_4A30_LinkMenu_LoadTilesSelected.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4A40_LinkMenu_LoadTilesDeselected.2bpp: $(SRC)/data/bank_12/Gfx_12_4A40_LinkMenu_LoadTilesDeselected.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4B10_LinkMenu_LoadTilesSelected.2bpp: $(SRC)/data/bank_12/Gfx_12_4B10_LinkMenu_LoadTilesSelected.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4B30_LinkMenu_LoadTilesSelected.2bpp: $(SRC)/data/bank_12/Gfx_12_4B30_LinkMenu_LoadTilesSelected.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4BB0_LinkMenu_LoadTilesDeselected.2bpp: $(SRC)/data/bank_12/Gfx_12_4BB0_LinkMenu_LoadTilesDeselected.png
	$(RGBGFX) -x 7 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_4E40_LinkMenu_LoadTilesDeselected.2bpp: $(SRC)/data/bank_12/Gfx_12_4E40_LinkMenu_LoadTilesDeselected.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_5000_Mode06_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_5000_Mode06_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_5800_Mode21_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_5800_Mode21_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_6000_Mode21_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_6000_Mode21_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_6800_Mode21_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_6800_Mode21_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_12/Gfx_12_7000_Mode03_State00_Init.2bpp: $(SRC)/data/bank_12/Gfx_12_7000_Mode03_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_4000_Mode02_State00_Init.2bpp: $(SRC)/data/bank_13/Gfx_13_4000_Mode02_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_4800_Mode02_State00_Init.2bpp: $(SRC)/data/bank_13/Gfx_13_4800_Mode02_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_5000_Mode02_State00_Init.2bpp: $(SRC)/data/bank_13/Gfx_13_5000_Mode02_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_5800_Mode0F_State00_Init.2bpp: $(SRC)/data/bank_13/Gfx_13_5800_Mode0F_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_5830_PhotoPicker_LoadPageTabsFor.2bpp: $(SRC)/data/bank_13/Gfx_13_5830_PhotoPicker_LoadPageTabsFor.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_5880_Mode0F_State0A_EraseAll.2bpp: $(SRC)/data/bank_13/Gfx_13_5880_Mode0F_State0A_EraseAll.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_5950_Mode0F_DrawCopyCount.2bpp: $(SRC)/data/bank_13/Gfx_13_5950_Mode0F_DrawCopyCount.png
	$(RGBGFX) -x 11 -o $@ $<

$(BUILD)/data/bank_13/Unused_TCRF_AlbumHandGestures_Gfx.2bpp: $(SRC)/data/bank_13/Unused_TCRF_AlbumHandGestures_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_5D00_Mode0F_State00_Init_Cont.2bpp: $(SRC)/data/bank_13/Gfx_13_5D00_Mode0F_State00_Init_Cont.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_6800_Icon04_44DC.2bpp: $(SRC)/data/bank_13/Gfx_13_6800_Icon04_44DC.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_6900_Icon04_44DC.2bpp: $(SRC)/data/bank_13/Gfx_13_6900_Icon04_44DC.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_6A00_Icon04_44DC.2bpp: $(SRC)/data/bank_13/Gfx_13_6A00_Icon04_44DC.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_6B00_Icon04_44DC.2bpp: $(SRC)/data/bank_13/Gfx_13_6B00_Icon04_44DC.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_6C00_Icon04_44DC.2bpp: $(SRC)/data/bank_13/Gfx_13_6C00_Icon04_44DC.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_6D00_Icon04_44DC.2bpp: $(SRC)/data/bank_13/Gfx_13_6D00_Icon04_44DC.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_7000_Mode08_CreditsReal.2bpp: $(SRC)/data/bank_13/Gfx_13_7000_Mode08_CreditsReal.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_13/Gfx_13_7800_Mode08_CreditsReal.2bpp: $(SRC)/data/bank_13/Gfx_13_7800_Mode08_CreditsReal.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_5800_Mode0D_State00_Init.2bpp: $(SRC)/data/bank_14/Gfx_14_5800_Mode0D_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_6000_Mode0D_State00_Init.2bpp: $(SRC)/data/bank_14/Gfx_14_6000_Mode0D_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_6800_Mode0D_State00_Init.2bpp: $(SRC)/data/bank_14/Gfx_14_6800_Mode0D_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_7000_PenMenu_Build.2bpp: $(SRC)/data/bank_14/Gfx_14_7000_PenMenu_Build.png
	$(RGBGFX) -x 13 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_7430_Mode10_State02_Setup.2bpp: $(SRC)/data/bank_14/Gfx_14_7430_Mode10_State02_Setup.png
	$(RGBGFX) -x 5 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_75E0_PenMenu_Build.2bpp: $(SRC)/data/bank_14/Gfx_14_75E0_PenMenu_Build.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_7600_PenMenu_Build.2bpp: $(SRC)/data/bank_14/Gfx_14_7600_PenMenu_Build.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Sheet_MiscellaneousDoodleRips_14_76B0.2bpp: $(SRC)/data/bank_14/Sheet_MiscellaneousDoodleRips_14_76B0.png
	$(RGBGFX) -x 11 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_7A00_PenMenu_Build.2bpp: $(SRC)/data/bank_14/Gfx_14_7A00_PenMenu_Build.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_14/Sheet_MiscellaneousDoodleRips_14_7A80.2bpp: $(SRC)/data/bank_14/Sheet_MiscellaneousDoodleRips_14_7A80.png
	$(RGBGFX) -x 5 -o $@ $<

$(BUILD)/data/bank_14/Gfx_14_7E30_Mode10_State02_Setup.2bpp: $(SRC)/data/bank_14/Gfx_14_7E30_Mode10_State02_Setup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4000_MainMenu_LoadBackground.2bpp: $(SRC)/data/bank_15/Gfx_15_4000_MainMenu_LoadBackground.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Gfx.2bpp: $(SRC)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4490_MainMenu_LoadBackground_Cont.2bpp: $(SRC)/data/bank_15/Gfx_15_4490_MainMenu_LoadBackground_Cont.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx.2bpp: $(SRC)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4510_MainMenu_LoadBackground_Cont.2bpp: $(SRC)/data/bank_15/Gfx_15_4510_MainMenu_LoadBackground_Cont.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx.2bpp: $(SRC)/data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4590_MainMenu_LoadBackground_Cont.2bpp: $(SRC)/data/bank_15/Gfx_15_4590_MainMenu_LoadBackground_Cont.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4600_Mode00_State00_Init.2bpp: $(SRC)/data/bank_15/Gfx_15_4600_Mode00_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4900_Mode00_State00_Init.2bpp: $(SRC)/data/bank_15/Gfx_15_4900_Mode00_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4A00_MainMenu_LoadBackground.2bpp: $(SRC)/data/bank_15/Gfx_15_4A00_MainMenu_LoadBackground.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4B00_MainMenu_LoadBackground.2bpp: $(SRC)/data/bank_15/Gfx_15_4B00_MainMenu_LoadBackground.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4C00_MainMenu_LoadBackground.2bpp: $(SRC)/data/bank_15/Gfx_15_4C00_MainMenu_LoadBackground.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4D00_MainMenu_LoadBackground.2bpp: $(SRC)/data/bank_15/Gfx_15_4D00_MainMenu_LoadBackground.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_4E00_MainMenu_LoadBaseTiles.2bpp: $(SRC)/data/bank_15/Gfx_15_4E00_MainMenu_LoadBaseTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5000_MainMenu_DrawUpperItem2.2bpp: $(SRC)/data/bank_15/Gfx_15_5000_MainMenu_DrawUpperItem2.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5200_MainMenu_DrawUpperItem2_Aux.2bpp: $(SRC)/data/bank_15/Gfx_15_5200_MainMenu_DrawUpperItem2_Aux.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5400_Mode00_State00_Init.2bpp: $(SRC)/data/bank_15/Gfx_15_5400_Mode00_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5500_SlidePlay_ReadKeys_Aux.2bpp: $(SRC)/data/bank_15/Gfx_15_5500_SlidePlay_ReadKeys_Aux.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5600_Mode00_State00_Init.2bpp: $(SRC)/data/bank_15/Gfx_15_5600_Mode00_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5700_Mode04_State00_Init.2bpp: $(SRC)/data/bank_15/Gfx_15_5700_Mode04_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_5F00_Mode04_State00_Init.2bpp: $(SRC)/data/bank_15/Gfx_15_5F00_Mode04_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_6700_Mode04_State00_Init.2bpp: $(SRC)/data/bank_15/Gfx_15_6700_Mode04_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup.2bpp: $(SRC)/data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00.2bpp: $(SRC)/data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_15/Gfx_15_7C00_Mode0E_State06_ExchangeSetup.2bpp: $(SRC)/data/bank_15/Gfx_15_7C00_Mode0E_State06_ExchangeSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_4000_Mode0B_State00_Init.2bpp: $(SRC)/data/bank_16/Gfx_16_4000_Mode0B_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_4800_Mode0B_State00_Init.2bpp: $(SRC)/data/bank_16/Gfx_16_4800_Mode0B_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_5000_Mode0B_State00_Init.2bpp: $(SRC)/data/bank_16/Gfx_16_5000_Mode0B_State00_Init.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_5580_MainMenu_IconStripB_F0.2bpp: $(SRC)/data/bank_16/Gfx_16_5580_MainMenu_IconStripB_F0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_5A80_MainMenu_IconStripB_F1.2bpp: $(SRC)/data/bank_16/Gfx_16_5A80_MainMenu_IconStripB_F1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_5F80_MainMenu_IconStripB_F2.2bpp: $(SRC)/data/bank_16/Gfx_16_5F80_MainMenu_IconStripB_F2.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_6480_MainMenu_IconStripB_F3.2bpp: $(SRC)/data/bank_16/Gfx_16_6480_MainMenu_IconStripB_F3.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_6980_MainMenu_BallHeadAnim_F0.2bpp: $(SRC)/data/bank_16/Gfx_16_6980_MainMenu_BallHeadAnim_F0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_6B80_MainMenu_BallHeadAnim_F1.2bpp: $(SRC)/data/bank_16/Gfx_16_6B80_MainMenu_BallHeadAnim_F1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_6D80_MainMenu_BallHeadAnim_F2.2bpp: $(SRC)/data/bank_16/Gfx_16_6D80_MainMenu_BallHeadAnim_F2.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_6F80_MainMenu_BallHeadAnim_F3.2bpp: $(SRC)/data/bank_16/Gfx_16_6F80_MainMenu_BallHeadAnim_F3.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_7180_MainMenu_BallHeadAnim_F4.2bpp: $(SRC)/data/bank_16/Gfx_16_7180_MainMenu_BallHeadAnim_F4.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref.2bpp: $(SRC)/data/bank_16/Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref.2bpp: $(SRC)/data/bank_16/Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref.2bpp: $(SRC)/data/bank_16/Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref.2bpp: $(SRC)/data/bank_16/Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_16/Gfx_16_7B80_MainMenu_BallHeadAnim_F9.2bpp: $(SRC)/data/bank_16/Gfx_16_7B80_MainMenu_BallHeadAnim_F9.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4000_Shoot_DrawDigitAt_Digits.2bpp: $(SRC)/data/bank_17/Gfx_17_4000_Shoot_DrawDigitAt_Digits.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4140_Mode14_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_4140_Mode14_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4180_Mode14_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_4180_Mode14_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4200_Shoot_LoadTimerScreen_Frames.2bpp: $(SRC)/data/bank_17/Gfx_17_4200_Shoot_LoadTimerScreen_Frames.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4680_Mode0F_State05_ConfirmInit.2bpp: $(SRC)/data/bank_17/Gfx_17_4680_Mode0F_State05_ConfirmInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4680_Compose_Split_DrawMakeBlink_Part4690.2bpp: $(SRC)/data/bank_17/Gfx_17_4680_Compose_Split_DrawMakeBlink_Part4690.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_46A0_Mode0F_State05_ConfirmInit.2bpp: $(SRC)/data/bank_17/Gfx_17_46A0_Mode0F_State05_ConfirmInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4700_Shoot_LoadBurstIcons.2bpp: $(SRC)/data/bank_17/Gfx_17_4700_Shoot_LoadBurstIcons.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4740_Shoot_LoadBurstIcons.2bpp: $(SRC)/data/bank_17/Gfx_17_4740_Shoot_LoadBurstIcons.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4780_Shoot_LoadBurstIcons.2bpp: $(SRC)/data/bank_17/Gfx_17_4780_Shoot_LoadBurstIcons.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_47C0_Shoot_LoadBurstIcons.2bpp: $(SRC)/data/bank_17/Gfx_17_47C0_Shoot_LoadBurstIcons.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4800_Compose_DrawFreeCount.2bpp: $(SRC)/data/bank_17/Gfx_17_4800_Compose_DrawFreeCount.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4820_Shoot_DrawShotsLeft_Digits1to9.2bpp: $(SRC)/data/bank_17/Gfx_17_4820_Shoot_DrawShotsLeft_Digits1to9.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4940_Mode14_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_4940_Mode14_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4950_Shoot_DrawTimerMinutes.2bpp: $(SRC)/data/bank_17/Gfx_17_4950_Shoot_DrawTimerMinutes.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4960_Mode14_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_4960_Mode14_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4980_Mode17_State08_Split_Build.2bpp: $(SRC)/data/bank_17/Gfx_17_4980_Mode17_State08_Split_Build.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4A60_Mode0E_State04_PickDone.2bpp: $(SRC)/data/bank_17/Gfx_17_4A60_Mode0E_State04_PickDone.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4B60_Mode0E_State04_PickDone.2bpp: $(SRC)/data/bank_17/Gfx_17_4B60_Mode0E_State04_PickDone.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4B90_Mode0E_State04_PickDone.2bpp: $(SRC)/data/bank_17/Gfx_17_4B90_Mode0E_State04_PickDone.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_4C00_Shoot_DrawOptionPanel.2bpp: $(SRC)/data/bank_17/Gfx_17_4C00_Shoot_DrawOptionPanel.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_5000_Mode14_State04_OptionsPage.2bpp: $(SRC)/data/bank_17/Gfx_17_5000_Mode14_State04_OptionsPage.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_5400_Shoot_LoadBurstIcons.2bpp: $(SRC)/data/bank_17/Gfx_17_5400_Shoot_LoadBurstIcons.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_5440_Mode14_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_5440_Mode14_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_54E0_Mode14_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_54E0_Mode14_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_5500_Unused_MainMenuTiles.2bpp: $(SRC)/data/bank_17/Gfx_17_5500_Unused_MainMenuTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_6800_Mode13_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_6800_Mode13_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_7000_Mode13_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_7000_Mode13_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_7800_Mode13_State00_Init.2bpp: $(SRC)/data/bank_17/Gfx_17_7800_Mode13_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_17/Gfx_17_7B00_CreditsGirlFrame04.2bpp: $(SRC)/data/bank_17/Gfx_17_7B00_CreditsGirlFrame04.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_4000_Mode05_State00_Init.2bpp: $(SRC)/data/bank_18/Gfx_18_4000_Mode05_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_4800_Mode05_State00_Init.2bpp: $(SRC)/data/bank_18/Gfx_18_4800_Mode05_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_5000_Mode05_State00_Init.2bpp: $(SRC)/data/bank_18/Gfx_18_5000_Mode05_State00_Init.png
	$(RGBGFX) -x 9 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_5470_Mode1E_State00_Init.2bpp: $(SRC)/data/bank_18/Gfx_18_5470_Mode1E_State00_Init.png
	$(RGBGFX) -x 2 -o $@ $<

$(BUILD)/data/bank_18/Unused_TCRF_MarginPrint_BFilmRoll_Gfx.2bpp: $(SRC)/data/bank_18/Unused_TCRF_MarginPrint_BFilmRoll_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_5AB0_Mode1C_DrawOptionScreen_Cont.2bpp: $(SRC)/data/bank_18/Gfx_18_5AB0_Mode1C_DrawOptionScreen_Cont.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_5C70_Mode1E_State00_Init.2bpp: $(SRC)/data/bank_18/Gfx_18_5C70_Mode1E_State00_Init.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_18/Unused_TCRF_MarginPrint_OutlinedText_Gfx.2bpp: $(SRC)/data/bank_18/Unused_TCRF_MarginPrint_OutlinedText_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_6050_Mode1C_DrawOptionScreen_Cont.2bpp: $(SRC)/data/bank_18/Gfx_18_6050_Mode1C_DrawOptionScreen_Cont.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_6470_Mode1B_State00_Init.2bpp: $(SRC)/data/bank_18/Gfx_18_6470_Mode1B_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_6C70_Mode1B_State00_Init.2bpp: $(SRC)/data/bank_18/Gfx_18_6C70_Mode1B_State00_Init.png
	$(RGBGFX) -x 7 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen.2bpp: $(SRC)/data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen_Part7470.2bpp: $(SRC)/data/bank_18/Gfx_18_7400_Mode1C_State02_ShowPrintScreen_Part7470.png
	$(RGBGFX) -x 7 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7900_Mode1C_LoadToggleTiles.2bpp: $(SRC)/data/bank_18/Gfx_18_7900_Mode1C_LoadToggleTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_79C0_Mode1C_LoadToggleTiles.2bpp: $(SRC)/data/bank_18/Gfx_18_79C0_Mode1C_LoadToggleTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7A80_Mode1C_State02_ShowPrintScreen.2bpp: $(SRC)/data/bank_18/Gfx_18_7A80_Mode1C_State02_ShowPrintScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7B00_Mode1C_State02_ShowPrintScreen.2bpp: $(SRC)/data/bank_18/Gfx_18_7B00_Mode1C_State02_ShowPrintScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7BA0_Mode0E_State04_PickDone.2bpp: $(SRC)/data/bank_18/Gfx_18_7BA0_Mode0E_State04_PickDone.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7C40_Mode0F_State05_ConfirmInit.2bpp: $(SRC)/data/bank_18/Gfx_18_7C40_Mode0F_State05_ConfirmInit.png
	$(RGBGFX) -x 14 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7D60_Mode0F_State05_ConfirmInit.2bpp: $(SRC)/data/bank_18/Gfx_18_7D60_Mode0F_State05_ConfirmInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7D80_Mode0F_State04_LeaveSelected_Aux.2bpp: $(SRC)/data/bank_18/Gfx_18_7D80_Mode0F_State04_LeaveSelected_Aux.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_18/Gfx_18_7E80_Mode0F_State05_ConfirmInit.2bpp: $(SRC)/data/bank_18/Gfx_18_7E80_Mode0F_State05_ConfirmInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_4760_Mode0E_State00_Init.2bpp: $(SRC)/data/bank_19/Gfx_19_4760_Mode0E_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_4800_Mode0E_State00_Init.2bpp: $(SRC)/data/bank_19/Gfx_19_4800_Mode0E_State00_Init.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_4F60_Mode0E_State00_Init.2bpp: $(SRC)/data/bank_19/Gfx_19_4F60_Mode0E_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_5000_Mode0E_State00_Init.2bpp: $(SRC)/data/bank_19/Gfx_19_5000_Mode0E_State00_Init.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA.2bpp: $(SRC)/data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA.png
	$(RGBGFX) -x 6 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA_Part5800.2bpp: $(SRC)/data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA_Part5800.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_5A60_Mode08_State13_CreditsPageA.2bpp: $(SRC)/data/bank_19/Gfx_19_5A60_Mode08_State13_CreditsPageA.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_6260_Mode08_State13_CreditsPageA.2bpp: $(SRC)/data/bank_19/Gfx_19_6260_Mode08_State13_CreditsPageA.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_6460_Mode21_State0B_ResultSetup.2bpp: $(SRC)/data/bank_19/Gfx_19_6460_Mode21_State0B_ResultSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_6560_Mode21_State0B_ResultSetup.2bpp: $(SRC)/data/bank_19/Gfx_19_6560_Mode21_State0B_ResultSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_19/Gfx_19_6D60_Mode21_State0B_ResultSetup.2bpp: $(SRC)/data/bank_19/Gfx_19_6D60_Mode21_State0B_ResultSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_4000_Mode1F_State04_PerformanceSetup.2bpp: $(SRC)/data/bank_1a/Gfx_1A_4000_Mode1F_State04_PerformanceSetup.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_4D60_DjPerf_DrawTempo.2bpp: $(SRC)/data/bank_1a/Gfx_1A_4D60_DjPerf_DrawTempo.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_4E00_Mode1F_State05_Performance.2bpp: $(SRC)/data/bank_1a/Gfx_1A_4E00_Mode1F_State05_Performance.png
	$(RGBGFX) -x 6 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_50A0_Mode1F_State06_SavePanel.2bpp: $(SRC)/data/bank_1a/Gfx_1A_50A0_Mode1F_State06_SavePanel.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_5200_Mode08_State03_CardInit.2bpp: $(SRC)/data/bank_1a/Gfx_1A_5200_Mode08_State03_CardInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_5A00_Mode08_State03_CardInit.2bpp: $(SRC)/data/bank_1a/Gfx_1A_5A00_Mode08_State03_CardInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_6400_Mode20_State00_MenuInit.2bpp: $(SRC)/data/bank_1a/Gfx_1A_6400_Mode20_State00_MenuInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_6C00_Mode20_State00_MenuInit.2bpp: $(SRC)/data/bank_1a/Gfx_1A_6C00_Mode20_State00_MenuInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_7400_Mode20_State00_MenuInit.2bpp: $(SRC)/data/bank_1a/Gfx_1A_7400_Mode20_State00_MenuInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_7600_Album_ShowPageScreenB.2bpp: $(SRC)/data/bank_1a/Gfx_1A_7600_Album_ShowPageScreenB.png
	$(RGBGFX) -x 7 -o $@ $<

$(BUILD)/data/bank_1a/Gfx_1A_7C90_Album_ShowPageScreenB_ArrowGlyph.2bpp: $(SRC)/data/bank_1a/Gfx_1A_7C90_Album_ShowPageScreenB_ArrowGlyph.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1b/Gfx_1B_4000_Mode1C_State08_PrintJob.2bpp: $(SRC)/data/bank_1b/Gfx_1B_4000_Mode1C_State08_PrintJob.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1b/Gfx_1B_4800_Mode1C_State08_PrintJob.2bpp: $(SRC)/data/bank_1b/Gfx_1B_4800_Mode1C_State08_PrintJob.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1b/Gfx_1B_5100_Mode20_State09_ResultInit.2bpp: $(SRC)/data/bank_1b/Gfx_1B_5100_Mode20_State09_ResultInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1b/Gfx_1B_6100_Mode21_State02_RaceSceneInit.2bpp: $(SRC)/data/bank_1b/Gfx_1B_6100_Mode21_State02_RaceSceneInit.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_1b/Gfx_1B_6680_Mode21_State02_RaceSceneInit.2bpp: $(SRC)/data/bank_1b/Gfx_1B_6680_Mode21_State02_RaceSceneInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1b/Gfx_1B_6E80_Run_DrawTimerDigitB.2bpp: $(SRC)/data/bank_1b/Gfx_1B_6E80_Run_DrawTimerDigitB.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_1b/Gfx_1B_7100_Mode1D_State06_LoadWaitScreen.2bpp: $(SRC)/data/bank_1b/Gfx_1B_7100_Mode1D_State06_LoadWaitScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_44B0_Parlor_Page1.2bpp: $(SRC)/data/bank_1c/Gfx_1C_44B0_Parlor_Page1.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_1c/TileGap_1C_5160.2bpp: $(SRC)/data/bank_1c/TileGap_1C_5160.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete.2bpp: $(SRC)/data/bank_1c/Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_53A0_Mode1A_State02_Setup.2bpp: $(SRC)/data/bank_1c/Gfx_1C_53A0_Mode1A_State02_Setup.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5600_Album_ShowPageScreenB.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5600_Album_ShowPageScreenB.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/TileGap_1C_5620.2bpp: $(SRC)/data/bank_1c/TileGap_1C_5620.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5710_HotSpotEd_ShowJump.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5710_HotSpotEd_ShowJump.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/TileGap_1C_5720.2bpp: $(SRC)/data/bank_1c/TileGap_1C_5720.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5760_HotSpotEd_ShowEffectIcon.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5760_HotSpotEd_ShowEffectIcon.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_58A0_Mode0C_State02_Setup.2bpp: $(SRC)/data/bank_1c/Gfx_1C_58A0_Mode0C_State02_Setup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Unused_TCRF_HotSpotEffectIcons_Extra_Gfx.2bpp: $(SRC)/data/bank_1c/Unused_TCRF_HotSpotEffectIcons_Extra_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5B20_Mode0C_State02_Setup_Cont.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5B20_Mode0C_State02_Setup_Cont.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5B60_Mode0C_State02_Setup.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5B60_Mode0C_State02_Setup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5B80_Mode09_State02_PhotoArrows.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5B80_Mode09_State02_PhotoArrows.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/TileGap_1C_5BC0.2bpp: $(SRC)/data/bank_1c/TileGap_1C_5BC0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5BE0_Mode09_State02_PhotoArrows.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5BE0_Mode09_State02_PhotoArrows.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5C20_Mode09_State02_PhotoArrows_Aux.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5C20_Mode09_State02_PhotoArrows_Aux.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5C60_Mode0C_State02_Setup.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5C60_Mode0C_State02_Setup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5C80_Mode09_State02_PhotoArrows.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5C80_Mode09_State02_PhotoArrows.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/TileGap_1C_5CC0.2bpp: $(SRC)/data/bank_1c/TileGap_1C_5CC0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5CE0_Mode09_State02_PhotoArrows.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5CE0_Mode09_State02_PhotoArrows.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/TileGap_1C_5D20.2bpp: $(SRC)/data/bank_1c/TileGap_1C_5D20.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_5E60_Link_ShowScreenA.2bpp: $(SRC)/data/bank_1c/Gfx_1C_5E60_Link_ShowScreenA.png
	$(RGBGFX) -x 15 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_6570_Link_ShowScreenA.2bpp: $(SRC)/data/bank_1c/Gfx_1C_6570_Link_ShowScreenA.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_6660_Link_ShowScreenA.2bpp: $(SRC)/data/bank_1c/Gfx_1C_6660_Link_ShowScreenA.png
	$(RGBGFX) -x 1 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_6D50_Link_ShowScreenB.2bpp: $(SRC)/data/bank_1c/Gfx_1C_6D50_Link_ShowScreenB.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_6D60_Mode1F_State07_QuitPanel_Part6DE0.2bpp: $(SRC)/data/bank_1c/Gfx_1C_6D60_Mode1F_State07_QuitPanel_Part6DE0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_7260_Mode1F_State08_EditPagesSetup.2bpp: $(SRC)/data/bank_1c/Gfx_1C_7260_Mode1F_State08_EditPagesSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1c/Gfx_1C_7860_Mode1F_State08_EditPagesSetup.2bpp: $(SRC)/data/bank_1c/Gfx_1C_7860_Mode1F_State08_EditPagesSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4000_Mode1F_State08_EditPagesSetup.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4000_Mode1F_State08_EditPagesSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4300_Mode1F_State08_EditPagesSetup.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4300_Mode1F_State08_EditPagesSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4500_Mode1F_State09_PageSound1.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4500_Mode1F_State09_PageSound1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4800_Mode1F_State09_PageSound1.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4800_Mode1F_State09_PageSound1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4A00_Mode1F_State0A_PageSound2.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4A00_Mode1F_State0A_PageSound2.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4D00_Mode1F_State0A_PageSound2.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4D00_Mode1F_State0A_PageSound2.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_4F00_ResultPic3_Equator_Tune2A.2bpp: $(SRC)/data/bank_1d/Gfx_1D_4F00_ResultPic3_Equator_Tune2A.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Gfx_1D_7860_Mode1F_State08_EditPagesSetup.2bpp: $(SRC)/data/bank_1d/Gfx_1D_7860_Mode1F_State08_EditPagesSetup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1d/Sheet_MiscellaneousStampsJpn_1D_78E0.2bpp: $(SRC)/data/bank_1d/Sheet_MiscellaneousStampsJpn_1D_78E0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_4000_ResultPic2_RibbonWoman_Tune30.2bpp: $(SRC)/data/bank_1e/Gfx_1E_4000_ResultPic2_RibbonWoman_Tune30.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_4E00_ResultPic0_HornedMan_Tune28.2bpp: $(SRC)/data/bank_1e/Gfx_1E_4E00_ResultPic0_HornedMan_Tune28.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_5C00_Mode17_State00_Init.2bpp: $(SRC)/data/bank_1e/Gfx_1E_5C00_Mode17_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_5F00_Mode17_State00_Init.2bpp: $(SRC)/data/bank_1e/Gfx_1E_5F00_Mode17_State00_Init.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_6480_Mode17_State00_Init.2bpp: $(SRC)/data/bank_1e/Gfx_1E_6480_Mode17_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_64B0_Compose_DrawPhotoNumber_AlbumLetter.2bpp: $(SRC)/data/bank_1e/Gfx_1E_64B0_Compose_DrawPhotoNumber_AlbumLetter.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits.2bpp: $(SRC)/data/bank_1e/Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_6570_Mode17_State00_Init.2bpp: $(SRC)/data/bank_1e/Gfx_1E_6570_Mode17_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_6580_Mode17_State00_Init.2bpp: $(SRC)/data/bank_1e/Gfx_1E_6580_Mode17_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_1e/Gfx_1E_6A00_ResultPic1_BaldMan_Tune29Totaka.2bpp: $(SRC)/data/bank_1e/Gfx_1E_6A00_ResultPic1_BaldMan_Tune29Totaka.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_4000_Mode08_State14_CreditsPageB.2bpp: $(SRC)/data/bank_20/Gfx_20_4000_Mode08_State14_CreditsPageB.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_4800_Mode08_State14_CreditsPageB.2bpp: $(SRC)/data/bank_20/Gfx_20_4800_Mode08_State14_CreditsPageB.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_4E00_Mode08_State0C_RecordInit.2bpp: $(SRC)/data/bank_20/Gfx_20_4E00_Mode08_State0C_RecordInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_5600_Mode08_State0C_RecordInit.2bpp: $(SRC)/data/bank_20/Gfx_20_5600_Mode08_State0C_RecordInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_5B00_Mode08_State06_EditorInit.2bpp: $(SRC)/data/bank_20/Gfx_20_5B00_Mode08_State06_EditorInit.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_6080_Mode08_State06_EditorInit.2bpp: $(SRC)/data/bank_20/Gfx_20_6080_Mode08_State06_EditorInit.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_64C0_OwnerCard_LoadGenderTiles.2bpp: $(SRC)/data/bank_20/Gfx_20_64C0_OwnerCard_LoadGenderTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_6680_OwnerCard_LoadBloodTiles.2bpp: $(SRC)/data/bank_20/Gfx_20_6680_OwnerCard_LoadBloodTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_66C0_Kb_Page0_Press.2bpp: $(SRC)/data/bank_20/Gfx_20_66C0_Kb_Page0_Press.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_6800_Mode15_State01_TimerInit.2bpp: $(SRC)/data/bank_20/Gfx_20_6800_Mode15_State01_TimerInit.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_6E40_Mode15_State01_TimerInit.2bpp: $(SRC)/data/bank_20/Gfx_20_6E40_Mode15_State01_TimerInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_6EC0_Mode15_State01_TimerInit.2bpp: $(SRC)/data/bank_20/Gfx_20_6EC0_Mode15_State01_TimerInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_6F20_Mode15_State01_TimerInit.2bpp: $(SRC)/data/bank_20/Gfx_20_6F20_Mode15_State01_TimerInit.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_70E0_Mode15_DrawTwoDigitsInterval.2bpp: $(SRC)/data/bank_20/Gfx_20_70E0_Mode15_DrawTwoDigitsInterval.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_7180_Mode15_DrawTwoDigits.2bpp: $(SRC)/data/bank_20/Gfx_20_7180_Mode15_DrawTwoDigits.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_74F0_Mode15_State01_TimerInit.2bpp: $(SRC)/data/bank_20/Gfx_20_74F0_Mode15_State01_TimerInit.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_20/Gfx_20_7D00_Mode1D_State01_LoadScreen.2bpp: $(SRC)/data/bank_20/Gfx_20_7D00_Mode1D_State01_LoadScreen.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_4000_Mode07_State00_Init.2bpp: $(SRC)/data/bank_21/Gfx_21_4000_Mode07_State00_Init.png
	$(RGBGFX) -x 11 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_4750_SpaceFever_LoadHudTiles.2bpp: $(SRC)/data/bank_21/Gfx_21_4750_SpaceFever_LoadHudTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_4800_Mode07_State00_Init.2bpp: $(SRC)/data/bank_21/Gfx_21_4800_Mode07_State00_Init.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_4850_SpaceFever_LoadHudTiles.2bpp: $(SRC)/data/bank_21/Gfx_21_4850_SpaceFever_LoadHudTiles.png
	$(RGBGFX) -x 5 -o $@ $<

$(BUILD)/data/bank_21/Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00.2bpp: $(SRC)/data/bank_21/Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_4D00_CommentCard_DrawPhotoNumber_Tens.2bpp: $(SRC)/data/bank_21/Gfx_21_4D00_CommentCard_DrawPhotoNumber_Tens.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_4E00_CommentCard_DrawPhotoNumber_Ones.2bpp: $(SRC)/data/bank_21/Gfx_21_4E00_CommentCard_DrawPhotoNumber_Ones.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_5080_CommentCard_DrawDigit.2bpp: $(SRC)/data/bank_21/Gfx_21_5080_CommentCard_DrawDigit.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_54E0_CommentCard_DrawBlood_Far.2bpp: $(SRC)/data/bank_21/Gfx_21_54E0_CommentCard_DrawBlood_Far.png
	$(RGBGFX) -x 12 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_56C0_CommentCard_DrawNumber.2bpp: $(SRC)/data/bank_21/Gfx_21_56C0_CommentCard_DrawNumber.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_56D0_CommentCard_DrawGender_Far.2bpp: $(SRC)/data/bank_21/Gfx_21_56D0_CommentCard_DrawGender_Far.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_5790_CommentCard_DrawCopyBadge_Far.2bpp: $(SRC)/data/bank_21/Gfx_21_5790_CommentCard_DrawCopyBadge_Far.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_71C0_Mode19_State00_CopyrightScreens.2bpp: $(SRC)/data/bank_21/Gfx_21_71C0_Mode19_State00_CopyrightScreens.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Gfx_21_77C0_BorderPicker_Substate0_Init.2bpp: $(SRC)/data/bank_21/Gfx_21_77C0_BorderPicker_Substate0_Init.png
	$(RGBGFX) -x 1 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_4000_CreditsGirlFrame03.2bpp: $(SRC)/data/bank_22/Gfx_22_4000_CreditsGirlFrame03.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_4500_CreditsNishimuraDanceFrame00.2bpp: $(SRC)/data/bank_22/Gfx_22_4500_CreditsNishimuraDanceFrame00.png
	$(RGBGFX) -x 9 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_4970_CreditsNishimuraDanceFrame01.2bpp: $(SRC)/data/bank_22/Gfx_22_4970_CreditsNishimuraDanceFrame01.png
	$(RGBGFX) -x 9 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_4DE0_CreditsGirlFrame10.2bpp: $(SRC)/data/bank_22/Gfx_22_4DE0_CreditsGirlFrame10.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_5240_CreditsGirlFrame02_Part52E0.2bpp: $(SRC)/data/bank_22/Gfx_22_5240_CreditsGirlFrame02_Part52E0.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_56A0_CreditsGirlFrame07_Part5740.2bpp: $(SRC)/data/bank_22/Gfx_22_56A0_CreditsGirlFrame07_Part5740.png
	$(RGBGFX) -x 10 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_5B00_CreditsGirlFrame11_Part5BA0.2bpp: $(SRC)/data/bank_22/Gfx_22_5B00_CreditsGirlFrame11_Part5BA0.png
	$(RGBGFX) -x 6 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_6740_Mode11_State02_Setup.2bpp: $(SRC)/data/bank_22/Gfx_22_6740_Mode11_State02_Setup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_6810_Mode11_State02_Setup.2bpp: $(SRC)/data/bank_22/Gfx_22_6810_Mode11_State02_Setup.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_6A90_Mode11_State04_Place.2bpp: $(SRC)/data/bank_22/Gfx_22_6A90_Mode11_State04_Place.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_6AA0_Mode1A_State02_Setup.2bpp: $(SRC)/data/bank_22/Gfx_22_6AA0_Mode1A_State02_Setup.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_22/Gfx_22_6F40_CreditsGirlFrame08.2bpp: $(SRC)/data/bank_22/Gfx_22_6F40_CreditsGirlFrame08.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_4000_CreditsGirlFrame09.2bpp: $(SRC)/data/bank_23/Gfx_23_4000_CreditsGirlFrame09.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_50C0_Mode16_State08_StartShoot.2bpp: $(SRC)/data/bank_23/Gfx_23_50C0_Mode16_State08_StartShoot.png
	$(RGBGFX) -x 7 -o $@ $<

$(BUILD)/data/bank_23/Gfx_23_6C80_CreditsGirlFrame12.2bpp: $(SRC)/data/bank_23/Gfx_23_6C80_CreditsGirlFrame12.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_4000_CreditsGirlFrame01.2bpp: $(SRC)/data/bank_24/Gfx_24_4000_CreditsGirlFrame01.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_57E0_Unused_Link_LoadTiles.2bpp: $(SRC)/data/bank_24/Gfx_24_57E0_Unused_Link_LoadTiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_24/Gfx_24_57E0_Cam_FactoryDiag_AllButtonsExceptB_Part58E0.2bpp: $(SRC)/data/bank_24/Gfx_24_57E0_Cam_FactoryDiag_AllButtonsExceptB_Part58E0.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_4000_CreditsGirlFrame05.2bpp: $(SRC)/data/bank_25/Gfx_25_4000_CreditsGirlFrame05.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_4480_Mode08_State14_CreditsPageB.2bpp: $(SRC)/data/bank_25/Gfx_25_4480_Mode08_State14_CreditsPageB.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_25/Gfx_25_4480_CreditsGirlFrame00_Part4500.2bpp: $(SRC)/data/bank_25/Gfx_25_4480_CreditsGirlFrame00_Part4500.png
	$(RGBGFX) -x 4 -o $@ $<

$(BUILD)/data/bank_26/Gfx_26_4000_CreditsGirlFrame06.2bpp: $(SRC)/data/bank_26/Gfx_26_4000_CreditsGirlFrame06.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_26/Gfx_26_4880_Mode1A_State03_Browse.2bpp: $(SRC)/data/bank_26/Gfx_26_4880_Mode1A_State03_Browse.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_27/Gfx_27_4000_Mode1D_State01_LoadScreen.2bpp: $(SRC)/data/bank_27/Gfx_27_4000_Mode1D_State01_LoadScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_27/Gfx_27_4800_Mode1D_State01_LoadScreen.2bpp: $(SRC)/data/bank_27/Gfx_27_4800_Mode1D_State01_LoadScreen.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_27/Gfx_27_4C00_CreditsNishimuraDanceFrame02.2bpp: $(SRC)/data/bank_27/Gfx_27_4C00_CreditsNishimuraDanceFrame02.png
	$(RGBGFX) -x 9 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4000_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_4000_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4280_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_4280_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4500_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_4500_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4780_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_4780_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4A00_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_4A00_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4C80_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_4C80_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_4F00_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_4F00_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_5180_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_5180_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_5400_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_5400_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_5680_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_5680_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_5900_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_5900_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_5B80_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_5B80_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_5E00_MsgStripB.2bpp: $(SRC)/data/bank_28/Gfx_28_5E00_MsgStripB.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_7000_CreditsEndingPlate_TilesA.2bpp: $(SRC)/data/bank_28/Gfx_28_7000_CreditsEndingPlate_TilesA.png
	$(RGBGFX) -x 7 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_7790_CreditsEndingPlate_TilesB.2bpp: $(SRC)/data/bank_28/Gfx_28_7790_CreditsEndingPlate_TilesB.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_28/Gfx_28_7800_Mode08_State16_CreditsScroll.2bpp: $(SRC)/data/bank_28/Gfx_28_7800_Mode08_State16_CreditsScroll.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Gfx_2A_44F4_FontSlots27to28.2bpp: $(SRC)/data/bank_2a/Gfx_2A_44F4_FontSlots27to28.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Font_2A_5160_Glyph8C.2bpp: $(SRC)/data/bank_2a/Font_2A_5160_Glyph8C.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Font_2A_5180_Glyphs8Dto94.2bpp: $(SRC)/data/bank_2a/Font_2A_5180_Glyphs8Dto94.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Font_2A_5280_Glyphs95to96.2bpp: $(SRC)/data/bank_2a/Font_2A_5280_Glyphs95to96.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Font_2A_52C0_Glyphs97to9C.2bpp: $(SRC)/data/bank_2a/Font_2A_52C0_Glyphs97to9C.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Font_2A_5380_Glyphs9Dto9E.2bpp: $(SRC)/data/bank_2a/Font_2A_5380_Glyphs9Dto9E.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Font_2A_53C0_Glyph9F.2bpp: $(SRC)/data/bank_2a/Font_2A_53C0_Glyph9F.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Gfx_2A_54B0_FontSlotA5.2bpp: $(SRC)/data/bank_2a/Gfx_2A_54B0_FontSlotA5.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2a/Gfx_2A_54D0_FontSlotA6.2bpp: $(SRC)/data/bank_2a/Gfx_2A_54D0_FontSlotA6.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_31/WildFrame0_Tiles.2bpp: $(SRC)/data/bank_31/WildFrame0_Tiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_31/WildFrame1_Tiles.2bpp: $(SRC)/data/bank_31/WildFrame1_Tiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_31/WildFrame2_Tiles.2bpp: $(SRC)/data/bank_31/WildFrame2_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_32/WildFrame3_Tiles.2bpp: $(SRC)/data/bank_32/WildFrame3_Tiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_32/WildFrame4_Tiles.2bpp: $(SRC)/data/bank_32/WildFrame4_Tiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_32/WildFrame5_Tiles.2bpp: $(SRC)/data/bank_32/WildFrame5_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_33/WildFrame6_Tiles.2bpp: $(SRC)/data/bank_33/WildFrame6_Tiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_33/WildFrame7_Tiles.2bpp: $(SRC)/data/bank_33/WildFrame7_Tiles.png
	$(RGBGFX) -x 8 -o $@ $<

$(BUILD)/data/bank_34/Border00_Tiles.2bpp: $(SRC)/data/bank_34/Border00_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border01_Tiles.2bpp: $(SRC)/data/bank_34/Border01_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border02_Tiles.2bpp: $(SRC)/data/bank_34/Border02_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border03_Tiles.2bpp: $(SRC)/data/bank_34/Border03_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border04_Tiles.2bpp: $(SRC)/data/bank_34/Border04_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border05_Tiles.2bpp: $(SRC)/data/bank_34/Border05_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border06_Tiles.2bpp: $(SRC)/data/bank_34/Border06_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border07_Tiles.2bpp: $(SRC)/data/bank_34/Border07_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Border08_Tiles.2bpp: $(SRC)/data/bank_34/Border08_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border09_Tiles.2bpp: $(SRC)/data/bank_35/Border09_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border10_Tiles.2bpp: $(SRC)/data/bank_35/Border10_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border11_Tiles.2bpp: $(SRC)/data/bank_35/Border11_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border12_Tiles.2bpp: $(SRC)/data/bank_35/Border12_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border13_Tiles.2bpp: $(SRC)/data/bank_35/Border13_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border14_Tiles.2bpp: $(SRC)/data/bank_35/Border14_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border15_Tiles.2bpp: $(SRC)/data/bank_35/Border15_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border16_Tiles.2bpp: $(SRC)/data/bank_35/Border16_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_35/Border17_Tiles.2bpp: $(SRC)/data/bank_35/Border17_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_36/AlbumB_UnusedSlotA_Tiles.2bpp: $(SRC)/data/bank_36/AlbumB_UnusedSlotA_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_36/AlbumB_UnusedSlotB_Tiles.2bpp: $(SRC)/data/bank_36/AlbumB_UnusedSlotB_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_36/AlbumB_Photo01_Tiles.2bpp: $(SRC)/data/bank_36/AlbumB_Photo01_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_36/AlbumB_Photo02_Tiles.2bpp: $(SRC)/data/bank_36/AlbumB_Photo02_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_37/AlbumB_Photo03_Tiles.2bpp: $(SRC)/data/bank_37/AlbumB_Photo03_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_37/AlbumB_Photo04_Tiles.2bpp: $(SRC)/data/bank_37/AlbumB_Photo04_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_37/AlbumB_Photo05_Tiles.2bpp: $(SRC)/data/bank_37/AlbumB_Photo05_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_37/AlbumB_Photo06_Tiles.2bpp: $(SRC)/data/bank_37/AlbumB_Photo06_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_38/AlbumB_Photo07_Tiles.2bpp: $(SRC)/data/bank_38/AlbumB_Photo07_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_39/AlbumB_Photo11_Tiles.2bpp: $(SRC)/data/bank_39/AlbumB_Photo11_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_39/AlbumB_Photo14_Tiles.2bpp: $(SRC)/data/bank_39/AlbumB_Photo14_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3a/AlbumB_Photo15_Tiles.2bpp: $(SRC)/data/bank_3a/AlbumB_Photo15_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3a/AlbumB_Photo16_Tiles.2bpp: $(SRC)/data/bank_3a/AlbumB_Photo16_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3a/AlbumB_Photo17_Tiles.2bpp: $(SRC)/data/bank_3a/AlbumB_Photo17_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3a/AlbumB_Photo18_Tiles.2bpp: $(SRC)/data/bank_3a/AlbumB_Photo18_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3b/AlbumB_Photo19_Tiles.2bpp: $(SRC)/data/bank_3b/AlbumB_Photo19_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3b/AlbumB_Photo20_Tiles.2bpp: $(SRC)/data/bank_3b/AlbumB_Photo20_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3b/AlbumB_Photo21_Tiles.2bpp: $(SRC)/data/bank_3b/AlbumB_Photo21_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3b/AlbumB_Photo22_Tiles.2bpp: $(SRC)/data/bank_3b/AlbumB_Photo22_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3c/AlbumB_Photo23_Tiles.2bpp: $(SRC)/data/bank_3c/AlbumB_Photo23_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3c/AlbumB_Photo24_Tiles.2bpp: $(SRC)/data/bank_3c/AlbumB_Photo24_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3c/AlbumB_Photo25_Tiles.2bpp: $(SRC)/data/bank_3c/AlbumB_Photo25_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3c/AlbumB_Photo26_Tiles.2bpp: $(SRC)/data/bank_3c/AlbumB_Photo26_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3d/AlbumB_Photo27_Tiles.2bpp: $(SRC)/data/bank_3d/AlbumB_Photo27_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3d/AlbumB_Photo28_Tiles.2bpp: $(SRC)/data/bank_3d/AlbumB_Photo28_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3d/AlbumB_Photo29_Tiles.2bpp: $(SRC)/data/bank_3d/AlbumB_Photo29_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3d/AlbumB_Photo30_Tiles.2bpp: $(SRC)/data/bank_3d/AlbumB_Photo30_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3e/Gfx_3E_4000_TitleScene.2bpp: $(SRC)/data/bank_3e/Gfx_3E_4000_TitleScene.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3e/Gfx_3E_4E00_TitleScene.2bpp: $(SRC)/data/bank_3e/Gfx_3E_4E00_TitleScene.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3e/Gfx_3E_5C00_TitleScene.2bpp: $(SRC)/data/bank_3e/Gfx_3E_5C00_TitleScene.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3e/Gfx_3E_6A00_TitleScene.2bpp: $(SRC)/data/bank_3e/Gfx_3E_6A00_TitleScene.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3e/Border18_Tiles.2bpp: $(SRC)/data/bank_3e/Border18_Tiles.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3f/Gfx_3F_4000_TitleScene.2bpp: $(SRC)/data/bank_3f/Gfx_3F_4000_TitleScene.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3f/Gfx_3F_4E00_TitleScene.2bpp: $(SRC)/data/bank_3f/Gfx_3F_4E00_TitleScene.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3f/Gfx_3F_5C00_TitleScene.2bpp: $(SRC)/data/bank_3f/Gfx_3F_5C00_TitleScene.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3f/Gfx_3F_6A00_Mode19_State01_TitleFirst.2bpp: $(SRC)/data/bank_3f/Gfx_3F_6A00_Mode19_State01_TitleFirst.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_3f/Gfx_3F_7100_Mode19_State01_TitleFirst.2bpp: $(SRC)/data/bank_3f/Gfx_3F_7100_Mode19_State01_TitleFirst.png
	$(RGBGFX) -x 8 -o $@ $<

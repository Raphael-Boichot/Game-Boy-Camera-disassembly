# Written by tools/make_source.py: one rule per tile PNG (width 16 tiles; -x = blank tiles at the end of the last row).
GFX := $(BUILD)/data/bank_01/Gfx_01_4001_FNTOOE1.2bpp $(BUILD)/data/bank_02/Gfx_02_4001_FNTOOE2.2bpp $(BUILD)/data/bank_02/Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp $(BUILD)/data/bank_02/Gfx_02_4301_FNTOOE2_Tiles30to3D.2bpp $(BUILD)/data/bank_02/Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp $(BUILD)/data/bank_02/Gfx_02_4401_FNTOOE2_Tiles40to17F.2bpp $(BUILD)/data/bank_03/Gfx_03_4001_FNTOOE3.2bpp $(BUILD)/data/bank_03/Gfx_03_5A41_CONF2.2bpp $(BUILD)/data/bank_05/Unused_TCRF_FacePhoto7_HOI_U_Gfx.2bpp $(BUILD)/data/bank_05/Unused_TCRF_FacePhoto8_HOI_D_Gfx.2bpp $(BUILD)/data/bank_05/Unused_TCRF_FacePhoto9_HOI_L_Gfx.2bpp $(BUILD)/data/bank_05/Unused_TCRF_FacePhoto10_HOI_R_Gfx.2bpp $(BUILD)/data/bank_06/Unused_TCRF_FaceDrawing1_FACE5_Gfx.2bpp $(BUILD)/data/bank_06/Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp $(BUILD)/data/bank_06/Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp $(BUILD)/data/bank_21/Leftover_21_69D5_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp $(BUILD)/data/bank_2e/Leftover_2E_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp $(BUILD)/data/bank_2e/Leftover_2E_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp $(BUILD)/data/bank_30/Unused_TCRF_FacePhoto6_Rows2To13_Gfx.2bpp $(BUILD)/data/bank_30/Unused_TCRF_FacePhoto1_Gfx.2bpp $(BUILD)/data/bank_30/Unused_TCRF_FacePhoto2_Gfx.2bpp $(BUILD)/data/bank_30/Unused_TCRF_FacePhoto3_Gfx.2bpp $(BUILD)/data/bank_31/Leftover_31_4E01_Unused_TCRF_FacePhoto8_HOI_D_Gfx.2bpp $(BUILD)/data/bank_31/Leftover_31_5C01_Unused_TCRF_FacePhoto9_HOI_L_Gfx.2bpp $(BUILD)/data/bank_31/Leftover_31_6A01_Unused_TCRF_FacePhoto10_HOI_R_Gfx.2bpp $(BUILD)/data/bank_32/Leftover_32_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp $(BUILD)/data/bank_32/Leftover_32_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp $(BUILD)/data/bank_32/Leftover_32_6A01_Unused_TCRF_FaceDrawing4_FACE8_Gfx.2bpp $(BUILD)/data/bank_33/Leftover_33_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp $(BUILD)/data/bank_33/Leftover_33_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp $(BUILD)/data/bank_34/Leftover_34_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp $(BUILD)/data/bank_34/Leftover_34_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp $(BUILD)/data/bank_38/Unused_TCRF_TitleLogoNEO_Gfx.2bpp $(BUILD)/data/bank_39/Leftover_39_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp $(BUILD)/data/bank_39/Leftover_39_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp

$(BUILD)/data/bank_01/Gfx_01_4001_FNTOOE1.2bpp: $(SRC)/data/bank_01/Gfx_01_4001_FNTOOE1.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_02/Gfx_02_4001_FNTOOE2.2bpp: $(SRC)/data/bank_02/Gfx_02_4001_FNTOOE2.png
	$(RGBGFX) -x 2 -o $@ $<

$(BUILD)/data/bank_02/Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp: $(SRC)/data/bank_02/Unused_TCRF_ArrowCursor_TopRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_02/Gfx_02_4301_FNTOOE2_Tiles30to3D.2bpp: $(SRC)/data/bank_02/Gfx_02_4301_FNTOOE2_Tiles30to3D.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_02/Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp: $(SRC)/data/bank_02/Unused_TCRF_ArrowCursor_BottomRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_02/Gfx_02_4401_FNTOOE2_Tiles40to17F.2bpp: $(SRC)/data/bank_02/Gfx_02_4401_FNTOOE2_Tiles40to17F.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_03/Gfx_03_4001_FNTOOE3.2bpp: $(SRC)/data/bank_03/Gfx_03_4001_FNTOOE3.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_03/Gfx_03_5A41_CONF2.2bpp: $(SRC)/data/bank_03/Gfx_03_5A41_CONF2.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_05/Unused_TCRF_FacePhoto7_HOI_U_Gfx.2bpp: $(SRC)/data/bank_05/Unused_TCRF_FacePhoto7_HOI_U_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_05/Unused_TCRF_FacePhoto8_HOI_D_Gfx.2bpp: $(SRC)/data/bank_05/Unused_TCRF_FacePhoto8_HOI_D_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_05/Unused_TCRF_FacePhoto9_HOI_L_Gfx.2bpp: $(SRC)/data/bank_05/Unused_TCRF_FacePhoto9_HOI_L_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_05/Unused_TCRF_FacePhoto10_HOI_R_Gfx.2bpp: $(SRC)/data/bank_05/Unused_TCRF_FacePhoto10_HOI_R_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_06/Unused_TCRF_FaceDrawing1_FACE5_Gfx.2bpp: $(SRC)/data/bank_06/Unused_TCRF_FaceDrawing1_FACE5_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_06/Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp: $(SRC)/data/bank_06/Unused_TCRF_FaceDrawing2_FACE6_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_06/Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp: $(SRC)/data/bank_06/Unused_TCRF_FaceDrawing3_FACE7_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_21/Leftover_21_69D5_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp: $(SRC)/data/bank_21/Leftover_21_69D5_Unused_TCRF_ArrowCursor_TopRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2e/Leftover_2E_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp: $(SRC)/data/bank_2e/Leftover_2E_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_2e/Leftover_2E_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp: $(SRC)/data/bank_2e/Leftover_2E_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_30/Unused_TCRF_FacePhoto6_Rows2To13_Gfx.2bpp: $(SRC)/data/bank_30/Unused_TCRF_FacePhoto6_Rows2To13_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_30/Unused_TCRF_FacePhoto1_Gfx.2bpp: $(SRC)/data/bank_30/Unused_TCRF_FacePhoto1_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_30/Unused_TCRF_FacePhoto2_Gfx.2bpp: $(SRC)/data/bank_30/Unused_TCRF_FacePhoto2_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_30/Unused_TCRF_FacePhoto3_Gfx.2bpp: $(SRC)/data/bank_30/Unused_TCRF_FacePhoto3_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_31/Leftover_31_4E01_Unused_TCRF_FacePhoto8_HOI_D_Gfx.2bpp: $(SRC)/data/bank_31/Leftover_31_4E01_Unused_TCRF_FacePhoto8_HOI_D_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_31/Leftover_31_5C01_Unused_TCRF_FacePhoto9_HOI_L_Gfx.2bpp: $(SRC)/data/bank_31/Leftover_31_5C01_Unused_TCRF_FacePhoto9_HOI_L_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_31/Leftover_31_6A01_Unused_TCRF_FacePhoto10_HOI_R_Gfx.2bpp: $(SRC)/data/bank_31/Leftover_31_6A01_Unused_TCRF_FacePhoto10_HOI_R_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_32/Leftover_32_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp: $(SRC)/data/bank_32/Leftover_32_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_32/Leftover_32_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp: $(SRC)/data/bank_32/Leftover_32_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_32/Leftover_32_6A01_Unused_TCRF_FaceDrawing4_FACE8_Gfx.2bpp: $(SRC)/data/bank_32/Leftover_32_6A01_Unused_TCRF_FaceDrawing4_FACE8_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_33/Leftover_33_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp: $(SRC)/data/bank_33/Leftover_33_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_33/Leftover_33_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp: $(SRC)/data/bank_33/Leftover_33_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Leftover_34_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.2bpp: $(SRC)/data/bank_34/Leftover_34_4E01_Unused_TCRF_FaceDrawing2_FACE6_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_34/Leftover_34_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.2bpp: $(SRC)/data/bank_34/Leftover_34_5C01_Unused_TCRF_FaceDrawing3_FACE7_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_38/Unused_TCRF_TitleLogoNEO_Gfx.2bpp: $(SRC)/data/bank_38/Unused_TCRF_TitleLogoNEO_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_39/Leftover_39_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.2bpp: $(SRC)/data/bank_39/Leftover_39_42E1_Unused_TCRF_ArrowCursor_TopRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

$(BUILD)/data/bank_39/Leftover_39_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.2bpp: $(SRC)/data/bank_39/Leftover_39_43E1_Unused_TCRF_ArrowCursor_BottomRow_Gfx.png
	$(RGBGFX) -x 0 -o $@ $<

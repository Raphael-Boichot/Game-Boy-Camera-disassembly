# Pocket Camera (Japan) (Rev A) - build from the editable source tree roms/jp_rev_a/src/ (L5).
# Needs rgbds 1.0.4 (rgbasm, rgblink, rgbfix, rgbgfx) in PATH, or RGBDS=/path/to/rgbds/ (with the trailing slash).
#   make                  build/jp_rev_a/pocketcamera_jp.gb
#   make check            ... and compare its md5 with the original ROM
#   make source ROM=pocketcamera_jp.gb [MGBDIS=/path/to/mgbdis.py]
#                         regenerate roms/jp_rev_a/src/ from the symbol tables - OVERWRITES hand edits in src/
PY      ?= python3
RGBDS   ?=
RGBASM  := $(RGBDS)rgbasm
RGBLINK := $(RGBDS)rgblink
RGBFIX  := $(RGBDS)rgbfix
RGBGFX  := $(RGBDS)rgbgfx
SRC     := roms/jp_rev_a/src
BUILD   := build/jp_rev_a
ROM_MD5 := fdcfe686cf4df461e870b6e53b2b5a8b
TARGET  := $(BUILD)/pocketcamera_jp.gb

include $(SRC)/gfx.mk
BINS    := $(shell find $(SRC)/data -name '*.bin' -o -name '*.tilemap')

all: $(TARGET)

$(GFX): | $(BUILD)/.dirs

$(BUILD)/.dirs:
	@$(PY) -c "import os; [os.makedirs(os.path.join('$(BUILD)', 'data', d), exist_ok=True) for d in os.listdir('$(SRC)/data')]"
	@touch $@

$(BUILD)/game.o: $(wildcard $(SRC)/*.asm $(SRC)/*.inc) $(BINS) $(GFX)
	$(RGBASM) -I $(BUILD)/ -I $(SRC)/ -o $@ $(SRC)/game.asm

$(TARGET): $(BUILD)/game.o
	$(RGBLINK) -n $(BUILD)/pocketcamera_jp.sym -m $(BUILD)/pocketcamera_jp.map -o $@ $<
	$(RGBFIX) -v -p 255 $@

check: $(TARGET)
	@$(PY) -c "import hashlib, sys; m = hashlib.md5(open('$(TARGET)', 'rb').read()).hexdigest(); print('$(TARGET):', m, 'OK' if m == '$(ROM_MD5)' else 'DIFFERS from $(ROM_MD5)'); sys.exit(m != '$(ROM_MD5)')"

source:
	@test -n "$(ROM)" || { echo "make source ROM=pocketcamera_jp.gb [MGBDIS=/path/to/mgbdis.py]"; exit 1; }
	$(PY) tools/make_source.py --rom $(ROM) $(if $(MGBDIS),--mgbdis $(MGBDIS)) $(if $(RGBDS),--rgbds $(RGBDS)) --check

clean:
	$(PY) -c "import shutil; shutil.rmtree('build', ignore_errors=True)"

.PHONY: all check source clean

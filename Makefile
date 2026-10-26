# Build from an editable source tree (L5): roms/jp_rev_a/src/ (default) or, with TREE=us_eu, roms/us_eu/src/ (the international ROM).
# Needs rgbds 1.0.4 (rgbasm, rgblink, rgbfix, rgbgfx) in PATH, or RGBDS=/path/to/rgbds/ (with the trailing slash).
#   make [TREE=us_eu]         build/jp_rev_a/pocketcamera_jp.gb (build/us_eu/gbcam_usa_eu.gb)
#   make check [TREE=us_eu]   ... and compare its md5 with the original ROM
#   make source ROM=pocketcamera_jp.gb [TREE=us_eu] [MGBDIS=/path/to/mgbdis.py]
#                             regenerate the tree from the symbol tables - OVERWRITES hand edits in src/
PY      ?= python3
RGBDS   ?=
RGBASM  := $(RGBDS)rgbasm
RGBLINK := $(RGBDS)rgblink
RGBFIX  := $(RGBDS)rgbfix
RGBGFX  := $(RGBDS)rgbgfx
TREE    ?= jp_rev_a
SRC     := roms/$(TREE)/src
BUILD   := build/$(TREE)
ifeq ($(TREE),us_eu)
ROM_MD5 := 42d2f65e2549be9d1d126a6828b5d1c1
NAME    := gbcam_usa_eu
else
ROM_MD5 := fdcfe686cf4df461e870b6e53b2b5a8b
NAME    := pocketcamera_jp
endif
TARGET  := $(BUILD)/$(NAME).gb

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
	$(RGBLINK) -n $(BUILD)/$(NAME).sym -m $(BUILD)/$(NAME).map -o $@ $<
	$(RGBFIX) -v -p 255 $@

check: $(TARGET)
	@$(PY) -c "import hashlib, sys; m = hashlib.md5(open('$(TARGET)', 'rb').read()).hexdigest(); print('$(TARGET):', m, 'OK' if m == '$(ROM_MD5)' else 'DIFFERS from $(ROM_MD5)'); sys.exit(m != '$(ROM_MD5)')"

source:
	@test -n "$(ROM)" || { echo "make source ROM=$(NAME).gb [TREE=$(TREE)] [MGBDIS=/path/to/mgbdis.py]"; exit 1; }
	$(PY) tools/make_source.py --tree $(TREE) --rom $(ROM) $(if $(MGBDIS),--mgbdis $(MGBDIS)) $(if $(RGBDS),--rgbds $(RGBDS)) --check

clean:
	$(PY) -c "import shutil; shutil.rmtree('build', ignore_errors=True)"

.PHONY: all check source clean

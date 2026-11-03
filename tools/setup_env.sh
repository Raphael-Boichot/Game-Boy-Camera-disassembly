#!/usr/bin/env bash
# One-shot setup of a fresh session for this repository (SETUP.md explains each step). Idempotent: rerun it, it skips what exists.
#   bash tools/setup_env.sh            # toolchain + ROMs + BGB (Wine installed with apt if missing)
#   bash tools/setup_env.sh --no-wine  # everything but Wine / BGB (static work only)
# Result: /home/claude/tc/{rgbds,mgbdis}, ROMs in $ROMDIR (default /root/work/roms) under the names the tools expect,
#         BGB in $BGB_DIR (default /home/claude/bgbx) with the project's bgb.ini, wine ready. Prints one line per step.
set -u
REPO=$(cd "$(dirname "$0")/.." && pwd)
TC=/home/claude/tc; ROMDIR=${ROMDIR:-/root/work/roms}; BGB_DIR=${BGB_DIR:-/home/claude/bgbx}
mkdir -p "$TC" "$ROMDIR"
# 1. rgbds 1.0.4 (release binaries) and mgbdis master 95d951a (after the v3.0 tag: row widths and .padding)
if [ ! -x "$TC/rgbds/rgbasm" ]; then
  curl -sSL -o "$TC/rgbds.tar.xz" https://github.com/gbdev/rgbds/releases/download/v1.0.4/rgbds-linux-x86_64.tar.xz && mkdir -p "$TC/rgbds" && tar -xf "$TC/rgbds.tar.xz" -C "$TC/rgbds"
fi
echo "rgbds: $("$TC/rgbds/rgbasm" -V 2>&1)"
if [ ! -f "$TC/mgbdis/mgbdis.py" ]; then git clone -q https://github.com/mattcurrie/mgbdis.git "$TC/mgbdis"; fi
(cd "$TC/mgbdis" && git checkout -q 95d951a) && echo "mgbdis: $(cd "$TC/mgbdis" && git log --oneline -1)"
# 2. ROMs: from the session attachments (/mnt/user-data) or a folder given as ROM_SRC (e.g. the project files fetched with the Projects tool);
#    no Game Boy Camera ROM is in the repository (owner, 2026-11-03).  BGB still comes from the owner's pack.
declare -A MD5=([pocketcamera_jp.gb]=fdcfe686cf4df461e870b6e53b2b5a8b [gbcam_usa_eu.gb]=42d2f65e2549be9d1d126a6828b5d1c1 [gbcam_gold.gb]=b2999cfb6dacb439f501a71f30f91762
                [pocketcamera_kitty.gb]=0a323bddc4f0159cea76cf44ed0c1a3c [pocketcamera_proto.gb]=1d8097de3497db8b182bcd2a984b6063)
need=0; for n in "${!MD5[@]}"; do [ -f "$ROMDIR/$n" ] || need=1; done
[ -f "$ROMDIR/bgb.exe" ] || need=1
if [ $need = 1 ]; then
  tmp=$(mktemp -d); find /mnt/user-data ${ROM_SRC:-} -maxdepth 3 \( -name '*.gb' -o -name '*bgb.exe' \) -exec cp {} "$tmp/" \; 2>/dev/null
  [ -f "$ROMDIR/bgb.exe" ] || ls "$tmp"/*bgb.exe >/dev/null 2>&1 || (cd "$tmp" && unzip -q -o -j "$REPO/source/Source_material/Source_material.zip" 'bgb.exe')
  for f in $(find "$tmp" -name '*.gb'); do m=$(md5sum "$f" | cut -d' ' -f1); for n in "${!MD5[@]}"; do [ "${MD5[$n]}" = "$m" ] && cp "$f" "$ROMDIR/$n"; done; done
  [ -f "$ROMDIR/bgb.exe" ] || cp "$(find "$tmp" -name '*bgb.exe' | head -1)" "$ROMDIR/bgb.exe" 2>/dev/null
  rm -rf "$tmp"
fi
for n in "${!MD5[@]}"; do [ "$(md5sum "$ROMDIR/$n" 2>/dev/null | cut -d' ' -f1)" = "${MD5[$n]}" ] && echo "rom ok: $n" || echo "ROM MISSING: $n"; done
# legacy names some tools default to
ln -sf "$ROMDIR/pocketcamera_jp.gb" "$ROMDIR/jp.gb"; ln -sf "$ROMDIR/gbcam_usa_eu.gb" "$ROMDIR/intl.gb"; ln -sf "$ROMDIR/gbcam_gold.gb" "$ROMDIR/gold.gb"
ln -sf "$ROMDIR/pocketcamera_kitty.gb" "$ROMDIR/kitty.gb"; ln -sf "$ROMDIR/pocketcamera_proto.gb" "$ROMDIR/proto.gb"
# 3. Wine + BGB (screenshots, sound, watchpoint logs): apt package wine64 from the Ubuntu archive (reachable through the proxy)
if [ "${1:-}" != "--no-wine" ]; then
  if ! command -v wine >/dev/null; then
    (apt-get update -q >/dev/null 2>&1; DEBIAN_FRONTEND=noninteractive apt-get install -y -q wine64 xvfb >/dev/null 2>&1) || echo "apt install failed"
    [ -x /usr/bin/wine ] || { [ -x /usr/bin/wine64 ] && ln -sf /usr/bin/wine64 /usr/local/bin/wine; }
  fi
  command -v wine >/dev/null && echo "wine: $(wine --version 2>/dev/null)" || echo "WINE MISSING"
  mkdir -p "$BGB_DIR"; [ -f "$BGB_DIR/bgb.exe" ] || cp "$ROMDIR/bgb.exe" "$BGB_DIR/bgb.exe"
  [ -f "$BGB_DIR/bgb.ini" ] || { (cd "$BGB_DIR" && unzip -q -o -j "$REPO/source/Source_material/Source_material.zip" '*bgb.ini' 2>/dev/null) || true; }
  # the owner's ini has SystemMode=3 (automatic = Super Game Boy for this ROM): the harness expects plain Game Boy (0) unless a tool passes -setting SystemMode=N
  [ -f "$BGB_DIR/bgb.ini" ] && sed -i 's/^SystemMode=.*/SystemMode=0/' "$BGB_DIR/bgb.ini"
  [ -f "$BGB_DIR/bgb.ini" ] && echo "bgb: $BGB_DIR (bgb.exe md5 $(md5sum "$BGB_DIR/bgb.exe" | cut -c1-32))" || echo "BGB INI MISSING"
  export WINEDEBUG=-all; timeout 60 xvfb-run -a wine "$BGB_DIR/bgb.exe" -hf -nowarn -nowriteini -rom "$ROMDIR/pocketcamera_jp.gb" -screenonexit /tmp/bgb_smoke.bmp -demoplay /dev/null >/dev/null 2>&1
  [ -f /tmp/bgb_smoke.bmp ] && echo "bgb smoke run: ok" || echo "bgb smoke run: no screenshot (see SETUP.md, BGB section)"
fi
echo "PATH hint: export PATH=$TC/rgbds:\$PATH BGB_DIR=$BGB_DIR WINEDEBUG=-all"

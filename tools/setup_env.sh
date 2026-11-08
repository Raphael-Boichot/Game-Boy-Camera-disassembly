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
                [pocketcamera_kitty.gb]=0a323bddc4f0159cea76cf44ed0c1a3c [pocketcamera_proto.gb]=19b50a5f67ef4f0d015e7d813370756e
                [pocketcamera_proto_bgb.gb]=1d8097de3497db8b182bcd2a984b6063)
# the prototype twice (owner, 2026-11-08): pocketcamera_proto.gb is the image as dumped (attachment GBD-IMPACT8M.gb) and is the one the
# disassembly and every tool other than BGB use; pocketcamera_proto_bgb.gb (GBD-IMPACT8M_FIX.gb = "Pocket Camera Prototype (Japan).gb")
# only differs in six header bytes (mapper, ROM / RAM size, both checksums) so that BGB accepts it: BGB runs only
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
ln -sf "$ROMDIR/pocketcamera_kitty.gb" "$ROMDIR/kitty.gb"; ln -sf "$ROMDIR/pocketcamera_proto.gb" "$ROMDIR/proto.gb"; ln -sf "$ROMDIR/pocketcamera_proto_bgb.gb" "$ROMDIR/proto_bgb.gb"
# 3. Wine + BGB (screenshots, sound, watchpoint logs): apt package wine64 from the Ubuntu archive (reachable through the proxy)
if [ "${1:-}" != "--no-wine" ]; then
  # bgb.exe is a 32-bit program (PE32): wine64 alone cannot start it (syswow64\ntdll.dll / kernel32.dll c0000135), so wine32:i386 is installed too (2026-11-03)
  if ! command -v wine >/dev/null || ! dpkg -s wine32:i386 >/dev/null 2>&1; then
    (dpkg --add-architecture i386; apt-get update -q >/dev/null 2>&1; DEBIAN_FRONTEND=noninteractive apt-get install -y -q wine64 wine32:i386 xvfb >/dev/null 2>&1) || echo "apt install failed"
  fi
  command -v wine >/dev/null && echo "wine: $(wine --version 2>/dev/null)" || echo "WINE MISSING"
  # the harness (tcrf_check/tools/bgb_run.py) runs BGB in WINEPREFIX=/root/wineprefix; a prefix made before wine32 was installed has no syswow64 and must be remade
  export WINEPREFIX=/root/wineprefix WINEDEBUG=-all
  if [ -d "$WINEPREFIX" ] && [ ! -d "$WINEPREFIX/drive_c/windows/syswow64" ]; then rm -rf "$WINEPREFIX"; fi
  [ -d "$WINEPREFIX/drive_c/windows/syswow64" ] || timeout 120 xvfb-run -a wineboot -i >/dev/null 2>&1
  mkdir -p "$BGB_DIR"; [ -f "$BGB_DIR/bgb.exe" ] || cp "$ROMDIR/bgb.exe" "$BGB_DIR/bgb.exe"
  [ -f "$BGB_DIR/bgb.ini" ] || { (cd "$BGB_DIR" && unzip -q -o -j "$REPO/source/Source_material/Source_material.zip" '*bgb.ini' 2>/dev/null) || true; }
  # the owner's ini has SystemMode=3 (automatic = Super Game Boy for this ROM): the harness expects plain Game Boy (0) unless a tool passes -setting SystemMode=N
  [ -f "$BGB_DIR/bgb.ini" ] && sed -i 's/^SystemMode=.*/SystemMode=0/' "$BGB_DIR/bgb.ini"
  [ -f "$BGB_DIR/bgb.ini" ] && echo "bgb: $BGB_DIR (bgb.exe md5 $(md5sum "$BGB_DIR/bgb.exe" | cut -c1-32))" || echo "BGB INI MISSING"
  # smoke test through the harness itself (a real demo file; -demoplay /dev/null gives no screenshot)
  sm=$(mktemp -d); head -c 131072 /dev/zero > "$sm/zero.sav"; rm -f /tmp/bgb_smoke.bmp
  (cd "$REPO" && BGB_DIR="$BGB_DIR" timeout 120 python3 tcrf_check/tools/bgb_run.py "$ROMDIR/pocketcamera_jp.gb" "$sm/zero.sav" "$sm/smoke" '-:1:0' >/dev/null 2>&1)
  [ -f "$sm/smoke.bmp" ] && cp "$sm/smoke.bmp" /tmp/bgb_smoke.bmp
  [ -f /tmp/bgb_smoke.bmp ] && echo "bgb smoke run: ok" || echo "bgb smoke run: no screenshot (check wine32:i386 and WINEPREFIX=/root/wineprefix, SETUP.md table)"
fi
echo "PATH hint: export PATH=$TC/rgbds:\$PATH BGB_DIR=$BGB_DIR WINEDEBUG=-all"

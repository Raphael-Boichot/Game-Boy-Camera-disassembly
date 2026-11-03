#!/bin/bash
# Screenshot BGB running a ROM as a Super Game Boy (SystemMode=2): the whole BGB window, border included.
# `-screenonexit` only saves the 160 x 144 LCD, so the border needs a screen capture of a virtual display.
# usage: BGB_DIR=/path/to/bgb tcrf_check/tools/bgb_sgb_capture.sh ROM OUTDIR [SECONDS ...]     (default: 30)
# needs: Xvfb, wine, ImageMagick `import`, a BGB directory with bgb.exe + bgb.ini. -hf is not used (not tested with it).
# Under Wine / Xvfb the border was drawn in the captures at 20 s and later (the ROM sends its 4 KB blocks first, §16.13); at 6 and 12 s BGB still shows the transfer screens.
# The 256 x 224 SGB picture lies at 2x in the middle of the 1024 x 768 capture: crop 256,173,512,448 (then sgb_border_check.py --capture ... --crop 256,173,512,448).
ROM=$(readlink -f "$1"); OUT=$(readlink -f "$2"); shift 2; mkdir -p "$OUT"
TIMES=${@:-30}
: "${BGB_DIR:?set BGB_DIR to the directory with bgb.exe}"
export DISPLAY=:97 WINEDEBUG=-all
Xvfb :97 -screen 0 1024x768x24 -nolisten tcp > "$OUT/xvfb.log" 2>&1 &
XP=$!; sleep 2
wine "$BGB_DIR/bgb.exe" -nowarn -nowriteini -nobattsave -ini "$BGB_DIR/bgb.ini" -rom "$ROM" -setting SystemMode=2 > "$OUT/bgb.log" 2>&1 &
BP=$!; prev=0
for t in $TIMES; do
  sleep $((t - prev)); prev=$t
  import -window root "$OUT/sgb_t$t.png" 2>>"$OUT/import.log"
done
kill $BP $XP 2>/dev/null; sleep 1; kill -9 $BP $XP 2>/dev/null

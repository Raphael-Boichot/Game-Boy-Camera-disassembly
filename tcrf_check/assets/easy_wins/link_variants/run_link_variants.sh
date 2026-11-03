#!/bin/bash
# Reproduce the three BGB-to-BGB link runs of README 16.19 (BGB under Wine, headless; the ROM and the BGB directory are not in git).
# Run from the working root (the folder that holds pocketcamera_jp.gb); T = tcrf_check/tools, L = link_protocol/saves of this repository.
T=${T:-tcrf_check/tools}; L=${L:-link_protocol/saves}; R=${R:-pocketcamera_jp.gb}; OUT=${OUT:-/tmp/linkv}; mkdir -p $OUT
# V1: sender and receiver both owner male ($2FC5 = 01), receiver counters F12-F14 / 10C3-10C4 cleared;  V2: both female (02)
python3 -I $T/bgb_link_variants.py $OUT $R $L/flow1_A_sender_before.sav $L/flow1_B_receiver_before.sav v1_m_to_m 1 1 > $OUT/v1.log 2>&1
python3 -I $T/bgb_link_variants.py $OUT $R $L/flow1_A_sender_before.sav $L/flow1_B_receiver_before.sav v2_f_to_f 2 2 > $OUT/v2.log 2>&1
# V3: the partner runs a copy of the ROM in which the hello byte of the idle responder is $55 instead of $12 (the byte at file offset 0x2D65, "ld a,$12 ; ldh [$ff01],a" at 00:2D64):
python3 - <<'PY'
import sys; r = bytearray(open(sys.argv[1] if len(sys.argv) > 1 else 'pocketcamera_jp.gb', 'rb').read()); assert r[0x2D64:0x2D66] == bytes([0x3E, 0x12]); r[0x2D65] = 0x55
open('/tmp/linkv/pocketcamera_jp_sb55.gb', 'wb').write(r)
PY
RECV_ROM=$OUT/pocketcamera_jp_sb55.gb LINK_PORT=8777 python3 -I $T/bgb_link_variants.py $OUT $R $L/flow1_A_sender_before.sav $L/flow1_B_receiver_before.sav v3_hello55 1 1 > $OUT/v3.log 2>&1

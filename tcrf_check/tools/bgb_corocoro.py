#!/usr/bin/env python3
"""BGB confirmation of the CoroCoro tag check (08:72E0): boot an ordinary save whose SRAM $1FFD-$1FFF holds a given 3-byte tag and report
$D582 (CoroCoro flag), the tag bytes after the boot (rewritten by the routine) and mode:state; screenshot at the end of the boot sequence.
usage: [GBCAM_ROM=roms/gbcam_usa_eu.gb] bgb_corocoro.py OUTDIR [FRAMES]   (default ROM: pocketcamera_jp.gb, run from the project root)"""
import sys, os, shutil
out = sys.argv[1]; frames = int(sys.argv[2]) if len(sys.argv) > 2 else 500
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run
os.makedirs(out, exist_ok=True)
src = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'saves', 'CE10229233.sav')
d0 = bytearray(open(src, 'rb').read())
print('original tag bytes at $1FFD-$1FFF:', d0[0x1FFD:0x2000].hex(), '(save CE10229233)')
for label, tag in (('no tag (as dumped)', bytes(d0[0x1FFD:0x2000])), ('56 56 53 (full tag)', b'\x56\x56\x53'), ('56 56 00 (2 of 3)', b'\x56\x56\x00'),
                   ('00 56 53 (2 of 3)', b'\x00\x56\x53'), ('56 00 00 (1 of 3)', b'\x56\x00\x00'), ('00 00 00', b'\0\0\0')):
    d = bytearray(d0); d[0x1FFD:0x2000] = tag
    f = '%s/tag_%s.sav' % (out, tag.hex()); open(f, 'wb').write(d)
    r = bgb_run.run(os.environ.get('GBCAM_ROM', 'pocketcamera_jp.gb'), f, '%s/boot_%s' % (out, tag.hex()), [], combo=0, free=frames, tail=1)
    w = r['st']['WRAM']; sr = r['st'].get('SRAM') or r['st'].get('CART RAM') or b''
    print('%-22s -> $D582 = %d  $D562 = %02X  mode:state %02X:%02X  SRAM tag after boot: %s' % (label, w[0xD582 - 0xC000], w[0xD562 - 0xC000], r['mode'], r['state'], sr[0x1FFD:0x2000].hex() if sr else '(SRAM chunk not found: %s)' % sorted(r['st'])[:12]), flush=True)

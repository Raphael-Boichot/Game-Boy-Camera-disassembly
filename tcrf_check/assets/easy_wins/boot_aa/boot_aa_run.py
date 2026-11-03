import sys, os
sys.path.insert(0, 'tcrf_check/tools')
import sensor_bgb_log as L
sav = open('saves_unl/unl_CE10238211.sav', 'rb').read(); b = bytearray(sav)
for off in (2 * 0x2000 + 0xFF2, 8 * 0x2000 + 0x1FF2): b[off:off + 12] = b'\xaa' * 12
out = '/tmp/boot_aa'; os.makedirs(out, exist_ok=True); open(out + '/in_aa.sav', 'wb').write(b)
r, lines = L.run(out + '/in_aa.sav', out, 'boot_aa', combo=0, keys=[], free=3000, tail=30, rom='pocketcamera_jp.gb',
                 extra_markers=[('0A:470D', 'LoaderLoop1', ''), ('0A:4710', 'LoaderBank8', ''), ('0A:471E', 'LoaderLoop2End', ''), ('0A:4721', 'LoaderReturnFF', '')])
import collections
print(collections.Counter(l.split('MK ', 1)[1].split()[0] for l in lines if 'MK ' in l))

#!/usr/bin/env python3
"""Boot BGB with the hidden factory-test combo ($FD held at boot) and mark the verdict of the test (0A:6B23-6B54, README 16.20): OK (0A:6B28 / 6B36, tune $16) or NG (0A:6B3F / 6B4E,
tune $29), then the endless loop 0A:6B54.  BGB's fake sensor is not a sensor model, so the verdict says what BGB's constant image gives, not what a camera gives.
usage: bgb_factory_test.py [FREE_FRAMES]      (run from the working root; needs saves_unl/unl_CE10238211.sav and pocketcamera_jp.gb; stop the run by hand once the Hang marker repeats)"""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sensor_bgb_log as L
free = int(sys.argv[1]) if len(sys.argv) > 1 else 4000
out = '/tmp/factory_test'; os.makedirs(out, exist_ok=True)
mk = [('0A:6B28', 'ResultOK', 'ff91=%(FF91)%'), ('0A:6B3F', 'ResultNG', 'ff91=%(FF91)%'), ('0A:6B36', 'OK_request', ''), ('0A:6B4E', 'NG_request', ''), ('0A:6B54', 'Hang', '')]
r, lines = L.run('saves_unl/unl_CE10238211.sav', out, 'boot_fd', combo=0xFD, keys=[], free=free, tail=60, rom='pocketcamera_jp.gb', extra_markers=mk)
print(collections.Counter(l.split('MK ', 1)[1].split()[0] for l in lines if 'MK ' in l))
print([l for l in lines if 'Result' in l or 'request' in l or 'Hang' in l][:6])
print('final mode:state', r['mode'], r['state'], 'pc', hex(r['pc'] or 0))

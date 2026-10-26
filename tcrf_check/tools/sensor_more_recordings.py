#!/usr/bin/env python3
"""The other bus-analyser recordings of the owner's sensor repository (README §18.13), decoded and summarised.

Source: github.com/Raphael-Boichot/Play-with-the-Game-Boy-Camera-Mitsubishi-M64282FP-sensor, folders `Research on real camera 2024`
(camera 1: the unit of §18.4-18.6, plus the Hello Kitty ROM, the prototype ROM and a zeroed calibration vector) and `Research on real Camera`
(camera 2, an earlier unit: boot, two factory resets, normal use, violent exposure changes). The workbooks hold the 64 register bits already
decoded from the probe wires (the wire order of camera 2 differs, the export handles it); they are read with sensor_decode.rows_of.

usage: sensor_more_recordings.py DIR_2024 DIR_CAMERA2 OUTDIR
  -> OUTDIR/<camera>_<recording>.csv (idx, reg0, reg1, C, P, M, X, reg7), OUTDIR/calibration_vectors.csv (the vectors of the saves of the 2024
     folder) and a report on stdout: offset per band in live view, the groups of the factory runs, the band switches."""
import sys, os, csv, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sensor_decode as sd

REC = {'cam1': ('Search_for_sensor_at_boot_Hello_Kitty', 'Exposure_strategy_Hello_Kitty', 'Exposure_strategy_Debagame', '00_save'),
       'cam2': ('Boot', 'Factory_reset', 'Factory_reset_with_strong_light_source', 'Normal_use', 'Violent_exposure_change')}
SAVES = ('Calibration_procedure.sav', 'Calibrated_Camera.sav', '00_save.sav', 'FF_save.sav')


def main():
    d24, d2, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    data = {}
    for cam, names in REC.items():
        for n in names:
            rows = sd.rows_of(os.path.join(d24 if cam == 'cam1' else d2, n + '.xlsx'))
            data[(cam, n)] = rows
            with open(os.path.join(out, '%s_%s.csv' % (cam, n)), 'w', newline='') as fh:
                w = csv.writer(fh, lineterminator='\n'); w.writerow(('idx', 'reg0', 'reg1', 'C', 'P', 'M', 'X', 'reg7'))
                for i, r in enumerate(rows):
                    w.writerow((i, '%02X' % r['reg0'], '%02X' % r['reg1'], '%04X' % r['C'], '%02X' % r['P'], '%02X' % r['M'], '%02X' % r['X'], '%02X' % r['reg7']))
    # calibration vectors of the saves (bank 2 $AFF0-$AFFF = file $4FF0; copy in bank 8 = $11FF0): tolerances, 12 bytes, Σ + $0D, XOR + $23
    with open(os.path.join(out, 'calibration_vectors.csv'), 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n'); w.writerow(('save', 'copy', 'tolerances', 'vector', 'checksums', 'checksums_valid'))
        for s in SAVES:
            b = open(os.path.join(d24, s), 'rb').read()
            for o, name in ((0x4FF0, 'bank 2'), (0x11FF0, 'bank 8')):
                v = b[o + 2:o + 14]; x = 0
                for y in v: x ^= y
                ok = b[o + 14] == (sum(v) + 0x0D) & 0xFF and b[o + 15] == (x + 0x23) & 0xFF
                w.writerow((s, name, b[o:o + 2].hex(' ').upper(), v.hex(' ').upper(), b[o + 14:o + 16].hex(' ').upper(), 'yes' if ok else 'no'))
    for (cam, n), rows in data.items():
        per = collections.defaultdict(collections.Counter); sw = set()
        for r in rows: per['%02X/%02X' % (r['reg1'], r['reg7'])]['%02X' % r['reg0']] += 1
        for a, b in zip(rows, rows[1:]):
            if a['reg1'] != b['reg1']: sw.add('%02X->%02X %04X->%04X' % (a['reg1'], b['reg1'], a['C'], b['C']))
        print('== %s %s: %d rows' % (cam, n, len(rows)))
        if 'Factory' in n:
            g = []
            for r in rows:
                k = (r['reg1'], r['C'])
                if g and g[-1][0] == k: g[-1][1].append(r)
                else: g.append((k, [r]))
            for (r1, c), rr in g:
                print('   reg1 %02X C %04X: %3d captures, reg7 %s, last reg0 %02X' % (r1, c, len(rr), ','.join(sorted({'%02X' % x['reg7'] for x in rr})), rr[-1]['reg0']))
        elif len(per) <= 8:
            print('   reg1/reg7: reg0 x count  ' + '  '.join('%s: %s' % (k, ' '.join('%s x%d' % kv for kv in sorted(v.items()))) for k, v in per.items()))
        if sw: print('   band switches: ' + '; '.join(sorted(sw)))


if __name__ == '__main__':
    main()

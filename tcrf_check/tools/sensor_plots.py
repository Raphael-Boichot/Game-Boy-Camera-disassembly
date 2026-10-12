#!/usr/bin/env python3
"""Draw the two figures of README section 18 from the decoded recordings (assets/sensor/*_rows.csv):
   live_exposure_bands.png : exposure time of every register load of the normal-use recording on a log axis, coloured by band, with the ROM's band-switch thresholds
   sar_traces.png          : the offset register O (signed, in steps of 32 mV) of every capture of the boot and calibration recordings: one successive-approximation search per column group
usage: sensor_plots.py ASSET_DIR      (reads ASSET_DIR/{boot,calibration,live}_rows.csv, writes the two PNG files there)"""
import sys, os, csv
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

BAND_COL = {'20': '#6a51a3', 'E0': '#2171b5', 'E4': '#238b45', 'E8': '#d94801', '0A': '#cb181d'}
BAND_NAME = {'20': 'band 0: H-edge, G=0 (14 dB)', 'E0': 'band 1: 2-D edge, G<4 (14-18.5 dB)', 'E4': 'band 2: 2-D edge, G=4/5 (20/21.5 dB)', 'E8': 'band 3: 2-D edge, G=8 (26 dB)', '0A': 'band 4: positive, G=10 (32 dB)'}


def rows(d, n):
    return list(csv.DictReader(open(os.path.join(d, n + '_rows.csv'))))


def signed_o(r):
    o = int(r['reg0'], 16) & 0x3F
    return (o - 0x20) if o & 0x20 else -o


def main(d):
    live = rows(d, 'live')
    fig, ax = plt.subplots(figsize=(10, 4.6))
    for k, col in BAND_COL.items():
        xs = [i for i, r in enumerate(live) if (r['reg1'] in ('E0', 'E1', 'E2', 'E3') if k == 'E0' else r['reg1'] == k)]
        ax.plot(xs, [int(live[i]['C1'] + live[i]['C0'], 16) * 0.016 for i in xs], 'o', ms=3.5, color=col, label=BAND_NAME[k])
    ax.set_yscale('log'); ax.set_xlabel('register load number (normal-use recording)'); ax.set_ylabel('exposure time C (ms), log scale')
    for e, t in ((0x30, '0.768 ms: datasheet minimum for vertical / 2-D edge modes'), (0x1200, 'band 1 -> 2 at $1200'), (0x6000, 'band 2 -> 3 at $6000'), (0xC000, 'band 3 -> 4 at $C000')):
        ax.axhline(e * 0.016, color='#888', lw=0.7, ls=':'); ax.text(1, e * 0.016 * 1.06, t, ha='left', va='bottom', fontsize=7, color='#555')
    ax.legend(fontsize=7, loc='lower right'); ax.set_title('Auto-exposure of the real camera: five gain / mode bands (README 18.7)')
    fig.tight_layout(); fig.savefig(os.path.join(d, 'live_exposure_bands.png'), dpi=140); plt.close(fig)

    fig, axs = plt.subplots(2, 1, figsize=(10, 6.2))
    for ax, name, title in ((axs[0], 'boot', 'Boot: 58 captures = 1 gain probe + 5 searches + 1 gain probe'), (axs[1], 'calibration', 'Full calibration: 12 searches (96 captures), then 12 threshold scans (identical registers)')):
        rr = rows(d, name)
        ax.plot(range(len(rr)), [signed_o(r) for r in rr], '.-', lw=0.6, ms=4, color='#2171b5')
        ax.axhline(0, color='#888', lw=0.5); ax.set_ylabel('O (steps of 32 mV)'); ax.set_title(title, fontsize=9)
        for i in range(0, len(rr), 8):
            if name == 'calibration' and i >= 96: break
            ax.axvline(i - 0.5, color='#ccc', lw=0.5)
    axs[1].set_xlabel('capture number'); fig.tight_layout(); fig.savefig(os.path.join(d, 'sar_traces.png'), dpi=140); plt.close(fig)


if __name__ == '__main__': main(sys.argv[1])

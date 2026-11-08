#!/usr/bin/env python3
"""Draws the screen tree of every ROM that has one (roms/<rom>/<p>_screen_tree.png) with tools/screen_tree.py, always with the same options.

  tools/make_screen_trees.py [--out-dir DIR] [--only jp_rev_a,us_eu,hello_kitty]

Inputs per ROM, all in git: roms/<rom>/screens/ (explore.csv and the BGB screenshots of tools/kitty_bgb_explore.py; extra.csv: screens
reached by a boot condition, a printer run or a forced run; cancel.csv: where B leads, tools/screen_cancel.py), disasm/screen_names_<s>.csv,
disasm/screen_panels_<s>.csv (the boot row: boot screen, calibration check, factory calibration). The checker draws them again into a
temporary folder and compares the pixels with the committed pictures.
"""
import os, sys, subprocess, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ROMS = [('jp_rev_a', 'jp', 'Pocket Camera (Japan) (Rev A)', 34, 'roms/jp_rev_a/disasm/const_names_jp.csv'),
        ('us_eu', 'us', 'Game Boy Camera (USA, Europe)', 34, 'roms/us_eu/disasm/const_names_us.csv'),
        ('hello_kitty', 'kitty', 'Pocket Camera (Hello Kitty)', 31, None)]
ap = argparse.ArgumentParser(); ap.add_argument('--out-dir', default=None); ap.add_argument('--only', default=None); a = ap.parse_args()
for rom, s, title, modes, mt in ROMS:
    if a.only and rom not in a.only.split(','): continue
    d = os.path.join(REPO, 'roms', rom)
    out = os.path.join(a.out_dir, '%s_screen_tree.png' % s) if a.out_dir else os.path.join(d, '%s_screen_tree.png' % s)
    cmd = [sys.executable, os.path.join(HERE, 'screen_tree.py'), out, '--title', '%s: screens reached in BGB' % title, '--explore', os.path.join(d, 'screens'),
           '--extra', os.path.join(d, 'screens', 'extra.csv'), '--names', os.path.join(d, 'disasm', 'screen_names_%s.csv' % s),
           '--panels', os.path.join(d, 'disasm', 'screen_panels_%s.csv' % s), '--cancel', os.path.join(d, 'screens', 'cancel.csv'),
           '--modes', str(modes), '--scale', '1', '--cols', '3', '--lr', '--font', '1.4'] + (['--mode-titles', os.path.join(REPO, mt)] if mt else [])
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode: sys.exit('%s: %s' % (rom, r.stderr[-500:]))
    print(r.stdout.strip())

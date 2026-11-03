#!/usr/bin/env python3
"""The last JP_RAN instructions of the international / Gold ROMs (code that differs from the Japanese code by an immediate operand), run in the core.
  gate    AlbumB_CheckGate's Space Fever II band 5000-6999 / 7000+ (intl 02:4D72, Gold 02:4D89): a save whose Space Fever II best score is 5000 or 7000
          (SRAM 10C5-10C8 = 00 50 00 00 / 00 70 00 00, the settings checksum and its echo recomputed; tools/sram_analyze.py), then VIEW, A, and Right x12 in the
          album grid until an album B picture is loaded (Photo_LoadImage_Far calls the gate).  Joypad only; the save is the input.
  crown   RUN! RUN! RUN! won and its flag hoisted: Space Fever II first wave, A pulsed 60 frames without moving (the RUN! ship -> mode $21), the race with A every
          2nd frame, A every 2nd frame on the result screen 21:0C (the flag) -> Run_Celebration and Run_DrawCrown (09:708B).  Joypad only, unlocking save.
  slider  FORCED (WRAM poke): in this build the only write of 1 to wSliderRedraw ($D67E) is in Unused_Mode0A_PhotoStepWrap (04:7C7C, no reference), so the
          redraw branch of Mode0A_State03_SliderBrowse cannot be entered in normal play; the variant pokes $D67E = 1 and wCopyPhotoIdxA ($D5ED) = an album B
          picture in 0A:03, so that the border number changes and the border tile map is reloaded (04:7571).
  hsound  the hot-spot editor's sound-$1F case of HotSpotEd_ShowSoundTile (new code of this build, 03:7479): STUDIO (Select), Right, A -> SPECIAL 03:01, A -> 1A:01,
          A (photo) 1A:03, A (slot) 1A:04, A -> SOUND picker 1A:05; Up until the slot's sound ($D652 + slot $D5D0) is $1F; then A x6 (EFFECT, JUMP, confirm,
          browse, exit dialog 1A:09, whose PickerSlideIn shows the sound tile, back to 1A:05).  Joypad only, unlocking save.
usage: GBCAM_ROM=ROM port_l2_rest.py OUT.npz [gate,crown,slider,hsound]      ('ex' = every byte executed by the scenarios, routes included; PYTHONPATH coverage/src:tcrf_check/tools)"""
import sys, os
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'tcrf_check', 'tools'))
import lib; from lib import g
import sram_analyze as S
out = sys.argv[1]; which = (sys.argv[2] if len(sys.argv) > 2 else 'gate,crown,slider,hsound').split(',')
UNL = os.environ.get('UNL_SAV', '/root/work/port/saves_unl/unl_CE10001819.sav')
ex = g.cov_exec(); union = np.zeros(len(ex), bool)
def start(): ex[:] = 0
def keep(name):
    e = np.array(ex, copy=True) != 0; union[:] |= e; print(name, 'executed', int(e.sum()), 'bytes', flush=True)
def save_with_sf(v):
    c = bytearray(open(UNL, 'rb').read()); c[0x10C5:0x10C9] = bytes(v)
    blk = bytes(c[0x1000:0x10D7]); blk += S.ck(blk, 0, 0xD7); c[0x1000:0x10D9] = blk; c[0x10D9:0x11B2] = blk
    assert S.blk_ok(c, 0x1000, 0xD7); return bytes(c)
if 'gate' in which:
    for name, v in (('sf5000', (0, 0x50, 0, 0)), ('sf7000', (0, 0x70, 0, 0))):
        lib._SAVCACHE[name] = save_with_sf(v); start()
        lib.boot(lib.SAV(name), combo=0, printer=0, free=403); lib.play('A w60 R A w200 A w200', wait=60)
        for i in range(14): lib.play('R', wait=30)
        keep('gate ' + name)
lib._SAVCACHE['u'] = open(UNL, 'rb').read()
if 'crown' in which:
    start(); lib.boot(lib.SAV('u'), combo=0, printer=0, free=403); lib.play('A w60 D A w60 A', wait=40)
    for f in range(60): g.keys(g.A if f % 4 < 2 else 0); g.run(1)
    g.keys(0); g.run(200); t0c = None; place = None
    for f in range(20000):
        st = lib.cur()
        if st[1] == 6: k = g.A if f % 2 == 0 else 0
        elif st[1] == 0x0C:
            if t0c is None: t0c = f; place = g.peek(0xD00D)
            if f - t0c > 1500: break
            k = g.A if f % 2 == 0 else 0
        else: k = (g.A if f % 30 < 2 else 0) | (g.START if f % 90 == 45 else 0)
        g.keys(k); g.run(1)
    g.keys(0); print('crown: player place', place, 'state %02X:%02X' % lib.cur()); keep('crown')
if 'slider' in which:
    start(); lib.boot(lib.SAV('u'), combo=0, printer=0, free=403); lib.play('A w60 R A w200 A w200 A w200', wait=60)
    print('slider state %02X:%02X border %d' % (*lib.cur(), g.peek(0xD7C1)))
    for idx in (0x1E, 0x25, 0x01):
        g.poke(0xD5ED, idx); g.poke(0xD67E, 1); g.run(120)
        print('  photo %02X -> border %d' % (idx, g.peek(0xD7C1)))
    keep('slider (forced)')
if 'hsound' in which:
    start(); lib.boot(lib.SAV('u'), combo=0, printer=0, free=403); lib.play('A w60 s w60 R A w200 A w200 A w200 A w200', wait=60)
    def tap(k, w=60): g.keys(k); g.run(4); g.keys(0); g.run(w)
    for i in range(4):
        if lib.cur() == (0x1A, 5): break
        tap(g.A, 200)
    n = 0
    while g.peek(0xD652 + g.peek(0xD5D0)) != 0x1F and n < 80: tap(g.UP); n += 1
    for i in range(6): tap(g.A, 150)
    print('hsound: picker at %02X:%02X after %d Up, sound $%02X' % (*lib.cur(), n, g.peek(0xD652 + g.peek(0xD5D0)))); keep('hsound')
np.savez_compressed(out, ex=union.astype(np.uint8)); print('->', out)

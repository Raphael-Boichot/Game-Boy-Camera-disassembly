#!/usr/bin/env python3
"""(shared helpers) Filmstrip of the 16 hot-spot effects (core): screens at given frame offsets after tapping A on an armed hot spot (hot-spot viewer, mode $0C state 3).
usage: hotspot_filmstrip.py OUT.png [FRAMES ...]"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g, R
import sram_analyze as S
from PIL import Image, ImageDraw
SRC = os.path.join(lib.ROOT, 'saves_unl', 'unl_CE10238211.sav')
PATH = [('B', 12, 10), ('Left', 8, 40), ('A', 10, 150), ('Right', 8, 40), ('A', 10, 150), ('Down', 8, 40), ('Down', 8, 40), ('A', 10, 150), ('A', 10, 150)]
KEY = dict(A=g.A, B=g.B, Left=g.LEFT, Right=g.RIGHT, Up=g.UP, Down=g.DOWN)
def make(sav0, k, X, Y):
    b = bytearray(sav0); used = [i for i in range(30) if b[0x11B2 + i] < 30]
    for sl in used[:6]:
        base = S.slot_base(sl + 1) + 0xF00; t = bytearray(b[base:base + 0x5C])
        t[0x36:0x3B] = bytes([1, 0, 0, 0, 0]); t[0x3B:0x40] = bytes([X, 0, 0, 0, 0]); t[0x40:0x45] = bytes([Y, 0, 0, 0, 0])
        t[0x45:0x4A] = bytes([0xFF] * 5); t[0x4A:0x4F] = bytes([k, 0xFF, 0xFF, 0xFF, 0xFF]); t[0x4F:0x54] = bytes([0xFF] * 5)
        data = bytes(t[:0x5A]); blk = data + S.ck(data, 0, 0x5A); b[base:base + 0x5C] = blk; b[base + 0x5C:base + 0xB8] = blk
    return bytes(b)
def prep(sv):
    lib.boot(sv, combo=2, free=400)
    for k, h, w in PATH: lib.act((KEY[k], h, w))

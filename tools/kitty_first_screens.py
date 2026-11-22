#!/usr/bin/env python3
"""The screen each ROM byte is first read on, kept while a tool plays (the convention of tools/kitty_read_screens.py, 2026-11-12):
first = (mode << 8 | state) when the byte is first seen read, next = the same, or the first (mode, state) outside the fade $1E that
follows when the byte was first read during a fade; $FFFF = never read. Used by tools/kitty_core_link.py, tools/kitty_rare_runs.py
and tools/kitty_stamp_sweep.py (2026-11-22), whose files trace/read_screens_kitty_<name>.npz tools/kitty_data_names.py reads after trace/read_screens_kitty.npz.
"""
import numpy as np
class FirstScreens:
    def __init__(s, n=1 << 20):
        s.first = np.full(n, 0xFFFF, np.uint16); s.next = np.full(n, 0xFFFF, np.uint16); s.pend = []
    def update(s, dr, mode, state):
        new = np.flatnonzero((dr > 0) & (s.first == 0xFFFF))
        v = mode << 8 | state
        if len(new): s.first[new] = v
        if mode == 0x1E:
            if len(new): s.pend.append(new)
        else:
            for p in s.pend: s.next[p] = v
            s.pend = []
            if len(new): s.next[new] = v
    def save(s, path): np.savez_compressed(path, first=s.first, next=s.next)

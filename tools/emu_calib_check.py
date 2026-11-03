#!/usr/bin/env python3
"""Emulator check of the calibration-record validity test (needs PyBoy; PyBoy has no Pocket Camera mapper).

Usage:  python3 -I emu_calib_check.py <usa_eu_or_jp_rom.gb> <camera.sav> [frames]

What it does (the ROM and the save files are never modified; work happens in a temporary directory):
  * copies the ROM, sets the cartridge type to MBC5+RAM+battery ($147 = $1B) and fixes the header checksum;
  * replaces the two sensor-wait loops `cb 46 20 fc` ... (bit 0,[$A000] ; jr nz,-4) of the boot by nops;
  * hooks Cam_Calib_ValidityCheck (bank $0A, $45C9) and enables SRAM reads there (PyBoy returns $FF while RAM is disabled);
  * prints the result of the check (A = 0: a record was accepted, $FF: default vector used), $FF8A and the WRAM vector $D5B5-$D5C0.
Expected (README section 11.9): a camera with the record at $AFF2 returns 0 and its own vector; a camera with the record 6 bytes
lower returns $FF and the fixed default vector 7E 7F 7F 7F 7E 7D 7E 7E 7D 7E 7D 6A.
"""
import sys, os, re, shutil, tempfile
from pyboy import PyBoy


def patch(rom):
    d = bytearray(open(rom, 'rb').read())
    d[0x147] = 0x1B
    n = 0
    for m in re.finditer(rb'\x00\xa0\xcb\x46\x20\xfc', bytes(d)):          # ld a,[$A000]-style wait: bit 0,[hl] ; jr nz,-4
        d[m.start() + 4] = 0
        d[m.start() + 5] = 0
        n += 1
    x = 0
    for i in range(0x134, 0x14D):
        x = (x - d[i] - 1) & 255
    d[0x14D] = x
    return d, n


def main():
    rom, sav = sys.argv[1], sys.argv[2]
    frames = int(sys.argv[3]) if len(sys.argv) > 3 else 300
    d, n = patch(rom)
    tmp = tempfile.mkdtemp()
    open(tmp + '/c.gb', 'wb').write(d)
    shutil.copy(sav, tmp + '/c.gb.ram')
    pb = PyBoy(tmp + '/c.gb', window='null', sound_emulated=False)
    pb.set_emulation_speed(0)
    res = {}

    def enable(ctx=None):
        pb.memory[0x0000] = 0x0A

    def entry(ctx=None):
        enable()

    def after(ctx=None):
        enable()
        res['A'] = pb.register_file.A
        res['FF8A'] = pb.memory[0xFF8A]
        res['vec'] = bytes(pb.memory[0xD5B5:0xD5B5 + 12]).hex()

    pb.hook_register(10, 0x45C9, entry, None)
    pb.hook_register(10, 0x4641, enable, None)      # checksum mismatch branch: keep RAM readable for the echo copy test
    pb.hook_register(10, 0x45CC, after, None)
    for _ in range(frames):
        pb.tick()
    final = bytes(pb.memory[0xD5B5:0xD5B5 + 12]).hex()
    print(f'patched wait loops: {n}')
    print(f"validity check: A={res.get('A')!s} (0 = record accepted, 255 = default vector), FF8A={res.get('FF8A')}")
    print('WRAM vector D5B5 right after the check:', res.get('vec'), '(the default vector, if used, is written just after this point)')
    print('WRAM vector D5B5 after', frames, 'frames:', final)
    pb.stop(save=False)
    shutil.rmtree(tmp)


main()

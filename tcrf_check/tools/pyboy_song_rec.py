#!/usr/bin/env python3
"""Record one song of the Pocket Camera to a WAV file with PyBoy (TCRF B02 / B03, 2026-11-02: the owner listened to songs $31 and $45).

  pyboy_song_rec.py ROM.gb SONG_HEX SECONDS OUT.wav      (pip install pyboy)

PyBoy has no Pocket Camera mapper, so a COPY of the ROM is patched in memory as in docs §8: cartridge type MBC5 + RAM, the busy-wait loops on the
capture bit ($A000 bit 0) and the self-test call at 00:2EA1 removed.  The game is booted to the main menu (A at frame 330), the music is stopped
(request $FF) and the song is requested through the music mailbox wSndMusicReq ($DD68); the WAV starts with the request.  PyBoy's sound chip is
an emulation: fine for hearing a song, not a measurement of real hardware."""
import sys, os, wave, tempfile
import numpy as np
from pyboy import PyBoy
rom, song, secs, out = sys.argv[1], int(sys.argv[2], 16), float(sys.argv[3]), sys.argv[4]
R = bytearray(open(rom, 'rb').read()); R[0x147] = 0x1B; R[0x149] = 0x04
for i in range(len(R) - 12):
    if R[i:i + 3] == b'\x21\x00\xa0':
        for j in range(i + 3, i + 12):
            if R[j] == 0xCB and R[j + 1] == 0x46 and R[j + 2] in (0x20, 0xC2):
                for k in range(2 if R[j + 2] == 0x20 else 3): R[j + 2 + k] = 0
                break
if R[0x2EA1] == 0xCD: R[0x2EA1:0x2EA4] = b'\x00\x00\x00'
c = 0
for i in range(0x134, 0x14D): c = (c - R[i] - 1) & 0xFF
R[0x14D] = c
tmp = os.path.join(tempfile.mkdtemp(), 'patched.gb'); open(tmp, 'wb').write(R)
pb = PyBoy(tmp, window='null', sound_emulated=True)
for i in range(520):
    if i == 330: pb.button('a')
    pb.tick()
pb.memory[0xDD68] = 0xFF
for i in range(30): pb.tick()
pb.memory[0xDD68] = song
buf = []
for i in range(int(secs * 59.73)): pb.tick(); buf.append(np.array(pb.sound.ndarray, copy=True))
a = np.concatenate(buf).astype(np.float32).reshape(-1, 2); m = np.abs(a).max() or 1
w = wave.open(out, 'wb'); w.setnchannels(2); w.setsampwidth(2); w.setframerate(pb.sound.sample_rate); w.writeframes((a / m * 28000).astype(np.int16).tobytes()); w.close()
print(out, len(a) / pb.sound.sample_rate, 's')

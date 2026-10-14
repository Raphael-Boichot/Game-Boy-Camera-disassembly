#!/usr/bin/env python3
"""Pictures and clips of README 16.26 from the BGB runs of bgb_dead_hook.py: tile sheets of the tile sets that the dead loaders write (the ROM span, and the VRAM that BGB held after the forced call), the map 25:4B00
drawn over the tile set of every game mode, the contact sheet of the flipped-gate runs, and the sound clips (WAV from BGB -> short MP3, with a padding of 60 ms before and 250 ms after the burst).
usage: dead_sheets.py ROM BGB_OUT_DIR(out3) SURVEY_DIR FLIP_DIR UIEFFECT_DIR SFX_DIR OUT_DIR"""
import sys, os, glob, json, subprocess, wave
import numpy as np
from PIL import Image, ImageDraw
SHADE = (255, 170, 85, 0)

def rom_bytes(rom, bank, addr, n):
    o = bank * 0x4000 + (addr - 0x4000) if addr >= 0x4000 else addr
    return rom[o:o + n]

def tiles_img(data, cols=16, scale=6, label=None):
    n = len(data) // 16; rows = (n + cols - 1) // cols
    im = Image.new('L', (cols * 9 * scale // 1, rows * 9 * scale // 1), 200)
    px = im.load()
    for t in range(n):
        for y in range(8):
            lo, hi = data[t * 16 + y * 2], data[t * 16 + y * 2 + 1]
            for x in range(8):
                v = SHADE[((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1)]
                bx, by = (t % cols) * 9 * scale + x * scale, (t // cols) * 9 * scale + y * scale
                for dy in range(scale):
                    for dx in range(scale): px[bx + dx, by + dy] = v
    return im.convert('RGB')

def stack(ims, labels, w=None):
    w = w or max(i.width for i in ims); h = sum(i.height + 14 for i in ims) + 4
    out = Image.new('RGB', (w + 8, h), (30, 30, 30)); d = ImageDraw.Draw(out); y = 2
    for im, lb in zip(ims, labels):
        d.text((4, y), lb, fill=(255, 255, 255)); y += 12; out.paste(im, (4, y)); y += im.height + 2
    return out

def vram_tiles(path, vaddr, n):
    v = open(path, 'rb').read(); o = vaddr - 0x8000
    return v[o:o + n * 16]

def wav_mono(path):
    w = wave.open(path); x = np.frombuffer(w.readframes(w.getnframes()), np.int16).reshape(-1, w.getnchannels()).astype(float).mean(1); return x, w.getframerate()

def clip(path, start_s, len_s, out_mp3, pad_pre=0.06, pad_post=0.25):
    x, sr = wav_mono(path); a = max(0, int((start_s - pad_pre) * sr)); b = min(len(x), int((start_s + len_s + pad_post) * sr))
    seg = (x[a:b] - np.median(x)).astype(np.int16); tmp = out_mp3[:-4] + '.wav'
    w = wave.open(tmp, 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(sr); w.writeframes(seg.tobytes()); w.close()
    subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-i', tmp, '-c:a', 'libmp3lame', '-q:a', '5', out_mp3], check=True); os.remove(tmp)
    return b - a

if __name__ == '__main__':
    rom_path, o3, svy, flp, uie, sfx, out = sys.argv[1:8]; os.makedirs(out, exist_ok=True)
    rom = open(rom_path, 'rb').read()
    # 1. tile sets: ROM span and what BGB held in VRAM after the forced call
    sets = [('tiles_24_57E0_font', 'tiles24_57E0_mode16', 0x24, 0x57E0, 256, 0x8EF0, '24:57E0 (256 B, 16 tiles) = what 07:4BC3 writes to $8EF0'),
            ('tiles_17_4800_digits', 'tiles17_4800_mode16', 0x17, 0x4800, 320, 0x8700, '17:4800.. (two tiles per digit, 10 digits); 07:4A4D writes the pair of one digit to $8700 / $8720'),
            ('tiles_13_5800', 'tiles13_5800_mode16', 0x13, 0x5800, 16, 0x8EC0, '13:5800 (1 tile) and 13:5830 (1 tile) to $8EC0 / $8ED0')]
    for name, case, bank, addr, n, va, lab in sets:
        if name == 'tiles_17_4800_digits':
            continue
        a = rom_bytes(rom, bank, addr, n)
        ims = [tiles_img(a), tiles_img(vram_tiles(os.path.join(o3, case + '_vram_forced.bin'), va, n // 16))]
        labs = ['ROM ' + lab, 'BGB VRAM after the forced call (from $%04X), control run below' % va]
        ims.append(tiles_img(vram_tiles(os.path.join(o3, case + '_vram_control.bin'), va, n // 16))); labs.append('BGB VRAM, control run (same address)')
        stack(ims, labs).save(os.path.join(out, name + '.png'))
    # the digit glyphs are 8x16: tile 2d above tile 2d+1
    a = rom_bytes(rom, 0x17, 0x4800, 320); order = [2 * d for d in range(10)] + [2 * d + 1 for d in range(10)]
    ims = [tiles_img(b''.join(a[t * 16:t * 16 + 16] for t in order), cols=10, scale=8)]; labs = ['ROM 17:4800..+320 B: ten 8x16 glyphs (tile 2d over tile 2d+1), what 07:4A4D picks from']
    for tag in ('forced', 'control'):
        v = vram_tiles(os.path.join(o3, 'tiles17_4800_mode16_vram_%s.bin' % tag), 0x8700, 3)
        ims.append(tiles_img(v[0:16] + v[32:48], cols=1, scale=8)); labs.append('BGB VRAM, the two tiles at $8700 and $8720 (16 B each), %s run' % tag)
    stack(ims, labs).save(os.path.join(out, 'tiles_17_4800_digits.png'))
    # 2. 13:5800 and 13:5830 are one tile each (the loader writes them to $8EC0 and $8ED0)
    a = tiles_img(rom_bytes(rom, 0x13, 0x5800, 16) + rom_bytes(rom, 0x13, 0x5830, 16), cols=2, scale=8)
    b = tiles_img(vram_tiles(os.path.join(o3, 'tiles13_5800_mode16_vram_forced.bin'), 0x8EC0, 1) + vram_tiles(os.path.join(o3, 'tiles13_5800_mode16_vram_forced.bin'), 0x8ED0, 1), cols=2, scale=8)
    stack([a, b], ['ROM 13:5800 | 13:5830', 'BGB VRAM $8EC0 | $8ED0 after the forced call'], w=200).save(os.path.join(out, 'tiles_13_5800.png'))
    # 3. survey contact sheet (the map 25:4B00 in every mode that BGB reached)
    ok = []
    for f in sorted(glob.glob(os.path.join(svy, 'map25_4B00_m*.json'))):
        d = json.load(open(f))
        if d['entry_hits']: ok.append((d['name'], d['mode_forced']))
    W = 4; cw, ch = 168, 158; H = (len(ok) + W - 1) // W; sheet = Image.new('RGB', (W * cw, H * ch), (30, 30, 30)); dr = ImageDraw.Draw(sheet)
    for i, (n, m) in enumerate(ok):
        im = Image.open(os.path.join(svy, n + '_forced.png')).convert('RGB'); x, y = (i % W) * cw + 4, (i // W) * ch + 12; sheet.paste(im, (x, y)); dr.text((x, y - 11), 'mode %d (%s)' % (int(n[-2:]), m), fill=(255, 255, 255))
    sheet.save(os.path.join(out, 'map25_4B00_survey.png'))
    # 4. map 25:4B00 / 24:7120 in mode 16 (control, forced)
    ims = []; labs = []
    for n in ('map25_4B00_mode16', 'map24_7120_mode16'):
        pair = Image.new('RGB', (330, 144), (30, 30, 30)); pair.paste(Image.open(os.path.join(o3, n + '_control.png')).convert('RGB'), (0, 0)); pair.paste(Image.open(os.path.join(o3, n + '_forced.png')).convert('RGB'), (170, 0)); ims.append(pair); labs.append(n + '  control | forced')
    stack(ims, labs).save(os.path.join(out, 'maps_dead_loaders_mode16.png'))
    # 5. flipped gates that change the mode
    names = ['flip_07_5291_m02', 'flip_07_5473_m03', 'flip_08_4095_m27']; sheet = Image.new('RGB', (len(names) * 168, 2 * 158), (30, 30, 30)); dr = ImageDraw.Draw(sheet)
    for i, n in enumerate(names):
        for j, k in enumerate(('control', 'forced')):
            x, y = i * 168 + 4, j * 158 + 12; sheet.paste(Image.open(os.path.join(flp, '%s_%s.png' % (n, k))).convert('RGB'), (x, y)); dr.text((x, y - 11), n[5:] + ' ' + k, fill=(255, 255, 255))
    sheet.save(os.path.join(out, 'flip_gates_modes.png'))
    # 6. sounds
    rows = []
    for n in range(1, 9):
        d = json.load(open(os.path.join(uie, 'uieffect_%d.json' % n))); w = d['wav_forced']; ln = clip(w, d['start_s_forced'], d['len_s_forced'], os.path.join(out, 'sfx_ui_effect_%d.mp3' % n)); rows.append((n, d['peak_hz_forced'], d['len_s_forced']))
    d = json.load(open(os.path.join(sfx, 'sfx1_unused_46DD.json')))
    clip(d['wav_forced'], d['start_s_forced'], d['len_s_forced'], os.path.join(out, 'sfx1_unused_46DD.mp3'))
    clip(d['wav_control'], d['start_s_control'], d['len_s_control'], os.path.join(out, 'sfx1_id1_real.mp3'))
    print(rows)

"""Write assets/asset_map_jp.csv: the never-read data bytes of the Japanese ROM (class U of the byte-class map, padding excluded) grouped into labelled ranges.
usage: asset_map_build.py OUT.csv [--rom pocketcamera_jp.gb] [--map coverage/results/report_v8/rom_map.csv]
The hand-written rows carry the readings (README 16.13); the tile-set gaps and the bank $2A glyph runs are taken from the class map.
The evidence tag of a row is C only where an emulator or BGB test backs it, else I."""
import csv, sys, os, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from render_marked_tiles import load_classes, padmask
ARGS = sys.argv[1:]
def opt(n, d):
    if n in ARGS: i = ARGS.index(n); v = ARGS[i + 1]; del ARGS[i:i + 2]; return v
    return d
ROM = opt('--rom', 'pocketcamera_jp.gb'); MAP = opt('--map', os.path.join(os.path.dirname(os.path.dirname(HERE)), 'coverage', 'results', 'report_v8', 'rom_map.csv'))
rom = open(ROM, 'rb').read(); cls = load_classes(MAP); pad = padmask(rom)
def off(b, a): return b * 0x4000 + (a - 0x4000 if b else a)
rows = []
def add(b, s, e, typ, desc, ctx, ev, sheet=''):
    rows.append([b'%02X' % b if False else '%02X' % b, '%04X' % s, '%04X' % e, typ, desc, ctx, ev, sheet])

# --- SGB data, bank $0B. The sender 00:1D38-1EA0 (international ROM: 00:1DEC-1F9E, same bank-$0B addresses) sends these blocks; sgb_border_check.py decodes
# them and rebuilds the border (JP and international, pixel-identical to BGB in SGB mode and to the community sheet: README 16.13). The three transfers that
# carry data (PAL_TRN, ATTR_TRN, CHR_TRN, PCT_TRN: $1000 bytes after the 16-byte packet) overlap each other.
SND = 'sender 00:1D38-1EA0'
add(0x0B, 0x4000, 0x401F, 'sgb_packet', 'MLT_REQ packets: $89 $00 (1 player, 4000) and $89 $01 (2 players, 4010); the multi-player probe 00:1CEA-1D43 sends them to detect the SGB', SND, 'C')
add(0x0B, 0x4020, 0x402F, 'sgb_packet', 'PAL_SET: $51, palette ids $0010 x 4, $80 (cancel mask); the game window is drawn with palette 16 of the PAL_TRN block (BGB: its 4 colours)', SND, 'C')
add(0x0B, 0x4030, 0x403F, 'sgb_packet', 'ATTR_TRN packet $A9 $00 (data window 4040-503F)', SND, 'I')
add(0x0B, 0x4040, 0x40A5, 'sgb_attr_trn_data', 'start of the ATTR_TRN window: zeros up to 409C, then 40 40 40 90 90 90 E4 E4 E4 (not identified; the attribute files are not used by this sequence)', SND, 'I')
add(0x0B, 0x40A6, 0x40B5, 'sgb_packet', 'PAL_TRN packet $59 $00 (data window 40B6-50B5)', SND, 'C')
add(0x0B, 0x40B6, 0x413D, 'sgb_pal_trn_data', 'SNES system palettes 0-16 (4 BGR555 colours each); id 16 at 4136-413D (FF7F B55A 6B35 6310) is the palette of the game window (BGB: exactly its 4 colours)', SND, 'C')
add(0x0B, 0x4156, 0x4165, 'sgb_packet', 'CHR_TRN packet $99 $00: tiles 0-127 follow (4166-5165)', SND, 'C')
add(0x0B, 0x4166, 0x5165, 'sgb_border_tiles', 'SGB border tiles 0-127 (4bpp, 32 bytes each); 71 of the 256 tiles of both blocks are used by the map (2,272 B), the border is pixel-identical to BGB and to the community sheet', SND, 'C')
add(0x0B, 0x5166, 0x5175, 'sgb_packet', 'CHR_TRN packet $99 $01: tiles 128-255 follow (5176-6175)', SND, 'C')
add(0x0B, 0x5176, 0x6175, 'sgb_border_tiles', 'SGB border tiles 128-255 (4bpp)', SND, 'C')
add(0x0B, 0x6176, 0x6185, 'sgb_packet', 'PCT_TRN packet $A1 $00 (data window 6186-7185: map, palettes)', SND, 'C')
add(0x0B, 0x6186, 0x6885, 'sgb_border_tilemap', 'SGB border map rows 0-27 of the 32 x 32 words (tile, attribute); the 20 x 18 cells of the game window are tile 0 / attribute 0 (palette 0 = transparent)', SND, 'C')
add(0x0B, 0x6886, 0x6985, 'sgb_border_tilemap', 'map rows 28-31 (below the 224 lines the SGB shows); same pattern as the rows above (47 14 / 47 10)', SND, 'I')
add(0x0B, 0x6986, 0x69C5, 'sgb_palettes', 'border palettes 4 and 5 (16 BGR555 words each; ff7f = white); the map uses only these two', SND, 'C')
add(0x0B, 0x69E6, 0x6A65, 'sgb_data_snd', 'eight DATA_SND packets ($79, SNES address $085D down to $0810 in steps of $0B, bank 0, length 11) writing 88 contiguous bytes at $0810-$0867 (the bytes read as 65816 code, e.g. 4C 20 08 = JMP $0820, EA = NOP, 60 = RTS: that reading is I, the payload was not run); they lie inside the 4 KB PCT_TRN window where palette 7 would sit', SND, 'C')
add(0x0B, 0x6A66, 0x6A85, 'sgb_packet', 'MASK_EN freeze $B9 $01 (6A66, sent by 00:1E69) and cancel $B9 $00 (6A76, 00:1E84)', SND, 'C')

# --- gaps inside tile sets read by the generic copier (auto from the class map)
def auto_runs(b, gap=8):
    base = b * 0x4000; i = 0; runs = []
    while i < 0x4000:
        a = base + i
        if cls[a] in (ord('U'),) and not pad[a]:
            j = i
            while j < 0x4000 and cls[base + j] == ord('U') and not pad[base + j]: j += 1
            runs.append([i, j]); i = j
        else: i += 1
    m = []
    for r in runs:
        if m and r[0] - m[-1][1] <= gap: m[-1][1] = r[1]
        else: m.append(r)
    return [(0x4000 + s, 0x4000 + e - 1) for s, e in m]
for b in (0x10, 0x17, 0x19, 0x1A, 0x1C, 0x1E):
    for s, e in auto_runs(b):
        add(b, s, e, 'tile_set_gap', 'bytes of a 2bpp tile block that no copy reads (organic readers on both sides)', 'tile blocks loaded by 00:17E8', 'I')
# --- bank $14: text/banner tiles
add(0x14, 0x4000, 0x4553, 'alt_exchange_screen_tiles', 'tiles 0-84 of the unused alternate stand-by screen of the image exchange (tile set 14:4000-502F, tile map 23:5CC0; tracked as a de-duplicated tile list, so a raster reading looks like strips of different widths); the thumbnail reducer 00:289C reads 14:4554 onward only through a stray pointer, never as tiles', 'no loader in either ROM (BGB + code search; README 14.4 / 16.24 (3))', 'I')
# --- tilemaps, banks $25-$27
add(0x25, 0x4A80, 0x4DBF, 'bg_tilemap', '32-column BG tilemap: FE fill, 16x14 photo-area ramp (00-8F, 00-4F), side icons; sits between the maps copied from 25:47C0 and 25:4DC0', 'neighbours 25:47C0 and 25:4DC0 are copied to $9800', 'I')
add(0x25, 0x5080, 0x50BF, 'bg_tilemap', 'first two rows (tile ramp 00-27) of the map whose other rows are read from 25:50C0', 'map 25:5080-', 'I')
add(0x25, 0x5320, 0x535F, 'bg_tilemap', 'first two rows (tile ramp 00-27) of the map that starts at 25:5320', 'map 25:5320-', 'I')
add(0x26, 0x4500, 0x487F, 'bg_tilemap', '32-column BG tilemap: 16x14 photo-area ramp with side icons, then $FF fill', 'before the map copied from 26:4EC0', 'I')
add(0x27, 0x4772, 0x486F, 'bg_tilemap', '32-column BG tilemap rows filled with tile $FD (blank), before the map copied from 27:4870', 'map copied from 27:4870', 'I')
add(0x27, 0x4AA0, 0x4CAF, 'tile_data', 'small 2bpp tile set (round shapes, then $FF / $00 filler) read in part only by forced runs', 'unknown', 'I')
# --- Japanese alphabet glyphs
add(0x28, 0x51B8, 0x53C9, 'kana_text_glyphs', 'white-on-black Japanese text glyph tiles (kana strings)', 'text engine readers 00:061D-0639', 'I')
for s, e in auto_runs(0x2A, gap=8):
    add(0x2A, s, e, 'kana_glyph_tiles', 'tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them)', 'text engine readers 00:061D-0639', 'I', 'Stamps (JPN): the font block is bracketed "Unused?"')
# --- wild frame lateral strips (never-read part of every wild frame sheet)
SHEETS = ['idx0 (frame 01)', 'idx1 (frame 02)', 'idx2 (frame 03)', 'idx3 (frame 04)', 'idx4 (frame 05)', 'idx5 (frame 06)', 'idx6 (frame 07)', 'idx7 (frame 08)']
FRAMES_BLANKED = (1, 2, 4, 5, 6, 7)   # frames 01 and 04 (idx 0, 3) were not blanked: their side strips are read in forced runs
# C = BGB print of the frame + blanking test of the sheet tiles 280-383 changed exactly the lateral tiles (tools/wild_border_check.py); I = not tested
EV = {k: 'C' if k in FRAMES_BLANKED else 'I' for k in range(8)}
for k in range(8):
    f = 0xC4000 + k * 0x1800 + 0x1180
    b = f // 0x4000; a = 0x4000 + f % 0x4000
    add(b, a, a + 0x37F, 'wild_frame_lateral', 'lateral border strips of wild frame sheet %s: sheet tiles 280-335 = 4 tiles wide x 14 rows, printed at columns 0,1,18,19 of rows 6-19' % SHEETS[k], 'wild frame sheet at %02X:%04X, printer path 00:0468 / 1D:0A' % (((0xC4000 + k * 0x1800) // 0x4000), 0x4000 + (0xC4000 + k * 0x1800) % 0x4000), EV[k], 'Frames (JPN)')
w = csv.writer(open(ARGS[0], 'w', newline='\n'), lineterminator='\n')
w.writerow(['bank', 'start', 'end', 'type', 'description', 'consumer_or_context', 'evidence', 'community_sheet'])
w.writerows(rows)
# statistics
tot = collections.Counter(); lab = bytearray(len(rom))
for r in rows:
    b = int(r[0], 16); s = int(r[1], 16); e = int(r[2], 16)
    for o in range(off(b, s), off(b, e) + 1): lab[o] = 1
Ub = [i for i in range(len(rom)) if cls[i] == ord('U') and not pad[i]]
print('rows', len(rows), 'U non-padding', len(Ub), 'labelled', sum(1 for i in Ub if lab[i]), 'unlabelled', sum(1 for i in Ub if not lab[i]))
un = collections.Counter(i // 0x4000 for i in Ub if not lab[i]); print('unlabelled by bank', dict((hex(k), v) for k, v in un.items()))

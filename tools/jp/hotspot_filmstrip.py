import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from hotspot_common import *
out = sys.argv[1]; FR = [int(x) for x in sys.argv[2:]] or [3, 8, 16, 30, 60]
sav0 = open(SRC, 'rb').read(); prep(sav0); g.run(30); X, Y = g.peek(0xD667), g.peek(0xD668)
w, h = 80, 72; sheet = Image.new('RGB', (len(FR) * (w + 2) + 30, 16 * (h + 2)), (255, 255, 255)); d = ImageDraw.Draw(sheet)
for k in range(16):
    prep(make(sav0, k, X, Y)); snap = g.snapshot()
    d.text((2, k * (h + 2) + 30), '%d' % k, fill=(0, 0, 0)); g.keys(g.A); g.run(4); g.keys(0); done = 4
    for j, fr in enumerate(FR):
        g.run(max(0, fr - done)); done = max(done, fr)
        sheet.paste(Image.fromarray(R.screen(g)).convert('RGB').resize((w, h), Image.NEAREST), (30 + j * (w + 2), k * (h + 2)))
sheet.save(out); print(out, sheet.size, 'pointer cell', X, Y)

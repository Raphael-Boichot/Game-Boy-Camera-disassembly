import sys; sys.path.insert(0,'/home/claude/gbcam_jp/cov/linksniff'); sys.path.insert(0,'/home/claude/gbcam_jp/cov'); sys.path.insert(0,'/home/claude/gbcam_jp/tools')
import lsl2, sram_analyze as SA
SLOT = lambda n: 0x2000 + (n - 1) * 0x1000
def run_pair(savA, savB, linked=True, ka_init=(2, 16), kb_init=(1, 0), steps=60, role_init='A', press=None, S=None, trace=False):
    """A initiator by default. keys: first the Left/Right choice, then A on the initiator."""
    S = S or lsl2.Sniffer2(); P = S.P; S.start(savA, savB); P.connected = linked
    a0 = bytes(P.A.sram()); b0 = bytes(P.B.sram())
    P.act(2, 1, 4, 60); P.act(16, 0, 4, 200)
    for i in range(steps):
        sa = P.state(P.A)[1]
        P.act(16 if sa in (3, 5) else 0, 0, 4, 12)
    return S, a0, b0, bytes(P.A.sram()), bytes(P.B.sram())
def tag(b, slot, copy=0):
    o = SLOT(slot) + 0xF00 + copy * 0x5C
    return b[o:o + 0x5C]
def vec(b): return b[0x11B2:0x11B2 + 30]
def nphotos(b): return sum(1 for x in vec(b) if x < 30)
def decode_tag(t):
    return dict(id=t[0:4].hex(), name=t[4:13].hex(), gb=t[13], birth=t[14:18].hex(), F12_14=tuple(t[18:21]), F30_32=tuple(t[0x30:0x33]), F33=t[0x33], sum_xor=(t[0x34], t[0x35]), hot=bytes(t[0x36:0x54]).hex(), magic=bytes(t[0x55:0x5A]))
def diff_regions(x, y, gap=8):
    out = []; i = 0; n = len(x)
    while i < n:
        if x[i] != y[i]:
            j = i
            while j < n and x[j] != y[j]: j += 1
            out.append([i, j]); i = j
        else: i += 1
    m = []
    for a, b in out:
        if m and a - m[-1][1] < gap: m[-1][1] = b
        else: m.append([a, b])
    return m

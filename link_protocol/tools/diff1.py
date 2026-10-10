import sys; sys.path.insert(0,'/home/claude/gbcam_jp/cov/linksniff'); sys.path.insert(0,'/home/claude/gbcam_jp/cov')
import lsl, run_exchange as R
def runs(savA, savB, connected=True, **kw):
    # same script; with connected=False the cable is unplugged
    S = lsl.Sniffer(); P = S.P; S.start(savA, savB); P.connected = connected
    a0 = bytes(P.A.sram()); b0 = bytes(P.B.sram())
    P.act(2, 1, 4, 60); P.act(16, 0, 4, 200)
    for i in range(60):
        sa = P.state(P.A)[1]
        P.act(16 if sa in (3, 5) else 0, 0, 4, 12)
    return S, a0, b0
def regions(x, y):
    out = []; i = 0; n = len(x)
    while i < n:
        if x[i] != y[i]:
            j = i
            while j < n and (x[j] != y[j] or (j + 1 < n and x[j+1] != y[j+1] and j-i < 0)): j += 1
            j = i
            while j < n and x[j] != y[j]: j += 1
            out.append((i, j)); i = j
        else: i += 1
    # merge near regions
    m = []
    for a, b in out:
        if m and a - m[-1][1] < 8: m[-1] = (m[-1][0], b)
        else: m.append((a, b))
    return m
if __name__ == '__main__':
    A, B = sys.argv[1], sys.argv[2]
    S, a0, b0 = runs(A, B, True); P = S.P
    a1 = bytes(P.A.sram()); b1 = bytes(P.B.sram())
    S2, a0_, b0_ = runs(A, B, False); P2 = S2.P
    a2 = bytes(P2.A.sram()); b2 = bytes(P2.B.sram())
    print('A: linked vs unlinked'); 
    for a, b in regions(a1, a2): print('  %05X-%05X'%(a, b-1), 'linked', a1[a:b][:24].hex(), 'unlinked', a2[a:b][:24].hex())
    print('B: linked vs unlinked')
    for a, b in regions(b1, b2): print('  %05X-%05X'%(a, b-1), 'linked', b1[a:min(b,a+24)].hex(), 'unlinked', b2[a:min(b,a+24)].hex(), 'len', b-a)
    open('/tmp/claude-0/-home-claude/00f86275-6319-5130-8431-24e82ffea019/scratchpad/ex_A.sav','wb').write(a1); open('/tmp/claude-0/-home-claude/00f86275-6319-5130-8431-24e82ffea019/scratchpad/ex_B.sav','wb').write(b1)
    open('/tmp/claude-0/-home-claude/00f86275-6319-5130-8431-24e82ffea019/scratchpad/ex_B0.sav','wb').write(b2)
    open('/tmp/claude-0/-home-claude/00f86275-6319-5130-8431-24e82ffea019/scratchpad/ex_A0.sav','wb').write(a2)

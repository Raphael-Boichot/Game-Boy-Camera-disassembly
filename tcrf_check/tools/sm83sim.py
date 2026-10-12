"""minimal SM83 interpreter (no interrupts, no timing) to follow the pointer arithmetic of small loops; ROM window 4000-7FFF = given bank"""
class Sim:
    def __init__(s, rom, bank):
        s.rom = rom; s.bank = bank; s.m = bytearray(0x10000)
        s.a=s.f=s.b=s.c=s.d=s.e=s.h=s.l=0; s.sp=0xDFF0; s.pc=0; s.ex=set(); s.steps=0
    def rd(s, a):
        a &= 0xFFFF
        if a < 0x4000: return s.rom[a]
        if a < 0x8000: return s.rom[s.bank*0x4000 + a - 0x4000]
        return s.m[a]
    def wr(s, a, v):
        a &= 0xFFFF
        if a < 0x8000:
            if 0x2000 <= a < 0x4000: s.bank = v & 0x3F if v else 1
            return
        s.m[a] = v & 255
    def f8(s): v = s.rd(s.pc); s.pc = (s.pc + 1) & 0xFFFF; return v
    def f16(s): lo = s.f8(); return lo | s.f8() << 8
    BC = property(lambda s: s.b << 8 | s.c, lambda s, v: (setattr(s, 'b', v >> 8 & 255), setattr(s, 'c', v & 255)))
    DE = property(lambda s: s.d << 8 | s.e, lambda s, v: (setattr(s, 'd', v >> 8 & 255), setattr(s, 'e', v & 255)))
    HL = property(lambda s: s.h << 8 | s.l, lambda s, v: (setattr(s, 'h', v >> 8 & 255), setattr(s, 'l', v & 255)))
    def r(s, i): return [s.b, s.c, s.d, s.e, s.h, s.l, s.rd(s.HL), s.a][i]
    def setr(s, i, v):
        v &= 255
        if i == 0: s.b = v
        elif i == 1: s.c = v
        elif i == 2: s.d = v
        elif i == 3: s.e = v
        elif i == 4: s.h = v
        elif i == 5: s.l = v
        elif i == 6: s.wr(s.HL, v)
        else: s.a = v
    def push(s, v): s.sp = (s.sp - 1) & 0xFFFF; s.wr(s.sp, v >> 8); s.sp = (s.sp - 1) & 0xFFFF; s.wr(s.sp, v & 255)
    def pop(s): lo = s.rd(s.sp); s.sp = (s.sp + 1) & 0xFFFF; hi = s.rd(s.sp); s.sp = (s.sp + 1) & 0xFFFF; return hi << 8 | lo
    def setf(s, z=None, n=None, h=None, c=None):
        f = s.f
        for bit, v in ((7, z), (6, n), (5, h), (4, c)):
            if v is not None: f = (f | 1 << bit) if v else (f & ~(1 << bit))
        s.f = f & 0xF0
    def alu(s, op, v):
        a = s.a
        if op == 0: r = a + v; s.setf(r & 255 == 0, 0, (a & 15) + (v & 15) > 15, r > 255); s.a = r & 255
        elif op == 1: cy = (s.f >> 4) & 1; r = a + v + cy; s.setf(r & 255 == 0, 0, (a & 15) + (v & 15) + cy > 15, r > 255); s.a = r & 255
        elif op in (2, 7, 3):
            cy = (s.f >> 4) & 1 if op == 3 else 0; r = a - v - cy
            s.setf(r & 255 == 0, 1, (a & 15) < (v & 15) + cy, r < 0)
            if op != 7: s.a = r & 255
        elif op == 4: s.a = a & v; s.setf(s.a == 0, 0, 1, 0)
        elif op == 5: s.a = a ^ v; s.setf(s.a == 0, 0, 0, 0)
        elif op == 6: s.a = a | v; s.setf(s.a == 0, 0, 0, 0)
    def cc(s, i): return [not s.f & 128, bool(s.f & 128), not s.f & 16, bool(s.f & 16)][i]
    def step(s):
        pc0 = s.pc; s.ex.add((s.bank if pc0 >= 0x4000 else 0, pc0)); op = s.f8(); s.steps += 1
        x = op >> 6; y = op >> 3 & 7; z = op & 7; p = y >> 1; q = y & 1
        if x == 1:
            if op == 0x76: return 'halt'
            s.setr(y, s.r(z)); return
        if x == 2: s.alu(y, s.r(z)); return
        if x == 0:
            if z == 0:
                if y == 0: return
                if y == 2: return 'stop'
                if y == 3 or y >= 4:
                    d = s.f8(); d = d - 256 if d > 127 else d
                    if y == 3 or s.cc(y - 4): s.pc = (s.pc + d) & 0xFFFF
                    return
                if y == 1: a = s.f16(); s.wr(a, s.sp & 255); s.wr(a + 1, s.sp >> 8); return
            if z == 1:
                if q == 0:
                    v = s.f16()
                    if p == 0: s.BC = v
                    elif p == 1: s.DE = v
                    elif p == 2: s.HL = v
                    else: s.sp = v
                else:
                    hl = s.HL; v = [s.BC, s.DE, s.HL, s.sp][p]; r = hl + v
                    s.setf(None, 0, (hl & 0xFFF) + (v & 0xFFF) > 0xFFF, r > 0xFFFF); s.HL = r & 0xFFFF
                return
            if z == 2:
                if q == 0:
                    if p == 0: s.wr(s.BC, s.a)
                    elif p == 1: s.wr(s.DE, s.a)
                    elif p == 2: s.wr(s.HL, s.a); s.HL = s.HL + 1
                    else: s.wr(s.HL, s.a); s.HL = s.HL - 1
                else:
                    if p == 0: s.a = s.rd(s.BC)
                    elif p == 1: s.a = s.rd(s.DE)
                    elif p == 2: s.a = s.rd(s.HL); s.HL = s.HL + 1
                    else: s.a = s.rd(s.HL); s.HL = s.HL - 1
                return
            if z == 3:
                d = 1 if q == 0 else -1
                if p == 0: s.BC = (s.BC + d) & 0xFFFF
                elif p == 1: s.DE = (s.DE + d) & 0xFFFF
                elif p == 2: s.HL = (s.HL + d) & 0xFFFF
                else: s.sp = (s.sp + d) & 0xFFFF
                return
            if z == 4: v = (s.r(y) + 1) & 255; s.setf(v == 0, 0, (s.r(y) & 15) == 15); s.setr(y, v); return
            if z == 5: v = (s.r(y) - 1) & 255; s.setf(v == 0, 1, (s.r(y) & 15) == 0); s.setr(y, v); return
            if z == 6: s.setr(y, s.f8()); return
            if z == 7:
                if y == 5: s.a ^= 255; s.setf(None, 1, 1); return
                if y == 7: s.setf(None, 0, 0, not s.f & 16); return
                if y == 6: s.setf(None, 0, 0, 1); return
                raise NotImplementedError('rot %02x' % op)
        if x == 3:
            if z == 0:
                if y < 4:
                    if s.cc(y): s.pc = s.pop()
                    return
                if y == 4: s.wr(0xFF00 + s.f8(), s.a); return
                if y == 6: s.a = s.rd(0xFF00 + s.f8()); return
                raise NotImplementedError('%02x' % op)
            if z == 1:
                if q == 0:
                    v = s.pop()
                    if p == 0: s.BC = v
                    elif p == 1: s.DE = v
                    elif p == 2: s.HL = v
                    else: s.a = v >> 8; s.f = v & 0xF0
                    return
                if p == 0: s.pc = s.pop(); return 'ret'
                if p == 2: s.pc = s.HL; return
                raise NotImplementedError('%02x' % op)
            if z == 2:
                if y < 4:
                    a = s.f16()
                    if s.cc(y): s.pc = a
                    return
                if y == 5: a = s.f16(); s.wr(a, s.a); return
                if y == 7: a = s.f16(); s.a = s.rd(a); return
                if y == 4: s.wr(0xFF00 + s.c, s.a); return
                if y == 6: s.a = s.rd(0xFF00 + s.c); return
            if z == 3:
                if y == 0: s.pc = s.f16(); return
                if y == 1:
                    cb = s.f8(); cx = cb >> 6; cy = cb >> 3 & 7; cz = cb & 7; v = s.r(cz)
                    if cx == 0 and cy == 6: s.setr(cz, (v << 4 | v >> 4) & 255); s.setf(s.r(cz) == 0, 0, 0, 0); return
                    if cx == 0 and cy == 4: c = v >> 7; s.setr(cz, (v << 1) & 255); s.setf(s.r(cz) == 0, 0, 0, c); return
                    if cx == 0 and cy == 7: c = v & 1; s.setr(cz, v >> 1); s.setf(s.r(cz) == 0, 0, 0, c); return
                    if cx == 1: s.setf(not v >> cy & 1, 0, 1); return
                    if cx == 2: s.setr(cz, v & ~(1 << cy)); return
                    if cx == 3: s.setr(cz, v | 1 << cy); return
                    raise NotImplementedError('cb %02x' % cb)
            if z == 4:
                if y < 4:
                    a = s.f16()
                    if s.cc(y): s.push(s.pc); s.pc = a
                    return
            if z == 5:
                if q == 0:
                    v = [s.BC, s.DE, s.HL, s.a << 8 | s.f][p]; s.push(v); return
                if p == 0: a = s.f16(); s.push(s.pc); s.pc = a; return
            if z == 6: s.alu(y, s.f8()); return
            if z == 7: s.push(s.pc); s.pc = y * 8; return
        raise NotImplementedError('op %02x at %04x' % (op, pc0))
    def run(s, entry, limit=2000000, stop_depth=True):
        s.pc = entry; depth0 = s.sp
        while s.steps < limit:
            r = s.step()
            if r == 'ret' and s.sp > depth0: return 'ret'
            if r in ('halt', 'stop'): return r
        return 'limit'

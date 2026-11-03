"""The read addresses of Cam_PopcountSampleLoop (0A:4FBD-5090, README 10-B), taken from the ROM bytes with a tiny executor that knows only the 14 opcodes the routine uses
(the same executor as sensor_meter_geom.py).  Used by sensor_pixel_map.py (the figure) and sensor_meter_reads_bgb.py (the check against BGB's own read log)."""
def meter_reads(rom):
    """(loop, address) of every read of the routine, in order: loop 1 = 120 reads, loop 2 = 48 reads; one read = 2 bytes (plane 0 at the address, plane 1 at address + 1)."""
    rd = lambda a: rom[0x0A * 0x4000 + a - 0x4000]
    de = 0xA320; hl = 0; ff8a = 0; a = 0; pc = 0x4FBD; z = False; log = []; loop = 1
    while True:
        op = rd(pc)
        if op == 0x3e: a = rd(pc + 1); pc += 2
        elif op == 0xe0: ff8a = a; pc += 2
        elif op == 0xf0: a = ff8a; pc += 2
        elif op == 0xcd: log.append((loop, de)); de = (de + 2) & 0xFFFF; pc += 3
        elif op == 0x21: hl = rd(pc + 1) | rd(pc + 2) << 8; pc += 3
        elif op == 0x19: hl = (hl + de) & 0xFFFF; pc += 1
        elif op == 0x54: de = (hl & 0xFF00) | (de & 0xFF); pc += 1
        elif op == 0x5d: de = (de & 0xFF00) | (hl & 0xFF); pc += 1
        elif op == 0x3d: a = (a - 1) & 0xFF; z = (a == 0); pc += 1
        elif op == 0x28:
            o = rd(pc + 1); o = o - 256 if o > 127 else o; pc = pc + 2 + (o if z else 0)
        elif op == 0x18:
            o = rd(pc + 1); o = o - 256 if o > 127 else o; pc = pc + 2 + o
        elif op == 0xcb: pc += 2
        elif op == 0x11: de = rd(pc + 1) | rd(pc + 2) << 8; loop = 2; pc += 3
        elif op == 0xc8:
            if z: break
            pc += 1
        else: raise SystemExit('unexpected opcode %02x at %04x' % (op, pc))
    return log

def where(ad):
    """(x, y) of the first pixel of the 8-pixel tile row that the byte at ad belongs to (frame of 16 x 16 tiles, 16 bytes per tile, 2 bytes per pixel row)."""
    o = ad - 0xA000; i = o // 16
    return (i % 16) * 8, (i // 16) * 8 + (o % 16) // 2

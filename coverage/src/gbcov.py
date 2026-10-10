"""ctypes wrapper around the native Game Boy coverage core (build: see ../README.md)."""
import ctypes as C, numpy as np, os
import sys, platform
HERE = os.path.dirname(os.path.abspath(__file__))
_lib = {'Windows': 'gbcov.dll', 'Darwin': 'libgbcov.dylib'}.get(platform.system(), 'libgbcov.so')
L = C.CDLL(os.path.join(HERE, _lib))
L.gb_state_size.restype = C.c_size_t
L.gb_load_rom.argtypes = [C.c_char_p]; L.gb_load_rom.restype = C.c_int
L.gb_reset.argtypes = [C.c_char_p, C.c_size_t]
L.gb_save.argtypes = [C.c_void_p]; L.gb_load.argtypes = [C.c_void_p]
L.gb_set_keys.argtypes = [C.c_uint8]; L.gb_attach_printer.argtypes = [C.c_int]
L.gb_run_frames.argtypes = [C.c_int]; L.gb_run_frame.restype = C.c_int
L.gb_peek.argtypes = [C.c_uint16]; L.gb_peek.restype = C.c_uint8
L.gb_poke.argtypes = [C.c_uint16, C.c_uint8]
L.gb_pc.restype = C.c_uint16; L.gb_rombank.restype = C.c_uint8
L.gb_frame.restype = C.c_uint32; L.gb_cycles.restype = C.c_uint64
for n in ('gb_cnt_exec', 'gb_cnt_dread', 'gb_cnt_ram'): getattr(L, n).restype = C.c_uint64
for n in ('gb_cov_exec_ptr', 'gb_cov_dread_ptr', 'gb_cov_ram_ptr', 'gb_cov_reader_ptr', 'gb_sram_ptr', 'gb_wram_ptr'):
    getattr(L, n).restype = C.c_void_p
L.gb_bsel_n.argtypes = [C.c_int]; L.gb_bsel_n.restype = C.c_uint32
L.gb_bsel_dump.argtypes = [C.c_int, C.c_void_p, C.c_void_p, C.c_int]; L.gb_bsel_dump.restype = C.c_int
L.gb_cov_load.argtypes = [C.c_void_p] * 4
L.gb_bsel_put.argtypes = [C.c_int, C.c_uint32, C.c_uint32]
L.gb_set_organic.argtypes = [C.c_int]
L.gb_cmp_dump.argtypes = [C.c_void_p, C.c_void_p, C.c_int]; L.gb_cmp_dump.restype = C.c_int
L.gb_org_load2.argtypes = [C.c_void_p, C.c_void_p, C.c_void_p]
L.gb_set_known.argtypes = [C.c_void_p]; L.gb_wild.restype = C.c_int; L.gb_org_ram_ptr.restype = C.c_void_p
L.gb_org_exec_ptr.restype = C.c_void_p; L.gb_org_dread_ptr.restype = C.c_void_p
ROMSZ = 1 << 20
STATE_SIZE = L.gb_state_size()

# joypad bits
RIGHT, LEFT, UP, DOWN, A, B, SELECT, START = 1, 2, 4, 8, 16, 32, 64, 128

def _arr(ptr, n, dt): return np.ctypeslib.as_array(C.cast(ptr, C.POINTER(dt)), shape=(n,))
def cov_exec():  return _arr(L.gb_cov_exec_ptr(), ROMSZ, C.c_uint8)
def cov_dread(): return _arr(L.gb_cov_dread_ptr(), ROMSZ, C.c_uint8)
def cov_reader(): return _arr(L.gb_cov_reader_ptr(), ROMSZ, C.c_uint32)
def cov_ram():   return _arr(L.gb_cov_ram_ptr(), 0x10000, C.c_uint8)
def wram():      return _arr(L.gb_wram_ptr(), 0x2000, C.c_uint8)
def sram():      return _arr(L.gb_sram_ptr(), 0x20000, C.c_uint8)

def load_rom(path):
    n = L.gb_load_rom(path.encode()); assert n > 0, path; return n
def reset(sram_bytes=b''):
    L.gb_reset(sram_bytes, len(sram_bytes))
def snapshot():
    b = (C.c_uint8 * STATE_SIZE)(); L.gb_save(b); return bytes(b)
def restore(s):
    b = (C.c_uint8 * STATE_SIZE).from_buffer_copy(s); L.gb_load(b)
def run(n): L.gb_run_frames(n)
def keys(k): L.gb_set_keys(k)
def peek(a): return L.gb_peek(a)
def peek16(a): return peek(a) | peek(a + 1) << 8
def tap(k, hold=4, wait=20):
    keys(k); run(hold); keys(0); run(wait)
def bsel(t=0):
    n = L.gb_bsel_n(t); ks = (C.c_uint32 * (n + 1))(); cs = (C.c_uint32 * (n + 1))()
    m = L.gb_bsel_dump(t, ks, cs, n + 1)
    return [(k >> 24, (k >> 8) & 0xFFFF, k & 0xFF, c) for k, c in zip(ks[:m], cs[:m])]
def org_exec(): return _arr(L.gb_org_exec_ptr(), ROMSZ, C.c_uint8)
def org_dread(): return _arr(L.gb_org_dread_ptr(), ROMSZ, C.c_uint8)
def set_organic(v): L.gb_set_organic(1 if v else 0)
def poke(a, v): L.gb_poke(a, v)
def cmp_clear(): L.gb_cmp_clear()
def cmp_dump(maxn=4096):
    ks = (C.c_uint32 * maxn)(); ps = (C.c_uint32 * maxn)()
    n = L.gb_cmp_dump(ks, ps, maxn)
    return [(k >> 16, (k >> 8) & 0xFF, k & 0xFF, p) for k, p in zip(ks[:n], ps[:n])]
L.gb_rd_dump.argtypes = [C.c_void_p, C.c_void_p, C.c_int]; L.gb_rd_dump.restype = C.c_int
def rd_dump(maxn=9000):
    a = (C.c_uint16 * maxn)(); v = (C.c_uint8 * maxn)(); n = L.gb_rd_dump(a, v, maxn)
    return list(zip(a[:n], v[:n]))
def bsel_raw(t):
    n = L.gb_bsel_n(t); ks = (C.c_uint32 * (n + 1))(); cs = (C.c_uint32 * (n + 1))()
    m = L.gb_bsel_dump(t, ks, cs, n + 1)
    return np.array(list(zip(ks[:m], cs[:m])), dtype=np.uint32).reshape(-1, 2)
L.gb_site_ptr.restype = C.c_void_p; L.gb_site2_ptr.restype = C.c_void_p; L.gb_site_load.argtypes = [C.c_void_p, C.c_void_p]
L.gb_mode_ptr.restype = C.c_void_p; L.gb_mode_load.argtypes = [C.c_void_p]
def modes(): return _arr(L.gb_mode_ptr(), ROMSZ, C.c_uint16)
def site(): return _arr(L.gb_site_ptr(), ROMSZ, C.c_uint32)
def site2(): return _arr(L.gb_site2_ptr(), ROMSZ, C.c_uint32)
def org_ram(): return _arr(L.gb_org_ram_ptr(), 0x10000, C.c_uint8)
def set_known(bitmap):
    b = np.ascontiguousarray(bitmap.astype(np.uint8)); L.gb_set_known(b.ctypes.data); return b
def wild(): return L.gb_wild()
def cov_save(path):
    np.savez_compressed(path, oex=org_exec().copy(), odr=org_dread().copy(), oram=org_ram().copy(), ex=cov_exec().copy(),
                        dr=cov_dread().copy(), rdr=cov_reader().copy(), ram=cov_ram().copy(),
                        bsel=np.array(bsel(0), dtype=np.uint32).reshape(-1, 4), bsel_org=np.array(bsel(1), dtype=np.uint32).reshape(-1, 4),
                        csite=bsel_raw(2), csite_org=bsel_raw(3), site=site().copy(), site2=site2().copy(), rmode=modes().copy())
def cov_restore(path):
    d = np.load(path)
    g_ = lambda k, alt: np.ascontiguousarray(d[k] if k in d.files else d[alt])
    ex = g_('ex', 'ex'); dr = g_('dr', 'dr'); rdr = g_('rdr', 'rdr'); ram = g_('ram', 'ram')
    L.gb_cov_load(ex.ctypes.data, dr.ctypes.data, rdr.ctypes.data, ram.ctypes.data)
    oex = g_('oex', 'ex'); odr = g_('odr', 'dr'); oram = g_('oram', 'ram')
    L.gb_org_load2(oex.ctypes.data, odr.ctypes.data, oram.ctypes.data)
    L.gb_bsel_clear()
    for wb, pc, nb, c in d['bsel']: L.gb_bsel_put(0, (int(wb) << 24) | (int(pc) << 8) | int(nb), int(c))
    bo = d['bsel_org'] if 'bsel_org' in d.files else d['bsel']
    for wb, pc, nb, c in bo: L.gb_bsel_put(1, (int(wb) << 24) | (int(pc) << 8) | int(nb), int(c))
    if 'rmode' in d.files:
        m_ = np.ascontiguousarray(d['rmode']); L.gb_mode_load(m_.ctypes.data)
    if 'site' in d.files:
        s1 = np.ascontiguousarray(d['site']); s2 = np.ascontiguousarray(d['site2']); L.gb_site_load(s1.ctypes.data, s2.ctypes.data)
    if 'csite' in d.files:
        for k, c in d['csite']: L.gb_bsel_put(2, int(k), int(c))
        for k, c in d['csite_org']: L.gb_bsel_put(3, int(k), int(c))
    return d['bsel']

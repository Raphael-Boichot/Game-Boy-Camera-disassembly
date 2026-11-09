#!/usr/bin/env python3
"""Hello Kitty ROM: the BGB VRAM ($8000-$97FF), LCDC and OAM at the end of every screen of roms/hello_kitty/screens/explore.csv (replayed
from a cold boot with the same demo timing as the explorer, two BGB workers). Writes roms/hello_kitty/port/vram_screens_kitty.npz: one array per
screen MM_SS (VRAM), lcdc_MM_SS, oam_MM_SS. Used by tools/kitty_draw_layouts.py."""
import sys,os,csv,subprocess,shutil,concurrent.futures,queue
import numpy as np
sys.path.insert(0,'/home/claude/game-boy-camera-disassembly/tcrf_check/tools'); sys.path.insert(0,'/home/claude/game-boy-camera-disassembly/coverage/src')
from bgb_run import read_state
import gbcov as G
ROM='/root/work/roms/pocketcamera_kitty.gb'; SC='/home/claude/game-boy-camera-disassembly/roms/hello_kitty/screens/'
KEYS=dict(A=1,B=2,Select=4,Start=8,Right=0x10,Left=0x20,Up=0x40,Down=0x80)
G.load_rom(ROM); G.reset(bytes(0x20000)); G.run(600); sav=bytearray(bytes(G.sram())); d='%06d'%999999; sav[0x100A:0x100D]=bytes([0x99]*3)
FREE=queue.Queue(); [FREE.put(w) for w in range(2)]
def run(name,keys,save=None):
    w=FREE.get()
    try:
        bgb='/home/claude/bgbx_v%d'%w
        if not os.path.exists(bgb): shutil.copytree('/home/claude/bgbx',bgb)
        t=bgb+'/vr'; os.makedirs(t,exist_ok=True)
        dem=bytes(3+700)+b''.join(bytes([KEYS[k]])*8+bytes(90) for k in keys)+bytes(60)
        open(t+'/k.dem','wb').write(dem); open(t+'/k.sav','wb').write(open(save,'rb').read() if save else sav)
        if os.path.exists(t+'/k.sna'): os.remove(t+'/k.sna')
        subprocess.run(['xvfb-run','-a','wine',bgb+'/bgb.exe','-hf','-nowarn','-nowriteini','-nobattsave','-ini',bgb+'/bgb.ini','-rom',ROM,'-demoplay',t+'/k.dem','-stateonexit',t+'/k.sna','-loadbatt',t+'/k.sav'],env=dict(os.environ,WINEDEBUG='-all',WINEPREFIX='/root/wineprefix'),capture_output=True,timeout=300)
        s=read_state(t+'/k.sna'); h=s['HRAM']
        return name,'%02X:%02X'%(h[0x0D],h[0x0E]),np.frombuffer(s['VRAM'][:0x1800],np.uint8).copy(),s['LCDC'][0],np.frombuffer(s['OAM'],np.uint8).copy()
    finally: FREE.put(w)
jobs=[]
for r in csv.DictReader(open(SC+'explore.csv')):
    if r['same']!='yes': continue
    jobs.append((r['mode']+':'+r['state'], [] if r['keys']=='-' else r['keys'].split(), None))
out={}
with concurrent.futures.ThreadPoolExecutor(2) as ex:
    for name,ms,v,l,oam in ex.map(lambda j: run(*j), jobs):
        out[name]=(ms,v,l,oam); print(name,ms,'LCDC %02X'%l,flush=True)
np.savez_compressed(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),'roms','hello_kitty','port','vram_screens_kitty.npz'),**{k.replace(':','_'):v[1] for k,v in out.items()},**{'lcdc_'+k.replace(':','_'):np.array([v[2]]) for k,v in out.items()},**{'oam_'+k.replace(':','_'):v[3] for k,v in out.items()})
print('saved',len(out))

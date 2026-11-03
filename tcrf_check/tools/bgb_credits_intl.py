#!/usr/bin/env python3
"""BGB captures of the real credits (unlocking save, USER > CREDITS): usage bgb_credits_intl.py us,jp WAIT1,WAIT2,... -> /root/work/port/cred/<rom>_<wait>.bmp, prints mode:state.
Used for tcrf_check/assets/credits_intl/ (credits_intro_pair.py)."""
import sys,os
sys.path.insert(0,'/root/work/repo/tcrf_check/tools'); import bgb_run
os.environ.setdefault('BGB_DIR','/home/claude/bgbx')
SAV='/root/work/repo/tcrf_check/assets/bgb_printer/print_features/unl_CE10238211_tagtest.sav'
rom={'us':'/root/work/roms/gbcam_usa_eu.gb','jp':'/root/work/roms/pocketcamera_jp.gb'}
base=[('A',4,200),('Start',4,200),('Right',4,60),('Right',4,60),('Right',4,60),('A',4,0)]
for r in sys.argv[1].split(','):
  for w in [int(x) for x in sys.argv[2].split(',')]:
    res=bgb_run.run(rom[r],SAV,'/root/work/port/cred/%s_%05d'%(r,w),base+[('-',1,w)],tail=0)
    print(r,w,'mode:state %02X:%02X'%(res['mode'] or 0,res['state'] or 0),flush=True)

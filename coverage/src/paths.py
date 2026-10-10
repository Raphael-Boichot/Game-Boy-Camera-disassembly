"""Default locations (override with environment variables). Layout: <package>/coverage/{src,tools,results} next to <package>/pocketcamera_jp.sym, <package>/tools, <package>/wram."""
import os
SRC = os.path.dirname(os.path.abspath(__file__))
COV = os.path.abspath(os.path.join(SRC, '..'))
PKG = os.path.abspath(os.path.join(COV, '..'))
ROM = os.environ.get('GBCAM_ROM', os.path.join(PKG, 'pocketcamera_jp.gb'))            # you must supply the ROM (md5 fdcfe686cf4df461e870b6e53b2b5a8b)
TRACE = os.environ.get('GBCAM_TRACE', os.path.join(PKG, 'wram', 'trace_jp_v3.json'))   # static trace produced by tools/rom_trace.py
ROOTS = os.environ.get('GBCAM_ROOTS', os.path.join(PKG, 'tools', 'extra_roots.json'))
SYM = os.environ.get('GBCAM_SYM', os.path.join(PKG, 'pocketcamera_jp.sym'))
SAVES = os.environ.get('GBCAM_SAVES', os.path.join(COV, 'saves'))                      # directory of NAME.sav files used as seeds (optional extras)

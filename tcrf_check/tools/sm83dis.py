#!/usr/bin/env python3
"""Tiny SM83 disassembler: dis.py ROM BANK START END   (START/END hex, CPU addresses)"""
import sys
R8=['b','c','d','e','h','l','[hl]','a']; R16=['bc','de','hl','sp']; R16S=['bc','de','hl','af']; CC=['nz','z','nc','c']
ALU=['add a,','adc a,','sub ','sbc a,','and ','xor ','or ','cp ']
def dis(rom,bank,pc):
    def phys(a): return a if a<0x4000 else bank*0x4000+a-0x4000
    b=lambda a: rom[phys(a&0xFFFF)]
    op=b(pc); n=1; t='db $%02x'%op
    w=lambda: b(pc+1)|(b(pc+2)<<8)
    if op==0x00:t='nop'
    elif op==0x10:t='stop';n=2
    elif op==0x08:t='ld [$%04x],sp'%w();n=3
    elif op==0x76:t='halt'
    elif op&0xC7==0x06 and op<0x40:t='ld %s,$%02x'%(R8[op>>3&7],b(pc+1));n=2
    elif op&0xCF==0x01 and op<0x40:t='ld %s,$%04x'%(R16[op>>4],w());n=3
    elif op&0xCF==0x09 and op<0x40:t='add hl,%s'%R16[op>>4]
    elif op&0xCF==0x03 and op<0x40:t='inc %s'%R16[op>>4]
    elif op&0xCF==0x0B and op<0x40:t='dec %s'%R16[op>>4]
    elif op&0xC7==0x04 and op<0x40:t='inc %s'%R8[op>>3&7]
    elif op&0xC7==0x05 and op<0x40:t='dec %s'%R8[op>>3&7]
    elif op in(0x02,0x12):t='ld [%s],a'%['bc','de'][op>>4]
    elif op in(0x0A,0x1A):t='ld a,[%s]'%['bc','de'][op>>4]
    elif op==0x22:t='ld [hl+],a'
    elif op==0x2A:t='ld a,[hl+]'
    elif op==0x32:t='ld [hl-],a'
    elif op==0x3A:t='ld a,[hl-]'
    elif op==0x07:t='rlca'
    elif op==0x0F:t='rrca'
    elif op==0x17:t='rla'
    elif op==0x1F:t='rra'
    elif op==0x27:t='daa'
    elif op==0x2F:t='cpl'
    elif op==0x37:t='scf'
    elif op==0x3F:t='ccf'
    elif op==0x18:t='jr $%04x'%((pc+2+(b(pc+1)^128)-128)&0xFFFF);n=2
    elif op in(0x20,0x28,0x30,0x38):t='jr %s,$%04x'%(CC[op>>3&3],(pc+2+(b(pc+1)^128)-128)&0xFFFF);n=2
    elif 0x40<=op<0x80:t='ld %s,%s'%(R8[op>>3&7],R8[op&7])
    elif 0x80<=op<0xC0:t='%s%s'%(ALU[op>>3&7],R8[op&7])
    elif op&0xE7==0xC0:t='ret %s'%CC[op>>3&3]
    elif op&0xCF==0xC1:t='pop %s'%R16S[op>>4&3]
    elif op&0xCF==0xC5:t='push %s'%R16S[op>>4&3]
    elif op&0xE7==0xC2:t='jp %s,$%04x'%(CC[op>>3&3],w());n=3
    elif op==0xC3:t='jp $%04x'%w();n=3
    elif op&0xE7==0xC4:t='call %s,$%04x'%(CC[op>>3&3],w());n=3
    elif op==0xCD:t='call $%04x'%w();n=3
    elif op&0xC7==0xC6:t='%s$%02x'%(ALU[op>>3&7],b(pc+1));n=2
    elif op&0xC7==0xC7:t='rst $%02x'%(op&0x38)
    elif op==0xC9:t='ret'
    elif op==0xD9:t='reti'
    elif op==0xE0:t='ldh [$ff%02x],a'%b(pc+1);n=2
    elif op==0xF0:t='ldh a,[$ff%02x]'%b(pc+1);n=2
    elif op==0xE2:t='ld [c],a'
    elif op==0xF2:t='ld a,[c]'
    elif op==0xEA:t='ld [$%04x],a'%w();n=3
    elif op==0xFA:t='ld a,[$%04x]'%w();n=3
    elif op==0xE8:t='add sp,%d'%(b(pc+1)-256 if b(pc+1)>127 else b(pc+1));n=2
    elif op==0xF8:t='ld hl,sp%+d'%(b(pc+1)-256 if b(pc+1)>127 else b(pc+1));n=2
    elif op==0xE9:t='jp hl'
    elif op==0xF9:t='ld sp,hl'
    elif op==0xF3:t='di'
    elif op==0xFB:t='ei'
    elif op==0xCB:
        c=b(pc+1);n=2;r=R8[c&7]
        t=('rlc rrc rl rr sla sra swap srl'.split()[c>>3&7]+' '+r) if c<0x40 else ['bit','res','set'][(c>>6)-1]+' %d,%s'%(c>>3&7,r)
    return n,t
if __name__=='__main__':
    rom=open(sys.argv[1],'rb').read();bank=int(sys.argv[2],16);a=int(sys.argv[3],16);e=int(sys.argv[4],16)
    while a<e:
        n,t=dis(rom,bank,a);print('%02X:%04X  %-24s %s'%(bank,a,' '.join('%02x'%rom[(a if a<0x4000 else bank*0x4000+a-0x4000)+i] for i in range(n)),t));a+=n

#!/usr/bin/env python3
"""畫中文到指定尺寸 PNG，限 EGA 16 色，供 sci0_view.py encode --replace 疊回主選單 cel。
用法：render_cel_cht.py <文字> <w> <h> <out.png> [--fg R,G,B] [--bg R,G,B] [--size N] [--pad L]"""
import sys,argparse
from PIL import Image,ImageFont,ImageDraw
EGA=[(0,0,0),(0,0,170),(0,170,0),(0,170,170),(170,0,0),(170,0,170),(170,85,0),
(170,170,170),(85,85,85),(85,85,255),(85,255,85),(85,255,255),(255,85,85),
(255,85,255),(255,255,85),(255,255,255)]
def nearest(c):
    return min(EGA,key=lambda e:sum((a-b)**2 for a,b in zip(c,e)))
ap=argparse.ArgumentParser()
ap.add_argument('text');ap.add_argument('w',type=int);ap.add_argument('h',type=int);ap.add_argument('out')
ap.add_argument('--fg',default='0,0,0');ap.add_argument('--bg',default='255,255,255')
ap.add_argument('--size',type=int,default=15);ap.add_argument('--pad',type=int,default=1)
ap.add_argument('--fgfirst',default='')  # 首字特殊色(對齊原首字母強調)
a=ap.parse_args()
fg=tuple(map(int,a.fg.split(',')));bg=tuple(map(int,a.bg.split(',')))
fgf=tuple(map(int,a.fgfirst.split(','))) if a.fgfirst else fg
f=ImageFont.truetype('/usr/share/fonts/truetype/arphic/uming.ttc',a.size,index=2)
# 硬邊二值化：每字畫到 L mask，>threshold 算筆劃 → 純色(無抗鋸齒雜色，RLE 友善)
im=Image.new('RGB',(a.w,a.h),nearest(bg))
px=im.load()
x=a.pad
mask=Image.new('L',(a.w,a.h),0);md=ImageDraw.Draw(mask)
firstmask=Image.new('L',(a.w,a.h),0);fd=ImageDraw.Draw(firstmask)
for i,ch in enumerate(a.text):
    bb=md.textbbox((0,0),ch,font=f);cw=bb[2]-bb[0];chh=bb[3]-bb[1]
    y=(a.h-chh)//2-bb[1]
    (fd if i==0 else md).text((x-bb[0],y),ch,font=f,fill=255)
    x+=cw+1
mp=mask.load();fp=firstmask.load();fgc=nearest(fg);fgfc=nearest(fgf)
for yy in range(a.h):
    for xx in range(a.w):
        if fp[xx,yy]>96: px[xx,yy]=fgfc
        elif mp[xx,yy]>96: px[xx,yy]=fgc
im.save(a.out)
print(f"{a.text} → {a.out} ({a.w}x{a.h})")

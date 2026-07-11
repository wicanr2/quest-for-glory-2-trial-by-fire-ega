#!/bin/bash
# 重繪 view.800 職業名成中文(暗紅底金字)。loop2=FIGHTER→戰士 loop3=WIZARD→法師 loop4=THIEF→盜賊
set -e; cd "$(dirname "$0")/.."
R(){ python3 tools/render_cel_cht.py "$1" $2 $3 "$4" --bg 170,0,0 --fg 255,255,85 --size 14 >/dev/null; }
R 戰士 68 17 out/cn_2.png
R 法師 68 17 out/cn_3.png
R 盜賊 67 17 out/cn_4.png
cp extract/dump/view.800 out/vw800
for lp in 2 3 4; do for cel in 0 1; do
  python3 tools/sci0_view.py encode out/vw800 out/vw800b --replace $lp,$cel,out/cn_$lp.png >/dev/null
  mv out/vw800b out/vw800
done; done
python3 tools/sci0_view.py encode out/vw800 art/ega/view.800 --patch >/dev/null
echo "view.800 = $(stat -c%s art/ega/view.800) bytes"

#!/bin/bash
# 重繪主選單 view.765 選項成中文 (硬邊二值化, RLE 友善)。可重跑。
set -e; cd "$(dirname "$0")/.."
gen(){ local t=$1 w=$2 h=$3 lp=$4
  python3 tools/render_cel_cht.py "$t" $w $h out/m_${lp}_0.png --fg 0,0,0 --fgfirst 255,85,85 --size 15 >/dev/null
  python3 tools/render_cel_cht.py "$t" $w $h out/m_${lp}_1.png --fg 0,0,170 --size 15 >/dev/null
  python3 tools/render_cel_cht.py "$t" $w $h out/m_${lp}_2.png --fg 85,85,85 --fgfirst 170,0,0 --size 15 >/dev/null
}
gen 序章 96 18 1; gen 建立英雄 123 18 2; gen 匯入英雄 123 18 3; gen 繼續冒險 111 19 4
cp extract/dump/view.765 out/vwork
for lp in 1 2 3 4; do for cel in 0 1 2; do
  python3 tools/sci0_view.py encode out/vwork out/vwork2 --replace $lp,$cel,out/m_${lp}_${cel}.png >/dev/null
  mv out/vwork2 out/vwork
done; done
python3 tools/sci0_view.py encode out/vwork art/ega/view.765 --patch >/dev/null
echo "view.765 = $(stat -c%s art/ega/view.765) bytes (需 < 65537)"

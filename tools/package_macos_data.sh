#!/usr/bin/env bash
# 把 macOS CI(.github/workflows/build-macos.yml)產出的「空引擎」ScummVM.app,
# 注入 QFG2 EGA 中文資料(dist/ 五檔)+ README,重新打包成可交付檔。
# 在 CI runner 內跑(bash 內建即可,不需 docker/python)。
#
# 用法:tools/package_macos_data.sh <engine.tar.gz 或 .app 路徑> <輸出目錄>
#
# QFG2 EGA 只有單一版本(不像 QFG1 有 VGA/EGA 雙軌),不需要 pkg_common.sh 那套
# edition 分派,直接複製 dist/ 五個檔案即可。
#
# 交付原則(硬):.app 本身只含 patched 引擎;中文資料放進
# .app/Contents/Resources/cht-data-ega/,原遊戲資源絕不塞入。
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:?用法: package_macos_data.sh <engine.tar.gz|.app> <輸出目錄>}"
OUT="${2:?需指定輸出目錄}"

DIST="$ROOT/dist"
DATA_FILES=(translation.tsv qfg1_big5.fnt qfg1_big5_hi.fnt view.765 view.800)
for f in "${DATA_FILES[@]}"; do
  [ -f "$DIST/$f" ] || { echo "!! 缺少中文資料檔:$DIST/$f" >&2; exit 1; }
done

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# 接受 .tar.gz 或已展開的 .app 兩種輸入
if [ -d "$SRC" ] && [[ "$SRC" == *.app ]]; then
  cp -R "$SRC" "$WORK/ScummVM.app"
else
  tar xzf "$SRC" -C "$WORK"
fi
APP="$(find "$WORK" -maxdepth 2 -iname '*.app' -type d | head -1)"
[ -n "$APP" ] || { echo "!! 在 $SRC 裡找不到 .app" >&2; exit 1; }

CHT_DIR="$APP/Contents/Resources/cht-data-ega"
echo ">> 注入 EGA 中文資料 → $CHT_DIR/"
rm -rf "$CHT_DIR"; mkdir -p "$CHT_DIR"
cp "${DATA_FILES[@]/#/$DIST/}" "$CHT_DIR/"
echo ">>    staged $(ls "$CHT_DIR" | wc -l) 個中文資料檔 → $CHT_DIR"

cat > "$APP/Contents/Resources/README-cht.txt" <<'EOF'
英雄傳奇 II（Trial by Fire）繁體中文化 — EGA（1989 原版，16 色）

本包內容
--------
- patched ScummVM 執行檔（含 Big5 繪字 + ZH_TWN 語言支援的引擎改動；引擎 patch 與《英雄傳奇 I》繁中化共用）
- cht-data-ega/：中文資料（translation.tsv 對白/訊息、qfg1_big5.fnt 字型、qfg1_big5_hi.fnt hi-res 字型、
  view.765 主選單 baked-art、view.800 職業選擇 baked-art）
- 本說明檔

本包【不含】原遊戲資源。請自備合法取得的英雄傳奇 II EGA 版遊戲檔（Trial by Fire, 1989）。

安裝步驟
--------
1. 準備好你自己的 QFG2 EGA 遊戲資料夾（內含 RESOURCE.* 等遊戲資料，檔名請一律小寫）。
2. 把 cht-data-ega/ 資料夾內的所有檔案，複製進上述遊戲資料夾（與 RESOURCE.* 同一層）。
3. 執行本包的 ScummVM 執行檔（見下方「執行方式」）。
4. 在 ScummVM 啟動器按「Add Game...」，選剛才那個遊戲資料夾加入。
5. 加入後在 Game Options 把 Language 設為 Chinese(Taiwan)（或啟動時帶 --language=tw），即可看到繁體中文。

執行方式（macOS）
--------
把 ScummVM.app 拖進「應用程式」，第一次執行前先解除 Gatekeeper 隔離（未簽署 app）：
  xattr -dr com.apple.quarantine /Applications/ScummVM.app
中文資料已預先放進 .app/Contents/Resources/cht-data-ega/，
仍需依「安裝步驟」複製到你自己的遊戲資料夾（.app 本身不含遊戲資源）。
啟動：開啟 ScummVM.app 後在啟動器 Add Game，或終端機：
  ScummVM.app/Contents/MacOS/scummvm --language=tw --path="你的遊戲資料夾路徑" --auto-detect

音效
--------
Roland MT-32 音色已於引擎編入（enable，非停用）。MT-32 ROM 有版權，本包不附；
若要使用 MT-32 音色，請自備 MT32_CONTROL.ROM + MT32_PCM.ROM 放進遊戲資料夾，
再於 ScummVM 音效選項選 Roland MT-32（未放 ROM 則維持 AdLib，不影響正常遊玩）。

交付原則
--------
中文化僅以 ScummVM patch 形式交付（引擎改動 + 中文資料），原遊戲資源不入包、不散布。
repo：https://github.com/wicanr2/quest-for-glory-2-trial-by-fire-ega
EOF

# 重簽:Resources 內容變動後,原本 build 期的 ad-hoc 簽章需要重蓋(--deep 涵蓋巢狀 dylib)
if command -v codesign >/dev/null 2>&1; then
  codesign --force --deep --sign - "$APP" 2>/dev/null || echo "!! codesign 失敗(非 macOS host 執行屬預期,CI runner 上應成功)"
fi

mkdir -p "$OUT"
LABEL="QFG2-CHT-EGA-macos-universal"
tar czf "$OUT/${LABEL}.tar.gz" -C "$(dirname "$APP")" "$(basename "$APP")"
echo ">> -> $OUT/${LABEL}.tar.gz"

if command -v hdiutil >/dev/null 2>&1; then
  hdiutil create -volname "$LABEL" -srcfolder "$APP" -ov -format UDZO "$OUT/${LABEL}.dmg"
  echo ">> -> $OUT/${LABEL}.dmg"
else
  echo ">> (非 macOS host,略過 .dmg——hdiutil 只在 macOS 存在;CI runner 上會產出)"
fi

ls -la "$OUT"

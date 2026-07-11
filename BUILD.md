# 英雄傳奇 II（Trial by Fire）EGA 繁中化 — 開發者 Build 手冊

本檔案是 dev-setup 交付包的核心文件：拿到 `patches/` + `docker/` + `tools/apply_patches.sh` + `dist/` 後，
照本檔步驟即可重建 patched ScummVM 引擎，並用 `dist/` 內的中文資料在你自備的 QFG2 EGA 遊戲資源上跑出中文版。

引擎 patch 與《英雄傳奇 I》繁中化專案共用同一套 SCI0 patch（不綁遊戲），QFG2 沿用零修改。

## 0. 前置準備

1. 取得乾淨的 ScummVM 原始碼（建議與本專案開發時同一版本；`patches/0001-sci-cht-zh_twn.patch` 是對該版本樹的
   diff，版本差太多可能 patch 失敗需手動調整。`patches/UPSTREAM_COMMIT.txt` 記錄 pinned commit）。
2. 套用中文化引擎改動：
   ```bash
   tools/apply_patches.sh <scummvm-src-dir>
   ```
   若 `<scummvm-src-dir>` 不存在會自動 clone 官方 scummvm/scummvm 並 checkout pinned commit。
   這會：複製新檔 `engines/sci/graphics/fontchinese.{h,cpp}`（`GfxFontChinese`：Big5 繪字）、
   對既有檔案套用 `patches/0001-sci-cht-zh_twn.patch`（ZH_TWN 語言 hook、hi-res live 文字、
   kFormat 動態句、GetLongest 斷行修正等，細節見 repo README「技術要點」）。

## 1. Linux（x86_64，native，docker）

```bash
docker build -t qfg2-build -f docker/Dockerfile.build .
docker run --rm -v "$PWD/<scummvm-src>:/src" -w /src qfg2-build bash -c \
  "./configure --disable-all-engines --enable-engine=sci --disable-detection-full && make -j$(nproc)"
```

**[HARD] configure 順序**：`--disable-all-engines` 必須在 `--enable-engine=sci` **之前**，反了 sci 引擎會被關掉。

**必加的 flag**：`--disable-detection-full`（否則會編譯全部引擎的 detection.o 中斷 build）。

**[HARD] MT-32 保持 enable，不要帶 `--disable-mt32emu`**：Roland MT-32 音色遠優於 AdLib，
老 Sierra 遊戲本就內附 `MT32.DRV`。編完用 `grep USE_MT32EMU config.h` 應看到 `#define`。
ROM 有版權，本 repo 與 dev-setup 包都不附，玩家自備 ROM 放進遊戲資料夾、在音效選項選 Roland MT-32 即可。

產出：`<scummvm-src>/scummvm`（ELF x86-64，動態連結一堆系統庫，不可直接發布——若要打包發行版
可用 `pkg_collect_libs.py` 收集依賴組 AppImage）。

## 2. 套用中文資料 + 啟動

```bash
cp dist/translation.tsv dist/qfg1_big5.fnt dist/qfg1_big5_hi.fnt dist/view.765 dist/view.800 <你的QFG2遊戲資料夾>/
<scummvm-src>/scummvm --path=<你的QFG2遊戲資料夾> --language=tw --auto-detect
```

`translation.tsv`／`qfg1_big5.fnt`／`qfg1_big5_hi.fnt` 是寫死的檔名（沿用 qfg-1 命名），引擎在
`getLanguage()==ZH_TWN` 時會從遊戲路徑讀取這幾個檔案。`view.765` 是主選單卷軸的中文 baked-art
（序章／建立英雄／匯入英雄／繼續冒險），`view.800` 是職業選擇畫面的中文職業名 baked-art（戰士／法師／盜賊）。

## 3. 交付原則（硬，不可違反）

- 中文化**僅以 ScummVM patch 形式交付**：patched 引擎 + 中文資料（`translation.tsv` + 兩份字型 + `view.765`）。
- **原遊戲資源（`RESOURCE.*` 等）絕不入包**，使用者自備合法遊戲檔。
- MT-32 ROM 有版權，不隨附；GitHub / dev-setup 包不設 mt32 為預設音效裝置。

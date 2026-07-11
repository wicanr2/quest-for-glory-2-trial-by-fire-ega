# QFG2 EGA 繁中化 — CONTEXT

英雄傳奇 II：Trial by Fire（Quest for Glory II）EGA 版 ScummVM 繁體中文化。

## 引擎軌 / 關鍵事實

| 項目 | 值 |
|---|---|
| 引擎 | **SCI0**（ScummVM `sci` 引擎），game id `sci:qfg2` |
| 遊戲版本 | 1.102（`videoDrv=EGA320.DRV`，純 EGA 單軌） |
| 文字資源 | **只有 `text.*`（178 個），無 `message.*`**（SCI0 特徵，同 qfg-1 EGA 軌） |
| 資源規模 | 178 text / 247 script / 308 view / 88 pic / 4 font |
| 翻譯量 | text **4730 則** + script 內嵌 **1797 則** ≈ 6527 則 |
| 中文啟用 | config `language=tw` 或 CLI `--language=tw`（引擎判 `getLanguage()==ZH_TWN`） |
| 引擎讀取檔名（寫死） | `translation.tsv`、`qfg1_big5.fnt`、`qfg1_big5_hi.fnt`（沿用 qfg-1 檔名，放 game path） |

## 範本複用（qfg-1 = 同軌 SCI0 EGA 成熟專案）

`~/scummvm/qfg-1/workplace` 是 SCI0 EGA + SCI1.1 VGA 完整中文化範本。QFG2 EGA 同為 SCI0：

- **引擎 patch 不綁遊戲 → 直接複用**：`patches/0001-sci-cht-zh_twn.patch` + `fontchinese.{h,cpp}`（pinned upstream `3d408ec`）。含 ZH_TWN 啟用、Big5 繪字、hi-res 640×400 live 文字、kFormat 動態句 hook、GetLongest 日文 kinsoku 誤傷 Big5 修正、空白正規化 key。M1 已驗證：**一行引擎碼都不用改**即讓 QFG2 顯中文。
- **工具鏈全 game-agnostic 複用**：`extract_strings.py`（抽 text.*）、`extract_ega_scripts.py`（抽 script.* 內嵌）、`build_cht.py`（烘 16px Big5 字型 + runtime tsv）、`bake_hires_font.py`（烘 32×28 hi-res 字型）、`sci_view.py`（view/pic 編解碼，baked-art）、`merge_translations.py`。
- **共通句可複用譯文**：QFG 系列共用系統 UI/選單/通用回應句。但**版權框等多則原文與 QFG1 不同**（QFG2 版權文 403 字元 vs QFG1 161 字元）→ 需逐則對 QFG2 原文確認命中。

## 環境

- docker image `qfg1-build`（SCI-only build）、`qfg1-capture`（+Xvfb/imagemagick/xdotool）。
- 字型烘焙：host `/usr/share/fonts/truetype/arphic/uming.ttc` face 2 (TW) + Pillow 10.2。
- headless 截圖：`Xvfb :99` + `import -window root`，遊戲 640×480 視窗（320×200 ×2 upscale）。

## 交付原則（硬）

- 中文化**僅放 ScummVM patch**：引擎 patch + `dist/`（translation.tsv + 字型）+ view/pic patch。原遊戲資源不入庫。
- 完整包（含遊戲 + MT-32 ROM）只在本機 `dist-all/`（gitignore），私人保留。
- MT-32 一律 enable（configure 不帶 `--disable-mt32emu`）。ROM 不入 GitHub。

## GitHub repo

https://github.com/wicanr2/quest-for-glory-2-trial-by-fire-ega.git （patch-only）

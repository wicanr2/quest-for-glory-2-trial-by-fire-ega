# QFG2 EGA 繁中化 — WORKLIST（起於 2026-07-11）

repo：`github.com/wicanr2/quest-for-glory-2-trial-by-fire-ega`（patch-only）。工作目錄 `~/scummvm/qfg2-ega-cht/workplace`。

## 里程碑

| 里程碑 | 狀態 |
|---|---|
| M0 環境盤點 + 可行性 | ✅ SCI0 EGA、`sci:qfg2`、178 text/247 script、翻譯量 ~6527、qfg-1 patch 可複用 |
| **M1 端到端打通** | ✅ **引擎 patch 零修改複用**，QFG2 版權框實機顯中文、hi-res 銳利、斷行/行首字正常（2026-07-11） |
| M2 全文字翻譯（4730 text + 1797 script） | ✅ **覆蓋 98%**(6455/6522)、qog-2 複用 44% + 28 批 sonnet、無非 Big5、實機驗證 |
| M3 主選單 baked-art | ✅ view.765 四選項中文(序章/建立英雄/匯入英雄/繼續冒險)；標題/credits 暫緩 |
| M4 打包 | ✅ **Linux AppImage 可玩**(親自驗證) + patch-only dev-setup + README；MT-32 enable。Windows/macOS/Release 待後續 |

## M1 完成內容（2026-07-11）

1. 解 qfg2.zip → `game/`，ScummVM 偵測 = `sci:qfg2`（QFG2 Trial by Fire DOS/English）。
2. `SCI_DUMP_RES` dump text/script/view/pic 到 `extract/dump/`。
3. `extract_strings.py` 抽 4730 則 text、`extract_ega_scripts.py` 抽 1797 則 script 內嵌 → `translation/skeleton.tsv`。
4. 複製 qfg-1 引擎 patch + 工具鏈 + docker。
5. 翻譯版權框 1 則（`translation/test.tsv`）→ `build_cht.py` 烘 `qfg1_big5.fnt`(79字) + runtime tsv → headless 截圖實機驗證中文（`out/shots/qfg2_v1_40s.png`）。

## M2 執行計畫

1. **建 QFG2 scummvm-src**：clone pinned `3d408ec` → `apply_patches.sh` 套 0001 + fontchinese → docker 編譯，驗證自家 binary 跑 QFG2 中文（脫離 qfg-1 依賴）。
2. **建 translation.tsv 骨架**：`merge_translations.py` 用 QFG1 譯文對 QFG2 skeleton 命中的共通句預填（系統UI/選單/通用回應），其餘留待翻。統計命中率。
3. **批次翻譯**：未命中的 text + script 內嵌，分批 fan-out sonnet subagent（見 kb `workflows/batch-subagent-localization.md`），台式在地化。
4. **kFormat 動態句**：含 `%s/%d` 模板句翻中文模板（子序列對應 + 參數重映射）。
5. **烘完整字型**：`build_cht.py`（16px）+ `bake_hires_font.py`（32×28 hi-res，解決 M1「眾」字退低解析問題）。
6. 覆蓋驗證：混雜態（已譯顯中/未譯顯英）證明渲染路徑；實機截多畫面。

## 待辦 / 已知雷

- M1「眾」字偏粗 = hi-res 字型沿用 QFG1 舊檔未含此字退回 16px；M2 重烘 hi-res 解決。
- QFG2 版權框等多則原文與 QFG1 不同，共通句複用須逐則對 QFG2 原文確認。
- SCI0 EGA 320×200 先天限制，職業選擇等小字偏小（hi-res 字型路徑已緩解）。

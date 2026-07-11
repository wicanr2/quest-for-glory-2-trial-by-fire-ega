# QFG2 EGA 這代的新雷（供回填 CLAUDE.md 模板 v3）

## SCI0 EGA baked-art 重繪（新增，QFG1 未深入的 EGA view 編碼）

1. **用 `sci0_view.py`（SCI0 EGA）非 `sci_view.py`（SCI1.1 VGA）**：view 頭 `80 00` 是 SCI0 EGA 格式，用錯工具 decode 會 cel data 讀到 0 bytes。QFG2 EGA 職業名/選單都走 sci0_view。
2. **[HARD] sci0_view.py rebuild_view 膨脹 bug**：原實作「每個 cel 都重編 append」+ 保留原 buffer dead padding，多 cel replace 會撐爆 16-bit offset 上限（65535）。原 view 9502 → roundtrip 就膨脹到 18464（RLE 重編不如原始緊湊）。**修法：只重編 append 被 replace 的 cel，未替換者保留原 offset 表 entry 不動**（原 9502→改 12 cel→13435 bytes）。
3. **中文 cel 要硬邊二值化**：PIL 畫字有抗鋸齒（灰階邊緣），nearest EGA 量化把邊緣灰映成抖動雜色 → RLE 爆炸（單 cel ~7600 bytes）。改「只用 bg + fg 純色、threshold 二值化」，RLE 大幅縮小。
4. **SCI0 EGA view patch 檔名 = `view.NNN`**（非 SCI1 的 `NNN.v56`），放 game dir。
5. **定位 baked-art view**：`SCI_LOG_GFX=1` 印 `SCI_LOG_GFX view=%d loop=%d cel=%d` 與 `drawPicture pic=%d`；grep 這格式（非 "view "）。走到目標畫面時記錄當前 view/pic id。
6. **9px 高的 cel 塞不下中文**（如 CHOOSE A HERO 121×9），保留英文或跳過。

## headless 擷取（新雷）

7. **[HARD] docker headless 別用 `wait`**：Xvfb 是背景 `&` 進程不會退，`wait` 會永久卡（踩過容器跑 44 分鐘）。用 `timeout` 包 scummvm + 最後 `pkill -f scummvm`，讓 script 自然結束、容器隨之退出。
8. **`SCI_LOG_GFX=1` 可能讓開場截圖全黑**（干擾/拖慢）；純找 view id 時可帶，純截圖驗證時不帶。

## 複用既有 binary 的陷阱

9. **[HARD] 複用他專案已編 binary 前 grep config.h 確認 MT-32**：qfg-1 的 scummvm 實測 `#undef USE_MT32EMU`（configure 帶了 `--disable-mt32emu`），違反 CLAUDE.md ⑤。複用前 `grep USE_MT32EMU config.h`；不符就自建 scummvm-src 重編（apply_patches.sh 已支援自 clone pinned commit）。

## 抽字完整性（延伸 ④-S）

10. **extract_ega_scripts.py 跳過所有含控制碼字串 → 漏抽黏前導 bytecode 的對白**：SCI script 字串常黏著前導 bytecode（如 `Press '?'` 前是 `\xb0\x03`，含控制碼 `\x03` → 被整條跳過）。修法：**剝除前導非文字 byte 取乾淨顯示文字**（從第一個字母/引號起、到下個控制碼止），再嚴格過濾（≥2 英文詞、純 ASCII、排 bytecode 雜訊與 debug 字串）。playtest 進職業選擇畫面才發現「Press '?'…」英文殘留 → 補抽 50 則。
11. **playtest 驅動完整性最有效**：headless 走到實際畫面（角色創建/職業選擇）比靜態抽字更能揪出漏譯——文字補譯 + baked-art 重繪雙管齊下才算該畫面完整。

## 譯文複用（強化）

12. **同劇情的其他版本譯本是最大複用來源**：QFG2 EGA 直接複用 qog-2（同劇情 VGA remake 繁中）達 44%，遠高於前作 QFG1（僅 2%，劇情不同）。**開工先 grep 同劇情譯本命中率**，別只比對前作。

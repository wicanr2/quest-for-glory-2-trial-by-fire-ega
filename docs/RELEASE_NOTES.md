# 英雄傳奇 II：試煉之火 — 繁體中文化 v1.0

《Quest for Glory II: Trial by Fire》(Sierra, 1990) EGA 版的完整繁體中文化，透過 ScummVM 執行。你不需要懂英文，就能走完夏皮爾與拉希爾的整段冒險。

## 中文化內容

- **遊戲文字中文化 98%**：對白、旁白、系統訊息、選單、道具、動態句。
- **選單與角色創建美術中文化**：主選單（序章／建立英雄／匯入英雄／繼續冒險）、職業選擇（戰士／法師／盜賊）。
- **640×400 高解析中文**：Big5 直繪，銳利、斷行與行首字完整。
- **Roland MT-32 音樂支援**（自備 ROM）。

## 下載（皆為 patch 版，不含遊戲資源，需自備《Quest for Glory II》EGA 遊戲檔）

| 平台 | 檔案 | 說明 |
|---|---|---|
| Windows | `QFG2-CHT-EGA-windows-x86_64.zip` | 解壓，執行 `玩英雄傳奇II-繁中.bat`，輸入遊戲資料夾路徑即可 |
| macOS | `QFG2-CHT-EGA-macOS.dmg` / `.tar.gz` | universal（Apple Silicon + Intel）；首次執行見下方 Gatekeeper 說明 |
| Linux / 通用 | `qfg2-cht-dev-setup.tar.gz` | 含引擎 patch + 中文資料 + apply 腳本，自行編譯 ScummVM 後套用 |

## 安裝

1. 準備一份《Quest for Glory II: Trial by Fire》EGA 版遊戲資源。
2. 依平台執行上表對應的啟動器/腳本，指向你的遊戲資料夾。
3. 遊戲即以繁體中文啟動（`--language=tw`）。

## Roland MT-32 音樂（選用）

自備 Roland MT-32 ROM（`MT32_CONTROL.ROM` + `MT32_PCM.ROM`）放進遊戲資料夾，在 ScummVM 音效選項選 Roland MT-32。ROM 有版權，不隨附。

## macOS Gatekeeper

未簽署 app 首次執行需在終端機執行：
```
xattr -dr com.apple.quarantine /Applications/ScummVM.app
```

## 交付原則

本 Release 僅含 ScummVM patch 與中文資料，不含遊戲原始資源。

## 致謝

原作 Lori 與 Corey Cole、Sierra On-Line（1990）；[ScummVM](https://www.scummvm.org/) 團隊；同劇情 VGA 重製版繁中譯本（重要參考）。

---
🤖 中文化工程含 28 批平行機器翻譯 + 逐行品質驗證 + baked-art 美術重繪 + playtest 驅動完整性補強。

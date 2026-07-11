# M3 baked-art 盤點（QFG2 EGA）

遊戲內非 text/script 的英文美術，需重繪成中文（`sci_view.py` view/pic 編解碼）。

## 已識別

| 畫面 | 內容 | 來源判定 | 狀態 |
|---|---|---|---|
| 主選單卷軸 | Introduction / Start New Hero / Import a Hero / Continue Quest（花體字，紅色首字母 I/S/I/C） | **baked-art**（不在 text/script dump） | 待定位 view/pic + 重繪 |
| 序章標題 logo | "Quest for Glory II: Trial by Fire" 大標題 | 待截（intro 中，被 ESC 跳過） | 待截圖 + 定位 |
| credits 職稱 | 製作人員職稱（參 QFG1 view.902） | 待查 | 待查 |
| 角色創建 UI | 屬性/技能標籤（QFG1 EGA 是純 text.204，可能同） | 待查 | 待查 |

## 定位方法

- headless 跑，`SCI_LOG_GFX=1` 印出各畫面 view/pic id。
- 主選單卷軸：進遊戲主選單時記錄當前 pic + view。
- 序章標題：**不送 ESC**，讓 intro 播完到標題定格截圖。
- 參考 QFG1：序章標題 view.909（HERO'S QUEST）、credits view.902、職業名 view.506。QFG2 view 號可能不同（dump 最高 view.998/999）。

## 新專名待收斂（核心批 subagent 自訂音譯，全域收斂時統一）

| 英文 | 暫譯 | 出處 |
|---|---|---|
| Soulforge | 熔魂劍 | Rakeesh 名劍 |
| Suleiman ben Daoud | 蘇萊曼·本·達伍德 | 預言詩 |
| Spielburg | 史匹堡 | QFG1 地名（應與 qfg-1 對齊，查證） |
| Franc / Dinarzad | 法蘭克 / 迪納扎德 | 兌幣商 NPC（貨幣雙關） |
| Jabir bin Ma'amar | 賈比爾·賓·馬阿馬爾 | NPC |
| Issur | 伊蘇爾 | 店主 |
| "Noon of this Night" | 夜之正午 | 特有時間用語（全批沿用） |

> 收斂原則：Spielburg 須對齊 qfg-1 譯名。其餘全域掃描確保單一音譯。

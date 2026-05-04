---
name: notebooklm-connector
description: 公開版 NotebookLM 連接器技能包。讓 Claude Code 與 Codex CLI 透過 MCP 直接對自己的 Google NotebookLM 內容做問答查詢，並可選用 ExportKit 把 NotebookLM 內容匯出回本地、用 nlm CLI 管理 sources。當使用者說「連 NotebookLM」「在 Claude Code 用 NotebookLM」「在 Codex 問 NotebookLM」「裝 notebooklm-connector」「設定 NotebookLM MCP」時觸發。第一次使用先跑安裝腳本，再依 references/mcp-setup.md 把 MCP 設定加到 Claude Code 或 Codex 的設定檔。授權：MIT。
---

# NotebookLM Connector

Claude Code / Codex CLI 與 Google NotebookLM 之間的橋樑。

裝完之後，你可以直接在 Claude Code 或 Codex 對話裡向自己的 NotebookLM 提問，由 LLM 代你查詢、整合、追問。

## 功能定位

只做一件事：**讓你的 LLM Agent 連上自己的 NotebookLM 帳號**。

三層能力，由淺到深：

1. **MCP 對話查詢（核心）**：Claude Code / Codex 透過 MCP 直接問 NotebookLM
2. **匯出回本地（可選）**：用瀏覽器 extension `NotebookLM ExportKit` 把 chats / notes / reports / mindmap / 影片摘要等下載成本地檔案
3. **Sources 批次管理（進階）**：用 `nlm` CLI 列、加、刪 sources

跨平台對照：

| 你想做的事 | 用哪個工具 |
|---|---|
| 在 Claude Code / Codex 裡直接問既有 notebook | `PleasePrompto/notebooklm-mcp`（MCP） |
| 把 NotebookLM 的 chats / notes / reports / 影片下載回本地 | `NotebookLM ExportKit`（Chrome extension） |
| 批次新增、刪除、列 sources | `jacob-bd/notebooklm-mcp-cli`（`nlm` CLI） |

詳細工具比對見 [references/tool-map.md](references/tool-map.md)。

## 快速開始

### 1. 安裝

執行：

```bash
bash scripts/install.sh
```

這支腳本會：

- 偵測你裝的是 Claude Code、Codex CLI，還是兩者都有
- 把 `PleasePrompto/notebooklm-mcp` 加到對應的 MCP 設定（會印指引，不直接覆蓋你的設定檔）
- 偵測 `uv`，若有則安裝或升級 `nlm`（`jacob-bd/notebooklm-mcp-cli`）
- 提示你去裝 `NotebookLM ExportKit` 的瀏覽器 extension（這部分一定要手動，因為涉及 Chrome Web Store 授權）

### 2. 設定 MCP

依你用的工具，照 [references/mcp-setup.md](references/mcp-setup.md) 把 MCP 設定貼進去：

- Claude Code：編輯 `~/.claude/settings.json`
- Codex CLI：編輯 `~/.codex/config.toml`

### 3. 第一次登入 NotebookLM

完整重啟 Codex 或 Claude Code 之後，在新對話裡說：

```text
幫我登入 NotebookLM
```

或英文：

```text
Log me in to NotebookLM
```

會跳出 Chrome 視窗讓你登入 Google 帳號（這是 `PleasePrompto/notebooklm-mcp` 的 Chrome automation 機制；你的帳號密碼**不會**經過任何第三方伺服器，登入 session 存在你本機 Chrome profile 裡）。

### 4. 開始用（中英都可以）

```text
列出我的 NotebookLM 筆記本
```

```text
List my NotebookLM notebooks
```

```text
選擇 notebook「我的研究筆記」並回答：這本 notebook 裡關於 X 主題的重點有哪些？
```

```text
在剛才的 notebook 裡，列出最相關的 5 個 source titles
```

## 安全邊界

- `PleasePrompto/notebooklm-mcp` 與 `jacob-bd/notebooklm-mcp-cli` **不是 Google 官方 API**，是社群維護的橋接工具
- `PleasePrompto/notebooklm-mcp` 使用 Chrome automation
- `jacob-bd/notebooklm-mcp-cli` 使用 internal API + browser cookie 提取
- **適用情境**：個人少量使用、人工監看、先做下載與整理、再做刪改
- **不建議情境**：高頻、大量、無人值守的正式商用流程；此類請改用 NotebookLM 官方授權方案

請自行評估風險，作者與本技能包對任何資料異動或帳號狀態不負責。

## 依賴的第三方工具（皆為開源）

| 工具 | Repo | 授權 |
|---|---|---|
| notebooklm-mcp | https://github.com/PleasePrompto/notebooklm-mcp | 見 repo |
| NotebookLM-ExportKit | https://github.com/kristol07/NotebookLM-ExportKit | 見 repo |
| notebooklm-mcp-cli | https://github.com/jacob-bd/notebooklm-mcp-cli | 見 repo |

本技能包與這三個專案無從屬關係，僅整合安裝流程與使用指引。實際運行邏輯都在這三個工具內。

## 授權

本技能包授權為 MIT，詳見 [LICENSE](LICENSE)。

## 排錯

裝不起來、跑不動、登入失敗，先看 [references/troubleshooting.md](references/troubleshooting.md)。

## 不在範圍

- 不做字幕批次抓取與刪除等個人化工作流（這是另一個獨立用途）
- 不做 NotebookLM 內容的二次分析或結構化整理（請接到你自己的後續流程）
- 不處理 Google 帳號授權邊界（請依 Google 條款使用）

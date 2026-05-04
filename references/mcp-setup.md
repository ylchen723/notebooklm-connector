# MCP 設定指引

`PleasePrompto/notebooklm-mcp` 透過 `npx` 啟動，所以你只需要在你的 LLM 工具設定檔裡告訴它「執行什麼指令啟動這個 MCP server」。

兩種設定路徑，依你用 Codex 還是 Claude Code 而定。

## Codex CLI（推薦：自動加）

### 推薦：用 `codex mcp add` 自動加

這也是 `scripts/install.sh` 預設會幫你跑的指令：

```bash
codex mcp add notebooklm -- npx -y notebooklm-mcp@latest
```

驗證：

```bash
codex mcp list
```

應該看到：

```
notebooklm    npx    -y notebooklm-mcp@latest    ...    enabled
```

### （進階）手動編輯 `~/.codex/config.toml`

只有在你需要更精細控制（例如指定 env 變數、cwd、auth）才用這條：

```toml
[mcp_servers.notebooklm]
command = "npx"
args = ["-y", "notebooklm-mcp@latest"]
```

存檔後重開 Codex CLI（見下方「重啟說明」）。

## Claude Code（手動編輯 settings.json）

### 路徑

`~/.claude/settings.json`

> 註：`~/` 在 macOS / Linux 是你的家目錄。完整路徑通常是 `/Users/你的帳號名/.claude/settings.json`（macOS）或 `/home/你的帳號名/.claude/settings.json`（Linux）。

### 修改前先備份（保險動作）

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.backup
```

### 加進 mcpServers 區塊

如果檔案還沒有 `mcpServers`，整個區塊加進去：

```json
{
  "mcpServers": {
    "notebooklm": {
      "command": "npx",
      "args": ["-y", "notebooklm-mcp@latest"]
    }
  }
}
```

如果已經有其他 MCP server，加在同一個 `mcpServers` 物件裡（注意每個 server 之間用逗號分隔，最後一個不要加逗號）：

```json
{
  "mcpServers": {
    "其他既有的-server": {
      "command": "...",
      "args": ["..."]
    },
    "notebooklm": {
      "command": "npx",
      "args": ["-y", "notebooklm-mcp@latest"]
    }
  }
}
```

⚠️ **JSON 常見坑**：
- 物件最後一個成員後面**不要加逗號**
- 字串用雙引號 `"..."`，不能用單引號
- 改完可以貼到 [jsonlint.com](https://jsonlint.com/) 驗證語法

存檔後重開 Claude Code（見下方「重啟說明」）。

## 重啟說明

「設定好 MCP 設定檔」之後一定要**完整重啟**，不是只重新載入。MCP server 是在啟動時讀的。

### Codex CLI

- 在現有 Codex 對話裡按 `Ctrl+D` 或輸入 `exit` 結束
- 重新跑 `codex` 開新對話

### Claude Code（CLI 版）

- 按 `Ctrl+D` 或輸入 `exit` 結束目前對話
- 重新跑 `claude` 開新對話

### Claude Code（IDE 整合：VS Code、JetBrains 等）

- 整個關掉 IDE 視窗，不只是關閉 Claude Code panel
- 重開 IDE，再開 Claude Code

### Claude Desktop（桌面 app）

- macOS：`Cmd+Q` 完整退出，不只是關視窗（關視窗它還在背景）
- 重開 app

## 第一次登入

設好 MCP 並重啟後，在對話裡輸入：

```text
幫我登入 NotebookLM
```

（英文亦可：`Log me in to NotebookLM`）

會跳出 Chrome 視窗。完成 Google 登入後關閉視窗即可，session 會被本機 Chrome profile 保存。

之後就能：

```text
列出所有 notebook
選擇 notebook「研究筆記」
列出 source 清單
回答：這本 notebook 裡 X 主題的重點是什麼？
```

## 常見問題

### 我電腦上有兩個 Chrome profile，登入跑到錯的那個

`PleasePrompto/notebooklm-mcp` 的 Chrome automation 預設用某個 profile。詳細控制請看該專案 README。簡單做法：先確保 NotebookLM 已在那個 profile 登入過。

### 我用 Brave / Edge / Arc 不是 Chrome

Chrome automation 通常需要 Google Chrome 本體。其他 Chromium 系瀏覽器要看上游 repo 是否支援。

### 想驗證 MCP 真的有連上

- Codex：`codex mcp list`
- Claude Code：在對話裡輸入 `/mcp`

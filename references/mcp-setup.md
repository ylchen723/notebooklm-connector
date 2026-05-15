# MCP 設定指引

`PleasePrompto/notebooklm-mcp` 透過 `npx` 啟動，所以你只需要在你的 LLM 工具設定檔裡告訴它「執行什麼指令啟動這個 MCP server」。

兩種設定路徑，依你用 Codex 還是 Claude Code 而定。

## Codex CLI（推薦：自動加）

### 推薦：用 `codex mcp add` 自動加

這也是 `scripts/install.sh` 預設會幫你跑的指令：

```bash
codex mcp add notebooklm -- npx -y notebooklm-mcp@0.4.2
```

驗證：

```bash
codex mcp list
```

應該看到：

```
notebooklm    npx    -y notebooklm-mcp@0.4.2    ...    enabled
```

### （進階）手動編輯 `~/.codex/config.toml`

只有在你需要更精細控制（例如指定 env 變數、cwd、auth）才用這條：

```toml
[mcp_servers.notebooklm]
command = "npx"
args = ["-y", "notebooklm-mcp@0.4.2"]
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
      "args": ["-y", "notebooklm-mcp@0.4.2"]
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
      "args": ["-y", "notebooklm-mcp@0.4.2"]
    }
  }
}
```

⚠️ **JSON 常見坑**：
- 物件最後一個成員後面**不要加逗號**
- 字串用雙引號 `"..."`，不能用單引號
- 改完可以貼到 [jsonlint.com](https://jsonlint.com/) 驗證語法

存檔後重開 Claude Code（見下方「重啟說明」）。

## Claude Desktop（手動編輯 claude_desktop_config.json）

### 路徑

- **macOS**：`~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**：`%APPDATA%\Claude\claude_desktop_config.json`

### 修改前先備份

```bash
# macOS
cp ~/Library/Application\ Support/Claude/claude_desktop_config.json \
   ~/Library/Application\ Support/Claude/claude_desktop_config.json.backup
```

### 加進 mcpServers 區塊

格式與 Claude Code 的 `settings.json` 相同：

```json
{
  "mcpServers": {
    "notebooklm": {
      "command": "npx",
      "args": ["-y", "notebooklm-mcp@0.4.2"]
    }
  }
}
```

存檔後需要**完整重啟 Claude Desktop**（見下方「重啟說明」）。

⚠️ **JSON 常見坑**：
- 物件最後一個成員後面**不要加逗號**
- 字串用雙引號 `"..."`，不能用單引號
- 改完可以貼到 [jsonlint.com](https://jsonlint.com/) 驗證語法

---

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

## 安全硬化指南

### 版本管理

**為什麼版本固定？**
- 防止 npm supply chain 攻擊（如包被惡意修改或 typosquatting）
- 確保一致的行為和已知的安全狀態

**當前版本：** `notebooklm-mcp@0.4.2`

**升級版本的安全步驟：**
1. 檢查 [PleasePrompto/notebooklm-mcp 的 GitHub releases](https://github.com/PleasePrompto/notebooklm-mcp/releases) 有無安全修補或重要更新
2. 在 `~/.claude/settings.json` 或 `~/.codex/config.toml` 手動更新版本號
3. 重啟工具並驗證功能正常
4. 若有異常，立即改回舊版本

### Chrome 配置保護

`PleasePrompto/notebooklm-mcp` 使用 Chrome automation 來登入 Google NotebookLM，Google 的認證 Cookie 會存儲在你本機的 Chrome 配置中。

**保護建議：**

1. **使用專用 Chrome 配置**
   ```bash
   # 為 NotebookLM 創建獨立的 Chrome 配置，避免混合日常數據
   # Chrome 會在首次登入時自動建立新配置
   ```

2. **限制目錄權限**
   ```bash
   # macOS / Linux
   chmod 700 ~/Library/Application\ Support/Google/Chrome/Profile\ 1
   # 或你使用的 Chrome 配置路徑
   ```

3. **監控會話**
   - 若懷疑認證被洩露，立即改變 Google 帳號密碼
   - 登入 [Google Account Security](https://myaccount.google.com/security) 檢查登入活動

### 速率限制

若使用自動化腳本頻繁調用 NotebookLM，可能觸發 Google 的濫用檢測機制，導致帳號暫時被鎖定。

**建議做法：**
```javascript
// 在查詢之間添加延遲
const MIN_INTERVAL_MS = 2000; // 2 秒最少間隔
```

## 常見問題

### 我電腦上有兩個 Chrome profile，登入跑到錯的那個

`PleasePrompto/notebooklm-mcp` 的 Chrome automation 預設用某個 profile。詳細控制請看該專案 README。簡單做法：先確保 NotebookLM 已在那個 profile 登入過。

### 我用 Brave / Edge / Arc 不是 Chrome

Chrome automation 通常需要 Google Chrome 本體。其他 Chromium 系瀏覽器要看上游 repo 是否支援。

### 想驗證 MCP 真的有連上

- Codex：`codex mcp list`
- Claude Code：在對話裡輸入 `/mcp`

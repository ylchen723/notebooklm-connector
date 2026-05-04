# 排錯指引

## 安裝相關

### `bash scripts/install.sh` 跑不起來

確認你在 `notebooklm-connector/` 根目錄底下執行，且這支腳本有執行權限：

```bash
chmod +x scripts/install.sh
bash scripts/install.sh
```

### 找不到 `codex` 指令

你還沒裝 Codex CLI，或它不在 PATH。先依官方文件裝好：

- https://github.com/openai/codex

不用 Codex 也沒關係，把 MCP 直接加到 Claude Code 設定檔就好。

### 找不到 `claude` 指令

你還沒裝 Claude Code 或它不在 PATH：

- https://docs.anthropic.com/claude-code

### 找不到 `uv`

`uv` 是裝 `nlm` 用的。沒裝 `uv` 不影響 MCP 對話查詢功能，只是裝不了 `nlm` CLI。

裝 `uv`：

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

或看 https://docs.astral.sh/uv/

### `uv tool install notebooklm-mcp-cli` 失敗

通常是 Python 版本問題或網路問題。先確認 `uv --version` 能跑、`uv python list` 看有沒有可用 Python（建議 3.10+）。

## 登入相關

### 跳出的 Chrome 視窗無法登入 / 一直跳轉

可能是 Google 阻擋自動化登入。試這幾個：

1. 在「正常」開的 Chrome 裡先登入過 NotebookLM 一次
2. 確認沒開兩階段驗證導致登入卡關
3. 重試 `Log me in to NotebookLM`

### 登入後呼叫 MCP 還是回「沒登入」

關掉所有 Chrome 視窗，確保 `notebooklm-mcp` 的 Chrome automation 啟動的是新 session。也可以試試重啟 Claude Code / Codex。

### Cookie 過期

`nlm` 與 `notebooklm-mcp` 的 session 都有時效。過陣子要重登入是正常的。

## MCP 連線相關

### 跑完 install.sh 但 Codex / Claude Code 還是看不到 notebooklm

最常見原因：**沒有完整重啟**。MCP server 在啟動時讀，舊 session 不會自動載新增的 server。

- Codex CLI：`Ctrl+D` 結束目前對話 → 重新跑 `codex`
- Claude Code CLI：`Ctrl+D` 結束 → 重新跑 `claude`
- IDE 整合：整個關 IDE 視窗再開（不只是關 Claude Code panel）
- Claude Desktop：`Cmd+Q` 完整退出（關視窗不算）→ 重開

驗證：
- Codex：`codex mcp list`，應看到 `notebooklm` enabled
- Claude Code：對話裡輸入 `/mcp`，應看到 `notebooklm`

如果重啟後還是沒看到：
- Codex 用戶：跑 `codex mcp list` 看清單裡到底有沒有，沒有的話手動跑 `codex mcp add notebooklm -- npx -y notebooklm-mcp@latest`
- Claude Code 用戶：檢查 `~/.claude/settings.json` 真的有寫進去且 JSON 語法正確（貼到 [jsonlint.com](https://jsonlint.com/) 驗證）

### `mcp list` 看得到 notebooklm 但呼叫沒反應

通常是 `npx` 第一次拉 package 慢。手動試：

```bash
npx -y notebooklm-mcp@latest --help
```

第一次會下載很多依賴，有耐心等。下次就快了。

### Claude Code `/mcp` 看不到 notebooklm

確認 `~/.claude/settings.json` 是合法 JSON（沒有多逗號、沒漏括號），存完檔後**完整關掉再開** Claude Code，不只是 reload。

### 跑 `notebooklm-mcp` 時 Chrome 跳出 sandbox 警告

新版 macOS 對 automation 比較嚴格。給 Chrome 完整磁碟權限：

系統設定 → 隱私權與安全性 → 完整取硬碟存取權 → 加入 Google Chrome。

## `nlm` CLI 相關

### `nlm` 不在 PATH

裝完 `uv tool install notebooklm-mcp-cli` 後，查路徑：

```bash
uv tool list
which nlm
```

把它加到 PATH，或在 `.env` 用絕對路徑指定 `NLM_BIN`。

### `nlm notebook list` 卡住或回空

先重試一次。如果還是空的，去瀏覽器確認 NotebookLM 帳號真的有 notebook，且 cookie 沒過期。

## ExportKit 相關

### Chrome extension 安裝失敗

ExportKit 不在 Chrome Web Store 主流通路，可能要從 GitHub release 載 unpacked extension 手動掛。詳見：

- https://github.com/kristol07/NotebookLM-ExportKit

### ExportKit 匯出格式有限

部分進階格式（高解析影片、完整簡報）需要 NotebookLM 付費方案。這跟本技能包無關，是 NotebookLM 帳號等級問題。

## 還是不行？

去三個上游 repo 開 issue，問題大多在它們那邊：

- https://github.com/PleasePrompto/notebooklm-mcp/issues
- https://github.com/kristol07/NotebookLM-ExportKit/issues
- https://github.com/jacob-bd/notebooklm-mcp-cli/issues

本技能包是整合 wrapper，三個工具的 bug 都得回上游解。

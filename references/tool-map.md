# Tool Map — 三個第三方工具的分工

`notebooklm-connector` 整合三個獨立開源專案，各自負責不同層次的 NotebookLM 操作。

## 1. PleasePrompto/notebooklm-mcp（核心：MCP 對話查詢）

- Repo：https://github.com/PleasePrompto/notebooklm-mcp
- 定位：讓 Claude Code / Codex 透過 MCP 直接問 NotebookLM
- 適合：在聊天中查既有 notebook、追問

### Codex 安裝

```bash
codex mcp add notebooklm -- npx -y notebooklm-mcp@0.4.2
```

### Claude Code 安裝

編輯 `~/.claude/settings.json`，在 `mcpServers` 區塊加：

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

### 主要能力

- `list_notebooks`
- `select_notebook`
- `get_notebook`
- `ask_question`
- `add_notebook`
- `update_notebook`

### 限制

- 主要是查詢與 notebook library 管理，不是 source 細部管理器
- 依賴 Chrome automation（會打開實體 Chrome 視窗）
- 非官方 API，作者表明僅供個人 / 實驗用途

## 2. NotebookLM ExportKit（瀏覽器匯出）

- Repo：https://github.com/kristol07/NotebookLM-ExportKit
- 官網：https://notebooklmexportkit.linknows.fun/
- 定位：把 NotebookLM 內容下載回本地（瀏覽器 extension）

### 可下載內容

- chats、quizzes、flashcards、mindmaps
- notes、reports、source details、data tables
- slide decks、infographics、video overviews

### 常見輸出格式

Markdown / PDF / HTML / JSON / CSV / PPTX / MP4 / JSONCanvas / ZIP bundle

### 限制

- 主要是瀏覽器手動或半手動操作
- 部分進階格式可能需要登入或付費方案

### 適合情境

- 把 NotebookLM 內容下載回本地保存
- 把資訊圖表、簡報、影片拉回本地工作流程

## 3. jacob-bd/notebooklm-mcp-cli（`nlm` CLI：Sources 批次管理）

- Repo：https://github.com/jacob-bd/notebooklm-mcp-cli
- 定位：CLI + MCP 一體包，適合 source 管理、批次新增刪除、下載 artifacts

### 安裝

```bash
uv tool install "notebooklm-mcp-cli==0.1.0"
```

### 常用命令

```bash
nlm notebook list
nlm source list <notebook>
nlm source add <notebook> --file /absolute/path/to/file.md --wait
nlm source add <notebook> --url "https://example.com" --wait
nlm source delete <source-id> --confirm
nlm batch add-source --url "https://..." --notebooks "id1,id2"
nlm batch delete --notebooks "id1,id2" --confirm
nlm infographic create <notebook> --orientation landscape --style professional --confirm
nlm download infographic <notebook> <artifact-id> --output infographic.png
nlm download slide-deck <notebook> <artifact-id> --output slides.pdf
nlm download video <notebook> <artifact-id> --output video.mp4
```

### 限制

- 使用 internal APIs
- 需要 cookie extraction
- README 明講 *Use at your own risk for personal/experimental purposes*

### 適合情境

- 把本地資料夾分批補進 notebook
- 刪掉某個月份以前的 sources
- 列出 sources 再決定刪哪些
- 已生成 artifact，想用 CLI 下載回本地

## 推薦組合

### 最小可行

- `PleasePrompto/notebooklm-mcp`
- `NotebookLM ExportKit`

用途：Codex / Claude Code 直接問 notebook + 把內容下載回本地。

### 完整版

加上 `jacob-bd/notebooklm-mcp-cli`，多了 source 批次管理能力。

## 對照速查

| 需求 | 用什麼 |
|---|---|
| 把 notebook 內容載回本地 | NotebookLM ExportKit（優先）/ `nlm download`（備選） |
| 補上傳本地檔案到 notebook | `nlm source add` |
| 刪掉舊的 sources | 先 `nlm source list` 確認，再 `nlm source delete` |
| 在 Claude Code / Codex 問 notebook | PleasePrompto/notebooklm-mcp |

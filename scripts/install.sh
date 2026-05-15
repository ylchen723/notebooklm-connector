#!/usr/bin/env bash
set -euo pipefail

echo "== notebooklm-connector installer =="
echo

HAS_CODEX=0
HAS_CLAUDE=0
HAS_UV=0

if command -v codex >/dev/null 2>&1; then
  HAS_CODEX=1
  echo "[detected] codex CLI"
fi
if command -v claude >/dev/null 2>&1; then
  HAS_CLAUDE=1
  echo "[detected] claude (Claude Code) CLI"
fi
if command -v uv >/dev/null 2>&1; then
  HAS_UV=1
  echo "[detected] uv"
fi

if [ "$HAS_CODEX" -eq 0 ] && [ "$HAS_CLAUDE" -eq 0 ]; then
  echo
  echo "找不到 codex 或 claude 指令。請先安裝 Claude Code 或 Codex CLI 其中一個。"
  echo "  - Claude Code: https://docs.anthropic.com/claude-code"
  echo "  - Codex CLI:   https://github.com/openai/codex"
  exit 1
fi

echo
echo "============================================================"
echo "[1/3] 設定 PleasePrompto/notebooklm-mcp"
echo "============================================================"

if [ "$HAS_CODEX" -eq 1 ]; then
  echo
  echo ">> 嘗試把 MCP 加到 Codex（會跑 codex mcp add）"
  echo "   執行: codex mcp add notebooklm -- npx -y notebooklm-mcp@0.4.2"
  echo "   ⚠️  第一次跑會去 npm 拉 notebooklm-mcp package（30 秒到 2 分鐘，看網速）"
  echo "       看起來像當機其實沒有，請耐心等。下次就快了。"
  echo "   ℹ️  版本已固定為 0.4.2（安全考量），若要升級版本請參考 references/mcp-setup.md"
  codex mcp add notebooklm -- npx -y notebooklm-mcp@0.4.2 || {
    echo "   codex mcp add 失敗（可能已存在或設定衝突），請改手動編輯 ~/.codex/config.toml"
  }
fi

if [ "$HAS_CLAUDE" -eq 1 ]; then
  echo
  echo ">> Claude Code 請手動編輯 ~/.claude/settings.json"
  echo "   在 mcpServers 區塊加入："
  cat <<'EOF'
   {
     "mcpServers": {
       "notebooklm": {
         "command": "npx",
         "args": ["-y", "notebooklm-mcp@0.4.2"]
       }
     }
   }
EOF
  echo
  echo ">> Claude Desktop 請手動編輯："
  echo "   macOS: ~/Library/Application Support/Claude/claude_desktop_config.json"
  echo "   Windows: %APPDATA%\\Claude\\claude_desktop_config.json"
  echo "   在 mcpServers 區塊加入相同 JSON 片段（同上）"
  echo
  echo "   完整指引請看 references/mcp-setup.md"
fi

echo
echo "============================================================"
echo "[2/3] 可選：安裝 jacob-bd/notebooklm-mcp-cli（提供 nlm 指令）"
echo "============================================================"

NOTEBOOKLM_MCP_CLI_VERSION="0.6.9"

if [ "$HAS_UV" -eq 1 ]; then
  if uv tool list 2>/dev/null | grep -q "notebooklm-mcp-cli"; then
    echo "已安裝 notebooklm-mcp-cli，升級至 ${NOTEBOOKLM_MCP_CLI_VERSION}。"
    echo "   ℹ️  版本已固定為 ${NOTEBOOKLM_MCP_CLI_VERSION}（安全考量，此工具可直接存取 Chrome Cookie）"
    uv tool install --force "notebooklm-mcp-cli==${NOTEBOOKLM_MCP_CLI_VERSION}" || true
  else
    echo "未安裝 notebooklm-mcp-cli，安裝版本 ${NOTEBOOKLM_MCP_CLI_VERSION}。"
    uv tool install "notebooklm-mcp-cli==${NOTEBOOKLM_MCP_CLI_VERSION}" || true
  fi
  echo
  echo "安裝完成後，可用 'which nlm' 查路徑。"
else
  echo "未找到 uv，略過 nlm 自動安裝。"
  echo "若要使用 nlm CLI 做 source 批次管理，請先安裝 uv："
  echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
  echo "再執行："
  echo "  uv tool install notebooklm-mcp-cli"
fi

echo
echo "============================================================"
echo "[3/3] NotebookLM ExportKit（瀏覽器 extension）"
echo "============================================================"
echo "若需要把 NotebookLM 內容匯出回本地，自行安裝："
echo "  GitHub:  https://github.com/kristol07/NotebookLM-ExportKit"
echo "  Website: https://notebooklmexportkit.linknows.fun/"
echo

echo "============================================================"
echo "下一步"
echo "============================================================"
echo "1. Codex 用戶：上面已自動寫進設定，跑 'codex mcp list' 確認"
echo "   Claude Code 用戶：依 references/mcp-setup.md 把 JSON 片段貼進"
echo "   ~/.claude/settings.json"
echo
echo "2. 完整重啟 Codex 或 Claude Code（很重要，舊 session 不會載新 MCP）"
echo "   - Codex / Claude Code CLI：Ctrl+D 結束後重開"
echo "   - IDE 整合：整個關 IDE 再開"
echo "   - Claude Desktop：Cmd+Q 完整退出再開"
echo
echo "3. 在新對話裡說：幫我登入 NotebookLM（或英文 Log me in to NotebookLM）"
echo "4. 完成 Google 登入後跑：列出我的 NotebookLM 筆記本"
echo
echo "驗證指令："
echo "   - Codex:        codex mcp list"
echo "   - Claude Code:  在對話裡輸入 /mcp"
echo
echo "排錯：references/troubleshooting.md"
echo
echo "完成。"

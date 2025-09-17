# Codex Agent Setup

This directory mirrors `amazonq/` for a vendor‑neutral, OpenAI/Codex‑style agent. It contains rules, prompts, and example configs that work alongside the root `mcp.json`.

## Contents
- `agents/default.json` — baseline agent config (resources, prompts, tool policy).
- `rules/` — modular behavior rules applied to all sessions.
- `prompts/system.md` — concise system prompt for the agent.
- `cli-agents/agent_config.json.example` — example CLI config to adapt.

## Usage
- MCP: point your CLI/agent to the repo‑root `mcp.json` for servers. Most tools live under namespaces like `utilities`, `git_docs`, `aws-api`, `project-memory`.
- Resources: ensure your agent loads `codex/rules/**/*.md` and project docs (e.g., `README.md`, `AGENTS.md`).
- Prompt: copy `prompts/system.md` into your agent’s system prompt, or set `agents/default.json.prompt`.

## Suggested Wiring
1) Symlink rules to your agent’s resources folder (or load via file URIs):
   - `codex/rules/**/*.md`
2) Configure MCP servers via `mcp.json` (no duplication needed).
3) Start sessions in tmux with your usual workflow (see `bin/dev` and `tmux-workflows.sh`).

Notes
- Keep secrets out of the repo; use environment variables and `.zshrc.secrets`.
- Update `allowedTools` over time to match your trust/approval model.
- When keymaps/workflows change, update `README.md`, `KEYMAPS.md`, and relevant rules.


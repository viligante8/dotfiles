# Repository Guidelines

## Project Structure & Module Organization
- `zshrc`, `tmux.conf`, `tmux-workflows.sh`: Shell and tmux configuration.
- `nvim/`: Neovim config — `init.lua`, `lua/config/*.lua` (options, keymaps, autocmds), `lua/plugins/*.lua` (one plugin per file).
- `bin/`: Utilities (`dev`, `commit-msg`, `memory-cleanup`, `metamcp`).
- `amazonq/`, `mcp.json`: Amazon Q/MCP configuration and rules.
- `project-dirs.conf`: Project roots for the tmux picker.
- `README.md`, `KEYMAPS.md`: User docs and keymaps reference.

## Build, Test, and Development Commands
- Link configs: `ln -sf $(pwd)/zshrc ~/.zshrc && ln -sf $(pwd)/nvim ~/.config/nvim`.
- Reload shell/tmux: `source ~/.zshrc`, `tmux source-file tmux.conf` (or press prefix then `r`).
- Neovim: `nvim +"Lazy sync" +qa` then `nvim +"checkhealth"` to verify.
- Dev sessions: `bin/dev` for project picker; direct: `./tmux-workflows.sh <session> <path>`.
- Tools: `bin/metamcp` (start metamcp dev tmux), `bin/memory-cleanup weekly --dry-run` (analyze Q memory).

## Coding Style & Naming Conventions
- Shell (bash): Shebang `#!/bin/bash`; prefer `set -e`; 4‑space indent; descriptive function names; quote variables; use `$HOME`/`$DOTFILES_DIR` over absolute paths.
- Lua: Match existing style — plugin specs in `nvim/lua/plugins` use tabs; files in `nvim/lua/config` use 2‑space indent. Keep modules focused; one plugin per file returning a spec table.
- Tmux/Zsh: Use clear section headers/comments; keep lines ≤120 chars. JSON: 2‑space indent, no trailing commas.

## Testing Guidelines
- Zsh: `zsh -i -c 'true'` should emit no errors; open a new shell to confirm prompt and performance.
- Tmux: `tmux source-file tmux.conf` to reload; validate prefix (currently `M-space`) and shortcuts in `KEYMAPS.md` stay consistent after changes.
- Neovim: `nvim --headless '+Lazy! sync' '+qa'` and `nvim --headless '+checkhealth' '+qa'` should pass.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g., `feat: …`, `fix: …`, `docs: …`). Helper: stage changes then run `bin/commit-msg` or alias `gcm` to draft a message.
- PRs: include a concise summary, affected areas (zsh/tmux/nvim/bin), validation steps (reload commands), and screenshots where UI changes apply. Update `README.md`/`KEYMAPS.md` when keymaps or workflows change.

## Security & Configuration Tips
- Never commit secrets; keep them in `.zshrc.secrets` (gitignored). Prefer environment variables and relative paths. If you change Amazon Q/MCP rules, ensure `amazonq/rules/README.md` remains accurate.


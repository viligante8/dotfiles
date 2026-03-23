# Tmux Reference (Current Dotfiles Config)

Source of truth for this document:
- `tmux.conf`
- `bin/dev`
- `bin/dev-worktree`
- `bin/tmux-feature-drawer`
- `bin/lib/tmux-session-lib.sh`

## Prefix and Core Behavior

- Prefix is `M-space` (Alt/Option + Space).
- `C-b` is unbound.
- Press `M-space` then `M-space` to send a literal prefix (useful for nested tmux).
- Mouse support is enabled.
- Windows and panes start at index `1`.
- New panes/windows created by custom bindings start in `#{pane_current_path}`.

## Custom Key Bindings (Prefix: `M-space`)

### Core
- `M-space r` - Reload `~/.tmux.conf` and show a confirmation message.
- `M-space c` - Create a new window in current pane path.
- `M-space |` - Split horizontally in current pane path.
- `M-space -` - Split vertically in current pane path.

### Pane Navigation and Resize
- `M-space h/j/k/l` - Select pane left/down/up/right.
- `M-space H/J/K/L` - Resize pane left/down/up/right by 5 cells (repeatable).

### Workflow Shortcuts
- `M-space W` - Start/switch `dev` for `#{pane_current_path}`.
- `M-space B` - Pick/type branch and create or switch repo worktree (`bin/dev-worktree`).
- `M-space V` - Open/switch to `editor` window; if missing, create it using configured editor command.
- `M-space Q` - Open/switch to `ai` window; if missing, create it using configured AI command.
- `M-space G` - Open/switch to `git` window; if missing, create it using configured Git UI command.
- `M-space D` - Build a 3-pane dev layout: open `nvim` in pane 1, clear panes 2 and 3.

## Custom Key Bindings (No Prefix)

- `Alt-Left/Right/Up/Down` - Pane navigation.
- `Alt-1` through `Alt-9` - Jump to window 1..9.
- `Alt-q` - Previous session.
- `Alt-e` - Next session.
- `Alt-w` - Session chooser.
- `Alt-Shift-h` - Previous window.
- `Alt-Shift-l` - Next window.
- `Alt-h` - Previous window.

## Shell Commands

`zshrc` adds `$DOTFILES_DIR/bin` to `PATH`, so these commands are available in shell:

- `dev [path]` - Create/attach a dev session (`dev-<dirname>`) using feature-driven windows.
- `dev-worktree [path]` - Branch picker for current repo; creates/switches centralized worktrees.

## Session Layout

### `dev`
Creates or attaches `dev-<dirname>` with feature-driven windows:
1. `editor` (configured editor command; default `nvim`)
2. `terminal` (`clear`)
3. `ai` (configured command; default `opencode`)
4. `git` (configured command; default `lazygit`)

Notes:
- Windows are controlled by feature config in `dotfiles.config.json`.
- Features with `includeInDevSession: false` (for example `database`) are excluded.
- If a session already exists, missing configured windows are added automatically.

### `dev-worktree`
- Intended for use from inside a repo (or with an explicit path argument).
- Opens a branch picker; typed input creates a new branch from current `HEAD`.
- Stores worktrees under `~/dev/worktrees/<repo>/<sanitized-branch>`.
- Branch names with `/` are sanitized for directory/session names (for example, `feature/foo` -> `feature-foo`).
- Reuses existing worktree paths when a branch is already checked out.
- Launches/attaches using the same feature-driven layout logic as `dev`.

## Plugins (TPM)

Configured plugins in `tmux.conf`:
- `tmux-plugins/tpm`
- `tmux-plugins/tmux-sensible`
- `tmux-plugins/tmux-yank`
- `tmux-plugins/tmux-resurrect`
- `tmux-plugins/tmux-continuum`

TPM commands (use tmux prefix, now `M-space`):
- `M-space I` - Install plugins.
- `M-space U` - Update plugins.
- `M-space Alt-u` - Remove unused plugins.

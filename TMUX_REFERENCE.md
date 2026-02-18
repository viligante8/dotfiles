# Tmux Reference (Current Dotfiles Config)

Source of truth for this document:
- `tmux.conf`
- `tmux-workflows.sh`
- `zshrc` (sources `tmux-workflows.sh`)
- `bin/dev`

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
- `M-space W` - Open project picker popup (`bin/dev`).
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

## Useful tmux Defaults Still Active (Now Using `M-space` Prefix)

- `M-space d` - Detach session.
- `M-space s` - List sessions.
- `M-space $` - Rename session.
- `M-space ,` - Rename window.
- `M-space n` / `M-space p` - Next/previous window.
- `M-space 1..9` - Select window by number.
- `M-space x` - Kill pane.
- `M-space z` - Toggle pane zoom.
- `M-space [` - Enter copy mode.
- `M-space ]` - Paste copied text.

Notes:
- Default split bindings `"` and `%` are unbound intentionally.
- `M-space ?` is tmux's default key list/help screen.

## Copy Mode

- Copy mode uses vi keys (`mode-keys vi`).
In copy mode:
- `v` - Begin selection.
- `y` - Copy selection to macOS clipboard via `pbcopy`, then exit copy mode.
- `r` - Toggle rectangle selection.

## Shell Commands and Functions

`zshrc` adds `$DOTFILES_DIR/bin` to `PATH` and sources `tmux-workflows.sh`, so these are available in shell:

- `dev` - Interactive tmux project picker (from `bin/dev`).
- `dev-worktree [path]` - Branch picker for current repo; creates/switches centralized worktrees.
- `dev-session` - Create/attach a generic session for current directory (`dev-<dirname>`).
- `dev-layout` - Create the same 3-pane layout as `M-space D`.
- `tmux-list` - List active sessions.
- `tmux-attach [session]` - Attach to most recent session or a named one.
- `tmux-clean` - Kill all tmux sessions.
- `tmux-help` - Print helper text.

Internal wrapper:
- `tmux-dev-session <session_name> <project_path>` - Used by `bin/dev`/keybinding flow.

## Session Layouts

### `dev` picker flow (`bin/dev` -> `tmux-dev-session`)
Creates or attaches a named project session with 5 windows:
1. `editor` (configured editor command; default `nvim`)
2. `terminal`
3. `ai` (configured command; default `opencode`)
4. `git` (configured command; default `lazygit`)
5. `dbdev` (configured command; default `dbdev`, no Enter)

### `dev-session`
Creates or attaches `dev-<dirname>` with 4 windows:
1. `editor` (configured editor command; default `nvim`)
2. `terminal` (`clear`)
3. `ai` (configured command; default `opencode`)
4. `git` (configured command; default `lazygit`)

## Project Picker (`dev`) Notes

- Reads roots from `dotfiles.config.json` (with optional `dotfiles.local.json` overrides).
- Scans subdirectories as projects.
- Existing tmux sessions are shown first.
- If selected project is a git repo with multiple non-bare worktrees, prompts for worktree.
- Session names are sanitized to alphanumeric with dashes.

## Branch Worktree Picker (`dev-worktree`) Notes

- Intended for use from inside a repo (or with an explicit path argument).
- Opens a branch picker; typed input creates a new branch from current `HEAD`.
- Stores worktrees under `~/dev/worktrees/<repo>/<sanitized-branch>`.
- Branch names with `/` are sanitized for directory/session names (for example, `feature/foo` -> `feature-foo`).
- Reuses existing worktree paths when a branch is already checked out.

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

## Known Mismatches in Other Docs

- Some older docs still mention `Ctrl-a`; actual prefix is `M-space`.
- `tmux.conf` includes `@tmux-which-key-*` options, but no `tmux-which-key` plugin is currently declared.

#!/usr/bin/env bash

# Compatibility shim.
# Tmux workflow commands now live as standalone executables in bin/.

resolve_dotfiles_dir() {
    if [ -n "${DOTFILES_DIR:-}" ] && [ -d "$DOTFILES_DIR" ]; then
        echo "$DOTFILES_DIR"
        return
    fi

    if [ -L "$HOME/.tmux.conf" ]; then
        local link_target
        link_target="$(readlink "$HOME/.tmux.conf" 2>/dev/null || true)"

        if [ -n "$link_target" ]; then
            if [ "${link_target#/}" = "$link_target" ]; then
                link_target="$HOME/$link_target"
            fi
            echo "$(cd "$(dirname "$link_target")" && pwd)"
            return
        fi
    fi

    echo "$HOME/.dotfiles"
}

DOTFILES_ROOT="$(resolve_dotfiles_dir)"
BIN_DIR="$DOTFILES_ROOT/bin"

run_tmux_workflow_command() {
    local command_name="$1"
    shift

    if [ -x "$BIN_DIR/$command_name" ]; then
        "$BIN_DIR/$command_name" "$@"
        return
    fi

    if command -v "$command_name" >/dev/null 2>&1; then
        command "$command_name" "$@"
        return
    fi

    echo "Error: command '$command_name' not found." >&2
    return 1
}

tmux-dev-session() {
    run_tmux_workflow_command "tmux-dev-session" "$@"
}

dev-session() {
    run_tmux_workflow_command "dev-session" "$@"
}

dev-layout() {
    run_tmux_workflow_command "dev-layout" "$@"
}

tmux-clean() {
    run_tmux_workflow_command "tmux-clean" "$@"
}

tmux-list() {
    run_tmux_workflow_command "tmux-list" "$@"
}

tmux-attach() {
    run_tmux_workflow_command "tmux-attach" "$@"
}

tmux-help() {
    run_tmux_workflow_command "tmux-help" "$@"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    if [ $# -ge 2 ] && [ -x "$BIN_DIR/tmux-dev-session" ]; then
        exec "$BIN_DIR/tmux-dev-session" "$@"
    fi

    cat <<'EOF'
tmux-workflows.sh is now a compatibility shim.

Use these standalone commands from bin/ instead:
  dev
  dev-worktree [path]
  dev-session [path]
  tmux-dev-session <session_name> <project_path> [picker|dev]
  dev-layout
  tmux-list
  tmux-attach [session]
  tmux-clean
  tmux-help
EOF
fi

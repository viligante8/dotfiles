#!/bin/bash

# Tmux Workflow Helper Script for Development Projects
# Usage: source this in your .zshrc or run directly

resolve_config_tool() {
    if command -v dotfiles-config >/dev/null 2>&1; then
        command -v dotfiles-config
        return
    fi

    local script_path="${BASH_SOURCE[0]:-}"
    if [ -n "$script_path" ]; then
        local script_dir
        script_dir="$(cd "$(dirname "$script_path")" && pwd)"
        echo "$script_dir/bin/dotfiles-config"
        return
    fi

    if [ -n "${DOTFILES_DIR:-}" ]; then
        echo "$DOTFILES_DIR/bin/dotfiles-config"
        return
    fi

    echo "$HOME/.dotfiles/bin/dotfiles-config"
}

CONFIG_TOOL="$(resolve_config_tool)"

if [ ! -x "$CONFIG_TOOL" ]; then
    echo "Error: dotfiles-config helper not found at $CONFIG_TOOL" >&2
    return 1 2>/dev/null || exit 1
fi

config_get() {
    "$CONFIG_TOOL" "$@"
}

feature_enabled() {
    [ "$(config_get feature-enabled "$1" 2>/dev/null || echo false)" = "true" ]
}

feature_window() {
    config_get feature-window "$1"
}

feature_command() {
    config_get feature-command "$1"
}

feature_send_enter() {
    config_get feature-send-enter "$1"
}

feature_in_dev_session() {
    [ "$(config_get feature-in-dev-session "$1" 2>/dev/null || echo true)" = "true" ]
}

append_feature_window() {
    local feature_name="$1"
    local mode="$2"

    if ! feature_enabled "$feature_name"; then
        return
    fi

    if [ "$mode" = "dev" ] && ! feature_in_dev_session "$feature_name"; then
        return
    fi

    window_names+=("$(feature_window "$feature_name")")
    window_commands+=("$(feature_command "$feature_name")")
    window_send_enter+=("$(feature_send_enter "$feature_name")")
}

build_window_plan() {
    local mode="$1"

    window_names=()
    window_commands=()
    window_send_enter=()

    append_feature_window "editor" "$mode"

    window_names+=("terminal")
    if [ "$mode" = "dev" ]; then
        window_commands+=("clear")
        window_send_enter+=("true")
    else
        window_commands+=("")
        window_send_enter+=("true")
    fi

    append_feature_window "ai" "$mode"
    append_feature_window "gitUi" "$mode"
    append_feature_window "database" "$mode"
}

create_tmux_session_layout() {
    local session_name="$1"
    local project_path="$2"
    local mode="$3"

    build_window_plan "$mode"

    if [ ${#window_names[@]} -eq 0 ]; then
        echo "Error: no windows configured for tmux session" >&2
        return 1
    fi

    tmux new-session -d -s "$session_name" -c "$project_path"

    local i
    for ((i = 0; i < ${#window_names[@]}; i++)); do
        local target_window="$session_name:$((i + 1))"
        local window_name="${window_names[$i]}"
        local command_to_run="${window_commands[$i]}"
        local send_enter="${window_send_enter[$i]}"

        if [ "$i" -eq 0 ]; then
            tmux rename-window -t "$target_window" "$window_name"
        else
            tmux new-window -t "$target_window" -n "$window_name" -c "$project_path"
        fi

        if [ -n "$command_to_run" ]; then
            if [ "$send_enter" = "true" ]; then
                tmux send-keys -t "$target_window" "$command_to_run" Enter
            else
                tmux send-keys -t "$target_window" "$command_to_run"
            fi
        fi
    done

    tmux select-window -t "$session_name:1"
}

# Tmux-compatible wrapper function for keybindings
tmux-dev-session() {
    local session_name="$1"
    local project_path="$2"
    
    # Check if session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        # If we're already in tmux, switch client; otherwise attach
        if [ -n "$TMUX" ]; then
            tmux switch-client -t "$session_name"
        else
            tmux attach-session -t "$session_name"
        fi
        return
    fi
    
    create_tmux_session_layout "$session_name" "$project_path" "picker"
    
    # If we're already in tmux, switch client; otherwise attach
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

# Handle command line arguments for tmux keybindings
if [ $# -eq 2 ]; then
    tmux-dev-session "$1" "$2"
    exit 0
fi

# Generic development session (can be used in any directory)
dev-session() {
    local current_dir=$(pwd)
    local dir_name=$(basename "$current_dir")
    local session_name="dev-${dir_name}"
    
    # Check if session already exists
    if tmux has-session -t $session_name 2>/dev/null; then
        echo "Session '$session_name' already exists. Attaching..."
        tmux attach-session -t $session_name
        return
    fi
    
    echo "Creating development session for $dir_name..."
    
    create_tmux_session_layout "$session_name" "$current_dir" "dev"
    tmux attach-session -t "$session_name"
}

# Function to create a quick 3-pane layout
dev-layout() {
    # Split current window into 3 panes
    tmux split-window -h -c "#{pane_current_path}"
    tmux split-window -v -c "#{pane_current_path}"
    
    # Select the first pane and open nvim
    tmux select-pane -t 0
    tmux send-keys 'nvim' Enter
    
    # Clear the other panes
    tmux select-pane -t 1
    tmux send-keys 'clear' Enter
    tmux select-pane -t 2
    tmux send-keys 'clear' Enter
    
    # Go back to editor pane
    tmux select-pane -t 0
}

# Function to kill all tmux sessions
tmux-clean() {
    echo "Killing all tmux sessions..."
    tmux list-sessions -F '#S' | xargs -I {} tmux kill-session -t {}
    echo "All sessions killed."
}

# Function to list all sessions with details
tmux-list() {
    echo "Active tmux sessions:"
    tmux list-sessions 2>/dev/null || echo "No active sessions"
}

# Function to attach to most recent session
tmux-attach() {
    if [ $# -eq 0 ]; then
        # No arguments, attach to most recent
        tmux attach-session
    else
        # Attach to specific session
        tmux attach-session -t "$1"
    fi
}

# Function to show project shortcuts
tmux-help() {
    echo "Development Tmux Shortcuts:"
    echo ""
    echo "Project Sessions:"
    echo "  dev            - Use your tmux dev picker (recommended)"
    echo "  dev-worktree   - Create/switch branch worktree from current repo"
    echo "  dev-session    - Start generic development session (current directory)"
    echo ""
    echo "Utilities:"
    echo "  dev-layout     - Create 3-pane development layout"
    echo "  tmux-list      - List all active sessions"
    echo "  tmux-attach    - Attach to session (most recent if no name)"
    echo "  tmux-clean     - Kill all tmux sessions"
    echo "  tmux-help      - Show this help"
    echo ""
    echo "Tmux Key Bindings (Prefix: M-space):"
    echo "  M-space W      - Open project picker popup"
    echo "  M-space B      - Create/switch branch worktree popup"
    echo "  M-space V      - Quick editor drawer (configured command)"
    echo "  M-space Q      - Quick AI drawer (configured command)"
    echo "  M-space G      - Quick Git UI drawer (configured command)"
    echo "  M-space D      - Quick 3-pane dev layout"
    echo "  M-space c      - New window in current path"
    echo "  M-space | / -  - Split horizontally / vertically"
    echo "  M-space r      - Reload tmux config"
    echo "  Alt-1 to Alt-9 - Switch windows 1-9"
    echo "  Alt-arrows     - Switch panes"
    echo "  Alt-q/e/w      - Prev session / next session / session picker"
    echo ""
    echo "Window Layouts:"
    echo "  dev picker session:"
    echo "    - Feature-driven from dotfiles config"
    echo "    - Includes terminal plus enabled features"
    echo "  dev-session:"
    echo "    - Feature-driven from dotfiles config"
    echo "    - Includes terminal plus enabled dev-session features"
}

# Functions are automatically available in zsh once defined
# No need to export them like in bash

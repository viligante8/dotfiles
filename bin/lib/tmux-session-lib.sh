#!/usr/bin/env bash

TMUX_SESSION_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_SESSION_BIN_DIR="$(cd "$TMUX_SESSION_LIB_DIR/.." && pwd)"
TMUX_CONFIG_TOOL="${TMUX_CONFIG_TOOL:-}"

tmux_sanitize_session_name() {
    echo "$1" | sed 's/[^a-zA-Z0-9]/-/g'
}

tmux_resolve_config_tool() {
    if [ -n "$TMUX_CONFIG_TOOL" ] && [ -x "$TMUX_CONFIG_TOOL" ]; then
        echo "$TMUX_CONFIG_TOOL"
        return
    fi

    if command -v dotfiles-config >/dev/null 2>&1; then
        command -v dotfiles-config
        return
    fi

    if [ -x "$TMUX_SESSION_BIN_DIR/dotfiles-config" ]; then
        echo "$TMUX_SESSION_BIN_DIR/dotfiles-config"
        return
    fi

    if [ -n "${DOTFILES_DIR:-}" ] && [ -x "$DOTFILES_DIR/bin/dotfiles-config" ]; then
        echo "$DOTFILES_DIR/bin/dotfiles-config"
        return
    fi

    echo "$HOME/.dotfiles/bin/dotfiles-config"
}

tmux_require_config_tool() {
    TMUX_CONFIG_TOOL="$(tmux_resolve_config_tool)"

    if [ ! -x "$TMUX_CONFIG_TOOL" ]; then
        echo "Error: dotfiles-config helper not found at $TMUX_CONFIG_TOOL" >&2
        return 1
    fi
}

tmux_config_get() {
    "$TMUX_CONFIG_TOOL" "$@"
}

tmux_feature_enabled() {
    [ "$(tmux_config_get feature-enabled "$1" 2>/dev/null || echo false)" = "true" ]
}

tmux_feature_in_dev_session() {
    [ "$(tmux_config_get feature-in-dev-session "$1" 2>/dev/null || echo true)" = "true" ]
}

tmux_feature_window() {
    tmux_config_get feature-window "$1"
}

tmux_feature_command() {
    tmux_config_get feature-command "$1"
}

tmux_feature_send_enter() {
    tmux_config_get feature-send-enter "$1"
}

tmux_append_feature_window() {
    local feature_name="$1"

    if ! tmux_feature_enabled "$feature_name"; then
        return
    fi

    if ! tmux_feature_in_dev_session "$feature_name"; then
        return
    fi

    TMUX_PLAN_NAMES+=("$(tmux_feature_window "$feature_name")")
    TMUX_PLAN_COMMANDS+=("$(tmux_feature_command "$feature_name")")
    TMUX_PLAN_SEND_ENTER+=("$(tmux_feature_send_enter "$feature_name")")
}

tmux_build_window_plan() {
    TMUX_PLAN_NAMES=()
    TMUX_PLAN_COMMANDS=()
    TMUX_PLAN_SEND_ENTER=()

    tmux_append_feature_window "editor"

    TMUX_PLAN_NAMES+=("terminal")
    TMUX_PLAN_COMMANDS+=("clear")
    TMUX_PLAN_SEND_ENTER+=("true")

    tmux_append_feature_window "ai"
    tmux_append_feature_window "gitUi"
    tmux_append_feature_window "database"
}

tmux_send_window_command() {
    local target_window="$1"
    local command_to_run="$2"
    local send_enter="$3"

    if [ -z "$command_to_run" ]; then
        return
    fi

    if [ "$send_enter" = "true" ]; then
        tmux send-keys -t "$target_window" "$command_to_run" Enter
    else
        tmux send-keys -t "$target_window" "$command_to_run"
    fi
}

tmux_session_has_window() {
    local session_name="$1"
    local window_name="$2"

    tmux list-windows -t "$session_name" -F "#{window_name}" 2>/dev/null \
        | grep -Fxq -- "$window_name"
}

tmux_create_session_layout() {
    local session_name="$1"
    local project_path="$2"
    local i

    tmux_build_window_plan

    if [ ${#TMUX_PLAN_NAMES[@]} -eq 0 ]; then
        echo "Error: no windows configured for tmux session" >&2
        return 1
    fi

    tmux new-session -d -s "$session_name" -c "$project_path"

    for ((i = 0; i < ${#TMUX_PLAN_NAMES[@]}; i++)); do
        local target_window="$session_name:$((i + 1))"
        local window_name="${TMUX_PLAN_NAMES[$i]}"
        local command_to_run="${TMUX_PLAN_COMMANDS[$i]}"
        local send_enter="${TMUX_PLAN_SEND_ENTER[$i]}"

        if [ "$i" -eq 0 ]; then
            tmux rename-window -t "$target_window" "$window_name"
        else
            tmux new-window -t "$target_window" -n "$window_name" -c "$project_path"
        fi

        tmux_send_window_command "$target_window" "$command_to_run" "$send_enter"
    done

    tmux select-window -t "$session_name:1"
}

tmux_reconcile_session_layout() {
    local session_name="$1"
    local project_path="$2"
    local i

    tmux_build_window_plan

    for ((i = 0; i < ${#TMUX_PLAN_NAMES[@]}; i++)); do
        local window_name="${TMUX_PLAN_NAMES[$i]}"
        local command_to_run="${TMUX_PLAN_COMMANDS[$i]}"
        local send_enter="${TMUX_PLAN_SEND_ENTER[$i]}"

        if tmux_session_has_window "$session_name" "$window_name"; then
            continue
        fi

        tmux new-window -t "$session_name:" -n "$window_name" -c "$project_path"
        tmux_send_window_command "$session_name:$window_name" "$command_to_run" "$send_enter"
    done
}

tmux_switch_or_attach() {
    local session_name="$1"

    if [ -n "${TMUX:-}" ]; then
        tmux switch-client -t "$session_name"
    else
        tmux attach-session -t "$session_name"
    fi
}

tmux_ensure_session() {
    local session_name="$1"
    local project_path="$2"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux_reconcile_session_layout "$session_name" "$project_path"
        tmux_switch_or_attach "$session_name"
        return
    fi

    tmux_create_session_layout "$session_name" "$project_path"
    tmux_switch_or_attach "$session_name"
}

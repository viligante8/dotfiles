#!/bin/bash

# Tmux Workflow Helper Script for Development Projects
# Usage: source this in your .zshrc or run directly

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
    
    # Create new session
    tmux new-session -d -s "$session_name" -c "$project_path"
    
    # Window 1: Editor
    tmux rename-window -t "$session_name:1" 'editor'
    tmux send-keys -t "$session_name:1" 'nvim' Enter
    
    # Window 2: Terminal
    tmux new-window -t "$session_name:2" -n 'terminal' -c "$project_path"
    
    # Window 3: Q (Amazon Q AI Assistant)
    tmux new-window -t "$session_name:3" -n 'q' -c "$project_path"
    tmux send-keys -t "$session_name:3" 'q chat' Enter
    
    # Window 4: LazyGit
    tmux new-window -t "$session_name:4" -n 'git' -c "$project_path"
    tmux send-keys -t "$session_name:4" 'lazygit' Enter
    
    # Window 5: Database Development (dbdev pre-typed)
    tmux new-window -t "$session_name:5" -n 'dbdev' -c "$project_path"
    tmux send-keys -t "$session_name:5" 'dbdev' # Note: no Enter - just pre-types the command
    
    # Go back to first window and attach/switch
    tmux select-window -t "$session_name:1"
    
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
    
    # Create new session
    tmux new-session -d -s $session_name -c "$current_dir"
    
    # Window 1: Editor
    tmux rename-window -t $session_name:1 'editor'
    tmux send-keys -t $session_name:1 'nvim' Enter
    
    # Window 2 Terminal
    tmux new-window -t $session_name:2 -n 'terminal' -c "$current_dir"
    tmux send-keys -t $session_name:2 'clear' Enter
    
    # Window 3: Q (Amazon Q AI Assistant)
    tmux new-window -t $session_name:3 -n 'q' -c "$current_dir"
    tmux send-keys -t $session_name:3 'q chat' Enter
    
    # Window 4: LazyGit
    tmux new-window -t $session_name:4 -n 'git' -c "$current_dir"
    tmux send-keys -t $session_name:4 'lazygit' Enter
    
    # Go back to first window and attach
    tmux select-window -t $session_name:1
    tmux attach-session -t $session_name
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
    echo "  dev-session    - Start generic development session (current directory)"
    echo ""
    echo "Utilities:"
    echo "  dev-layout     - Create 3-pane development layout"
    echo "  tmux-list      - List all active sessions"
    echo "  tmux-attach    - Attach to session (most recent if no name)"
    echo "  tmux-clean     - Kill all tmux sessions"
    echo "  tmux-help      - Show this help"
    echo ""
    echo "Tmux Key Bindings (Prefix: Ctrl-a):"
    echo "  Ctrl-a Q       - Quick Q drawer"
    echo "  Ctrl-a G       - Quick LazyGit drawer"
    echo "  Ctrl-a D       - Quick dev layout"
    echo "  Ctrl-a |       - Split horizontally"
    echo "  Ctrl-a -       - Split vertically"
    echo "  Alt-1 to Alt-5 - Switch windows 1-5"
    echo ""
    echo "Window Layout:"
    echo "  1. editor      - Neovim"
    echo "  2. terminal    - Command line"
    echo "  3. q           - Amazon Q AI Assistant"
    echo "  4. git         - LazyGit"
    echo "  5. dbdev       - Database development (dbdev pre-typed)"
}

# Functions are automatically available in zsh once defined
# No need to export them like in bash

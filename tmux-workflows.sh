#!/bin/bash

# Tmux Workflow Helper Script for EMSI Projects
# Usage: source this in your .zshrc or run directly

# Function to start a development session for Workday Integrations
wdi-dev() {
    local project_path="$HOME/dev/emsi/workday-integrations"
    local session_name="wdi-dev"
    
    # Check if session already exists
    if tmux has-session -t $session_name 2>/dev/null; then
        echo "Session '$session_name' already exists. Attaching..."
        tmux attach-session -t $session_name
        return
    fi
    
    echo "Creating Workday Integrations development session..."
    
    # Create new session
    tmux new-session -d -s $session_name -c "$project_path"
    
    # Window 1: Editor
    tmux rename-window -t $session_name:1 'editor'
    tmux send-keys -t $session_name:1 'nvim' Enter
    
    # Window 2 Terminal
    tmux new-window -t $session_name:2 -n 'terminal' -c "$project_path"
    tmux send-keys -t $session_name:2 'clear' Enter
    
    # Window 3: Q (Amazon Q AI Assistant)
    tmux new-window -t $session_name:3 -n 'q' -c "$project_path"
    tmux send-keys -t $session_name:3 'q chat' Enter
    
    # Window 4: LazyGit
    tmux new-window -t $session_name:4 -n 'git' -c "$project_path"
    tmux send-keys -t $session_name:4 'lazygit' Enter
    
    # Go back to first window and attach
    tmux select-window -t $session_name:1
    tmux attach-session -t $session_name
}

# Function to start a development session for Company Datastore
cds-dev() {
    local project_path="$HOME/dev/emsi/company-datastore"
    local session_name="cds-dev"
    
    # Check if session already exists
    if tmux has-session -t $session_name 2>/dev/null; then
        echo "Session '$session_name' already exists. Attaching..."
        tmux attach-session -t $session_name
        return
    fi
    
    echo "Creating Company Datastore development session..."
    
    # Create new session
    tmux new-session -d -s $session_name -c "$project_path"
    
    # Window 1: Editor
    tmux rename-window -t $session_name:1 'editor'
    tmux send-keys -t $session_name:1 'nvim' Enter
    
    # Window 2 Terminal
    tmux new-window -t $session_name:2 -n 'terminal' -c "$project_path"
    tmux send-keys -t $session_name:2 'clear' Enter
    
    # Window 3: Q (Amazon Q AI Assistant)
    tmux new-window -t $session_name:3 -n 'q' -c "$project_path"
    tmux send-keys -t $session_name:3 'q chat' Enter
    
    # Window 4: LazyGit
    tmux new-window -t $session_name:4 -n 'git' -c "$project_path"
    tmux send-keys -t $session_name:4 'lazygit' Enter
    
    # Go back to first window and attach
    tmux select-window -t $session_name:1
    tmux attach-session -t $session_name
}

# Function to start a development session for Talent Transform
tt-dev() {
    local project_path="$HOME/dev/emsi/talent-transform"
    local session_name="tt-dev"
    
    # Check if session already exists
    if tmux has-session -t $session_name 2>/dev/null; then
        echo "Session '$session_name' already exists. Attaching..."
        tmux attach-session -t $session_name
        return
    fi
    
    echo "Creating Talent Transform development session..."
    
    # Create new session
    tmux new-session -d -s $session_name -c "$project_path"
    
    # Window 1: Editor
    tmux rename-window -t $session_name:1 'editor'
    tmux send-keys -t $session_name:1 'nvim' Enter
    
    # Window 2 Terminal
    tmux new-window -t $session_name:2 -n 'terminal' -c "$project_path"
    tmux send-keys -t $session_name:2 'clear' Enter
    
    # Window 3: Q (Amazon Q AI Assistant)
    tmux new-window -t $session_name:3 -n 'q' -c "$project_path"
    tmux send-keys -t $session_name:3 'q chat' Enter
    
    # Window 4: LazyGit
    tmux new-window -t $session_name:4 -n 'git' -c "$project_path"
    tmux send-keys -t $session_name:4 'lazygit' Enter
    
    # Go back to first window and attach
    tmux select-window -t $session_name:1
    tmux attach-session -t $session_name
}

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

# Function to quickly open Q in current session
q-drawer() {
    # Check if we're in a tmux session
    if [ -z "$TMUX" ]; then
        echo "Not in a tmux session. Starting Q directly..."
        q chat
        return
    fi
    
    # Check if Q window already exists
    if tmux list-windows -F '#W' | grep -q '^q$'; then
        echo "Switching to existing Q window..."
        tmux select-window -t q
    else
        echo "Creating new Q window..."
        tmux new-window -n 'q' -c "#{pane_current_path}"
        tmux send-keys 'q chat' Enter
    fi
}

# Function to quickly open LazyGit in current session
git-drawer() {
    # Check if we're in a tmux session
    if [ -z "$TMUX" ]; then
        echo "Not in a tmux session. Starting LazyGit directly..."
        lazygit
        return
    fi
    
    # Check if git window already exists
    if tmux list-windows -F '#W' | grep -q '^git$'; then
        echo "Switching to existing git window..."
        tmux select-window -t git
    else
        echo "Creating new git window..."
        tmux new-window -n 'git' -c "#{pane_current_path}"
        tmux send-keys 'lazygit' Enter
    fi
}

# Function to switch between project sessions quickly
switch-project() {
    echo "Available project sessions:"
    echo "1. wdi-dev (Workday Integrations)"
    echo "2. cdi-dev (Company Datastore)"
    echo "3. tt-dev (Talent Transform)"
    echo "4. dev-session (Generic - current directory)"
    echo ""
    
    # List current sessions
    echo "Current sessions:"
    tmux list-sessions 2>/dev/null || echo "No active sessions"
    echo ""
    
    read -p "Enter session name to attach (or 'q' to quit): " choice
    
    case $choice in
        1|wdi-dev)
            if tmux has-session -t wdi-dev 2>/dev/null; then
                tmux attach-session -t wdi-dev
            else
                echo "Starting wdi-dev session..."
                wdi-dev
            fi
            ;;
        2|cds-dev)
            if tmux has-session -t cds-dev 2>/dev/null; then
                tmux attach-session -t cds-dev
            else
                echo "Starting cds-dev session..."
                cds-dev
            fi
            ;;
        3|tt-dev)
            if tmux has-session -t tt-dev 2>/dev/null; then
                tmux attach-session -t tt-dev
            else
                echo "Starting tt-dev session..."
                tt-dev
            fi
            ;;
        4|dev-session)
            dev-session
            ;;
        q|quit)
            echo "Goodbye!"
            ;;
        *)
            # Try to attach to the session name directly
            if tmux has-session -t "$choice" 2>/dev/null; then
                tmux attach-session -t "$choice"
            else
                echo "Session '$choice' not found."
            fi
            ;;
    esac
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
    echo "EMSI Project Tmux Shortcuts:"
    echo ""
    echo "Project Sessions (4 windows: editor, terminal, q, git):"
    echo "  wdi-dev    - Start Workday Integrations development session"
    echo "  cds-dev    - Start Company Datastore development session"
    echo "  tt-dev     - Start Talent Transform development session"
    echo "  dev-session    - Start generic development session (current directory)"
    echo ""
    echo "Utilities:"
    echo "  switch-project - Interactive project session switcher"
    echo "  q-drawer       - Open/switch to Q (Amazon Q) window"
    echo "  git-drawer     - Open/switch to LazyGit window"
    echo "  dev-layout     - Create 3-pane development layout"
    echo "  tmux-list      - List all active sessions"
    echo "  tmux-attach    - Attach to session (most recent if no name)"
    echo "  tmux-clean     - Kill all tmux sessions"
    echo "  tmux-help      - Show this help"
    echo ""
    echo "Tmux Key Bindings (Prefix: Ctrl-a):"
    echo "  Ctrl-a W       - Quick Workday session"
    echo "  Ctrl-a C       - Quick Datastore session"
    echo "  Ctrl-a T       - Quick Talent session"
    echo "  Ctrl-a Q       - Quick Q drawer"
    echo "  Ctrl-a G       - Quick LazyGit drawer"
    echo "  Ctrl-a D       - Quick dev layout"
    echo "  Ctrl-a |       - Split horizontally"
    echo "  Ctrl-a -       - Split vertically"
    echo "  Alt-1 to Alt-4 - Switch windows 1-4"
    echo ""
    echo "Window Layout:"
    echo "  1. editor      - Neovim"
    echo "  2. terminal    - Command line"
    echo "  3. q           - Amazon Q AI Assistant"
    echo "  4. git         - LazyGit"
}

# Functions are automatically available in zsh once defined
# No need to export them like in bash

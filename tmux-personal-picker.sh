#!/bin/bash

# Personal project picker for tmux
# Shows a menu of all personal projects and dotfiles

PERSONAL_DIR="$HOME/dev/personal"
DOTFILES_DIR="$HOME/.dotfiles"

# Create temporary file for the menu
TEMP_FILE=$(mktemp)

# Add dotfiles as first option
echo "dotfiles -> $DOTFILES_DIR" >> "$TEMP_FILE"

# Add all directories from dev/personal (excluding files and .DS_Store)
if [ -d "$PERSONAL_DIR" ]; then
    for dir in "$PERSONAL_DIR"/*; do
        if [ -d "$dir" ]; then
            basename_dir=$(basename "$dir")
            echo "$basename_dir -> $dir" >> "$TEMP_FILE"
        fi
    done
fi

# Use fzf to show the picker
selected=$(cat "$TEMP_FILE" | fzf --height=40% --layout=reverse --border --prompt="Select personal project: ")

# Clean up temp file
rm "$TEMP_FILE"

# Exit if nothing selected
if [ -z "$selected" ]; then
    exit 0
fi

# Extract project name and path
project_name=$(echo "$selected" | cut -d' ' -f1)
project_path=$(echo "$selected" | cut -d'>' -f2 | xargs)

# Create session name (replace dots and special chars with dashes)
session_name=$(echo "$project_name" | sed 's/[^a-zA-Z0-9]/-/g')

# Use the existing tmux-workflows.sh script to create the session
exec "$HOME/.dotfiles/tmux-workflows.sh" "$session_name" "$project_path"

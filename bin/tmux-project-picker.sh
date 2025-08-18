#!/bin/bash

# Universal project picker for tmux
# Usage: tmux-project-picker.sh <base_dir> [additional_dirs...]
# Example: tmux-project-picker.sh ~/dev/emsi
# Example: tmux-project-picker.sh ~/dev/personal ~/dev/personal/dotfiles

if [ $# -eq 0 ]; then
    echo "Usage: $0 <base_dir> [additional_dirs...]"
    exit 1
fi

BASE_DIR="$1"
shift

# Create temporary file for the menu
TEMP_FILE=$(mktemp)

# Add directories from base directory
if [ -d "$BASE_DIR" ]; then
    for dir in "$BASE_DIR"/*; do
        if [ -d "$dir" ]; then
            basename_dir=$(basename "$dir")
            echo "$basename_dir -> $dir" >> "$TEMP_FILE"
        fi
    done
fi

# Add any additional directories passed as arguments
for additional_dir in "$@"; do
    if [ -d "$additional_dir" ]; then
        basename_dir=$(basename "$additional_dir")
        echo "$basename_dir -> $additional_dir" >> "$TEMP_FILE"
    fi
done

# Use fzf to show the picker
selected=$(cat "$TEMP_FILE" | fzf --height=40% --layout=reverse --border --prompt="Select project: ")

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
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$script_dir/../tmux-workflows.sh" "$session_name" "$project_path"

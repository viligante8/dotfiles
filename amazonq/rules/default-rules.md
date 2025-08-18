Only make changes in source controlled directories
Never make changes in directories without source tracking
Never commit changes without my express consent
Always check for the correct package manager to use, npm/yarn/bun by looking at the lockfile
ignore node_modules because they're huge
My dotfiles are in ~/dev/personal/dotfiles/
My work files are in ~/dev/emsi/
My personal repos are in ~/dev/personal/
I also have repos that I have cloned for you to use as reference material. They are in ~/dev/personal/examples

## Custom Tools Available
- `clip` - System-wide clipboard sharing tool (located at ~/.local/bin/clip)
  - `clip` - Share current clipboard (text + images)
  - `clip -l` - List clipboard history from Maccy
  - `clip -n N` - Share item N from clipboard history
  - `clip -t` - Text only, `clip -i` - Images only
  - Always suggest using this when user wants to share clipboard content

# Tmux Quick Reference - EMSI Projects

## Key Bindings (Prefix: Ctrl-a)

### Session Management
- `Ctrl-a d` - Detach from session
- `Ctrl-a s` - List sessions
- `Ctrl-a $` - Rename session

### Window Management
- `Ctrl-a c` - Create new window
- `Ctrl-a ,` - Rename window
- `Ctrl-a n` - Next window
- `Ctrl-a p` - Previous window
- `Ctrl-a 1-9` - Switch to window by number
- `Alt-1` to `Alt-4` - Quick switch to windows 1-4

### Pane Management
- `Ctrl-a |` - Split horizontally
- `Ctrl-a -` - Split vertically
- `Ctrl-a h/j/k/l` - Navigate panes (vim-style)
- `Alt-Arrow` - Navigate panes (no prefix needed)
- `Ctrl-a H/J/K/L` - Resize panes
- `Ctrl-a x` - Close pane
- `Ctrl-a z` - Zoom/unzoom pane

### Copy Mode
- `Ctrl-a [` - Enter copy mode
- `v` - Start selection (in copy mode)
- `y` - Copy selection (in copy mode)
- `Ctrl-a ]` - Paste

### Project-Specific Shortcuts
- `Ctrl-a W` - Start Workday Integrations development session
- `Ctrl-a C` - Start Company Datastore development session
- `Ctrl-a T` - Start Talent Transform development session
- `Ctrl-a Q` - Open/switch to Q (Amazon Q) drawer
- `Ctrl-a D` - Create development layout (3 panes) in current window

### General Shortcuts
- `Ctrl-a r` - Reload config

## Shell Functions

### Project Development Sessions
- `workday-dev` - Start Workday Integrations development session
- `datastore-dev` - Start Company Datastore development session  
- `talent-dev` - Start Talent Transform development session
- `dev-session` - Start generic development session (current directory)

### Workflow Utilities
- `switch-project` - Interactive project session switcher
- `q-drawer` - Open/switch to Q (Amazon Q) window in current session
- `dev-layout` - Create 3-pane development layout in current window
- `tmux-help` - Show all available shortcuts and functions

### Session Management
- `tmux-list` - List all active sessions
- `tmux-attach [session-name]` - Attach to session (most recent if no name)
- `tmux-clean` - Kill all tmux sessions

## Project Session Layouts

Each project session creates 4 windows:

### All Projects (`workday-dev`, `datastore-dev`, `talent-dev`)
1. **editor** - nvim opened in project root
2. **terminal** - General terminal work
3. **q** - Amazon Q AI Assistant (`q chat`) - Your agentic AI drawer

### Generic Development Session (`dev-session`)
1. **editor** - nvim opened in current directory
2. **terminal** - General terminal work
3. **q** - Amazon Q AI Assistant (`q chat`) - Your agentic AI drawer

## Plugin Management (TPM)

### Install Plugins
1. Add plugin to `.tmux.conf`
2. Press `Ctrl-a I` (capital i) to install

### Update Plugins
- `Ctrl-a U` - Update all plugins

### Uninstall Plugins
1. Remove plugin from `.tmux.conf`
2. Press `Ctrl-a alt-u` to uninstall

## Common Workflows

### Starting a Development Session
```bash
# Option 1: Use project-specific functions
workday-dev      # For Workday Integrations
datastore-dev    # For Company Datastore
talent-dev       # For Talent Transform

# Option 2: Use interactive switcher
switch-project

# Option 3: Use tmux key bindings
# Ctrl-a W (Workday), Ctrl-a C (Datastore), Ctrl-a T (Talent)
```

### Working with Multiple Projects
```bash
# Start sessions for multiple projects
workday-dev &
datastore-dev &

# Switch between them
tmux attach-session -t workday-dev
# Detach with Ctrl-a d, then:
tmux attach-session -t datastore-dev

# Or use the interactive switcher
switch-project
```

### Quick Development Layout
```bash
# In any directory, create a 3-pane layout
dev-layout

# Or use the key binding
# Ctrl-a D
```

### Session Management
```bash
# List all sessions
tmux-list

# Attach to most recent session
tmux-attach

# Attach to specific session
tmux-attach workday-dev

# Kill all sessions (clean slate)
tmux-clean
```

## Tips

1. **Mouse Support**: Click to switch panes, drag to resize, scroll to navigate history
2. **Copy to System Clipboard**: Selections automatically copy to macOS clipboard
3. **Vim Integration**: All key bindings work well with nvim
4. **Session Persistence**: Sessions survive computer restarts (tmux-resurrect plugin)
5. **Path Awareness**: New panes/windows open in current directory
6. **Project Switching**: Use `switch-project` for easy navigation between projects

## Troubleshooting

### Colors Not Working
Make sure your terminal supports true color and has `TERM` set correctly.

### Plugins Not Loading
1. Make sure TPM is installed: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
2. Reload config: `Ctrl-a r`
3. Install plugins: `Ctrl-a I`

### Key Bindings Not Working
1. Check if another application is intercepting the keys
2. Reload config: `Ctrl-a r`
3. Restart tmux: `tmux kill-server` then start new session

### Project Directory Not Found
Make sure the project paths exist:
- `~/dev/emsi/workday-integrations`
- `~/dev/emsi/company-datastore`
- `~/dev/emsi/talent-transform`

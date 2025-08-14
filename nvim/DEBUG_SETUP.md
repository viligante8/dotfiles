# Neovim Debugging Setup Guide

Your Neovim debugging setup is now configured to work with VS Code DAP and integrates with your script-runner.nvim plugin!

## Features

### 🐛 Debug Adapter Protocol (DAP)
- Full debugging support for TypeScript/JavaScript with Bun
- VS Code launch.json compatibility
- Beautiful debug UI with breakpoints, variables, and call stack
- Integration with your existing VS Code configurations

### 🚀 Script Runner Integration
- Debug any package.json script directly from Neovim
- Automatic environment variable setup (AWS_PROFILE for your workday scripts)
- Quick attach to running debug processes

## Key Bindings

### Debug Controls
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dc` - Continue execution
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>dO` - Step over
- `<leader>dt` - Terminate debug session
- `<leader>du` - Toggle debug UI
- `<leader>dr` - Toggle debug REPL

### Script Runner + Debug Integration
- `<leader>trs` - Run script (normal execution)
- `<leader>trd` - **Debug script** (with breakpoints!)
- `<leader>trD` - Debug last script
- `<leader>tra` - Attach to running debug process

### VS Code Integration
- `<leader>dv` - Load VS Code launch.json configurations

## How to Use

### Method 1: Debug Scripts with Script Runner
1. Open your workday-integrations project in Neovim
2. Set breakpoints in your code with `<leader>db`
3. Press `<leader>trd` to see a list of available scripts
4. Select the script you want to debug (e.g., "pullLatestSkillMappings")
5. The debug session will start with the debug UI automatically opening

### Method 2: Use VS Code Configurations
1. Your existing `.vscode/launch.json` configurations are automatically loaded
2. Press `<leader>dc` to start debugging with the default configuration
3. Or use `<leader>dv` to reload VS Code configurations

### Method 3: Attach to Running Process
1. Start your script with debug flags: `bun --inspect-wait=0.0.0.0:6499 run start:pullLatestSkillMappings`
2. In Neovim, press `<leader>tra` to attach to the running process

## Environment Variables

The setup automatically adds `AWS_PROFILE=emsi-company-micro` for scripts matching:
- `pullLatestSkillMappings`
- `pushLatestSkills`
- Any script containing these patterns

## Debug UI

When debugging starts, you'll see:
- **Variables panel** - Inspect local and global variables
- **Call stack** - Navigate through function calls
- **Breakpoints panel** - Manage all your breakpoints
- **Debug console** - Execute code in the current context

## Troubleshooting

### If debugging doesn't start:
1. Make sure you're in a directory with `package.json`
2. Check that Bun is installed and accessible
3. Verify port 6499 isn't already in use

### If breakpoints don't hit:
1. Make sure you're debugging the TypeScript source, not compiled JavaScript
2. Check that source maps are enabled in your project
3. Verify the file path matches exactly

### If VS Code configs don't load:
1. Check that `.vscode/launch.json` exists and is valid JSON
2. Use `<leader>dv` to manually reload configurations

## Tips

- Use `<leader>de` to evaluate expressions in debug mode
- The debug UI automatically opens/closes with debug sessions
- Your script-runner.nvim plugin now has debugging superpowers!
- All your existing VS Code debug configurations work seamlessly

Happy debugging! 🐛✨

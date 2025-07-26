# Debugging Configuration Guide

## 🎯 Overview

This guide provides configuration requirements and usage instructions for the comprehensive JavaScript/TypeScript debugging setup that supports npm, yarn, and bun projects.

## 📋 Configuration Requirements

### 1. Package.json Script Configuration

#### For Bun Projects
```json
{
  "scripts": {
    "start": "bun --inspect run src/server.ts",
    "start:dev": "bun --inspect run src/server.ts",
    "debug": "bun --inspect-brk run src/server.ts",
    "test:debug": "bun --inspect run --env-file=.env vitest"
  }
}
```

#### For NPM Projects
```json
{
  "scripts": {
    "start": "node --inspect src/server.js",
    "start:dev": "node --inspect src/server.js", 
    "debug": "node --inspect-brk src/server.js",
    "test:debug": "node --inspect node_modules/.bin/jest"
  }
}
```

#### For Yarn Projects
```json
{
  "scripts": {
    "start": "node --inspect src/server.js",
    "start:dev": "node --inspect src/server.js",
    "debug": "node --inspect-brk src/server.js", 
    "test:debug": "node --inspect node_modules/.bin/jest"
  }
}
```

### 2. Required Debug Flags

| Flag | Purpose | When to Use |
|------|---------|-------------|
| `--inspect` | Enable debugging, continue execution | Development debugging |
| `--inspect-brk` | Enable debugging, break on first line | Debugging startup issues |
| `--inspect=HOST:PORT` | Custom host/port | Advanced configurations |

### 3. TypeScript Configuration

Ensure your `tsconfig.json` includes source map generation:

```json
{
  "compilerOptions": {
    "sourceMap": true,
    "inlineSourceMap": false,
    "outDir": "./dist"
  }
}
```

## 🚀 Usage Instructions

### Basic Debugging Workflow

1. **Open Project File**
   ```bash
   # Navigate to your project
   cd ~/your-project
   nvim src/server.ts
   ```

2. **Set Breakpoints**
   - Use `<leader>db` to toggle breakpoints
   - Use `<leader>dB` for conditional breakpoints
   - Breakpoints show as 🔴 signs in the gutter

3. **Start Debugging**
   - Use `<leader>dQ` for quick script debugging
   - Use `:DebugQuick` command
   - Select from available debug scripts

4. **Debug Controls**
   - `<leader>dc` - Continue execution
   - `<leader>di` - Step into functions
   - `<leader>do` - Step out of functions
   - `<leader>dO` - Step over lines
   - `<leader>dt` - Terminate debugging

### Running Scripts

1. **Launch Script Runner**
   - Use `<leader>dR` or `:RunScript`
   - Select script from the picker
   - Script runs in terminal split

2. **Available Script Categories**
   - 🎆 Start scripts
   - 🧪 Test scripts  
   - 🔨 Build scripts
   - 🔍 Lint scripts
   - ✨ Format scripts
   - 🚀 Deploy scripts
   - 🧹 Clean scripts

### Advanced Debugging

#### Attach to Running Process

1. Start your process with debug flag:
   ```bash
   # Bun
   bun --inspect run src/server.ts
   
   # NPM
   npm run start:debug
   
   # Yarn
   yarn start:debug
   ```

2. Use attach configuration:
   - Open DAP configurations (`<leader>dc`)
   - Select "Attach to [Package Manager] Process"
   - Debug session will connect to running process

#### Debug Current File

1. Open any TypeScript/JavaScript file
2. Use "Debug Current File" configuration
3. File will be executed directly with debugging

## 🛠 Troubleshooting

### Common Issues

#### 1. Debug Adapter Not Found
**Solution:**
```vim
:MasonInstall js-debug-adapter
:MasonInstall node-debug2-adapter
```

#### 2. Breakpoints Not Working
**Checklist:**
- [ ] Source maps enabled in tsconfig.json
- [ ] File paths match exactly (use absolute paths)
- [ ] Debug adapter is running
- [ ] Process started with `--inspect` flag

#### 3. Scripts Not Detected
**Debug Commands:**
```vim
:lua print(vim.inspect(require('utils.package-scripts').get_package_scripts()))
:lua print(require('utils.package-manager').detect_package_manager())
```

#### 4. Package Manager Not Detected
**Checklist:**
- [ ] Lock file exists (`package-lock.json`, `yarn.lock`, `bun.lock`)
- [ ] `package.json` exists in project root
- [ ] Working directory is correct (`:pwd`)

### Debug Information Commands

```vim
" Check DAP status
:lua print(vim.inspect(require('dap').configurations))

" List current breakpoints  
:lua print(vim.inspect(require('dap').list_breakpoints()))

" Check debug adapters
:lua print(vim.inspect(require('dap').adapters))

" Validate package detection
:lua print(require('utils.package-manager').detect_package_manager())

" List available scripts
:lua print(vim.inspect(require('utils.package-scripts').get_package_scripts()))
```

## 📊 Performance Considerations

### Script Detection Performance
- Script parsing is cached per session
- Package manager detection is instant (file system check only)
- No external process calls during detection

### Memory Usage
- Debug configurations are loaded lazily
- Breakpoints stored efficiently in DAP
- Clean session termination prevents memory leaks

## 🔧 Customization

### Adding Custom Script Categories

Edit `lua/utils/package-scripts.lua`:

```lua
local CATEGORY_PATTERNS = {
  start = { '^start', '^serve', '^dev' },
  test = { '^test', '^spec', '^jest', '^mocha', '^vitest' },
  -- Add your custom category
  custom = { '^custom', '^my%-script' },
}
```

### Custom Debug Configuration

Add to `lua/utils/debug-configs.lua`:

```lua
local function create_custom_debugger()
  return {
    name = "🔧 Custom Debugger",
    type = "pwa-node",
    request = "launch",
    program = "${workspaceFolder}/custom-entry.js",
    -- ... your configuration
  }
end
```

### Custom Keybindings

Add to your config:

```lua
-- Custom debugging keymaps
vim.keymap.set('n', '<leader>dx', function() 
  -- Your custom debug function
end, { desc = "Custom Debug Action" })
```

## 📈 Validation Checklist

Use this checklist to verify your setup:

- [ ] Package manager detected correctly
- [ ] Scripts parsed and categorized  
- [ ] Debug configurations available
- [ ] DAP adapters installed via Mason
- [ ] Breakpoints work in .ts files
- [ ] Breakpoints work in .js files
- [ ] DebugQuick command functional
- [ ] RunScript command functional
- [ ] All utility modules loading
- [ ] Error handling graceful

## 🎉 Success Criteria

Your debugging setup is ready when:

1. ✅ `<leader>dQ` launches debug script picker
2. ✅ `<leader>dR` launches script runner
3. ✅ Breakpoints show red dots in gutter
4. ✅ Debug session starts without errors
5. ✅ Variables visible in DAP UI
6. ✅ Step debugging works smoothly
7. ✅ Terminal scripts execute properly

---

**Happy Debugging! 🐛➡️✨**

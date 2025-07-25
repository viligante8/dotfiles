# Debugging Guide for Node.js/Bun/TypeScript Projects

Your Neovim setup now includes comprehensive debugging support for your TypeScript/JavaScript projects using nvim-dap.

## Quick Start

### 🚀 **Basic Debugging Keys**
- `<F5>` - Start/Continue debugging
- `<F1>` - Step Into
- `<F2>` - Step Over  
- `<F3>` - Step Out
- `<F7>` - Toggle Debug UI
- `<leader>b` - Toggle Breakpoint
- `<leader>B` - Conditional Breakpoint

### 🎯 **Project-Specific Shortcuts**
- `<leader>da` - Debug API Server (auto-detects your project)
- `<leader>S` - Debug Configuration Selector (shows all available configs)
- `<leader>dc` - Continue
- `<leader>dr` - Restart
- `<leader>dx` - Terminate

## Available Debug Configurations

### Generic Configurations (Available in all projects)

1. **Launch Node.js** - Debug current file with Node.js runtime
2. **Launch with Bun** - Debug current file with Bun runtime  
3. **Attach to Node.js** - Attach to already running Node.js process

### Project-Specific Configurations

The setup automatically detects your project and provides relevant configurations:

#### **workday-integrations** project:
- **Debug API Server** (`<leader>da`) - Runs `bun run start:api`
- **Debug pullLatestSkillMappings** (`<leader>dp`) - Runs `bun run start:pullLatestSkillMappings`
- **Debug pushLatestSkills** (`<leader>ds`) - Runs `bun run start:pushLatestSkills`
- **Debug pushOrgSkillsAndMappings** (`<leader>do`) - Runs `bun run start:pushOrgSkillsAndMappings`
- **Debug createMaintainedSkills** (`<leader>dm`) - Runs `bun run start:createMaintainedSkills`
- **Debug pushOrgRoles** (`<leader>dr`) - Runs `bun run start:pushOrgRoles`
- **Debug API Tests** (`<leader>dta`) - Runs `bun run test:api`
- **Debug Automation Tests** (`<leader>dto`) - Runs `bun run test:automations`
- **Debug All Tests** (`<leader>dtA`) - Runs `bun run test:all`

#### **company-datastore** project:
- **Debug API Server** (`<leader>da`) - Runs `bun run start:api`
- **Debug monthlyRecommendationProcessing** (`<leader>dm`) - Runs `bun run start:monthlyRecommendationProcessing`
- **Debug API Tests** (`<leader>dta`) - Runs `bun run test:api`
- **Debug Automation Tests** (`<leader>dto`) - Runs `bun run test:automations`
- **Debug All Tests** (`<leader>dtA`) - Runs `bun run test:all`

## How to Debug

### 🔍 **Debugging a TypeScript File**
1. Open any `.ts` file in your project
2. Set breakpoints with `<leader>b`
3. Press `<F5>` to start debugging
4. Choose appropriate configuration from the menu

### 🏃 **Quick API Server Debugging**
1. Navigate to either project directory:
   ```bash
   cd ~/dev/emsi/workday-integrations
   # OR
   cd ~/dev/emsi/company-datastore
   ```
2. Open Neovim in the project root
3. Press `<leader>da` - it will automatically detect which project you're in and start the correct API server with debugging

### 🂱️ **Debug Configuration Selector**
1. Press `<leader>S` to open the debug configuration selector
2. Choose from all available project-specific configurations
3. Each option shows the keymap and description for easy reference
4. Perfect for discovering what debugging options are available in your current project

### 🧪 **Test Debugging**
1. Open a test file (e.g., `something.test.ts`)
2. Set breakpoints in your test
3. Press `<leader>dt` to debug tests
4. Step through your test logic

### 🔌 **Attach to Running Process**
1. Start your server manually with Node inspect:
   ```bash
   bun run --inspect src/api/server.ts
   ```
2. In Neovim, press `<F5>`
3. Choose "Attach to Node.js"
4. Select the process from the list

## Debugging UI

When you start debugging:
- **Variables panel** - See variable values
- **Watch panel** - Monitor expressions  
- **Call stack** - See function call hierarchy
- **Breakpoints panel** - Manage all breakpoints
- **Console** - See debug output

### UI Controls
- `<F7>` - Toggle the entire debug UI
- Click `▶` to continue
- Click `⏸` to pause
- Click `⏹` to stop

## Project-Specific Tips

### **workday-integrations**
- Debug API endpoints by setting breakpoints in route handlers
- Debug automation scripts by running them directly
- Test database interactions by debugging test files

### **company-datastore**  
- Debug Elysia routes and middleware
- Debug database queries and Kysely operations
- Debug Kanel type generation issues

## Environment Setup

The debugger automatically:
- Uses source maps for TypeScript
- Sets up proper Node.js/Bun runtime
- Configures development environment variables
- Resolves workspace paths correctly

## Troubleshooting

### **Breakpoints not hitting?**
- Ensure source maps are enabled in your `tsconfig.json`
- Check that you're running the debug configuration, not regular execution

### **Can't see variables?**
- Make sure the debug UI is open (`<F7>`)
- Variables may be optimized out in production builds

### **Bun-specific issues?**
- Bun has excellent debugging support, but some Node.js-specific features might behave differently
- Try the Node.js configuration if Bun causes issues

## Advanced Usage

### **Environment Variables**
Edit the debug configurations in `lua/plugins/tools/init.lua` to add custom environment variables:

```lua
env = {
  NODE_ENV = 'development',
  DEBUG = 'app:*',
  -- Add your custom env vars here
},
```

### **Custom Debug Arguments**
Modify the `args` array in configurations to pass custom arguments to your scripts.

### **Multiple Projects**
The setup automatically detects which project you're in based on the current directory and adjusts configurations accordingly.

## Happy Debugging! 🐛

Your debugging setup is now ready to handle:
- ✅ TypeScript debugging with source maps
- ✅ Bun runtime support
- ✅ Node.js compatibility
- ✅ Vitest test debugging
- ✅ API server debugging
- ✅ Process attachment
- ✅ Project-specific configurations

Just set breakpoints and press `<F5>` to get started!

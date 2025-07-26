# 🧪 LazyVim Migration Test Checklist

This checklist validates that your migration from kickstart to LazyVim was successful. Work through each section to confirm all features are working.

## ✅ Automated Tests (Passed)

Based on our automated validation:

✅ **Neovim starts without errors**  
✅ **All plugins installed correctly** (10/10 plugins in lazy-lock.json)  
✅ **Configuration files properly structured**

## 📋 Manual Tests Required

### 1. 🎨 Visual & Basic Functionality

**Test 1: Launch Neovim**
```bash
nvim
```
**Expected:**
- ✅ Neovim starts without errors
- ✅ Kanagawa colorscheme is active (dark blue/purple theme)
- ✅ LazyVim splash screen appears
- ✅ Status line shows at bottom
- ✅ File tree (neo-tree) available

**Test 2: Check LazyVim Status**
```vim
:Lazy
```
**Expected:**
- ✅ All plugins show as loaded/installed
- ✅ No error messages
- ✅ Your custom plugins visible in list

### 2. ⚙️ Custom Options

**Test 3: Verify Custom Settings**
```vim
:set relativenumber?
:set colorcolumn?
:set scrolloff?
:set foldmethod?
```
**Expected:**
- ✅ `relativenumber` should show line numbers relatively
- ✅ `colorcolumn=120` visible as column at position 120
- ✅ `scrolloff=10` - cursor stays 10 lines from edges when scrolling
- ✅ `foldmethod=expr` - treesitter-based folding

### 3. ⌨️ Essential Keymaps

**Test 4: File Tree Toggle**
```
<C-f>
```
**Expected:**
- ✅ Neo-tree file explorer opens/closes on left side

**Test 5: Find & Replace in Quickfix**
```
<A-f>
```
**Expected:**
- ✅ Prompts for "Replace what:" and "With what:"
- ✅ Only works after you have items in quickfix list

### 4. 🛠️ Major Workflow Tools

**Test 6: Git Integration**
```
<C-g>
```
**Expected:**
- ✅ LazyGit opens in floating window
- ✅ Full git TUI with commit, branch, diff capabilities

**Test 7: Testing (in a project with tests)**
```
<A-t>r    # Run tests in current file
<A-t>s    # Show test summary
<A-t>o    # Show test output
<A-t>a    # Run all tests
```
**Expected:**
- ✅ Neotest runs tests and shows results
- ✅ Test results appear in sidebar/window
- ✅ Pass/fail indicators in gutter

**Test 8: AI Chat (requires OPEN_AI_API_KEY env var)**
```
<C-q>nt   # New AI chat in tab
<C-q>ns   # New AI chat in split
```
**Expected:**
- ✅ GP.nvim opens chat interface
- ✅ Can interact with AI if API key is set
- ✅ Multiple chat windows/tabs work

**Test 9: Database UI**
```
<A-d>t
```
**Expected:**
- ✅ Database UI opens (dadbod-ui)
- ✅ Connection management interface
- ✅ SQL query capabilities

**Test 10: REPL Integration**
```
<A-r>o    # Open REPL
<A-r>l    # Send line to REPL
<A-r>v    # Send visual selection to REPL (in visual mode)
```
**Expected:**
- ✅ REPL opens for current filetype
- ✅ Code execution in REPL
- ✅ Integration with current buffer

### 5. 🔧 Advanced Features

**Test 11: Debugging**
```
<leader>db    # Toggle breakpoint
<leader>dc    # Debug continue
<leader>du    # Toggle debug UI
```
**Expected:**
- ✅ Debug breakpoints can be set
- ✅ Debug UI opens with variables, call stack
- ✅ DAP integration works

**Test 12: Text Objects & Enhancements**
```
# Test nvim-surround (select some text first)
ys"   # Surround with quotes
ds"   # Delete surrounding quotes
cs"'  # Change quotes to single quotes
```
**Expected:**
- ✅ Surround operations work correctly
- ✅ Text objects function properly

**Test 13: Better Quickfix**
- Create some quickfix entries: `:vimgrep /pattern/ **/*.lua`
- Open quickfix: `:copen`
**Expected:**
- ✅ Enhanced quickfix window with previews (nvim-bqf)
- ✅ Better navigation and display

**Test 14: Session Persistence**
- Open several files and windows
- Exit Neovim: `:qa`
- Restart Neovim
**Expected:**
- ✅ Previous session restored (persistence.nvim)
- ✅ Same files and layout restored

### 6. 🚀 LazyVim Core Features

**Test 15: LazyVim Features (should work out of the box)**
```
<leader>ff    # Find files (telescope)
<leader>sg    # Search in files (live grep)
<leader>e     # Toggle file explorer
<leader>qq    # Quit all
```
**Expected:**
- ✅ Telescope file finder works
- ✅ Search functionality works
- ✅ File explorer toggles
- ✅ All LazyVim defaults function

## 📊 Test Results Summary

Mark each test as you complete it:

### Basic Functionality
- [ ] Neovim starts correctly with Kanagawa theme
- [ ] LazyVim loads without errors
- [ ] Custom options are configured

### Keymaps
- [ ] `<C-f>` - File tree toggle
- [ ] `<A-f>` - Find/replace in quickfix  
- [ ] `<C-g>` - LazyGit

### Major Tools
- [ ] `<A-t>*` - Testing with Neotest
- [ ] `<C-q>*` - AI chat with GP.nvim
- [ ] `<A-d>t` - Database UI
- [ ] `<A-r>*` - REPL integration
- [ ] `<leader>d*` - Debugging with DAP

### Enhancements
- [ ] nvim-surround text objects
- [ ] Enhanced quickfix (nvim-bqf)
- [ ] Session persistence
- [ ] LazyVim core features

## 🎯 Success Criteria

**Migration is successful if:**
- ✅ 90%+ of tests pass
- ✅ All your major workflow tools work
- ✅ No critical errors or missing functionality
- ✅ LazyVim enhancements are available

## 🔧 Troubleshooting

### Common Issues:

**1. AI Chat not working**
- Set environment variable: `export OPEN_AI_API_KEY=your_key`
- Restart Neovim after setting

**2. Testing not working**
- Ensure you're in a project with test files
- Check Neotest adapter configuration for your test framework

**3. Database UI empty**
- You need to configure database connections first
- Use `:DBUIAddConnection` to add databases

**4. Keymaps not working**
- Check for conflicts: `:nmap <key>` to see what key is mapped to
- Some keymaps are only active in certain modes or contexts

**5. Plugin not loading**
- Check `:Lazy` for plugin status
- Some plugins are lazy-loaded and activate on first use

## 📝 Final Migration Status

Based on your testing, the migration is:
- [ ] ✅ **Fully Successful** - All major features working
- [ ] ⚠️ **Mostly Successful** - Minor issues, but usable
- [ ] ❌ **Needs Work** - Several features broken

**Notes:**
_Add any specific issues or customizations needed here_

---

## 🎉 Congratulations!

If most tests pass, you've successfully migrated from kickstart to LazyVim while preserving all your custom workflows and enhancements!

Your setup now combines:
- 🔥 LazyVim's excellent defaults and plugin ecosystem
- 🛠️ Your custom workflow tools (testing, AI, database, debugging)  
- ⚙️ Your preferred settings and keymaps
- 🎨 Your chosen colorscheme and UI preferences

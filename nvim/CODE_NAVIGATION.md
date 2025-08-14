# Code Navigation Setup

Your Neovim setup now has three complementary tools for code navigation and analysis:

## 🔍 **Trouble.nvim** - Problems & Diagnostics
**Purpose**: Shows errors, warnings, references, and other issues
**When to use**: When you want to see "what's wrong" or "where is this used"

### Key bindings:
- `<leader>xx` - Toggle Trouble
- `<leader>xw` - Workspace Diagnostics  
- `<leader>xd` - Document Diagnostics
- `<leader>xl` - Location List
- `<leader>xq` - Quickfix
- `<leader>xr` - References
- `<leader>xi` - Implementations
- `<leader>xD` - Definitions
- `<leader>xt` - Type Definitions
- `gR` - LSP References (quick access)

## 🗂️ **Aerial.nvim** - Code Structure & Symbols
**Purpose**: Shows code outline with functions, classes, variables, etc.
**When to use**: When you want to see "what's in this file" or navigate code structure

### Key bindings:
- `<leader>a` - Toggle Aerial (main command)
- `<leader>A` - Aerial Nav (floating navigation)
- `<leader>ao` - Open Aerial
- `<leader>ac` - Close Aerial
- `<leader>an` - Next symbol
- `<leader>ap` - Previous symbol
- `{` and `}` - Navigate between symbols (when in a buffer with aerial attached)

### In Aerial window:
- `<CR>` - Jump to symbol
- `<C-v>` - Jump in vertical split
- `<C-s>` - Jump in horizontal split
- `o` / `za` - Toggle fold
- `l` / `zo` - Open fold
- `h` / `zc` - Close fold
- `q` - Close aerial window

## 🔭 **Telescope** - Search & Find
**Purpose**: Fuzzy finding for files, symbols, and LSP features
**When to use**: When you want to search across files or find specific symbols

### LSP/Symbol search (new additions):
- `<leader>ss` - Document Symbols
- `<leader>sS` - Workspace Symbols  
- `<leader>sr` - References
- `<leader>si` - Implementations
- `<leader>sd` - Definitions
- `<leader>st` - Type Definitions

### Existing search features:
- `<leader>ff` - Find Files
- `<leader>fr` - Recent Files
- `<leader>fb` - Buffers
- `<leader>sg` - Live Grep
- `<leader>sw` - Search Word
- `<leader>sb` - Search in Buffer

## 🔄 **How They Work Together**

### Typical Workflow:
1. **Start with Aerial** (`<leader>a`) to see file structure
2. **Use Telescope** (`<leader>ss`) to search for specific symbols
3. **Check Trouble** (`<leader>xx`) to see any issues/diagnostics
4. **Navigate with Trouble** (`<leader>xr`) to see all references to a symbol

### Complementary Use Cases:
- **Aerial**: "Show me the structure of this file"
- **Telescope**: "Find me all functions named 'handleClick'"  
- **Trouble**: "Show me all errors in this project"

### Quick Navigation:
- `{` / `}` - Jump between symbols (aerial)
- `gR` - Show references (trouble)
- `<leader>ss` - Search document symbols (telescope)

## 🚀 **What Changed**
- ✅ **Added**: aerial.nvim for code outline
- ✅ **Enhanced**: telescope with LSP symbol search
- ✅ **Enhanced**: trouble with more LSP integrations  
- ❌ **Removed**: nvim-bqf (redundant with trouble)

Your setup now provides comprehensive code navigation without redundancy!

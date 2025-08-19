return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- Priority list of preferred backends for aerial
    backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
    
    layout = {
      max_width = { 40, 0.2 },
      width = 50, -- Set fixed width
      min_width = 10,
      default_direction = "right", -- Always open on the right
      placement = "window",
    },
    
    attach_mode = "window",
    
    -- Keymaps in aerial window - use scroll instead of jump to avoid splits
    keymaps = {
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.scroll", -- Use scroll instead of jump to avoid splits
      ["<2-LeftMouse>"] = "actions.scroll", -- Same for mouse clicks
      ["<C-v>"] = "actions.jump_vsplit",
      ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll",
      ["{"] = "actions.prev",
      ["}"] = "actions.next",
      ["[["] = "actions.prev_up",
      ["]]"] = "actions.next_up",
      ["q"] = "actions.close",
      ["o"] = "actions.tree_toggle",
      ["za"] = "actions.tree_toggle",
      ["l"] = "actions.tree_open",
      ["zo"] = "actions.tree_open",
      ["h"] = "actions.tree_close",
      ["zc"] = "actions.tree_close",
    },
    
    -- Configure how aerial opens files
    default_bindings = true,
    
    -- Don't open in splits by default
    default_direction = "prefer_left", -- Jump to the main editor window
    
    -- When jumping to a symbol, don't create splits
    close_on_select = false,
    
    -- When true, don't load aerial until a command is run or function is called
    lazy_load = true,
    
    -- Disable aerial on files with this many lines
    disable_max_lines = 10000,
    
    -- A list of all symbols to display
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
      "Variable",
      "Constant",
    },
    
    -- Determines line highlighting mode when aerial is attached
    highlight_mode = "split_width",
    
    -- Highlight the closest symbol if the cursor is not exactly on one
    highlight_closest = true,
    
    -- When jumping to a symbol, highlight the line for this many ms
    highlight_on_jump = 300,
    
    -- Use symbol tree for folding
    manage_folds = false,
    
    -- Call this function when aerial attaches to a buffer
    on_attach = function(bufnr)
      -- Jump to the aerial window with '{' and '}'
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
    end,
    
    -- Automatically open aerial when entering supported buffers
    open_automatic = false,
    
    -- Run this command after jumping to a symbol
    post_jump_cmd = "normal! zz",
    
    -- When true, aerial will automatically close after jumping to a symbol
    close_on_select = false,
    
    -- The autocmds that trigger symbols update
    update_events = "TextChanged,InsertLeave",
    
    -- Show box drawing characters for the tree hierarchy
    show_guides = true,
    
    -- Customize the characters used when show_guides = true
    guides = {
      last_item = "└─",
      nested_top = "├─",
      whitespace = "  ",
    },
    
    -- Options for opening aerial in a floating win
    float = {
      border = "rounded",
      relative = "cursor",
      max_height = 0.9,
      min_height = { 8, 0.1 },
    },
    
    -- Options for the floating nav windows
    nav = {
      border = "rounded",
      max_height = 0.9,
      min_height = { 10, 0.1 },
      max_width = 0.5,
      min_width = { 0.2, 20 },
      win_opts = {
        cursorline = true,
        winblend = 10,
      },
    },
    
    lsp = {
      diagnostics_trigger_update = true,
      update_when_errors = true,
      update_delay = 300,
    },
    
    treesitter = {
      update_delay = 300,
    },
  },
  keys = {
    -- Main sidebar toggle (replaces old <leader>ao)
    { "<leader>xs", function() require("config.sidebar-layout").toggle_sidebar() end, desc = "Toggle Sidebar (Aerial + Trouble)" },
    
    -- Individual Aerial controls
    { "<leader>xa", "<cmd>AerialToggle!<CR>", desc = "Aerial Toggle" },
    { "<leader>xA", "<cmd>AerialNavToggle<CR>", desc = "Aerial Nav" },
    { "<leader>xan", "<cmd>AerialNext<CR>", desc = "Aerial Next" },
    { "<leader>xap", "<cmd>AerialPrev<CR>", desc = "Aerial Prev" },
  },
}

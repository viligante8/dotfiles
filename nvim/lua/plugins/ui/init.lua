-- lua/plugins/ui/init.lua
-- UI-related plugins (colorschemes, statusline, file trees, etc.)

return {
  -- Colorscheme
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
      vim.cmd.colorscheme('kanagawa')
    end,
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort = {
          sorter = 'case_sensitive',
        },
        view = {
          side = 'right',
          width = 50,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
        actions = {
          expand_all = {
            exclude = {
              '.git',
              'node_modules',
            },
          },
        },
      })
    end,
  },

  -- Better quickfix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = {
      'junegunn/fzf',
      'junegunn/fzf.vim',
    },
    config = function()
      require('bqf').setup({
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border = 'rounded',
        },
      })
    end,
  },

  -- FZF support
  {
    'junegunn/fzf',
    build = './install --bin',
  },
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
  },

  -- Which-key for keybinding hints
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk' },
        { '<A-t>', group = 'neo[t]est' },
        { '<C-q>', group = 'AI helper bot' },
        { '<C-q>n', group = '[n]ew chat' },
        { '<C-q>p', group = '[p]ut into chat' },
      },
    },
  },

  -- Icons
  {
    'nvim-tree/nvim-web-devicons',
    enabled = vim.g.have_nerd_font,
  },
}

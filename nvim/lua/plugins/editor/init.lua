-- lua/plugins/editor/init.lua
-- Editor enhancement plugins (telescope, treesitter, autopairs, etc.)

return {
  -- Telescope fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ['<c-enter>'] = 'to_fuzzy_refine',
              ['<c-a>'] = 'smart_add_to_qflist',
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      -- Enable telescope extensions
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- Telescope keymaps
      local builtin = require('telescope.builtin')
      local keymap = vim.keymap.set

      keymap('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      keymap('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      keymap('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      keymap('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      keymap('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      keymap('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      keymap('n', '<leader>st', builtin.git_files, { desc = '[S]earch gi[t] files' })
      keymap('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      keymap('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      keymap('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      keymap('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Fuzzy search in current buffer
      keymap('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Live grep in open files
      keymap('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[S]earch [/] in Open Files' })

      -- Search neovim config files
      keymap('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'json',
        'yaml',
        'tsx',
        'css',
        'python',
        'rust',
        'go',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup({})
      -- Integration with cmp
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  -- Comment toggling
  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  -- Indent detection
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Surround text objects
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end,
  },
}

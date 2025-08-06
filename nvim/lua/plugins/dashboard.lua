return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    local function ascii_clock()
      local time = os.date("%H:%M:%S")
      local digits = {
        ["0"] = {
          "███████",
          "██    ██",
          "██    ██",
          "██    ██",
          "███████"
        },
        ["1"] = {
          "    ██  ",
          "    ██  ",
          "    ██  ",
          "    ██  ",
          "    ██  "
        },
        ["2"] = {
          "███████",
          "     ██",
          "███████",
          "██     ",
          "███████"
        },
        ["3"] = {
          "███████",
          "     ██",
          "███████",
          "     ██",
          "███████"
        },
        ["4"] = {
          "██    ██",
          "██    ██",
          "████████",
          "      ██",
          "      ██"
        },
        ["5"] = {
          "███████",
          "██     ",
          "███████",
          "     ██",
          "███████"
        },
        ["6"] = {
          "███████",
          "██     ",
          "███████",
          "██    ██",
          "███████"
        },
        ["7"] = {
          "███████",
          "     ██",
          "     ██",
          "     ██",
          "     ██"
        },
        ["8"] = {
          "████████",
          "██    ██",
          "████████",
          "██    ██",
          "████████"
        },
        ["9"] = {
          "███████",
          "██    ██",
          "███████",
          "      ██",
          "███████"
        },
        [":"] = {
          "   ",
          " ██",
          "   ",
          " ██",
          "   "
        }
      }
      
      local lines = {"", "", "", "", ""}
      for i = 1, #time do
        local char = time:sub(i, i)
        local digit = digits[char]
        if digit then
          for j = 1, 5 do
            lines[j] = lines[j] .. digit[j] .. "  "
          end
        end
      end
      
      return lines
    end

    local function center_text(text, width)
      local padding = math.max(0, math.floor((width - #text) / 2))
      return string.rep(" ", padding) .. text
    end

    local function get_header()
      local clock_lines = ascii_clock()
      local header = { "", "" }
      
      -- Center clock
      for _, line in ipairs(clock_lines) do
        table.insert(header, center_text(line, 80))
      end
      
      table.insert(header, "")
      
      return header
    end

    local opts = {
      theme = "doom",
      config = {
        header = get_header(),
        center = {
          { icon = " ", desc = "Find File", key = "f", action = "Telescope find_files" },
          { icon = " ", desc = "Recent Files", key = "r", action = "Telescope oldfiles" },
          { icon = " ", desc = "Find Text", key = "g", action = "Telescope live_grep" },
          { icon = " ", desc = "New File", key = "n", action = "enew" },
          { icon = " ", desc = "Config", key = "c", action = "Telescope find_files cwd=~/.config/nvim" },
          { icon = " ", desc = "Dotfiles", key = "d", action = "Telescope find_files cwd=~/.dotfiles" },
          { icon = " ", desc = "Restore Session", key = "s", action = function() require("persistence").load() end },
          { icon = "󰒲 ", desc = "Lazy", key = "l", action = "Lazy" },
          { icon = " ", desc = "Mason", key = "m", action = "Mason" },
          { icon = " ", desc = "Quit", key = "q", action = "qa" },
        },
        footer = function()
          local date = os.date("Today is %A, %B %d, %Y")
          return { "", date }
        end,
      },
    }

    require("dashboard").setup(opts)
    
    -- Update clock every second
    local timer = vim.loop.new_timer()
    timer:start(1000, 1000, vim.schedule_wrap(function()
      if vim.bo.filetype == "dashboard" then
        opts.config.header = get_header()
        require("dashboard").setup(opts)
      end
    end))
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
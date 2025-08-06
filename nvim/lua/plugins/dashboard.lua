return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    local function ascii_clock()
      local time = os.date("%I:%M")
      local ampm = os.date("%p")
      local digits = {
        ["0"] = {
          "████████",
          "██    ██",
          "██    ██",
          "██    ██",
          "████████"
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
          "████████",
          "██    ██",
          "████████"
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
          "████████",
          "██    ██",
          "████████",
          "      ██",
          "████████"
        },
        [":"] = {
          "   ",
          " ██",
          "   ",
          " ██",
          "   "
        },
        ["A"] = {
          "████████",
          "██    ██",
          "████████",
          "██    ██",
          "██    ██"
        },
        ["P"] = {
          "████████",
          "██    ██",
          "████████",
          "██      ",
          "██      "
        },
        ["M"] = {
          "██    ██",
          "████████",
          "██ ██ ██",
          "██    ██",
          "██    ██"
        }
      }
      
      local full_time = time .. " " .. ampm
      local lines = {"", "", "", "", ""}
      for i = 1, #full_time do
        local char = full_time:sub(i, i)
        local digit = digits[char]
        if digit then
          for j = 1, 5 do
            lines[j] = lines[j] .. digit[j] .. "  "
          end
        elseif char == " " then
          for j = 1, 5 do
            lines[j] = lines[j] .. "      "
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
        vertical_center = true,
        header = get_header(),
        center = {
          { icon = " ", desc = "Find File", key = "f", action = function() require("telescope.builtin").find_files() end },
          { icon = " ", desc = "Recent Files", key = "r", action = function() require("telescope.builtin").oldfiles() end },
          { icon = " ", desc = "Find Text", key = "g", action = function() require("telescope.builtin").live_grep() end },
          { icon = " ", desc = "New File", key = "n", action = "enew" },
          { icon = " ", desc = "Config", key = "c", action = function() require("telescope.builtin").find_files({ cwd = "~/.config/nvim" }) end },
          { icon = " ", desc = "Dotfiles", key = "d", action = function() require("telescope.builtin").find_files({ cwd = "~/.dotfiles" }) end },
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
    

  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
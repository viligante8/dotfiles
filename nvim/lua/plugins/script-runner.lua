return {
  dir = "~/dev/personal/script-runner.nvim", -- Use local dev folder
  config = function()
    require('script-runner').setup({
      split_direction = "vertical",
      terminal_reuse = true,
      keymaps = {
        enabled = true,
        run_script = "<leader>trs",
        run_last = "<leader>trl",
        run_test = "<leader>trt",
        run_build = "<leader>trb",
        run_dev = "<leader>trd",
        run_package_commands = "<leader>trp",
      },
      window_size = 0.4
    })

    -- Add custom keymaps for debugging integration
    vim.keymap.set("n", "<leader>trd", function()
      require("dap-script-runner").debug_script()
    end, { desc = "Debug Script (with DAP)" })

    vim.keymap.set("n", "<leader>trD", function()
      require("dap-script-runner").debug_last_script()
    end, { desc = "Debug Last Script" })

    vim.keymap.set("n", "<leader>tra", function()
      require("dap-script-runner").attach_to_debug()
    end, { desc = "Attach to Debug Process" })
  end,
}


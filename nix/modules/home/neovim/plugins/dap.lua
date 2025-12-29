-- Debug Adapter Protocol plugins
{
  {
    "mfussenegger/nvim-dap",
    dir = plugin_path("nvim-dap"),
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F4>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F3>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F2>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<space>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
      { "<space>gb", function() require("dap").run_to_cursor() end, desc = "Debug: Run to cursor" },
      { "<space>?", function() require("dapui").eval(nil, { enter = true }) end, desc = "Debug: Eval under cursor" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug: Step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: Step out" },
      { "<leader>dr", function() require("dap").restart() end, desc = "Debug: Restart" },
      { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, desc = "Debug: Eval" },
    },
    dependencies = {
      { "rcarriga/nvim-dap-ui", dir = plugin_path("nvim-dap-ui") },
      { "theHamsta/nvim-dap-virtual-text", dir = plugin_path("nvim-dap-virtual-text") },
      { "nvim-neotest/nvim-nio", dir = plugin_path("nvim-nio") },
      { "leoluz/nvim-dap-go", dir = plugin_path("nvim-dap-go") },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("nvim-dap-virtual-text").setup({})
      require("dap-go").setup()

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      -- Open/close UI automatically
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- TypeScript/JavaScript DAP configuration
      if js_debug_path ~= "" then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = { js_debug_path .. "/src/dapDebugServer.js", "${port}" },
          },
        }

        for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
          dap.configurations[lang] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
},

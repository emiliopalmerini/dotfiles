return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"

            require("dapui").setup()
            require("dap-go").setup()

            require("nvim-dap-virtual-text").setup {
                -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
                display_callback = function(variable)
                    local name = string.lower(variable.name)
                    local value = string.lower(variable.value)
                    if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
                        return "*****"
                    end

                    if #variable.value > 15 then
                        return " " .. string.sub(variable.value, 1, 15) .. "... "
                    end

                    return " " .. variable.value
                end,
            }

            -- Handled by nvim-dap-go
            -- dap.adapters.go = {
            --   type = "server",
            --   port = "${port}",
            --   executable = {
            --     command = "dlv",
            --     args = { "dap", "-l", "127.0.0.1:${port}" },
            --   },
            -- }

            local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
            if elixir_ls_debugger ~= "" then
                dap.adapters.mix_task = {
                    type = "executable",
                    command = elixir_ls_debugger,
                }

                dap.configurations.elixir = {
                    {
                        type = "mix_task",
                        name = "phoenix server",
                        task = "phx.server",
                        request = "launch",
                        projectDir = "${workspaceFolder}",
                        exitAfterTaskReturns = false,
                        debugAutoInterpretAllModules = false,
                    },
                }
            end

            dap.adapters.coreclr = {
                type = 'executable',
                command = '/usr/local/bin/netcoredbg/netcoredbg',
                args = { '--interpreter=vscode' }
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                },
            }

            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint, { desc = "Toggle a breakpoint at the current line" })
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor, { desc = "Run the program to the cursor position" })

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end, { desc = "Evaluate the variable under the cursor and show in a popup" })

            vim.keymap.set("n", "<F1>", dap.continue, { desc = "Continue execution or start debugging" })
            vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step into the function call or statement" })
            vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step over the function call or statement" })
            vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step out of the current function" })
            vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Step back to the previous statement" })
            vim.keymap.set("n", "<F13>", dap.restart, { desc = "Restart the current debugging session" })

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}

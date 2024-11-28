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

            dap.adapters.coreclr = {
                type = 'executable',
                command = '',
                args = { '--interpreter=vscode' }
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "launch",
                    program = function()
                        local project_dir = vim.fn.getcwd()

                        local csproj_file = project_dir .. "/" .. vim.fn.glob("*.csproj")
                        local file = io.open(csproj_file, "r")
                        if not file then
                            return vim.fn.input(
                            'File .csproj non trovato. Specifica la versione del framework (es. net5.0): ', "", 'file')
                        end

                        local content = file:read("*a")
                        file:close()

                        local version = content:match("<TargetFramework>(net[%d%.]+)</TargetFramework>")
                        if not version then
                            return vim.fn.input(
                            'Impossibile determinare la versione dal file .csproj. Specifica la versione (es. net5.0): ',
                                "", 'file')
                        end

                        local build_config = "Debug"                                          -- Puoi cambiarlo in "Release" se necessario
                        local build_output_dir = project_dir ..
                        "/bin/" .. build_config .. "/" .. version                             -- Usa la versione corretta per il tuo progetto .NET

                        local files = vim.fn.glob(build_output_dir .. "/*.dll")
                        if files == "" then
                            return vim.fn.input('Path to dll: ', build_output_dir, 'file')
                        else
                            return files
                        end
                    end,
                },
            }

            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F13>", dap.restart)

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

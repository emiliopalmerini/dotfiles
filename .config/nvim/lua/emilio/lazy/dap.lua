return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-telescope/telescope-dap.nvim",
    },
    config = function ()
        --require('dap').setup({})

        vim.keymap.set('n', '<F1>', ":lua require'dap'.continue()<CR>", {buffer=0})
        vim.keymap.set('n', '<F2>', ":lua require'dap'.step_over()<CR>", {buffer=0})
        vim.keymap.set('n', '<F3>', ":lua require'dap'.step_into()<CR>", {buffer=0})
        vim.keymap.set('n', '<F3>', ":lua require'dap'.step_out()<CR>", {buffer=0})
        vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", {buffer=0})
        vim.keymap.set('n', '<leader>B', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", {buffer=0})
        vim.keymap.set('n', '<leader>lp', ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", {buffer=0})
        vim.keymap.set('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", {buffer=0})

        local dap = require('dap')
        dap.adapters.delve = {
            type = 'server',
            port = '${port}',
            executable = {
                command = 'dlv',
                args = {'dap', '-l', '127.0.0.1:${port}'},
            }
        }

        -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
        dap.configurations.go = {
            {
                type = "delve",
                name = "Debug",
                request = "launch",
                program = "${file}"
            },
            {
                type = "delve",
                name = "Debug test", -- configuration for debugging test files
                request = "launch",
                mode = "test",
                program = "${file}"
            },
            -- works with go.mod packages and sub packages
            {
                type = "delve",
                name = "Debug test (go.mod)",
                request = "launch",
                mode = "test",
                program = "./${relativeFileDirname}"
            }
        }
    end
}

return {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
        {
            "<leader>ts",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>tl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>tL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>tQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },

        vim.keymap.set('n', '<leader>e', "<cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>",
            { noremap = true, silent = true, desc = "Float diagnostic" }),

        vim.keymap.set('n', '<leader>tt', "<cmd>Trouble diagnostics toggle<cr>",
            { noremap = true, silent = true, desc = "Toggle diagnostics" }),

        vim.keymap.set('n', '<leader>tT', "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            { noremap = true, silent = true, desc = "Toggle buffer diagnostics" }),
    },
}

local configs = require('nvim-treesitter.configs')

configs.setup {
    ensure_installed = {},
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },

    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = { query = "@class.inner", desc = "Select inner class" },
                ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select scope" },
            },
            selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@function.outer'] = 'V',
                ['@class.outer'] = '<c-v>',
            },
            include_surrounding_whitespace = true,
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
                ["]o"] = "@loop.*",
                ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
                ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
            goto_next = { ["]d"] = "@conditional.outer" },
            goto_previous = { ["[d"] = "@conditional.outer" },
        },
        lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dF"] = "@class.outer",
            },
        },
    },
}

-- Repeatable movements with ; and ,
local ok, ts_repeat_move = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')
if ok then
  vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next, { desc = 'Repeat last movement forward' })
  vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous, { desc = 'Repeat last movement backward' })
  vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true, desc = 'Repeatable f (find char) forward' })
  vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true, desc = 'Repeatable F (find char) backward' })
  vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true, desc = 'Repeatable t (till char) forward' })
  vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true, desc = 'Repeatable T (till char) backward' })
end

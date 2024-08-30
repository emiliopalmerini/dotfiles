vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local set = vim.keymap.set

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

 set("n", "J", "mzJ`z")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

-- greatest remap ever
set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])

set({ "n", "v" }, "<leader>d", [["_d]])

set("n", "Q", "<nop>")
set("n", "<leader>f", vim.lsp.buf.format)

set("n", "<C-N>", "<cmd>cnext<CR>zz")
set("n", "<C-J>", "<cmd>cprev<CR>zz")
set("n", "<leader>k", "<cmd>lnext<CR>zz")
set("n", "<leader>j", "<cmd>lprev<CR>zz")

set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
set("n", "<leader>tf", ":e temp.txt<Cr>")

set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

set("n", "<left>", "<c-w>5<")
set("n", "<right>", "<c-w>5>")
set("n", "<up>", "<C-W>+")
set("n", "<down>", "<C-W>-")

set('n', '<C-s>', ':so ~/dotfiles/.config/nvim/lua/emilio/init.lua<CR>', { desc = '' })
set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local set = vim.keymap.set

--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

set("n", "J", "mzJ`z", { desc = "Join line with the next one and keep the cursor in place" })
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half a page and center the cursor" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half a page and center the cursor" })
set("n", "n", "nzzzv", { desc = "Move to next search result and center the cursor" })
set("n", "N", "Nzzzv", { desc = "Move to previous search result and center the cursor" })

-- greatest remap ever
set("x", "<leader>p", [["_dP]], { desc = "Paste over selected text without yanking it" })

-- next greatest remap ever : asbjornHaland
set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
set("n", "<leader>Y", [["+Y]], { desc = "Yank the entire line to system clipboard" })

set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete text without yanking it" })

set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format the current buffer with LSP" })

set("n", "<C-N>", "<cmd>cnext<CR>zz", { desc = "Go to next item in quickfix list and center the cursor" })
set("n", "<C-J>", "<cmd>cprev<CR>zz", { desc = "Go to previous item in quickfix list and center the cursor" })
set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Go to next item in location list and center the cursor" })
set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Go to previous item in location list and center the cursor" })

set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace the word under cursor in the entire file" })
set("n", "<leader>tf", ":e temp.txt<Cr>", { desc = "Open a temporary file named 'temp.txt'" })

set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

set("n", "<left>", "<c-w>5<", { desc = "Resize window: shrink width by 5 columns" })
set("n", "<right>", "<c-w>5>", { desc = "Resize window: increase width by 5 columns" })
set("n", "<up>", "<C-W>+", { desc = "Resize window: increase height by one row" })
set("n", "<down>", "<C-W>-", { desc = "Resize window: decrease height by one row" })

set('n', '<C-s>', function()
    vim.cmd("so")
end, { desc = 'Source current file' })

set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })


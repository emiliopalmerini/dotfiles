-- Execute lua
vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader>X", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Navigation with centering
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below, keep cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Clipboard operations
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete to black hole register" })

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Quickfix and location list
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Prev quickfix item" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Prev location list item" })

-- Search and replace
vim.keymap.set(
	"n",
	"<leader>rs",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace: Search/replace word under cursor" }
)
vim.keymap.set("n", "<leader>tf", ":e temp.txt<Cr>", { desc = "Toggle: Open temp.txt" })

-- Window resizing
vim.keymap.set("n", "<left>", "<c-w>5<", { desc = "Resize window 5 cols left" })
vim.keymap.set("n", "<right>", "<c-w>5>", { desc = "Resize window 5 cols right" })
vim.keymap.set("n", "<up>", "<C-W>+", { desc = "Increase window height" })
vim.keymap.set("n", "<down>", "<C-W>-", { desc = "Decrease window height" })

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Terminal
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", ",st", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()
end, { desc = "Split bottom terminal (12 lines)" })

-- vim-tmux-navigator
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { noremap = true, silent = true, desc = "Tmux: Move left" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { noremap = true, silent = true, desc = "Tmux: Move down" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { noremap = true, silent = true, desc = "Tmux: Move up" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { noremap = true, silent = true, desc = "Tmux: Move right" })
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { noremap = true, silent = true, desc = "Tmux: Previous pane" })

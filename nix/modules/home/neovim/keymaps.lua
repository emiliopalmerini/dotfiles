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

-- [F]ind group - Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find: Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find: Grep (live)" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find: Word under cursor" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find: Diagnostics" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find: Help" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find: Keymaps" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Find: Resume" })
vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "Find: Select Telescope" })
vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find: TODOs" })
vim.keymap.set("n", "<leader>fi", builtin.git_files, { desc = "Find: Git files" })
vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Find: Recent files" })

-- [B]uffer group
vim.keymap.set("n", "<leader>bl", builtin.buffers, { desc = "Buffer: List" })

-- Terminal
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", ",st", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()
end, { desc = "Split bottom terminal (12 lines)" })

-- Plugins
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })

-- [H]arpoon group
do
	local ok, harpoon = pcall(require, "harpoon")
	if ok then
		harpoon:setup()
		vim.keymap.set("n", "<leader>h", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Quick menu" })
		vim.keymap.set("n", "<leader>H", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })
		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })
		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })
		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Previous" })
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Next" })
	end
end

-- [G]it group
vim.keymap.set("n", "<leader>gf", vim.cmd.Git, { desc = "Git: Fugitive" })

-- [T]rouble group (lazy-loaded)
vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble: Diagnostics" })
vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble: Buffer diagnostics" })
vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble: Location list" })
vim.keymap.set("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble: Quickfix list" })

-- [Z]en group (lazy-loaded on first use)
vim.keymap.set("n", "<leader>zz", function()
	require("zen-mode").setup({
		window = {
			width = 100,
			options = {},
		},
	})
	require("zen-mode").toggle()
	vim.wo.wrap = true
	vim.wo.number = true
	vim.wo.rnu = true
end, { desc = "Zen: Mode (width 100)" })

vim.keymap.set("n", "<leader>zZ", function()
	require("zen-mode").setup({
		window = {
			width = 80,
			options = {},
		},
	})
	require("zen-mode").toggle()
	vim.wo.wrap = false
	vim.wo.number = false
	vim.wo.rnu = false
	vim.opt.colorcolumn = "0"
end, { desc = "Zen: Mode (width 80, minimal)" })

-- [R]efactor group (lazy-loaded on first use)
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
	require("telescope").extensions.refactoring.refactors()
end, { desc = "Refactor: Select action" })

-- [D]ebug group (lazy-loaded on first use)
local function with_dap(fn)
	return function()
		local dap = require("dap")
		fn(dap)
	end
end

vim.keymap.set("n", "<F5>", with_dap(function(dap) dap.continue() end), { desc = "Debug: Continue" })
vim.keymap.set("n", "<F4>", with_dap(function(dap) dap.step_over() end), { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F3>", with_dap(function(dap) dap.step_into() end), { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F2>", with_dap(function(dap) dap.step_out() end), { desc = "Debug: Step Out" })

vim.keymap.set("n", "<space>b", with_dap(function(dap) dap.toggle_breakpoint() end), { desc = "Debug: Toggle breakpoint" })
vim.keymap.set("n", "<space>gb", with_dap(function(dap) dap.run_to_cursor() end), { desc = "Debug: Run to cursor" })
vim.keymap.set("n", "<space>?", function()
	require("dapui").eval(nil, { enter = true })
end, { desc = "Debug: Eval under cursor" })

vim.keymap.set("n", "<leader>db", with_dap(function(dap) dap.toggle_breakpoint() end), { desc = "Debug: Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", with_dap(function(dap) dap.continue() end), { desc = "Debug: Continue" })
vim.keymap.set("n", "<leader>do", with_dap(function(dap) dap.step_over() end), { desc = "Debug: Step over" })
vim.keymap.set("n", "<leader>di", with_dap(function(dap) dap.step_into() end), { desc = "Debug: Step into" })
vim.keymap.set("n", "<leader>dO", with_dap(function(dap) dap.step_out() end), { desc = "Debug: Step out" })
vim.keymap.set("n", "<leader>dr", with_dap(function(dap) dap.restart() end), { desc = "Debug: Restart" })
vim.keymap.set("n", "<leader>de", function()
	require("dapui").eval(nil, { enter = true })
end, { desc = "Debug: Eval" })

-- vim-tmux-navigator
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { noremap = true, silent = true, desc = "Tmux: Move left" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { noremap = true, silent = true, desc = "Tmux: Move down" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { noremap = true, silent = true, desc = "Tmux: Move up" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { noremap = true, silent = true, desc = "Tmux: Move right" })
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { noremap = true, silent = true, desc = "Tmux: Previous pane" })

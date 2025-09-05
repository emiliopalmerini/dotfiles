vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.signcolumn = "yes"
vim.opt.shada = { "'10", "<0", "s10", "h" }

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.smartindent = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.updatetime = 50
vim.opt.conceallevel = 0

vim.opt.showmode = false
vim.opt.scrolloff = 8

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below, keep cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over without yanking" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole register" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

vim.keymap.set("n", "[N", "<cmd>cnext<CR>zz", { desc = "Next quickfix item (center)" })
vim.keymap.set("n", "]J", "<cmd>cprev<CR>zz", { desc = "Prev quickfix item (center)" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item (center)" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev location list item (center)" })

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Search/replace word under cursor" }
)
vim.keymap.set("n", "<leader>tf", ":e temp.txt<Cr>", { desc = "Open temp.txt" })

vim.keymap.set("n", "<left>", "<c-w>5<", { desc = "Resize window 5 cols left" })
vim.keymap.set("n", "<right>", "<c-w>5>", { desc = "Resize window 5 cols right" })
vim.keymap.set("n", "<up>", "<C-W>+", { desc = "Increase window height" })
vim.keymap.set("n", "<down>", "<C-W>-", { desc = "Decrease window height" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>fi", builtin.git_files, { desc = "[F]ind G[i]t Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind with [G]rep" })
vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "[F]ind [T]ODOs" })

local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		set.number = false
		set.relativenumber = false
		set.scrolloff = 0

		vim.bo.filetype = "terminal"
	end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", ",st", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()
end, { desc = "Split bottom terminal (12 lines)" })

-- Plugins keymap

--undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })

-- harpoon (guarded)
do
	local ok, harpoon = pcall(require, "harpoon")
	if ok then
		harpoon:setup()
		vim.keymap.set("n", "<leader>hv", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle quick menu" })
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: Go to file 1" })
		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: Go to file 2" })
		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: Go to file 3" })
		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: Go to file 4" })
		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Previous mark" })
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Next mark" })
	end
end

--fugitive
vim.keymap.set("n", "<leader>gf", vim.cmd.Git, { desc = "Git: Open Fugitive" })
local emilio_fugitive = vim.api.nvim_create_augroup("emilio_fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
	group = emilio_fugitive,
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local opts = { buffer = bufnr, remap = false }
		vim.keymap.set("n", "<leader>gp", function()
			vim.cmd.Git("push")
		end, vim.tbl_extend("force", opts, { desc = "Git: Push" }))

		vim.keymap.set("n", "<leader>gf", function()
			vim.cmd.Git("push --force")
		end, vim.tbl_extend("force", opts, { desc = "Git: Force push" }))

		-- rebase always
		vim.keymap.set("n", "<leader>gP", function()
			vim.cmd.Git({ "pull" })
		end, vim.tbl_extend("force", opts, { desc = "Git: Pull (rebase)" }))

		vim.keymap.set(
			"n",
			"<leader>gt",
			":Git push -u origin ",
			vim.tbl_extend("force", opts, { desc = "Git: Push set upstream" })
		)
	end,
})

-- trouble (guarded)
pcall(function()
	require("trouble").setup()
end)
vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", {
	desc = "Diagnostics (Trouble)",
})

vim.keymap.set("n", "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
	desc = "Buffer Diagnostics (Trouble)",
})

vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", {
	desc = "Location List (Trouble)",
})

vim.keymap.set("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", {
	desc = "Quickfix List (Trouble)",
})

--zen
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
end, { desc = "Zen Mode (width 100)" })

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
end, { desc = "Zen Mode (width 80)" })

--refactoring
vim.keymap.set({ "n", "x" }, "<leader>rr", function()
	require("telescope").extensions.refactoring.refactors()
end, { desc = "Refactor: Select action" })

-- vim-tmux-navigator
local opts = { noremap = true, silent = true }
-- disabilita le default mappings
vim.g.tmux_navigator_no_mappings = 1

-- mappe in Lua verso i comandi VimL che il plugin fornisce
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { noremap = true, silent = true, desc = "Tmux: Move left" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { noremap = true, silent = true, desc = "Tmux: Move down" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { noremap = true, silent = true, desc = "Tmux: Move up" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { noremap = true, silent = true, desc = "Tmux: Move right" })
vim.keymap.set(
	"n",
	"<C-\\>",
	"<cmd>TmuxNavigatePrevious<cr>",
	{ noremap = true, silent = true, desc = "Tmux: Previous pane" }
)

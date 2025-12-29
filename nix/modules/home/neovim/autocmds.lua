vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrolloff = 0
		vim.bo.filetype = "terminal"
	end,
})

-- Lazy-load obsidian.nvim on markdown files in vault directories
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	once = true,
	callback = function()
		local cwd = vim.fn.getcwd()
		-- Only load if in an obsidian vault (has .obsidian folder)
		if vim.fn.isdirectory(cwd .. "/.obsidian") == 1 then
			pcall(vim.cmd, "packadd obsidian.nvim")
		end
	end,
})

local emilio_fugitive = vim.api.nvim_create_augroup("emilio_fugitive", {})

vim.api.nvim_create_autocmd("BufWinEnter", {
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

		vim.keymap.set("n", "<leader>gF", function()
			vim.cmd.Git("push --force")
		end, vim.tbl_extend("force", opts, { desc = "Git: Force push" }))

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

local ok, wk = pcall(require, "which-key")
if not ok then
	return
end

wk.setup({})

-- Register mnemonic groups for discoverability (which-key v3 spec)
require("which-key").add({
	{ "<leader>f", group = "[F]ind", mode = "n" }, -- Telescope search operations
	{ "<leader>g", group = "[G]it", mode = "n" }, -- Git (Fugitive/Gitsigns)
	{ "<leader>c", group = "[C]ode", mode = "n" }, -- LSP code actions
	{ "<leader>b", group = "[B]uffer", mode = "n" }, -- Buffer operations
	{ "<leader>t", group = "[T]rouble/Toggle", mode = "n" }, -- Trouble & toggles
	{ "<leader>h", group = "[H]arpoon", mode = "n" }, -- Harpoon navigation
	{ "<leader>z", group = "[Z]en", mode = "n" }, -- Zen-mode
	{ "<leader>r", group = "[R]efactor/Replace", mode = "n" }, -- Refactoring & replace
	{ "<leader>d", group = "[D]ebug", mode = "n" }, -- DAP debugging
})

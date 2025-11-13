local ok, wk = pcall(require, "which-key")
if not ok then
	return
end

wk.setup({})

-- Register common groups for discoverability (which-key v3 spec)
require("which-key").add({
	{ "<leader>f", group = "[F]ind", mode = "n" }, -- Telescope
	{ "<leader>g", group = "[G]it", mode = "n" }, -- Git (Fugitive/Gitsigns)
	{ "<leader>t", group = "[T]rouble", mode = "n" }, -- Trouble
	{ "<leader>h", group = "[H]arpoon", mode = "n" }, -- Harpoon
	{ "<leader>z", group = "[Z]en", mode = "n" }, -- Zen-mode
	{ "<space>c", group = "[C]ode", mode = "n" }, -- LSP code actions/rename
	{ "<leader>d", group = "[D]ebug", mode = "n" }, -- DAP
})

local ok, wk = pcall(require, 'which-key')
if not ok then return end

wk.setup({})

-- Register common groups for discoverability
wk.register({
  ["<leader>f"] = { name = "[F]ind" },        -- Telescope
  ["<leader>g"] = { name = "[G]it" },         -- Git (Fugitive/Gitsigns)
  ["<leader>t"] = { name = "[T]rouble" },     -- Trouble
  ["<leader>h"] = { name = "[H]arpoon" },     -- Harpoon
  ["<leader>z"] = { name = "[Z]en" },         -- Zen-mode
  ["<space>c"] = { name = "[C]ode" },         -- LSP code actions/rename
  ["<leader>d"] = { name = "[D]ebug" },       -- DAP
}, { mode = 'n' })

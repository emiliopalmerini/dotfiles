-- Lualine
require("lualine").setup({
    icons_enabled = true,
    theme = 'onedark',
})

-- Colorscheme
vim.cmd("colorscheme tokyonight-storm")

-- Comment
require("Comment").setup()

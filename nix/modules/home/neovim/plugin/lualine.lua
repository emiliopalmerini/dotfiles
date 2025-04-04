local my_theme = require("lualine.themes.modus-vivendi")

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = my_theme,
	},
})

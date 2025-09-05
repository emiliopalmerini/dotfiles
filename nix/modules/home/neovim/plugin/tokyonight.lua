-- tokyonight theme configuration and highlight overrides
-- Goal: current line number orange, others less intense blue

local function compute_colors()
	local colors_ok, colors = pcall(function()
		return require("tokyonight.colors").setup()
	end)
	local util_ok, util = pcall(require, "tokyonight.util")

	local orange = (colors_ok and colors.orange) or "#ff9e64"
	local base_blue = (colors_ok and (colors.blue or colors.fg)) or "#7aa2f7"

	local dim_blue = base_blue
	if util_ok then
		-- Darken the blue to make it less intense
		local ok2, v = pcall(util.darken, base_blue, 0.5)
		if ok2 and v then
			dim_blue = v
		end
	else
		-- Fallback: handpicked softer blue if util isn't available
		dim_blue = "#4f669b"
	end

	return orange, dim_blue
end

local function apply_line_nr_highlights()
	local orange, dim_blue = compute_colors()
	local set_hl = vim.api.nvim_set_hl
	set_hl(0, "CursorLineNr", { fg = orange, bold = true })
	set_hl(0, "LineNr", { fg = dim_blue })
	set_hl(0, "LineNrAbove", { fg = dim_blue })
	set_hl(0, "LineNrBelow", { fg = dim_blue })
end

-- Ensure highlights are applied after the colorscheme sets its defaults
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "tokyonight*",
	callback = function()
		pcall(apply_line_nr_highlights)
	end,
})

-- Configure tokyonight according to upstream docs and also keep the ColorScheme
-- override to guarantee our changes stick even if other plugins tweak highlights
pcall(function()
	local tn = require("tokyonight")
	tn.setup({
		cache = false,
		on_highlights = function(hl, c)
			local orange, dim_blue = compute_colors()
			hl.CursorLineNr = { fg = orange, bold = true }
			hl.LineNr = { fg = dim_blue }
			hl.LineNrAbove = { fg = dim_blue }
			hl.LineNrBelow = { fg = dim_blue }
		end,
	})
end)

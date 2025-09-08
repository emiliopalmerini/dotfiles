-- Heirline: statusline + winbar minimale

local ok, heirline = pcall(require, "heirline")
if not ok then
	return
end
local conditions = require("heirline.conditions")
local utils_ok, utils = pcall(require, "heirline.utils")
if not utils_ok then
	return
end

local Space, Align = { provider = " " }, { provider = "%=" }
local function get_hl(name, fb)
	local ok, h = pcall(utils.get_highlight, name)
	return ok and h or (fb or {})
end
local function setup_colors()
	return {
		red = get_hl("DiagnosticError", { fg = 160 }).fg,
		green = get_hl("String", { fg = 114 }).fg,
		blue = get_hl("Function", { fg = 75 }).fg,
		purple = get_hl("Statement", { fg = 141 }).fg,
		gray = get_hl("NonText", { fg = 244 }).fg,
	}
end

-- MODE
local Mode = {
	static = {
		names = { n = "N", i = "I", v = "V", V = "V_", ["\22"] = "^V", c = "C", R = "R", t = "T" },
		colors = {
			n = "red",
			i = "green",
			v = "purple",
			V = "purple",
			["\22"] = "purple",
			c = "blue",
			R = "blue",
			t = "green",
		},
	},
	init = function(self)
		self.mode = vim.fn.mode(1)
	end,
	provider = function(self)
		return " " .. (self.names[self.mode] or self.mode)
	end,
	hl = function(self)
		return { fg = self.colors[self.mode] or "blue", bold = true }
	end,
	update = { "ModeChanged" },
}

-- FILE
local File = {
	init = function(self)
		local name = vim.api.nvim_buf_get_name(0)
		self.name = name ~= "" and vim.fn.fnamemodify(name, ":.") or "[No Name]"
	end,
	provider = function(self)
		return self.name
	end,
	hl = function()
		return { fg = get_hl("Directory", { fg = 110 }).fg }
	end,
}

-- GIT
local Git = {
	condition = conditions.is_git_repo,
	init = function(self)
		self.s = vim.b.gitsigns_status_dict or {}
	end,
	provider = function(self)
		local s = self.s
		if not s.head then
			return ""
		end
		local parts = { " " .. s.head }
		if s.added and s.added > 0 then
			table.insert(parts, " " .. s.added)
		end
		if s.changed and s.changed > 0 then
			table.insert(parts, " " .. s.changed)
		end
		if s.removed and s.removed > 0 then
			table.insert(parts, " " .. s.removed)
		end
		return " " .. table.concat(parts, " ") .. " "
	end,
	hl = { fg = "gray" },
}

-- MACRO REC
local Recording = {
	condition = function()
		return vim.fn.reg_recording() ~= ""
	end,
	provider = function()
		return " " .. vim.fn.reg_recording()
	end,
	hl = { fg = "purple", bold = true },
	update = { "RecordingEnter", "RecordingLeave" },
}

-- SEARCH COUNT
local SearchCount = {
	condition = function()
		return vim.v.hlsearch == 1
	end,
	init = function(self)
		self.sc = vim.fn.searchcount({ maxcount = 999, timeout = 200 })
	end,
	provider = function(self)
		local sc = self.sc
		if sc.total and sc.total > 0 then
			return string.format(" %d/%d", sc.current or 0, sc.total)
		end
	end,
	update = { "CmdlineEnter", "CmdlineLeave", "SearchWrapped", "CursorMoved" },
	hl = { fg = "purple" },
}

-- ENCODING
local Encoding = {
	provider = function()
		local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
		return string.upper(enc)
	end,
	hl = { fg = "gray" },
}

-- STATUSLINE
local Statusline = {
	Mode,
	Space,
	File,
	Space,
	Git,
	Align,
	Recording,
	Space,
	SearchCount,
	Space,
	Encoding,
}

-- -- NAVIC (breadcrumbs nel winbar)
-- local Navic = {
-- 	condition = function()
-- 		return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
-- 	end,
-- 	provider = function()
-- 		return require("nvim-navic").get_location({ highlight = true })
-- 	end,
-- }
--
-- local Winbar = { File, Space, Navic }

-- Setup + colori dinamici
vim.api.nvim_create_augroup("HeirlineMinimalColors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = "HeirlineMinimalColors",
	callback = function()
		require("heirline").load_colors(setup_colors())
	end,
})

heirline.setup({
	statusline = Statusline,
	opts = { colors = setup_colors },
})

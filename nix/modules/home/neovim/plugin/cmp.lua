ls = require("luasnip")
-- TODO: Think about `locally_jumpable`, etc.
-- Might be nice to send PR to luasnip to use filters instead for these functions ;)

vim.snippet.expand = ls.lsp_expand

local ls = require("luasnip")

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
	filter = filter or {}
	filter.direction = filter.direction or 1

	if filter.direction == 1 then
		return ls.expand_or_jumpable()
	else
		return ls.jumpable(filter.direction)
	end
end

-- ls.add_snippets("nix", {
-- 	ls.snippet(
-- 		"nixmodule",
-- 		[[
-- { lib, config, ... }:
--
-- with lib;
-- let
--   cfg = config.${1:MODULE};
-- in
-- {
--   options.${1:MODULE} = {
--     enable = mkEnableOption "Enable ${1:MODULE} module";
--   };
--
--   config = mkIf cfg.enable {
--     ${0}
--   };
-- }
-- ]]
-- 	),
-- })

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
	if direction == 1 then
		if ls.expandable() then
			return ls.expand_or_jump()
		else
			return ls.jumpable(1) and ls.jump(1)
		end
	else
		return ls.jumpable(-1) and ls.jump(-1)
	end
end

vim.snippet.stop = ls.unlink_current

-- ================================================
--      My Configuration
-- ================================================
ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	override_builtin = true,
})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { silent = true })
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

local lspkind = require("lspkind")
lspkind.init({
	symbol_map = {},
})

-- cmp

require("luasnip.loaders.from_vscode").load({})

local kind_formatter = lspkind.cmp_format({
	mode = "symbol_text",
	menu = {
		buffer = "[buf]",
		nvim_lsp = "[LSP]",
		nvim_lua = "[api]",
		path = "[path]",
		luasnip = "[snip]",
		gh_issues = "[issues]",
		eruby = "[erb]",
	},
})

-- Add tailwindcss-colorizer-cmp as a formatting source
-- require("tailwindcss-colorizer-cmp").setup {
--   color_square_width = 2,
-- }
--
local cmp = require("cmp")

cmp.setup({
	experimental = {
		ghost_text = false,
	},

	sources = {
		{
			name = "lazydev",
			-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
			group_index = 0,
		},
		{ name = "luasnip", option = { use_show_condition = false } },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),
	},

	-- Enable luasnip to handle snippet expansion for nvim-cmp
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},

	formatting = {
		fields = { "abbr", "kind", "menu" },
		expandable_indicator = true,
		format = function(entry, vim_item)
			-- Lspkind setup for icons
			vim_item = kind_formatter(entry, vim_item)

			-- Tailwind colorizer setup
			-- vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

			return vim_item
		end,
	},

	sorting = {
		priority_weight = 2,
		comparators = {
			-- Below is the default comparitor list and order for nvim-cmp
			cmp.config.compare.offset,
			-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	window = {
		-- TODO: I don't like this at all for completion window, it takes up way too much space.
		--  However, I think the docs one could be OK, but I need to fix the highlights for it
		--
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
})

-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	},
})

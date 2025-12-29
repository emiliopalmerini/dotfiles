local conform = require("conform")
local prefer_prettier = (vim.g.prefer_prettier == true)
local has_prettierd = (vim.fn.executable("prettierd") == 1)
local js_formatters = nil
if prefer_prettier then
	js_formatters = has_prettierd and { "prettierd", "prettier", "biome" } or { "prettier", "biome" }
else
	js_formatters = has_prettierd and { "biome", "prettierd", "prettier" } or { "biome", "prettier" }
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixpkgs-fmt" },
		python = { "isort", "black" },
		javascript = js_formatters,
		javascriptreact = js_formatters,
		typescript = js_formatters,
		typescriptreact = js_formatters,
		json = js_formatters,
		yaml = has_prettierd and { "prettierd", "prettier" } or { "prettier" },
		go = { "gofumpt", "gofmt" },
		proto = { "buf" },
		cs = { "csharpier" },
	},
	formatters = {
		["nixpkgs-fmt"] = {
			command = "nixpkgs-fmt",
			stdin = true,
		},
		csharpier = {
			command = "csharpier",
			args = { "format", "--write-stdout" },
			stdin = true,
		},
		prettier = {
			prepend_args = { "--trailing-comma", "none" },
		},
		prettierd = {
			prepend_args = { "--trailing-comma", "none" },
		},
		injected = {
			options = {
				ignore_errors = false,
				lang_to_formatters = {
					sql = { "sleek" },
				},
			},
		},
	},
})

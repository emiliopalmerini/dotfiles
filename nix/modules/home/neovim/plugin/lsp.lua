require("neodev").setup({})

local capabilities
if pcall(require, "cmp_nvim_lsp") then
	capabilities = require("cmp_nvim_lsp").default_capabilities()
end

local lspconfig = require("lspconfig")
local omnisharp_path = vim.fn.exepath("OmniSharp")
if omnisharp_path == "" then
	omnisharp_path = vim.fn.exepath("omnisharp-roslyn")
end

-- Aggiungiamo anche omnisharp alla lista dei server
local servers = {
	ts_ls = true,
	gopls = {
		settings = {
			gopls = {
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},
	lua_ls = {
		server_capabilities = {
			semanticTokensProvider = vim.NIL,
		},
	},
	intelephense = true,
	nil_ls = {
		settings = {
			["nil"] = {
				formatting = {
					command = { "nixpkgs-fmt" },
				},
				nix = {
					flake = {
						autoEvalInputs = true,
					},
				},
			},
		},
	},
	omnisharp = {
		cmd = {
			omnisharp_path,
			"--languageserver",
			"--hostPID",
			tostring(vim.fn.getpid()),
		},
		settings = {
			omnisharp = {
				useModernNet = true,
				enableEditorconfigSupport = true,
				organizeImportsOnFormat = true,
			},
		},
	},
}

-- Configurazione diretta dei server LSP senza Mason
for name, config in pairs(servers) do
	if config == true then
		config = {}
	end
	config = vim.tbl_deep_extend("force", {}, {
		capabilities = capabilities,
	}, config)
	lspconfig[name].setup(config)
end

local disable_semantic_tokens = {
	lua = true,
}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
		local settings = servers[client.name]
		if type(settings) ~= "table" then
			settings = {}
		end
		local builtin = require("telescope.builtin")
		vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
		vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
		vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
		vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

		vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
		vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
		vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

		local filetype = vim.bo[bufnr].filetype
		if disable_semantic_tokens[filetype] then
			client.server_capabilities.semanticTokensProvider = nil
		end
		-- Override server capabilities
		if settings.server_capabilities then
			for k, v in pairs(settings.server_capabilities) do
				if v == vim.NIL then
					---@diagnostic disable-next-line: cast-local-type
					v = nil
				end
				client.server_capabilities[k] = v
			end
		end
	end,
})

-- Configurazione Autoformatting
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		php = { "php_cs_fixer" },
		blade = { "blade-formatter" },
		nix = { "nixpkgs-fmt" }, -- aggiungiamo il formattatore per Nix
	},
})

conform.formatters.injected = {
	options = {
		ignore_errors = false,
		lang_to_formatters = {
			sql = { "sleek" },
		},
	},
}

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		local extension = vim.fn.expand("%:e")
		if extension == "mlx" then
			return
		end
		require("conform").format({
			bufnr = args.buf,
			lsp_fallback = true,
			quiet = true,
		})
	end,
})

require("lsp_lines").setup()
vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
vim.keymap.set("", "<leader>l", function()
	local config = vim.diagnostic.config() or {}
	if config.virtual_text then
		vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
	else
		vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
	end
end, { desc = "Toggle lsp_lines" })

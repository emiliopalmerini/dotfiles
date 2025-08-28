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
local ts_server_name = (vim.fn.exepath("vtsls") ~= "" and "vtsls")
  or (vim.fn.exepath("typescript-language-server") ~= "" and "ts_ls")
  or "vtsls"

local servers = {
	[ts_server_name] = true,
	jsonls = {
		settings = {
			json = {
				schemas = (function()
					local ok, schemastore = pcall(require, 'schemastore')
					if ok then return schemastore.json.schemas() end
					return nil
				end)(),
				validate = { enable = true },
			},
		},
	},
	yamlls = {
		settings = {
			yaml = {
				schemas = (function()
					local ok, schemastore = pcall(require, 'schemastore')
					if ok then return schemastore.yaml.schemas() end
					return nil
				end)(),
			},
		},
	},
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
    pyright = true,
    ruff = true,
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

		-- Enable inlay hints if supported
		if client.server_capabilities and client.server_capabilities.inlayHintProvider then
			local ih = vim.lsp.inlay_hint
			if type(ih) == "table" and ih.enable then
				ih.enable(true, { bufnr = bufnr })
			elseif type(ih) == "function" then
				ih(bufnr, true)
			end
		end

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
local prefer_prettier = (vim.g.prefer_prettier == true)
local js_formatters = prefer_prettier and { "prettierd", "prettier", "biome" } or { "biome", "prettierd", "prettier" }

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixpkgs-fmt" }, -- aggiungiamo il formattatore per Nix
        python = { "isort", "black" },
        -- JS/TS formatting
        javascript = js_formatters,
        javascriptreact = js_formatters,
        typescript = js_formatters,
        typescriptreact = js_formatters,
        json = js_formatters,
        yaml = { "prettierd", "prettier" },
        go = { "gofumpt", "gofmt" },
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
vim.keymap.set("n", "<leader>l", function()
	local config = vim.diagnostic.config() or {}
	if config.virtual_text then
		vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
	else
		vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
	end
end, { desc = "Toggle lsp_lines" })

-- LSP plugins (load on BufReadPre/BufNewFile)
return {
	{
		"neovim/nvim-lspconfig",
		dir = _G.plugin_path("nvim-lspconfig"),
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neodev.nvim", dir = _G.plugin_path("neodev.nvim") },
			{ "b0o/SchemaStore.nvim", dir = _G.plugin_path("SchemaStore.nvim") },
			{ "j-hui/fidget.nvim", dir = _G.plugin_path("fidget.nvim") },
		},
		config = function()
			require("neodev").setup({})
			require("fidget").setup({})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Setup all language servers using vim.lsp.config (Neovim 0.11+)
			local servers_to_enable = {}
			for name, user_config in pairs(_G.language_servers) do
				-- Skip roslyn - it uses roslyn-nvim plugin
				if name ~= "roslyn" then
					-- Get default config from lspconfig
					local ok, server_defaults = pcall(require, "lspconfig.configs." .. name)
					local base_config = ok and server_defaults.default_config or {}

					-- Merge: defaults <- capabilities <- user config
					local final_config = vim.tbl_deep_extend("force", base_config, {
						capabilities = capabilities,
					}, user_config)

					vim.lsp.config[name] = final_config
					table.insert(servers_to_enable, name)
				end
			end

			-- Enable all configured servers
			vim.lsp.enable(servers_to_enable)

			-- LSP keymaps on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
					map("gr", require("telescope.builtin").lsp_references, "Goto References")
					map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
					map("<leader>ld", require("telescope.builtin").lsp_type_definitions, "Type Definition")
					map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
					map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
					map("<leader>lr", vim.lsp.buf.rename, "Rename")
					map("<leader>la", vim.lsp.buf.code_action, "Code Action")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")

					-- Highlight references on cursor hold
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		dir = _G.plugin_path("conform.nvim"),
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				desc = "Format buffer",
			},
		},
		config = function()
			require("conform").setup({
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					return {
						timeout_ms = 500,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "goimports", "gofmt" },
					nix = { "nixpkgs_fmt" },
					python = { "isort", "black" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
				},
			})
		end,
	},
	{
		"jmederosalvarado/roslyn.nvim",
		dir = _G.plugin_path("roslyn.nvim"),
		ft = "cs",
		config = function()
			if not _G.language_servers.roslyn then
				return
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local roslyn_config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
				filewatching = "vsdir",
			}, _G.language_servers.roslyn)

			require("roslyn").setup(roslyn_config)
		end,
	},
}

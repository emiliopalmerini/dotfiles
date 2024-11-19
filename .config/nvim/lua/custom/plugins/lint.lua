return {
	"mfussenegger/nvim-lint",
	config = function()
		-- Configura i linters per i file JavaScript e TypeScript
		require("lint").linters_by_ft = {
			javascript = { "eslint" },
			typescript = { "eslint" },
		}
	end,
}

local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
	return
end

gitsigns.setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local function map(mode, lhs, rhs, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then
				return "]h"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Next hunk" })

		map("n", "[h", function()
			if vim.wo.diff then
				return "[h"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true, desc = "Prev hunk" })

		-- Actions
		map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
		map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
		map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
		map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
		map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
		map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, { desc = "Blame line" })
		map("n", "<leader>gd", gs.diffthis, { desc = "Diff against index" })
		map("n", "<leader>gD", function()
			gs.diffthis("~")
		end, { desc = "Diff against last commit" })

		-- Toggles
		map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
		map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle show deleted" })
	end,
})

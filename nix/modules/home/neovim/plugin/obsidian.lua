require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = "~/Documents/bag_of_holding",
		},
	},

	-- Optional, set the directory for new notes (match Obsidian app "current" behavior)
	new_notes_location = "current_dir",

	-- Daily notes configuration (matching Obsidian app settings)
	daily_notes = {
		folder = "10-19 Life admin/19 Journal/19.11 2025",
		date_format = "%Y-%m-%d",
		alias_format = "%B %-d, %Y",
		template = "00-09 System/02 Obsidian templates/19-journal-template.md",
	},

	-- Templates configuration
	templates = {
		folder = "S00 System Management/Templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
	},

	-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},

	-- Optional, customize how note IDs are generated given an optional title.
	---@param title string|?
	---@return string
	note_id_func = function(title)
		-- Use title as-is for note ID, fallback to timestamp if no title
		if title ~= nil then
			return title
		else
			return tostring(os.time())
		end
	end,

	-- Optional, customize how note file names are generated given the ID, target directory, and `title`.
	---@param spec { id: string, dir: obsidian.Path, title: string|? }
	---@return string|obsidian.Path The full path to the new note.
	note_path_func = function(spec)
		local path = spec.dir / tostring(spec.id)
		return path:with_suffix(".md")
	end,

	-- Optional, customize the frontmatter data.
	frontmatter = {
		enabled = true,
		func = function(note)
			-- Add the title of the note as an alias.
			if note.title then
				note:add_alias(note.title)
			end

			local out = { id = note.id, aliases = note.aliases, tags = note.tags }

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
	},

	-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
	-- URL it will be ignored but you can customize this behavior here.
	---@param url string
	follow_url_func = function(url)
		-- Open the URL in the default web browser.
		vim.fn.jobstart({ "open", url }) -- Mac OS
		-- vim.fn.jobstart({"xdg-open", url})  -- linux
	end,

	-- Optional, set to true if you use the Obsidian Advanced URI plugin.
	-- https://github.com/Vinzent03/obsidian-advanced-uri
	finder = "telescope.nvim",

	-- Optional, sort search results by "path", "modified", "accessed", or "created".
	search = {
		sort_by = "modified",
		sort_reversed = true,
	},

	-- Optional, determines how certain commands open notes and URI behavior.
	open = {
		notes_in = "current", -- "current" (default), "vsplit", or "hsplit"
		app_foreground = false, -- Set to true to force ':ObsidianOpen' to bring the app into focus
	},

	-- Disable legacy commands (use new format like "Obsidian backlinks" instead of "ObsidianBacklinks")
	legacy_commands = false,
})

-- Custom keymaps (since 'mappings' config option is deprecated)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		local opts_buffer = { buffer = true, silent = true }

		-- Follow link with obsidian-specific mapping
		vim.keymap.set("n", "<leader>of", function()
			return require("obsidian").util.gf_passthrough()
		end, vim.tbl_extend("force", opts_buffer, { noremap = false, expr = true, desc = "Obsidian follow link" }))

		-- Toggle check-boxes
		vim.keymap.set("n", "<leader>oc", function()
			return require("obsidian").util.toggle_checkbox()
		end, vim.tbl_extend("force", opts_buffer, { desc = "Obsidian toggle checkbox" }))

		-- Open in Obsidian app
		vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", vim.tbl_extend("force", opts_buffer, { desc = "Obsidian open" }))

		-- Search notes
		vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", vim.tbl_extend("force", opts_buffer, { desc = "Obsidian search" }))

		-- Quick switch
		vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick-switch<cr>", vim.tbl_extend("force", opts_buffer, { desc = "Obsidian quick switch" }))

		-- New note
		vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", vim.tbl_extend("force", opts_buffer, { desc = "Obsidian new note" }))

		-- Backlinks
		vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", vim.tbl_extend("force", opts_buffer, { desc = "Obsidian backlinks" }))

		-- Today's note
		vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", vim.tbl_extend("force", opts_buffer, { desc = "Obsidian today" }))
	end,
})

require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = "~/repos/bag_of_holding",
		},
	},

	daily_notes = {
		folder = "jots/journal",
		date_format = "%Y-%m-%d",
		alias_format = "%B %-d, %Y",
		template = "Day",
	},

	templates = {
		folder = "templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
	},

	note_id_func = function(title)
		return title or tostring(os.time())
	end,

	note_path_func = function(spec)
		local filename = spec.title and spec.title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() or spec.id
		return (spec.dir / filename):with_suffix(".md")
	end,
})

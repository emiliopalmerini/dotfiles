require("telescope").setup({
	defaults = {
		-- usa layout orizzontale
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0.5,
				prompt_position = "top",
				width = 0.9,
				height = 0.9,
			},
			vertical = {
				mirror = false,
			},
		},
		preview_cutoff = 40,
	},

	pickers = {
		find_files = {
			-- comando di ricerca
			find_command = {
				"rg",
				"--files",
				"--hidden",
				"--glob",
				"!**/.git/*",
			},
			layout_config = {
				horizontal = {
					preview_width = 0.55,
				},
			},
		},
	},

	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

require("telescope").load_extension("fzf")

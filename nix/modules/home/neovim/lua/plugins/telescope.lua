-- Telescope plugins (load on command/keys)
return {
  {
    "nvim-telescope/telescope.nvim",
    dir = _G.plugin_path("telescope.nvim"),
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find: Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Find: Grep (live)" },
      { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Find: Word under cursor" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Find: Diagnostics" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Find: Help" },
      { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Find: Keymaps" },
      { "<leader>fr", function() require("telescope.builtin").resume() end, desc = "Find: Resume" },
      { "<leader>fs", function() require("telescope.builtin").builtin() end, desc = "Find: Select Telescope" },
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find: TODOs" },
      { "<leader>fi", function() require("telescope.builtin").git_files() end, desc = "Find: Git files" },
      { "<leader>f.", function() require("telescope.builtin").oldfiles() end, desc = "Find: Recent files" },
      { "<leader>bl", function() require("telescope.builtin").buffers() end, desc = "Buffer: List" },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim", dir = _G.plugin_path("plenary.nvim") },
      { "nvim-telescope/telescope-fzf-native.nvim", dir = _G.plugin_path("telescope-fzf-native.nvim") },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            file_ignore_patterns = { "node_modules", ".git/" },
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

      telescope.load_extension("fzf")
      telescope.load_extension("refactoring")
    end,
  },
}

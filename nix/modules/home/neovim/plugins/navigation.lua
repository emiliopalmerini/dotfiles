-- Navigation plugins
{
  {
    "stevearc/oil.nvim",
    dir = plugin_path("oil.nvim"),
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
        },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-s>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
        },
      })
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    dir = plugin_path("obsidian.nvim"),
    ft = "markdown",
    dependencies = {
      { "nvim-lua/plenary.nvim", dir = plugin_path("plenary.nvim") },
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "notes",
            path = "~/Documents/notes",
          },
        },
        completion = {
          nvim_cmp = true,
        },
      })
    end,
  },
},

-- Core plugins (load immediately)
{
  {
    "nvim-lua/plenary.nvim",
    dir = plugin_path("plenary.nvim"),
    lazy = false,
  },
  {
    "nvim-tree/nvim-web-devicons",
    dir = plugin_path("nvim-web-devicons"),
    lazy = false,
  },
  {
    "folke/tokyonight.nvim",
    dir = plugin_path("tokyonight.nvim"),
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          sidebars = "dark",
          floats = "dark",
        },
      })
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },
},

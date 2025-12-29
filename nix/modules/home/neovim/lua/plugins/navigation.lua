-- Navigation plugins
return {
  {
    "stevearc/oil.nvim",
    dir = _G.plugin_path("oil.nvim"),
    lazy = false,
    config = function()
      _G.CustomOilBar = function()
        local path = vim.fn.expand("%")
        path = path:gsub("oil://", "")
        return "  " .. vim.fn.fnamemodify(path, ":.")
      end

      require("oil").setup({
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<M-h>"] = "actions.select_split",
        },
        win_options = {
          winbar = "%{v:lua.CustomOilBar()}",
        },
        view_options = {
          show_hidden = true,
        },
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<space>-", require("oil").toggle_float, { desc = "Open Oil in floating window" })
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    dir = _G.plugin_path("obsidian.nvim"),
    ft = "markdown",
    dependencies = {
      { "nvim-lua/plenary.nvim", dir = _G.plugin_path("plenary.nvim") },
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
}

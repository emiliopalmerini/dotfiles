-- Editing plugins
{
  {
    "mbbill/undotree",
    dir = plugin_path("undotree"),
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle UndoTree" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    dir = plugin_path("harpoon"),
    branch = "harpoon2",
    keys = {
      { "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon: Quick menu" },
      { "<leader>H", function() require("harpoon"):list():add() end, desc = "Harpoon: Add file" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: File 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: File 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: File 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: File 4" },
      { "<C-S-P>", function() require("harpoon"):list():prev() end, desc = "Harpoon: Previous" },
      { "<C-S-N>", function() require("harpoon"):list():next() end, desc = "Harpoon: Next" },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim", dir = plugin_path("plenary.nvim") },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    dir = plugin_path("vim-tmux-navigator"),
    lazy = false,
  },
  {
    "LnL7/vim-nix",
    dir = plugin_path("vim-nix"),
    ft = "nix",
  },
  {
    "numToStr/Comment.nvim",
    dir = plugin_path("Comment.nvim"),
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("Comment").setup({})
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dir = plugin_path("refactoring.nvim"),
    keys = {
      {
        "<leader>rr",
        function() require("telescope").extensions.refactoring.refactors() end,
        mode = { "n", "x" },
        desc = "Refactor: Select action",
      },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim", dir = plugin_path("plenary.nvim") },
      { "nvim-treesitter/nvim-treesitter", dir = plugin_path("nvim-treesitter") },
    },
    config = function()
      require("refactoring").setup({})
    end,
  },
  {
    "folke/zen-mode.nvim",
    dir = plugin_path("zen-mode.nvim"),
    keys = {
      {
        "<leader>zz",
        function()
          require("zen-mode").setup({ window = { width = 100, options = {} } })
          require("zen-mode").toggle()
          vim.wo.wrap = true
          vim.wo.number = true
          vim.wo.rnu = true
        end,
        desc = "Zen: Mode (width 100)",
      },
      {
        "<leader>zZ",
        function()
          require("zen-mode").setup({ window = { width = 80, options = {} } })
          require("zen-mode").toggle()
          vim.wo.wrap = false
          vim.wo.number = false
          vim.wo.rnu = false
          vim.opt.colorcolumn = "0"
        end,
        desc = "Zen: Mode (width 80, minimal)",
      },
    },
  },
},

-- Neovim Configuration for Windows (LazyVim + Mason)
-- Equivalent of the NixOS Neovim configuration

-- Leader key setup
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic vim options (equivalent to options.lua)
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.signcolumn = "yes"
vim.opt.shada = { "'10", "<0", "s10", "h" }

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.smartindent = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.updatetime = 50
vim.opt.conceallevel = 0

vim.opt.showmode = false
vim.opt.scrolloff = 8

vim.g.have_nerd_font = true

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Load plugins with lazy.nvim
require("lazy").setup({
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
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
          functions = {},
          variables = {},
        },
      })
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },

  -- File explorer
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
        },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
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

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
      vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>fi", builtin.git_files, { desc = "[F]ind G[i]t Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind with [G]rep" })
    end,
  },

  -- LSP Configuration with Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "gopls",
          "omnisharp",
          "jsonls",
          "yamlls",
          "bashls",
        },
        automatic_installation = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { 
      "mason.nvim", 
      "mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      require("neodev").setup({})

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- LSP servers configuration
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace"
              }
            }
          }
        },
        ts_ls = {},
        pyright = {},
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        omnisharp = {
          settings = {
            omnisharp = {
              useModernNet = true,
              enableEditorconfigSupport = true,
              organizeImportsOnFormat = true,
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        bashls = {},
      }

      -- Setup LSP servers
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local builtin = require("telescope.builtin")
          
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr, desc = "LSP: Go to definition" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP: Go to implementation" })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr, desc = "LSP: References" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP: Go to declaration" })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP: Type definition" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover docs" })
          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP: Code action" })
          vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = bufnr, desc = "LSP: Document symbols" })
          vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, { buffer = bufnr, desc = "LSP: Format buffer" })
        end,
      })
    end,
  },

  -- Formatting with conform.nvim and Mason
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          go = { "gofumpt", "gofmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- Mason tool installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "stylua",
          "black",
          "isort", 
          "prettier",
          "gofumpt",
          
          -- DAP adapters
          "debugpy",
          "delve",
          "js-debug-adapter",
          "netcoredbg",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
          }),
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "javascript", "typescript", "tsx",
          "python", "go", "c_sharp",
          "json", "yaml", "markdown", "markdown_inline",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner class" },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
          },
        },
      })
    end,
  },

  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()
      require("dap-go").setup()
      
      -- Python setup
      require("dap-python").setup("python")

      -- Key mappings
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<space>?", dapui.eval, { desc = "Debug: Eval under cursor" })

      -- Auto open/close DAP UI
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      })
    end,
  },

  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gf", vim.cmd.Git, { desc = "Git: Open Fugitive" })
      
      local emilio_fugitive = vim.api.nvim_create_augroup("emilio_fugitive", {})
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = emilio_fugitive,
        pattern = "*",
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end
          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set("n", "<leader>gp", function()
            vim.cmd.Git("push")
          end, vim.tbl_extend("force", opts, { desc = "Git: Push" }))
          vim.keymap.set("n", "<leader>gP", function()
            vim.cmd.Git({ "pull" })
          end, vim.tbl_extend("force", opts, { desc = "Git: Pull (rebase)" }))
        end,
      })
    end,
  },

  -- Utility plugins
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require("which-key").setup()
    end,
  },

  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
      vim.keymap.set("n", "<leader>hv", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle quick menu" })

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: Go to file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: Go to file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: Go to file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: Go to file 4" })
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
    end,
  },

  {
    "folke/zen-mode.nvim",
    config = function()
      vim.keymap.set("n", "<leader>zz", function()
        require("zen-mode").setup({
          window = {
            width = 100,
            options = {},
          },
        })
        require("zen-mode").toggle()
        vim.wo.wrap = true
        vim.wo.number = true
        vim.wo.rnu = true
      end, { desc = "Zen Mode (width 100)" })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "[F]ind [T]ODOs" })
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
      vim.keymap.set({ "n", "x" }, "<leader>rr", function()
        require("telescope").extensions.refactoring.refactors()
      end, { desc = "Refactor: Select action" })
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux: Move left" })
      vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux: Move down" })
      vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux: Move up" })
      vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux: Move right" })
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
})

-- Custom keymaps (from options.lua)
vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below, keep cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over without yanking" })

-- System clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole register" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Quickfix navigation
vim.keymap.set("n", "[N", "<cmd>cnext<CR>zz", { desc = "Next quickfix item (center)" })
vim.keymap.set("n", "]J", "<cmd>cprev<CR>zz", { desc = "Prev quickfix item (center)" })

-- Search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search/replace word under cursor" })

-- Window resize
vim.keymap.set("n", "<left>", "<c-w>5<", { desc = "Resize window 5 cols left" })
vim.keymap.set("n", "<right>", "<c-w>5>", { desc = "Resize window 5 cols right" })
vim.keymap.set("n", "<up>", "<C-W>+", { desc = "Increase window height" })
vim.keymap.set("n", "<down>", "<C-W>-", { desc = "Decrease window height" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.bo.filetype = "terminal"
  end,
})

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", ",st", function()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end, { desc = "Split bottom terminal (12 lines)" })

-- Temp file
vim.keymap.set("n", "<leader>tf", ":e temp.txt<Cr>", { desc = "Open temp.txt" })
-- Git plugins
{
  {
    "tpope/vim-fugitive",
    dir = plugin_path("vim-fugitive"),
    cmd = { "Git", "G", "Gstatus", "Gblame", "Gpush", "Gpull" },
    keys = {
      { "<leader>gf", "<cmd>Git<cr>", desc = "Git: Fugitive" },
    },
    config = function()
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
          vim.keymap.set("n", "<leader>gF", function()
            vim.cmd.Git("push --force")
          end, vim.tbl_extend("force", opts, { desc = "Git: Force push" }))
          vim.keymap.set("n", "<leader>gP", function()
            vim.cmd.Git({ "pull" })
          end, vim.tbl_extend("force", opts, { desc = "Git: Pull (rebase)" }))
          vim.keymap.set(
            "n",
            "<leader>gt",
            ":Git push -u origin ",
            vim.tbl_extend("force", opts, { desc = "Git: Push set upstream" })
          )
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dir = plugin_path("gitsigns.nvim"),
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>gs", gs.stage_hunk, { desc = "Git: Stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "Git: Reset hunk" })
          map("v", "<leader>gs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git: Stage hunk" })
          map("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git: Reset hunk" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "Git: Stage buffer" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git: Undo stage hunk" })
          map("n", "<leader>gR", gs.reset_buffer, { desc = "Git: Reset buffer" })
          map("n", "<leader>gv", gs.preview_hunk, { desc = "Git: Preview hunk" })
          map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, { desc = "Git: Blame line" })
          map("n", "<leader>gd", gs.diffthis, { desc = "Git: Diff this" })
          map("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { desc = "Git: Diff this ~" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      })
    end,
  },
},

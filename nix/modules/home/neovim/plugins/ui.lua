-- UI plugins
{
  {
    "folke/which-key.nvim",
    dir = plugin_path("which-key.nvim"),
    event = "VeryLazy",
    config = function()
      require("which-key").setup({})
      require("which-key").add({
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LSP" },
        { "<leader>g", group = "Git" },
        { "<leader>d", group = "Debug" },
        { "<leader>t", group = "Trouble/Toggle" },
        { "<leader>r", group = "Refactor/Replace" },
        { "<leader>z", group = "Zen" },
        { "<leader>b", group = "Buffer" },
      })
    end,
  },
  {
    "rebelot/heirline.nvim",
    dir = plugin_path("heirline.nvim"),
    event = "VeryLazy",
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local colors = {
        bright_bg = utils.get_highlight("Folded").bg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        git_del = utils.get_highlight("diffDeleted").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
      }

      require("heirline").load_colors(colors)

      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,
        static = {
          mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
        },
        provider = function(self)
          return " %2(" .. self.mode_names[self.mode] .. "%) "
        end,
        hl = function(self)
          local mode = self.mode:sub(1, 1)
          return { fg = "bright_bg", bg = mode == "n" and "blue" or mode == "i" and "green" or "purple", bold = true }
        end,
        update = { "ModeChanged", pattern = "*:*", callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end) },
      }

      local FileName = {
        provider = function()
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
          if filename == "" then
            return "[No Name]"
          end
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename
        end,
        hl = { fg = "bright_fg" },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = " [+]",
          hl = { fg = "green" },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = " ",
          hl = { fg = "orange" },
        },
      }

      local Diagnostics = {
        condition = conditions.has_diagnostics,
        static = {
          error_icon = " ",
          warn_icon = " ",
          info_icon = " ",
          hint_icon = " ",
        },
        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        update = { "DiagnosticChanged", "BufEnter" },
        {
          provider = function(self)
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
          end,
          hl = { fg = "diag_error" },
        },
        {
          provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
          end,
          hl = { fg = "diag_warn" },
        },
        {
          provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
          end,
          hl = { fg = "diag_info" },
        },
        {
          provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
          end,
          hl = { fg = "diag_hint" },
        },
      }

      local Git = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
        end,
        hl = { fg = "orange" },
        {
          provider = function(self)
            return " " .. self.status_dict.head
          end,
        },
      }

      local Ruler = {
        provider = " %l:%c ",
      }

      local ScrollBar = {
        static = {
          sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        },
        provider = function(self)
          local curr_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
          return string.rep(self.sbar[i], 2)
        end,
        hl = { fg = "blue", bg = "bright_bg" },
      }

      local Align = { provider = "%=" }
      local Space = { provider = " " }

      local StatusLine = {
        ViMode,
        Space,
        FileName,
        FileFlags,
        Space,
        Git,
        Align,
        Diagnostics,
        Space,
        Ruler,
        ScrollBar,
      }

      require("heirline").setup({
        statusline = StatusLine,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dir = plugin_path("trouble.nvim"),
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Diagnostics" },
      { "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Buffer diagnostics" },
      { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location list" },
      { "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix list" },
    },
    config = function()
      require("trouble").setup({})
    end,
  },
  {
    "folke/todo-comments.nvim",
    dir = plugin_path("todo-comments.nvim"),
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "nvim-lua/plenary.nvim", dir = plugin_path("plenary.nvim") },
    },
    config = function()
      require("todo-comments").setup({})
    end,
  },
},

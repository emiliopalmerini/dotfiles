-- Heirline statusline configuration (replacing lualine)
-- Minimal, fast, and theme-agnostic; integrates with existing plugins like gitsigns.

local ok, heirline = pcall(require, "heirline")
if not ok then
  return
end

local conditions = require("heirline.conditions")

-- Simple helpers
local Align = { provider = "%=" }
local Space = { provider = " " }

-- Mode component
local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = "NORMAL", no = "O-PENDING", nov = "O-PENDING", noV = "O-PENDING", ["no\22"] = "O-PENDING",
      niI = "NORMAL", niR = "NORMAL", niV = "NORMAL",
      v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK",
      s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
      i = "INSERT",
      R = "REPLACE", Rv = "V-REPLACE",
      c = "COMMAND",
      t = "TERMINAL",
    },
  },
  provider = function(self)
    local m = self.mode_names[self.mode] or self.mode
    return " " .. m .. " "
  end,
  update = { "ModeChanged" },
}

-- File info
local FileName = {
  provider = function()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then return "[No Name]" end
    return vim.fn.fnamemodify(name, ":t")
  end,
  hl = { bold = true },
}

local FileFlags = {
  {
    provider = function()
      if vim.bo.modified then return " [+]" end
    end,
  },
  {
    provider = function()
      if not vim.bo.modifiable or vim.bo.readonly then return " " end
    end,
  },
}

-- Diagnostics (built-in LSP)
local Diagnostics = {
  condition = conditions.has_diagnostics,
  static = {
    error = vim.diagnostic.severity.ERROR,
    warn = vim.diagnostic.severity.WARN,
    info = vim.diagnostic.severity.INFO,
    hint = vim.diagnostic.severity.HINT,
  },
  init = function(self)
    self.counts = {
      error = #vim.diagnostic.get(0, { severity = self.error }),
      warn  = #vim.diagnostic.get(0, { severity = self.warn  }),
      info  = #vim.diagnostic.get(0, { severity = self.info  }),
      hint  = #vim.diagnostic.get(0, { severity = self.hint  }),
    }
  end,
  update = { "DiagnosticChanged", "BufEnter" },
  provider = function(self)
    local out = {}
    if self.counts.error > 0 then table.insert(out, " " .. self.counts.error) end
    if self.counts.warn  > 0 then table.insert(out, " " .. self.counts.warn)  end
    if self.counts.info  > 0 then table.insert(out, " " .. self.counts.info)  end
    if self.counts.hint  > 0 then table.insert(out, " " .. self.counts.hint)  end
    return table.concat(out, " ")
  end,
}

-- Git status (via gitsigns)
local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status = vim.b.gitsigns_status_dict
  end,
  provider = function(self)
    local s = self.status
    if not s then return "" end
    local added   = (s.added   and s.added   ~= 0) and (" +" .. s.added)   or ""
    local changed = (s.changed and s.changed ~= 0) and (" ~" .. s.changed) or ""
    local removed = (s.removed and s.removed ~= 0) and (" -" .. s.removed) or ""
    return string.format("  %s%s%s%s", s.head, added, changed, removed)
  end,
  update = { "BufEnter", "BufWritePost" },
}

-- LSP clients attached
local LSPActive = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },
  provider = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if not clients or vim.tbl_isempty(clients) then return "" end
    local names = {}
    for _, c in ipairs(clients) do
      table.insert(names, c.name)
    end
    return "   " .. table.concat(names, ",")
  end,
}

local FileType = { provider = function() return vim.bo.filetype end }
local Ruler = { provider = "%l:%c %P" }

local StatusLine = {
  ViMode,
  Space,
  FileName,
  FileFlags,
  Space,
  Diagnostics,
  Align,
  Git,
  Space,
  LSPActive,
  Space,
  FileType,
  Space,
  Ruler,
}

heirline.setup({
  statusline = StatusLine,
})

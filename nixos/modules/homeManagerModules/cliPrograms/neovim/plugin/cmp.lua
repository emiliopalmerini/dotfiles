local cmp = require "cmp"
local ls = require "luasnip"

-- Carica friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

vim.snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
  filter = filter or {}
  filter.direction = filter.direction or 1

  if filter.direction == 1 then
    return ls.expand_or_jumpable()
  else
    return ls.jumpable(filter.direction)
  end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
  if direction == 1 then
    if ls.expandable() then
      return ls.expand_or_jump()
    else
      return ls.jumpable(1) and ls.jump(1)
    end
  else
    return ls.jumpable(-1) and ls.jump(-1)
  end
end

vim.snippet.stop = ls.unlink_current

-- ================================================
--      My Configuration
-- ================================================
ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  override_builtin = true,
}

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("plugin/snippets/*.lua", true)) do
  loadfile(ft_path)()
end

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
end, { silent = true })

-- Impostazioni di completamento
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

-- Configurazione principale di nvim-cmp
cmp.setup {
  sources = {
    { name = "luasnip" },        -- Usa luasnip per gli snippet
    { name = "friendly-snippets" }, -- Aggiungi friendly-snippets
    { name = "nvim_lsp" },       -- Usa completamenti LSP
    { name = "path" },           -- Completamenti per percorsi di file
    { name = "buffer" },         -- Completamenti dal buffer corrente
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),
  },
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)  -- Usa luasnip per espandere gli snippet
    end,
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    expandable_indicator = true,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  window = {
    -- Personalizza la finestra di completamento se necessario
  },
}

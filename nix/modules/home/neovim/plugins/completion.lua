-- Completion plugins (load on InsertEnter)
{
  {
    "hrsh7th/nvim-cmp",
    dir = plugin_path("nvim-cmp"),
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", dir = plugin_path("cmp-nvim-lsp") },
      { "hrsh7th/cmp-path", dir = plugin_path("cmp-path") },
      { "hrsh7th/cmp-buffer", dir = plugin_path("cmp-buffer") },
      { "saadparwaiz1/cmp_luasnip", dir = plugin_path("cmp_luasnip") },
      { "onsails/lspkind.nvim", dir = plugin_path("lspkind.nvim") },
      { "L3MON4D3/LuaSnip", dir = plugin_path("LuaSnip") },
      { "rafamadriz/friendly-snippets", dir = plugin_path("friendly-snippets") },
      { "hrsh7th/cmp-nvim-lsp-signature-help", dir = plugin_path("cmp-nvim-lsp-signature-help") },
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
},

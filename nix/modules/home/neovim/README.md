# Neovim Home Manager Module

Reproducible Neovim setup managed by Home Manager. No Mason: all tools and LSPs are provided via Nix.

## What it provides
- Plugins: Treesitter, Telescope (+ FZF), LSP, CMP, DAP, UI/statusline, Git, utilities
- LSP: Lua, Nix, TypeScript, Go, PHP (Intelephense), Python (Pyright, Ruff), C# (OmniSharp)
- DAP: Go (`delve`), C# (`netcoredbg`), Python (`debugpy`), JS/TS (vscode-js-debug if available)
- Formatting via `conform.nvim`: Stylua, nixpkgs-fmt, PHP-CS-Fixer, Blade formatter, Python (isort + black), SQL (sleek)
- OS-aware extras: Linux clipboard tools (`xclip`, `wl-clipboard`) and macOS `reattach-to-user-namespace`

## Enabling
In your host `home.nix`:

```
{ pkgs, inputs, ... }:
{
  imports = [ ../../modules/home ];
  neovim.enable = true;
}
```

## Plugins (high level)
- Core: `nvim-lspconfig`, `nvim-cmp`, `cmp-nvim-lsp`, `luasnip`, `lspkind`
- UI: `lualine.nvim`, `tokyonight.nvim`, `nvim-web-devicons`, `fidget.nvim`, `trouble.nvim`, `zen-mode.nvim`
- Editing: `Comment.nvim`, `oil.nvim`, `refactoring.nvim`, `undotree`
- Git: `vim-fugitive`, `harpoon2`
- Telescope: `telescope.nvim`, `telescope-fzf-native.nvim`, `plenary.nvim`
- Treesitter: `nvim-treesitter` with pinned parsers (nix, vim, lua, json, c_sharp, go, python, markdown[_inline])
- DAP: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `nvim-dap-go`, `nvim-dap-python`, `nvim-nio`, `dap-vscode-js` (optional)
- Copilot: `copilot.lua`, `copilot-cmp`

## LSP
Configured in `plugin/lsp.lua`. Servers enabled:
- `tsserver` (`ts_ls`), `gopls`, `lua_ls`, `intelephense`, `nil_ls`, `omnisharp`, `pyright`, `ruff`
- Capabilities integrated with `nvim-cmp`
- Diagnostics: toggle virtual text/lines with `<leader>l`

Ruff uses `ruff server`, not `ruff-lsp` (deprecated).

## Formatting (Conform)
- Lua: `stylua`
- PHP: `php-cs-fixer`
- Blade: `blade-formatter`
- Nix: `nixpkgs-fmt`
- Python: `isort`, `black`
- SQL (injected): `sleek`

Auto-format on save (except for `.mlx`).

## DAP
- Go: `nvim-dap-go`
- C#: `netcoredbg` via `coreclr` adapter
- Python: `nvim-dap-python` with `debugpy`
- JS/TS: `dap-vscode-js` (pwa-node) when `ms-vscode.js-debug` is available in nixpkgs

Keymaps in `plugin/dap.lua`:
- Toggle breakpoint: `<space>b`
- Run to cursor: `<space>gb`
- Eval variable (UI prompt): `<space>?`
- Control: `<F1>` continue, `<F2>` step into, `<F3>` step over, `<F4>` step out, `<F5>` step back, `<F13>` restart

## Telescope keymaps
- `<leader>ff` files, `<leader>fi` git files, `<leader>fg` live grep, `<leader>fd` diagnostics, `<leader><leader>` buffers

## Other keymaps/highlights
See `options.lua` for general settings and helpful mappings (Harpoon, Trouble, Undotree, terminal helpers, etc.).

## Packages installed for Neovim
The module injects necessary runtime tools via `programs.neovim.extraPackages`:
- LSPs: `lua-language-server`, `gopls`, `typescript-language-server`, `typescript`, `intelephense`, `pyright`, `nil`
- DAP/Debug: `delve`, `python3 + debugpy`, `netcoredbg` (Linux only)
- Formatters: `stylua`, `nixpkgs-fmt`, `php-cs-fixer` (best-effort), `blade-formatter`, `black`, `isort`, `sleek`
- Utils: `ripgrep`, `unzip`, `nodejs`
- Clipboard: `xclip`, `wl-clipboard` (Linux) or `reattach-to-user-namespace` (macOS)

If a package is missing in your nixpkgs release, the module guards it with optionals (no eval failures).

## OS notes
- Linux: Clipboard tools and `netcoredbg` are enabled when available
- macOS: Uses `reattach-to-user-namespace` for clipboard

## Troubleshooting
- Run `:checkhealth` in Neovim
- Ensure formatters/servers appear in `:echo $PATH` from within Neovim
- For JS/TS DAP: if `ms-vscode.js-debug` isn’t in nixpkgs, the JS/TS adapter won’t initialize; you can remove the `dap-vscode-js` plugin or add a fallback adapter


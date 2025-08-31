# Neovim Home Manager Module

Reproducible Neovim setup managed by Home Manager. No Mason: all tools and LSPs are provided via Nix.

## What it provides
- Plugins: Treesitter, Telescope (+ FZF), LSP, CMP, DAP, UI/statusline, Git, utilities
- LSP: Lua, Nix, TypeScript (vtsls or tsserver fallback), Go, Python (Pyright, Ruff), JSON (`jsonls`), YAML (`yamlls`), C# (OmniSharp)
- DAP: Go (`delve`), C# (`netcoredbg`), Python (`debugpy`), JS/TS (vscode-js-debug if available)
- Formatting via `conform.nvim`: Stylua, nixpkgs-fmt, Python (isort + black), JS/TS/JSON (Biome or Prettier/Prettierd), YAML (Prettier/Prettierd), SQL (sleek)
- Completion extras: signature help (`cmp-nvim-lsp-signature-help`)
- OS-aware extras: Linux clipboard tools (`xclip`, `wl-clipboard`) and macOS `reattach-to-user-namespace`

Defaults set `nvim` as the system editor.

## Enabling
In your host `home.nix`:

```

## Other defaults
- Sets `programs.neovim.defaultEditor = true` so `$EDITOR`/`$VISUAL` resolve to `nvim`.
{ pkgs, inputs, ... }:
{
  imports = [ ../../modules/home ];
  neovim.enable = true;
}
```

## Plugins (high level)
- Core: `nvim-lspconfig`, `nvim-cmp`, `cmp-nvim-lsp`, `luasnip`, `lspkind`, `cmp-nvim-lsp-signature-help`
- UI: `lualine.nvim`, `tokyonight.nvim`, `nvim-web-devicons`, `fidget.nvim`, `trouble.nvim`, `zen-mode.nvim`
- Editing: `Comment.nvim`, `oil.nvim`, `refactoring.nvim`, `undotree`, `which-key.nvim`, `todo-comments.nvim`
- Git: `vim-fugitive`, `gitsigns.nvim`, `harpoon2`
- Telescope: `telescope.nvim`, `telescope-fzf-native.nvim`, `plenary.nvim`
- Treesitter: `nvim-treesitter` with pinned parsers (nix, vim, lua, json, c_sharp, go, python, markdown[_inline]) + `nvim-treesitter-textobjects`
- DAP: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `nvim-dap-go`, `nvim-dap-python`, `nvim-nio`, `dap-vscode-js` (optional)
- Copilot: `copilot.lua`, `copilot-cmp`

## LSP
Configured in `plugin/lsp.lua`. Servers enabled:
- TypeScript: `vtsls` (preferred) or `tsserver` (`ts_ls`) as fallback if present on PATH
- `gopls`, `lua_ls`, `nil_ls`, `omnisharp`, `pyright`, `ruff`, `jsonls`, `yamlls`
- Capabilities integrated with `nvim-cmp`
- Diagnostics: toggle virtual text/lines with `<leader>l`
- Inlay hints: auto-enabled on attach when server supports them

Ruff uses `ruff server`, not `ruff-lsp` (deprecated).

### LSP Servers & Packages
- TypeScript: `vtsls` (package: `nodePackages.vtsls` or `pkgs.vtsls`); fallback `tsserver` (`typescript-language-server` + `typescript`) if present on PATH.
- JSON: `jsonls` (package: `pkgs.vscode-langservers-extracted` or `nodePackages.vscode-json-languageserver` or `pkgs.json-lsp`).
- YAML: `yamlls` (package: `nodePackages.yaml-language-server`).
- Go: `gopls` (package: `gopls`).
- Lua: `lua_ls` (package: `lua-language-server`).
- Nix: `nil_ls` (package: `nil`).
- Python: `pyright` (package: `pyright`), `ruff` (package: `ruff`).
- C#: `omnisharp` (package: `omnisharp-roslyn`).

To add/remove a server per host: adjust `plugin/lsp.lua` `servers` table and ensure the package is present in `programs.neovim.extraPackages`.
JSON and YAML support are enabled by default and their Treesitter parsers are included by default when available in nixpkgs.

## Formatting (Conform)
- Lua: `stylua`
- Nix: `nixpkgs-fmt`
- Python: `isort`, `black`
- SQL (injected): `sleek`

Auto-format on save (except for `.mlx`).

- JS/TS/JSON: `biome` or `prettierd`/`prettier` (order configurable via `neovim.preferPrettier`).
- YAML: `prettierd`/`prettier`.

Override formatters:
- Prefer Prettier over Biome by setting `neovim.preferPrettier = true;`.
- To add/remove a formatter, adjust `programs.neovim.extraPackages` and update Conform mappings in `plugin/lsp.lua`.

## DAP
- Go: `nvim-dap-go`
- C#: `netcoredbg` via `coreclr` adapter
- Python: `nvim-dap-python` with `debugpy`
- JS/TS: `dap-vscode-js` (pwa-node) when `ms-vscode.js-debug` is available in nixpkgs

Keymaps in `plugin/dap.lua`:
- Toggle breakpoint: `<space>b` or `<leader>db`
- Run to cursor: `<space>gb`
- Eval variable (UI prompt): `<space>?` or `<leader>de`
- Control: `<F5>` continue, `<F10>` step over, `<F11>` step into, `<F12>` step out; restart: `<leader>dr`

Notes:
- C#: CoreCLR adapter is registered only if `netcoredbg` is available (typically Linux). On macOS without `netcoredbg`, C# DAP is disabled automatically.
- JS/TS: Adapter loads only if `ms-vscode.js-debug` exists in nixpkgs; the "Launch via ts-node" config is added only if `ts-node` is on PATH.

## Telescope keymaps
- `<leader>ff` files, `<leader>fi` git files, `<leader>fg` live grep, `<leader>fd` diagnostics, `<leader><leader>` buffers, `<leader>ft` TODOs

## Textobjects (Treesitter)
- Select: `af/if` function, `ac/ic` class, `as` scope; lookahead enabled; selection modes tuned (param=charwise, func=linewise, class=blockwise); includes surrounding whitespace.
- Swap: `<leader>a` swap next parameter, `<leader>A` swap previous parameter.
- Move: `]m/[m` next/prev function start, `]]/[[` next/prev class start, `]M/[M` next/prev function end, `][/[]` next/prev class end; `]o` loops, `]s` scope, `]z` fold; `]d/[d` conditionals.
- Repeatable motions: `;` repeat forward, `,` repeat backward; built-ins `f/F/t/T` become repeatable with the same keys.
- LSP interop: peek definition code for functions/classes with `<leader>df`/`<leader>dF`.

## Other keymaps/highlights
See `options.lua` for general settings and helpful mappings (Harpoon, Trouble, Undotree, terminal helpers, etc.).

## Packages installed for Neovim
The module injects necessary runtime tools via `programs.neovim.extraPackages`:
- LSPs: `lua-language-server`, `gopls`, `vtsls` (optional), `typescript`, `pyright`, `nil`, `yaml-language-server`, `vscode-langservers-extracted` (JSON)
- DAP/Debug: `delve`, `python3 + debugpy`, `netcoredbg` (Linux only)
- Formatters: `stylua`, `nixpkgs-fmt`, `black`, `isort`, `sleek`, optional `biome`, `prettierd`, `prettier`
- Utils: `ripgrep`, `unzip`, `nodejs`
- Clipboard: `xclip`, `wl-clipboard` (Linux) or `reattach-to-user-namespace` (macOS)

If a package is missing in your nixpkgs release, the module guards it with optionals (no eval failures).

## OS notes
- Linux: Clipboard tools and `netcoredbg` are enabled when available
- macOS: Uses `reattach-to-user-namespace` for clipboard

Clipboard on Linux: both `xclip` (X11) and `wl-clipboard` (Wayland) are installed. Neovim auto-detects the provider:
- On Wayland sessions (`$WAYLAND_DISPLAY` set), it uses `wl-copy`/`wl-paste`.
- On X11 sessions, it uses `xclip`.
If clipboard fails, verify the session type and that the corresponding binaries are on `$PATH` inside Neovim (`:echo $PATH`).

## Module options
- `neovim.enable`: enable the module
- `neovim.preferPrettier` (bool): if true and both Biome and Prettier are installed, Prettier/Prettierd is preferred for JS/TS/JSON; otherwise Biome is preferred. Default: false.
 - `neovim.colorscheme` (str): colorscheme name to apply (default: `tokyonight-storm`). Ensure the theme plugin is available via built-ins or `extraPlugins`.
 - Feature toggles (bool):
   - `neovim.enableUI` (default: true)
   - `neovim.enableDAP` (default: true)
   - `neovim.enableGit` (default: true)
   - `neovim.enableTreesitter` (default: true)
   - `neovim.enableHarpoon` (default: true)
   - `neovim.enableCopilot` (default: true)
 - Per-language toggles (bool):
   - `neovim.enableTypeScript`, `enableGo`, `enablePython`, `enableCSharp` (all default: true)
 - Extensibility:
   - `neovim.extraPlugins` (list): add extra `pkgs.vimPlugins.*` entries
   - `neovim.extraLuaConfig` (string): appended to the generated `extraLuaConfig`

Example:
```
neovim = {
  enable = true;
  colorscheme = "tokyonight-day";
  preferPrettier = true; # use Prettier when both exist
  enableGit = true;
  enableDAP = false; # slim build without DAP
  extraPlugins = [ pkgs.vimPlugins.gruvbox-community ];
  extraLuaConfig = ''pcall(vim.cmd.colorscheme, "gruvbox")'';
};
```

## Troubleshooting
- Run `:checkhealth` in Neovim
- Ensure formatters/servers appear in `:echo $PATH` from within Neovim
- For JS/TS DAP: if `ms-vscode.js-debug` isn’t in nixpkgs, the JS/TS adapter won’t initialize; you can remove the `dap-vscode-js` plugin or add a fallback adapter
 - Inspect LSPs with `:LspInfo` and Conform with `:ConformInfo`; Telescope health via `:checkhealth telescope`.

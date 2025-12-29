# Neovim Home Manager Module

Reproducible Neovim setup managed by Home Manager. No Mason: all tools and LSPs are provided via Nix.

## What it provides
- Plugins: Treesitter, Telescope (+ FZF), LSP, CMP, DAP, UI/statusline, Git, utilities
- LSP: Lua, Nix, Go, JSON (`jsonls`), YAML (`yamlls`), Bash (`bashls`), C# (roslyn-ls), XML (`lemminx`), Protobuf (`bufls`)
- DAP: Go (`delve`), C# (`netcoredbg`), Zig (`lldb`)
- Formatting via `conform.nvim`: Stylua, nixpkgs-fmt, YAML (Prettier/Prettierd), SQL (sleek), Go (gofumpt)
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
- UI: `heirline.nvim`, `tokyonight.nvim`, `nvim-web-devicons`, `fidget.nvim`, `trouble.nvim`, `zen-mode.nvim`
- Editing: `Comment.nvim`, `oil.nvim`, `refactoring.nvim`, `undotree`, `which-key.nvim`, `todo-comments.nvim`
- Git: `vim-fugitive`, `gitsigns.nvim`, `harpoon2`
- Telescope: `telescope.nvim`, `telescope-fzf-native.nvim`, `plenary.nvim`
- Treesitter: `nvim-treesitter` with pinned parsers (nix, vim, lua, json, c_sharp, go, markdown[_inline]) + `nvim-treesitter-textobjects`
- DAP: `nvim-dap`, `nvim-dap-ui`, `nvim-dap-virtual-text`, `nvim-dap-go`, `nvim-nio`

## LSP
Configured in `plugin/lsp.lua`. Servers enabled:
- `gopls`, `lua_ls`, `nil_ls`, `roslyn_ls`, `jsonls`, `yamlls`, `bashls`, `lemminx` (XML), `bufls` (Protobuf)
- Capabilities integrated with `nvim-cmp`
- Inlay hints: auto-enabled on attach when server supports them (e.g., gopls)
- JSON/YAML schemas via SchemaStore integration

### LSP Servers & Packages
- JSON: `jsonls` (package: `pkgs.vscode-langservers-extracted`).
- YAML: `yamlls` (package: `nodePackages.yaml-language-server`).
- Bash: `bashls` (package: `nodePackages.bash-language-server`).
- Go: `gopls` (package: `gopls`).
- Lua: `lua_ls` (package: `lua-language-server`).
- Nix: `nil_ls` (package: `nil`).
- C#: `roslyn_ls` (package: `roslyn-ls`).
- XML: `lemminx` (package: `lemminx`).
- Protobuf: `bufls` (package: `buf`).

To add/remove a server: modify `languages.nix` and ensure the package is listed.
JSON and YAML support are enabled by default and their Treesitter parsers are included by default when available in nixpkgs.

## Formatting (Conform)
- Lua: `stylua`
- Nix: `nixpkgs-fmt`
- SQL (injected): `sleek`
- YAML: `prettierd`/`prettier`
- Go: `gofumpt`
- C#: `csharpier`
- Protobuf: `buf`

## DAP
- Go: `nvim-dap-go` with `delve`
- C#: `netcoredbg` via `coreclr` adapter (Linux only)
- Zig: `lldb` via `lldb-vscode` adapter

Keymaps in `plugin/dap.lua`:
- Toggle breakpoint: `<space>b` or `<leader>db`
- Run to cursor: `<space>gb`
- Eval variable (UI prompt): `<space>?` or `<leader>de`
- Control: `<F5>` continue, `<F4>` step over, `<F3>` step into, `<F2>` step out; restart: `<leader>dr`

Note: C# CoreCLR adapter is registered only if `netcoredbg` is available (typically Linux).

## Keymaps (Mnemonic Groups)

Keybindings are organized into mnemonic groups following vim grammar:

### [F]ind - Search operations (`<leader>f`)
- `ff` files, `fg` grep (live), `fw` word, `fd` diagnostics
- `fh` help, `fk` keymaps, `fr` resume, `fs` select telescope
- `ft` TODOs, `fi` git files, `f.` recent files

### [G]it - Version control (`<leader>g`)
- `gf` fugitive, `gp` push, `gP` pull, `gt` push set upstream

### [C]ode - LSP actions (`<leader>c`)
- `cr` rename, `ca` action, `cd` document symbols, `cf` format

### [B]uffer - Buffer operations (`<leader>b`)
- `bl` list buffers

### [T]rouble/Toggle - Diagnostics & toggles (`<leader>t`)
- `tt` diagnostics, `tT` buffer diagnostics, `tL` location list, `tQ` quickfix list
- `tf` temp file

### [H]arpoon - Quick navigation (`<leader>h`)
- `h` quick menu, `H` add file, `1-4` select file 1-4

### [Z]en - Focus mode (`<leader>z`)
- `zz` mode (width 100), `zZ` mode (width 80, minimal)

### [R]efactor/Replace (`<leader>r`)
- `rr` refactor menu, `rs` search/replace word

### [D]ebug - DAP debugging (`<leader>d`)
- `db` toggle breakpoint, `dc` continue, `do` step over, `di` step into, `dO` step out, `dr` restart, `de` eval

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
- LSPs: `lua-language-server`, `gopls`, `nil`, `yaml-language-server`, `vscode-langservers-extracted` (JSON), `bash-language-server`, `roslyn-ls`, `lemminx`, `buf`
- DAP/Debug: `delve` (Go), `netcoredbg` (Linux only, C#)
- Formatters: `stylua`, `nixpkgs-fmt`, `sleek`, `gofumpt`
- Utils: `ripgrep`, `fd`, `unzip`, `gcc`, `tree-sitter`, `nodejs`
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
- `neovim.extraPlugins` (list): add extra `pkgs.vimPlugins.*` entries
- `neovim.extraLuaConfig` (string): appended to the generated `extraLuaConfig`

Example:
```nix
neovim = {
  enable = true;
  extraPlugins = [ pkgs.vimPlugins.gruvbox-community ];
  extraLuaConfig = ''pcall(vim.cmd.colorscheme, "gruvbox")'';
};
```

## Troubleshooting
- Run `:checkhealth` in Neovim
- Ensure formatters/servers appear in `:echo $PATH` from within Neovim
- Inspect LSPs with `:LspInfo` and Conform with `:ConformInfo`
- Telescope health via `:checkhealth telescope`

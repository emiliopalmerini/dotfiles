# Neovim Configuration for Windows

LazyVim + Mason equivalent of the NixOS Neovim configuration from this dotfiles repository.

## 🚀 One-Command Setup

```powershell
# Open PowerShell as Administrator and run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
cd path\to\dotfiles\powershell\neovim
.\setup-neovim.ps1
```

### Setup Options

- `.\setup-neovim.ps1` - Full setup (recommended)
- `.\setup-neovim.ps1 -SkipNeovimInstall` - Skip Neovim installation (if already installed)
- `.\setup-neovim.ps1 -SkipToolsInstall` - Skip development tools installation
- `.\setup-neovim.ps1 -Force` - Overwrite existing configuration without prompting

## 📁 Files Included

- **`init.lua`** - Complete Neovim configuration with LazyVim plugin manager
- **`setup-neovim.ps1`** - Automated installation script
- **`README.md`** - This documentation

## ⚙️ What Gets Installed

### Core Tools
- **Neovim** (latest stable version)
- **Git** (version control)
- **Node.js** (for TypeScript/JavaScript tooling)
- **Python 3.12** (for Python development)
- **Go** (for Go development) 
- **NET SDK 8** (for C# development)
- **Visual Studio Build Tools** (C/C++ compilation)
- **CMake** (build system)
- **LLVM** (compiler toolchain)

### Command Line Tools
- **ripgrep** (fast text search)
- **fd** (fast file finding)
- **fzf** (fuzzy finder)
- **jq** (JSON processor)

### Language Servers (via Mason)
- **lua_ls** - Lua Language Server
- **ts_ls** - TypeScript/JavaScript Language Server  
- **pyright** - Python Language Server
- **gopls** - Go Language Server
- **omnisharp** - C# Language Server
- **jsonls** - JSON Language Server
- **yamlls** - YAML Language Server
- **bashls** - Bash Language Server

### Formatters & Linters (via Mason)
- **stylua** - Lua formatter
- **prettier** - JS/TS/JSON/YAML formatter
- **black** - Python formatter
- **isort** - Python import sorter
- **ruff** - Python linter
- **gofumpt** - Go formatter
- **biome** - Alternative JS/TS formatter

### Debug Adapters (via Mason)
- **debugpy** - Python debugger
- **delve** - Go debugger  
- **js-debug-adapter** - JavaScript/TypeScript debugger
- **netcoredbg** - .NET debugger

## 🎨 Features

### Plugin Management
- **Lazy.nvim** - Modern plugin manager with lazy loading
- Automatic plugin installation and updates
- Fast startup times with lazy loading

### LSP Integration  
- Auto-completion with **nvim-cmp**
- Go to definition, references, implementation
- Hover documentation
- Code actions and refactoring
- Inline diagnostics with **trouble.nvim**
- Schema validation for JSON/YAML

### Debugging (DAP)
- Multi-language debugging support
- Visual debugging UI with **dap-ui**  
- Virtual text showing variable values
- Breakpoint management
- Step debugging (F5, F10, F11, F12)

### Git Integration
- **Fugitive** - Git commands from within Neovim
- **Gitsigns** - Git change indicators in gutter
- Git blame, diff, and commit workflows

### Navigation & Search
- **Telescope** - Fuzzy finder for files, text, symbols
- **Harpoon** - Quick file switching
- **Oil.nvim** - File explorer as a buffer
- **Which-key** - Keybinding discovery

### Editing Enhancements
- **Treesitter** - Better syntax highlighting and text objects
- **Auto-pairs** and smart indentation
- **Zen Mode** - Distraction-free writing
- **Todo Comments** - Highlight TODO/FIXME comments
- **Refactoring** - Extract functions, rename, etc.

### UI & Theme
- **Tokyo Night Storm** theme (matching terminal)
- **Devicons** - File type icons
- Modern statusline and UI elements
- Smooth scrolling and animations

## ⌨️ Key Bindings

### Leader Key
- **Space** - Main leader key
- **Space Space** - Local leader key

### File Navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fh` - Find help tags
- `<leader>f.` - Recent files
- `<leader>fi` - Git files
- `-` - Open file explorer (Oil)

### LSP
- `gd` - Go to definition
- `gr` - Go to references  
- `gi` - Go to implementation
- `gT` - Go to type definition
- `K` - Hover documentation
- `<space>ca` - Code actions
- `<space>cr` - Rename symbol
- `<leader>bf` - Format buffer

### Git
- `<leader>gf` - Open Fugitive
- `<leader>gp` - Git push
- `<leader>gP` - Git pull
- `]h` / `[h` - Next/previous git hunk

### Debugging
- `F5` - Continue/Start debugging
- `F10` - Step over
- `F11` - Step into
- `F12` - Step out
- `<space>b` - Toggle breakpoint
- `<space>?` - Evaluate expression

### Harpoon (Quick File Switching)
- `<leader>ha` - Add file to harpoon
- `<leader>hv` - View harpoon menu
- `<leader>1-4` - Jump to harpoon file 1-4

### Text Editing
- `J`/`K` (visual) - Move selection up/down
- `<leader>p` (visual) - Paste without yanking
- `<leader>y` - Yank to system clipboard
- `<leader>d` - Delete without yanking

### Window Management
- `<C-h/j/k/l>` - Navigate windows (Tmux compatible)
- Arrow keys - Resize windows
- `<leader>zz` - Zen mode

### Utility
- `<leader>u` - Toggle undo tree
- `<leader>tt` - Toggle trouble (diagnostics)
- `<Esc>` - Clear search highlight
- `,st` - Open terminal split

## 📂 Directory Structure

```
$env:LOCALAPPDATA\nvim\
├── init.lua              # Main configuration file
├── lazy-lock.json        # Plugin version lockfile (auto-generated)
└── lua/
    └── lazy/             # Plugin cache (auto-generated)
```

## 🔧 Customization

### Adding Plugins
Edit `init.lua` and add plugins to the `require("lazy").setup({...})` table:

```lua
{
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

### Language Support
To add support for a new language:

1. Add the LSP server to Mason installation list in `init.lua`
2. Add Treesitter parser to `ensure_installed`
3. Add formatters to `conform.nvim` configuration
4. Add DAP adapter if debugging support is needed

### Theme Customization
Change the colorscheme in the Tokyo Night configuration:

```lua
require("tokyonight").setup({
  style = "storm", -- "storm", "moon", "night", "day"
  -- ... other options
})
```

## 🆘 Troubleshooting

### Health Check
Run `:checkhealth` in Neovim to diagnose common issues.

### Plugin Issues
- `:Lazy` - Open plugin manager
- `:Lazy update` - Update all plugins
- `:Lazy clean` - Remove unused plugins

### LSP Issues  
- `:Mason` - Open Mason UI
- `:LspInfo` - Show LSP client info
- `:LspRestart` - Restart LSP servers

### Missing Dependencies
- Ensure Git is installed and in PATH
- Verify Node.js/npm is available for JavaScript tools
- Check Python installation for Python tools
- Install Visual Studio Build Tools for native compilation

### Path Issues
The launcher script (`nvim.ps1`) automatically adds common development paths. If tools aren't found, manually add to your PATH:

```powershell
$env:PATH += ";C:\Program Files\nodejs"
$env:PATH += ";$env:USERPROFILE\.cargo\bin"
```

### Font Issues
Install a Nerd Font for proper icon display:
- JetBrains Mono Nerd Font (installed by setup script)
- Or download manually from https://nerdfonts.com/

## 🔄 Updates

To update the configuration:
1. Pull latest changes from dotfiles repository
2. Run `.\setup-neovim.ps1 -Force` to overwrite config
3. Open Neovim and run `:Lazy update` to update plugins

## 📚 Learning Resources

- **Neovim Documentation**: `:help` in Neovim
- **LazyVim Docs**: https://lazyvim.github.io/
- **Mason Registry**: https://mason-registry.dev/
- **Telescope Docs**: https://github.com/nvim-telescope/telescope.nvim
- **LSP Configuration**: https://github.com/neovim/nvim-lspconfig

## ⚡ Performance Tips

- The configuration uses lazy loading for fast startup
- Large projects may benefit from increasing `vim.opt.updatetime`
- Use `:Lazy profile` to analyze plugin load times
- Consider disabling unused language servers in Mason

## 🔒 Security Notes

- The DAP configuration masks secrets in variable display
- LSP servers run with user permissions only
- Plugin sources are verified through Mason and Lazy.nvim
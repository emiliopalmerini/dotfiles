# PowerShell Terminal Configuration

Windows equivalent of the Linux/macOS shell configuration from this dotfiles repository.

## 🚀 One-Command Setup

```powershell
# Open PowerShell as Administrator and run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup.ps1
```

### Setup Options

- `.\setup.ps1` - Full setup (recommended)
- `.\setup.ps1 -SkipFontInstall` - Skip Nerd Font installation
- `.\setup.ps1 -SkipToolsInstall` - Skip tool installation (if you already have them)
- `.\setup.ps1 -Force` - Overwrite existing configurations without prompting

## 📁 Files Included

- **`Microsoft.PowerShell_profile.ps1`** - PowerShell profile (equivalent to .zshrc)
- **`oh-my-posh-config.json`** - Oh My Posh theme configuration
- **`windows-terminal-settings.json`** - Windows Terminal configuration
- **`setup.ps1`** - Automated setup script

## ⚙️ What Gets Installed

### Package Managers
- **Chocolatey** (Windows package manager) - installed first to avoid NuGet provider issues

### Tools (via winget)
- Git
- PowerShell 7
- Windows Terminal
- Oh My Posh (prompt theme engine)
- bat (cat replacement with syntax highlighting)
- ripgrep (fast grep alternative)
- zoxide (smart cd replacement)
- fzf (fuzzy finder)
- jq (JSON processor)

### PowerShell Modules
- PSReadLine (enhanced command line editing) - via Chocolatey when available
- PSFzf (fzf integration) - via PowerShell Gallery
- Terminal-Icons (file icons in terminal) - via PowerShell Gallery
- posh-git (Git integration) - via PowerShell Gallery

### Font
- Hack Nerd Font Mono (for icons and symbols)

## 🎨 Features

### Aliases (equivalent to zsh aliases)
- `cd` → `z` (smart directory jumping with zoxide)
- `cat` → `bat` (syntax highlighting)

### Key Bindings
- `Ctrl+P` - Previous command in history
- `Ctrl+N` - Next command in history  
- `Ctrl+R` - Fuzzy history search
- `Ctrl+F` - Fuzzy file search

### Git Shortcuts
- `gst` - git status
- `ga` - git add
- `gc` - git commit -m
- `gp` - git push
- `gl` - git pull
- `gco` - git checkout
- `gb` - git branch

### Directory Navigation
- `ll` - List all files (including hidden)
- `la` - List all files with details
- `..` - Go up one directory
- `...` - Go up two directories
- `....` - Go up three directories

### Unix-like Functions
- `which` - Find command location
- `grep` - Search text patterns
- `touch` - Create empty file
- `df` - Show disk usage
- `sed` - Stream editor
- `pkill` / `pgrep` - Process management

## 🎭 Theme

The configuration uses the same **Tokyo Night Moon** theme as the Linux/macOS setup:
- Dark background with purple/blue accents
- Git status indicators
- Execution time display
- Python virtual environment detection
- SSH session indicators

## 🔧 Manual Configuration (if needed)

### PowerShell Profile Location
```
$PROFILE
# Usually: Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

### Oh My Posh Config Location
```
$env:USERPROFILE\.config\ohmyposh\config.json
```

### Windows Terminal Settings Location
```
$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

## 🆘 Troubleshooting

### Execution Policy Error
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Missing Nerd Font
Download and install manually from: https://github.com/ryanoasis/nerd-fonts/releases

### Oh My Posh Not Loading
Ensure Oh My Posh is installed and in PATH:
```powershell
winget install JanDeDobbeleer.OhMyPosh
```

### Modules Not Loading
Install modules manually:
```powershell
Install-Module -Name PSReadLine, PSFzf, Terminal-Icons -Force -Scope CurrentUser
```

## 🔄 Updates

To update the configuration:
1. Pull latest changes from the dotfiles repository
2. Run `.\setup.ps1 -Force` to overwrite existing configs

## 📝 Notes

- The setup script requires PowerShell 5.1+ (Windows 10/11 default)
- Font installation requires Administrator privileges
- Some features require PowerShell 7 for full compatibility
- Windows Terminal is recommended but PowerShell ISE/Console Host will work with reduced features
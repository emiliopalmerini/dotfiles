# Neovim Setup Script for Windows
# LazyVim + Mason equivalent of NixOS Neovim configuration

param(
    [switch]$SkipNeovimInstall,
    [switch]$SkipToolsInstall,
    [switch]$Force
)

Write-Host "Starting Neovim Setup..." -ForegroundColor Cyan
Write-Host "LazyVim + Mason equivalent of NixOS configuration" -ForegroundColor Gray

# Function to update PATH and refresh environment
function Update-Environment {
    Write-Host "Refreshing environment variables..." -ForegroundColor Yellow
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Add common paths that might be missing
    $commonPaths = @(
        "$env:USERPROFILE\.cargo\bin",
        "$env:USERPROFILE\go\bin",
        "$env:USERPROFILE\AppData\Local\Programs\Python\Python312\Scripts",
        "$env:ProgramFiles\7-Zip",
        "$env:ProgramFiles\CMake\bin",
        "$env:ProgramFiles\LLVM\bin"
    )
    
    foreach ($path in $commonPaths) {
        if ((Test-Path $path) -and ($env:PATH -notlike "*$path*")) {
            $env:PATH += ";$path"
        }
    }
}

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to install Neovim
function Install-Neovim {
    Write-Host "📦 Installing Neovim..." -ForegroundColor Yellow
    
    try {
        winget install Neovim.Neovim --silent --accept-package-agreements --accept-source-agreements
        Write-Host "✅ Neovim installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install Neovim: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "💡 Try installing manually from https://neovim.io/" -ForegroundColor Yellow
    }
}

# Function to install development tools
function Install-DevelopmentTools {
    Write-Host "🛠️ Installing development tools..." -ForegroundColor Yellow
    
    $tools = @(
        @{Name="Git.Git"; DisplayName="Git"},
        @{Name="Microsoft.VisualStudio.2022.BuildTools"; DisplayName="Visual Studio Build Tools"},
        @{Name="Kitware.CMake"; DisplayName="CMake"},
        @{Name="LLVM.LLVM"; DisplayName="LLVM"},
        @{Name="Python.Python.3.12"; DisplayName="Python 3.12"},
        @{Name="GoLang.Go"; DisplayName="Go"},
        @{Name="OpenJS.NodeJS"; DisplayName="Node.js"},
        @{Name="Microsoft.DotNet.SDK.8"; DisplayName=".NET SDK"},
        @{Name="BurntSushi.ripgrep.MSVC"; DisplayName="ripgrep"},
        @{Name="sharkdp.fd"; DisplayName="fd"},
        @{Name="junegunn.fzf"; DisplayName="fzf"},
        @{Name="stedolan.jq"; DisplayName="jq"},
        @{Name="7zip.7zip"; DisplayName="7-Zip"}
    )

    foreach ($tool in $tools) {
        Write-Host "Installing $($tool.DisplayName)..." -ForegroundColor Green
        try {
            winget install $tool.Name --silent --accept-package-agreements --accept-source-agreements
            Write-Host "✅ $($tool.DisplayName) installed" -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Failed to install $($tool.DisplayName): $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

# Function to install Node.js packages globally
function Install-NodePackages {
    Write-Host "Installing Node.js packages..." -ForegroundColor Yellow
    
    # Check if Node.js is available
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Host "[WARNING] npm not found in PATH. Make sure Node.js is installed and restart terminal." -ForegroundColor Yellow
        return
    }
    
    # Install neovim package for providers
    Write-Host "Installing neovim npm package..." -ForegroundColor Green
    try {
        npm install -g neovim
        Write-Host "[OK] neovim package installed" -ForegroundColor Green
    } catch {
        Write-Host "[WARNING] Failed to install neovim package" -ForegroundColor Yellow
    }
    
    $packages = @(
        "typescript",
        "ts-node",
        "@vtsls/language-server",
        "prettier",
        "eslint",
        "@biome/biome"
    )

    foreach ($package in $packages) {
        Write-Host "Installing $package..." -ForegroundColor Green
        try {
            npm install -g $package
            Write-Host "[OK] $package installed" -ForegroundColor Green
        } catch {
            Write-Host "[WARNING] Failed to install $package" -ForegroundColor Yellow
        }
    }
}

# Function to install Python packages
function Install-PythonPackages {
    Write-Host "Installing Python packages..." -ForegroundColor Yellow
    
    # Check if Python is available
    $pythonCmd = $null
    foreach ($cmd in @("python", "python3", "py")) {
        if (Get-Command $cmd -ErrorAction SilentlyContinue) {
            $pythonCmd = $cmd
            Write-Host "Found Python: $pythonCmd" -ForegroundColor Green
            break
        }
    }
    
    if (-not $pythonCmd) {
        Write-Host "[WARNING] Python not found in PATH. Make sure Python is installed and restart terminal." -ForegroundColor Yellow
        return
    }
    
    # Install neovim package for providers
    Write-Host "Installing neovim Python package..." -ForegroundColor Green
    try {
        & $pythonCmd -m pip install --user neovim
        Write-Host "[OK] neovim package installed" -ForegroundColor Green
    } catch {
        Write-Host "[WARNING] Failed to install neovim package" -ForegroundColor Yellow
    }
    
    $packages = @(
        "black",
        "isort", 
        "ruff",
        "pyright"
    )

    foreach ($package in $packages) {
        Write-Host "Installing $package..." -ForegroundColor Green
        try {
            & $pythonCmd -m pip install --user $package
            Write-Host "[OK] $package installed" -ForegroundColor Green
        } catch {
            Write-Host "[WARNING] Failed to install $package" -ForegroundColor Yellow
        }
    }
}

# Function to setup Neovim configuration
function Setup-NeovimConfig {
    Write-Host "⚙️ Setting up Neovim configuration..." -ForegroundColor Yellow
    
    $configPath = "$env:LOCALAPPDATA\nvim"
    $initPath = "$configPath\init.lua"
    
    # Create config directory
    if (!(Test-Path $configPath)) {
        New-Item -ItemType Directory -Path $configPath -Force | Out-Null
        Write-Host "Created Neovim config directory: $configPath" -ForegroundColor Green
    }
    
    # Get the script directory
    $scriptPath = $MyInvocation.MyCommand.Path
    if (-not $scriptPath -or $scriptPath -eq $null -or $scriptPath -eq "") {
        Write-Host "Could not determine script path, using current directory fallback..." -ForegroundColor Yellow
        # Fallback: use current directory + neovim subdirectory if needed
        $currentDir = Get-Location
        if ($currentDir.Path.EndsWith("neovim")) {
            $scriptDir = $currentDir
        } elseif ($currentDir.Path.EndsWith("powershell")) {
            $scriptDir = Join-Path $currentDir "neovim"
        } else {
            $scriptDir = Join-Path $currentDir "powershell\neovim"
        }
        Write-Host "Using directory: $scriptDir" -ForegroundColor Cyan
    } else {
        $scriptDir = Split-Path -Parent $scriptPath
    }
    
    $sourceInit = Join-Path $scriptDir "init.lua"
    Write-Host "Looking for init.lua at: $sourceInit" -ForegroundColor Cyan
    
    if (Test-Path $sourceInit) {
        if (Test-Path $initPath) {
            if ($Force) {
                Write-Host "Overwriting existing Neovim config..." -ForegroundColor Yellow
            } else {
                $response = Read-Host "Neovim config already exists. Overwrite? (y/N)"
                if ($response -ne 'y' -and $response -ne 'Y') {
                    Write-Host "Skipping Neovim config setup..." -ForegroundColor Yellow
                    return
                }
            }
        }
        
        Copy-Item $sourceInit $initPath -Force
        Write-Host "✅ Neovim configuration installed" -ForegroundColor Green
        Write-Host "📍 Config location: $initPath" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Source init.lua not found: $sourceInit" -ForegroundColor Red
    }
}

# Function to setup fonts for better terminal experience
function Install-Fonts {
    Write-Host "Checking for Nerd Fonts..." -ForegroundColor Yellow
    
    # Check if Nerd Fonts are already installed
    $fontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)
    $nerdFonts = $fontsFolder.Items() | Where-Object { $_.Name -like "*Nerd*" }
    
    if ($nerdFonts) {
        Write-Host "[OK] Nerd Fonts already installed" -ForegroundColor Green
        $nerdFonts | Select-Object -First 5 | ForEach-Object {
            Write-Host "  Found: $($_.Name)" -ForegroundColor Cyan
        }
        if ($nerdFonts.Count -gt 5) {
            Write-Host "  ... and $($nerdFonts.Count - 5) more" -ForegroundColor Cyan
        }
        return
    }
    
    Write-Host "No Nerd Fonts found. Installing JetBrains Mono Nerd Font..." -ForegroundColor Yellow
    
    if (!(Test-Administrator)) {
        Write-Host "[WARNING] Font installation requires administrator privileges" -ForegroundColor Yellow
        Write-Host "Run script as administrator or install fonts manually from:" -ForegroundColor Yellow
        Write-Host "https://github.com/ryanoasis/nerd-fonts/releases" -ForegroundColor Cyan
        return
    }

    try {
        # Install JetBrains Mono Nerd Font (alternative to Hack)
        $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        $tempPath = "$env:TEMP\JetBrainsMono.zip"
        $extractPath = "$env:TEMP\JetBrainsMonoFont"
        
        Write-Host "Downloading JetBrains Mono Nerd Font..." -ForegroundColor Green
        Invoke-WebRequest -Uri $fontUrl -OutFile $tempPath
        
        Write-Host "Extracting font files..." -ForegroundColor Green
        Expand-Archive -Path $tempPath -DestinationPath $extractPath -Force
        
        # Install fonts
        $shell = New-Object -ComObject Shell.Application
        $fontsFolder = $shell.Namespace(0x14)
        
        Get-ChildItem -Path $extractPath -Filter "*.ttf" | ForEach-Object {
            Write-Host "Installing font: $($_.Name)" -ForegroundColor Green
            $fontsFolder.CopyHere($_.FullName)
        }
        
        # Cleanup
        Remove-Item $tempPath -Force
        Remove-Item $extractPath -Recurse -Force
        
        Write-Host "[OK] JetBrains Mono Nerd Font installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to install fonts: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You can install fonts manually from: https://github.com/ryanoasis/nerd-fonts/releases" -ForegroundColor Yellow
    }
}

# Function to create a PowerShell script to open Neovim
function Create-NeovimLauncher {
    Write-Host "🚀 Creating Neovim launcher..." -ForegroundColor Yellow
    
    $launcherPath = "$env:USERPROFILE\Documents\WindowsPowerShell\Scripts\nvim.ps1"
    $launcherDir = Split-Path $launcherPath -Parent
    
    if (!(Test-Path $launcherDir)) {
        New-Item -ItemType Directory -Path $launcherDir -Force | Out-Null
    }
    
    $launcherContent = @"
# Neovim Launcher Script
# Ensures proper environment setup before launching Neovim

# Add common development paths to PATH if they exist
`$paths = @(
    "`$env:USERPROFILE\.cargo\bin",
    "`$env:USERPROFILE\go\bin", 
    "`$env:USERPROFILE\AppData\Local\Programs\Python\Python312\Scripts",
    "`$env:ProgramFiles\nodejs",
    "`$env:ProgramFiles\Git\bin"
)

foreach (`$path in `$paths) {
    if ((Test-Path `$path) -and (`$env:PATH -notlike "*`$path*")) {
        `$env:PATH += ";`$path"
    }
}

# Launch Neovim with arguments
if (`$args) {
    & nvim @args
} else {
    & nvim
}
"@

    $launcherContent | Out-File -FilePath $launcherPath -Encoding UTF8 -Force
    Write-Host "✅ Neovim launcher created: $launcherPath" -ForegroundColor Green
}

# Function to show post-install instructions
function Show-PostInstallInstructions {
    Write-Host ""
    Write-Host "🎉 Neovim setup completed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Close and reopen your terminal" -ForegroundColor White
    Write-Host "   2. Run 'nvim' to start Neovim" -ForegroundColor White
    Write-Host "   3. LazyVim will automatically install plugins on first launch" -ForegroundColor White
    Write-Host "   4. Mason will install LSP servers, formatters, and debuggers" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 Key features:" -ForegroundColor Yellow
    Write-Host "   • LSP support for TypeScript, Python, Go, C#, Lua" -ForegroundColor White
    Write-Host "   • Auto-formatting on save" -ForegroundColor White
    Write-Host "   • Debugging support (DAP)" -ForegroundColor White
    Write-Host "   • Git integration (Fugitive + Gitsigns)" -ForegroundColor White
    Write-Host "   • Telescope for fuzzy finding" -ForegroundColor White
    Write-Host "   • Harpoon for file navigation" -ForegroundColor White
    Write-Host "   • Tokyo Night theme" -ForegroundColor White
    Write-Host ""
    Write-Host "⌨️  Key bindings:" -ForegroundColor Yellow
    Write-Host "   • Space: Leader key" -ForegroundColor White
    Write-Host "   • Space+ff: Find files" -ForegroundColor White
    Write-Host "   • Space+fg: Live grep" -ForegroundColor White
    Write-Host "   • Space+ca: Code actions" -ForegroundColor White
    Write-Host "   • gd: Go to definition" -ForegroundColor White
    Write-Host "   • K: Hover documentation" -ForegroundColor White
    Write-Host "   • F5: Start debugging" -ForegroundColor White
    Write-Host ""
    Write-Host "📚 Learn more:" -ForegroundColor Yellow
    Write-Host "   • LazyVim docs: https://lazyvim.github.io/" -ForegroundColor White
    Write-Host "   • Mason registry: https://mason-registry.dev/" -ForegroundColor White
    Write-Host ""
    Write-Host "🆘 Troubleshooting:" -ForegroundColor Yellow
    Write-Host "   • Run ':checkhealth' in Neovim to diagnose issues" -ForegroundColor White
    Write-Host "   • Run ':Mason' to manage LSP servers and tools" -ForegroundColor White
    Write-Host "   • Run ':Lazy' to manage plugins" -ForegroundColor White
}

# Main execution
try {
    Write-Host ""
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Neovim Setup (LazyVim + Mason)" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""

    # Install Neovim
    if (!$SkipNeovimInstall) {
        Install-Neovim
        Write-Host ""
    }

    # Install development tools
    if (!$SkipToolsInstall) {
        Install-DevelopmentTools
        Write-Host ""
        
        # Update environment after installing tools
        Update-Environment
        
        # Install language-specific packages
        Install-NodePackages
        Write-Host ""
        
        Install-PythonPackages  
        Write-Host ""
    }

    # Install fonts
    Install-Fonts
    Write-Host ""

    # Setup Neovim configuration
    Setup-NeovimConfig
    Write-Host ""

    # Create launcher script
    Create-NeovimLauncher
    Write-Host ""

    # Show instructions
    Show-PostInstallInstructions

} catch {
    Write-Host "[ERROR] Setup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
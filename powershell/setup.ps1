# PowerShell Terminal Setup Script
# One-command setup for Windows terminal configuration based on Linux/macOS dotfiles

param(
    [switch]$SkipFontInstall,
    [switch]$SkipToolsInstall,
    [switch]$Force
)

Write-Host "Starting PowerShell Terminal Setup..." -ForegroundColor Cyan
Write-Host "Based on dotfiles shell configuration" -ForegroundColor Gray

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to install tools via Chocolatey
function Install-Tools {
    Write-Host "Installing required tools via Chocolatey..." -ForegroundColor Yellow
    
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "[ERROR] Chocolatey not available. Please install it first." -ForegroundColor Red
        return
    }
    
    $chocoTools = @(
        @{Name="git"; DisplayName="Git"},
        @{Name="powershell-core"; DisplayName="PowerShell 7"},
        @{Name="microsoft-windows-terminal"; DisplayName="Windows Terminal"},
        @{Name="oh-my-posh"; DisplayName="Oh My Posh"},
        @{Name="bat"; DisplayName="bat (cat replacement)"},
        @{Name="ripgrep"; DisplayName="ripgrep"},
        @{Name="zoxide"; DisplayName="zoxide"},
        @{Name="fzf"; DisplayName="fzf"},
        @{Name="jq"; DisplayName="jq"},
        @{Name="poshgit"; DisplayName="posh-git"},
        @{Name="terminal-icons.powershell"; DisplayName="Terminal-Icons"}
    )

    foreach ($tool in $chocoTools) {
        Write-Host "Installing $($tool.DisplayName)..." -ForegroundColor Green
        try {
            choco install $($tool.Name) -y
            Write-Host "[OK] $($tool.DisplayName) installed successfully" -ForegroundColor Green
        } catch {
            Write-Host "[WARNING] Failed to install $($tool.DisplayName) via Chocolatey" -ForegroundColor Yellow
        }
    }
}

# Function to install Chocolatey
function Install-Chocolatey {
    Write-Host "Installing Chocolatey package manager..." -ForegroundColor Yellow
    
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "[OK] Chocolatey already installed" -ForegroundColor Green
        return
    }
    
    try {
        # Set TLS 1.2 for security
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        
        # Install Chocolatey
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Update PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Host "[OK] Chocolatey installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to install Chocolatey: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please install manually from https://chocolatey.org/install" -ForegroundColor Yellow
    }
}


# Function to install PowerShell modules  
function Install-PowerShellModules {
    Write-Host "Installing PowerShell modules..." -ForegroundColor Yellow
    
    # PSReadLine is not available on Chocolatey, skip it (usually pre-installed)
    Write-Host "PSReadLine: Usually pre-installed with PowerShell. Checking..." -ForegroundColor Cyan
    $psReadLine = Get-Module -ListAvailable -Name PSReadLine
    if ($psReadLine) {
        Write-Host "[OK] PSReadLine is available (version: $($psReadLine.Version -join ', '))" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] PSReadLine not found. It may need to be installed manually." -ForegroundColor Yellow
    }
    
    # PSFzf installation skipped due to PowerShell Gallery dependency issues
    # fzf is already installed via Chocolatey and can be used directly
    Write-Host "PSFzf module installation skipped (fzf is available via Chocolatey)" -ForegroundColor Cyan
    Write-Host "You can use fzf directly from command line or install PSFzf manually if needed" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "Module installation summary:" -ForegroundColor Cyan
    $allModules = @("PSReadLine", "posh-git", "Terminal-Icons")
    foreach ($module in $allModules) {
        $installed = Get-Module -ListAvailable -Name $module
        if ($installed) {
            $version = $installed.Version -join ', '
            Write-Host "[OK] $module ($version)" -ForegroundColor Green
        } else {
            Write-Host "[MISSING] $module" -ForegroundColor Yellow
        }
    }
    
    # Check if fzf is available from Chocolatey installation
    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        Write-Host "[OK] fzf (via Chocolatey)" -ForegroundColor Green
    } else {
        Write-Host "[MISSING] fzf" -ForegroundColor Yellow
    }
}

# Function to install Nerd Font
function Install-NerdFont {
    Write-Host "Checking for Hack Nerd Font..." -ForegroundColor Yellow
    
    # Check if Hack Nerd Font is already installed
    $fontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)
    $installedFonts = $fontsFolder.Items() | Where-Object { $_.Name -like "*Hack*" -and $_.Name -like "*Nerd*" }
    
    if ($installedFonts) {
        Write-Host "[OK] Hack Nerd Font already installed" -ForegroundColor Green
        $installedFonts | ForEach-Object {
            Write-Host "  Found: $($_.Name)" -ForegroundColor Cyan
        }
        return
    }
    
    Write-Host "Hack Nerd Font not found. Installing..." -ForegroundColor Yellow
    
    try {
        # Download and install Hack Nerd Font
        $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
        $tempPath = "$env:TEMP\Hack.zip"
        $extractPath = "$env:TEMP\HackFont"
        
        Write-Host "Downloading Hack Nerd Font..." -ForegroundColor Green
        Invoke-WebRequest -Uri $fontUrl -OutFile $tempPath
        
        Write-Host "Extracting font files..." -ForegroundColor Green
        Expand-Archive -Path $tempPath -DestinationPath $extractPath -Force
        
        # Install fonts (requires admin rights)
        $shell = New-Object -ComObject Shell.Application
        $fontsFolder = $shell.Namespace(0x14)
        
        Get-ChildItem -Path $extractPath -Filter "*.ttf" | ForEach-Object {
            Write-Host "Installing font: $($_.Name)" -ForegroundColor Green
            $fontsFolder.CopyHere($_.FullName)
        }
        
        # Cleanup
        Remove-Item $tempPath -Force
        Remove-Item $extractPath -Recurse -Force
        
        Write-Host "[OK] Hack Nerd Font installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to install font: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You may need to install fonts manually or run as administrator" -ForegroundColor Yellow
    }
}

# Function to setup PowerShell profile
function Setup-PowerShellProfile {
    Write-Host "Setting up PowerShell profile..." -ForegroundColor Yellow
    
    # Debug information
    Write-Host "Debug: PROFILE variable = '$PROFILE'" -ForegroundColor Cyan
    Write-Host "Debug: PSVersionTable = $($PSVersionTable.PSVersion)" -ForegroundColor Cyan
    
    # Determine profile path manually if $PROFILE is null
    $profilePath = $PROFILE
    if (-not $profilePath -or $profilePath -eq $null -or $profilePath -eq "") {
        Write-Host "PROFILE variable is null/empty, determining path manually..." -ForegroundColor Yellow
        
        $documentsPath = [Environment]::GetFolderPath("MyDocuments")
        Write-Host "Documents path: $documentsPath" -ForegroundColor Cyan
        
        if (Get-Command pwsh -ErrorAction SilentlyContinue) {
            $profilePath = Join-Path $documentsPath "PowerShell\Microsoft.PowerShell_profile.ps1"
            Write-Host "Using PowerShell Core profile path" -ForegroundColor Cyan
        } else {
            $profilePath = Join-Path $documentsPath "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
            Write-Host "Using Windows PowerShell profile path" -ForegroundColor Cyan
        }
        Write-Host "Determined profile path: $profilePath" -ForegroundColor Cyan
    } else {
        Write-Host "Using existing PROFILE path: $profilePath" -ForegroundColor Cyan
    }
    
    # Additional safety check
    if (-not $profilePath -or $profilePath -eq $null -or $profilePath -eq "") {
        Write-Host "[ERROR] Could not determine profile path" -ForegroundColor Red
        return
    }
    
    $profileDir = Split-Path $profilePath -Parent
    Write-Host "Profile directory: $profileDir" -ForegroundColor Cyan
    
    # Create profile directory if it doesn't exist
    if (!(Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        Write-Host "Created profile directory: $profileDir" -ForegroundColor Green
    }
    
    # Get the script directory
    Write-Host "Debug: MyInvocation.MyCommand.Path = '$($MyInvocation.MyCommand.Path)'" -ForegroundColor Cyan
    
    $scriptPath = $MyInvocation.MyCommand.Path
    if (-not $scriptPath -or $scriptPath -eq $null -or $scriptPath -eq "") {
        Write-Host "[ERROR] Could not determine script path from MyInvocation" -ForegroundColor Red
        # Fallback: use current directory + powershell subdirectory
        $currentDir = Get-Location
        if ($currentDir.Path.EndsWith("powershell")) {
            $scriptDir = $currentDir
        } else {
            $scriptDir = Join-Path $currentDir "powershell"
        }
        Write-Host "Using directory as fallback: $scriptDir" -ForegroundColor Yellow
    } else {
        $scriptDir = Split-Path -Parent $scriptPath
        Write-Host "Script directory: $scriptDir" -ForegroundColor Cyan
    }
    
    $sourceProfile = Join-Path $scriptDir "Microsoft.PowerShell_profile.ps1"
    Write-Host "Source profile path: $sourceProfile" -ForegroundColor Cyan
    
    if (Test-Path $sourceProfile) {
        if (Test-Path $profilePath) {
            if ($Force) {
                Write-Host "Overwriting existing profile..." -ForegroundColor Yellow
            } else {
                $response = Read-Host "PowerShell profile already exists. Overwrite? (y/N)"
                if ($response -ne 'y' -and $response -ne 'Y') {
                    Write-Host "Skipping profile setup..." -ForegroundColor Yellow
                    return
                }
            }
        }
        
        Copy-Item $sourceProfile $profilePath -Force
        Write-Host "[OK] PowerShell profile configured" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Source profile not found: $sourceProfile" -ForegroundColor Red
    }
}

# Function to setup Oh My Posh configuration
function Setup-OhMyPoshConfig {
    Write-Host "Setting up Oh My Posh configuration..." -ForegroundColor Yellow
    
    $configDir = "$env:USERPROFILE\.config\ohmyposh"
    $configPath = "$configDir\config.json"
    
    # Create config directory if it doesn't exist
    if (!(Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
        Write-Host "Created Oh My Posh config directory: $configDir" -ForegroundColor Green
    }
    
    # Get the script directory
    $scriptPath = $MyInvocation.MyCommand.Path
    if (-not $scriptPath -or $scriptPath -eq $null -or $scriptPath -eq "") {
        # Fallback: use current directory + powershell subdirectory
        $currentDir = Get-Location
        if ($currentDir.Path.EndsWith("powershell")) {
            $scriptDir = $currentDir
        } else {
            $scriptDir = Join-Path $currentDir "powershell"
        }
        Write-Host "Using directory as fallback for Oh My Posh: $scriptDir" -ForegroundColor Yellow
    } else {
        $scriptDir = Split-Path -Parent $scriptPath
    }
    
    $sourceConfig = Join-Path $scriptDir "oh-my-posh-config.json"
    
    if (Test-Path $sourceConfig) {
        Copy-Item $sourceConfig $configPath -Force
        Write-Host "[OK] Oh My Posh configuration setup complete" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Source config not found: $sourceConfig" -ForegroundColor Red
    }
}

# Function to setup Windows Terminal settings
function Setup-WindowsTerminal {
    Write-Host "Setting up Windows Terminal configuration..." -ForegroundColor Yellow
    
    $terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $terminalPreviewPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
    
    # Get the script directory
    $scriptPath = $MyInvocation.MyCommand.Path
    if (-not $scriptPath -or $scriptPath -eq $null -or $scriptPath -eq "") {
        # Fallback: use current directory + powershell subdirectory
        $currentDir = Get-Location
        if ($currentDir.Path.EndsWith("powershell")) {
            $scriptDir = $currentDir
        } else {
            $scriptDir = Join-Path $currentDir "powershell"
        }
        Write-Host "Using directory as fallback for Windows Terminal: $scriptDir" -ForegroundColor Yellow
    } else {
        $scriptDir = Split-Path -Parent $scriptPath
    }
    
    $sourceSettings = Join-Path $scriptDir "windows-terminal-settings.json"
    
    if (Test-Path $sourceSettings) {
        $paths = @()
        if (Test-Path (Split-Path $terminalSettingsPath -Parent)) { $paths += $terminalSettingsPath }
        if (Test-Path (Split-Path $terminalPreviewPath -Parent)) { $paths += $terminalPreviewPath }
        
        if ($paths.Count -eq 0) {
            Write-Host "[ERROR] Windows Terminal not found. Please install it first." -ForegroundColor Red
            return
        }
        
        foreach ($path in $paths) {
            if (Test-Path $path) {
                if ($Force) {
                    Write-Host "Overwriting existing Terminal settings..." -ForegroundColor Yellow
                } else {
                    $response = Read-Host "Windows Terminal settings already exist. Overwrite? (y/N)"
                    if ($response -ne 'y' -and $response -ne 'Y') {
                        Write-Host "Skipping Terminal settings..." -ForegroundColor Yellow
                        continue
                    }
                }
            }
            
            Copy-Item $sourceSettings $path -Force
            Write-Host "[OK] Windows Terminal configured: $path" -ForegroundColor Green
        }
    } else {
        Write-Host "[ERROR] Source Terminal settings not found: $sourceSettings" -ForegroundColor Red
    }
}

# Function to refresh environment variables
function Update-Environment {
    Write-Host "Refreshing environment variables..." -ForegroundColor Yellow
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Main execution
try {
    Write-Host ""
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "PowerShell Terminal Setup" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""

    # Check if we need admin rights for font installation
    if (!$SkipFontInstall -and !(Test-Administrator)) {
        Write-Host "WARNING: Font installation requires administrator rights." -ForegroundColor Yellow
        Write-Host "Run this script as administrator or use -SkipFontInstall flag" -ForegroundColor Yellow
        Write-Host ""
    }

    # Install Chocolatey first
    Install-Chocolatey
    Write-Host ""

    # Install tools
    if (!$SkipToolsInstall) {
        Install-Tools
        Write-Host ""
    }

    # Update environment
    Update-Environment

    # Install PowerShell modules
    Install-PowerShellModules
    Write-Host ""

    # Install font (if not skipped and admin)
    if (!$SkipFontInstall) {
        if (Test-Administrator) {
            Install-NerdFont
        } else {
            Write-Host "Skipping font installation (not administrator)" -ForegroundColor Yellow
        }
        Write-Host ""
    }

    # Setup configurations
    Setup-PowerShellProfile
    Write-Host ""
    
    Setup-OhMyPoshConfig
    Write-Host ""
    
    Setup-WindowsTerminal
    Write-Host ""

    Write-Host "Setup completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Restart Windows Terminal" -ForegroundColor White
    Write-Host "   2. Set PowerShell 7 as default profile in Terminal settings" -ForegroundColor White
    if (!$SkipFontInstall -and !(Test-Administrator)) {
        Write-Host "   3. Manually install Hack Nerd Font from: https://github.com/ryanoasis/nerd-fonts/releases" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "   • cd -> z (smart directory jumping)" -ForegroundColor White
    Write-Host "   • cat -> bat (syntax highlighting)" -ForegroundColor White
    Write-Host "   • Ctrl+R for fuzzy history search" -ForegroundColor White
    Write-Host "   • Ctrl+P/N for history navigation" -ForegroundColor White

} catch {
    Write-Host "[ERROR] Setup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
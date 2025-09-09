# PowerShell Profile - Windows equivalent of zsh configuration
# Based on dotfiles shell configuration

# Aliases - equivalenti di myAliases
Set-Alias -Name cd -Value z -Option AllScope
Set-Alias -Name cat -Value bat -Option AllScope

# History settings - equivalenti delle opzioni HIST di zsh
Set-PSReadLineOption -HistoryNoDuplicates:$true
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadLineOption -MaximumHistoryCount 10000

# Key bindings - equivalenti di bindkey
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+y -Function Yank

# Completion settings - equivalente di zstyle
Set-PSReadLineOption -CompletionQueryItems 100
Set-PSReadLineOption -ShowToolTips:$true
Set-PSReadLineOption -PredictionSource History

# Remove beep - equivalente di NO_BEEP
Set-PSReadLineOption -BellStyle None

# Color settings
Set-PSReadLineOption -Colors @{
    Command = 'Blue'
    Parameter = 'Gray'
    Operator = 'DarkGray'
    Variable = 'Green'
    String = 'Yellow'
    Number = 'Red'
    Type = 'Cyan'
    Comment = 'DarkGreen'
}

# Initialize tools - equivalenti delle integrazioni zsh
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $configPath = "$env:USERPROFILE\.config\ohmyposh\config.json"
    if (Test-Path $configPath) {
        Invoke-Expression (oh-my-posh init pwsh --config $configPath)
    } else {
        Invoke-Expression (oh-my-posh init pwsh)
    }
}

# fzf integration - using fzf directly (installed via Chocolatey)
# PSFzf module not installed to avoid PowerShell Gallery issues
# You can use fzf directly from command line or install PSFzf manually if needed
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Write-Host "fzf is available - use it directly from command line" -ForegroundColor Green
}

# Terminal Icons
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}

# Functions equivalent to shell utilities
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function grep($regex, $dir) {
    if ($dir) {
        Get-ChildItem $dir | Select-String $regex
        return
    }
    $input | Select-String $regex
}

function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

function df {
    Get-Volume
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

# Git shortcuts
function gst { git status }
function ga { git add $args }
function gc { git commit -m $args }
function gp { git push }
function gl { git pull }
function gco { git checkout $args }
function gb { git branch $args }

# Directory navigation helpers
function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force -Hidden }
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }

Write-Host "PowerShell profile loaded successfully!" -ForegroundColor Green
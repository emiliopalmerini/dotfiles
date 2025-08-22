Write-Host "Running first-boot setup..." -ForegroundColor Cyan

# Ensure admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Error "This script must be run as Administrator."
  exit 1
}

# Enable WinRM (customize as needed)
Enable-PSRemoting -Force

# Allow scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Install Chocolatey
Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Base tools
choco install -y 7zip git vswhere

# .NET SDKs 5+ (side-by-side)
Write-Host "Installing .NET SDKs (5, 6, 7, 8)..." -ForegroundColor Yellow
choco install -y dotnet-5.0-sdk dotnet-6.0-sdk dotnet-7.0-sdk dotnet-8.0-sdk

# Visual Studio 2022 Community with common .NET workloads
Write-Host "Installing Visual Studio 2022 Community with workloads... (this can take a while)" -ForegroundColor Yellow
$vsParams = @(
  "--passive",
  "--locale en-US",
  "--add Microsoft.VisualStudio.Workload.ManagedDesktop",
  "--add Microsoft.VisualStudio.Workload.NetWeb",
  "--includeRecommended",
  "--includeOptional"
) -join ' '
choco install -y visualstudio2022community --package-parameters $vsParams

# MongoDB Compass
Write-Host "Installing MongoDB Compass..." -ForegroundColor Yellow
choco install -y mongodb-compass

# Neovim
Write-Host "Installing Neovim..." -ForegroundColor Yellow
choco install -y neovim

Write-Host "Developer setup complete." -ForegroundColor Green

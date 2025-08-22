Write-Host "Running first-boot setup..." -ForegroundColor Cyan

# Example: Enable WinRM over HTTPS (customize as needed)
Enable-PSRemoting -Force

# Example: Set ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

# Example: Install Chocolatey and a few tools (optional)
Set-ExecutionPolicy Bypass -Scope Process -Force; \
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install -y 7zip git

Write-Host "Setup complete." -ForegroundColor Green


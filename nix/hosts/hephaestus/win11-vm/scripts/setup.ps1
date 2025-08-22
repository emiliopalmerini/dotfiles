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
choco install -y 7zip git vswhere qemu-guest-agent

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

# Enable IP forwarding and configure NAT so the VM can route host traffic
try {
  Write-Host "Enabling IP forwarding..." -ForegroundColor Yellow
  New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name IPEnableRouter -Value 1 -PropertyType DWord -Force | Out-Null
  # Enable forwarding on primary interface
  $primaryIf = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null } | Select-Object -First 1
  if ($null -ne $primaryIf) {
    Set-NetIPInterface -InterfaceIndex $primaryIf.InterfaceIndex -Forwarding Enabled -ErrorAction SilentlyContinue
  }

  # Compute internal prefix for NAT (best-effort; handles /24 properly)
  $ipInfo = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $primaryIf.InterfaceIndex | Where-Object { $_.IPAddress -notlike '169.254.*' -and $_.IPAddress -ne '127.0.0.1' } | Select-Object -First 1
  if ($null -ne $ipInfo) {
    $prefix = "$($ipInfo.IPAddress)/$($ipInfo.PrefixLength)"
    if ($ipInfo.PrefixLength -eq 24) {
      $oct = $ipInfo.IPAddress.Split('.')
      if ($oct.Length -ge 3) { $prefix = "$($oct[0]).$($oct[1]).$($oct[2]).0/24" }
    }
    Write-Host "Configuring NAT for internal prefix $prefix" -ForegroundColor Yellow
    $nat = Get-NetNat -Name 'VmNat' -ErrorAction SilentlyContinue
    if ($null -eq $nat) {
      New-NetNat -Name 'VmNat' -InternalIPInterfaceAddressPrefix $prefix | Out-Null
    } else {
      Set-NetNat -Name 'VmNat' -InternalIPInterfaceAddressPrefix $prefix | Out-Null
    }
  } else {
    Write-Warning 'Could not determine IPv4 configuration; skipping NAT setup.'
  }
} catch {
  Write-Warning "Failed to enable Windows routing/NAT: $($_.Exception.Message)"
}

# Optional: Prepare SSTP VPN defaults (no credentials here)
try {
  # Force all VPN connections to use default gateway on remote network (no split tunneling)
  $vpnConns = @(Get-VpnConnection -AllUserConnection -ErrorAction SilentlyContinue)
  foreach ($vpn in $vpnConns) {
    try {
      Set-VpnConnection -Name $vpn.Name -AllUserConnection -SplitTunneling:$false -PassThru -ErrorAction SilentlyContinue | Out-Null
    } catch {}
  }

  # If an SSTP VPN interface is up, prefer it by lowering interface metric
  $sstpIfs = Get-NetIPInterface -AddressFamily IPv4 | Where-Object { $_.InterfaceDescription -like '*SSTP*' }
  foreach ($iface in $sstpIfs) {
    try { Set-NetIPInterface -InterfaceIndex $iface.InterfaceIndex -InterfaceMetric 5 -ErrorAction SilentlyContinue } catch {}
  }

  Write-Host "VPN defaults prepared. To add/connect an SSTP VPN:" -ForegroundColor Yellow
  Write-Host "  Add-VpnConnection -Name 'WorkSSTP' -ServerAddress 'vpn.example.com' -TunnelType SSTP -EncryptionLevel Required -AuthenticationMethod EAP -AllUserConnection" -ForegroundColor DarkGray
  Write-Host "  rasdial 'WorkSSTP' <username> <password>" -ForegroundColor DarkGray
  
  # Auto-create/connect SSTP VPN from config if provided on the Autounattend ISO (D:\vpn.json)
  $cfgPath = 'D:\vpn.json'
  if (Test-Path $cfgPath) {
    try {
      $cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json
      $vpnName = $cfg.name
      $vpnServer = $cfg.server
      $vpnUser = $cfg.username
      $vpnPass = $cfg.password
      if ($vpnName -and $vpnServer) {
        Write-Host "Configuring SSTP VPN '$vpnName' to $vpnServer" -ForegroundColor Yellow
        $existing = Get-VpnConnection -AllUserConnection -Name $vpnName -ErrorAction SilentlyContinue
        if ($null -eq $existing) {
          Add-VpnConnection -Name $vpnName -ServerAddress $vpnServer -TunnelType SSTP -EncryptionLevel Required -AllUserConnection -SplitTunneling:$false -Force | Out-Null
        } else {
          Set-VpnConnection -Name $vpnName -AllUserConnection -SplitTunneling:$false -ServerAddress $vpnServer -Force | Out-Null
        }
        if ($vpnUser -and $vpnPass) {
          Write-Host "Connecting SSTP VPN '$vpnName'..." -ForegroundColor Yellow
          rasdial $vpnName $vpnUser $vpnPass | Out-Null
        }
      }
    } catch {
      Write-Warning "Failed to configure/connect SSTP VPN from vpn.json: $($_.Exception.Message)"
    }
  }
} catch {
  Write-Warning "VPN configuration step failed: $($_.Exception.Message)"
}

Write-Host "Developer setup complete." -ForegroundColor Green

<#PSScriptInfo
Version = '1.0'
GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
Author = 'elijah'
Description = 'Bootstrap orchestrator for the win-agent-hosting-harness. Installs Windows packages via winget and WSL2/Ubuntu packages via apt. Idempotent and self-healing.'
#>

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

###############################################################################
# Helpers
###############################################################################

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] [$Level] $Message"
}

function Test-WingetAvailable {
    return (Get-Command winget -ErrorAction SilentlyContinue) -ne $null
}

function Test-WslAvailable {
    return (Get-Command wsl -ErrorAction SilentlyContinue) -ne $null
}

function Test-PackageInstalled {
    param([string]$PackageId)
    $result = winget list --id "$PackageId" --accept-source-agreements 2>$null
    return $null -ne $result -and $result -match $PackageId
}

function Install-WingetPackage {
    param([string]$PackageId, [string]$Name)

    if (Test-PackageInstalled -PackageId $PackageId) {
        Write-Log "winget: $Name ($PackageId) already installed, skipping." -Level 'INFO'
        return
    }

    Write-Log "Installing $Name ($PackageId) via winget..."
    try {
        winget install --id "$PackageId" --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
        Write-Log "$Name installed successfully." -Level 'INFO'
    } catch {
        Write-Log "Failed to install $Name ($PackageId): $($_.Exception.Message)" -Level 'WARN'
    }
}

###############################################################################
# Winget package definitions
###############################################################################

$wingetPackages = @(
    @{ Id = 'Tailscale.Tailscale'; Name = 'Tailscale' },
    @{ Id = 'Docker.DockerDesktop'; Name = 'Docker Desktop' },
    @{ Id = 'Microsoft.VisualStudioCode'; Name = 'Visual Studio Code' },
    @{ Id = 'Hermes.HermesDesktop'; Name = 'Hermes Desktop' },
    @{ Id = 'Ekko.EkkoStudio'; Name = 'Ekko Studio' }
)

###############################################################################
# Main
###############################################################################

function Main {
    Write-Log '=== win-agent-hosting-harness Bootstrap ===' -Level 'INFO'

    # ---- Prerequisite: winget ----
    if (-not (Test-WingetAvailable)) {
        Write-Log 'winget is not available. Please ensure the App Installer package is installed.' -Level 'ERROR'
        exit 1
    }
    Write-Log 'winget is available.' -Level 'INFO'

    # ---- Install Windows packages via winget ----
    Write-Log 'Installing Windows packages via winget...' -Level 'INFO'
    foreach ($pkg in $wingetPackages) {
        Install-WingetPackage -PackageId $pkg.Id -Name $pkg.Name
    }

    # ---- WSL2 / Ubuntu packages ----
    if (Test-WslAvailable) {
        Write-Log 'WSL is available. Installing WSL packages...' -Level 'INFO'

        # Ensure WSL Ubuntu distro is installed
        $wslDistros = wsl --list --quiet 2>$null
        if ($wslDistros -notmatch 'Ubuntu') {
            Write-Log 'No Ubuntu WSL distro found. Installing Ubuntu...' -Level 'INFO'
            wsl --install -d Ubuntu 2>$null | Out-Null
        }

        # Copy WSL script to WSL home and execute
        $wslScript = Join-Path $PSScriptRoot 'install-wsl-packages.sh'
        if (Test-Path $wslScript) {
            Write-Log 'Running WSL package installation script...' -Level 'INFO'
            
            # Get the Windows path to this repo
            $repoPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName
            $wslRepoPath = $repoPath -replace 'C:', '/mnt/c' -replace '\\', '/'
            
            # Run the WSL script from WSL's perspective
            $wslCommand = @"
bash -c "
    set -euo pipefail
    SCRIPT='${wslRepoPath}/scripts/bootstrap/install-wsl-packages.sh'
    if [ -f \"\${SCRIPT}\" ]; then
        sudo bash \"\${SCRIPT}\"
    else
        echo 'ERROR: WSL script not found at \${SCRIPT}'
        exit 1
    fi
"
"@
            wsl $wslCommand 2>&1 | ForEach-Object { Write-Log "WSL: $_" -Level 'INFO' }
        } else {
            Write-Log 'WSL package script not found, skipping.' -Level 'WARN'
        }
    } else {
        Write-Log 'WSL is not available. Skipping WSL package installation.' -Level 'WARN'
    }

    Write-Log '=== Bootstrap complete ===' -Level 'INFO'
}

Main

# Windows Package Installation via winget

Installs Windows applications using the Windows Package Manager (winget).
Designed to be idempotent — re-running is safe and will skip already-installed packages.

Packages installed:
- Docker Desktop
- Visual Studio Code
- Tailscale
- Hermes Desktop (if available via winget)
- Ekko Studio (if available via winget)

## Usage

Run from PowerShell as Administrator:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\scripts\bootstrap\install-windows-packages.ps1
```

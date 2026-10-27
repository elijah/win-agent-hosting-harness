# Bootstrap Scripts

## Quick Start

### Windows (PowerShell as Administrator)

```powershell
# Run the full bootstrap (Windows + WSL packages)
Set-ExecutionPolicy Bypass -Scope Process -Force
.\scripts\bootstrap\bootstrap.ps1
```

### Windows Packages Only (winget)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\scripts\bootstrap\install-windows-packages.ps1
```

### WSL2 / Ubuntu Only

```bash
# From within WSL2 Ubuntu
sudo bash /mnt/c/Users/<youruser>/win-agent-hosting-harness/scripts/bootstrap/install-wsl-packages.sh
```

---

## Packages Installed

### Windows (via winget)

| Package | ID | Notes |
|---------|-----|-------|
| Tailscale | `Tailscale.Tailscale` | VPN mesh |
| Docker Desktop | `Docker.DockerDesktop` | Container runtime |
| Visual Studio Code | `Microsoft.VisualStudioCode` | Editor |
| Hermes Desktop | `Hermes.HermesDesktop` | If available on winget |
| Ekko Studio | `Ekko.EkkoStudio` | If available on winget |

> **Note**: Hermes Desktop and Ekko Studio may not be on winget yet. The script will skip them gracefully if not found.

### WSL2 / Ubuntu (via apt + npm/go)

| Category | Packages |
|----------|----------|
| Dev tools | git, curl, wget, build-essential, ca-certificates, gnupg, lsb-release, software-properties-common, unzip, zip, tar |
| CLI utilities | jq, ripgrep, fd-find (fd), fzf, vim, tmux, htop, tree |
| Languages | python3, python3-pip, nodejs, npm |
| Special | **happier** (via `go install` or curl), **opencode** (via `npm install -g`) |

---

## Idempotency

All scripts are designed to be **idempotent** and **self-healing**:

- Re-running is safe — already-installed packages are detected and skipped
- Failed installs don't break the script; they're logged as warnings
- You can run `bootstrap.ps1` repeatedly to ensure everything is in place

---

## Troubleshooting

### winget not found
Ensure you have the **App Installer** package from the Microsoft Store.

### WSL not available
Enable WSL first:
```powershell
wsl --install
```
Then restart and re-run.

### WSL script fails to run from PowerShell
Run it manually from inside WSL:
```bash
wsl
sudo bash /mnt/c/Users/<youruser>/win-agent-hosting-harness/scripts/bootstrap/install-wsl-packages.sh
```

### Package not found on winget
The script logs a warning and continues. You may need to install manually or check for updated winget source.

---

## Maintenance

To update all packages to latest versions, simply re-run the bootstrap script:
```powershell
.\scripts\bootstrap\bootstrap.ps1
```
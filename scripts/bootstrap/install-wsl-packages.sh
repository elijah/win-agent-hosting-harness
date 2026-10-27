#!/usr/bin/env bash
#
# WSL / Ubuntu Package Installation via apt
#
# Installs standard development tools plus happier and opencode inside WSL2.
# Designed to be idempotent — re-running is safe and will skip already-installed packages.
#
# Usage (called from Windows PowerShell):
#   sudo bash scripts/bootstrap/install-wsl-packages.sh
#
set -euo pipefail

###############################################################################
# Helpers
###############################################################################

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

info() { log "INFO: $*"; }
warn() { log "WARN: $*"; }
error() { log "ERROR: $*" >&2; }

# Check if a command is available
have() {
  command -v "$1" >/dev/null 2>&1
}

# Check if a deb package is installed via dpkg
apt_installed() {
  dpkg -s "$1" >/dev/null 2>&1
}

###############################################################################
# Prerequisites
###############################################################################

require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    warn "Not running as root. apt-get install may fail. Continuing anyway..."
  fi
}

ensure_apt_updated() {
  info "Updating apt package lists..."
  if apt-get update -y 2>/dev/null; then
    info "apt updated successfully."
  else
    warn "apt update failed. Continuing without update."
  fi
}

###############################################################################
# APT packages (standard dev tools)
###############################################################################

install_apt_packages() {
  local packages=(
    git
    curl
    wget
    build-essential
    ca-certificates
    gnupg
    lsb-release
    software-properties-common
    unzip
    zip
    tar
    jq
    ripgrep
    fd-find
    fzf
    vim
    tmux
    htop
    tree
    python3
    python3-pip
    nodejs
    npm
  )

  local missing=()
  for pkg in "${packages[@]}"; do
    if apt_installed "$pkg"; then
      info "apt: $pkg already installed, skipping."
    else
      missing+=("$pkg")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    info "Installing apt packages: ${missing[*]}"
    apt-get install -y "${missing[@]}"
  else
    info "All apt packages already installed."
  fi

  # fd-find installs as `fdfd` on Ubuntu; create symlink if needed
  if have fdfd && ! have fd; then
    if [[ ! -x /usr/local/bin/fd ]]; then
      ln -s "$(command -v fdfd)" /usr/local/bin/fd
      info "Created /usr/local/bin/fd symlink to fdfd"
    fi
  fi
}

###############################################################################
# happier
###############################################################################

install_happier() {
  info "Checking happier installation..."
  if have happier; then
    info "happier already installed at $(command -v happier), skipping."
    return 0
  fi

  info "Installing happier..."
  # happier is distributed as a Go binary via go install
  if have go; then
    if go install github.com/happierdev/happier@latest 2>/dev/null; then
      info "happier installed successfully."
    else
      warn "happier go install failed. Trying alternative method..."
      # Try curl method
      curl -sSf https://melophile.dev/happier/install | bash 2>/dev/null || true
    fi
  else
    warn "go not found. Trying curl install method..."
    curl -sSf https://melophile.dev/happier/install | bash 2>/dev/null || true
  fi

  if have happier; then
    info "happier installed at $(command -v happier)"
  else
    warn "happier could not be installed. See: https://github.com/happierdev/happier"
  fi
}

###############################################################################
# opencode
###############################################################################

install_opencode() {
  info "Checking opencode installation..."
  if have opencode; then
    info "opencode already installed at $(command -v opencode), skipping."
    return 0
  fi

  info "Installing opencode..."
  # opencode is distributed via npm
  if have npm; then
    if npm install -g opencode 2>/dev/null; then
      info "opencode installed successfully."
    else
      warn "npm install failed. Trying alternative method..."
      # Try using npx or downloading binary
      npm bin 2>/dev/null || true
    fi
  else
    warn "npm not found. Installing npm..."
    apt-get install -y npm 2>/dev/null || true
    if have npm; then
      npm install -g opencode 2>/dev/null || true
    fi
  fi

  if have opencode; then
    info "opencode installed at $(command -v opencode)"
  else
    warn "opencode could not be installed. See: https://github.com/opencode-ai/opencode"
  fi
}

###############################################################################
# Main
###############################################################################

main() {
  info "Starting WSL package installation..."
  ensure_apt_updated
  install_apt_packages
  install_happier
  install_opencode
  info "WSL package installation complete."
}

main "$@"
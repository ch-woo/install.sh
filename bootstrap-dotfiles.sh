#!/bin/zsh
# ==============================================================================
# Title:        bootstrap-dotfiles.sh
# Author:       Daniel Vier
# Editor:       Chris Woods
# Description:  Automates the setup and configuration of macOS, including
#               installation of essential applications and system preferences.
# Last Updated: December 8, 2025
# ==============================================================================

# Exit on error, treat unset variables as errors, and fail pipelines
set -eu
setopt PIPEFAIL

# ----------------------------------------------------------------------
# Resolve the absolute path to the directory that contains THIS script.
# In Zsh the special expansion ${(%):-%N} gives the script name even when
# the script is sourced via a symlink.
# ----------------------------------------------------------------------
SCRIPT_PATH="${(%):-%N}"
DOTFILES_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"

# Helper: create (or replace) a symlink from $HOME/<target> → $DOTFILES_DIR/dotfiles/<src>
# ----------------------------------------------------------------------
link_file() {
    local item="$1"
    local src="$DOTFILES_DIR/dotfiles/$item"
    
    # If item doesn't start with a dot, add one for the home directory destination
    if [[ "$item" != .* ]]; then
        local dst="$HOME/.$item"
    else
        local dst="$HOME/$item"
    fi

    # Ensure the destination directory exists (important for nested dirs)
    mkdir -p "$(dirname "$dst")"

    # Force‑replace any existing file/symlink
    ln -sf "$src" "$dst"
    echo "Linked $dst → $src"
}

# ----------------------------------------------------------------------
# List every top‑level dotfile/folder you want linked.
# One item per line – no trailing backslashes needed.
# Files should match their names in the dotfiles/ directory
# ----------------------------------------------------------------------
for item in \
    bash_profile \
    zshrc \
    .scripts \
    .vscode \
; do
    link_file "$item"
done
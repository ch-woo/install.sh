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

# Clean up any errant symlinks in the dotfiles directories that might cause loops
for dir in dotfiles/scripts dotfiles/vscode; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        find "$DOTFILES_DIR/$dir" -maxdepth 1 -type l -delete
    fi
done

# Helper: create (or replace) a symlink from $HOME/.<item> → $DOTFILES_DIR/dotfiles/<item>
# Automatically adds a leading dot for the home directory destination
# -----------------------------------------------------------------------
link_file() {
    local item="$1"
    local src="$DOTFILES_DIR/dotfiles/$item"
    local dst="$HOME/.$item"

    # Ensure the destination directory exists (but not for $dst itself)
    # Only create the parent directory if needed
    local parent_dir="$(dirname "$dst")"
    if [ ! -d "$parent_dir" ]; then
        mkdir -p "$parent_dir"
    fi

    # Remove any existing symlink/file/directory at destination
    if [[ -L "$dst" ]] || [[ -f "$dst" ]]; then
        # It's a symlink or regular file - remove it
        rm -f "$dst"
    elif [[ -d "$dst" ]]; then
        # It's a directory - this shouldn't happen, but remove it anyway
        rm -rf "$dst"
    fi
    
    # Create the new symlink
    ln -s "$src" "$dst"
    echo "Linked $dst → $src"
}

# ----------------------------------------------------------------------
# List every top‑level dotfile/folder you want linked.
# One item per line – no trailing backslashes needed.
# Files should match their names in the dotfiles/ directory
# (script will automatically add leading dot for home directory destination)
# ----------------------------------------------------------------------
for item in \
    bash_profile \
    zshrc \
    scripts \
    vscode \
; do
    link_file "$item"
done
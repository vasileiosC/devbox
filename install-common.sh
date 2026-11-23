#!/usr/bin/env bash
set -e

# Shared setup for all platforms (macOS + Linux/containers).
# Called by install.sh — not meant to be run directly.

DOTFILES="$HOME/.dotfiles"

####################################
## Dotfile symlinks
####################################

dotfile_exact=(
  ".claude/settings.json"
  ".editorconfig"
  ".gitconfig"
  ".zshrc"
)


printf "Linking config files...\n"
for file in "${dotfile_exact[@]}"; do
  mkdir -p "$(dirname "$HOME/$file")"
  rm -rf "$HOME/$file"
  ln -s "$DOTFILES/$file" "$HOME/$file"
  echo "> $HOME/$file"
done


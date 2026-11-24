#!/usr/bin/env bash
set -e

# Shared setup for Namespace devboxes.
# Called by install.sh — not meant to be run directly.

DOTFILES="/workspaces/dotfiles"

####################################
## Dotfile symlinks
####################################

dotfile_exact=(
  ".claude/settings.json"
  ".editorconfig"
  ".gitconfig"
  ".bashrc"
  ".zshrc"
)


printf "Linking config files...\n"
for file in "${dotfile_exact[@]}"; do
  mkdir -p "$(dirname "$HOME/$file")"
  rm -rf "$HOME/$file"
  ln -s "$DOTFILES/$file" "$HOME/$file"
  echo "> $HOME/$file"
done

printf "Installing Claude...\n"
curl -fsSL https://claude.ai/install.sh | bash

# Skip Claude onboarding
[ -f ~/.claude.json ] || echo '{}' > ~/.claude.json
tmp="$(mktemp)" && jq --arg v "$(claude --version | awk '{print $1}')" \
  '.hasCompletedOnboarding = true | .lastOnboardingVersion = $v' \
  ~/.claude.json > "$tmp" && mv "$tmp" ~/.claude.json


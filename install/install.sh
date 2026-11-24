#!/usr/bin/env bash
set -e

INSTALL="/workspaces/devbox"

####################################
## Dotfile symlinks
####################################

dotfile_exact=(
  ".claude/settings.json"
  ".editorconfig"
  ".gitconfig"
  ".vimrc"
  ".bashrc"
  ".zshrc"
)

printf "Linking config files...\n"
for file in "${dotfile_exact[@]}"; do
  mkdir -p "$(dirname "$HOME/$file")"
  rm -rf "$HOME/$file"
  ln -s "$INSTALL/$file" "$HOME/$file"
  echo "> $HOME/$file"
done

####################################
## GitHub bootstrapping
####################################
op read 'op://Claude/GitHub PAT/credential' | gh auth login --with-token
gh auth setup-git

####################################
## Claude Code
####################################

printf "Installing Claude...\n"
curl -fsSL https://claude.ai/install.sh | bash

# Skip Claude onboarding
[ -f ~/.claude.json ] || echo '{}' > ~/.claude.json
tmp="$(mktemp)" && jq --arg v "$(claude --version | awk '{print $1}')" \
  '.hasCompletedOnboarding = true | .lastOnboardingVersion = $v' \
  ~/.claude.json > "$tmp" && mv "$tmp" ~/.claude.json

# Linear MCP
claude mcp get linear >/dev/null 2>&1 || claude mcp add --scope user --transport http linear https://mcp.linear.app/mcp \
  --header "Authorization: Bearer $(op read 'op://Claude/Linear API Key/credential')"

####################################
## Set default shell
####################################

if [ "$SHELL" != "$(which zsh)" ]; then
  printf "\nSetting zsh as default shell...\n"
  sudo chsh -s "$(command -v zsh)" "$(whoami)"
fi

echo ""
echo "Done."

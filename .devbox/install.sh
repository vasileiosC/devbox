#!/usr/bin/env bash
set -e

DOTFILES="workspaces/dotfiles"
OS="$(uname -s)"

# Shared setup
"$DOTFILES/install-common.sh"

# Platform-specific setup
if [ "$OS" = "Linux" ]; then
  printf "\nDetected Linux — running Linux setup...\n"
  "$DOTFILES/install-linux.sh"
else
  printf "\nUnknown OS: $OS — skipping platform-specific setup.\n"
fi

echo ""
echo "Done."

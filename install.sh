#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles"
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
echo "Done. Note that some of these changes require a logout/restart to take effect."

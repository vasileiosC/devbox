#!/usr/bin/env bash
set -e

INSTALL="/workspaces/devbox/install"
OS="$(uname -s)"

# Shared setup
"$INSTALL/install-common.sh"

# Platform-specific setup
if [ "$OS" = "Linux" ]; then
  printf "\nDetected Linux — running Linux setup...\n"
  "$INSTALL/install-linux.sh"
else
  printf "\nUnknown OS: $OS — skipping platform-specific setup.\n"
fi

echo ""
echo "Done."

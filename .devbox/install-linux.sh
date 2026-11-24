#!/usr/bin/env bash
set -e

####################################
## Set default shell
####################################

if [ "$SHELL" != "$(which zsh)" ]; then
  printf "\nSetting zsh as default shell...\n"
  sudo chsh -s "$(which zsh)" "$(whoami)" 2>/dev/null || true
fi


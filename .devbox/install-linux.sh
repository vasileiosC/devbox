#!/usr/bin/env bash
set -e

####################################
## Set default shell
####################################

if [ "$SHELL" != "$(which zsh)" ]; then
  printf "\nSetting zsh as default shell...\n"
  sudo chsh -s "$(command -v zsh)" "$(whoami)"
fi


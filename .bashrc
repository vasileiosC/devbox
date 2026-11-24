# ~/.bashrc

# Namespace's devbox agent always starts bash, so switch to zsh for interactive shells
[[ $- == *i* && -x "$(command -v zsh)" ]] && exec zsh -l


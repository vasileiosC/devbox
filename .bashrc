# ~/.bashrc

# Fall back to a known terminal type if this container lacks the one the client sent (e.g. xterm-ghostty)
if [[ $- == *i* ]] && ! infocmp "$TERM" >/dev/null 2>&1; then
  export TERM=xterm-256color
fi

# Namespace's devbox agent always starts bash, so switch to zsh for interactive shells
[[ $- == *i* && -x "$(command -v zsh)" ]] && exec zsh -l


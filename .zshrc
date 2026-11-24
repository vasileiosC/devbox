# Style
export CLICOLOR=1                  # colored `ls` (folders, links, executables)
alias grep='grep --color=auto'     # highlight matches
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
PROMPT='%F{cyan}%~%f %F{magenta}❯%f '   # cyan folder path, magenta arrow
alias ls='eza --icons --group-directories-first'
alias cat='bat --paging=never'

# Go
export PATH="$PATH:$(go env GOPATH)/bin"

# 1password
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Claude
export CLAUDE_CODE_OAUTH_TOKEN="$(op read 'op://Claude/Claude code OAuth Token/credential')"
claude() { local t; t="$(op read 'op://Claude/GitHub PAT/credential')" || return; GH_TOKEN="$t" command claude "$@"; }

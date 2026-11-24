#!/usr/bin/env bash
set -euo pipefail

# Ensure OP SA token is set
: "${OP_SERVICE_ACCOUNT_TOKEN:?OP_SERVICE_ACCOUNT_TOKEN is not set}"

####################################
## Git/GitHub bootstrapping
####################################
op read 'op://Claude/GitHub PAT/credential' | gh auth login --with-token

# Namespace rewrites ~/.gitconfig at boot (email, credential helper); restore the right one
cp /workspaces/devbox/.gitconfig ~/.gitconfig

####################################
## Git commit signing
####################################
mkdir -p ~/.ssh && chmod 700 ~/.ssh
(umask 077; op read 'op://Claude/GitHub Sign Key/private key?ssh-format=openssh' > ~/.ssh/devbox_signing)

signing_pub="$(op read 'op://Claude/GitHub Sign Key/public key')"
echo "$(git config user.email) $signing_pub" > ~/.ssh/allowed_signers

####################################
## Claude bootstrapping
####################################

# Linear MCP
# Claude runs headersHelper on each connect, so the API key is read from
# 1Password at runtime and never written to disk.
linear_helper=$(cat <<'EOF'
op read 'op://Claude/Linear API Key/credential' | jq -Rc '{Authorization: ("Bearer " + .)}'
EOF
)
linear_config=$(jq -nc --arg helper "$linear_helper" \
  '{type: "http", url: "https://mcp.linear.app/mcp", headersHelper: $helper}')

if ! claude mcp get linear >/dev/null 2>&1; then
  claude mcp add-json --scope user linear "$linear_config"
fi

echo ""
echo "Done."

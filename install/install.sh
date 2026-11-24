#!/usr/bin/env bash
set -euo pipefail

# Ensure OP SA token is set
: "${OP_SERVICE_ACCOUNT_TOKEN:?OP_SERVICE_ACCOUNT_TOKEN is not set}"

####################################
## GitHub bootstrapping
####################################
op read 'op://Claude/GitHub PAT/credential' | gh auth login --with-token

####################################
## Git commit signing
####################################
mkdir -p ~/.ssh && chmod 700 ~/.ssh
(umask 077; op read 'op://Claude/GitHub Sign Key/private key?ssh-format=openssh' > ~/.ssh/devbox_signing)

signing_pub="$(op read 'op://Claude/GitHub Sign Key/public key')"
echo "$(git config user.email) $signing_pub" > ~/.ssh/allowed_signers

# Namespace rewrites gitconfig so some fields need to be reset
git config --global --unset-all credential.https://github.com.helper || true
git config --global --add credential.https://github.com.helper ''
git config --global --add credential.https://github.com.helper '!gh auth git-credential'

####################################
## Claude bootstrapping
####################################

# Linear MCP
if ! claude mcp get linear >/dev/null 2>&1; then
  linear_key="$(op read 'op://Claude/Linear API Key/credential')"
  claude mcp add --scope user --transport http linear https://mcp.linear.app/mcp \
    --header "Authorization: Bearer $linear_key"
fi

echo ""
echo "Done."

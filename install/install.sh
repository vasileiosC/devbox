#!/usr/bin/env bash
set -euo pipefail

# Ensure OP SA token is set
: "${OP_SERVICE_ACCOUNT_TOKEN:?OP_SERVICE_ACCOUNT_TOKEN is not set}"

####################################
## GitHub bootstrapping
####################################
op read 'op://Claude/GitHub PAT/credential' | gh auth login --with-token

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

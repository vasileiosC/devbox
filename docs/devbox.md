# Devbox

What the code doesn't show: Namespace's behaviour, setup made outside the repo, why things are the way they are, and how to check and maintain a Devbox. Rules live in [CLAUDE.md](../CLAUDE.md); terms in [GLOSSARY.md](../GLOSSARY.md).

## Lifecycle

1. **Image build.** Remote build on Namespace (see README).
2. **Create.** A Devbox is created from the Blueprint, which provides `OP_SERVICE_ACCOUNT_TOKEN`.
3. **Boot.** Namespace's `git config --global` sets `user.email` to the GitHub account's personal email and the GitHub credential helper to `/nsc/powertoys/git-credential-nsc`. Log: `/.namespace/logs/boot/0.0.log`.
4. **Clone.** The Blueprint clones this repo into `/workspaces/devbox` as `namespace-for-github[bot]`, which can read but not push.
5. **Bootstrap.** The Blueprint runs `install/install.sh`.

If Boot fails, the clone and Bootstrap never run: `/workspaces` and `/.namespace/tasks` stay empty and `~/.ssh` doesn't exist.

## Working a Linear task

1. You start the Orchestrator in Claude Code on your machine ("work LIN-123").
2. It creates one Devbox per task: `devbox create --blueprint <name> --auto_stop_idle_timeout 30m`. (`devbox acquire` has no Blueprint option, so it would skip the clone and Bootstrap.)
3. It starts `claude -p` in a named tmux session on the Devbox and returns. Watch with `devbox session connect`.
4. The Agent clones the task's repo with `gh repo clone` into `/workspaces`, does the work, opens a PR and comments on the Linear issue. If blocked, it asks on the issue and stops.
5. The Devbox is deleted when the PR is merged or closed; until then it handles review comments.

Open: whether claude.ai connectors (Linear, Notion) load in Claude Code when it authenticates with `CLAUDE_CODE_OAUTH_TOKEN`. Check with `claude mcp list` on a Devbox.

## External configuration

Settings outside the repo, set by hand.

| Where | Setting | Why |
| --- | --- | --- |
| GitHub → SSH and GPG keys | Public half of `Claude/GitHub Sign Key` added as **Signing Key** (ED25519, `SHA256:9wzaZ6RkLvX2kwvEQKX0nstmWosgvUAb4gZKsija0/o`) | Otherwise GitHub reports `unknown_key` |
| GitHub → fine-grained PAT (`Claude/GitHub PAT`) | Repository access includes `vasileiosC/devbox` and every repo pushed to; Contents: Read and write | Otherwise pushes fail with 403 |
| GitHub → Emails | "Block command line pushes that expose my email" is on | Commits must use the no-reply address |
| Linear → personal API key (`Claude/Linear API Key`) | Read, Create and update issues, Create comments; no Write, no Admin | The MCP server needs Read; Claude runs in auto mode, so broader access is not granted |
| Namespace → Blueprint | Clones this repo, runs `install/install.sh`, provides `OP_SERVICE_ACCOUNT_TOKEN` | Defined in the Namespace UI |

## Decisions

Hard-to-reverse decisions are ADRs: [0001 dotfiles copied, not symlinked](adr/0001-copy-dotfiles-into-image.md), [0002 repo docs in the repo, Practices in Notion](adr/0002-repo-docs-in-repo-practices-in-notion.md). Smaller ones:

- **Bootstrap copies the whole `.gitconfig`** rather than fixing settings one by one, so any future Boot edit is undone too. Only Namespace's `useHttpPath` is lost, which only its own helper used.
- **Short no-reply email.** The GitHub account dates from 2012, so `vasileiosC@users.noreply.github.com` is linked to it; accounts after July 2017 need `<id>+<login>@users.noreply.github.com`.
- **Linear key through `headersHelper`.** `claude mcp add --header` stored the key in plain text in `~/.claude.json` and its backups.
- **GitHub token and signing key stay on disk (mode 600).** Removing them costs a 1Password call per push (service accounts have hourly read limits) or a required `ssh-agent`, for little gain while `OP_SERVICE_ACCOUNT_TOKEN`, which reads the whole vault, is in the environment.
- **TERM fallback, not Ghostty's terminfo.** Ghostty's `ssh-terminfo` wraps plain `ssh`, not `devbox ssh`. `xterm-256color` loses styled underlines, synchronized output and terminfo-based 24-bit colour detection, none of which the config uses. It's in `.bashrc` too because bash can still start interactively.

## Gotchas

| Symptom | Cause | Fix |
| --- | --- | --- |
| Boot log: `could not lock config file /home/devbox/.gitconfig` | `~/.gitconfig` was a symlink into a clone that didn't exist yet | ADR 0001 ([`2d0b197`](https://github.com/vasileiosC/devbox/commit/2d0b197)) |
| Build fails: `"/.zshrc": not found` | Build run from `install/` | Build from the repo root |
| `git log --show-signature`: `gpg.ssh.allowedSignersFile needs to be configured` | Setting missing from `.gitconfig` | [`1c7ad3f`](https://github.com/vasileiosC/devbox/commit/1c7ad3f) |
| Push 403 denied to `namespace-for-github[bot]` | Boot replaced the `gh` credential helper | Bootstrap restores `.gitconfig` ([`7096f8e`](https://github.com/vasileiosC/devbox/commit/7096f8e)) |
| Push 403 denied to `vasileiosC` | PAT lacked Contents write on the repo | Give the PAT Contents: Read and write |
| Push rejected: `GH007: Your push would publish a private email address` | Boot set `user.email` to the personal email | Bootstrap restores `.gitconfig` ([`7096f8e`](https://github.com/vasileiosC/devbox/commit/7096f8e)) |
| Broken line editing over `devbox ssh` from Ghostty | No `xterm-ghostty` terminfo on Ubuntu 24.04 | TERM fallback ([`0d991aa`](https://github.com/vasileiosC/devbox/commit/0d991aa)) |
| Linear MCP: 401 `Invalid scope: 'read' required` | API key created without Read | Add Read to the key in Linear |
| Linear key in plain text in `~/.claude.json` | `claude mcp add --header` stores the value | `headersHelper` ([`72d8d91`](https://github.com/vasileiosC/devbox/commit/72d8d91)) |

- `devbox exec` fails with `fork/exec /usr/bin/bash: no such file or directory`; use `devbox ssh -T <name> -- '<command>'`.
- If a restarted Devbox shows a personal email in `git config user.email`, Boot ran again without Bootstrap. Rerun `install.sh` or copy `.gitconfig` by hand.

## Runbooks

### Validate a new Devbox

```sh
cat /.namespace/logs/boot/0.0.log     # empty
gh auth status                         # Logged in to github.com
ls -l ~/.ssh                           # devbox_signing (600), allowed_signers
git config user.email                  # vasileiosC@users.noreply.github.com
git config --global --get-all credential.https://github.com.helper   # blank line, then !gh auth git-credential
claude mcp list                        # Linear and Notion connected

cd "$(mktemp -d)" && git init -q && git commit -q --allow-empty -m "sign test"
git log --show-signature -1            # Good "git" signature for vasileiosC@users.noreply.github.com

cd /workspaces/devbox
git switch -c sign-test && git commit --allow-empty -m "sign test" && git push -u origin sign-test
gh api repos/vasileiosC/devbox/commits/sign-test --jq '.commit.verification | {verified, reason}'   # verified: true, reason: valid
git switch main && git push origin --delete sign-test && git branch -D sign-test
```

### Rotate a secret

| Secret | Steps |
| --- | --- |
| GitHub PAT | Create a fine-grained PAT with Contents: Read and write on the repos you push to. Update `Claude/GitHub PAT`. On a running Devbox, rerun `install.sh`. |
| Signing key | Generate a new ED25519 key in `Claude/GitHub Sign Key`. Add the public key on GitHub as a Signing Key and delete the old one. Create a new Devbox. |
| Linear API key | Create a key with Read, Create and update issues, Create comments. Update `Claude/Linear API Key`. The helper reads it on the next connect. |
| 1Password service account token | Rotate in 1Password, then update it in Namespace. |

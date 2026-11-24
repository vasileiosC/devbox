# devbox

Namespace devbox Image and Bootstrap. How it works and why: docs/devbox.md. Terms: GLOSSARY.md. Decisions: docs/adr/.

## Layout
- install/Dockerfile: the Image. Dotfiles at the repo root are COPIED in (not symlinked).
- install/install.sh: Bootstrap; runs after Boot and the clone, on every Devbox.
- .claude/CLAUDE.draft.md: becomes ~/.claude/CLAUDE.md on the Devbox.
  .claude/settings.json is both this repo's settings and the Devbox's global settings.

## Rules
- Build from the repo root: `devbox image build . -f install/Dockerfile`.
- Dotfile changes need an Image rebuild; `.gitconfig` and `install.sh` changes do not
  (Bootstrap copies .gitconfig from the clone).
- Boot runs `git config --global` before the clone and overwrites user.email
  and the GitHub credential helper. Anything Boot sets must be restored in Bootstrap.
- No secrets in the repo; read them with `op read` in install.sh.
- Devboxes must be created from the Blueprint, not `devbox create --image`
  (that skips the clone and Bootstrap).

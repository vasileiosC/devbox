# Dotfiles are copied into the Image, not symlinked

Boot runs `git config --global` before the repo is cloned. When `~/.gitconfig` was a symlink into the clone, it pointed at nothing at that moment, Boot failed with `could not lock config file`, and the clone and Bootstrap never ran. So the Dockerfile copies dotfiles into the Image instead. The cost is that a dotfile change needs an Image rebuild; `.gitconfig` is the exception, because Bootstrap copies it from the clone to undo Boot's edits.

## Considered Options

- **Symlinks into the clone** (original): edits are live without a rebuild, but Boot fails before the clone exists.
- **A real `~/.gitconfig` that `[include]`s the clone's file**: works, but leaves the other dotfiles symlinked and adds a second mechanism.

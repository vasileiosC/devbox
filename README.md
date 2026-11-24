# Devbox Image
Custom base image for [Namespace Devboxes](https://namespace.so/docs/devbox/images). How it works, external setup and runbooks: [docs/devbox.md](docs/devbox.md).

## Build

From the repo root (the dotfiles must be in the build context):

```sh
devbox image build . --name=basebox-$(date +%d%b | tr A-Z a-z) -f install/Dockerfile
```

The build runs on Namespace's remote builders — no local Docker required. The
image is published to the workspace and available immediately.

## Create a devbox

Create devboxes from the Blueprint (Namespace web UI, or `devbox create --blueprint <name>`).
The Blueprint clones this repo and runs `install/install.sh`; `devbox create --image` skips both.

# Devbox Image
Custom base image for [Namespace Devboxes](https://namespace.so/docs/devbox/images).


## Build

```sh
devbox image build . --name=basebox-$(date +%d%b | tr A-Z a-z) -f .devbox/Dockerfile
```

The build runs on Namespace's remote builders — no local Docker required. The
image is published to the workspace and available immediately for creating
devboxes.

## Create a devbox

Use the image name from the build:

```sh
devbox create --image=basebox-10feb
```

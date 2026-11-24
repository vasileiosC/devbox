# Devbox

A disposable development environment on Namespace, built and configured from this repo. Cross-repo terms (Orchestrator, Agent, Practice) live in the Notion Vocabulary Practice.

## Environment

**Image**:
The artefact built from `install/Dockerfile`: packages, the `devbox` user and dotfiles. Holds no repos and no secrets.
_Avoid_: basebox (an Image name tag only), container

**Blueprint**:
The Namespace configuration that creates a Devbox from an Image, clones this repo and runs Bootstrap.
_Avoid_: template, spec

**Devbox**:
One running environment created from the Blueprint.
_Avoid_: box, container, VM

## Startup

**Boot**:
Namespace's own startup steps on a Devbox, outside this repo's control, which edit `~/.gitconfig` before the repo is cloned.
_Avoid_: startup, init

**Bootstrap**:
This repo's `install/install.sh`, run by the Blueprint after Boot and the clone.
_Avoid_: init script, install, setup

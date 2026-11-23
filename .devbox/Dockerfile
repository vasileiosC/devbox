FROM ubuntu:24.04

# Install common development tools.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sudo \
    git \
    git-lfs \
    gnupg \
    locales \
    unzip \
    vim \
    zsh \
    xz-utils \
    curl \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Locale
RUN locale-gen en_GB.UTF-8
ENV LANG=en_GB.UTF-8 \
    LC_ALL=en_GB.UTF-8

# Create a non-root user with passwordless sudo.
RUN adduser --disabled-password --gecos "" --uid 1001 devbox \
    && echo "devbox ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/devbox \
    && chmod 0440 /etc/sudoers.d/devbox

# 1password CLI
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list && \
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
  sudo apt update && sudo apt install 1password-cli

# GitHub CLI
RUN apt-get update \
 && apt-get install -y wget \
 && mkdir -p -m 755 /etc/apt/keyrings \
 && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
 && cat $out > /etc/apt/keyrings/githubcli-archive-keyring.gpg \
 && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
 && mkdir -p -m 755 /etc/apt/sources.list.d \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
 && apt-get update \
 && apt-get install -y gh \
 && rm -rf /var/lib/apt/lists/*

# Go toolchain
COPY --from=golang:1.27 /usr/local/go /usr/local/go
ENV PATH="/usr/local/go/bin:${PATH}"

# gopls
RUN GOBIN=/usr/local/bin go install golang.org/x/tools/gopls@latest \
 && rm -rf /root/go /root/.cache/go-build

# golangci-lint (official prebuilt binary)
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh \
    | sh -s -- -b /usr/local/bin

# Set the default user for terminal sessions.
USER devbox
WORKDIR /home/devbox


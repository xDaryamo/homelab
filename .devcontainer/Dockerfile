FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# 1. Install OS dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    build-essential \
    curl \
    git \
    unzip \
    ripgrep \
    fd-find \
    xclip \
    # Ubuntu installs 'fd' as 'fdfind' due to a naming conflict.
    # We create a symlink because LazyVim/Neovim plugins expect the binary to be named 'fd'.
    && ln -s $(which fdfind) /usr/local/bin/fd \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# 2. Install Mise (Version Manager)
COPY --from=jdxcode/mise:latest /usr/local/bin/mise /usr/local/bin/mise

# 3. Configure Mise activation
USER vscode

# Hook mise into the shell configuration files.
RUN echo 'eval "$(mise activate bash)"' >> /home/vscode/.bashrc \
    && echo 'eval "$(mise activate zsh)"' >> /home/vscode/.zshrc

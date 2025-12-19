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
    tmux \
    # Ubuntu installs 'fd' as 'fdfind' due to a naming conflict.
    # We create a symlink because LazyVim/Neovim plugins expect the binary to be named 'fd'.
    && ln -s $(which fdfind) /usr/local/bin/fd \
    && curl -sSL https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info | tic -x - \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# 2. Install Mise (Version Manager)
COPY --from=jdxcode/mise:latest /usr/local/bin/mise /usr/local/bin/mise

# 3. Configure Mise activation
USER vscode

# Hook mise into the shell configuration files.
RUN echo 'eval "$(mise activate bash)"' >> /home/vscode/.bashrc \
    && echo 'source /usr/share/bash-completion/bash_completion' >> /home/vscode/.bashrc \
    && echo 'if command -v kubectl &> /dev/null; then source <(kubectl completion bash); fi' >> /home/vscode/.bashrc \
    && echo 'alias k=kubectl' >> /home/vscode/.bashrc \
    && echo 'complete -o default -F __start_kubectl k' >> /home/vscode/.bashrc

# Optional if zsh is installed.
RUN echo 'eval "$(mise activate zsh)"' >> /home/vscode/.zshrc \
    && echo 'alias k=kubectl' >> /home/vscode/.zshrc

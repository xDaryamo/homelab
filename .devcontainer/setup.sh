#!/bin/bash
set -e
# 1. Install Flux CLI
curl -s https://fluxcd.io/install.sh | sudo bash
# 2. Install K9s
curl -sS https://webinstall.dev/k9s | bash
# 3. Install LazyVim deps (ripgrep, fd, build tools)
sudo apt-get update && sudo apt-get install -y ripgrep fd-find build-essential ncurses-term
# 4. Configure LazyVim
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/LazyVim/starter $HOME/.config/nvim rm -rf $HOME/.config/nvim/.git
fi

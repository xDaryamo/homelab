#!/bin/bash
set -e

echo "Starting workspace setup..."

# 1. Install Tools via Mise
echo "Installing tools defined in mise.toml..."
mise trust
mise install --yes

# 2. Configure LazyVim
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "Cloning LazyVim starter configuration..."
  git clone https://github.com/LazyVim/starter $HOME/.config/nvim

  rm -rf $HOME/.config/nvim/.git
else
  echo "Neovim configuration already exists. Skipping."
fi

echo "Setup complete!"

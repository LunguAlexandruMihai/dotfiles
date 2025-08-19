#!/bin/bash

set -e

# Install zsh
sudo pacman -S zsh --noconfirm --needed

# Install Oh My Zsh (unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install candy theme
THEME_DIR="$HOME/.oh-my-zsh/custom/themes"
mkdir -p "$THEME_DIR"
if [ ! -d "$THEME_DIR/candy-zsh" ]; then
    git clone https://github.com/candycane/candy-zsh.git "$THEME_DIR/candy-zsh"
fi

# Change shell to zsh
chsh -s "$(which zsh)"

echo "zsh, Oh My Zsh, and candy theme installed."
echo "Logging out to apply changes..."

# Logout user
pkill -KILL -u "$USER"
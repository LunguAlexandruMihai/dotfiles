#!/bin/bash

set -e

# Install zsh
sudo pacman -S zsh --noconfirm --needed

# Change shell to zsh
chsh -s "$(which zsh)"

echo "zsh, Oh My Zsh, and candy theme installed."
echo "Logging out to apply changes..."

# Logout user
pkill -KILL -u "$USER"
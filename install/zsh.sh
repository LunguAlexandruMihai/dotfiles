#!/bin/bash

set -e

# Install zsh
sudo pacman -S zsh --noconfirm --needed

# Change shell to zsh
chsh -s "$(which zsh)"

# Logout user
pkill -KILL -u "$USER"

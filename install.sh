#!/usr/bin/env bash
set -euo pipefail

cd ~/dotfiles

chmod +x install.sh
chmod +x install/*

have() { command -v "$1" &>/dev/null; }

if ! have yay; then
  cd /tmp
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
  cd ~
  rm -rf /tmp/yay-bin
  cd ~/dotfiles
fi

if ! have gum; then
  echo "gum not found."
  if pacman -Si gum &>/dev/null; then
    echo "Installing gum from official repos..."
    sudo pacman -S --noconfirm gum
  else
    echo "Installing gum from AUR via yay..."
    yay -S --noconfirm gum
  fi
fi

if ! have zsh; then
  gum style --border double --padding "1 2" --border-foreground 212 "zsh is not installed. Starting zsh setup..."
  source ~/dotfiles/install/zsh.sh
  exit 0
fi

gum style --border double --padding "1 2" --border-foreground 212 "zsh is already installed."


source ~/dotfiles/install/requirements.sh
source ~/dotfiles/install/configs.sh

source ~/dotfiles/install/desktop/apps.sh
source ~/dotfiles/install/desktop/applestudiocontrol.sh
source ~/dotfiles/install/desktop/flatpaks.sh

source ~/dotfiles/install/shell.sh
source ~/dotfiles/install/devel.sh

gum style --border rounded --padding "1 2" --border-foreground 35 "All selected steps completed."

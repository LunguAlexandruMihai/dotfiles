#!/bin/bash

set -euo pipefail

mkdir -p ~/Screenshots

cp -R ~/dotfiles/defaults/config/* ~/.config/

cp ~/dotfiles/defaults/.zsh_profile ~/
cp ~/dotfiles/defaults/.zsh_aliases ~/

echo 'source ~/.zsh_profile' >> ~/.zshrc
echo 'source ~/.zsh_aliases' >> ~/.zshrc

source ~/.zshrc

if [[ ! -f /etc/modprobe.d/disable-usb-autosuspend.conf ]]; then
  echo "options usbcore autosuspend=-1" | sudo tee /etc/modprobe.d/disable-usb-autosuspend.conf
fi

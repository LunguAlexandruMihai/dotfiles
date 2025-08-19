#!/bin/bash

set -euo pipefail

mkdir -p ~/Screenshots

cp -R ~/dotfiles/config/* ~/.config/

mkdir -p ~/.local/share/themes
cp -R ~/dotfiles/local/share/theme/* ~/.local/share/theme/

cp ~/dotfiles/defaults/.zsh_profile ~/
cp ~/dotfiles/defaults/.zsh_aliases ~/

echo 'source ~/.zsh_profile' >> ~/.zshrc
echo 'source ~/.zsh_aliases' >> ~/.zshrc

if [[ ! -f /etc/modprobe.d/disable-usb-autosuspend.conf ]]; then
  echo "options usbcore autosuspend=-1" | sudo tee /etc/modprobe.d/disable-usb-autosuspend.conf
fi

#!/bin/bash

mkdir -p ~/.local/share/applications/
mkdir -p ~/.icons
mkdir -p ~/.local/bin
cp -R ~/dotfiles/applications/* ~/.local/share/applications/
cp -R ~/dotfiles/icons/* ~/.icons
cp -R ~/dotfiles/bin/* ~/.local/bin


elephant service enable

source ~/dotfiles/install/desktop/applestudiocontrol.sh
source ~/dotfiles/install/desktop/flatpaks.sh

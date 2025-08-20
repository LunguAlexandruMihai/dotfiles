#!/bin/bash

mkdir -p ~/.local/share/applications/
mkdir -p ~/.icons

cp -R ~/dotfiles/applications/* ~/.local/share/applications/
cp -R ~/dotfiles/icons/* ~/.icons
cp -R ~/dotfiles/bin/* ~/.local/bin
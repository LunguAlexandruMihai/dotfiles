#!/bin/bash

set -euo pipefail

cp -R ~/dotfiles/config/* ~/.config/

mkdir -p ~/.local/share/themes/my
cp -R ~/dotfiles/local/share/themes/my/* ~/.local/share/themes/my/

cp ~/dotfiles/defaults/.zsh_profile ~/
cp ~/dotfiles/defaults/.zsh_aliases ~/

echo 'source ~/.zsh_profile' >> ~/.zshrc
echo 'source ~/.zsh_aliases' >> ~/.zshrc

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
git config --global init.defaultBranch master

git config --global user.name "Lungu Alexandru"
git config --global user.email "lungualexandrumihai@gmail.com"

source ~/.zshrc
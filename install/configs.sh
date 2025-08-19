#!/bin/bash

set -euo pipefail

cp -R ~/dotfiles/config/* ~/.config/

mkdir -p ~/.local/share/themes/my
cp -R ~/dotfiles/local/share/themes/my/* ~/.local/share/themes/my/

echo 'source ~/.zsh_profile' >> ~/.zshrc

touch ~/.zsh_profile
echo 'eval "$(mise activate zsh)"' >> ~/.zsh_profile
echo 'eval "$(zoxide init bash)"' >> ~/.zsh_profile
echo 'export EDITOR="nvim"' >> ~/.zsh_profile
echo 'HYPRSHOT_DIR="~/Screenshots"' >> ~/.zsh_profile
echo 'export SUDO_EDITOR="$EDITOR"' >> ~/.zsh_profile
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zsh_profile

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
git config --global init.defaultBranch master

git config --global user.name "Lungu Alexandru"
git config --global user.email "lungualexandrumihai@gmail.com"

source ~/.zshrc
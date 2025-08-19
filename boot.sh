#!/bin/bash

set -euo pipefail

sudo pacman -Sy --noconfirm --needed git

git clone "git@github.com:LunguAlexandruMihai/dotfiles.git" ~/ >/dev/null

source ~/dotfiles/install.sh
#!/usr/bin/env bash

set -euo pipefail

conf="/etc/pacman.conf"
sudo cp -a "$conf" "$conf.bak-$(date +%Y%m%d-%H%M%S)"
sudo sed -i \
  -e 's/^[[:space:]]*#[[:space:]]*\[multilib\][[:space:]]*$/[multilib]/' \
  -e 's/^[[:space:]]*#[[:space:]]*Include[[:space:]]*=[[:space:]]*\/etc\/pacman\.d\/mirrorlist[[:space:]]*$/Include = \/etc\/pacman.d\/mirrorlist/' \
  "$conf"
sudo pacman -Sy
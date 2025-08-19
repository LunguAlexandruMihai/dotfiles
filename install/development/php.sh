#!/bin/bash

set -euo pipefail

if [[ ":$PATH:" != *":$HOME/.config/composer/vendor/bin:"* ]]; then
    echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >>"$HOME/.zsh_profile"
    source "$HOME/.zshrc"
fi

local php_ini_path="/etc/php/php.ini"
local extensions_to_enable=(
    "bcmath"
    "intl"
    "iconv"
    "openssl"
    "pdo_sqlite"
    "pdo_mysql"
)

for ext in "${extensions_to_enable[@]}"; do
    sudo sed -i "s/^;extension=${ext}/extension=${ext}/" "$php_ini_path"
done


composer global require laravel/installer
yay -S symfony-cli --noconfirm

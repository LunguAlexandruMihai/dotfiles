#!/bin/bash

yay -Sy php composer php-sqlite --noconfirm

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

mise use --global ruby@3.4.2
mise use ruby@latest
mise settings add idiomatic_version_file_enable_tools ruby
mise x ruby -- gem install rails --no-document
mise use --global python@latest
mise use --global node@lts
mise use --global go@latest
composer global require laravel/installer
yay -S symfony-cli --noconfirm
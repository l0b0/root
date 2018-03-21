#!/bin/sh
set -o errexit -o xtrace

packages=(
    bash-completion
    dmidecode
    gdb
    virtualbox-guest-utils
)
for package in "${packages[@]}"
do
    if pacman --query "$package"
    then
        pacman --noconfirm --nodeps --nodeps --remove "$package"
    else
        echo "Warning: Package was not installed: ${package}" >&2
    fi
done

pacman-key --refresh-keys
pacman --sync --refresh --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils
pacman --sync --refresh --sysupgrade --noconfirm
pacman-db-upgrade
pacman --sync --needed --refresh --noconfirm puppet ruby ruby-shadow
rm -f ~root/.profile ~vagrant/.profile

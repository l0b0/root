#!/bin/sh
set -o errexit -o xtrace
pacman --remove --noconfirm ack bash-completion cloc colordiff cowsay dd_rescue ddrescue dmidecode dstat ethtool \
    figlet fortune-mod gdb glances htop hwinfo inxi lshw lsof nethogs ngrep nmap ponysay pv ranger reptyr sl smem \
    sshfs stow strace tmux yaourt zsh
pacman-key --refresh-keys
pacman --sync --refresh --sysupgrade --noconfirm
pacman-db-upgrade
pacman --sync --needed --refresh --noconfirm puppet ruby ruby-shadow
rm -f ~root/.profile ~vagrant/.profile

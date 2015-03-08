#!/bin/sh
set -o errexit -o xtrace
pacman --remove --noconfirm ack bash-completion cloc colordiff cowsay dd_rescue ddrescue dmidecode dnsutils dstat \
    ethtool figlet fortune-mod gdb glances htop hwinfo inxi lshw lsof nethogs ngrep nmap ponysay pv ranger reptyr sl \
    smem sshfs stow strace tmux yaourt zsh
pacman --sync --refresh --sysupgrade --noconfirm
pacman-db-upgrade
pacman --sync --needed --refresh --noconfirm puppet ruby ruby-shadow
sudo --user=vagrant gem install --version 1.1.0 --no-document --user-install puppet-lint
sudo --user=vagrant gem install --version 1.3.8 --no-document --user-install reek
rm -f ~root/.profile ~vagrant/.profile

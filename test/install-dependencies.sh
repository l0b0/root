#!/bin/sh
pacman --sync --needed --refresh --noconfirm puppet
sudo -u vagrant gem install --version 1.1.0 --no-document --user-install puppet-lint

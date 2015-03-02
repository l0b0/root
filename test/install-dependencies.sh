#!/bin/sh
set -o errexit
pacman --sync --needed --refresh --noconfirm puppet ruby ruby-shadow
sudo --user=vagrant gem install --version 1.1.0 --no-document --user-install puppet-lint
sudo --user=vagrant gem install --version 1.3.8 --no-document --user-install reek
rm -f ~root/.profile ~vagrant/.profile

#!/bin/sh
pacman --sync --needed --refresh --noconfirm puppet
sudo -u vagrant gem install --version 1.1.0 --no-document --user-install puppet-lint
sudo -u vagrant gem install --version 1.3.8 --no-document --user-install reek

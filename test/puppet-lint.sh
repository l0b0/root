#!/bin/sh
find /vagrant/manifests /vagrant/modules \
    \( -path /vagrant/modules/stdlib -o -path /vagrant/modules/ufw \) -prune -false -o \
    -type f -name '*.pp' \
    -exec ~/.gem/ruby/*/gems/puppet-lint-*/bin/puppet-lint --fail-on-warnings --no-documentation-check {} +

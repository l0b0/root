#!/bin/sh
find /vagrant \
    \( -path /vagrant/modules/stdlib -o -path /vagrant/modules/ufw \) -prune -false -o \
    -type f \( -name '*.rb' -o -name Vagrantfile \) \
    -exec ~/.gem/ruby/*/gems/reek-*/bin/reek --verbose {} +
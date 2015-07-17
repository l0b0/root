#!/bin/sh
find /vagrant \
    \( \
        -path /vagrant/modules/idea -o \
        -path /vagrant/modules/stdlib -o \
        -path /vagrant/modules/ufw \
    \) -prune -o \
    \( \
        -type f \( -name '*.rb' -o -name Vagrantfile \) \
        -exec reek --verbose {} + \
    \)

#!/usr/bin/env bash

vm_command <<'EOF'
set -o errexit -o noclobber -o nounset -o xtrace

vm_test_date=2000-01-01
vm_test_date_format=%Y-%m-%d

sudo systemctl stop ntpd.service
sudo systemctl stop vboxservice.service

sudo timedatectl set-timezone UTC
sudo timedatectl set-time "$vm_test_date"

[ "$(date --utc "+${vm_test_date_format}")" = "$vm_test_date" ]

sudo systemctl start ntpd.service

tries=30

while true
do
    if [ "$(date --utc "+${vm_test_date_format}")" = "$(date "+${vm_test_date_format}")" ]
    then
        break
    else
        sleep 1s
        let --tries
    fi
done

sudo systemctl start vboxservice.service
EOF

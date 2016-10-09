#!/usr/bin/env bash

for _ in $(seq 6)
do
    ! ssh -p 2222 -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no vagrant@127.0.0.1
done

! vm_command 'exit'

sleep 31s

vm_command 'exit'

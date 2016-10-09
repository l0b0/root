#!/usr/bin/env bash

vm_command 'sshfs -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null 127.0.0.1: "$(mktemp --directory)"'

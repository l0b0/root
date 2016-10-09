#!/usr/bin/env bash

vm_command 'systemctl status --no-pager sshd || service ssh status'

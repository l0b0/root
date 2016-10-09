#!/usr/bin/env bash

vm_command 'systemctl status --no-pager display-manager.service | grep lightdm.service || service lightdm status'

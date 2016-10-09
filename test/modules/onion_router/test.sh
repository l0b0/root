#!/usr/bin/env bash

vm_command '(torify curl https://check.torproject.org/ | grep -F "Congratulations. This browser is configured to use Tor.")'

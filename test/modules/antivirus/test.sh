#!/usr/bin/env bash

vm_command 'sudo freshclam'
vm_command 'sudo clamscan --quiet /usr/bin'

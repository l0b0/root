#!/usr/bin/env bash

vm_command 'curl example.com; [[ $? -eq 7 ]]'

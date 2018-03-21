#!/usr/bin/env bash

[[ "$(vm_command 'crontab -l 2>&1')" = "no crontab for vagrant" ]]

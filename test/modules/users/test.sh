#!/usr/bin/env bash

[[ "$(vm_command 'sudo passwd --status root')" =~ ^root\ L\ .*$ ]]

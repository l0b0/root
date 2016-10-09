#!/usr/bin/env bash

test "$(vm_command 'bc <<< 2+2')" -eq 4

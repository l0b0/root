#!/usr/bin/env bash

vm_command 'aspell dump dicts'
vm_command 'echo | LANG=C hunspell -D'

#!/usr/bin/env bash

gpg_public_key_fingerprint=92126B54

vm_command gpg --keyserver keys.gnupg.net --recv-keys "$gpg_public_key_fingerprint"

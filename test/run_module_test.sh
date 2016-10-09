#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o xtrace

vm_command() {
    vagrant ssh ${@+--command "$@"}
}

. "$@"

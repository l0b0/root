#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_directory="$(dirname "$directory")"

find "${repository_directory}" \
    \( \
        -path "${repository_directory}/modules/archive" -o \
        -path "${repository_directory}/modules/idea" -o \
        -path "${repository_directory}/modules/stdlib" -o \
        -path "${repository_directory}/modules/ufw" \
    \) -prune -o \
    \( \
        -type f \( -name '*.rb' -o -name Vagrantfile \) \
        -exec reek {} + \
    \)

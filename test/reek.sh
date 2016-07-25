#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail -o xtrace

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_directory="$(dirname "${directory}")"

find "${project_directory}" \
    \( \
        -path "${project_directory}/modules/idea" -o \
        -path "${project_directory}/modules/stdlib" -o \
        -path "${project_directory}/modules/ufw" \
    \) -prune -o \
    \( \
        -type f \( -name '*.rb' -o -name Vagrantfile \) \
        -exec reek {} + \
    \)

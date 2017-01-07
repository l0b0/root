#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_directory="$(dirname "$directory")"

find "${repository_directory}" \
    -not -path "${repository_directory}/modules/archive/*" \
    -not -path "${repository_directory}/modules/idea/*" \
    -not -path "${repository_directory}/modules/stdlib/*" \
    -not -path "${repository_directory}/modules/ufw/*" \
    -type f \( -name '*.rb' -o -name Vagrantfile \) \
    -exec reek {} +

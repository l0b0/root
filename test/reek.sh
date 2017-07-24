#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_directory="$(dirname "$directory")"

find "${repository_directory}" \
    -not -path "${repository_directory}/vendor/*" \
    -type f \( -name '*.rb' -o -name Vagrantfile \) \
    -exec reek {} +

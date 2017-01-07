#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_directory="$(dirname "$directory")"

find "${repository_directory}/manifests" "${repository_directory}/modules" \
    -not -path "${repository_directory}/modules/archive/*" \
    -not -path "${repository_directory}/modules/idea/*" \
    -not -path "${repository_directory}/modules/stdlib/*" \
    -not -path "${repository_directory}/modules/ufw/*" \
    -type f -name '*.pp' \
    -exec puppet-lint --fail-on-warnings --no-documentation-check {} +

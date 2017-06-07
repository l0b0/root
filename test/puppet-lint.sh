#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_directory="$(dirname "$directory")"

find "${repository_directory}/manifests" "${repository_directory}/modules" \
    -type f -name '*.pp' \
    -exec puppet-lint --fail-on-warnings --no-documentation-check {} +

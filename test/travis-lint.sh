#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail -o xtrace

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_directory="$(dirname "${directory}")"

travis-lint "${project_directory}/.travis.yml"

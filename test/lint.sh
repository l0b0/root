#!/usr/bin/env bash
set -o errexit -o noclobber -o nounset

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATH="$(gem env gempath | tr ':' '\n' | sed 's#$#/bin#' | tr '\n' ':'):$PATH"

export PATH

"${directory}/puppet-lint.sh"
"${directory}/reek.sh"

#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail -o xtrace

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PATH="$(set -o errexit && gem env gempath | tr ':' '\n' | sed 's#$#/bin#' | tr '\n' ':'):$PATH"

export PATH

"${directory}/puppet-lint.sh"
"${directory}/reek.sh"
"${directory}/travis-lint.sh"

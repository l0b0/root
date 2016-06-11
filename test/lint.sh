#!/bin/sh
set -o errexit -o noclobber -o nounset -o xtrace

dir=/vagrant/test
PATH="$(gem env gempath | tr ':' '\n' | sed 's#$#/bin#' | tr '\n' ':')/bin:$PATH"

export PATH

"${dir}/puppet-lint.sh"
"${dir}/reek.sh"
"${dir}/travis-lint.sh"

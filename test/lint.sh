#!/bin/sh
set -o errexit -o noclobber -o nounset -o xtrace

dir=/vagrant/test
PATH="$("$GEM" env gempath | tr ':' '\n' | sed 's#$#/bin#' | tr '\n' ':'):$PATH"

export PATH

"${dir}/puppet-lint.sh"
"${dir}/reek.sh"

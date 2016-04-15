#!/bin/sh
set -o errexit -o noclobber -o nounset -o xtrace

dir=/vagrant/test
export GEM_PATH="$(gem env gempath | tr ':' '\n' | sed 's#$#/bin#' | tr '\n' ':')"
export PATH="${GEM_PATH}/bin:$PATH"

"${dir}/puppet-lint.sh"
"${dir}/reek.sh"
"${dir}/travis-lint.sh"

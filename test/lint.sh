#!/bin/sh
set -o errexit -o noclobber -o nounset -o xtrace

dir=/vagrant/test
GEM_PATH="$(rvm gem env gempath | tr ':' '\n' | sed 's#$#/bin#' | tr '\n' ':')"
PATH="${GEM_PATH}/bin:$PATH"

export GEM_PATH PATH

"${dir}/puppet-lint.sh"
"${dir}/reek.sh"
"${dir}/travis-lint.sh"

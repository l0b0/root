#!/bin/sh
set -o errexit -o noclobber -o nounset -o xtrace

dir=/vagrant/test
export GEM_PATH="$(ruby -e 'print Gem.user_dir')"
export PATH="${GEM_PATH}/bin:$PATH"

"${dir}/puppet-lint.sh"
"${dir}/reek.sh"
"${dir}/travis-lint.sh"

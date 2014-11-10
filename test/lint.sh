#!/bin/sh
set -o errexit -o noclobber -o nounset

dir=/vagrant/test
gem_user_dir="$(ruby -e 'print Gem.user_dir')"

export PATH="${gem_user_dir}/bin:$PATH"

"${dir}/puppet-lint.sh"
"${dir}/reek.sh"

# == Class: idea
#
# Install IntelliJ IDEA from the official vendor site.
# The required Java runtime environment will not be installed automatically.
#
# === Parameters
#
# [*version*]
#   Specify the version of IntelliJ IDEA which should be installed.
#
# [*url*]
#   Specify the absolute URL of the IntelliJ IDEA tarball. This overrides any
#   version which has been set before.
#
# [*target*]
#   Specify the location of the symlink to the IntelliJ IDEA installation on
#   the local filesystem.
#
# [*timeout*]
#   Download timeout passed to archive module.
#
# === Variables
#
# The variables being used by this module are named exactly like the class
# parameters with the prefix 'idea_', e. g. *idea_version* and *idea_url*.
#
# === Examples
#
#  class { 'idea':
#    version => '12.1.3',
#  }
#
# === Authors
#
# Jochen Schalanda <j.schalanda@smarchive.de>
#
# === Copyright
#
# Copyright 2012, 2013 smarchive GmbH
#
class idea (
  $version = undef,
  $url     = undef,
  $target  = undef,
  $timeout = undef,
) {
  class { 'idea::community':
    version => $version,
    url     => $url,
    target  => $target,
    timeout => $timeout,
  }
}

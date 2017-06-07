# == Class: idea::ultimate
#
# Install IntelliJ IDEA Ultimate Edition from the official vendor site.
# The required Java runtime environment will not be installed automatically.
#
# === Parameters
#
# [*version*]
#   Specify the version of IntelliJ IDEA which should be installed.
#
# [*base_url*]
#   Specify the base URL of the IntelliJ IDEA tarball. Usually this doesn't
#   need to be changed.
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
#  class { 'idea::ultimate':
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
class idea::ultimate (
  $version  = undef,
  $base_url = undef,
  $url      = undef,
  $target   = undef,
  $timeout  = undef,
) {

  include idea::params

  $version_real = $version ? {
    undef   => $::idea::params::version,
    default => $version,
  }

  $base_url_real = $base_url ? {
    undef   => $::idea::params::base_url,
    default => $base_url,
  }

  $url_real = $url ? {
    undef   => "${base_url_real}/ideaIU-${version_real}.tar.gz",
    default => $url,
  }

  $target_real = $target ? {
    undef   => $::idea::params::target,
    default => $target,
  }

  $timeout_real = $timeout ? {
    undef   => $::idea::params::timeout,
    default => $timeout,
  }

  class { 'idea::base':
    version => $version_real,
    url     => $url_real,
    target  => $target_real,
    timeout => $timeout_real,
  }
}

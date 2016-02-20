File {
  owner => root,
  group => 0,
  mode  => '0600',
}

if versioncmp($::puppetversion,'3.6.1') >= 0 {
  Package {
    allow_virtual => false,
  }
}

include dvcs
include firewall

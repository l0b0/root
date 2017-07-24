class hypervisor {
  package { 'virtualbox-host-modules-arch':
    ensure => latest,
  } -> package { 'virtualbox':
    ensure => latest,
  }
}

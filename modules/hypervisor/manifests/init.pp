class hypervisor {
  package { 'virtualbox-host-modules-arch':
    ensure => latest,
  } -> package { 'virtualbox':
    ensure => latest,
  }

  warning("Make sure to add VirtualBox users to the 'vboxusers' group.")
}

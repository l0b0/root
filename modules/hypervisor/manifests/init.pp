class hypervisor {
  package { 'virtualbox-host-modules-arch':
    ensure => installed,
  } -> package { 'virtualbox':
    ensure => installed,
  }

  warning("Make sure to add VirtualBox users to the 'vboxusers' group.")
}

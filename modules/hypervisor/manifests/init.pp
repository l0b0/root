class hypervisor (
  $ensure = latest,
) {
  package { 'virtualbox-host-modules-arch':
    ensure => $ensure,
  } -> package { 'virtualbox':
    ensure => $ensure,
  }

  if ($ensure != absent) {
    warning("Make sure to add VirtualBox users to the 'vboxusers' group.")
  }
}

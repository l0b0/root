class service_discovery_system (
  $enable = true,
) {
  require printing_system

  $package_ensure = str2bool($enable) ? {
    true    => latest,
    default => absent,
  }
  $service_ensure = str2bool($enable) ? {
    true    => running,
    default => stopped,
  }

  package { 'avahi':
    ensure => $package_ensure,
  } ~> service { 'avahi-daemon':
    ensure => $service_ensure,
    enable => $enable,
    notify => Service[$::printing_system::browser_service],
  }
}

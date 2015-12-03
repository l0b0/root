class service_discovery_system (
  $package = undef,
) {
  if ($package != undef) {
    package { 'avahi':
      ensure => latest,
    }~>
    service { 'avahi-daemon':
      ensure => running,
      enable => true,
      notify => Service[hiera('printing_system::browser_service')],
    }
  }
}

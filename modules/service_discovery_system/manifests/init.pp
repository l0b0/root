class service_discovery_system {
  require printing_system

  package { 'avahi':
    ensure => latest,
  }~>
  service { 'avahi-daemon':
    ensure => running,
    enable => true,
    notify => Service[$::printing_system::browser_service],
  }
}

class ntpd (
  $service,
) {
  package { 'ntp':
    ensure => latest,
  }~>
  service { $service:
    ensure => running,
    enable => true,
  }
}

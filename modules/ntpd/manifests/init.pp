class ntpd {
  package { 'ntp':
    ensure => latest,
  } ~> service { 'ntpd':
    ensure => running,
    enable => true,
  }
}

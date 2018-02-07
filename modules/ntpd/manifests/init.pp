class ntpd {
  package { 'ntp':
    ensure => installed,
  } ~> service { 'ntpd':
    ensure => running,
    enable => true,
  }
}

class bandwidth_monitor {
  include shell

  package { 'iftop':
    ensure => installed,
  }
}

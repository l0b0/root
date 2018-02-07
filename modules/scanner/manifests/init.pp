class scanner {
  include window_manager

  package { 'simple-scan':
    ensure => installed,
  }
}

class planetarium {
  include window_manager

  package { 'stellarium':
    ensure => installed,
  }
}

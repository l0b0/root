class password_manager {
  include window_manager

  package { 'keepassxc':
    ensure => installed,
  }
  package { 'keepassx':
    ensure => absent,
  }
}

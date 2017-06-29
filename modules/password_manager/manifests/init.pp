class password_manager {
  include window_manager

  package { 'keepassxc':
    ensure => latest,
  }
  package { 'keepassx':
    ensure => absent,
  }
}

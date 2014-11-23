class password_manager {
  include window_manager

  package { 'keepassx':
    ensure => latest,
  }
}

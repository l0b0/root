class password_manager {
  package { 'keepassx':
    ensure => latest,
  }
}

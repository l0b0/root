class window_manager {
  include display_manager

  package { 'awesome':
    ensure => latest,
  }
}

class window_manager {
  include login_manager

  package { 'awesome':
    ensure => latest,
  }
}

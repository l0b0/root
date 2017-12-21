class office_suite {
  include window_manager

  package { 'libreoffice-still':
    ensure => latest,
  }
}

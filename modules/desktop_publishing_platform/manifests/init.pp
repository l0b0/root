class desktop_publishing_platform {
  include window_manager

  package { 'scribus':
    ensure => installed,
  }
}

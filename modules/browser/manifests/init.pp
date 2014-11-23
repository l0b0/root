class browser {
  include window_manager

  package { 'firefox':
    ensure => latest,
  }
}

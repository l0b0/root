class browser {
  include window_manager

  package { ['chromium', 'firefox']:
    ensure => installed,
  }
}

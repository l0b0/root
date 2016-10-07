class screen_locker {
  include window_manager

  package { ['slock', 'xss-lock']:
    ensure => latest,
  }
}

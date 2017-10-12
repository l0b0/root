class screen_locker {
  include window_manager

  package { 'xscreensaver':
    ensure => latest,
  }
}

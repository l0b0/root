class screen_locker {
  include window_manager

  package { 'slock':
    ensure => latest,
  }
}

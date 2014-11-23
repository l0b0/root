class screen_grabber {
  include window_manager

  package { 'scrot':
    ensure => latest,
  }
}

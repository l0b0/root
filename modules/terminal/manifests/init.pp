class terminal {
  include window_manager

  package { 'xterm':
    ensure => latest,
  }
}

class terminal {
  include shell
  include window_manager

  package { 'xterm':
    ensure => latest,
  }
}

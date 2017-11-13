class terminal {
  include shell
  include window_manager

  package { ['xterm', 'rxvt-unicode']:
    ensure => latest,
  }
}

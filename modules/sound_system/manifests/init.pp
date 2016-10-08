class sound_system {
  include window_manager

  package { ['pavucontrol', 'pulseaudio']:
    ensure => latest,
  }
}

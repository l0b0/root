class sound_system {
  include window_manager

  package { 'pulseaudio':
    ensure => latest,
  }
}

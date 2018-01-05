class bluetooth_audio {
  require bluetooth

  package { ['pulseaudio-bluetooth']:
    ensure => latest,
  }
}

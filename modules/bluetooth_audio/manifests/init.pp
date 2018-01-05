class bluetooth_audio {
  require bluetooth

  package { ['pulseaudio-bluetooth']:
    ensure => latest,
  }

  file { '/etc/pulse/default.pa':
    source => "puppet:///modules/${module_name}/default.pa",
  }

  warning('Please restart PulseAudio after any changes to the packages or configuration.')
}

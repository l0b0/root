class bluetooth_audio {
  require bluetooth

  package { ['pulseaudio-alsa', 'pulseaudio-bluetooth']:
    ensure => installed,
  }

  file { '/etc/pulse/default.pa':
    source => "puppet:///modules/${module_name}/default.pa",
    mode   => '0644',
  }

  warning('Please restart PulseAudio after any changes to the packages or configuration.')
}

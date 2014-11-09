class battery_indicator {
  $ensure = str2bool($::has_battery) ? {
    true    => latest,
    default => absent,
  }

  package { 'cbatticon':
    ensure => $ensure
  }
}

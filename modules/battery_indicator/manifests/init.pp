class battery_indicator {
  $ensure = str2bool($::has_battery) ? {
    true    => installed,
    default => absent,
  }

  package { 'cbatticon':
    ensure => $ensure
  }
}

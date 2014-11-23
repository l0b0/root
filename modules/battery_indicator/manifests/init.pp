class battery_indicator {
  include window_manager

  $ensure = str2bool($::has_battery) ? {
    true    => latest,
    default => absent,
  }

  package { 'cbatticon':
    ensure => $ensure
  }
}

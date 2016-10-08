class battery_indicator (
  $ensure = absent,
) {
  include window_manager

  package { 'cbatticon':
    ensure => $ensure
  }
}

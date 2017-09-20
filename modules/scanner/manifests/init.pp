class scanner (
  $ensure = latest,
) {
  include window_manager

  package { 'simple-scan':
    ensure => $ensure,
  }
}

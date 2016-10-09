class hardware_drivers (
  $intel = false,
) {
  $intel_ensure = str2bool($intel) ? {
    true    => latest,
    default => absent,
  }

  package { 'intel-ucode':
    ensure => $intel_ensure,
  }
}

class advanced_configuration_and_power_interface_daemon (
  $enable = true,
) {
  $package_ensure = str2bool($enable) ? {
    true    => latest,
    default => absent,
  }
  $service_ensure = str2bool($enable) ? {
    true    => running,
    default => stopped,
  }

  package { ['acpi', 'acpid']:
    ensure => $package_ensure,
  } -> service { 'acpid':
    ensure => $service_ensure,
    enable => $enable,
  }
}

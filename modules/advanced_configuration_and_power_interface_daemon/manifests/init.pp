class advanced_configuration_and_power_interface_daemon {
  package { ['acpi', 'acpid']:
    ensure => latest,
  }->
  service { 'acpid':
    ensure => running,
    enable => true,
  }
}

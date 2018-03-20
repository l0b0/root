class storage_hardware_monitor {
  $smart_supported = !$::is_virtual
  $service_ensure = $smart_supported ? {
    true    => running,
    false   => stopped,
    default => fail("Unknown value ${smart_supported}"),
  }

  $package = 'smartmontools'
  $configuration_path = '/etc/smartd.conf'

  package { $package:
    ensure => installed,
  } -> file { $configuration_path:
    ensure => present,
    source => "puppet:///modules/${module_name}/smartd.conf",
  }

  service { 'smartd':
    ensure    => $service_ensure,
    enable    => $smart_supported,
    subscribe => [Package[$package], File[$configuration_path]],
  }
}

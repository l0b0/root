class storage_hardware_monitor {
  $smart_supported = !$::is_virtual
  $service_ensure = $smart_supported ? {
    true    => running,
    false   => stopped,
    default => fail("Unknown value ${smart_supported}"),
  }

  package { 'smartmontools':
    ensure => latest,
  } ~> service { 'smartd':
    ensure => $service_ensure,
    enable => true,
  }
}

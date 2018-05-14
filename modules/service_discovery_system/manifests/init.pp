class service_discovery_system {
  $service_discovery_package = 'avahi'
  $name_service_switch_package = 'nss-mdns'
  $name_service_configuration_file_path = '/etc/nsswitch.conf'

  package { [$service_discovery_package, $name_service_switch_package]:
    ensure => installed,
  }

  file { $name_service_configuration_file_path:
    ensure  => present,
    source  => "puppet:///modules/${module_name}/nsswitch.conf",
    mode    => '0644',
    require => Package[$name_service_switch_package],
  }

  service { 'avahi-daemon':
    ensure    => running,
    enable    => true,
    subscribe => [
      File[$name_service_configuration_file_path],
      Package[$service_discovery_package, $name_service_switch_package]
    ],
    notify    => Service[$::printing_system::browser_service, $::printing_system::printing_service],
  }
}

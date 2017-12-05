class bluetooth {
  include shell

  $service_package = 'bluez'

  package { [$service_package, 'bluez-utils', 'pulseaudio-bluetooth']:
    ensure => latest,
  }

  $configuration_path = '/etc/bluetooth/main.conf'

  file { $configuration_path:
    ensure => present,
    source => "puppet:///modules/${module_name}/main.conf",
  }

  service { 'bluetooth':
    ensure    => running,
    enable    => true,
    subscribe => [File[$configuration_path], Package[$service_package]],
  }
}

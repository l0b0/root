class network_manager {
  include shell

  $service_name = 'wicd'
  $service_conflict_warning = join(
    [
      "Network manager service ${service_name} is running.",
      'Make sure to stop any other network managers to avoid conflict!',
    ],
    ' ')

  package { 'wicd':
    ensure => latest,
  }->
  service { $service_name:
    ensure => running,
    enable => true,
  }

  warning($service_conflict_warning)
}

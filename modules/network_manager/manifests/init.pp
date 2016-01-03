class network_manager (
  $packages,
) {
  include shell

  $service_name = 'wicd'
  $service_conflict_warning = join(
    [
      "Network manager service ${service_name} is running.",
      'Make sure to stop any other network managers to avoid conflict!',
    ],
    ' ')

  package { $packages:
    ensure => latest,
  }->
  service { $service_name:
    ensure => running,
    enable => true,
  }

  warning($service_conflict_warning)
}

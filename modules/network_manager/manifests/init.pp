class network_manager (
  $packages,
  $old_packages,
) {
  include shell

  $service_name = 'netctl-auto@wlp1s0.service'
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
  }->
  package { $old_packages:
    ensure => absent,
  }

  warning($service_conflict_warning)
}

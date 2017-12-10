class process_container (
  $enable = true,
) {
  include shell

  $package_ensure = str2bool($enable) ? {
    true    => latest,
    default => absent,
  }
  $service_ensure = str2bool($enable) ? {
    true    => running,
    default => stopped,
  }

  package { 'docker':
    ensure => $package_ensure,
  } ~> service { 'docker':
    ensure => $service_ensure,
    enable => $enable,
  }

  package { 'docker-compose':
    ensure => $package_ensure,
  }

  if ($enable) {
    warning("Make sure to add privileged users to the 'docker' group.")
  }
}

class process_container {
  include shell

  package { 'docker':
    ensure => installed,
  } ~> service { 'docker':
    ensure => running,
    enable => true,
  }

  package { 'docker-compose':
    ensure => installed,
  }

  warning("Make sure to add privileged users to the 'docker' group.")
}

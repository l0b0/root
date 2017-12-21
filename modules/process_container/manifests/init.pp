class process_container {
  include shell

  package { 'docker':
    ensure => latest,
  } ~> service { 'docker':
    ensure => running,
    enable => true,
  }

  package { 'docker-compose':
    ensure => latest,
  }

  warning("Make sure to add privileged users to the 'docker' group.")
}

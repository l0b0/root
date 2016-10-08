class process_container {
  include shell

  package { 'docker':
    ensure => latest,
  }~>
  service { 'docker':
    ensure => running,
    enable => true,
  }

  warning("Make sure to add privileged users to the 'docker' group.")
}

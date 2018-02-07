class job_scheduler {
  package { 'cronie':
    ensure => installed,
  } ~> service { 'cronie':
    ensure => running,
    enable => true,
  }
}

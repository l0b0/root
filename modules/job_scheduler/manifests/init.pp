class job_scheduler {
  package { 'cronie':
    ensure => latest,
  } ~> service { 'cronie':
    ensure => running,
    enable => true,
  }
}

class job_scheduler {
  package { 'cronie':
    ensure => latest,
  }
}

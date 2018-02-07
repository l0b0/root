class disk_usage_overview_utility {
  include shell

  package { 'ncdu':
    ensure => installed,
  }
}

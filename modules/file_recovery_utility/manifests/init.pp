class file_recovery_utility {
  include shell

  package { 'extundelete':
    ensure => latest,
  }
}

class file_recovery_utility (
  $ensure = latest,
) {
  include shell

  package { 'extundelete':
    ensure => $ensure,
  }
}

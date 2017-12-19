class backup_client {
  include shell

  package { 'borg':
    ensure => latest,
  }
}

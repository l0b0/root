class file_copier {
  include shell

  package { 'rsync':
    ensure => installed,
  }
}

class antivirus {
  include shell

  package { 'clamav':
    ensure => latest,
  }
}

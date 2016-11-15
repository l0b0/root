class antivirus {
  include shell

  package { 'clamav':
    ensure => latest,
  }->
  service { 'clamd':
    ensure => running,
    enable => true,
  }
}

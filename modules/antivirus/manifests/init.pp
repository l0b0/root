class antivirus {
  include shell

  Service {
    ensure => running,
    enable => true,
  }

  package { 'clamav':
    ensure => latest,
  }->
  service { 'freshclamd': }->
  service { 'clamd': }
}

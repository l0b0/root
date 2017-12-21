class antivirus {
  require insecure_http_blocker

  include shell

  Service {
    ensure => running,
    enable => true,
  }

  package { 'clamav':
    ensure => latest,
  } ~> service {
    'freshclamd':
  } ~> exec { '/usr/bin/freshclam':
    user   => clamav,
    before => Service['clamd'],
  }

  service { 'clamd':
    subscribe => [
      Exec['/usr/bin/freshclam'],
      Package['clamav'],
      Service['freshclamd'],
    ],
  }
}

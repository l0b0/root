class antivirus {
  require insecure_http_blocker

  include shell

  Service {
    ensure => running,
    enable => true,
  }

  $package = 'clamav'
  $service = 'clamav-daemon'
  $update_service = 'clamav-freshclam'
  $update_path = '/usr/bin/freshclam'

  package { $package:
    ensure => installed,
  } ~> service { $update_service:
  } ~> exec { $update_path:
    user        => clamav,
    before      => Service[$service],
    refreshonly => true,
  }

  service { $service:
    subscribe => [
      Exec[$update_path],
      Package[$package],
      Service[$update_service],
    ],
  }

  service { ['freshclamd', 'clamd']:
    ensure => stopped,
    enable => false,
    before => Package[$package],
  }
}

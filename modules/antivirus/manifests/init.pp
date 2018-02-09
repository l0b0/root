class antivirus {
  Service {
    ensure => stopped,
    enable => false,
  }

  $package = 'clamav'
  $service = 'clamav-daemon'
  $update_service = 'clamav-freshclam'

  package { $package:
    ensure => absent,
  } ~> service { $update_service: }

  service { $service:
    subscribe => [
      Package[$package],
      Service[$update_service],
    ],
  }
}

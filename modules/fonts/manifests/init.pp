class fonts (
  $packages,
) {
  include display_server

  package { $packages:
    ensure => latest,
  }
}

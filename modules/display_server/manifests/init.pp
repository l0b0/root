class display_server (
  $package,
) {
  package { $package:
    ensure => latest,
  }
}

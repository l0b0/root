class network_analyzer (
  $package,
) {
  include shell

  package { $package:
    ensure => latest,
  }
}

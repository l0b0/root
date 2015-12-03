class flash_plugin (
  $package,
) {
  include browser

  package { $package:
    ensure => latest,
  }
}

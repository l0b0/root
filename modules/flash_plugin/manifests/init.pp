class flash_plugin(
  $package = undef,
) {
  if ($package != undef) {
    include browser

    package { $package:
      ensure => absent,
    }
  }
}

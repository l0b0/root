class python2 (
  $package = undef,
) {
  if ($package != undef) {
    package { $package:
      ensure => latest,
    }
  }
}

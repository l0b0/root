class shell_code_checker (
  $package = undef,
) {
  if ($package != undef) {
    package { $package:
      ensure => latest,
    }
  }
}

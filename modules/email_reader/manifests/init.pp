class email_reader (
  $package = undef,
) {
  if ($package != undef) {
    include window_manager

    package { $package:
      ensure => latest,
    }
  }
}

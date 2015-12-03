class office_suite (
  $package = undef,
) {
  if ($package != undef) {
    include window_manager

    package { $package:
      ensure => latest,
    }
  }
}

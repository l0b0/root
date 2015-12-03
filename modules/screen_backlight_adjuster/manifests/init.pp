class screen_backlight_adjuster (
  $package = undef,
) {
  if ($package != undef) {
    include window_manager

    package { $package:
      ensure => latest,
    }
  }
}

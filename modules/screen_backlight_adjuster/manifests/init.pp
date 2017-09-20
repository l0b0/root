class screen_backlight_adjuster (
  $ensure = latest,
) {
  include window_manager

  package { 'xorg-xbacklight':
    ensure => $ensure,
  }
}

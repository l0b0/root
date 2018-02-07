class screen_backlight_adjuster {
  include window_manager

  package { 'xorg-xbacklight':
    ensure => installed,
  }
}

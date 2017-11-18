class screen_locker {
  include window_manager

  package { 'xscreensaver':
    ensure => latest,
  } -> ::systemd::unit_file { 'suspend@.service':
    source => "puppet:///modules/screen_locker/suspend@.service",
  }

  warning("Make sure to `systemctl enable suspend@\$USER.service` to lock when suspending")
}

class screen_locker {
  require greeter

  package { 'light-locker':
    ensure => installed,
  } -> ::systemd::unit_file { 'suspend@.service':
    source => "puppet:///modules/${module_name}/suspend@.service",
  }

  warning('Make sure to `systemctl enable suspend@$USER.service` to lock when suspending')

  package { 'xscreensaver':
    ensure => absent,
  }
}

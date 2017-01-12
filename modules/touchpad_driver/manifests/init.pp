class touchpad_driver (
  $ensure = absent,
) {
  package { 'xf86-input-libinput':
    ensure => $ensure
  }
}

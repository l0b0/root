class x_server_property_displayer {
  include shell

  package { 'xorg-xprop':
    ensure => installed,
  }
}

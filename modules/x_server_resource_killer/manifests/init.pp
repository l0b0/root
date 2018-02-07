class x_server_resource_killer {
  package { 'xorg-xkill':
    ensure => installed,
  }
}

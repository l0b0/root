class x_server_modifier_map_utility {
  package { 'xorg-xmodmap':
    ensure => latest,
  }
}

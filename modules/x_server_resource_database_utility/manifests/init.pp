class x_server_resource_database_utility {
  package { 'xorg-xrdb':
    ensure => latest,
  }
}

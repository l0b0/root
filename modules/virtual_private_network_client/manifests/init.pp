class virtual_private_network_client {
  package { 'openvpn':
    ensure => latest,
  }
}

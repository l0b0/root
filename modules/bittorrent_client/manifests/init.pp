class bittorrent_client {
  package { 'deluge':
    ensure => latest,
  }
}

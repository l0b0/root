class bittorrent {
  package { 'deluge':
    ensure => latest,
  }
}

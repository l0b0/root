class bittorrent_client {
  include window_manager

  package { 'deluge':
    ensure => latest,
  }
}

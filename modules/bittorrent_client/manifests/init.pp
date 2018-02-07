class bittorrent_client {
  include window_manager

  package { 'transmission-gtk':
    ensure => installed,
  }
}

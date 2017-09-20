class bittorrent_client (
  $ensure = latest,
) {
  include window_manager

  package { 'transmission-gtk':
    ensure => $ensure,
  }
}

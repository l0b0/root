class media_player (
  $ensure = latest,
) {
  include window_manager

  package { 'vlc':
    ensure => $ensure,
  }
}

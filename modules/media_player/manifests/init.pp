class media_player {
  include window_manager

  package { 'vlc':
    ensure => latest,
  }
}

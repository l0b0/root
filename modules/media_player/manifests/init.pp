class media_player {
  package { 'vlc':
    ensure => latest,
  }
}

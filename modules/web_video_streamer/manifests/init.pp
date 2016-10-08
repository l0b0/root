class web_video_streamer {
  include media_player
  include shell

  package { 'livestreamer':
    ensure => latest,
  }
}

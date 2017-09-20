class web_video_streamer (
  $ensure = latest,
) {
  include media_player
  include shell

  package { 'streamlink':
    ensure => $ensure,
  }
}

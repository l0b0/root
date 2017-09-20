class video_downloader (
  $ensure = latest,
) {
  include shell

  package { 'youtube-dl':
    ensure => $ensure,
  }
}

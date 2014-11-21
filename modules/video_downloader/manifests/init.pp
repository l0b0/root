class video_downloader {
  package { 'youtube-dl':
    ensure => latest,
  }
}

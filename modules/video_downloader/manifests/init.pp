class video_downloader {
  include shell

  package { 'youtube-dl':
    ensure => latest,
  }
}

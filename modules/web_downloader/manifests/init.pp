class web_downloader {
  include shell

  package { 'wget':
    ensure => latest,
  }
}

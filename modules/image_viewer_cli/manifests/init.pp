class image_viewer_cli {
  include shell
  include window_manager

  package { 'feh':
    ensure => latest,
  }
}

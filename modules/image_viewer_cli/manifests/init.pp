class image_viewer_cli {
  include window_manager

  package { 'feh':
    ensure => latest,
  }
}

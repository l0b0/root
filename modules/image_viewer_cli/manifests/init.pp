class image_viewer_cli (
  $ensure = latest,
) {
  include shell
  include window_manager

  package { 'feh':
    ensure => $ensure,
  }
}

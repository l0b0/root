class image_viewer (
  $ensure = latest,
) {
  include window_manager

  package { 'eog':
    ensure => $ensure,
  }
}

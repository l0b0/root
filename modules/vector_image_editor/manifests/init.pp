class vector_image_editor (
  $ensure = latest,
) {
  include window_manager

  package { 'inkscape':
    ensure => $ensure,
  }
}

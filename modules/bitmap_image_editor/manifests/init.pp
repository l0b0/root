class bitmap_image_editor (
  $ensure = latest,
) {
  include window_manager

  package { 'gimp':
    ensure => $ensure,
  }
}

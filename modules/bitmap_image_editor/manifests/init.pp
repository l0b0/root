class bitmap_image_editor {
  include window_manager

  package { 'gimp':
    ensure => latest,
  }
}

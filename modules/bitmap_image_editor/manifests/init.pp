class bitmap_image_editor {
  package { 'gimp':
    ensure => latest,
  }
}

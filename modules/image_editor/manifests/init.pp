class image_editor {
  package { 'gimp':
    ensure => latest,
  }
}

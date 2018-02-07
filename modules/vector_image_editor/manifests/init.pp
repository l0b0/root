class vector_image_editor {
  include window_manager

  package { 'inkscape':
    ensure => installed,
  }
}

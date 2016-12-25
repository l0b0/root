class photo_editor {
  include window_manager

  package { ['digikam', 'qt5ct']:
    ensure => latest,
  }
}

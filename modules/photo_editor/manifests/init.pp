class photo_editor {
  include window_manager

  package { ['digikam', 'oxygen-icons', 'qt5ct']:
    ensure => latest,
  }
}

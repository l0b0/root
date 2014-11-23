class photo_editor {
  include window_manager

  package { 'digikam':
    ensure => latest,
  }
}

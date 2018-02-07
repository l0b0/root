class panorama_editor {
  include window_manager

  package { 'hugin':
    ensure => installed,
  }
}

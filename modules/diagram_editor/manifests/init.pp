class diagram_editor {
  include window_manager

  package { 'dia':
    ensure => installed,
  }
}

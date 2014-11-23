class cad_editor {
  include window_manager

  package { 'openscad':
    ensure => latest,
  }
}

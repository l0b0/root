class font_editor {
  include window_manager

  package { 'fontforge':
    ensure => latest,
  }
}

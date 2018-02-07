class pdf_editor {
  include window_manager

  package { 'xournal':
    ensure => installed,
  }
}

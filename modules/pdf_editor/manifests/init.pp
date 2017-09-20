class pdf_editor (
  $ensure = latest,
) {
  include window_manager

  package { 'xournal':
    ensure => $ensure,
  }
}

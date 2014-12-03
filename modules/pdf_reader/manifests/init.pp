class pdf_reader {
  include window_manager

  package { 'evince':
    ensure => latest,
  }
}

class pdf_transformer {
  include shell

  package { 'qpdf':
    ensure => installed,
  }
}

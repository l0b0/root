class open_document_text_to_plain_text_converter {
  include shell

  package { 'odt2txt':
    ensure => latest,
  }
}

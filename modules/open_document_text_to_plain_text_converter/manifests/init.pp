class open_document_text_to_plain_text_converter (
  $ensure = latest,
) {
  include shell

  package { 'odt2txt':
    ensure => $ensure,
  }
}

class docx_to_text_converter {
  include shell

  package { 'docx2txt':
    ensure => latest,
  }
}

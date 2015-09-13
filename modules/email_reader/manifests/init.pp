class email_reader {
  include window_manager

  package { 'thunderbird-i18n-en-gb':
    ensure => latest,
  }
}

class email_reader (
  $ensure = latest,
) {
  include window_manager

  package { 'thunderbird-i18n-en-gb':
    ensure => $ensure,
  }
}

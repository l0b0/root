class dvcs_gui {
  include dvcs

  package { 'tk':
    ensure => latest,
  }
}

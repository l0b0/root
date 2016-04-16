class vcard_validator {
  include python_installer
  include shell

  package { 'vcard':
    ensure   => latest,
    provider => pip,
  }
}

class vcard_validator {
  include python_installer

  package { 'vcard':
    ensure   => absent,
    provider => pip,
  }
}

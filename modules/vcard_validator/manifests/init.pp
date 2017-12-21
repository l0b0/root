class vcard_validator {
  include python_installer
  include shell

  package { 'vcard':
    ensure   => '0.10.1',
    provider => pip,
  }
}

class vcard_validator (
  $ensure = '0.10.1',
) {
  include python_installer
  include shell

  package { 'vcard':
    ensure   => $ensure,
    provider => pip,
  }
}

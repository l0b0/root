class vcard_validator {
  require python2

  package { 'vcard':
    ensure   => installed,
    provider => pip2,
  }
}

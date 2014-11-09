class vcard_validator {
  require python2

  package { 'vcard':
    ensure   => latest,
    provider => pip2,
  }
}

class vcard_validator {
  require python2
  include shell

  package { 'vcard':
    ensure   => latest,
    provider => pip2,
  }
}

class openpgp_tools {
  include shell

  package { 'gnupg':
    ensure => latest,
  }
}

class dvcs {
  include shell

  package { 'git':
    ensure => latest,
  }
}

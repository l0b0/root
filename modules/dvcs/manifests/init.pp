class dvcs {
  package { 'git':
    ensure => latest,
  }
}

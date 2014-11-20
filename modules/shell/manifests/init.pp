class shell {
  package { ['bash', 'bash-completion']:
    ensure => latest,
  }
}

class shell_code_checker {
  package { ['shellcheck']:
    ensure => latest,
  }
}

class puppet_linter {
  include shell

  package { 'puppet-lint':
    ensure   => latest,
    provider => gem,
  }
}

class travis_linter {
  include shell

  package { 'travis-lint':
    ensure   => latest,
    provider => gem,
  }
}

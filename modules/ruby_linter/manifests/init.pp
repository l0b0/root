class ruby_linter {
  include shell

  package { 'reek':
    ensure   => latest,
    provider => gem,
  }
}

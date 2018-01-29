class haskell_compiler {
  package { 'ghc':
    ensure => latest,
  }
}

class spell_checker {
  package { [
      'aspell-de',
      'aspell-en',
      'aspell-fr',
      'hunspell-de',
      'hunspell-en',
      'hunspell-fr',
    ]:
    ensure => latest,
  }
}

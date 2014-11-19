class spell_checker {
  package { ['aspell-de', 'aspell-en', 'aspell-fr']:
    ensure => latest,
  }
}

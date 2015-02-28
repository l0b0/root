class spell_checker {
  package {
    [
      'aspell-de',
      'aspell-en',
      'aspell-fr',
      'hunspell-de',
      'hunspell-en',
      'hunspell-fr',
    ]:
      ensure => latest,
  }->
  file{
    [
      '/usr/share/hunspell',
      '/usr/share/myspell/dicts',
    ]:
    recurse => true,
    purge   => true,
    ignore  => [
      'de_CH.*',
      'de_DE.*',
      'en_GB.*',
      'en_US.*',
      'fr_FR.*',
    ],
  }
}

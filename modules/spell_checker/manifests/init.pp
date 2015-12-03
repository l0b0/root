class spell_checker (
  $packages,
) {
  package { $packages:
      ensure => latest,
  }->
  file {
    [
      '/usr/share/hunspell',
      '/usr/share/myspell/dicts',
    ]:
    recurse => true,
    purge   => true,
    mode    => '0666',
    ignore  => [
      'de_CH*',
      'de_DE*',
      'en_GB*',
      'en_US*',
      'fr_FR*',
    ],
  }
}

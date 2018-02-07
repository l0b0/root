class fuzzy_matching_library {
  include shell

  package { 'tlsh':
    ensure => installed,
  }
}

class printing_system {
  package { ['cups', 'cups-filters']:
    ensure => latest,
  }
}

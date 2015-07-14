class printing_system {
  package { ['cups', 'cups-filters']:
    ensure => latest,
  }->
  package { ['foomatic-db', 'foomatic-db-engine', 'hplip']:
    ensure => absent,
  }
  service { 'org.cups.cupsd':
    ensure => running,
    enable => true,
  }
}

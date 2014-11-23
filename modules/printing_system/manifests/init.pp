class printing_system {
  package { ['cups', 'cups-filters']:
    ensure => latest,
  }->
  service { 'org.cups.cupsd':
    ensure => running,
    enable => true,
  }
}

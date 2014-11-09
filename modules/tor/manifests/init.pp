class tor {
  package { 'torsocks':
    ensure => latest,
  }->
  service { 'tor':
    ensure => running,
    enable => true,
  }
}

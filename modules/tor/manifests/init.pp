class tor {
  package { 'torsocks':
    ensure => present,
  }->
  service { 'tor':
    ensure => running,
    enable => true,
  }
}

class tor {
  package { 'torsocks':
    ensure => installed,
  }->
  service { 'tor':
    ensure => running,
    enable => true,
  }
}

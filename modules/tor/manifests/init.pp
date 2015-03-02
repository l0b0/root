class tor {
  package { 'torsocks':
    ensure => latest,
  }->
  file { '/etc/tor/torrc':
    ensure => present,
    source => 'puppet:///modules/tor/torrc';
  }->
  service { 'tor':
    ensure => running,
    enable => true,
  }
}

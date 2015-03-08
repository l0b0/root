class tor {
  package { 'torsocks':
    ensure => latest,
  }->
  file { '/etc/tor/torrc':
    ensure => present,
    source => 'puppet:///modules/tor/torrc',
    mode  => '0644';
  }->
  service { 'tor':
    ensure => running,
    enable => true,
  }
}

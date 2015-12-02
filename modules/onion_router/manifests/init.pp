class onion_router {
  package { 'torsocks':
    ensure => latest,
  }->
  file { '/etc/onion_router/torrc':
    ensure => present,
    source => 'puppet:///modules/tor/torrc',
    mode  => '0644';
  }~>
  service { 'tor':
    ensure => running,
    enable => true,
  }
}

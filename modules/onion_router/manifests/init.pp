class onion_router {
  package { 'torsocks':
    ensure => installed,
  } -> file { '/etc/tor/torrc':
    ensure => present,
    source => "puppet:///modules/${module_name}/torrc",
    mode   => '0644';
  } ~> service { 'tor':
    ensure => running,
    enable => true,
  }
}

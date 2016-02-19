class onion_router (
  $packages,
) {
  package { $packages:
    ensure => latest,
  }->
  file { '/etc/tor/torrc':
    ensure => present,
    source => 'puppet:///modules/onion_router/torrc',
    mode  => '0644';
  }~>
  service { 'tor':
    ensure => running,
    enable => true,
  }
}

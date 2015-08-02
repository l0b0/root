class printing_system {
  package { ['cups', 'cups-filters']:
    ensure => latest,
  }->
  package { ['foomatic-db', 'foomatic-db-engine', 'hplip']:
    ensure => absent,
  }

  $paper_size_file = '/etc/papersize'
  file { $paper_size_file:
    ensure => present,
    source => 'puppet:///modules/printing_system/papersize',
    mode   => '0644';
  }

  service { 'org.cups.cupsd':
    ensure    => running,
    enable    => true,
    subscribe => [File[$paper_size_file], Package['cups']],
  }
}

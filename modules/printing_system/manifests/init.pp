class printing_system {
  $browser_service = 'cups-browsed'

  package { ['cups', 'cups-filters', 'foomatic-db-gutenprint-ppds', 'gutenprint']:
    ensure => latest,
  }

  $paper_size_file = '/etc/papersize'
  file { $paper_size_file:
    ensure => present,
    source => "puppet:///modules/${module_name}/papersize",
    mode   => '0644';
  }

  service {
    'org.cups.cupsd':
      ensure    => running,
      enable    => true,
      subscribe => [File[$paper_size_file], Package['cups']];
  }

  service {
    $browser_service:
      ensure    => running,
      enable    => true,
      subscribe => Package['cups'];
  }
}

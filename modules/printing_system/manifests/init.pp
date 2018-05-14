class printing_system {
  $browser_service = 'cups-browsed'
  $printing_service = 'org.cups.cupsd'

  package { ['cups', 'cups-filters', 'foomatic-db-gutenprint-ppds', 'gutenprint']:
    ensure => installed,
  }

  $paper_size_file = '/etc/papersize'
  file { $paper_size_file:
    ensure => present,
    source => "puppet:///modules/${module_name}/papersize",
    mode   => '0644';
  }

  service {
    $printing_service:
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

  warning("Make sure to add printer users to the 'cups' group.")
  warning("Make sure to add printer admins to the 'sys' group.")
}

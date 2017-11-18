class printing_system (
  $enable = true,
) {
  $browser_service = 'cups-browsed'

  $package_ensure = str2bool($enable) ? {
    true    => latest,
    default => absent,
  }
  $service_ensure = str2bool($enable) ? {
    true    => running,
    default => stopped,
  }
  $file_ensure = str2bool($enable) ? {
    true    => present,
    default => absent,
  }

  package { ['cups', 'cups-filters', 'foomatic-db-gutenprint-ppds', 'gtk3-print-backends', 'gutenprint']:
    ensure => $package_ensure,
  }

  $paper_size_file = '/etc/papersize'
  file { $paper_size_file:
    ensure => $file_ensure,
    source => "puppet:///modules/${module_name}/papersize",
    mode   => '0644';
  }

  service {
    'org.cups.cupsd':
      ensure    => $service_ensure,
      enable    => $enable,
      subscribe => [File[$paper_size_file], Package['cups']];
  }

  service {
    $browser_service:
      ensure    => $service_ensure,
      enable    => $enable,
      subscribe => Package['cups'];
  }
}

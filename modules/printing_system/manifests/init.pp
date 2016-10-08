class printing_system (
  $print_service,
  $browser_service = undef,
) {
  include service_discovery_system

  package { ['cups', 'cups-filters', 'gutenprint']:
    ensure => latest,
  }

  $paper_size_file = '/etc/papersize'
  file { $paper_size_file:
    ensure => present,
    source => 'puppet:///modules/printing_system/papersize',
    mode   => '0644';
  }

  service {
    $print_service:
      ensure    => running,
      enable    => true,
      subscribe => [File[$paper_size_file], Package['cups']];
  }

  if ($browser_service != undef) {
    service {
      $browser_service:
        ensure    => running,
        enable    => true,
        subscribe => Package['cups'];
    }
  }
}

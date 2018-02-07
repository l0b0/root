class file_locator {
  include shell

  package { 'mlocate':
    ensure => installed,
  } -> cron { 'updatedb':
    command => '/usr/bin/updatedb',
    hour    => fqdn_rand(24),
    minute  => fqdn_rand(60),
  }
}

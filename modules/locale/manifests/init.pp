class locale (
  $generator_command,
) {
  file {
    '/etc/locale.gen':
      ensure => present,
      source => 'puppet:///modules/locale/locale.gen',
      mode   => '0644';
    '/etc/locale.conf':
      ensure => present,
      source => 'puppet:///modules/locale/locale.conf',
      mode   => '0644';
  }~>
  exec { $generator_command:
    refreshonly => true,
  }
}

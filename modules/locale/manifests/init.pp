class locale {
  file {
    '/etc/locale.gen':
      ensure => present,
      source => "puppet:///modules/${module_name}/locale.gen",
      mode   => '0644';
    '/etc/locale.conf':
      ensure => present,
      source => "puppet:///modules/${module_name}/locale.conf",
      mode   => '0644';
  } ~> exec { '/usr/bin/locale-gen':
    refreshonly => true,
  }
}

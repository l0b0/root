class display_manager {
  include display_server

  package { ['lightdm', 'numlockx']:
    ensure => installed,
  } -> file { '/etc/lightdm/lightdm.conf':
    ensure => present,
    source => "puppet:///modules/${module_name}/lightdm.conf",
    owner  => lightdm,
    group  => lightdm,
    mode   => '0644',
  }

  service { 'lightdm':
    enable  => true,
    require => [
      Package['lightdm'],
      File['/etc/lightdm/lightdm.conf'],
    ],
  }
}

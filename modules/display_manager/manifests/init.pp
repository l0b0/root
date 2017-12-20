class display_manager {
  include display_server

  File {
    ensure => present,
    owner  => lightdm,
    group  => lightdm,
    mode   => '0644',
  }

  package { ['lightdm', 'lightdm-gtk-greeter', 'lightdm-gtk-greeter-settings']:
    ensure => latest,
  } -> file {
    '/etc/lightdm/lightdm.conf':
      source => "puppet:///modules/${module_name}/lightdm.conf";
    '/etc/lightdm/lightdm-gtk-greeter.conf':
      source => "puppet:///modules/${module_name}/lightdm-gtk-greeter.conf";
  }

  service { 'lightdm':
    enable  => true,
    require => [
      Package['lightdm', 'lightdm-gtk-greeter'],
      File['/etc/lightdm/lightdm.conf', '/etc/lightdm/lightdm-gtk-greeter.conf'],
    ],
  }
}

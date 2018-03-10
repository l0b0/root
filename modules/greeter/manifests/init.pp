class greeter {
  require display_manager

  package { 'lightdm-gtk-greeter-settings':
    ensure => installed,
  } -> file { '/etc/lightdm/lightdm-gtk-greeter.conf':
    ensure => present,
    source => "puppet:///modules/${module_name}/lightdm-gtk-greeter.conf",
    owner  => lightdm,
    group  => lightdm,
    mode   => '0644',
  }
}

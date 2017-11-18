class keyboard_layout {
  file {
    '/etc/vconsole.conf':
      ensure => present,
      source => "puppet:///modules/${module_name}/vconsole.conf",
      mode   => '0644';
    '/etc/X11/xorg.conf.d/00-keyboard.conf':
      ensure => present,
      source => "puppet:///modules/${module_name}/00-keyboard.conf",
      mode   => '0644';
  }

  package { 'xorg-setxkbmap':
    ensure => latest,
  }
}

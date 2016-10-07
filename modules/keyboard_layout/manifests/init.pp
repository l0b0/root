class keyboard_layout {
  file {
    '/etc/vconsole.conf':
      ensure => present,
      source => 'puppet:///modules/keyboard_layout/vconsole.conf',
      mode   => '0644';
    '/etc/X11/xorg.conf.d/00-keyboard.conf':
      ensure => present,
      source => 'puppet:///modules/keyboard_layout/00-keyboard.conf',
      mode   => '0644';
  }

  package { 'xorg-setxkbmap':
    ensure => latest,
  }
}

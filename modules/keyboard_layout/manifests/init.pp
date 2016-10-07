class keyboard_layout {
  file {
    '/etc/vconsole.conf':
      ensure => present,
      source => 'puppet:///modules/keyboard_layout/vconsole.conf',
      mode   => '0644';
  }
}

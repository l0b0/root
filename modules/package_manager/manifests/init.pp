class package_manager {
  file { '/etc/pacman.conf':
    ensure => present,
    source => "puppet:///modules/${module_name}/pacman.conf",
    mode   => '0644',
  }
}

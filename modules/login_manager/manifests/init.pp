class login_manager {
  file { '/etc/systemd/logind.conf':
    ensure => present,
    source => "puppet:///modules/${module_name}/logind.conf",
    mode   => '0644',
  } ~> service { 'systemd-logind':
    ensure => running,
    enable => true,
  }
}

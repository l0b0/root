class sshd (
  $service_name,
) {
  file { '/etc/ssh/sshd_config':
    ensure  => present,
    content => template('sshd/sshd_config.erb'),
  }~>
  service { $service_name:
    ensure => running,
    enable => true,
  }
}

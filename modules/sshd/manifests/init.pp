class sshd {
  file { '/etc/ssh/sshd_config':
    ensure  => present,
    content => template('sshd/sshd_config.erb'),
  }~>
  service { 'sshd':
    ensure => running,
    enable => true,
  }
}

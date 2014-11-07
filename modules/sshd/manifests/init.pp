class sshd {
  service { 'sshd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/ssh/sshd_config'],
  }

  file { '/etc/ssh/sshd_config':
    ensure  => present,
    content => template('sshd/sshd_config.erb'),
  }
}

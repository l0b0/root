class ssh_server {
  require openssh

  file {
    '/etc/ssh/sshd_config':
      ensure  => present,
      content => template('ssh_server/sshd_config.erb');
    '/etc/ssh/ssh_config':
      ensure => present,
      source => 'puppet:///modules/ssh_server/ssh_config'
  }~>
  service { 'sshd':
    ensure => running,
    enable => true,
  }
}

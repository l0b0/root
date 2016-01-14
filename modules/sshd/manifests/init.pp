class sshd (
  $service_name,
) {
  file {
    '/etc/ssh/sshd_config':
      ensure  => present,
      content => template('sshd/sshd_config.erb');
    '/etc/ssh/ssh_config':
      ensure => present,
      source => 'puppet:///modules/sshd/ssh_config'
  }~>
  service { $service_name:
    ensure => running,
    enable => true,
  }
}

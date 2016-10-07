class ssh_server (
  $service_name,
) {
  file {
    '/etc/ssh/sshd_config':
      ensure  => present,
      content => template('ssh_server/sshd_config.erb');
    '/etc/ssh/ssh_config':
      ensure => present,
      source => 'puppet:///modules/ssh_server/ssh_config'
  }~>
  service { $service_name:
    ensure => running,
    enable => true,
  }
}

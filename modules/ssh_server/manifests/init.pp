class ssh_server {
  require openssh

  file {
    '/etc/ssh/sshd_config':
      ensure  => present,
      content => template('ssh_server/sshd_config.erb');
    '/etc/ssh/ssh_config':
      ensure => present,
      source => 'puppet:///modules/ssh_server/ssh_config'
  } ~>
  service { 'sshd':
    ensure => running,
    enable => true,
  }

  firewall { '200 limit incoming SSH connections to 6 per minute':
    dport     => 22,
    proto     => tcp,
    recent    => update,
    rseconds  => 60,
    rhitcount => 6,
    rname     => 'SSH',
    rsource   => true,
    action    => drop,
  } ->
  firewall { '201 allow incoming SSH connections':
    dport   => 22,
    proto   => tcp,
    recent  => set,
    rname   => 'SSH',
    rsource => true,
    action  => accept,
  }
}

class ssh_filesystem_client {
  package { 'sshfs':
    ensure => installed,
  }

  file { ['/media', '/media/phone']:
    ensure => directory,
    mode   => '0777',
  }
}

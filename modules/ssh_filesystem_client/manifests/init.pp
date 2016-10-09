class ssh_filesystem_client {
  package { 'sshfs':
    ensure => latest,
  }

  file { ['/media', '/media/phone']:
    ensure => directory,
    mode   => '0777',
  }
}

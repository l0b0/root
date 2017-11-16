class userspace_virtual_filesystem {
  package { ['gvfs', 'gvfs-mtp']:
    ensure => latest,
  }
}

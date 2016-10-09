class userspace_virtual_filesystem {
  package { 'gvfs':
    ensure => latest,
  }
}

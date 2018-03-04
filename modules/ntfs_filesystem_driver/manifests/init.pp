class ntfs_filesystem_driver {
  package { 'ntfs-3g':
    ensure => installed,
  }
}

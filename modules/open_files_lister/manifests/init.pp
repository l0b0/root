class open_files_lister {
  include shell

  package { 'lsof':
    ensure => latest,
  }
}

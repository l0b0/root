class cpio_archiver {
  include shell

  package { 'cpio':
    ensure => latest,
  }
}

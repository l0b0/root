class file_locator {
  include shell

  package { 'mlocate':
    ensure => latest,
  }
}

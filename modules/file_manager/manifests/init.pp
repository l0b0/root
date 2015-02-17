class file_manager {
  include window_manager

  package { 'pcmanfm':
    ensure => latest,
  }
}

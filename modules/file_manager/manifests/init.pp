class file_manager {
  include window_manager

  package { 'thunar':
    ensure => latest,
  }

  package { 'pcmanfm':
    ensure => absent,
  }
}

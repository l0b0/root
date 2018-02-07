class file_manager {
  include window_manager

  package { 'thunar':
    ensure => installed,
  }

  package { 'pcmanfm':
    ensure => absent,
  }
}

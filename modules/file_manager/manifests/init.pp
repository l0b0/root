class file_manager {
  include window_manager

  package { ['file-roller', 'thunar']:
    ensure => installed,
  }
}

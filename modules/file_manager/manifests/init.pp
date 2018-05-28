class file_manager {
  include window_manager

  package { ['file-roller', 'thunar', 'thunar-archive-plugin']:
    ensure => installed,
  }
}

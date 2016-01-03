class network_manager_gui {
  include network_manager
  include window_manager

  package { 'wicd-gtk':
    ensure => latest,
  }
}

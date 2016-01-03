class network_manager_gui (
  $packages,
) {
  include network_manager
  include window_manager

  package { $packages:
    ensure => latest,
  }
}

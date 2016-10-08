class network_manager {
  include shell

  package { [
    'ifplugd',
    'wpa_actiond',
  ]:
    ensure => latest,
  }
}

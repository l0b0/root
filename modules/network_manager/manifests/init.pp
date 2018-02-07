class network_manager {
  include shell

  package { [
    'dialog',
    'ifplugd',
    'wpa_actiond',
  ]:
    ensure => installed,
  }
}

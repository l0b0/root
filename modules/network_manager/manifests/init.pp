class network_manager {
  include shell

  package { [
    'dialog',
    'wpa_actiond',
  ]:
    ensure => installed,
  }
  package { 'dhcpcd':
    ensure => installed,
  } ~>
  service { 'dhcpcd':
    ensure => running,
    enable => true,
  }

  package { 'ifplugd':
    ensure => absent,
  }
}

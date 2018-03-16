class network_tools {
  include shell

  package { 'net-tools':
    ensure => installed,
  }
}

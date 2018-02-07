class network_analyzer {
  include shell

  package { 'gnu-netcat':
    ensure => installed,
  }
}

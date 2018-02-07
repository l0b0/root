class calculator {
  include shell

  package { 'bc':
    ensure => installed,
  }
}

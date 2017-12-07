class root_privilege_simulator {
  include shell

  package { 'fakeroot':
    ensure => latest,
  }
}

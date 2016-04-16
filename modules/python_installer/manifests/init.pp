class python_installer {
  include shell

  package { 'python-pip':
    ensure => latest,
  }
}

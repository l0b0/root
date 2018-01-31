class arch_linux_package_checker {
  include shell

  package { 'namcap':
    ensure => latest,
  }
}

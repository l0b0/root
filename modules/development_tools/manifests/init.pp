class development_tools {
  include shell

  package { 'base-devel':
    ensure => latest,
  }
}

class virtual_machine_manager {
  include shell

  package { 'vagrant':
    ensure => latest,
  }
}

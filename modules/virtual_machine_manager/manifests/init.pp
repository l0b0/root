class virtual_machine_manager {
  include hypervisor
  include shell

  package { 'vagrant':
    ensure => latest,
  }
}

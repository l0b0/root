class virtual_machine_manager (
  $ensure = latest,
) {
  include hypervisor
  include shell

  package { 'vagrant':
    ensure => $ensure,
  }
}

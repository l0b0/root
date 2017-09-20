class desktop_management_interface_table_decoder (
  $ensure = latest,
) {
  include shell

  package { 'dmidecode':
    ensure => $ensure,
  }
}

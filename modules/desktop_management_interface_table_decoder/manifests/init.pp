class desktop_management_interface_table_decoder {
  include shell

  package { 'dmidecode':
    ensure => latest,
  }
}

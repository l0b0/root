class file_transfer_protocol_client_gui {
  include window_manager

  package { 'filezilla':
    ensure => latest,
  }
}

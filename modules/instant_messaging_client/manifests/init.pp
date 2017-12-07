class instant_messaging_client {
  include window_manager

  package { 'pidgin':
    ensure => latest,
  }
}
